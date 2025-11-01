import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_filter_provider.dart';
import '../providers/filtered_invoices_provider.dart';
import 'invoice_detail_page.dart';

class InvoicePage extends HookConsumerWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);
    final theme = Theme.of(context);

    // Listen to tab changes and update filter
    useEffect(() {
      void listener() {
        final notifier = ref.read(invoiceFilterProvider.notifier);
        switch (tabController.index) {
          case 0:
            notifier.showAll();
            break;
          case 1:
            notifier.showUnpaid();
            break;
          case 2:
            notifier.showPaid();
            break;
          case 3:
            notifier.showOverdue();
            break;
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: theme.colorScheme.surface,
          child: SafeArea(
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Tất cả'),
                Tab(text: 'Chưa TT'),
                Tab(text: 'Đã TT'),
                Tab(text: 'Quá hạn'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: TabBarView(
            controller: tabController,
            children: const [
              _InvoiceListView(),
              _InvoiceListView(),
              _InvoiceListView(),
              _InvoiceListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceListView extends ConsumerWidget {
  const _InvoiceListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(filteredInvoicesStreamProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(filteredInvoicesStreamProvider);
      },
      child: invoicesAsync.when(
        data: (invoices) {
          if (invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có hoá đơn nào',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return _InvoiceCard(invoice: invoice);
            },
          );
        },
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
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InvoiceDetailPage(billId: invoice.id),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.billNumber ?? 'N/A',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${invoice.roomName ?? 'N/A'} • ${invoice.tenantName ?? 'N/A'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amount Section with gradient background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer.withOpacity(0.3),
                        theme.colorScheme.primaryContainer.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormatter.format(invoice.finalAmount),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      _StatusBadge(status: invoice.status),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Due Date
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: invoice.isOverdue
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Hạn: ${dateFormatter.format(invoice.dueDate ?? DateTime.now())}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: invoice.isOverdue
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: invoice.isOverdue
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (invoice.isOverdue) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.warning_rounded,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BillStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case BillStatus.paid:
        backgroundColor = const Color(0xFF10B981);
        textColor = Colors.white;
        icon = Icons.check_circle_rounded;
        text = 'Đã TT';
        break;
      case BillStatus.unpaid:
        backgroundColor = const Color(0xFFF59E0B);
        textColor = Colors.white;
        icon = Icons.schedule_rounded;
        text = 'Chưa TT';
        break;
      case BillStatus.overdue:
        backgroundColor = const Color(0xFFEF4444);
        textColor = Colors.white;
        icon = Icons.error_rounded;
        text = 'Quá hạn';
        break;
      case BillStatus.cancelled:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurfaceVariant;
        icon = Icons.cancel_rounded;
        text = 'Đã huỷ';
        break;
      case BillStatus.partiallyPaid:
        backgroundColor = const Color(0xFF3B82F6);
        textColor = Colors.white;
        icon = Icons.payments_rounded;
        text = 'TT 1 phần';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
