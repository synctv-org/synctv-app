import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'package:synctv_app/pages/splash_page.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  await SyncTvService.init();
  await SyncTvService.syncServerTime();
  await OAuth2DeepLinkService.initialize();

  try {
    VideoPlayerMediaKit.ensureInitialized(
      android: true,
      iOS: false,
      windows: true,
      macOS: true,
      linux: true,
    );
  } catch (e) {
    debugPrint('Failed to initialize media playback: $e');
  }
  runApp(const MyApp());
}

const _enableAccessibilityTools = bool.fromEnvironment(
  'SYNCTV_ENABLE_ACCESSIBILITY_TOOLS',
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyncTV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [FLocalizations.delegate],
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final newMediaQueryData = mediaQueryData.copyWith(
          textScaler: mediaQueryData.textScaler.clamp(
            minScaleFactor: 0.85,
            maxScaleFactor: 1.3,
          ),
        );
        final foruiTheme = Theme.of(context).brightness == Brightness.dark
            ? FThemes.blue.dark.desktop
            : FThemes.blue.light.desktop;
        Widget appChild = MediaQuery(data: newMediaQueryData, child: child!);
        appChild = ResponsiveBreakpoints.builder(
          breakpoints: AppBreakpoints.values,
          child: appChild,
        );
        if (kDebugMode && _enableAccessibilityTools) {
          appChild = AccessibilityTools(
            checkFontOverflows: true,
            buttonsAlignment: ButtonsAlignment.bottomLeft,
            child: appChild,
          );
        }

        return FTheme(data: foruiTheme, child: appChild);
      },
      home: const ResponsiveHome(),
    );
  }
}
