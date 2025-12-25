import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';

class LegalLinkWidget extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String url;
  final bool isDark;

  const LegalLinkWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.url,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;

    return InkWell(
      onTap: () => _openUrl(context, ref, url, languageCode),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey[700]!,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey[400]!,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(
    BuildContext context,
    WidgetRef ref,
    String url,
    String languageCode,
  ) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizationsHelper.translate('error', languageCode),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('anErrorOccurredMessage', languageCode)}: $e',
            ),
          ),
        );
      }
    }
  }
}

