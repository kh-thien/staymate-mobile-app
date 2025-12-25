import '../entities/invoice.dart';
import '../entities/payment_account.dart';

abstract class InvoiceRepository {
  /// Confirm payment: update bill status, payment method, and payment date atomically
  Future<void> confirmPayment({
    required String billNumberOrId,
    required BillStatus newStatus,
    required PaymentMethod paymentMethod,
    required DateTime paymentDate,
  });

  /// Get all invoices for current tenant
  Future<List<Invoice>> getInvoices();

  /// Get invoice detail by ID with items
  Future<Invoice> getInvoiceDetail(String billId);

  /// Stream invoices for realtime updates
  Stream<List<Invoice>> streamInvoices();

  /// Get invoices by status
  Future<List<Invoice>> getInvoicesByStatus(BillStatus status);

  /// Get landlord's default payment account for an invoice
  Future<PaymentAccount?> getLandlordPaymentAccount(String billId);

  /// Update bill status
  Future<void> updateBillStatus(String billNumberOrId, BillStatus newStatus);

    /// Update payment method and payment date for payments
    Future<void> updatePaymentInfo({
      required String billId,
      required PaymentMethod paymentMethod,
      required DateTime paymentDate,
      String? receivingAccountId,
    });

  /// Get payment account from payment (receiving_account)
  Future<PaymentAccount?> getPaymentAccountFromPayment(String billId);
  }
