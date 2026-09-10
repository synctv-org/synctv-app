import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/permission_bits.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

void main() {
  test('guest permission masks retain their high bits on every platform', () {
    expect(RoomGuestPermissions.viewMembers, 4294967296);
    expect(RoomGuestPermissions.all, 64424509440);
    final settings = SyncTvRoomSettings(
      guestAddedPermissions: RoomGuestPermissions.all,
      guestRemovedPermissions: RoomGuestPermissions.viewMembers,
    );
    expect(settings.effectiveGuestPermissions, 60129542144);
    expect(
      PermissionBits.contains(
        settings.effectiveGuestPermissions,
        RoomGuestPermissions.viewMembers,
      ),
      isFalse,
    );
    expect(
      PermissionBits.contains(
        settings.effectiveGuestPermissions,
        RoomGuestPermissions.useP2pMedia,
      ),
      isTrue,
    );
    expect(
      PermissionBits.add(
        settings.effectiveGuestPermissions,
        RoomGuestPermissions.viewMembers,
      ),
      RoomGuestPermissions.all,
    );
    expect(
      PermissionBits.remove(RoomGuestPermissions.all, RoomGuestPermissions.all),
      0,
    );
    expect(
      PermissionBits.add(1, RoomGuestPermissions.useP2pMedia),
      34359738369,
    );
  });
}
