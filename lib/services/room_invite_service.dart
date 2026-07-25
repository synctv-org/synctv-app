import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_session_store.dart';
import 'package:synctv_app/services/synctv_service.dart';

class RoomInvite {
  const RoomInvite({required this.roomId, this.serverEndpoint});

  final String roomId;
  final String? serverEndpoint;
}

class RoomInviteService {
  RoomInviteService._();

  static const String linkPath = '/rooms/join';

  static String createInviteLink(SyncTvRoom room) {
    final activeServer = SyncTvService.activeServer;
    if (activeServer == null) {
      throw SyncTvApiException('请先添加并连接服务器', statusCode: 400);
    }
    final uri = Uri.parse(activeServer.endpoint);
    final basePath = uri.path.endsWith('/')
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
    return uri
        .replace(
          path: '$basePath$linkPath',
          queryParameters: {'room_id': room.roomId},
        )
        .toString();
  }

  static RoomInvite parse(String input) {
    final value = input.trim();
    if (value.isEmpty) {
      throw const FormatException('empty invite');
    }

    final uri = Uri.tryParse(value);
    if (uri != null && uri.hasScheme) {
      final roomId =
          uri.queryParameters['room_id'] ??
          uri.queryParameters['roomId'] ??
          uri.queryParameters['r'];
      if (roomId != null && roomId.trim().isNotEmpty) {
        return RoomInvite(
          roomId: roomId.trim(),
          serverEndpoint: _serverEndpointFromInviteUri(uri),
        );
      }

      final segments = uri.pathSegments;
      if (segments.length >= 2 && segments[0] == 'rooms') {
        return RoomInvite(
          roomId: segments.last,
          serverEndpoint: _serverEndpointFromInviteUri(uri),
        );
      }
    }

    return RoomInvite(roomId: value);
  }

  static List<SyncTvServerProfile> matchingServers(String? endpoint) {
    final value = endpoint?.trim();
    if (value == null || value.isEmpty) return const [];
    final normalized = SyncTvApiClient.normalizeBaseUrl(value);
    return SyncTvService.servers
        .where((server) => server.endpoint == normalized)
        .toList(growable: false);
  }

  static String _serverEndpointFromInviteUri(Uri uri) {
    final marker = linkPath;
    final markerIndex = uri.path.lastIndexOf(marker);
    final basePath = markerIndex < 0 ? '' : uri.path.substring(0, markerIndex);
    return SyncTvApiClient.normalizeBaseUrl(
      Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
        path: basePath,
      ).toString(),
    );
  }
}
