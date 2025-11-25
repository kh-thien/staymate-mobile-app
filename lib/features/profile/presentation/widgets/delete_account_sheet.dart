import 'package:flutter/material.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class DeleteAccountResult {
  final bool confirmed;
  final String reason;

  const DeleteAccountResult({required this.confirmed, required this.reason});
}

Future<DeleteAccountResult?> showDeleteAccountSheet({
  required BuildContext context,
  required bool isDark,
  required String languageCode,
}) async {
  final reasonController = TextEditingController();

  final result = await showModalBottomSheet<DeleteAccountResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _DeleteAccountSheet(
      isDark: isDark,
      languageCode: languageCode,
      reasonController: reasonController,
    ),
  );

  reasonController.dispose();
  return result;
}

class _DeleteAccountSheet extends StatefulWidget {
  const _DeleteAccountSheet({
    required this.isDark,
    required this.languageCode,
    required this.reasonController,
  });

  final bool isDark;
  final String languageCode;
  final TextEditingController reasonController;

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  bool isAcknowledged = false;
  String? selectedReason;
  final List<String> presetReasons = [
    'deleteReasonPrivacy',
    'deleteReasonNoLongerRenting',
    'deleteReasonBuggy',
    'deleteReasonOther',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: padding, left: 16, right: 16, top: 12),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.surfaceDarkElevated : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? AppColors.dividerDark
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.warning_rounded, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizationsHelper.translate(
                          'deleteAccount',
                          widget.languageCode,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: widget.isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey[600],
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizationsHelper.translate(
                    'deleteAccountLongDescription',
                    widget.languageCode,
                  ),
                  style: TextStyle(
                    color: widget.isDark
                        ? AppColors.textSecondaryDark
                        : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: presetReasons
                      .map(
                        (key) => ChoiceChip(
                          selected: selectedReason == key,
                          label: Text(
                            AppLocalizationsHelper.translate(
                              key,
                              widget.languageCode,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedReason = selected ? key : null;
                              if (selected) {
                                widget.reasonController.text =
                                    selected && key != 'deleteReasonOther'
                                    ? AppLocalizationsHelper.translate(
                                        key,
                                        widget.languageCode,
                                      )
                                    : '';
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: widget.reasonController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppLocalizationsHelper.translate(
                      'deleteAccountReasonPlaceholder',
                      widget.languageCode,
                    ),
                    hintText: AppLocalizationsHelper.translate(
                      'deleteAccountReasonHint',
                      widget.languageCode,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _AcknowledgementTile(
                  isDark: widget.isDark,
                  languageCode: widget.languageCode,
                  value: isAcknowledged,
                  onChanged: (value) {
                    setState(() {
                      isAcknowledged = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          AppLocalizationsHelper.translate(
                            'cancel',
                            widget.languageCode,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.redAccent.shade400,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: isAcknowledged
                            ? () {
                                Navigator.of(context).pop(
                                  DeleteAccountResult(
                                    confirmed: true,
                                    reason: widget.reasonController.text.trim(),
                                  ),
                                );
                              }
                            : null,
                        child: Text(
                          AppLocalizationsHelper.translate(
                            'deleteAccountConfirm',
                            widget.languageCode,
                          ),
                        ),
                      ),
                    ),
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

class _AcknowledgementTile extends StatelessWidget {
  const _AcknowledgementTile({
    required this.isDark,
    required this.languageCode,
    required this.value,
    required this.onChanged,
  });

  final bool isDark;
  final String languageCode;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.redAccent.shade100 : Colors.redAccent;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: value
                ? color
                : (isDark ? AppColors.borderDark : Colors.grey.shade300),
          ),
          color: value
              ? color.withOpacity(isDark ? 0.15 : 0.12)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Checkbox(value: value, onChanged: onChanged, activeColor: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizationsHelper.translate(
                  'deleteAccountAcknowledge',
                  languageCode,
                ),
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
