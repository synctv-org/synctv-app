import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class _ToastAction {
  final String label;
  final VoidCallback onPressed;

  const _ToastAction({required this.label, required this.onPressed});
}

class AppNotifications {
  AppNotifications._();

  static OverlayEntry? _activeToast;
  static Timer? _activeToastTimer;

  static void dismissAll() {
    _activeToastTimer?.cancel();
    _activeToastTimer = null;
    final entry = _activeToast;
    _activeToast = null;
    _removeToast(entry);
  }

  static void _removeToast(OverlayEntry? entry) {
    if (entry == null) return;
    try {
      entry.remove();
    } on StateError {
      // The owning overlay was disposed before the queued removal ran.
    }
  }

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
      duration: duration,
      action: _actionFromSnackBarAction(action),
    );
  }

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
      duration: duration,
      action: _actionFromSnackBarAction(action),
    );
  }

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
      duration: duration,
      action: _actionFromSnackBarAction(action),
    );
  }

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
      duration: duration,
      action: _actionFromSnackBarAction(action),
    );
  }

  static void _showToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    Color textColor = Colors.white,
    _ToastAction? action,
    bool loading = false,
    Color? indicatorColor,
  }) {
    dismissAll();
    final overlayState = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 70 + MediaQuery.of(context).padding.bottom,
        left: 24,
        right: 24,
        child: AppOverlaySurface(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final animationValue = value.clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, 16 * (1 - animationValue)),
                  child: Opacity(opacity: animationValue, child: child),
                );
              },
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: AppPanelSurface(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (loading) ...[
                          AppLoadingIndicator(
                            size: AppLoadingSize.sm,
                            centered: false,
                            color: indicatorColor ?? textColor,
                          ),
                          const SizedBox(width: 10),
                        ] else if (icon != null) ...[
                          Icon(icon, color: textColor, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Text(
                            message,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (action != null) ...[
                          const SizedBox(width: 12),
                          AppActionButton(
                            style: AppActionButtonStyle.text,
                            size: AppActionButtonSize.sm,
                            foregroundColor: textColor,
                            onPressed: () {
                              _removeToast(overlayEntry);
                              if (identical(_activeToast, overlayEntry)) {
                                _activeToast = null;
                                _activeToastTimer?.cancel();
                                _activeToastTimer = null;
                              }
                              action.onPressed();
                            },
                            label: action.label,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    _activeToast = overlayEntry;
    _activeToastTimer = Timer(duration, () {
      _removeToast(overlayEntry);
      if (identical(_activeToast, overlayEntry)) {
        _activeToast = null;
        _activeToastTimer = null;
      }
    });
  }

  static _ToastAction? _actionFromSnackBarAction(SnackBarAction? action) {
    if (action == null) return null;
    return _ToastAction(label: action.label, onPressed: action.onPressed);
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
    _showToast(
      context,
      message,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade800,
      icon: Icons.delete_outline_rounded,
      duration: duration,
      action: _ToastAction(label: context.l10n.undo, onPressed: onUndo),
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
    _showToast(
      context,
      message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration,
      action: _actionFromSnackBarAction(action),
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
      backgroundColor: isEnabled
          ? Colors.green.shade600
          : Colors.orange.shade600,
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
    _showToast(
      context,
      message,
      backgroundColor: Colors.blue.shade700,
      duration: duration ?? const Duration(seconds: 5),
      loading: true,
      indicatorColor: indicatorColor,
    );
  }
}
