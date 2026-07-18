import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_config;

void main() {
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
      ],
      folderCount: Int64.ONE,
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

    expect(decoded.mediaLibrary?.playlists.single.sourceProvider, 'bilibili');
    expect(decoded.mediaLibrary?.media.single.sourceProvider, 'directUrl');
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
            "folderCount": "1",
            "fileCount": "1",
            "version": "v1"
          }
        }
      }
    ''');

    final decoded = RoomRealtimeCodec.decode(
      Uint8List.fromList(decodedMessage.writeToBuffer()),
    );

    expect(decoded.mediaLibrary?.playlists.single.sourceProvider, 'bilibili');
    expect(decoded.mediaLibrary?.media.single.sourceProvider, 'directUrl');
  });
}
