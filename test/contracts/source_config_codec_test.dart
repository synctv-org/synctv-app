import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  group('Playback proxy mode source config', () {
    final mediaCases = <(source_enum.SourceProvider, Map<String, dynamic>)>[
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
        {'url': 'https://example.test/video.mp4'},
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
        {'serverId': 'alist-main', 'path': '/movies/video.mp4'},
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
        {'kind': 'video', 'bvid': 'BV1test', 'cid': 42},
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        {'serverId': 'emby-main', 'itemId': 'item-42'},
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
        {'serverId': 'cloudreve-main', 'path': '/movies/video.mp4'},
      ),
    ];
    final playlistCases = <(source_enum.SourceProvider, Map<String, dynamic>)>[
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
        {'serverId': 'alist-main', 'path': '/movies'},
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
        {
          'source': {'type': 'popular'},
        },
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        {
          'serverId': 'emby-main',
          'source': {'type': 'folder', 'itemId': 'folder-42'},
        },
      ),
      (
        source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
        {'serverId': 'cloudreve-main', 'path': '/movies'},
      ),
    ];

    test('round trips proxy preferences for supported media sources', () {
      for (final (provider, baseConfig) in mediaCases) {
        for (final mode in ['prefer', 'only', 'directPrefer', 'directOnly']) {
          final config = {...baseConfig, 'proxyMode': mode};
          final encoded = SourceConfigCodec.mediaSourceConfigFromMap(
            sourceProvider: provider,
            sourceConfig: config,
          )!;

          expect(
            SourceConfigCodec.mediaSourceConfigToMap(encoded)['proxyMode'],
            mode,
            reason: '$provider media should preserve $mode',
          );
        }
      }
    });

    test('round trips proxy preferences for supported playlists', () {
      for (final (provider, baseConfig) in playlistCases) {
        for (final mode in ['prefer', 'only', 'directPrefer', 'directOnly']) {
          final config = {...baseConfig, 'proxyMode': mode};
          final encoded = SourceConfigCodec.playlistSourceConfigFromMap(
            sourceProvider: provider,
            sourceConfig: config,
          )!;

          expect(
            SourceConfigCodec.playlistSourceConfigToMap(encoded)['proxyMode'],
            mode,
            reason: '$provider playlist should preserve $mode',
          );
        }
      }
    });

    test('omits automatic mode from persisted source config maps', () {
      for (final (provider, baseConfig) in [...mediaCases, ...playlistCases]) {
        final isMedia = mediaCases.any(
          (entry) => identical(entry.$2, baseConfig),
        );
        final encoded = isMedia
            ? SourceConfigCodec.mediaSourceConfigFromMap(
                sourceProvider: provider,
                sourceConfig: baseConfig,
              )!
            : SourceConfigCodec.playlistSourceConfigFromMap(
                sourceProvider: provider,
                sourceConfig: baseConfig,
              )!;
        final result = isMedia
            ? SourceConfigCodec.mediaSourceConfigToMap(
                encoded as source.MediaSourceConfig,
              )
            : SourceConfigCodec.playlistSourceConfigToMap(
                encoded as source.PlaylistSourceConfig,
              );

        expect(result, isNot(contains('proxyMode')));
      }
    });
  });

  group('Bilibili playlist source config', () {
    test('encodes every provider-specific source shape', () {
      final cases = <Map<String, dynamic>>[
        {
          'source': {'type': 'videoParts', 'bvid': 'BV1test', 'aid': 123},
        },
        {
          'source': {'type': 'popular'},
        },
        {
          'source': {'type': 'recommended'},
          'shared': true,
        },
        {
          'source': {'type': 'upVideos', 'mid': 123, 'keyword': 'music'},
        },
        {
          'source': {'type': 'favoriteVideos', 'mediaId': 456},
        },
        {
          'source': {'type': 'collectionVideos', 'mid': 123, 'seasonId': 789},
        },
        {
          'source': {'type': 'seriesVideos', 'mid': 123, 'seriesId': 987},
        },
        {
          'source': {'type': 'watchLater'},
        },
        {
          'source': {'type': 'pgcSeason', 'seasonId': 42},
        },
        {
          'source': {'type': 'liveRecommended'},
        },
        {
          'source': {'type': 'liveFollowed'},
        },
        {
          'source': {'type': 'liveArea', 'parentAreaId': 1, 'areaId': 2},
        },
        {
          'source': {'type': 'history', 'historyType': 'archive'},
        },
        {
          'source': {
            'type': 'pgcTimeline',
            'timelineType': 'guochuang',
            'beforeDays': 2,
            'afterDays': 5,
          },
        },
      ];

      final variants = cases
          .map(
            (config) => SourceConfigCodec.playlistSourceConfigFromMap(
              sourceProvider:
                  source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
              sourceConfig: config,
            ),
          )
          .whereType<source.PlaylistSourceConfig>()
          .map((config) => config.bilibili.whichSource())
          .toList();

      expect(
        variants,
        source.BilibiliPlaylistSourceConfig_Source.values
            .where(
              (value) =>
                  value != source.BilibiliPlaylistSourceConfig_Source.notSet,
            )
            .toList(),
      );
    });

    test('round trips collection identifiers and shared credential mode', () {
      final encoded = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
        sourceConfig: {
          'source': {'type': 'collectionVideos', 'mid': 123, 'seasonId': 789},
          'shared': true,
        },
      )!;

      expect(SourceConfigCodec.playlistSourceConfigToMap(encoded), {
        'source': {'type': 'collectionVideos', 'mid': 123, 'seasonId': 789},
        'shared': true,
      });
    });

    test('round trips a multi-part video source', () {
      final encoded = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
        sourceConfig: {
          'source': {'type': 'videoParts', 'bvid': 'BV1test', 'aid': 123},
        },
      )!;

      expect(SourceConfigCodec.playlistSourceConfigToMap(encoded), {
        'source': {'type': 'videoParts', 'bvid': 'BV1test', 'aid': 123},
      });
    });

    test('round trips a cursor-backed playback history source', () {
      final encoded = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
        sourceConfig: {
          'source': {'type': 'history', 'historyType': 'live'},
          'shared': true,
        },
      )!;

      expect(SourceConfigCodec.playlistSourceConfigToMap(encoded), {
        'source': {'type': 'history', 'historyType': 'live'},
        'shared': true,
      });
    });
  });

  group('Emby playlist source config', () {
    test('round trips favorite people and person item sources', () {
      final favoritePeople = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        sourceConfig: {
          'serverId': 'emby-main',
          'source': {'type': 'favoritePeople'},
        },
      )!;
      final personItems = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
        sourceConfig: {
          'serverId': 'emby-main',
          'source': {
            'type': 'personItems',
            'personId': 'person-1',
            'itemTypes': ['Movie', 'Episode'],
          },
        },
      )!;

      expect(
        favoritePeople.emby.whichSource(),
        source.EmbyPlaylistSourceConfig_Source.favoritePeople,
      );
      expect(SourceConfigCodec.playlistSourceConfigToMap(personItems), {
        'serverId': 'emby-main',
        'source': {
          'type': 'personItems',
          'personId': 'person-1',
          'itemTypes': ['Movie', 'Episode'],
        },
      });
    });
  });

  group('Live source config', () {
    test('round trips explicit playback kind and RTMP publish mode', () {
      final direct = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
        sourceConfig: {
          'url': 'https://example.test/live.m3u8',
          'playbackKind': 'live',
        },
      )!;
      final rtmp = SourceConfigCodec.mediaSourceConfigFromMap(
        sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_RTMP,
        sourceConfig: {'mode': 'audioOnly'},
      )!;

      expect(
        direct.directUrl.playbackKind,
        source.PlaybackKind.PLAYBACK_KIND_LIVE,
      );
      final directMap = SourceConfigCodec.mediaSourceConfigToMap(direct);
      expect(directMap['url'], 'https://example.test/live.m3u8');
      expect(directMap['playbackKind'], 'live');
      expect(directMap['medias'], [
        {'url': 'https://example.test/live.m3u8'},
      ]);
      expect(rtmp.rtmp.mode, source.RtmpStreamMode.RTMP_STREAM_MODE_AUDIO_ONLY);
      expect(SourceConfigCodec.mediaSourceConfigToMap(rtmp), {
        'mode': 'audioOnly',
      });
    });

    test('round trips RTMP, RTSP, HTTP-FLV, and WHEP pull sources', () {
      final cases = <Map<String, dynamic>>[
        {
          'source': {
            'protocol': 'rtmp',
            'url': 'rtmp://example.test/live/stream',
            'mode': 'videoOnly',
          },
        },
        {
          'source': {
            'protocol': 'rtsp',
            'url': 'rtsp://example.test/camera',
            'transport': 'udp',
            'videoTrack': {'mode': 'index', 'index': 2},
            'audioTrack': {'mode': 'disabled'},
          },
        },
        {
          'source': {
            'protocol': 'httpFlv',
            'url': 'https://example.test/live/stream.flv',
          },
        },
        {
          'source': {
            'protocol': 'whep',
            'url': 'https://example.test/live/whep',
            'authorization': 'Bearer upstream-token',
          },
        },
      ];

      for (final sourceConfig in cases) {
        final encoded = SourceConfigCodec.mediaSourceConfigFromMap(
          sourceProvider: source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
          sourceConfig: sourceConfig,
        )!;
        expect(SourceConfigCodec.mediaSourceConfigToMap(encoded), sourceConfig);
      }
    });
  });
}
