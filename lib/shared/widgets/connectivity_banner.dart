import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stay_mate/core/services/locale_provider.dart';
import '../../core/services/connectivity_state_provider.dart';
import '../../core/localization/app_localizations_helper.dart';

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityStateProvider);
    final theme = Theme.of(context);

    String message;
    Color backgroundColor;
    IconData icon;

    switch (status) {
      case ConnectivityStatus.reconnecting:
        message = AppLocalizationsHelper.translate('reconnecting', ref.watch(appLocaleProvider).languageCode);
        backgroundColor = Colors.amber.shade700;
        icon = Icons.wifi_tethering_rounded;
        break;
      case ConnectivityStatus.disconnected:
        message = AppLocalizationsHelper.translate('noInternetConnection', ref.watch(appLocaleProvider).languageCode);
        backgroundColor = Colors.red.shade700;
        icon = Icons.wifi_off_rounded;
        break;
      case ConnectivityStatus.connected:
        return const SizedBox.shrink(); // Hide banner when connected
    }

    return Material(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

