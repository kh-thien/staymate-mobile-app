import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';

/// Empty state widget for chat screens
class ChatEmptyState extends ConsumerWidget {
  final String? customMessage;
  final String? customSubtitle;

  const ChatEmptyState({super.key, this.customMessage, this.customSubtitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final isDark = theme.brightness == Brightness.dark;

    // Use custom message if provided (for chat detail page), otherwise use default contract message
    final title =
        customMessage ??
        AppLocalizationsHelper.translate('noConversationsYet', languageCode);
    final subtitle =
        customSubtitle ??
        AppLocalizationsHelper.translate(
          'chatWillAppearWhenYouHaveContract',
          languageCode,
        );
    final showContactLandlord = customMessage == null;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 24),
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 100,
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (showContactLandlord) ...[
                const SizedBox(height: 12),
                Text(
                  AppLocalizationsHelper.translate(
                    'pleaseContactLandlord',
                    languageCode,
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_downward_rounded,
                    size: 16,
                    color: isDark
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.6)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizationsHelper.translate(
                      'pullDownToRefresh',
                      languageCode,
                    ),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.7,
                      ),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
