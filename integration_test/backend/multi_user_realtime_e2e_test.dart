// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/features/room/application/room_realtime_channel.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/data/room_realtime_connection.dart';
import 'package:synctv_app/features/room/data/synctv_room_session_gateway.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

import 'local_backend_test_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test(
    'multi-user realtime permissions, kick, and ban',
    () async {
      const baseUrl = String.fromEnvironment('SYNCTV_E2E_BASE_URL');
      const rootPassword = String.fromEnvironment('SYNCTV_E2E_ROOT_PASSWORD');
      const allowInsecureTls = bool.fromEnvironment(
        'SYNCTV_E2E_ALLOW_INSECURE_TLS',
      );
      const retainFixture = bool.fromEnvironment('SYNCTV_E2E_RETAIN_FIXTURE');
      if (baseUrl.isEmpty || rootPassword.isEmpty) {
        throw StateError(
          'SYNCTV_E2E_BASE_URL and SYNCTV_E2E_ROOT_PASSWORD are required',
        );
      }

      final stamp = DateTime.now().microsecondsSinceEpoch;
      final owner = _UserSeed('e2e_owner_$stamp', 'E2eOwner-$stamp-aA!');
      final member = _UserSeed('e2e_member_$stamp', 'E2eMember-$stamp-aA!');
      final viewer = _UserSeed('e2e_viewer_$stamp', 'E2eViewer-$stamp-aA!');
      final probes = <_ChannelProbe>[];
      String? roomId;

      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.addServer(
        baseUrl,
        allowInsecureTls: allowInsecureTls,
      );

      try {
        await _loginRoot(rootPassword);
        final rootId = (await SyncTvService.getMe(refresh: true)).id;
        final memberId = await _createUser(member);
        final viewerId = await _createUser(viewer);
        await _createUser(owner);

        await _login(owner);
        final room = await SyncTvService.createRoom(
          'Multi-user UI $stamp',
          description: 'Automated multi-user realtime frontend scenario',
        );
        roomId = room.roomId;
        await SyncTvService.addRoomMember(
          roomId,
          rootId,
          role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          notify: false,
        );
        await SyncTvService.addRoomMember(roomId, memberId, notify: false);
        await SyncTvService.addRoomMember(roomId, viewerId, notify: false);
        final preview = await SyncTvService.prepareDirectUrl(
          provider_common.PrepareDirectUrlRequest(
            url:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
          ),
        );
        final mediaId = await SyncTvService.addDiscoveredSource(
          roomId,
          source: preview.source,
          name: 'Multi-user bee',
        );
        await SyncTvService.switchMedia(roomId, mediaId);
        await SyncTvService.updatePlaybackState(
          roomId,
          isPlaying: true,
          position: 2,
        );

        await _login(member);
        final memberProbe = await _connectProbe('member', roomId);
        probes.add(memberProbe);
        await memberProbe.waitFor(
          (message) => message.kind == RoomRealtimeMessageKind.myStatus,
          'member self-room-member snapshot',
        );

        await _login(viewer);
        final viewerProbe = await _connectProbe('viewer', roomId);
        probes.add(viewerProbe);
        await viewerProbe.waitFor(
          (message) => message.kind == RoomRealtimeMessageKind.myStatus,
          'viewer self-room-member snapshot',
        );
        await memberProbe.waitUntil(
          () => memberProbe.playbackMessageCount > 0,
          'member initial playback snapshot',
        );
        await viewerProbe.waitUntil(
          () => viewerProbe.playbackMessageCount > 0,
          'viewer initial playback snapshot',
        );

        await _loginRoot(rootPassword);
        final removedPermissions = RoomMemberPermissions.all;
        final removedEffectivePermissions =
            RoomEffectivePermissions.sendChatMessages |
            RoomEffectivePermissions.manageOwnMedia |
            RoomEffectivePermissions.browseLibrary |
            RoomEffectivePermissions.viewMembers |
            RoomEffectivePermissions.viewChatHistory |
            RoomEffectivePermissions.useVoiceChat |
            RoomEffectivePermissions.useP2pMedia;
        final beforeMemberBaseline = memberProbe.messages.length;
        await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
          roomId,
          memberId,
          role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
          addedPermissions: RoomMemberPermissions.all,
        );
        final memberBaseline = await memberProbe.waitFor(
          (message) =>
              message.kind == RoomRealtimeMessageKind.myStatus &&
              message.selfMember != null,
          'member permission baseline',
          after: beforeMemberBaseline,
        );
        expect(
          memberBaseline.selfMember!.permissions & removedEffectivePermissions,
          removedEffectivePermissions,
        );
        final beforeRestriction = memberProbe.messages.length;
        await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
          roomId,
          memberId,
          role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
          removedPermissions: removedPermissions,
        );
        final restricted = await memberProbe.waitFor(
          (message) =>
              message.kind == RoomRealtimeMessageKind.myStatus &&
              message.selfMember != null,
          'restricted member permission snapshot',
          after: beforeRestriction,
        );
        expect(
          restricted.selfMember!.permissions & removedEffectivePermissions,
          0,
        );
        print('restricted_permissions=${restricted.selfMember!.permissions}');

        final beforeRestore = memberProbe.messages.length;
        await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
          roomId,
          memberId,
          role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
          addedPermissions: RoomMemberPermissions.all,
        );
        final restored = await memberProbe.waitFor(
          (message) =>
              message.kind == RoomRealtimeMessageKind.myStatus &&
              message.selfMember != null,
          'restored member permission snapshot',
          after: beforeRestore,
        );
        expect(
          restored.selfMember!.permissions & removedEffectivePermissions,
          removedEffectivePermissions,
        );
        print('restored_permissions=${restored.selfMember!.permissions}');

        final removedAdminPermissions =
            RoomAdminPermissions.controlPlaybackState |
            RoomAdminPermissions.navigatePlayback |
            RoomAdminPermissions.removeMembers |
            RoomAdminPermissions.manageMemberPermissions |
            RoomAdminPermissions.manageRoomSettings |
            RoomAdminPermissions.viewPlaybackHistory;
        final beforeAdminRestriction = memberProbe.messages.length;
        await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
          roomId,
          memberId,
          role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          adminRemovedPermissions: removedAdminPermissions,
        );
        final restrictedAdmin = await memberProbe.waitFor(
          (message) =>
              message.kind == RoomRealtimeMessageKind.myStatus &&
              message.selfMember != null,
          'restricted administrator permission snapshot',
          after: beforeAdminRestriction,
        );
        expect(
          restrictedAdmin.selfMember!.role,
          common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        );
        expect(
          restrictedAdmin.selfMember!.permissions & removedAdminPermissions,
          0,
        );
        print(
          'restricted_admin_permissions='
          '${restrictedAdmin.selfMember!.permissions}',
        );
        final beforeAdminRestore = memberProbe.messages.length;
        await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
          roomId,
          memberId,
          role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          adminAddedPermissions: removedAdminPermissions,
        );
        final restoredAdmin = await memberProbe.waitFor(
          (message) =>
              message.kind == RoomRealtimeMessageKind.myStatus &&
              message.selfMember != null,
          'restored administrator permission snapshot',
          after: beforeAdminRestore,
        );
        expect(
          restoredAdmin.selfMember!.role,
          common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        );
        expect(
          restoredAdmin.selfMember!.permissions & removedAdminPermissions,
          removedAdminPermissions,
        );
        print(
          'restored_admin_permissions=${restoredAdmin.selfMember!.permissions}',
        );
        final persistedMember = (await SyncTvService.adminListRoomMembersPage(
          roomId,
          search: member.username,
        )).members.singleWhere((item) => item.userId == memberId);
        expect(
          persistedMember.adminAddedPermissions & removedAdminPermissions,
          removedAdminPermissions,
        );
        print(
          'persisted_admin_added_permissions='
          '${persistedMember.adminAddedPermissions}',
        );

        if (retainFixture) {
          await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
            roomId,
            memberId,
            role: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
            addedPermissions: RoomMemberPermissions.all,
          );
          print('E2E_FIXTURE_ROOM_ID=$roomId');
          print('E2E_FIXTURE_OWNER_USERNAME=${owner.username}');
          print('E2E_FIXTURE_MEMBER_USERNAME=${member.username}');
          print('E2E_FIXTURE_VIEWER_USERNAME=${viewer.username}');
          return;
        }

        final memberPlaybackCount = memberProbe.playbackMessageCount;
        final viewerPlaybackCount = viewerProbe.playbackMessageCount;
        await SyncTvService.updatePlaybackState(
          roomId,
          isPlaying: false,
          position: 4,
        );
        await memberProbe.waitUntil(
          () => memberProbe.playbackMessageCount > memberPlaybackCount,
          'member playback update',
        );
        await viewerProbe.waitUntil(
          () => viewerProbe.playbackMessageCount > viewerPlaybackCount,
          'viewer playback update',
        );

        await SyncTvService.adminKickRoomMember(
          roomId,
          memberId,
          kickCooldownSeconds: 2,
        );
        await memberProbe.waitForTerminalSignal('member kick');

        final viewerPlaybackAfterKick = viewerProbe.playbackMessageCount;
        await SyncTvService.updatePlaybackState(
          roomId,
          isPlaying: true,
          position: 5,
        );
        await viewerProbe.waitUntil(
          () => viewerProbe.playbackMessageCount > viewerPlaybackAfterKick,
          'viewer playback after member kick',
        );

        await SyncTvService.adminBanUser(
          viewerId,
          true,
          reason: 'multi-user realtime test',
        );
        await viewerProbe.waitForTerminalSignal('viewer ban');
        await SyncTvService.adminBanUser(viewerId, false);

        print('OK_MULTI_USER_REALTIME_E2E');
      } finally {
        for (final probe in probes) {
          await probe.close();
        }
        var canCleanup = false;
        try {
          await _loginRoot(rootPassword);
          canCleanup = true;
        } catch (_) {
          // The primary failure remains authoritative when cleanup cannot log in.
        }
        if (!retainFixture && canCleanup && roomId != null) {
          try {
            await SyncTvService.adminDeleteRoom(roomId);
          } catch (_) {
            // Best-effort cleanup keeps the primary test failure visible.
          }
        }
        for (final seed
            in !retainFixture && canCleanup
                ? [owner, member, viewer]
                : const <_UserSeed>[]) {
          List<SyncTvUser> users;
          try {
            users = (await SyncTvService.adminListUsersPage(
              pageSize: 20,
              search: seed.username,
            )).users;
          } catch (_) {
            continue;
          }
          for (final user in users) {
            if (user.username == seed.username) {
              try {
                await SyncTvService.adminBanUser(user.id, false);
                await SyncTvService.adminDeleteUser(user.id);
              } catch (_) {
                // Best-effort cleanup keeps the primary test failure visible.
              }
            }
          }
        }
      }
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}

Future<String> _createUser(_UserSeed seed) async {
  await SyncTvService.adminAddUser(
    seed.username,
    seed.password,
    common_enum.UserRole.USER_ROLE_USER,
  );
  final page = await SyncTvService.adminListUsersPage(
    pageSize: 20,
    search: seed.username,
  );
  return page.users.singleWhere((user) => user.username == seed.username).id;
}

Future<void> _login(_UserSeed seed) async {
  try {
    await SyncTvService.logout();
  } catch (_) {
    // A fresh login below replaces any expired session.
  }
  await _retryRateLimited(
    () => loginLocalPasswordUser(seed.username, seed.password),
    'login user',
  );
}

Future<void> _loginRoot(String password) async {
  try {
    await SyncTvService.logout();
  } catch (_) {
    // A fresh login below replaces any expired session.
  }
  await _retryRateLimited(() => loginLocalRoot(password), 'login root');
}

Future<T> _retryRateLimited<T>(
  Future<T> Function() action,
  String label, {
  int maxAttempts = 3,
}) async {
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await action();
    } on SyncTvApiException catch (error) {
      if (error.statusCode != 429 || attempt == maxAttempts) rethrow;
      final seconds = _rateLimitDelaySeconds(error.message);
      print('$label rate limited; waiting ${seconds}s (attempt $attempt)');
      await Future<void>.delayed(Duration(seconds: seconds));
    }
  }
  throw StateError('$label retry loop exhausted');
}

int _rateLimitDelaySeconds(String message) {
  final match = RegExp(r'(\d+)s').firstMatch(message);
  final parsed = match == null ? null : int.tryParse(match.group(1)!);
  return (parsed ?? 10).clamp(1, 60);
}

Future<_ChannelProbe> _connectProbe(String label, String roomId) async {
  final channel =
      const IoRoomRealtimeChannelFactory(
        sessionGateway: SyncTvRoomSessionGateway(),
      ).connect(
        roomId,
        initialMessages: RoomRealtimeCodec.encodeInitialObservations(),
      );
  final probe = _ChannelProbe(label, channel);
  await channel.ready;
  return probe;
}

final class _ChannelProbe {
  _ChannelProbe(this.label, this.channel) {
    _subscription = channel.stream.listen(
      (data) {
        final message = RoomRealtimeCodec.decode(data);
        messages.add(message);
        _updates.add(null);
      },
      onError: (Object error, StackTrace stackTrace) {
        errors.add(error);
        if (!_terminal.isCompleted) _terminal.complete();
        _updates.add(null);
      },
      onDone: () {
        done = true;
        if (!_terminal.isCompleted) _terminal.complete();
        _updates.add(null);
      },
    );
  }

  final String label;
  final RoomRealtimeChannel channel;
  final List<RoomRealtimeMessage> messages = [];
  final List<Object> errors = [];
  final StreamController<void> _updates = StreamController<void>.broadcast();
  final Completer<void> _terminal = Completer<void>();
  late final StreamSubscription<Uint8List> _subscription;
  bool done = false;

  int get playbackMessageCount => messages
      .where(
        (message) =>
            message.playbackStatus != null ||
            message.kind == RoomRealtimeMessageKind.status,
      )
      .length;

  Future<RoomRealtimeMessage> waitFor(
    bool Function(RoomRealtimeMessage message) predicate,
    String description, {
    int after = 0,
  }) async {
    RoomRealtimeMessage? match() =>
        messages.skip(after).where(predicate).lastOrNull;
    final existing = match();
    if (existing != null) return existing;
    await waitUntil(() => match() != null, description);
    return match()!;
  }

  Future<void> waitUntil(bool Function() predicate, String description) async {
    if (predicate()) return;
    await _updates.stream
        .firstWhere((_) => predicate())
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw TimeoutException(
            '$label timed out waiting for $description; '
            'kinds=${messages.map((item) => item.kind.name).toList()} '
            'self=${messages.where((item) => item.selfMember != null).map((item) => '${item.selfMember!.role}:${item.selfMember!.permissions}').toList()} '
            'errors=$errors done=$done',
          ),
        );
  }

  Future<void> waitForTerminalSignal(String description) async {
    if (!_terminal.isCompleted) {
      await _terminal.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException(
          '$label did not terminate after $description; '
          'kinds=${messages.map((item) => item.kind.name).toList()} '
          'errors=$errors',
        ),
      );
    }
    print(
      '$label terminal after $description: done=$done errors=$errors '
      'kinds=${messages.map((item) => item.kind.name).toList()}',
    );
  }

  Future<void> close() async {
    try {
      await _subscription.cancel();
    } catch (_) {
      // The peer may already have terminated the subscription.
    }
    try {
      await channel.close();
    } catch (_) {
      // The peer may already have terminated the socket.
    }
    await _updates.close();
  }
}

final class _UserSeed {
  const _UserSeed(this.username, this.password);

  final String username;
  final String password;
}
