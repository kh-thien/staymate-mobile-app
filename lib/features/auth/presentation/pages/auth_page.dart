import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../bloc/auth_bloc_exports.dart';
import '../utils/auth_error_handler.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_card.dart';
import '../widgets/sign_in_form.dart';
import '../widgets/sign_up_form.dart';

/// Màn hình đăng nhập/đăng ký với TabBar
class AuthPage extends ConsumerStatefulWidget {
  final bool initialIsSignIn;

  const AuthPage({
    super.key,
    this.initialIsSignIn = true,
  });

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Sign In controllers
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // Sign Up controllers
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();

  bool _hasShownSuccessMessage = false;
  String? _lastErrorMessage;
  AuthBlocState? _previousState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIsSignIn ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocListener<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        _handleAuthState(context, state);
      },
      child: BlocBuilder<AuthBloc, AuthBlocState>(
        builder: (context, state) {
          // Nếu đã đăng nhập, hiển thị loading
          if (state is AuthAuthenticated) {
            return Scaffold(
              body: Container(
                decoration: _buildBackgroundDecoration(isDark),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            );
          }

          // Hiển thị auth form
          return _buildAuthForm(isDark);
        },
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration(bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                const Color(0xFF0F172A),
                const Color(0xFF1E293B),
                const Color(0xFF334155),
              ]
            : [
                const Color(0xFFF8FAFC),
                const Color(0xFFF1F5F9),
                const Color(0xFFE2E8F0),
              ],
      ),
    );
  }

  Widget _buildAuthForm(bool isDark) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(isDark),
        child: Column(
          children: [
            // SafeArea với language selector ở góc trên
            SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  // Auth Header
                  AuthHeader(isDark: isDark),
                  // Language selector ở góc trên bên phải
                  Positioned(
                    top: 8,
                    right: 16,
                    child: LanguageSelector(
                      isCompact: true,
                      iconColor: isDark
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Auth Card - Chiếm hết phần còn lại, không có SafeArea
            Expanded(
              child: AuthCard(
                isDark: isDark,
                tabController: _tabController,
                signInTab: SignInForm(
                  isDark: isDark,
                  formKey: _signInFormKey,
                  emailController: _signInEmailController,
                  passwordController: _signInPasswordController,
                ),
                signUpTab: SignUpForm(
                  isDark: isDark,
                  formKey: _signUpFormKey,
                  nameController: _signUpNameController,
                  emailController: _signUpEmailController,
                  passwordController: _signUpPasswordController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthBlocState state) {
    if (!mounted) return;
    final languageCode = ref.read(appLocaleProvider).languageCode;

    // Xử lý thành công - CHỈ hiển thị khi chuyển từ AuthSigningIn/AuthSigningUp
    if (state is AuthAuthenticated) {
      // Chỉ hiển thị thông báo nếu previous state là AuthSigningIn
      // (tức là user vừa đăng nhập, không phải app check lại auth status khi khởi động)
      final shouldShowMessage = _previousState is AuthSigningIn;
      
      if (shouldShowMessage && !_hasShownSuccessMessage) {
        _hasShownSuccessMessage = true;
        _lastErrorMessage = null;

        // Hiển thị thông báo thành công
        CustomSnackbar.showSuccess(
          context,
          AppLocalizationsHelper.translate('signInSuccess', languageCode),
        );

        // Navigate đến home sau khi đăng nhập thành công
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          context.go('/');
        });
        return;
      }
      // Nếu không phải từ AuthSigningIn (ví dụ: từ CheckAuthStatus khi app khởi động),
      // router sẽ tự động redirect về home, không cần hiển thị thông báo
    } else if (state is AuthSignUpSuccess) {
      // Chỉ hiển thị thông báo nếu previous state là AuthSigningUp
      final shouldShowMessage = _previousState is AuthSigningUp;
      
      if (shouldShowMessage && !_hasShownSuccessMessage) {
        _hasShownSuccessMessage = true;
        _lastErrorMessage = null;

        // Hiển thị thông báo thành công
        CustomSnackbar.showSuccess(
          context,
          AppLocalizationsHelper.translate('signUpSuccess', languageCode),
        );

        // Navigate đến home sau khi đăng ký thành công
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          context.go('/');
        });
        return;
      }
    }
    // Xử lý email confirmation required
    else if (state is AuthEmailConfirmationRequired) {
      // Chỉ xử lý nếu previous state là AuthSigningUp
      final shouldShowMessage = _previousState is AuthSigningUp;
      
      if (shouldShowMessage && !_hasShownSuccessMessage) {
        _hasShownSuccessMessage = true;
        _lastErrorMessage = null;

        // Hiển thị thông báo yêu cầu xác nhận email
        CustomSnackbar.showInfo(
          context,
          AppLocalizationsHelper.translate(
            'authSignUpEmailConfirmationRequired',
            languageCode,
          ),
        );

        // Chuyển về tab Sign In và clear form
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          _tabController.animateTo(0); // Chuyển về tab Sign In
          // Clear sign up form
          _signUpNameController.clear();
          _signUpEmailController.clear();
          _signUpPasswordController.clear();
        });
      }
    }
    // Xử lý lỗi
    else if (state is AuthError) {
      // Chỉ hiển thị lỗi nếu message khác với lần trước
      if (_lastErrorMessage != state.message) {
        _lastErrorMessage = state.message;
        _hasShownSuccessMessage = false; // Reset để có thể hiển thị success sau khi fix error
        
        // Xử lý error message
        final errorMessage = AuthErrorHandler.getErrorMessageFromCode(
          state.message,
          state.code,
          languageCode,
        );

        // Nếu là admin blocked, hiển thị warning thay vì error
        if (state.code == 'admin_blocked') {
          CustomSnackbar.showWarning(context, errorMessage);
        } else if (state.code == 'email_not_confirmed') {
          // Hiển thị info snackbar cho email not confirmed
          CustomSnackbar.showInfo(context, errorMessage);
        } else {
          // Hiển thị snackbar lỗi
          CustomSnackbar.showError(context, errorMessage);
        }

        // Clear error sau 5 giây để có thể hiển thị lỗi mới
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            _lastErrorMessage = null;
          }
        });
      }
    }
    // Reset flag khi về trạng thái ban đầu
    else if (state is AuthUnauthenticated || state is AuthInitial) {
      _hasShownSuccessMessage = false;
      _lastErrorMessage = null;
    }

    // Lưu state hiện tại làm previous state cho lần tiếp theo
    _previousState = state;
  }
}
