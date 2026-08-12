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
  group('Synology source config codec', () {
    test('round trips File Station and Video Station media sources', () {
      const fileJson = {
        'serverId': 'dsm-home',
        'type': 'file',
        'path': '/video/movie.mkv',
      };
      const videoJson = {
        'serverId': 'dsm-home',
        'type': 'libraryItem',
        'kind': 'episode',
        'itemId': 42,
        'fileId': 84,
      };

      final file = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY,
        sourceConfig: fileJson,
      )!;
      final video = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY,
        sourceConfig: videoJson,
      )!;

      expect(
        file.whichProvider(),
        source_config.MediaSourceConfig_Provider.synology,
      );
      expect(
        video.synology.libraryItem.kind,
        source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE,
      );
      expect(SourceConfigCodec.mediaSourceConfigToMap(file), fileJson);
      expect(SourceConfigCodec.mediaSourceConfigToMap(video), videoJson);
    });

    test('round trips all provider-specific dynamic playlist shapes', () {
      final sources = [
        {'serverId': 'dsm', 'type': 'files', 'path': '/video'},
        {'serverId': 'dsm', 'type': 'movies', 'libraryId': 1},
        {'serverId': 'dsm', 'type': 'tvShows', 'libraryId': 2},
        {'serverId': 'dsm', 'type': 'episodes', 'libraryId': 2, 'tvShowId': 9},
        {'serverId': 'dsm', 'type': 'homeVideos', 'libraryId': 3},
        {'serverId': 'dsm', 'type': 'tvRecordings', 'libraryId': 4},
      ];

      for (final source in sources) {
        final config = SourceConfigCodec.playlistSourceConfigFromMap(
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY,
          sourceConfig: source,
        )!;
        expect(
          config.whichProvider(),
          source_config.PlaylistSourceConfig_Provider.synology,
        );
        expect(SourceConfigCodec.playlistSourceConfigToMap(config), source);
      }
    });
  });

  test(
    'Synology target codec preserves directory and playable target types',
    () {
      final targets = [
        client.ProviderTarget(
          synology: client.SynologyTarget(
            file: client.SynologyFileTarget(relativePath: 'Series/Episode.mkv'),
          ),
        ),
        client.ProviderTarget(
          synology: client.SynologyTarget(
            libraryItem: client.SynologyLibraryItemTarget(
              kind: source_enum
                  .SynologyLibraryItemKind
                  .SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE,
              itemId: Int64(42),
              fileId: Int64(84),
              parentId: Int64(9),
            ),
          ),
        ),
        client.ProviderTarget(
          synology: client.SynologyTarget(
            tvShow: client.SynologyTvShowTarget(
              libraryId: Int64(2),
              tvShowId: Int64(9),
            ),
          ),
        ),
      ];

      for (final target in targets) {
        final decoded = providerTargetFromBase64(
          providerTargetToBase64(target),
        );
        expect(providerTargetToJson(decoded), providerTargetToJson(target));
      }
    },
  );
}
