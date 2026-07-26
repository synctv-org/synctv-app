import 'package:synctv_app/data/synctv_api/synctv_account_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_admin_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_auth_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_file_upload_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_memory_cache.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_public_room_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_management_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_room_media_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';

class SyncTvDomainServices {
  SyncTvDomainServices({
    required SyncTvApiClient api,
    required SyncTvSessionStore sessionStore,
  }) {
    cache = SyncTvMemoryCache();
    auth = SyncTvAuthDomainService(api: api, sessionStore: sessionStore);
    account = SyncTvAccountDomainService(
      api: api,
      sessionStore: sessionStore,
      cache: cache,
    );
    notifications = SyncTvNotificationDomainService(api, cache: cache);
    publicRooms = SyncTvPublicRoomDomainService(
      api: api,
      sessionStore: sessionStore,
      authService: auth,
      cache: cache,
    );
    roomManagement = SyncTvRoomManagementDomainService(api, cache: cache);
    roomMedia = SyncTvRoomMediaDomainService(api);
    fileUploads = SyncTvFileUploadDomainService(api);
    providers = SyncTvProviderDomainService(api);
    admin = SyncTvAdminDomainService(api, cache: cache);
  }

  late final SyncTvMemoryCache cache;
  late final SyncTvAuthDomainService auth;
  late final SyncTvAccountDomainService account;
  late final SyncTvNotificationDomainService notifications;
  late final SyncTvPublicRoomDomainService publicRooms;
  late final SyncTvRoomManagementDomainService roomManagement;
  late final SyncTvRoomMediaDomainService roomMedia;
  late final SyncTvFileUploadDomainService fileUploads;
  late final SyncTvProviderDomainService providers;
  late final SyncTvAdminDomainService admin;
}
