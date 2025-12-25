import 'dart:async';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/invoice.dart';
import '../models/invoice_model.dart';
import '../models/bill_item_model.dart';
import '../models/payment_account_model.dart';

class InvoiceRemoteDatasource {
  /// Maps Dart PaymentMethod enum to Postgres enum value
  String _paymentMethodToPostgres(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
      case PaymentMethod.qrCode:
        return 'QRCODE';
      case PaymentMethod.momo:
        return 'MOMO';
      case PaymentMethod.zaloPay:
        return 'ZALO_PAY';
      case PaymentMethod.card:
        return 'CARD';
    }
  }

  /// Confirm payment: update bill status, payment method, and payment date atomically
  Future<void> confirmPayment({
    required String billNumberOrId,
    required BillStatus newStatus,
    required PaymentMethod paymentMethod,
    required DateTime paymentDate,
  }) async {
    try {
      final isUuid =
          billNumberOrId.length == 36 && billNumberOrId.contains('-');
      print(
        '🔍 Datasource: Confirming payment for bill: $billNumberOrId (isUuid: $isUuid)',
      );
      print(
        '🔍 Datasource: New status: \'${newStatus.toJsonValue()}\', method: $paymentMethod, date: $paymentDate',
      );

      final updateData = {
        'status': newStatus.toJsonValue(),
        'payment_method': _paymentMethodToPostgres(paymentMethod),
        'payment_date': paymentDate.toIso8601String(),
      };

      final response = isUuid
          ? await _supabase
                .from('bills')
                .update(updateData)
                .eq('id', billNumberOrId)
                .select()
          : await _supabase
                .from('bills')
                .update(updateData)
                .eq('bill_number', billNumberOrId)
                .select();

      print('📦 Datasource: Supabase response: $response');
      print('📦 Datasource: Response length: ${response.length}');

      if (response.isEmpty) {
        print(
          '⚠️ Datasource: No rows updated - RLS policy blocked the update!',
        );
        throw Exception(
          'Failed to confirm payment: RLS policy may have blocked the operation',
        );
      } else {
        print(
          '✅ Datasource: Successfully confirmed payment for bill $billNumberOrId',
        );
      }
    } catch (e) {
      print('❌ Datasource: Error confirming payment: $e');
      rethrow;
    }
  }

  final SupabaseClient _supabase;

  InvoiceRemoteDatasource(this._supabase);

  /// Get all invoices for current tenant
  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Query bills directly - RLS policy now checks through tenants.user_id
      final response = await _supabase
          .from('bills')
          .select('''
            *,
            rooms(
              code,
              name
            ),
            tenants(
              fullname
            ),
            contracts!inner(
              id
            )
          ''')
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);

      final invoices = <InvoiceModel>[];
      for (var json in response) {
        // Extract nested data
        final room = json['rooms'] as Map<String, dynamic>?;
        final tenant = json['tenants'] as Map<String, dynamic>?;

        // Create invoice with room and tenant info
        final invoiceJson = Map<String, dynamic>.from(json as Map);
        invoiceJson['room_code'] = room?['code'];
        invoiceJson['room_name'] = room?['name'];
        invoiceJson['tenant_name'] = tenant?['fullname'];
        invoiceJson['bill_items'] = []; // Will be loaded separately for detail

        invoices.add(InvoiceModel.fromJson(invoiceJson));
      }

      return invoices;
    } catch (e) {
      rethrow;
    }
  }

  /// Get invoice detail with items
  Future<InvoiceModel> getInvoiceDetail(String billId) async {
    try {
      // Get bill with relations
      final billResponse = await _supabase
          .from('bills')
          .select('''
            *,
            rooms(
              code,
              name
            ),
            tenants(
              fullname
            )
          ''')
          .eq('id', billId)
          .single();

      // Get bill items with service info
      final itemsResponse = await _supabase
          .from('bill_items')
          .select('''
            *,
            services(
              name,
              service_type,
              unit
            )
          ''')
          .eq('bill_id', billId)
          .order('created_at', ascending: true);

      // Parse bill items
      final billItems = <BillItemModel>[];
      for (var itemJson in itemsResponse) {
        final service = itemJson['services'] as Map<String, dynamic>?;
        final billItemJson = Map<String, dynamic>.from(itemJson as Map);
        billItemJson['service_name'] = service?['name'];
        billItemJson['service_type'] = service?['service_type'];
        billItemJson['service_unit'] = service?['unit'];

        billItems.add(BillItemModel.fromJson(billItemJson));
      }

      // Extract nested data
      final room = billResponse['rooms'] as Map<String, dynamic>?;
      final tenant = billResponse['tenants'] as Map<String, dynamic>?;

      final invoiceJson = {
        ...billResponse,
        'room_code': room?['code'],
        'room_name': room?['name'],
        'tenant_name': tenant?['fullname'],
        'bill_items': billItems.map((item) => item.toJson()).toList(),
      };

      return InvoiceModel.fromJson(invoiceJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Stream invoices for realtime updates
  Stream<List<InvoiceModel>> streamInvoices() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final controller = StreamController<List<InvoiceModel>>();

    // Initial load
    getInvoices().then((invoices) {
      if (!controller.isClosed) {
        controller.add(invoices);
      }
    });

    // Subscribe to realtime changes
    final channel = _supabase
        .channel('invoices_${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bills',
          callback: (payload) async {
            // Reload all invoices on any change
            try {
              final invoices = await getInvoices();
              if (!controller.isClosed) {
                controller.add(invoices);
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

  /// Get landlord's default payment account for an invoice
  /// Flow: bills (by bill_number) -> contracts (by contract_id) ->
  ///       landlord_id -> payment_accounts (is_default = true)
  ///
  /// [billNumberOrId] can be either bill_number (BILL-XXX) or bill id (UUID)
  Future<PaymentAccountModel?> getLandlordPaymentAccount(
    String billNumberOrId,
  ) async {
    try {
      print('🔍 Datasource: Getting payment account for bill: $billNumberOrId');
      log('🔍 Getting payment account for bill: $billNumberOrId');

      // Step 1: Get bill to find contract_id
      // Try to search by bill_number first (if it looks like a bill number)
      // Otherwise search by id (UUID)
      print('🔍 Datasource: Querying bills table...');

      final isUuid =
          billNumberOrId.contains('-') && billNumberOrId.length == 36;

      final billResponse = isUuid
          ? await _supabase
                .from('bills')
                .select('id, bill_number, contract_id')
                .eq('id', billNumberOrId)
                .maybeSingle()
          : await _supabase
                .from('bills')
                .select('id, bill_number, contract_id')
                .eq('bill_number', billNumberOrId)
                .maybeSingle();

      print('📋 Datasource: Bill response: $billResponse');
      log('📋 Bill response: $billResponse');

      if (billResponse == null) {
        throw Exception('Bill not found');
      }

      final contractId = billResponse['contract_id'] as String?;
      if (contractId == null) {
        throw Exception('Contract ID not found for this bill');
      }

      print('📝 Datasource: Contract ID: $contractId');
      log('📝 Contract ID: $contractId');

      // Step 2: Get contract and landlord_id (via property if needed)
      print('🔍 Datasource: Querying contracts with rooms & properties...');
      final contractResponse = await _supabase
          .from('contracts')
          .select('''
            id, 
            landlord_id,
            room_id,
            tenant_id,
            rooms!inner(
              id,
              property_id,
              properties!inner(
                id,
                owner_id
              )
            )
          ''')
          .eq('id', contractId)
          .maybeSingle();

      print('🏠 Datasource: Contract response: $contractResponse');
      log('🏠 Contract response: $contractResponse');

      if (contractResponse == null) {
        throw Exception('Contract not found');
      }

      // Get landlord_id from contract, or fallback to property owner_id
      String? landlordId = contractResponse['landlord_id'] as String?;

      if (landlordId == null) {
        // Try to get from property owner
        final rooms = contractResponse['rooms'] as Map<String, dynamic>?;
        final properties = rooms?['properties'] as Map<String, dynamic>?;
        landlordId = properties?['owner_id'] as String?;
        print(
          '🏠 Datasource: landlord_id was null, got from property owner: $landlordId',
        );
      }

      if (landlordId == null) {
        throw Exception('Landlord ID not found for this contract');
      }

      print('👤 Datasource: Landlord ID: $landlordId');
      log('👤 Landlord ID: $landlordId');

      // Step 3: Get landlord's default payment account
      print(
        '🔍 Datasource: Querying payment_accounts for user_id: $landlordId',
      );
      final paymentResponse = await _supabase
          .from('payment_accounts')
          .select()
          .eq('user_id', landlordId)
          .eq('is_default', true)
          .eq('is_active', true)
          .isFilter('deleted_at', null)
          .limit(1)
          .maybeSingle();

      print('💳 Datasource: Payment account response: $paymentResponse');
      log('💳 Payment account response: $paymentResponse');

      if (paymentResponse == null) {
        log('⚠️ No default payment account found for landlord');
        return null;
      }

      return PaymentAccountModel.fromJson(paymentResponse);
    } catch (e, stackTrace) {
      log('❌ Error getting payment account: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Update bill status
  Future<void> updateBillStatus(
    String billNumberOrId,
    BillStatus newStatus,
  ) async {
    try {
      // Detect if input is UUID or bill_number
      final isUuid =
          billNumberOrId.length == 36 && billNumberOrId.contains('-');

      print('🔍 Datasource: Updating bill: $billNumberOrId (isUuid: $isUuid)');
      print('🔍 Datasource: New status: ${newStatus.toJsonValue()}');

      final response = isUuid
          ? await _supabase
                .from('bills')
                .update({'status': newStatus.toJsonValue()})
                .eq('id', billNumberOrId)
                .select()
          : await _supabase
                .from('bills')
                .update({'status': newStatus.toJsonValue()})
                .eq('bill_number', billNumberOrId)
                .select();

      print('📦 Datasource: Supabase response: $response');
      print('📦 Datasource: Response length: ${response.length}');

      if (response.isEmpty) {
        print(
          '⚠️ Datasource: No rows updated - RLS policy blocked the update!',
        );
        throw Exception(
          'Failed to update bill: RLS policy may have blocked the operation',
        );
      } else {
        print(
          '✅ Datasource: Successfully updated bill $billNumberOrId to ${newStatus.toJsonValue()}',
        );
      }
    } catch (e) {
      print('❌ Datasource: Error updating bill status: $e');
      rethrow;
    }
  }

  /// Update payment method and payment date for payments
  Future<void> updatePaymentInfo({
    required String billId,
    required PaymentMethod paymentMethod,
    required DateTime paymentDate,
    String? receivingAccountId,
  }) async {
    try {
      print('🔍 Datasource: Updating payment info for bill $billId');
      final updateData = <String, dynamic>{
        'method': _paymentMethodToPostgres(paymentMethod),
        'payment_date': paymentDate.toIso8601String(),
      };
      
      if (receivingAccountId != null) {
        updateData['receiving_account'] = receivingAccountId;
        print('🔍 Datasource: Setting receiving_account: $receivingAccountId');
      }
      
      final response = await _supabase
          .from('payments')
          .update(updateData)
          .eq('bill_id', billId)
          .select();
      print('📦 Datasource: Supabase response: $response');
      if (response.isEmpty) {
        print(
          '⚠️ Datasource: No rows updated - RLS policy blocked the update!',
        );
        throw Exception(
          'Failed to update payment info: RLS policy may have blocked the operation',
        );
      } else {
        print(
          '✅ Datasource: Successfully updated payment info for bill $billId',
        );
      }
    } catch (e) {
      print('❌ Datasource: Error updating payment info: $e');
      rethrow;
    }
  }

  /// Get payment account from payment (receiving_account)
  Future<PaymentAccountModel?> getPaymentAccountFromPayment(
    String billId,
  ) async {
    try {
      print('🔍 Datasource: Getting payment account from payment for bill $billId');
      
      // Get payment with receiving_account
      final paymentResponse = await _supabase
          .from('payments')
          .select('receiving_account')
          .eq('bill_id', billId)
          .isFilter('deleted_at', null)
          .maybeSingle();
      
      if (paymentResponse == null) {
        print('⚠️ Datasource: Payment not found for bill $billId');
        return null;
      }
      
      final receivingAccountId = paymentResponse['receiving_account'] as String?;
      if (receivingAccountId == null) {
        print('⚠️ Datasource: No receiving_account found for payment');
        return null;
      }
      
      print('🔍 Datasource: Found receiving_account: $receivingAccountId');
      
      // Get payment account
      final accountResponse = await _supabase
          .from('payment_accounts')
          .select()
          .eq('id', receivingAccountId)
          .isFilter('deleted_at', null)
          .maybeSingle();
      
      if (accountResponse == null) {
        print('⚠️ Datasource: Payment account not found: $receivingAccountId');
        return null;
      }
      
      print('✅ Datasource: Found payment account');
      return PaymentAccountModel.fromJson(accountResponse);
    } catch (e, stackTrace) {
      log('❌ Error getting payment account from payment: $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
