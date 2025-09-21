import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/auth/password_reset_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/awareness_screen.dart';
import '../screens/reminder_settings_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/admin_dashboard.dart';
import '../screens/clinics_screen.dart';
import '../screens/questions_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        builder: (context, state) {
          final email = state.extra as String;
          return OtpVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: '/questions',
        builder: (context, state) => const QuestionsScreen(),
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
            builder: (context, state) =>
                const ChatScreen(userId: ''), // Remove userId if not needed
          ),
          GoRoute(
            path: 'admin',
            builder: (context, state) => const AdminDashboard(),
          ),
          GoRoute(
            path: 'clinics',
            builder: (context, state) => const ClinicsScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // We'll handle authentication redirects in the main.dart file
      // using a Consumer to access the AuthService
      return null;
    },
  );
}
