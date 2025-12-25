import 'package:flutter/material.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class PasswordSection extends StatelessWidget {
  const PasswordSection({
    super.key,
    required this.languageCode,
    required this.isDark,
    required this.isExpanded,
    required this.isLoading,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onToggle,
    required this.onSubmit,
  });

  final String languageCode;
  final bool isDark;
  final bool isExpanded;
  final bool isLoading;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onToggle;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizationsHelper.translate(
                    'changePassword',
                    languageCode,
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey[600],
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const SizedBox(height: 16),
                _PasswordField(
                  controller: currentPasswordController,
                  labelKey: 'currentPassword',
                  languageCode: languageCode,
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  controller: newPasswordController,
                  labelKey: 'newPassword',
                  languageCode: languageCode,
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  controller: confirmPasswordController,
                  labelKey: 'confirmNewPassword',
                  languageCode: languageCode,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onSubmit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            AppLocalizationsHelper.translate(
                              'changePassword',
                              languageCode,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.labelKey,
    required this.languageCode,
  });

  final TextEditingController controller;
  final String labelKey;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: AppLocalizationsHelper.translate(
          labelKey,
          languageCode,
        ),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}

