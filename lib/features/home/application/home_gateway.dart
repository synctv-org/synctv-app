import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/contracts/account_models.dart';

abstract interface class HomeGateway {
  Stream<void> get authErrors;

  bool get hasServer;
  SyncTvSessionIdentity get sessionIdentity;
  String? get guestRoomId;

  Future<SyncTvUser> getCurrentUser();

  Future<List<RoomCategoryInfo>> listRoomCategories({bool refresh = false});

  Future<List<RoomLabelInfo>> listRoomLabels({bool refresh = false});

  Future<RoomDiscoveryPage> discoverRooms({
    required int page,
    required int pageSize,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
  });

  Future<RoomsPage> getJoinedRooms({required int page, required int pageSize});

  Future<SyncTvRoom> getRoom(String roomId);

  Future<JoinRoomResult> joinRoom(String roomId, String password);

  Future<void> deleteRoom(String roomId);

  Future<SyncTvRoom> favoriteRoom(String roomId);

  Future<SyncTvRoom> unfavoriteRoom(String roomId);

  Future<void> logout();
}
