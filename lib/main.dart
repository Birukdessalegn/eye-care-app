import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/admin_dashboard.dart';
import 'screens/awareness_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/clinics_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/reminder_settings_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/otp_verification_screen.dart';
import 'screens/auth/password_reset_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/questions_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _router = GoRouter(
      refreshListenable: authService,
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationScreen(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const PasswordResetScreen(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) {
            final email = state.extra as String;
            return OtpVerificationScreen(email: email);
          },
        ),
        GoRoute(
          path: '/exercises',
          builder: (context, state) => const ExerciseScreen(),
        ),
        GoRoute(
          path: '/awareness',
          builder: (context, state) => const AwarenessScreen(),
        ),
        GoRoute(
          path: '/reminders',
          builder: (context, state) => const ReminderSettingsScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) {
            final userId = state.extra as String;
            return ChatScreen(userId: userId);
          },
        ),
        GoRoute(
          path: '/clinics',
          builder: (context, state) => const ClinicsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboard(),
        ),
        GoRoute(
          path: '/questions',
          builder: (context, state) => const QuestionsScreen(),
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authService.isLoggedIn;
        final isLoggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/reset-password' ||
            state.matchedLocation == '/otp';

        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }

        if (isLoggedIn && isLoggingIn) {
          return '/';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'OcuCare',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.indigo,
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
