import 'package:flutter/material.dart';

/// 统一的系统消息工具类
class MessageUtils {
  /// 私有构造函数，防止实例化
  MessageUtils._();

  /// 默认的底部边距（考虑导航栏高度）
  static EdgeInsets _getDefaultMargin(BuildContext context) {
    // 改为胶囊形状，左右边距加大，不要太宽
    final width = MediaQuery.of(context).size.width;
    // 如果是宽屏，限制最大宽度
    double horizontalMargin = width > 600 ? (width - 400) / 2 : 40;

    return EdgeInsets.only(
      bottom: 70 + MediaQuery.of(context).padding.bottom,
      left: horizontalMargin,
      right: horizontalMargin,
    );
  }

  /// 默认的形状
  static RoundedRectangleBorder get _defaultShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24), // 胶囊形状
    );
  }

  /// 显示成功消息
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    // 使用全局 Overlay 显示 Toast，避免被 Dialog 或 BottomSheet 遮挡
    _showToast(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  /// 显示错误消息
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showToast(
      context,
      message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_outline,
    );
  }

  /// 显示警告消息
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showToast(
      context,
      message,
      backgroundColor: Colors.orange.shade600,
      icon: Icons.warning_amber_rounded,
    );
  }

  /// 显示信息消息
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _showToast(
      context,
      message,
      backgroundColor: const Color(0xFF333333),
      icon: Icons.info_outline,
    );
  }

  // 私有方法：使用 Overlay 实现真正的全屏顶层 Toast
  static void _showToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 70 + MediaQuery.of(context).padding.bottom,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                final animationValue = value.clamp(0.0, 1.0);
                return Transform.scale(
                  scale: animationValue,
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // 2秒后自动消失
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  /// 显示删除操作消息（带撤销功能）
  static void showDelete(
    BuildContext context,
    String message, {
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: _getDefaultMargin(context),
        shape: _defaultShape,
        action: SnackBarAction(
          label: '撤销',
          textColor: Colors.white,
          onPressed: onUndo,
        ),
      ),
    );
  }

  /// 显示自定义颜色的消息
  static void showCustom(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: _getDefaultMargin(context),
        shape: _defaultShape,
        action: action,
      ),
    );
  }

  /// 显示开关状态变更消息
  static void showToggle(
    BuildContext context,
    String message, {
    required bool isEnabled,
    Duration duration = const Duration(seconds: 2),
  }) {
    showCustom(
      context,
      message,
      backgroundColor:
          isEnabled ? Colors.green.shade600 : Colors.orange.shade600,
      duration: duration,
    );
  }

  /// 显示加载中消息（带圆形进度指示器）
  static void showLoading(
    BuildContext context,
    String message, {
    Duration? duration,
    Color? indicatorColor,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  indicatorColor ?? Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 5), // 默认较长时间，通常需要手动关闭
        margin: _getDefaultMargin(context),
        shape: _defaultShape,
      ),
    );
  }
}
