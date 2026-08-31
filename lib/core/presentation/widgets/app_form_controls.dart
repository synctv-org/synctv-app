import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';

enum AppActionButtonStyle { filled, tonal, outlined, text, destructive }

enum AppActionButtonSize { sm, md }

enum AppIconButtonStyle { ghost, tonal, outlined, filled, destructive }

enum AppIconButtonSize { sm, md }

enum AppChipStyle { filled, tonal, outlined }

/// Tooltip implementation backed by a plain [OverlayEntry].
///
/// Flutter's OverlayPortal tooltip can corrupt the desktop semantics tree when
/// an anchored control disappears during a route or media transition.
class AppTooltip extends StatefulWidget {
  const AppTooltip({super.key, required this.message, required this.child});

  final String message;
  final Widget child;

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

  OverlayEntry? _entry;
  Timer? _showTimer;

  String get _message => widget.message;

  void _scheduleShow() {
    _showTimer?.cancel();
    _showTimer = Timer(_showDelay, _show);
  }

  void _show() {
    _showTimer?.cancel();
    if (!mounted || _entry != null || _message.isEmpty) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final target = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (target == null || overlayBox == null || !target.hasSize) return;

    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onInverseSurface,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: _message, style: textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 8,
    )..layout(maxWidth: _maxTextWidth);
    final width = textPainter.width + _horizontalPadding * 2;
    final height = textPainter.height + _verticalPadding * 2;
    final targetOrigin = target.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final targetRect = targetOrigin & target.size;
    final left = (targetRect.center.dx - width / 2)
        .clamp(
          _margin,
          math.max(_margin, overlayBox.size.width - width - _margin),
        )
        .toDouble();
    final below = targetRect.bottom + _gap;
    final top = below + height <= overlayBox.size.height - _margin
        ? below
        : math.max(_margin, targetRect.top - height - _gap).toDouble();
    final background = theme.colorScheme.inverseSurface;
    final borderRadius = BorderRadius.circular(6);

    _entry = OverlayEntry(
      builder: (_) => Positioned(
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
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  void _hide() {
    _showTimer?.cancel();
    _showTimer = null;
    final entry = _entry;
    _entry = null;
    entry?.remove();
    entry?.dispose();
  }

  @override
  void didUpdateWidget(covariant AppTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) _hide();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      tooltip: _message,
      child: Focus(
        onFocusChange: (focused) => focused ? _scheduleShow() : _hide(),
        child: MouseRegion(
          onEnter: (_) => _scheduleShow(),
          onExit: (_) => _hide(),
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onLongPressStart: (_) => _show(),
            onLongPressEnd: (_) => _hide(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class AppRefreshIndicator extends StatelessWidget {
  final RefreshCallback onRefresh;
  final Widget child;
  final double displacement;
  final double edgeOffset;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final RefreshIndicatorTriggerMode triggerMode;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.displacement = 40,
    this.edgeOffset = 0,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? theme.colorScheme.primary,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      displacement: displacement,
      edgeOffset: edgeOffset,
      strokeWidth: strokeWidth,
      notificationPredicate: notificationPredicate,
      triggerMode: triggerMode,
      child: child,
    );
  }
}

class AppAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double radius;
  final double? size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final IconData fallbackIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BoxShape shape;
  final BorderRadiusGeometry borderRadius;

  const AppAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.radius = 18,
    this.size,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.fallbackIcon = Icons.person_outline_rounded,
    this.onPressed,
    this.tooltip,
    this.border,
    this.boxShadow,
    this.shape = BoxShape.circle,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  String get _initial {
    final value = name?.trim();
    if (value == null || value.isEmpty) return '?';
    return value.characters.first.toUpperCase();
  }

  bool get _hasName => name?.trim().isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final effectiveBackground = backgroundColor ?? scheme.primary;
    final effectiveForeground = foregroundColor ?? scheme.onPrimary;
    final effectiveSize = size ?? radius * 2;
    final effectiveTextStyle = (textStyle ?? theme.textTheme.labelLarge)
        ?.copyWith(color: effectiveForeground, fontWeight: FontWeight.w800);
    final resolvedImageUrl = imageUrl?.trim() ?? '';
    final image = resolvedImageUrl.isEmpty
        ? null
        : Image.network(
            resolvedImageUrl,
            width: effectiveSize,
            height: effectiveSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Text(_initial, style: effectiveTextStyle);
            },
          );

    final avatar = AppPanelSurface(
      width: effectiveSize,
      height: effectiveSize,
      color: effectiveBackground,
      shape: shape,
      borderRadius: borderRadius,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      border: border,
      boxShadow: boxShadow,
      child:
          image ??
          (_hasName
              ? Text(_initial, style: effectiveTextStyle)
              : Icon(
                  fallbackIcon,
                  color: effectiveForeground,
                  size: effectiveSize * 0.52,
                )),
    );

    Widget result = avatar;
    if (onPressed != null) {
      result = AppInkSurface(
        onTap: onPressed,
        color: Colors.transparent,
        shape: shape == BoxShape.circle
            ? const CircleBorder()
            : RoundedRectangleBorder(borderRadius: borderRadius),
        child: result,
      );
    }
    if (tooltip != null) {
      result = AppTooltip(message: tooltip!, child: result);
    }
    return result;
  }
}

class AppListView extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final bool primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final Clip clipBehavior;
  final double? itemExtent;
  final Widget? prototypeItem;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final DragStartBehavior dragStartBehavior;
  final List<Widget>? children;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int? itemCount;
  final String? restorationId;

  const AppListView({
    super.key,
    required List<Widget> this.children,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.itemExtent,
    this.prototypeItem,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
  }) : itemBuilder = null,
       separatorBuilder = null,
       itemCount = null;

  const AppListView.builder({
    super.key,
    required IndexedWidgetBuilder this.itemBuilder,
    required this.itemCount,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.itemExtent,
    this.prototypeItem,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
  }) : children = null,
       separatorBuilder = null;

  const AppListView.separated({
    super.key,
    required IndexedWidgetBuilder this.itemBuilder,
    required IndexedWidgetBuilder this.separatorBuilder,
    required this.itemCount,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
  }) : children = null,
       itemExtent = null,
       prototypeItem = null;

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder != null) {
      return ListView.separated(
        padding: padding,
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        clipBehavior: clipBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        dragStartBehavior: dragStartBehavior,
        restorationId: restorationId,
        itemCount: itemCount ?? 0,
        itemBuilder: itemBuilder!,
        separatorBuilder: separatorBuilder!,
      );
    }
    if (itemBuilder != null) {
      return ListView.builder(
        padding: padding,
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        clipBehavior: clipBehavior,
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
        keyboardDismissBehavior: keyboardDismissBehavior,
        dragStartBehavior: dragStartBehavior,
        restorationId: restorationId,
        itemCount: itemCount,
        itemBuilder: itemBuilder!,
      );
    }
    return ListView(
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      primary: primary,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      clipBehavior: clipBehavior,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      keyboardDismissBehavior: keyboardDismissBehavior,
      dragStartBehavior: dragStartBehavior,
      restorationId: restorationId,
      children: children ?? const <Widget>[],
    );
  }
}

class AppSingleChildScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool reverse;
  final bool primary;
  final Clip clipBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final DragStartBehavior dragStartBehavior;
  final String? restorationId;

  const AppSingleChildScrollView({
    super.key,
    required this.child,
    this.padding,
    this.controller,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary = false,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      controller: controller,
      physics: physics,
      scrollDirection: scrollDirection,
      reverse: reverse,
      primary: primary,
      clipBehavior: clipBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      dragStartBehavior: dragStartBehavior,
      restorationId: restorationId,
      child: child,
    );
  }
}

class AppGridView extends StatelessWidget {
  final SliverGridDelegate? gridDelegate;
  final int? crossAxisCount;
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final bool primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final Clip clipBehavior;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double? mainAxisExtent;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final DragStartBehavior dragStartBehavior;
  final String? restorationId;

  const AppGridView.builder({
    super.key,
    required SliverGridDelegate this.gridDelegate,
    required IndexedWidgetBuilder this.itemBuilder,
    required this.itemCount,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
  }) : children = null,
       crossAxisCount = null,
       mainAxisSpacing = 0,
       crossAxisSpacing = 0,
       childAspectRatio = 1,
       mainAxisExtent = null;

  const AppGridView.count({
    super.key,
    required int this.crossAxisCount,
    required List<Widget> this.children,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.clipBehavior = Clip.hardEdge,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.mainAxisExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
  }) : gridDelegate = null,
       itemBuilder = null,
       itemCount = null;

  @override
  Widget build(BuildContext context) {
    if (itemBuilder != null) {
      return GridView.builder(
        padding: padding,
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        primary: primary,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        clipBehavior: clipBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        dragStartBehavior: dragStartBehavior,
        restorationId: restorationId,
        gridDelegate: gridDelegate!,
        itemCount: itemCount,
        itemBuilder: itemBuilder!,
      );
    }
    return GridView.count(
      padding: padding,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      primary: primary,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      clipBehavior: clipBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      dragStartBehavior: dragStartBehavior,
      restorationId: restorationId,
      crossAxisCount: crossAxisCount!,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      mainAxisExtent: mainAxisExtent,
      children: children ?? const <Widget>[],
    );
  }
}

class AppDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const AppDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.dividerColor.withValues(alpha: 0.72),
    );
  }
}

class AppVerticalDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  const AppVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return VerticalDivider(
      width: width,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.dividerColor.withValues(alpha: 0.72),
    );
  }
}

class AppSelectableText extends StatelessWidget {
  final String data;
  final String? semanticLabel;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool monospace;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextScaler? textScaler;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final SelectionChangedCallback? onSelectionChanged;

  const AppSelectableText(
    this.data, {
    super.key,
    this.semanticLabel,
    this.style,
    this.maxLines,
    this.textAlign,
    this.monospace = false,
    this.autofocus = false,
    this.focusNode,
    this.textScaler,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = monospace && style?.fontFamily == null
        ? style?.copyWith(fontFamily: 'monospace') ??
              const TextStyle(fontFamily: 'monospace')
        : style;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 28),
      child: Semantics(
        label: semanticLabel ?? data,
        readOnly: true,
        child: ExcludeSemantics(
          child: SelectableText(
            data,
            style: effectiveStyle,
            maxLines: maxLines,
            textAlign: textAlign,
            autofocus: autofocus,
            focusNode: focusNode,
            textScaler: textScaler,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            onSelectionChanged: onSelectionChanged,
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final bool showLabel;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final BorderSide? enabledBorderSide;
  final BorderSide? focusedBorderSide;
  final BorderSide? disabledBorderSide;
  final TextStyle? style;
  final GestureTapCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool showClearButton;
  final bool showVisibilityToggle;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? counterText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final bool? selectAllOnFocus;
  final UndoHistoryController? undoController;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.showLabel = true,
    this.focusNode,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.filled = false,
    this.fillColor,
    this.contentPadding,
    this.borderRadius,
    this.enabledBorderSide,
    this.focusedBorderSide,
    this.disabledBorderSide,
    this.style,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.showClearButton = true,
    this.showVisibilityToggle = true,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.counterText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.smartDashesType,
    this.smartQuotesType,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.selectAllOnFocus,
    this.undoController,
    this.spellCheckConfiguration,
    this.contentInsertionConfiguration,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  FocusNode? _ownedFocusNode;
  bool _capsLockOn = false;
  bool _keyboardHandlerRegistered = false;

  bool get _enabled => widget.enabled && !widget.readOnly;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());
  bool get _showCapsLockWarning =>
      widget.obscureText && _effectiveFocusNode.hasFocus && _capsLockOn;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    widget.controller.addListener(_handleControllerChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);
    _syncKeyboardHandler();
    _updateCapsLockState();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      final previousFocusNode = oldWidget.focusNode ?? _ownedFocusNode!;
      previousFocusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) {
        previousFocusNode.dispose();
        _ownedFocusNode = null;
      }
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }
    if (oldWidget.obscureText != widget.obscureText && widget.obscureText) {
      _obscure = true;
    }
    _syncKeyboardHandler();
    _updateCapsLockState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    if (_keyboardHandlerRegistered) {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKeyEvent);
    }
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() => _updateCapsLockState(forceRebuild: true);

  bool _handleHardwareKeyEvent(KeyEvent event) {
    _updateCapsLockState();
    return false;
  }

  void _syncKeyboardHandler() {
    if (widget.obscureText == _keyboardHandlerRegistered) return;
    if (widget.obscureText) {
      HardwareKeyboard.instance.addHandler(_handleHardwareKeyEvent);
    } else {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKeyEvent);
    }
    _keyboardHandlerRegistered = widget.obscureText;
  }

  void _updateCapsLockState({bool forceRebuild = false}) {
    final next = HardwareKeyboard.instance.lockModesEnabled.contains(
      KeyboardLockMode.capsLock,
    );
    if ((_capsLockOn == next && !forceRebuild) || !mounted) return;
    setState(() => _capsLockOn = next);
  }

  void _setText(String value) {
    final next = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
    setState(() => widget.controller.value = next);
    widget.onChanged?.call(value);
  }

  void _clear() {
    _setText('');
    _effectiveFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final maxLines = widget.obscureText ? 1 : widget.maxLines;
    return _buildNativeTextField(context, maxLines);
  }

  Widget _buildNativeTextField(BuildContext context, int? maxLines) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dense = AppMetrics.usesDenseLayout(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);
    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide:
          widget.enabledBorderSide ??
          BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide:
          widget.focusedBorderSide ??
          BorderSide(color: scheme.primary, width: 1.4),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide:
          widget.disabledBorderSide ??
          BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.35)),
    );
    final suffix = _hasSuffixActions
        ? Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _buildNativeSuffix(context),
          )
        : null;

    return TextFormField(
      controller: widget.controller,
      focusNode: _effectiveFocusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: _obscure,
      enableInteractiveSelection: true,
      enableSuggestions: widget.obscureText ? false : widget.enableSuggestions,
      autocorrect: widget.obscureText ? false : widget.autocorrect,
      minLines: widget.obscureText ? null : widget.minLines,
      maxLines: maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      selectAllOnFocus: widget.selectAllOnFocus,
      undoController: widget.undoController,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: widget.style ?? theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        isDense: dense,
        labelText: widget.showLabel ? widget.label : null,
        hintText: widget.hintText,
        helperText: _showCapsLockWarning ? null : widget.helperText,
        helper: _showCapsLockWarning
            ? _PasswordCapsLockHelper(helperText: widget.helperText)
            : null,
        errorText: widget.errorText,
        counterText: widget.counterText,
        filled: widget.filled || widget.fillColor != null,
        fillColor: widget.fillColor ?? scheme.surfaceContainerHighest,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: 18),
        suffixIcon: suffix,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 10 : 13),
        border: enabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        disabledBorder: disabledBorder,
        errorBorder: enabledBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: focusedBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildNativeSuffix(BuildContext context) {
    final actions = <Widget>[];
    if (widget.suffix != null) actions.add(widget.suffix!);
    if (widget.obscureText && widget.showVisibilityToggle) {
      actions.add(
        IconButton(
          tooltip: _obscure
              ? context.l10n.showPassword
              : context.l10n.hidePassword,
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18,
          ),
          onPressed: widget.enabled
              ? () => setState(() => _obscure = !_obscure)
              : null,
        ),
      );
    }
    if (_enabled &&
        widget.showClearButton &&
        widget.controller.text.isNotEmpty) {
      actions.add(
        IconButton(
          tooltip: context.l10n.clear,
          icon: const Icon(Icons.close_rounded, size: 18),
          onPressed: _clear,
        ),
      );
    }
    return ExcludeFocus(
      child: Row(mainAxisSize: MainAxisSize.min, children: actions),
    );
  }

  bool get _hasSuffixActions {
    return widget.suffix != null ||
        (widget.obscureText && widget.showVisibilityToggle) ||
        (_enabled &&
            widget.showClearButton &&
            widget.controller.text.isNotEmpty);
  }
}

class _PasswordCapsLockHelper extends StatelessWidget {
  const _PasswordCapsLockHelper({this.helperText});

  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final warningColor = Theme.of(context).colorScheme.tertiary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (helperText != null) Text(helperText!),
        Semantics(
          liveRegion: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_capslock_rounded,
                size: 14,
                color: warningColor,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  context.l10n.capsLockOn,
                  style: TextStyle(color: warningColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppReadOnlyField extends StatefulWidget {
  final String label;
  final String value;
  final IconData? prefixIcon;
  final int maxLines;
  final TextOverflow overflow;
  final bool selectable;

  const AppReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    this.prefixIcon,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.selectable = true,
  });

  @override
  State<AppReadOnlyField> createState() => _AppReadOnlyFieldState();
}

class _AppReadOnlyFieldState extends State<AppReadOnlyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant AppReadOnlyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      label: widget.label,
      prefixIcon: widget.prefixIcon,
      readOnly: true,
      showClearButton: false,
      enableSuggestions: false,
      autocorrect: false,
      maxLines: widget.maxLines,
    );
  }
}

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final double? width;
  final IconData icon;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.width,
    this.icon = Icons.search_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final field = AppTextField(
      controller: controller,
      label: hintText,
      showLabel: false,
      hintText: hintText,
      prefixIcon: icon,
      enabled: enabled,
      showClearButton: true,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
    if (width == null) return field;
    return SizedBox(width: width, child: field);
  }
}

class AppActionButton extends StatelessWidget {
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
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : prefix ?? (icon == null ? null : Icon(icon, size: 18));
    final child = Text(label, overflow: TextOverflow.ellipsis);
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
    final buttonStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(minimumSize),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: size == AppActionButtonSize.sm ? 10 : 14,
        ),
      ),
      foregroundColor: destructiveStyle
          ? WidgetStatePropertyAll(Theme.of(context).colorScheme.onError)
          : foregroundColor == null
          ? null
          : WidgetStatePropertyAll(foregroundColor),
      backgroundColor: destructiveStyle
          ? WidgetStatePropertyAll(Theme.of(context).colorScheme.error)
          : null,
    );
    Widget button;
    switch (style) {
      case AppActionButtonStyle.filled:
      case AppActionButtonStyle.destructive:
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

    return Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: label,
      onTap: effectiveOnPressed,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        child: button,
      ),
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
    final child = loading
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(
            selected && selectedIcon != null ? selectedIcon : icon,
            size: iconSize,
          );
    final destructive = style == AppIconButtonStyle.destructive;
    final baseStyle = IconButton.styleFrom(
      minimumSize: Size(buttonSize, buttonSize),
      maximumSize: Size(buttonSize, buttonSize),
      padding: EdgeInsets.zero,
      backgroundColor: destructive ? Theme.of(context).colorScheme.error : null,
      foregroundColor: destructive
          ? Theme.of(context).colorScheme.onError
          : null,
      side: style == AppIconButtonStyle.outlined
          ? BorderSide(color: Theme.of(context).colorScheme.outline)
          : null,
    );
    Widget button;
    switch (style) {
      case AppIconButtonStyle.ghost:
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

    return Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: tooltip,
      selected: selected,
      onTap: effectiveOnPressed,
      child: showTooltip ? AppTooltip(message: tooltip, child: button) : button,
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

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final SemanticFormatterCallback? semanticFormatterCallback;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.semanticFormatterCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      semanticFormatterCallback: semanticFormatterCallback,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
    );
  }
}

class AppSegmentedControl<T> extends StatelessWidget {
  final T value;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onChanged;
  final ButtonStyle? style;
  final bool showSelectedIcon;

  const AppSegmentedControl({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.style,
    this.showSelectedIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      style: style,
      segments: segments,
      selected: {value},
      showSelectedIcon: showSelectedIcon,
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}

class AppDefaultTabController extends StatelessWidget {
  final int length;
  final Widget child;
  final int initialIndex;
  final Duration? animationDuration;

  const AppDefaultTabController({
    super.key,
    required this.length,
    required this.child,
    this.initialIndex = 0,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      initialIndex: initialIndex,
      animationDuration: animationDuration,
      child: child,
    );
  }
}

class AppTabBar extends StatelessWidget {
  final TabController? controller;
  final List<Widget> tabs;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final Color? dividerColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final ScrollPhysics? physics;
  final ValueChanged<int>? onTap;

  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.tabAlignment,
    this.padding,
    this.labelPadding,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.physics,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollBehavior = ScrollConfiguration.of(context).copyWith(
      dragDevices: const {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
      },
    );
    return _HorizontalPointerScroller(
      enabled: isScrollable,
      child: ScrollConfiguration(
        behavior: scrollBehavior,
        child: TabBar(
          controller: controller,
          tabs: tabs,
          isScrollable: isScrollable,
          tabAlignment: tabAlignment,
          padding: padding,
          labelPadding: labelPadding,
          indicator: indicator,
          indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
          dividerColor: dividerColor ?? Colors.transparent,
          labelColor: labelColor ?? theme.colorScheme.primary,
          unselectedLabelColor:
              unselectedLabelColor ?? theme.colorScheme.onSurfaceVariant,
          labelStyle:
              labelStyle ??
              theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
          unselectedLabelStyle:
              unselectedLabelStyle ??
              theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          physics: physics,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _HorizontalPointerScroller extends StatefulWidget {
  const _HorizontalPointerScroller({
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  State<_HorizontalPointerScroller> createState() =>
      _HorizontalPointerScrollerState();
}

class _HorizontalPointerScrollerState
    extends State<_HorizontalPointerScroller> {
  final _contentKey = GlobalKey();
  int? _mousePointer;
  double? _lastMouseX;

  ScrollPosition? get _position {
    ScrollableState? scrollable;
    void visit(Element element) {
      if (scrollable != null) return;
      if (element is StatefulElement && element.state is ScrollableState) {
        scrollable = element.state as ScrollableState;
        return;
      }
      element.visitChildren(visit);
    }

    final context = _contentKey.currentContext;
    if (context is Element) context.visitChildren(visit);
    return scrollable?.position;
  }

  void _moveBy(double delta) {
    final position = _position;
    if (position == null || !position.hasContentDimensions) return;
    position.jumpTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.enabled || event.kind != PointerDeviceKind.mouse) return;
    _mousePointer = event.pointer;
    _lastMouseX = event.position.dx;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _mousePointer ||
        event.buttons & kPrimaryMouseButton == 0) {
      return;
    }
    final previousX = _lastMouseX;
    _lastMouseX = event.position.dx;
    if (previousX != null) _moveBy(previousX - event.position.dx);
  }

  void _handlePointerEnd(PointerEvent event) {
    if (event.pointer != _mousePointer) return;
    _mousePointer = null;
    _lastMouseX = null;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.enabled || event is! PointerScrollEvent) return;
    final delta = event.scrollDelta.dx.abs() > event.scrollDelta.dy.abs()
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    if (delta == 0) return;
    GestureBinding.instance.pointerSignalResolver.register(
      event,
      (_) => _moveBy(delta),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerEnd,
      onPointerCancel: _handlePointerEnd,
      onPointerSignal: _handlePointerSignal,
      child: KeyedSubtree(key: _contentKey, child: widget.child),
    );
  }
}

Decoration appTabPillIndicator({
  required Color color,
  BorderRadiusGeometry borderRadius = const BorderRadius.all(
    Radius.circular(8),
  ),
  List<BoxShadow>? boxShadow,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: borderRadius,
    boxShadow: boxShadow,
  );
}

class AppTabBarView extends StatelessWidget {
  final TabController? controller;
  final List<Widget> children;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  const AppTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

enum AppLoadingSize { sm, md, lg }

class AppLoadingIndicator extends StatelessWidget {
  final AppLoadingSize size;
  final bool centered;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.md,
    this.centered = true,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final progressSize = switch (size) {
      AppLoadingSize.sm => 16.0,
      AppLoadingSize.md => 24.0,
      AppLoadingSize.lg => 36.0,
    };
    Widget progress = SizedBox(
      width: progressSize,
      height: progressSize,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: size == AppLoadingSize.sm ? 2 : 3,
      ),
    );
    if (padding != EdgeInsets.zero) {
      progress = Padding(padding: padding, child: progress);
    }
    return centered ? Center(child: progress) : progress;
  }
}

class AppLinearProgress extends StatelessWidget {
  final double? value;
  final double minHeight;
  final Color? color;
  final Color? backgroundColor;

  const AppLinearProgress({
    super.key,
    this.value,
    this.minHeight = 2,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LinearProgressIndicator(
      value: value,
      minHeight: minHeight,
      color: color ?? theme.colorScheme.primary,
      backgroundColor:
          backgroundColor ?? theme.colorScheme.primary.withValues(alpha: 0.12),
    );
  }
}

class AppInkSurface extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final Color? color;
  final ShapeBorder? shape;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Clip clipBehavior;
  final EdgeInsetsGeometry? padding;
  final double elevation;

  const AppInkSurface({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.color,
    this.shape,
    this.borderRadius,
    this.borderSide,
    this.clipBehavior = Clip.antiAlias,
    this.padding,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? const BorderRadius.all(Radius.circular(8));
    final effectiveShape =
        shape ??
        RoundedRectangleBorder(
          borderRadius: effectiveBorderRadius,
          side: borderSide ?? BorderSide.none,
        );
    Widget content = child;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (onTap != null || onLongPress != null) {
      final effectiveSemanticLabel =
          semanticLabel ?? _inferSemanticLabel(child);
      content = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: shape == null ? effectiveBorderRadius : null,
        customBorder: shape,
        child: Semantics(
          button: true,
          label: effectiveSemanticLabel,
          enabled: true,
          child: content,
        ),
      );
    }
    return Material(
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: effectiveShape,
      clipBehavior: clipBehavior,
      elevation: elevation,
      child: content,
    );
  }

  String _inferSemanticLabel(Widget widget) {
    if (widget is Text) return widget.data ?? '';
    if (widget is Tooltip) return widget.message ?? '';
    if (widget is Semantics) return widget.properties.label ?? '';
    return '';
  }
}

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}

class AppPageBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;
  final bool avoidMacOsTitleBar;
  final double toolbarHeight;

  const AppPageBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle,
    this.elevation,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.bottom,
    this.automaticallyImplyLeading = true,
    this.avoidMacOsTitleBar = true,
    this.toolbarHeight = kToolbarHeight,
  });

  // Flutter's macOS content view already starts below the native title bar.
  // A small inset keeps controls clear of the title-bar boundary without
  // adding a second full title-bar height to every page header.
  static const double _macOsTitleBarCompensation = 16;

  double get _topCompensation =>
      avoidMacOsTitleBar &&
          !kIsWeb &&
          defaultTargetPlatform == TargetPlatform.macOS
      ? _macOsTitleBarCompensation
      : 0;

  @override
  Size get preferredSize => Size.fromHeight(
    toolbarHeight + _topCompensation + (bottom?.preferredSize.height ?? 0),
  );

  @override
  Widget build(BuildContext context) {
    final compensation = _topCompensation;
    Widget? offsetTitle = title;
    Widget? offsetLeading = leading;
    List<Widget>? offsetActions = actions;
    if (compensation > 0) {
      offsetTitle = title == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: compensation),
              child: title,
            );
      offsetLeading = leading == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: compensation),
              child: leading,
            );
      offsetActions = actions
          ?.map(
            (action) => Padding(
              padding: EdgeInsets.only(top: compensation),
              child: action,
            ),
          )
          .toList(growable: false);
    }
    return AppBar(
      title: offsetTitle,
      actions: offsetActions,
      leading: offsetLeading,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor,
      systemOverlayStyle: systemOverlayStyle,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight + compensation,
    );
  }
}

class AppSliverAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? flexibleSpace;
  final double? expandedHeight;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? elevation;
  final Color? backgroundColor;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppSliverAppBar({
    super.key,
    this.title,
    this.flexibleSpace,
    this.expandedHeight,
    this.pinned = false,
    this.floating = false,
    this.snap = false,
    this.elevation,
    this.backgroundColor,
    this.automaticallyImplyLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      flexibleSpace: flexibleSpace,
      expandedHeight: expandedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      elevation: elevation,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
    );
  }
}

class AppSafeArea extends StatelessWidget {
  final Widget child;
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;

  const AppSafeArea({
    super.key,
    required this.child,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      minimum: minimum,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}

class AppOverlaySurface extends StatelessWidget {
  final Widget child;
  final MaterialType type;
  final Color color;

  const AppOverlaySurface({
    super.key,
    required this.child,
    this.type = MaterialType.transparency,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(type: type, color: color, child: child);
  }
}

class AppBlurSurface extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double sigmaX;
  final double sigmaY;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final BoxShape shape;
  final double? width;
  final double? height;

  const AppBlurSurface({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.border,
    this.boxShadow,
    this.shape = BoxShape.rectangle,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final blurredSurface = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          border: border,
          boxShadow: boxShadow,
          shape: shape,
        ),
        child: child,
      ),
    );

    if (shape == BoxShape.circle) {
      return ClipOval(child: blurredSurface);
    }

    return ClipRRect(borderRadius: borderRadius, child: blurredSurface);
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
    if (widget.onPressed == null) return;
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
    if (widget.rotateOnPressed) {
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
      child: Semantics(
        button: true,
        enabled: widget.onPressed != null,
        label: widget.tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: _handleTap,
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

class AppPanelSurface extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Clip clipBehavior;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final BoxShape shape;

  const AppPanelSurface({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.boxShadow,
    this.border,
    this.gradient,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.clipBehavior = Clip.antiAlias,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.surface;
    final content = padding == EdgeInsets.zero
        ? child
        : Padding(padding: padding, child: child);

    return Container(
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: effectiveColor,
        gradient: gradient,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        border: border,
        boxShadow: boxShadow,
        shape: shape,
      ),
      child: content,
    );
  }
}

class AppAnimatedPanelSurface extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Clip clipBehavior;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final BoxShape shape;

  const AppAnimatedPanelSurface({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.border,
    this.boxShadow,
    this.gradient,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.clipBehavior = Clip.antiAlias,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.surface;
    final content = padding == EdgeInsets.zero
        ? child
        : Padding(padding: padding, child: child);

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: effectiveColor,
        gradient: gradient,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        border: border,
        boxShadow: boxShadow,
        shape: shape,
      ),
      child: content,
    );
  }
}

class AppFloatingInputSurface extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final Color? color;

  const AppFloatingInputSurface({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      margin: margin,
      color: color ?? theme.cardColor,
      borderRadius: borderRadius,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}

class AppBadge extends StatelessWidget {
  final Widget label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? borderSide;
  final TextStyle? textStyle;
  final double iconSize;
  final BoxConstraints? constraints;

  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.borderSide,
    this.textStyle,
    this.iconSize = 14,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveBackground =
        backgroundColor ?? effectiveColor.withValues(alpha: 0.10);
    final effectiveTextStyle = (textStyle ?? theme.textTheme.labelMedium)
        ?.copyWith(color: effectiveColor, fontWeight: FontWeight.w700);

    return AppPanelSurface(
      constraints: constraints,
      margin: margin,
      color: effectiveBackground,
      borderRadius: borderRadius,
      border: borderSide == null ? null : Border.fromBorderSide(borderSide!),
      padding: padding,
      clipBehavior: Clip.none,
      child: DefaultTextStyle.merge(
        style: effectiveTextStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: iconSize, color: effectiveColor),
              const SizedBox(width: 4),
            ],
            Flexible(child: label),
          ],
        ),
      ),
    );
  }
}

class AppDataToolbar extends StatelessWidget {
  final String title;
  final int? count;
  final bool loading;
  final VoidCallback? onRefresh;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final double compactBreakpoint;
  final TextStyle? titleStyle;
  final TextStyle? countStyle;
  final String? refreshTooltip;
  final IconData refreshIcon;
  final AppIconButtonStyle refreshStyle;

  const AppDataToolbar({
    super.key,
    required this.title,
    this.count,
    this.loading = false,
    this.onRefresh,
    this.action,
    this.padding,
    this.compactBreakpoint = 430,
    this.titleStyle,
    this.countStyle,
    this.refreshTooltip,
    this.refreshIcon = Icons.refresh,
    this.refreshStyle = AppIconButtonStyle.ghost,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                titleStyle ??
                theme.textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          AppBadge(
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            label: Text(
              count.toString(),
              style:
                  countStyle ??
                  TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ],
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ?action,
        if (onRefresh != null)
          AppIconButton(
            tooltip: refreshTooltip ?? context.l10n.refresh,
            onPressed: loading ? null : onRefresh,
            icon: refreshIcon,
            loading: loading,
            style: refreshStyle,
          ),
      ],
    );

    return Padding(
      padding: padding ?? AppMetrics.toolbarPadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < compactBreakpoint;
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                titleWidget,
                if (action != null || onRefresh != null) ...[
                  const SizedBox(height: 8),
                  AppSingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: actions,
                  ),
                ],
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: titleWidget),
              if (action != null || onRefresh != null) actions,
            ],
          );
        },
      ),
    );
  }
}

class AppIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final BorderRadiusGeometry borderRadius;
  final double backgroundAlpha;
  final Widget? child;

  const AppIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.iconColor,
    this.backgroundColor,
    this.size = 40,
    this.iconSize = 24,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundAlpha = 0.10,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanelSurface(
      width: size,
      height: size,
      color: backgroundColor ?? color.withValues(alpha: backgroundAlpha),
      borderRadius: borderRadius,
      child: child ?? Icon(icon, color: iconColor ?? color, size: iconSize),
    );
  }
}

class AppInfoBanner extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final Widget? message;
  final Widget? trailing;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;
  final CrossAxisAlignment crossAxisAlignment;
  final double iconSize;
  final double iconBoxSize;
  final bool boxedIcon;
  final double spacing;
  final double messageSpacing;

  const AppInfoBanner({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.trailing,
    this.color,
    this.backgroundColor,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.border,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.iconSize = 20,
    this.iconBoxSize = 34,
    this.boxedIcon = false,
    this.spacing = 10,
    this.messageSpacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveBackground =
        backgroundColor ?? effectiveColor.withValues(alpha: 0.08);
    final effectiveBorder =
        border ?? Border.all(color: effectiveColor.withValues(alpha: 0.18));

    return AppPanelSurface(
      width: double.infinity,
      margin: margin,
      color: effectiveBackground,
      borderRadius: borderRadius,
      border: effectiveBorder,
      padding: padding ?? AppMetrics.infoBannerPadding(context),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          boxedIcon
              ? AppIconBadge(
                  icon: icon,
                  color: effectiveColor,
                  size: iconBoxSize,
                  iconSize: iconSize,
                  borderRadius: borderRadius,
                  backgroundAlpha: 0.12,
                )
              : Icon(icon, color: effectiveColor, size: iconSize),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                if (message != null) ...[
                  SizedBox(height: messageSpacing),
                  message!,
                ],
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: spacing), trailing!],
        ],
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconSize = 0,
    this.iconColor,
    this.padding,
    this.maxWidth,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconSize = iconSize > 0
        ? iconSize
        : AppMetrics.emptyStateIconSize(context);
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: effectiveIconSize,
          color: iconColor ?? theme.disabledColor.withValues(alpha: 0.5),
        ),
        SizedBox(height: AppMetrics.usesDenseLayout(context) ? 10 : 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: titleStyle ?? TextStyle(color: theme.hintColor),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style:
                subtitleStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor.withValues(alpha: 0.78),
                ),
          ),
        ],
      ],
    );
    if (maxWidth != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: content,
      );
    }
    return Padding(
      padding: padding ?? AppMetrics.emptyStatePadding(context),
      child: content,
    );
  }
}

class AppEmptyMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool centered;

  const AppEmptyMessage({
    super.key,
    required this.message,
    this.icon,
    this.padding,
    this.style,
    this.textAlign = TextAlign.center,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = Text(
      message,
      textAlign: textAlign,
      style: style ?? TextStyle(color: theme.hintColor),
    );
    Widget content = icon == null
        ? text
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.disabledColor.withValues(alpha: 0.55)),
              const SizedBox(height: 8),
              text,
            ],
          );
    content = Padding(
      padding: padding ?? AppMetrics.emptyMessagePadding(context),
      child: content,
    );
    return centered ? Center(child: content) : content;
  }
}

class AppPaginationBar extends StatelessWidget {
  final String label;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final Widget? leading;
  final Widget? trailing;

  const AppPaginationBar({
    super.key,
    required this.label,
    required this.onPrevious,
    required this.onNext,
    this.padding,
    this.labelStyle,
    this.leading,
    this.trailing,
  });

  factory AppPaginationBar.page({
    Key? key,
    required BuildContext context,
    required int page,
    int? pageSize,
    int? total,
    required VoidCallback? onPrevious,
    required VoidCallback? onNext,
    EdgeInsetsGeometry? padding,
    TextStyle? labelStyle,
    Widget? leading,
    Widget? trailing,
  }) {
    final label = pageSize == null
        ? total == null
              ? context.l10n.pageNumber(page)
              : context.l10n.pageTotalSummary(page, total)
        : total == null
        ? context.l10n.pageSizeSummary(page, pageSize)
        : context.l10n.pageSizeTotalSummary(page, pageSize, total);
    return AppPaginationBar(
      key: key,
      label: label,
      onPrevious: onPrevious,
      onNext: onNext,
      padding: padding,
      labelStyle: labelStyle,
      leading: leading,
      trailing: trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = constraints.hasBoundedWidth;
        final labelWidget = Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: labelStyle ?? TextStyle(color: theme.hintColor),
        );
        final flexibleLabel = bounded
            ? Expanded(child: labelWidget)
            : Flexible(fit: FlexFit.loose, child: labelWidget);

        return Padding(
          padding: padding ?? AppMetrics.paginationPadding(context),
          child: Row(
            mainAxisSize: bounded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              flexibleLabel,
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              AppIconButton(
                tooltip: context.l10n.previousPage,
                icon: Icons.chevron_left_rounded,
                onPressed: onPrevious,
              ),
              AppIconButton(
                tooltip: context.l10n.nextPage,
                icon: Icons.chevron_right_rounded,
                onPressed: onNext,
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppLoadMoreFooter extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;
  final String? label;
  final EdgeInsetsGeometry? padding;
  final AppActionButtonStyle buttonStyle;
  final AppLoadingSize loadingSize;
  final bool visible;

  const AppLoadMoreFooter({
    super.key,
    required this.loading,
    required this.onPressed,
    this.label,
    this.padding,
    this.buttonStyle = AppActionButtonStyle.text,
    this.loadingSize = AppLoadingSize.sm,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Padding(
      padding: padding ?? AppMetrics.loadMorePadding(context),
      child: Center(
        child: loading
            ? AppLoadingIndicator(size: loadingSize, centered: false)
            : AppActionButton(
                onPressed: onPressed,
                label: label ?? context.l10n.loadMore,
                style: buttonStyle,
                size: AppActionButtonSize.sm,
              ),
      ),
    );
  }
}

class AppImageThumbnail extends StatelessWidget {
  final String? url;
  final String? assetName;
  final Uint8List? bytes;
  final File? file;
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final IconData errorIcon;
  final Widget? errorChild;
  final List<BoxShadow>? boxShadow;
  final String? semanticLabel;
  final Map<String, String>? headers;

  const AppImageThumbnail({
    super.key,
    required String this.url,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorChild,
    this.boxShadow,
    this.semanticLabel,
    this.headers,
  }) : assetName = null,
       bytes = null,
       file = null;

  const AppImageThumbnail.asset({
    super.key,
    required String this.assetName,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorChild,
    this.boxShadow,
    this.semanticLabel,
    this.headers,
  }) : url = null,
       bytes = null,
       file = null;

  const AppImageThumbnail.memory({
    super.key,
    required Uint8List this.bytes,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorChild,
    this.boxShadow,
    this.semanticLabel,
    this.headers,
  }) : url = null,
       assetName = null,
       file = null;

  const AppImageThumbnail.file({
    super.key,
    required File this.file,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorChild,
    this.boxShadow,
    this.semanticLabel,
    this.headers,
  }) : url = null,
       assetName = null,
       bytes = null;

  @override
  Widget build(BuildContext context) {
    final effectiveSemanticLabel = semanticLabel ?? context.l10n.image;
    final fallback = Center(child: errorChild ?? Icon(errorIcon));
    final image = switch ((url, assetName, bytes, file)) {
      (final String value, null, null, null) => Image.network(
        value,
        headers: headers,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: effectiveSemanticLabel,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
      (null, final String value, null, null) => Image.asset(
        value,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: effectiveSemanticLabel,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
      (null, null, final Uint8List value, null) => Image.memory(
        value,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: effectiveSemanticLabel,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
      (null, null, null, final File value) => Image.file(
        value,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: effectiveSemanticLabel,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
      _ => fallback,
    };

    return AppPanelSurface(
      width: width,
      height: height,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: image,
    );
  }
}

class AppTransparentRouteSurface extends StatelessWidget {
  final Widget child;

  const AppTransparentRouteSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppOverlaySurface(child: child);
  }
}

class AppPopupMenuButton<T> extends StatelessWidget {
  final String tooltip;
  final Widget? icon;
  final Widget? child;
  final T? initialValue;
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final VoidCallback? onOpened;
  final VoidCallback? onCanceled;
  final EdgeInsetsGeometry padding;
  final Offset offset;
  final Color? color;

  const AppPopupMenuButton({
    super.key,
    required this.tooltip,
    required this.itemBuilder,
    this.icon,
    this.child,
    this.initialValue,
    this.onSelected,
    this.onOpened,
    this.onCanceled,
    this.padding = const EdgeInsets.all(8),
    this.offset = Offset.zero,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: tooltip,
      icon: icon,
      initialValue: initialValue,
      onSelected: onSelected,
      onOpened: onOpened,
      onCanceled: onCanceled,
      itemBuilder: itemBuilder,
      padding: padding,
      offset: offset,
      color: color,
      child: child,
    );
  }
}

class AppMenuAnchor extends StatelessWidget {
  final List<Widget> menuChildren;
  final Widget Function(
    BuildContext context,
    MenuController controller,
    Widget? child,
  )
  builder;

  const AppMenuAnchor({
    super.key,
    required this.menuChildren,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(menuChildren: menuChildren, builder: builder);
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding ?? AppMetrics.cardPadding(context),
        child: child,
      ),
    );
  }
}

class AppAccordionItem extends StatelessWidget {
  final Widget title;
  final Widget child;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? padding;

  const AppAccordionItem({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget accordion = ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: title,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      children: [child],
    );
    if (padding != null) {
      accordion = Padding(padding: padding!, child: accordion);
    }
    return accordion;
  }
}

class AppTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool destructive;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;
  final String? semanticsLabel;
  final bool autofocus;
  final FocusNode? focusNode;

  const AppTile({
    super.key,
    required this.title,
    this.subtitle,
    this.prefix,
    this.suffix,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    this.destructive = false,
    this.padding,
    this.contentPadding,
    this.selected = false,
    this.semanticsLabel,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: title,
      subtitle: subtitle,
      leading: prefix,
      trailing: suffix,
      enabled: enabled,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer
          .withValues(alpha: 0.45),
      iconColor: destructive ? Theme.of(context).colorScheme.error : null,
      textColor: destructive ? Theme.of(context).colorScheme.error : null,
      autofocus: autofocus,
      focusNode: focusNode,
      onTap: enabled ? onPressed : null,
      onLongPress: enabled ? onLongPress : null,
      contentPadding: contentPadding,
    );
    Widget result = Material(type: MaterialType.transparency, child: tile);
    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }
    return result;
  }
}

class AppSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? prefix;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticsLabel;

  const AppSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.prefix,
    this.enabled = true,
    this.padding,
    this.contentPadding,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onChanged != null;
    return AppTile(
      title: title,
      subtitle: subtitle,
      prefix: prefix,
      suffix: AppSwitch(
        value: value,
        onChanged: onChanged,
        enabled: effectiveEnabled,
        semanticsLabel: semanticsLabel,
      ),
      enabled: effectiveEnabled,
      padding: padding,
      contentPadding: contentPadding,
      semanticsLabel: semanticsLabel,
      onPressed: effectiveEnabled ? () => onChanged?.call(!value) : null,
    );
  }
}

class AppCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final String? semanticsLabel;

  const AppCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.padding,
    this.contentPadding,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onChanged != null;
    return AppTile(
      title: title,
      subtitle: subtitle,
      prefix: AppCheckbox(
        value: value,
        onChanged: onChanged,
        enabled: effectiveEnabled,
        semanticsLabel: semanticsLabel,
      ),
      suffix: suffix,
      enabled: effectiveEnabled,
      padding: padding,
      contentPadding: contentPadding,
      semanticsLabel: semanticsLabel,
      onPressed: effectiveEnabled ? () => onChanged?.call(!value) : null,
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Widget content;
  final String? cancelLabel;
  final String? confirmLabel;
  final IconData? confirmIcon;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final bool destructive;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.cancelLabel,
    this.confirmLabel,
    this.confirmIcon,
    this.onCancel,
    this.onConfirm,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      title: Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 480),
        child: SingleChildScrollView(child: content),
      ),
      actions: _actions(context),
    );
  }

  List<Widget> _actions(BuildContext context) => [
    AppActionButton(
      onPressed: onConfirm,
      icon: confirmIcon,
      label: confirmLabel ?? context.l10n.confirm,
      style: destructive
          ? AppActionButtonStyle.destructive
          : AppActionButtonStyle.filled,
    ),
    AppActionButton(
      onPressed: onCancel ?? () => Navigator.pop(context, false),
      label: cancelLabel ?? context.l10n.cancel,
      style: AppActionButtonStyle.outlined,
    ),
  ];
}

class AppDialog extends StatelessWidget {
  final Widget? title;
  final Widget? body;
  final List<Widget> actions;
  final Widget? icon;
  final BoxConstraints constraints;

  const AppDialog({
    super.key,
    this.title,
    this.body,
    required this.actions,
    this.icon,
    this.constraints = const BoxConstraints(minWidth: 280, maxWidth: 560),
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = AppMetrics.dialogMaxHeight(
      context,
      constraints.hasBoundedHeight ? constraints.maxHeight : null,
    );
    return AlertDialog(
      icon: icon,
      title: title,
      content: body == null
          ? null
          : ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.minWidth,
                maxWidth: constraints.maxWidth,
                maxHeight: maxHeight,
              ),
              child: SingleChildScrollView(child: body),
            ),
      actions: actions,
    );
  }
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.55),
    builder: builder,
  );
}

class AppDialogFrame extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double? maxHeight;
  final EdgeInsets? insetPadding;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final Clip clipBehavior;
  final bool allowWide;

  const AppDialogFrame({
    super.key,
    required this.child,
    this.maxWidth = 560,
    this.maxHeight,
    this.insetPadding,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.clipBehavior = Clip.antiAlias,
    this.allowWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetPadding ?? AppMetrics.dialogInsetPadding(context),
      clipBehavior: clipBehavior,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppMetrics.dialogMaxWidth(
            context,
            maxWidth,
            allowWide: allowWide,
          ),
          maxHeight: AppMetrics.dialogMaxHeight(context, maxHeight),
        ),
        child: child,
      ),
    );
  }
}

class AppDialogHeader extends StatelessWidget {
  final Widget title;
  final IconData icon;
  final Color? color;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry padding;
  final double iconBoxSize;
  final double iconSize;

  const AppDialogHeader({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.onClose,
    this.padding = const EdgeInsets.fromLTRB(22, 16, 16, 14),
    this.iconBoxSize = 40,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return AppPanelSurface(
      width: double.infinity,
      color: effectiveColor.withValues(alpha: 0.12),
      borderRadius: BorderRadius.zero,
      padding: padding,
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
            color: effectiveColor,
            size: iconBoxSize,
            iconSize: iconSize,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            backgroundAlpha: 0.16,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DefaultTextStyle.merge(
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              child: title,
            ),
          ),
          if (onClose != null)
            AppIconButton(
              tooltip: context.l10n.close,
              onPressed: onClose,
              icon: Icons.close_rounded,
            ),
        ],
      ),
    );
  }
}

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? barrierColor,
  Color? backgroundColor,
  BoxConstraints? constraints,
  ShapeBorder? shape,
  Clip? clipBehavior,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
    constraints: constraints,
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    shape:
        shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
    clipBehavior: clipBehavior,
    builder: builder,
  );
}

class AppBottomSheetFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool includeKeyboardInset;

  const AppBottomSheetFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    this.includeKeyboardInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final resolved = padding.resolve(Directionality.of(context));
    return SafeArea(
      child: Padding(
        padding: resolved.copyWith(
          bottom:
              resolved.bottom + (includeKeyboardInset ? viewInsets.bottom : 0),
        ),
        child: child,
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final String? errorText;
  final String? semanticsLabel;
  final bool enabled;
  final bool leadingLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorText,
    this.semanticsLabel,
    this.enabled = true,
    this.leadingLabel = false,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onChanged != null;
    final control = Switch(
      value: value,
      onChanged: effectiveEnabled ? onChanged : null,
      focusNode: focusNode,
      autofocus: autofocus,
    );
    final labelWidget = label == null
        ? control
        : Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: leadingLabel ? TextDirection.rtl : null,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label!),
                    if (description != null)
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (errorText != null)
                      Text(
                        errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              control,
            ],
          );
    return Semantics(
      label: semanticsLabel ?? label ?? context.l10n.switchControl,
      toggled: value,
      enabled: effectiveEnabled,
      child: label == null
          ? labelWidget
          : InkWell(
              onTap: effectiveEnabled ? () => onChanged?.call(!value) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: labelWidget,
              ),
            ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final String? errorText;
  final String? semanticsLabel;
  final bool enabled;
  final bool leadingLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorText,
    this.semanticsLabel,
    this.enabled = true,
    this.leadingLabel = false,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onChanged != null;
    final control = Checkbox(
      value: value,
      onChanged: effectiveEnabled
          ? (next) {
              if (next != null) onChanged?.call(next);
            }
          : null,
      focusNode: focusNode,
      autofocus: autofocus,
    );
    if (label == null) {
      return Semantics(
        label: semanticsLabel,
        checked: value,
        enabled: effectiveEnabled,
        child: control,
      );
    }
    final labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: leadingLabel ? TextDirection.rtl : null,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label!),
              if (description != null)
                Text(
                  description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (errorText != null)
                Text(
                  errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        control,
      ],
    );
    return Semantics(
      label: semanticsLabel ?? label,
      checked: value,
      enabled: effectiveEnabled,
      child: InkWell(
        onTap: effectiveEnabled ? () => onChanged?.call(!value) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: labelWidget,
        ),
      ),
    );
  }
}

class AppSelect<T> extends StatelessWidget {
  final T? value;
  final Map<String, T> options;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hintText;
  final String? description;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget Function(BuildContext context, T value)? optionPrefixBuilder;
  final FormFieldSetter<T>? onSaved;
  final VoidCallback? onReset;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode autovalidateMode;
  final bool enabled;
  final bool expands;
  final bool clearable;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool canRequestFocus;
  final TextAlign textAlign;
  final double? width;
  final bool? compact;

  const AppSelect({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.hintText,
    this.description,
    this.errorText,
    this.prefixIcon,
    this.optionPrefixBuilder,
    this.onSaved,
    this.onReset,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUnfocus,
    this.enabled = true,
    this.expands = false,
    this.clearable = false,
    this.focusNode,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.textAlign = TextAlign.start,
    this.width,
    this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final field = DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: enabled && onChanged != null ? _handleChange : null,
      focusNode: focusNode,
      autofocus: autofocus,
      isExpanded: true,
      alignment: textAlign == TextAlign.end
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? context.l10n.selectOption,
        helperText: description,
        errorText: errorText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 18),
      ),
      validator: validator,
      autovalidateMode: autovalidateMode,
      onSaved: onSaved,
      items: [
        for (final entry in options.entries)
          DropdownMenuItem<T>(
            value: entry.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (optionPrefixBuilder != null) ...[
                  optionPrefixBuilder!(context, entry.value),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(entry.key, textAlign: textAlign)),
              ],
            ),
          ),
      ],
      selectedItemBuilder: (context) => [
        for (final entry in options.entries)
          Text(
            entry.key,
            textAlign: textAlign,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );

    final effectiveWidth = width ?? _defaultWidth(context);
    if (effectiveWidth == null) return field;
    return SizedBox(width: effectiveWidth, child: field);
  }

  void _handleChange(T? next) {
    final callback = onChanged;
    if (callback == null) return;
    if (next != null) {
      callback(next);
      return;
    }
    if (options.values.any((value) => value == null)) {
      callback(next);
    }
  }

  double? _defaultWidth(BuildContext context) {
    if (compact == false) return null;
    if (label != null || description != null || errorText != null) {
      return null;
    }
    if (options.isEmpty) return null;

    final maxLabelLength = options.keys.fold<int>(
      hintText?.characters.length ?? 0,
      (max, label) => math.max(max, label.characters.length),
    );
    final textWidth = maxLabelLength * 14.0;
    final chromeWidth = prefixIcon == null ? 52.0 : 76.0;
    final width = textWidth + chromeWidth;
    final dense = AppMetrics.usesDenseLayout(context);
    final minWidth = dense ? 86.0 : 96.0;
    final maxWidth = dense ? 158.0 : 176.0;
    return width.clamp(minWidth, maxWidth).toDouble();
  }
}
