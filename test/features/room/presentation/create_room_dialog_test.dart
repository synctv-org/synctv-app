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
    expect(
      find.byKey(const ValueKey('create-room-public-visibility')),
      findsOneWidget,
    );
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
    expect(
      find.byKey(const ValueKey('create-room-public-visibility')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('create-room-password')), findsNothing);
    expect(find.text('Password room'), findsNothing);
  });

  testWidgets('optional password policy keeps password controls independent', (
    tester,
  ) async {
    await _pumpCreateRoomDialog(
      tester,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL,
    );

    expect(find.text('Room visibility'), findsOneWidget);
    expect(find.text('Public room'), findsOneWidget);
    expect(find.text('Password room'), findsOneWidget);
    expect(find.text('No password'), findsOneWidget);
    expect(find.byKey(const ValueKey('create-room-password')), findsNothing);

    await tester.ensureVisible(find.text('Password room'));
    await tester.tap(find.text('Password room'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('create-room-password')), findsOneWidget);
  });

  testWidgets('creates a private room without a password', (tester) async {
    final gateway = await _pumpCreateRoomDialog(
      tester,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL,
      surfaceSize: const Size(800, 1200),
    );

    await tester.enterText(find.byType(TextField).first, 'Private room');
    final visibility = find.byKey(
      const ValueKey('create-room-public-visibility'),
    );
    await tester.ensureVisible(visibility);
    await tester.pumpAndSettle();
    await tester.tap(visibility);
    await tester.pump();
    await tester.tap(find.text('Create room').last);
    await tester.pumpAndSettle();

    expect(gateway.createdPassword, isNull);
    expect(gateway.createdIsPublic, isFalse);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('creates a public password-protected room', (tester) async {
    final gateway = await _pumpCreateRoomDialog(
      tester,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL,
      surfaceSize: const Size(800, 1200),
    );

    await tester.enterText(find.byType(TextField).first, 'Protected room');
    final passwordRoom = find.text('Password room');
    await tester.ensureVisible(passwordRoom);
    await tester.pumpAndSettle();
    await tester.tap(passwordRoom);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('create-room-password')),
      'secret',
    );
    await tester.tap(find.text('Create room').last);
    await tester.pumpAndSettle();

    expect(gateway.createdPassword, 'secret');
    expect(gateway.createdIsPublic, isTrue);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}

Future<_FakeRoomCreationGateway> _pumpCreateRoomDialog(
  WidgetTester tester,
  common.RoomPasswordPolicy passwordPolicy, {
  Size? surfaceSize,
}) async {
  if (surfaceSize != null) {
    tester.view.physicalSize = surfaceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  final gateway = _FakeRoomCreationGateway(_settings(passwordPolicy));
  await tester.pumpWidget(
    DependencyScope<RoomCreationGateway>(
      value: gateway,
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
  return gateway;
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
      rtmpAdvertiseAddress: null,
    );

final class _FakeRoomCreationGateway implements RoomCreationGateway {
  _FakeRoomCreationGateway(this.settings);

  final PublicSettingsInfo settings;
  String? createdPassword;
  bool? createdIsPublic;

  @override
  Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
    bool isPublic = true,
  }) async {
    createdPassword = password;
    createdIsPublic = isPublic;
    return SyncTvRoom(
      roomId: 'room_created',
      roomName: name,
      creatorId: 'user_creator',
      status: common.RoomStatus.ROOM_STATUS_ACTIVE,
      isPublic: isPublic,
      needPassword: password != null,
    );
  }

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
