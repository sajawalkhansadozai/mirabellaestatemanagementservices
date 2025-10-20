// ===============================
// File: lib/main.dart
// Entry point + app theme + Firebase initialization
// ===============================
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'constants/tokens.dart';
import 'screens/home/home_screen.dart';
import 'firebase_options.dart'; // FlutterFire CLI se generate hoga

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize karein
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MirabellaEstateApp());
}

class MirabellaEstateApp extends StatelessWidget {
  const MirabellaEstateApp({super.key});

  // Firebase Analytics instance
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.blueSeed,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MEMS',
      theme: base.copyWith(
        scaffoldBackgroundColor: AppColors.slate50,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      // Firebase Analytics observer add karein
      navigatorObservers: [observer],
      home: const HomeScreen(),
    );
  }
}
