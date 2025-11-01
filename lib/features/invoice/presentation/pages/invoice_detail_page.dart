import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stay_mate/core/constants/ui_constants.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_provider.dart';

class InvoiceDetailPage extends ConsumerWidget {
  final String billId;

  const InvoiceDetailPage({super.key, required this.billId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(billId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chi tiết hoá đơn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(30),
          //   topRight: Radius.circular(30),
          // ),
        ),
        child: ClipRRect(
          child: invoiceAsync.when(
            data: (invoice) => _InvoiceDetailContent(invoice: invoice),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Lỗi: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(
                      text: error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InvoiceDetailContent extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceDetailContent({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: UIConstants.contentBottomPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Header card với gradient background
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.receipt_long_rounded,
                            color: theme.colorScheme.onPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invoice.billNumber ?? 'N/A',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              _StatusChip(status: invoice.status),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.home_rounded,
                      iconColor: Colors.blue,
                      label: 'Phòng',
                      value: invoice.roomName ?? 'N/A',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.person_rounded,
                      iconColor: Colors.purple,
                      label: 'Khách thuê',
                      value: invoice.tenantName ?? 'N/A',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.calendar_month_rounded,
                      iconColor: Colors.orange,
                      label: 'Kỳ thanh toán',
                      value:
                          '${dateFormatter.format(invoice.periodStart ?? DateTime.now())} - ${dateFormatter.format(invoice.periodEnd ?? DateTime.now())}',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.event_rounded,
                      iconColor: invoice.isOverdue
                          ? theme.colorScheme.error
                          : Colors.green,
                      label: 'Hạn thanh toán',
                      value: dateFormatter.format(
                        invoice.dueDate ?? DateTime.now(),
                      ),
                      valueColor: invoice.isOverdue
                          ? theme.colorScheme.error
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            // Bill items
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.secondaryContainer.withOpacity(0.3),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_rounded,
                            color: theme.colorScheme.secondary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Chi tiết hoá đơn',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${invoice.items.length} mục',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (invoice.items.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox_rounded,
                                  size: 48,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Chưa có chi tiết hoá đơn',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...invoice.items.map(
                          (item) => _BillItemRow(
                            item: item,
                            currencyFormatter: currencyFormatter,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Summary card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calculate_rounded,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tổng kết',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        label: 'Tổng tiền',
                        value: currencyFormatter.format(invoice.totalAmount),
                      ),
                      if (invoice.lateFee > 0) ...[
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Phí trễ hạn',
                          value: currencyFormatter.format(invoice.lateFee),
                          valueColor: theme.colorScheme.error,
                        ),
                      ],
                      if (invoice.discountAmount > 0) ...[
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Giảm giá',
                          value:
                              '- ${currencyFormatter.format(invoice.discountAmount)}',
                          valueColor: Colors.green,
                        ),
                      ],
                      const Divider(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.1),
                              theme.colorScheme.primaryContainer.withOpacity(
                                0.3,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _SummaryRow(
                          label: 'Tổng cộng',
                          value: currencyFormatter.format(invoice.finalAmount),
                          isBold: true,
                          valueColor: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment button
            if (invoice.status == BillStatus.unpaid ||
                invoice.status == BillStatus.overdue ||
                invoice.status == BillStatus.partiallyPaid)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // TODO: Implement payment functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Chức năng thanh toán sẽ được cập nhật sau',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment_rounded,
                              color: theme.colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Thanh toán ngay',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final BillStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case BillStatus.paid:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        text = 'Đã thanh toán';
        break;
      case BillStatus.unpaid:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        text = 'Chưa thanh toán';
        break;
      case BillStatus.overdue:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        text = 'Quá hạn';
        break;
      case BillStatus.cancelled:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        text = 'Đã huỷ';
        break;
      case BillStatus.partiallyPaid:
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        text = 'Thanh toán 1 phần';
        break;
    }

    return Chip(
      label: Text(text),
      backgroundColor: backgroundColor,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(text: '$label: '),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BillItemRow extends StatelessWidget {
  final dynamic item;
  final NumberFormat currencyFormatter;

  const _BillItemRow({required this.item, required this.currencyFormatter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.serviceName ?? item.description ?? 'N/A',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.description != null &&
                    item.serviceName != item.description) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 2)}',
                      ),
                      if (item.unit != null && item.unit!.isNotEmpty) ...[
                        TextSpan(text: ' '),
                        TextSpan(
                          text: item.unit!,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: theme.textTheme.bodySmall!.fontSize! + 1,
                          ),
                        ),
                      ],
                      TextSpan(
                        text: ' x ${currencyFormatter.format(item.unitPrice)}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(item.amount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : null,
            color: isBold ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
