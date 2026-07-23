import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/pages/home_screen.dart';
import 'package:synctv_app/services/app_locale_controller.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/picture_in_picture_service.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_video_player_media_kit/synctv_video_player_media_kit.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  await appLocaleController.load();
  await SyncTvService.init();
  if (SyncTvService.activeServer != null) {
    await SyncTvService.syncServerTime();
  }
  await OAuth2DeepLinkService.initialize();

  if (!kIsWeb &&
      const {
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform)) {
    await windowManager.ensureInitialized();
    await windowManager.setTitleBarStyle(
      TitleBarStyle.normal,
      windowButtonVisibility: true,
    );
    await windowManager.setMinimumSize(desktopWindowMinimumSize);
    final windowSize = await windowManager.getSize();
    if (windowSize.width < desktopWindowMinimumSize.width ||
        windowSize.height < desktopWindowMinimumSize.height) {
      await windowManager.setSize(desktopWindowDefaultSize);
      await windowManager.center();
    }
  }

  try {
    SyncTvVideoPlayerMediaKit.ensureInitialized(
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
    return ListenableBuilder(
      listenable: appLocaleController,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        locale: appLocaleController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FLocalizations.delegate,
        ],
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final newMediaQueryData = mediaQueryData.copyWith(
            textScaler: mediaQueryData.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.3,
            ),
          );
          final foruiTheme = Theme.of(context).brightness == Brightness.dark
              ? FTheme.neutral.dark.desktop
              : FTheme.neutral.light.desktop;
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
        home: const HomeScreen(),
      ),
    );
  }
}
