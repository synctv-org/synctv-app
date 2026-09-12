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
    entry.dispose();
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
      backgroundColor: Colors.green.shade800,
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
      backgroundColor: Colors.red.shade700,
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
      textColor: Colors.black,
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
    var timeoutPaused = false;
    var accessibilityRetained = false;
    var hovered = false;
    var focused = false;
    void scheduleTimeout() {
      _activeToastTimer?.cancel();
      _activeToastTimer = Timer(duration, () {
        if (identical(_activeToast, overlayEntry)) dismissAll();
      });
    }

    void updateTimeout() {
      if (!identical(_activeToast, overlayEntry)) return;
      final paused = accessibilityRetained || hovered || focused;
      if (paused == timeoutPaused) return;
      timeoutPaused = paused;
      if (paused) {
        _activeToastTimer?.cancel();
        _activeToastTimer = null;
      } else {
        scheduleTimeout();
      }
    }

    overlayEntry = OverlayEntry(
      builder: (context) {
        final media = MediaQuery.of(context);
        final bottom = (70 + media.padding.bottom).clamp(
          media.viewInsets.bottom + 16,
          double.infinity,
        );
        return Positioned(
          bottom: bottom,
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
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    maxHeight:
                        (media.size.height - bottom - media.padding.top - 16)
                            .clamp(1.0, double.infinity),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const messageStyle = TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      );
                      final style = DefaultTextStyle.of(context).style
                          .merge(messageStyle.copyWith(color: textColor));
                      final painter =
                          TextPainter(
                            text: TextSpan(text: message, style: style),
                            textDirection: Directionality.of(context),
                            textScaler: MediaQuery.textScalerOf(context),
                            maxLines: 3,
                            ellipsis: '\u2026',
                          )..layout(
                            maxWidth:
                                (constraints.maxWidth -
                                        28 -
                                        (loading || icon != null ? 30 : 0))
                                    .clamp(1.0, double.infinity),
                          );
                      final truncated = painter.didExceedMaxLines;
                      painter.dispose();
                      final interactive = action != null || truncated;
                      if (!interactive) {
                        hovered = false;
                        focused = false;
                      }
                      final retain = media.accessibleNavigation && interactive;
                      accessibilityRetained = retain;
                      updateTimeout();
                      final toast = IgnorePointer(
                        ignoring: action == null && !truncated,
                        child: AppSingleChildScrollView(
                          child: AppPanelSurface(
                            color: backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (retain)
                                    IconButtonTheme(
                                      data: IconButtonThemeData(
                                        style: IconButton.styleFrom(
                                          foregroundColor: textColor,
                                        ),
                                      ),
                                      child: AppIconButton(
                                        icon: Icons.close_rounded,
                                        tooltip: MaterialLocalizations.of(
                                          context,
                                        ).closeButtonTooltip,
                                        onPressed: () {
                                          if (identical(
                                            _activeToast,
                                            overlayEntry,
                                          )) {
                                            dismissAll();
                                          }
                                        },
                                      ),
                                    ),
                                  Row(
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
                                        child: Semantics(
                                          liveRegion: true,
                                          child: Text(
                                            message,
                                            style: style,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (truncated)
                                    IconButtonTheme(
                                      data: IconButtonThemeData(
                                        style: IconButton.styleFrom(
                                          foregroundColor: textColor,
                                        ),
                                      ),
                                      child: AppIconButton(
                                        icon: Icons.open_in_full_rounded,
                                        tooltip:
                                            Localizations.of<AppLocalizations>(
                                              context,
                                              AppLocalizations,
                                            )?.details ??
                                            MaterialLocalizations.of(context)
                                                .moreButtonTooltip,
                                        onPressed: () {
                                          if (!identical(
                                            _activeToast,
                                            overlayEntry,
                                          )) {
                                            return;
                                          }
                                          _showDetails(
                                            context,
                                            message,
                                            action,
                                          );
                                        },
                                      ),
                                    ),
                                  if (action != null) ...[
                                    const SizedBox(height: 8),
                                    AppActionButton(
                                      wrapLabel: true,
                                      style: AppActionButtonStyle.text,
                                      size: AppActionButtonSize.sm,
                                      foregroundColor: textColor,
                                      onPressed: () {
                                        if (!identical(
                                          _activeToast,
                                          overlayEntry,
                                        )) {
                                          return;
                                        }
                                        dismissAll();
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
                      );
                      if (!interactive) return toast;
                      return MouseRegion(
                        onEnter: (_) {
                          hovered = true;
                          updateTimeout();
                        },
                        onExit: (_) {
                          hovered = false;
                          updateTimeout();
                        },
                        child: Focus(
                          canRequestFocus: false,
                          onFocusChange: (value) {
                            focused = value;
                            updateTimeout();
                          },
                          child: toast,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
    _activeToast = overlayEntry;
    scheduleTimeout();
  }

  static void _showDetails(
    BuildContext context,
    String message,
    _ToastAction? action,
  ) {
    final navigator = Navigator.of(context, rootNavigator: true);
    dismissAll();
    var handled = false;
    showAppDialog<void>(
      context: navigator.context,
      builder: (context) => AppDialog(
        title: Text(
          Localizations.of<AppLocalizations>(
                context,
                AppLocalizations,
              )?.message ??
              MaterialLocalizations.of(context).alertDialogLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        body: AppSelectableText(message),
        actions: [
          AppActionButton(
            label: MaterialLocalizations.of(context).closeButtonTooltip,
            wrapLabel: true,
            onPressed: () {
              if (context.mounted &&
                  ModalRoute.of(context)?.isCurrent == true) {
                Navigator.of(context).pop();
              }
            },
          ),
          if (action != null)
            AppActionButton(
              label: action.label,
              wrapLabel: true,
              onPressed: () {
                if (handled ||
                    !context.mounted ||
                    ModalRoute.of(context)?.isCurrent != true) {
                  return;
                }
                handled = true;
                Navigator.of(context).pop();
                action.onPressed();
              },
            ),
        ],
      ),
    );
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
          ? Colors.green.shade800
          : Colors.orange.shade600,
      textColor: isEnabled ? Colors.white : Colors.black,
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
