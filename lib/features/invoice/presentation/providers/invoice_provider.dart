import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/invoice.dart';
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
