import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/reminder_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/auth/password_reset_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/awareness_screen.dart';
import 'screens/reminder_settings_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/clinics_screen.dart';
import 'utils/firebase_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('Initializing Firebase...');
  
  try {
    // Initialize Firebase with the correct options
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Activate App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      // You can also set providers for other platforms, like Apple and web.
    );
    print('Firebase App Check activated with debug provider.');
    
    // Test Firebase connection
    await FirebaseTest.testConnection();
    
  } catch (e) {
    print('Firebase initialization or App Check activation failed: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ReminderService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          return MaterialApp.router(
            title: 'Eye Care',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 4,
                centerTitle: true,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routerConfig: GoRouter(
              routes: _buildRoutes(),
              redirect: (context, state) {
                final isLoggedIn = authService.isLoggedIn;
                final isAuthPage = state.uri.toString() == '/login' || 
                                  state.uri.toString() == '/register' ||
                                  state.uri.toString() == '/reset-password';

                if (!isLoggedIn && !isAuthPage) {
                  return '/login';
                }

                if (isLoggedIn && isAuthPage) {
                  return '/';
                }

                return null;
              },
              refreshListenable: authService,
            ),
          );
        },
      ),
    );
  }

  List<RouteBase> _buildRoutes() {
    return [
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
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'exercises',
            builder: (context, state) => const ExerciseScreen(),
          ),
          GoRoute(
            path: 'awareness',
            builder: (context, state) => const AwarenessScreen(),
          ),
          GoRoute(
            path: 'reminders',
            builder: (context, state) => const ReminderSettingsScreen(),
          ),
          GoRoute(
            path: 'chat',
            builder: (context, state) => ChatScreen(userId: 'current_user_id'),
          ),
          GoRoute(
            path: 'clinics',
            builder: (context, state) => const ClinicsScreen(),
          ),
        ],
      ),
    ];
  }
}
