import 'package:synctv_app/services/synctv_account_service.dart';
import 'package:synctv_app/services/synctv_admin_service.dart';
import 'package:synctv_app/services/synctv_api_client.dart';
import 'package:synctv_app/services/synctv_auth_service.dart';
import 'package:synctv_app/services/synctv_provider_service.dart';
import 'package:synctv_app/services/synctv_public_room_service.dart';
import 'package:synctv_app/services/synctv_room_management_service.dart';
import 'package:synctv_app/services/synctv_room_media_service.dart';
import 'package:synctv_app/services/synctv_session_store.dart';

class SyncTvDomainServices {
  SyncTvDomainServices({
    required SyncTvApiClient api,
    required SyncTvSessionStore sessionStore,
  }) {
    auth = SyncTvAuthDomainService(api: api, sessionStore: sessionStore);
    account = SyncTvAccountDomainService(api: api, sessionStore: sessionStore);
    notifications = SyncTvNotificationDomainService(api);
    publicRooms = SyncTvPublicRoomDomainService(
      api: api,
      sessionStore: sessionStore,
      authService: auth,
    );
    roomManagement = SyncTvRoomManagementDomainService(api);
    roomMedia = SyncTvRoomMediaDomainService(api);
    providers = SyncTvProviderDomainService(api);
    admin = SyncTvAdminDomainService(api);
  }

  late final SyncTvAuthDomainService auth;
  late final SyncTvAccountDomainService account;
  late final SyncTvNotificationDomainService notifications;
  late final SyncTvPublicRoomDomainService publicRooms;
  late final SyncTvRoomManagementDomainService roomManagement;
  late final SyncTvRoomMediaDomainService roomMedia;
  late final SyncTvProviderDomainService providers;
  late final SyncTvAdminDomainService admin;
}
