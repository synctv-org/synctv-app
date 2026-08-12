import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

enum RoomAuthenticationMode { ready, guest, account }

RoomAuthenticationMode roomAuthenticationMode({
  required SyncTvSessionIdentity identity,
  required String roomId,
  required client_enum.RoomDiscoveryAccess discoveryAccess,
}) {
  final guestAccess =
      discoveryAccess ==
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST;
  return switch (identity) {
    AccountSessionIdentity() => RoomAuthenticationMode.ready,
    AnonymousSessionIdentity() =>
      guestAccess
          ? RoomAuthenticationMode.guest
          : RoomAuthenticationMode.account,
    GuestSessionIdentity() =>
      guestAccess
          ? (identity.roomId == roomId
                ? RoomAuthenticationMode.ready
                : RoomAuthenticationMode.guest)
          : RoomAuthenticationMode.account,
  };
}
