import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/invoice_model.dart';
import '../models/bill_item_model.dart';

class InvoiceRemoteDatasource {
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
}
