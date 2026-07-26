import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

void main() {
  group('QNAP source config codec', () {
    test('round trips a media source', () {
      const json = {'serverId': 'qnap-home', 'path': '/Multimedia/movie.mkv'};

      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: 'qnap',
        sourceConfig: json,
      )!;

      expect(
        config.whichProvider(),
        source_config.MediaSourceConfig_Provider.qnap,
      );
      expect(config.qnap.path, '/Multimedia/movie.mkv');
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), json);
    });

    test('round trips a dynamic playlist source', () {
      const json = {'serverId': 'qnap-home', 'path': '/Multimedia'};

      final config = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: 'qnap',
        sourceConfig: json,
      )!;

      expect(
        config.whichProvider(),
        source_config.PlaylistSourceConfig_Provider.qnap,
      );
      expect(SourceConfigCodec.playlistSourceConfigToMap(config), json);
    });
  });

  test('QNAP provider target codec preserves the relative path', () {
    final target = client.ProviderTarget(
      qnap: client.QnapTarget(relativePath: '/Multimedia/movie.mkv'),
    );

    final encoded = providerTargetToBase64(target);

    expect(
      providerTargetToJson(providerTargetFromBase64(encoded)),
      providerTargetToJson(target),
    );
  });
}
