import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/repositories/contract_repository.dart';
import '../models/contract_model.dart';
import '../models/contract_file_model.dart';

class ContractRepositoryImpl implements ContractRepository {
  final SupabaseClient _supabase;

  ContractRepositoryImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<String?> getTenantIdByUserId(String userId) async {
    print('🔍🔍🔍 [ContractRepo] Getting tenant_id for user: $userId 🔍🔍🔍');
    developer.log(
      '🔍 [ContractRepo] Getting tenant_id for user: $userId',
      name: 'ContractRepository',
    );
    try {
      final response = await _supabase
          .from('tenants')
          .select('id')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .maybeSingle();

      if (response == null) {
        print('⚠️⚠️⚠️ [ContractRepo] No tenant found for user: $userId ⚠️⚠️⚠️');
        developer.log(
          '⚠️ [ContractRepo] No tenant found for user: $userId',
          name: 'ContractRepository',
        );
        return null;
      }

      final tenantId = response['id'] as String?;
      print('✅✅✅ [ContractRepo] Found tenant_id: $tenantId for user: $userId ✅✅✅');
      developer.log(
        '✅ [ContractRepo] Found tenant_id: $tenantId for user: $userId',
        name: 'ContractRepository',
      );
      return tenantId;
    } catch (e, stackTrace) {
      developer.log(
        '❌ [ContractRepo] Error getting tenant_id for user $userId: $e',
        name: 'ContractRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<List<ContractEntity>> getContractsByTenantId(String tenantId) async {
    print('🔍🔍🔍 [ContractRepo] Getting contracts for tenant_id: $tenantId 🔍🔍🔍');
    developer.log(
      '🔍 [ContractRepo] Getting contracts for tenant_id: $tenantId',
      name: 'ContractRepository',
    );
    try {
      final response = await _supabase
          .from('contracts')
          .select('''
            *,
            rooms!inner(
              code,
              name,
              properties!inner(
                address,
                ward,
                city,
                name
              )
            )
          ''')
          .eq('tenant_id', tenantId)
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);

      developer.log(
        '📊 [ContractRepo] Query response length: ${(response as List).length}',
        name: 'ContractRepository',
      );
      print('📊📊📊 [ContractRepo] Query response length: ${(response as List).length} 📊📊📊');

      final contracts = (response as List).map((json) {
        // Extract nested room and property data
        final room = json['rooms'] as Map<String, dynamic>?;
        final property = room?['properties'] as Map<String, dynamic>?;
        
        // Flatten nested data for model
        final contractJson = Map<String, dynamic>.from(json as Map);
        contractJson['room_code'] = room?['code'];
        contractJson['room_name'] = room?['name'];
        contractJson['property_address'] = property?['address'];
        contractJson['property_ward'] = property?['ward'];
        contractJson['property_city'] = property?['city'];
        contractJson['property_name'] = property?['name'];
        
        return ContractModel.fromJson(contractJson);
      }).toList();

      developer.log(
        '✅ [ContractRepo] Successfully parsed ${contracts.length} contracts',
        name: 'ContractRepository',
      );
      print('✅✅✅ [ContractRepo] Successfully parsed ${contracts.length} contracts ✅✅✅');

      if (contracts.isEmpty) {
        print('⚠️⚠️⚠️ [ContractRepo] No contracts found for tenant_id: $tenantId ⚠️⚠️⚠️');
        developer.log(
          '⚠️ [ContractRepo] No contracts found for tenant_id: $tenantId',
          name: 'ContractRepository',
        );
      } else {
        print('📋📋📋 [ContractRepo] Contracts: ${contracts.map((c) => c.contractNumber ?? c.id).join(", ")} 📋📋📋');
        developer.log(
          '📋 [ContractRepo] Contracts: ${contracts.map((c) => c.contractNumber ?? c.id).join(", ")}',
          name: 'ContractRepository',
        );
      }

      return contracts.map((model) => model.toEntity()).toList();
    } catch (e, stackTrace) {
      developer.log(
        '❌ [ContractRepo] Error getting contracts for tenant $tenantId: $e',
        name: 'ContractRepository',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow; // Re-throw để UI có thể hiển thị lỗi
    }
  }

  @override
  Future<ContractEntity> getContractDetail(String contractId) async {
    try {
      final contractResponse = await _supabase
          .from('contracts')
          .select('''
            *,
            rooms!inner(
              code,
              name,
              properties!inner(
                address,
                ward,
                city,
                name
              )
            )
          ''')
          .eq('id', contractId)
          .maybeSingle();

      if (contractResponse == null) {
        throw Exception('Contract not found');
      }

      // Extract nested room and property data
      final room = contractResponse['rooms'] as Map<String, dynamic>?;
      final property = room?['properties'] as Map<String, dynamic>?;
      
      // Flatten nested data for model
      final contractJson = Map<String, dynamic>.from(contractResponse as Map);
      contractJson['room_code'] = room?['code'];
      contractJson['room_name'] = room?['name'];
      contractJson['property_address'] = property?['address'];
      contractJson['property_ward'] = property?['ward'];
      contractJson['property_city'] = property?['city'];
      contractJson['property_name'] = property?['name'];

      final contract = ContractModel.fromJson(contractJson);
      return contract.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContractFileModel>> getContractFiles(String contractId) async {
    try {
      final filesResponse = await _supabase
          .from('contract_files')
          .select()
          .eq('contract_id', contractId)
          .order('upload_order', ascending: true);

      final files = (filesResponse as List)
          .map((json) => ContractFileModel.fromJson(json))
          .toList();
      return files;
    } catch (e) {
      return [];
    }
  }
}
