import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';

void main() {
  test('TrueNAS media and playlist source configs round trip', () {
    final media = SourceConfigCodec.mediaSourceConfigFromMap(
      sourceProvider: 'truenas',
      sourceConfig: const {
        'serverId': 'nas-home',
        'path': '/mnt/tank/Movie.mkv',
      },
    )!;
    expect(SourceConfigCodec.providerForMediaSourceConfig(media), 'truenas');
    expect(SourceConfigCodec.mediaSourceConfigToMap(media), {
      'serverId': 'nas-home',
      'path': '/mnt/tank/Movie.mkv',
    });

    final playlist = SourceConfigCodec.playlistSourceConfigFromMap(
      sourceProvider: 'truenas',
      sourceConfig: const {
        'serverId': 'nas-home',
        'source': {'type': 'search', 'path': '/mnt/tank', 'query': 'movie'},
      },
    )!;
    expect(
      SourceConfigCodec.providerForPlaylistSourceConfig(playlist),
      'truenas',
    );
    expect(SourceConfigCodec.playlistSourceConfigToMap(playlist), {
      'serverId': 'nas-home',
      'source': {'type': 'search', 'path': '/mnt/tank', 'query': 'movie'},
    });
  });
}
