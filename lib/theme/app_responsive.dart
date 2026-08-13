import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppBreakpointNames {
  static const compact = MOBILE;
  static const medium = TABLET;
  static const expanded = 'EXPANDED';
  static const desktop = DESKTOP;
  static const wide = 'WIDE';
}

class AppBreakpoints {
  static const double compactEnd = 599;
  static const double mediumStart = 600;
  static const double mediumEnd = 839;
  static const double expandedStart = 840;
  static const double expandedEnd = 1199;
  static const double desktopStart = 1200;
  static const double desktopEnd = 1599;
  static const double wideStart = 1600;

  static const values = <Breakpoint>[
    Breakpoint(start: 0, end: compactEnd, name: AppBreakpointNames.compact),
    Breakpoint(
      start: mediumStart,
      end: mediumEnd,
      name: AppBreakpointNames.medium,
    ),
    Breakpoint(
      start: expandedStart,
      end: expandedEnd,
      name: AppBreakpointNames.expanded,
    ),
    Breakpoint(
      start: desktopStart,
      end: desktopEnd,
      name: AppBreakpointNames.desktop,
    ),
    Breakpoint(
      start: wideStart,
      end: double.infinity,
      name: AppBreakpointNames.wide,
    ),
  ];

  static double widthOf(BuildContext context) {
    try {
      return ResponsiveBreakpoints.of(context).screenWidth;
    } catch (_) {
      return MediaQuery.sizeOf(context).width;
    }
  }

  static bool isCompact(BuildContext context) => widthOf(context) < mediumStart;

  static bool isMedium(BuildContext context) {
    final width = widthOf(context);
    return width >= mediumStart && width < expandedStart;
  }

  static bool isExpanded(BuildContext context) {
    final width = widthOf(context);
    return width >= expandedStart && width < desktopStart;
  }

  static bool isDesktop(BuildContext context) =>
      widthOf(context) >= expandedStart;

  static bool isWide(BuildContext context) => widthOf(context) >= wideStart;
}

class AppMetrics {
  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double minTouchTarget = 44;
  static const double minDesktopControl = 40;
  static const double contentMaxWidth = 1280;
  static const double managementMaxWidth = 1440;

  static EdgeInsets pagePadding(BuildContext context) {
    final width = AppBreakpoints.widthOf(context);
    if (width >= AppBreakpoints.wideStart) {
      return const EdgeInsets.symmetric(horizontal: 28, vertical: 18);
    }
    if (width >= AppBreakpoints.desktopStart) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    if (width >= AppBreakpoints.expandedStart) {
      return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
    if (width >= AppBreakpoints.mediumStart) {
      return const EdgeInsets.symmetric(horizontal: 18, vertical: 14);
    }
    return const EdgeInsets.symmetric(horizontal: 14, vertical: 14);
  }

  static bool usesDenseLayout(BuildContext context) {
    return AppBreakpoints.widthOf(context) >= AppBreakpoints.expandedStart;
  }

  static EdgeInsets cardPadding(BuildContext context) {
    if (usesDenseLayout(context)) return const EdgeInsets.all(12);
    return const EdgeInsets.all(14);
  }

  static EdgeInsets toolbarPadding(BuildContext context) {
    if (usesDenseLayout(context)) {
      return const EdgeInsets.fromLTRB(8, 0, 6, 8);
    }
    return const EdgeInsets.fromLTRB(10, 0, 8, 10);
  }

  static EdgeInsets infoBannerPadding(BuildContext context) {
    if (usesDenseLayout(context)) {
      return const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
    }
    return const EdgeInsets.all(12);
  }

  static EdgeInsets emptyStatePadding(BuildContext context) {
    if (usesDenseLayout(context)) return const EdgeInsets.all(12);
    return const EdgeInsets.all(16);
  }

  static double emptyStateIconSize(BuildContext context) {
    if (usesDenseLayout(context)) return 36;
    return 44;
  }

  static EdgeInsets emptyMessagePadding(BuildContext context) {
    if (usesDenseLayout(context)) return const EdgeInsets.all(12);
    return const EdgeInsets.all(16);
  }

  static EdgeInsets paginationPadding(BuildContext context) {
    if (usesDenseLayout(context)) {
      return const EdgeInsets.fromLTRB(10, 2, 10, 8);
    }
    return const EdgeInsets.fromLTRB(14, 4, 14, 10);
  }

  static EdgeInsets loadMorePadding(BuildContext context) {
    if (usesDenseLayout(context)) return const EdgeInsets.all(10);
    return const EdgeInsets.all(14);
  }

  static double contentWidth(BuildContext context) {
    final width = AppBreakpoints.widthOf(context);
    if (width >= AppBreakpoints.wideStart) return managementMaxWidth;
    if (width >= AppBreakpoints.desktopStart) return contentMaxWidth;
    return double.infinity;
  }

  static double dialogMaxWidth(
    BuildContext context,
    double requestedMaxWidth, {
    bool allowWide = false,
  }) {
    final width = AppBreakpoints.widthOf(context);
    final cap = allowWide
        ? switch (width) {
            >= AppBreakpoints.wideStart => 1320.0,
            >= AppBreakpoints.desktopStart => 1160.0,
            >= AppBreakpoints.expandedStart => 980.0,
            >= AppBreakpoints.mediumStart => 820.0,
            _ => math.max(280.0, width - 24),
          }
        : switch (width) {
            >= AppBreakpoints.wideStart => 760.0,
            >= AppBreakpoints.desktopStart => 680.0,
            >= AppBreakpoints.expandedStart => 620.0,
            >= AppBreakpoints.mediumStart => 560.0,
            _ => math.max(280.0, width - 24),
          };
    return math.min(requestedMaxWidth, cap);
  }

  static double dialogMaxHeight(
    BuildContext context,
    double? requestedMaxHeight,
  ) {
    final size = MediaQuery.sizeOf(context);
    final verticalMargin = size.height < 720 ? 20.0 : 48.0;
    final available = math.max(320.0, size.height - verticalMargin);
    return math.min(requestedMaxHeight ?? available, available);
  }

  static EdgeInsets dialogInsetPadding(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact =
        size.width < AppBreakpoints.mediumStart || size.height < 720;
    return EdgeInsets.symmetric(
      horizontal: compact ? 12 : 24,
      vertical: compact ? 10 : 24,
    );
  }
}
