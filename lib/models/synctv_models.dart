import 'package:synctv_app/models/proto_mapping.dart';
import 'package:synctv_app/models/source_config_codec.dart';
import 'package:synctv_app/services/synctv_clock.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

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

class SyncTvUser {
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

  SyncTvUser({
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

  SyncTvUser copyWith({
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
  final RoomCategoryInfo? category;
  final List<RoomLabelInfo> labels;
  final bool isFavorite;

  SyncTvRoom({
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
    this.category,
    this.labels = const [],
    this.isFavorite = false,
  });

  SyncTvRoom copyWith({
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
    RoomCategoryInfo? category,
    List<RoomLabelInfo>? labels,
    bool? isFavorite,
  }) {
    return SyncTvRoom(
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
      category: category ?? this.category,
      labels: labels ?? this.labels,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SyncTvPlaybackUrlOption {
  final String name;
  final String url;
  final Map<String, String> headers;
  final int? expireAt;
  final String resolution;
  final int? bitrate;
  final String codec;
  final int? fps;
  final Map<String, String> metadata;

  const SyncTvPlaybackUrlOption({
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

class SyncTvPlaybackModeOption {
  final String key;
  final String format;
  final List<SyncTvPlaybackUrlOption> urls;
  final int defaultUrlIndex;
  final Map<String, dynamic>? subtitles;
  final String? danmu;
  final Map<String, String> danmuHeaders;
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
    this.streamDanmu,
    this.streamDanmuHeaders = const {},
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
      _ when lower.startsWith('transcoded_') => key.substring(
        'transcoded_'.length,
      ),
      _ => key,
    };
    if (format.trim().isEmpty) return display;
    return '$display · ${format.trim().toUpperCase()}';
  }

  int get safeDefaultUrlIndex =>
      defaultUrlIndex >= 0 && defaultUrlIndex < urls.length
      ? defaultUrlIndex
      : 0;

  SyncTvPlaybackUrlOption? get defaultUrl =>
      urls.isEmpty ? null : urls[safeDefaultUrlIndex];
}

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
  final int availability;
  final int version;
  final Map<String, String> headers;
  final bool isFolder;
  final String? parentId;
  final Map<String, dynamic>? subtitles;
  final String? danmu;
  final Map<String, String> danmuHeaders;
  final String? streamDanmu;
  final Map<String, String> streamDanmuHeaders;
  final String sourceProvider;
  final String providerInstanceName;
  final Map<String, dynamic> sourceConfig;
  final Map<String, dynamic> metadata;
  final String description;
  final String coverUrl;
  final String thumbnailUrl;
  final List<SyncTvPlaybackModeOption> playbackModes;
  final String selectedPlaybackMode;
  final int selectedPlaybackUrlIndex;

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
    this.availability = 0,
    this.version = 0,
    this.headers = const {},
    this.isFolder = false,
    this.parentId,
    this.subtitles,
    this.danmu,
    this.danmuHeaders = const {},
    this.streamDanmu,
    this.streamDanmuHeaders = const {},
    this.sourceProvider = '',
    this.providerInstanceName = '',
    this.sourceConfig = const {},
    this.metadata = const {},
    this.description = '',
    this.coverUrl = '',
    this.thumbnailUrl = '',
    this.playbackModes = const [],
    this.selectedPlaybackMode = '',
    this.selectedPlaybackUrlIndex = 0,
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

  bool get isPlaylist => this is RoomPlaylistItem || id.startsWith('pl_');

  bool get isDynamicPlaylist =>
      this is RoomPlaylistItem && metadata['isDynamic'] == true;

  bool get isProviderDynamicItem => this is RoomDynamicMediaEntry;

  bool get isProviderDynamicEntry => isDynamicPlaylist || isProviderDynamicItem;

  bool get hasPlaybackTarget =>
      (subPath ?? '').isNotEmpty && (parentId ?? '').startsWith('pl_');

  String get playbackMediaId => isStaticMedia && !hasPlaybackTarget ? id : '';

  String get playbackPlaylistId =>
      hasPlaybackTarget ? parentId! : (isPlaylist ? id : '');

  String? get playbackTarget => hasPlaybackTarget ? subPath : null;

  bool get hasPlaybackChoices =>
      playbackModes.length > 1 ||
      playbackModes.any((mode) => mode.urls.length > 1);

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
      type: mode.format.isEmpty ? type : mode.format,
      subtitles: mode.subtitles,
      danmu: mode.danmu,
      danmuHeaders: mode.danmuHeaders,
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
    int? availability,
    int? version,
    Map<String, String>? headers,
    bool? isFolder,
    String? parentId,
    Map<String, dynamic>? subtitles,
    String? danmu,
    Map<String, String>? danmuHeaders,
    String? streamDanmu,
    Map<String, String>? streamDanmuHeaders,
    bool clearSubtitles = false,
    bool clearDanmu = false,
    bool clearStreamDanmu = false,
    String? sourceProvider,
    String? providerInstanceName,
    Map<String, dynamic>? sourceConfig,
    Map<String, dynamic>? metadata,
    String? description,
    String? coverUrl,
    String? thumbnailUrl,
    List<SyncTvPlaybackModeOption>? playbackModes,
    String? selectedPlaybackMode,
    int? selectedPlaybackUrlIndex,
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
      version: version ?? this.version,
      headers: headers ?? this.headers,
      isFolder: isFolder ?? this.isFolder,
      parentId: parentId ?? this.parentId,
      subtitles: clearSubtitles ? null : subtitles ?? this.subtitles,
      danmu: clearDanmu ? null : danmu ?? this.danmu,
      danmuHeaders: clearDanmu ? const {} : danmuHeaders ?? this.danmuHeaders,
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

  static RoomMediaEntry fromPlaybackProto(
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
      live: playback.isLive,
      headers: selectedUrl?.headers ?? const {},
      type: selectedMode.format,
      roomId: playback.roomId,
      position: playback.playlistPosition,
      subPath: subPath,
      parentId: parentId,
      subtitles: selectedMode.subtitles,
      danmu: selectedMode.danmu,
      danmuHeaders: selectedMode.danmuHeaders,
      streamDanmu: selectedMode.streamDanmu,
      streamDanmuHeaders: selectedMode.streamDanmuHeaders,
      sourceProvider: SourceConfigCodec.providerToString(playback.provider),
      providerInstanceName: playback.providerInstanceName,
      playbackModes: modes,
      selectedPlaybackMode: selectedMode.key,
      selectedPlaybackUrlIndex: selectedMode.safeDefaultUrlIndex,
      metadata: {
        'defaultMode': playback.defaultMode,
        if (playback.hasMetadata())
          'playbackMetadata': protoMessageToJsonMap(playback.metadata),
        if (playback.hasExpiresAt()) 'expiresAt': playback.expiresAt.toInt(),
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
        return SyncTvPlaybackUrlOption(
          name: media.name,
          url: resolveUrl == null ? media.url : resolveUrl(media.url),
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

      return SyncTvPlaybackModeOption(
        key: entry.key,
        format: format,
        urls: urls,
        defaultUrlIndex: defaultMediaIndex,
        subtitles: _subtitleMapFromProto(
          info.subtitles,
          resolveUrl: resolveUrl,
        ),
        danmu: _danmuUrlFromProto(
          info.danmakus,
          stream: false,
          resolveUrl: resolveUrl,
        ),
        danmuHeaders: _danmuHeadersFromProto(info.danmakus, stream: false),
        streamDanmu: _danmuUrlFromProto(
          info.danmakus,
          stream: true,
          resolveUrl: resolveUrl,
        ),
        streamDanmuHeaders: _danmuHeadersFromProto(info.danmakus, stream: true),
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
      };
      index++;
    }
    return result.isEmpty ? null : result;
  }

  static String? _danmuUrlFromProto(
    Iterable<client.PlaybackDanmaku> danmakus, {
    required bool stream,
    String Function(String url)? resolveUrl,
  }) {
    for (final danmaku in danmakus) {
      final url = danmaku.url.trim();
      if (url.isEmpty) continue;
      if (_isStreamDanmu(danmaku) != stream) continue;
      return resolveUrl == null ? url : resolveUrl(url);
    }
    return null;
  }

  static Map<String, String> _danmuHeadersFromProto(
    Iterable<client.PlaybackDanmaku> danmakus, {
    required bool stream,
  }) {
    for (final danmaku in danmakus) {
      final url = danmaku.url.trim();
      if (url.isEmpty) continue;
      if (_isStreamDanmu(danmaku) != stream) continue;
      return Map<String, String>.from(danmaku.headers);
    }
    return const {};
  }

  static bool _isStreamDanmu(client.PlaybackDanmaku danmaku) {
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
    super.version,
    super.headers,
    super.sourceProvider,
    super.providerInstanceName,
    super.sourceConfig,
    super.metadata,
    super.description,
    super.coverUrl,
    super.thumbnailUrl,
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
    super.version,
    super.description,
    super.coverUrl,
    super.type,
    super.sourceProvider,
    super.providerInstanceName,
    super.sourceConfig,
    super.metadata,
  }) : super(url: '', isFolder: true);
}

class RoomDynamicMediaEntry extends RoomMediaEntry {
  RoomDynamicMediaEntry({
    required super.id,
    required super.name,
    required super.parentId,
    required super.subPath,
    required super.isFolder,
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
    super.streamDanmu,
    super.streamDanmuHeaders,
    super.sourceProvider,
    super.providerInstanceName,
    super.playbackModes,
    super.selectedPlaybackMode,
    super.selectedPlaybackUrlIndex,
    super.metadata,
  });
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
  });

  double derivedCurrentTime({DateTime? now}) {
    final base = currentTime.isFinite && currentTime > 0 ? currentTime : 0.0;
    if (!isPlaying || generatedAtMillis <= 0) return base;
    final elapsedMillis =
        (now ?? SyncedClock.now()).millisecondsSinceEpoch - generatedAtMillis;
    if (elapsedMillis <= 0) return base;
    return base + elapsedMillis / 1000.0 * playbackRate;
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
  static const int all =
      chat |
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

class SyncTvRoomSettings {
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

  SyncTvRoomSettings({
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

  factory SyncTvRoomSettings.fromJson(Map<String, dynamic> json) {
    return SyncTvRoomSettings(
      requirePassword: _readBool(json, 'requirePassword', false),
      allowGuestJoin: _readBool(json, 'allowGuestJoin', false),
      requireApproval: _readBool(json, 'requireApproval', false),
      allowAutoJoin: _readBool(json, 'allowAutoJoin', true),
      maxMembers: _readInt(json, 'maxMembers', 100),
      chatEnabled: _readBool(json, 'chatEnabled', true),
      danmakuEnabled: _readBool(json, 'danmakuEnabled', true),
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
      'danmakuEnabled': danmakuEnabled,
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
