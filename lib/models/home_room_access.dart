enum HomeIdentityKind { anonymous, guest, account }

enum RoomAuthenticationMode { none, guest, account }

RoomAuthenticationMode roomAuthenticationMode({
  required HomeIdentityKind identity,
  required bool guestAccess,
  required bool guestBoundToRoom,
}) {
  return switch (identity) {
    HomeIdentityKind.account => RoomAuthenticationMode.none,
    HomeIdentityKind.anonymous =>
      guestAccess
          ? RoomAuthenticationMode.guest
          : RoomAuthenticationMode.account,
    HomeIdentityKind.guest =>
      guestAccess
          ? (guestBoundToRoom
                ? RoomAuthenticationMode.none
                : RoomAuthenticationMode.guest)
          : RoomAuthenticationMode.account,
  };
}
