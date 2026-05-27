class WUser {
  final String id;
  final String username;
  final String? email;
  final int role;
  final int createdAt;
  final int updatedAt;
  final int status;
  final int onlineCount;
  final bool emailVerified;
  final bool isBanned;
  final int bannedAt;
  final String bannedBy;
  final String bannedReason;

  WUser({
    required this.id,
    required this.username,
    this.email,
    required this.role,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.status = 0,
    this.onlineCount = 0,
    this.emailVerified = false,
    this.isBanned = false,
    this.bannedAt = 0,
    this.bannedBy = '',
    this.bannedReason = '',
  });
}

class WRoom {
  final String roomId;
  final String roomName;
  final String description;
  final int viewerCount;
  final int memberCount;
  final bool needPassword;
  final String creator;
  final String creatorId;
  final int createdAt;
  final int updatedAt;
  final int status;
  final bool isBanned;
  final int availability;
  final int version;
  final int creatorStatus;
  final bool hidden;
  final bool needVerify;
  final bool guestCanPause;
  final bool guestCanAdd;

  WRoom({
    required this.roomId,
    required this.roomName,
    this.description = '',
    this.viewerCount = 0,
    this.memberCount = 0,
    this.needPassword = false,
    this.creator = '',
    required this.creatorId,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.status = 0,
    this.isBanned = false,
    this.availability = 0,
    this.version = 0,
    this.creatorStatus = 0,
    this.hidden = false,
    this.needVerify = false,
    this.guestCanPause = true,
    this.guestCanAdd = true,
  });

  WRoom copyWith({
    String? roomId,
    String? roomName,
    String? description,
    int? viewerCount,
    int? memberCount,
    bool? needPassword,
    String? creator,
    String? creatorId,
    int? createdAt,
    int? updatedAt,
    int? status,
    bool? isBanned,
    int? availability,
    int? version,
    int? creatorStatus,
    bool? hidden,
    bool? needVerify,
    bool? guestCanPause,
    bool? guestCanAdd,
  }) {
    return WRoom(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      description: description ?? this.description,
      viewerCount: viewerCount ?? this.viewerCount,
      memberCount: memberCount ?? this.memberCount,
      needPassword: needPassword ?? this.needPassword,
      creator: creator ?? this.creator,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      isBanned: isBanned ?? this.isBanned,
      availability: availability ?? this.availability,
      version: version ?? this.version,
      creatorStatus: creatorStatus ?? this.creatorStatus,
      hidden: hidden ?? this.hidden,
      needVerify: needVerify ?? this.needVerify,
      guestCanPause: guestCanPause ?? this.guestCanPause,
      guestCanAdd: guestCanAdd ?? this.guestCanAdd,
    );
  }
}

class WMovie {
  final String id;
  final String name;
  final String url;
  final bool live;
  final bool proxy;
  final String type;
  final String? subPath;
  final String creator;
  final String roomId;
  final double position;
  final int addedAt;
  final int createdAt;
  final int updatedAt;
  final int itemCount;
  final int availability;
  final int version;
  final Map<String, String> headers;
  final bool isFolder;
  final String? parentId;
  final Map<String, dynamic>? subtitles;
  final String? danmu;
  final String? streamDanmu;
  final String sourceProvider;
  final String providerInstanceName;
  final Map<String, dynamic> sourceConfig;
  final Map<String, dynamic> metadata;

  WMovie({
    required this.id,
    required this.name,
    required this.url,
    this.live = false,
    this.proxy = false,
    this.type = '',
    this.subPath,
    this.creator = '',
    this.roomId = '',
    this.position = 0,
    this.addedAt = 0,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.itemCount = 0,
    this.availability = 0,
    this.version = 0,
    this.headers = const {},
    this.isFolder = false,
    this.parentId,
    this.subtitles,
    this.danmu,
    this.streamDanmu,
    this.sourceProvider = '',
    this.providerInstanceName = '',
    this.sourceConfig = const {},
    this.metadata = const {},
  });

  bool get isStaticMedia => id.startsWith('med_');

  bool get isPlaylist => id.startsWith('pl_');

  bool get hasPlaybackTarget =>
      (subPath ?? '').isNotEmpty && (parentId ?? '').startsWith('pl_');

  String get playbackWatchMediaId =>
      isStaticMedia && !hasPlaybackTarget ? id : '';

  String get playbackWatchPlaylistId =>
      hasPlaybackTarget ? parentId! : (isPlaylist ? id : '');

  String? get playbackWatchTarget => hasPlaybackTarget ? subPath : null;

  bool hasSamePlaybackIdentity(WMovie other) {
    return playbackWatchMediaId == other.playbackWatchMediaId &&
        playbackWatchPlaylistId == other.playbackWatchPlaylistId &&
        playbackWatchTarget == other.playbackWatchTarget;
  }

  WMovie copyWith({
    String? id,
    String? name,
    String? url,
    bool? live,
    bool? proxy,
    String? type,
    String? subPath,
    String? creator,
    String? roomId,
    double? position,
    int? addedAt,
    int? createdAt,
    int? updatedAt,
    int? itemCount,
    int? availability,
    int? version,
    Map<String, String>? headers,
    bool? isFolder,
    String? parentId,
    Map<String, dynamic>? subtitles,
    String? danmu,
    String? streamDanmu,
    String? sourceProvider,
    String? providerInstanceName,
    Map<String, dynamic>? sourceConfig,
    Map<String, dynamic>? metadata,
  }) {
    return WMovie(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      live: live ?? this.live,
      proxy: proxy ?? this.proxy,
      type: type ?? this.type,
      subPath: subPath ?? this.subPath,
      creator: creator ?? this.creator,
      roomId: roomId ?? this.roomId,
      position: position ?? this.position,
      addedAt: addedAt ?? this.addedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      itemCount: itemCount ?? this.itemCount,
      availability: availability ?? this.availability,
      version: version ?? this.version,
      headers: headers ?? this.headers,
      isFolder: isFolder ?? this.isFolder,
      parentId: parentId ?? this.parentId,
      subtitles: subtitles ?? this.subtitles,
      danmu: danmu ?? this.danmu,
      streamDanmu: streamDanmu ?? this.streamDanmu,
      sourceProvider: sourceProvider ?? this.sourceProvider,
      providerInstanceName: providerInstanceName ?? this.providerInstanceName,
      sourceConfig: sourceConfig ?? this.sourceConfig,
      metadata: metadata ?? this.metadata,
    );
  }

  WMovie withPlaybackIdentityFrom(WMovie? source) {
    if (source == null || !source.hasPlaybackTarget || id != source.parentId) {
      return this;
    }
    return copyWith(
      id: source.id,
      subPath: source.subPath,
      parentId: source.parentId,
      sourceProvider: source.sourceProvider,
      providerInstanceName: source.providerInstanceName,
      sourceConfig: source.sourceConfig,
    );
  }
}

class RoomCheckInfo {
  final bool exists;
  final bool requiresPassword;
  final String name;
  final int availability;

  const RoomCheckInfo({
    required this.exists,
    required this.requiresPassword,
    required this.name,
    required this.availability,
  });

  bool get isAvailable => availability == 1;
}

class WPlaybackStatus {
  final WMovie? movie;
  final bool isPlaying;
  final double currentTime;
  final double playbackRate;

  WPlaybackStatus({
    this.movie,
    this.isPlaying = false,
    this.currentTime = 0,
    this.playbackRate = 1.0,
  });
}

class RoomMemberPermissions {
  static const int chat = 1 << 0;
  static const int createMediaResource = 1 << 1;
  static const int viewMediaResources = 1 << 2;
  static const int viewMemberList = 1 << 3;
  static const int viewChatHistory = 1 << 4;
  static const int useWebRTC = 1 << 5;
  static const int all = chat |
      createMediaResource |
      viewMediaResources |
      viewMemberList |
      viewChatHistory |
      useWebRTC;

  static const Map<int, String> descriptions = {
    chat: '发送聊天/弹幕',
    createMediaResource: '添加媒体',
    viewMediaResources: '查看媒体列表',
    viewMemberList: '查看成员列表',
    viewChatHistory: '查看聊天历史',
    useWebRTC: 'WebRTC 通话',
  };
}

class RoomGuestPermissions {
  static const int viewMemberList = 1 << 32;
  static const int viewChatHistory = 1 << 33;
  static const int useWebRTC = 1 << 34;
  static const int all = viewMemberList | viewChatHistory | useWebRTC;
}

class WRoomSettings {
  bool requirePassword;
  bool allowGuestJoin;
  bool requireApproval;
  bool allowAutoJoin;
  int maxMembers;
  bool chatEnabled;
  bool danmakuEnabled;
  int adminAddedPermissions;
  int adminRemovedPermissions;
  int memberAddedPermissions;
  int memberRemovedPermissions;
  int guestAddedPermissions;
  int guestRemovedPermissions;

  WRoomSettings({
    this.requirePassword = false,
    this.allowGuestJoin = false,
    this.requireApproval = false,
    this.allowAutoJoin = true,
    this.maxMembers = 100,
    this.chatEnabled = true,
    this.danmakuEnabled = true,
    this.adminAddedPermissions = 0,
    this.adminRemovedPermissions = 0,
    this.memberAddedPermissions = 0,
    this.memberRemovedPermissions = 0,
    this.guestAddedPermissions = 0,
    this.guestRemovedPermissions = 0,
  });

  factory WRoomSettings.fromJson(Map<String, dynamic> json) {
    return WRoomSettings(
      requirePassword: _readBool(json, 'require_password', false),
      allowGuestJoin: _readBool(json, 'allow_guest_join', false),
      requireApproval: _readBool(json, 'require_approval', false),
      allowAutoJoin: _readBool(json, 'allow_auto_join', true),
      maxMembers: _readInt(json, 'max_members', 100),
      chatEnabled: _readBool(json, 'chat_enabled', true),
      danmakuEnabled: _readBool(json, 'danmaku_enabled', true),
      adminAddedPermissions: _readInt(json, 'admin_added_permissions', 0),
      adminRemovedPermissions: _readInt(json, 'admin_removed_permissions', 0),
      memberAddedPermissions: _readInt(json, 'member_added_permissions', 0),
      memberRemovedPermissions: _readInt(json, 'member_removed_permissions', 0),
      guestAddedPermissions: _readInt(json, 'guest_added_permissions', 0),
      guestRemovedPermissions: _readInt(json, 'guest_removed_permissions', 0),
    );
  }

  int get effectiveMemberPermissions {
    return (RoomMemberPermissions.all | memberAddedPermissions) &
        ~memberRemovedPermissions;
  }

  int get effectiveGuestPermissions {
    return guestAddedPermissions & ~guestRemovedPermissions;
  }

  Map<String, dynamic> toJson() {
    return {
      'require_password': requirePassword,
      'allow_guest_join': allowGuestJoin,
      'require_approval': requireApproval,
      'allow_auto_join': allowAutoJoin,
      'max_members': maxMembers,
      'chat_enabled': chatEnabled,
      'danmaku_enabled': danmakuEnabled,
      'admin_added_permissions': adminAddedPermissions,
      'admin_removed_permissions': adminRemovedPermissions,
      'member_added_permissions': memberAddedPermissions,
      'member_removed_permissions': memberRemovedPermissions,
      'guest_added_permissions': guestAddedPermissions,
      'guest_removed_permissions': guestRemovedPermissions,
    };
  }

  static bool _readBool(
    Map<String, dynamic> json,
    String key,
    bool defaultValue,
  ) {
    final value = json[key];
    if (value is bool) return value;
    if (value is String) return value == 'true';
    return defaultValue;
  }

  static int _readInt(
    Map<String, dynamic> json,
    String key,
    int defaultValue,
  ) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }
}
