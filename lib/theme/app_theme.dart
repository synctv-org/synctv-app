import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF2563EB);
  static const Color _secondary = Color(0xFF0F766E);
  static const Color _tertiary = Color(0xFF7C3AED);
  static const Color _lightScaffold = Color(0xFFF6F7FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _darkScaffold = Color(0xFF111318);
  static const Color _darkSurface = Color(0xFF181B22);
  static const BorderRadius _controlRadius = BorderRadius.all(
    Radius.circular(8),
  );
  static const Size _controlMinSize = Size(44, 44);

  static const FlexSchemeData _scheme = FlexSchemeData(
    name: 'SyncTV',
    description: 'SyncTV production color system',
    light: FlexSchemeColor(
      primary: _primary,
      primaryContainer: Color(0xFFDDE7FF),
      secondary: _secondary,
      secondaryContainer: Color(0xFFCDEDE8),
      tertiary: _tertiary,
      tertiaryContainer: Color(0xFFE9DDFF),
      appBarColor: _lightScaffold,
      error: Color(0xFFDC2626),
    ),
    dark: FlexSchemeColor(
      primary: Color(0xFF93B4FF),
      primaryContainer: Color(0xFF173C8F),
      secondary: Color(0xFF5ED0C5),
      secondaryContainer: Color(0xFF0B514B),
      tertiary: Color(0xFFC4B5FD),
      tertiaryContainer: Color(0xFF4C1D95),
      appBarColor: _darkScaffold,
      error: Color(0xFFF87171),
    ),
  );

  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    interactionEffects: true,
    useMaterial3Typography: true,
    defaultRadius: 8,
    buttonMinSize: _controlMinSize,
    textButtonRadius: 8,
    filledButtonRadius: 8,
    elevatedButtonRadius: 8,
    outlinedButtonRadius: 8,
    segmentedButtonRadius: 8,
    inputDecoratorRadius: 8,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorIsDense: true,
    inputDecoratorIsFilled: true,
    inputDecoratorUnfocusedHasBorder: true,
    inputDecoratorFocusedBorderWidth: 1.4,
    cardRadius: 8,
    dialogRadius: 12,
    bottomSheetRadius: 12,
    popupMenuRadius: 8,
    menuRadius: 8,
    tooltipRadius: 6,
    snackBarRadius: 8,
  );

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color focusedColor,
    required Color disabledColor,
    required Color errorColor,
    required Color iconColor,
  }) {
    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: _controlRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: const BoxConstraints(minHeight: 44),
      prefixIconColor: iconColor,
      suffixIconColor: iconColor,
      prefixIconConstraints: const BoxConstraints.tightFor(
        width: 44,
        height: 44,
      ),
      suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      border: border(borderColor),
      enabledBorder: border(borderColor),
      focusedBorder: border(focusedColor, width: 1.4),
      disabledBorder: border(disabledColor),
      errorBorder: border(errorColor),
      focusedErrorBorder: border(errorColor, width: 1.4),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  static ButtonStyle _buttonStyle() {
    return const ButtonStyle(
      minimumSize: WidgetStatePropertyAll(_controlMinSize),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: _controlRadius),
      ),
      textStyle: WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  static IconButtonThemeData _iconButtonTheme() {
    return const IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(_controlMinSize),
        tapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.standard,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: _controlRadius),
        ),
      ),
    );
  }

  static ThemeData get light {
    final theme = FlexThemeData.light(
      colors: _scheme.light,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 3,
      scaffoldBackground: _lightScaffold,
      surface: _lightSurface,
      subThemesData: _subThemes,
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
    return _finishLight(theme);
  }

  static ThemeData get dark {
    final theme = FlexThemeData.dark(
      colors: _scheme.dark,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 8,
      scaffoldBackground: _darkScaffold,
      surface: _darkSurface,
      darkIsTrueBlack: false,
      subThemesData: _subThemes,
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
    );
    return _finishDark(theme);
  }

  static ThemeData _finishLight(ThemeData theme) {
    return theme.copyWith(
      scaffoldBackgroundColor: _lightScaffold,
      cardTheme: const CardThemeData(
        color: _lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFFE1E7F0)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: _lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: _lightSurface,
        borderColor: const Color(0xFFD7DEE8),
        focusedColor: _primary,
        disabledColor: const Color(0xFFE2E8F0),
        errorColor: const Color(0xFFDC2626),
        iconColor: const Color(0xFF64748B),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _buttonStyle()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle()),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle()),
      textButtonTheme: TextButtonThemeData(style: _buttonStyle()),
      iconButtonTheme: _iconButtonTheme(),
      dividerTheme: const DividerThemeData(color: Color(0xFFE1E7F0)),
      textTheme: theme.textTheme.apply(
        bodyColor: const Color(0xFF111827),
        displayColor: const Color(0xFF111827),
      ),
    );
  }

  static ThemeData _finishDark(ThemeData theme) {
    return theme.copyWith(
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
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF2B303B), width: 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: _darkSurface,
        borderColor: const Color(0xFF343A46),
        focusedColor: const Color(0xFF93B4FF),
        disabledColor: const Color(0xFF252A33),
        errorColor: const Color(0xFFF87171),
        iconColor: const Color(0xFF94A3B8),
      ),
      filledButtonTheme: FilledButtonThemeData(style: _buttonStyle()),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle()),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle()),
      textButtonTheme: TextButtonThemeData(style: _buttonStyle()),
      iconButtonTheme: _iconButtonTheme(),
      dividerTheme: const DividerThemeData(color: Color(0xFF2B303B)),
      textTheme: theme.textTheme.apply(
        bodyColor: const Color(0xFFF8FAFC),
        displayColor: const Color(0xFFF8FAFC),
      ),
    );
  }
}
