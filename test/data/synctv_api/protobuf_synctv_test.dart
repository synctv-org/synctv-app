import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_chat_manager.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/playback_client_profile.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/providers/presentation/binding/bilibili_geetest_flow.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_config.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';
import 'package:synctv_app/features/auth/infrastructure/oauth2_callback_service.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_auth_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_admin_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_public_room_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_management_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_media_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pb.dart' as common_pb;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/oauth2.pb.dart' as oauth2;
import 'package:synctv_app/src/generated/proto/passkey.pb.dart' as passkey;
import 'package:synctv_app/src/generated/proto/passkey.pbenum.dart'
    as passkey_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/src/generated/proto/providers/alist.pb.dart'
    as alist;
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/cloudreve.pb.dart'
    as cloudreve;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/emby.pb.dart' as emby;
import 'package:synctv_app/features/room/presentation/playback_danmaku.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/features/room/domain/chat_reactions.dart';
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

client.ProviderTarget testProviderTarget(String relativePath) {
  return client.ProviderTarget(
    alist: client.AlistTarget(relativePath: relativePath),
  );
}

Map<String, dynamic> testProviderTargetJson(client.ProviderTarget target) {
  return providerTargetToJson(target);
}

String testProviderTargetToken(client.ProviderTarget target) {
  return providerTargetToBase64(target);
}

String testBytesJson(String value) => base64Encode(utf8.encode(value));

Map<String, Object> testActiveServerPreferences({
  required String baseUrl,
  String accessToken = 'token',
  String refreshToken = '',
}) {
  return {
    SyncTvSessionStore.serversKey: jsonEncode([
      {
        'declared_server_id': 'srv_test',
        'name': 'Test Server',
        'endpoint': baseUrl,
        'session': {
          'kind': 'account',
          if (accessToken.isNotEmpty) 'access_token': accessToken,
          if (refreshToken.isNotEmpty) 'refresh_token': refreshToken,
        },
      },
    ]),
    SyncTvSessionStore.activeServerKey: baseUrl,
  };
}

Map<String, dynamic> testPasskeyRequestOptions({
  required String challenge,
  String rpId = '',
  List<Map<String, dynamic>> allowCredentials = const [],
}) {
  return {
    'publicKey': {
      'challenge': testBytesJson(challenge),
      if (rpId.isNotEmpty) 'rpId': rpId,
      if (allowCredentials.isNotEmpty) 'allowCredentials': allowCredentials,
    },
  };
}

String testBytesBase64Url(String value) =>
    base64UrlEncode(utf8.encode(value)).replaceAll('=', '');

Map<String, dynamic> testPasskeyCreationOptions({
  required String challenge,
  required String userId,
  required String username,
}) {
  return {
    'publicKey': {
      'challenge': testBytesJson(challenge),
      'user': {'id': testBytesJson(userId), 'name': username},
    },
  };
}

passkey.PasskeyAuthenticationCredential testPasskeyAuthenticationCredential(
  String id,
) {
  return passkeyAuthenticationCredentialFromJson({
    'id': id,
    'rawId': testBytesBase64Url(id),
    'type': 'public-key',
    'response': {
      'authenticatorData': testBytesBase64Url('auth-data'),
      'clientDataJSON': testBytesBase64Url('{}'),
      'signature': testBytesBase64Url('sig'),
      'userHandle': testBytesBase64Url('usr_1'),
    },
    'clientExtensionResults': <String, dynamic>{},
  });
}

passkey.PasskeyRegistrationCredential testPasskeyRegistrationCredential(
  String id,
) {
  return passkeyRegistrationCredentialFromJson({
    'id': id,
    'rawId': testBytesBase64Url(id),
    'type': 'public-key',
    'response': {
      'attestationObject': testBytesBase64Url('attestation'),
      'clientDataJSON': testBytesBase64Url('{}'),
      'transports': ['internal'],
    },
    'clientExtensionResults': <String, dynamic>{},
  });
}

void main() {
  test('TOTP MFA facades send protobuf JSON and store login tokens', () async {
    final requests = <http.Request>[];
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: session,
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'accessToken': 'access-${requests.length}',
            'refreshToken': 'refresh-${requests.length}',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.auth.verifyMfaTotp(
      client.VerifyMfaTotpRequest(mfaSessionId: 'mfa-session', code: '123456'),
    );
    await api.auth.verifyMfaRecoveryCode(
      client.VerifyMfaRecoveryCodeRequest(
        mfaSessionId: 'mfa-session-2',
        recoveryCode: 'ABCD-EFGH-JKLM',
      ),
    );

    expect(requests.map((request) => request.method), ['POST', 'POST']);
    expect(requests.map((request) => request.url.path), [
      '/api/auth/mfa/totp/verify',
      '/api/auth/mfa/recovery-code/verify',
    ]);
    expect(jsonDecode(requests[0].body), {
      'mfaSessionId': 'mfa-session',
      'code': '123456',
    });
    expect(jsonDecode(requests[1].body), {
      'mfaSessionId': 'mfa-session-2',
      'recoveryCode': 'ABCD-EFGH-JKLM',
    });
    expect(session.accessToken, 'access-2');
    expect(session.refreshToken, 'refresh-2');
  });

  test(
    'TOTP account facades cover setup recovery codes and deletion',
    () async {
      final requests = <http.Request>[];
      final session = SyncTvSession()
        ..updateAccountTokens(accessToken: 'account-token');
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: session,
        httpClient: MockClient((request) async {
          requests.add(request);
          final response = switch (request.url.path) {
            '/api/user/totp/setup/start' => {
              'setupId': 'setup-id',
              'secret': 'JBSWY3DPEHPK3PXP',
              'otpauthUri': 'otpauth://totp/SyncTV:test',
              'expiresAt': '1700000000',
            },
            '/api/user/totp/setup/finish' => {
              'recoveryCodes': ['CODE-ONE1-TEST'],
            },
            '/api/user/totp/recovery-codes/regenerate' => {
              'recoveryCodes': ['CODE-TWO2-TEST'],
            },
            '/api/user/totp' => {'deleted': true},
            _ => throw StateError('Unexpected TOTP path ${request.url.path}'),
          };
          return http.Response(
            jsonEncode(response),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final setup = await api.user.startTotpSetup(
        client.StartTotpSetupRequest(verificationId: 'verification-1'),
      );
      final confirmed = await api.user.finishTotpSetup(
        client.FinishTotpSetupRequest(setupId: setup.setupId, code: '123456'),
      );
      final regenerated = await api.user.regenerateTotpRecoveryCodes(
        client.RegenerateTotpRecoveryCodesRequest(
          verificationId: 'verification-2',
        ),
      );
      final deleted = await api.user.deleteTotp(
        client.DeleteTotpRequest(verificationId: 'verification-3'),
      );

      expect(setup.secret, 'JBSWY3DPEHPK3PXP');
      expect(setup.expiresAt.toInt(), 1700000000);
      expect(confirmed.recoveryCodes, ['CODE-ONE1-TEST']);
      expect(regenerated.recoveryCodes, ['CODE-TWO2-TEST']);
      expect(deleted.deleted, isTrue);
      expect(
        requests.map((request) => '${request.method} ${request.url.path}'),
        [
          'POST /api/user/totp/setup/start',
          'POST /api/user/totp/setup/finish',
          'POST /api/user/totp/recovery-codes/regenerate',
          'DELETE /api/user/totp',
        ],
      );
      expect(
        requests.every(
          (request) =>
              request.headers['authorization'] == 'Bearer account-token',
        ),
        isTrue,
      );
      expect(jsonDecode(requests[0].body), {
        'verificationId': 'verification-1',
      });
      expect(jsonDecode(requests[1].body), {
        'setupId': 'setup-id',
        'code': '123456',
      });
      expect(jsonDecode(requests[2].body), {
        'verificationId': 'verification-2',
      });
      expect(jsonDecode(requests[3].body), {
        'verificationId': 'verification-3',
      });
    },
  );

  test('empty HTTP error responses retain their status code', () async {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession(),
      httpClient: MockClient((_) async => http.Response('', 429)),
    );

    await expectLater(
      api.auth.loginWithDirectPassword(
        client.LoginWithDirectPasswordRequest(
          loginSessionId: 'login-session',
          password: 'password',
        ),
      ),
      throwsA(
        isA<SyncTvApiException>()
            .having((error) => error.statusCode, 'statusCode', 429)
            .having((error) => error.message, 'message', 'HTTP 429')
            .having((error) => error.requestMethod, 'requestMethod', 'POST')
            .having(
              (error) => error.requestUri?.path,
              'requestUri.path',
              '/api/auth/direct-password/login',
            )
            .having(
              (error) => error.toString(),
              'toString',
              'POST /api/auth/direct-password/login: HTTP 429',
            ),
      ),
    );
  });

  test('Cloudreve media source config round trips through protobuf', () {
    final config = SourceConfigCodec.mediaSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
      sourceConfig: {
        'serverId': 'cloudreve-server',
        'path': 'cloudreve://my/Movies/movie.mp4',
      },
    );

    expect(config, isNotNull);
    expect(
      SourceConfigCodec.providerForMediaSourceConfig(config!),
      source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
    );
    expect(SourceConfigCodec.mediaSourceConfigToMap(config), {
      'serverId': 'cloudreve-server',
      'path': 'cloudreve://my/Movies/movie.mp4',
    });
    expect(
      SourceConfigCodec.providerFromString('cloudreve'),
      source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
    );
  });

  test('Cloudreve dynamic playlist config and target round trip', () {
    final config = SourceConfigCodec.playlistSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
      sourceConfig: {
        'serverId': 'cloudreve-server',
        'path': 'cloudreve://my/Shows',
      },
    );
    expect(config, isNotNull);
    expect(
      SourceConfigCodec.providerForPlaylistSourceConfig(config!),
      source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
    );
    expect(SourceConfigCodec.playlistSourceConfigToMap(config), {
      'serverId': 'cloudreve-server',
      'path': 'cloudreve://my/Shows',
    });

    final target = client.ProviderTarget(
      cloudreve: client.CloudreveTarget(
        relativePath: '/Season 1/Episode 1.mp4',
      ),
    );
    final encoded = providerTargetToBase64(target);
    final decoded = providerTargetFromBase64(encoded);
    expect(decoded.whichTarget(), client.ProviderTarget_Target.cloudreve);
    expect(decoded.cloudreve.relativePath, '/Season 1/Episode 1.mp4');
  });

  test('Cloudreve list pagination preserves page and cursor modes', () {
    final pageRequest = cloudreve.ListRequest(
      serverId: 'cloudreve-server',
      path: '/Movies',
      page: cloudreve.PagePagination(page: 3),
      perPage: 20,
    );
    final cursorRequest = cloudreve.ListRequest(
      serverId: 'cloudreve-server',
      path: '/Movies',
      cursor: cloudreve.CursorPagination(cursor: 'cursor-3'),
      perPage: 20,
    );

    expect(
      cloudreve.ListRequest.fromBuffer(
        pageRequest.writeToBuffer(),
      ).whichPagination(),
      cloudreve.ListRequest_Pagination.page,
    );
    expect(
      cloudreve.ListRequest.fromBuffer(
        cursorRequest.writeToBuffer(),
      ).whichPagination(),
      cloudreve.ListRequest_Pagination.cursor,
    );

    final pageResponse = cloudreve.ListResponse(
      page: cloudreve.PagePagination(page: 3, total: Int64(45)),
    );
    final cursorResponse = cloudreve.ListResponse(
      cursor: cloudreve.CursorPagination(cursor: 'cursor-4'),
    );
    expect(
      pageResponse.whichPagination(),
      cloudreve.ListResponse_Pagination.page,
    );
    expect(pageResponse.page.total, Int64(45));
    expect(
      cursorResponse.whichPagination(),
      cloudreve.ListResponse_Pagination.cursor,
    );
    expect(cursorResponse.cursor.cursor, 'cursor-4');
  });

  test('Twitch media source configs preserve each resource kind', () {
    for (final entry in [
      ('live', 'channel', 'synctv'),
      ('video', 'videoId', '123456'),
      ('clip', 'slug', 'ClipSlug'),
    ]) {
      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
        sourceConfig: {'kind': entry.$1, entry.$2: entry.$3, 'shared': true},
      );
      expect(config, isNotNull);
      expect(
        SourceConfigCodec.providerForMediaSourceConfig(config!),
        source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
      );
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), {
        'kind': entry.$1,
        entry.$2: entry.$3,
        'shared': true,
      });
    }
  });

  test('Huya media source configs preserve live and video resources', () {
    for (final entry in [
      ('live', 'roomId', '660000'),
      ('video', 'videoId', '1002412640'),
    ]) {
      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
        sourceConfig: {'kind': entry.$1, entry.$2: entry.$3},
      );
      expect(config, isNotNull);
      expect(
        SourceConfigCodec.providerForMediaSourceConfig(config!),
        source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
      );
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), {
        'kind': entry.$1,
        entry.$2: entry.$3,
      });
    }
    expect(
      SourceConfigCodec.providerFromString('huya'),
      source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
    );
  });

  test('Douyu media source config preserves room aliases', () {
    final config = SourceConfigCodec.mediaSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
      sourceConfig: const {'room': 'some_room'},
    );
    expect(config, isNotNull);
    expect(
      SourceConfigCodec.providerForMediaSourceConfig(config!),
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
    );
    expect(SourceConfigCodec.mediaSourceConfigToMap(config), {
      'room': 'some_room',
    });
    expect(
      SourceConfigCodec.providerFromString('douyu'),
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
    );
  });

  test('AcFun media source configs preserve provider-specific fields', () {
    for (final sourceConfig in [
      const {'kind': 'video', 'videoId': 'ac123_2'},
      const {
        'kind': 'bangumi',
        'bangumiId': 'aa5023171_36188_1750645',
        'episodeQuery': 'ac=2',
      },
      const {'kind': 'live', 'authorId': '265502'},
    ]) {
      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
        sourceConfig: sourceConfig,
      );
      expect(config, isNotNull);
      expect(
        SourceConfigCodec.providerForMediaSourceConfig(config!),
        source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
      );
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), sourceConfig);
    }
    expect(
      SourceConfigCodec.providerFromString('acfun'),
      source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
    );
  });

  test('CCTV media source config preserves its resource', () {
    const sourceConfig = {
      'resource': 'https://news.cctv.com/2024/02/21/ARTIexample.shtml',
    };
    final config = SourceConfigCodec.mediaSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_CCTV,
      sourceConfig: sourceConfig,
    );

    expect(config, isNotNull);
    expect(
      SourceConfigCodec.providerForMediaSourceConfig(config!),
      source_enum.SourceProvider.SOURCE_PROVIDER_CCTV,
    );
    expect(SourceConfigCodec.mediaSourceConfigToMap(config), sourceConfig);
    expect(
      SourceConfigCodec.providerFromString('cctv'),
      source_enum.SourceProvider.SOURCE_PROVIDER_CCTV,
    );
  });

  test('Twitch dynamic playlist and typed target round trip', () {
    final config = SourceConfigCodec.playlistSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
      sourceConfig: {
        'kind': 'channel',
        'channel': 'synctv',
        'content': 'highlights',
        'shared': true,
      },
    );
    expect(config, isNotNull);
    expect(
      SourceConfigCodec.providerForPlaylistSourceConfig(config!),
      source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
    );
    expect(SourceConfigCodec.playlistSourceConfigToMap(config), {
      'kind': 'channel',
      'channel': 'synctv',
      'content': 'highlights',
      'shared': true,
    });

    final target = client.ProviderTarget(
      twitch: client.TwitchTarget(
        kind: client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_CLIP,
        id: 'ClipSlug',
      ),
    );
    final decoded = providerTargetFromBase64(providerTargetToBase64(target));
    expect(decoded.whichTarget(), client.ProviderTarget_Target.twitch);
    expect(
      decoded.twitch.kind,
      client_enum.TwitchTargetKind.TWITCH_TARGET_KIND_CLIP,
    );
    expect(decoded.twitch.id, 'ClipSlug');
  });

  test('unset source configs use the unspecified provider', () {
    expect(
      SourceConfigCodec.providerForMediaSourceConfig(
        source_config.MediaSourceConfig(),
      ),
      source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    );
    expect(
      SourceConfigCodec.providerForPlaylistSourceConfig(
        source_config.PlaylistSourceConfig(),
      ),
      source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    );
  });

  test('playback status derives current position from generated time', () {
    final status = SyncTvPlaybackStatus(
      isPlaying: true,
      currentTime: 10,
      playbackRate: 1.5,
      generatedAtMillis: 1_000,
    );

    expect(
      status.derivedCurrentTime(
        now: DateTime.fromMillisecondsSinceEpoch(3_000),
      ),
      13,
    );
  });

  test('paused playback status keeps anchor position', () {
    final status = SyncTvPlaybackStatus(
      isPlaying: false,
      currentTime: 10,
      playbackRate: 2,
      generatedAtMillis: 1_000,
    );

    expect(
      status.derivedCurrentTime(
        now: DateTime.fromMillisecondsSinceEpoch(5_000),
      ),
      10,
    );
  });

  test(
    'public settings derive user-facing auth policy hints from protobuf fields',
    () {
      const settings = PublicSettingsInfo(
        roomCreationEnabled: true,
        maxRoomsPerUser: 3,
        defaultMaxMembers: 12,
        roomCreationApprovalRequired: true,
        roomPasswordPolicy:
            common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_REQUIRED,
        enablePasswordSignup: true,
        passwordSignupNeedReview: true,
        enableEmailSignup: true,
        enableEmail: true,
        enableGuest: false,
        emailSignupNeedReview: true,
        enableWebauthn: true,
        webauthnRpId: 'example.com',
        enableWebauthnSignup: true,
        webauthnSignupNeedReview: true,
        emailWhitelistEnabled: true,
        emailWhitelistDomains: ['example.com'],
        tsDisguisedAsPng: true,
        customPublishHost: 'rtmp://publish.example.test/app',
      );

      expect(settings.authPolicyHints, [
        '密码注册需要管理员审核',
        '邮箱注册需要管理员审核',
        'Passkey 注册需要管理员审核',
        '服务器启用了邮箱白名单，注册邮箱需要在白名单内',
        '访客访问未启用',
      ]);
    },
  );

  test('protobuf watch events preserve typed resource payloads', () {
    final observedJson = jsonDecode('''
      {
        "observed": {
          "observeId": "playback-state",
          "changed": true,
          "eventCursor": {"sequence": "42"}
        }
      }
    ''');
    final observed = client.WatchPlaybackStateEvent()
      ..mergeFromProto3Json(
        observedJson,
        supportNamesWithUnderscores: false,
        permissiveEnums: true,
        ignoreUnknownFields: true,
      );

    expect(observed.hasObserved(), isTrue);
    expect(observed.observed.eventCursor.sequence.toInt(), 42);
    expect(observed.observed.changed, isTrue);

    final changedJson = jsonDecode('''
      {
        "resourceEvent": {
          "observeId": "playback-state",
          "eventCursor": {"sequence": "43"},
          "playbackState": {
            "roomId": "room_abc",
            "playingMediaId": "med_abc",
            "position": 12.5,
            "speed": 1.25,
            "isPlaying": true,
            "version": "7"
          }
        }
      }
    ''');
    final changed = client.WatchPlaybackStateEvent()
      ..mergeFromProto3Json(
        changedJson,
        supportNamesWithUnderscores: false,
        permissiveEnums: true,
        ignoreUnknownFields: true,
      );

    expect(changed.hasResourceEvent(), isTrue);
    expect(changed.resourceEvent.eventCursor.sequence.toInt(), 43);
    expect(changed.resourceEvent.hasPlaybackState(), isTrue);
    expect(changed.resourceEvent.playbackState.position, 12.5);
    expect(changed.resourceEvent.playbackState.speed, 1.25);
    expect(changed.resourceEvent.playbackState.isPlaying, isTrue);
  });

  test('realtime event log displays protobuf JSON payloads', () {
    final heartbeat = client.ClientMessage(
      heartbeat: client.HeartbeatMessage(timestamp: Int64(1781248744)),
    ).writeToBuffer();
    final outgoing = RoomRealtimeCodec.describeOutgoing(heartbeat);
    expect(outgoing.payload, {
      'heartbeat': {'timestamp': '1781248744'},
    });

    final joined = client.ServerMessage(
      resourceEvent: client.ResourceEvent(
        observeId: 'room_member_events',
        roomMemberEvent: client.RoomMemberEvent(
          eventId: 'evt_member_1',
          roomId: 'room_140',
          kind: client.RoomMemberEventKind.ROOM_MEMBER_EVENT_KIND_JOINED,
          member: common_pb.RoomMember(
            roomId: 'room_140',
            userId: 'usr_133',
            username: 'test2',
            role: common.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
            permissions: Int64(1048575),
            joinedAt: Int64(1781248669),
            isOnline: true,
          ),
        ),
      ),
    ).writeToBuffer();
    final incoming = RoomRealtimeCodec.describeIncoming(
      Uint8List.fromList(joined),
    );

    expect(incoming.payload, {
      'resourceEvent': {
        'observeId': 'room_member_events',
        'roomMemberEvent': {
          'eventId': 'evt_member_1',
          'roomId': 'room_140',
          'kind': 'ROOM_MEMBER_EVENT_KIND_JOINED',
          'member': {
            'roomId': 'room_140',
            'userId': 'usr_133',
            'username': 'test2',
            'role': 'ROOM_MEMBER_ROLE_CREATOR',
            'permissions': '1048575',
            'joinedAt': '1781248669',
            'isOnline': true,
          },
        },
      },
    });
  });

  test(
    'room resource watch DTO distinguishes observed, changed, and error',
    () {
      final observed = RoomResourceWatchEvent<void>.observed(
        version: '1',
        changed: false,
      );
      final changed = RoomResourceWatchEvent<String>.changed(
        version: '2',
        snapshot: 'snapshot',
      );
      final error = RoomResourceWatchEvent<void>.error(
        message: 'permission denied',
        code: 403,
      );

      final observedEvent = observed as RoomResourceObserved<void>;
      expect(observedEvent.version, '1');
      expect(observedEvent.changed, isFalse);

      final changedEvent = changed as RoomResourceChanged<String>;
      expect(changedEvent.snapshot, 'snapshot');

      final failedEvent = error as RoomResourceWatchFailed<void>;
      expect(failedEvent.message, 'permission denied');
      expect(failedEvent.code, 403);
    },
  );

  test('playback control uses playback state update oneof', () {
    final update = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodePlaybackStateUpdate(
        PlaybackControlAction.seek,
        isPlaying: true,
        position: 12.5,
        playbackRate: 1.25,
      ),
    );

    expect(update.hasPlaybackStateUpdate(), isTrue);
    expect(
      update.playbackStateUpdate.type,
      client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SEEK,
    );
    expect(update.playbackStateUpdate.playing, isTrue);
    expect(update.playbackStateUpdate.position, 12.5);
    expect(update.playbackStateUpdate.speed, 1.25);
  });

  test(
    'guarded playback state update uses source guard without version lock',
    () {
      final message = RoomRealtimeCodec.buildGuardedPlaybackStateUpdateMessage(
        PlaybackControlAction.pause,
        SyncTvPlaybackStatus(
          playbackRate: 1,
          version: 7,
          playingMediaId: 'med_1',
          playingPlaylistId: '',
          targetHash:
              'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
        ),
        isPlaying: false,
        position: 0.658,
        playbackRate: 1,
        clientOperationId: '3d918f61-3959-49ef-a962-5d94b8ac8470',
        clientTimeMillis: 123456,
      );

      expect(message.hasPlaybackStateUpdate(), isTrue);
      expect(
        message.playbackStateUpdate.type,
        client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_PAUSE,
      );
      expect(message.playbackStateUpdate.playing, isFalse);
      expect(message.playbackStateUpdate.position, 0.658);
      expect(message.playbackStateUpdate.speed, 1);
      expect(message.playbackStateUpdate.hasVersion(), isFalse);
      expect(message.playbackStateUpdate.expectedMediaId, 'med_1');
      expect(message.playbackStateUpdate.hasExpectedPlaylistId(), isFalse);
      expect(
        message.playbackStateUpdate.expectedTargetHash,
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
      expect(
        message.playbackStateUpdate.clientOperationId,
        '3d918f61-3959-49ef-a962-5d94b8ac8470',
      );
      expect(message.playbackStateUpdate.clientTimeMillis, Int64(123456));
    },
  );

  test('realtime chat messages preserve danmaku presentation fields', () {
    final chat = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeChat(
        'hello overlay',
        displayPosition: 'scroll',
        displayColor: '#ff6600',
      ),
    );

    expect(chat.hasChat(), isTrue);
    expect(chat.chat.content, 'hello overlay');
    expect(chat.chat.displayPosition, 'scroll');
    expect(chat.chat.displayColor, '#ff6600');
  });

  test(
    'initial realtime observations include only permission-safe resources',
    () {
      final messages = RoomRealtimeCodec.encodeInitialObservations()
          .map(client.ClientMessage.fromBuffer)
          .toList(growable: false);
      final observeIds = messages
          .map((message) => message.observeResource.observeId)
          .toList(growable: false);
      expect(observeIds.where((id) => id == 'playback_state'), hasLength(1));
      expect(observeIds.where((id) => id == 'playback'), hasLength(1));
      expect(
        observeIds.toSet(),
        containsAll([
          'playback_state',
          'playback',
          'room_settings',
          'self_room_member',
          'online_count',
        ]),
      );
      expect(observeIds, isNot(contains('playlist_items')));
      expect(observeIds, isNot(contains('chat_events')));
      expect(
        messages
            .map((message) => message.observeResource.observeId)
            .contains('webrtc_events'),
        isFalse,
      );

      final snapshotObserve = messages
          .map((message) => message.observeResource)
          .firstWhere((observe) => observe.observeId == 'playback');

      expect(
        snapshotObserve.deliveryMode,
        client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
      );
      expect(snapshotObserve.hasPlayback(), isTrue);
      final profile = snapshotObserve.playback.playbackClientProfile;
      expect(
        profile.streamPreference,
        client.PlaybackStreamPreference.PLAYBACK_STREAM_PREFERENCE_AUTO,
      );
      expect(profile.maxAudioChannels, 2);
      expect(profile.supportedVideoCodecs, [
        client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
        client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
        client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
        client.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
      ]);
      expect(profile.supportedContainers, [
        client.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
        client.PlaybackContainer.PLAYBACK_CONTAINER_MKV,
        client.PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
      ]);
      expect(profile.supportedLiveTransports, [
        client.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_FLV,
        client.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_HLS,
      ]);
      expect(
        profile.audioCapability,
        client.PlaybackAudioCapability.PLAYBACK_AUDIO_CAPABILITY_STEREO,
      );
      expect(
        profile.subtitlePreference,
        client.PlaybackSubtitlePreference.PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
      );

      final chatObserve = client.ClientMessage.fromBuffer(
        RoomRealtimeCodec.encodeChatEventsObservation(),
      ).observeResource;
      expect(chatObserve.hasChatEvents(), isTrue);
      expect(
        chatObserve.deliveryMode,
        client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
      );
    },
  );

  test('guest realtime observations resolve playback over guest HTTP', () {
    final observeIds =
        RoomRealtimeCodec.encodeInitialObservations(
              includeResolvedPlayback: false,
            )
            .map(client.ClientMessage.fromBuffer)
            .map((message) => message.observeResource.observeId);

    expect(observeIds, contains('playback_state'));
    expect(observeIds, isNot(contains('playback')));
  });

  test('chat event observation uses event sequence cursor', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeChatEventsObservation(afterEventId: 'evt_42'),
    );

    expect(message.hasObserveResource(), isTrue);
    expect(message.observeResource.hasChatEvents(), isTrue);
    expect(message.observeResource.chatEvents.afterEventSequence.toInt(), 0);
  });

  test('online count observation supports member list filters', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeOnlineCountObservation(
        observeId: 'visible_member_online_count',
        userIds: const ['usr_1', 'usr_2'],
        roles: const [common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN],
      ),
    );

    expect(message.hasObserveResource(), isTrue);
    final observe = message.observeResource;
    expect(observe.observeId, 'visible_member_online_count');
    expect(observe.hasOnlineCount(), isTrue);
    expect(observe.onlineCount.userIds, ['usr_1', 'usr_2']);
    expect(observe.onlineCount.roles, [
      common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
    ]);
  });

  test('room realtime decoder exposes typed protobuf messages', () {
    final chat = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'chat_events',
          chatEvent: client.ChatMessageEvent(
            eventId: 'evt_chat',
            kind: client_enum
                .ChatMessageEventKind
                .CHAT_MESSAGE_EVENT_KIND_CREATED,
            message: client.ChatMessageReceive(
              content: 'hello',
              userId: 'usr_sender',
              username: 'alice',
              timestamp: Int64(123),
            ),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(chat.kind, RoomRealtimeMessageKind.chat);
    expect(chat.chatContent, 'hello');
    expect(chat.senderUserId, 'usr_sender');
    expect(chat.senderUsername, 'alice');
    expect(chat.timestampMillis, 123000);

    final anonymousChat = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'chat_events',
          chatEvent: client.ChatMessageEvent(
            eventId: 'evt_chat_without_author',
            message: client.ChatMessageReceive(content: 'system event'),
          ),
        ),
      ).writeToBuffer(),
    );
    expect(anonymousChat.senderUsername, isNull);

    final playback = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'playbackState',
          playbackState: client.PlaybackState(
            isPlaying: true,
            position: 42.5,
            speed: 1.25,
          ),
        ),
      ).writeToBuffer(),
    );

    expect(playback.kind, RoomRealtimeMessageKind.status);
    expect(playback.status?.isPlaying, isTrue);
    expect(playback.status?.currentTime, 42.5);
    expect(playback.status?.playbackRate, 1.25);

    final voiceOffer = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'webrtc',
          webrtcEvent: client.WebRTCEvent(
            voiceOffer: client.WebRTCVoiceOffer(
              from: 'usr_peer:conn_1',
              data: '{"sdp":"offer"}',
            ),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(voiceOffer.kind, RoomRealtimeMessageKind.webrtcVoiceOffer);
    expect(
      voiceOffer.webRtc,
      isA<RoomRealtimeWebRtcVoiceNegotiationSignal>().having(
        (signal) => signal.from,
        'from',
        'usr_peer:conn_1',
      ),
    );
    expect(voiceOffer.webRtc?.signalType, 'offer');
    expect(voiceOffer.webRtc?.payload(), {
      'sdp': 'offer',
      'from': 'usr_peer:conn_1',
      'type': 'offer',
    });

    final mediaOffer = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'webrtc',
          webrtcEvent: client.WebRTCEvent(
            mediaOffer: client.WebRTCMediaOffer(
              from: 'usr_peer:conn_1',
              data: '{"sdp":"media-offer"}',
              swarmId: 'sm1_test',
            ),
          ),
        ),
      ).writeToBuffer(),
    );
    expect(mediaOffer.kind, RoomRealtimeMessageKind.webrtcMediaOffer);
    expect(mediaOffer.webRtc, isA<RoomRealtimeWebRtcMediaNegotiationSignal>());
    expect(mediaOffer.webRtc?.payload(), {
      'sdp': 'media-offer',
      'from': 'usr_peer:conn_1',
      'type': 'offer',
      'media_swarm_id': 'sm1_test',
    });

    final swarmPeers = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'webrtc',
          webrtcEvent: client.WebRTCEvent(
            mediaSwarmPeers: client.WebRTCMediaSwarmPeers(
              swarmId: 'sm1_test',
              swarmTicket: 'renewed-ticket',
              peers: [
                client.WebRTCMediaSwarmPeer(
                  userId: 'usr_peer',
                  connId: 'conn_1',
                ),
              ],
            ),
          ),
        ),
      ).writeToBuffer(),
    );
    expect(swarmPeers.kind, RoomRealtimeMessageKind.webrtcMediaSwarmPeers);
    expect(swarmPeers.webRtc, isA<RoomRealtimeWebRtcMediaSwarmPeersSignal>());
    expect(swarmPeers.webRtc?.signalType, 'media_swarm_peers');
    expect(swarmPeers.webRtc?.payload(), {
      'media_swarm_id': 'sm1_test',
      'peers': [
        {'user_id': 'usr_peer', 'conn_id': 'conn_1'},
      ],
      'media_swarm_ticket': 'renewed-ticket',
    });

    final peerLeft = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'webrtc',
          webrtcEvent: client.WebRTCEvent(
            mediaPeerLeft: client.WebRTCMediaPeerLeft(
              swarmId: 'sm1_test',
              userId: 'usr_peer',
              connId: 'conn_1',
            ),
          ),
        ),
      ).writeToBuffer(),
    );
    expect(peerLeft.kind, RoomRealtimeMessageKind.webrtcMediaPeerLeft);
    expect(peerLeft.webRtc, isA<RoomRealtimeWebRtcMediaPeerLeftSignal>());
    expect(peerLeft.webRtc?.signalType, 'media_swarm_leave');
    expect(peerLeft.webRtc?.payload(), {
      'user_id': 'usr_peer',
      'conn_id': 'conn_1',
      'media_swarm_id': 'sm1_test',
      'from': 'usr_peer:conn_1',
    });

    final onlineEvent = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'manage_member_online_events',
          onlineEvent: client.OnlineEvent(
            eventId: 'evt_online_1',
            roomId: 'room_1',
            userId: 'usr_1',
            username: 'alice',
            role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
            kind: client.OnlineEventKind.ONLINE_EVENT_KIND_JOINED,
            occurredAt: Int64(1781260000),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(onlineEvent.kind, RoomRealtimeMessageKind.onlineEvent);
    expect(onlineEvent.resourceObserveId, 'manage_member_online_events');
    expect(onlineEvent.onlineEvent?.userId, 'usr_1');
    expect(onlineEvent.onlineEvent?.username, 'alice');
    expect(onlineEvent.onlineEvent?.isOnline, isTrue);
    expect(onlineEvent.timestampMillis, 1781260000000);
  });

  test(
    'chat realtime events update existing entries and remove deleted ones',
    () {
      RoomRealtimeMessage decodeChatEvent({
        required String eventId,
        required client_enum.ChatMessageEventKind kind,
        required String content,
        client_enum.ChatMessageStatus status =
            client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE,
        int editedAt = 0,
        int deletedAt = 0,
      }) {
        return RoomRealtimeCodec.decode(
          client.ServerMessage(
            resourceEvent: client.ResourceEvent(
              observeId: 'chat_events',
              eventCursor: client.EventCursor(
                eventId: eventId,
                sequence: Int64(100),
              ),
              chatEvent: client.ChatMessageEvent(
                eventId: eventId,
                roomId: 'room_1',
                kind: kind,
                message: client.ChatMessageReceive(
                  id: 'msg_1',
                  userId: 'usr_1',
                  username: 'alice',
                  content: content,
                  timestamp: Int64(123),
                  status: status,
                  editedAt: Int64(editedAt),
                  deletedAt: Int64(deletedAt),
                ),
              ),
            ),
          ).writeToBuffer(),
        );
      }

      final messages = <RoomRealtimeChatEntry>[];

      final created = decodeChatEvent(
        eventId: 'evt_1',
        kind: client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_CREATED,
        content: 'hello',
      );
      expect(created.kind, RoomRealtimeMessageKind.chat);
      expect(created.chatEventId, 'evt_1');
      expect(created.resourceVersion, '100');
      expect(created.isChatCreated, isTrue);

      messages.applyRealtimeEvent(
        RoomRealtimeChatEntry.fromMessage(created, receivedAtMillis: 1),
        eventKind: created.chatEventKind,
        maxEntries: 100,
      );
      expect(messages.map((entry) => entry.content), ['hello']);

      final edited = decodeChatEvent(
        eventId: 'evt_2',
        kind: client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_EDITED,
        content: 'hello edited',
        status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_EDITED,
        editedAt: 124,
      );
      expect(edited.chatEventId, 'evt_2');
      expect(edited.isChatEdited, isTrue);

      messages.applyRealtimeEvent(
        RoomRealtimeChatEntry.fromMessage(edited, receivedAtMillis: 1),
        eventKind: edited.chatEventKind,
        maxEntries: 100,
      );
      expect(messages, hasLength(1));
      expect(messages.single.content, 'hello edited');
      expect(messages.single.isEdited, isTrue);

      final deleted = decodeChatEvent(
        eventId: 'evt_3',
        kind: client_enum.ChatMessageEventKind.CHAT_MESSAGE_EVENT_KIND_DELETED,
        content: 'hello edited',
        status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_DELETED,
        deletedAt: 125,
      );
      expect(deleted.chatEventId, 'evt_3');
      expect(deleted.isChatDeleted, isTrue);

      messages.applyRealtimeEvent(
        RoomRealtimeChatEntry.fromMessage(deleted, receivedAtMillis: 1),
        eventKind: deleted.chatEventKind,
        maxEntries: 100,
      );
      expect(messages, isEmpty);
    },
  );

  test('chat pin resource event is decoded from websocket payload', () {
    final decoded = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'chat_pin_events',
          eventCursor: client.EventCursor(sequence: Int64(78)),
          chatPinEvent: client.ChatPinEvent(
            eventId: 'pin_evt_1',
            roomId: 'room_1',
            kind: client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_PINNED,
            message: client.ChatMessageReceive(
              id: 'msg_1',
              roomId: 'room_1',
              userId: 'usr_sender',
              username: 'sender',
              content: 'pinned',
              timestamp: Int64(1760000100),
              status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_ACTIVE,
            ),
            pin: client.ChatMessagePin(
              pinnedByUserId: 'usr_mod',
              pinnedByUsername: 'mod',
              note: 'important',
              pinnedAt: Int64(1760000200),
            ),
            occurredAt: Int64(1760000201),
            sequence: Int64(78),
          ),
        ),
      ).writeToBuffer(),
    );

    expect(decoded.kind, RoomRealtimeMessageKind.chatPin);
    expect(decoded.resourceObserveId, 'chat_pin_events');
    expect(decoded.resourceVersion, '78');
    expect(decoded.chatPinEvent?.eventId, 'pin_evt_1');
    expect(decoded.chatPinEvent?.message.id, 'msg_1');
    expect(decoded.chatPinEvent?.pin?.note, 'important');
    expect(decoded.chatPinEvent?.sequence, 78);

    final observe = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeChatPinEventsObservation(version: '78'),
    );
    expect(observe.observeResource.hasChatPinEvents(), isTrue);
    expect(
      observe.observeResource.chatPinEvents.afterEventSequence.toInt(),
      78,
    );
    expect(
      observe.observeResource.deliveryMode,
      client.ResourceDeliveryMode.RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
    );
  });

  test('chat pin state is preserved for realtime chat entries', () {
    const pin = ChatPinInfo(
      pinnedByUserId: 'usr_mod',
      pinnedByUsername: 'mod',
      note: 'important',
      pinnedAt: 1760000200,
    );
    const message = RoomChatMessageInfo(
      id: 'msg_1',
      roomId: 'room_1',
      userId: 'usr_sender',
      username: 'sender',
      content: 'pinned',
      timestamp: 1760000100,
      pin: pin,
    );

    final entry = RoomRealtimeChatEntry.fromHistory(message);
    expect(entry.isPinned, isTrue);
    expect(entry.pin?.note, 'important');

    final cleared = entry.copyWith(clearPin: true);
    expect(cleared.isPinned, isFalse);
    expect(cleared.pin, isNull);
  });

  test('chat reactions are mapped from protobuf events and endpoints', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path ==
            '/api/rooms/room_1/chat/messages/msg_1/reactions/%F0%9F%91%8D') {
          return http.Response(
            jsonEncode({
              'id': 'evt_1',
              'sequence': '8',
              'roomId': 'room_1',
              'kind': client_enum
                  .ChatMessageEventKind
                  .CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED
                  .value,
              'message': {
                'id': 'msg_1',
                'roomId': 'room_1',
                'userId': 'usr_sender',
                'username': 'sender',
                'content': 'hello',
                'timestamp': '1760000100',
                'version': '2',
                'status': client_enum
                    .ChatMessageStatus
                    .CHAT_MESSAGE_STATUS_ACTIVE
                    .value,
                'reactions': [
                  {'key': '👍', 'count': '3', 'reactedByMe': true},
                ],
                'reactionCount': 3,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path ==
            '/api/rooms/room_1/chat/messages/msg_1/reactions/%F0%9F%91%8D/users') {
          return http.Response(
            jsonEncode({
              'users': [
                {
                  'userId': 'usr_1',
                  'username': 'alice',
                  'reactedAt': '1760000200',
                },
              ],
              'nextCursor': 'cursor_2',
              'total': '1',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          'unexpected ${request.method} ${request.url}',
          404,
        );
      }),
    );
    final service = SyncTvRoomMediaDomainService(api);

    final reacted = await service.setChatReaction(
      'room_1',
      'msg_1',
      '👍',
      enabled: true,
    );
    final users = await service.listChatReactionUsers(
      'room_1',
      'msg_1',
      '👍',
      limit: 25,
      cursor: 'cursor_1',
    );

    expect(requests[0].method, 'PUT');
    expect(requests[0].url.queryParameters, isEmpty);
    expect(reacted.reactionCount, 3);
    expect(reacted.reactions, hasLength(1));
    expect(reacted.reactions.single.key, '👍');
    expect(reacted.reactions.single.count, 3);
    expect(reacted.reactions.single.reactedByMe, isTrue);

    expect(requests[1].method, 'GET');
    expect(requests[1].url.queryParameters, {
      'limit': '25',
      'cursor': 'cursor_1',
    });
    expect(users.total, 1);
    expect(users.nextCursor, 'cursor_2');
    expect(users.users.single.userId, 'usr_1');
    expect(users.users.single.username, 'alice');
    expect(users.users.single.reactedAt, 1760000200);
  });

  test(
    'chat search and pin endpoints map current protobuf contracts',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/rooms/room_1/chat/search':
              return http.Response(
                jsonEncode({
                  'messages': [
                    {
                      'id': 'msg_1',
                      'roomId': 'room_1',
                      'userId': 'usr_sender',
                      'username': 'sender',
                      'content': 'search hit',
                      'timestamp': '1760000100',
                      'version': '1',
                      'status': client_enum
                          .ChatMessageStatus
                          .CHAT_MESSAGE_STATUS_ACTIVE
                          .value,
                      'pin': {
                        'pinnedByUserId': 'usr_mod',
                        'pinnedByUsername': 'mod',
                        'note': 'important',
                        'pinnedAt': '1760000200',
                      },
                    },
                  ],
                  'nextCursor': 'cursor_2',
                  'eventCursor': {'sequence': '77'},
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/chat/pinned-messages':
              return http.Response(
                jsonEncode({
                  'messages': [
                    {
                      'message': {
                        'id': 'msg_1',
                        'roomId': 'room_1',
                        'userId': 'usr_sender',
                        'username': 'sender',
                        'content': 'pinned',
                        'timestamp': '1760000100',
                        'version': '1',
                        'status': client_enum
                            .ChatMessageStatus
                            .CHAT_MESSAGE_STATUS_ACTIVE
                            .value,
                      },
                      'pinnedByUserId': 'usr_mod',
                      'pinnedByUsername': 'mod',
                      'note': 'important',
                      'pinnedAt': '1760000200',
                    },
                  ],
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/chat/messages/msg_1/pin':
              if (request.method == 'PUT') {
                return http.Response(
                  jsonEncode({
                    'event': {
                      'eventId': 'pin_evt_1',
                      'roomId': 'room_1',
                      'kind': client_enum
                          .ChatPinEventKind
                          .CHAT_PIN_EVENT_KIND_PINNED
                          .value,
                      'message': {
                        'id': 'msg_1',
                        'roomId': 'room_1',
                        'userId': 'usr_sender',
                        'username': 'sender',
                        'content': 'pinned',
                        'timestamp': '1760000100',
                        'version': '1',
                        'status': client_enum
                            .ChatMessageStatus
                            .CHAT_MESSAGE_STATUS_ACTIVE
                            .value,
                      },
                      'pin': {
                        'pinnedByUserId': 'usr_mod',
                        'pinnedByUsername': 'mod',
                        'note': 'important',
                        'pinnedAt': '1760000200',
                      },
                      'occurredAt': '1760000201',
                      'sequence': '78',
                    },
                  }),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              }
              return http.Response(
                jsonEncode({
                  'event': {
                    'eventId': 'pin_evt_2',
                    'roomId': 'room_1',
                    'kind': client_enum
                        .ChatPinEventKind
                        .CHAT_PIN_EVENT_KIND_UNPINNED
                        .value,
                    'message': {
                      'id': 'msg_1',
                      'roomId': 'room_1',
                      'userId': 'usr_sender',
                      'username': 'sender',
                      'content': 'unpinned',
                      'timestamp': '1760000100',
                      'version': '1',
                      'status': client_enum
                          .ChatMessageStatus
                          .CHAT_MESSAGE_STATUS_ACTIVE
                          .value,
                    },
                    'occurredAt': '1760000301',
                    'sequence': '79',
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response(
            'unexpected ${request.method} ${request.url}',
            404,
          );
        }),
      );
      final service = SyncTvRoomMediaDomainService(api);

      final search = await service.searchChatMessages(
        'room_1',
        query: 'needle',
        limit: 25,
        cursor: 'cursor_1',
        includeDeleted: true,
        userId: 'usr_sender',
      );
      final pinned = await service.listPinnedChatMessages('room_1', limit: 10);
      final pinEvent = await service.pinChatMessage(
        'room_1',
        'msg_1',
        note: 'important',
      );
      final unpinEvent = await service.unpinChatMessage('room_1', 'msg_1');

      expect(requests[0].method, 'GET');
      expect(requests[0].url.queryParameters, {
        'query': 'needle',
        'cursor': 'cursor_1',
        'limit': '25',
        'includeDeleted': 'true',
        'userId': 'usr_sender',
      });
      expect(search.nextCursor, 'cursor_2');
      expect(search.eventCursor, '77');
      expect(search.messages.single.isPinned, isTrue);
      expect(search.messages.single.pin?.note, 'important');

      expect(requests[1].method, 'GET');
      expect(requests[1].url.queryParameters, {'limit': '10'});
      expect(pinned.single.message.id, 'msg_1');
      expect(pinned.single.pin.pinnedByUsername, 'mod');

      expect(requests[2].method, 'PUT');
      final pinBody = jsonDecode(requests[2].body) as Map<String, dynamic>;
      expect(pinBody..remove('clientOperationId'), {
        'messageId': 'msg_1',
        'note': 'important',
      });
      expect(
        jsonDecode(requests[2].body),
        containsPair('clientOperationId', isA<String>()),
      );
      expect(pinEvent.eventId, 'pin_evt_1');
      expect(
        pinEvent.kind,
        client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_PINNED,
      );
      expect(pinEvent.pin?.pinnedAt, 1760000200);

      expect(requests[3].method, 'DELETE');
      expect(requests[3].body, isEmpty);
      expect(requests[3].url.queryParameters.keys, ['clientOperationId']);
      expect(
        requests[3].url.queryParameters['clientOperationId'],
        isA<String>().having((value) => value.isNotEmpty, 'isNotEmpty', isTrue),
      );
      expect(
        unpinEvent.kind,
        client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED,
      );
      expect(unpinEvent.pin, isNull);
    },
  );

  test('chat pin watch decodes SSE resource events', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/chat-pin-events');
      expect(request.uri.queryParameters, {
        'deliveryMode': client_enum
            .ResourceDeliveryMode
            .RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT
            .value
            .toString(),
        'afterEventSequence': '76',
      });
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType(
          'text',
          'event-stream',
          charset: 'utf-8',
        )
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
            'observeId': 'chat_pin_events',
            'eventCursor': {'sequence': '78'},
            'chatPinEvent': {
              'eventId': 'pin_evt_1',
              'roomId': 'room_1',
              'kind': 'CHAT_PIN_EVENT_KIND_PINNED',
              'message': {'id': 'msg_1', 'roomId': 'room_1', 'userId': 'usr_sender', 'username': 'sender', 'content': 'pinned', 'timestamp': '1760000100', 'status': 'CHAT_MESSAGE_STATUS_ACTIVE'},
              'pin': {'pinnedByUserId': 'usr_mod', 'pinnedByUsername': 'mod', 'note': 'important', 'pinnedAt': '1760000200'},
              'occurredAt': '1760000201',
              'sequence': '78',
            },
          })}\n\n',
        );
      await request.response.close();
    });
    final api = SyncTvApiClient(
      baseUrl: 'http://${server.address.host}:${server.port}',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
    );
    final service = SyncTvRoomMediaDomainService(api);

    try {
      final event = await service
          .watchChatPinEvents('room_1', version: '76')
          .first;

      final changed = event as RoomResourceChanged<ChatPinEventInfo>;
      expect(changed.version, '78');
      expect(changed.snapshot?.eventId, 'pin_evt_1');
      expect(changed.snapshot?.message.id, 'msg_1');
      expect(changed.snapshot?.pin?.note, 'important');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test(
    'content reports can target rooms, users, members, and chat messages',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          expect(request.method, 'POST');
          expect(request.url.path, '/api/rooms/room_1/reports');
          return http.Response(
            jsonEncode({'report_id': 'report_${requests.length}'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final service = SyncTvRoomMediaDomainService(api);

      await service.reportRoom(
        'room_1',
        reasonCode: 'spam',
        reason: 'room reason',
      );
      await service.reportUser(
        'room_1',
        'usr_target',
        reasonCode: 'abuse',
        reason: 'user reason',
      );
      await service.reportRoomMember(
        'room_1',
        'usr_member',
        reasonCode: 'illegal',
        reason: 'member reason',
      );
      await service.reportChatMessage(
        'room_1',
        'msg_1',
        reasonCode: 'other',
        reason: 'message reason',
      );

      expect(requests, hasLength(4));
      expect(jsonDecode(requests[0].body), {
        'room': {'roomId': 'room_1'},
        'reasonCode': 'spam',
        'reason': 'room reason',
      });
      expect(jsonDecode(requests[1].body), {
        'user': {'userId': 'usr_target'},
        'reasonCode': 'abuse',
        'reason': 'user reason',
      });
      expect(jsonDecode(requests[2].body), {
        'roomMember': {'roomId': 'room_1', 'userId': 'usr_member'},
        'reasonCode': 'illegal',
        'reason': 'member reason',
      });
      expect(jsonDecode(requests[3].body), {
        'chatMessage': {'roomId': 'room_1', 'messageId': 'msg_1'},
        'reasonCode': 'other',
        'reason': 'message reason',
      });
    },
  );

  test(
    'single chat message endpoint is exposed through room media service',
    () async {
      http.Request? captured;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          captured = request;
          return http.Response(
            jsonEncode({
              'id': 'msg_42',
              'roomId': 'room_1',
              'userId': 'usr_sender',
              'username': 'sender',
              'content': 'single message',
              'timestamp': '1760000300',
              'version': '4',
              'status': client_enum
                  .ChatMessageStatus
                  .CHAT_MESSAGE_STATUS_ACTIVE
                  .value,
              'displayPosition': 'top',
              'displayColor': '#ffcc00',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final service = SyncTvRoomMediaDomainService(api);

      final message = await service.getChatMessage(
        'room_1',
        'msg_42',
        includeDeleted: true,
      );

      expect(captured, isNotNull);
      expect(captured!.method, 'GET');
      expect(captured!.url.path, '/api/rooms/room_1/chat/messages/msg_42');
      expect(captured!.url.queryParameters, {'includeDeleted': 'true'});
      expect(message.id, 'msg_42');
      expect(message.content, 'single message');
      expect(message.version, 4);
      expect(message.displayPosition, 'top');
      expect(message.displayColor, '#ffcc00');
    },
  );

  test('chat reaction realtime event updates the existing message', () {
    final messages = <RoomRealtimeChatEntry>[
      const RoomRealtimeChatEntry(
        id: 'msg_1',
        userId: 'usr_sender',
        username: 'sender',
        content: 'hello',
        timestampMillis: 1760000100000,
      ),
    ];
    final updated = RoomRealtimeChatEntry.fromHistory(
      const RoomChatMessageInfo(
        id: 'msg_1',
        roomId: 'room_1',
        userId: 'usr_sender',
        username: 'sender',
        content: 'hello',
        timestamp: 1760000100,
        reactions: [
          ChatReactionSummaryInfo(key: 'like', count: 1, reactedByMe: true),
        ],
        reactionCount: 1,
      ),
    );

    messages.applyRealtimeEvent(
      updated,
      eventKind: RoomRealtimeChatEventKind.reactionsChanged,
      maxEntries: 100,
    );

    expect(messages, hasLength(1));
    expect(messages.single.id, 'msg_1');
    expect(messages.single.content, 'hello');
  });

  test('chat reaction summary is appended to playback danmaku text', () {
    const reactions = [
      ChatReactionSummaryInfo(key: '👍', count: 2, reactedByMe: false),
      ChatReactionSummaryInfo(key: '😂', count: 5, reactedByMe: true),
      ChatReactionSummaryInfo(key: '🎉', count: 3, reactedByMe: false),
    ];
    final danmaku = chatMessageToDanmaku(
      const RoomChatMessageInfo(
        id: 'msg_1',
        roomId: 'room_1',
        userId: 'usr_sender',
        username: 'sender',
        content: 'hello',
        timestamp: 1760000100,
        displayPosition: '12.5',
        reactions: reactions,
        reactionCount: 10,
      ),
    );

    expect(chatReactionSummarySuffix(reactions), '  😂5 🎉3');
    expect(danmaku.text, 'sender: hello  😂5 🎉3');
    expect(danmaku.origin, DanmakuOrigin.chat);
  });

  test('live playback skips historical chat danmaku fetches', () async {
    final result = await fetchPlaybackDanmakuWindow(
      loadMessages: (_) => throw StateError('live media must skip history'),
      roomId: 'room_1',
      entry: RoomMediaEntry(
        id: 'med_live',
        name: 'Live',
        url: 'https://example.test/live.m3u8',
        live: true,
      ),
      positionSeconds: 30,
    );

    expect(result, isNull);
  });

  test('avatar upload completes ownership proof before update', () async {
    final upload = LocalImageUpload(
      bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
      fileName: 'avatar.png',
      mimeType: 'image/png',
      width: 2,
      height: 3,
    );
    Map<String, dynamic>? updateBody;
    Map<String, dynamic>? completeBody;
    var uploadSessionRequests = 0;

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.path == '/api/user/avatar/upload-session') {
          uploadSessionRequests += 1;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final parts = body['parts'] as List<dynamic>? ?? const [];
          if (parts.isEmpty) {
            return http.Response(
              jsonEncode({
                'plan': {
                  'checksumAlgorithm': 'sha256',
                  'partSizeBytes': upload.sizeBytes,
                  'parts': [
                    {
                      'partNumber': 1,
                      'offsetBytes': 0,
                      'sizeBytes': upload.sizeBytes,
                    },
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(parts, [
            {
              'partNumber': 1,
              'offsetBytes': '0',
              'sizeBytes': upload.sizeBytes.toString(),
              'checksumSha256': upload.checksumSha256,
            },
          ]);
          return http.Response(
            jsonEncode({
              'session': {
                'avatarReference': {'id': 'avatar_1'},
                'uploadRequired': false,
                'ownershipProofRequired': true,
                'ownershipProofNonce': 'nonce_1',
                'ownershipProofRanges': [
                  {'offset': 1, 'length': 3},
                ],
                'uploadToken': 'upload-token',
                'encodedObjectKey': 'avatar-object-key',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'POST' &&
            request.url.path ==
                '/api/user/avatar-objects/avatar-object-key/complete') {
          completeBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'complete': true,
              'uploadedSizeBytes': upload.sizeBytes,
              'uploadedParts': [1],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' && request.url.path == '/api/user/avatar') {
          updateBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'id': 'usr_1', 'username': 'root'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          'unexpected request: ${request.method} '
          '${request.url.path}',
          404,
        );
      }),
    );

    final updated = await SyncTvFileUploadDomainService(
      api,
    ).updateUserAvatar(upload);

    expect(updated.id, 'usr_1');
    expect(uploadSessionRequests, 2);
    expect(updateBody?['avatarReference'], {'id': 'avatar_1'});
    expect(completeBody?['fileId'], 'avatar_1');
    expect(completeBody?['token'], 'upload-token');
    expect(completeBody?['parts'], [
      {
        'partNumber': 1,
        'etag': '',
        'sizeBytes': upload.sizeBytes.toString(),
        'checksumSha256': upload.checksumSha256,
      },
    ]);
    expect(
      completeBody?['ownershipProof'],
      _expectedOwnershipProof(
        upload.bytes,
        nonce: 'nonce_1',
        contentManifestSha256:
            _expectedContentManifestSha256(upload.sizeBytes, upload.sizeBytes, [
              (
                partNumber: 1,
                sizeBytes: upload.sizeBytes,
                checksum: upload.checksumSha256,
              ),
            ]),
        ranges: const [(offset: 1, length: 3)],
      ),
    );
  });

  test(
    'object upload facades send raw bytes and parse progress headers',
    () async {
      final uploadBytes = Uint8List.fromList([1, 2, 3, 4]);
      final range = client.FileUploadRange(
        start: Int64(1),
        endInclusive: Int64(3),
        totalSize: Int64(9),
      );
      final expectedPaths = <String>{
        '/api/user/avatar-objects/avatar-object-key',
        '/api/chat/attachment-objects/chat-attachment-key',
        '/api/room/cover-objects/room-cover-key',
        '/api/playlist/cover-objects/playlist-cover-key',
        '/api/media/cover-objects/media-cover-key',
        '/api/media/thumbnail-objects/media-thumbnail-key',
      };
      final seenPaths = <String>[];

      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()
          ..updateAccountTokens(accessToken: 'access-token'),
        httpClient: MockClient((request) async {
          seenPaths.add(request.url.path);
          expect(request.method, 'PUT');
          expect(expectedPaths, contains(request.url.path));
          expect(request.headers.containsKey('authorization'), isFalse);
          expect(request.headers['x-synctv-file-upload-token'], 'upload-token');
          expect(request.headers['content-type'], 'image/png');
          expect(request.bodyBytes, uploadBytes);
          if (request.url.path.endsWith('/avatar-object-key')) {
            expect(request.headers['content-range'], 'bytes 1-3/9');
          } else {
            expect(request.headers.containsKey('content-range'), isFalse);
          }
          return http.Response(
            '',
            204,
            headers: {
              'x-synctv-upload-complete': 'true',
              'x-synctv-uploaded-size-bytes': uploadBytes.length.toString(),
              'x-synctv-uploaded-parts': '1,2',
            },
          );
        }),
      );

      final cases = <Future<dynamic>>[
        api.user.uploadUserAvatarObject(
          client.UploadUserAvatarObjectRequest(
            encodedObjectKey: 'avatar-object-key',
            token: 'upload-token',
            contentType: 'image/png',
            data: uploadBytes,
            contentRange: range,
          ),
        ),
        api.room.uploadChatAttachmentObject(
          client.UploadChatAttachmentObjectRequest(
            roomId: 'room_1',
            encodedObjectKey: 'chat-attachment-key',
            token: 'upload-token',
            contentType: 'image/png',
            data: uploadBytes,
          ),
        ),
        api.room.uploadRoomCoverObject(
          client.UploadRoomCoverObjectRequest(
            encodedObjectKey: 'room-cover-key',
            token: 'upload-token',
            contentType: 'image/png',
            data: uploadBytes,
          ),
        ),
        api.room.uploadPlaylistCoverObject(
          client.UploadPlaylistCoverObjectRequest(
            encodedObjectKey: 'playlist-cover-key',
            token: 'upload-token',
            contentType: 'image/png',
            data: uploadBytes,
          ),
        ),
        api.room.uploadMediaCoverObject(
          client.UploadMediaCoverObjectRequest(
            encodedObjectKey: 'media-cover-key',
            token: 'upload-token',
            contentType: 'image/png',
            data: uploadBytes,
          ),
        ),
        api.room.uploadMediaThumbnailObject(
          client.UploadMediaThumbnailObjectRequest(
            encodedObjectKey: 'media-thumbnail-key',
            token: 'upload-token',
            contentType: 'image/png',
            data: uploadBytes,
          ),
        ),
      ];

      for (final pending in cases) {
        final response = await pending;
        expect(response.complete, isTrue);
        expect(response.uploadedSizeBytes, Int64(uploadBytes.length));
        expect(response.uploadedParts, [1, 2]);
      }
      expect(seenPaths.toSet(), expectedPaths);
    },
  );

  test(
    'object get facades map token, range, bytes, and response headers',
    () async {
      const manifest =
          '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
      final body = Uint8List.fromList([8, 9, 10]);
      final expectedPaths = <String>{
        '/api/user/avatar-objects/avatar-object-key',
        '/api/chat/attachment-objects/chat-attachment-key',
        '/api/room/cover-objects/room-cover-key',
        '/api/playlist/cover-objects/playlist-cover-key',
        '/api/media/cover-objects/media-cover-key',
        '/api/media/thumbnail-objects/media-thumbnail-key',
      };
      final rangeHeaders = <String, String>{
        '/api/user/avatar-objects/avatar-object-key': 'bytes=1-3',
        '/api/chat/attachment-objects/chat-attachment-key': 'bytes=4-',
        '/api/room/cover-objects/room-cover-key': 'bytes=-5',
      };
      final seenPaths = <String>[];

      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()
          ..updateAccountTokens(accessToken: 'access-token'),
        httpClient: MockClient((request) async {
          seenPaths.add(request.url.path);
          expect(request.method, 'GET');
          expect(expectedPaths, contains(request.url.path));
          expect(request.headers.containsKey('authorization'), isFalse);
          expect(request.url.queryParameters['token'], 'download-token');
          final expectedRange = rangeHeaders[request.url.path];
          if (expectedRange == null) {
            expect(request.headers.containsKey('range'), isFalse);
            return http.Response.bytes(
              body,
              200,
              headers: {
                'content-type': 'image/webp',
                'content-length': body.length.toString(),
                'x-synctv-content-manifest-sha256': manifest,
              },
            );
          }
          expect(request.headers['range'], expectedRange);
          return http.Response.bytes(
            body,
            206,
            headers: {
              'content-type': 'image/webp',
              'content-range': 'bytes 1-3/9',
              'x-synctv-content-manifest-sha256': manifest,
            },
          );
        }),
      );

      final responses = <dynamic>[
        await api.user.getUserAvatarObject(
          client.GetUserAvatarObjectRequest(
            encodedObjectKey: 'avatar-object-key',
            token: 'download-token',
            range: client.FileRangeRequest(
              exact: client.FileByteRange(
                start: Int64(1),
                endInclusive: Int64(3),
              ),
            ),
          ),
        ),
        await api.room.getChatAttachmentObject(
          client.GetChatAttachmentObjectRequest(
            roomId: 'room_1',
            encodedObjectKey: 'chat-attachment-key',
            token: 'download-token',
            range: client.FileRangeRequest(fromStart: Int64(4)),
          ),
        ),
        await api.room.getRoomCoverObject(
          client.GetRoomCoverObjectRequest(
            encodedObjectKey: 'room-cover-key',
            token: 'download-token',
            range: client.FileRangeRequest(suffixLength: Int64(5)),
          ),
        ),
        await api.room.getPlaylistCoverObject(
          client.GetPlaylistCoverObjectRequest(
            encodedObjectKey: 'playlist-cover-key',
            token: 'download-token',
          ),
        ),
        await api.room.getMediaCoverObject(
          client.GetMediaCoverObjectRequest(
            encodedObjectKey: 'media-cover-key',
            token: 'download-token',
          ),
        ),
        await api.room.getMediaThumbnailObject(
          client.GetMediaThumbnailObjectRequest(
            encodedObjectKey: 'media-thumbnail-key',
            token: 'download-token',
          ),
        ),
      ];

      for (final response in responses) {
        expect(response.mimeType, 'image/webp');
        expect(response.contentManifestSha256, manifest);
        expect(response.data, body);
      }
      expect(responses[0].totalSizeBytes, Int64(9));
      expect(responses[1].totalSizeBytes, Int64(9));
      expect(responses[2].totalSizeBytes, Int64(9));
      expect(responses[3].totalSizeBytes, Int64(body.length));
      expect(responses[4].totalSizeBytes, Int64(body.length));
      expect(responses[5].totalSizeBytes, Int64(body.length));
      expect(responses[0].contentRange.start, Int64(1));
      expect(responses[0].contentRange.endInclusive, Int64(3));
      expect(responses[1].contentRange.start, Int64(1));
      expect(responses[2].contentRange.endInclusive, Int64(3));
      expect(responses[3].hasContentRange(), isFalse);
      expect(responses[4].hasContentRange(), isFalse);
      expect(responses[5].hasContentRange(), isFalse);
      expect(responses[1].roomId, 'room_1');
      expect(seenPaths.toSet(), expectedPaths);
    },
  );

  test('media thumbnail upload uses current protobuf endpoints', () async {
    final upload = LocalImageUpload(
      bytes: Uint8List.fromList([1, 2, 3, 4]),
      fileName: 'thumb.png',
      mimeType: 'image/png',
      width: 16,
      height: 9,
    );
    final requests = <http.Request>[];
    Map<String, dynamic>? completeBody;
    Map<String, dynamic>? updateBody;
    var uploadSessionRequests = 0;

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.method == 'POST' &&
            request.url.path ==
                '/api/rooms/room_1/media/med_1/thumbnail/upload-session') {
          uploadSessionRequests += 1;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final parts = body['parts'] as List<dynamic>? ?? const [];
          expect(body['roomId'], 'room_1');
          expect(body['mediaId'], 'med_1');
          expect(body['clientThumbnailId'], isNotEmpty);
          expect(body['mimeType'], upload.mimeType);
          expect(body['sizeBytes'], upload.sizeBytes.toString());
          expect(body['width'], upload.width);
          expect(body['height'], upload.height);
          if (parts.isEmpty) {
            return http.Response(
              jsonEncode({
                'plan': {
                  'checksumAlgorithm': 'sha256',
                  'partSizeBytes': upload.sizeBytes,
                  'parts': [
                    {
                      'partNumber': 1,
                      'offsetBytes': 0,
                      'sizeBytes': upload.sizeBytes,
                    },
                  ],
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(parts, [
            {
              'partNumber': 1,
              'offsetBytes': '0',
              'sizeBytes': upload.sizeBytes.toString(),
              'checksumSha256': upload.checksumSha256,
            },
          ]);
          return http.Response(
            jsonEncode({
              'session': {
                'thumbnailReference': {'id': 'thumb_1'},
                'uploadRequired': true,
                'uploadUrl': '/api/media/thumbnail-objects/thumb-object-key',
                'uploadHeaders': {'x-upload-extra': '1'},
                'uploadToken': 'upload-token',
                'encodedObjectKey': 'thumb-object-key',
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' &&
            request.url.path ==
                '/api/media/thumbnail-objects/thumb-object-key') {
          expect(request.bodyBytes, upload.bytes);
          expect(request.headers['x-upload-extra'], '1');
          expect(request.headers['content-type'], upload.mimeType);
          return http.Response(
            '',
            200,
            headers: {
              'x-synctv-upload-complete': 'true',
              'x-synctv-uploaded-size-bytes': upload.sizeBytes.toString(),
              'x-synctv-uploaded-parts': '1',
              'etag': 'thumb-etag',
            },
          );
        }
        if (request.method == 'POST' &&
            request.url.path ==
                '/api/media/thumbnail-objects/thumb-object-key/complete') {
          completeBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'complete': true,
              'uploadedSizeBytes': upload.sizeBytes,
              'uploadedParts': [1],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.method == 'PUT' &&
            request.url.path == '/api/rooms/room_1/media/med_1/thumbnail') {
          updateBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'id': 'med_1',
              'roomId': 'room_1',
              'name': 'Episode 1',
              'thumbnail': {'id': 'thumb_1', 'url': '/thumb.png'},
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          'unexpected request: ${request.method} '
          '${request.url.path}',
          404,
        );
      }),
    );

    final updated = await SyncTvFileUploadDomainService(
      api,
    ).updateVideoThumbnail('room_1', 'med_1', upload);

    expect(updated.id, 'med_1');
    expect(uploadSessionRequests, 2);
    expect(completeBody?['fileId'], 'thumb_1');
    expect(completeBody?['token'], 'upload-token');
    expect(completeBody?['parts'], [
      {
        'partNumber': 1,
        'etag': 'thumb-etag',
        'sizeBytes': upload.sizeBytes.toString(),
        'checksumSha256': upload.checksumSha256,
      },
    ]);
    expect(updateBody?['thumbnailReference'], {'id': 'thumb_1'});
    expect(requests.map((request) => '${request.method} ${request.url.path}'), [
      'POST /api/rooms/room_1/media/med_1/thumbnail/upload-session',
      'POST /api/rooms/room_1/media/med_1/thumbnail/upload-session',
      'PUT /api/media/thumbnail-objects/thumb-object-key',
      'POST /api/media/thumbnail-objects/thumb-object-key/complete',
      'PUT /api/rooms/room_1/media/med_1/thumbnail',
    ]);
  });

  test(
    'avatar upload session sends whole-object upload without byte range',
    () async {
      final upload = LocalImageUpload(
        bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
        fileName: 'avatar.png',
        mimeType: 'image/png',
        width: 2,
        height: 3,
      );
      Map<String, dynamic>? completeBody;
      List<int>? uploadedBody;
      Map<String, String>? uploadedHeaders;
      var uploadSessionRequests = 0;

      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          if (request.method == 'POST' &&
              request.url.path == '/api/user/avatar/upload-session') {
            uploadSessionRequests += 1;
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            final parts = body['parts'] as List<dynamic>? ?? const [];
            if (parts.isEmpty) {
              return http.Response(
                jsonEncode({
                  'plan': {
                    'checksumAlgorithm': 'sha256',
                    'partSizeBytes': upload.sizeBytes,
                    'parts': [
                      {
                        'partNumber': 1,
                        'offsetBytes': 0,
                        'sizeBytes': upload.sizeBytes,
                      },
                    ],
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            return http.Response(
              jsonEncode({
                'session': {
                  'avatarReference': {'id': 'avatar_2'},
                  'uploadRequired': true,
                  'uploadUrl': '/api/user/avatar-objects/avatar-object-key',
                  'uploadHeaders': {
                    'x-synctv-file-upload-token': 'upload-token',
                    'x-upload-extra': '1',
                  },
                  'uploadToken': 'upload-token',
                  'encodedObjectKey': 'avatar-object-key',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.method == 'PUT' &&
              request.url.path ==
                  '/api/user/avatar-objects/avatar-object-key') {
            uploadedBody = request.bodyBytes;
            uploadedHeaders = Map<String, String>.from(request.headers);
            return http.Response('', 204, headers: {'etag': 'etag-1'});
          }
          if (request.method == 'POST' &&
              request.url.path ==
                  '/api/user/avatar-objects/avatar-object-key/complete') {
            completeBody = jsonDecode(request.body) as Map<String, dynamic>;
            return http.Response(
              jsonEncode({
                'complete': true,
                'uploadedSizeBytes': upload.sizeBytes,
                'uploadedParts': [1],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.method == 'PUT' &&
              request.url.path == '/api/user/avatar') {
            return http.Response(
              jsonEncode({'id': 'usr_1', 'username': 'root'}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response(
            'unexpected request: ${request.method} '
            '${request.url.path}',
            404,
          );
        }),
      );

      final updated = await SyncTvFileUploadDomainService(
        api,
      ).updateUserAvatar(upload);

      expect(updated.id, 'usr_1');
      expect(uploadSessionRequests, 2);
      expect(uploadedBody, upload.bytes);
      expect(uploadedHeaders?['x-synctv-file-upload-token'], 'upload-token');
      expect(uploadedHeaders?['x-upload-extra'], '1');
      expect(uploadedHeaders?['content-type'], 'image/png');
      expect(uploadedHeaders?.containsKey('content-range'), isFalse);
      expect(completeBody?['parts'], [
        {
          'partNumber': 1,
          'etag': 'etag-1',
          'sizeBytes': upload.sizeBytes.toString(),
          'checksumSha256': upload.checksumSha256,
        },
      ]);
    },
  );

  test(
    'avatar upload session sends byte ranges for server-mediated parts',
    () async {
      final upload = LocalImageUpload(
        bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
        fileName: 'avatar.png',
        mimeType: 'image/png',
        width: 2,
        height: 3,
      );
      final uploadedRanges = <String>[];
      var uploadSessionRequests = 0;

      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          if (request.method == 'POST' &&
              request.url.path == '/api/user/avatar/upload-session') {
            uploadSessionRequests += 1;
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            final parts = body['parts'] as List<dynamic>? ?? const [];
            if (parts.isEmpty) {
              return http.Response(
                jsonEncode({
                  'plan': {
                    'checksumAlgorithm': 'sha256',
                    'partSizeBytes': 3,
                    'parts': [
                      {'partNumber': 1, 'offsetBytes': 0, 'sizeBytes': 3},
                      {'partNumber': 2, 'offsetBytes': 3, 'sizeBytes': 3},
                    ],
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            }
            return http.Response(
              jsonEncode({
                'session': {
                  'avatarReference': {'id': 'avatar_2'},
                  'uploadRequired': true,
                  'uploadUrl': '/api/user/avatar-objects/avatar-object-key',
                  'uploadHeaders': {
                    'x-synctv-file-upload-token': 'upload-token',
                  },
                  'uploadToken': 'upload-token',
                  'encodedObjectKey': 'avatar-object-key',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.method == 'PUT' &&
              request.url.path ==
                  '/api/user/avatar-objects/avatar-object-key') {
            uploadedRanges.add(request.headers['content-range'] ?? '');
            return http.Response(
              '',
              204,
              headers: {'etag': 'etag-${uploadedRanges.length}'},
            );
          }
          if (request.method == 'POST' &&
              request.url.path ==
                  '/api/user/avatar-objects/avatar-object-key/complete') {
            return http.Response(
              jsonEncode({
                'complete': true,
                'uploadedSizeBytes': upload.sizeBytes,
                'uploadedParts': [1, 2],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.method == 'PUT' &&
              request.url.path == '/api/user/avatar') {
            return http.Response(
              jsonEncode({'id': 'usr_1', 'username': 'root'}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response(
            'unexpected request: ${request.method} '
            '${request.url.path}',
            404,
          );
        }),
      );

      final updated = await SyncTvFileUploadDomainService(
        api,
      ).updateUserAvatar(upload);

      expect(updated.id, 'usr_1');
      expect(uploadSessionRequests, 2);
      expect(uploadedRanges, ['bytes 0-2/6', 'bytes 3-5/6']);
    },
  );

  test('OAuth2 callback parser accepts callback URLs and validates state', () {
    final parsed = OAuth2CallbackParser.parse(
      Uri.parse(
        'http://127.0.0.1:49152/oauth2/callback?code=abc123._%2B-&state=AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
    );

    expect(parsed.code, 'abc123._+-');
    expect(parsed.state, 'AbCdEfGh1234567890aBcDeFgHiJkLm');

    final encoded = OAuth2CallbackParser.parse(
      Uri.parse(
        'http://127.0.0.1:49152/oauth2/callback?code=abc+def&state=state%20value',
      ),
      expectedState: 'state value',
    );
    expect(encoded.code, 'abc def');
    expect(encoded.state, 'state value');

    final loopback = OAuth2CallbackParser.parse(
      Uri.parse(
        'http://127.0.0.1:49152/oauth2/callback?code=xyz&state=AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
    );
    expect(loopback.code, 'xyz');

    expect(
      () => OAuth2CallbackParser.parse(
        Uri.parse('code=xyz&state=AbCdEfGh1234567890aBcDeFgHiJkLm'),
        expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      throwsArgumentError,
    );

    expect(
      () => OAuth2CallbackParser.parse(
        Uri.parse(
          'http://127.0.0.1:49152/oauth2/callback?code=abc&state=wrong',
        ),
        expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      throwsArgumentError,
    );

    expect(
      () => OAuth2CallbackParser.parse(
        Uri.parse(
          'http://example.com/oauth2/callback?code=abc&state=AbCdEfGh1234567890aBcDeFgHiJkLm',
        ),
        expectedState: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      ),
      throwsArgumentError,
    );

    expect(
      () => OAuth2CallbackParser.parse(Uri.parse('plain-code')),
      throwsArgumentError,
    );
  });

  test('OAuth2 app link origin rejects custom schemes', () {
    expect(OAuth2CallbackConfig.hasMobileOrigin, isFalse);
    expect(() => OAuth2CallbackService.mobileCallbackUrl, throwsStateError);
    expect(
      OAuth2CallbackConfig.parseMobileOrigin('https://app.synctv.local').host,
      'app.synctv.local',
    );
    expect(
      OAuth2CallbackConfig.parseMobileOrigin(
        'https://app.synctv.local/oauth2/callback',
      ).toString(),
      'https://app.synctv.local',
    );
    final appLinkOrigin = OAuth2CallbackConfig.parseMobileOrigin(
      'https://app.synctv.local',
    );
    expect(
      OAuth2CallbackConfig.isMobileCallbackUriForOrigin(
        Uri.parse(
          'https://app.synctv.local/oauth2/callback?code=abc&state=xyz',
        ),
        appLinkOrigin,
      ),
      isTrue,
    );
    expect(
      OAuth2CallbackConfig.isMobileCallbackUriForOrigin(
        Uri.parse(
          'https://app.synctv.local:8443/oauth2/callback?code=abc&state=xyz',
        ),
        appLinkOrigin,
      ),
      isFalse,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin(
        'https://app.synctv.local:8443',
      ),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin('native-app://callback'),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin('http://app.synctv.local'),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin('https:///callback'),
      throwsStateError,
    );
    expect(
      () => OAuth2CallbackConfig.parseMobileOrigin(
        'https://app.synctv.local?callback=1',
      ),
      throwsStateError,
    );
    expect(
      OAuth2CallbackConfig.isMobileCallbackUri(
        Uri.parse(
          'https://app.synctv.local/oauth2/callback?code=abc&state=xyz',
        ),
      ),
      isFalse,
    );
  });

  test('voice chat manager uses server-provided ICE servers', () async {
    var loadCount = 0;
    final manager = VoiceChatManager(
      loadIceServers: () async {
        loadCount += 1;
        return [
          const IceServerInfo(
            urls: ['turn:turn.example.test:3478'],
            username: 'alice',
            credential: 'secret',
          ),
        ];
      },
      onSignalingMessage: (_, _) {},
      onStateChange: () {},
    );

    final first = await manager.loadIceServerConfigurationForTest();
    final second = await manager.loadIceServerConfigurationForTest();

    expect(loadCount, 1);
    expect(first, same(second));
    expect(first, [
      {
        'urls': ['turn:turn.example.test:3478'],
        'username': 'alice',
        'credential': 'secret',
      },
    ]);
  });

  test('WebRTC signaling encoder maps manager events to protobuf messages', () {
    final voiceOffer = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcVoiceSignal('offer', {
        'sdp': 'sdp-offer',
        'type': 'offer',
        'to': 'usr_peer:conn_1',
      }),
    );
    expect(voiceOffer.hasWebrtc(), isTrue);
    expect(voiceOffer.webrtc.hasVoiceOffer(), isTrue);
    expect(voiceOffer.webrtc.voiceOffer.to, 'usr_peer:conn_1');
    expect(jsonDecode(voiceOffer.webrtc.voiceOffer.data), {
      'sdp': 'sdp-offer',
      'type': 'offer',
    });

    final join = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcVoiceSignal('join', const {
        'client_operation_id': 'ed537455-83d3-43a4-b244-08f3963a4710',
      }),
    );
    expect(join.hasWebrtc(), isTrue);
    expect(join.webrtc.hasVoiceJoin(), isTrue);
    expect(
      join.webrtc.voiceJoin.clientOperationId,
      'ed537455-83d3-43a4-b244-08f3963a4710',
    );

    final mediaSwarmJoin = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcMediaSignal('media_swarm_join', const {
        'media_swarm_id': 'sm1_test',
        'media_swarm_ticket': 'ticket.test',
      }),
    );
    expect(mediaSwarmJoin.webrtc.mediaSwarmJoin.swarmId, 'sm1_test');
    expect(mediaSwarmJoin.webrtc.mediaSwarmJoin.swarmTicket, 'ticket.test');

    final mediaSwarmLeave = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcMediaSignal('media_swarm_leave', const {
        'media_swarm_id': 'sm1_test',
        'media_swarm_ticket': 'ticket.test',
      }),
    );
    expect(mediaSwarmLeave.webrtc.mediaSwarmLeave.swarmId, 'sm1_test');

    final mediaOffer = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeWebRtcMediaSignal('offer', const {
        'sdp': 'media-sdp',
        'type': 'offer',
        'to': 'usr_peer:conn_1',
        'media_swarm_id': 'sm1_test',
        'media_swarm_ticket': 'ticket.test',
      }),
    );
    expect(mediaOffer.webrtc.hasMediaOffer(), isTrue);
    expect(mediaOffer.webrtc.mediaOffer.to, 'usr_peer:conn_1');
    expect(mediaOffer.webrtc.mediaOffer.swarmId, 'sm1_test');
    expect(jsonDecode(mediaOffer.webrtc.mediaOffer.data), {
      'sdp': 'media-sdp',
      'type': 'offer',
    });

    expect(
      RoomRealtimeCodec.encodeWebRtcVoiceSignal('unknown', const {}),
      isEmpty,
    );
    expect(
      RoomRealtimeCodec.encodeWebRtcMediaSignal('unknown', const {}),
      isEmpty,
    );
  });

  test('API client resolves server-relative resource URLs', () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/synctv/api',
      session: SyncTvSession(),
    );
    expect(api.baseUrl, 'https://example.test/synctv');

    expect(
      api.resolveResourceUrl('/api/providers/proxy/emby/entry.mp4?token=abc'),
      'https://example.test/synctv/api/providers/proxy/emby/entry.mp4?token=abc',
    );
    expect(
      api.resolveResourceUrl('api/providers/emby/thumbnail/item_1'),
      'https://example.test/synctv/api/providers/emby/thumbnail/item_1',
    );
    expect(
      api.resolveResourceUrl('https://cdn.example.test/entry.mp4'),
      'https://cdn.example.test/entry.mp4',
    );
  });

  test(
    'provider bind aggregation follows available instance protobuf API',
    () async {
      final requests = <http.Request>[];
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        requests.add(http.Request(request.method, request.uri));
        request.response.headers.contentType = io.ContentType.json;

        final instanceName = request.uri.queryParameters['instanceName'] ?? '';
        if (request.uri.path == '/api/providers/instances/available') {
          request.response.write(
            jsonEncode({
              'instances': ['', 'edge', 'edge'],
            }),
          );
        } else if (request.uri.path == '/api/providers/alist/binds') {
          request.response.write(
            jsonEncode({
              'binds': instanceName == 'edge'
                  ? [
                      {
                        'id': 'alist_edge',
                        'serverId': 'alist_server_edge',
                        'host': 'https://alist-edge.example.test',
                        'username': 'edge-user',
                        'createdAt': 2,
                        'providerInstanceName': 'edge',
                      },
                    ]
                  : [
                      {
                        'id': 'alist_default_a',
                        'serverId': 'alist_server_default',
                        'host': 'https://alist.example.test',
                        'username': 'default-user',
                        'createdAt': 1,
                        'providerInstanceName': '',
                      },
                      {
                        'id': 'alist_default_b',
                        'serverId': 'alist_server_default',
                        'host': 'https://alist.example.test',
                        'username': 'default-user',
                        'createdAt': 1,
                        'providerInstanceName': '',
                      },
                    ],
            }),
          );
        } else if (request.uri.path == '/api/providers/emby/binds') {
          request.response.write(
            jsonEncode({
              'binds': [
                {
                  'id': instanceName == 'edge' ? 'emby_edge' : 'emby_default',
                  'serverId': instanceName == 'edge'
                      ? 'emby_server_edge'
                      : 'emby_server',
                  'host': instanceName == 'edge'
                      ? 'https://emby-edge.example.test'
                      : 'https://emby.example.test',
                  'userId': instanceName == 'edge'
                      ? 'edge-user'
                      : 'default-user',
                  'createdAt': instanceName == 'edge' ? 4 : 3,
                  'providerInstanceName': instanceName,
                },
              ],
            }),
          );
        } else if (request.uri.path == '/api/providers/bilibili/binds') {
          request.response.write(
            jsonEncode({
              'binds': [
                {
                  'id': instanceName == 'edge' ? 'bili_edge' : 'bili_default',
                  'serverId': instanceName == 'edge'
                      ? 'bili_server_edge'
                      : 'bili_server',
                  'createdAt': instanceName == 'edge' ? 6 : 5,
                  'providerInstanceName': instanceName,
                },
              ],
            }),
          );
        } else {
          request.response
            ..statusCode = 404
            ..write('{}');
        }
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final alistBinds = await SyncTvService.getAllAlistBindInfos();
        final embyBinds = await SyncTvService.getAllEmbyBindInfos();
        final bilibiliBinds = await SyncTvService.getAllBilibiliBindInfos();

        expect(alistBinds.map((bind) => bind.serverId), [
          'alist_server_default',
          'alist_server_edge',
        ]);
        expect(alistBinds.last.providerInstanceName, 'edge');
        expect(embyBinds.map((bind) => bind.providerInstanceName), [
          '',
          'edge',
        ]);
        expect(bilibiliBinds.map((bind) => bind.providerInstanceName), [
          '',
          'edge',
        ]);

        final availableRequests = requests.where(
          (request) => request.url.path == '/api/providers/instances/available',
        );
        expect(
          availableRequests.map(
            (request) => request.url.queryParameters['providerType'],
          ),
          ['alist', 'emby', 'bilibili'],
        );
        expect(
          requests.map(
            (request) =>
                '${request.url.path}?${request.url.queryParameters['instanceName'] ?? ''}',
          ),
          containsAll([
            '/api/providers/alist/binds?',
            '/api/providers/alist/binds?edge',
            '/api/providers/emby/binds?',
            '/api/providers/emby/binds?edge',
            '/api/providers/bilibili/binds?',
            '/api/providers/bilibili/binds?edge',
          ]),
        );
        expect(
          requests
              .where(
                (request) =>
                    request.url.path == '/api/providers/alist/binds' &&
                    !request.url.queryParameters.containsKey('instanceName'),
              )
              .length,
          1,
        );
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }
    },
  );

  test(
    'provider bind aggregation includes default local instance when discovery is empty',
    () async {
      final requests = <http.Request>[];
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        requests.add(http.Request(request.method, request.uri));
        request.response.headers.contentType = io.ContentType.json;
        if (request.uri.path == '/api/providers/instances/available') {
          request.response.write(jsonEncode({'instances': []}));
        } else if (request.uri.path == '/api/providers/alist/binds') {
          request.response.write(
            jsonEncode({
              'binds': [
                {
                  'id': 'alist_default',
                  'serverId': 'alist_server_default',
                  'host': 'https://alist.example.test',
                  'username': 'default-user',
                  'createdAt': 1,
                  'providerInstanceName': '',
                },
              ],
            }),
          );
        } else {
          request.response
            ..statusCode = 404
            ..write('{}');
        }
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final binds = await SyncTvService.getAllAlistBindInfos();

        expect(binds.map((bind) => bind.serverId), ['alist_server_default']);
        expect(binds.single.providerInstanceName, isEmpty);

        final paths = requests.map((request) => request.url.path);
        expect(paths, contains('/api/providers/instances/available'));
        expect(paths, contains('/api/providers/alist/binds'));
        expect(
          requests
              .where(
                (request) => request.url.path == '/api/providers/alist/binds',
              )
              .single
              .url
              .queryParameters,
          isNot(contains('instanceName')),
        );
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }
    },
  );

  test(
    'API client refreshes access token once before retrying request',
    () async {
      final requests = <http.Request>[];
      var persistedRefresh = false;
      var authErrors = 0;
      final session = SyncTvSession()
        ..updateAccountTokens(accessToken: 'expired-access')
        ..updateAccountTokens(refreshToken: 'refresh-token');
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: session,
        onAuthError: (_) => authErrors++,
        onTokenRefresh: (_) async => persistedRefresh = true,
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.url.path == '/api/user') {
            if (requests.where((item) => item.url.path == '/api/user').length ==
                1) {
              return http.Response(
                jsonEncode({'message': 'expired'}),
                401,
                headers: {'content-type': 'application/json'},
              );
            }
            expect(request.headers['authorization'], 'Bearer fresh-access');
            return http.Response(
              jsonEncode({'id': 'usr_1', 'username': 'alice'}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/auth/refresh') {
            expect(jsonDecode(request.body), {'refreshToken': 'refresh-token'});
            return http.Response(
              jsonEncode({
                'accessToken': 'fresh-access',
                'refreshToken': 'fresh-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final profile = await api.user.getProfile(client.GetProfileRequest());

      expect(profile.id, 'usr_1');
      expect(session.accessToken, 'fresh-access');
      expect(session.refreshToken, 'fresh-refresh');
      expect(persistedRefresh, isTrue);
      expect(authErrors, 0);
      expect(requests.map((request) => request.url.path), [
        '/api/user',
        '/api/auth/refresh',
        '/api/user',
      ]);
    },
  );

  test('signed upload 401 does not invalidate the user session', () async {
    var authErrors = 0;
    final session = SyncTvSession()
      ..updateAccountTokens(accessToken: 'user-access')
      ..updateAccountTokens(refreshToken: 'user-refresh');
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: session,
      onAuthError: (_) => authErrors++,
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({'message': 'Upload token expired'}),
          401,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );

    await expectLater(
      api.uploadRawBytes('/api/files/upload-object', const [
        1,
        2,
        3,
      ], contentType: 'application/octet-stream'),
      throwsA(
        isA<SyncTvApiException>().having(
          (error) => error.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
    expect(authErrors, 0);
    expect(session.accessToken, 'user-access');
    expect(session.refreshToken, 'user-refresh');
  });

  test(
    'API client keeps the refreshed session when retry returns a business 401',
    () async {
      final requests = <http.Request>[];
      var authErrors = 0;
      final session = SyncTvSession()
        ..updateAccountTokens(accessToken: 'access-token')
        ..updateAccountTokens(refreshToken: 'refresh-token');
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: session,
        onAuthError: (_) => authErrors++,
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.url.path == '/api/auth/refresh') {
            return http.Response(
              jsonEncode({
                'accessToken': 'fresh-access',
                'refreshToken': 'fresh-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/user') {
            return http.Response(
              jsonEncode({'message': 'Authentication failed'}),
              401,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('not found', 404);
        }),
      );

      await expectLater(
        api.user.getProfile(client.GetProfileRequest()),
        throwsA(
          isA<SyncTvApiException>().having(
            (error) => error.statusCode,
            'statusCode',
            401,
          ),
        ),
      );

      expect(session.accessToken, 'fresh-access');
      expect(session.refreshToken, 'fresh-refresh');
      expect(authErrors, 0);
      expect(requests.map((request) => request.url.path), [
        '/api/user',
        '/api/auth/refresh',
        '/api/user',
      ]);
    },
  );

  test(
    'late login response cannot overwrite the newly active server',
    () async {
      final responseCompleter = Completer<http.Response>();
      final requestStarted = Completer<void>();
      final session = SyncTvSession();
      final api = SyncTvApiClient(
        baseUrl: 'https://server-a.test',
        session: session,
        httpClient: MockClient((request) {
          requestStarted.complete();
          return responseCompleter.future;
        }),
      );

      final login = api.auth.loginWithDirectPassword(
        client.LoginWithDirectPasswordRequest(
          loginSessionId: 'login-a',
          password: 'password-a',
        ),
      );
      await requestStarted.future;
      api.baseUrl = 'https://server-b.test';
      session
        ..updateAccountTokens(accessToken: 'server-b-access')
        ..updateAccountTokens(refreshToken: 'server-b-refresh');
      responseCompleter.complete(
        http.Response(
          jsonEncode({
            'accessToken': 'server-a-access',
            'refreshToken': 'server-a-refresh',
          }),
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      await expectLater(login, throwsA(isA<SyncTvStaleEndpointException>()));
      expect(session.accessToken, 'server-b-access');
      expect(session.refreshToken, 'server-b-refresh');
    },
  );

  test('late unauthorized response cannot clear the active server', () async {
    final responseCompleter = Completer<http.Response>();
    final requestStarted = Completer<void>();
    var authErrors = 0;
    final session = SyncTvSession()
      ..updateAccountTokens(accessToken: 'server-a-access');
    final api = SyncTvApiClient(
      baseUrl: 'https://server-a.test',
      session: session,
      onAuthError: (_) => authErrors++,
      httpClient: MockClient((request) {
        requestStarted.complete();
        return responseCompleter.future;
      }),
    );

    final profile = api.user.getProfile(client.GetProfileRequest());
    await requestStarted.future;
    api.baseUrl = 'https://server-b.test';
    session.updateAccountTokens(accessToken: 'server-b-access');
    responseCompleter.complete(
      http.Response(
        jsonEncode({'message': 'expired server-a token'}),
        401,
        headers: {'content-type': 'application/json'},
      ),
    );

    await expectLater(profile, throwsA(isA<SyncTvStaleEndpointException>()));
    expect(authErrors, 0);
    expect(session.accessToken, 'server-b-access');
  });

  test('token refresh is isolated by endpoint generation', () async {
    final serverARefresh = Completer<http.Response>();
    final serverARefreshStarted = Completer<void>();
    var serverBProfileRequests = 0;
    var serverBRefreshRequests = 0;
    final session = SyncTvSession()
      ..updateAccountTokens(accessToken: 'server-a-expired')
      ..updateAccountTokens(refreshToken: 'server-a-refresh');
    final api = SyncTvApiClient(
      baseUrl: 'https://server-a.test',
      session: session,
      httpClient: MockClient((request) {
        if (request.url.host == 'server-a.test' &&
            request.url.path == '/api/user') {
          return Future.value(
            http.Response(
              jsonEncode({'message': 'expired'}),
              401,
              headers: {'content-type': 'application/json'},
            ),
          );
        }
        if (request.url.host == 'server-a.test' &&
            request.url.path == '/api/auth/refresh') {
          serverARefreshStarted.complete();
          return serverARefresh.future;
        }
        if (request.url.host == 'server-b.test' &&
            request.url.path == '/api/user') {
          serverBProfileRequests++;
          if (serverBProfileRequests == 1) {
            return Future.value(
              http.Response(
                jsonEncode({'message': 'expired'}),
                401,
                headers: {'content-type': 'application/json'},
              ),
            );
          }
          return Future.value(
            http.Response(
              jsonEncode({'id': 'user-b', 'username': 'server-b-user'}),
              200,
              headers: {'content-type': 'application/json'},
            ),
          );
        }
        if (request.url.host == 'server-b.test' &&
            request.url.path == '/api/auth/refresh') {
          serverBRefreshRequests++;
          return Future.value(
            http.Response(
              jsonEncode({
                'accessToken': 'server-b-fresh',
                'refreshToken': 'server-b-fresh-refresh',
              }),
              200,
              headers: {'content-type': 'application/json'},
            ),
          );
        }
        return Future.value(http.Response('not found', 404));
      }),
    );

    final serverAProfile = api.user.getProfile(client.GetProfileRequest());
    await serverARefreshStarted.future;
    api.baseUrl = 'https://server-b.test';
    session
      ..updateAccountTokens(accessToken: 'server-b-expired')
      ..updateAccountTokens(refreshToken: 'server-b-refresh');

    final serverBProfile = await api.user.getProfile(
      client.GetProfileRequest(),
    );
    expect(serverBProfile.id, 'user-b');
    expect(serverBRefreshRequests, 1);
    expect(session.accessToken, 'server-b-fresh');

    serverARefresh.complete(
      http.Response(
        jsonEncode({
          'accessToken': 'server-a-fresh',
          'refreshToken': 'server-a-fresh-refresh',
        }),
        200,
        headers: {'content-type': 'application/json'},
      ),
    );
    await expectLater(
      serverAProfile,
      throwsA(isA<SyncTvStaleEndpointException>()),
    );
    expect(session.accessToken, 'server-b-fresh');
    expect(session.refreshToken, 'server-b-fresh-refresh');
  });

  test(
    'service fetches a single media record from protobuf endpoint',
    () async {
      Uri? requestedUri;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            jsonEncode({
              'id': 'med_1',
              'roomId': 'room_1',
              'sourceProvider':
                  source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL.value,
              'name': 'Feature',
              'creatorId': 'user_1',
              'providerInstanceName': 'edge',
              'position': 12.5,
              'addedAt': '1760000100',
              'availability': client
                  .ResourceAvailability
                  .RESOURCE_AVAILABILITY_CREATOR_INACTIVE
                  .value,
              'version': '91',
              'metadata': {'source': '/api/providers/proxy/direct/feature.mp4'},
              'sourceConfig': {
                'directUrl': {
                  'medias': [
                    {'url': 'https://origin.example/feature.mp4'},
                  ],
                },
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final media = api.mapMedia(
        await api.room.getMedia(
          'room_1',
          client.GetMediaRequest(mediaId: 'med_1'),
        ),
      );

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/rooms/room_1/media/med_1');
      expect(media.id, 'med_1');
      expect(media.name, 'Feature');
      expect(media.url, 'https://origin.example/feature.mp4');
      expect(media.creator, 'user_1');
      expect(media.roomId, 'room_1');
      expect(media.position, 12.5);
      expect(media.addedAt, 1760000100);
      expect(
        media.sourceProvider,
        source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
      );
      expect(media.providerInstanceName, 'edge');
      expect(
        media.availability,
        client.ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
      );
      expect(media.version, 91);
      expect(media.proxy, isFalse);
      expect(media.headers, isEmpty);
      expect(media.sourceConfig['url'], 'https://origin.example/feature.mp4');
      expect(
        media.metadata['source'],
        '/api/providers/proxy/direct/feature.mp4',
      );
    },
  );

  test(
    'service fetches playlist and media details from protobuf endpoints',
    () async {
      final requests = <http.Request>[];
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final listener = server.listen((request) async {
        requests.add(http.Request(request.method, request.uri));
        request.response.headers.contentType = io.ContentType.json;
        if (request.uri.path == '/api/rooms/room_1/playlists/pl_1') {
          request.response.write(
            jsonEncode({
              'playlist': {
                'id': 'pl_1',
                'roomId': 'room_1',
                'name': 'Season 1',
                'parentId': '',
                'isDynamic': true,
                'sourceProvider':
                    source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value,
                'providerInstanceName': 'alist_main',
                'sourceConfig': {
                  'alist': {'path': '/shows/season-1'},
                },
              },
              'childPlaylistCount': 2,
              'mediaCount': 8,
            }),
          );
        } else if (request.uri.path == '/api/rooms/room_1/media/med_1') {
          request.response.write(
            jsonEncode({
              'id': 'med_1',
              'roomId': 'room_1',
              'sourceProvider':
                  source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL.value,
              'name': 'Episode 1',
              'creatorId': 'usr_creator',
              'providerInstanceName': 'edge',
              'metadata': {'url': '/api/providers/proxy/direct/episode-1.mp4'},
              'sourceConfig': {
                'directUrl': {
                  'medias': [
                    {'url': 'https://origin.example/episode-1.mp4'},
                  ],
                },
              },
            }),
          );
        } else {
          request.response.statusCode = 404;
          request.response.write('{}');
        }
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final playlist = await SyncTvService.getPlaylist('room_1', 'pl_1');
        final media = await SyncTvService.getMedia('room_1', 'med_1');

        expect(playlist.playlist.id, 'pl_1');
        expect(playlist.playlist.name, 'Season 1');
        expect(playlist.playlist.isPlaylist, isTrue);
        expect(playlist.playlist.playbackPlaylistId, 'pl_1');
        expect(playlist.playlist.metadata['isDynamic'], isTrue);
        expect(
          playlist.playlist.sourceProvider,
          source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
        );
        expect(playlist.playlist.providerInstanceName, 'alist_main');
        expect(playlist.playlist.sourceConfig['path'], '/shows/season-1');
        expect(playlist.childPlaylistCount, 2);
        expect(playlist.mediaCount, 8);
        expect(media.id, 'med_1');
        expect(media.creator, 'usr_creator');
        expect(media.proxy, isFalse);
        expect(media.url, 'https://origin.example/episode-1.mp4');
        expect(
          media.sourceConfig['url'],
          'https://origin.example/episode-1.mp4',
        );
        expect(requests.map((request) => request.url.path), [
          '/api/rooms/room_1/playlists/pl_1',
          '/api/rooms/room_1/media/med_1',
        ]);
      } finally {
        await listener.cancel();
        await server.close(force: true);
      }
    },
  );

  test(
    'watch playlist items query is derived from protobuf requests',
    () async {
      Uri? requestedUri;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            '',
            200,
            headers: {'content-type': 'text/event-stream'},
          );
        }),
      );

      await api.room
          .watchPlaylistItems(
            'room_1',
            client.WatchPlaylistItemsRequest(
              deliveryMode: client
                  .ResourceDeliveryMode
                  .RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
              playlistItems: client.ObservePlaylistItems(
                afterEventSequence: Int64(7),
                request: client.ListPlaylistItemsRequest(
                  playlistId: 'playlist_1',
                  target: testProviderTarget('season-1'),
                  page: client.PagePagination(page: 2),
                  pageSize: 25,
                  search: 'matrix',
                  sourceProvider:
                      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
                  providerInstanceName: 'home',
                  sortBy: client.MediaListSortBy.MEDIA_LIST_SORT_BY_NAME,
                  sortDirection: client.SortDirection.SORT_DIRECTION_DESC,
                  availability: client
                      .ResourceAvailabilityFilter
                      .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
                ),
              ),
            ),
          )
          .drain<void>();

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/rooms/room_1/watch/playlist-items');
      expect(
        requestedUri!.queryParameters,
        containsPair('afterEventSequence', '7'),
      );
      expect(
        requestedUri!.queryParameters,
        containsPair(
          'deliveryMode',
          client_enum
              .ResourceDeliveryMode
              .RESOURCE_DELIVERY_MODE_NOTIFY_ONLY
              .value
              .toString(),
        ),
      );
      expect(
        requestedUri!.queryParameters,
        containsPair('playlistId', 'playlist_1'),
      );
      expect(
        requestedUri!.queryParameters,
        containsPair('target', '{"alist":{"relativePath":"season-1"}}'),
      );
      expect(requestedUri!.queryParameters, containsPair('page', '2'));
      expect(requestedUri!.queryParameters, containsPair('pageSize', '25'));
      expect(requestedUri!.queryParameters, containsPair('search', 'matrix'));
      expect(
        requestedUri!.queryParameters,
        containsPair(
          'sourceProvider',
          source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value.toString(),
        ),
      );
      expect(
        requestedUri!.queryParameters,
        containsPair('providerInstanceName', 'home'),
      );
      expect(requestedUri!.queryParameters, containsPair('sortBy', '2'));
      expect(requestedUri!.queryParameters, containsPair('sortDirection', '2'));
      expect(requestedUri!.queryParameters, containsPair('availability', '1'));
    },
  );

  test('watch playlist items sends a flat cursor query', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '',
          200,
          headers: {'content-type': 'text/event-stream'},
        );
      }),
    );

    await api.room
        .watchPlaylistItems(
          'room_1',
          client.WatchPlaylistItemsRequest(
            playlistItems: client.ObservePlaylistItems(
              request: client.ListPlaylistItemsRequest(
                playlistId: 'playlist_1',
                cursor: client.CursorPagination(cursor: 'cursor-2'),
                pageSize: 25,
              ),
            ),
          ),
        )
        .drain<void>();

    expect(requestedUri, isNotNull);
    expect(requestedUri!.queryParameters, containsPair('cursor', 'cursor-2'));
    expect(requestedUri!.queryParameters.containsKey('page'), isFalse);
  });

  test('playlist items watch decodes nested protobuf JSON bytes payloads', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/playlist-items');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType(
          'text',
          'event-stream',
          charset: 'utf-8',
        )
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
            'observeId': 'playlist-items',
            'version': 'items-v2',
            'playlistItems': {
              'playlists': [
                {
                  'id': 'pl_dynamic',
                  'roomId': 'room_1',
                  'name': 'Season 1',
                  'sourceProvider': source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value,
                  'providerInstanceName': 'main',
                  'isDynamic': true,
                  'sourceConfig': {
                    'alist': {'path': '/shows/season-1'},
                  },
                },
              ],
              'media': [
                {
                  'id': 'med_1',
                  'roomId': 'room_1',
                  'sourceProvider': source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL.value,
                  'name': 'Episode 1',
                  'creatorId': 'usr_creator',
                  'metadata': {'source': '/api/media/med_1/stream'},
                  'sourceConfig': {
                    'directUrl': {
                      'medias': [
                        {'url': 'https://origin.example/episode-1.mp4'},
                      ],
                    },
                  },
                },
              ],
              'dynamicItems': [
                {
                  'name': 'Remote Episode',
                  'item_type': client.ItemType.ITEM_TYPE_MEDIA.value,
                  'target': {
                    'alist': {'relativePath': '/remote/episode-1.mkv'},
                  },
                  'size': '123456',
                  'thumbnail': 'https://img.example/ep1.jpg',
                  'mediaSourceConfig': {
                    'bilibili': {
                      'video': {'bvid': 'BV1preview', 'aid': '100', 'cid': '200', 'shared': true},
                    },
                  },
                },
              ],
              'currentPath': [
                {
                  'name': 'Season 1',
                  'target': {
                    'alist': {'relativePath': 'season-1'},
                  },
                },
              ],
              'version': 'snapshot-v2',
            },
          })}\n\n',
        );
      await request.response.close();
    });

    try {
      final api = SyncTvApiClient(
        baseUrl: 'http://${server.address.host}:${server.port}',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      );

      final event = await api.room
          .watchPlaylistItems(
            'room_1',
            client.WatchPlaylistItemsRequest(
              playlistItems: client.ObservePlaylistItems(
                request: client.ListPlaylistItemsRequest(
                  playlistId: 'pl_dynamic',
                ),
              ),
            ),
          )
          .first;

      expect(event.hasResourceEvent(), isTrue);
      final snapshot = event.resourceEvent.playlistItems;
      expect(snapshot.version, 'snapshot-v2');
      expect(
        SourceConfigCodec.playlistSourceConfigToMap(
          snapshot.playlists.single.sourceConfig,
        ),
        {'path': '/shows/season-1'},
      );
      expect(resourceMetadataToJson(snapshot.media.single.metadata), {
        'source': '/api/media/med_1/stream',
      });
      expect(
        SourceConfigCodec.mediaSourceConfigToMap(
          snapshot.media.single.sourceConfig,
        ),
        {'url': 'https://origin.example/episode-1.mp4'},
      );
      expect(testProviderTargetJson(snapshot.dynamicItems.single.target), {
        'relativePath': '/remote/episode-1.mkv',
      });
      expect(
        SourceConfigCodec.mediaSourceConfigToMap(
          snapshot.dynamicItems.single.mediaSourceConfig,
        ),
        {
          'kind': 'video',
          'type': 'video',
          'bvid': 'BV1preview',
          'aid': 100,
          'cid': 200,
          'shared': true,
        },
      );
      expect(testProviderTargetJson(snapshot.currentPath.single.target), {
        'relativePath': 'season-1',
      });
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test(
    'list playlists page preserves protobuf filters sorting and total',
    () async {
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        requestedUri = request.uri;
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'playlists': [
                {
                  'id': 'pl_1',
                  'roomId': 'room_1',
                  'name': 'Movies',
                  'sourceProvider':
                      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value,
                  'providerInstanceName': 'home',
                  'isDynamic': true,
                  'position': 4.5,
                  'itemCount': 12,
                  'createdAt': '1760000200',
                  'updatedAt': '1760000300',
                  'availability': client
                      .ResourceAvailability
                      .RESOURCE_AVAILABILITY_AVAILABLE
                      .value,
                  'browseAccessMode': client_enum
                      .PlaylistBrowseAccessMode
                      .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS
                      .value,
                  'version': '92',
                },
              ],
              'total': 5,
            }),
          );
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final page = await SyncTvService.listPlaylistsPage(
          'room_1',
          parentId: 'pl_parent',
          page: 2,
          pageSize: 25,
          search: 'movie',
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
          providerInstanceName: 'home',
          dynamicOnly: true,
          sortBy: client_enum.PlaylistListSortBy.PLAYLIST_LIST_SORT_BY_NAME,
          sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
          availability: client_enum
              .ResourceAvailabilityFilter
              .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
        );

        expect(page.total, 5);
        expect(page.page, 2);
        expect(page.pageSize, 25);
        expect(page.playlists.single.id, 'pl_1');
        expect(page.playlists.single.type, 'emby');
        expect(page.playlists.single.roomId, 'room_1');
        expect(page.playlists.single.position, 4.5);
        expect(page.playlists.single.itemCount, 12);
        expect(page.playlists.single.createdAt, 1760000200);
        expect(page.playlists.single.updatedAt, 1760000300);
        expect(
          page.playlists.single.availability,
          client.ResourceAvailability.RESOURCE_AVAILABILITY_AVAILABLE,
        );
        expect(
          page.playlists.single.browseAccessMode,
          client_enum
              .PlaylistBrowseAccessMode
              .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS,
        );
        expect(page.playlists.single.version, 92);
        expect(requestedUri!.path, '/api/rooms/room_1/playlists');
        expect(
          requestedUri!.queryParameters,
          containsPair('parentId', 'pl_parent'),
        );
        expect(requestedUri!.queryParameters, containsPair('page', '2'));
        expect(requestedUri!.queryParameters, containsPair('pageSize', '25'));
        expect(requestedUri!.queryParameters, containsPair('search', 'movie'));
        expect(
          requestedUri!.queryParameters,
          containsPair(
            'sourceProvider',
            source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value.toString(),
          ),
        );
        expect(
          requestedUri!.queryParameters,
          containsPair('providerInstanceName', 'home'),
        );
        expect(
          requestedUri!.queryParameters,
          containsPair('dynamicOnly', 'true'),
        );
        expect(requestedUri!.queryParameters, containsPair('sortBy', '2'));
        expect(
          requestedUri!.queryParameters,
          containsPair('sortDirection', '2'),
        );
        expect(
          requestedUri!.queryParameters,
          containsPair('availability', '1'),
        );
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }
    },
  );

  test('SSE watch refreshes access token before retrying stream', () async {
    final requests = <http.BaseRequest>[];
    var persistedRefresh = false;
    var authErrors = 0;
    final session = SyncTvSession()
      ..updateAccountTokens(accessToken: 'expired-access')
      ..updateAccountTokens(refreshToken: 'refresh-token');
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      onAuthError: (_) => authErrors++,
      onTokenRefresh: (_) async => persistedRefresh = true,
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/rooms/room_1/watch/room-members') {
          if (requests
                  .where(
                    (item) =>
                        item.url.path == '/api/rooms/room_1/watch/room-members',
                  )
                  .length ==
              1) {
            return http.Response(
              jsonEncode({'message': 'expired'}),
              401,
              headers: {'content-type': 'application/json'},
            );
          }
          expect(request.headers['authorization'], 'Bearer fresh-access');
          return http.Response(
            'event: observed\n'
            'data: {"observeId":"room-members","eventCursor":{"eventId":"members-v2"},"changed":false}\n\n',
            200,
            headers: {'content-type': 'text/event-stream'},
          );
        }
        if (request.url.path == '/api/auth/refresh') {
          return http.Response(
            jsonEncode({
              'accessToken': 'fresh-access',
              'refreshToken': 'fresh-refresh',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('not found', 404);
      }),
    );

    final event = await api.room
        .watchRoomMemberEvents('room_1', client.WatchRoomMemberEventsRequest())
        .first;

    expect(event.observed.eventCursor.eventId, 'members-v2');
    expect(session.accessToken, 'fresh-access');
    expect(session.refreshToken, 'fresh-refresh');
    expect(persistedRefresh, isTrue);
    expect(authErrors, 0);
    expect(requests.map((request) => request.url.path), [
      '/api/rooms/room_1/watch/room-members',
      '/api/auth/refresh',
      '/api/rooms/room_1/watch/room-members',
    ]);
  });

  test('room settings watch decodes protobuf JSON settings payload', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/room-settings');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType(
          'text',
          'event-stream',
          charset: 'utf-8',
        )
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
            'observeId': 'room-settings',
            'eventCursor': {'sequence': 99},
            'roomSettings': {
              'roomId': 'room_1',
              'version': 99,
              'settings': {'allowGuestJoin': true, 'requireApproval': true, 'maxMembers': 42, 'chatEnabled': false, 'voiceChatEnabled': false, 'p2pMediaEnabled': false},
            },
          })}\n\n',
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final event = await SyncTvService.watchRoomSettings(
        'room_1',
      ).firstWhere((event) => event is RoomResourceChanged<SyncTvRoomSettings>);
      final changed = event as RoomResourceChanged<SyncTvRoomSettings>;

      expect(changed.version, '99');
      expect(changed.snapshot, isNotNull);
      expect(changed.snapshot!.allowGuestJoin, isTrue);
      expect(changed.snapshot!.requireApproval, isTrue);
      expect(changed.snapshot!.maxMembers, 42);
      expect(changed.snapshot!.chatEnabled, isFalse);
      expect(changed.snapshot!.voiceChatEnabled, isFalse);
      expect(changed.snapshot!.p2pMediaEnabled, isFalse);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test(
    'dynamic playlist item mapping keeps target for browsing and playback',
    () {
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession(),
      );
      final target = testProviderTarget('/shows/ep1.mkv');
      final encodedTarget = testProviderTargetToken(target);

      final entry = api.mapDynamicItem(
        client.PlaylistItem(
          name: 'Episode 1',
          itemType: client.ItemType.ITEM_TYPE_MEDIA,
          target: target,
          thumbnail: '/covers/ep1.jpg',
        ),
        playlistId: 'pl_dynamic',
      );

      expect(entry.parentId, 'pl_dynamic');
      expect(entry.id, encodedTarget);
      expect(entry.subPath, encodedTarget);
      expect(entry.coverUrl, 'https://example.test/covers/ep1.jpg');
      expect(entry.metadata['target_json'], {'relativePath': '/shows/ep1.mkv'});
    },
  );

  test('realtime dynamic playlist items keep observed playlist parent id', () {
    final target = testProviderTarget('/shows/ep1.mkv');
    final encodedTarget = testProviderTargetToken(target);
    RoomRealtimeCodec.encodePlaylistObservation(
      observeId: 'playlistItems',
      playlistId: 'pl_dynamic',
      target: testProviderTargetToken(testProviderTarget('/shows')),
    );

    final message = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'playlistItems',
          playlistItems: client.ListPlaylistItemsResponse(
            dynamicItems: [
              client.PlaylistItem(
                name: 'Episode 1',
                itemType: client.ItemType.ITEM_TYPE_MEDIA,
                target: target,
              ),
            ],
            currentPath: [
              client.PlaylistBrowsePathNode(
                name: 'Season 1',
                target: testProviderTarget('/shows'),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );

    final entry = message.mediaLibrary!.dynamicItems.single;
    expect(entry.parentId, 'pl_dynamic');
    expect(entry.subPath, encodedTarget);
    expect(entry.playbackPlaylistId, 'pl_dynamic');
    expect(entry.playbackTarget, encodedTarget);
  });

  test(
    'dynamic playlist playback sends playlist target protobuf body',
    () async {
      final requestBodies = <String>[];
      final requestedUris = <Uri>[];
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final origin = 'http://${server.address.host}:${server.port}';
      final requests = server.listen((request) async {
        requestedUris.add(request.uri);
        requestBodies.add(await utf8.decoder.bind(request).join());
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write('{}');
        await request.response.close();
      });
      final target = testProviderTarget('/shows/ep1.mkv');
      final encodedTarget = testProviderTargetToken(target);

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(origin);

        await SyncTvService.switchMedia(
          'room_1',
          encodedTarget,
          subPath: encodedTarget,
          playlistId: 'pl_dynamic',
        );
      } finally {
        await requests.cancel();
        await server.close(force: true);
      }

      expect(requestedUris.first.path, '/api/rooms/room_1/playback/start');
      final body = jsonDecode(requestBodies.first) as Map<String, dynamic>;
      expect(body['mediaId'], '');
      expect(body['playlistId'], 'pl_dynamic');
      expect(body['target'], {
        'alist': {'relativePath': '/shows/ep1.mkv'},
      });
    },
  );

  test(
    'invalid playback entry IDs are rejected before a stop-like request',
    () async {
      var requestCount = 0;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestCount++;
          return http.Response('{}', 200);
        }),
      );
      final domain = SyncTvRoomMediaDomainService(api);

      await expectLater(
        domain.switchMedia('room_1', 'media_10'),
        throwsA(isA<ArgumentError>()),
      );
      expect(requestCount, 0);
    },
  );

  test('switch playback entry and play uses the start response', () async {
    final requestUris = <Uri>[];
    final requestBodies = <String>[];
    final requestMethods = <String>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestUris.add(request.uri);
      requestMethods.add(request.method);
      requestBodies.add(await utf8.decoder.bind(request).join());
      switch (request.uri.path) {
        case '/api/rooms/room_1/playback/start':
          request.response
            ..statusCode = 200
            ..headers.contentType = io.ContentType.json
            ..write(
              jsonEncode({
                'roomId': 'room_1',
                'playingMediaId': 'med_1',
                'position': 0.0,
                'speed': 1.0,
                'isPlaying': true,
                'version': '8',
              }),
            );
        default:
          request.response
            ..statusCode = 404
            ..write('unexpected ${request.method} ${request.uri}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final playback = await SyncTvService.switchMediaAndPlay(
        'room_1',
        'med_1',
      );

      expect(playback.isPlaying, isTrue);
      expect(playback.playingMediaId, 'med_1');
      expect(
        List.generate(
          requestUris.length,
          (index) => '${requestMethods[index]} ${requestUris[index].path}',
        ),
        ['POST /api/rooms/room_1/playback/start'],
      );
      final startBody = jsonDecode(requestBodies[0]) as Map<String, dynamic>;
      final operationId = startBody.remove('clientOperationId');
      expect(startBody, {'mediaId': 'med_1', 'playlistId': ''});
      expect(
        operationId,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ),
        ),
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('playback mapping preserves mode and url choices', () {
    final entry = RoomMediaEntry.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_1',
        roomId: 'room_1',
        name: 'Multi Source',
        playlistPosition: 3.5,
        provider: source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
        providerInstanceName: 'alist_main',
        playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
        metadata: client.PlaybackMetadata(
          live: client.LivePlaybackMetadata(
            mediaId: 'med_1',
            roomId: 'room_1',
            availability:
                client.LiveStreamAvailability.LIVE_STREAM_AVAILABILITY_LIVE,
            streamGenerationId: 'generation-1',
          ),
        ),
        expiresAt: Int64(1700000000),
        durationSeconds: 3661.5,
        playbackInfos: [
          MapEntry(
            'direct',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Original',
                  url: 'http://origin.test/video.mp4',
                  headers: const {'Authorization': 'Bearer media'}.entries,
                  metadata: client.PlaybackMediaMetadata(
                    resolution: '1920x1080',
                    codec: 'h264',
                  ),
                  format: 'mp4',
                ),
                client.PlaybackMedia(
                  name: 'Original DASH',
                  url: 'http://origin.test/video.mpd',
                  format: 'dash',
                ),
              ],
              subtitles: [
                client.PlaybackSubtitle(
                  name: '中文',
                  url: 'http://origin.test/video.srt',
                  headers: const {'Referer': 'https://subtitle.test/'}.entries,
                  format: 'srt',
                  expireAt: Int64(1785923000),
                  p2pDelivery: client.P2pResourceDelivery(
                    swarmId: 'sm3_subtitle',
                    swarmTicket: 'subtitle-ticket',
                  ),
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: '弹幕',
                  url: 'http://origin.test/danmaku.xml',
                  headers: const {'User-Agent': 'danmaku-client'}.entries,
                  format: 'xml',
                  delivery: client
                      .PlaybackDanmakuDelivery
                      .PLAYBACK_DANMAKU_DELIVERY_DOCUMENT,
                  expireAt: Int64(1785923100),
                  p2pDelivery: client.P2pResourceDelivery(
                    swarmId: 'sm3_danmaku',
                    swarmTicket: 'danmaku-ticket',
                  ),
                ),
                client.PlaybackDanmaku(
                  name: '实时弹幕',
                  url: '/live-danmaku/stream',
                  format: 'synctv-bilibili-live',
                  delivery: client
                      .PlaybackDanmakuDelivery
                      .PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM,
                  p2pDelivery: client.P2pResourceDelivery(
                    swarmId: 'sm3_invalid_live',
                    swarmTicket: 'invalid-live-ticket',
                  ),
                ),
              ],
            ),
          ),
          MapEntry(
            'proxied',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Proxy 720P',
                  url: '/proxy/video-720.m3u8',
                  metadata: client.PlaybackMediaMetadata(
                    resolution: '1280x720',
                    codec: 'h264',
                  ),
                  format: 'hls',
                ),
                client.PlaybackMedia(
                  name: 'Proxy 1080P',
                  url: '/proxy/video-1080.m3u8',
                  expireAt: Int64(1785923199),
                  metadata: client.PlaybackMediaMetadata(
                    resolution: '1920x1080',
                    codec: 'hevc',
                  ),
                  format: 'hls',
                  p2pDelivery: client.P2pResourceDelivery(
                    swarmId: 'sm2_server_approved',
                    swarmTicket: 'ticket',
                  ),
                ),
              ],
              defaultMediaIndex: 1,
            ),
          ),
        ],
        defaultMode: 'proxied',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(entry.url, 'https://example.test/proxy/video-1080.m3u8');
    expect(entry.roomId, 'room_1');
    expect(entry.position, 3.5);
    expect(entry.live, isTrue);
    expect(entry.liveStreamAvailability, SyncTvLiveStreamAvailability.live);
    expect(entry.liveStreamGenerationId, 'generation-1');
    expect(
      entry.sourceProvider,
      source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
    );
    expect(entry.providerInstanceName, 'alist_main');
    expect(entry.playbackExpireAt, 1700000000);
    expect(entry.metadata.containsKey('expiresAt'), isFalse);
    expect(entry.metadata['durationSeconds'], 3661.5);
    expect(entry.playbackModes, hasLength(2));
    expect(entry.hasPlaybackChoices, isTrue);
    expect(entry.selectedPlaybackMode, 'proxied');
    expect(entry.selectedPlaybackUrlIndex, 1);
    expect(entry.playbackModes.first.key, 'proxied');
    expect(
      entry.selectedPlaybackUrlOption?.p2pDelivery?.swarmId,
      'sm2_server_approved',
    );
    expect(entry.selectedPlaybackUrlOption?.format, 'hls');
    expect(entry.selectedPlaybackUrlOption?.expireAt, 1785923199);
    final switched = entry.selectPlayback(
      modeKey: 'direct',
      urlIndex: 0,
      resolveUrl: (url) => url,
    );
    expect(switched.url, 'http://origin.test/video.mp4');
    expect(switched.headers, {'Authorization': 'Bearer media'});
    expect(switched.type, 'mp4');
    expect(switched.subtitles, isNotNull);
    expect(switched.subtitles?['sub_0']['headers'], {
      'Referer': 'https://subtitle.test/',
    });
    expect(switched.subtitles?['sub_0']['expireAt'], 1785923000);
    expect(switched.subtitles?['sub_0']['p2pDelivery'].swarmId, 'sm3_subtitle');
    expect(switched.danmu, 'http://origin.test/danmaku.xml');
    expect(switched.danmuHeaders, {'User-Agent': 'danmaku-client'});
    expect(switched.danmuP2pDelivery?.swarmId, 'sm3_danmaku');
    expect(switched.streamDanmu, 'https://example.test/live-danmaku/stream');
    expect(switched.playbackChoiceLabel, contains('原始'));

    final selectedAlternateFormat = entry.selectPlayback(
      modeKey: 'direct',
      urlIndex: 1,
      resolveUrl: (url) => url,
    );
    expect(selectedAlternateFormat.type, 'dash');
  });

  test(
    'playback mapping keeps static danmaku delivery bound to the selected resource',
    () {
      final entry = RoomMediaEntry.fromPlaybackProto(
        client.Playback(
          mediaId: 'med_danmaku',
          name: 'Danmaku source',
          playbackInfos: [
            MapEntry(
              'direct',
              client.PlaybackInfo(
                medias: [
                  client.PlaybackMedia(
                    name: 'Video',
                    url: 'https://origin.test/video.mp4',
                    format: 'mp4',
                  ),
                ],
                danmakus: [
                  client.PlaybackDanmaku(
                    name: 'Preferred static danmaku',
                    url: 'https://origin.test/preferred.xml',
                    headers: const {'X-Danmaku': 'preferred'}.entries,
                    format: 'xml',
                    delivery: client
                        .PlaybackDanmakuDelivery
                        .PLAYBACK_DANMAKU_DELIVERY_DOCUMENT,
                  ),
                  client.PlaybackDanmaku(
                    name: 'Alternate static danmaku',
                    url: 'https://origin.test/alternate.xml',
                    headers: const {'X-Danmaku': 'alternate'}.entries,
                    format: 'xml',
                    delivery: client
                        .PlaybackDanmakuDelivery
                        .PLAYBACK_DANMAKU_DELIVERY_DOCUMENT,
                    p2pDelivery: client.P2pResourceDelivery(
                      swarmId: 'sm3_alternate',
                      swarmTicket: 'alternate-ticket',
                    ),
                  ),
                  client.PlaybackDanmaku(
                    name: 'Live danmaku',
                    url: '/live-danmaku/med_danmaku',
                    headers: const {'X-Danmaku': 'live'}.entries,
                    format: 'synctv-bilibili-live',
                    delivery: client
                        .PlaybackDanmakuDelivery
                        .PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM,
                    p2pDelivery: client.P2pResourceDelivery(
                      swarmId: 'sm3_live',
                      swarmTicket: 'live-ticket',
                    ),
                  ),
                ],
              ),
            ),
          ],
          defaultMode: 'direct',
        ),
        resolveUrl: (url) =>
            url.startsWith('/') ? 'https://example.test$url' : url,
      );

      expect(entry.danmu, 'https://origin.test/preferred.xml');
      expect(entry.danmuHeaders, {'X-Danmaku': 'preferred'});
      expect(entry.danmuP2pDelivery, isNull);
      expect(
        entry.streamDanmu,
        'https://example.test/live-danmaku/med_danmaku',
      );
      expect(entry.streamDanmuHeaders, {'X-Danmaku': 'live'});
    },
  );

  test('playback mapping preserves Bilibili live start time', () {
    final entry = RoomMediaEntry.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_bilibili_live',
        name: 'Bilibili Live',
        playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
        metadata: client.PlaybackMetadata(
          bilibili: client.BilibiliPlaybackMetadata(
            roomId: Int64(21292831),
            liveStartedAt: Int64(1785919599),
          ),
        ),
        playbackInfos: [
          MapEntry(
            'direct',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'HLS',
                  url: 'https://live.example.test/index.m3u8',
                  format: 'hls',
                  expireAt: Int64(1785923199),
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'direct',
      ),
    );

    expect(entry.live, isTrue);
    expect(entry.liveStartedAt, 1785919599);
    expect(entry.selectedPlaybackUrlOption?.expireAt, 1785923199);
  });

  test('playback mapping routes live danmaku to stream channel', () {
    final entry = RoomMediaEntry.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_1',
        name: 'Bilibili Live Source',
        playbackInfos: [
          MapEntry(
            'direct',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'File',
                  url: 'http://origin.test/video.mp4',
                  format: 'mp4',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: 'XML',
                  url: 'http://origin.test/danmaku.xml',
                  format: 'xml',
                  delivery: client
                      .PlaybackDanmakuDelivery
                      .PLAYBACK_DANMAKU_DELIVERY_DOCUMENT,
                ),
              ],
            ),
          ),
          MapEntry(
            'bilibili_live',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Live',
                  url:
                      '/api/playback-providers/r/bilibili/v1/media-streams/live/0?sig=s&uid=u&exp=1',
                  format: 'flv',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: 'Live Danmaku',
                  url:
                      '/api/playback-providers/r/bilibili/live-danmaku/med_public',
                  headers: const {'X-Live': '1'}.entries,
                  format: 'synctv-bilibili-live',
                  delivery: client
                      .PlaybackDanmakuDelivery
                      .PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM,
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'direct',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(entry.danmu, 'http://origin.test/danmaku.xml');
    expect(entry.streamDanmu, isNull);
    expect(
      entry.playbackModes.singleWhere((mode) => mode.key == 'direct').danmu,
      'http://origin.test/danmaku.xml',
    );

    final live = entry.selectPlayback(
      modeKey: 'bilibili_live',
      urlIndex: 0,
      resolveUrl: (url) => url,
    );
    expect(
      live.url,
      'https://example.test/api/playback-providers/r/bilibili/v1/media-streams/live/0?sig=s&uid=u&exp=1',
    );
    expect(live.danmu, isNull);
    expect(
      live.streamDanmu,
      'https://example.test/api/playback-providers/r/bilibili/live-danmaku/med_public',
    );
    expect(live.streamDanmuHeaders, {'X-Live': '1'});
    expect(
      live.playbackModes
          .singleWhere((mode) => mode.key == 'bilibili_live')
          .streamDanmu,
      'https://example.test/api/playback-providers/r/bilibili/live-danmaku/med_public',
    );
  });

  test('playback mapping recognizes legacy live danmaku delivery', () {
    final legacySources = <(String, String)>[
      ('synctv-bilibili-live', 'https://example.test/bilibili'),
      ('synctv-twitch-live', 'https://example.test/twitch'),
      ('synctv-huya-live', 'https://example.test/huya'),
      ('synctv-douyu-live', 'https://example.test/douyu'),
      ('synctv-douyin-live', 'https://example.test/douyin'),
      ('synctv-acfun-live', 'https://example.test/acfun'),
      ('legacy', 'https://example.test/live-danmaku/stream'),
    ];

    for (final (format, url) in legacySources) {
      final entry = RoomMediaEntry.fromPlaybackProto(
        client.Playback(
          mediaId: 'med_legacy',
          name: 'Legacy live danmaku',
          playbackInfos: [
            MapEntry(
              'live',
              client.PlaybackInfo(
                medias: [
                  client.PlaybackMedia(
                    name: 'Live',
                    url: 'https://example.test/live.flv',
                    format: 'flv',
                  ),
                ],
                danmakus: [
                  client.PlaybackDanmaku(
                    name: 'Legacy',
                    url: url,
                    format: format,
                  ),
                ],
              ),
            ),
          ],
          defaultMode: 'live',
        ),
      );

      expect(entry.streamDanmu, url, reason: format);
      expect(entry.danmu, isNull, reason: format);
    }
  });

  test('playback mapping preserves live proxy HLS and FLV choices', () {
    final entry = RoomMediaEntry.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_liveProxy',
        roomId: 'room_1',
        name: 'Upstream Live',
        provider: source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
        playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
        playbackInfos: [
          MapEntry(
            'hls',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'HLS',
                  url:
                      '/api/playback-providers/room/live-proxy/ver_1/hls-master',
                  format: 'hls',
                ),
              ],
            ),
          ),
          MapEntry(
            'flv',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'FLV',
                  url:
                      '/api/playback-providers/room/live-proxy/ver_1/flv-stream',
                  format: 'flv',
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'hls',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(entry.live, isTrue);
    expect(
      entry.sourceProvider,
      source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
    );
    expect(entry.type, 'hls');
    expect(
      entry.url,
      'https://example.test/api/playback-providers/room/live-proxy/ver_1/hls-master',
    );

    final flv = entry.selectPlayback(
      modeKey: 'flv',
      urlIndex: 0,
      resolveUrl: (url) => url,
    );
    expect(flv.type, 'flv');
    expect(
      flv.url,
      'https://example.test/api/playback-providers/room/live-proxy/ver_1/flv-stream',
    );
    expect(flv.playbackChoiceLabel, contains('FLV'));
  });

  test('playback mapping resolves nested playback resources', () {
    final entry = RoomMediaEntry.fromPlaybackProto(
      client.Playback(
        mediaId: 'med_1',
        name: 'AList Source',
        playbackInfos: [
          MapEntry(
            'proxy',
            client.PlaybackInfo(
              medias: [
                client.PlaybackMedia(
                  name: 'Proxy',
                  url: '/api/providers/proxy/alist/item/stream?token=abc',
                  format: 'mp4',
                ),
              ],
              subtitles: [
                client.PlaybackSubtitle(
                  name: '中文',
                  url: '/api/providers/proxy/alist/subtitle.srt',
                  format: 'srt',
                ),
              ],
              danmakus: [
                client.PlaybackDanmaku(
                  name: '弹幕',
                  url: '/api/providers/proxy/alist/danmaku.xml',
                  format: 'xml',
                  delivery: client
                      .PlaybackDanmakuDelivery
                      .PLAYBACK_DANMAKU_DELIVERY_DOCUMENT,
                ),
              ],
            ),
          ),
        ],
        defaultMode: 'proxy',
      ),
      resolveUrl: (url) =>
          url.startsWith('/') ? 'https://example.test$url' : url,
    );

    expect(
      entry.url,
      'https://example.test/api/providers/proxy/alist/item/stream?token=abc',
    );
    expect(
      entry.playbackModes.single.urls.single.url,
      'https://example.test/api/providers/proxy/alist/item/stream?token=abc',
    );
    expect(
      entry.subtitles?['sub_0']['url'],
      'https://example.test/api/providers/proxy/alist/subtitle.srt',
    );
    expect(
      entry.danmu,
      'https://example.test/api/providers/proxy/alist/danmaku.xml',
    );
  });

  test('playback state watch decodes protobuf JSON target payload', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      expect(request.uri.path, '/api/rooms/room_1/watch/playback-state');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType(
          'text',
          'event-stream',
          charset: 'utf-8',
        )
        ..write(
          'event: changed\n'
          'data: ${jsonEncode({
            'observeId': 'playback-state',
            'eventCursor': {'sequence': 100},
            'playbackState': {
              'roomId': 'room_1',
              'playingPlaylistId': 'pl_dynamic',
              'target': {
                'alist': {'relativePath': '/shows/ep1.mkv'},
              },
              'position': 24.5,
              'speed': 1.25,
              'isPlaying': true,
            },
          })}\n\n',
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final event = await SyncTvService.watchPlaybackState('room_1').firstWhere(
        (event) => event is RoomResourceChanged<SyncTvPlaybackStatus>,
      );
      final changed = event as RoomResourceChanged<SyncTvPlaybackStatus>;
      final target = testProviderTarget('/shows/ep1.mkv');

      expect(changed.version, '100');
      expect(changed.snapshot, isNotNull);
      expect(changed.snapshot!.isPlaying, isTrue);
      expect(changed.snapshot!.currentTime, 24.5);
      expect(changed.snapshot!.playbackRate, 1.25);
      expect(changed.snapshot!.entry!.parentId, 'pl_dynamic');
      expect(
        changed.snapshot!.entry!.playbackTarget,
        testProviderTargetToken(target),
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('watch playback state query uses known event sequence', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '',
          200,
          headers: {'content-type': 'text/event-stream'},
        );
      }),
    );

    await api.room
        .watchPlaybackState(
          'room_1',
          client.WatchPlaybackStateRequest(
            playbackState: client.ObservePlaybackState(
              eventSequence: Int64(42),
            ),
          ),
        )
        .drain<void>();

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/watch/playback-state');
    expect(requestedUri!.queryParameters, containsPair('eventSequence', '42'));
    expect(
      requestedUri!.queryParameters,
      isNot(contains('afterEventSequence')),
    );
  });

  test(
    'watch playback snapshot query includes dynamic playlist target',
    () async {
      Uri? requestedUri;
      final playbackClientProfile = defaultPlaybackClientProfile();
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            '',
            200,
            headers: {'content-type': 'text/event-stream'},
          );
        }),
      );

      await api.room
          .watchPlayback(
            'room_1',
            client.WatchPlaybackRequest(
              playback: client.ObservePlayback(
                playbackClientProfile: playbackClientProfile,
              ),
            ),
          )
          .drain<void>();

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/rooms/room_1/watch/playback');
      final encodedProfile = requestedUri!.queryParameters['clientProfile'];
      expect(encodedProfile, isNotNull);
      final decodedProfile = client.PlaybackClientProfile.fromBuffer(
        base64Url.decode(base64Url.normalize(encodedProfile!)),
      );
      expect(
        decodedProfile.writeToBuffer(),
        playbackClientProfile.writeToBuffer(),
      );
      expect(
        requestedUri!.queryParameters,
        isNot(contains('afterEventSequence')),
      );
      for (final legacyParameter in [
        'streamPreference',
        'maxStreamingBitrate',
        'maxAudioChannels',
        'videoCodecs',
        'containers',
        'liveTransports',
        'audioCapability',
        'subtitlePreference',
      ]) {
        expect(requestedUri!.queryParameters, isNot(contains(legacyParameter)));
      }
    },
  );

  test(
    'playback state update parses PlaybackState from protobuf endpoint',
    () async {
      Uri? requestedUri;
      String? requestMethod;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestMethod = request.method;
          requestBody = request.body;
          return http.Response(
            jsonEncode({
              'roomId': 'room_1',
              'playingMediaId': 'med_1',
              'position': 42.5,
              'speed': 1.25,
              'isPlaying': true,
              'version': '8',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.room.updatePlaybackState(
        'room_1',
        client.UpdatePlaybackStateRequest(
          type: client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED,
          playing: true,
          position: 42.5,
          speed: 1.25,
        ),
      );

      expect(requestMethod, 'PATCH');
      expect(requestedUri!.path, '/api/rooms/room_1/playback');
      final body = jsonDecode(requestBody!) as Map<String, dynamic>;
      expect(
        body['type'],
        client.PlaybackUpdateType.PLAYBACK_UPDATE_TYPE_SPEED.value,
      );
      expect(body['playing'], isTrue);
      expect(body['position'], 42.5);
      expect(body['speed'], 1.25);
      expect(response.playingMediaId, 'med_1');
      expect(response.position, 42.5);
      expect(response.speed, 1.25);
    },
  );

  test(
    'move media sends protobuf body for arbitrary target playlist',
    () async {
      Uri? requestedUri;
      String? requestMethod;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestMethod = request.method;
          requestBody = request.body;
          return http.Response(
            jsonEncode({
              'movedCount': 1,
              'media': [
                {
                  'id': 'med_1',
                  'roomId': 'room_1',
                  'sourceProvider': source_enum
                      .SourceProvider
                      .SOURCE_PROVIDER_DIRECT_URL
                      .value,
                  'name': 'Feature',
                },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.room.moveMedia(
        'room_1',
        client.MoveMediaRequest(
          mediaIds: ['med_1'],
          sourcePlaylistId: 'pl_source',
          targetPlaylistId: 'pl_target',
          afterMediaId: 'med_anchor',
        ),
      );

      expect(requestMethod, 'POST');
      expect(requestedUri!.path, '/api/rooms/room_1/media/move');
      final body = jsonDecode(requestBody!) as Map<String, dynamic>;
      expect(body['mediaIds'], ['med_1']);
      expect(body['sourcePlaylistId'], 'pl_source');
      expect(body['targetPlaylistId'], 'pl_target');
      expect(body['afterMediaId'], 'med_anchor');
      expect(body.containsKey('beforeMediaId'), isFalse);
      expect(response.movedCount, 1);
      expect(response.media.single.id, 'med_1');
    },
  );

  test('delete media uses protobuf path and query contract', () async {
    Uri? requestedUri;
    String? requestMethod;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.deleteMedia(
      'room_1',
      client.DeleteMediaRequest(mediaId: 'med_1', force: true),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/media/med_1');
    expect(requestedUri!.queryParameters, containsPair('force', 'true'));
    expect(response.success, isTrue);
  });

  test('move playlist sends protobuf oneof anchor body', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({'id': 'pl_1', 'roomId': 'room_1', 'name': 'Moved'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.movePlaylist(
      'room_1',
      client.MovePlaylistRequest(playlistId: 'pl_1', beforePlaylistId: 'pl_0'),
    );
    await api.room.movePlaylist(
      'room_1',
      client.MovePlaylistRequest(playlistId: 'pl_1', afterPlaylistId: 'pl_2'),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/rooms/room_1/playlists/pl_1/move');
    final beforeBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(beforeBody['playlistId'], 'pl_1');
    expect(beforeBody['beforePlaylistId'], 'pl_0');
    expect(beforeBody.containsKey('afterPlaylistId'), isFalse);

    final afterBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(afterBody['playlistId'], 'pl_1');
    expect(afterBody['afterPlaylistId'], 'pl_2');
    expect(afterBody.containsKey('beforePlaylistId'), isFalse);
  });

  test(
    'delete entries sends media and playlist ids in protobuf body',
    () async {
      Uri? requestedUri;
      String? requestMethod;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestMethod = request.method;
          requestBody = request.body;
          return http.Response(
            jsonEncode({'deletedMedia': 2, 'deletedPlaylists': 1}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.room.deleteEntries(
        'room_1',
        client.DeleteEntriesRequest(
          mediaIds: ['med_1', 'med_2'],
          playlistIds: ['pl_1'],
          force: true,
        ),
      );

      expect(requestMethod, 'DELETE');
      expect(requestedUri!.path, '/api/rooms/room_1/entries');
      final body = jsonDecode(requestBody!) as Map<String, dynamic>;
      expect(body['mediaIds'], ['med_1', 'med_2']);
      expect(body['playlistIds'], ['pl_1']);
      expect(body['force'], isTrue);
      expect(response.deletedMedia, 2);
      expect(response.deletedPlaylists, 1);
    },
  );

  test('clear root playlist sends protobuf request body', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'success': true, 'deletedCount': 2}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.clearPlaylist(
      'room_1',
      client.ClearPlaylistRequest(),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/media');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body, isEmpty);
    expect(response.success, isTrue);
    expect(response.deletedCount, 2);
  });

  test('clear playlist scope uses ClearPlaylist protobuf body', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({
            'success': true,
            'deletedCount': 2,
            'deletedPlaylists': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.room.clearPlaylist(
      'room_1',
      client.ClearPlaylistRequest(playlistId: 'pl_1'),
    );

    expect(requestMethod, 'DELETE');
    expect(requestedUri!.path, '/api/rooms/room_1/media');
    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['playlistId'], 'pl_1');
    expect(response.deletedCount, 2);
    expect(response.deletedPlaylists, 1);
  });

  test(
    'clear media library keeps playlist scope through ClearPlaylist protobuf',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          return http.Response(
            jsonEncode({'success': true}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final media = SyncTvRoomMediaDomainService(api);

      await media.clearMediaLibrary('room_1', parentId: 'pl_1');

      expect(requests, hasLength(1));
      expect(requests.single.method, 'DELETE');
      expect(requests.single.url.path, '/api/rooms/room_1/media');
      final body = jsonDecode(requests.single.body) as Map<String, dynamic>;
      expect(body, {'playlistId': 'pl_1'});
    },
  );

  test('watch room members query uses protobuf enum values', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '',
          200,
          headers: {'content-type': 'text/event-stream'},
        );
      }),
    );

    await api.room
        .watchRoomMemberEvents(
          'room_1',
          client.WatchRoomMemberEventsRequest(
            deliveryMode: client
                .ResourceDeliveryMode
                .RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
            roomMemberEvents: client.ObserveRoomMemberEvents(
              afterEventSequence: Int64(1),
            ),
          ),
        )
        .drain<void>();

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/watch/room-members');
    expect(
      requestedUri!.queryParameters,
      containsPair('afterEventSequence', '1'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair(
        'deliveryMode',
        client_enum
            .ResourceDeliveryMode
            .RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT
            .value
            .toString(),
      ),
    );
  });

  test('admin list users query preserves protobuf filters', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({'instances': [], 'total': 0}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.listUsers(
      admin.ListUsersRequest(
        page: 4,
        pageSize: 30,
        search: 'alice',
        status: common.UserStatus.USER_STATUS_ACTIVE,
        role: common.UserRole.USER_ROLE_ADMIN,
        isBanned: false,
        sortBy: admin.UserListSortBy.USER_LIST_SORT_BY_USERNAME,
        sortDirection: admin.SortDirection.SORT_DIRECTION_ASC,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/users');
    expect(requestedUri!.queryParameters, containsPair('page', '4'));
    expect(requestedUri!.queryParameters, containsPair('pageSize', '30'));
    expect(requestedUri!.queryParameters, containsPair('search', 'alice'));
    expect(requestedUri!.queryParameters, containsPair('status', '1'));
    expect(requestedUri!.queryParameters, containsPair('role', '2'));
    expect(requestedUri!.queryParameters, containsPair('isBanned', 'false'));
    expect(requestedUri!.queryParameters, containsPair('sortBy', '3'));
    expect(requestedUri!.queryParameters, containsPair('sortDirection', '1'));
  });

  test('admin user service preserves pagination sorting and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'users': [
              {
                'id': 'usr_1',
                'username': 'alice',
                'email': 'alice@example.test',
                'role': common.UserRole.USER_ROLE_ADMIN.value,
                'status': common.UserStatus.USER_STATUS_ACTIVE.value,
              },
            ],
            'total': 9,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListUsersPage(
        page: 2,
        pageSize: 50,
        search: 'alice',
        status: common.UserStatus.USER_STATUS_ACTIVE,
        role: common.UserRole.USER_ROLE_ADMIN,
        isBanned: false,
        sortBy: admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 9);
      expect(page.users.single.id, 'usr_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/users');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'pageSize': '50',
      'status': '${common.UserStatus.USER_STATUS_ACTIVE.value}',
      'role': '${common.UserRole.USER_ROLE_ADMIN.value}',
      'search': 'alice',
      'sortBy': '${admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL.value}',
      'sortDirection': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
      'isBanned': 'false',
    });
  });

  test(
    'admin user mapping preserves current protobuf role and status enums',
    () {
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession(),
      );
      final user = api.mapAdminUser(
        admin.AdminUser(
          id: 'usr_1',
          username: 'root',
          role: common.UserRole.USER_ROLE_ROOT,
          status: common.UserStatus.USER_STATUS_ACTIVE,
          createdAt: Int64(1760000001),
          updatedAt: Int64(1760000002),
          isBanned: false,
        ),
      );
      final banned = api.mapAdminUser(
        admin.AdminUser(
          id: 'usr_2',
          username: 'blocked',
          role: common.UserRole.USER_ROLE_USER,
          status: common.UserStatus.USER_STATUS_ACTIVE,
          isBanned: true,
          bannedAt: Int64(1760000003),
          bannedBy: 'usr_root',
          bannedReason: 'abuse',
        ),
      );

      expect(
        user.role,
        isA<AccountUserRole>().having(
          (role) => role.value,
          'value',
          common.UserRole.USER_ROLE_ROOT,
        ),
      );
      expect(user.status, common.UserStatus.USER_STATUS_ACTIVE);
      expect(user.createdAt, 1760000001);
      expect(user.updatedAt, 1760000002);
      expect(user.isBanned, isFalse);
      expect(
        banned.role,
        isA<AccountUserRole>().having(
          (role) => role.value,
          'value',
          common.UserRole.USER_ROLE_USER,
        ),
      );
      expect(banned.status, common.UserStatus.USER_STATUS_BANNED);
      expect(banned.isBanned, isTrue);
      expect(banned.bannedAt, 1760000003);
      expect(banned.bannedBy, 'usr_root');
      expect(banned.bannedReason, 'abuse');
    },
  );

  test('admin user create and ban preserve protobuf request fields', () async {
    final requests = <http.Request>[];
    const adminCredential = 'not-a-real-test-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/ban')) {
          return http.Response(
            jsonEncode({
              'id': 'usr_1',
              'username': 'alice',
              'role': common.UserRole.USER_ROLE_ADMIN.value,
              'status': common.UserStatus.USER_STATUS_BANNED.value,
              'isBanned': true,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'id': 'usr_1',
            'username': 'alice',
            'email': 'alice@example.test',
            'role': common.UserRole.USER_ROLE_ADMIN.value,
            'status': common.UserStatus.USER_STATUS_BANNED.value,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.createUser(
      admin.CreateUserRequest(
        username: 'alice',
        password: adminCredential,
        email: 'alice@example.test',
        role: common.UserRole.USER_ROLE_ADMIN,
        status: common.UserStatus.USER_STATUS_BANNED,
      ),
    );
    await api.adminService.banUser(
      admin.BanUserRequest(userId: 'usr_1', reason: 'spam'),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/admin/users');
    expect(jsonDecode(requests.first.body), {
      'username': 'alice',
      'password': adminCredential,
      'email': 'alice@example.test',
      'role': common.UserRole.USER_ROLE_ADMIN.value,
      'status': common.UserStatus.USER_STATUS_BANNED.value,
    });
    expect(requests.last.method, 'POST');
    expect(requests.last.url.path, '/api/admin/users/usr_1/ban');
    expect(jsonDecode(requests.last.body), {
      'userId': 'usr_1',
      'reason': 'spam',
    });
  });

  test('admin unban user uses protobuf path command endpoint', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'id': 'usr_1',
            'username': 'alice',
            'role': common.UserRole.USER_ROLE_USER.value,
            'status': common.UserStatus.USER_STATUS_ACTIVE.value,
            'isBanned': false,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.unbanUser(admin.UnbanUserRequest(userId: 'usr_1'));

    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/api/admin/users/usr_1/unban');
    expect(requests.single.body, isEmpty);
  });

  test('admin room mapping keeps lifecycle status separate from ban flag', () {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
    );
    final room = api.mapAdminRoom(
      admin.Room(
        id: 'room_1',
        name: 'The Room',
        creatorId: 'usr_1',
        creatorUsername: 'alice',
        status: common.RoomStatus.ROOM_STATUS_ACTIVE,
        isBanned: true,
        memberCount: 9,
        description: 'Admin room description',
        updatedAt: Int64(1760000010),
        creatorStatus: common.UserStatus.USER_STATUS_BANNED,
        version: Int64(88),
      ),
    );

    expect(room.status, common.RoomStatus.ROOM_STATUS_ACTIVE);
    expect(room.isBanned, isTrue);
    expect(room.onlineMemberCount, 0);
    expect(room.onlineGuestCount, 0);
    expect(room.memberCount, 9);
    expect(room.description, 'Admin room description');
    expect(room.updatedAt, 1760000010);
    expect(room.creatorStatus, common.UserStatus.USER_STATUS_BANNED);
    expect(room.version, 88);
  });

  test(
    'public room discovery preserves filters and omits viewer state',
    () async {
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        requestedUri = request.uri;
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'rooms': [
                {
                  'room': {
                    'id': 'room_1',
                    'name': 'Public Room',
                    'createdBy': 'usr_1',
                    'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
                    'description': 'Public room description',
                    'updatedAt': '1760000020',
                    'isBanned': true,
                    'availability': client
                        .ResourceAvailability
                        .RESOURCE_AVAILABILITY_CREATOR_INACTIVE
                        .value,
                    'version': '89',
                  },
                  'access': client_enum
                      .RoomDiscoveryAccess
                      .ROOM_DISCOVERY_ACCESS_UNAVAILABLE
                      .value,
                },
              ],
              'total': 12,
            }),
          );
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final page = await SyncTvService.discoverRooms(
          page: 2,
          pageSize: 30,
          search: 'Public',
          categoryId: 'roomcat_anime',
          labelIds: const ['roomlbl_weekly', 'roomlbl_friends'],
        );

        expect(page.total, 12);
        expect(page.page, 2);
        expect(page.pageSize, 30);
        expect(page.rooms.single.roomId, 'room_1');
        expect(page.rooms.single.description, 'Public room description');
        expect(page.rooms.single.updatedAt, 1760000020);
        expect(page.rooms.single.isBanned, isTrue);
        expect(
          page.rooms.single.availability,
          client.ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
        );
        expect(page.rooms.single.version, 89);
        expect(page.rooms.single.joined, isFalse);
        expect(page.rooms.single.isFavorite, isFalse);
        expect(
          page.rooms.single.discoveryAccess,
          client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNAVAILABLE,
        );
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/rooms/discover');
      expect(requestedUri!.queryParametersAll, {
        'page': ['2'],
        'pageSize': ['30'],
        'search': ['Public'],
        'categoryId': ['roomcat_anime'],
        'labelIds': ['roomlbl_weekly', 'roomlbl_friends'],
      });
    },
  );

  test('my room service preserves relation filters sorting and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'rooms': [
              {
                'room': {
                  'id': 'room_2',
                  'name': 'Mine',
                  'createdBy': 'usr_1',
                  'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
                },
                'permissions': '7',
                'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
              },
            ],
            'total': 8,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues(
        testActiveServerPreferences(
          baseUrl: 'http://${server.address.host}:${server.port}',
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      );
      await SyncTvService.init();

      final page = await SyncTvService.getMyRoomsPage(
        page: 3,
        pageSize: 40,
        search: 'Mine',
        status: common.RoomStatus.ROOM_STATUS_ACTIVE,
        isBanned: false,
        relation: client_enum.MyRoomRelation.MY_ROOM_RELATION_PARTICIPATING,
        sortBy: client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_NAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 8);
      expect(page.page, 3);
      expect(page.pageSize, 40);
      expect(page.rooms.single.roomId, 'room_2');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/rooms');
    expect(requestedUri!.queryParameters, {
      'page': '3',
      'pageSize': '40',
      'status': '${common.RoomStatus.ROOM_STATUS_ACTIVE.value}',
      'search': 'Mine',
      'isBanned': 'false',
      'relation':
          '${client_enum.MyRoomRelation.MY_ROOM_RELATION_PARTICIPATING.value}',
      'sortBy':
          '${client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_NAME.value}',
      'sortDirection': '${client_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test(
    'admin room service preserves pagination sorting ban filter and total',
    () async {
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        requestedUri = request.uri;
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'rooms': [
                {
                  'id': 'room_1',
                  'name': 'Room',
                  'createdBy': 'usr_1',
                  'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
                  'isBanned': false,
                },
              ],
              'total': 7,
            }),
          );
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final page = await SyncTvService.adminListRoomsPage(
          page: 3,
          pageSize: 50,
          search: 'Room',
          categoryId: 'roomcat_anime',
          labelIds: const ['roomlbl_weekly'],
          status: common.RoomStatus.ROOM_STATUS_ACTIVE,
          isBanned: false,
          sortBy: admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
          sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
        );

        expect(page.total, 7);
        expect(page.rooms.single.roomId, 'room_1');
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/admin/rooms');
      expect(requestedUri!.queryParametersAll, {
        'page': ['3'],
        'pageSize': ['50'],
        'status': ['${common.RoomStatus.ROOM_STATUS_ACTIVE.value}'],
        'search': ['Room'],
        'categoryId': ['roomcat_anime'],
        'labelIds': ['roomlbl_weekly'],
        'isBanned': ['false'],
        'sortBy': [
          '${admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT.value}',
        ],
        'sortDirection': [
          '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
        ],
      });
    },
  );

  test('admin user rooms service preserves protobuf query and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'rooms': [
              {
                'id': 'room_2',
                'name': 'Owned Room',
                'createdBy': 'usr_1',
                'status': common.RoomStatus.ROOM_STATUS_CLOSED.value,
                'isBanned': true,
              },
            ],
            'total': 4,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListUserRoomsPage(
        'usr_1',
        page: 2,
        pageSize: 20,
        search: 'Owned',
        status: common.RoomStatus.ROOM_STATUS_CLOSED,
        isBanned: true,
        sortBy: admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 4);
      expect(page.rooms.single.roomId, 'room_2');
      expect(page.rooms.single.isBanned, isTrue);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/users/usr_1/rooms');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'pageSize': '20',
      'status': '${common.RoomStatus.ROOM_STATUS_CLOSED.value}',
      'search': 'Owned',
      'isBanned': 'true',
      'sortBy': '${admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME.value}',
      'sortDirection': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test('chat history query is generated from protobuf request', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '{}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.getChatHistory(
      'room_1',
      client.GetChatHistoryRequest(
        limit: 75,
        cursor: '2026-05-27T01:02:03Z|msg_1',
        includeMessageTypes: [
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED,
        ],
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/chat/history');
    expect(requestedUri!.queryParameters, containsPair('limit', '75'));
    expect(
      requestedUri!.queryParameters,
      containsPair('cursor', '2026-05-27T01:02:03Z|msg_1'),
    );
    expect(requestedUri!.queryParametersAll['includeMessageTypes'], [
      '1',
      '1001',
    ]);
  });

  test('chat playback query includes requested message types', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '{"messages":[]}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.getChatPlaybackMessages(
      'room_1',
      client.GetChatPlaybackMessagesRequest(
        playbackMediaId: 'med_1',
        positionSeconds: 12.5,
        includeMessageTypes: [
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
        ],
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/chat/playback-messages');
    expect(
      requestedUri!.queryParameters,
      containsPair('playbackMediaId', 'med_1'),
    );
    expect(
      requestedUri!.queryParameters,
      containsPair('positionSeconds', '12.5'),
    );
    expect(requestedUri!.queryParametersAll['includeMessageTypes'], ['1']);
  });

  test('account preferences preserve protobuf settings payload', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'preferences': {
              'twoFactorEnabled': true,
              'notifications': {
                'room_invitation_in_app': true,
                'room_event_in_app': false,
                'system_announcement_in_app': true,
                'room_invitation_email': false,
                'room_event_email': true,
                'system_announcement_email': false,
              },
              'settings': {
                'allowGuestJoin': true,
                'requireApproval': true,
                'chatEnabled': true,
              },
            },
            'authFactors': {
              'password': true,
              'webauthn': true,
              'email': false,
              'eligibleCount': 2,
            },
          }),
        );
      await request.response.close();
    });

    late final AccountPreferences preferences;
    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      preferences = await SyncTvService.getAccountPreferences();
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/preferences');
    expect(preferences.twoFactorEnabled, isTrue);
    expect(preferences.canUsePasskey, isTrue);
    expect(preferences.eligibleFactorCount, 2);
    expect(preferences.settings['allowGuestJoin'], isTrue);
    expect(preferences.settings['requireApproval'], isTrue);
  });

  test('notification detail endpoint maps protobuf response', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'id': '42',
            'notificationType': 3,
            'title': 'Room updated',
            'content': 'Playback changed',
            'data': {'roomId': 'room_1'},
            'isRead': false,
            'createdAt': '1760000000',
            'updatedAt': '1760000010',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.notifications.getNotification(
      client.GetNotificationRequest(notificationId: Int64(42)),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/notifications/42');
    expect(response.id, '42');
    expect(response.title, 'Room updated');
    expect(notificationDataToJson(response.data), {'roomId': 'room_1'});
  });

  test('room stream query and kick use protobuf contract', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/kick')) {
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'streams': [
              {'mediaId': 'med_1', 'active': true},
            ],
            'total': 1,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final streams = await api.room.listRoomStreams(
      'room_1',
      client.ListRoomStreamsRequest(
        page: 2,
        pageSize: 20,
        search: 'med',
        sortBy: client.RoomStreamListSortBy.ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
        sortDirection: client.SortDirection.SORT_DIRECTION_DESC,
      ),
    );
    await api.room.kickRoomStream(
      'room_1',
      client.KickRoomStreamRequest(mediaId: 'med_1', reason: 'stale publisher'),
    );

    expect(streams.streams.single.mediaId, 'med_1');
    expect(requests.first.url.path, '/api/rooms/room_1/streams');
    expect(requests.first.url.queryParameters, containsPair('page', '2'));
    expect(requests.first.url.queryParameters, containsPair('pageSize', '20'));
    expect(requests.first.url.queryParameters, containsPair('search', 'med'));
    expect(requests.first.url.queryParameters, containsPair('sortBy', '1'));
    expect(
      requests.first.url.queryParameters,
      containsPair('sortDirection', '2'),
    );
    expect(requests.last.method, 'POST');
    expect(requests.last.url.path, '/api/rooms/room_1/streams/med_1/kick');
    expect(jsonDecode(requests.last.body), {
      'mediaId': 'med_1',
      'reason': 'stale publisher',
    });
  });

  test('room stream service maps detail endpoint and pagination', () async {
    final requests = <http.Request>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final listener = server.listen((request) async {
      requests.add(http.Request(request.method, request.uri));
      request.response.headers.contentType = io.ContentType.json;
      if (request.uri.path == '/api/rooms/room_1/streams/med_1') {
        request.response.write(
          jsonEncode({
            'active': true,
            'publisher': {'userId': 'usr_publisher', 'startedAt': '1760000000'},
          }),
        );
      } else if (request.uri.path == '/api/rooms/room_1/streams') {
        request.response.write(
          jsonEncode({
            'streams': [
              {'mediaId': 'med_1', 'active': true},
              {'mediaId': 'med_2', 'active': false},
            ],
            'total': 12,
          }),
        );
      } else {
        request.response.statusCode = 404;
        request.response.write('{}');
      }
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.listRoomStreamsPage(
        'room_1',
        page: 2,
        pageSize: 50,
        search: 'med',
        sortDirection: client.SortDirection.SORT_DIRECTION_DESC,
      );
      final detail = await SyncTvService.getRoomStreamInfo('room_1', 'med_1');

      expect(page.total, 12);
      expect(page.page, 2);
      expect(page.pageSize, 50);
      expect(page.streams, hasLength(2));
      expect(page.streams.first.publisherUserId, 'usr_publisher');
      expect(page.streams.first.startedAt, 1760000000);
      expect(page.streams.last.active, isFalse);
      expect(detail.publisherUserId, 'usr_publisher');
      expect(requests.map((request) => request.url.path), [
        '/api/rooms/room_1/streams',
        '/api/rooms/room_1/streams/med_1',
        '/api/rooms/room_1/streams/med_1',
      ]);
      expect(requests.first.url.queryParameters, containsPair('page', '2'));
      expect(
        requests.first.url.queryParameters,
        containsPair('pageSize', '50'),
      );
      expect(requests.first.url.queryParameters, containsPair('search', 'med'));
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('room stream endpoints use path protobuf parameters', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.contains('/publish-key')) {
          return http.Response(
            jsonEncode({
              'publishKey': 'pub_1',
              'rtmpUrl': 'rtmp://example.test/live',
              'streamKey': 'stream_1',
              'expiresAt': '1760000100',
              'type': 'PUBLISH_KEY_TYPE_SINGLE_USE',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'active': true,
            'publisher': {'userId': 'user_1', 'startedAt': '1760000000'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final publish = await api.room.createRoomPublishKey(
      'room_1',
      client.CreateRoomPublishKeyRequest(
        mediaId: 'med_1',
        type: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
        expiresAt: Int64(1760000100),
      ),
    );
    final info = await api.room.getRoomStreamInfo(
      'room_1',
      client.GetRoomStreamInfoRequest(mediaId: 'med_1'),
    );

    expect(publish.publishKey, 'pub_1');
    expect(info.active, isTrue);
    expect(info.publisher.userId, 'user_1');
    expect(requests.first.method, 'POST');
    expect(
      requests.first.url.path,
      '/api/playback-providers/room_1/rtmp/med_1/publish-key',
    );
    expect(jsonDecode(requests.first.body), containsPair('type', 1));
    expect(requests.last.method, 'GET');
    expect(requests.last.url.path, '/api/rooms/room_1/streams/med_1');
  });

  test('legacy publish key responses default to single-use', () async {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'publishKey': 'pub_legacy',
            'rtmpUrl': 'rtmp://example.test/live',
            'streamKey': 'stream_legacy',
            'expiresAt': '1760000100',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvRoomMediaDomainService(api);

    final publish = await service.createRtmpPublishKeyInfo(
      'room_1',
      'med_1',
      keyType: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
    );

    expect(
      publish.keyType,
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
    );
    expect(publish.expiresAt, 1760000100);
  });

  test(
    'direct url, rtmp, and live proxy require prepare intents before creation',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          final requestBody = request.body.isEmpty
              ? <String, dynamic>{}
              : jsonDecode(request.body) as Map<String, dynamic>;
          if (request.url.path == '/api/providers/prepare/direct-url') {
            return http.Response(
              jsonEncode({
                'source': {
                  'media': {
                    'directUrl': {
                      'medias': [
                        {
                          'url': requestBody['url'],
                          'headers': requestBody['headers'] ?? {},
                        },
                      ],
                      'playbackKind': requestBody['playbackKind'],
                      'proxyMode': requestBody['proxyMode'],
                    },
                  },
                },
                'suggestedName': 'entry.m3u8',
                'playbackKind': requestBody['playbackKind'],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/providers/prepare/rtmp') {
            return http.Response(
              jsonEncode({
                'source': {
                  'media': {
                    'rtmp': {'mode': requestBody['mode']},
                  },
                },
                'suggestedName': 'RTMP live stream',
                'playbackKind':
                    source_enum.PlaybackKind.PLAYBACK_KIND_LIVE.value,
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/providers/prepare/live-proxy') {
            return http.Response(
              jsonEncode({
                'source': {
                  'media': {'liveProxy': requestBody},
                },
                'suggestedName': 'room',
                'playbackKind':
                    source_enum.PlaybackKind.PLAYBACK_KIND_LIVE.value,
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/rooms/room_1/media' &&
              request.method == 'POST') {
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            final sourceConfig =
                body['sourceConfig'] as Map<String, dynamic>? ?? {};
            final provider = sourceConfig.containsKey('rtmp')
                ? source_enum.SourceProvider.SOURCE_PROVIDER_RTMP
                : sourceConfig.containsKey('liveProxy')
                ? source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY
                : source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL;
            final mediaId =
                provider == source_enum.SourceProvider.SOURCE_PROVIDER_RTMP
                ? 'med_rtmp'
                : provider ==
                      source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY
                ? 'med_liveProxy'
                : 'med_direct';
            return http.Response(
              jsonEncode({
                'id': mediaId,
                'roomId': 'room_1',
                'sourceProvider': provider.value,
                'name': body['name'] ?? '',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('{}', 404);
        }),
      );
      final providers = SyncTvProviderDomainService(api);
      final roomMedia = SyncTvRoomMediaDomainService(api);

      final direct = await providers.prepareDirectUrl(
        provider_common.PrepareDirectUrlRequest(
          url: 'https://media.example.test/entry.m3u8',
          playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
          headers: const {'User-Agent': 'Mozilla/5.0'}.entries,
          proxyMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
        ),
      );
      final directId = await roomMedia.addMediaFromSourceConfig(
        'room_1',
        playlistId: 'pl_1',
        sourceConfig: direct.source.media,
        name: 'Direct HLS',
      );
      final rtmpPreview = await providers.prepareRtmp(
        source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
      );
      final rtmpId = await roomMedia.addMediaFromSourceConfig(
        'room_1',
        playlistId: 'pl_1',
        sourceConfig: rtmpPreview.source.media,
        name: 'Camera',
      );
      final liveProxy = await providers.prepareLiveProxy(
        provider_common.PrepareLiveProxyRequest(
          rtmp: provider_common.PrepareRtmpPullIntent(
            url: 'rtmp://upstream.example.test/live/room',
            mode: source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
          ),
        ),
      );
      final liveProxyId = await roomMedia.addMediaFromSourceConfig(
        'room_1',
        playlistId: 'pl_1',
        sourceConfig: liveProxy.source.media,
        name: 'Upstream Live',
      );

      expect(directId, 'med_direct');
      expect(rtmpId, 'med_rtmp');
      expect(liveProxyId, 'med_liveProxy');

      expect(requests[0].url.path, '/api/providers/prepare/direct-url');
      expect(jsonDecode(requests[0].body), {
        'url': 'https://media.example.test/entry.m3u8',
        'headers': {'User-Agent': 'Mozilla/5.0'},
        'playbackKind': source_enum.PlaybackKind.PLAYBACK_KIND_LIVE.value,
        'proxyMode':
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY.value,
      });
      final directBody = jsonDecode(requests[1].body) as Map<String, dynamic>;
      expect(directBody.containsKey('sourceProvider'), isFalse);
      expect(directBody['playlistId'], 'pl_1');
      expect(directBody['sourceConfig'], {
        'directUrl': {
          'medias': [
            {
              'url': 'https://media.example.test/entry.m3u8',
              'headers': {'User-Agent': 'Mozilla/5.0'},
            },
          ],
          'playbackKind': source_enum.PlaybackKind.PLAYBACK_KIND_LIVE.value,
          'proxyMode':
              source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY.value,
        },
      });

      expect(requests[2].url.path, '/api/providers/prepare/rtmp');
      expect(jsonDecode(requests[2].body), {
        'mode': source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT.value,
      });
      final rtmpBody = jsonDecode(requests[3].body) as Map<String, dynamic>;
      expect(rtmpBody.containsKey('sourceProvider'), isFalse);
      expect(rtmpBody['playlistId'], 'pl_1');
      expect(rtmpBody['sourceConfig'], {
        'rtmp': {
          'mode': source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT.value,
        },
      });

      final liveProxyBody =
          jsonDecode(requests[5].body) as Map<String, dynamic>;
      expect(liveProxyBody.containsKey('sourceProvider'), isFalse);
      expect(liveProxyBody['playlistId'], 'pl_1');
      expect(liveProxyBody['sourceConfig'], {
        'liveProxy': {
          'rtmp': {
            'url': 'rtmp://upstream.example.test/live/room',
            'mode': source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT.value,
          },
        },
      });
      expect(requests[4].url.path, '/api/providers/prepare/live-proxy');
      expect(jsonDecode(requests[4].body), {
        'rtmp': {
          'url': 'rtmp://upstream.example.test/live/room',
          'mode': source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT.value,
        },
      });
    },
  );

  test(
    'emby dynamic playlist creation sends playlist source config oneof',
    () async {
      Uri? requestedUri;
      String? requestMethod;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestMethod = request.method;
          requestBody = request.body;
          return http.Response(
            jsonEncode({
              'id': 'pl_emby',
              'roomId': 'room_1',
              'name': 'Season 1',
              'isDynamic': true,
              'sourceProvider':
                  source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value,
              'providerInstanceName': 'emby_main',
              'sourceConfig': {
                'emby': {
                  'serverId': 'server_1',
                  'folder': {'itemId': 'folder_1'},
                },
              },
              'browseAccessMode': client_enum
                  .PlaylistBrowseAccessMode
                  .PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY
                  .value,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final domain = SyncTvRoomMediaDomainService(api);

      final playlist = await domain.createPlaylistFromSourceConfig(
        'room_1',
        name: 'Season 1',
        parentId: 'pl_parent',
        providerInstanceName: 'emby_main',
        browseAccessMode: client_enum
            .PlaylistBrowseAccessMode
            .PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY,
        sourceConfig: source_config.PlaylistSourceConfig(
          emby: source_config.EmbyPlaylistSourceConfig(
            serverId: 'server_1',
            folder: source_config.EmbyFolderPlaylistSource(itemId: 'folder_1'),
          ),
        ),
      );

      expect(requestMethod, 'POST');
      expect(requestedUri!.path, '/api/rooms/room_1/playlists');
      final body = jsonDecode(requestBody!) as Map<String, dynamic>;
      expect(body['name'], 'Season 1');
      expect(body['parentId'], 'pl_parent');
      expect(
        body['sourceProvider'],
        source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value,
      );
      expect(body['providerInstanceName'], 'emby_main');
      expect(body['sourceConfig'], {
        'emby': {
          'serverId': 'server_1',
          'folder': {'itemId': 'folder_1'},
        },
      });
      expect(playlist.id, 'pl_emby');
      expect(playlist.isDynamicPlaylist, isTrue);
    },
  );

  test(
    'dynamic playlist update sends complete source config replacement',
    () async {
      Uri? requestedUri;
      String? requestMethod;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestMethod = request.method;
          requestBody = request.body;
          return http.Response(
            jsonEncode({
              'id': 'pl_dynamic',
              'roomId': 'room_1',
              'name': 'Updated library',
              'isDynamic': true,
              'sourceProvider':
                  source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value,
              'sourceConfig': {
                'alist': {
                  'serverId': 'alist-main',
                  'path': '/library/updated',
                  'proxyMode': source_config
                      .PlaybackProxyMode
                      .PLAYBACK_PROXY_MODE_DIRECT_ONLY
                      .value,
                },
              },
              'browseAccessMode': client_enum
                  .PlaylistBrowseAccessMode
                  .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS
                  .value,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final domain = SyncTvRoomMediaDomainService(api);

      await domain.updatePlaylist(
        'room_1',
        'pl_dynamic',
        name: 'Updated library',
        sourceConfig: source_config.PlaylistSourceConfig(
          alist: source_config.AlistPlaylistSourceConfig(
            serverId: 'alist-main',
            path: '/library/updated',
            proxyMode:
                source_config.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
          ),
        ),
        browseAccessMode: client_enum
            .PlaylistBrowseAccessMode
            .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS,
      );

      expect(requestMethod, 'PATCH');
      expect(requestedUri!.path, '/api/rooms/room_1/playlists/pl_dynamic');
      final body = jsonDecode(requestBody!) as Map<String, dynamic>;
      expect(body['name'], 'Updated library');
      expect(body['sourceConfig'], {
        'alist': {
          'serverId': 'alist-main',
          'path': '/library/updated',
          'proxyMode': source_config
              .PlaybackProxyMode
              .PLAYBACK_PROXY_MODE_DIRECT_ONLY
              .value,
        },
      });
      expect(body.containsKey('sourceProvider'), isFalse);
      expect(
        body['browseAccessMode'],
        client_enum
            .PlaylistBrowseAccessMode
            .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS
            .value,
      );
    },
  );

  test('account closure uses protobuf command endpoint and body', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final session = SyncTvSession()..updateAccountTokens(accessToken: 'token');
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.closeAccount(client.CloseAccountRequest());

    expect(response.success, isTrue);
    expect(requestMethod, 'POST');
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/account-closure');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), <String, dynamic>{});
    expect(session.accessToken, isNull);
  });

  test('email unbind uses protobuf command endpoint', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'id': 'usr_1', 'username': 'alice', 'email': ''}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.unbindEmail(client.UnbindEmailRequest());

    expect(response.id, 'usr_1');
    expect(response.email, isEmpty);
    expect(requestMethod, 'POST');
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/email/unbind');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), <String, dynamic>{});
  });

  test('admin test email uses protobuf request body only', () async {
    Uri? requestedUri;
    String? requestMethod;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestMethod = request.method;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'message': 'ok'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.adminService.sendTestEmail(
      admin.SendTestEmailRequest(to: 'ops@example.test'),
    );

    expect(response.message, 'ok');
    expect(requestMethod, 'POST');
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/email/test');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {'to': 'ops@example.test'});
  });

  test(
    'room settings update keeps typed service model and protobuf bytes body',
    () async {
      String? requestBody;
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final origin = 'http://${server.address.host}:${server.port}';
      final requests = server.listen((request) async {
        requestedUri = request.uri;
        requestBody = await utf8.decoder.bind(request).join();
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'room': {
                'roomId': 'room_1',
                'room_name': 'Room 1',
                'creatorId': 'user_1',
                'settings': {'allowGuestJoin': true},
              },
            }),
          );
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(origin);

        await SyncTvService.updateRoomSettings(
          'room_1',
          SyncTvRoomSettings(
            allowGuestJoin: true,
            requireApproval: true,
            maxMembers: 42,
            chatEnabled: false,
            voiceChatEnabled: false,
            p2pMediaEnabled: false,
            guestAddedPermissions: RoomGuestPermissions.viewMembers,
          ),
        );
      } finally {
        await requests.cancel();
        await server.close(force: true);
      }

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/rooms/room_1/settings');
      final body = jsonDecode(requestBody!) as Map<String, dynamic>;
      final settings = body['settings'] as Map<String, dynamic>;
      expect(settings['allowGuestJoin'], isTrue);
      expect(settings['requireApproval'], isTrue);
      expect(settings['maxMembers'], '42');
      expect(settings['chatEnabled'], isFalse);
      expect(settings['voiceChatEnabled'], isFalse);
      expect(settings['p2pMediaEnabled'], isFalse);
      expect(settings['autoPlay'], {
        'enabled': true,
        'mode': client.PlayMode.PLAY_MODE_SEQUENTIAL.value,
        'delay': 3,
      });
      expect(
        settings['guestAddedPermissions'],
        RoomGuestPermissions.viewMembers.toString(),
      );
      expect(
        body['updateMask'],
        'allowGuestJoin,maxMembers,requireApproval,allowAutoJoin,chatEnabled,'
        'voiceChatEnabled,p2pMediaEnabled,autoPlay.enabled,autoPlay.mode,'
        'autoPlay.delay,'
        'adminAddedPermissions,adminRemovedPermissions,memberAddedPermissions,'
        'memberRemovedPermissions,guestAddedPermissions,guestRemovedPermissions',
      );
      expect(body.containsKey('roomId'), isFalse);
    },
  );

  test(
    'room visibility update uses its dedicated authenticated endpoint',
    () async {
      http.Request? capturedRequest;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'id': 'room_1',
              'name': 'Room 1',
              'createdBy': 'user_1',
              'isPublic': false,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final service = SyncTvRoomManagementDomainService(api);

      final room = await service.updateRoomVisibility('room_1', false);

      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.method, 'PATCH');
      expect(capturedRequest!.url.path, '/api/rooms/room_1/visibility');
      expect(capturedRequest!.headers['authorization'], 'Bearer token');
      expect(jsonDecode(capturedRequest!.body), {'isPublic': false});
      expect(room.isPublic, isFalse);
    },
  );

  test('room playback mode update uses a narrow protobuf field mask', () async {
    String? requestBody;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final origin = 'http://${server.address.host}:${server.port}';
    final requests = server.listen((request) async {
      requestBody = await utf8.decoder.bind(request).join();
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'roomId': 'room_1',
            'roomName': 'Room 1',
            'creatorId': 'user_1',
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(origin);
      await SyncTvService.updateRoomAutoPlay(
        'room_1',
        enabled: true,
        mode: client.PlayMode.PLAY_MODE_SHUFFLE,
      );
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    final body = jsonDecode(requestBody!) as Map<String, dynamic>;
    expect(body['updateMask'], 'autoPlay.enabled,autoPlay.mode');
    expect(body['settings'], {
      'autoPlay': {
        'enabled': true,
        'mode': client.PlayMode.PLAY_MODE_SHUFFLE.value,
      },
    });
  });

  test('admin settings reads typed protobuf endpoint', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'server': {'name': 'SyncTV Test'},
            'roomDefaults': {},
            'permissions': {},
            'roomCreation': {},
            'user': {},
            'oauth2': {},
            'rtmp': {},
            'email': {
              'enabled': true,
              'smtpHost': 'mail.example.test',
              'smtpCredentials': {'username': 'smtp-user'},
              'smtpProxy': {
                'url': 'socks5://proxy.example.test:1080',
                'credentials': {'username': 'proxy-user'},
              },
            },
            'webrtc': {},
            'chat': {},
            'playbackHistory': {
              'retentionDays': '30',
              'maxEntriesPerRoom': '100',
            },
            'cors': {},
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final settings = await SyncTvService.runtimeGetSettings();
      final serverSection = settings.section('server');
      final section = settings.section('email');
      final rtmpSection = settings.section('rtmp');
      final playbackHistorySection = settings.section('playbackHistory');

      expect(serverSection?.settings['name'], 'SyncTV Test');
      expect(section, isNotNull);
      expect(section!.name, 'email');
      expect(section.settings['enabled'], isTrue);
      expect(section.settings['smtpHost'], 'mail.example.test');
      expect(section.settings['smtpCredentials'], {'username': 'smtp-user'});
      expect(section.settings['smtpProxy'], {
        'url': 'socks5://proxy.example.test:1080',
        'credentials': {'username': 'proxy-user'},
      });
      expect(rtmpSection, isNotNull);
      expect(rtmpSection!.settings['customPublishHost'], isNull);
      expect(playbackHistorySection?.settings, {
        'retentionDays': 30,
        'maxEntriesPerRoom': '100',
      });
      expect(settings.section('proxy'), isNull);
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/settings');
    expect(requestedUri!.queryParameters, isEmpty);
  });

  test('admin settings update sends typed runtime patch body', () async {
    final requestedBodies = <Map<String, dynamic>>[];
    final requestedUris = <Uri>[];
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      requestedUris.add(request.uri);
      requestedBodies.add(
        jsonDecode(await utf8.decoder.bind(request).join())
            as Map<String, dynamic>,
      );
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'server': {'name': 'Updated SyncTV'},
            'roomDefaults': {'defaultMaxMembers': '100'},
            'roomCreation': {'maxRoomsPerUser': '42', 'enabled': true},
            'permissions': {},
            'user': {},
            'oauth2': {},
            'rtmp': {},
            'email': {},
            'webrtc': {},
            'chat': {},
            'playbackHistory': {
              'retentionDays': '60',
              'maxEntriesPerRoom': '100',
            },
            'cors': {
              'allowedOrigins': ['https://app.example.test'],
            },
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      await SyncTvService.runtimeUpdateSettingInSection(
        'server',
        'name',
        'Updated SyncTV',
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'roomCreation',
        'maxRoomsPerUser',
        42,
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'roomCreation',
        'enabled',
        false,
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'roomCreation',
        'passwordPolicy',
        'ROOM_PASSWORD_POLICY_FORBIDDEN',
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'cors',
        'allowedOrigins',
        ['https://app.example.test'],
      );
      await SyncTvService.runtimeUpdateSettingInSection('email', 'smtpProxy', {
        'url': 'socks5://proxy.example.test:1080',
        'credentials': {'username': 'proxy-user', 'password': 'proxy-secret'},
      });
      await SyncTvService.runtimeUpdateSettingInSection(
        'email',
        'smtpHost',
        'smtp.example.test',
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'email',
        'fromEmail',
        null,
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'rtmp',
        'customPublishHost',
        'rtmp://live.example.test',
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'rtmp',
        'customPublishHost',
        null,
      );
      await SyncTvService.runtimeUpdateSettingInSection(
        'playbackHistory',
        'retentionDays',
        60,
      );
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }

    expect(
      requestedUris.map((uri) => uri.path).toList(),
      everyElement('/api/admin/settings'),
    );
    expect(requestedBodies, [
      {
        'settings': {
          'server': {'name': 'Updated SyncTV'},
        },
        'updateMask': 'server.name',
      },
      {
        'settings': {
          'roomCreation': {'maxRoomsPerUser': '42'},
        },
        'updateMask': 'roomCreation.maxRoomsPerUser',
      },
      {
        'settings': {
          'roomCreation': {'enabled': false},
        },
        'updateMask': 'roomCreation.enabled',
      },
      {
        'settings': {
          'roomCreation': {'passwordPolicy': 3},
        },
        'updateMask': 'roomCreation.passwordPolicy',
      },
      {
        'settings': {
          'cors': {
            'allowedOrigins': ['https://app.example.test'],
          },
        },
        'updateMask': 'cors.allowedOrigins',
      },
      {
        'settings': {
          'email': {
            'smtpProxy': {
              'url': 'socks5://proxy.example.test:1080',
              'credentials': {
                'username': 'proxy-user',
                'password': 'proxy-secret',
              },
            },
          },
        },
        'updateMask': 'email.smtpProxy',
      },
      {
        'settings': {
          'email': {'smtpHost': 'smtp.example.test'},
        },
        'updateMask': 'email.smtpHost',
      },
      {
        'settings': {'email': <String, dynamic>{}},
        'updateMask': 'email.fromEmail',
      },
      {
        'settings': {
          'rtmp': {'customPublishHost': 'rtmp://live.example.test'},
        },
        'updateMask': 'rtmp.customPublishHost',
      },
      {
        'settings': {'rtmp': <String, dynamic>{}},
        'updateMask': 'rtmp.customPublishHost',
      },
      {
        'settings': {
          'playbackHistory': {'retentionDays': 60},
        },
        'updateMask': 'playbackHistory.retentionDays',
      },
    ]);
    expect(requestedBodies, everyElement(contains('settings')));
  });

  test(
    'admin runtime settings backup facades use export and import routes',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: SyncTvSession()
          ..updateAccountTokens(accessToken: 'admin-token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          final body = switch (request.url.path) {
            '/api/admin/settings/export' => {
              'formatVersion': 1,
              'settings': <String, dynamic>{},
            },
            '/api/admin/settings/import' => {
              'applied': false,
              'changedSections': ['email'],
            },
            _ => throw StateError(
              'Unexpected settings path ${request.url.path}',
            ),
          };
          return http.Response(
            jsonEncode(body),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final snapshot = await api.adminService.exportSettings(
        admin.ExportSettingsRequest(),
      );
      final result = await api.adminService.importSettings(
        admin.ImportSettingsRequest(snapshot: snapshot, dryRun: true),
      );

      expect(requests.map((request) => request.method), ['POST', 'POST']);
      expect(requests.map((request) => request.url.path), [
        '/api/admin/settings/export',
        '/api/admin/settings/import',
      ]);
      expect(requests.first.body, isEmpty);
      expect(jsonDecode(requests.last.body), {
        'snapshot': {'formatVersion': 1, 'settings': <String, dynamic>{}},
        'dryRun': true,
      });
      expect(result.applied, isFalse);
      expect(result.changedSections, ['email']);
    },
  );

  test('room member service preserves pagination filters and version', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'members': [
              {
                'roomId': 'room_1',
                'userId': 'usr_1',
                'username': 'alice',
                'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                'permissions': '7',
                'joinedAt': '1700000000',
                'isOnline': true,
              },
            ],
            'total': 6,
            'version': 'members-v3',
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.getRoomMemberDetailsPage(
        'room_1',
        page: 2,
        pageSize: 25,
        search: 'alice',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        sortBy:
            client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME,
        sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 6);
      expect(page.page, 2);
      expect(page.pageSize, 25);
      expect(page.version, 'members-v3');
      expect(page.members.single.userId, 'usr_1');
      expect(page.members.single.isOnline, isTrue);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/members');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'pageSize': '25',
      'search': 'alice',
      'role': '${common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value}',
      'sortBy':
          '${client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME.value}',
      'sortDirection': '${client_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test(
    'room join review service preserves pagination filters and total',
    () async {
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        requestedUri = request.uri;
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'reviews': [
                {
                  'id': 'rev_1',
                  'roomId': 'room_1',
                  'userId': 'usr_2',
                  'username': 'bob',
                  'requestedRole':
                      common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                  'status': common.ReviewStatus.REVIEW_STATUS_PENDING.value,
                  'requestedAt': '1700000001',
                },
              ],
              'total': 3,
            }),
          );
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final page = await SyncTvService.listRoomJoinReviewsPage(
          'room_1',
          page: 4,
          pageSize: 10,
          status: common.ReviewStatus.REVIEW_STATUS_PENDING,
          userId: 'usr_2',
        );

        expect(page.total, 3);
        expect(page.page, 4);
        expect(page.pageSize, 10);
        expect(page.reviews.single.id, 'rev_1');
        expect(page.reviews.single.username, 'bob');
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/rooms/room_1/reviews/joins');
      expect(requestedUri!.queryParameters, {
        'page': '4',
        'pageSize': '10',
        'status': '${common.ReviewStatus.REVIEW_STATUS_PENDING.value}',
        'userId': 'usr_2',
      });
    },
  );

  test('kick member sends protobuf request body instead of query', () async {
    Uri? requestedUri;
    String? requestBody;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response(
          '{}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.kickMember(
      'room_1',
      client.KickMemberRequest(
        userId: 'user_1',
        kickCooldownSeconds: Int64(120),
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/members/user_1');
    expect(
      requestedUri!.queryParameters,
      isNot(contains('kickCooldownSeconds')),
    );
    expect(jsonDecode(requestBody!), {
      'userId': 'user_1',
      'kickCooldownSeconds': '120',
    });
  });

  test('room management kick member preserves custom cooldown', () async {
    Uri? requestedUri;
    String? requestBody;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      requestBody = await utf8.decoder.bind(request).join();
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write('{}');
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      await SyncTvService.kickMember(
        'room_1',
        'usr_9',
        kickCooldownSeconds: 300,
      );
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/room_1/members/usr_9');
    expect(jsonDecode(requestBody!), {
      'userId': 'usr_9',
      'kickCooldownSeconds': '300',
    });
  });

  test('member permission overrides send protobuf request body', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'member': {
              'roomId': 'room_1',
              'userId': 'usr_1',
              'username': 'alice',
              'role': 3,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.room.updateMemberPermissions(
      'room_1',
      client.UpdateMemberPermissionsRequest(
        userId: 'usr_1',
        addedPermissions: Int64(1),
        removedPermissions: Int64(4),
        adminAddedPermissions: Int64(0),
        adminRemovedPermissions: Int64(0),
      ),
    );
    await api.room.updateMemberPermissions(
      'room_1',
      client.UpdateMemberPermissionsRequest(
        userId: 'usr_1',
        addedPermissions: Int64(0),
        removedPermissions: Int64(0),
        adminAddedPermissions: Int64(2),
        adminRemovedPermissions: Int64(8),
      ),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'PATCH');
    expect(requests.first.url.path, '/api/rooms/room_1/members/usr_1');
    final memberBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(memberBody['userId'], 'usr_1');
    expect(memberBody['addedPermissions'], '1');
    expect(memberBody['removedPermissions'], '4');
    expect(memberBody['adminAddedPermissions'], '0');
    expect(memberBody['adminRemovedPermissions'], '0');

    final adminBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(adminBody['userId'], 'usr_1');
    expect(adminBody['addedPermissions'], '0');
    expect(adminBody['removedPermissions'], '0');
    expect(adminBody['adminAddedPermissions'], '2');
    expect(adminBody['adminRemovedPermissions'], '8');
  });

  test(
    'member role update returns the authoritative member snapshot',
    () async {
      http.Request? capturedRequest;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'roomId': 'room_1',
              'userId': 'usr_1',
              'username': 'alice',
              'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
              'permissions': '${RoomAdminPermissions.defaults}',
              'adminAddedPermissions':
                  '${RoomAdminPermissions.controlPlaybackState}',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final service = SyncTvRoomManagementDomainService(api);

      final member = await service.setRoomMemberRole(
        'room_1',
        'usr_1',
        common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
      );

      expect(member.userId, 'usr_1');
      expect(member.role, common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN);
      expect(member.permissions, RoomAdminPermissions.defaults);
      expect(
        member.adminAddedPermissions,
        RoomAdminPermissions.controlPlaybackState,
      );
      expect(capturedRequest?.method, 'PATCH');
      expect(capturedRequest?.url.path, '/api/rooms/room_1/members/usr_1');
      expect(jsonDecode(capturedRequest!.body), {
        'userId': 'usr_1',
        'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
      });
    },
  );

  test('member display metadata routes use latest protobuf contract', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'roomId': 'room_1',
            'userId': 'usr_1',
            'username': 'alice',
            'role': 3,
            'remarkName': 'Alice A.',
            'displayTag': 'host',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final remark = await api.room.updateMemberRemarkName(
      'room_1',
      client.UpdateMemberRemarkNameRequest(
        userId: 'usr_1',
        remarkName: 'Alice A.',
      ),
    );
    final tag = await api.room.updateMemberDisplayTag(
      'room_1',
      client.UpdateMemberDisplayTagRequest(userId: 'usr_1', displayTag: 'host'),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'PATCH');
    expect(
      requests.first.url.path,
      '/api/rooms/room_1/members/usr_1/remark-name',
    );
    expect(jsonDecode(requests.first.body), {
      'userId': 'usr_1',
      'remarkName': 'Alice A.',
    });
    expect(requests.last.method, 'PATCH');
    expect(
      requests.last.url.path,
      '/api/rooms/room_1/members/usr_1/display-tag',
    );
    expect(jsonDecode(requests.last.body), {
      'userId': 'usr_1',
      'displayTag': 'host',
    });
    expect(remark.remarkName, 'Alice A.');
    expect(tag.displayTag, 'host');
  });

  test('room lifecycle and member commands use protobuf contract', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/room_1/owner':
            return http.Response(
              jsonEncode({
                'room': {
                  'id': 'room_1',
                  'name': 'Room',
                  'createdBy': 'usr_2',
                  'status': 1,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/members':
            return http.Response(
              jsonEncode({
                'member': {
                  'roomId': 'room_1',
                  'userId': 'usr_3',
                  'username': 'carol',
                  'role': 3,
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1/members/@me':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/room_1':
            return http.Response(
              jsonEncode({'success': true}),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response('not found', 404);
      }),
    );

    await api.room.transferRoomOwnership(
      'room_1',
      client.TransferRoomOwnershipRequest(newOwnerUserId: 'usr_2'),
    );
    await api.room.addMember(
      'room_1',
      client.AddMemberRequest(
        userId: 'usr_3',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
        notify: false,
      ),
    );
    await api.room.leaveRoom('room_1', client.LeaveRoomRequest());
    await api.room.deleteRoom('room_1', client.DeleteRoomRequest());

    expect(requests.map((request) => request.method), [
      'POST',
      'POST',
      'DELETE',
      'DELETE',
    ]);
    expect(requests.map((request) => request.url.path), [
      '/api/rooms/room_1/owner',
      '/api/rooms/room_1/members',
      '/api/rooms/room_1/members/@me',
      '/api/rooms/room_1',
    ]);
    expect(jsonDecode(requests[0].body), {'newOwnerUserId': 'usr_2'});
    expect(jsonDecode(requests[1].body), {
      'userId': 'usr_3',
      'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
      'notify': false,
    });
    expect(requests[2].body, isEmpty);
    expect(requests[3].body, isEmpty);
  });

  test('admin room ban and password update preserve protobuf fields', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/password')) {
          return http.Response(
            jsonEncode({'success': true}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_1',
              'name': 'Room',
              'createdBy': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              'isBanned': true,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.banRoom(
      admin.BanRoomRequest(roomId: 'room_1', reason: 'abuse'),
    );
    await api.adminService.updateRoomPassword(
      admin.UpdateRoomPasswordRequest(roomId: 'room_1', newPassword: ''),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/admin/rooms/room_1/ban');
    expect(jsonDecode(requests.first.body), {
      'roomId': 'room_1',
      'reason': 'abuse',
    });
    expect(requests.last.method, 'POST');
    expect(requests.last.url.path, '/api/admin/rooms/room_1/password');
    expect(jsonDecode(requests.last.body), {
      'roomId': 'room_1',
      'newPassword': '',
    });
  });

  test('room password clear uses room password delete endpoint', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvRoomManagementDomainService(api);

    await service.updateRoomPassword('room_1', '');

    expect(requests, hasLength(1));
    expect(requests.single.method, 'DELETE');
    expect(requests.single.url.path, '/api/rooms/room_1/password');
    expect(jsonDecode(requests.single.body), <String, dynamic>{});
  });

  test(
    'room password update registers OPAQUE bytes without plaintext',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/rooms/room_1/password/opaque/registration/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'room_password_session',
                  'registrationResponse': base64Encode([9, 8, 7]),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/password/opaque/registration/finish':
              return http.Response(
                jsonEncode({'success': true}),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );
      final service = SyncTvRoomManagementDomainService(
        api,
        opaqueClient: _FakeOpaqueClient(),
      );

      await service.updateRoomPassword('room_1', 'plain-room-password');

      expect(requests.map((request) => request.method), ['PATCH', 'PATCH']);
      expect(requests.map((request) => request.url.path), [
        '/api/rooms/room_1/password/opaque/registration/start',
        '/api/rooms/room_1/password/opaque/registration/finish',
      ]);

      final bodies = requests
          .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
          .toList();
      expect(bodies[0], {
        'registrationRequest': base64Encode([1, 2, 3]),
      });
      expect(bodies[1], {
        'sessionId': 'room_password_session',
        'registrationUpload': base64Encode([4, 5, 6]),
      });
      for (final body in bodies) {
        expect(body.containsKey('password'), isFalse);
        expect(body.values, isNot(contains('plain-room-password')));
      }
    },
  );

  test(
    'room join with password uses OPAQUE login bytes without plaintext',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/rooms/room_1/password/opaque/login/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'room_login_session',
                  'credentialResponse': base64Encode([30, 31, 32]),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/password/opaque/login/finish':
              return http.Response(
                jsonEncode({
                  'room': {
                    'id': 'room_1',
                    'name': 'Room',
                    'createdBy': 'usr_1',
                    'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
                  },
                  'member': {
                    'roomId': 'room_1',
                    'userId': 'usr_2',
                    'username': 'bob',
                    'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );
      final service = SyncTvPublicRoomDomainService(
        api: api,
        authService: SyncTvAuthDomainService(
          api: api,
          sessionStore: SyncTvSessionStore(api.session),
        ),
        opaqueClient: _FakeOpaqueClient(),
      );

      await service.joinRoom('room_1', 'plain-room-password');

      expect(requests.map((request) => request.method), ['POST', 'POST']);
      expect(requests.map((request) => request.url.path), [
        '/api/rooms/room_1/password/opaque/login/start',
        '/api/rooms/room_1/password/opaque/login/finish',
      ]);

      final bodies = requests
          .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
          .toList();
      expect(bodies[0], {
        'roomId': 'room_1',
        'credentialRequest': base64Encode([40, 41, 42]),
      });
      expect(bodies[1], {
        'sessionId': 'room_login_session',
        'credentialFinalization': base64Encode([50, 51, 52]),
      });
      for (final body in bodies) {
        expect(body.containsKey('password'), isFalse);
        expect(body.values, isNot(contains('plain-room-password')));
      }
    },
  );

  test(
    'room join without password keeps plain membership endpoint empty',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          return http.Response(
            jsonEncode({
              'room': {
                'id': 'room_1',
                'name': 'Room',
                'createdBy': 'usr_1',
                'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              },
              'member': {
                'roomId': 'room_1',
                'userId': 'usr_2',
                'username': 'bob',
                'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final sessionStore = SyncTvSessionStore(api.session);
      final service = SyncTvPublicRoomDomainService(
        api: api,
        authService: SyncTvAuthDomainService(
          api: api,
          sessionStore: sessionStore,
        ),
      );

      await service.joinRoom('room_1', '');

      expect(requests, hasLength(1));
      expect(requests.single.method, 'PUT');
      expect(requests.single.url.path, '/api/rooms/room_1/members/@me');
      expect(jsonDecode(requests.single.body), {'roomId': 'room_1'});
    },
  );

  test('admin unban room uses protobuf path command endpoint', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_1',
              'name': 'Room',
              'createdBy': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_ACTIVE.value,
              'isBanned': false,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.unbanRoom(admin.UnbanRoomRequest(roomId: 'room_1'));

    expect(requests, hasLength(1));
    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/api/admin/rooms/room_1/unban');
    expect(requests.single.body, isEmpty);
  });

  test(
    'admin kick member sends protobuf request body instead of query',
    () async {
      Uri? requestedUri;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestBody = request.body;
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await api.adminService.kickMember(
        admin.KickMemberRequest(
          roomId: 'room_1',
          userId: 'user_1',
          kickCooldownSeconds: Int64(180),
        ),
      );

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/admin/rooms/room_1/members/user_1');
      expect(
        requestedUri!.queryParameters,
        isNot(contains('kickCooldownSeconds')),
      );
      expect(jsonDecode(requestBody!), {
        'roomId': 'room_1',
        'userId': 'user_1',
        'kickCooldownSeconds': '180',
      });
    },
  );

  test('admin add member sends current room member role enum body', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'member': {
              'roomId': 'room_1',
              'userId': 'usr_1',
              'username': 'alice',
              'role': 3,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.adminService.addMember(
      admin.AddMemberRequest(
        roomId: 'room_1',
        userId: 'usr_1',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
        notify: true,
      ),
    );
    await api.adminService.addMember(
      admin.AddMemberRequest(
        roomId: 'room_1',
        userId: 'usr_2',
        role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
        notify: false,
      ),
    );

    expect(requests, hasLength(2));
    expect(requests.first.method, 'POST');
    expect(requests.first.url.path, '/api/admin/rooms/room_1/members');
    final memberBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
    expect(memberBody['roomId'], 'room_1');
    expect(memberBody['userId'], 'usr_1');
    expect(
      memberBody['role'],
      common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
    );
    expect(memberBody['notify'], isTrue);

    final adminBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
    expect(adminBody['userId'], 'usr_2');
    expect(
      adminBody['role'],
      common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
    );
    expect(adminBody['notify'], isFalse);
  });

  test(
    'admin room member service preserves protobuf filters and options',
    () async {
      final requests = <http.Request>[];
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final subscription = server.listen((request) async {
        final body = await utf8.decoder.bind(request).join();
        requests.add(http.Request(request.method, request.uri)..body = body);
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json;
        if (request.method == 'GET') {
          request.response.write(
            jsonEncode({
              'members': [
                {
                  'roomId': 'room_1',
                  'userId': 'usr_1',
                  'username': 'alice',
                  'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                  'joinedAt': '1700000000',
                  'isOnline': true,
                },
              ],
              'total': 1,
            }),
          );
        } else if (request.method == 'POST') {
          request.response.write(
            jsonEncode({
              'member': {
                'roomId': 'room_1',
                'userId': 'usr_2',
                'username': 'bob',
                'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
              },
            }),
          );
        } else {
          request.response.write(jsonEncode({'success': true}));
        }
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(
          'http://${server.address.host}:${server.port}',
        );

        final page = await SyncTvService.adminListRoomMembersPage(
          'room_1',
          page: 2,
          pageSize: 20,
          search: 'alice',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          sortBy:
              admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME,
          sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
        );
        await SyncTvService.adminAddRoomMember(
          'room_1',
          'usr_2',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
          notify: false,
        );
        await SyncTvService.adminKickRoomMember(
          'room_1',
          'usr_1',
          kickCooldownSeconds: 900,
        );

        expect(page.total, 1);
        expect(page.members.single.userId, 'usr_1');
      } finally {
        await subscription.cancel();
        await server.close(force: true);
      }

      expect(requests, hasLength(3));
      expect(requests[0].method, 'GET');
      expect(requests[0].url.path, '/api/admin/rooms/room_1/members');
      expect(requests[0].url.queryParameters, {
        'page': '2',
        'pageSize': '20',
        'search': 'alice',
        'role': '${common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value}',
        'sortBy':
            '${admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_USERNAME.value}',
        'sortDirection': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
      });
      expect(jsonDecode(requests[1].body), {
        'roomId': 'room_1',
        'userId': 'usr_2',
        'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
        'notify': false,
      });
      expect(jsonDecode(requests[2].body), {
        'roomId': 'room_1',
        'userId': 'usr_1',
        'kickCooldownSeconds': '900',
      });
    },
  );

  test('admin list admins service preserves pagination and total', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'admins': [
              {
                'id': 'usr_1',
                'username': 'root',
                'email': 'root@example.test',
                'role': common.UserRole.USER_ROLE_ROOT.value,
                'status': common.UserStatus.USER_STATUS_ACTIVE.value,
              },
            ],
            'total': 12,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListAdminsPage(
        page: 3,
        pageSize: 20,
        search: 'root',
        sortBy: admin_enum.UserListSortBy.USER_LIST_SORT_BY_USERNAME,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      );

      expect(page.total, 12);
      expect(page.admins.single.id, 'usr_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/admins');
    expect(requestedUri!.queryParameters, {
      'page': '3',
      'pageSize': '20',
      'search': 'root',
      'sortBy': '${admin_enum.UserListSortBy.USER_LIST_SORT_BY_USERNAME.value}',
      'sortDirection': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
  });

  test(
    'admin add admin promotes an existing user through path command',
    () async {
      http.Request? capturedRequest;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final service = SyncTvAdminDomainService(api);

      await service.addAdmin('usr_2');

      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.method, 'POST');
      expect(capturedRequest!.url.path, '/api/admin/admins/usr_2');
      expect(jsonDecode(capturedRequest!.body), {'userId': 'usr_2'});
    },
  );

  test(
    'admin member role and permission overrides use protobuf body',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          return http.Response(
            jsonEncode({
              'member': {
                'roomId': 'room_1',
                'userId': 'usr_1',
                'username': 'alice',
                'role': 2,
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await api.adminService.updateMemberPermissions(
        admin.UpdateMemberPermissionsRequest(
          roomId: 'room_1',
          userId: 'usr_1',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          adminAddedPermissions: Int64(2),
          adminRemovedPermissions: Int64(8),
        ),
      );
      await api.adminService.updateMemberPermissions(
        admin.UpdateMemberPermissionsRequest(
          roomId: 'room_1',
          userId: 'usr_1',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
          addedPermissions: Int64(1),
          removedPermissions: Int64(4),
        ),
      );

      expect(requests, hasLength(2));
      expect(requests.first.method, 'PATCH');
      expect(requests.first.url.path, '/api/admin/rooms/room_1/members/usr_1');
      final adminBody = jsonDecode(requests.first.body) as Map<String, dynamic>;
      expect(adminBody['roomId'], 'room_1');
      expect(adminBody['userId'], 'usr_1');
      expect(
        adminBody['role'],
        common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
      );
      expect(adminBody['adminAddedPermissions'], '2');
      expect(adminBody['adminRemovedPermissions'], '8');

      final memberBody = jsonDecode(requests.last.body) as Map<String, dynamic>;
      expect(
        memberBody['role'],
        common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
      );
      expect(memberBody['addedPermissions'], '1');
      expect(memberBody['removedPermissions'], '4');
    },
  );

  test(
    'admin member display metadata routes use latest protobuf contract',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          return http.Response(
            jsonEncode({
              'roomId': 'room_1',
              'userId': 'usr_1',
              'username': 'alice',
              'role': 2,
              'remarkName': 'Alice A.',
              'displayTag': 'host',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final remark = await api.adminService.updateMemberRemarkName(
        admin.UpdateMemberRemarkNameRequest(
          roomId: 'room_1',
          userId: 'usr_1',
          remarkName: 'Alice A.',
        ),
      );
      final tag = await api.adminService.updateMemberDisplayTag(
        admin.UpdateMemberDisplayTagRequest(
          roomId: 'room_1',
          userId: 'usr_1',
          displayTag: 'host',
        ),
      );

      expect(requests, hasLength(2));
      expect(requests.first.method, 'PATCH');
      expect(
        requests.first.url.path,
        '/api/admin/rooms/room_1/members/usr_1/remark-name',
      );
      expect(jsonDecode(requests.first.body), {
        'roomId': 'room_1',
        'userId': 'usr_1',
        'remarkName': 'Alice A.',
      });
      expect(requests.last.method, 'PATCH');
      expect(
        requests.last.url.path,
        '/api/admin/rooms/room_1/members/usr_1/display-tag',
      );
      expect(jsonDecode(requests.last.body), {
        'roomId': 'room_1',
        'userId': 'usr_1',
        'displayTag': 'host',
      });
      expect(remark.remarkName, 'Alice A.');
      expect(tag.displayTag, 'host');
    },
  );

  test(
    'available provider instances query is generated from protobuf request',
    () async {
      Uri? requestedUri;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await api.providerCommon.listAvailableProviderInstances(
        provider_common.ListAvailableProviderInstancesRequest(
          providerType: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        ),
      );

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/instances/available');
      expect(
        requestedUri!.queryParameters,
        containsPair('providerType', 'emby'),
      );
    },
  );

  test('provider instance domain service maps protobuf response', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final listener = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'instances': ['home', 'edge'],
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final instances = await SyncTvService.listAvailableProviderInstances(
        providerType: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value
            .toString(),
      );

      expect(instances, ['home', 'edge']);
      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/instances/available');
      expect(
        requestedUri!.queryParameters,
        containsPair('providerType', 'emby'),
      );
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('alist search sends protobuf request body', () async {
    Uri? requestedUri;
    String? requestBody;
    const directoryCredential = 'not-real-directory-credential';
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        requestBody = request.body;
        return http.Response(
          jsonEncode({'content': <Object?>[], 'total': '0'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.alistProvider.search(
      alist.SearchRequest(
        serverId: 'server_1',
        parent: '/movies',
        keywords: 'matrix',
        scope: Int64(2),
        page: Int64(3),
        perPage: Int64(40),
        password: directoryCredential,
        instanceName: 'edge',
      ),
    );

    expect(response, isA<alist.SearchResponse>());
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/alist/search');
    expect(requestedUri!.queryParameters, isEmpty);
    expect(jsonDecode(requestBody!), {
      'serverId': 'server_1',
      'parent': '/movies',
      'keywords': 'matrix',
      'scope': '2',
      'page': '3',
      'perPage': '40',
      'password': directoryCredential,
      'instanceName': 'edge',
    });
  });

  test(
    'alist list sends directory password in protobuf request body',
    () async {
      Uri? requestedUri;
      String? requestBody;
      const directoryCredential = 'not-real-directory-credential';
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestBody = request.body;
          return http.Response(
            jsonEncode({
              'content': [
                {
                  'name': 'entry.mp4',
                  'size': '1024',
                  'isDir': false,
                  'modified': '1760000100',
                  'thumb': '/thumb.jpg',
                  'type': '2',
                  'sign': 'signed-query-fragment',
                },
              ],
              'total': '1',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.alistProvider.list(
        alist.ListRequest(
          serverId: 'server_1',
          path: '/private',
          page: Int64(2),
          perPage: Int64(30),
          password: directoryCredential,
          refresh: true,
          instanceName: 'edge',
        ),
      );

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/alist/list');
      expect(requestedUri!.queryParameters, isEmpty);
      expect(jsonDecode(requestBody!), {
        'serverId': 'server_1',
        'path': '/private',
        'password': directoryCredential,
        'page': '2',
        'perPage': '30',
        'refresh': true,
        'instanceName': 'edge',
      });
      expect(response.content.single.sign, 'signed-query-fragment');
    },
  );

  test('alist domain model preserves file item sign', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'content': [
              {
                'name': 'entry.mp4',
                'size': '1024',
                'isDir': false,
                'modified': '1760000100',
                'thumb': '/thumb.jpg',
                'type': '2',
                'sign': 'signed-query-fragment',
              },
            ],
            'total': '1',
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.listAlistPage(
        '/private',
        serverId: 'server_1',
      );

      expect(page.items.single.sign, 'signed-query-fragment');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test(
    'alist login sends plaintext credential and optional otp fields',
    () async {
      Uri? requestedUri;
      String? requestBody;
      const providerCredential = 'not-real-provider-credential';
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestBody = request.body;
          return http.Response(
            jsonEncode({'token': 'alist_token', 'serverId': 'server_1'}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.alistProvider.login(
        alist.LoginRequest(
          host: 'https://alist.example.test',
          username: 'alice',
          password: providerCredential,
          otpCode: '',
          otpSecret: '',
          instanceName: 'edge',
        ),
      );

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/alist/login');
      expect(response.token, 'alist_token');
      expect(response.serverId, 'server_1');
      expect(requestedUri!.queryParameters, isEmpty);
      expect(jsonDecode(requestBody!), {
        'host': 'https://alist.example.test',
        'username': 'alice',
        'password': providerCredential,
        'otpCode': '',
        'otpSecret': '',
        'instanceName': 'edge',
      });
    },
  );

  test(
    'provider login supports alist otp and emby api key protobuf oneof',
    () async {
      final requests = <http.Request>[];
      const providerCredential = 'not-real-provider-credential';
      const embyCredential = 'not-real-emby-credential';
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.url.path == '/api/providers/alist/login') {
            return http.Response(
              jsonEncode({'token': 'alist_token', 'serverId': 'alist_server'}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path == '/api/providers/emby/login') {
            return http.Response(
              jsonEncode({
                'userId': 'emby_user',
                'username': 'alice',
                'is_admin': true,
                'serverId': 'emby_server',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('not found', 404);
        }),
      );

      await api.alistProvider.login(
        alist.LoginRequest(
          host: 'https://alist.example.test',
          username: 'alice',
          password: providerCredential,
          otpCode: '123456',
          otpSecret: 'totp-secret',
          instanceName: 'alist-edge',
        ),
      );
      await api.alistProvider.login(
        alist.LoginRequest(
          host: 'https://alist2.example.test',
          username: 'alice',
          hashedPassword: 'hashed-password',
          otpCode: '',
          otpSecret: '',
          instanceName: 'alist-hashed',
        ),
      );
      await api.embyProvider.login(
        emby.LoginRequest(
          host: 'https://jellyfin.example.test',
          username: 'bob',
          apiKey: embyCredential,
          instanceName: 'emby-edge',
        ),
      );

      expect(requests.map((request) => request.url.path), [
        '/api/providers/alist/login',
        '/api/providers/alist/login',
        '/api/providers/emby/login',
      ]);
      expect(jsonDecode(requests[0].body), {
        'host': 'https://alist.example.test',
        'username': 'alice',
        'password': providerCredential,
        'otpCode': '123456',
        'otpSecret': 'totp-secret',
        'instanceName': 'alist-edge',
      });
      expect(jsonDecode(requests[1].body), {
        'host': 'https://alist2.example.test',
        'username': 'alice',
        'hashedPassword': 'hashed-password',
        'otpCode': '',
        'otpSecret': '',
        'instanceName': 'alist-hashed',
      });
      expect(
        (jsonDecode(requests[1].body) as Map).containsKey('password'),
        isFalse,
      );
      expect(jsonDecode(requests[2].body), {
        'host': 'https://jellyfin.example.test',
        'username': 'bob',
        'apiKey': embyCredential,
        'instanceName': 'emby-edge',
      });
      expect(
        (jsonDecode(requests[2].body) as Map).containsKey('password'),
        isFalse,
      );
    },
  );

  test(
    'emby list maps server thumbnail proxy url from protobuf response',
    () async {
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final origin = 'http://${server.address.host}:${server.port}';
      final requests = server.listen((request) async {
        requestedUri = request.uri;
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'items': [
                {
                  'id': 'emby-item-1',
                  'name': 'Episode 1',
                  'type': 'Episode',
                  'description': 'Pilot episode',
                  'thumbnail':
                      '/api/providers/emby/thumbnail/emby-item-1?server_id=srv_1&credential_owner_id=usr_1&max_height=300',
                },
              ],
              'total': '1',
            }),
          );
        await request.response.close();
      });

      late final EmbyListPage page;
      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(origin);

        page = await SyncTvService.listEmbyPage(
          EmbyListMode.folder,
          targetId: '/',
          serverId: 'srv_1',
        );
      } finally {
        await requests.cancel();
        await server.close(force: true);
      }

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/emby/list');
      expect(page.items, hasLength(1));
      expect(
        page.items.single.thumbnail,
        '$origin/api/providers/emby/thumbnail/emby-item-1?server_id=srv_1&credential_owner_id=usr_1&max_height=300',
      );
      expect(page.items.single.description, 'Pilot episode');
    },
  );

  test('provider instance query is generated from protobuf request', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          '{}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.providerCommon.listProviderInstances(
      provider_common.ListProviderInstancesRequest(
        page: 2,
        pageSize: 10,
        providerType: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        search: 'home',
        enabled: true,
        tls: false,
        sortBy: provider_common
            .ProviderInstanceListSortBy
            .PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
        sortDirection: provider_common.SortDirection.SORT_DIRECTION_DESC,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/instances');
    expect(requestedUri!.queryParameters, containsPair('page', '2'));
    expect(requestedUri!.queryParameters, containsPair('pageSize', '10'));
    expect(requestedUri!.queryParameters, containsPair('providerType', 'emby'));
    expect(requestedUri!.queryParameters, containsPair('search', 'home'));
    expect(requestedUri!.queryParameters, containsPair('enabled', 'true'));
    expect(requestedUri!.queryParameters, containsPair('tls', 'false'));
    expect(requestedUri!.queryParameters, containsPair('sortBy', '3'));
    expect(requestedUri!.queryParameters, containsPair('sortDirection', '2'));
  });

  test(
    'provider instance service forwards paging TLS sort filters and total',
    () async {
      Uri? requestedUri;
      final server = await io.HttpServer.bind(
        io.InternetAddress.loopbackIPv4,
        0,
      );
      final origin = 'http://${server.address.host}:${server.port}';
      final requests = server.listen((request) async {
        requestedUri = request.uri;
        request.response
          ..statusCode = 200
          ..headers.contentType = io.ContentType.json
          ..write(
            jsonEncode({
              'instances': [
                {
                  'name': 'edge',
                  'endpoint': 'https://edge.example.test',
                  'providers': [
                    source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value,
                  ],
                  'timeoutSeconds': 30,
                  'tls': true,
                  'insecureTls': false,
                  'enabled': true,
                  'status': provider_common
                      .ProviderInstanceStatus
                      .PROVIDER_INSTANCE_STATUS_CONNECTED
                      .value,
                  'createdAt': '1700000000',
                  'updatedAt': '1700000100',
                },
              ],
              'total': 11,
            }),
          );
        await request.response.close();
      });

      try {
        SharedPreferences.setMockInitialValues({});
        await SyncTvService.init();
        await SyncTvService.setBaseUrl(origin);

        final page = await SyncTvService.adminListProviderInstancesPage(
          page: 3,
          pageSize: 20,
          providerType: source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value
              .toString(),
          search: 'edge',
          enabled: true,
          tls: false,
          sortBy: provider_common
              .ProviderInstanceListSortBy
              .PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT,
          sortDirection: provider_common.SortDirection.SORT_DIRECTION_DESC,
        );

        expect(page.total, 11);
        expect(page.instances.single.name, 'edge');
      } finally {
        await requests.cancel();
        await server.close(force: true);
      }

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/providers/instances');
      expect(requestedUri!.queryParameters, containsPair('page', '3'));
      expect(requestedUri!.queryParameters, containsPair('pageSize', '20'));
      expect(
        requestedUri!.queryParameters,
        containsPair('providerType', 'alist'),
      );
      expect(requestedUri!.queryParameters, containsPair('search', 'edge'));
      expect(requestedUri!.queryParameters, containsPair('enabled', 'true'));
      expect(requestedUri!.queryParameters, containsPair('tls', 'false'));
      expect(requestedUri!.queryParameters, containsPair('sortBy', '4'));
      expect(requestedUri!.queryParameters, containsPair('sortDirection', '2'));
    },
  );

  test('provider backend discovery uses protobuf path request', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'backends': ['alist', 'alist-edge'],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.providerCommon.listProviderBackends(
      provider_common.ListProviderBackendsRequest(
        providerType: source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
      ),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/providers/backends/alist');
    expect(response.backends, ['alist', 'alist-edge']);
  });

  test('provider instance mutations send protobuf request bodies', () async {
    final requests = <http.Request>[];
    Map<String, Object?> instanceJson({
      String name = 'edge',
      List<String> providers = const ['alist'],
      bool enabled = true,
    }) {
      return {
        'instance': {
          'name': name,
          'endpoint': 'https://provider.example.test',
          'comment': 'edge node',
          'timeoutSeconds': 30,
          'tls': true,
          'insecureTls': false,
          'providers': providers,
          'enabled': enabled,
          'status': 1,
          'createdAt': '1760000000',
          'updatedAt': '1760000010',
        },
      };
    }

    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.method == 'DELETE') {
          return http.Response(
            jsonEncode({'success': true}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode(
            instanceJson(enabled: !request.url.path.endsWith('/disable')),
          ),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.providerCommon.addProviderInstance(
      provider_common.AddProviderInstanceRequest(
        name: 'edge',
        endpoint: 'https://provider.example.test',
        providers: [
          source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
          source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        ],
        comment: 'edge node',
        timeoutSeconds: 45,
        tls: true,
        insecureTls: false,
        jwtSecret: 'jwt-secret',
        customCa: 'pem',
      ),
    );
    await api.providerCommon.updateProviderInstance(
      provider_common.UpdateProviderInstanceRequest(
        name: 'edge',
        endpoint: 'https://provider2.example.test',
        providers: [source_enum.SourceProvider.SOURCE_PROVIDER_ALIST],
        clearComment_10: true,
        clearJwtSecret_11: true,
        clearCustomCa_12: true,
      ),
    );
    await api.providerCommon.reconnectProviderInstance(
      provider_common.ReconnectProviderInstanceRequest(name: 'edge'),
    );
    await api.providerCommon.enableProviderInstance(
      provider_common.EnableProviderInstanceRequest(name: 'edge'),
    );
    await api.providerCommon.disableProviderInstance(
      provider_common.DisableProviderInstanceRequest(name: 'edge'),
    );
    await api.providerCommon.deleteProviderInstance(
      provider_common.DeleteProviderInstanceRequest(name: 'edge'),
    );

    expect(requests[0].method, 'POST');
    expect(requests[0].url.path, '/api/providers/instances');
    expect(jsonDecode(requests[0].body), {
      'name': 'edge',
      'endpoint': 'https://provider.example.test',
      'comment': 'edge node',
      'timeoutSeconds': 45,
      'tls': true,
      'insecureTls': false,
      'providers': [
        source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value,
        source_enum.SourceProvider.SOURCE_PROVIDER_EMBY.value,
      ],
      'jwtSecret': 'jwt-secret',
      'customCa': 'pem',
    });

    expect(requests[1].method, 'PUT');
    expect(requests[1].url.path, '/api/providers/instances/edge');
    expect(jsonDecode(requests[1].body), {
      'name': 'edge',
      'endpoint': 'https://provider2.example.test',
      'providers': [source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value],
      'clearComment': true,
      'clearJwtSecret': true,
      'clearCustomCa': true,
    });

    expect(requests[2].method, 'POST');
    expect(requests[2].url.path, '/api/providers/instances/edge/reconnect');
    expect(requests[2].body, isEmpty);
    expect(requests[3].url.path, '/api/providers/instances/edge/enable');
    expect(requests[4].url.path, '/api/providers/instances/edge/disable');
    expect(requests[5].method, 'DELETE');
    expect(requests[5].url.path, '/api/providers/instances/edge');
  });

  test('OAuth2 unlink sends provider instance and user id query', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({'success': true, 'removedCount': 1}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.oauth2Service.unlinkProvider(
      oauth2.UnlinkProviderRequest(
        provider: oauth2.OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITHUB,
        providerInstanceName: 'github-main',
        providerUserId: 'gh_123',
      ),
    );

    expect(response.success, isTrue);
    expect(response.removedCount, 1);
    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/oauth2/type/github/unlink');
    expect(requestedUri!.queryParameters, {
      'providerUserId': 'gh_123',
      'providerInstanceName': 'github-main',
    });
  });

  test(
    'OAuth2 bind options keep already linked provider instances available',
    () {
      final providers = [
        const OAuth2ProviderOption(
          name: 'github-main',
          type: 'github',
          signupEnabled: true,
          signupNeedReview: false,
        ),
      ];
      const linked = [
        OAuth2LinkedAccount(
          providerType: 'github',
          providerUsername: 'alice',
          providerInstanceName: 'github-main',
          providerIssuer: 'https://github.com',
          providerUserId: 'gh_alice',
          linkedAt: 1_700_000_000,
        ),
      ];

      final bindable = oauth2BindableProviders(providers);

      expect(linked.single.providerInstanceName, 'github-main');
      expect(bindable, hasLength(1));
      expect(bindable.single.name, 'github-main');
    },
  );

  test('OAuth2 login result maps the registration review outcome', () async {
    Uri? requestedUri;
    String? requestBody;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      requestBody = await utf8.decoder.bind(request).join();
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'accessToken': '',
            'refreshToken': '',
            'expiresIn': '600',
            'redirectUrl': 'https://app.example.test/oauth2/done',
            'operation': 'OAUTH2_OPERATION_LOGIN',
            'registrationReviewRequired': true,
            'registrationReviewId': 'rev_oauth2_1',
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      expect(await SyncTvService.getToken(), isNull);
      final result = await SyncTvService.finishOAuth2Login(
        code: 'abc123',
        state: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
      );

      expect(result, isA<RegistrationReviewPending>());
      expect((result as RegistrationReviewPending).reviewId, 'rev_oauth2_1');
      expect(await SyncTvService.getToken(), isNull);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/oauth2/exchange');
    expect(jsonDecode(requestBody!), {
      'code': 'abc123',
      'state': 'AbCdEfGh1234567890aBcDeFgHiJkLm',
    });
  });

  test(
    'OAuth2 bind exchange does not overwrite the signed-in session',
    () async {
      final session = SyncTvSession()
        ..updateAccountTokens(accessToken: 'existing-access')
        ..updateAccountTokens(refreshToken: 'existing-refresh');
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: session,
        httpClient: MockClient((request) async {
          expect(request.headers['authorization'], 'Bearer existing-access');
          return http.Response(
            jsonEncode({
              'accessToken': '',
              'refreshToken': '',
              'operation': 'OAUTH2_OPERATION_BIND',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.oauth2Service.exchangeAuthorizationCode(
        oauth2.ExchangeAuthorizationCodeRequest(
          code: 'abc123',
          state: 'AbCdEfGh1234567890aBcDeFgHiJkLm',
        ),
      );

      expect(response.operation, oauth2.OAuth2Operation.OAUTH2_OPERATION_BIND);
      expect(session.accessToken, 'existing-access');
      expect(session.refreshToken, 'existing-refresh');
      expect(session.identity, isA<AccountSessionIdentity>());
    },
  );

  test(
    'Bilibili QR and SMS login endpoints use protobuf request bodies',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          if (request.url.path.endsWith('/login/qr/generate')) {
            return http.Response(
              jsonEncode({
                'url': 'https://passport.bilibili.com/qr',
                'key': 'qr_key',
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path.endsWith('/login/sms/start')) {
            return http.Response(
              jsonEncode({
                'sessionToken': 'sms_session_1',
                'gt': 'gt_value',
                'challenge': 'challenge_value',
                'expiresAt': 1710000300,
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path.endsWith('/login/sms/send')) {
            return http.Response(
              jsonEncode({
                'sessionToken': 'sms_session_2',
                'expiresAt': 1710000360,
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (request.url.path.endsWith('/login/sms/login')) {
            return http.Response(
              '{}',
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('{}', 404);
        }),
      );

      final qr = await api.bilibiliProvider.loginQR(
        bilibili.LoginQRRequest(instanceName: 'main'),
      );
      final smsStart = await api.bilibiliProvider.startSMSLogin(
        bilibili.StartSMSLoginRequest(instanceName: 'main'),
      );
      final smsSend = await api.bilibiliProvider.sendSMS(
        bilibili.SendSMSRequest(
          sessionToken: 'sms_session_1',
          phone: '13800138000',
          validate: 'geetest_validate',
        ),
      );
      await api.bilibiliProvider.loginSMS(
        bilibili.LoginSMSRequest(sessionToken: 'sms_session_2', code: '123456'),
      );

      expect(qr.url, 'https://passport.bilibili.com/qr');
      expect(qr.key, 'qr_key');
      expect(smsStart.sessionToken, 'sms_session_1');
      expect(smsStart.gt, 'gt_value');
      expect(smsStart.challenge, 'challenge_value');
      expect(smsStart.expiresAt.toInt(), 1710000300);
      expect(smsSend.sessionToken, 'sms_session_2');
      expect(smsSend.expiresAt.toInt(), 1710000360);
      expect(requests[0].url.path, '/api/providers/bilibili/login/qr/generate');
      expect(jsonDecode(requests[0].body), {'instanceName': 'main'});
      expect(requests[1].url.path, '/api/providers/bilibili/login/sms/start');
      expect(jsonDecode(requests[1].body), {'instanceName': 'main'});
      expect(requests[2].url.path, '/api/providers/bilibili/login/sms/send');
      expect(jsonDecode(requests[2].body), {
        'sessionToken': 'sms_session_1',
        'phone': '13800138000',
        'validate': 'geetest_validate',
      });
      expect(requests[3].url.path, '/api/providers/bilibili/login/sms/login');
      expect(jsonDecode(requests[3].body), {
        'sessionToken': 'sms_session_2',
        'code': '123456',
      });
    },
  );

  test('Bilibili Geetest page bridges frontend-rendered validate result', () {
    final html = buildBilibiliGeetestHtml(
      gt: 'gt"</script><script>bad()</script>',
      challenge: r'challenge\value',
    );

    expect(html, contains('https://static.geetest.com/static/tools/gt.js'));
    expect(html, contains('initGeetest({'));
    expect(html, contains('SyncTVGeetest.postMessage'));
    expect(html, contains(r'gt\"\u003c/script\u003e'));
    expect(html, contains(r'challenge\\value'));

    final result = parseBilibiliGeetestMessage(
      jsonEncode({'validate': ' geetest_validate '}),
    );
    expect(result.validate, 'geetest_validate');

    expect(
      () => parseBilibiliGeetestMessage(jsonEncode({'validate': ''})),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => parseBilibiliGeetestMessage(jsonEncode({'error': 'load failed'})),
      throwsA(isA<StateError>()),
    );
  });

  test(
    'notification write endpoints accept protobuf bodies and 204 responses',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          return http.Response('', 204);
        }),
      );

      await api.notifications.markAsRead(
        client.MarkAsReadRequest(notificationIds: [Int64(42), Int64(43)]),
      );
      await api.notifications.markAllAsRead(
        client.MarkAllAsReadRequest(before: Int64(1_700_000_000)),
      );
      await api.notifications.deleteAllRead(client.DeleteAllReadRequest());

      expect(requests, hasLength(3));
      expect(requests[0].method, 'POST');
      expect(requests[0].url.path, '/api/notifications/actions/mark-read');
      expect(jsonDecode(requests[0].body), {
        'notificationIds': ['42', '43'],
      });
      expect(requests[1].method, 'POST');
      expect(requests[1].url.path, '/api/notifications/read-all');
      expect(jsonDecode(requests[1].body), {'before': '1700000000'});
      expect(requests[2].method, 'DELETE');
      expect(requests[2].url.path, '/api/notifications/read');
      expect(requests[2].body, isEmpty);
    },
  );

  test('notification service batches valid ids for mark read', () async {
    http.Request? capturedRequest;
    final server = await io.HttpServer.bind('127.0.0.1', 0);
    final listener = server.listen((request) async {
      final body = await utf8.decoder.bind(request).join();
      capturedRequest = http.Request(request.method, request.uri)..body = body;
      request.response
        ..statusCode = 204
        ..headers.contentType = io.ContentType.json;
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      await SyncTvService.markNotificationsAsRead([0, 42, -1, 43]);
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }

    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.method, 'POST');
    expect(capturedRequest!.url.path, '/api/notifications/actions/mark-read');
    expect(jsonDecode(capturedRequest!.body), {
      'notificationIds': ['42', '43'],
    });
  });

  test(
    'websocket ticket endpoint uses protobuf body for signed-in users',
    () async {
      Uri? requestedUri;
      String? requestBody;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          requestBody = request.body;
          return http.Response(
            jsonEncode({
              'ticket': 'ws_ticket_1',
              'roomId': 'room_1',
              'expiresInSecs': '30',
              'usage': 'Use in WebSocket URL',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.room.createWebSocketTicket(
        client.CreateWebSocketTicketRequest(roomId: 'room_1'),
      );

      expect(response.ticket, 'ws_ticket_1');
      expect(response.roomId, 'room_1');
      expect(response.expiresInSecs.toInt(), 30);
      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/tickets');
      expect(requestedUri!.queryParameters, isEmpty);
      expect(jsonDecode(requestBody!), {'roomId': 'room_1'});
    },
  );

  test(
    'room facade keeps room path separate from protobuf bodies and queries',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/rooms/room_1/members':
              if (request.method == 'GET') {
                return http.Response(
                  jsonEncode({'members': [], 'total': 0, 'version': 'v1'}),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              }
              return http.Response(
                jsonEncode({
                  'member': {
                    'roomId': 'room_1',
                    'userId': 'usr_2',
                    'username': 'bob',
                    'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/members/usr_2':
              return http.Response(
                jsonEncode({
                  'member': {
                    'roomId': 'room_1',
                    'userId': 'usr_2',
                    'username': 'bob',
                    'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                    'addedPermissions': '7',
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/playlists/pl_1':
              return http.Response(
                jsonEncode({'success': true}),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/rooms/room_1/playback/stop':
              return http.Response(
                '{}',
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );

      await api.room.getRoomMembers(
        'room_1',
        client.GetRoomMembersRequest(
          page: 2,
          pageSize: 10,
          search: 'bob',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          sortBy: client_enum
              .RoomMemberListSortBy
              .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
          sortDirection: client_enum.SortDirection.SORT_DIRECTION_ASC,
        ),
      );
      await api.room.addMember(
        'room_1',
        client.AddMemberRequest(
          userId: 'usr_2',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
          notify: true,
        ),
      );
      await api.room.updateMemberPermissions(
        'room_1',
        client.UpdateMemberPermissionsRequest(
          userId: 'usr_2',
          role: common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
          addedPermissions: Int64(7),
        ),
      );
      await api.room.deletePlaylist(
        'room_1',
        client.DeletePlaylistRequest(playlistId: 'pl_1', force: true),
      );
      await api.room.stopPlayback('room_1', client.StopPlaybackRequest());

      expect(requests[0].method, 'GET');
      expect(requests[0].url.path, '/api/rooms/room_1/members');
      expect(requests[0].url.queryParameters, {
        'page': '2',
        'pageSize': '10',
        'search': 'bob',
        'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value.toString(),
        'sortBy': client_enum
            .RoomMemberListSortBy
            .ROOM_MEMBER_LIST_SORT_BY_USERNAME
            .value
            .toString(),
        'sortDirection': client_enum.SortDirection.SORT_DIRECTION_ASC.value
            .toString(),
      });

      expect(requests[1].method, 'POST');
      expect(requests[1].url.path, '/api/rooms/room_1/members');
      expect(jsonDecode(requests[1].body), {
        'userId': 'usr_2',
        'role': common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
        'notify': true,
      });

      expect(requests[2].method, 'PATCH');
      expect(requests[2].url.path, '/api/rooms/room_1/members/usr_2');
      final permissionBody =
          jsonDecode(requests[2].body) as Map<String, dynamic>;
      expect(permissionBody, containsPair('userId', 'usr_2'));
      expect(
        permissionBody,
        containsPair(
          'role',
          common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
        ),
      );
      expect(permissionBody, containsPair('addedPermissions', '7'));
      expect(permissionBody, isNot(contains('roomId')));

      expect(requests[3].method, 'DELETE');
      expect(requests[3].url.path, '/api/rooms/room_1/playlists/pl_1');
      expect(requests[3].url.queryParameters, {'force': 'true'});
      expect(requests[3].body, isEmpty);

      expect(requests[4].method, 'POST');
      expect(requests[4].url.path, '/api/rooms/room_1/playback/stop');
      expect(jsonDecode(requests[4].body), <String, dynamic>{});
    },
  );

  test('room websocket uri uses ticket and json transport', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        expect(request.url.path, '/api/tickets');
        return http.Response(
          jsonEncode(<String, dynamic>{
            'ticket': 'ws_ticket',
            'expiresInSecs': '30',
          }),
          200,
        );
      }),
    );

    final ticket = await api.room.createWebSocketTicket(
      client.CreateWebSocketTicketRequest(),
    );
    final uri = api.roomWebSocketUri('room_1', ticket: ticket.ticket);

    expect(requests.single.method, 'POST');
    expect(uri.scheme, 'wss');
    expect(uri.path, '/ws/rooms/room_1');
    expect(uri.queryParameters, {'ticket': 'ws_ticket', 'format': 'json'});
  });

  test(
    'admin review endpoints use current protobuf query and body contracts',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          final path = request.url.path;
          if (path.endsWith('/user-registrations')) {
            return http.Response(
              jsonEncode({'reviews': [], 'total': 0}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (path.endsWith('/room-creations')) {
            return http.Response(
              jsonEncode({'reviews': [], 'total': 0}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          if (path.endsWith('/room-joins')) {
            return http.Response(
              jsonEncode({'reviews': [], 'total': 0}),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response(
            '{}',
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      await api.adminService.listUserRegistrationReviews(
        admin.ListUserRegistrationReviewsRequest(
          page: 2,
          pageSize: 30,
          status: common.ReviewStatus.REVIEW_STATUS_APPROVED,
          search: 'alice',
        ),
      );
      await api.adminService.approveUserRegistrationReview(
        admin.ApproveUserRegistrationReviewRequest(requestId: 'usr_1'),
      );
      await api.adminService.rejectUserRegistrationReview(
        admin.RejectUserRegistrationReviewRequest(
          requestId: 'usr_2',
          reason: 'duplicate',
        ),
      );
      await api.adminService.listRoomCreationReviews(
        admin.ListRoomCreationReviewsRequest(
          page: 3,
          pageSize: 25,
          status: common.ReviewStatus.REVIEW_STATUS_REJECTED,
          requestedBy: 'usr_3',
          search: 'movie night',
        ),
      );
      await api.adminService.approveRoomCreationReview(
        admin.ApproveRoomCreationReviewRequest(requestId: 'room_1'),
      );
      await api.adminService.rejectRoomCreationReview(
        admin.RejectRoomCreationReviewRequest(
          requestId: 'room_2',
          reason: 'policy',
        ),
      );
      await api.adminService.listRoomJoinReviews(
        admin.ListRoomJoinReviewsRequest(
          page: 4,
          pageSize: 20,
          status: common.ReviewStatus.REVIEW_STATUS_PENDING,
          roomId: 'room_3',
          userId: 'usr_4',
        ),
      );
      await api.adminService.approveRoomJoinReview(
        admin.ApproveRoomJoinReviewRequest(requestId: 'rev_1'),
      );
      await api.adminService.rejectRoomJoinReview(
        admin.RejectRoomJoinReviewRequest(requestId: 'rev_2', reason: 'full'),
      );

      expect(requests, hasLength(9));
      expect(requests[0].method, 'GET');
      expect(requests[0].url.path, '/api/admin/reviews/user-registrations');
      expect(requests[0].url.queryParameters, {
        'page': '2',
        'pageSize': '30',
        'status': '${common.ReviewStatus.REVIEW_STATUS_APPROVED.value}',
        'search': 'alice',
      });
      expect(
        requests[1].url.path,
        '/api/admin/reviews/user-registrations/approve',
      );
      expect(jsonDecode(requests[1].body), {'requestId': 'usr_1'});
      expect(
        requests[2].url.path,
        '/api/admin/reviews/user-registrations/reject',
      );
      expect(jsonDecode(requests[2].body), {
        'requestId': 'usr_2',
        'reason': 'duplicate',
      });

      expect(requests[3].url.path, '/api/admin/reviews/room-creations');
      expect(requests[3].url.queryParameters, {
        'page': '3',
        'pageSize': '25',
        'status': '${common.ReviewStatus.REVIEW_STATUS_REJECTED.value}',
        'requestedBy': 'usr_3',
        'search': 'movie night',
      });
      expect(requests[4].url.path, '/api/admin/reviews/room-creations/approve');
      expect(jsonDecode(requests[4].body), {'requestId': 'room_1'});
      expect(requests[5].url.path, '/api/admin/reviews/room-creations/reject');
      expect(jsonDecode(requests[5].body), {
        'requestId': 'room_2',
        'reason': 'policy',
      });

      expect(requests[6].url.path, '/api/admin/reviews/room-joins');
      expect(requests[6].url.queryParameters, {
        'page': '4',
        'pageSize': '20',
        'status': '${common.ReviewStatus.REVIEW_STATUS_PENDING.value}',
        'roomId': 'room_3',
        'userId': 'usr_4',
      });
      expect(requests[7].url.path, '/api/admin/reviews/room-joins/approve');
      expect(jsonDecode(requests[7].body), {'requestId': 'rev_1'});
      expect(requests[8].url.path, '/api/admin/reviews/room-joins/reject');
      expect(jsonDecode(requests[8].body), {
        'requestId': 'rev_2',
        'reason': 'full',
      });
    },
  );

  test('admin registration review maps OAuth2 protobuf details', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      expect(request.uri.path, '/api/admin/reviews/user-registrations');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'reviews': [
              {
                'id': 'usr_review_1',
                'username': 'alice',
                'email': 'alice@example.test',
                'signupMethod': 3,
                'status': common.ReviewStatus.REVIEW_STATUS_PENDING.value,
                'requestedAt': 1710000000,
                'oauth2Provider': 'oidc',
                'oauth2ProviderUserId': 'sub-123',
                'oauth2ProviderUsername': 'alice-oidc',
                'oauth2AvatarUrl': 'https://issuer.example.test/a.png',
                'oauth2ProviderInstanceName': 'logto-main',
                'oauth2ProviderIssuer': 'https://issuer.example.test',
              },
            ],
            'total': 1,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues(
        testActiveServerPreferences(
          baseUrl: 'http://${server.address.host}:${server.port}',
        ),
      );
      await SyncTvService.init();
      final page = await SyncTvService.adminListReviewsPage(
        kind: AdminReviewKind.userRegistration,
      );
      expect(page.total, 1);
      final review = page.reviews.single as AdminUserRegistrationReview;
      expect(review.signupMethod, admin.SignupMethod.SIGNUP_METHOD_OAUTH2);
      expect(review.oauth2Provider, 'oidc');
      expect(review.oauth2ProviderInstanceName, 'logto-main');
      expect(review.oauth2ProviderUserId, 'sub-123');
      expect(review.oauth2ProviderUsername, 'alice-oidc');
      expect(review.oauth2ProviderIssuer, 'https://issuer.example.test');
      expect(review.oauth2AvatarUrl, 'https://issuer.example.test/a.png');
      expect(review.details, contains('注册方式 OAuth2'));
      expect(review.details, contains('实例 logto-main'));
      expect(review.details, contains('Provider ID sub-123'));
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }
  });

  test('admin registration review maps Passkey protobuf details', () async {
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      expect(request.uri.path, '/api/admin/reviews/user-registrations');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'reviews': [
              {
                'id': 'usr_review_2',
                'username': 'bob',
                'email': '',
                'signupMethod': 5,
                'status': common.ReviewStatus.REVIEW_STATUS_PENDING.value,
                'requestedAt': 1710000300,
                'webauthnCredentialId': 'Y3JlZGVudGlhbC0x',
                'webauthnCredentialName': 'MacBook Touch ID',
              },
            ],
            'total': 1,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues(
        testActiveServerPreferences(
          baseUrl: 'http://${server.address.host}:${server.port}',
        ),
      );
      await SyncTvService.init();
      final page = await SyncTvService.adminListReviewsPage(
        kind: AdminReviewKind.userRegistration,
      );
      expect(page.total, 1);
      final review = page.reviews.single as AdminUserRegistrationReview;
      expect(review.signupMethod, admin.SignupMethod.SIGNUP_METHOD_WEBAUTHN);
      expect(review.webauthnCredentialId, 'Y3JlZGVudGlhbC0x');
      expect(review.webauthnCredentialName, 'MacBook Touch ID');
      expect(review.details, contains('注册方式 Passkey'));
      expect(review.details, contains('Passkey MacBook Touch ID'));
      expect(review.details, contains('Credential Y3JlZGVudGlhbC0x'));
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }
  });

  test('admin stream and ban list queries preserve protobuf filters', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/api/admin/streams') {
          return http.Response(
            jsonEncode({
              'streams': [
                {
                  'roomId': 'room_1',
                  'mediaId': 'med_1',
                  'userId': 'usr_1',
                  'nodeId': 'node_a',
                  'startedAt': '11',
                },
              ],
              'total': 6,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/admin/bans') {
          return http.Response(
            jsonEncode({
              'bans': [
                {
                  'id': 'ban_1',
                  'targetType': admin.BanTargetType.BAN_TARGET_TYPE_ROOM.value,
                  'roomId': 'room_1',
                  'room_name': 'Room 1',
                  'banned_by': 'usr_admin',
                  'banned_by_username': 'root',
                  'reason': 'policy',
                  'starts_at': '12',
                  'ends_at': '0',
                  'revoked_at': '0',
                  'revoked_by': '',
                  'is_active': true,
                },
              ],
              'total': 1,
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('not found', 404);
      }),
    );

    final streams = await api.adminService.listActiveStreams(
      admin.ListActiveStreamsRequest(
        page: 3,
        pageSize: 40,
        roomId: 'room_1',
        userId: 'usr_1',
        nodeId: 'node_a',
        search: 'feature',
        sortBy: admin_enum
            .ActiveStreamListSortBy
            .ACTIVE_STREAM_LIST_SORT_BY_NODE_ID,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_ASC,
      ),
    );
    final bans = await api.adminService.listBanRecords(
      admin.ListBanRecordsRequest(
        page: 2,
        pageSize: 25,
        targetType: admin.BanTargetType.BAN_TARGET_TYPE_ROOM,
        active: true,
        userId: 'usr_2',
        roomId: 'room_1',
      ),
    );

    expect(streams.streams.single.nodeId, 'node_a');
    expect(streams.total, 6);
    expect(bans.total, 1);
    expect(requests, hasLength(2));
    expect(requests[0].method, 'GET');
    expect(requests[0].url.path, '/api/admin/streams');
    expect(requests[0].url.queryParameters, {
      'page': '3',
      'pageSize': '40',
      'roomId': 'room_1',
      'userId': 'usr_1',
      'nodeId': 'node_a',
      'search': 'feature',
      'sortBy':
          '${admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_NODE_ID.value}',
      'sortDirection': '${admin_enum.SortDirection.SORT_DIRECTION_ASC.value}',
    });
    expect(requests[1].method, 'GET');
    expect(requests[1].url.path, '/api/admin/bans');
    expect(requests[1].url.queryParameters, {
      'page': '2',
      'pageSize': '25',
      'targetType': '${admin.BanTargetType.BAN_TARGET_TYPE_ROOM.value}',
      'active': 'true',
      'userId': 'usr_2',
      'roomId': 'room_1',
    });
  });

  test(
    'admin slice cache service maps stats and maintenance operations',
    () async {
      final requests = <http.Request>[];
      final nodeStats = {
        'nodeId': 'node_a',
        'config': {
          'engineEnabled': true,
          'backend': 'file',
          'fileCacheDir': '/var/cache/synctv',
          'sliceSize': '4194304',
          'maxCacheSize': '1073741824',
          'segmentTtlSecs': '600',
          'staleMaxAgeSecs': '120',
          'staleWhileRevalidate': true,
          'evictionIntervalSecs': '30',
          'watermarkRatio': 0.75,
        },
        'currentSizeBytes': '536870912',
        'entryCount': '18',
        'metadataEntries': '16',
        'updatingEntries': '1',
        'lockCount': '2',
        'usageRatio': 0.5,
      };
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          final response = switch (request.url.path) {
            '/api/admin/slice-cache' => {
              'nodes': [nodeStats],
              'failures': [
                {'nodeId': 'node_b', 'error': 'unreachable'},
              ],
            },
            '/api/admin/slice-cache/purge' => {
              'success': true,
              'removedEntries': '18',
              'freedBytes': '536870912',
              'stats': {
                ...nodeStats,
                'currentSizeBytes': '0',
                'entryCount': '0',
              },
            },
            '/api/admin/slice-cache/evict-expired' => {
              'success': false,
              'removedExpiredEntries': '4',
              'nodes': [
                {
                  'nodeId': 'node_a',
                  'success': true,
                  'removedExpiredEntries': '4',
                  'stats': nodeStats,
                },
              ],
              'failures': [
                {'nodeId': 'node_b', 'error': 'timeout'},
              ],
            },
            _ => throw StateError(
              'Unexpected slice cache path ${request.url.path}',
            ),
          };
          return http.Response(
            jsonEncode(response),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final service = SyncTvAdminDomainService(api);

      final stats = await service.getSliceCacheStats(allNodes: true);
      final purge = await service.purgeSliceCache(nodeId: 'node_a');
      final eviction = await service.evictExpiredSliceCache(allNodes: true);

      expect(stats.nodes.single.nodeId, 'node_a');
      expect(stats.nodes.single.currentSizeBytes, 536870912);
      expect(stats.nodes.single.config.maxCacheSize, 1073741824);
      expect(stats.nodes.single.config.staleWhileRevalidate, isTrue);
      expect(stats.failures.single.nodeId, 'node_b');
      expect(purge.success, isTrue);
      expect(purge.removedEntries, 18);
      expect(purge.freedBytes, 536870912);
      expect(purge.stats?.entryCount, 0);
      expect(eviction.success, isFalse);
      expect(eviction.removedEntries, 4);
      expect(eviction.nodes.single.removedEntries, 4);
      expect(eviction.failures.single.error, 'timeout');

      expect(requests.map((request) => request.method), [
        'GET',
        'POST',
        'POST',
      ]);
      expect(requests[0].url.queryParameters, {'allNodes': 'true'});
      expect(jsonDecode(requests[1].body), {
        'nodeId': 'node_a',
        'allNodes': false,
      });
      expect(jsonDecode(requests[2].body), {'nodeId': '', 'allNodes': true});
    },
  );

  test('admin active stream service preserves total for paging', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'streams': [
              {
                'roomId': 'room_1',
                'mediaId': 'med_1',
                'userId': 'usr_1',
                'nodeId': 'node_a',
                'startedAt': '1700000000',
              },
            ],
            'total': 3,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final page = await SyncTvService.adminListActiveStreamsPage(
        page: 2,
        pageSize: 20,
        roomId: 'room_1',
        userId: 'usr_1',
        nodeId: 'node_a',
        search: 'med_1',
        sortBy: admin_enum
            .ActiveStreamListSortBy
            .ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
        sortDirection: admin_enum.SortDirection.SORT_DIRECTION_DESC,
      );

      expect(page.total, 3);
      expect(page.streams.single.mediaId, 'med_1');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/admin/streams');
    expect(requestedUri!.queryParameters, {
      'page': '2',
      'pageSize': '20',
      'roomId': 'room_1',
      'userId': 'usr_1',
      'nodeId': 'node_a',
      'search': 'med_1',
      'sortBy':
          '${admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT.value}',
      'sortDirection': '${admin_enum.SortDirection.SORT_DIRECTION_DESC.value}',
    });
  });

  test('public settings response stays typed instead of map-shaped', () async {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'roomCreationEnabled': true,
            'maxRoomsPerUser': 8,
            'defaultMaxMembers': 64,
            'roomCreationApprovalRequired': true,
            'roomPasswordPolicy': 'ROOM_PASSWORD_POLICY_OPTIONAL',
            'enablePasswordSignup': true,
            'passwordSignupNeedReview': false,
            'enableEmailSignup': true,
            'enableEmail': true,
            'enableGuest': false,
            'emailSignupNeedReview': true,
            'enableWebauthn': true,
            'enableWebauthnSignup': true,
            'webauthnSignupNeedReview': false,
            'tsDisguisedAsPng': true,
            'customPublishHost': 'rtmp://publish.example.test/live',
            'emailWhitelistEnabled': true,
            'emailWhitelistDomains': ['example.com', 'corp.test'],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final settings = await api.publicService.getPublicSettings(
      client.GetPublicSettingsRequest(),
    );

    expect(settings.enableEmailSignup, isTrue);
    expect(settings.enableWebauthnSignup, isTrue);
    expect(settings.enableGuest, isFalse);
    expect(settings.maxRoomsPerUser.toInt(), 8);
    expect(
      settings.roomPasswordPolicy,
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL,
    );
    expect(settings.tsDisguisedAsPng, isTrue);
    expect(settings.customPublishHost, 'rtmp://publish.example.test/live');
    expect(settings.emailWhitelistEnabled, isTrue);
    expect(settings.enableEmail, isTrue);
    expect(settings.enableWebauthn, isTrue);
    expect(settings.emailWhitelistDomains, ['example.com', 'corp.test']);
  });

  test('public settings domain maps RTMP publishing options', () async {
    SharedPreferences.setMockInitialValues({});
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final requests = server.listen((request) async {
      expect(request.uri.path, '/api/public/settings');
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'roomCreationEnabled': true,
            'maxRoomsPerUser': 3,
            'defaultMaxMembers': 12,
            'roomCreationApprovalRequired': false,
            'roomPasswordPolicy': 'ROOM_PASSWORD_POLICY_OPTIONAL',
            'enablePasswordSignup': true,
            'passwordSignupNeedReview': false,
            'enableEmailSignup': true,
            'enableEmail': true,
            'enableGuest': true,
            'emailSignupNeedReview': false,
            'enableWebauthn': false,
            'enableWebauthnSignup': true,
            'webauthnSignupNeedReview': true,
            'tsDisguisedAsPng': true,
            'customPublishHost': 'rtmp://publish.example.test/app',
            'emailWhitelistEnabled': false,
            'emailWhitelistDomains': [],
          }),
        );
      await request.response.close();
    });

    try {
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      final settings = await SyncTvService.getPublicSettings();
      expect(settings.tsDisguisedAsPng, isTrue);
      expect(settings.customPublishHost, 'rtmp://publish.example.test/app');
      expect(settings.enableEmail, isTrue);
      expect(settings.enableWebauthn, isFalse);
    } finally {
      await requests.cancel();
      await server.close(force: true);
    }
  });

  test('public server info endpoint maps protobuf response', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({'serverId': 'srv_prod', 'serverName': 'SyncTV Prod'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.publicService.getServerInfo(
      client.GetServerInfoRequest(),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/public/server-info');
    expect(response.serverId, 'srv_prod');
    expect(response.serverName, 'SyncTV Prod');
  });

  test(
    'public server time endpoint maps protobuf query and response',
    () async {
      Uri? requestedUri;
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession(),
        httpClient: MockClient((request) async {
          requestedUri = request.url;
          return http.Response(
            jsonEncode({
              'clientSentAtNanos': '100',
              'serverReceivedAtNanos': '150',
              'serverSentAtNanos': '175',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.publicService.getServerTime(
        client.GetServerTimeRequest(clientSentAtNanos: Int64(100)),
      );

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/public/time');
      expect(requestedUri!.queryParameters, {'clientSentAtNanos': '100'});
      expect(response.clientSentAtNanos, Int64(100));
      expect(response.serverReceivedAtNanos, Int64(150));
      expect(response.serverSentAtNanos, Int64(175));
    },
  );

  test('public server info is exposed through SyncTV service domain', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response.headers.contentType = io.ContentType.json;
      request.response.write(
        jsonEncode({'serverId': 'srv_local', 'serverName': 'Local Dev'}),
      );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final info = await SyncTvService.getServerInfo(refresh: true);

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/public/server-info');
      expect(info.serverId, 'srv_local');
      expect(info.serverName, 'Local Dev');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('public server time is exposed through SyncTV service domain', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response.headers.contentType = io.ContentType.json;
      request.response.write(
        jsonEncode({
          'clientSentAtNanos': '200',
          'serverReceivedAtNanos': '250',
          'serverSentAtNanos': '275',
        }),
      );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );

      final time = await SyncTvService.getServerTime(clientSentAtNanos: 200);

      expect(requestedUri, isNotNull);
      expect(requestedUri!.path, '/api/public/time');
      expect(requestedUri!.queryParameters, {'clientSentAtNanos': '200'});
      expect(time.serverReceivedAtNanos, Int64(250));
      expect(time.serverSentAtNanos, Int64(275));
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('public room taxonomy endpoints map categories and labels', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requests.add(request);
        switch (request.url.path) {
          case '/api/rooms/categories':
            return http.Response(
              jsonEncode({
                'categories': [
                  {
                    'id': 'roomcat_anime',
                    'key': 'anime',
                    'name': 'Anime',
                    'description': 'Animation rooms',
                    'sortOrder': 10,
                    'isEnabled': true,
                  },
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          case '/api/rooms/labels':
            return http.Response(
              jsonEncode({
                'labels': [
                  {
                    'id': 'roomlbl_weekly',
                    'key': 'weekly',
                    'name': 'Weekly',
                    'description': 'Weekly sessions',
                    'color': '#3366ff',
                    'categoryId': 'roomcat_anime',
                    'sortOrder': 20,
                    'isEnabled': true,
                  },
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
        }
        return http.Response(
          'unexpected ${request.method} ${request.url}',
          404,
        );
      }),
    );
    final sessionStore = SyncTvSessionStore(api.session);
    final service = SyncTvPublicRoomDomainService(
      api: api,
      authService: SyncTvAuthDomainService(
        api: api,
        sessionStore: sessionStore,
      ),
    );

    final categories = await service.listRoomCategories(
      includeDisabled: true,
      refresh: true,
    );
    final labels = await service.listRoomLabels(
      categoryId: 'roomcat_anime',
      refresh: true,
    );

    expect(requests[0].url.path, '/api/rooms/categories');
    expect(requests[0].url.queryParameters, {'includeDisabled': 'true'});
    expect(categories.single.id, 'roomcat_anime');
    expect(categories.single.sortOrder, 10);

    expect(requests[1].url.path, '/api/rooms/labels');
    expect(requests[1].url.queryParameters, {
      'includeDisabled': 'false',
      'categoryId': 'roomcat_anime',
    });
    expect(labels.single.id, 'roomlbl_weekly');
    expect(labels.single.color, '#3366ff');
  });

  test(
    'room mapping preserves category and labels from protobuf response',
    () async {
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession(),
        httpClient: MockClient((request) async {
          return http.Response(
            jsonEncode({
              'room': {
                'id': 'room_tax',
                'name': 'Taxonomy Room',
                'createdBy': 'usr_owner',
                'status': 1,
                'category': {
                  'id': 'roomcat_anime',
                  'key': 'anime',
                  'name': 'Anime',
                  'sortOrder': 10,
                  'isEnabled': true,
                },
                'labels': [
                  {
                    'id': 'roomlbl_weekly',
                    'key': 'weekly',
                    'name': 'Weekly',
                    'color': '#3366ff',
                    'categoryId': 'roomcat_anime',
                    'sortOrder': 20,
                    'isEnabled': true,
                  },
                ],
              },
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final response = await api.user.getRoom(
        client.GetRoomRequest(roomId: 'room_tax'),
      );
      final room = api.mapRoom(response.room);

      expect(room.category?.id, 'roomcat_anime');
      expect(room.category?.name, 'Anime');
      expect(room.labels.single.id, 'roomlbl_weekly');
      expect(room.labels.single.categoryId, 'roomcat_anime');
    },
  );

  test('server profiles isolate addresses that declare the same id', () async {
    SharedPreferences.setMockInitialValues({});
    final session = SyncTvSession();
    final store = SyncTvSessionStore(session, builtInServerUrl: '');

    await store.load();
    await store.addOrUpdateServer(
      declaredServerId: 'srv_same',
      name: 'Main',
      endpoint: 'https://one.example.test',
    );
    await store.addOrUpdateServer(
      declaredServerId: 'srv_same',
      name: 'Main',
      endpoint: 'https://two.example.test/',
    );

    expect(store.servers, hasLength(2));
    expect(store.activeServerEndpoint, 'https://two.example.test');
    expect(
      store.servers.map((server) => server.endpoint),
      containsAll(['https://one.example.test', 'https://two.example.test']),
    );
    expect(store.servers.map((server) => server.declaredServerId).toSet(), {
      'srv_same',
    });
    expect(store.baseUrl, 'https://two.example.test');
  });

  test('server sessions are isolated when switching servers', () async {
    SharedPreferences.setMockInitialValues({});
    final session = SyncTvSession();
    final store = SyncTvSessionStore(session);

    await store.load();
    await store.addOrUpdateServer(
      declaredServerId: 'srv_a',
      name: 'A',
      endpoint: 'https://a.example.test',
    );
    session.updateAccountTokens(accessToken: 'token-a');
    session.updateAccountTokens(refreshToken: 'refresh-a');
    await store.persistSession();

    await store.addOrUpdateServer(
      declaredServerId: 'srv_b',
      name: 'B',
      endpoint: 'https://b.example.test',
    );
    expect(session.accessToken, isNull);
    session.updateAccountTokens(accessToken: 'token-b');
    await store.persistSession();

    await store.activateServer('https://a.example.test');
    expect(store.baseUrl, 'https://a.example.test');
    expect(session.accessToken, 'token-a');
    expect(session.refreshToken, 'refresh-a');

    await store.activateServer('https://b.example.test');
    expect(store.baseUrl, 'https://b.example.test');
    expect(session.accessToken, 'token-b');
    expect(session.refreshToken, isNull);
  });

  test('room invite links preserve normalized server endpoint and room id', () {
    final link = RoomInviteService.createInviteLink(
      room: SyncTvRoom(
        roomId: 'room_123',
        roomName: 'Room',
        creatorId: 'usr_1',
      ),
      serverEndpoint: 'HTTPS://Sync.Example:443/api/',
    );
    final parsed = RoomInviteService.parse(link);

    expect(Uri.parse(link).path, '/rooms/join');
    expect(parsed.roomId, 'room_123');
    expect(parsed.serverEndpoint, 'https://sync.example');
    expect(RoomInviteService.parse('room_plain').roomId, 'room_plain');
  });

  test(
    'create room sends visibility and defaults a missing response field to public',
    () async {
      http.Request? capturedRequest;
      const roomCredential = 'not-real-room-credential';
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'id': 'room_pending',
              'name': 'Review Room',
              'createdBy': 'usr_1',
              'status': common.RoomStatus.ROOM_STATUS_UNSPECIFIED.value,
              'settings': {'allowGuestJoin': true},
              'description': '',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final sessionStore = SyncTvSessionStore(api.session);
      final service = SyncTvPublicRoomDomainService(
        api: api,
        authService: SyncTvAuthDomainService(
          api: api,
          sessionStore: sessionStore,
        ),
      );

      final room = await service.createRoom(
        'Review Room',
        password: roomCredential,
        categoryId: 'roomcat_anime',
        labelIds: const ['roomlbl_weekly'],
        isPublic: false,
      );

      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.url.path, '/api/rooms');
      expect(jsonDecode(capturedRequest!.body), {
        'name': 'Review Room',
        'password': roomCredential,
        'categoryId': 'roomcat_anime',
        'labelIds': ['roomlbl_weekly'],
        'isPublic': false,
      });
      expect(room.roomId, 'room_pending');
      expect(room.status, common.RoomStatus.ROOM_STATUS_UNSPECIFIED);
      expect(room.isActive, isFalse);
      expect(room.joined, isTrue);
      expect(room.canJoin, isFalse);
      expect(
        room.discoveryAccess,
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_ENTER,
      );
      expect(
        room.myRelation,
        client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED,
      );
      expect(room.needPassword, isFalse);
      expect(room.isPublic, isTrue);
    },
  );

  test('room discovery maps live presence and member counts', () async {
    Uri? requestedUri;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedUri = request.uri;
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'rooms': [
              {
                'room': {
                  'id': 'room_hot',
                  'name': 'Hot Room',
                  'createdBy': 'usr_owner',
                  'status': 1,
                  'memberCount': 12,
                  'presence': {
                    'onlineMemberCount': 5,
                    'onlineGuestCount': 2,
                    'connectionCount': 8,
                  },
                },
                'canJoin': true,
                'access': client_enum
                    .RoomDiscoveryAccess
                    .ROOM_DISCOVERY_ACCESS_GUEST
                    .value,
              },
            ],
          }),
        );
      await request.response.close();
    });

    late final RoomDiscoveryPage discovery;
    try {
      SharedPreferences.setMockInitialValues({});
      await SyncTvService.init();
      await SyncTvService.setBaseUrl(
        'http://${server.address.host}:${server.port}',
      );
      discovery = await SyncTvService.discoverRooms(pageSize: 8);
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/rooms/discover');
    expect(requestedUri!.queryParameters, {'page': '1', 'pageSize': '8'});
    expect(discovery.rooms.single.roomId, 'room_hot');
    expect(discovery.rooms.single.onlineMemberCount, 5);
    expect(discovery.rooms.single.onlineGuestCount, 2);
    expect(discovery.rooms.single.memberCount, 12);
    expect(discovery.rooms.single.joined, isFalse);
    expect(discovery.rooms.single.isFavorite, isFalse);
    expect(
      discovery.rooms.single.discoveryAccess,
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST,
    );
  });

  test('room discovery endpoint maps viewer access details', () async {
    Uri? requestedUri;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'user-token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_private',
              'name': 'Private Room',
              'createdBy': 'usr_owner',
              'availability': 1,
            },
            'canJoin': true,
            'access': client_enum
                .RoomDiscoveryAccess
                .ROOM_DISCOVERY_ACCESS_PASSWORD
                .value,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.getRoomDiscovery(
      client.GetRoomDiscoveryRequest(roomId: 'room_private'),
    );

    expect(requestedUri, isNotNull);
    expect(requestedUri!.path, '/api/user/rooms/room_private/discovery');
    expect(response.room.name, 'Private Room');
    expect(response.canJoin, isTrue);
    expect(
      response.access,
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_PASSWORD,
    );
  });

  test('signed-in room discovery uses the authenticated endpoint', () async {
    Uri? requestedUri;
    String? authorization;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'user-token'),
      httpClient: MockClient((request) async {
        requestedUri = request.url;
        authorization = request.headers['authorization'];
        return http.Response(
          jsonEncode({
            'rooms': [
              {
                'room': {
                  'id': 'room_joined',
                  'name': 'Joined Room',
                  'createdBy': 'usr_owner',
                  'availability': 1,
                },
                'joined': true,
                'favorited': true,
                'canJoin': false,
                'access': client_enum
                    .RoomDiscoveryAccess
                    .ROOM_DISCOVERY_ACCESS_ENTER
                    .value,
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.discoverRooms(
      client.DiscoverRoomsRequest(page: 1, pageSize: 24),
    );

    expect(requestedUri!.path, '/api/user/rooms/discover');
    expect(requestedUri!.queryParameters, {'page': '1', 'pageSize': '24'});
    expect(authorization, 'Bearer user-token');
    expect(response.rooms.single.joined, isTrue);
    expect(response.rooms.single.favorited, isTrue);
  });

  test('guest room tokens are omitted from discovery requests', () async {
    final requests = <({String path, String? authorization})>[];
    final session = SyncTvSession()
      ..activateGuest(
        accessToken: 'guest-room-token',
        roomId: 'room_guest',
        displayName: 'Guest',
      );
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requests.add((
          path: request.url.path,
          authorization: request.headers['authorization'],
        ));
        if (request.url.path == '/api/rooms/discover') {
          return http.Response(
            jsonEncode({'rooms': <Object>[], 'featuredRooms': <Object>[]}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response(
          jsonEncode({
            'room': {
              'id': 'room_guest',
              'name': 'Guest Room',
              'createdBy': 'usr_owner',
              'availability': 1,
            },
            'canJoin': true,
            'access': client_enum
                .RoomDiscoveryAccess
                .ROOM_DISCOVERY_ACCESS_GUEST
                .value,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    await api.publicService.discoverRooms(client.DiscoverRoomsRequest());
    await api.publicService.getRoomDiscovery(
      client.GetRoomDiscoveryRequest(roomId: 'room_guest'),
    );

    expect(requests.map((request) => request.path), [
      '/api/rooms/discover',
      '/api/rooms/room_guest/discovery',
    ]);
    expect(requests.every((request) => request.authorization == null), isTrue);
  });

  test('refresh-only session restores authenticated room discovery', () async {
    final requestedPaths = <String>[];
    String? discoveryAuthorization;
    final server = await io.HttpServer.bind(io.InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((request) async {
      requestedPaths.add(request.uri.path);
      request.response.headers.contentType = io.ContentType.json;
      if (request.uri.path == '/api/auth/refresh') {
        request.response.write(
          jsonEncode({
            'accessToken': 'fresh-access',
            'refreshToken': 'fresh-refresh',
          }),
        );
      } else if (request.uri.path == '/api/user/rooms/discover') {
        discoveryAuthorization = request.headers.value('authorization');
        request.response.write(
          jsonEncode({'rooms': <Object>[], 'featuredRooms': <Object>[]}),
        );
      } else {
        request.response.statusCode = 404;
        request.response.write(jsonEncode({'message': 'not found'}));
      }
      await request.response.close();
    });

    try {
      final baseUrl = 'http://${server.address.host}:${server.port}';
      SharedPreferences.setMockInitialValues(
        testActiveServerPreferences(
          baseUrl: baseUrl,
          accessToken: '',
          refreshToken: 'refresh-only-token',
        ),
      );
      await SyncTvService.init();

      await SyncTvService.discoverRooms(pageSize: 8);

      expect(requestedPaths, ['/api/auth/refresh', '/api/user/rooms/discover']);
      expect(discoveryAuthorization, 'Bearer fresh-access');
    } finally {
      await subscription.cancel();
      await server.close(force: true);
    }
  });

  test('room discovery maps pending approval as non-joinable', () async {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'user-token'),
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'room': {
              'id': 'room_pending',
              'name': 'Pending Room',
              'createdBy': 'usr_owner',
              'availability': 1,
            },
            'canJoin': false,
            'access': client_enum
                .RoomDiscoveryAccess
                .ROOM_DISCOVERY_ACCESS_PENDING_APPROVAL
                .value,
          }),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );

    final response = await api.user.getRoomDiscovery(
      client.GetRoomDiscoveryRequest(roomId: 'room_pending'),
    );
    final room = api.mapRoomDiscoveryItem(response);

    expect(room.canJoin, isFalse);
    expect(
      room.discoveryAccess,
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_PENDING_APPROVAL,
    );
  });

  test('SyncTV service preserves room discovery state', () async {
    http.Request? capturedRequest;
    final server = await io.HttpServer.bind('127.0.0.1', 0);
    final listener = server.listen((request) async {
      capturedRequest = http.Request(request.method, request.uri);
      request.response
        ..statusCode = 200
        ..headers.contentType = io.ContentType.json
        ..write(
          jsonEncode({
            'room': {
              'id': 'room_lobby',
              'name': 'Lobby',
              'createdBy': 'usr_owner',
              'availability': 1,
            },
            'joined': true,
            'favorited': true,
            'access': client_enum
                .RoomDiscoveryAccess
                .ROOM_DISCOVERY_ACCESS_ENTER
                .value,
          }),
        );
      await request.response.close();
    });

    try {
      SharedPreferences.setMockInitialValues(
        testActiveServerPreferences(
          baseUrl: 'http://${server.address.host}:${server.port}',
        ),
      );
      await SyncTvService.init();

      final room = await SyncTvService.getRoomDiscovery('room_lobby');

      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.url.path, '/api/user/rooms/room_lobby/discovery');
      expect(room.roomName, 'Lobby');
      expect(room.joined, isTrue);
      expect(room.isFavorite, isTrue);
      expect(
        room.discoveryAccess,
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_ENTER,
      );
    } finally {
      await listener.cancel();
      await server.close(force: true);
    }
  });

  test('email login confirmation uses dedicated protobuf contract', () async {
    http.Request? capturedRequest;
    const emailLoginToken = 'not-real-email-login-token';
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'email': 'alice@example.test',
            },
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.auth.confirmEmailLogin(
      client.ConfirmEmailLoginRequest(
        loginSessionId: 'login-session',
        emailToken: emailLoginToken,
      ),
    );

    expect(response.user.email, 'alice@example.test');
    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.url.path, '/api/auth/email/confirm');
    expect(jsonDecode(capturedRequest!.body), {
      'loginSessionId': 'login-session',
      'emailToken': emailLoginToken,
    });
    expect(session.accessToken, 'access-token');
    expect(session.refreshToken, 'refresh-token');
  });

  test(
    'direct password and email registration use protobuf auth contracts',
    () async {
      final requests = <http.Request>[];
      final session = SyncTvSession();
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: session,
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/auth/direct-password/register':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_register',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'register-access',
                  'refreshToken': 'register-refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/direct-password/login':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_login',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'login-access',
                  'refreshToken': 'login-refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/email/registration/request':
              return http.Response(
                jsonEncode({'message': 'sent'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/email/registration/confirm':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_email',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'email-access',
                  'refreshToken': 'email-refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );

      await api.auth.registerWithDirectPassword(
        client.RegisterWithDirectPasswordRequest(
          username: 'alice',
          email: 'alice@example.test',
          password: 'plain-password',
        ),
      );
      await api.auth.loginWithDirectPassword(
        client.LoginWithDirectPasswordRequest(
          loginSessionId: 'login-session',
          password: 'plain-password',
        ),
      );
      await api.auth.requestEmailRegistration(
        client.RequestEmailRegistrationRequest(
          username: 'alice',
          email: 'alice@example.test',
        ),
      );
      await api.auth.confirmEmailRegistration(
        client.ConfirmEmailRegistrationRequest(
          emailToken: 'email-register-token',
          password: 'plain-password',
        ),
      );

      expect(requests.map((request) => request.url.path), [
        '/api/auth/direct-password/register',
        '/api/auth/direct-password/login',
        '/api/auth/email/registration/request',
        '/api/auth/email/registration/confirm',
      ]);
      expect(jsonDecode(requests[0].body), {
        'username': 'alice',
        'email': 'alice@example.test',
        'password': 'plain-password',
      });
      expect(jsonDecode(requests[1].body), {
        'loginSessionId': 'login-session',
        'password': 'plain-password',
      });
      expect(jsonDecode(requests[2].body), {
        'username': 'alice',
        'email': 'alice@example.test',
      });
      expect(jsonDecode(requests[3].body), {
        'emailToken': 'email-register-token',
        'password': 'plain-password',
      });
      expect(session.accessToken, 'email-access');
      expect(session.refreshToken, 'email-refresh');
    },
  );

  test(
    'admin taxonomy endpoints use current protobuf routes and bodies',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/admin/rooms/categories':
              if (request.method == 'GET') {
                return http.Response(
                  jsonEncode({
                    'categories': [
                      {
                        'id': 'roomcat_anime',
                        'key': 'anime',
                        'name': 'Anime',
                        'sortOrder': 10,
                        'isEnabled': true,
                      },
                    ],
                  }),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              }
              return http.Response(
                jsonEncode({
                  'id': 'roomcat_anime',
                  'key': 'anime',
                  'name': 'Anime',
                  'description': 'Animation rooms',
                  'sortOrder': 10,
                  'isEnabled': true,
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/admin/rooms/categories/roomcat_anime':
              return http.Response(
                jsonEncode({'success': true}),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/admin/rooms/labels':
              if (request.method == 'GET') {
                return http.Response(
                  jsonEncode({
                    'labels': [
                      {
                        'id': 'roomlbl_weekly',
                        'key': 'weekly',
                        'name': 'Weekly',
                        'color': '#3366ff',
                        'categoryId': 'roomcat_anime',
                        'sortOrder': 20,
                        'isEnabled': true,
                      },
                    ],
                  }),
                  200,
                  headers: {'content-type': 'application/json'},
                );
              }
              return http.Response(
                jsonEncode({
                  'id': 'roomlbl_weekly',
                  'key': 'weekly',
                  'name': 'Weekly',
                  'description': 'Weekly sessions',
                  'color': '#3366ff',
                  'categoryId': 'roomcat_anime',
                  'sortOrder': 20,
                  'isEnabled': true,
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/admin/rooms/labels/roomlbl_weekly':
              return http.Response(
                jsonEncode({'success': true}),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/admin/rooms/room_tax/taxonomy':
              return http.Response(
                jsonEncode({
                  'id': 'room_tax',
                  'name': 'Taxonomy Room',
                  'createdBy': 'usr_owner',
                  'status': 1,
                  'category': {
                    'id': 'roomcat_anime',
                    'key': 'anime',
                    'name': 'Anime',
                    'sortOrder': 10,
                    'isEnabled': true,
                  },
                  'labels': [
                    {
                      'id': 'roomlbl_weekly',
                      'key': 'weekly',
                      'name': 'Weekly',
                      'color': '#3366ff',
                      'categoryId': 'roomcat_anime',
                      'sortOrder': 20,
                      'isEnabled': true,
                    },
                  ],
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response(
            'unexpected ${request.method} ${request.url}',
            404,
          );
        }),
      );
      final service = SyncTvAdminDomainService(api);

      final categories = await service.listRoomCategories(
        includeDisabled: true,
        refresh: true,
      );
      final category = await service.upsertRoomCategory(
        key: 'anime',
        name: 'Anime',
        description: 'Animation rooms',
        sortOrder: 10,
        isEnabled: true,
      );
      await service.deleteRoomCategory('roomcat_anime');
      final labels = await service.listRoomLabels(
        includeDisabled: true,
        categoryId: 'roomcat_anime',
        refresh: true,
      );
      final label = await service.upsertRoomLabel(
        key: 'weekly',
        name: 'Weekly',
        description: 'Weekly sessions',
        color: '#3366ff',
        categoryId: 'roomcat_anime',
        sortOrder: 20,
        isEnabled: true,
      );
      await service.deleteRoomLabel('roomlbl_weekly');
      final room = await service.updateRoomTaxonomy(
        'room_tax',
        categoryId: 'roomcat_anime',
        labelIds: const ['roomlbl_weekly'],
      );

      expect(
        requests.map((request) => '${request.method} ${request.url.path}'),
        [
          'GET /api/admin/rooms/categories',
          'POST /api/admin/rooms/categories',
          'DELETE /api/admin/rooms/categories/roomcat_anime',
          'GET /api/admin/rooms/labels',
          'POST /api/admin/rooms/labels',
          'DELETE /api/admin/rooms/labels/roomlbl_weekly',
          'PATCH /api/admin/rooms/room_tax/taxonomy',
        ],
      );
      expect(requests[0].url.queryParameters, {'includeDisabled': 'true'});
      expect(categories.single.id, 'roomcat_anime');
      expect(jsonDecode(requests[1].body), {
        'key': 'anime',
        'name': 'Anime',
        'description': 'Animation rooms',
        'sortOrder': 10,
        'isEnabled': true,
      });
      expect(category.id, 'roomcat_anime');
      expect(requests[3].url.queryParameters, {
        'includeDisabled': 'true',
        'categoryId': 'roomcat_anime',
      });
      expect(labels.single.id, 'roomlbl_weekly');
      expect(jsonDecode(requests[4].body), {
        'key': 'weekly',
        'name': 'Weekly',
        'description': 'Weekly sessions',
        'color': '#3366ff',
        'categoryId': 'roomcat_anime',
        'sortOrder': 20,
        'isEnabled': true,
      });
      expect(label.id, 'roomlbl_weekly');
      expect(jsonDecode(requests[6].body), {
        'roomId': 'room_tax',
        'categoryId': 'roomcat_anime',
        'labelIds': ['roomlbl_weekly'],
        'clearCategory': false,
      });
      expect(room.category?.id, 'roomcat_anime');
      expect(room.labels.single.id, 'roomlbl_weekly');
    },
  );

  test('login discovery is server-driven and preserves method order', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'loginSessionId': 'login-session',
            'availableMethods': [
              'LOGIN_METHOD_PASSKEY',
              'LOGIN_METHOD_PASSWORD',
              'LOGIN_METHOD_EMAIL_CODE',
            ],
            'expiresAt': '2000000000',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: SyncTvSessionStore(SyncTvSession()),
    );

    final login = await service.startLogin('alice@example.test');

    expect(requests.single.url.path, '/api/auth/login/start');
    expect(jsonDecode(requests.single.body), {'email': 'alice@example.test'});
    expect(login.sessionId, 'login-session');
    expect(login.supportsPasskey, isTrue);
    expect(login.supportsPassword, isTrue);
    expect(login.supportsEmailCode, isTrue);
    expect(
      login.expiresAt,
      DateTime.fromMillisecondsSinceEpoch(2000000000000, isUtc: true),
    );
  });

  test('Passkey option mapping preserves WebAuthn hints and extensions', () {
    final creation = passkey.PasskeyCreationChallenge(
      publicKey: passkey.PasskeyPublicKeyCredentialCreationOptions(
        rp: passkey.PasskeyRelyingParty(id: 'example.test', name: 'SyncTV'),
        user: passkey.PasskeyUserEntity(
          id: utf8.encode('user-1'),
          name: 'alice',
          displayName: 'Alice',
        ),
        challenge: utf8.encode('register-challenge'),
        pubKeyCredParams: [
          passkey.PasskeyPubKeyCredentialParam(
            type: passkey_enum
                .PasskeyPublicKeyCredentialType
                .PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY,
            alg: Int64(-7),
          ),
        ],
        hints: [
          passkey_enum
              .PasskeyPublicKeyCredentialHint
              .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_CLIENT_DEVICE,
          passkey_enum
              .PasskeyPublicKeyCredentialHint
              .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_SECURITY_KEY,
        ],
        attestation: passkey_enum
            .PasskeyAttestationConveyancePreference
            .PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_DIRECT,
        attestationFormats: [
          passkey_enum
              .PasskeyAttestationFormat
              .PASSKEY_ATTESTATION_FORMAT_PACKED,
          passkey_enum
              .PasskeyAttestationFormat
              .PASSKEY_ATTESTATION_FORMAT_APPLE,
        ],
        extensions: passkey.PasskeyRegistrationExtensionsInput(
          credProtect: passkey.PasskeyCredProtectInput(
            credentialProtectionPolicy: passkey_enum
                .PasskeyCredentialProtectionPolicy
                .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED,
            enforceCredentialProtectionPolicy: false,
          ),
          uvm: true,
          credProps: true,
          minPinLength: true,
          hmacCreateSecret: true,
        ),
      ),
    );
    final authentication = passkey.PasskeyRequestChallenge(
      mediation: passkey_enum
          .PasskeyMediationRequirement
          .PASSKEY_MEDIATION_REQUIREMENT_CONDITIONAL,
      publicKey: passkey.PasskeyPublicKeyCredentialRequestOptions(
        challenge: utf8.encode('login-challenge'),
        rpId: 'example.test',
        userVerification: passkey_enum
            .PasskeyUserVerificationRequirement
            .PASSKEY_USER_VERIFICATION_REQUIREMENT_REQUIRED,
        hints: [
          passkey_enum
              .PasskeyPublicKeyCredentialHint
              .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_HYBRID,
        ],
        extensions: passkey.PasskeyAuthenticationExtensionsInput(
          appid: 'https://example.test/app-id.json',
          uvm: true,
          hmacGetSecret: passkey.PasskeyHmacGetSecretInput(
            output1: utf8.encode('salt-1'),
            output2: utf8.encode('salt-2'),
          ),
        ),
      ),
    );

    expect(passkeyChallengeToJson(creation), {
      'rp': {'id': 'example.test', 'name': 'SyncTV'},
      'user': {
        'id': testBytesBase64Url('user-1'),
        'name': 'alice',
        'displayName': 'Alice',
      },
      'challenge': testBytesBase64Url('register-challenge'),
      'pubKeyCredParams': [
        {'type': 'public-key', 'alg': -7},
      ],
      'hints': ['client-device', 'security-key'],
      'attestation': 'direct',
      'attestationFormats': ['packed', 'apple'],
      'extensions': {
        'credProtect': {
          'credentialProtectionPolicy': 'userVerificationRequired',
          'enforceCredentialProtectionPolicy': false,
        },
        'uvm': true,
        'credProps': true,
        'minPinLength': true,
        'hmacCreateSecret': true,
      },
    });
    expect(passkeyChallengeToJson(authentication), {
      'challenge': testBytesBase64Url('login-challenge'),
      'rpId': 'example.test',
      'userVerification': 'required',
      'hints': ['hybrid'],
      'extensions': {
        'appid': 'https://example.test/app-id.json',
        'uvm': true,
        'hmacGetSecret': {
          'output1': testBytesBase64Url('salt-1'),
          'output2': testBytesBase64Url('salt-2'),
        },
      },
      'mediation': 'conditional',
    });
  });

  test('Passkey credential mapping preserves extension results', () {
    final registration = passkeyRegistrationCredentialFromJson({
      'id': 'registration-id',
      'rawId': testBytesBase64Url('registration-id'),
      'type': 'public-key',
      'response': {
        'attestationObject': testBytesBase64Url('attestation'),
        'clientDataJSON': testBytesBase64Url('{}'),
        'transports': ['internal'],
      },
      'clientExtensionResults': {
        'appid': false,
        'credProps': {'rk': true},
        'hmacSecret': true,
        'credProtect': 'userVerificationRequired',
        'minPinLength': 6,
      },
    });
    final authentication = passkeyAuthenticationCredentialFromJson({
      'id': 'authentication-id',
      'rawId': testBytesBase64Url('authentication-id'),
      'type': 'public-key',
      'response': {
        'authenticatorData': testBytesBase64Url('authenticator-data'),
        'clientDataJSON': testBytesBase64Url('{}'),
        'signature': testBytesBase64Url('signature'),
      },
      'clientExtensionResults': {
        'appid': true,
        'hmacGetSecret': {
          'output1': testBytesBase64Url('secret-1'),
          'output2': testBytesBase64Url('secret-2'),
        },
      },
    });

    expect(registration.hasExtensions(), isTrue);
    expect(registration.extensions.appid, isFalse);
    expect(registration.extensions.credProps.rk, isTrue);
    expect(registration.extensions.hmacSecret, isTrue);
    expect(
      registration.extensions.credProtect,
      passkey_enum
          .PasskeyCredentialProtectionPolicy
          .PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED,
    );
    expect(registration.extensions.minPinLength, 6);
    expect(authentication.hasExtensions(), isTrue);
    expect(authentication.extensions.appid, isTrue);
    expect(
      authentication.extensions.hmacGetSecret.output1,
      utf8.encode('secret-1'),
    );
    expect(
      authentication.extensions.hmacGetSecret.output2,
      utf8.encode('secret-2'),
    );
  });

  test('Passkey registration accepts an omitted transport list', () {
    final credential = passkeyRegistrationCredentialFromJson({
      'id': 'registration-id',
      'rawId': testBytesBase64Url('registration-id'),
      'type': 'public-key',
      'response': {
        'attestationObject': testBytesBase64Url('attestation'),
        'clientDataJSON': testBytesBase64Url('{}'),
      },
      'clientExtensionResults': <String, dynamic>{},
    });

    expect(credential.response.transports, isEmpty);
  });

  test('direct password domain sends the selected login session', () async {
    SharedPreferences.setMockInitialValues({});
    final requests = <http.Request>[];
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'user': {
              'id': 'usr_1',
              'username': 'alice',
              'email': 'alice@example.test',
            },
            'accessToken': 'access',
            'refreshToken': 'refresh',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: SyncTvSessionStore(session),
    );

    await service.loginWithDirectPassword(
      loginSessionId: 'login-session-1',
      password: 'plain-password',
    );
    await service.loginWithDirectPassword(
      loginSessionId: 'login-session-2',
      password: 'plain-password',
    );

    expect(requests.map((request) => jsonDecode(request.body)), [
      {'loginSessionId': 'login-session-1', 'password': 'plain-password'},
      {'loginSessionId': 'login-session-2', 'password': 'plain-password'},
    ]);
    expect(session.accessToken, 'access');
    expect(session.refreshToken, 'refresh');
  });

  test('MFA challenge preserves methods and UTC expiry', () async {
    final session = SyncTvSession();
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: session,
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'mfa': {
              'required': true,
              'sessionId': 'mfa-session',
              'availableMethods': [
                'MFA_METHOD_TOTP',
                'MFA_METHOD_RECOVERY_CODE',
              ],
              'maskedEmail': 'a***@example.test',
              'expiresAt': '2000000300',
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: SyncTvSessionStore(session),
    );

    final result = await service.loginWithDirectPassword(
      loginSessionId: 'login-session',
      password: 'plain-password',
    );

    expect(result, isA<MfaRequired>());
    final challenge = (result as MfaRequired).challenge;
    expect(challenge.supportsTotp, isTrue);
    expect(challenge.supportsRecoveryCode, isTrue);
    expect(challenge.supportsPasskey, isFalse);
    expect(challenge.maskedEmail, 'a***@example.test');
    expect(
      challenge.expiresAt,
      DateTime.fromMillisecondsSinceEpoch(2000000300000, isUtc: true),
    );
    expect(session.accessToken, isNull);
    expect(session.refreshToken, isNull);
  });

  test(
    'passkey endpoints translate WebAuthn JSON through protobuf bytes',
    () async {
      final requests = <http.Request>[];
      final session = SyncTvSession()
        ..updateAccountTokens(accessToken: 'access');
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: session,
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/auth/passkeys/login/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'login_passkey_session',
                  'options': testPasskeyRequestOptions(
                    challenge: 'login-challenge',
                    rpId: 'example.test',
                  ),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/passkeys/login/finish':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_1',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'new-access',
                  'refreshToken': 'new-refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/mfa/passkeys/start':
              return http.Response(
                jsonEncode({
                  'passkeySessionId': 'mfa_passkey_session',
                  'options': testPasskeyRequestOptions(
                    challenge: 'mfa-challenge',
                    allowCredentials: [
                      {'id': testBytesJson('cred-1'), 'type': 1},
                    ],
                  ),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/mfa/passkeys/finish':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_1',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'mfa-access',
                  'refreshToken': 'mfa-refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/user/passkeys/bind/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'bind_session',
                  'options': testPasskeyCreationOptions(
                    challenge: 'bind-challenge',
                    userId: 'usr_1',
                    username: 'alice',
                  ),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/user/passkeys/bind/finish':
              return http.Response(
                jsonEncode({
                  'credential': {
                    'credentialId': 'cred_1',
                    'name': 'MacBook Touch ID',
                    'signCount': '1',
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );

      final loginStart = await api.auth.startPasskeyLogin(
        client.StartPasskeyLoginRequest(loginSessionId: 'login-context'),
      );
      await api.auth.finishPasskeyLogin(
        client.FinishPasskeyLoginRequest(
          sessionId: loginStart.sessionId,
          credential: testPasskeyAuthenticationCredential('cred-login'),
        ),
      );
      final mfaStart = await api.auth.startMfaPasskey(
        client.StartMfaPasskeyRequest(mfaSessionId: 'mfa_session'),
      );
      await api.auth.finishMfaPasskey(
        client.FinishMfaPasskeyRequest(
          mfaSessionId: 'mfa_session',
          passkeySessionId: mfaStart.passkeySessionId,
          credential: testPasskeyAuthenticationCredential('cred-mfa'),
        ),
      );
      final bindStart = await api.user.startPasskeyBind(
        client.StartPasskeyBindRequest(name: 'MacBook Touch ID'),
      );
      await api.user.finishPasskeyBind(
        client.FinishPasskeyBindRequest(
          sessionId: bindStart.sessionId,
          credential: testPasskeyRegistrationCredential('cred-bind'),
        ),
      );

      expect(passkeyChallengeToJson(loginStart.options), {
        'challenge': testBytesBase64Url('login-challenge'),
        'rpId': 'example.test',
      });
      expect(passkeyChallengeToJson(mfaStart.options), {
        'challenge': testBytesBase64Url('mfa-challenge'),
        'rpId': '',
        'allowCredentials': [
          {
            'id': testBytesBase64Url('cred-1'),
            'type': 'public-key',
            'transports': <String>[],
          },
        ],
      });
      expect(passkeyChallengeToJson(bindStart.options), {
        'rp': {'id': '', 'name': ''},
        'user': {
          'id': testBytesBase64Url('usr_1'),
          'name': 'alice',
          'displayName': '',
        },
        'challenge': testBytesBase64Url('bind-challenge'),
        'pubKeyCredParams': <Map<String, dynamic>>[],
      });
      expect(session.accessToken, 'mfa-access');
      expect(session.refreshToken, 'mfa-refresh');

      final bodies = requests
          .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
          .toList();
      expect(bodies[0], {'loginSessionId': 'login-context'});
      expect(bodies[1], {
        'sessionId': 'login_passkey_session',
        'credential': {
          'id': 'cred-login',
          'rawId': testBytesJson('cred-login'),
          'response': {
            'authenticatorData': testBytesJson('auth-data'),
            'clientDataJSON': testBytesJson('{}'),
            'signature': testBytesJson('sig'),
            'userHandle': testBytesJson('usr_1'),
          },
          'type': 1,
        },
      });
      expect(bodies[2], {'mfaSessionId': 'mfa_session'});
      expect(bodies[3], {
        'mfaSessionId': 'mfa_session',
        'passkeySessionId': 'mfa_passkey_session',
        'credential': {
          'id': 'cred-mfa',
          'rawId': testBytesJson('cred-mfa'),
          'response': {
            'authenticatorData': testBytesJson('auth-data'),
            'clientDataJSON': testBytesJson('{}'),
            'signature': testBytesJson('sig'),
            'userHandle': testBytesJson('usr_1'),
          },
          'type': 1,
        },
      });
      expect(bodies[4], {'name': 'MacBook Touch ID'});
      expect(bodies[5], {
        'sessionId': 'bind_session',
        'credential': {
          'id': 'cred-bind',
          'rawId': testBytesJson('cred-bind'),
          'response': {
            'attestationObject': testBytesJson('attestation'),
            'clientDataJSON': testBytesJson('{}'),
            'transports': [4],
          },
          'type': 1,
        },
      });
    },
  );

  test(
    'sensitive operation verification endpoints use protobuf payloads',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'access'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/user/sensitive-verification/start':
              return http.Response(
                jsonEncode({
                  'challenge': {
                    'sessionId': 'sensitive_session',
                    'requiredCount': 2,
                    'requiredMethods': [
                      'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN',
                    ],
                    'completedMethods': [],
                    'availableMethods': [
                      'SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD',
                      'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN',
                      'SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL',
                    ],
                    'expiresAt': '2000000000',
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/user/sensitive-verification/passkey/start':
              return http.Response(
                jsonEncode({
                  'passkeySessionId': 'passkey_session',
                  'options': testPasskeyRequestOptions(
                    challenge: 'sensitive-passkey',
                  ),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/user/sensitive-verification/email/request':
              return http.Response(
                jsonEncode({
                  'message': 'sent',
                  'maskedEmail': 'a***@example.test',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/user/sensitive-verification/finish':
              return http.Response(
                jsonEncode({'verificationId': 'verification_1'}),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );
      final service = SyncTvAuthDomainService(
        api: api,
        sessionStore: SyncTvSessionStore(api.session),
      );

      final start = await service.startSensitiveOperationVerification();
      expect(start, isA<SensitiveOperationVerificationPending>());
      final startChallenge =
          (start as SensitiveOperationVerificationPending).challenge;
      final passkey = await service.startSensitiveOperationPasskey(
        startChallenge.sessionId,
      );
      final emailCode = await service.requestSensitiveOperationEmailCode(
        startChallenge.sessionId,
      );
      final finish = await service.finishSensitiveOperationVerification(
        sessionId: startChallenge.sessionId,
        method: client
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
        passkeySessionId: passkey.passkeySessionId,
        passkeyCredential: {
          'id': 'cred-sensitive',
          'rawId': testBytesBase64Url('cred-sensitive'),
          'type': 'public-key',
          'response': {
            'authenticatorData': testBytesBase64Url('auth-data'),
            'clientDataJSON': testBytesBase64Url('{}'),
            'signature': testBytesBase64Url('sig'),
            'userHandle': testBytesBase64Url('usr_1'),
          },
          'clientExtensionResults': <String, dynamic>{},
        },
      );

      expect(startChallenge.requiresPasskey, isTrue);
      expect(startChallenge.requiredCount, 2);
      expect(
        startChallenge.expiresAt,
        DateTime.fromMillisecondsSinceEpoch(2000000000 * 1000),
      );
      expect(jsonDecode(utf8.decode(passkey.options)), {
        'challenge': testBytesBase64Url('sensitive-passkey'),
        'rpId': '',
      });
      expect(emailCode.maskedEmail, 'a***@example.test');
      expect(finish, isA<SensitiveOperationVerificationComplete>());
      expect(
        (finish as SensitiveOperationVerificationComplete).verificationId,
        'verification_1',
      );

      expect(requests.map((request) => request.url.path), [
        '/api/user/sensitive-verification/start',
        '/api/user/sensitive-verification/passkey/start',
        '/api/user/sensitive-verification/email/request',
        '/api/user/sensitive-verification/finish',
      ]);
      expect(jsonDecode(requests[0].body), <String, dynamic>{});
      expect(jsonDecode(requests[1].body), {'sessionId': 'sensitive_session'});
      expect(jsonDecode(requests[2].body), {'sessionId': 'sensitive_session'});
      expect(jsonDecode(requests[3].body), {
        'sessionId': 'sensitive_session',
        'method': client
            .SensitiveOperationVerificationMethod
            .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN
            .value,
        'password': '',
        'emailToken': '',
        'passkeySessionId': 'passkey_session',
        'passkeyCredential': {
          'id': 'cred-sensitive',
          'rawId': testBytesJson('cred-sensitive'),
          'response': {
            'authenticatorData': testBytesJson('auth-data'),
            'clientDataJSON': testBytesJson('{}'),
            'signature': testBytesJson('sig'),
            'userHandle': testBytesJson('usr_1'),
          },
          'type': 1,
        },
        'totpCode': '',
        'recoveryCode': '',
      });
    },
  );

  test('two-factor changes use the verified security endpoint', () async {
    late http.Request captured;
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'access'),
      httpClient: MockClient((request) async {
        captured = request;
        return http.Response(
          jsonEncode({
            'preferences': {'twoFactorEnabled': true},
            'authFactors': {
              'password': true,
              'email': true,
              'eligibleCount': 2,
            },
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final response = await api.user.setTwoFactorEnabled(
      client.SetTwoFactorEnabledRequest(
        enabled: true,
        verificationId: 'verification-id',
      ),
    );

    expect(captured.method, 'PUT');
    expect(captured.url.path, '/api/user/two-factor');
    expect(jsonDecode(captured.body), {
      'enabled': true,
      'verificationId': 'verification-id',
    });
    expect(response.preferences.twoFactorEnabled, isTrue);
  });

  test(
    'opaque auth endpoints send protocol bytes without plaintext password',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession(),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/auth/opaque/registration/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'reg_session',
                  'registrationResponse': base64Encode([9, 8, 7]),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/opaque/registration/finish':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_1',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'access',
                  'refreshToken': 'refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/opaque/login/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'login_session',
                  'credentialResponse': base64Encode([6, 5, 4]),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/auth/opaque/login/finish':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_1',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                  'accessToken': 'access',
                  'refreshToken': 'refresh',
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );

      await api.auth.startOpaqueRegistration(
        client.StartOpaqueRegistrationRequest(
          username: 'alice',
          email: 'alice@example.test',
          registrationRequest: [1, 2, 3],
        ),
      );
      await api.auth.finishOpaqueRegistration(
        client.FinishOpaqueRegistrationRequest(
          sessionId: 'reg_session',
          registrationUpload: [4, 5, 6],
        ),
      );
      await api.auth.startOpaqueLogin(
        client.StartOpaqueLoginRequest(
          loginSessionId: 'login-context',
          credentialRequest: [7, 8, 9],
        ),
      );
      await api.auth.finishOpaqueLogin(
        client.FinishOpaqueLoginRequest(
          sessionId: 'login_session',
          credentialFinalization: [10, 11, 12],
        ),
      );

      expect(requests.map((request) => request.url.path), [
        '/api/auth/opaque/registration/start',
        '/api/auth/opaque/registration/finish',
        '/api/auth/opaque/login/start',
        '/api/auth/opaque/login/finish',
      ]);

      final bodies = requests
          .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
          .toList();
      expect(bodies[0], {
        'username': 'alice',
        'email': 'alice@example.test',
        'registrationRequest': base64Encode([1, 2, 3]),
      });
      expect(bodies[1], {
        'sessionId': 'reg_session',
        'registrationUpload': base64Encode([4, 5, 6]),
      });
      expect(bodies[2], {
        'loginSessionId': 'login-context',
        'credentialRequest': base64Encode([7, 8, 9]),
      });
      expect(bodies[3], {
        'sessionId': 'login_session',
        'credentialFinalization': base64Encode([10, 11, 12]),
      });
      for (final body in bodies) {
        expect(body.containsKey('password'), isFalse);
        expect(body.values, isNot(contains('plain-password')));
      }
    },
  );

  test('opaque registration domain omits blank email identifier', () async {
    final requests = <http.Request>[];
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test/api',
      session: SyncTvSession(),
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          jsonEncode({
            'sessionId': 'reg_session',
            'registrationResponse': base64Encode([9, 8, 7]),
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    final sessionStore = SyncTvSessionStore(api.session);
    final service = SyncTvAuthDomainService(
      api: api,
      sessionStore: sessionStore,
    );

    await service.startOpaqueRegistration(
      username: 'alice',
      email: '',
      registrationRequest: [1, 2, 3],
    );

    expect(requests, hasLength(1));
    expect(requests.single.url.path, '/api/auth/opaque/registration/start');
    expect(jsonDecode(requests.single.body), {
      'username': 'alice',
      'registrationRequest': base64Encode([1, 2, 3]),
    });
  });

  test(
    'opaque password management sends protocol bytes without plaintext',
    () async {
      final requests = <http.Request>[];
      const emailResetToken = 'not-real-email-reset-token';
      final api = SyncTvApiClient(
        baseUrl: 'https://example.test/api',
        session: SyncTvSession()..updateAccountTokens(accessToken: 'access'),
        httpClient: MockClient((request) async {
          requests.add(request);
          switch (request.url.path) {
            case '/api/user/opaque-password/update/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'update_session',
                  'credentialResponse': base64Encode([9, 8, 7]),
                  'registrationResponse': base64Encode([6, 5, 4]),
                  'passkeySessionId': 'passkey_session',
                  'passkeyOptions': {'challenge': 'opaque-update-passkey'},
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/user/opaque-password/update/finish':
              return http.Response(
                jsonEncode({
                  'user': {
                    'id': 'usr_1',
                    'username': 'alice',
                    'email': 'alice@example.test',
                  },
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/email/password/reset':
              return http.Response(
                jsonEncode({'message': 'sent'}),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/email/password/opaque/start':
              return http.Response(
                jsonEncode({
                  'sessionId': 'reset_session',
                  'registrationResponse': base64Encode([11, 12, 13]),
                }),
                200,
                headers: {'content-type': 'application/json'},
              );
            case '/api/email/password/opaque/finish':
              return http.Response(
                jsonEncode({'message': 'reset', 'userId': 'usr_1'}),
                200,
                headers: {'content-type': 'application/json'},
              );
          }
          return http.Response('not found', 404);
        }),
      );

      await api.user.startOpaquePasswordUpdate(
        client.StartOpaquePasswordUpdateRequest(
          credentialRequest: [1, 2, 3],
          registrationRequest: [4, 5, 6],
          verificationMethod: client_enum
              .OpaquePasswordUpdateVerificationMethod
              .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD,
          emailToken: '',
        ),
      );
      await api.user.finishOpaquePasswordUpdate(
        client.FinishOpaquePasswordUpdateRequest(
          sessionId: 'update_session',
          credentialFinalization: [7, 8, 9],
          registrationUpload: [10, 11, 12],
          passkeySessionId: '',
        ),
      );
      await api.emailService.requestPasswordReset(
        client.RequestPasswordResetRequest(email: 'alice@example.test'),
      );
      await api.emailService.startOpaquePasswordReset(
        client.StartOpaquePasswordResetRequest(
          email: 'alice@example.test',
          token: emailResetToken,
          registrationRequest: [13, 14, 15],
        ),
      );
      await api.emailService.finishOpaquePasswordReset(
        client.FinishOpaquePasswordResetRequest(
          sessionId: 'reset_session',
          registrationUpload: [16, 17, 18],
        ),
      );

      expect(requests.map((request) => request.url.path), [
        '/api/user/opaque-password/update/start',
        '/api/user/opaque-password/update/finish',
        '/api/email/password/reset',
        '/api/email/password/opaque/start',
        '/api/email/password/opaque/finish',
      ]);

      final bodies = requests
          .map((request) => jsonDecode(request.body) as Map<String, dynamic>)
          .toList();
      expect(bodies[0], {
        'credentialRequest': base64Encode([1, 2, 3]),
        'registrationRequest': base64Encode([4, 5, 6]),
        'verificationMethod': client_enum
            .OpaquePasswordUpdateVerificationMethod
            .OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD
            .value,
        'emailToken': '',
      });
      expect(bodies[1], {
        'sessionId': 'update_session',
        'credentialFinalization': base64Encode([7, 8, 9]),
        'registrationUpload': base64Encode([10, 11, 12]),
        'passkeySessionId': '',
      });
      expect(bodies[1].containsKey('passkeyCredential'), isFalse);
      expect(bodies[2], {'email': 'alice@example.test'});
      expect(bodies[3], {
        'email': 'alice@example.test',
        'token': emailResetToken,
        'registrationRequest': base64Encode([13, 14, 15]),
      });
      expect(bodies[4], {
        'sessionId': 'reset_session',
        'registrationUpload': base64Encode([16, 17, 18]),
      });
      for (final body in bodies) {
        expect(body.containsKey('password'), isFalse);
        expect(body.values, isNot(contains('not-real-provider-credential')));
      }
    },
  );
}

String _expectedOwnershipProof(
  List<int> bytes, {
  required String nonce,
  required String contentManifestSha256,
  required List<({int offset, int length})> ranges,
}) {
  final proofBytes = BytesBuilder();
  proofBytes.add(utf8.encode('synctv-file-ownership-proof-v1'));
  proofBytes.add([0]);
  proofBytes.add(utf8.encode(nonce));
  proofBytes.add([0]);
  proofBytes.add(utf8.encode(contentManifestSha256.trim().toLowerCase()));
  proofBytes.add(
    (ByteData(8)..setInt64(0, bytes.length, Endian.big)).buffer.asUint8List(),
  );
  proofBytes.add(
    (ByteData(8)..setUint64(0, ranges.length, Endian.big)).buffer.asUint8List(),
  );
  for (final range in ranges) {
    proofBytes.add(
      (ByteData(8)..setInt64(0, range.offset, Endian.big)).buffer.asUint8List(),
    );
    proofBytes.add(
      (ByteData(4)..setInt32(0, range.length, Endian.big)).buffer.asUint8List(),
    );
    proofBytes.add(
      Uint8List.sublistView(
        Uint8List.fromList(bytes),
        range.offset,
        range.offset + range.length,
      ),
    );
  }
  return sha256.convert(proofBytes.toBytes()).toString();
}

String _expectedContentManifestSha256(
  int sizeBytes,
  int partSizeBytes,
  List<({int partNumber, int sizeBytes, String checksum})> parts,
) {
  final sorted = [...parts]
    ..sort((a, b) => a.partNumber.compareTo(b.partNumber));
  final bytes = BytesBuilder();
  bytes.add(utf8.encode('synctv-file-part-manifest-sha256-v1'));
  bytes.add([0]);
  bytes.add(
    (ByteData(8)..setInt64(0, sizeBytes, Endian.big)).buffer.asUint8List(),
  );
  bytes.add(
    (ByteData(8)..setInt64(0, partSizeBytes, Endian.big)).buffer.asUint8List(),
  );
  bytes.add(
    (ByteData(8)..setUint64(0, sorted.length, Endian.big)).buffer.asUint8List(),
  );
  for (final part in sorted) {
    bytes.add(
      (ByteData(
        4,
      )..setInt32(0, part.partNumber, Endian.big)).buffer.asUint8List(),
    );
    bytes.add(
      (ByteData(
        8,
      )..setInt64(0, part.sizeBytes, Endian.big)).buffer.asUint8List(),
    );
    bytes.add(utf8.encode(part.checksum.trim().toLowerCase()));
  }
  return sha256.convert(bytes.toBytes()).toString();
}

class _FakeOpaqueClient implements opaque.SyncTvOpaqueClient {
  @override
  Future<opaque.OpaqueRegistrationStart> startRegistration(
    String password,
  ) async {
    expect(password, 'plain-room-password');
    return opaque.OpaqueRegistrationStart(
      registrationRequest: Uint8List.fromList([1, 2, 3]),
      state: Uint8List.fromList([20, 21, 22]),
    );
  }

  @override
  Future<opaque.OpaqueRegistrationFinish> finishRegistration({
    required String password,
    required Uint8List state,
    required Uint8List registrationResponse,
  }) async {
    expect(password, 'plain-room-password');
    expect(state, [20, 21, 22]);
    expect(registrationResponse, [9, 8, 7]);
    return opaque.OpaqueRegistrationFinish(
      registrationUpload: Uint8List.fromList([4, 5, 6]),
    );
  }

  @override
  Future<opaque.OpaqueLoginStart> startLogin(String password) async {
    expect(password, 'plain-room-password');
    return opaque.OpaqueLoginStart(
      credentialRequest: Uint8List.fromList([40, 41, 42]),
      state: Uint8List.fromList([60, 61, 62]),
    );
  }

  @override
  Future<opaque.OpaqueLoginFinish> finishLogin({
    required String password,
    required Uint8List state,
    required Uint8List credentialResponse,
  }) async {
    expect(password, 'plain-room-password');
    expect(state, [60, 61, 62]);
    expect(credentialResponse, [30, 31, 32]);
    return opaque.OpaqueLoginFinish(
      credentialFinalization: Uint8List.fromList([50, 51, 52]),
      sessionKey: Uint8List.fromList([70, 71, 72]),
    );
  }
}
