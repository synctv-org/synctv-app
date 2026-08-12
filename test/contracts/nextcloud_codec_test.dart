import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

void main() {
  group('Nextcloud source config codec', () {
    test('round trips media source with uint64 file ID', () {
      const json = {
        'serverId': 'nextcloud-home',
        'path': '/Videos/Movie.mkv',
        'fileId': 9007199254740993,
      };

      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD,
        sourceConfig: json,
      )!;

      expect(
        config.whichProvider(),
        source_config.MediaSourceConfig_Provider.nextcloud,
      );
      expect(config.nextcloud.fileId, Int64(9007199254740993));
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), json);
    });

    test('round trips folder, favorites, and search playlist sources', () {
      const sources = [
        {
          'serverId': 'nextcloud-home',
          'source': {'type': 'folder', 'path': '/Videos'},
        },
        {
          'serverId': 'nextcloud-home',
          'source': {'type': 'favorites'},
        },
        {
          'serverId': 'nextcloud-home',
          'source': {'type': 'search', 'path': '/Videos', 'query': 'movie'},
        },
      ];

      for (final source in sources) {
        final config = SourceConfigCodec.playlistSourceConfigFromMap(
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD,
          sourceConfig: source,
        )!;
        expect(
          config.whichProvider(),
          source_config.PlaylistSourceConfig_Provider.nextcloud,
        );
        expect(SourceConfigCodec.playlistSourceConfigToMap(config), source);
      }
    });
  });

  test('Nextcloud provider target preserves path and uint64 file ID', () {
    final target = client.ProviderTarget(
      nextcloud: client.NextcloudTarget(
        path: '/Videos/Movie.mkv',
        fileId: Int64(9007199254740993),
      ),
    );

    final decoded = providerTargetFromBase64(providerTargetToBase64(target));

    expect(providerTargetToJson(decoded), providerTargetToJson(target));
  });
}
