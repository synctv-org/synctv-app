import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/pages/home_screen.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

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

    return AppScaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 纯图标类展示
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppImageThumbnail.asset(
                  assetName: 'assets/icon/robot_3.png',
                  width: 96,
                  height: 96,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  errorChild: AppIconBadge(
                    icon: Icons.live_tv_rounded,
                    color: theme.primaryColor,
                    size: 96,
                    iconSize: 48,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
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
                  context.l10n.appTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.appTagline,
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

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
