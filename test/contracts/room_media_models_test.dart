import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

void main() {
  group('media lifecycle and playlist browse access', () {
    test('creator-inactive entries remain visible but cannot activate', () {
      final media = RoomMediaItem(
        id: 'med_1',
        name: 'Unavailable media',
        url: 'https://example.test/media.mp4',
        availability: client_enum
            .ResourceAvailability
            .RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
      );
      final playlist = RoomPlaylistItem(
        id: 'pl_1',
        name: 'Unavailable playlist',
        creator: 'usr_creator',
        availability: client_enum
            .ResourceAvailability
            .RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
        metadata: const {'isDynamic': true},
      );

      expect(media.isAvailable, isFalse);
      expect(playlist.isAvailable, isFalse);
      expect(playlist.canBrowsePlaylistFor('usr_creator'), isFalse);
    });

    test('default browse access follows static and dynamic playlist kinds', () {
      final staticPlaylist = RoomPlaylistItem(
        id: 'pl_static',
        name: 'Static playlist',
        creator: 'usr_creator',
      );
      final dynamicPlaylist = RoomPlaylistItem(
        id: 'pl_dynamic',
        name: 'Dynamic playlist',
        creator: 'usr_creator',
        metadata: const {'isDynamic': true},
      );

      expect(staticPlaylist.canBrowsePlaylistFor('usr_member'), isTrue);
      expect(staticPlaylist.canBrowsePlaylistFor(''), isFalse);
      expect(dynamicPlaylist.canBrowsePlaylistFor('usr_creator'), isTrue);
      expect(dynamicPlaylist.canBrowsePlaylistFor('usr_member'), isFalse);
    });

    test('room-member mode shares dynamic playlist browsing', () {
      final playlist = RoomPlaylistItem(
        id: 'pl_shared',
        name: 'Shared dynamic playlist',
        creator: 'usr_creator',
        browseAccessMode: client_enum
            .PlaylistBrowseAccessMode
            .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS,
        metadata: const {'isDynamic': true},
      );

      expect(playlist.canBrowsePlaylistFor('usr_member'), isTrue);
      expect(playlist.canBrowsePlaylistFor(''), isFalse);
    });

    test('explicit creator-only mode also restricts static playlists', () {
      final playlist = RoomPlaylistItem(
        id: 'pl_private_static',
        name: 'Creator-only static playlist',
        creator: 'usr_creator',
        browseAccessMode: client_enum
            .PlaylistBrowseAccessMode
            .PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY,
      );

      expect(playlist.canBrowsePlaylistFor('usr_creator'), isTrue);
      expect(playlist.canBrowsePlaylistFor('usr_member'), isFalse);
    });
  });

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
    expect(page.hasNextPage(2), isTrue);
  });

  test('page navigation falls back to page size when total is unavailable', () {
    final fullPage = RoomMediaLibraryPage(
      playlists: const [],
      media: const [],
      dynamicItems: List.generate(
        20,
        (index) => RoomDynamicMediaEntry(
          id: 'media-$index',
          name: 'Media $index',
          parentId: 'playlist',
          subPath: 'media-$index',
          isPlaylist: false,
        ),
      ),
      currentPath: const [],
      total: null,
      playlistCount: 0,
      fileCount: 0,
      version: 'v1',
      usesCursor: false,
      nextCursor: '',
      page: 2,
      supportsSearch: false,
    );
    final partialPage = RoomMediaLibraryPage(
      playlists: const [],
      media: const [],
      dynamicItems: fullPage.dynamicItems.take(5).toList(),
      currentPath: const [],
      total: null,
      playlistCount: 0,
      fileCount: 0,
      version: 'v2',
      usesCursor: false,
      nextCursor: '',
      page: 3,
      supportsSearch: false,
    );

    expect(fullPage.hasNextPage(20), isTrue);
    expect(partialPage.hasNextPage(20), isFalse);
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
