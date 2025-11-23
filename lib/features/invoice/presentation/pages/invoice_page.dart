import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../domain/entities/invoice.dart';
import '../providers/invoice_filter_provider.dart';
import '../providers/filtered_invoices_provider.dart';
import 'invoice_detail_page.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/providers/app_bar_provider.dart';




class InvoicePage extends HookConsumerWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 5);
    final theme = Theme.of(context);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    // Manage AppBar State
    useEffect(() {
      final notifier = ref.read(appBarProvider.notifier);
      // Use a small delay to ensure this runs after any cleanup from previous page
      Future.microtask(() {
        notifier.updateTitle(
          AppLocalizationsHelper.translate('invoices', languageCode),
        );
      });
      // Don't reset in cleanup - let the next page set its own title
      return null;
    }, const []);

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
            notifier.showProcessing();
            break;
          case 3:
            notifier.showPaid();
            break;
          case 4:
            notifier.showOverdue();
            break;
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Custom TabBar with modern design
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.primaryContainer,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: theme.colorScheme.onPrimaryContainer,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.receipt_long_rounded, size: 18),
                        text: AppLocalizationsHelper.translate('all', languageCode),
                      ),
                      Tab(
                        icon: const Icon(Icons.pending_actions_rounded, size: 18),
                        text: AppLocalizationsHelper.translate('unpaidShort', languageCode),
                      ),
                      Tab(
                        icon: const Icon(Icons.hourglass_empty_rounded, size: 18),
                        text: AppLocalizationsHelper.translate('processing', languageCode),
                      ),
                      Tab(
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        text: AppLocalizationsHelper.translate('paidShort', languageCode),
                      ),
                      Tab(
                        icon: const Icon(Icons.error_rounded, size: 18),
                        text: AppLocalizationsHelper.translate('overdue', languageCode),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // TabBarView content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _InvoiceListView(tabController: tabController),
                    _InvoiceListView(tabController: tabController),
                    _InvoiceListView(tabController: tabController),
                    _InvoiceListView(tabController: tabController),
                    _InvoiceListView(tabController: tabController),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceListView extends ConsumerWidget {
  final TabController tabController;

  const _InvoiceListView({required this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final invoicesAsync = ref.watch(filteredInvoicesStreamProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(filteredInvoicesStreamProvider);
      },
      child: invoicesAsync.when(
        data: (invoices) {
          if (invoices.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: AppLocalizationsHelper.translate('noInvoicesFound', languageCode),
              subtitle: AppLocalizationsHelper.translate('invoicesOfThisCategoryWillAppearHere', languageCode),
              onRefresh: () => ref.invalidate(filteredInvoicesStreamProvider),
              refreshLabel: AppLocalizationsHelper.translate('refresh', languageCode),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: UIConstants.contentBottomPadding,
            ),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return _InvoiceCard(
                invoice: invoice,
                tabController: tabController,
              );
            },
          );
        },
                loading: () => ListView.builder(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: UIConstants.contentBottomPadding,
          ),
          itemCount: 5, // Display 5 skeleton items while loading
          itemBuilder: (context, index) => const InvoiceCardSkeleton(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppLocalizationsHelper.translate('error', languageCode)}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: error.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(filteredInvoicesStreamProvider);
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    AppLocalizationsHelper.translate('tryAgain', languageCode),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
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

class _InvoiceCard extends ConsumerWidget {
  final Invoice invoice;
  final TabController tabController;

  const _InvoiceCard({required this.invoice, required this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    // Format currency - Always use VND
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.surfaceDarkElevated 
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? AppColors.borderDark 
              : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InvoiceDetailPage(billId: invoice.id),
              ),
            );

            // If result contains switchToTab, animate to that tab
            print('📱 InvoicePage: Received result: $result');
            if (result is Map && result['switchToTab'] != null) {
              print('🔄 Switching to tab: ${result['switchToTab']}');

              // Invalidate provider to refresh the list
              print('♻️  Invalidating invoices provider...');
              ref.invalidate(filteredInvoicesStreamProvider);

              tabController.animateTo(result['switchToTab']);

              // Show success message
              if (context.mounted) {
                final locale = ref.read(appLocaleProvider);
                final languageCode = locale.languageCode;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizationsHelper.translate('paymentRecorded', languageCode),
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
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
                          if (invoice.name != null && invoice.name!.isNotEmpty)
                            Text(
                              invoice.name!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (invoice.name != null && invoice.name!.isNotEmpty)
                            const SizedBox(height: 4),
                          Text(
                            invoice.billNumber ?? 'N/A',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
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
                          AppLocalizationsHelper.translate('totalAmount', languageCode),
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
                      '${AppLocalizationsHelper.translate('dueDate', languageCode)}: ${dateFormatter.format(invoice.dueDate ?? DateTime.now())}',
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

class _StatusBadge extends ConsumerWidget {
  final BillStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case BillStatus.paid:
        backgroundColor = const Color(0xFF10B981);
        textColor = Colors.white;
        icon = Icons.check_circle_rounded;
        text = AppLocalizationsHelper.translate('paidShort', languageCode);
        break;
      case BillStatus.unpaid:
        backgroundColor = const Color(0xFFF59E0B);
        textColor = Colors.white;
        icon = Icons.schedule_rounded;
        text = AppLocalizationsHelper.translate('unpaidShort', languageCode);
        break;
      case BillStatus.processing:
        backgroundColor = const Color(0xFF8B5CF6);
        textColor = Colors.white;
        icon = Icons.hourglass_empty_rounded;
        text = AppLocalizationsHelper.translate('processing', languageCode);
        break;
      case BillStatus.overdue:
        backgroundColor = const Color(0xFFEF4444);
        textColor = Colors.white;
        icon = Icons.error_rounded;
        text = AppLocalizationsHelper.translate('overdue', languageCode);
        break;
      case BillStatus.cancelled:
        backgroundColor = theme.colorScheme.surfaceContainerHighest;
        textColor = theme.colorScheme.onSurfaceVariant;
        icon = Icons.cancel_rounded;
        text = AppLocalizationsHelper.translate('cancelled', languageCode);
        break;
      case BillStatus.partiallyPaid:
        backgroundColor = const Color(0xFF3B82F6);
        textColor = Colors.white;
        icon = Icons.payments_rounded;
        text = AppLocalizationsHelper.translate('partiallyPaid', languageCode);
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
