import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/payment_account.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../data/datasources/invoice_remote_datasource.dart';
import '../../data/repositories/invoice_repository_impl.dart';

part '../../../../generated/features/invoice/presentation/providers/invoice_provider.g.dart';

/// Provide Supabase client
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Provide datasource
@riverpod
InvoiceRemoteDatasource invoiceRemoteDatasource(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return InvoiceRemoteDatasource(supabase);
}

/// Provide repository
@riverpod
InvoiceRepository invoiceRepository(Ref ref) {
  final datasource = ref.watch(invoiceRemoteDatasourceProvider);
  return InvoiceRepositoryImpl(datasource);
}

/// Get all invoices
@riverpod
Future<List<Invoice>> invoices(Ref ref) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.getInvoices();
}

/// Stream invoices with realtime updates
@riverpod
Stream<List<Invoice>> invoicesStream(Ref ref) {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.streamInvoices();
}

/// Get invoice detail
@riverpod
Future<Invoice> invoiceDetail(Ref ref, String billId) async {
  final repository = ref.watch(invoiceRepositoryProvider);
  return repository.getInvoiceDetail(billId);
}

/// Get invoices by status (with filtering)
@riverpod
Future<List<Invoice>> invoicesByStatus(Ref ref, BillStatus? status) async {
  final repository = ref.watch(invoiceRepositoryProvider);

  if (status == null) {
    // Return all invoices
    return repository.getInvoices();
  }

  return repository.getInvoicesByStatus(status);
}

/// Get upcoming invoices (unpaid/processing/overdue with dueDate within 3 days)
@riverpod
Future<List<Invoice>> upcomingInvoices(Ref ref) async {
  final allInvoices = await ref.watch(invoicesProvider.future);
  final now = DateTime.now();
  final threeDaysLater = now.add(const Duration(days: 3));

  return allInvoices.where((invoice) {
    // Only show unpaid, processing, overdue, or partially paid invoices
    final isPending = invoice.status == BillStatus.unpaid ||
        invoice.status == BillStatus.processing ||
        invoice.status == BillStatus.overdue ||
        invoice.status == BillStatus.partiallyPaid;

    // Check if dueDate is within 3 days
    if (invoice.dueDate == null) return false;
    final dueDate = invoice.dueDate!;
    final isUpcoming = dueDate.isAfter(now) && dueDate.isBefore(threeDaysLater) ||
        dueDate.isAtSameMomentAs(now) ||
        (dueDate.isBefore(now) && invoice.status == BillStatus.overdue);

    return isPending && isUpcoming;
  }).toList();
}

/// Get landlord's payment account for an invoice
@riverpod
Future<PaymentAccount?> landlordPaymentAccount(Ref ref, String billId) async {
  print(
    '🎯 Provider START: landlordPaymentAccount called with billId: $billId',
  );
  try {
    final repository = ref.watch(invoiceRepositoryProvider);
    print('🎯 Provider: Got repository, calling getLandlordPaymentAccount...');
    final result = await repository.getLandlordPaymentAccount(billId);
    print('🎯 Provider SUCCESS: Got result: ${result != null}');
    return result;
  } catch (e, stack) {
    print('🎯 Provider ERROR: $e');
    print('🎯 Provider STACK: $stack');
    rethrow;
  }
}

/// Get payment account from payment (receiving_account)
@riverpod
Future<PaymentAccount?> paymentAccountFromPayment(
  Ref ref,
  String billId,
) async {
  print(
    '🎯 Provider START: paymentAccountFromPayment called with billId: $billId',
  );
  try {
    final repository = ref.watch(invoiceRepositoryProvider);
    print(
      '🎯 Provider: Got repository, calling getPaymentAccountFromPayment...',
    );
    final result = await repository.getPaymentAccountFromPayment(billId);
    print('🎯 Provider SUCCESS: Got result: ${result != null}');
    return result;
  } catch (e, stack) {
    print('🎯 Provider ERROR: $e');
    print('🎯 Provider STACK: $stack');
    rethrow;
  }
}
