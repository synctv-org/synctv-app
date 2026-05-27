import 'package:flutter/material.dart';
import 'dart:io';
import 'package:synctv_app/pages/desktop/desktop_home_screen.dart';
import 'package:synctv_app/pages/large_screen/large_screen_home.dart';
import 'package:synctv_app/main.dart'; // For WatchTogetherHomeScreen

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // 启动页展示 0.8 秒，符合鸿蒙设计规范中的 0.3-0.8 秒最佳实践
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ResponsiveHome(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 沉浸式背景色，深色模式直接使用黑色
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 纯图标类展示
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/icon/robot_3.png',
                    width: 96,
                    height: 96,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.live_tv_rounded,
                          size: 48,
                          color: theme.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 底部品牌标识（上下布局类）
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '看搭子',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 8.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '让距离不再是距离',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white54 : Colors.black54,
                    letterSpacing: 4.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  bool _isDesktop() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDesktop()) {
      return const DesktopHomeScreen();
    }
    if (MediaQuery.of(context).size.width > 600) {
      return const LargeScreenHome();
    }
    return const WatchTogetherHomeScreen();
  }
}
