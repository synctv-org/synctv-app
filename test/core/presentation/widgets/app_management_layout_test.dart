import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../../../test_app.dart';

void main() {
  group('AppContentWidthBox', () {
    testWidgets('caps and centers content on wide windows', (tester) async {
      tester.view.physicalSize = const Size(1800, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppContentWidthBox(
              child: Container(
                key: const Key('content'),
                color: Colors.red,
                height: 40,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final rect = tester.getRect(find.byKey(const Key('content')));
      expect(rect.width, AppMetrics.managementMaxWidth);
      // Centered inside the 1800px surface, so both margins match.
      final leftMargin = rect.left;
      final rightMargin = 1800 - rect.right;
      expect(leftMargin, closeTo(rightMargin, 0.5));
      expect(leftMargin, greaterThan(0));
    });

    testWidgets('passes content through below the desktop breakpoint', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1100, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppContentWidthBox(
              child: Container(
                key: const Key('content'),
                color: Colors.red,
                height: 40,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final rect = tester.getRect(find.byKey(const Key('content')));
      expect(rect.left, 0);
      expect(rect.width, 1100);
    });
  });

  group('AppSectionTabBar', () {
    testWidgets('renders one uniform 44px row geometry', (tester) async {
      final controller = TabController(length: 3, vsync: tester);
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              body: AppSectionTabBar(
                controller: controller,
                tabs: const [
                  AppSectionTab(icon: Icons.grid_view_rounded, label: 'A'),
                  AppSectionTab(icon: Icons.people_rounded, label: 'B'),
                  AppSectionTab(icon: Icons.circle_outlined, label: 'C'),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final barRect = tester.getRect(find.byType(AppSectionTabBar));
      final tabBarRect = tester.getRect(find.byType(AppTabBar));
      // Panel padding (6 top + 8 bottom) plus the 1px bottom divider.
      expect(barRect.height - tabBarRect.height, 6 + 8 + 1);
      for (final tab in find.byType(Tab).evaluate()) {
        final size = tester.getSize(find.byWidget(tab.widget));
        expect(size.height, 44, reason: 'every tab row is 44px');
      }
    });
  });

  group('AdminSettingsPage layout', () {
    testWidgets('caps the section content beside the rail on wide windows', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1800, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final gateway = _StubAdminGateway();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => DependencyScope<AdminGateway>(
            value: gateway,
            child: buildThemedTestApp(context, child),
          ),
          home: const AdminSettingsPage(),
        ),
      );
      await tester.pump();
      gateway.complete();
      await tester.pumpAndSettle();

      final stackRect = tester.getRect(find.byType(IndexedStack).first);
      expect(
        stackRect.width,
        lessThanOrEqualTo(AppMetrics.managementMaxWidth),
        reason: 'section content is capped on wide windows',
      );
      final railRect = tester.getRect(find.byType(IndexedStack).first);
      expect(railRect.left, greaterThan(232));
    });
  });
}

class _StubAdminGateway implements AdminGateway {
  final completer = Completer<AdminServiceState>();

  void complete() {
    completer.complete(
      const AdminServiceState(
        totalUsers: 1,
        activeUsers: 1,
        bannedUsers: 0,
        totalRooms: 1,
        activeRooms: 1,
        bannedRooms: 0,
        totalMedia: 0,
        providerInstances: 0,
        activeStreams: 0,
        openReports: 0,
      ),
    );
  }

  @override
  Future<AdminServiceState> adminGetServiceState() => completer.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
