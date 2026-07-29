import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';

void main() {
  group('ProviderDistributionPolicy', () {
    const full = ProviderDistributionPolicy(includesThirdPartyProviders: true);
    const store = ProviderDistributionPolicy(
      includesThirdPartyProviders: false,
    );

    test('full distribution includes every provider and OAuth2', () {
      expect(full.allowsOAuth2, isTrue);
      for (final provider
          in ProviderDistributionPolicy.thirdPartyProviderTypes) {
        expect(full.allowsProvider(provider), isTrue);
      }
    });

    test('store distribution excludes third-party providers and OAuth2', () {
      expect(store.allowsOAuth2, isTrue);
      for (final provider
          in ProviderDistributionPolicy.thirdPartyProviderTypes) {
        expect(store.allowsProvider(provider), isFalse);
      }
    });

    test('store distribution includes user-owned media providers', () {
      for (final provider in const [
        'directUrl',
        'rtmp',
        'liveProxy',
        'alist',
        'emby',
        'cloudreve',
        'fnos',
        'qnap',
        'synology',
        'nextcloud',
        'seafile',
        'truenas',
      ]) {
        expect(store.allowsProvider(provider), isTrue, reason: provider);
      }
    });
  });
}
