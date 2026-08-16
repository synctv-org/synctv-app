import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';

final class _TestResourceUrlResolver implements ResourceUrlResolver {
  const _TestResourceUrlResolver({required this.serverResource});

  final bool serverResource;

  @override
  Map<String, String> get authenticatedHeaders => const {
    'authorization': 'Bearer session-token',
  };

  @override
  bool isServerResource(String resourceUrl) => serverResource;

  @override
  String resolve(String resourceUrl) => resourceUrl;
}

void main() {
  group('isServerApiResourceUrl', () {
    test('accepts resources below the configured API path', () {
      expect(
        isServerApiResourceUrl(
          'https://synctv.example/synctv/api/playback-providers/room/bilibili/live-danmaku/media',
          'https://synctv.example/synctv',
        ),
        isTrue,
      );
    });

    test('rejects a cohosted application outside the deployment path', () {
      expect(
        isServerApiResourceUrl(
          'https://synctv.example/other-app/danmaku',
          'https://synctv.example/synctv',
        ),
        isFalse,
      );
    });

    test('rejects resources outside the SyncTV API namespace', () {
      expect(
        isServerApiResourceUrl(
          'https://synctv.example/synctv/provider-origin/danmaku',
          'https://synctv.example/synctv',
        ),
        isFalse,
      );
    });
  });

  test('adds session credentials to server playback resources', () {
    final headers = authenticatedServerResourceHeaders(
      const _TestResourceUrlResolver(serverResource: true),
      'https://synctv.example/api/rooms/room/playlists/playlist/danmaku/bilibili-live',
      const {'X-Playback': 'live'},
    );

    expect(headers, {
      'X-Playback': 'live',
      'authorization': 'Bearer session-token',
    });
  });

  test('keeps session credentials away from provider origins', () {
    final headers = authenticatedServerResourceHeaders(
      const _TestResourceUrlResolver(serverResource: false),
      'https://api.bilibili.com/x/v1/dm/list.so?oid=1',
      const {'Referer': 'https://www.bilibili.com'},
    );

    expect(headers, {'Referer': 'https://www.bilibili.com'});
  });

  test('uses the current session authorization for server resources', () {
    final headers = authenticatedServerResourceHeaders(
      const _TestResourceUrlResolver(serverResource: true),
      'https://synctv.example/api/playback-providers/room/bilibili/live-danmaku/media',
      const {'Authorization': 'Bearer stale-provider-token'},
    );

    expect(headers, {'authorization': 'Bearer session-token'});
  });
}
