import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/source_config_codec.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;

void main() {
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
              sourceProvider: 'bilibili',
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
        sourceProvider: 'bilibili',
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
        sourceProvider: 'bilibili',
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
        sourceProvider: 'bilibili',
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
        sourceProvider: 'emby',
        sourceConfig: {
          'serverId': 'emby-main',
          'source': {'type': 'favoritePeople'},
        },
      )!;
      final personItems = SourceConfigCodec.playlistSourceConfigFromMap(
        sourceProvider: 'emby',
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
}
