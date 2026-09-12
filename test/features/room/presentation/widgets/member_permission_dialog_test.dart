import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/member_permission_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

import '../../../../test_app.dart';

void main() {
  for (final width in [320.0, 390.0, 834.0]) {
    for (final admin in [false, true]) {
      testWidgets(
        'permission editor fits $width with large text (admin: $admin)',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 568));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          MemberPermissionOverrideResult? result;
          await _open(
            tester,
            admin: admin,
            scale: 1.5,
            onResult: (value) => result = value,
          );
          expect(tester.takeException(), isNull);
          expect(find.text('Save').hitTestable(), findsOneWidget);
          await tester.tap(find.text('Allow').first);
          await tester.pump();
          await tester.tap(find.text('Deny').first);
          await tester.pump();
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();
          expect(result, isNotNull);
          expect(result!.addedPermissions, 0);
          expect(result!.adminAddedPermissions, 0);
          expect(
            result!.removedPermissions,
            admin ? 0 : RoomMemberPermissions.sendChatMessages,
          );
          expect(
            result!.adminRemovedPermissions,
            admin ? RoomAdminPermissions.sendChatMessages : 0,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('clear removes every override and cancel returns no changes', (
    tester,
  ) async {
    MemberPermissionOverrideResult? result;
    await _open(
      tester,
      added: RoomMemberPermissions.all,
      removed: RoomMemberPermissions.viewMembers,
      onResult: (value) => result = value,
    );
    await tester.tap(find.text('Clear overrides'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(result!.addedPermissions, 0);
    expect(result!.removedPermissions, 0);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });
}

Future<void> _open(
  WidgetTester tester, {
  bool admin = false,
  double scale = 1,
  int added = 0,
  int removed = 0,
  required ValueChanged<MemberPermissionOverrideResult?> onResult,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: buildThemedTestApp(context, child),
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => onResult(
              await showAppDialog<MemberPermissionOverrideResult>(
                context: context,
                builder: (_) => MemberPermissionDialog(
                  member: AdminRoomMember(
                    roomId: 'room_test',
                    userId: 'user_test',
                    username: 'Test member',
                    role: admin
                        ? common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN
                        : common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                    permissions: 0,
                    addedPermissions: added,
                    removedPermissions: removed,
                    adminAddedPermissions: 0,
                    adminRemovedPermissions: 0,
                    joinedAt: 0,
                    isOnline: false,
                  ),
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
