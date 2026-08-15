import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/room/application/room_creation_gateway.dart';
import 'package:synctv_app/features/room/presentation/create_room_dialog.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

import '../../../test_app.dart';

void main() {
  testWidgets('required password policy directly renders its password field', (
    tester,
  ) async {
    await _pumpCreateRoomDialog(
      tester,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_REQUIRED,
    );

    expect(find.text('Access method'), findsNothing);
    expect(find.byKey(const ValueKey('create-room-password')), findsOneWidget);
    expect(find.text('Password room'), findsNothing);
  });

  testWidgets('forbidden password policy omits the fixed access controls', (
    tester,
  ) async {
    await _pumpCreateRoomDialog(
      tester,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_FORBIDDEN,
    );

    expect(find.text('Access method'), findsNothing);
    expect(find.byKey(const ValueKey('create-room-password')), findsNothing);
    expect(find.text('Password room'), findsNothing);
  });

  testWidgets('optional password policy keeps the access selector', (
    tester,
  ) async {
    await _pumpCreateRoomDialog(
      tester,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL,
    );

    expect(find.text('Access method'), findsOneWidget);
    expect(find.text('Public room'), findsOneWidget);
    expect(find.text('Password room'), findsOneWidget);
    expect(find.byKey(const ValueKey('create-room-password')), findsNothing);

    await tester.ensureVisible(find.text('Password room'));
    await tester.tap(find.text('Password room'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('create-room-password')), findsOneWidget);
  });
}

Future<void> _pumpCreateRoomDialog(
  WidgetTester tester,
  common.RoomPasswordPolicy passwordPolicy,
) async {
  await tester.pumpWidget(
    DependencyScope<RoomCreationGateway>(
      value: _FakeRoomCreationGateway(_settings(passwordPolicy)),
      child: MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showCreateRoomDialog(
                context: context,
                onCreated: (_) async {},
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

PublicSettingsInfo _settings(common.RoomPasswordPolicy passwordPolicy) =>
    PublicSettingsInfo(
      roomCreationEnabled: true,
      maxRoomsPerUser: 10,
      defaultMaxMembers: 100,
      roomCreationApprovalRequired: false,
      roomPasswordPolicy: passwordPolicy,
      enablePasswordSignup: true,
      passwordSignupNeedReview: false,
      enableEmailSignup: true,
      enableEmail: true,
      enableGuest: true,
      emailSignupNeedReview: false,
      enableWebauthn: false,
      webauthnRpId: '',
      enableWebauthnSignup: false,
      webauthnSignupNeedReview: false,
      emailWhitelistEnabled: false,
      emailWhitelistDomains: const [],
      tsDisguisedAsPng: false,
      customPublishHost: null,
    );

final class _FakeRoomCreationGateway implements RoomCreationGateway {
  const _FakeRoomCreationGateway(this.settings);

  final PublicSettingsInfo settings;

  @override
  Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
  }) => Future<SyncTvRoom>.error(UnimplementedError());

  @override
  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false}) async =>
      settings;

  @override
  Future<List<RoomCategoryInfo>> listCategories({bool refresh = false}) async =>
      const [];

  @override
  Future<List<RoomLabelInfo>> listLabels({bool refresh = false}) async =>
      const [];
}
