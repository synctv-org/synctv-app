import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
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
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
          sourceConfig: source,
        )!;
        expect(
          SourceConfigCodec.providerForMediaSourceConfig(config),
          source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
        );
        expect(SourceConfigCodec.mediaSourceConfigToMap(config), source);
      }

      final playlist = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
        sourceConfig: const {'secUid': 'MS4wLjABAAAAexample', 'shared': true},
      )!;
      expect(
        SourceConfigCodec.providerForPlaylistSourceConfig(playlist),
        source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
      );
      expect(SourceConfigCodec.playlistSourceConfigToMap(playlist), {
        'secUid': 'MS4wLjABAAAAexample',
        'shared': true,
      });
    });
  });
}
