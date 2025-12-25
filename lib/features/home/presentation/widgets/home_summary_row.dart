import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../invoice/presentation/providers/invoice_provider.dart';

class HomeSummaryRow extends HookConsumerWidget {
  const HomeSummaryRow({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingInvoicesAsync = ref.watch(upcomingInvoicesProvider);

    // Memoize currency format to avoid recreating on every build
    final currencyFormat = useMemoized(
      () => NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '₫',
        decimalDigits: 0,
      ),
      [],
    );

    return upcomingInvoicesAsync.when(
      data: (invoices) {
        // Calculate total amount
        final totalAmount = invoices.fold<double>(
          0.0,
          (sum, invoice) => sum + invoice.totalAmount,
        );

        return _UpcomingPaymentCard(
          languageCode: languageCode,
          totalAmount: totalAmount,
          formattedAmount: currencyFormat.format(totalAmount),
          invoiceCount: invoices.length,
        );
      },
      loading: () => _UpcomingPaymentCard(
        languageCode: languageCode,
        totalAmount: 0,
        formattedAmount: '₫0',
        invoiceCount: 0,
        isLoading: true,
      ),
      error: (error, stack) => _UpcomingPaymentCard(
        languageCode: languageCode,
        totalAmount: 0,
        formattedAmount: '₫0',
        invoiceCount: 0,
      ),
    );
  }
}

class _UpcomingPaymentCard extends StatelessWidget {
  const _UpcomingPaymentCard({
    required this.languageCode,
    required this.totalAmount,
    required this.formattedAmount,
    required this.invoiceCount,
    this.isLoading = false,
  });

  final String languageCode;
  final double totalAmount;
  final String formattedAmount;
  final int invoiceCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(
                    Icons.payments_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizationsHelper.translate(
                    'upcomingPayment',
                    languageCode,
                  ),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedAmount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  invoiceCount == 0
                      ? AppLocalizationsHelper.translate(
                          'noUpcomingPayments',
                          languageCode,
                        )
                      : AppLocalizationsHelper.translate(
                          'dueSoon',
                          languageCode,
                        ),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

