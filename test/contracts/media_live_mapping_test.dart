import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  final api = SyncTvApiClient(
    baseUrl: 'http://localhost',
    session: SyncTvSession(),
  );

  test('maps every explicit live media source to live library entries', () {
    final sources =
        <(source_enum.SourceProvider, source_config.MediaSourceConfig)>[
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
            source_config.MediaSourceConfig(
              directUrl: source_config.DirectUrlMediaSourceConfig(
                playbackKind: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
            source_config.MediaSourceConfig(
              bilibili: source_config.BilibiliMediaSourceConfig(
                live: source_config.BilibiliLiveSourceConfig(roomId: Int64(1)),
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_RTMP,
            source_config.MediaSourceConfig(
              rtmp: source_config.RtmpMediaSourceConfig(),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
            source_config.MediaSourceConfig(
              liveProxy: source_config.LiveProxyMediaSourceConfig(
                httpFlv: source_config.HttpFlvPullSourceConfig(
                  url: 'https://example.com/live.flv',
                ),
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
            source_config.MediaSourceConfig(
              twitch: source_config.TwitchMediaSourceConfig(
                live: source_config.TwitchLiveSourceConfig(channel: 'channel'),
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
            source_config.MediaSourceConfig(
              huya: source_config.HuyaMediaSourceConfig(
                live: source_config.HuyaLiveSourceConfig(roomId: '1'),
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
            source_config.MediaSourceConfig(
              douyu: source_config.DouyuMediaSourceConfig(room: '1'),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
            source_config.MediaSourceConfig(
              douyin: source_config.DouyinMediaSourceConfig(
                live: source_config.DouyinLiveSourceConfig(webRid: '1'),
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
            source_config.MediaSourceConfig(
              tiktok: source_config.TikTokMediaSourceConfig(
                live: source_config.TikTokLiveSourceConfig(uniqueId: 'creator'),
              ),
            ),
          ),
          (
            source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
            source_config.MediaSourceConfig(
              acFun: source_config.AcFunMediaSourceConfig(
                live: source_config.AcFunLiveSourceConfig(authorId: '1'),
              ),
            ),
          ),
        ];

    for (final (provider, sourceConfig) in sources) {
      final mapped = api.mapMedia(
        client.Media(
          id: 'med_1',
          roomId: 'room_1',
          name: provider.name,
          sourceProvider: provider,
          sourceConfig: sourceConfig,
        ),
      );
      expect(mapped.live, isTrue, reason: provider.name);
    }
  });

  test('keeps explicit VOD media sources seekable', () {
    final mapped = api.mapMedia(
      client.Media(
        id: 'med_1',
        roomId: 'room_1',
        name: 'TikTok VOD',
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
        sourceConfig: source_config.MediaSourceConfig(
          tiktok: source_config.TikTokMediaSourceConfig(
            video: source_config.TikTokVideoSourceConfig(videoId: '1'),
          ),
        ),
      ),
    );

    expect(mapped.live, isFalse);
  });

  test('preserves live oneofs from REST media JSON', () {
    final directConfig = source_config.MediaSourceConfig()
      ..mergeFromProto3Json({
        'tiktok': {
          'live': {'uniqueId': 'creator'},
        },
      });
    expect(
      directConfig.tiktok.whichSource(),
      source_config.TikTokMediaSourceConfig_Source.live,
    );

    final directMedia = client.Media()
      ..mergeFromProto3Json({
        'id': 'med_26',
        'roomId': 'room_4',
        'sourceProvider': 21,
        'name': 'TikTok Live Fixture',
        'sourceConfig': {
          'tiktok': {
            'live': {'uniqueId': 'creator'},
          },
        },
      }, permissiveEnums: true);
    expect(
      directMedia.sourceConfig.tiktok.whichSource(),
      source_config.TikTokMediaSourceConfig_Source.live,
    );

    final media = api.decodeProtoJson({
      'id': 'med_26',
      'roomId': 'room_4',
      'sourceProvider': 21,
      'name': 'TikTok Live Fixture',
      'sourceConfig': {
        'tiktok': {
          'live': {'uniqueId': 'creator'},
        },
      },
    }, client.Media.create);

    expect(
      media.sourceConfig.tiktok.whichSource(),
      source_config.TikTokMediaSourceConfig_Source.live,
    );
    expect(api.mapMedia(media).sourceConfig, {
      'kind': 'live',
      'uniqueId': 'creator',
    });
    expect(api.mapMedia(media).live, isTrue);
  });
}
