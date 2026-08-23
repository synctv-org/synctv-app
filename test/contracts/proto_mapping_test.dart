import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/src/generated/proto/admin.pb.dart' as admin;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/src/generated/proto/oauth2.pbenum.dart';

void main() {
  group('OAuth2 provider type mapping', () {
    const mappings = <OAuth2ProviderType, String>{
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_QQ: 'qq',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITHUB: 'github',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GOOGLE: 'google',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_MICROSOFT: 'microsoft',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_DISCORD: 'discord',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_CASDOOR: 'casdoor',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_LOGTO: 'logto',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_OIDC: 'oidc',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_FEISHU: 'feishu',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_GITEE: 'gitee',
      OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_APPLE: 'apple',
    };

    for (final entry in mappings.entries) {
      test('round-trips ${entry.value}', () {
        expect(oauth2ProviderTypeToString(entry.key), entry.value);
        expect(oauth2ProviderTypeFromString(entry.value), entry.key);
      });
    }

    test('maps unknown values to unspecified', () {
      expect(
        oauth2ProviderTypeFromString('unknown'),
        OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_UNSPECIFIED,
      );
      expect(
        oauth2ProviderTypeToString(
          OAuth2ProviderType.OAUTH2_PROVIDER_TYPE_UNSPECIFIED,
        ),
        isEmpty,
      );
    });
  });

  test('keeps proto3 default-valued runtime settings in section maps', () {
    final settings = admin.RuntimeSettings(
      user: admin.UserSettings()..mergeFromProto3Json(<String, dynamic>{}),
      roomCreation: admin.RoomCreationSettings()
        ..mergeFromProto3Json(<String, dynamic>{}),
      email: admin.EmailSettings()..mergeFromProto3Json(<String, dynamic>{}),
      rtmp: admin.RtmpSettings()..mergeFromProto3Json(<String, dynamic>{}),
    );

    expect(
      runtimeSettingsSectionToJson(settings, 'user').keys,
      containsAll(<String>[
        'enablePasswordSignup',
        'passwordSignupNeedReview',
        'enableEmailSignup',
        'emailSignupNeedReview',
        'enableWebauthnSignup',
        'webauthnSignupNeedReview',
        'enableGuest',
      ]),
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'user')['enableGuest'],
      isFalse,
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'roomCreation').keys,
      containsAll(<String>[
        'enabled',
        'approvalRequired',
        'passwordPolicy',
        'maxRoomsPerUser',
      ]),
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'roomCreation')['passwordPolicy'],
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_OPTIONAL.name,
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'email').keys,
      containsAll(<String>[
        'enabled',
        'smtpPort',
        'useTls',
        'fromName',
        'whitelistEnabled',
        'whitelistDomains',
      ]),
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'rtmp').keys,
      contains('tsDisguisedAsPng'),
    );

    final oauth2Settings = admin.OAuth2Settings()
      ..mergeFromProto3Json({
        'providers': [
          {
            'name': 'github',
            'github': {'clientId': 'id'},
          },
        ],
      });
    final oauth2 = admin.RuntimeSettings(oauth2: oauth2Settings);
    final providers = runtimeSettingsSectionToJson(
      oauth2,
      'oauth2',
    )['providers'];
    expect(providers, isA<List<dynamic>>());
    expect((providers as List).single, containsPair('enableSignup', false));
    expect(providers.single, containsPair('signupNeedReview', false));
  });

  test('keeps editable settings when optional sections are absent', () {
    final settings = admin.RuntimeSettings();

    expect(
      runtimeSettingsSectionToJson(settings, 'rtmp'),
      containsPair('advertiseAddress', isNull),
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'rtmp'),
      containsPair('tsDisguisedAsPng', false),
    );
    expect(
      runtimeSettingsSectionToJson(settings, 'email').keys,
      containsAll(<String>[
        'enabled',
        'smtpHost',
        'smtpPort',
        'smtpCredentials',
        'smtpProxy',
        'useTls',
        'fromEmail',
        'fromName',
        'whitelistEnabled',
        'whitelistDomains',
      ]),
    );
  });
}
