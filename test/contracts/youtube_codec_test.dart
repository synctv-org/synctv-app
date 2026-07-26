import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  group('YouTube source config codec', () {
    test('round trips Cookie credential fields', () {
      final request = youtube.BindRequest(
        label: 'Browser session',
        visitorData: 'visitor',
        poToken: 'po-token',
        cookie: 'LOGIN_INFO=login; SAPISID=secret',
        instanceName: 'primary',
      );
      final decoded = youtube.BindRequest.fromBuffer(request.writeToBuffer());

      expect(decoded.cookie, 'LOGIN_INFO=login; SAPISID=secret');
      expect(decoded.instanceName, 'primary');
      expect(youtube.BindInfo(hasCookie: true).hasCookie, isTrue);
    });

    test('round trips video config', () {
      final config = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: 'youtube',
        sourceConfig: const {'videoId': 'dQw4w9WgXcQ', 'shared': true},
      )!;
      expect(SourceConfigCodec.providerForMediaSourceConfig(config), 'youtube');
      expect(SourceConfigCodec.mediaSourceConfigToMap(config), {
        'videoId': 'dQw4w9WgXcQ',
        'shared': true,
      });
    });

    for (final source in [
      const {'kind': 'playlist', 'playlistId': 'PL123', 'shared': true},
      const {
        'kind': 'channel',
        'channelId': 'UC12345678901234567890',
        'content': 'shorts',
      },
      const {'kind': 'search', 'query': 'SyncTV'},
    ]) {
      test('round trips ${source['kind']} playlist config', () {
        final config = SourceConfigCodec.playlistSourceConfigFromMap(
          sourceProvider: 'youtube',
          sourceConfig: source,
        )!;
        expect(
          SourceConfigCodec.providerForPlaylistSourceConfig(config),
          'youtube',
        );
        expect(SourceConfigCodec.playlistSourceConfigToMap(config), source);
      });
    }

    test('encodes nested channel content enum as an integer', () {
      final config = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: 'youtube',
        sourceConfig: const {
          'kind': 'channel',
          'channelId': 'UCuAXFkgsw1L7xaCfnd5JJOw',
          'content': 'shorts',
        },
      )!;

      final json = SourceConfigCodec.playlistSourceConfigJson(config);
      expect(
        json['youtube']['channel']['content'],
        source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_SHORTS.value,
      );
    });
  });
}
