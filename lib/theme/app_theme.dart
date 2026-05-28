import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF2563EB);
  static const Color _lightScaffold = Color(0xFFF4F6FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _darkScaffold = Color(0xFF101114);
  static const Color _darkSurface = Color(0xFF181A20);

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
      primary: _seedColor,
      onPrimary: Colors.white,
      surface: _lightSurface,
      onSurface: const Color(0xFF111827),
      surfaceContainerHighest: const Color(0xFFE7ECF3),
    ),
    scaffoldBackgroundColor: _lightScaffold,
    cardTheme: const CardThemeData(
      color: _lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: _lightSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _lightSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _lightScaffold,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF111827)),
      titleTextStyle: TextStyle(
        color: Color(0xFF111827),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD7DEE8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD7DEE8)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFE2E8F0)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF111827)),
      bodyMedium: TextStyle(color: Color(0xFF111827)),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      primary: const Color(0xFF7AA2FF),
      surface: _darkSurface,
      onSurface: const Color(0xFFF8FAFC),
      surfaceContainerHighest: const Color(0xFF242833),
    ),
    scaffoldBackgroundColor: _darkScaffold,
    cardTheme: const CardThemeData(
      color: _darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF2B303B), width: 1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF2B303B), width: 1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF2B303B), width: 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkScaffold,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
      titleTextStyle: TextStyle(
        color: Color(0xFFF8FAFC),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF343A46)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF343A46)),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFF8FAFC)),
      bodyMedium: TextStyle(color: Color(0xFFF8FAFC)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2B303B),
    ),
  );
}
