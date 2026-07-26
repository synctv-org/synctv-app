import 'package:synctv_app/features/home/application/home_gateway.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

class SyncTvHomeGateway implements HomeGateway {
  const SyncTvHomeGateway();

  @override
  Stream<void> get authErrors => SyncTvService.onAuthError;

  @override
  bool get hasServer => SyncTvService.activeServer != null;

  @override
  bool get hasRecoverableSession => SyncTvService.hasRecoverableSession;

  @override
  bool get isGuestSession => SyncTvService.isGuestSession;

  @override
  String? get guestRoomId => SyncTvService.guestRoomId;

  @override
  Future<SyncTvUser> getCurrentUser() => SyncTvService.getMe();

  @override
  Future<List<RoomCategoryInfo>> listRoomCategories({bool refresh = false}) {
    return SyncTvService.listRoomCategories(refresh: refresh);
  }

  @override
  Future<List<RoomLabelInfo>> listRoomLabels({bool refresh = false}) {
    return SyncTvService.listRoomLabels(refresh: refresh);
  }

  @override
  Future<RoomDiscoveryPage> discoverRooms({
    required int page,
    required int pageSize,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
  }) {
    return SyncTvService.discoverRooms(
      page: page,
      pageSize: pageSize,
      search: search,
      categoryId: categoryId,
      labelIds: labelIds,
    );
  }

  @override
  Future<RoomsPage> getJoinedRooms({required int page, required int pageSize}) {
    return SyncTvService.getMyRoomsPage(page: page, pageSize: pageSize);
  }

  @override
  Future<SyncTvRoom> getRoom(String roomId) {
    return SyncTvService.getRoomDiscovery(roomId);
  }

  @override
  Future<JoinRoomResult> joinRoom(String roomId, String password) {
    return SyncTvService.joinRoom(roomId, password);
  }

  @override
  Future<void> deleteRoom(String roomId) => SyncTvService.deleteRoom(roomId);

  @override
  Future<SyncTvRoom> favoriteRoom(String roomId) {
    return SyncTvService.favoriteRoom(roomId);
  }

  @override
  Future<SyncTvRoom> unfavoriteRoom(String roomId) {
    return SyncTvService.unfavoriteRoom(roomId);
  }

  @override
  Future<void> logout() => SyncTvService.logout();
}
