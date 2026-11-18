import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tooltip implementation backed by a plain [OverlayEntry].
///
/// Flutter's OverlayPortal tooltip can corrupt the desktop semantics tree when
/// an anchored control disappears during a route or media transition.
class AppTooltip extends StatefulWidget {
  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.excludeFromSemantics = false,
  });

  final String message;
  final Widget child;
  final bool excludeFromSemantics;

  @override
  State<AppTooltip> createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {
  static const _showDelay = Duration(milliseconds: 500);
  static const _margin = 8.0;
  static const _gap = 8.0;
  static const _horizontalPadding = 10.0;
  static const _verticalPadding = 6.0;
  static const _maxTextWidth = 280.0;
  static final _visibleTooltips = <_AppTooltipState>{};
  static bool _escapeDown = false;

  static KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (_escapeDown) {
      if (event is KeyUpEvent) {
        _escapeDown = false;
        _removeKeyHandlerIfIdle();
      }
      return KeyEventResult.handled;
    }
    if (event is! KeyDownEvent || _visibleTooltips.isEmpty) {
      return KeyEventResult.ignored;
    }
    _escapeDown = true;
    for (final tooltip in _visibleTooltips.toList()) {
      tooltip._dismissed = true;
      tooltip._hide();
    }
    return KeyEventResult.handled;
  }

  static void _removeKeyHandlerIfIdle() {
    if (_visibleTooltips.isEmpty && !_escapeDown) {
      FocusManager.instance.removeEarlyKeyEventHandler(_handleKeyEvent);
    }
  }

  OverlayEntry? _entry;
  Timer? _showTimer;
  bool _hovered = false;
  bool _focused = false;
  bool _longPressed = false;
  bool _dismissed = false;

  String get _message => widget.message;

  void _updateVisibility() {
    if (_dismissed && (_hovered || _focused || _longPressed)) return;
    _dismissed = false;
    if (_longPressed) {
      _show();
    } else if (_hovered || _focused) {
      if (_entry == null && _showTimer?.isActive != true) _scheduleShow();
    } else {
      _hide();
    }
  }

  void _scheduleShow() {
    _showTimer?.cancel();
    if (_dismissed) return;
    _showTimer = Timer(_showDelay, _show);
  }

  void _show() {
    _showTimer?.cancel();
    if (!mounted || _dismissed || _entry != null || _message.isEmpty) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final target = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (target == null || overlayBox == null || !target.hasSize) return;

    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onInverseSurface,
    );
    final direction = Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    _entry = OverlayEntry(
      builder: (overlayContext) => Positioned.fill(
        child: LayoutBuilder(
          builder: (overlayContext, constraints) {
            if (!mounted ||
                !target.attached ||
                !overlayBox.attached ||
                !target.hasSize) {
              return const SizedBox.shrink();
            }
            final media = MediaQuery.of(overlayContext);
            final safeLeft =
                math.max(media.padding.left, media.viewInsets.left) + _margin;
            final safeTop =
                math.max(media.padding.top, media.viewInsets.top) + _margin;
            final safeRight =
                constraints.maxWidth -
                math.max(media.padding.right, media.viewInsets.right) -
                _margin;
            final safeBottom =
                constraints.maxHeight -
                math.max(media.padding.bottom, media.viewInsets.bottom) -
                _margin;
            final maxTextWidth = math.min(
              _maxTextWidth,
              math.max(1.0, safeRight - safeLeft - 2 * _horizontalPadding),
            );
            final maxTextHeight = math.max(
              1.0,
              safeBottom - safeTop - 2 * _verticalPadding,
            );
            final textPainter = TextPainter(
              text: TextSpan(text: _message, style: textStyle),
              textDirection: direction,
              textScaler: textScaler,
              maxLines: 8,
              ellipsis: '\u2026',
            );
            late final double width;
            late final double height;
            var maxLines = 8;
            try {
              textPainter.layout(maxWidth: maxTextWidth);
              var lineHeight = 0.0;
              var fittingLines = 0;
              for (final line in textPainter.computeLineMetrics()) {
                lineHeight += line.height;
                if (lineHeight > maxTextHeight) break;
                fittingLines++;
              }
              maxLines = math.max(1, fittingLines);
              if (maxLines < 8) {
                textPainter.maxLines = maxLines;
                textPainter.layout(maxWidth: maxTextWidth);
              }
              width = textPainter.width + _horizontalPadding * 2;
              height = textPainter.height + _verticalPadding * 2;
            } finally {
              textPainter.dispose();
            }
            final targetOrigin = target.localToGlobal(
              Offset.zero,
              ancestor: overlayBox,
            );
            final targetRect = targetOrigin & target.size;
            final left = (targetRect.center.dx - width / 2)
                .clamp(safeLeft, math.max(safeLeft, safeRight - width))
                .toDouble();
            final below = targetRect.bottom + _gap;
            final preferredTop = below + height <= safeBottom
                ? below
                : targetRect.top - height - _gap;
            final top = preferredTop
                .clamp(safeTop, math.max(safeTop, safeBottom - height))
                .toDouble();
            final background = theme.colorScheme.inverseSurface;
            final borderRadius = BorderRadius.circular(6);

            return Stack(
              children: [
                Positioned(
                  left: left,
                  top: top,
                  width: width,
                  child: IgnorePointer(
                    child: ExcludeSemantics(
                      child: Material(
                        color: Colors.transparent,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: borderRadius,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: _horizontalPadding,
                              vertical: _verticalPadding,
                            ),
                            child: Text(
                              _message,
                              style: textStyle,
                              textDirection: direction,
                              textScaler: textScaler,
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    overlay.insert(_entry!);
    // Hovered tooltips must handle Escape before a dialog's dismiss shortcut.
    if (_visibleTooltips.isEmpty && !_escapeDown) {
      FocusManager.instance.addEarlyKeyEventHandler(_handleKeyEvent);
    }
    _visibleTooltips.add(this);
  }

  void _hide() {
    _showTimer?.cancel();
    _showTimer = null;
    final entry = _entry;
    _entry = null;
    entry?.remove();
    entry?.dispose();
    _visibleTooltips.remove(this);
    _removeKeyHandlerIfIdle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_entry == null && _showTimer?.isActive != true) return;
    _hide();
    if (_hovered || _focused || _longPressed) _scheduleShow();
  }

  @override
  void didUpdateWidget(covariant AppTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      _hide();
      if (_hovered || _focused || _longPressed) _scheduleShow();
    }
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      tooltip: widget.excludeFromSemantics ? null : _message,
      child: Focus(
        canRequestFocus: false,
        onFocusChange: (focused) {
          _focused = focused;
          if (focused) _dismissed = false;
          _updateVisibility();
        },
        child: MouseRegion(
          onEnter: (_) {
            _hovered = true;
            _dismissed = false;
            _updateVisibility();
          },
          onExit: (_) {
            _hovered = false;
            _updateVisibility();
          },
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onLongPressStart: (_) {
              _longPressed = true;
              _dismissed = false;
              _updateVisibility();
            },
            onLongPressEnd: (_) {
              _longPressed = false;
              _updateVisibility();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
