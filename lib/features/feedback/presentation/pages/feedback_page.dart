import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';

class FeedbackPage extends HookConsumerWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final subjectController = useTextEditingController();
    final messageController = useTextEditingController();
    final isLoading = useState(false);

    Future<void> submitFeedback() async {
      if (subjectController.text.trim().isEmpty ||
          messageController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizationsHelper.translate(
                'pleaseFillAllFields',
                languageCode,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      isLoading.value = true;

      try {
        final String email = 'staymate.home@gmail.com';
        final String subject = Uri.encodeComponent(
          '[Feedback] ${subjectController.text.trim()}',
        );
        final String body = Uri.encodeComponent(
          '${messageController.text.trim()}\n\n---\nSubmitted from Stay Mate App',
        );
        final Uri emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');

        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizationsHelper.translate(
                    'feedbackSent',
                    languageCode,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );
            
            // Clear form
            subjectController.clear();
            messageController.clear();
            
            // Navigate back after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            });
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizationsHelper.translate(
                    'cannotOpenEmailApp',
                    languageCode,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizationsHelper.translate('error', languageCode)}: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.surfaceDarkElevated
            : Colors.white,
        foregroundColor: isDark
            ? AppColors.textPrimaryDark
            : Colors.black,
        elevation: 0,
        title: Text(
          AppLocalizationsHelper.translate(
            'sendFeedback',
            languageCode,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppColors.textPrimaryDark
                : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDarkElevated
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.borderDark
                      : Colors.blue[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : Colors.blue[700],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizationsHelper.translate(
                        'feedbackInfo',
                        languageCode,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subject field
            Text(
              AppLocalizationsHelper.translate(
                'feedbackSubject',
                languageCode,
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: AppLocalizationsHelper.translate(
                  'feedbackSubjectHint',
                  languageCode,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.surfaceDarkElevated
                    : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : Colors.black87,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Message field
            Text(
              AppLocalizationsHelper.translate(
                'feedbackMessage',
                languageCode,
              ),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: AppLocalizationsHelper.translate(
                  'feedbackMessageHint',
                  languageCode,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.surfaceDarkElevated
                    : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : Colors.black87,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading.value ? null : submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        AppLocalizationsHelper.translate(
                          'sendFeedback',
                          languageCode,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

