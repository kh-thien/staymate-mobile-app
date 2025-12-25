import '../../domain/entities/invoice.dart';
import '../../domain/entities/payment_account.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  @override
  Future<void> confirmPayment({
    required String billNumberOrId,
    required BillStatus newStatus,
    required PaymentMethod paymentMethod,
    required DateTime paymentDate,
  }) async {
    try {
      print('🏪 Repository: Confirming payment for bill $billNumberOrId');
      await _remoteDatasource.confirmPayment(
        billNumberOrId: billNumberOrId,
        newStatus: newStatus,
        paymentMethod: paymentMethod,
        paymentDate: paymentDate,
      );
      print('🏪 Repository: Payment confirmation completed successfully');
    } catch (e) {
      print('🏪 Repository: Payment confirmation failed - $e');
      throw Exception('Failed to confirm payment: $e');
    }
  }

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

  @override
  Future<PaymentAccount?> getLandlordPaymentAccount(String billId) async {
    try {
      print('🏪 Repository: Getting payment account for bill: $billId');
      final model = await _remoteDatasource.getLandlordPaymentAccount(billId);
      print('🏪 Repository: Got payment account model: ${model != null}');
      return model?.toEntity();
    } catch (e) {
      print('🏪 Repository ERROR: $e');
      throw Exception('Failed to get landlord payment account: $e');
    }
  }

  @override
  Future<void> updateBillStatus(
    String billNumberOrId,
    BillStatus newStatus,
  ) async {
    try {
      print(
        '🏪 Repository: Updating bill $billNumberOrId to ${newStatus.name}',
      );
      await _remoteDatasource.updateBillStatus(billNumberOrId, newStatus);
      print('🏪 Repository: Update completed successfully');
    } catch (e) {
      print('🏪 Repository: Update failed - $e');
      throw Exception('Failed to update bill status: $e');
    }
  }

  /// Update payment method and payment date for payments
  @override
  Future<void> updatePaymentInfo({
    required String billId,
    required PaymentMethod paymentMethod,
    required DateTime paymentDate,
    String? receivingAccountId,
  }) async {
    try {
      print('🏪 Repository: Updating payment info for bill $billId');
      await _remoteDatasource.updatePaymentInfo(
        billId: billId,
        paymentMethod: paymentMethod,
        paymentDate: paymentDate,
        receivingAccountId: receivingAccountId,
      );
      print('🏪 Repository: Payment info update completed successfully');
    } catch (e) {
      print('🏪 Repository: Payment info update failed - $e');
      throw Exception('Failed to update payment info: $e');
    }
  }

  /// Get payment account from payment (receiving_account)
  @override
  Future<PaymentAccount?> getPaymentAccountFromPayment(String billId) async {
    try {
      print('🏪 Repository: Getting payment account from payment for bill $billId');
      final model = await _remoteDatasource.getPaymentAccountFromPayment(billId);
      return model?.toEntity();
    } catch (e) {
      print('🏪 Repository ERROR: $e');
      throw Exception('Failed to get payment account from payment: $e');
    }
  }
}
