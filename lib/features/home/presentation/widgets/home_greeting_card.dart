import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations_helper.dart';

class HomeGreetingCard extends StatelessWidget {
  const HomeGreetingCard({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5A77FF), Color(0xFF7E8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A77FF).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greetingMessage(languageCode),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizationsHelper.translate(
              'homeWelcomeMessage',
              languageCode,
            ),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _PrimaryActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  translationKey: 'scanQRCode',
                  languageCode: languageCode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PrimaryActionButton(
                  icon: Icons.keyboard_rounded,
                  translationKey: 'enterCode',
                  languageCode: languageCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _greetingMessage(String languageCode) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppLocalizationsHelper.translate(
        'homeGreetingMorning',
        languageCode,
      );
    } else if (hour < 18) {
      return AppLocalizationsHelper.translate(
        'homeGreetingAfternoon',
        languageCode,
      );
    }
    return AppLocalizationsHelper.translate(
      'homeGreetingEvening',
      languageCode,
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.icon,
    required this.translationKey,
    required this.languageCode,
  });

  final IconData icon;
  final String translationKey;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        final message = AppLocalizationsHelper.translate(
          'featureUnderDevelopment',
          languageCode,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5A77FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      icon: Icon(icon, color: const Color(0xFF5A77FF)),
      label: Text(
        AppLocalizationsHelper.translate(translationKey, languageCode),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

