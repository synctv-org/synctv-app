import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/home/domain/home_room_access.dart';

void main() {
  test('anonymous users use the room-supported authentication mode', () {
    expect(
      roomAuthenticationMode(
        identity: HomeIdentityKind.anonymous,
        guestAccess: true,
        guestBoundToRoom: false,
      ),
      RoomAuthenticationMode.guest,
    );
    expect(
      roomAuthenticationMode(
        identity: HomeIdentityKind.anonymous,
        guestAccess: false,
        guestBoundToRoom: false,
      ),
      RoomAuthenticationMode.account,
    );
  });

  test('guests can reuse only the token bound to the selected room', () {
    expect(
      roomAuthenticationMode(
        identity: HomeIdentityKind.guest,
        guestAccess: true,
        guestBoundToRoom: true,
      ),
      RoomAuthenticationMode.none,
    );
    expect(
      roomAuthenticationMode(
        identity: HomeIdentityKind.guest,
        guestAccess: true,
        guestBoundToRoom: false,
      ),
      RoomAuthenticationMode.guest,
    );
  });

  test('guests use account authentication for sign-in rooms', () {
    expect(
      roomAuthenticationMode(
        identity: HomeIdentityKind.guest,
        guestAccess: false,
        guestBoundToRoom: false,
      ),
      RoomAuthenticationMode.account,
    );
  });

  test('account users enter without another authentication prompt', () {
    expect(
      roomAuthenticationMode(
        identity: HomeIdentityKind.account,
        guestAccess: false,
        guestBoundToRoom: false,
      ),
      RoomAuthenticationMode.none,
    );
  });
}
