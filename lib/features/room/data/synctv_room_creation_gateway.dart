import 'package:synctv_app/features/room/application/room_creation_gateway.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

final class SyncTvRoomCreationGateway implements RoomCreationGateway {
  const SyncTvRoomCreationGateway();

  @override
  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false}) =>
      SyncTvService.getPublicSettings(refresh: refresh);

  @override
  Future<List<RoomCategoryInfo>> listCategories({bool refresh = false}) =>
      SyncTvService.listRoomCategories(refresh: refresh);

  @override
  Future<List<RoomLabelInfo>> listLabels({bool refresh = false}) =>
      SyncTvService.listRoomLabels(refresh: refresh);

  @override
  Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
    bool isPublic = true,
  }) => SyncTvService.createRoom(
    name,
    password: password,
    description: description,
    categoryId: categoryId,
    labelIds: labelIds,
    isPublic: isPublic,
  );
}
