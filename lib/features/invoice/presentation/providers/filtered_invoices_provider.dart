import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/invoice.dart';
import 'invoice_provider.dart';
import 'invoice_filter_provider.dart';

part '../../../../generated/features/invoice/presentation/providers/filtered_invoices_provider.g.dart';

/// Provide filtered invoices based on selected tab
@riverpod
Future<List<Invoice>> filteredInvoices(Ref ref) async {
  final filter = ref.watch(invoiceFilterProvider);
  return ref.watch(invoicesByStatusProvider(filter).future);
}

/// Provide filtered invoices stream with realtime updates
@riverpod
Stream<List<Invoice>> filteredInvoicesStream(Ref ref) async* {
  final filter = ref.watch(invoiceFilterProvider);
  final repository = ref.watch(invoiceRepositoryProvider);
  final allInvoicesStream = repository.streamInvoices();

  await for (final invoices in allInvoicesStream) {
    if (filter == null) {
      yield invoices;
    } else {
      // Filter locally from stream
      final filtered = invoices.where((invoice) {
        if (filter == BillStatus.overdue) {
          return invoice.isOverdue;
        }
        return invoice.status == filter;
      }).toList();
      yield filtered;
    }
  }
}
