import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/auth_bloc_exports.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/services/locale_provider.dart';
import '../../../../../core/localization/app_localizations_helper.dart';
import '../../../../../core/utils/validation_utils.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../shared/widgets/custom_snackbar.dart';
import 'auth_text_field.dart';
import 'auth_primary_button.dart';
import 'auth_google_button.dart';
import 'auth_apple_button.dart';
import 'auth_divider.dart';

class SignUpForm extends ConsumerStatefulWidget {
  final bool isDark;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignUpForm({
    super.key,
    required this.isDark,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  Future<void> _handleSignUp() async {
    if (!widget.formKey.currentState!.validate()) {
      return;
    }

    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;

    if (!_agreeToTerms) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        AppLocalizationsHelper.translate(
          'mustAgreeToTerms',
          languageCode,
        ),
      );
      return;
    }

    // Kiểm tra kết nối internet
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.checkConnectivity();

    if (!isConnected) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        '${AppLocalizationsHelper.translate('noInternetConnection', languageCode)}. ${AppLocalizationsHelper.translate('pleaseCheckInternetConnection', languageCode)}',
      );
      return;
    }

    if (!mounted) return;
    context.read<AuthBloc>().add(
          SignUpWithEmail(
            email: widget.emailController.text.trim(),
            password: widget.passwordController.text,
            fullName: widget.nameController.text.trim(),
          ),
        );
  }

  Future<void> _handleSignUpWithGoogle() async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;

    // Kiểm tra kết nối internet
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.checkConnectivity();

    if (!isConnected) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        '${AppLocalizationsHelper.translate('noInternetConnection', languageCode)}. ${AppLocalizationsHelper.translate('pleaseCheckInternetConnection', languageCode)}',
      );
      return;
    }

    if (!mounted) return;
    context.read<AuthBloc>().add(SignUpWithGoogle());
  }

  Future<void> _handleSignUpWithApple() async {
    final locale = ref.read(appLocaleProvider);
    final languageCode = locale.languageCode;

    // Kiểm tra kết nối internet
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.checkConnectivity();

    if (!isConnected) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        '${AppLocalizationsHelper.translate('noInternetConnection', languageCode)}. ${AppLocalizationsHelper.translate('pleaseCheckInternetConnection', languageCode)}',
      );
      return;
    }

    if (!mounted) return;
    context.read<AuthBloc>().add(SignUpWithApple());
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;
    final connectivityAsync = ref.watch(connectivityStreamProvider);
    final isConnected = connectivityAsync.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        final isLoading = state is AuthSigningUp;
        final isLoadingGoogle = state is AuthSigningUpWithGoogle;
        final isLoadingApple = state is AuthSigningUpWithApple;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Internet connectivity warning
                if (!isConnected)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizationsHelper.translate('noInternetConnection', languageCode),
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Name field
                AuthTextField(
                  controller: widget.nameController,
                  label: AppLocalizationsHelper.translate('fullName', languageCode),
                  icon: Icons.person_outlined,
                  textCapitalization: TextCapitalization.words,
                  isDark: widget.isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizationsHelper.translate('pleaseEnterName', languageCode);
                    }
                    // Sử dụng validation chặt chẽ hơn
                    final nameError = ValidationUtils.validateName(value);
                    if (nameError != null) {
                      return AppLocalizationsHelper.translate('pleaseEnterName', languageCode);
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Email field
                AuthTextField(
                  controller: widget.emailController,
                  label: AppLocalizationsHelper.translate('email', languageCode),
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  isDark: widget.isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizationsHelper.translate('pleaseEnterEmail', languageCode);
                    }
                    // Sử dụng validation chặt chẽ hơn
                    final emailError = ValidationUtils.validateEmail(value);
                    if (emailError != null) {
                      return AppLocalizationsHelper.translate('invalidEmail', languageCode);
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Password field
                AuthTextField(
                  controller: widget.passwordController,
                  label: AppLocalizationsHelper.translate('password', languageCode),
                  icon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  isDark: widget.isDark,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[500],
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizationsHelper.translate('pleaseEnterPassword', languageCode);
                    }
                    // Sử dụng validation đơn giản (6 ký tự) để không quá strict
                    // Có thể thay bằng validatePassword() nếu muốn strict hơn
                    final passwordError = ValidationUtils.validatePasswordSimple(value, minLength: 6);
                    if (passwordError != null) {
                      return AppLocalizationsHelper.translate('passwordMinLength', languageCode);
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Terms and Privacy Policy checkbox
                _buildTermsCheckbox(languageCode, widget.isDark),

                const SizedBox(height: 24),

                // Sign Up button
                AuthPrimaryButton(
                  text: AppLocalizationsHelper.translate('signUp', languageCode),
                  isLoading: isLoading,
                  onPressed: isConnected ? _handleSignUp : null,
                ),

                const SizedBox(height: 18),

                // Divider
                AuthDivider(isDark: widget.isDark),

                const SizedBox(height: 18),

                // Google Sign Up button
                AuthGoogleButton(
                  text: AppLocalizationsHelper.translate('signUpWithGoogle', languageCode),
                  isLoading: isLoadingGoogle,
                  onPressed: isConnected ? _handleSignUpWithGoogle : null,
                  isDark: widget.isDark,
                ),

                // Apple Sign Up button (iOS only)
                if (Platform.isIOS) ...[
                  const SizedBox(height: 12),
                  AuthAppleButton(
                    text: AppLocalizationsHelper.translate('signUpWithApple', languageCode),
                    isLoading: isLoadingApple,
                    onPressed: isConnected ? _handleSignUpWithApple : null,
                    isDark: widget.isDark,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsCheckbox(String languageCode, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, -4),
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            activeColor: Colors.blue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreeToTerms = !_agreeToTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: _buildTermsText(languageCode, isDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText(String languageCode, bool isDark) {
    final privacyPolicyUrl = AppConstants.privacyPolicyUrl;
    final termsUrl = AppConstants.termsOfServiceUrl;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: AppLocalizationsHelper.translate(
              'iAgreeTo',
              languageCode,
            ),
          ),
          const TextSpan(text: ' '),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _openUrl(termsUrl, languageCode),
              child: Text(
                AppLocalizationsHelper.translate(
                  'termsOfService',
                  languageCode,
                ),
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          TextSpan(
            text: ' ${AppLocalizationsHelper.translate('and', languageCode)} ',
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _openUrl(privacyPolicyUrl, languageCode),
              child: Text(
                AppLocalizationsHelper.translate(
                  'privacyPolicy',
                  languageCode,
                ),
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url, String languageCode) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            context,
            AppLocalizationsHelper.translate('error', languageCode),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          '${AppLocalizationsHelper.translate('anErrorOccurredMessage', languageCode)}: $e',
        );
      }
    }
  }
}

