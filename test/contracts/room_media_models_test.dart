import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

void main() {
  test('media library counts provider dynamic entries in scope summary', () {
    final page = RoomMediaLibraryPage(
      playlists: const [],
      media: const [],
      dynamicItems: [
        RoomDynamicMediaEntry(
          id: 'playlist',
          name: 'Playlist',
          parentId: 'playlist',
          subPath: 'playlist',
          isPlaylist: true,
        ),
        RoomDynamicMediaEntry(
          id: 'media',
          name: 'Media',
          parentId: 'playlist',
          subPath: 'media',
          isPlaylist: false,
        ),
      ],
      currentPath: const [],
      total: 5,
      playlistCount: 1,
      fileCount: 2,
      version: 'v1',
      usesCursor: false,
      nextCursor: '',
      page: 1,
      supportsSearch: true,
    );

    expect(page.effectivePlaylistCount, 2);
    expect(page.effectiveFileCount, 3);
  });

  test('only active user messages are editable by their sender', () {
    RoomChatMessageInfo message({
      required String userId,
      required client_enum.ChatMessageType messageType,
      int deletedAt = 0,
    }) => RoomChatMessageInfo(
      id: '1',
      roomId: 'room_1',
      userId: userId,
      username: 'user',
      content: 'message',
      timestamp: 1,
      messageType: messageType,
      deletedAt: deletedAt,
    );

    final userMessage = message(
      userId: 'usr_1',
      messageType: client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
    );
    final systemMessage = message(
      userId: 'usr_1',
      messageType:
          client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED,
    );

    expect(userMessage.canEditBy('usr_1'), isTrue);
    expect(userMessage.canEditBy('usr_2'), isFalse);
    expect(systemMessage.canEditBy('usr_1'), isFalse);
    expect(
      message(
        userId: 'usr_1',
        messageType: client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
        deletedAt: 2,
      ).canEditBy('usr_1'),
      isFalse,
    );
  });
}
