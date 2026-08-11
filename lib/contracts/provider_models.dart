import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;

class AlistBindInfo {
  final String id;
  final String serverId;
  final String host;
  final String username;
  final int createdAt;
  final String providerInstanceName;

  const AlistBindInfo({
    required this.id,
    required this.serverId,
    required this.host,
    required this.username,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class EmbyBindInfo {
  final String id;
  final String serverId;
  final String host;
  final String userId;
  final int createdAt;
  final String providerInstanceName;

  const EmbyBindInfo({
    required this.id,
    required this.serverId,
    required this.host,
    required this.userId,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class BilibiliBindInfo {
  final String id;
  final String serverId;
  final int createdAt;
  final String providerInstanceName;

  const BilibiliBindInfo({
    required this.id,
    required this.serverId,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class CloudreveBindInfo {
  final String id;
  final String serverId;
  final String host;
  final String email;
  final int createdAt;
  final String providerInstanceName;

  const CloudreveBindInfo({
    required this.id,
    required this.serverId,
    required this.host,
    required this.email,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class TwitchBindInfo {
  final String id;
  final String serverId;
  final String login;
  final String twitchUserId;
  final String clientId;
  final List<String> scopes;
  final int createdAt;
  final String providerInstanceName;

  const TwitchBindInfo({
    required this.id,
    required this.serverId,
    required this.login,
    required this.twitchUserId,
    this.clientId = '',
    this.scopes = const [],
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class YoutubeBindInfo {
  final String id;
  final String serverId;
  final String label;
  final bool hasVisitorData;
  final bool hasPoToken;
  final bool hasCookie;
  final int createdAt;
  final String providerInstanceName;

  const YoutubeBindInfo({
    required this.id,
    required this.serverId,
    required this.label,
    required this.hasVisitorData,
    required this.hasPoToken,
    required this.hasCookie,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class DouyinBindInfo {
  final String id;
  final String serverId;
  final String label;
  final bool hasCookie;
  final int createdAt;
  final String providerInstanceName;

  const DouyinBindInfo({
    required this.id,
    required this.serverId,
    required this.label,
    required this.hasCookie,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class TikTokBindInfo {
  final String id;
  final String serverId;
  final String label;
  final bool hasCookie;
  final int createdAt;
  final String providerInstanceName;

  const TikTokBindInfo({
    required this.id,
    required this.serverId,
    required this.label,
    required this.hasCookie,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class FnosBindInfo {
  final String id;
  final String serverId;
  final String endpoint;
  final String webdavEndpoint;
  final String mediaEndpoint;
  final String username;
  final int createdAt;
  final String providerInstanceName;
  final bool mediaAvailable;

  const FnosBindInfo({
    required this.id,
    required this.serverId,
    required this.endpoint,
    required this.webdavEndpoint,
    required this.mediaEndpoint,
    required this.username,
    required this.createdAt,
    required this.providerInstanceName,
    required this.mediaAvailable,
  });
}

sealed class FnosLoginInfo {
  const FnosLoginInfo();
}

class FnosAuthenticatedInfo extends FnosLoginInfo {
  final String serverId;
  final String hostName;
  final String version;
  final bool mediaAvailable;

  const FnosAuthenticatedInfo({
    required this.serverId,
    required this.hostName,
    required this.version,
    required this.mediaAvailable,
  });
}

class FnosTwoFactorRequiredInfo extends FnosLoginInfo {
  final bool setupRequired;

  const FnosTwoFactorRequiredInfo({required this.setupRequired});
}

class FnosFileItemInfo {
  final String name;
  final String path;
  final int? size;
  final int? modifiedAt;
  final int? createdAt;
  final bool isDir;
  final int? storageId;
  final provider_common.DiscoveredSource source;

  const FnosFileItemInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.modifiedAt,
    required this.createdAt,
    required this.isDir,
    required this.storageId,
    required this.source,
  });
}

class FnosFileListPage {
  final List<FnosFileItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const FnosFileListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class FnosMediaLibraryInfo {
  final String guid;
  final String title;
  final String poster;
  final List<String> posters;
  final String category;
  final int viewType;
  final int posterType;

  const FnosMediaLibraryInfo({
    required this.guid,
    required this.title,
    required this.poster,
    required this.posters,
    required this.category,
    required this.viewType,
    required this.posterType,
  });
}

enum FnosMediaCollection { library, favorites, history }

class FnosMediaItemInfo {
  final String guid;
  final String title;
  final String itemType;
  final String poster;
  final String mediaGuid;
  final String parentGuid;
  final String overview;
  final int durationSeconds;
  final int progressSeconds;
  final bool watched;
  final int seasonNumber;
  final int episodeNumber;
  final bool isFolder;
  final bool isPlayable;
  final bool favorite;
  final provider_common.DiscoveredSource source;

  const FnosMediaItemInfo({
    required this.guid,
    required this.title,
    required this.itemType,
    required this.poster,
    required this.mediaGuid,
    required this.parentGuid,
    required this.overview,
    required this.durationSeconds,
    required this.progressSeconds,
    required this.watched,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.isFolder,
    required this.isPlayable,
    required this.favorite,
    required this.source,
  });
}

class FnosMediaListPage {
  final List<FnosMediaItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const FnosMediaListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class QnapBindInfo {
  final String id;
  final String serverId;
  final String endpoint;
  final String username;
  final String serverName;
  final String version;
  final bool supportRtt;
  final int createdAt;
  final String providerInstanceName;

  const QnapBindInfo({
    required this.id,
    required this.serverId,
    required this.endpoint,
    required this.username,
    required this.serverName,
    required this.version,
    required this.supportRtt,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class QnapCapabilitiesInfo {
  final bool supportRtt;
  final bool hardwareTranscode;
  final bool qtranscode;
  final bool multimediaCodec;
  final bool hdStationSupport;

  const QnapCapabilitiesInfo({
    required this.supportRtt,
    required this.hardwareTranscode,
    required this.qtranscode,
    required this.multimediaCodec,
    required this.hdStationSupport,
  });
}

class QnapFileItemInfo {
  final String name;
  final String path;
  final bool isDir;
  final int size;
  final int modifiedAt;
  final int fileType;
  final List<int> preTranscodedHeights;
  final String thumbnailUrl;
  final provider_common.DiscoveredSource source;

  const QnapFileItemInfo({
    required this.name,
    required this.path,
    required this.isDir,
    required this.size,
    required this.modifiedAt,
    required this.fileType,
    required this.preTranscodedHeights,
    required this.thumbnailUrl,
    required this.source,
  });
}

class QnapFileListPage {
  final List<QnapFileItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final bool realtimeTranscode;
  final provider_common.DiscoveredSource? source;

  const QnapFileListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.realtimeTranscode,
    required this.source,
  });
}

class SynologyBindInfo {
  final String id;
  final String serverId;
  final String endpoint;
  final String username;
  final bool videoStationAvailable;
  final int createdAt;
  final String providerInstanceName;

  const SynologyBindInfo({
    required this.id,
    required this.serverId,
    required this.endpoint,
    required this.username,
    required this.videoStationAvailable,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class NextcloudBindInfo {
  final String id;
  final String serverId;
  final String endpoint;
  final String username;
  final String userId;
  final String displayName;
  final String version;
  final String edition;
  final int createdAt;
  final String providerInstanceName;

  const NextcloudBindInfo({
    required this.id,
    required this.serverId,
    required this.endpoint,
    required this.username,
    required this.userId,
    required this.displayName,
    required this.version,
    required this.edition,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class NextcloudLoginFlowInfo {
  final String loginUrl;
  final String pollEndpoint;
  final String pollToken;

  const NextcloudLoginFlowInfo({
    required this.loginUrl,
    required this.pollEndpoint,
    required this.pollToken,
  });
}

class NextcloudFileItemInfo {
  final String name;
  final String path;
  final int fileId;
  final bool isDir;
  final int size;
  final String modifiedAt;
  final String contentType;
  final String etag;
  final String permissions;
  final String ownerId;
  final String ownerDisplayName;
  final bool favorite;
  final bool hasPreview;
  final String blurhash;
  final int? width;
  final int? height;
  final int? durationMillis;
  final String previewUrl;
  final provider_common.DiscoveredSource source;

  const NextcloudFileItemInfo({
    required this.name,
    required this.path,
    required this.fileId,
    required this.isDir,
    required this.size,
    required this.modifiedAt,
    required this.contentType,
    required this.etag,
    required this.permissions,
    required this.ownerId,
    required this.ownerDisplayName,
    required this.favorite,
    required this.hasPreview,
    required this.blurhash,
    required this.width,
    required this.height,
    required this.durationMillis,
    required this.previewUrl,
    required this.source,
  });
}

class NextcloudFileListPage {
  final List<NextcloudFileItemInfo> items;
  final int? total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const NextcloudFileListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class SeafileBindInfo {
  final String id;
  final String serverId;
  final String endpoint;
  final String username;
  final String version;
  final List<String> features;
  final int createdAt;
  final String providerInstanceName;

  const SeafileBindInfo({
    required this.id,
    required this.serverId,
    required this.endpoint,
    required this.username,
    required this.version,
    required this.features,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class SeafileFileItemInfo {
  final String repositoryId;
  final String repositoryName;
  final String path;
  final String name;
  final String objectId;
  final bool isDir;
  final int size;
  final String modifiedAt;
  final String permission;
  final String modifierName;
  final bool starred;
  final bool hasThumbnail;
  final bool repositoryEncrypted;
  final bool passwordRequired;
  final String thumbnailUrl;
  final provider_common.DiscoveredSource source;

  const SeafileFileItemInfo({
    required this.repositoryId,
    required this.repositoryName,
    required this.path,
    required this.name,
    required this.objectId,
    required this.isDir,
    required this.size,
    required this.modifiedAt,
    required this.permission,
    required this.modifierName,
    required this.starred,
    required this.hasThumbnail,
    required this.repositoryEncrypted,
    required this.passwordRequired,
    required this.thumbnailUrl,
    required this.source,
  });
}

class SeafileFileListPage {
  final List<SeafileFileItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const SeafileFileListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class TrueNasBindInfo {
  final String id;
  final String serverId;
  final String endpoint;
  final String hostname;
  final String version;
  final String systemProduct;
  final int createdAt;
  final String providerInstanceName;

  const TrueNasBindInfo({
    required this.id,
    required this.serverId,
    required this.endpoint,
    required this.hostname,
    required this.version,
    required this.systemProduct,
    required this.createdAt,
    required this.providerInstanceName,
  });
}

class TrueNasFileItemInfo {
  final String name;
  final String path;
  final String realpath;
  final bool isDir;
  final int size;
  final int allocationSize;
  final int mode;
  final int uid;
  final int gid;
  final int mountId;
  final bool acl;
  final bool isMountpoint;
  final bool isControlDirectory;
  final List<String> attributes;
  final List<String> extendedAttributes;
  final List<String> zfsAttributes;
  final provider_common.DiscoveredSource source;

  const TrueNasFileItemInfo({
    required this.name,
    required this.path,
    required this.realpath,
    required this.isDir,
    required this.size,
    required this.allocationSize,
    required this.mode,
    required this.uid,
    required this.gid,
    required this.mountId,
    required this.acl,
    required this.isMountpoint,
    required this.isControlDirectory,
    required this.attributes,
    required this.extendedAttributes,
    required this.zfsAttributes,
    required this.source,
  });
}

class TrueNasFileListPage {
  final List<TrueNasFileItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const TrueNasFileListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class SynologyFileItemInfo {
  final String name;
  final String path;
  final bool isDir;
  final int size;
  final int modifiedAt;
  final int createdAt;
  final String fileType;
  final String thumbnailUrl;
  final provider_common.DiscoveredSource source;

  const SynologyFileItemInfo({
    required this.name,
    required this.path,
    required this.isDir,
    required this.size,
    required this.modifiedAt,
    required this.createdAt,
    required this.fileType,
    required this.thumbnailUrl,
    required this.source,
  });
}

class SynologyFileListPage {
  final List<SynologyFileItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const SynologyFileListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class SynologyVideoLibraryInfo {
  final int id;
  final String title;
  final String type;
  final bool isPublic;
  final bool visible;

  const SynologyVideoLibraryInfo({
    required this.id,
    required this.title,
    required this.type,
    required this.isPublic,
    required this.visible,
  });
}

enum SynologyVideoCollection {
  movies,
  tvShows,
  episodes,
  homeVideos,
  tvRecordings,
}

enum SynologyVideoEntryType { movie, tvShow, episode, homeVideo, tvRecording }

class SynologyVideoFileInfo {
  final int id;
  final String path;
  final int size;
  final int durationSeconds;
  final int progressSeconds;
  final int width;
  final int height;
  final String videoCodec;
  final String audioCodec;
  final String container;
  final int videoBitrate;
  final int audioBitrate;
  final int frameRateNumerator;
  final int frameRateDenominator;
  final int audioChannels;
  final int audioFrequencyHz;
  final bool conversionProduced;

  const SynologyVideoFileInfo({
    required this.id,
    required this.path,
    required this.size,
    required this.durationSeconds,
    required this.progressSeconds,
    required this.width,
    required this.height,
    required this.videoCodec,
    required this.audioCodec,
    required this.container,
    this.videoBitrate = 0,
    this.audioBitrate = 0,
    this.frameRateNumerator = 0,
    this.frameRateDenominator = 0,
    this.audioChannels = 0,
    this.audioFrequencyHz = 0,
    required this.conversionProduced,
  });
}

class SynologyVideoItemInfo {
  final int id;
  final int libraryId;
  final SynologyVideoEntryType type;
  final String title;
  final String sortTitle;
  final String tagline;
  final String summary;
  final String certificate;
  final int rating;
  final List<String> actors;
  final List<String> directors;
  final List<String> writers;
  final List<String> genres;
  final String originalAvailable;
  final int createTime;
  final int lastWatched;
  final double watchedRatio;
  final bool parentalControlled;
  final int? season;
  final int? episode;
  final int? tvShowId;
  final List<SynologyVideoFileInfo> files;
  final String posterUrl;
  final provider_common.DiscoveredSource source;

  const SynologyVideoItemInfo({
    required this.id,
    required this.libraryId,
    required this.type,
    required this.title,
    this.sortTitle = '',
    this.tagline = '',
    required this.summary,
    required this.certificate,
    required this.rating,
    this.actors = const [],
    this.directors = const [],
    this.writers = const [],
    this.genres = const [],
    this.originalAvailable = '',
    this.createTime = 0,
    this.lastWatched = 0,
    this.watchedRatio = 0,
    this.parentalControlled = false,
    required this.season,
    required this.episode,
    required this.tvShowId,
    required this.files,
    required this.posterUrl,
    required this.source,
  });

  bool get isPlayable =>
      type != SynologyVideoEntryType.tvShow && files.isNotEmpty;
}

class SynologyVideoListPage {
  final List<SynologyVideoItemInfo> items;
  final int total;
  final int page;
  final bool hasMore;
  final provider_common.DiscoveredSource? source;

  const SynologyVideoListPage({
    required this.items,
    required this.total,
    required this.page,
    required this.hasMore,
    required this.source,
  });
}

class CloudreveAccountInfo {
  final String id;
  final String email;
  final String nickname;

  const CloudreveAccountInfo({
    required this.id,
    required this.email,
    required this.nickname,
  });
}

class CloudreveItemInfo {
  final String id;
  final String name;
  final String path;
  final int size;
  final bool isDir;
  final int modified;
  final String thumbnail;
  final provider_common.DiscoveredSource source;

  const CloudreveItemInfo({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.isDir,
    required this.modified,
    required this.thumbnail,
    required this.source,
  });
}

class CloudreveListPage {
  final String serverId;
  final String providerInstanceName;
  final List<CloudreveItemInfo> items;
  final int total;
  final bool usesCursor;
  final String nextCursor;
  final provider_common.DiscoveredSource? source;

  const CloudreveListPage({
    required this.serverId,
    required this.providerInstanceName,
    required this.items,
    required this.total,
    required this.usesCursor,
    required this.nextCursor,
    required this.source,
  });
}

class AlistAccountInfo {
  final String username;
  final String basePath;

  const AlistAccountInfo({required this.username, required this.basePath});
}

class AlistLoginInfo {
  final String token;
  final String serverId;

  const AlistLoginInfo({required this.token, required this.serverId});
}

class EmbyAccountInfo {
  final String id;
  final String name;

  const EmbyAccountInfo({required this.id, required this.name});
}

class BilibiliAccountInfo {
  final bool isLogin;
  final int userId;
  final String username;
  final String face;
  final bool isVip;

  const BilibiliAccountInfo({
    required this.isLogin,
    required this.userId,
    required this.username,
    required this.face,
    required this.isVip,
  });
}

enum BilibiliPlaylistListMode {
  popular,
  recommended,
  videoParts,
  upVideos,
  favoriteVideos,
  collectionVideos,
  seriesVideos,
  watchLater,
  pgcSeason,
  liveRecommended,
  liveFollowed,
  liveArea,
  history,
  pgcTimeline,
}

enum BilibiliPlaylistHistoryType { all, archive, live }

class BilibiliPlaylistListIntent {
  const BilibiliPlaylistListIntent({
    required this.mode,
    this.bvid = '',
    this.aid,
    this.mid = 0,
    this.keyword = '',
    this.mediaId = 0,
    this.seasonId = 0,
    this.seriesId = 0,
    this.parentAreaId = 0,
    this.areaId = 0,
    this.historyType = BilibiliPlaylistHistoryType.all,
    this.timelineType = BilibiliPgcTimelineKind.anime,
    this.beforeDays = 0,
    this.afterDays = 0,
  });

  final BilibiliPlaylistListMode mode;
  final String bvid;
  final int? aid;
  final int mid;
  final String keyword;
  final int mediaId;
  final int seasonId;
  final int seriesId;
  final int parentAreaId;
  final int areaId;
  final BilibiliPlaylistHistoryType historyType;
  final BilibiliPgcTimelineKind timelineType;
  final int beforeDays;
  final int afterDays;
}

class BilibiliPlaylistListItemInfo {
  const BilibiliPlaylistListItemInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.isContainer,
    required this.source,
    required this.browse,
  });

  final String id;
  final String title;
  final String description;
  final String cover;
  final bool isContainer;
  final provider_common.DiscoveredSource source;
  final BilibiliPlaylistListIntent? browse;
}

class BilibiliPlaylistListPage {
  const BilibiliPlaylistListPage({
    required this.items,
    required this.hasMore,
    required this.page,
    required this.cursor,
    required this.source,
  });

  final List<BilibiliPlaylistListItemInfo> items;
  final bool hasMore;
  final int page;
  final String? cursor;
  final provider_common.DiscoveredSource source;
}

class BilibiliFavoriteFolderInfo {
  final int mediaId;
  final String title;
  final int mediaCount;
  final bool isPrivate;
  final bool isDefault;
  final provider_common.DiscoveredSource source;

  const BilibiliFavoriteFolderInfo({
    required this.mediaId,
    required this.title,
    required this.mediaCount,
    required this.isPrivate,
    required this.isDefault,
    required this.source,
  });
}

class BilibiliFollowedPgcInfo {
  final int seasonId;
  final String title;
  final String cover;
  final String description;
  final String latestEpisode;
  final provider_common.DiscoveredSource source;

  const BilibiliFollowedPgcInfo({
    required this.seasonId,
    required this.title,
    required this.cover,
    required this.description,
    required this.latestEpisode,
    required this.source,
  });
}

class BilibiliFollowedPgcPage {
  final List<BilibiliFollowedPgcInfo> items;
  final int total;
  final bool hasMore;

  const BilibiliFollowedPgcPage({
    required this.items,
    required this.total,
    required this.hasMore,
  });
}

enum BilibiliPgcTimelineKind { anime, cinema, guochuang }

class BilibiliPgcTimelineItemInfo {
  final int episodeId;
  final int seasonId;
  final String title;
  final String episodeTitle;
  final String cover;
  final String episodeCover;
  final int publishAt;
  final bool published;
  final String date;
  final int dayOfWeek;
  final bool delayed;
  final String delayReason;
  final provider_common.DiscoveredSource? source;

  const BilibiliPgcTimelineItemInfo({
    required this.episodeId,
    required this.seasonId,
    required this.title,
    required this.episodeTitle,
    required this.cover,
    required this.episodeCover,
    required this.publishAt,
    required this.published,
    required this.date,
    required this.dayOfWeek,
    required this.delayed,
    required this.delayReason,
    required this.source,
  });
}

class BilibiliPgcTimelineInfo {
  final List<BilibiliPgcTimelineItemInfo> items;
  final provider_common.DiscoveredSource source;

  const BilibiliPgcTimelineInfo({required this.items, required this.source});
}

enum BilibiliPgcSeasonKind { anime, movie, documentary, guochuang, tv, variety }

enum BilibiliPgcSeasonOrder {
  updated,
  danmaku,
  play,
  follow,
  score,
  started,
  released,
}

class BilibiliPgcSeasonInfo {
  final int seasonId;
  final int mediaId;
  final int firstEpisodeId;
  final String title;
  final String subtitle;
  final String cover;
  final String firstEpisodeCover;
  final String badge;
  final String progress;
  final String score;
  final bool finished;
  final BilibiliPgcSeasonKind type;
  final provider_common.DiscoveredSource source;

  const BilibiliPgcSeasonInfo({
    required this.seasonId,
    required this.mediaId,
    required this.firstEpisodeId,
    required this.title,
    required this.subtitle,
    required this.cover,
    required this.firstEpisodeCover,
    required this.badge,
    required this.progress,
    required this.score,
    required this.finished,
    required this.type,
    required this.source,
  });
}

class BilibiliPgcSeasonPage {
  final List<BilibiliPgcSeasonInfo> items;
  final int total;
  final bool hasMore;

  const BilibiliPgcSeasonPage({
    required this.items,
    required this.total,
    required this.hasMore,
  });
}

class BilibiliQrLoginInfo {
  final String url;
  final String key;

  const BilibiliQrLoginInfo({required this.url, required this.key});
}

class BilibiliSmsLoginInfo {
  final String sessionToken;
  final String gt;
  final String challenge;
  final int expiresAt;

  const BilibiliSmsLoginInfo({
    required this.sessionToken,
    required this.gt,
    required this.challenge,
    required this.expiresAt,
  });

  BilibiliSmsLoginInfo copyWith({
    String? sessionToken,
    String? gt,
    String? challenge,
    int? expiresAt,
  }) {
    return BilibiliSmsLoginInfo(
      sessionToken: sessionToken ?? this.sessionToken,
      gt: gt ?? this.gt,
      challenge: challenge ?? this.challenge,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class BilibiliParseCandidateInfo {
  final String title;
  final String description;
  final String cover;
  final List<String> actors;
  final int? durationSeconds;
  final int? partNumber;
  final int? width;
  final int? height;
  final provider_common.DiscoveredSource source;
  final BilibiliPlaylistListIntent? browse;

  const BilibiliParseCandidateInfo({
    required this.title,
    required this.description,
    required this.cover,
    required this.actors,
    required this.durationSeconds,
    required this.partNumber,
    required this.width,
    required this.height,
    required this.source,
    required this.browse,
  });

  bool get isMedia => source.hasMedia();
  bool get isPlaylist => source.hasPlaylist();
}

class BilibiliParseInfo {
  final String normalizedUrl;
  final List<BilibiliParseCandidateInfo> candidates;

  const BilibiliParseInfo({
    required this.normalizedUrl,
    required this.candidates,
  });
}

class BilibiliLiveAreaInfo {
  final int id;
  final int parentId;
  final String name;
  final String parentName;
  final String picture;
  final bool hot;
  final provider_common.DiscoveredSource source;

  const BilibiliLiveAreaInfo({
    required this.id,
    required this.parentId,
    required this.name,
    required this.parentName,
    required this.picture,
    required this.hot,
    required this.source,
  });
}

class AlistItemInfo {
  final String name;
  final String path;
  final int size;
  final bool isDir;
  final int modified;
  final String thumb;
  final int type;
  final String sign;
  final provider_common.DiscoveredSource source;

  const AlistItemInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.isDir,
    required this.modified,
    required this.thumb,
    required this.type,
    this.sign = '',
    required this.source,
  });
}

class AlistListPage {
  final String serverId;
  final String providerInstanceName;
  final List<AlistItemInfo> items;
  final int total;
  final provider_common.DiscoveredSource? source;

  const AlistListPage({
    required this.serverId,
    required this.providerInstanceName,
    required this.items,
    required this.total,
    required this.source,
  });
}

class EmbyLoginInfo {
  final String userId;
  final String username;
  final bool isAdmin;
  final String serverId;

  const EmbyLoginInfo({
    required this.userId,
    required this.username,
    required this.isAdmin,
    required this.serverId,
  });
}

class EmbyItemInfo {
  final String id;
  final String name;
  final String type;
  final bool isDir;
  final String parentId;
  final String seriesName;
  final String seriesId;
  final String seasonName;
  final String thumbnail;
  final String description;
  final provider_common.DiscoveredSource source;

  const EmbyItemInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.isDir,
    required this.parentId,
    required this.seriesName,
    required this.seriesId,
    required this.seasonName,
    required this.thumbnail,
    this.description = '',
    required this.source,
  });
}

enum EmbyListMode {
  folder,
  favoriteItems,
  favoritePeople,
  personItems,
  continueWatching,
  nextUp,
  recentlyAdded,
  playlists,
  collections,
  genres,
  genreItems,
}

class EmbyListPage {
  final String serverId;
  final String providerInstanceName;
  final List<EmbyItemInfo> items;
  final int total;
  final provider_common.DiscoveredSource? source;

  const EmbyListPage({
    required this.serverId,
    required this.providerInstanceName,
    required this.items,
    required this.total,
    required this.source,
  });
}
