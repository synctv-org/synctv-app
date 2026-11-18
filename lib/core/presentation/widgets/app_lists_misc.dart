import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_buttons.dart';
import 'package:synctv_app/core/presentation/widgets/app_controls_shared.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_fields.dart';
import 'package:synctv_app/core/presentation/widgets/app_surfaces.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

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
    final initial = Padding(
      padding: EdgeInsets.all(effectiveSize * 0.16),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          _initial,
          style: effectiveTextStyle,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
    final resolvedImageUrl = imageUrl?.trim() ?? '';
    final image = resolvedImageUrl.isEmpty
        ? null
        : Image.network(
            resolvedImageUrl,
            width: effectiveSize,
            height: effectiveSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return initial;
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
              ? initial
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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

enum AppLoadingSize { sm, md, lg }

class AppLoadingIndicator extends StatelessWidget {
  final AppLoadingSize size;
  final bool centered;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.md,
    this.centered = true,
    this.color,
    this.padding = EdgeInsets.zero,
    this.semanticLabel,
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
        semanticsLabel:
            semanticLabel ??
            Localizations.of<AppLocalizations>(
              context,
              AppLocalizations,
            )?.loading ??
            'Loading',
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
  final String? semanticLabel;

  const AppLinearProgress({
    super.key,
    this.value,
    this.minHeight = 2,
    this.color,
    this.backgroundColor,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LinearProgressIndicator(
      semanticsLabel:
          semanticLabel ??
          Localizations.of<AppLocalizations>(
            context,
            AppLocalizations,
          )?.loading ??
          'Loading',
      value: value,
      minHeight: minHeight,
      color: color ?? theme.colorScheme.primary,
      backgroundColor:
          backgroundColor ?? theme.colorScheme.primary.withValues(alpha: 0.12),
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
  final ValueChanged<bool>? onExpansionChanged;
  final EdgeInsetsGeometry? padding;

  const AppAccordionItem({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget accordion = ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
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
  final bool stackedSuffix;
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
    this.stackedSuffix = false,
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
      subtitle: stackedSuffix && suffix != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?subtitle,
                const SizedBox(height: 8),
                Align(alignment: AlignmentDirectional.centerEnd, child: suffix),
              ],
            )
          : subtitle,
      leading: prefix,
      trailing: stackedSuffix ? null : suffix,
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
    Widget tile = SwitchListTile(
      value: value,
      onChanged: effectiveEnabled ? onChanged : null,
      title: semanticsLabel == null
          ? title
          : Semantics(
              label: semanticsLabel,
              excludeSemantics: true,
              child: title,
            ),
      subtitle: subtitle,
      secondary: prefix,
      contentPadding: contentPadding,
    );
    tile = Material(type: MaterialType.transparency, child: tile);
    return padding == null ? tile : Padding(padding: padding!, child: tile);
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
    void toggle() => onChanged?.call(!value);
    Widget tile = Material(
      type: MaterialType.transparency,
      child: InkWell(
        excludeFromSemantics: true,
        onTap: effectiveEnabled ? toggle : null,
        child: Semantics(
          checked: value,
          enabled: effectiveEnabled,
          label: semanticsLabel,
          onTap: effectiveEnabled ? toggle : null,
          child: ListTile(
            title: prefix == null
                ? title
                : Row(
                    children: [
                      prefix!,
                      const SizedBox(width: 8),
                      Expanded(child: title),
                    ],
                  ),
            subtitle: subtitle,
            leading: ExcludeFocus(
              child: ExcludeSemantics(
                child: IgnorePointer(
                  child: AppCheckbox(
                    value: value,
                    onChanged: onChanged,
                    enabled: effectiveEnabled,
                  ),
                ),
              ),
            ),
            trailing: suffix,
            enabled: effectiveEnabled,
            contentPadding: contentPadding,
          ),
        ),
      ),
    );
    return padding == null ? tile : Padding(padding: padding!, child: tile);
  }
}
