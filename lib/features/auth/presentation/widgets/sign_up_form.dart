import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../bloc/auth_bloc_exports.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../shared/widgets/custom_snackbar.dart';
import 'auth_text_field.dart';
import 'auth_primary_button.dart';
import 'auth_google_button.dart';
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

  Future<void> _handleSignUp() async {
    if (!widget.formKey.currentState!.validate()) {
      return;
    }

    // Kiểm tra kết nối internet
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.checkConnectivity();

    if (!isConnected) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        'Không có kết nối internet. Vui lòng kiểm tra lại kết nối mạng.',
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
    // Kiểm tra kết nối internet
    final connectivityService = ref.read(connectivityServiceProvider);
    final isConnected = await connectivityService.checkConnectivity();

    if (!isConnected) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        'Không có kết nối internet. Vui lòng kiểm tra lại kết nối mạng.',
      );
      return;
    }

    if (!mounted) return;
    context.read<AuthBloc>().add(SignUpWithGoogle());
  }

  @override
  Widget build(BuildContext context) {
    final connectivityAsync = ref.watch(connectivityStreamProvider);
    final isConnected = connectivityAsync.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    return BlocBuilder<AuthBloc, AuthBlocState>(
      builder: (context, state) {
        final isLoading = state is AuthSigningUp;

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
                            'Không có kết nối internet',
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
                  label: 'Họ và tên',
                  icon: Icons.person_outlined,
                  textCapitalization: TextCapitalization.words,
                  isDark: widget.isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Email field
                AuthTextField(
                  controller: widget.emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  isDark: widget.isDark,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!value.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // Password field
                AuthTextField(
                  controller: widget.passwordController,
                  label: 'Mật khẩu',
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
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Sign Up button
                AuthPrimaryButton(
                  text: 'Đăng ký',
                  isLoading: isLoading,
                  onPressed: isConnected ? _handleSignUp : null,
                ),

                const SizedBox(height: 18),

                // Divider
                AuthDivider(isDark: widget.isDark),

                const SizedBox(height: 18),

                // Google Sign Up button
                AuthGoogleButton(
                  text: 'Đăng ký với Google',
                  isLoading: isLoading,
                  onPressed: isConnected ? _handleSignUpWithGoogle : null,
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

