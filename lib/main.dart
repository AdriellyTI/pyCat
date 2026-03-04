import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboard.dart';

void main() {
  runApp(const PyCatApp());
}

class PyCatApp extends StatelessWidget {
  const PyCatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PyCat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3B5998),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const OnboardScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
