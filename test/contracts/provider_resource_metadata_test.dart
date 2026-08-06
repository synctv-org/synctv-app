import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  final api = SyncTvApiClient(
    baseUrl: 'https://example.test',
    session: SyncTvSession(),
  );

  test('preserves provider metadata on resource metadata', () {
    final metadata = client.ResourceMetadata()
      ..mergeFromProto3Json({
        'source': '/api/media/med_1/stream',
        'provider': {
          'youtube': {
            'videoId': 'video-1',
            'channelId': 'channel-1',
            'channelName': 'Channel',
            'description': 'Description',
            'isLive': true,
          },
        },
      });

    expect(resourceMetadataToJson(metadata), {
      'source': '/api/media/med_1/stream',
      'provider': {
        'youtube': {
          'videoId': 'video-1',
          'channelId': 'channel-1',
          'channelName': 'Channel',
          'description': 'Description',
          'isLive': true,
        },
      },
    });
  });

  test('provider playback kinds remain typed across protobuf and JSON', () {
    final cases = <(client.PlaybackMetadata, String, String)>[
      (
        client.PlaybackMetadata(
          bilibili: client.BilibiliPlaybackMetadata(
            kind: client.BilibiliPlaybackKind.BILIBILI_PLAYBACK_KIND_PGC,
          ),
        ),
        'bilibili',
        'BILIBILI_PLAYBACK_KIND_PGC',
      ),
      (
        client.PlaybackMetadata(
          douyin: client.DouyinPlaybackMetadata(
            kind: client.DouyinPlaybackKind.DOUYIN_PLAYBACK_KIND_LIVE,
          ),
        ),
        'douyin',
        'DOUYIN_PLAYBACK_KIND_LIVE',
      ),
      (
        client.PlaybackMetadata(
          emby: client.EmbyPlaybackMetadata(
            kind: client.EmbyPlaybackKind.EMBY_PLAYBACK_KIND_MUSIC_ALBUM,
          ),
        ),
        'emby',
        'EMBY_PLAYBACK_KIND_MUSIC_ALBUM',
      ),
      (
        client.PlaybackMetadata(
          tiktok: client.TikTokPlaybackMetadata(
            kind: client.TikTokPlaybackKind.TIK_TOK_PLAYBACK_KIND_VIDEO,
          ),
        ),
        'tiktok',
        'TIK_TOK_PLAYBACK_KIND_VIDEO',
      ),
      (
        client.PlaybackMetadata(
          synology: client.SynologyPlaybackMetadata(
            kind: source_enum
                .SynologyLibraryItemKind
                .SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING,
          ),
        ),
        'synology',
        'SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING',
      ),
    ];

    for (final (metadata, provider, expectedKind) in cases) {
      final json = protoMessageToJsonMap(metadata);
      expect((json[provider] as Map)['kind'], expectedKind);
      expect((json[provider] as Map).containsKey('contentType'), isFalse);
    }
  });

  test('provider live metadata marks static media as live', () {
    final media = client.Media()
      ..mergeFromProto3Json({
        'id': 'med_1',
        'roomId': 'room_1',
        'name': 'Live video',
        'metadata': {
          'provider': {
            'youtube': {
              'videoId': 'video-1',
              'channelId': 'channel-1',
              'channelName': 'Channel',
              'description': '',
              'isLive': true,
            },
          },
        },
      });

    final mapped = api.mapMedia(media);
    expect(mapped.live, isTrue);
    expect(mapped.metadata['provider'], isA<Map>());
  });

  test(
    'provider current live state is explicit and keeps live semantics offline',
    () {
      final metadata = client.ResourceMetadata()
        ..mergeFromProto3Json({
          'provider': {
            'bilibili': {
              'roomId': '21292831',
              'isLive': true,
              'isCurrentlyLive': false,
            },
          },
        });
      final liveState = resourceMetadataLiveState(metadata);

      expect(liveState.isLive, isTrue);
      expect(liveState.isCurrentlyLive, isFalse);

      final media = client.Media()
        ..mergeFromProto3Json({
          'id': 'med_offline_live',
          'roomId': 'room_1',
          'name': 'Offline live source',
          'metadata': {
            'provider': {
              'bilibili': {
                'roomId': '21292831',
                'isLive': true,
                'isCurrentlyLive': false,
              },
            },
          },
        });

      final mapped = api.mapMedia(media);
      expect(mapped.live, isTrue);
      expect(
        mapped.liveStreamAvailability,
        SyncTvLiveStreamAvailability.offline,
      );
    },
  );

  test('preserves provider metadata on playlists and dynamic items', () {
    final playlist = client.Playlist()
      ..mergeFromProto3Json({
        'id': 'pl_1',
        'roomId': 'room_1',
        'name': 'Live playlist',
        'isDynamic': true,
        'metadata': {
          'provider': {
            'bilibili': {'roomId': '21292831'},
          },
        },
      });
    final playlistEntry = api.mapPlaylist(playlist);

    final item =
        client.PlaylistItem(
          name: 'Live item',
          target: client.ProviderTarget(
            alist: client.AlistTarget(relativePath: '/live/item'),
          ),
        )..mergeFromProto3Json({
          'itemType': 'ITEM_TYPE_MEDIA',
          'metadata': {
            'provider': {
              'youtube': {
                'videoId': 'video-2',
                'channelId': 'channel-2',
                'channelName': 'Channel 2',
                'description': '',
                'isLive': true,
              },
            },
          },
        });
    final itemEntry = api.mapDynamicItem(item, playlistId: playlist.id);

    expect(playlistEntry.metadata['isDynamic'], isTrue);
    expect((playlistEntry.metadata['provider'] as Map)['bilibili'], {
      'roomId': '21292831',
    });
    expect(itemEntry.metadata['provider'], {
      'youtube': {
        'videoId': 'video-2',
        'channelId': 'channel-2',
        'channelName': 'Channel 2',
        'description': '',
        'isLive': true,
      },
    });
    expect(itemEntry.live, isTrue);
  });

  test('reads live state from every provider-owned live metadata variant', () {
    for (final providerJson in <Map<String, dynamic>>[
      {
        'bilibili': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'twitch': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'youtube': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'douyin': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'tiktok': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'huya': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'douyu': {'isLive': true, 'isCurrentlyLive': false},
      },
      {
        'acFun': {'isLive': true, 'isCurrentlyLive': false},
      },
    ]) {
      final metadata = client.ResourceMetadata()
        ..mergeFromProto3Json({'provider': providerJson});

      expect(resourceMetadataLiveState(metadata), (
        isLive: true,
        isCurrentlyLive: false,
      ), reason: providerJson.keys.single);
    }
  });

  test(
    'maps generic live availability while preserving live resource type',
    () {
      for (final entry in <(String, bool?)>[
        ('LIVE_STREAM_AVAILABILITY_LIVE', true),
        ('LIVE_STREAM_AVAILABILITY_OFFLINE', false),
        ('LIVE_STREAM_AVAILABILITY_UNSPECIFIED', null),
      ]) {
        final metadata = client.ResourceMetadata()
          ..mergeFromProto3Json({
            'provider': {
              'live': {'availability': entry.$1},
            },
          });

        expect(resourceMetadataLiveState(metadata), (
          isLive: true,
          isCurrentlyLive: entry.$2,
        ));
      }
    },
  );
}
