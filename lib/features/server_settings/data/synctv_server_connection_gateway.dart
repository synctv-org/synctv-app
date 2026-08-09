import 'package:synctv_app/features/server_settings/application/server_connection_gateway.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';

final class SyncTvServerConnectionGateway implements ServerConnectionGateway {
  const SyncTvServerConnectionGateway();

  @override
  String get serverBaseUrl => SyncTvService.baseUrl;

  @override
  List<ServerConnectionProfile> get servers =>
      SyncTvService.servers.map(_toConnectionProfile).toList(growable: false);

  @override
  ServerConnectionProfile? get activeServer =>
      switch (SyncTvService.activeServer) {
        final profile? => _toConnectionProfile(profile),
        null => null,
      };

  @override
  Future<ServerInfo> getServerInfo({bool refresh = false}) =>
      SyncTvService.getServerInfo(refresh: refresh);

  @override
  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  }) async {
    try {
      return _toConnectionProfile(
        await SyncTvService.addServer(
          address,
          allowInsecureTls: allowInsecureTls,
        ),
      );
    } on SyncTvApiException catch (error) {
      throw ServerConnectionException(error.message);
    }
  }

  @override
  Future<void> activateServer(String endpoint) =>
      SyncTvService.activateServer(endpoint);

  @override
  Future<void> removeServer(String endpoint) =>
      SyncTvService.removeServer(endpoint);

  @override
  Future<void> syncServerTime({bool refresh = false}) =>
      SyncTvService.syncServerTime(refresh: refresh);
}

ServerConnectionProfile _toConnectionProfile(SyncTvServerProfile profile) =>
    ServerConnectionProfile(
      endpoint: profile.endpoint,
      declaredServerId: profile.declaredServerId,
      name: profile.name,
      isBuiltIn: profile.isBuiltIn,
      allowInsecureTls: profile.allowInsecureTls,
      lastSeenAt: profile.lastSeenAt,
    );
