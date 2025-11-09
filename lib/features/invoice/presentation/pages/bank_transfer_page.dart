import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stay_mate/core/constants/ui_constants.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/payment_account.dart';
import '../providers/invoice_provider.dart';

class BankTransferPage extends ConsumerWidget {
  final Invoice invoice;

  const BankTransferPage({super.key, required this.invoice});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $label'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    // Use bill_number if available, otherwise fallback to id
    final billIdentifier = invoice.billNumber ?? invoice.id;
    print('💰 BankTransferPage: Using billIdentifier: $billIdentifier');
    print('💰 BankTransferPage: invoice.billNumber: ${invoice.billNumber}');
    print('💰 BankTransferPage: invoice.id: ${invoice.id}');

    final paymentAccountAsync = ref.watch(
      landlordPaymentAccountProvider(billIdentifier),
    );

    print(
      '💰 BankTransferPage: paymentAccountAsync state: ${paymentAccountAsync.runtimeType}',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thông tin chuyển khoản',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: paymentAccountAsync.when(
        data: (paymentAccount) {
          if (paymentAccount == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không tìm thấy thông tin tài khoản',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vui lòng liên hệ chủ nhà để được hỗ trợ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return _BankTransferContent(
            invoice: invoice,
            paymentAccount: paymentAccount,
            onCopy: _copyToClipboard,
            currencyFormatter: currencyFormatter,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Lỗi khi tải thông tin',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BankTransferContent extends ConsumerWidget {
  final Invoice invoice;
  final PaymentAccount paymentAccount;
  final void Function(BuildContext, String, String) onCopy;
  final NumberFormat currencyFormatter;

  const _BankTransferContent({
    required this.invoice,
    required this.paymentAccount,
    required this.onCopy,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transferContent = invoice.billNumber ?? invoice.id;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số tiền cần chuyển',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currencyFormatter.format(invoice.finalAmount),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => onCopy(
                      context,
                      invoice.finalAmount.toString(),
                      'số tiền',
                    ),
                    icon: const Icon(Icons.copy, color: Colors.white),
                    tooltip: 'Sao chép số tiền',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bank info section
            Text(
              'Thông tin chuyển khoản',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Bank name
            _InfoCard(
              icon: Icons.account_balance,
              iconColor: Colors.blue,
              label: 'Ngân hàng',
              value: paymentAccount.bankName,
              onCopy: () =>
                  onCopy(context, paymentAccount.bankName, 'tên ngân hàng'),
            ),

            const SizedBox(height: 10),

            // Account number
            _InfoCard(
              icon: Icons.credit_card,
              iconColor: Colors.green,
              label: 'Số tài khoản',
              value: paymentAccount.accountNumber,
              valueStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              onCopy: () =>
                  onCopy(context, paymentAccount.accountNumber, 'số tài khoản'),
            ),

            const SizedBox(height: 10),

            // Account holder
            _InfoCard(
              icon: Icons.person,
              iconColor: Colors.orange,
              label: 'Tên tài khoản',
              value: paymentAccount.accountHolder,
              onCopy: () => onCopy(
                context,
                paymentAccount.accountHolder,
                'tên tài khoản',
              ),
            ),

            const SizedBox(height: 10),

            // Transfer content
            _InfoCard(
              icon: Icons.description,
              iconColor: Colors.purple,
              label: 'Nội dung chuyển khoản',
              value: transferContent,
              valueStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
              onCopy: () =>
                  onCopy(context, transferContent, 'nội dung chuyển khoản'),
              highlightValue: true,
            ),

            if (paymentAccount.branch != null &&
                paymentAccount.branch!.isNotEmpty) ...[
              const SizedBox(height: 10),
              _InfoCard(
                icon: Icons.location_on,
                iconColor: Colors.teal,
                label: 'Chi nhánh',
                value: paymentAccount.branch!,
                showCopyButton: false,
              ),
            ],

            const SizedBox(height: 24),

            // Important note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber.shade700,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lưu ý',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ghi đúng nội dung chuyển khoản. Khi đã chắc chắn chuyển khoản, hãy bấm nút xác nhận bên dưới.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Confirm payment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Show confirmation dialog
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xác nhận thanh toán'),
                      content: const Text(
                        'Bạn đã chuyển khoản theo đúng thông tin?\n\nHóa đơn sẽ chuyển sang trạng thái "Chờ duyệt" và chủ nhà sẽ xác nhận sau khi nhận được tiền.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Chưa'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Đã chuyển khoản'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    try {
                      // Step 1: Update bill status only
                      print('🔄 Updating bill status to PROCESSING...');
                      await ref
                          .read(invoiceRepositoryProvider)
                          .updateBillStatus(
                            invoice.billNumber ?? invoice.id,
                            BillStatus.processing,
                          );
                      print('✅ Bill status updated successfully');

                      // Step 2: Update payment method and date in payments table
                      print(
                        '🔄 Updating payment method and date in payments...',
                      );
                      await ref
                          .read(invoiceRepositoryProvider)
                          .updatePaymentInfo(
                            billId: invoice.id,
                            paymentMethod: PaymentMethod.bankTransfer,
                            paymentDate: DateTime.now().toUtc(),
                            receivingAccountId: paymentAccount.id,
                          );
                      print('✅ Payment info updated successfully');

                      if (context.mounted) {
                        print('🔙 Closing bank transfer page with result...');
                        // Pop bank transfer page with result
                        Navigator.pop(context, {'paymentConfirmed': true});
                      }
                    } catch (e) {
                      print('❌ Error updating bill status: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Xác nhận đã thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: UIConstants.contentBottomPadding),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final TextStyle? valueStyle;
  final VoidCallback? onCopy;
  final bool showCopyButton;
  final bool highlightValue;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueStyle,
    this.onCopy,
    this.showCopyButton = true,
    this.highlightValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlightValue
            ? Colors.red.shade50
            : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlightValue
              ? Colors.red.shade200
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: highlightValue ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:
                      valueStyle ??
                      theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          if (showCopyButton && onCopy != null)
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy, size: 20),
              tooltip: 'Sao chép',
              style: IconButton.styleFrom(
                backgroundColor: iconColor.withOpacity(0.1),
                foregroundColor: iconColor,
              ),
            ),
        ],
      ),
    );
  }
}
