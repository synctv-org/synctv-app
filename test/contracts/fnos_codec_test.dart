import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  group('FNOS source config codec', () {
    test('round trips a file media source', () {
      const json = {
        'serverId': 'nas-home',
        'type': 'file',
        'path': '/Videos/movie.mkv',
      };

      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
        sourceConfig: json,
      )!;

      expect(
        config.whichProvider(),
        source_config.MediaSourceConfig_Provider.fnos,
      );
      expect(config.fnos.file.path, '/Videos/movie.mkv');
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), json);
    });

    test('round trips a media-library item source', () {
      const json = {
        'serverId': 'nas-home',
        'type': 'libraryItem',
        'itemGuid': 'item-guid',
        'mediaGuid': 'media-guid',
      };

      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
        sourceConfig: json,
      )!;

      expect(config.fnos.libraryItem.itemGuid, 'item-guid');
      expect(config.fnos.libraryItem.mediaGuid, 'media-guid');
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), json);
    });

    test('round trips a media-library playlist source', () {
      const json = {
        'serverId': 'nas-home',
        'type': 'mediaLibrary',
        'libraryGuid': 'library-guid',
        'parentGuid': 'folder-guid',
        'mediaTypes': ['Movie', 'TV'],
      };

      final config = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
        sourceConfig: json,
      )!;

      expect(config.fnos.mediaLibrary.mediaTypes, ['Movie', 'TV']);
      expect(SourceConfigCodec.playlistSourceConfigToMap(config), json);
    });

    test('round trips favorite and history playlist sources', () {
      for (final json in [
        {
          'serverId': 'nas-home',
          'type': 'favorites',
          'mediaTypes': ['Movie', 'Video'],
        },
        {'serverId': 'nas-home', 'type': 'history'},
      ]) {
        final config = SourceConfigCodec.playlistSourceConfigFromMap(
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
          sourceConfig: json,
        )!;
        expect(SourceConfigCodec.playlistSourceConfigToMap(config), json);
      }
    });
  });

  group('FNOS provider target codec', () {
    test('round trips file and media-item targets', () {
      final targets = [
        client.ProviderTarget(
          fnos: client.FnosTarget(
            file: client.FnosFileTarget(relativePath: '/Movies/a.mkv'),
          ),
        ),
        client.ProviderTarget(
          fnos: client.FnosTarget(
            mediaItem: client.FnosMediaItemTarget(
              itemGuid: 'item-guid',
              mediaGuid: 'media-guid',
              libraryGuid: 'library-guid',
            ),
          ),
        ),
      ];

      for (final target in targets) {
        final encoded = providerTargetToBase64(target);
        expect(
          providerTargetToJson(providerTargetFromBase64(encoded)),
          providerTargetToJson(target),
        );
      }
    });
  });
}
