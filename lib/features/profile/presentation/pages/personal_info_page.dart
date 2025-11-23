import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';
import '../widgets/personal_info_header.dart';
import '../widgets/profile_section_card.dart';

class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final user = Supabase.instance.client.auth.currentUser;
    final Map<String, dynamic> metadata =
        Map<String, dynamic>.from(user?.userMetadata ?? {});
    final Map<String, dynamic> accountMetadata =
        Map<String, dynamic>.from(user?.appMetadata ?? {});
    final fullName = (metadata['full_name'] as String?)?.trim();
    final phoneNumber = (metadata['phone'] as String?)?.trim();
    final avatarUrl = (metadata['avatar_url'] as String?)?.trim();

    final createdAtRaw = user?.createdAt;
    DateTime? createdAt;
    if (createdAtRaw != null) {
      try {
        createdAt = DateTime.parse(createdAtRaw);
      } catch (_) {
        createdAt = null;
      }
    }
    final createdAtFormatted = createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(createdAt.toLocal())
        : '-';
    final joinedAtLabel = createdAt != null
        ? AppLocalizationsHelper.translateWithParams(
            'memberSince',
            languageCode,
            {
              'date': DateFormat('dd/MM/yyyy HH:mm').format(
                createdAt.toLocal(),
              ),
            },
          )
        : '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.surfaceDarkElevated : Colors.white,
        foregroundColor:
            isDark ? AppColors.textPrimaryDark : Colors.black,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textPrimaryDark : Colors.black,
        ),
        title: Text(
          AppLocalizationsHelper.translate(
            'personalInfo',
            languageCode,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        width: double.infinity,
        color: isDark ? AppColors.surfaceDark : Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PersonalInfoHeader(
                fullName: fullName ??
                    AppLocalizationsHelper.translate(
                      'user',
                      languageCode,
                    ),
                email: user?.email ?? '-',
                joinedAt: joinedAtLabel,
                avatarUrl: avatarUrl,
              ),
              const SizedBox(height: 20),
              ProfileSectionCard(
                title: AppLocalizationsHelper.translate(
                  'personalInfo',
                  languageCode,
                ),
                children: [
                  ProfileInfoRow(
                    label: AppLocalizationsHelper.translate(
                      'fullName',
                      languageCode,
                    ),
                    value: fullName ??
                        AppLocalizationsHelper.translate(
                            'user',
                            languageCode,
                          ),
                  ),
                  ProfileInfoRow(
                    label: AppLocalizationsHelper.translate(
                      'email',
                      languageCode,
                    ),
                    value: user?.email ?? '-',
                  ),
                  if (phoneNumber != null && phoneNumber.isNotEmpty)
                    ProfileInfoRow(
                      label: AppLocalizationsHelper.translate(
                        'phoneNumber',
                        languageCode,
                      ),
                      value: phoneNumber,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ProfileSectionCard(
                title: AppLocalizationsHelper.translate(
                  'account',
                  languageCode,
                ),
                children: [
                  ProfileInfoRow(
                    label: AppLocalizationsHelper.translate(
                      'userId',
                      languageCode,
                    ),
                    value: user?.id ?? '-',
                  ),
                  ProfileInfoRow(
                    label: AppLocalizationsHelper.translate(
                      'created',
                      languageCode,
                    ),
                    value: createdAtFormatted,
                  ),
                  ProfileInfoRow(
                    label: AppLocalizationsHelper.translate(
                      'loginProvider',
                      languageCode,
                    ),
                    value:
                        (accountMetadata['provider'] as String?) ?? 'email',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

