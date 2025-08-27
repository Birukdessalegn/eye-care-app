import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocu_care/registration_screen.dart';
import 'package:ocu_care/doctor_home_screen.dart';
import 'package:ocu_care/home_screen.dart';
import 'package:ocu_care/login_screen.dart';
import 'package:ocu_care/exercise_screen.dart';
import 'package:ocu_care/reminder_settings_screen.dart';
import 'package:ocu_care/awareness_screen.dart';
import 'package:ocu_care/chat_screen.dart';

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
      title: 'Ocu-Care', // App title
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can keep this or use primaryColor
        scaffoldBackgroundColor:
            Colors.white, // Set the background color to white
      ),
      routerConfig: _router,
    );
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
 final user = FirebaseAuth.instance.currentUser;
 if (user == null) {
 // If the user is not logged in, redirect to login
 return LoginScreen();
 } else {
 // If the user is logged in, fetch their role and navigate accordingly
 return FutureBuilder<DocumentSnapshot>(
 future: FirebaseFirestore.instance
 .collection('users')
 .doc(user.uid)
 .get(),
 builder: (context, snapshot) {
 if (snapshot.connectionState == ConnectionState.waiting) {
 return const Scaffold(
 body: Center(child: CircularProgressIndicator()),
 );
 }
 if (snapshot.hasData && snapshot.data!.exists) {
 final role = snapshot.data!['role'];
 return role == 'Doctor' ? DoctorHomeScreen() : HomeScreen();
 }
 return LoginScreen(); // Default to login if role not found
 },
 );
 }
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
 GoRoute(
 path: '/chat/:userId',
 builder: (BuildContext context, GoRouterState state) {
 final userId = state.pathParameters['userId']!;
 return ChatScreen(userId: userId);
 },
 ),
 ],
);
  