import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

class ServerInfo {
  final String serverId;
  final String serverName;

  /// Realtime transports the server advertises, in the server's preference
  /// order. Empty on servers that do not advertise (older versions): callers
  /// fall back to their platform default.
  final List<client_enum.RealtimeTransportKind> realtimeTransports;

  /// Base64 SHA-256 of the WebTransport listener certificate, advertised so
  /// self-signed deployments work without manual pinning. Null when the
  /// server does not advertise one (or has no WebTransport transport).
  final String? webTransportCertificateHash;

  const ServerInfo({
    required this.serverId,
    required this.serverName,
    this.realtimeTransports = const [],
    this.webTransportCertificateHash,
  });
}

enum AuthPolicyHint {
  passwordReview,
  emailReview,
  passkeyReview,
  emailWhitelist,
  guestDisabled,
}

class PublicSettingsInfo {
  final bool roomCreationEnabled;
  final int maxRoomsPerUser;
  final int defaultMaxMembers;
  final bool roomCreationApprovalRequired;
  final common.RoomPasswordPolicy roomPasswordPolicy;
  final bool enablePasswordSignup;
  final bool passwordSignupNeedReview;
  final bool enableEmailSignup;
  final bool enableEmail;
  final bool enableGuest;
  final bool emailSignupNeedReview;
  final bool enableWebauthn;
  final String webauthnRpId;
  final bool enableWebauthnSignup;
  final bool webauthnSignupNeedReview;
  final bool emailWhitelistEnabled;
  final List<String> emailWhitelistDomains;
  final bool tsDisguisedAsPng;
  final String? rtmpAdvertiseAddress;

  const PublicSettingsInfo({
    required this.roomCreationEnabled,
    required this.maxRoomsPerUser,
    required this.defaultMaxMembers,
    required this.roomCreationApprovalRequired,
    required this.roomPasswordPolicy,
    required this.enablePasswordSignup,
    required this.passwordSignupNeedReview,
    required this.enableEmailSignup,
    required this.enableEmail,
    required this.enableGuest,
    required this.emailSignupNeedReview,
    required this.enableWebauthn,
    required this.webauthnRpId,
    required this.enableWebauthnSignup,
    required this.webauthnSignupNeedReview,
    required this.emailWhitelistEnabled,
    required this.emailWhitelistDomains,
    required this.tsDisguisedAsPng,
    required this.rtmpAdvertiseAddress,
  });

  List<AuthPolicyHint> get authPolicyHints {
    final hints = <AuthPolicyHint>[];
    if (passwordSignupNeedReview && enablePasswordSignup) {
      hints.add(AuthPolicyHint.passwordReview);
    }
    if (emailSignupNeedReview && enableEmailSignup) {
      hints.add(AuthPolicyHint.emailReview);
    }
    if (webauthnSignupNeedReview && enableWebauthnSignup) {
      hints.add(AuthPolicyHint.passkeyReview);
    }
    if (emailWhitelistEnabled) {
      hints.add(AuthPolicyHint.emailWhitelist);
    }
    if (!enableGuest) {
      hints.add(AuthPolicyHint.guestDisabled);
    }
    return List.unmodifiable(hints);
  }
}

class RoomsPage {
  final List<SyncTvRoom> rooms;
  final int total;
  final int page;
  final int pageSize;

  const RoomsPage({
    required this.rooms,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class RoomDiscoveryPage {
  final List<SyncTvRoom> featuredRooms;
  final List<SyncTvRoom> rooms;
  final int total;
  final int page;
  final int pageSize;

  const RoomDiscoveryPage({
    required this.featuredRooms,
    required this.rooms,
    required this.total,
    required this.page,
    required this.pageSize,
  });
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
