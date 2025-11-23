import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stay_mate/features/auth/presentation/widgets/sign_in_bottom_sheet.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';
import '../bloc/auth_bloc_exports.dart';
import '../utils/auth_error_handler.dart';

class SignUpBottomSheet extends ConsumerStatefulWidget {
  const SignUpBottomSheet({super.key});

  @override
  ConsumerState<SignUpBottomSheet> createState() => _SignUpBottomSheetState();
}

class _SignUpBottomSheetState extends ConsumerState<SignUpBottomSheet> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(appLocaleProvider).languageCode;

    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          // Đăng ký thành công
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizationsHelper.translate(
                    'signUpSuccessShort',
                    languageCode,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            );

            // Đóng bottom sheet sau một delay ngắn
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          }
        } else if (state is AuthError) {
          // Hiển thị lỗi
          if (mounted) {
            final errorMessage = AuthErrorHandler.getErrorMessageFromCode(
              state.message,
              state.code,
              languageCode,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppLocalizationsHelper.translate('signUpErrorPrefix', languageCode)}: $errorMessage',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          final isLoading = state is AuthSigningUp;

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizationsHelper.translate(
                          'signUpAccountTitle',
                          languageCode,
                        ),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizationsHelper.translate(
                          'signUpAccountSubtitle',
                          languageCode,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      child: Column(
                        children: [
                          // Name field
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: AppLocalizationsHelper.translate(
                                'fullName',
                                languageCode,
                              ),
                              prefixIcon: const Icon(Icons.person_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizationsHelper.translate(
                                  'pleaseEnterName',
                                  languageCode,
                                );
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: AppLocalizationsHelper.translate(
                                'email',
                                languageCode,
                              ),
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizationsHelper.translate(
                                  'pleaseEnterEmail',
                                  languageCode,
                                );
                              }
                              if (!value.contains('@')) {
                                return AppLocalizationsHelper.translate(
                                  'invalidEmail',
                                  languageCode,
                                );
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: AppLocalizationsHelper.translate(
                                'password',
                                languageCode,
                              ),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizationsHelper.translate(
                                  'pleaseEnterPassword',
                                  languageCode,
                                );
                              }
                              if (value.length < 6) {
                                return AppLocalizationsHelper.translate(
                                  'passwordMinLength',
                                  languageCode,
                                );
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Sign up button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      AppLocalizationsHelper.translate(
                                        'signUp',
                                        languageCode,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  AppLocalizationsHelper.translate(
                                    'orLabel',
                                    languageCode,
                                  ),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Google sign up button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: isLoading ? null : _signUpWithGoogle,
                              icon: const Icon(Icons.g_mobiledata, size: 24),
                              label: Text(
                                AppLocalizationsHelper.translate(
                                  'signUpWithGoogle',
                                  languageCode,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Switch to sign in
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizationsHelper.translate(
                          'alreadyHaveAccount',
                          languageCode,
                        ),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const SignInBottomSheet(),
                          );
                        },
                        child: Text(
                          AppLocalizationsHelper.translate('signIn', languageCode),
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _signUp() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizationsHelper.translate(
              'pleaseFillAllFields',
              ref.read(appLocaleProvider).languageCode,
            ),
          ),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      SignUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      ),
    );
  }

  Future<void> _signUpWithGoogle() async {
    context.read<AuthBloc>().add(SignUpWithGoogle());
  }
}
