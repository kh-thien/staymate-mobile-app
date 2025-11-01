import '../entities/invoice.dart';

abstract class InvoiceRepository {
  /// Get all invoices for current tenant
  Future<List<Invoice>> getInvoices();

  /// Get invoice detail by ID with items
  Future<Invoice> getInvoiceDetail(String billId);

  /// Stream invoices for realtime updates
  Stream<List<Invoice>> streamInvoices();

  /// Get invoices by status
  Future<List<Invoice>> getInvoicesByStatus(BillStatus status);
}
