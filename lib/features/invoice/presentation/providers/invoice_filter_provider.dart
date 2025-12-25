import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/invoice.dart';

part '../../../../generated/features/invoice/presentation/providers/invoice_filter_provider.g.dart';

/// Filter state for invoice tabs
@riverpod
class InvoiceFilter extends _$InvoiceFilter {
  @override
  BillStatus? build() {
    return null; // null means show all invoices
  }

  void setFilter(BillStatus? status) {
    state = status;
  }

  void showAll() {
    state = null;
  }

  void showUnpaid() {
    state = BillStatus.unpaid;
  }

  void showProcessing() {
    state = BillStatus.processing;
  }

  void showPaid() {
    state = BillStatus.paid;
  }

  void showOverdue() {
    state = BillStatus.overdue;
  }
}
