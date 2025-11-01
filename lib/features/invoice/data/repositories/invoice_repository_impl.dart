import '../../domain/entities/invoice.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDatasource _remoteDatasource;

  InvoiceRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<Invoice>> getInvoices() async {
    try {
      final models = await _remoteDatasource.getInvoices();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get invoices: $e');
    }
  }

  @override
  Future<Invoice> getInvoiceDetail(String billId) async {
    try {
      final model = await _remoteDatasource.getInvoiceDetail(billId);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get invoice detail: $e');
    }
  }

  @override
  Stream<List<Invoice>> streamInvoices() {
    return _remoteDatasource.streamInvoices().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<List<Invoice>> getInvoicesByStatus(BillStatus status) async {
    try {
      final allInvoices = await getInvoices();

      // Filter by status and check overdue
      return allInvoices.where((invoice) {
        if (status == BillStatus.overdue) {
          // Show overdue invoices (unpaid and past due date)
          return invoice.isOverdue;
        }
        return invoice.status == status;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get invoices by status: $e');
    }
  }
}
