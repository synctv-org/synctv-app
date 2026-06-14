import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

class WUser {
  final String id;
  final String username;
  final String? email;
  final String avatarUrl;
  final int role;
  final int createdAt;
  final int updatedAt;
  final int status;
  final int onlineCount;
  final int connectionCount;
  final bool isBanned;
  final int bannedAt;
  final String bannedBy;
  final String bannedReason;

  WUser({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl = '',
    required this.role,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.status = 0,
    this.onlineCount = 0,
    this.connectionCount = 0,
    this.isBanned = false,
    this.bannedAt = 0,
    this.bannedBy = '',
    this.bannedReason = '',
  });

  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  WUser copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    int? role,
    int? createdAt,
    int? updatedAt,
    int? status,
    int? onlineCount,
    int? connectionCount,
    bool? isBanned,
    int? bannedAt,
    String? bannedBy,
    String? bannedReason,
  }) {
    return WUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      onlineCount: onlineCount ?? this.onlineCount,
      connectionCount: connectionCount ?? this.connectionCount,
      isBanned: isBanned ?? this.isBanned,
      bannedAt: bannedAt ?? this.bannedAt,
      bannedBy: bannedBy ?? this.bannedBy,
      bannedReason: bannedReason ?? this.bannedReason,
    );
  }
}

class WRoom {
  final String roomId;
  final String roomName;
  final String description;
  final int viewerCount;
  final int connectionCount;
  final int memberCount;
  final bool needPassword;
  final String creator;
  final String creatorId;
  final String creatorAvatarUrl;
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
  final int myPermissions;
  final int myRole;
  final int myRelation;
  final String coverUrl;

  WRoom({
    required this.roomId,
    required this.roomName,
    this.description = '',
    this.viewerCount = 0,
    this.connectionCount = 0,
    this.memberCount = 0,
    this.needPassword = false,
    this.creator = '',
    required this.creatorId,
    this.creatorAvatarUrl = '',
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
    this.myPermissions = 0,
    this.myRole = 0,
    this.myRelation = 0,
    this.coverUrl = '',
  });

  WRoom copyWith({
    String? roomId,
    String? roomName,
    String? description,
    int? viewerCount,
    int? connectionCount,
    int? memberCount,
    bool? needPassword,
    String? creator,
    String? creatorId,
    String? creatorAvatarUrl,
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
    int? myPermissions,
    int? myRole,
    int? myRelation,
    String? coverUrl,
  }) {
    return WRoom(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      description: description ?? this.description,
      viewerCount: viewerCount ?? this.viewerCount,
      connectionCount: connectionCount ?? this.connectionCount,
      memberCount: memberCount ?? this.memberCount,
      needPassword: needPassword ?? this.needPassword,
      creator: creator ?? this.creator,
      creatorId: creatorId ?? this.creatorId,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
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
      myPermissions: myPermissions ?? this.myPermissions,
      myRole: myRole ?? this.myRole,
      myRelation: myRelation ?? this.myRelation,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}

class WPlaybackUrlOption {
  final String name;
  final String url;
  final Map<String, String> headers;
  final int? expireAt;
  final String resolution;
  final int? bitrate;
  final String codec;
  final int? fps;
  final Map<String, String> metadata;

  const WPlaybackUrlOption({
    required this.name,
    required this.url,
    this.headers = const {},
    this.expireAt,
    this.resolution = '',
    this.bitrate,
    this.codec = '',
    this.fps,
    this.metadata = const {},
  });

  String label(int index) {
    final parts = <String>[];
    if (name.trim().isNotEmpty) parts.add(name.trim());
    if (resolution.trim().isNotEmpty) parts.add(resolution.trim());
    if (codec.trim().isNotEmpty) parts.add(codec.trim().toUpperCase());
    if (fps != null && fps! > 0) parts.add('${fps}fps');
    if (bitrate != null && bitrate! > 0) {
      final mbps = bitrate! / 1000000;
      parts.add('${mbps.toStringAsFixed(mbps >= 10 ? 0 : 1)}Mbps');
    }
    return parts.isEmpty ? '线路 ${index + 1}' : parts.join(' · ');
  }
}

class WPlaybackModeOption {
  final String key;
  final String format;
  final List<WPlaybackUrlOption> urls;
  final int defaultUrlIndex;
  final Map<String, dynamic>? subtitles;
  final String? danmu;

  const WPlaybackModeOption({
    required this.key,
    this.format = '',
    this.urls = const [],
    this.defaultUrlIndex = 0,
    this.subtitles,
    this.danmu,
  });

  String get label {
    final lower = key.toLowerCase();
    final display = switch (lower) {
      'direct' => '原始',
      'proxy' || 'proxied' => '代理',
      'dash' => 'DASH',
      'hls' => 'HLS',
      'mp4' => 'MP4',
      _ when lower.endsWith('_transcode') =>
        '${key.substring(0, key.length - '_transcode'.length)} 转码',
      _ when lower.startsWith('transcoded_') =>
        key.substring('transcoded_'.length),
      _ => key,
    };
    if (format.trim().isEmpty) return display;
    return '$display · ${format.trim().toUpperCase()}';
  }

  int get safeDefaultUrlIndex =>
      defaultUrlIndex >= 0 && defaultUrlIndex < urls.length
          ? defaultUrlIndex
          : 0;

  WPlaybackUrlOption? get defaultUrl =>
      urls.isEmpty ? null : urls[safeDefaultUrlIndex];
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
  final String description;
  final String coverUrl;
  final List<WPlaybackModeOption> playbackModes;
  final String selectedPlaybackMode;
  final int selectedPlaybackUrlIndex;

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
    this.description = '',
    this.coverUrl = '',
    this.playbackModes = const [],
    this.selectedPlaybackMode = '',
    this.selectedPlaybackUrlIndex = 0,
  });

  bool get isStaticMedia => id.startsWith('med_');

  bool get isPlaylist => id.startsWith('pl_');

  bool get isDynamicPlaylist => isPlaylist && metadata['is_dynamic'] == true;

  bool get isProviderDynamicItem => !isStaticMedia && !isPlaylist;

  bool get isProviderDynamicEntry => isDynamicPlaylist || isProviderDynamicItem;

  bool get hasPlaybackTarget =>
      (subPath ?? '').isNotEmpty && (parentId ?? '').startsWith('pl_');

  String get playbackWatchMediaId =>
      isStaticMedia && !hasPlaybackTarget ? id : '';

  String get playbackWatchPlaylistId =>
      hasPlaybackTarget ? parentId! : (isPlaylist ? id : '');

  String? get playbackWatchTarget => hasPlaybackTarget ? subPath : null;

  bool get hasPlaybackChoices =>
      playbackModes.length > 1 ||
      playbackModes.any((mode) => mode.urls.length > 1);

  WPlaybackModeOption? get selectedPlaybackModeOption {
    if (playbackModes.isEmpty) return null;
    for (final mode in playbackModes) {
      if (mode.key == selectedPlaybackMode) return mode;
    }
    return playbackModes.first;
  }

  WPlaybackUrlOption? get selectedPlaybackUrlOption {
    final mode = selectedPlaybackModeOption;
    if (mode == null || mode.urls.isEmpty) return null;
    final index = selectedPlaybackUrlIndex >= 0 &&
            selectedPlaybackUrlIndex < mode.urls.length
        ? selectedPlaybackUrlIndex
        : mode.safeDefaultUrlIndex;
    return mode.urls[index];
  }

  String get playbackChoiceLabel {
    final mode = selectedPlaybackModeOption;
    if (mode == null) return '';
    final url = selectedPlaybackUrlOption;
    final urlLabel =
        url == null ? '' : url.label(selectedPlaybackUrlIndex).trim();
    return urlLabel.isEmpty ? mode.label : '${mode.label} · $urlLabel';
  }

  WMovie selectPlayback({
    required String modeKey,
    required int urlIndex,
    String Function(String url)? resolveUrl,
  }) {
    final mode = playbackModes.firstWhere(
      (entry) => entry.key == modeKey,
      orElse: () => playbackModes.isEmpty
          ? const WPlaybackModeOption(key: '')
          : playbackModes.first,
    );
    final index = urlIndex >= 0 && urlIndex < mode.urls.length
        ? urlIndex
        : mode.safeDefaultUrlIndex;
    final selectedUrl = mode.urls.isEmpty ? null : mode.urls[index];
    final rawUrl = selectedUrl?.url ?? url;
    return copyWith(
      url: resolveUrl == null ? rawUrl : resolveUrl(rawUrl),
      headers: selectedUrl?.headers ?? headers,
      type: mode.format.isEmpty ? type : mode.format,
      subtitles: mode.subtitles ?? subtitles,
      danmu: mode.danmu ?? danmu,
      selectedPlaybackMode: mode.key,
      selectedPlaybackUrlIndex: index,
    );
  }

  bool hasSamePlaybackIdentity(WMovie other) {
    final mediaId = playbackWatchMediaId;
    final otherMediaId = other.playbackWatchMediaId;
    if (mediaId.isNotEmpty || otherMediaId.isNotEmpty) {
      return mediaId.isNotEmpty && mediaId == otherMediaId;
    }

    final playlistId = playbackWatchPlaylistId;
    final otherPlaylistId = other.playbackWatchPlaylistId;
    if (playlistId.isEmpty || playlistId != otherPlaylistId) return false;

    final target = playbackWatchTarget ?? '';
    final otherTarget = other.playbackWatchTarget ?? '';
    return target.isEmpty || otherTarget.isEmpty || target == otherTarget;
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
    String? description,
    String? coverUrl,
    List<WPlaybackModeOption>? playbackModes,
    String? selectedPlaybackMode,
    int? selectedPlaybackUrlIndex,
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
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      playbackModes: playbackModes ?? this.playbackModes,
      selectedPlaybackMode: selectedPlaybackMode ?? this.selectedPlaybackMode,
      selectedPlaybackUrlIndex:
          selectedPlaybackUrlIndex ?? this.selectedPlaybackUrlIndex,
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

  static WMovie fromPlaybackProto(
    client.Playback playback, {
    String id = '',
    String? subPath,
    String? parentId,
    String Function(String url)? resolveUrl,
  }) {
    final modes = playbackModeOptionsFromProto(
      playback,
      resolveUrl: resolveUrl,
    );
    final defaultMode = modes.any((mode) => mode.key == playback.defaultMode)
        ? playback.defaultMode
        : modes.isEmpty
            ? ''
            : modes.first.key;
    final selectedMode = modes.firstWhere(
      (mode) => mode.key == defaultMode,
      orElse: () =>
          modes.isEmpty ? const WPlaybackModeOption(key: '') : modes.first,
    );
    final selectedUrl = selectedMode.defaultUrl;
    final selectedUrlValue = selectedUrl?.url ?? '';
    return WMovie(
      id: id.isNotEmpty
          ? id
          : playback.mediaId.isNotEmpty
              ? playback.mediaId
              : playback.playlistId,
      name: playback.name,
      url: selectedUrlValue,
      headers: selectedUrl?.headers ?? const {},
      type: selectedMode.format,
      subPath: subPath,
      parentId: parentId,
      subtitles: selectedMode.subtitles,
      danmu: selectedMode.danmu,
      playbackModes: modes,
      selectedPlaybackMode: selectedMode.key,
      selectedPlaybackUrlIndex: selectedMode.safeDefaultUrlIndex,
      metadata: {
        'default_mode': playback.defaultMode,
        'playback_metadata': Map<String, String>.from(
          playback.metadata,
        ),
      },
    );
  }

  static List<WPlaybackModeOption> playbackModeOptionsFromProto(
    client.Playback playback, {
    String Function(String url)? resolveUrl,
  }) {
    final entries = playback.playbackInfos.entries.toList()
      ..sort((a, b) {
        if (a.key == playback.defaultMode) return -1;
        if (b.key == playback.defaultMode) return 1;
        return a.key.compareTo(b.key);
      });

    return entries.map((entry) {
      final info = entry.value;
      final urls = info.urls.map((url) {
        final metadata = url.hasMetadata() ? url.metadata : null;
        return WPlaybackUrlOption(
          name: url.name,
          url: resolveUrl == null ? url.url : resolveUrl(url.url),
          headers: Map<String, String>.from(url.headers),
          expireAt: url.hasExpireAt() ? url.expireAt.toInt() : null,
          resolution: metadata?.resolution ?? '',
          bitrate:
              metadata?.hasBitrate() == true ? metadata!.bitrate.toInt() : null,
          codec: metadata?.codec ?? '',
          fps: metadata?.hasFps() == true ? metadata!.fps : null,
          metadata: metadata == null
              ? const {}
              : Map<String, String>.from(metadata.extra),
        );
      }).toList();

      return WPlaybackModeOption(
        key: entry.key,
        format: info.format,
        urls: urls,
        defaultUrlIndex: info.defaultUrlIndex,
        subtitles: _subtitleMapFromProto(
          info.subtitles,
          resolveUrl: resolveUrl,
        ),
        danmu: _danmuUrlFromProto(info.danmakus, resolveUrl: resolveUrl),
      );
    }).toList();
  }

  static Map<String, dynamic>? _subtitleMapFromProto(
    Iterable<client.Subtitle> subtitles, {
    String Function(String url)? resolveUrl,
  }) {
    final result = <String, dynamic>{};
    var index = 0;
    for (final subtitle in subtitles) {
      if (subtitle.urls.isEmpty) continue;
      final urlIndex = subtitle.defaultUrlIndex >= 0 &&
              subtitle.defaultUrlIndex < subtitle.urls.length
          ? subtitle.defaultUrlIndex
          : 0;
      final subtitleUrl = subtitle.urls[urlIndex];
      if (subtitleUrl.url.isEmpty) continue;
      final name = subtitle.name.trim().isNotEmpty
          ? subtitle.name.trim()
          : subtitle.language.trim().isNotEmpty
              ? subtitle.language.trim()
              : '字幕 ${index + 1}';
      result['sub_$index'] = {
        'name': name,
        'language': subtitle.language,
        'url':
            resolveUrl == null ? subtitleUrl.url : resolveUrl(subtitleUrl.url),
        'format': subtitleUrl.format,
        'headers': Map<String, String>.from(subtitleUrl.headers),
      };
      index++;
    }
    return result.isEmpty ? null : result;
  }

  static String? _danmuUrlFromProto(
    Iterable<client.Danmaku> danmakus, {
    String Function(String url)? resolveUrl,
  }) {
    for (final danmaku in danmakus) {
      final url = danmaku.url.trim();
      if (url.isNotEmpty) return resolveUrl == null ? url : resolveUrl(url);
    }
    return null;
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
  final int? version;
  final String playingMediaId;
  final String playingPlaylistId;
  final String targetHash;

  WPlaybackStatus({
    this.movie,
    this.isPlaying = false,
    this.currentTime = 0,
    this.playbackRate = 1.0,
    this.version,
    this.playingMediaId = '',
    this.playingPlaylistId = '',
    this.targetHash = '',
  });

  WPlaybackStatus copyWith({
    WMovie? movie,
    bool? isPlaying,
    double? currentTime,
    double? playbackRate,
    int? version,
    String? playingMediaId,
    String? playingPlaylistId,
    String? targetHash,
  }) {
    return WPlaybackStatus(
      movie: movie ?? this.movie,
      isPlaying: isPlaying ?? this.isPlaying,
      currentTime: currentTime ?? this.currentTime,
      playbackRate: playbackRate ?? this.playbackRate,
      version: version ?? this.version,
      playingMediaId: playingMediaId ?? this.playingMediaId,
      playingPlaylistId: playingPlaylistId ?? this.playingPlaylistId,
      targetHash: targetHash ?? this.targetHash,
    );
  }
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
