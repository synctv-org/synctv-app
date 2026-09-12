import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';

import '../../../test_app.dart';

void main() {
  testWidgets('join review identities and role follow the current locale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(600, 650));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final gateway = _JoinReviewGateway();
    Widget app(Locale locale) => MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: buildThemedTestApp(context, child),
      ),
      home: const Scaffold(body: AdminReviewTab()),
    );
    await tester.pumpWidget(app(const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Room ID: room_6'), findsOneWidget);
    expect(find.text('User ID: usr_13'), findsOneWidget);
    expect(find.text('Role: Member'), findsOneWidget);
    expect(find.text('Daniel'), findsOneWidget);
    await tester.pumpWidget(app(const Locale('zh')));
    await tester.pumpAndSettle();
    expect(find.text('角色: 成员'), findsOneWidget);
    expect(find.text('Role: Member'), findsNothing);
    expect(gateway.reads, 1);
    expect(tester.takeException(), isNull);
  });

  for (final testCase in <(String, Widget)>[
    ('user management', const UserManagementTab()),
    ('review', const AdminReviewTab()),
    ('provider', const AdminProviderTab()),
    ('runtime settings', const RuntimeSettingsSectionsTab()),
  ]) {
    testWidgets('${testCase.$1} initializes after localization is available', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: buildThemedTestApp,
          home: Scaffold(body: testCase.$2),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byWidget(testCase.$2), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });
  }
}

class _JoinReviewGateway implements AdminGateway {
  int reads = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminListReviewsPage) {
      reads++;
      return Future.value(
        const AdminReviewsPage(
          reviews: [
            AdminRoomJoinReview(
              id: 'rev_1',
              title: 'Review room',
              subtitle: 'Daniel',
              detail: '',
              status: common.ReviewStatus.REVIEW_STATUS_PENDING,
              requestedAt: 0,
              reviewedAt: null,
              reviewedBy: null,
              rejectionReason: null,
              requestedRole: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
              roomId: 'room_6',
              userId: 'usr_13',
            ),
          ],
          total: 1,
          page: 1,
          pageSize: 50,
        ),
      );
    }
    return super.noSuchMethod(invocation);
  }
}
