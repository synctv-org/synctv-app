import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

extension DiscoveredSourceAccess on provider_common.DiscoveredSource {
  bool get isMedia =>
      whichSourceConfig() ==
      provider_common.DiscoveredSource_SourceConfig.media;

  bool get isPlaylist =>
      whichSourceConfig() ==
      provider_common.DiscoveredSource_SourceConfig.playlist;

  source_config.MediaSourceConfig requireMedia() {
    if (!isMedia ||
        !hasMedia() ||
        media.whichProvider() ==
            source_config.MediaSourceConfig_Provider.notSet) {
      throw StateError('Provider discovery returned no media source');
    }
    return media.deepCopy();
  }

  source_config.PlaylistSourceConfig requirePlaylist() {
    if (!isPlaylist ||
        !hasPlaylist() ||
        playlist.whichProvider() ==
            source_config.PlaylistSourceConfig_Provider.notSet) {
      throw StateError('Provider discovery returned no playlist source');
    }
    return playlist.deepCopy();
  }

  provider_common.DiscoveredSource withPlaybackProxyMode(
    source_enum.PlaybackProxyMode mode,
  ) {
    final result = deepCopy();
    if (result.hasMedia()) {
      final media = result.media;
      switch (media.whichProvider()) {
        case source_config.MediaSourceConfig_Provider.directUrl:
          media.directUrl.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.alist:
          media.alist.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.bilibili:
          media.bilibili.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.emby:
          media.emby.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.cloudreve:
          media.cloudreve.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.fnos:
          media.fnos.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.qnap:
          media.qnap.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.synology:
          media.synology.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.nextcloud:
          media.nextcloud.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.seafile:
          media.seafile.proxyMode = mode;
        case source_config.MediaSourceConfig_Provider.truenas:
          media.truenas.proxyMode = mode;
        default:
          break;
      }
    }
    if (result.hasPlaylist()) {
      final playlist = result.playlist;
      switch (playlist.whichProvider()) {
        case source_config.PlaylistSourceConfig_Provider.alist:
          playlist.alist.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.bilibili:
          playlist.bilibili.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.emby:
          playlist.emby.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.cloudreve:
          playlist.cloudreve.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.fnos:
          playlist.fnos.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.qnap:
          playlist.qnap.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.synology:
          playlist.synology.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.nextcloud:
          playlist.nextcloud.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.seafile:
          playlist.seafile.proxyMode = mode;
        case source_config.PlaylistSourceConfig_Provider.truenas:
          playlist.truenas.proxyMode = mode;
        default:
          break;
      }
    }
    return result;
  }
}
