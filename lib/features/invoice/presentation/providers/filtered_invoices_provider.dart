import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/invoice.dart';
import 'invoice_provider.dart';
import 'invoice_filter_provider.dart';

part '../../../../generated/features/invoice/presentation/providers/filtered_invoices_provider.g.dart';

/// Provide filtered invoices based on selected tab
@riverpod
Future<List<Invoice>> filteredInvoices(Ref ref) async {
  final filter = ref.watch(invoiceFilterProvider);
  final invoices = await ref.watch(invoicesByStatusProvider(filter).future);
  // Sort by createdAt descending (newest first)
  invoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return invoices;
}

/// Provide filtered invoices stream with realtime updates
@riverpod
Stream<List<Invoice>> filteredInvoicesStream(Ref ref) async* {
  final filter = ref.watch(invoiceFilterProvider);
  final repository = ref.watch(invoiceRepositoryProvider);
  final allInvoicesStream = repository.streamInvoices();

  await for (final invoices in allInvoicesStream) {
    List<Invoice> result;
    if (filter == null) {
      result = invoices;
    } else {
      // Filter locally from stream
      result = invoices.where((invoice) {
        if (filter == BillStatus.overdue) {
          return invoice.isOverdue;
        }
        return invoice.status == filter;
      }).toList();
    }
    // Sort by createdAt descending (newest first)
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    yield result;
  }
}
