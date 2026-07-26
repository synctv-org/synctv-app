import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

void main() {
  group('Seafile source config codec', () {
    test('round trips media source metadata', () {
      const json = {
        'serverId': 'seafile-home',
        'repositoryId': 'repo-1',
        'path': '/Videos/Movie.mkv',
        'objectId': '0123456789abcdef',
        'hasThumbnail': true,
      };
      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: 'seafile',
        sourceConfig: json,
      )!;
      expect(
        config.whichProvider(),
        source_config.MediaSourceConfig_Provider.seafile,
      );
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), json);
    });

    test('round trips folder, starred, and search playlist sources', () {
      const sources = [
        {
          'serverId': 'seafile-home',
          'source': {
            'type': 'folder',
            'repositoryId': 'repo-1',
            'path': '/Videos',
          },
        },
        {
          'serverId': 'seafile-home',
          'source': {'type': 'starred'},
        },
        {
          'serverId': 'seafile-home',
          'source': {
            'type': 'search',
            'repositoryId': 'repo-1',
            'query': 'movie',
          },
        },
      ];
      for (final source in sources) {
        final config = SourceConfigCodec.playlistSourceConfigFromMap(
          sourceProvider: 'seafile',
          sourceConfig: source,
        )!;
        expect(
          config.whichProvider(),
          source_config.PlaylistSourceConfig_Provider.seafile,
        );
        expect(SourceConfigCodec.playlistSourceConfigToMap(config), source);
      }
    });
  });

  test('Seafile provider target preserves native file metadata', () {
    final target = client.ProviderTarget(
      seafile: client.SeafileTarget(
        repositoryId: 'repo-1',
        path: '/Videos/Movie.mkv',
        objectId: 'object-id',
        hasThumbnail: true,
      ),
    );
    final decoded = providerTargetFromBase64(providerTargetToBase64(target));
    expect(providerTargetToJson(decoded), providerTargetToJson(target));
  });
}
