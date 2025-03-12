import 'package:blissflow/screens/emergency_screen.dart';
import 'package:blissflow/screens/home_screen.dart';
import 'package:blissflow/screens/hydration_screen.dart';
import 'package:blissflow/screens/meditation_screen.dart';
import 'package:blissflow/screens/mood_screen.dart';
import 'package:blissflow/screens/profile_screen.dart';
import 'package:blissflow/screens/settings_screen.dart';
import 'package:blissflow/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BlissFlow',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/meditation': (context) => MeditationScreen(),
        '/hydration': (context) => HydrationScreen(),
        '/mood': (context) => MoodScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/emergency': (context) => EmergencyScreen(),
      },
    );
  }
}
