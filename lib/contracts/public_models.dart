import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

class ServerInfo {
  final String serverId;
  final String serverName;

  const ServerInfo({required this.serverId, required this.serverName});
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

  List<String> get authPolicyHints {
    final hints = <String>[];
    if (passwordSignupNeedReview && enablePasswordSignup) {
      hints.add('密码注册需要管理员审核');
    }
    if (emailSignupNeedReview && enableEmailSignup) {
      hints.add('邮箱注册需要管理员审核');
    }
    if (webauthnSignupNeedReview && enableWebauthnSignup) {
      hints.add('Passkey 注册需要管理员审核');
    }
    if (emailWhitelistEnabled) {
      hints.add('服务器启用了邮箱白名单，注册邮箱需要在白名单内');
    }
    if (!enableGuest) {
      hints.add('访客访问未启用');
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
