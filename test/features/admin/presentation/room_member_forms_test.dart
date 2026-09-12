import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/widgets/add_room_member_dialog.dart';
import 'package:synctv_app/features/admin/presentation/widgets/kick_room_member_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

void main() {
  for (final outcome in ['retry', 'cancel success', 'back failure']) {
    testWidgets('add member validates, preserves draft and handles $outcome', (
      tester,
    ) async {
      final gateway = _Gateway();
      Object? result;
      await _open(
        tester,
        const AddRoomMemberDialog(roomId: 'room'),
        gateway,
        (value) => result = value,
      );
      await tester.tap(find.text('Add'));
      await tester.pump();
      expect(find.text('Enter a user ID'), findsOneWidget);
      expect(gateway.requests, isEmpty);
      await tester.enterText(find.byType(TextField), '  usr_test  ');
      tester
          .widget<AppSelect<common.RoomMemberRole>>(
            find.byType(AppSelect<common.RoomMemberRole>),
          )
          .onChanged!(common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN);
      tester.widget<AppSwitchTile>(find.byType(AppSwitchTile)).onChanged!(
        false,
      );
      await tester.pump();
      final submit = tester
          .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Add'))
          .onPressed!;
      submit();
      submit();
      await tester.pump();
      expect(gateway.requests, hasLength(1));
      expect(gateway.calls.single.positionalArguments, ['room', 'usr_test']);
      expect(
        gateway.calls.single.namedArguments[#role],
        common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
      );
      expect(gateway.calls.single.namedArguments[#notify], isFalse);
      expect(
        tester.widget<AppTextField>(find.byType(AppTextField)).enabled,
        isFalse,
      );
      if (outcome == 'cancel success') {
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        gateway.requests.single.complete();
      } else if (outcome == 'back failure') {
        tester.state<NavigatorState>(find.byType(Navigator)).pop();
        await tester.pump();
        gateway.requests.single.completeError(StateError('late add failure'));
      } else {
        gateway.requests.single.completeError(StateError('add failed'));
      }
      await tester.pumpAndSettle();
      if (outcome == 'retry') {
        expect(find.textContaining('add failed'), findsWidgets);
        expect(
          tester
              .widget<AppTextField>(find.byType(AppTextField))
              .controller
              .text,
          '  usr_test  ',
        );
        expect(
          tester
              .widget<AppSelect<common.RoomMemberRole>>(
                find.byType(AppSelect<common.RoomMemberRole>),
              )
              .value,
          common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        );
        expect(
          tester.widget<AppSwitchTile>(find.byType(AppSwitchTile)).value,
          isFalse,
        );
        await tester.pump(const Duration(seconds: 4));
        await tester.tap(find.text('Add'));
        await tester.pump();
        expect(gateway.requests, hasLength(2));
        gateway.requests.last.complete();
        await tester.pumpAndSettle();
        expect(result, isTrue);
      } else {
        expect(result, outcome == 'cancel success' ? isFalse : isNull);
        expect(find.textContaining('late add failure'), findsNothing);
      }
      expect(find.text('Open'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      expect(tester.takeException(), isNull);
    });
  }

  for (final seconds in ['0', '-1', '2592001', 'bad', '1', '2592000']) {
    testWidgets('kick cooldown validates $seconds at narrow width', (
      tester,
    ) async {
      Object? result;
      await _open(
        tester,
        const KickRoomMemberDialog(),
        _Gateway(),
        (value) => result = value,
      );
      await tester.enterText(find.byType(TextField), seconds);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      if (seconds == '1' || seconds == '2592000') {
        expect(result, int.parse(seconds));
      } else {
        expect(
          find.text('Enter a value from 1 to 2592000 seconds'),
          findsOneWidget,
        );
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(result, isNull);
      }
      expect(find.text('Open'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _open(
  WidgetTester tester,
  Widget dialog,
  AdminGateway gateway,
  ValueChanged<Object?> onResult,
) async {
  await tester.binding.setSurfaceSize(const Size(320, 568));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!,
        ),
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => onResult(
              await showAppDialog<Object>(
                context: context,
                builder: (_) => dialog,
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

class _Gateway implements AdminGateway {
  final requests = <Completer<void>>[];
  final calls = <Invocation>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminAddRoomMember) {
      calls.add(invocation);
      final request = Completer<void>();
      requests.add(request);
      return request.future;
    }
    return super.noSuchMethod(invocation);
  }
}
