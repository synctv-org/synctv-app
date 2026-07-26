import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;

void main() {
  group('TikTok protobuf and source config', () {
    test('keeps Cookie bind fields in protobuf round trip', () {
      final request = tiktok.BindRequest(
        label: 'Browser session',
        cookie: 'sessionid=secret',
        instanceName: 'tiktok-edge',
      );
      final decoded = tiktok.BindRequest.fromBuffer(request.writeToBuffer());
      expect(decoded.label, 'Browser session');
      expect(decoded.cookie, 'sessionid=secret');
      expect(decoded.instanceName, 'tiktok-edge');
    });

    test('round trips video, live, and user posts source configs', () {
      for (final source in [
        {'kind': 'video', 'videoId': '7412345678901234567', 'shared': true},
        {'kind': 'live', 'uniqueId': 'creator_name', 'shared': true},
      ]) {
        final config = SourceConfigCodec.mediaSourceConfigFromMap(
          sourceProvider: 'tiktok',
          sourceConfig: source,
        )!;
        expect(
          SourceConfigCodec.providerForMediaSourceConfig(config),
          'tiktok',
        );
        expect(SourceConfigCodec.mediaSourceConfigToMap(config), source);
      }

      final playlist = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: 'tiktok',
        sourceConfig: const {'secUid': 'MS4wLjABAAAAexample', 'shared': true},
      )!;
      expect(
        SourceConfigCodec.providerForPlaylistSourceConfig(playlist),
        'tiktok',
      );
      expect(SourceConfigCodec.playlistSourceConfigToMap(playlist), {
        'secUid': 'MS4wLjABAAAAexample',
        'shared': true,
      });
    });
  });
}
