import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:synctv_app/theme/app_responsive.dart';

const _enableAccessibilityTools = bool.fromEnvironment(
  'SYNCTV_ENABLE_ACCESSIBILITY_TOOLS',
);

class AppViewport extends StatelessWidget {
  const AppViewport({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget app = ResponsiveBreakpoints.builder(
      breakpoints: AppBreakpoints.values,
      child: child,
    );
    if (kDebugMode && _enableAccessibilityTools) {
      app = AccessibilityTools(
        checkFontOverflows: true,
        buttonsAlignment: ButtonsAlignment.bottomLeft,
        child: app,
      );
    }
    return app;
  }
}
