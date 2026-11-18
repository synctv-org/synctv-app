import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/core/presentation/widgets/app_controls_shared.dart';
import 'package:synctv_app/core/presentation/widgets/app_surfaces.dart';
import 'package:synctv_app/l10n/l10n.dart';

enum AppActionButtonStyle {
  filled,
  tonal,
  outlined,
  text,
  destructive,
  destructiveSubtle,
}

enum AppActionButtonSize { sm, md }

/// Icon button visual treatments.
///
/// [destructiveSubtle] tints row-embedded destructive actions without the
/// filled weight of [destructive], which is reserved for standalone
/// destructive calls to action.
enum AppIconButtonStyle {
  ghost,
  tonal,
  outlined,
  filled,
  destructive,
  destructiveSubtle,
}

enum AppIconButtonSize { sm, md }

enum AppChipStyle { filled, tonal, outlined }

class _LoadingButtonSemantics extends StatelessWidget {
  const _LoadingButtonSemantics({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    enabled: false,
    label: label,
    value:
        Localizations.of<AppLocalizations>(
          context,
          AppLocalizations,
        )?.loading ??
        'Loading',
    excludeSemantics: true,
    child: child,
  );
}

class AppActionButton extends StatelessWidget {
  final bool wrapLabel;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? prefix;
  final String label;
  final bool loading;
  final AppActionButtonStyle style;
  final AppActionButtonSize size;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? foregroundColor;

  const AppActionButton({
    super.key,
    this.wrapLabel = false,
    required this.onPressed,
    required this.label,
    this.icon,
    this.prefix,
    this.loading = false,
    this.style = AppActionButtonStyle.filled,
    this.size = AppActionButtonSize.md,
    this.focusNode,
    this.autofocus = false,
    this.foregroundColor,
  }) : assert(icon == null || prefix == null);

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = loading ? null : onPressed;
    final buttonIcon = loading
        ? SizedBox(
            width: 18,
            height: 18,
            child: Builder(
              builder: (context) => CircularProgressIndicator(
                strokeWidth: 2,
                color: DefaultTextStyle.of(context).style.color,
              ),
            ),
          )
        : prefix ?? (icon == null ? null : Icon(icon, size: 18));
    final child = Text(
      label,
      overflow: wrapLabel ? TextOverflow.visible : TextOverflow.ellipsis,
      textAlign: wrapLabel ? TextAlign.center : null,
    );
    final buttonChild = buttonIcon == null
        ? child
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buttonIcon,
              const SizedBox(width: 8),
              Flexible(child: child),
            ],
          );
    final minimumSize = size == AppActionButtonSize.sm
        ? const Size(28, 36)
        : const Size(44, 44);
    final destructiveStyle = style == AppActionButtonStyle.destructive;
    final destructiveSubtleStyle =
        style == AppActionButtonStyle.destructiveSubtle;
    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(minimumSize),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: size == AppActionButtonSize.sm ? 10 : 14,
        ),
      ),
      foregroundColor: destructiveStyle
          ? WidgetStatePropertyAll(Theme.of(context).colorScheme.onError)
          : destructiveSubtleStyle
          ? WidgetStatePropertyAll(Theme.of(context).colorScheme.error)
          : foregroundColor == null
          ? null
          : WidgetStatePropertyAll(foregroundColor),
      backgroundColor: destructiveStyle
          ? WidgetStatePropertyAll(Theme.of(context).colorScheme.error)
          : destructiveSubtleStyle
          ? WidgetStatePropertyAll(
              Theme.of(context).colorScheme.error.withValues(alpha: 0.12),
            )
          : null,
    );
    Widget button;
    switch (style) {
      case AppActionButtonStyle.filled:
      case AppActionButtonStyle.destructive:
      case AppActionButtonStyle.destructiveSubtle:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppActionButtonStyle.tonal:
        button = FilledButton.tonal(
          onPressed: effectiveOnPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppActionButtonStyle.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          style: buttonStyle,
          child: buttonChild,
        );
      case AppActionButtonStyle.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          focusNode: focusNode,
          autofocus: autofocus,
          style: buttonStyle,
          child: buttonChild,
        );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      child: loading
          ? _LoadingButtonSemantics(label: label, child: button)
          : button,
    );
  }
}

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final IconData? selectedIcon;
  final String tooltip;
  final bool loading;
  final bool selected;
  final AppIconButtonStyle style;
  final FocusNode? focusNode;
  final bool autofocus;
  final double iconSize;
  final AppIconButtonSize size;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool showTooltip;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.selectedIcon,
    required this.tooltip,
    this.loading = false,
    this.selected = false,
    this.style = AppIconButtonStyle.ghost,
    this.focusNode,
    this.autofocus = false,
    this.iconSize = 20,
    this.size = AppIconButtonSize.md,
    this.padding,
    this.constraints,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = loading ? null : onPressed;
    final buttonSize = size == AppIconButtonSize.sm ? 36.0 : 44.0;
    final child = Semantics(
      label: tooltip,
      child: ExcludeSemantics(
        child: loading
            ? SizedBox(
                width: 16,
                height: 16,
                child: Builder(
                  builder: (context) => CircularProgressIndicator(
                    strokeWidth: 2,
                    color: IconTheme.of(context).color,
                  ),
                ),
              )
            : Icon(
                selected && selectedIcon != null ? selectedIcon : icon,
                size: iconSize,
              ),
      ),
    );
    final destructive = style == AppIconButtonStyle.destructive;
    final destructiveSubtle = style == AppIconButtonStyle.destructiveSubtle;
    final baseStyle = IconButton.styleFrom(
      minimumSize: Size(buttonSize, buttonSize),
      maximumSize: Size(buttonSize, buttonSize),
      padding: EdgeInsets.zero,
      backgroundColor: destructive
          ? Theme.of(context).colorScheme.error
          : destructiveSubtle
          ? Theme.of(context).colorScheme.error.withValues(alpha: 0.12)
          : null,
      foregroundColor: destructive
          ? Theme.of(context).colorScheme.onError
          : destructiveSubtle
          ? Theme.of(context).colorScheme.error
          : null,
      side: style == AppIconButtonStyle.outlined
          ? BorderSide(color: Theme.of(context).colorScheme.outline)
          : null,
    );
    Widget button;
    switch (style) {
      case AppIconButtonStyle.ghost:
      case AppIconButtonStyle.destructiveSubtle:
        button = IconButton(
          onPressed: effectiveOnPressed,
          icon: child,
          style: baseStyle,
          isSelected: selected,
          focusNode: focusNode,
          autofocus: autofocus,
          tooltip: null,
        );
      case AppIconButtonStyle.tonal:
        button = IconButton.filledTonal(
          onPressed: effectiveOnPressed,
          icon: child,
          style: baseStyle,
          isSelected: selected,
          focusNode: focusNode,
          autofocus: autofocus,
          tooltip: null,
        );
      case AppIconButtonStyle.outlined:
        button = IconButton.outlined(
          onPressed: effectiveOnPressed,
          icon: child,
          style: baseStyle,
          isSelected: selected,
          focusNode: focusNode,
          autofocus: autofocus,
          tooltip: null,
        );
      case AppIconButtonStyle.filled:
      case AppIconButtonStyle.destructive:
        button = IconButton.filled(
          onPressed: effectiveOnPressed,
          icon: child,
          style: baseStyle,
          isSelected: selected,
          focusNode: focusNode,
          autofocus: autofocus,
          tooltip: null,
        );
    }
    if (padding != null) {
      button = Padding(padding: padding!, child: button);
    }
    if (constraints != null) {
      button = ConstrainedBox(constraints: constraints!, child: button);
    }
    button = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      child: button,
    );
    if (loading) {
      button = _LoadingButtonSemantics(label: tooltip, child: button);
    }

    return Focus(
      canRequestFocus: false,
      onFocusChange: (focused) {
        if (!focused || !context.mounted) return;
        // Web accessibility focus can bypass traversal's scroll request.
        final target = context.findRenderObject();
        if (target != null && target.attached) target.showOnScreen();
      },
      child: showTooltip
          ? AppTooltip(
              message: tooltip,
              excludeFromSemantics: true,
              child: button,
            )
          : button,
    );
  }
}

class AppChip extends StatelessWidget {
  final Widget label;
  final Widget? avatar;
  final Widget? deleteIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final ValueChanged<bool>? onSelected;
  final bool selected;
  final bool enabled;
  final bool showCheckmark;
  final AppChipStyle style;

  const AppChip({
    super.key,
    required this.label,
    this.avatar,
    this.deleteIcon,
    this.onPressed,
    this.onDeleted,
    this.onSelected,
    this.selected = false,
    this.enabled = true,
    this.showCheckmark = false,
    this.style = AppChipStyle.tonal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = switch (style) {
      AppChipStyle.filled => scheme.primaryContainer,
      AppChipStyle.tonal => scheme.surfaceContainerHighest,
      AppChipStyle.outlined => scheme.surface,
    };
    final selectedColor = scheme.primaryContainer;
    final side = BorderSide(
      color: selected
          ? scheme.primary.withValues(alpha: 0.55)
          : scheme.outlineVariant.withValues(alpha: 0.82),
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
    );

    if (onSelected != null) {
      return FilterChip(
        avatar: avatar,
        label: label,
        selected: selected,
        onSelected: enabled ? onSelected : null,
        showCheckmark: showCheckmark,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: labelStyle,
        backgroundColor: background,
        selectedColor: selectedColor,
        side: side,
        shape: shape,
      );
    }
    if (onDeleted != null) {
      return InputChip(
        avatar: avatar,
        label: label,
        deleteIcon: deleteIcon,
        onDeleted: enabled ? onDeleted : null,
        onPressed: enabled ? onPressed : null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: labelStyle,
        backgroundColor: background,
        selectedColor: selectedColor,
        side: side,
        shape: shape,
      );
    }
    if (onPressed != null) {
      return ActionChip(
        avatar: avatar,
        label: label,
        onPressed: enabled ? onPressed : null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        labelStyle: labelStyle,
        backgroundColor: background,
        side: side,
        shape: shape,
      );
    }
    return Chip(
      avatar: avatar,
      label: label,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      labelStyle: labelStyle,
      backgroundColor: background,
      side: side,
      shape: shape,
    );
  }
}

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String tooltip;
  final bool small;
  final Object? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.small = false,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final child = Icon(icon);
    if (small) {
      return FloatingActionButton.small(
        heroTag: heroTag,
        tooltip: tooltip,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        child: child,
      );
    }
    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: tooltip,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: child,
    );
  }
}

class AppOverlayActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String label;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color foregroundColor;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final Size minimumSize;
  final MaterialTapTargetSize tapTargetSize;

  const AppOverlayActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 20,
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black26,
    this.textStyle,
    this.minimumSize = Size.zero,
    this.tapTargetSize = MaterialTapTargetSize.shrinkWrap,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      padding: padding,
      minimumSize: minimumSize,
      tapTargetSize: tapTargetSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: textStyle,
    );
    if (icon == null) {
      return TextButton(
        onPressed: onPressed,
        style: style,
        child: Text(label, style: textStyle),
      );
    }
    return TextButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, color: foregroundColor, size: 18),
      label: Text(label, style: textStyle),
    );
  }
}

class AppGlassIconButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool isDark;
  final double size;
  final Color? color;
  final double pressedScale;
  final Duration scaleDuration;
  final bool rotateOnPressed;
  final Duration rotationDuration;
  final Curve rotationCurve;
  final HapticFeedbackType hapticFeedback;

  const AppGlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.isDark,
    this.size = 48,
    this.color,
    this.pressedScale = 0.92,
    this.scaleDuration = const Duration(milliseconds: 140),
    this.rotateOnPressed = false,
    this.rotationDuration = const Duration(milliseconds: 400),
    this.rotationCurve = Curves.elasticOut,
    this.hapticFeedback = HapticFeedbackType.light,
  });

  @override
  State<AppGlassIconButton> createState() => _AppGlassIconButtonState();
}

class _AppGlassIconButtonState extends State<AppGlassIconButton>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  AnimationController? _rotationController;
  Animation<double>? _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: widget.scaleDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: widget.pressedScale).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _configureRotation();
  }

  @override
  void didUpdateWidget(covariant AppGlassIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scaleDuration != widget.scaleDuration) {
      _scaleController.duration = widget.scaleDuration;
    }
    if (oldWidget.pressedScale != widget.pressedScale) {
      _scaleAnimation = Tween<double>(begin: 1, end: widget.pressedScale)
          .animate(
            CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
          );
    }
    if (oldWidget.rotateOnPressed != widget.rotateOnPressed ||
        oldWidget.rotationDuration != widget.rotationDuration ||
        oldWidget.rotationCurve != widget.rotationCurve) {
      _rotationController?.dispose();
      _rotationController = null;
      _rotationAnimation = null;
      _configureRotation();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController?.dispose();
    super.dispose();
  }

  void _configureRotation() {
    if (!widget.rotateOnPressed) return;
    _rotationController = AnimationController(
      duration: widget.rotationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotationController!,
        curve: widget.rotationCurve,
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null || MediaQuery.disableAnimationsOf(context)) {
      return;
    }
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  void _handleTap() {
    if (widget.onPressed == null) return;
    if (widget.rotateOnPressed && !MediaQuery.disableAnimationsOf(context)) {
      _rotationController
        ?..reset()
        ..forward();
    }
    switch (widget.hapticFeedback) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
      case HapticFeedbackType.none:
        break;
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.rotateOnPressed && _rotationAnimation != null
        ? Listenable.merge([_scaleAnimation, _rotationAnimation!])
        : _scaleAnimation;
    final background =
        widget.color ??
        (widget.isDark
            ? Colors.grey.shade800.withValues(alpha: 0.5)
            : Colors.grey.shade100.withValues(alpha: 0.8));

    return AppTooltip(
      message: widget.tooltip,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        enabled: widget.onPressed != null,
        label: widget.tooltip,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTapDown: widget.onPressed == null ? null : _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onPressed == null ? null : _handleTap,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              Widget icon = widget.icon;
              if (widget.rotateOnPressed && _rotationAnimation != null) {
                icon = Transform.rotate(
                  angle: _rotationAnimation!.value * 2 * 3.14159,
                  child: icon,
                );
              }
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AppBlurSurface(
                  shape: BoxShape.circle,
                  width: widget.size,
                  height: widget.size,
                  color: background,
                  child: Center(child: icon),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum HapticFeedbackType { none, light, medium, heavy, selection }
