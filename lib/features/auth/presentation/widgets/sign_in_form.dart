import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../bloc/auth_bloc_exports.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/services/locale_provider.dart';
import '../../../../../core/localization/app_localizations_helper.dart';
import '../../../../../shared/widgets/custom_snackbar.dart';
import 'auth_text_field.dart';
import 'auth_primary_button.dart';
import 'auth_google_button.dart';
import 'auth_divider.dart';

class SignInForm extends ConsumerStatefulWidget {
  final bool isDark;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignInForm({
    super.key,
    required this.isDark,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  bool _obscurePassword = true;

  Future<void> _handleSignIn() async {
    if (!widget.formKey.currentState!.validate()) {
      return;
    }

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
    context.read<AuthBloc>().add(
          SignInWithEmail(
            email: widget.emailController.text.trim(),
            password: widget.passwordController.text,
          ),
        );
  }

  Future<void> _handleSignInWithGoogle() async {
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
    context.read<AuthBloc>().add(SignInWithGoogle());
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
        final isLoading = state is AuthSigningIn;

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
                    if (!value.contains('@')) {
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
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Sign In button
                AuthPrimaryButton(
                  text: AppLocalizationsHelper.translate('signIn', languageCode),
                  isLoading: isLoading,
                  onPressed: isConnected ? _handleSignIn : null,
                ),

                const SizedBox(height: 18),

                // Divider
                AuthDivider(isDark: widget.isDark),

                const SizedBox(height: 18),

                // Google Sign In button
                AuthGoogleButton(
                  text: AppLocalizationsHelper.translate('signInWithGoogle', languageCode),
                  isLoading: isLoading,
                  onPressed: isConnected ? _handleSignInWithGoogle : null,
                  isDark: widget.isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

