import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ocu_care/registration_screen.dart';
import 'package:ocu_care/firebase_options.dart';
import 'package:ocu_care/home_screen.dart';
import 'package:ocu_care/login_screen.dart';
import 'package:ocu_care/exercise_screen.dart';
import 'package:ocu_care/reminder_settings_screen.dart';
import 'package:ocu_care/awareness_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ocu-Care',
      theme: ThemeData(primarySwatch: Colors.blue), // Fixed syntax here
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placeholder Home Page')),
    ); // Closing the Scaffold properly
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return RegistrationScreen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          // This route will be accessed as /exercises
          path: 'exercises',
          builder: (BuildContext context, GoRouterState state) {
            // You can optionally pass state here if needed for ExerciseScreen
            return ExerciseScreen();
          },
        ),
        GoRoute(
          path: 'reminders',
          builder: (BuildContext context, GoRouterState state) {
            return ReminderSettingsScreen();
          },
        ),
        GoRoute(
          path: 'awareness',
          builder: (BuildContext context, GoRouterState state) {
            return AwarenessScreen();
          },
        ),
      ],
    ),
  ],
);
