import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/providers/douyin.pb.dart'
    as douyin;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  group('Douyin protobuf and source config', () {
    test('keeps Cookie bind fields in protobuf round trip', () {
      final request = douyin.BindRequest(
        label: 'Browser session',
        cookie: 'sessionid=secret',
        instanceName: 'douyin-edge',
      );
      final decoded = douyin.BindRequest.fromBuffer(request.writeToBuffer());
      expect(decoded.label, 'Browser session');
      expect(decoded.cookie, 'sessionid=secret');
      expect(decoded.instanceName, 'douyin-edge');
    });

    test('round trips video, live, and user posts source configs', () {
      for (final source in [
        {'kind': 'video', 'awemeId': '123456', 'shared': true},
        {'kind': 'live', 'webRid': '654321', 'shared': true},
      ]) {
        final config = SourceConfigCodec.mediaSourceConfigFromMap(
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
          sourceConfig: source,
        )!;
        expect(
          SourceConfigCodec.providerForMediaSourceConfig(config),
          source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
        );
        expect(SourceConfigCodec.mediaSourceConfigToMap(config), source);
      }

      final playlist = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
        sourceConfig: const {'secUid': 'MS4wLjABAAAAexample', 'shared': true},
      )!;
      expect(
        SourceConfigCodec.providerForPlaylistSourceConfig(playlist),
        source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
      );
      expect(SourceConfigCodec.playlistSourceConfigToMap(playlist), {
        'secUid': 'MS4wLjABAAAAexample',
        'shared': true,
      });
    });
  });
}
