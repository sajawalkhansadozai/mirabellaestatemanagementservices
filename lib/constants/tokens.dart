// ===============================
// File: lib/constants/tokens.dart
// Design tokens: colors, gradients, radii, spacing, shadows, meta
// ===============================
import 'package:flutter/material.dart';

class AppColors {
  // Brand blues
  static const Color blueSeed = Color(0xFF1E40AF); // blue-800-ish
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue800 = Color(0xFF1E40AF);

  // Neutrals / slate
  static const Color slate50 = Color(0xFFF8FAFC);
  static const blue400 = Color(0xFF60A5FA); // <— ADD THIS
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color gray900 = Color(0xFF111827);
  static const Color gray700 = Color(0xFF374151);

  // Accents
  static const Color green500 = Color(0xFF22C55E);
  static const Color yellow400 = Color(0xFFF59E0B);

  // Basics
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}

class AppGradients {
  static const LinearGradient blue = LinearGradient(
    colors: [AppColors.blue600, AppColors.blue800],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient blueBr = LinearGradient(
    colors: [AppColors.blue600, AppColors.blue800],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x1A000000), // 10% black
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      blurRadius: 18,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
  ];
}

class AppMeta {
  static const String phone = '+9233300492037';
  static const String email = 'info@mirabellaestatemanagementservices.com';
  static const String officeHours = 'Mon - Sat: 9:00 AM - 6:00 PM';
  static const String addressShort =
      'E-18 Gulshana Sehat Mirabella Complex, Islamabad';
}
