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

    final uri = Uri.parse(value);
    if (!uri.hasScheme) {
      return RoomInvite(roomId: uri.path == linkPath ? _roomId(uri) : value);
    }

    final segments = uri.pathSegments.toList();
    while (segments.isNotEmpty && segments.last.isEmpty) {
      segments.removeLast();
    }
    final hasRoomRoute =
        segments.length >= 2 && segments[segments.length - 2] == 'rooms';

    return RoomInvite(
      roomId: _roomId(uri),
      serverEndpoint: ServerEndpointIdentity.normalize(
        Uri(
          scheme: uri.scheme,
          userInfo: uri.userInfo,
          host: uri.host,
          port: uri.hasPort ? uri.port : null,
          pathSegments: hasRoomRoute
              ? segments.take(segments.length - 2)
              : segments,
        ).toString(),
      ),
    );
  }

  static String _roomId(Uri uri) {
    final segments = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    final hasRoomRoute =
        segments.length >= 2 && segments[segments.length - 2] == 'rooms';
    final roomIds = <String>{};
    for (final key in ['room_id', 'roomId', 'r']) {
      for (final rawId in uri.queryParametersAll[key] ?? const <String>[]) {
        final id = rawId.trim();
        if (id.isEmpty) throw const FormatException('empty invite room');
        roomIds.add(id);
      }
    }
    if (hasRoomRoute && segments.last != 'join') {
      roomIds.add(segments.last.trim());
    }
    if (roomIds.length != 1 || roomIds.single.isEmpty) {
      throw const FormatException('missing or ambiguous invite room');
    }

    return roomIds.single;
  }

  static bool matchesServerEndpoint({
    required String inviteEndpoint,
    required String serverEndpoint,
  }) {
    return ServerEndpointIdentity.normalize(inviteEndpoint) ==
        ServerEndpointIdentity.normalize(serverEndpoint);
  }
}
