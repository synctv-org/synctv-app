import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';

void main() {
  test('defines branding for every media provider', () {
    const providerTypes = [
      'directUrl',
      'rtmp',
      'liveProxy',
      'bilibili',
      'alist',
      'emby',
      'cloudreve',
      'twitch',
      'huya',
      'douyu',
      'acfun',
      'cctv',
      'fnos',
      'qnap',
      'synology',
      'nextcloud',
      'seafile',
      'truenas',
      'youtube',
      'douyin',
      'tiktok',
    ];

    for (final providerType in providerTypes) {
      final brand = mediaProviderBrand(providerType);
      expect(brand.known, isTrue, reason: providerType);
      expect(brand.label, isNotEmpty, reason: providerType);
      expect(brand.type, isNotEmpty, reason: providerType);
    }
  });

  test('normalizes provider aliases', () {
    expect(mediaProviderBrand('direct_url').type, 'directUrl');
    expect(mediaProviderBrand('Synology DSM').type, 'synology');
  });
}
