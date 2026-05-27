import 'package:synctv_app/models/watch_together_models.dart';

class PublicSettingsInfo {
  final bool allowRoomCreation;
  final int maxRoomsPerUser;
  final int maxMembersPerRoom;
  final bool disableCreateRoom;
  final bool createRoomNeedReview;
  final int roomTtl;
  final String roomPasswordPolicy;
  final bool enablePasswordSignup;
  final bool passwordSignupNeedReview;
  final bool enableEmailSignup;
  final bool enableGuest;
  final bool emailSignupNeedReview;
  final bool enableWebauthnSignup;
  final bool webauthnSignupNeedReview;
  final bool movieProxy;
  final bool liveProxy;
  final bool emailWhitelistEnabled;
  final bool tsDisguisedAsPng;
  final String customPublishHost;

  const PublicSettingsInfo({
    required this.allowRoomCreation,
    required this.maxRoomsPerUser,
    required this.maxMembersPerRoom,
    required this.disableCreateRoom,
    required this.createRoomNeedReview,
    required this.roomTtl,
    required this.roomPasswordPolicy,
    required this.enablePasswordSignup,
    required this.passwordSignupNeedReview,
    required this.enableEmailSignup,
    required this.enableGuest,
    required this.emailSignupNeedReview,
    required this.enableWebauthnSignup,
    required this.webauthnSignupNeedReview,
    required this.movieProxy,
    required this.liveProxy,
    required this.emailWhitelistEnabled,
    required this.tsDisguisedAsPng,
    required this.customPublishHost,
  });

  List<String> get roomCreationPolicyHints {
    final hints = <String>[];
    if (maxRoomsPerUser > 0) {
      hints.add('每个用户最多 $maxRoomsPerUser 个房间');
    }
    if (maxMembersPerRoom > 0) {
      hints.add('每个房间最多 $maxMembersPerRoom 名成员');
    }
    if (roomTtl > 0) {
      hints.add('房间空闲 ${_formatDuration(roomTtl)} 后自动清理');
    }
    final normalizedPolicy = roomPasswordPolicy.toLowerCase();
    if (normalizedPolicy == 'required') {
      hints.add('创建房间必须设置密码');
    } else if (normalizedPolicy == 'forbidden') {
      hints.add('新房间必须保持公开');
    }
    return List.unmodifiable(hints);
  }

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

  static String _formatDuration(int seconds) {
    if (seconds % 86400 == 0) {
      return '${seconds ~/ 86400} 天';
    }
    if (seconds % 3600 == 0) {
      return '${seconds ~/ 3600} 小时';
    }
    if (seconds % 60 == 0) {
      return '${seconds ~/ 60} 分钟';
    }
    return '$seconds 秒';
  }
}

class RoomsPage {
  final List<WRoom> rooms;
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

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
