import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

class RoomInvite {
  const RoomInvite({required this.roomId, this.serverEndpoint});

  final String roomId;
  final String? serverEndpoint;
}

class RoomInviteService {
  RoomInviteService._();

  static const String linkPath = '/rooms/join';

  static String createInviteLink({
    required SyncTvRoom room,
    required String serverEndpoint,
  }) {
    final uri = Uri.parse(ServerEndpointIdentity.normalize(serverEndpoint));
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

  static bool matchesServerEndpoint({
    required String inviteEndpoint,
    required String serverEndpoint,
  }) {
    return ServerEndpointIdentity.normalize(inviteEndpoint) ==
        ServerEndpointIdentity.normalize(serverEndpoint);
  }

  static String _serverEndpointFromInviteUri(Uri uri) {
    final marker = linkPath;
    final markerIndex = uri.path.lastIndexOf(marker);
    final basePath = markerIndex < 0 ? '' : uri.path.substring(0, markerIndex);
    return ServerEndpointIdentity.normalize(
      Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
        path: basePath,
      ).toString(),
    );
  }
}
