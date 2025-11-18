import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);
    final languageCode = currentLocale.languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2D3748),
          ),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          AppLocalizationsHelper.translate('language', languageCode),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: ListView(
        children: [
          // Vietnamese option
          _buildLanguageOption(
            context: context,
            locale: LocaleService.defaultLocale,
            title: 'Tiếng Việt',
            subtitle: 'Vietnamese',
            isSelected: LocaleService.isVietnamese(currentLocale),
            languageCode: languageCode,
            onTap: () {
              localeNotifier.setLocale(LocaleService.defaultLocale);
            },
          ),
          
          // English option
          _buildLanguageOption(
            context: context,
            locale: LocaleService.englishLocale,
            title: 'English',
            subtitle: 'Tiếng Anh',
            isSelected: LocaleService.isEnglish(currentLocale),
            languageCode: languageCode,
            onTap: () {
              localeNotifier.setLocale(LocaleService.englishLocale);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required Locale locale,
    required String title,
    required String subtitle,
    required bool isSelected,
    required String languageCode,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
    );
  }
}
