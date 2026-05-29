import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/watch_together_service.dart';

class RoomInvite {
  const RoomInvite({
    required this.roomId,
    this.serverId,
  });

  final String roomId;
  final String? serverId;
}

class RoomInviteService {
  RoomInviteService._();

  static const String linkPath = '/rooms/join';

  static String createInviteLink(WRoom room) {
    final activeServer = WatchTogetherService.activeServer;
    if (activeServer == null) {
      throw SyncTvApiException('请先添加并连接服务器', statusCode: 400);
    }
    final uri = Uri.parse(activeServer.activeEndpoint);
    final query = <String, String>{
      'room_id': room.roomId,
      if (!activeServer.isPending) 'server_id': activeServer.serverId,
    };
    return uri.replace(path: linkPath, queryParameters: query).toString();
  }

  static RoomInvite parse(String input) {
    final value = input.trim();
    if (value.isEmpty) {
      throw const FormatException('empty invite');
    }

    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      final roomId = uri.queryParameters['room_id'] ??
          uri.queryParameters['roomId'] ??
          uri.queryParameters['r'];
      if (roomId != null && roomId.trim().isNotEmpty) {
        return RoomInvite(
          roomId: roomId.trim(),
          serverId: _clean(uri.queryParameters['server_id'] ??
              uri.queryParameters['serverId'] ??
              uri.queryParameters['s']),
        );
      }

      final segments = uri.pathSegments;
      if (segments.length >= 2 && segments[0] == 'rooms') {
        return RoomInvite(
          roomId: segments.last,
          serverId: _clean(uri.queryParameters['server_id'] ??
              uri.queryParameters['serverId'] ??
              uri.queryParameters['s']),
        );
      }
    }

    return RoomInvite(roomId: value);
  }

  static List<SyncTvServerProfile> matchingServers(String? serverId) {
    final id = serverId?.trim();
    if (id == null || id.isEmpty) return const [];
    return WatchTogetherService.servers
        .where((server) => server.serverId == id)
        .toList(growable: false);
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
