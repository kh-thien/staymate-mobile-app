import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/contract_model.dart';
import '../models/maintenance_model.dart';
import '../models/maintenance_request_model.dart';

class MaintenanceRequestRemoteDatasource {
  final SupabaseClient _supabase;

  MaintenanceRequestRemoteDatasource(this._supabase);

  /// Get active contracts for current user
  /// Flow: auth.uid() → tenants.user_id → tenants.id → contracts.tenant_id
  Future<List<ContractModel>> getActiveContracts() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Step 1: Tìm tenant_id từ user_id
      final tenantResponse = await _supabase
          .from('tenants')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (tenantResponse == null) {
        return [];
      }

      final tenantId = tenantResponse['id'] as String;

      // Step 2: Lấy contracts của tenant này, JOIN với rooms và properties
      final response = await _supabase
          .from('contracts')
          .select('''
            id,
            room_id,
            tenant_id,
            landlord_id,
            contract_number,
            status,
            start_date,
            end_date,
            rooms!inner(
              id,
              code,
              name,
              property_id,
              properties!inner(
                id,
                name
              )
            )
          ''')
          .eq('tenant_id', tenantId)
          .eq('status', 'ACTIVE')
          .isFilter('deleted_at', null);

      final contracts = <ContractModel>[];
      for (var json in response) {
        final room = json['rooms'] as Map<String, dynamic>?;
        final property = room?['properties'] as Map<String, dynamic>?;

        final contractJson = Map<String, dynamic>.from(json as Map);
        contractJson['room_code'] = room?['code'];
        contractJson['room_name'] = room?['name'];
        contractJson['property_id'] = room?['property_id'];
        contractJson['property_name'] = property?['name'];

        contracts.add(ContractModel.fromJson(contractJson));
      }

      return contracts;
    } catch (e) {
      rethrow;
    }
  }

  /// Get all maintenance requests for current user
  Future<List<MaintenanceRequestModel>> getMaintenanceRequests() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await _supabase
          .from('maintenance_requests')
          .select('''
            *,
            properties(
              name
            ),
            rooms(
              code,
              name
            )
          ''')
          .eq('reported_by', user.id)
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);

      final requests = <MaintenanceRequestModel>[];
      for (var json in response) {
        final property = json['properties'] as Map<String, dynamic>?;
        final room = json['rooms'] as Map<String, dynamic>?;

        final requestJson = Map<String, dynamic>.from(json as Map);
        requestJson['property_name'] = property?['name'];
        requestJson['room_code'] = room?['code'];
        requestJson['room_name'] = room?['name'];

        requests.add(MaintenanceRequestModel.fromJson(requestJson));
      }

      return requests;
    } catch (e) {
      rethrow;
    }
  }

  /// Get maintenance request detail
  Future<MaintenanceRequestModel> getMaintenanceRequestDetail(String id) async {
    try {
      final response = await _supabase
          .from('maintenance_requests')
          .select('''
            *,
            properties(
              name
            ),
            rooms(
              code,
              name
            )
          ''')
          .eq('id', id)
          .single();

      final property = response['properties'] as Map<String, dynamic>?;
      final room = response['rooms'] as Map<String, dynamic>?;

      final requestJson = Map<String, dynamic>.from(response);
      requestJson['property_name'] = property?['name'];
      requestJson['room_code'] = room?['code'];
      requestJson['room_name'] = room?['name'];

      return MaintenanceRequestModel.fromJson(requestJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Create maintenance request with optional image upload
  Future<MaintenanceRequestModel> createMaintenanceRequest({
    required String description,
    required String propertiesId,
    required String roomId,
    List<String>? imagePaths,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // 1. Create maintenance request first
      final response = await _supabase
          .from('maintenance_requests')
          .insert({
            'reported_by': user.id,
            'description': description,
            'properties_id': propertiesId,
            'room_id': roomId,
            'maintenance_requests_status': 'PENDING',
          })
          .select('''
            *,
            properties(
              name
            ),
            rooms(
              code,
              name
            )
          ''')
          .single();

      final maintenanceRequestId = response['id'] as String;

      // 2. Upload images if provided (use first image for url_report)
      String? imageUrl;
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (int i = 0; i < imagePaths.length; i++) {
          final imagePath = imagePaths[i];
          final file = File(imagePath);
          final fileName = imagePath.split('/').last;
          final filePath = '$maintenanceRequestId/${i}_$fileName';

          await _supabase.storage
              .from('maintain-files')
              .upload(
                filePath,
                file,
                fileOptions: const FileOptions(upsert: true),
              );

          final url = _supabase.storage
              .from('maintain-files')
              .getPublicUrl(filePath);

          // Use first image as primary url_report
          if (i == 0) {
            imageUrl = url;
          }
        }

        // 3. Update maintenance request with primary image URL
        if (imageUrl != null) {
          await _supabase
              .from('maintenance_requests')
              .update({'url_report': imageUrl})
              .eq('id', maintenanceRequestId);

          response['url_report'] = imageUrl;
        }
      }

      // Parse response
      final property = response['properties'] as Map<String, dynamic>?;
      final room = response['rooms'] as Map<String, dynamic>?;

      final requestJson = Map<String, dynamic>.from(response);
      requestJson['property_name'] = property?['name'];
      requestJson['room_code'] = room?['code'];
      requestJson['room_name'] = room?['name'];

      return MaintenanceRequestModel.fromJson(requestJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Stream maintenance requests for realtime updates
  Stream<List<MaintenanceRequestModel>> streamMaintenanceRequests() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final controller = StreamController<List<MaintenanceRequestModel>>();

    // Initial load
    getMaintenanceRequests().then((requests) {
      if (!controller.isClosed) {
        controller.add(requests);
      }
    });

    // Subscribe to realtime changes
    final channel = _supabase
        .channel('maintenance_requests_${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'maintenance_requests',
          callback: (payload) async {
            try {
              final requests = await getMaintenanceRequests();
              if (!controller.isClosed) {
                controller.add(requests);
              }
            } catch (e) {
              // Ignore errors in realtime updates
            }
          },
        )
        .subscribe();

    controller.onCancel = () {
      _supabase.removeChannel(channel);
    };

    return controller.stream;
  }

  /// Cancel a maintenance request (change status to CANCELLED)
  Future<void> cancelMaintenanceRequest(String id) async {
    try {
      await _supabase
          .from('maintenance_requests')
          .update({'maintenance_requests_status': 'CANCELLED'})
          .eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a maintenance request (soft delete)
  Future<void> deleteMaintenanceRequest(String id) async {
    try {
      await _supabase
          .from('maintenance_requests')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  /// Get maintenance records for tenant's contracted properties
  /// Tenant can view maintenance progress (READ-ONLY) but NOT cancelled ones
  /// Tenant can only see maintenance for their own rooms or property-level maintenance (room_id IS NULL)
  Future<List<MaintenanceModel>> getMaintenanceRecords() async {
    try {
      // Step 1: Get active contracts to find property IDs and room IDs
      final contracts = await getActiveContracts();

      if (contracts.isEmpty) {
        return [];
      }

      // Step 2: Extract property IDs and room IDs
      final propertyIds = contracts
          .map((c) => c.propertyId)
          .whereType<String>()
          .toSet()
          .toList();

      final roomIds = contracts
          .map((c) => c.roomId)
          .whereType<String>()
          .toSet()
          .toList();

      // Step 3: Query maintenance table with filters
      // Logic: Show maintenance if:
      // 1. property_id matches AND (room_id IS NULL OR room_id matches tenant's rooms)
      // 2. Status is NOT CANCELLED
      // 3. deleted_at IS NULL
      final response = await _supabase
          .from('maintenance')
          .select('''
            id,
            user_report_id,
            status,
            maintenance_type,
            title,
            description,
            notes,
            room_id,
            property_id,
            url_image,
            cost,
            created_at,
            updated_at,
            deleted_at,
            priority,
            maintenance_request_id,
            properties!inner(name),
            rooms(code, name)
          ''')
          .inFilter('property_id', propertyIds)
          .neq('status', 'CANCELLED') // Hide CANCELLED status from tenant
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);

      print('✅ [DEBUG] Found ${response.length} maintenance records before room filtering');

      // Step 4: Filter by room_id in application layer
      // Keep records where room_id IS NULL (property-level maintenance) OR room_id is in tenant's rooms
      final filteredResponse = (response as List).where((json) {
        final roomId = json['room_id'] as String?;
        // If room_id is NULL, it's property-level maintenance (show it)
        if (roomId == null) {
          return true;
        }
        // If room_id is not NULL, only show if it's in tenant's rooms
        return roomIds.contains(roomId);
      }).toList();

      print('✅ [DEBUG] Found ${filteredResponse.length} maintenance records after room filtering');

      return filteredResponse.map<MaintenanceModel>((json) {
        // Flatten nested JSON structure
        final jsonMap = json as Map<String, dynamic>;
        final flattened = Map<String, dynamic>.from(jsonMap);
        flattened['property_name'] = jsonMap['properties']?['name'];
        flattened['room_code'] = jsonMap['rooms']?['code'];
        flattened['room_name'] = jsonMap['rooms']?['name'];
        flattened.remove('properties');
        flattened.remove('rooms');

        return MaintenanceModel.fromJson(flattened);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Stream maintenance records for realtime updates
  /// Same logic as getMaintenanceRecords but with realtime subscription
  Stream<List<MaintenanceModel>> streamMaintenanceRecords() async* {
    final controller = StreamController<List<MaintenanceModel>>();

    try {
      // Step 1: Get active contracts to find property IDs and room IDs
      final contracts = await getActiveContracts();

      if (contracts.isEmpty) {
        yield [];
        return;
      }

      // Step 2: Extract property IDs and room IDs
      final propertyIds = contracts
          .map((c) => c.propertyId)
          .whereType<String>()
          .toSet()
          .toList();

      final roomIds = contracts
          .map((c) => c.roomId)
          .whereType<String>()
          .toSet()
          .toList();

      // Step 3: Subscribe to realtime updates
      final channel = _supabase
          .channel(
            'maintenance-changes-${DateTime.now().millisecondsSinceEpoch}',
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'maintenance',
            callback: (payload) async {
              try {
                // Refetch all maintenance records
                final response = await _supabase
                    .from('maintenance')
                    .select('''
                      id,
                      user_report_id,
                      status,
                      maintenance_type,
                      title,
                      description,
                      notes,
                      room_id,
                      property_id,
                      url_image,
                      cost,
                      created_at,
                      updated_at,
                      deleted_at,
                      priority,
                      maintenance_request_id,
                      properties!inner(name),
                      rooms(code, name)
                    ''')
                    .inFilter('property_id', propertyIds)
                    .neq('status', 'CANCELLED')
                    .isFilter('deleted_at', null)
                    .order('created_at', ascending: false);

                // Filter by room_id in application layer
                // Keep records where room_id IS NULL (property-level maintenance) OR room_id is in tenant's rooms
                final filteredResponse = (response as List).where((json) {
                  final jsonMap = json as Map<String, dynamic>;
                  final roomId = jsonMap['room_id'] as String?;
                  // If room_id is NULL, it's property-level maintenance (show it)
                  if (roomId == null) {
                    return true;
                  }
                  // If room_id is not NULL, only show if it's in tenant's rooms
                  return roomIds.contains(roomId);
                }).toList();

                final maintenances = filteredResponse.map<MaintenanceModel>((json) {
                  final jsonMap = json as Map<String, dynamic>;
                  final flattened = Map<String, dynamic>.from(jsonMap);
                  flattened['property_name'] = jsonMap['properties']?['name'];
                  flattened['room_code'] = jsonMap['rooms']?['code'];
                  flattened['room_name'] = jsonMap['rooms']?['name'];
                  flattened.remove('properties');
                  flattened.remove('rooms');

                  return MaintenanceModel.fromJson(flattened);
                }).toList();

                if (!controller.isClosed) {
                  controller.add(maintenances);
                }
              } catch (e) {
                // Ignore errors in realtime updates
              }
            },
          )
          .subscribe();

      // Fetch initial data
      final initialRecords = await getMaintenanceRecords();
      if (!controller.isClosed) {
        controller.add(initialRecords);
      }

      controller.onCancel = () {
        _supabase.removeChannel(channel);
      };

      yield* controller.stream;
    } catch (e) {
      rethrow;
    }
  }
}
