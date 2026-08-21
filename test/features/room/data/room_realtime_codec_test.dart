import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config_pb;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_config;

void main() {
  test('room presence keeps member and guest counts separate', () {
    final encoded = client.ServerMessage(
      resourceEvent: client.ResourceEvent(
        observeId: 'online_count',
        onlineCount: client.OnlineCount(
          onlineMemberCount: 4,
          onlineGuestCount: 3,
        ),
      ),
    ).writeToBuffer();

    final decoded = RoomRealtimeCodec.decode(Uint8List.fromList(encoded));

    expect(decoded.kind, RoomRealtimeMessageKind.presenceCount);
    expect(decoded.onlineMemberCount, 4);
    expect(decoded.onlineGuestCount, 3);
  });

  test('playback errors preserve their client operation id', () {
    final encoded = client.ServerMessage(
      error: client.ErrorMessage(
        message: 'clock skew',
        code: 1001,
        clientOperationId: '3d918f61-3959-49ef-a962-5d94b8ac8470',
      ),
    ).writeToBuffer();

    final decoded = RoomRealtimeCodec.decode(Uint8List.fromList(encoded));

    expect(
      decoded.error?.clientOperationId,
      '3d918f61-3959-49ef-a962-5d94b8ac8470',
    );
  });

  test('empty playback state clears the authoritative playback source', () {
    final encoded = client.ServerMessage(
      resourceEvent: client.ResourceEvent(
        observeId: 'playback_state',
        playbackState: client.PlaybackState(
          isPlaying: false,
          position: 0,
          speed: 1,
          version: Int64(9),
        ),
      ),
    ).writeToBuffer();

    final decoded = RoomRealtimeCodec.decode(Uint8List.fromList(encoded));
    final status = decoded.playbackStatus!;

    expect(decoded.kind, RoomRealtimeMessageKind.status);
    expect(status.entry, isNull);
    expect(status.playingMediaId, isEmpty);
    expect(status.playingPlaylistId, isEmpty);
    expect(status.isPlaying, isFalse);
    expect(status.version, 9);
  });

  test('system chat messages use the product identity', () {
    expect(
      chatMessageDisplayUsername(
        messageType: client_enum
            .ChatMessageType
            .CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED,
        username: null,
      ),
      'SyncTV',
    );
    expect(
      chatMessageDisplayUsername(
        messageType: client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
        username: null,
        missingUsername: 'Deleted user',
      ),
      'Deleted user',
    );
  });

  test(
    'playback history observation and snapshot preserve public cursor ids',
    () {
      final observe = client.ClientMessage.fromBuffer(
        RoomRealtimeCodec.encodePlaybackHistoryObservation(
          observeId: 'manage_playback_history',
          version: '42',
        ),
      );
      expect(
        observe.observeResource.playbackHistory.afterEventSequence,
        Int64(42),
      );

      final message = client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'manage_playback_history',
          playbackHistory: client.ListPlaybackHistoryResponse(
            historyCursorId: 'ph_current',
            entries: [
              client.PlaybackHistoryEntry(id: 'ph_current', mediaId: 'med_1'),
            ],
          ),
        ),
      );
      final decoded = RoomRealtimeCodec.decode(
        Uint8List.fromList(message.writeToBuffer()),
      );
      expect(decoded.playbackHistory?.historyCursorId, 'ph_current');
      expect(decoded.playbackHistory?.entries.single.id, 'ph_current');
    },
  );

  test('playlist realtime snapshot preserves source providers', () {
    final response = client.ListPlaylistItemsResponse(
      playlists: [
        client.Playlist(
          id: 'pl_1',
          name: 'Dynamic',
          isDynamic: true,
          sourceProvider: source_config.SourceProvider.SOURCE_PROVIDER_BILIBILI,
        ),
      ],
      media: [
        client.Media(
          id: 'med_1',
          name: 'Direct',
          sourceProvider:
              source_config.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
        ),
        client.Media(
          id: 'med_2',
          name: 'TikTok Live',
          sourceProvider: source_config.SourceProvider.SOURCE_PROVIDER_TIKTOK,
          sourceConfig: source_config_pb.MediaSourceConfig(
            tiktok: source_config_pb.TikTokMediaSourceConfig(
              live: source_config_pb.TikTokLiveSourceConfig(
                uniqueId: 'creator',
              ),
            ),
          ),
        ),
      ],
      dynamicItems: [
        client.PlaylistItem(
          name: 'Live dynamic item',
          itemType: client_enum.ItemType.ITEM_TYPE_MEDIA,
          target: client.ProviderTarget(
            alist: client.AlistTarget(relativePath: '/live/item'),
          ),
          metadata: client.ResourceMetadata(
            provider: client.PlaybackMetadata(
              youtube: client.YoutubePlaybackMetadata(
                videoId: 'video-1',
                channelId: 'channel-1',
                channelName: 'Channel',
                description: '',
                isLive: true,
              ),
            ),
          ),
        ),
      ],
      playlistCount: Int64.ONE,
      fileCount: Int64.ONE,
      version: 'v1',
    );
    final message = client.ServerMessage(
      resourceEvent: client.ResourceEvent(
        observeId: 'manage_playlist_items_1',
        playlistItems: response,
      ),
    );

    final decoded = RoomRealtimeCodec.decode(
      Uint8List.fromList(message.writeToBuffer()),
    );

    expect(
      decoded.mediaLibrary?.playlists.single.sourceProvider,
      source_config.SourceProvider.SOURCE_PROVIDER_BILIBILI,
    );
    expect(
      decoded.mediaLibrary?.media.first.sourceProvider,
      source_config.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
    );
    expect(
      decoded.mediaLibrary?.media.last.sourceProvider,
      source_config.SourceProvider.SOURCE_PROVIDER_TIKTOK,
    );
    expect(decoded.mediaLibrary?.media.last.live, isTrue);
    expect(decoded.mediaLibrary?.dynamicItems.single.live, isTrue);
    expect(
      decoded.mediaLibrary?.dynamicItems.single.metadata['provider'],
      isA<Map>(),
    );
  });

  test('playlist observation encodes the requested page', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodePlaylistObservation(
        playlistId: 'pl_1',
        page: 3,
        pageSize: 20,
        search: 'movie',
      ),
    );

    final request = message.observeResource.playlistItems.request;
    expect(request.page.page, 3);
    expect(request.pageSize, 20);
    expect(request.search, 'movie');
    expect(request.playlistId, 'pl_1');
  });

  test('playlist observation omits pagination when page is unspecified', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodePlaylistObservation(playlistId: 'pl_dynamic'),
    );

    final request = message.observeResource.playlistItems.request;
    expect(
      request.whichPagination(),
      client.ListPlaylistItemsRequest_Pagination.notSet,
    );
    expect(request.pageSize, 100);
  });

  test('playlist observation encodes cursor pagination', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodePlaylistObservation(
        playlistId: 'pl_dynamic',
        cursor: 'next-page',
      ),
    );

    final request = message.observeResource.playlistItems.request;
    expect(
      request.whichPagination(),
      client.ListPlaylistItemsRequest_Pagination.cursor,
    );
    expect(request.cursor.cursor, 'next-page');
  });

  test('empty cursor does not override an explicit page', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodePlaylistObservation(page: 2, cursor: ''),
    );

    final request = message.observeResource.playlistItems.request;
    expect(
      request.whichPagination(),
      client.ListPlaylistItemsRequest_Pagination.page,
    );
    expect(request.page.page, 2);
  });

  test('static playlist response keeps the requested page', () {
    RoomRealtimeCodec.encodePlaylistObservation(
      observeId: 'playlist_page',
      playlistId: 'pl_static',
      page: 4,
    );

    final decoded = RoomRealtimeCodec.decode(
      client.ServerMessage(
        resourceEvent: client.ResourceEvent(
          observeId: 'playlist_page',
          playlistItems: client.ListPlaylistItemsResponse(total: Int64(120)),
        ),
      ).writeToBuffer(),
    );

    expect(decoded.mediaLibrary?.page, 4);
    expect(decoded.mediaLibrary?.usesCursor, isFalse);
  });

  test('playback resource snapshot preserves dynamic target identity', () {
    final target = client.ProviderTarget(
      alist: client.AlistTarget(relativePath: '/video.mp4'),
    );
    final message = client.ServerMessage(
      resourceEvent: client.ResourceEvent(
        observeId: 'playback',
        playback: client.Playback(
          playlistId: 'pl_1',
          roomId: 'room_1',
          name: 'Dynamic video',
          target: target,
          defaultMode: 'direct',
          playbackInfos: [
            MapEntry(
              'direct',
              client.PlaybackInfo(
                medias: [
                  client.PlaybackMedia(
                    name: 'Direct',
                    url: 'https://media.example/video.mp4',
                    format: 'mp4',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final decoded = RoomRealtimeCodec.decode(
      Uint8List.fromList(message.writeToBuffer()),
    );
    final status = decoded.playbackStatus!;
    final encodedTarget = providerTargetToBase64(target);

    expect(status.playingMediaId, isEmpty);
    expect(status.playingPlaylistId, 'pl_1');
    expect(status.entry?.id, encodedTarget);
    expect(status.entry?.parentId, 'pl_1');
    expect(status.entry?.subPath, encodedTarget);
  });

  test('websocket JSON preserves protobuf source provider enum names', () {
    final decodedMessage = SyncTvService.decodeRealtimeMessageJson('''
      {
        "resourceEvent": {
          "observeId": "manage_playlist_items_1",
          "playlistItems": {
            "playlists": [
              {
                "id": "pl_1",
                "name": "Dynamic",
                "isDynamic": true,
                "sourceProvider": "SOURCE_PROVIDER_BILIBILI"
              }
            ],
            "media": [
              {
                "id": "med_1",
                "name": "Direct",
                "sourceProvider": "SOURCE_PROVIDER_DIRECT_URL"
              }
            ],
            "playlistCount": "1",
            "fileCount": "1",
            "version": "v1"
          }
        }
      }
    ''');

    final decoded = RoomRealtimeCodec.decode(
      Uint8List.fromList(decodedMessage.writeToBuffer()),
    );

    expect(
      decoded.mediaLibrary?.playlists.single.sourceProvider,
      source_config.SourceProvider.SOURCE_PROVIDER_BILIBILI,
    );
    expect(
      decoded.mediaLibrary?.media.single.sourceProvider,
      source_config.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
    );
  });
}
