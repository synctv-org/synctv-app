import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  test('TrueNAS media and playlist source configs round trip', () {
    final media = SourceConfigCodec.mediaSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
      sourceConfig: const {
        'serverId': 'nas-home',
        'path': '/mnt/tank/Movie.mkv',
      },
    )!;
    expect(
      SourceConfigCodec.providerForMediaSourceConfig(media),
      source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
    );
    expect(SourceConfigCodec.mediaSourceConfigToMap(media), {
      'serverId': 'nas-home',
      'path': '/mnt/tank/Movie.mkv',
    });

    final playlist = SourceConfigCodec.playlistSourceConfigFromMap(
      sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
      sourceConfig: const {
        'serverId': 'nas-home',
        'source': {'type': 'search', 'path': '/mnt/tank', 'query': 'movie'},
      },
    )!;
    expect(
      SourceConfigCodec.providerForPlaylistSourceConfig(playlist),
      source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
    );
    expect(SourceConfigCodec.playlistSourceConfigToMap(playlist), {
      'serverId': 'nas-home',
      'source': {'type': 'search', 'path': '/mnt/tank', 'query': 'movie'},
    });
  });
}
