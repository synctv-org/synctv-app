import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/theme/app_responsive.dart';

/// Caps a management page's content column to [AppMetrics.contentWidth] and
/// centers it, so wide desktop windows don't stretch list rows, toolbars and
/// forms edge to edge. Below the desktop breakpoint the cap is inactive and
/// the box passes its child through unchanged.
class AppContentWidthBox extends StatelessWidget {
  const AppContentWidthBox({super.key, required this.child, this.maxWidth});

  final Widget child;

  /// Overrides the breakpoint-derived cap, e.g. for panels that sit beside a
  /// navigation rail and need the rail subtracted.
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final cap = maxWidth ?? AppMetrics.contentWidth(context);
    if (!cap.isFinite) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: cap),
        child: child,
      ),
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

class AppTransparentRouteSurface extends StatelessWidget {
  final Widget child;

  const AppTransparentRouteSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AppOverlaySurface(child: child);
  }
}
