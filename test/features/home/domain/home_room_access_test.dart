import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/home/domain/home_room_access.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

void main() {
  const guestIdentity = GuestSessionIdentity(
    accessToken: 'guest-token',
    roomId: 'room_1',
    displayName: 'Guest',
  );

  test('anonymous users use the room-supported authentication mode', () {
    expect(
      roomAuthenticationMode(
        identity: const AnonymousSessionIdentity(),
        roomId: 'room_1',
        discoveryAccess: client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST,
      ),
      RoomAuthenticationMode.guest,
    );
    expect(
      roomAuthenticationMode(
        identity: const AnonymousSessionIdentity(),
        roomId: 'room_1',
        discoveryAccess:
            client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_SIGN_IN,
      ),
      RoomAuthenticationMode.account,
    );
  });

  test('guests can reuse only the token bound to the selected room', () {
    expect(
      roomAuthenticationMode(
        identity: guestIdentity,
        roomId: 'room_1',
        discoveryAccess: client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST,
      ),
      RoomAuthenticationMode.ready,
    );
    expect(
      roomAuthenticationMode(
        identity: guestIdentity,
        roomId: 'room_2',
        discoveryAccess: client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST,
      ),
      RoomAuthenticationMode.guest,
    );
  });

  test('guests use account authentication for sign-in rooms', () {
    expect(
      roomAuthenticationMode(
        identity: guestIdentity,
        roomId: 'room_1',
        discoveryAccess:
            client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_SIGN_IN,
      ),
      RoomAuthenticationMode.account,
    );
  });

  test('account users enter without another authentication prompt', () {
    expect(
      roomAuthenticationMode(
        identity: const AccountSessionIdentity(),
        roomId: 'room_1',
        discoveryAccess:
            client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_SIGN_IN,
      ),
      RoomAuthenticationMode.ready,
    );
  });
}
