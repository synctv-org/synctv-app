import 'package:synctv_app/contracts/public_models.dart';

final class ServerConnectionProfile {
  const ServerConnectionProfile({
    required this.endpoint,
    required this.declaredServerId,
    required this.name,
    required this.isBuiltIn,
    required this.allowInsecureTls,
    this.lastSeenAt,
  });

  final String endpoint;
  final String declaredServerId;
  final String name;
  final bool isBuiltIn;
  final bool allowInsecureTls;
  final DateTime? lastSeenAt;
}

final class ServerConnectionException implements Exception {
  const ServerConnectionException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class ServerConnectionGateway {
  String get serverBaseUrl;

  List<ServerConnectionProfile> get servers;

  ServerConnectionProfile? get activeServer;

  Future<ServerInfo> getServerInfo({bool refresh = false});

  Future<ServerConnectionProfile> addServer(
    String address, {
    bool allowInsecureTls = false,
  });

  Future<void> activateServer(String endpoint);

  Future<void> removeServer(String endpoint);

  Future<void> syncServerTime({bool refresh = false});
}
