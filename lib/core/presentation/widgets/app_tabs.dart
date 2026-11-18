import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/core/presentation/widgets/app_surfaces.dart';

import 'dart:math' as math;

import 'package:synctv_app/core/presentation/widgets/app_tab_activity.dart';

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

class AppTabBar extends StatefulWidget {
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
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  final _tabKeys = <GlobalKey>[];
  final _scrollController = TabBarScrollController();
  TabController? _controller;
  double? _viewportDimension;
  (TextScaler, TextDirection)? _textLayout;
  bool _revealScheduled = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final previous = _textLayout;
    _textLayout = (
      MediaQuery.textScalerOf(context),
      Directionality.of(context),
    );
    if (previous != null && previous != _textLayout) _scheduleReveal();
  }

  bool _handleMetrics(ScrollMetricsNotification notification) {
    if (!widget.isScrollable ||
        notification.depth != 0 ||
        notification.metrics.axis != Axis.horizontal) {
      return false;
    }
    final previous = _viewportDimension;
    _viewportDimension = notification.metrics.viewportDimension;
    if (previous != null && previous != _viewportDimension) _scheduleReveal();
    return false;
  }

  void _scheduleReveal() {
    if (_revealScheduled) return;
    _revealScheduled = true;
    // Resize and text scaling can move the selected tab outside the viewport.
    // Scroll offsets alone must not interrupt manual browsing of other tabs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealScheduled = false;
      if (!mounted || !widget.isScrollable) return;
      final index = _controller?.index;
      if (index == null || index >= _tabKeys.length) return;
      final tabContext = _tabKeys[index].currentContext;
      final target = tabContext?.findRenderObject();
      if (tabContext == null || target == null || !target.attached) return;
      Scrollable.maybeOf(
        tabContext,
        axis: Axis.horizontal,
      )?.position.ensureVisible(target, alignment: 0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller = widget.controller ?? DefaultTabController.maybeOf(context);
    if (_tabKeys.length > widget.tabs.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
    }
    while (_tabKeys.length < widget.tabs.length) {
      _tabKeys.add(GlobalKey());
    }
    final theme = Theme.of(context);
    final scrollBehavior = ScrollConfiguration.of(context).copyWith(
      dragDevices: const {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
      },
    );
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
          TraversalDirection.left,
        ),
        SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
          TraversalDirection.right,
        ),
      },
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: _handleMetrics,
        child: _HorizontalPointerScroller(
          enabled: widget.isScrollable,
          controller: _scrollController,
          child: ScrollConfiguration(
            behavior: scrollBehavior,
            child: TabBar(
              controller: widget.controller,
              scrollController: _scrollController,
              tabs: [
                for (var index = 0; index < widget.tabs.length; index++)
                  if (widget.tabs[index] case final PreferredSizeWidget tab)
                    PreferredSize(
                      preferredSize: tab.preferredSize,
                      child: KeyedSubtree(key: _tabKeys[index], child: tab),
                    )
                  else
                    KeyedSubtree(
                      key: _tabKeys[index],
                      child: widget.tabs[index],
                    ),
              ],
              isScrollable: widget.isScrollable,
              tabAlignment: widget.tabAlignment,
              padding: widget.padding,
              labelPadding: widget.labelPadding,
              indicator: widget.indicator,
              indicatorSize: widget.indicatorSize ?? TabBarIndicatorSize.tab,
              dividerColor: widget.dividerColor ?? Colors.transparent,
              labelColor: widget.labelColor ?? theme.colorScheme.primary,
              unselectedLabelColor:
                  widget.unselectedLabelColor ??
                  theme.colorScheme.onSurfaceVariant,
              labelStyle:
                  widget.labelStyle ??
                  theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              unselectedLabelStyle:
                  widget.unselectedLabelStyle ??
                  theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              physics: widget.physics,
              onTap: widget.onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalPointerScroller extends StatefulWidget {
  const _HorizontalPointerScroller({
    required this.enabled,
    required this.controller,
    required this.child,
  });

  final bool enabled;
  final ScrollController controller;
  final Widget child;

  @override
  State<_HorizontalPointerScroller> createState() =>
      _HorizontalPointerScrollerState();
}

class _HorizontalPointerScrollerState
    extends State<_HorizontalPointerScroller> {
  int? _mousePointer;
  double? _lastMouseX;

  ScrollPosition? get _position {
    return widget.controller.hasClients ? widget.controller.position : null;
  }

  void _moveBy(double delta) {
    final position = _position;
    if (position == null || !position.hasContentDimensions) return;
    final directedDelta = axisDirectionIsReversed(position.axisDirection)
        ? -delta
        : delta;
    position.jumpTo(
      (position.pixels + directedDelta).clamp(
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
      child: widget.child,
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

/// One entry of [AppSectionTabBar].
class AppSectionTab {
  const AppSectionTab({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// The single top-level tab strip used by management pages (admin settings,
/// room settings, account center). 44px rows with icon + label, a soft pill
/// indicator, and the full-width surface with bottom divider — one geometry
/// everywhere instead of per-page variants.
class AppSectionTabBar extends StatelessWidget {
  const AppSectionTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.onTap,
  });

  final TabController controller;
  final List<AppSectionTab> tabs;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelMedium!;
    final tabHeight = math.max(
      44.0,
      MediaQuery.textScalerOf(context).scale(labelStyle.fontSize!) *
              (labelStyle.height ?? 1.4) +
          16,
    );
    return AppInkSurface(
      color: theme.colorScheme.surface,
      elevation: 0,
      clipBehavior: Clip.none,
      child: AppSafeArea(
        bottom: false,
        child: AppPanelSurface(
          borderRadius: BorderRadius.zero,
          clipBehavior: Clip.none,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.65),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          child: AppTabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: onTap,
            dividerColor: Colors.transparent,
            indicator: appTabPillIndicator(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
            ),
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.62,
            ),
            labelStyle: labelStyle.copyWith(fontWeight: FontWeight.w700),
            unselectedLabelStyle: labelStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              for (final tab in tabs)
                Tab(
                  height: tabHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tab.icon, size: 18),
                        const SizedBox(width: 6),
                        Text(tab.label),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
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
    final effectiveController = controller ?? DefaultTabController.of(context);
    return TabBarView(
      controller: effectiveController,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction,
      clipBehavior: clipBehavior,
      children: [
        for (var index = 0; index < children.length; index++)
          _AppTabPage(
            key: children[index].key == null
                ? null
                : ValueKey(children[index].key),
            controller: effectiveController,
            index: index,
            child: children[index],
          ),
      ],
    );
  }
}

class _AppTabPage extends StatelessWidget {
  const _AppTabPage({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
  });

  final TabController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parentActive = AppTabActivity.of(context);
    // TabBarView retains old child widgets during nonadjacent page animations.
    // Each retained page must still observe controller changes independently.
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (context, child) => AppTabActivity(
        active: parentActive && controller.index == index,
        child: child!,
      ),
    );
  }
}
