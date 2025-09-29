import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/utils/helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // TODO: Implement login logic with BLoC
        await Future.delayed(const Duration(seconds: 2)); // Mock delay

        // Navigate to home or show success
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đăng nhập thất bại: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // Logo or App Name
                const Text(
                  'StayMate',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSizes.paddingS),

                const Text(
                  'Chào mừng bạn trở lại',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                // Email Field
                CustomTextField(
                  label: 'Email',
                  hint: 'Nhập email của bạn',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationUtils.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Password Field
                CustomTextField(
                  label: 'Mật khẩu',
                  hint: 'Nhập mật khẩu của bạn',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),

                const SizedBox(height: AppSizes.paddingM),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to forgot password
                    },
                    child: const Text('Quên mật khẩu?'),
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Login Button
                CustomButton(
                  text: 'Đăng nhập',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Chưa có tài khoản? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Đăng ký ngay'),
                    ),
                  ],
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
