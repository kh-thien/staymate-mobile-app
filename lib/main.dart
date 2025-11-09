import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/router/auth_state_notifier.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'core/services/firebase_messaging_service.dart';
import 'features/auth/presentation/bloc/auth_bloc_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Vietnamese locale
  await initializeDateFormatting('vi', null);
  await initializeDateFormatting('vi_VN', null);

  await dotenv.load(fileName: ".env");

  // Suppress app_links plugin errors
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('app_links')) {
      return; // Ignore app_links errors
    }
    FlutterError.presentError(details);
  };

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Initialize Firebase và Firebase Messaging
  String? fcmToken;
  try {
    print('🔄 Initializing Firebase Core...');
    // Khởi tạo Firebase với options từ firebase_options.dart
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase Core initialized successfully');
    
    print('🔄 Initializing Firebase Messaging...');
    final firebaseMessagingService = FirebaseMessagingService();
    fcmToken = await firebaseMessagingService.initialize();
    
    if (fcmToken != null) {
      print('✅ Firebase Messaging initialized successfully');
      print('📱 FCM Token ID: $fcmToken');
    } else {
      print('⚠️ Firebase Messaging initialized but token is null');
      print('💡 This might be due to:');
      print('   1. Notification permission not granted');
      print('   2. Firebase not properly configured');
      print('   3. Google Services plugin not applied correctly');
    }
  } catch (e, stackTrace) {
    print('❌ Firebase initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
    print('💡 App will continue to run, but push notifications may not work');
    // App vẫn có thể chạy được, chỉ không có push notifications
  }

  runApp(const ProviderScope(child: StayMateApp()));
}

class StayMateApp extends StatefulWidget {
  const StayMateApp({super.key});

  @override
  State<StayMateApp> createState() => _StayMateAppState();
}

class _StayMateAppState extends State<StayMateApp> {
  late final AuthStateNotifier _authStateNotifier;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authStateNotifier = AuthStateNotifier();
    _router = AppRouter.createRouter(_authStateNotifier);
  }

  @override
  void dispose() {
    _authStateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc to the entire app
        BlocProvider<AuthBloc>(
          create: (context) {
            final bloc = AuthBloc(authService: AuthService())
              ..add(CheckAuthStatus()); // Check initial auth status
            
            // Update notifier với state ban đầu
            // AuthStateListener sẽ tiếp tục update khi state thay đổi
            _authStateNotifier.updateState(bloc.state);
            
            return bloc;
          },
        ),
      ],
      child: AuthStateListener(
        notifier: _authStateNotifier,
        child: MaterialApp.router(
          title: 'StayMate',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: _router,
        ),
      ),
    );
  }
}
