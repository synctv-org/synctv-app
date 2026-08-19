import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

class RoomCategoryInfo {
  final String id;
  final String key;
  final String name;
  final String description;
  final int sortOrder;
  final bool isEnabled;

  const RoomCategoryInfo({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.isEnabled,
  });
}

class RoomLabelInfo {
  final String id;
  final String key;
  final String name;
  final String description;
  final String color;
  final String categoryId;
  final int sortOrder;
  final bool isEnabled;

  const RoomLabelInfo({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
    required this.color,
    required this.categoryId,
    required this.sortOrder,
    required this.isEnabled,
  });
}

sealed class SyncTvUserRole {
  const SyncTvUserRole();

  bool get hasSystemAdminPrivileges => switch (this) {
    AccountUserRole(
      value: common_enum.UserRole.USER_ROLE_ROOT ||
          common_enum.UserRole.USER_ROLE_ADMIN,
    ) =>
      true,
    AccountUserRole() || RoomMembershipRole() => false,
  };

  bool get isSystemRoot => switch (this) {
    AccountUserRole(value: common_enum.UserRole.USER_ROLE_ROOT) => true,
    AccountUserRole() || RoomMembershipRole() => false,
  };

  bool get isRoomAdministrator => switch (this) {
    RoomMembershipRole(
      value: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
    ) =>
      true,
    AccountUserRole() || RoomMembershipRole() => false,
  };

  bool get isRoomCreator => switch (this) {
    RoomMembershipRole(
      value: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
    ) =>
      true,
    AccountUserRole() || RoomMembershipRole() => false,
  };

  bool get isRoomMember => switch (this) {
    RoomMembershipRole(
      value: common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
    ) =>
      true,
    AccountUserRole() || RoomMembershipRole() => false,
  };
}

final class AccountUserRole extends SyncTvUserRole {
  const AccountUserRole(this.value);

  final common_enum.UserRole value;
}

final class RoomMembershipRole extends SyncTvUserRole {
  const RoomMembershipRole(this.value);

  final common_enum.RoomMemberRole value;
}

class SyncTvUser {
  final String id;
  final String username;
  final String? email;
  final String avatarUrl;
  final SyncTvUserRole role;
  final int createdAt;
  final int updatedAt;
  final common_enum.UserStatus status;
  final int onlineCount;
  final int connectionCount;
  final bool isBanned;
  final int bannedAt;
  final String bannedBy;
  final String bannedReason;

  SyncTvUser({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl = '',
    required this.role,
    this.createdAt = 0,
    this.updatedAt = 0,
    this.status = common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
    this.onlineCount = 0,
    this.connectionCount = 0,
    this.isBanned = false,
    this.bannedAt = 0,
    this.bannedBy = '',
    this.bannedReason = '',
  });

  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  SyncTvUser copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    SyncTvUserRole? role,
    int? createdAt,
    int? updatedAt,
    common_enum.UserStatus? status,
    int? onlineCount,
    int? connectionCount,
    bool? isBanned,
    int? bannedAt,
    String? bannedBy,
    String? bannedReason,
  }) {
    return SyncTvUser(
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

class SyncTvRoom {
  final String roomId;
  final String roomName;
  final String description;
  final int onlineMemberCount;
  final int onlineGuestCount;
  final int connectionCount;
  final int memberCount;
  final bool needPassword;
  final bool isPublic;
  final String creator;
  final String creatorId;
  final String creatorAvatarUrl;
  final int createdAt;
  final int updatedAt;
  final common_enum.RoomStatus status;
  final bool isBanned;
  final client.ResourceAvailability availability;
  final int version;
  final common_enum.UserStatus creatorStatus;
  final bool hidden;
  final bool needVerify;
  final bool guestCanPause;
  final bool guestCanAdd;
  final int myPermissions;
  final common_enum.RoomMemberRole myRole;
  final client.MyRoomRelation myRelation;
  final String coverUrl;
  final RoomCategoryInfo? category;
  final List<RoomLabelInfo> labels;
  final bool isFavorite;
  final bool joined;
  final bool canJoin;
  final client.RoomDiscoveryAccess discoveryAccess;

  bool get isActive => status == common_enum.RoomStatus.ROOM_STATUS_ACTIVE;

  int get onlineCount => onlineMemberCount + onlineGuestCount;

  SyncTvRoom({
    required this.roomId,
    required this.roomName,
    this.description = '',
    this.onlineMemberCount = 0,
    this.onlineGuestCount = 0,
    this.connectionCount = 0,
    this.memberCount = 0,
    this.needPassword = false,
    this.isPublic = true,
    this.creator = '',
    required this.creatorId,
    this.creatorAvatarUrl = '',
    this.createdAt = 0,
    this.updatedAt = 0,
    this.status = common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
    this.isBanned = false,
    this.availability =
        client.ResourceAvailability.RESOURCE_AVAILABILITY_UNSPECIFIED,
    this.version = 0,
    this.creatorStatus = common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
    this.hidden = false,
    this.needVerify = false,
    this.guestCanPause = true,
    this.guestCanAdd = true,
    this.myPermissions = 0,
    this.myRole = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED,
    this.myRelation = client.MyRoomRelation.MY_ROOM_RELATION_UNSPECIFIED,
    this.coverUrl = '',
    this.category,
    this.labels = const [],
    this.isFavorite = false,
    this.joined = false,
    this.canJoin = false,
    this.discoveryAccess =
        client.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNSPECIFIED,
  });

  SyncTvRoom copyWith({
    String? roomId,
    String? roomName,
    String? description,
    int? onlineMemberCount,
    int? onlineGuestCount,
    int? connectionCount,
    int? memberCount,
    bool? needPassword,
    bool? isPublic,
    String? creator,
    String? creatorId,
    String? creatorAvatarUrl,
    int? createdAt,
    int? updatedAt,
    common_enum.RoomStatus? status,
    bool? isBanned,
    client.ResourceAvailability? availability,
    int? version,
    common_enum.UserStatus? creatorStatus,
    bool? hidden,
    bool? needVerify,
    bool? guestCanPause,
    bool? guestCanAdd,
    int? myPermissions,
    common_enum.RoomMemberRole? myRole,
    client.MyRoomRelation? myRelation,
    String? coverUrl,
    RoomCategoryInfo? category,
    List<RoomLabelInfo>? labels,
    bool? isFavorite,
    bool? joined,
    bool? canJoin,
    client.RoomDiscoveryAccess? discoveryAccess,
  }) {
    return SyncTvRoom(
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      description: description ?? this.description,
      onlineMemberCount: onlineMemberCount ?? this.onlineMemberCount,
      onlineGuestCount: onlineGuestCount ?? this.onlineGuestCount,
      connectionCount: connectionCount ?? this.connectionCount,
      memberCount: memberCount ?? this.memberCount,
      needPassword: needPassword ?? this.needPassword,
      isPublic: isPublic ?? this.isPublic,
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
      category: category ?? this.category,
      labels: labels ?? this.labels,
      isFavorite: isFavorite ?? this.isFavorite,
      joined: joined ?? this.joined,
      canJoin: canJoin ?? this.canJoin,
      discoveryAccess: discoveryAccess ?? this.discoveryAccess,
    );
  }
}

class P2pResourceDelivery {
  const P2pResourceDelivery({required this.swarmId, required this.swarmTicket});

  final String swarmId;
  final String swarmTicket;
}

class SyncTvPlaybackUrlOption {
  final String name;
  final String url;
  final String format;
  final Map<String, String> headers;
  final int? expireAt;
  final String resolution;
  final int? bitrate;
  final String codec;
  final int? fps;
  final Map<String, String> metadata;
  final P2pResourceDelivery? p2pDelivery;

  const SyncTvPlaybackUrlOption({
    required this.name,
    required this.url,
    this.format = '',
    this.headers = const {},
    this.expireAt,
    this.resolution = '',
    this.bitrate,
    this.codec = '',
    this.fps,
    this.metadata = const {},
    this.p2pDelivery,
  });

  String label(int index) {
    final parts = <String>[];
    void addUnique(String value) {
      final normalized = value.trim();
      if (normalized.isEmpty) return;
      final lower = normalized.toLowerCase();
      if (parts.any((part) => part.toLowerCase().contains(lower))) return;
      parts.add(normalized);
    }

    addUnique(name);
    addUnique(resolution);
    addUnique(codec.toUpperCase());
    if (fps != null && fps! > 0) addUnique('${fps}fps');
    if (bitrate != null && bitrate! > 0) {
      final mbps = bitrate! / 1000000;
      addUnique('${mbps.toStringAsFixed(mbps >= 10 ? 0 : 1)}Mbps');
    }
    final formatLabel = switch (format.trim().toLowerCase()) {
      'm3u8' || 'hls' => 'HLS',
      'mpd' || 'dash' => 'DASH',
      final value => value.toUpperCase(),
    };
    addUnique(formatLabel);
    return parts.isEmpty ? '线路 ${index + 1}' : parts.join(' · ');
  }
}

class SyncTvPlaybackModeOption {
  final String key;
  final String format;
  final List<SyncTvPlaybackUrlOption> urls;
  final int defaultUrlIndex;
  final Map<String, dynamic>? subtitles;
  final String? danmu;
  final Map<String, String> danmuHeaders;
  final P2pResourceDelivery? danmuP2pDelivery;
  final String? streamDanmu;
  final Map<String, String> streamDanmuHeaders;

  const SyncTvPlaybackModeOption({
    required this.key,
    this.format = '',
    this.urls = const [],
    this.defaultUrlIndex = 0,
    this.subtitles,
    this.danmu,
    this.danmuHeaders = const {},
    this.danmuP2pDelivery,
    this.streamDanmu,
    this.streamDanmuHeaders = const {},
  });

  String get label {
    final display = _playbackModeLabel(key);
    if (format.trim().isEmpty) return display;
    return '$display · ${format.trim().toUpperCase()}';
  }

  static String _playbackModeLabel(String key) {
    final lower = key.toLowerCase();
    if (lower.startsWith('proxy_') && lower != 'proxy_direct') {
      return '${_playbackModeLabel(key.substring('proxy_'.length))} · 代理';
    }
    if (lower.endsWith('_proxy') && lower != 'direct_proxy') {
      return '${_playbackModeLabel(key.substring(0, key.length - '_proxy'.length))} · 代理';
    }
    return switch (lower) {
      'main' => '主线路',
      _ when lower.startsWith('backup_') =>
        '备用线路 ${int.tryParse(lower.substring('backup_'.length)) ?? 1}',
      'direct' => '原始',
      'raw' || 'original' => '原始',
      'proxy' || 'proxied' || 'proxy_direct' || 'direct_proxy' => '代理',
      'dash' => 'DASH',
      'hls' => 'HLS',
      'mp4' => 'MP4',
      'progressive' => '普通视频',
      'transcoded' => '转码',
      'video_hls' => '视频 HLS',
      'audio_hls' => '音频 HLS',
      _ when lower.endsWith('_transcode') =>
        '${key.substring(0, key.length - '_transcode'.length)} 转码',
      _ when lower.startsWith('transcoded_') => key.substring(
        'transcoded_'.length,
      ),
      _ => key,
    };
  }

  int get safeDefaultUrlIndex =>
      defaultUrlIndex >= 0 && defaultUrlIndex < urls.length
      ? defaultUrlIndex
      : 0;

  SyncTvPlaybackUrlOption? get defaultUrl =>
      urls.isEmpty ? null : urls[safeDefaultUrlIndex];
}

enum SyncTvLiveStreamAvailability { unspecified, offline, live }

class RoomMediaEntry {
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
  final client.ResourceAvailability availability;
  final client_enum.PlaylistBrowseAccessMode browseAccessMode;
  final int version;
  final Map<String, String> headers;
  final bool isPlaylist;
  final String? parentId;
  final Map<String, dynamic>? subtitles;
  final String? danmu;
  final Map<String, String> danmuHeaders;
  final P2pResourceDelivery? danmuP2pDelivery;
  final String? streamDanmu;
  final Map<String, String> streamDanmuHeaders;
  final source_enum.SourceProvider sourceProvider;
  final String providerInstanceName;
  final Map<String, dynamic> sourceConfig;
  final Map<String, dynamic> metadata;
  final String description;
  final String coverUrl;
  final String thumbnailUrl;
  final List<SyncTvPlaybackModeOption> playbackModes;
  final String selectedPlaybackMode;
  final int selectedPlaybackUrlIndex;
  final SyncTvLiveStreamAvailability? liveStreamAvailability;
  final String liveStreamGenerationId;
  final int? liveStartedAt;
  final int? playbackExpireAt;

  RoomMediaEntry({
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
    this.availability =
        client.ResourceAvailability.RESOURCE_AVAILABILITY_UNSPECIFIED,
    this.browseAccessMode = client_enum
        .PlaylistBrowseAccessMode
        .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
    this.version = 0,
    this.headers = const {},
    this.isPlaylist = false,
    this.parentId,
    this.subtitles,
    this.danmu,
    this.danmuHeaders = const {},
    this.danmuP2pDelivery,
    this.streamDanmu,
    this.streamDanmuHeaders = const {},
    this.sourceProvider =
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    this.providerInstanceName = '',
    this.sourceConfig = const {},
    this.metadata = const {},
    this.description = '',
    this.coverUrl = '',
    this.thumbnailUrl = '',
    this.playbackModes = const [],
    this.selectedPlaybackMode = '',
    this.selectedPlaybackUrlIndex = 0,
    this.liveStreamAvailability,
    this.liveStreamGenerationId = '',
    this.liveStartedAt,
    this.playbackExpireAt,
  });

  static String playbackUrlFromResource({
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> sourceConfig,
  }) {
    final directUrl = _stringValue(sourceConfig['url']);
    if (directUrl.isNotEmpty) return directUrl;

    final medias = sourceConfig['medias'];
    if (medias is Iterable) {
      final mediaList = medias.whereType<Map>().toList(growable: false);
      if (mediaList.isNotEmpty) {
        final configuredIndex = _intValue(sourceConfig['defaultMediaIndex']);
        final index = configuredIndex >= 0 && configuredIndex < mediaList.length
            ? configuredIndex
            : 0;
        final mediaUrl = _stringValue(mediaList[index]['url']);
        if (mediaUrl.isNotEmpty) return mediaUrl;
      }
    }

    final metadataUrl = _stringValue(metadata['url']);
    if (metadataUrl.isNotEmpty) return metadataUrl;

    final source = _stringValue(metadata['source']);
    return _isPlaybackResource(source) ? source : '';
  }

  static bool _isPlaybackResource(String value) {
    if (value.startsWith('/api/')) return true;
    final scheme = Uri.tryParse(value)?.scheme.toLowerCase();
    return const {'http', 'https', 'rtmp', 'rtmps'}.contains(scheme);
  }

  static String _stringValue(Object? value) =>
      value == null ? '' : value.toString();

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool get isStaticMedia => this is RoomMediaItem || id.startsWith('med_');

  bool get isDynamicPlaylist =>
      this is RoomPlaylistItem && metadata['isDynamic'] == true;

  bool get isProviderDynamicItem => this is RoomDynamicMediaEntry;

  bool get isProviderDynamicEntry => isDynamicPlaylist || isProviderDynamicItem;

  bool get isAvailable =>
      availability !=
      client.ResourceAvailability.RESOURCE_AVAILABILITY_CREATOR_INACTIVE;

  client_enum.PlaylistBrowseAccessMode get effectiveBrowseAccessMode {
    if (browseAccessMode !=
        client_enum
            .PlaylistBrowseAccessMode
            .PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT) {
      return browseAccessMode;
    }
    return isDynamicPlaylist
        ? client_enum
              .PlaylistBrowseAccessMode
              .PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY
        : client_enum
              .PlaylistBrowseAccessMode
              .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS;
  }

  bool canBrowsePlaylistFor(String viewerId) {
    if (!isPlaylist || !isAvailable || viewerId.isEmpty) return false;
    return switch (effectiveBrowseAccessMode) {
      client_enum
          .PlaylistBrowseAccessMode
          .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS =>
        true,
      client_enum
          .PlaylistBrowseAccessMode
          .PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY =>
        creator.isNotEmpty && creator == viewerId,
      _ => false,
    };
  }

  bool get hasPlaybackTarget =>
      (subPath ?? '').isNotEmpty && (parentId ?? '').startsWith('pl_');

  String get playbackMediaId => isStaticMedia && !hasPlaybackTarget ? id : '';

  String get playbackPlaylistId =>
      hasPlaybackTarget ? parentId! : (isPlaylist ? id : '');

  String? get playbackTarget => hasPlaybackTarget ? subPath : null;

  bool get hasPlaybackChoices =>
      playbackModes.length > 1 ||
      playbackModes.any((mode) => mode.urls.length > 1);

  bool get isLiveStreamPlayable =>
      !live ||
      liveStreamAvailability == null ||
      liveStreamAvailability == SyncTvLiveStreamAvailability.live;

  SyncTvPlaybackModeOption? get selectedPlaybackModeOption {
    if (playbackModes.isEmpty) return null;
    for (final mode in playbackModes) {
      if (mode.key == selectedPlaybackMode) return mode;
    }
    return playbackModes.first;
  }

  SyncTvPlaybackUrlOption? get selectedPlaybackUrlOption {
    final mode = selectedPlaybackModeOption;
    if (mode == null || mode.urls.isEmpty) return null;
    final index =
        selectedPlaybackUrlIndex >= 0 &&
            selectedPlaybackUrlIndex < mode.urls.length
        ? selectedPlaybackUrlIndex
        : mode.safeDefaultUrlIndex;
    return mode.urls[index];
  }

  String get playbackAttachmentIdentity => [
    playbackMediaId,
    playbackPlaylistId,
    playbackTarget ?? '',
    selectedPlaybackMode,
    selectedPlaybackUrlIndex,
    liveStreamGenerationId,
  ].join('\u001f');

  String get playbackChoiceLabel {
    final mode = selectedPlaybackModeOption;
    if (mode == null) return '';
    final url = selectedPlaybackUrlOption;
    final urlLabel = url == null
        ? ''
        : url.label(selectedPlaybackUrlIndex).trim();
    return urlLabel.isEmpty ? mode.label : '${mode.label} · $urlLabel';
  }

  RoomMediaEntry selectPlayback({
    required String modeKey,
    required int urlIndex,
    String Function(String url)? resolveUrl,
  }) {
    final mode = playbackModes.firstWhere(
      (entry) => entry.key == modeKey,
      orElse: () => playbackModes.isEmpty
          ? const SyncTvPlaybackModeOption(key: '')
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
      type: selectedUrl?.format.isNotEmpty == true
          ? selectedUrl!.format
          : mode.format.isEmpty
          ? type
          : mode.format,
      subtitles: mode.subtitles,
      danmu: mode.danmu,
      danmuHeaders: mode.danmuHeaders,
      danmuP2pDelivery: mode.danmuP2pDelivery,
      streamDanmu: mode.streamDanmu,
      streamDanmuHeaders: mode.streamDanmuHeaders,
      clearSubtitles: mode.subtitles == null,
      clearDanmu: mode.danmu == null,
      clearStreamDanmu: mode.streamDanmu == null,
      selectedPlaybackMode: mode.key,
      selectedPlaybackUrlIndex: index,
    );
  }

  bool hasSamePlaybackIdentity(RoomMediaEntry other) {
    final mediaId = playbackMediaId;
    final otherMediaId = other.playbackMediaId;
    if (mediaId.isNotEmpty || otherMediaId.isNotEmpty) {
      return mediaId.isNotEmpty && mediaId == otherMediaId;
    }

    final playlistId = playbackPlaylistId;
    final otherPlaylistId = other.playbackPlaylistId;
    if (playlistId.isEmpty || playlistId != otherPlaylistId) return false;

    final target = playbackTarget ?? '';
    final otherTarget = other.playbackTarget ?? '';
    return target.isEmpty || otherTarget.isEmpty || target == otherTarget;
  }

  RoomMediaEntry copyWith({
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
    client.ResourceAvailability? availability,
    client_enum.PlaylistBrowseAccessMode? browseAccessMode,
    int? version,
    Map<String, String>? headers,
    bool? isPlaylist,
    String? parentId,
    Map<String, dynamic>? subtitles,
    String? danmu,
    Map<String, String>? danmuHeaders,
    P2pResourceDelivery? danmuP2pDelivery,
    String? streamDanmu,
    Map<String, String>? streamDanmuHeaders,
    bool clearSubtitles = false,
    bool clearDanmu = false,
    bool clearStreamDanmu = false,
    source_enum.SourceProvider? sourceProvider,
    String? providerInstanceName,
    Map<String, dynamic>? sourceConfig,
    Map<String, dynamic>? metadata,
    String? description,
    String? coverUrl,
    String? thumbnailUrl,
    List<SyncTvPlaybackModeOption>? playbackModes,
    String? selectedPlaybackMode,
    int? selectedPlaybackUrlIndex,
    SyncTvLiveStreamAvailability? liveStreamAvailability,
    String? liveStreamGenerationId,
    int? liveStartedAt,
    int? playbackExpireAt,
  }) {
    return RoomMediaEntry(
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
      browseAccessMode: browseAccessMode ?? this.browseAccessMode,
      version: version ?? this.version,
      headers: headers ?? this.headers,
      isPlaylist: isPlaylist ?? this.isPlaylist,
      parentId: parentId ?? this.parentId,
      subtitles: clearSubtitles ? null : subtitles ?? this.subtitles,
      danmu: clearDanmu ? null : danmu ?? this.danmu,
      danmuHeaders: clearDanmu ? const {} : danmuHeaders ?? this.danmuHeaders,
      danmuP2pDelivery: clearDanmu
          ? null
          : danmuP2pDelivery ?? this.danmuP2pDelivery,
      streamDanmu: clearStreamDanmu ? null : streamDanmu ?? this.streamDanmu,
      streamDanmuHeaders: clearStreamDanmu
          ? const {}
          : streamDanmuHeaders ?? this.streamDanmuHeaders,
      sourceProvider: sourceProvider ?? this.sourceProvider,
      providerInstanceName: providerInstanceName ?? this.providerInstanceName,
      sourceConfig: sourceConfig ?? this.sourceConfig,
      metadata: metadata ?? this.metadata,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      playbackModes: playbackModes ?? this.playbackModes,
      selectedPlaybackMode: selectedPlaybackMode ?? this.selectedPlaybackMode,
      selectedPlaybackUrlIndex:
          selectedPlaybackUrlIndex ?? this.selectedPlaybackUrlIndex,
      liveStreamAvailability:
          liveStreamAvailability ?? this.liveStreamAvailability,
      liveStreamGenerationId:
          liveStreamGenerationId ?? this.liveStreamGenerationId,
      liveStartedAt: liveStartedAt ?? this.liveStartedAt,
      playbackExpireAt: playbackExpireAt ?? this.playbackExpireAt,
    );
  }

  RoomMediaEntry withPlaybackIdentityFrom(RoomMediaEntry? source) {
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

  RoomMediaEntry withPlaybackSelectionFrom(RoomMediaEntry? source) {
    if (source == null || !hasSamePlaybackIdentity(source)) return this;
    final modeKey = source.selectedPlaybackMode;
    final mode = playbackModes.where((mode) => mode.key == modeKey).firstOrNull;
    final urlIndex = source.selectedPlaybackUrlIndex;
    if (mode == null || urlIndex < 0 || urlIndex >= mode.urls.length) {
      return this;
    }
    return selectPlayback(modeKey: modeKey, urlIndex: urlIndex);
  }

  static RoomMediaEntry fromPlaybackProto(
    client.Playback playback, {
    String id = '',
    String? subPath,
    String? parentId,
    String Function(String url)? resolveUrl,
  }) {
    final liveMetadata = playback.hasMetadata() && playback.metadata.hasLive()
        ? playback.metadata.live
        : null;
    final bilibiliMetadata =
        playback.hasMetadata() && playback.metadata.hasBilibili()
        ? playback.metadata.bilibili
        : null;
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
          modes.isEmpty ? const SyncTvPlaybackModeOption(key: '') : modes.first,
    );
    final selectedUrl = selectedMode.defaultUrl;
    final selectedUrlValue = selectedUrl?.url ?? '';
    return RoomPlaybackEntry(
      id: id.isNotEmpty
          ? id
          : playback.mediaId.isNotEmpty
          ? playback.mediaId
          : playback.playlistId,
      name: playback.name,
      url: selectedUrlValue,
      live:
          playback.playbackKind ==
          source_config.PlaybackKind.PLAYBACK_KIND_LIVE,
      headers: selectedUrl?.headers ?? const {},
      type: selectedUrl?.format ?? selectedMode.format,
      roomId: playback.roomId,
      position: playback.playlistPosition,
      subPath: subPath,
      parentId: parentId,
      subtitles: selectedMode.subtitles,
      danmu: selectedMode.danmu,
      danmuHeaders: selectedMode.danmuHeaders,
      danmuP2pDelivery: selectedMode.danmuP2pDelivery,
      streamDanmu: selectedMode.streamDanmu,
      streamDanmuHeaders: selectedMode.streamDanmuHeaders,
      sourceProvider: playback.provider,
      providerInstanceName: playback.providerInstanceName,
      playbackModes: modes,
      selectedPlaybackMode: selectedMode.key,
      selectedPlaybackUrlIndex: selectedMode.safeDefaultUrlIndex,
      liveStreamAvailability: liveMetadata == null
          ? null
          : switch (liveMetadata.availability) {
              client.LiveStreamAvailability.LIVE_STREAM_AVAILABILITY_OFFLINE =>
                SyncTvLiveStreamAvailability.offline,
              client.LiveStreamAvailability.LIVE_STREAM_AVAILABILITY_LIVE =>
                SyncTvLiveStreamAvailability.live,
              _ => SyncTvLiveStreamAvailability.unspecified,
            },
      liveStreamGenerationId: liveMetadata?.streamGenerationId ?? '',
      liveStartedAt: bilibiliMetadata?.hasLiveStartedAt() == true
          ? bilibiliMetadata!.liveStartedAt.toInt()
          : null,
      playbackExpireAt: playback.hasExpiresAt()
          ? playback.expiresAt.toInt()
          : null,
      metadata: {
        'defaultMode': playback.defaultMode,
        if (playback.hasMetadata())
          'playbackMetadata': protoMessageToJsonMap(playback.metadata),
        if (playback.hasDurationSeconds())
          'durationSeconds': playback.durationSeconds,
      },
    );
  }

  static List<SyncTvPlaybackModeOption> playbackModeOptionsFromProto(
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
      final urls = info.medias.map((media) {
        final metadata = media.hasMetadata() ? media.metadata : null;
        final p2pDelivery = media.hasP2pDelivery()
            ? P2pResourceDelivery(
                swarmId: media.p2pDelivery.swarmId,
                swarmTicket: media.p2pDelivery.swarmTicket,
              )
            : null;
        return SyncTvPlaybackUrlOption(
          name: media.name,
          url: resolveUrl == null ? media.url : resolveUrl(media.url),
          format: media.format,
          headers: Map<String, String>.from(media.headers),
          expireAt: media.hasExpireAt() ? media.expireAt.toInt() : null,
          resolution: metadata?.resolution ?? '',
          bitrate: metadata?.hasBitrate() == true
              ? metadata!.bitrate.toInt()
              : null,
          codec: metadata?.codec ?? '',
          fps: metadata?.hasFps() == true ? metadata!.fps : null,
          metadata: metadata == null
              ? const {}
              : protoMessageToJsonMap(
                  metadata,
                ).map((key, value) => MapEntry(key, value.toString())),
          p2pDelivery: p2pDelivery,
        );
      }).toList();
      final defaultMediaIndex = info.hasDefaultMediaIndex()
          ? info.defaultMediaIndex
          : 0;
      final formatMediaIndex =
          defaultMediaIndex >= 0 && defaultMediaIndex < info.medias.length
          ? defaultMediaIndex
          : 0;
      final format = info.medias.isEmpty
          ? ''
          : info.medias[formatMediaIndex].format;
      final staticDanmaku = _danmakuFromProto(
        info.danmakus,
        stream: false,
        resolveUrl: resolveUrl,
      );
      final streamDanmaku = _danmakuFromProto(
        info.danmakus,
        stream: true,
        resolveUrl: resolveUrl,
      );

      return SyncTvPlaybackModeOption(
        key: entry.key,
        format: format,
        urls: urls,
        defaultUrlIndex: defaultMediaIndex,
        subtitles: _subtitleMapFromProto(
          info.subtitles,
          resolveUrl: resolveUrl,
        ),
        danmu: staticDanmaku?.url,
        danmuHeaders: staticDanmaku?.headers ?? const {},
        danmuP2pDelivery: staticDanmaku?.p2pDelivery,
        streamDanmu: streamDanmaku?.url,
        streamDanmuHeaders: streamDanmaku?.headers ?? const {},
      );
    }).toList();
  }

  static Map<String, dynamic>? _subtitleMapFromProto(
    Iterable<client.PlaybackSubtitle> subtitles, {
    String Function(String url)? resolveUrl,
  }) {
    final result = <String, dynamic>{};
    var index = 0;
    for (final subtitle in subtitles) {
      final url = subtitle.url.trim();
      if (url.isEmpty) continue;
      final name = subtitle.name.trim().isNotEmpty
          ? subtitle.name.trim()
          : subtitle.language.trim().isNotEmpty
          ? subtitle.language.trim()
          : '字幕 ${index + 1}';
      result['sub_$index'] = {
        'name': name,
        'language': subtitle.language,
        'url': resolveUrl == null ? url : resolveUrl(url),
        'format': subtitle.format,
        'headers': Map<String, String>.from(subtitle.headers),
        if (subtitle.hasExpireAt()) 'expireAt': subtitle.expireAt.toInt(),
        if (subtitle.hasP2pDelivery())
          'p2pDelivery': P2pResourceDelivery(
            swarmId: subtitle.p2pDelivery.swarmId,
            swarmTicket: subtitle.p2pDelivery.swarmTicket,
          ),
      };
      index++;
    }
    return result.isEmpty ? null : result;
  }

  static ({
    String url,
    Map<String, String> headers,
    P2pResourceDelivery? p2pDelivery,
  })?
  _danmakuFromProto(
    Iterable<client.PlaybackDanmaku> danmakus, {
    required bool stream,
    String Function(String url)? resolveUrl,
  }) {
    for (final danmaku in danmakus) {
      final url = danmaku.url.trim();
      if (url.isEmpty) continue;
      if (_isStreamDanmu(danmaku) != stream) continue;
      final delivery = danmaku.hasP2pDelivery()
          ? P2pResourceDelivery(
              swarmId: danmaku.p2pDelivery.swarmId,
              swarmTicket: danmaku.p2pDelivery.swarmTicket,
            )
          : null;
      return (
        url: resolveUrl == null ? url : resolveUrl(url),
        headers: Map<String, String>.from(danmaku.headers),
        p2pDelivery: delivery,
      );
    }
    return null;
  }

  static bool _isStreamDanmu(client.PlaybackDanmaku danmaku) {
    final delivery = danmaku.delivery;
    if (delivery ==
        client.PlaybackDanmakuDelivery.PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM) {
      return true;
    }
    if (delivery ==
        client.PlaybackDanmakuDelivery.PLAYBACK_DANMAKU_DELIVERY_DOCUMENT) {
      return false;
    }

    final format = danmaku.format.trim().toLowerCase();
    if (format == 'synctv-bilibili-live') return true;
    if (format == 'synctv-twitch-live') return true;
    if (format == 'synctv-huya-live') return true;
    if (format == 'synctv-douyu-live') return true;
    if (format == 'synctv-douyin-live') return true;
    if (format == 'synctv-acfun-live') return true;
    return danmaku.url.contains('/live-danmaku/');
  }
}

class RoomMediaItem extends RoomMediaEntry {
  RoomMediaItem({
    required super.id,
    required super.name,
    required super.url,
    super.live,
    super.proxy,
    super.type,
    super.creator,
    super.roomId,
    super.position,
    super.addedAt,
    super.availability,
    super.browseAccessMode,
    super.version,
    super.headers,
    super.sourceProvider,
    super.providerInstanceName,
    super.sourceConfig,
    super.metadata,
    super.description,
    super.coverUrl,
    super.thumbnailUrl,
    super.liveStreamAvailability,
  });
}

class RoomPlaylistItem extends RoomMediaEntry {
  RoomPlaylistItem({
    required super.id,
    required super.name,
    super.creator,
    super.roomId,
    super.parentId,
    super.position,
    super.createdAt,
    super.updatedAt,
    super.itemCount,
    super.availability,
    super.browseAccessMode,
    super.version,
    super.description,
    super.coverUrl,
    super.type,
    super.sourceProvider,
    super.providerInstanceName,
    super.sourceConfig,
    super.metadata,
  }) : super(url: '', isPlaylist: true);
}

class RoomDynamicMediaEntry extends RoomMediaEntry {
  RoomDynamicMediaEntry({
    required super.id,
    required super.name,
    required super.parentId,
    required super.subPath,
    required super.isPlaylist,
    super.live,
    super.liveStreamAvailability,
    super.coverUrl,
    super.metadata,
    this.mediaSourceConfig,
    this.playlistSourceConfig,
  }) : super(url: '');

  final source_config.MediaSourceConfig? mediaSourceConfig;
  final source_config.PlaylistSourceConfig? playlistSourceConfig;
}

class RoomPlaybackEntry extends RoomMediaEntry {
  RoomPlaybackEntry({
    required super.id,
    required super.name,
    required super.url,
    super.live,
    super.headers,
    super.type,
    super.roomId,
    super.position,
    super.subPath,
    super.parentId,
    super.subtitles,
    super.danmu,
    super.danmuHeaders,
    super.danmuP2pDelivery,
    super.streamDanmu,
    super.streamDanmuHeaders,
    super.sourceProvider,
    super.providerInstanceName,
    super.playbackModes,
    super.selectedPlaybackMode,
    super.selectedPlaybackUrlIndex,
    super.liveStreamAvailability,
    super.liveStreamGenerationId,
    super.liveStartedAt,
    super.playbackExpireAt,
    super.metadata,
  });
}

sealed class JoinRoomResult {
  const JoinRoomResult();
}

final class RoomJoined extends JoinRoomResult {
  const RoomJoined();
}

final class RoomJoinReviewPending extends JoinRoomResult {
  const RoomJoinReviewPending();
}

final class RoomPasswordRejectedException implements Exception {
  const RoomPasswordRejectedException(this.cause);

  final Object cause;

  @override
  String toString() => 'RoomPasswordRejectedException: $cause';
}

class SyncTvPlaybackStatus {
  final RoomMediaEntry? entry;
  final bool isPlaying;

  /// Server-generated playback position at [generatedAtMillis].
  final double currentTime;
  final double playbackRate;
  final int generatedAtMillis;
  final int? version;
  final String playingMediaId;
  final String playingPlaylistId;
  final String targetHash;
  final String historyCursorId;
  final String clientOperationId;

  SyncTvPlaybackStatus({
    this.entry,
    this.isPlaying = false,
    this.currentTime = 0,
    this.playbackRate = 1.0,
    this.generatedAtMillis = 0,
    this.version,
    this.playingMediaId = '',
    this.playingPlaylistId = '',
    this.targetHash = '',
    this.historyCursorId = '',
    this.clientOperationId = '',
  });

  double derivedCurrentTime({required DateTime now}) {
    final base = currentTime.isFinite && currentTime > 0 ? currentTime : 0.0;
    if (!isPlaying || generatedAtMillis <= 0) return base;
    final elapsedMillis = now.millisecondsSinceEpoch - generatedAtMillis;
    if (elapsedMillis <= 0) return base;
    return base + elapsedMillis / 1000.0 * playbackRate;
  }

  bool hasSamePlaybackSource(SyncTvPlaybackStatus other) {
    return playingMediaId == other.playingMediaId &&
        playingPlaylistId == other.playingPlaylistId &&
        targetHash == other.targetHash;
  }

  SyncTvPlaybackStatus copyWith({
    RoomMediaEntry? entry,
    bool? isPlaying,
    double? currentTime,
    double? playbackRate,
    int? generatedAtMillis,
    int? version,
    String? playingMediaId,
    String? playingPlaylistId,
    String? targetHash,
    String? historyCursorId,
    String? clientOperationId,
  }) {
    return SyncTvPlaybackStatus(
      entry: entry ?? this.entry,
      isPlaying: isPlaying ?? this.isPlaying,
      currentTime: currentTime ?? this.currentTime,
      playbackRate: playbackRate ?? this.playbackRate,
      generatedAtMillis: generatedAtMillis ?? this.generatedAtMillis,
      version: version ?? this.version,
      playingMediaId: playingMediaId ?? this.playingMediaId,
      playingPlaylistId: playingPlaylistId ?? this.playingPlaylistId,
      targetHash: targetHash ?? this.targetHash,
      historyCursorId: historyCursorId ?? this.historyCursorId,
      clientOperationId: clientOperationId ?? this.clientOperationId,
    );
  }
}

SyncTvPlaybackStatus mergePlaybackStatusSnapshot({
  required SyncTvPlaybackStatus? current,
  required SyncTvPlaybackStatus incoming,
  required bool incomingHasTiming,
}) {
  final incomingEntry = incoming.entry;
  final currentEntry = current?.entry;
  final hasIncomingSource =
      incoming.playingMediaId.isNotEmpty ||
      incoming.playingPlaylistId.isNotEmpty ||
      incoming.targetHash.isNotEmpty;
  final hasSameEntry =
      currentEntry != null &&
      incomingEntry != null &&
      currentEntry.hasSamePlaybackIdentity(incomingEntry);
  final hasSameSource =
      current != null &&
      hasIncomingSource &&
      incoming.playingMediaId == current.playingMediaId &&
      incoming.playingPlaylistId == current.playingPlaylistId &&
      incoming.targetHash == current.targetHash;
  final canApplyIncomingEntry =
      incomingHasTiming || current == null || hasSameEntry;

  final RoomMediaEntry? mergedEntry;
  if (!hasIncomingSource && incomingEntry == null) {
    mergedEntry = null;
  } else if (incomingEntry != null && !canApplyIncomingEntry) {
    // Playback state and playback resources are observed independently. Keep
    // the resource bound to the newest state when an older snapshot arrives.
    mergedEntry = currentEntry;
  } else if (incomingEntry == null) {
    mergedEntry = !incomingHasTiming && hasSameSource ? currentEntry : null;
  } else if (incomingEntry.url.isEmpty &&
      currentEntry != null &&
      currentEntry.url.isNotEmpty &&
      hasSameEntry) {
    mergedEntry = currentEntry;
  } else if (hasSameEntry) {
    mergedEntry = incomingEntry.url.isEmpty
        ? currentEntry
        : incomingEntry
              .withPlaybackIdentityFrom(currentEntry)
              .withPlaybackSelectionFrom(currentEntry);
  } else {
    mergedEntry = incomingEntry;
  }

  return SyncTvPlaybackStatus(
    entry: mergedEntry,
    isPlaying: incomingHasTiming
        ? incoming.isPlaying
        : current?.isPlaying ?? incoming.isPlaying,
    currentTime: incomingHasTiming
        ? incoming.currentTime
        : current?.currentTime ?? incoming.currentTime,
    playbackRate: incomingHasTiming
        ? incoming.playbackRate
        : current?.playbackRate ?? incoming.playbackRate,
    generatedAtMillis: incomingHasTiming
        ? incoming.generatedAtMillis
        : current?.generatedAtMillis ?? incoming.generatedAtMillis,
    version: incoming.version ?? current?.version,
    playingMediaId: incomingHasTiming
        ? incoming.playingMediaId
        : current?.playingMediaId ?? incoming.playingMediaId,
    playingPlaylistId: incomingHasTiming
        ? incoming.playingPlaylistId
        : current?.playingPlaylistId ?? incoming.playingPlaylistId,
    targetHash: incomingHasTiming
        ? incoming.targetHash
        : current?.targetHash ?? incoming.targetHash,
    historyCursorId: incomingHasTiming
        ? incoming.historyCursorId
        : current?.historyCursorId ?? incoming.historyCursorId,
    clientOperationId: incomingHasTiming
        ? incoming.clientOperationId
        : current?.clientOperationId ?? incoming.clientOperationId,
  );
}

class RoomMemberPermissions {
  static const int sendChatMessages = 1 << 0;
  static const int manageOwnMedia = 1 << 1;
  static const int browseLibrary = 1 << 2;
  static const int viewMembers = 1 << 3;
  static const int viewChatHistory = 1 << 4;
  static const int useVoiceChat = 1 << 5;
  static const int useP2pMedia = 1 << 6;
  static const int all =
      sendChatMessages |
      manageOwnMedia |
      browseLibrary |
      viewMembers |
      viewChatHistory |
      useVoiceChat |
      useP2pMedia;

  static const List<int> values = [
    sendChatMessages,
    manageOwnMedia,
    browseLibrary,
    viewMembers,
    viewChatHistory,
    useVoiceChat,
    useP2pMedia,
  ];
}

class RoomGuestPermissions {
  static const int viewMembers = 1 << 32;
  static const int viewChatHistory = 1 << 33;
  static const int useVoiceChat = 1 << 34;
  static const int useP2pMedia = 1 << 35;
  static const int all =
      viewMembers | viewChatHistory | useVoiceChat | useP2pMedia;
}

class RoomAdminPermissions {
  static const int sendChatMessages = 1 << 0;
  static const int manageOwnMedia = 1 << 1;
  static const int browseLibrary = 1 << 2;
  static const int viewMembers = 1 << 3;
  static const int viewChatHistory = 1 << 4;
  static const int useVoiceChat = 1 << 5;
  static const int deleteMedia = 1 << 6;
  static const int reorderMedia = 1 << 7;
  static const int clearMedia = 1 << 8;
  static const int manageLiveStreams = 1 << 9;
  static const int controlPlaybackState = 1 << 10;
  static const int navigatePlayback = 1 << 11;
  static const int reviewJoinRequests = 1 << 12;
  static const int removeMembers = 1 << 13;
  static const int manageMemberPermissions = 1 << 14;
  static const int addMembers = 1 << 15;
  static const int manageRoomSettings = 1 << 16;
  static const int deleteChatMessages = 1 << 17;
  static const int deleteRoom = 1 << 18;
  static const int viewPlaybackHistory = 1 << 19;
  static const int useP2pMedia = 1 << 20;
  static const int all =
      sendChatMessages |
      manageOwnMedia |
      browseLibrary |
      viewMembers |
      viewChatHistory |
      useVoiceChat |
      deleteMedia |
      reorderMedia |
      clearMedia |
      manageLiveStreams |
      controlPlaybackState |
      navigatePlayback |
      reviewJoinRequests |
      removeMembers |
      manageMemberPermissions |
      addMembers |
      manageRoomSettings |
      deleteChatMessages |
      deleteRoom |
      viewPlaybackHistory |
      useP2pMedia;
  static const int defaults = all & ~deleteRoom;

  static const List<int> values = [
    sendChatMessages,
    manageOwnMedia,
    browseLibrary,
    viewMembers,
    viewChatHistory,
    useVoiceChat,
    deleteMedia,
    reorderMedia,
    clearMedia,
    manageLiveStreams,
    controlPlaybackState,
    navigatePlayback,
    reviewJoinRequests,
    removeMembers,
    manageMemberPermissions,
    addMembers,
    manageRoomSettings,
    deleteChatMessages,
    deleteRoom,
    viewPlaybackHistory,
    useP2pMedia,
  ];
}

/// Effective snapshots are projected by the server into the admin bitspace.
class RoomEffectivePermissions {
  static const int sendChatMessages = RoomAdminPermissions.sendChatMessages;
  static const int manageOwnMedia = RoomAdminPermissions.manageOwnMedia;
  static const int browseLibrary = RoomAdminPermissions.browseLibrary;
  static const int viewMembers = RoomAdminPermissions.viewMembers;
  static const int viewChatHistory = RoomAdminPermissions.viewChatHistory;
  static const int useVoiceChat = RoomAdminPermissions.useVoiceChat;
  static const int deleteMedia = RoomAdminPermissions.deleteMedia;
  static const int reorderMedia = RoomAdminPermissions.reorderMedia;
  static const int clearMedia = RoomAdminPermissions.clearMedia;
  static const int manageLiveStreams = RoomAdminPermissions.manageLiveStreams;
  static const int controlPlaybackState =
      RoomAdminPermissions.controlPlaybackState;
  static const int navigatePlayback = RoomAdminPermissions.navigatePlayback;
  static const int reviewJoinRequests = RoomAdminPermissions.reviewJoinRequests;
  static const int removeMembers = RoomAdminPermissions.removeMembers;
  static const int manageMemberPermissions =
      RoomAdminPermissions.manageMemberPermissions;
  static const int addMembers = RoomAdminPermissions.addMembers;
  static const int manageRoomSettings = RoomAdminPermissions.manageRoomSettings;
  static const int deleteChatMessages = RoomAdminPermissions.deleteChatMessages;
  static const int deleteRoom = RoomAdminPermissions.deleteRoom;
  static const int viewPlaybackHistory =
      RoomAdminPermissions.viewPlaybackHistory;
  static const int useP2pMedia = RoomAdminPermissions.useP2pMedia;
}

class SyncTvRoomSettings {
  bool requirePassword;
  bool allowGuestJoin;
  bool requireApproval;
  bool allowAutoJoin;
  int maxMembers;
  bool chatEnabled;
  bool autoPlayEnabled;
  client.PlayMode autoPlayMode;
  int autoPlayDelay;
  bool voiceChatEnabled;
  bool p2pMediaEnabled;
  int adminAddedPermissions;
  int adminRemovedPermissions;
  int memberAddedPermissions;
  int memberRemovedPermissions;
  int guestAddedPermissions;
  int guestRemovedPermissions;

  SyncTvRoomSettings({
    this.requirePassword = false,
    this.allowGuestJoin = false,
    this.requireApproval = false,
    this.allowAutoJoin = true,
    this.maxMembers = 100,
    this.chatEnabled = true,
    this.autoPlayEnabled = true,
    this.autoPlayMode = client.PlayMode.PLAY_MODE_SEQUENTIAL,
    this.autoPlayDelay = 3,
    this.voiceChatEnabled = true,
    this.p2pMediaEnabled = true,
    this.adminAddedPermissions = 0,
    this.adminRemovedPermissions = 0,
    this.memberAddedPermissions = 0,
    this.memberRemovedPermissions = 0,
    this.guestAddedPermissions = 0,
    this.guestRemovedPermissions = 0,
  });

  factory SyncTvRoomSettings.fromJson(Map<String, dynamic> json) {
    final autoPlayValue = json['autoPlay'];
    final autoPlay = autoPlayValue is Map
        ? Map<String, dynamic>.from(autoPlayValue)
        : const <String, dynamic>{};
    final parsedMode = client.PlayMode.valueOf(
      _readInt(autoPlay, 'mode', client.PlayMode.PLAY_MODE_SEQUENTIAL.value),
    );
    return SyncTvRoomSettings(
      requirePassword: _readBool(json, 'requirePassword', false),
      allowGuestJoin: _readBool(json, 'allowGuestJoin', false),
      requireApproval: _readBool(json, 'requireApproval', false),
      allowAutoJoin: _readBool(json, 'allowAutoJoin', true),
      maxMembers: _readInt(json, 'maxMembers', 100),
      chatEnabled: _readBool(json, 'chatEnabled', true),
      autoPlayEnabled: _readBool(autoPlay, 'enabled', true),
      autoPlayMode:
          parsedMode == null ||
              parsedMode == client.PlayMode.PLAY_MODE_UNSPECIFIED
          ? client.PlayMode.PLAY_MODE_SEQUENTIAL
          : parsedMode,
      autoPlayDelay: _readInt(autoPlay, 'delay', 3),
      voiceChatEnabled: _readBool(json, 'voiceChatEnabled', true),
      p2pMediaEnabled: _readBool(json, 'p2pMediaEnabled', true),
      adminAddedPermissions: _readInt(json, 'adminAddedPermissions', 0),
      adminRemovedPermissions: _readInt(json, 'adminRemovedPermissions', 0),
      memberAddedPermissions: _readInt(json, 'memberAddedPermissions', 0),
      memberRemovedPermissions: _readInt(json, 'memberRemovedPermissions', 0),
      guestAddedPermissions: _readInt(json, 'guestAddedPermissions', 0),
      guestRemovedPermissions: _readInt(json, 'guestRemovedPermissions', 0),
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
      'allowGuestJoin': allowGuestJoin,
      'requireApproval': requireApproval,
      'allowAutoJoin': allowAutoJoin,
      'maxMembers': maxMembers,
      'chatEnabled': chatEnabled,
      'autoPlay': {
        'enabled': autoPlayEnabled,
        'mode': autoPlayMode.value,
        'delay': autoPlayDelay,
      },
      'voiceChatEnabled': voiceChatEnabled,
      'p2pMediaEnabled': p2pMediaEnabled,
      'adminAddedPermissions': adminAddedPermissions,
      'adminRemovedPermissions': adminRemovedPermissions,
      'memberAddedPermissions': memberAddedPermissions,
      'memberRemovedPermissions': memberRemovedPermissions,
      'guestAddedPermissions': guestAddedPermissions,
      'guestRemovedPermissions': guestRemovedPermissions,
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

  static int _readInt(Map<String, dynamic> json, String key, int defaultValue) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }
}
