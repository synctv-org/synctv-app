import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

abstract interface class RoomCreationGateway {
  Future<PublicSettingsInfo> getPublicSettings({bool refresh = false});

  Future<List<RoomCategoryInfo>> listCategories({bool refresh = false});

  Future<List<RoomLabelInfo>> listLabels({bool refresh = false});

  Future<SyncTvRoom> createRoom(
    String name, {
    String? password,
    String? description,
    String categoryId = '',
    List<String> labelIds = const [],
    bool isPublic = true,
  });
}
