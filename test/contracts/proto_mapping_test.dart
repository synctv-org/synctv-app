import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
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
}
