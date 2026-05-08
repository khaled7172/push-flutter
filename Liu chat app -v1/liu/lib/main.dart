import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reset_password_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cxiiqwnlucgrnqhlahyb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN4aWlxd25sdWNncm5xaGxhaHliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzMjEzNDMsImV4cCI6MjA4ODg5NzM0M30.LKzbzq-nYi9H-i0tnI1fo58jqoP9MfkT_E3fKzPa5jY',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Tracks where to send user on deep link
  Widget _startScreen = supabase.auth.currentSession != null
      ? HomeScreen()
      : const LoginScreen();

  @override
  void initState() {
    super.initState();

    // Listen for auth state changes — catches deep link password reset
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (!mounted) return;

      if (event == AuthChangeEvent.passwordRecovery) {
        // User tapped reset link in email — send to reset screen
        setState(() {
          _startScreen = const ResetPasswordScreen();
        });
      } else if (event == AuthChangeEvent.signedIn) {
        setState(() {
          _startScreen = HomeScreen();
        });
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() {
          _startScreen = const LoginScreen();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: _startScreen,
        );
      },
    );
  }
}