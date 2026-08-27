import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:synctv_app/contracts/proto_mapping.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

class SourceConfigCodec {
  const SourceConfigCodec._();

  static source_enum.SourceProvider providerFromString(String value) {
    final normalized = value.trim();
    final numeric = int.tryParse(normalized);
    if (numeric != null) {
      return source_enum.SourceProvider.valueOf(numeric) ??
          source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED;
    }
    final lowercase = normalized.toLowerCase();
    final providerName = lowercase.startsWith('source_provider_')
        ? lowercase.substring('source_provider_'.length)
        : lowercase;
    return switch (providerName) {
      '' ||
      'unspecified' => source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
      'direct_url' ||
      'directurl' => source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
      'bilibili' => source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
      'alist' => source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
      'emby' => source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
      'rtmp' => source_enum.SourceProvider.SOURCE_PROVIDER_RTMP,
      'live_proxy' ||
      'liveproxy' => source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
      'cloudreve' => source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
      'twitch' => source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
      'huya' => source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
      'douyu' => source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
      'douyin' => source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
      'acfun' => source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
      'cctv' => source_enum.SourceProvider.SOURCE_PROVIDER_CCTV,
      'fnos' => source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
      'qnap' => source_enum.SourceProvider.SOURCE_PROVIDER_QNAP,
      'synology' => source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY,
      'nextcloud' => source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD,
      'seafile' => source_enum.SourceProvider.SOURCE_PROVIDER_SEAFILE,
      'truenas' => source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
      'youtube' => source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE,
      'tiktok' => source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
      _ => source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    };
  }

  static String providerToString(source_enum.SourceProvider value) {
    return switch (value) {
      source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL => 'directUrl',
      source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI => 'bilibili',
      source_enum.SourceProvider.SOURCE_PROVIDER_ALIST => 'alist',
      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY => 'emby',
      source_enum.SourceProvider.SOURCE_PROVIDER_RTMP => 'rtmp',
      source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY => 'liveProxy',
      source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE => 'cloudreve',
      source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH => 'twitch',
      source_enum.SourceProvider.SOURCE_PROVIDER_HUYA => 'huya',
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU => 'douyu',
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN => 'douyin',
      source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN => 'acfun',
      source_enum.SourceProvider.SOURCE_PROVIDER_CCTV => 'cctv',
      source_enum.SourceProvider.SOURCE_PROVIDER_FNOS => 'fnos',
      source_enum.SourceProvider.SOURCE_PROVIDER_QNAP => 'qnap',
      source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY => 'synology',
      source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD => 'nextcloud',
      source_enum.SourceProvider.SOURCE_PROVIDER_SEAFILE => 'seafile',
      source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS => 'truenas',
      source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE => 'youtube',
      source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK => 'tiktok',
      _ => '',
    };
  }

  static source_enum.SourceProvider providerForMediaSourceConfig(
    source_config.MediaSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.MediaSourceConfig_Provider.directUrl =>
        source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
      source_config.MediaSourceConfig_Provider.bilibili =>
        source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
      source_config.MediaSourceConfig_Provider.alist =>
        source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
      source_config.MediaSourceConfig_Provider.emby =>
        source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
      source_config.MediaSourceConfig_Provider.rtmp =>
        source_enum.SourceProvider.SOURCE_PROVIDER_RTMP,
      source_config.MediaSourceConfig_Provider.liveProxy =>
        source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
      source_config.MediaSourceConfig_Provider.cloudreve =>
        source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
      source_config.MediaSourceConfig_Provider.twitch =>
        source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
      source_config.MediaSourceConfig_Provider.huya =>
        source_enum.SourceProvider.SOURCE_PROVIDER_HUYA,
      source_config.MediaSourceConfig_Provider.douyu =>
        source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU,
      source_config.MediaSourceConfig_Provider.douyin =>
        source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
      source_config.MediaSourceConfig_Provider.acFun =>
        source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN,
      source_config.MediaSourceConfig_Provider.cctv =>
        source_enum.SourceProvider.SOURCE_PROVIDER_CCTV,
      source_config.MediaSourceConfig_Provider.fnos =>
        source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
      source_config.MediaSourceConfig_Provider.qnap =>
        source_enum.SourceProvider.SOURCE_PROVIDER_QNAP,
      source_config.MediaSourceConfig_Provider.synology =>
        source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY,
      source_config.MediaSourceConfig_Provider.nextcloud =>
        source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD,
      source_config.MediaSourceConfig_Provider.seafile =>
        source_enum.SourceProvider.SOURCE_PROVIDER_SEAFILE,
      source_config.MediaSourceConfig_Provider.truenas =>
        source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
      source_config.MediaSourceConfig_Provider.youtube =>
        source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE,
      source_config.MediaSourceConfig_Provider.tiktok =>
        source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
      source_config.MediaSourceConfig_Provider.notSet =>
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    };
  }

  static source_enum.SourceProvider providerForPlaylistSourceConfig(
    source_config.PlaylistSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.PlaylistSourceConfig_Provider.bilibili =>
        source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
      source_config.PlaylistSourceConfig_Provider.alist =>
        source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
      source_config.PlaylistSourceConfig_Provider.emby =>
        source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
      source_config.PlaylistSourceConfig_Provider.cloudreve =>
        source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE,
      source_config.PlaylistSourceConfig_Provider.twitch =>
        source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH,
      source_config.PlaylistSourceConfig_Provider.douyin =>
        source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN,
      source_config.PlaylistSourceConfig_Provider.fnos =>
        source_enum.SourceProvider.SOURCE_PROVIDER_FNOS,
      source_config.PlaylistSourceConfig_Provider.qnap =>
        source_enum.SourceProvider.SOURCE_PROVIDER_QNAP,
      source_config.PlaylistSourceConfig_Provider.synology =>
        source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY,
      source_config.PlaylistSourceConfig_Provider.nextcloud =>
        source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD,
      source_config.PlaylistSourceConfig_Provider.seafile =>
        source_enum.SourceProvider.SOURCE_PROVIDER_SEAFILE,
      source_config.PlaylistSourceConfig_Provider.truenas =>
        source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS,
      source_config.PlaylistSourceConfig_Provider.youtube =>
        source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE,
      source_config.PlaylistSourceConfig_Provider.tiktok =>
        source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK,
      source_config.PlaylistSourceConfig_Provider.notSet =>
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    };
  }

  static bool isSpecified(source_enum.SourceProvider value) {
    return value != source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED;
  }

  static List<source_enum.SourceProvider> providersFromStrings(
    Iterable<String> values,
  ) {
    return values.map(providerFromString).where(isSpecified).toList();
  }

  static List<String> providersToStrings(
    Iterable<source_enum.SourceProvider> values,
  ) {
    return values
        .map(providerToString)
        .where((value) => value.isNotEmpty)
        .toList();
  }

  static String providerJsonValue(pb.ProtobufEnum value) {
    if (value is source_enum.SourceProvider) return providerToString(value);
    return value.value.toString();
  }

  static source_config.MediaSourceConfig? mediaSourceConfigFromMap({
    required source_enum.SourceProvider sourceProvider,
    required Map<String, dynamic> sourceConfig,
  }) {
    return mediaSourceConfigForProvider(sourceProvider, sourceConfig);
  }

  static source_config.MediaSourceConfig? mediaSourceConfigForProvider(
    source_enum.SourceProvider provider,
    Map<String, dynamic> config,
  ) {
    return switch (provider) {
      source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL =>
        source_config.MediaSourceConfig(
          directUrl: _directUrlMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI =>
        source_config.MediaSourceConfig(
          bilibili: _bilibiliMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_ALIST =>
        source_config.MediaSourceConfig(
          alist: source_config.AlistMediaSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            password: _optionalString(config['password']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY =>
        source_config.MediaSourceConfig(
          emby: source_config.EmbyMediaSourceConfig(
            serverId: _string(config['serverId']),
            itemId: _string(config['itemId']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_RTMP =>
        source_config.MediaSourceConfig(
          rtmp: source_config.RtmpMediaSourceConfig(
            mode: _rtmpStreamModeFromValue(config['mode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY =>
        source_config.MediaSourceConfig(
          liveProxy: _liveProxyMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE =>
        source_config.MediaSourceConfig(
          cloudreve: source_config.CloudreveMediaSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH =>
        source_config.MediaSourceConfig(
          twitch: _twitchMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_HUYA =>
        source_config.MediaSourceConfig(huya: _huyaMediaSourceConfig(config)),
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYU =>
        source_config.MediaSourceConfig(
          douyu: source_config.DouyuMediaSourceConfig(
            room: _string(config['room']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN =>
        source_config.MediaSourceConfig(
          douyin: _douyinMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK =>
        source_config.MediaSourceConfig(
          tiktok: _tiktokMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_ACFUN =>
        source_config.MediaSourceConfig(acFun: _acFunMediaSourceConfig(config)),
      source_enum.SourceProvider.SOURCE_PROVIDER_CCTV =>
        source_config.MediaSourceConfig(
          cctv: source_config.CctvMediaSourceConfig(
            resource: _string(config['resource']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_FNOS =>
        source_config.MediaSourceConfig(fnos: _fnosMediaSourceConfig(config)),
      source_enum.SourceProvider.SOURCE_PROVIDER_QNAP =>
        source_config.MediaSourceConfig(
          qnap: source_config.QnapMediaSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY =>
        source_config.MediaSourceConfig(
          synology: _synologyMediaSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD =>
        source_config.MediaSourceConfig(
          nextcloud: source_config.NextcloudMediaSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            fileId: Int64(_int(config['fileId'])),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_SEAFILE =>
        source_config.MediaSourceConfig(
          seafile: source_config.SeafileMediaSourceConfig(
            serverId: _string(config['serverId']),
            repositoryId: _string(config['repositoryId']),
            path: _string(config['path']),
            objectId: _string(config['objectId']),
            hasThumbnail: config['hasThumbnail'] == true,
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS =>
        source_config.MediaSourceConfig(
          truenas: source_config.TrueNasMediaSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE =>
        source_config.MediaSourceConfig(
          youtube: source_config.YoutubeMediaSourceConfig(
            videoId: _string(config['videoId']),
            shared: config['shared'] == true,
          ),
        ),
      _ => null,
    };
  }

  static source_config.PlaylistSourceConfig? playlistSourceConfigFromMap({
    required source_enum.SourceProvider sourceProvider,
    required Map<String, dynamic> sourceConfig,
  }) {
    return playlistSourceConfigForProvider(sourceProvider, sourceConfig);
  }

  static source_config.PlaylistSourceConfig? playlistSourceConfigForProvider(
    source_enum.SourceProvider provider,
    Map<String, dynamic> config,
  ) {
    return switch (provider) {
      source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI =>
        source_config.PlaylistSourceConfig(
          bilibili: _bilibiliPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_ALIST =>
        source_config.PlaylistSourceConfig(
          alist: source_config.AlistPlaylistSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            password: _optionalString(config['password']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY =>
        source_config.PlaylistSourceConfig(
          emby: _embyPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_CLOUDREVE =>
        source_config.PlaylistSourceConfig(
          cloudreve: source_config.CloudrevePlaylistSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
            proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_TWITCH =>
        source_config.PlaylistSourceConfig(
          twitch: _twitchPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_DOUYIN =>
        source_config.PlaylistSourceConfig(
          douyin: source_config.DouyinPlaylistSourceConfig(
            secUid: _string(config['secUid']),
            shared: config['shared'] == true,
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_TIKTOK =>
        source_config.PlaylistSourceConfig(
          tiktok: source_config.TikTokPlaylistSourceConfig(
            secUid: _string(config['secUid']),
            shared: config['shared'] == true,
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_FNOS =>
        source_config.PlaylistSourceConfig(
          fnos: _fnosPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_QNAP =>
        source_config.PlaylistSourceConfig(
          qnap: source_config.QnapPlaylistSourceConfig(
            serverId: _string(config['serverId']),
            path: _string(config['path']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_SYNOLOGY =>
        source_config.PlaylistSourceConfig(
          synology: _synologyPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_NEXTCLOUD =>
        source_config.PlaylistSourceConfig(
          nextcloud: _nextcloudPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_SEAFILE =>
        source_config.PlaylistSourceConfig(
          seafile: _seafilePlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_TRUENAS =>
        source_config.PlaylistSourceConfig(
          truenas: _trueNasPlaylistSourceConfig(config),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_YOUTUBE =>
        source_config.PlaylistSourceConfig(
          youtube: _youtubePlaylistSourceConfig(config),
        ),
      _ => null,
    };
  }

  static Map<String, dynamic> mediaSourceConfigToMap(
    source_config.MediaSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.MediaSourceConfig_Provider.directUrl =>
        _directUrlMediaSourceConfigToMap(config.directUrl),
      source_config.MediaSourceConfig_Provider.bilibili =>
        _bilibiliMediaSourceConfigToMap(config.bilibili),
      source_config.MediaSourceConfig_Provider.alist => {
        if (config.alist.serverId.isNotEmpty) 'serverId': config.alist.serverId,
        'path': config.alist.path,
        if (config.alist.hasPassword()) 'password': config.alist.password,
        ..._playbackProxyModeMap(config.alist.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.emby => {
        if (config.emby.serverId.isNotEmpty) 'serverId': config.emby.serverId,
        'itemId': config.emby.itemId,
        ..._playbackProxyModeMap(config.emby.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.rtmp => {
        'mode': _rtmpStreamModeToString(config.rtmp.mode),
      },
      source_config.MediaSourceConfig_Provider.liveProxy =>
        _liveProxyMediaSourceConfigToMap(config.liveProxy),
      source_config.MediaSourceConfig_Provider.cloudreve => {
        if (config.cloudreve.serverId.isNotEmpty)
          'serverId': config.cloudreve.serverId,
        'path': config.cloudreve.path,
        ..._playbackProxyModeMap(config.cloudreve.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.twitch =>
        _twitchMediaSourceConfigToMap(config.twitch),
      source_config.MediaSourceConfig_Provider.huya =>
        _huyaMediaSourceConfigToMap(config.huya),
      source_config.MediaSourceConfig_Provider.douyu => {
        'room': config.douyu.room,
      },
      source_config.MediaSourceConfig_Provider.douyin =>
        _douyinMediaSourceConfigToMap(config.douyin),
      source_config.MediaSourceConfig_Provider.tiktok =>
        _tiktokMediaSourceConfigToMap(config.tiktok),
      source_config.MediaSourceConfig_Provider.acFun =>
        _acFunMediaSourceConfigToMap(config.acFun),
      source_config.MediaSourceConfig_Provider.cctv => {
        'resource': config.cctv.resource,
      },
      source_config.MediaSourceConfig_Provider.fnos =>
        _fnosMediaSourceConfigToMap(config.fnos),
      source_config.MediaSourceConfig_Provider.qnap => {
        'serverId': config.qnap.serverId,
        'path': config.qnap.path,
        ..._playbackProxyModeMap(config.qnap.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.synology =>
        _synologyMediaSourceConfigToMap(config.synology),
      source_config.MediaSourceConfig_Provider.nextcloud => {
        'serverId': config.nextcloud.serverId,
        'path': config.nextcloud.path,
        'fileId': config.nextcloud.fileId.toInt(),
        ..._playbackProxyModeMap(config.nextcloud.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.seafile => {
        'serverId': config.seafile.serverId,
        'repositoryId': config.seafile.repositoryId,
        'path': config.seafile.path,
        'objectId': config.seafile.objectId,
        if (config.seafile.hasThumbnail) 'hasThumbnail': true,
        ..._playbackProxyModeMap(config.seafile.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.truenas => {
        'serverId': config.truenas.serverId,
        'path': config.truenas.path,
        ..._playbackProxyModeMap(config.truenas.proxyMode),
      },
      source_config.MediaSourceConfig_Provider.youtube => {
        'videoId': config.youtube.videoId,
        if (config.youtube.shared) 'shared': true,
      },
      source_config.MediaSourceConfig_Provider.notSet => <String, dynamic>{},
    };
  }

  static bool isLiveMediaSourceConfig(source_config.MediaSourceConfig config) {
    return switch (config.whichProvider()) {
      source_config.MediaSourceConfig_Provider.directUrl =>
        config.directUrl.hasPlaybackKind() &&
            config.directUrl.playbackKind ==
                source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
      source_config.MediaSourceConfig_Provider.bilibili =>
        config.bilibili.whichSource() ==
            source_config.BilibiliMediaSourceConfig_Source.live,
      source_config.MediaSourceConfig_Provider.rtmp ||
      source_config.MediaSourceConfig_Provider.liveProxy ||
      source_config.MediaSourceConfig_Provider.douyu => true,
      source_config.MediaSourceConfig_Provider.twitch =>
        config.twitch.whichSource() ==
            source_config.TwitchMediaSourceConfig_Source.live,
      source_config.MediaSourceConfig_Provider.huya =>
        config.huya.whichSource() ==
            source_config.HuyaMediaSourceConfig_Source.live,
      source_config.MediaSourceConfig_Provider.douyin =>
        config.douyin.whichSource() ==
            source_config.DouyinMediaSourceConfig_Source.live,
      source_config.MediaSourceConfig_Provider.tiktok =>
        config.tiktok.whichSource() ==
            source_config.TikTokMediaSourceConfig_Source.live,
      source_config.MediaSourceConfig_Provider.acFun =>
        config.acFun.whichSource() ==
            source_config.AcFunMediaSourceConfig_Source.live,
      _ => false,
    };
  }

  static Map<String, dynamic> playlistSourceConfigToMap(
    source_config.PlaylistSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.PlaylistSourceConfig_Provider.bilibili =>
        _bilibiliPlaylistSourceConfigToMap(config.bilibili),
      source_config.PlaylistSourceConfig_Provider.alist => {
        if (config.alist.serverId.isNotEmpty) 'serverId': config.alist.serverId,
        'path': config.alist.path,
        if (config.alist.hasPassword()) 'password': config.alist.password,
        ..._playbackProxyModeMap(config.alist.proxyMode),
      },
      source_config.PlaylistSourceConfig_Provider.emby => {
        ..._embyPlaylistSourceConfigToMap(config.emby),
      },
      source_config.PlaylistSourceConfig_Provider.cloudreve => {
        if (config.cloudreve.serverId.isNotEmpty)
          'serverId': config.cloudreve.serverId,
        'path': config.cloudreve.path,
        ..._playbackProxyModeMap(config.cloudreve.proxyMode),
      },
      source_config.PlaylistSourceConfig_Provider.twitch =>
        _twitchPlaylistSourceConfigToMap(config.twitch),
      source_config.PlaylistSourceConfig_Provider.douyin => {
        'secUid': config.douyin.secUid,
        if (config.douyin.shared) 'shared': true,
      },
      source_config.PlaylistSourceConfig_Provider.tiktok => {
        'secUid': config.tiktok.secUid,
        if (config.tiktok.shared) 'shared': true,
      },
      source_config.PlaylistSourceConfig_Provider.fnos =>
        _fnosPlaylistSourceConfigToMap(config.fnos),
      source_config.PlaylistSourceConfig_Provider.qnap => {
        'serverId': config.qnap.serverId,
        'path': config.qnap.path,
        ..._playbackProxyModeMap(config.qnap.proxyMode),
      },
      source_config.PlaylistSourceConfig_Provider.synology =>
        _synologyPlaylistSourceConfigToMap(config.synology),
      source_config.PlaylistSourceConfig_Provider.nextcloud => {
        ..._nextcloudPlaylistSourceConfigToMap(config.nextcloud),
        ..._playbackProxyModeMap(config.nextcloud.proxyMode),
      },
      source_config.PlaylistSourceConfig_Provider.seafile => {
        ..._seafilePlaylistSourceConfigToMap(config.seafile),
        ..._playbackProxyModeMap(config.seafile.proxyMode),
      },
      source_config.PlaylistSourceConfig_Provider.truenas => {
        ..._trueNasPlaylistSourceConfigToMap(config.truenas),
        ..._playbackProxyModeMap(config.truenas.proxyMode),
      },
      source_config.PlaylistSourceConfig_Provider.youtube =>
        _youtubePlaylistSourceConfigToMap(config.youtube),
      source_config.PlaylistSourceConfig_Provider.notSet => <String, dynamic>{},
    };
  }

  static Map<String, dynamic> mediaSourceConfigJson(
    source_config.MediaSourceConfig config,
  ) {
    return protoMessageToIntegerEnumJsonMap(config);
  }

  static Map<String, dynamic> playlistSourceConfigJson(
    source_config.PlaylistSourceConfig config,
  ) {
    return protoMessageToIntegerEnumJsonMap(config);
  }

  static source_config.SynologyMediaSourceConfig _synologyMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final serverId = _string(config['serverId']);
    return switch (_string(config['type'])) {
      'file' => source_config.SynologyMediaSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        file: source_config.SynologyFileSourceConfig(
          path: _string(config['path']),
        ),
      ),
      'libraryItem' => source_config.SynologyMediaSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        libraryItem: source_config.SynologyLibraryItemSourceConfig(
          kind: _synologyLibraryItemKind(config['kind']),
          itemId: Int64(_int(config['itemId'])),
          fileId: Int64(_int(config['fileId'])),
        ),
      ),
      _ => source_config.SynologyMediaSourceConfig(serverId: serverId),
    };
  }

  static source_config.BilibiliPlaylistSourceConfig
  _bilibiliPlaylistSourceConfig(Map<String, dynamic> config) {
    final source = _dynamicMap(config['source']);
    final shared = config['shared'] == true;
    final result = switch (_string(source['type']).toLowerCase()) {
      'videoparts' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        videoParts: source_config.BilibiliVideoPartsPlaylistSource(
          bvid: _string(source['bvid']),
          aid: _optionalInt64(source['aid']),
        ),
      ),
      'popular' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        popular: source_config.BilibiliPopularPlaylistSource(),
      ),
      'recommended' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        recommended: source_config.BilibiliRecommendedPlaylistSource(),
      ),
      'upvideos' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        upVideos: source_config.BilibiliUpVideosPlaylistSource(
          mid: Int64(_int(source['mid'])),
          keyword: _string(source['keyword']),
        ),
      ),
      'favoritevideos' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        favoriteVideos: source_config.BilibiliFavoriteVideosPlaylistSource(
          mediaId: Int64(_int(source['mediaId'])),
        ),
      ),
      'collectionvideos' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        collectionVideos: source_config.BilibiliCollectionVideosPlaylistSource(
          mid: Int64(_int(source['mid'])),
          seasonId: Int64(_int(source['seasonId'])),
        ),
      ),
      'seriesvideos' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        seriesVideos: source_config.BilibiliSeriesVideosPlaylistSource(
          mid: Int64(_int(source['mid'])),
          seriesId: Int64(_int(source['seriesId'])),
        ),
      ),
      'watchlater' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        watchLater: source_config.BilibiliWatchLaterPlaylistSource(),
      ),
      'pgcseason' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        pgcSeason: source_config.BilibiliPgcSeasonPlaylistSource(
          seasonId: Int64(_int(source['seasonId'])),
        ),
      ),
      'liverecommended' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        liveRecommended: source_config.BilibiliLiveRecommendedPlaylistSource(),
      ),
      'livefollowed' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        liveFollowed: source_config.BilibiliLiveFollowedPlaylistSource(),
      ),
      'livearea' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        liveArea: source_config.BilibiliLiveAreaPlaylistSource(
          parentAreaId: Int64(_int(source['parentAreaId'])),
          areaId: Int64(_int(source['areaId'])),
        ),
      ),
      'history' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        history: source_config.BilibiliHistoryPlaylistSource(
          type: switch (_string(source['historyType']).trim().toLowerCase()) {
            'archive' =>
              source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ARCHIVE,
            'live' =>
              source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_LIVE,
            _ => source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ALL,
          },
        ),
      ),
      'pgctimeline' => source_config.BilibiliPlaylistSourceConfig(
        shared: shared,
        pgcTimeline: source_config.BilibiliPgcTimelinePlaylistSource(
          type: switch (_string(source['timelineType']).trim().toLowerCase()) {
            'cinema' =>
              source_enum
                  .BilibiliPgcTimelineType
                  .BILIBILI_PGC_TIMELINE_TYPE_CINEMA,
            'guochuang' =>
              source_enum
                  .BilibiliPgcTimelineType
                  .BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG,
            _ =>
              source_enum
                  .BilibiliPgcTimelineType
                  .BILIBILI_PGC_TIMELINE_TYPE_ANIME,
          },
          beforeDays: _int(source['beforeDays']),
          afterDays: _int(source['afterDays']),
        ),
      ),
      _ => source_config.BilibiliPlaylistSourceConfig(shared: shared),
    };
    result.proxyMode = _playbackProxyModeFromValue(config['proxyMode']);
    return result;
  }

  static Map<String, dynamic> _bilibiliPlaylistSourceConfigToMap(
    source_config.BilibiliPlaylistSourceConfig config,
  ) {
    final source = switch (config.whichSource()) {
      source_config.BilibiliPlaylistSourceConfig_Source.videoParts => {
        'type': 'videoParts',
        'bvid': config.videoParts.bvid,
        if (config.videoParts.hasAid()) 'aid': config.videoParts.aid.toInt(),
      },
      source_config.BilibiliPlaylistSourceConfig_Source.popular => {
        'type': 'popular',
      },
      source_config.BilibiliPlaylistSourceConfig_Source.recommended => {
        'type': 'recommended',
      },
      source_config.BilibiliPlaylistSourceConfig_Source.upVideos => {
        'type': 'upVideos',
        'mid': config.upVideos.mid.toInt(),
        if (config.upVideos.keyword.isNotEmpty)
          'keyword': config.upVideos.keyword,
      },
      source_config.BilibiliPlaylistSourceConfig_Source.favoriteVideos => {
        'type': 'favoriteVideos',
        'mediaId': config.favoriteVideos.mediaId.toInt(),
      },
      source_config.BilibiliPlaylistSourceConfig_Source.collectionVideos => {
        'type': 'collectionVideos',
        'mid': config.collectionVideos.mid.toInt(),
        'seasonId': config.collectionVideos.seasonId.toInt(),
      },
      source_config.BilibiliPlaylistSourceConfig_Source.seriesVideos => {
        'type': 'seriesVideos',
        'mid': config.seriesVideos.mid.toInt(),
        'seriesId': config.seriesVideos.seriesId.toInt(),
      },
      source_config.BilibiliPlaylistSourceConfig_Source.watchLater => {
        'type': 'watchLater',
      },
      source_config.BilibiliPlaylistSourceConfig_Source.pgcSeason => {
        'type': 'pgcSeason',
        'seasonId': config.pgcSeason.seasonId.toInt(),
      },
      source_config.BilibiliPlaylistSourceConfig_Source.liveRecommended => {
        'type': 'liveRecommended',
      },
      source_config.BilibiliPlaylistSourceConfig_Source.liveFollowed => {
        'type': 'liveFollowed',
      },
      source_config.BilibiliPlaylistSourceConfig_Source.liveArea => {
        'type': 'liveArea',
        'parentAreaId': config.liveArea.parentAreaId.toInt(),
        'areaId': config.liveArea.areaId.toInt(),
      },
      source_config.BilibiliPlaylistSourceConfig_Source.history => {
        'type': 'history',
        'historyType': switch (config.history.type) {
          source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_ARCHIVE =>
            'archive',
          source_enum.BilibiliHistoryType.BILIBILI_HISTORY_TYPE_LIVE => 'live',
          _ => 'all',
        },
      },
      source_config.BilibiliPlaylistSourceConfig_Source.pgcTimeline => {
        'type': 'pgcTimeline',
        'timelineType': switch (config.pgcTimeline.type) {
          source_enum
              .BilibiliPgcTimelineType
              .BILIBILI_PGC_TIMELINE_TYPE_CINEMA =>
            'cinema',
          source_enum
              .BilibiliPgcTimelineType
              .BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG =>
            'guochuang',
          _ => 'anime',
        },
        'beforeDays': config.pgcTimeline.beforeDays,
        'afterDays': config.pgcTimeline.afterDays,
      },
      source_config.BilibiliPlaylistSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
    return {
      'source': source,
      if (config.shared) 'shared': true,
      ..._playbackProxyModeMap(config.proxyMode),
    };
  }

  static source_config.EmbyPlaylistSourceConfig _embyPlaylistSourceConfig(
    Map<String, dynamic> config,
  ) {
    final serverId = _string(config['serverId']);
    final source = _dynamicMap(config['source']);
    final result = switch (_string(source['type']).toLowerCase()) {
      'folder' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        folder: source_config.EmbyFolderPlaylistSource(
          itemId: _string(source['itemId']),
        ),
      ),
      'favoriteitems' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        favoriteItems: source_config.EmbyFavoriteItemsPlaylistSource(
          itemTypes: _stringList(source['itemTypes']),
        ),
      ),
      'favoritepeople' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        favoritePeople: source_config.EmbyFavoritePeoplePlaylistSource(),
      ),
      'personitems' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        personItems: source_config.EmbyPersonItemsPlaylistSource(
          personId: _string(source['personId']),
          itemTypes: _stringList(source['itemTypes']),
        ),
      ),
      'continuewatching' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        continueWatching: source_config.EmbyContinueWatchingPlaylistSource(),
      ),
      'nextup' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        nextUp: source_config.EmbyNextUpPlaylistSource(),
      ),
      'recentlyadded' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        recentlyAdded: source_config.EmbyRecentlyAddedPlaylistSource(
          itemTypes: _stringList(source['itemTypes']),
        ),
      ),
      'playlists' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        playlists: source_config.EmbyPlaylistsPlaylistSource(),
      ),
      'collections' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        collections: source_config.EmbyCollectionsPlaylistSource(),
      ),
      'genres' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        genres: source_config.EmbyGenresPlaylistSource(
          itemTypes: _stringList(source['itemTypes']),
        ),
      ),
      'genreitems' => source_config.EmbyPlaylistSourceConfig(
        serverId: serverId,
        genreItems: source_config.EmbyGenreItemsPlaylistSource(
          genreId: _string(source['genreId']),
          itemTypes: _stringList(source['itemTypes']),
        ),
      ),
      _ => source_config.EmbyPlaylistSourceConfig(serverId: serverId),
    };
    result.proxyMode = _playbackProxyModeFromValue(config['proxyMode']);
    return result;
  }

  static Map<String, dynamic> _embyPlaylistSourceConfigToMap(
    source_config.EmbyPlaylistSourceConfig config,
  ) {
    final source = switch (config.whichSource()) {
      source_config.EmbyPlaylistSourceConfig_Source.folder => {
        'type': 'folder',
        'itemId': config.folder.itemId,
      },
      source_config.EmbyPlaylistSourceConfig_Source.favoriteItems => {
        'type': 'favoriteItems',
        'itemTypes': config.favoriteItems.itemTypes,
      },
      source_config.EmbyPlaylistSourceConfig_Source.favoritePeople => {
        'type': 'favoritePeople',
      },
      source_config.EmbyPlaylistSourceConfig_Source.personItems => {
        'type': 'personItems',
        'personId': config.personItems.personId,
        'itemTypes': config.personItems.itemTypes,
      },
      source_config.EmbyPlaylistSourceConfig_Source.continueWatching => {
        'type': 'continueWatching',
      },
      source_config.EmbyPlaylistSourceConfig_Source.nextUp => {
        'type': 'nextUp',
      },
      source_config.EmbyPlaylistSourceConfig_Source.recentlyAdded => {
        'type': 'recentlyAdded',
        'itemTypes': config.recentlyAdded.itemTypes,
      },
      source_config.EmbyPlaylistSourceConfig_Source.playlists => {
        'type': 'playlists',
      },
      source_config.EmbyPlaylistSourceConfig_Source.collections => {
        'type': 'collections',
      },
      source_config.EmbyPlaylistSourceConfig_Source.genres => {
        'type': 'genres',
        'itemTypes': config.genres.itemTypes,
      },
      source_config.EmbyPlaylistSourceConfig_Source.genreItems => {
        'type': 'genreItems',
        'genreId': config.genreItems.genreId,
        'itemTypes': config.genreItems.itemTypes,
      },
      source_config.EmbyPlaylistSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
    return {
      'serverId': config.serverId,
      'source': source,
      ..._playbackProxyModeMap(config.proxyMode),
    };
  }

  static source_config.NextcloudPlaylistSourceConfig
  _nextcloudPlaylistSourceConfig(Map<String, dynamic> config) {
    final serverId = _string(config['serverId']);
    final source = _dynamicMap(config['source']);
    return switch (_string(source['type']).toLowerCase()) {
      'folder' => source_config.NextcloudPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        folder: source_config.NextcloudFolderPlaylistSourceConfig(
          path: _string(source['path']),
        ),
      ),
      'favorites' => source_config.NextcloudPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        favorites: source_config.NextcloudFavoritesPlaylistSourceConfig(),
      ),
      'search' => source_config.NextcloudPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        search: source_config.NextcloudSearchPlaylistSourceConfig(
          path: _string(source['path']),
          query: _string(source['query']),
        ),
      ),
      _ => source_config.NextcloudPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
      ),
    };
  }

  static Map<String, dynamic> _nextcloudPlaylistSourceConfigToMap(
    source_config.NextcloudPlaylistSourceConfig config,
  ) {
    final source = switch (config.whichSource()) {
      source_config.NextcloudPlaylistSourceConfig_Source.folder => {
        'type': 'folder',
        'path': config.folder.path,
      },
      source_config.NextcloudPlaylistSourceConfig_Source.favorites => {
        'type': 'favorites',
      },
      source_config.NextcloudPlaylistSourceConfig_Source.search => {
        'type': 'search',
        'path': config.search.path,
        'query': config.search.query,
      },
      source_config.NextcloudPlaylistSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
    return {
      'serverId': config.serverId,
      'source': source,
      ..._playbackProxyModeMap(config.proxyMode),
    };
  }

  static source_config.SeafilePlaylistSourceConfig _seafilePlaylistSourceConfig(
    Map<String, dynamic> config,
  ) {
    final serverId = _string(config['serverId']);
    final source = _dynamicMap(config['source']);
    return switch (_string(source['type']).toLowerCase()) {
      'folder' => source_config.SeafilePlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        folder: source_config.SeafileFolderPlaylistSourceConfig(
          repositoryId: _string(source['repositoryId']),
          path: _string(source['path']),
        ),
      ),
      'starred' => source_config.SeafilePlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        starred: source_config.SeafileStarredPlaylistSourceConfig(),
      ),
      'search' => source_config.SeafilePlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        search: source_config.SeafileSearchPlaylistSourceConfig(
          repositoryId: _string(source['repositoryId']),
          query: _string(source['query']),
        ),
      ),
      _ => source_config.SeafilePlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
      ),
    };
  }

  static Map<String, dynamic> _seafilePlaylistSourceConfigToMap(
    source_config.SeafilePlaylistSourceConfig config,
  ) {
    final source = switch (config.whichSource()) {
      source_config.SeafilePlaylistSourceConfig_Source.folder => {
        'type': 'folder',
        'repositoryId': config.folder.repositoryId,
        'path': config.folder.path,
      },
      source_config.SeafilePlaylistSourceConfig_Source.starred => {
        'type': 'starred',
      },
      source_config.SeafilePlaylistSourceConfig_Source.search => {
        'type': 'search',
        'repositoryId': config.search.repositoryId,
        'query': config.search.query,
      },
      source_config.SeafilePlaylistSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
    return {
      'serverId': config.serverId,
      'source': source,
      ..._playbackProxyModeMap(config.proxyMode),
    };
  }

  static source_config.TrueNasPlaylistSourceConfig _trueNasPlaylistSourceConfig(
    Map<String, dynamic> config,
  ) {
    final serverId = _string(config['serverId']);
    final source = _dynamicMap(config['source']);
    return switch (_string(source['type']).toLowerCase()) {
      'folder' => source_config.TrueNasPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        folder: source_config.TrueNasFolderPlaylistSourceConfig(
          path: _string(source['path']),
        ),
      ),
      'search' => source_config.TrueNasPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        search: source_config.TrueNasSearchPlaylistSourceConfig(
          path: _string(source['path']),
          query: _string(source['query']),
        ),
      ),
      _ => source_config.TrueNasPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
      ),
    };
  }

  static Map<String, dynamic> _trueNasPlaylistSourceConfigToMap(
    source_config.TrueNasPlaylistSourceConfig config,
  ) {
    final source = switch (config.whichSource()) {
      source_config.TrueNasPlaylistSourceConfig_Source.folder => {
        'type': 'folder',
        'path': config.folder.path,
      },
      source_config.TrueNasPlaylistSourceConfig_Source.search => {
        'type': 'search',
        'path': config.search.path,
        'query': config.search.query,
      },
      source_config.TrueNasPlaylistSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
    return {
      'serverId': config.serverId,
      'source': source,
      ..._playbackProxyModeMap(config.proxyMode),
    };
  }

  static source_config.YoutubePlaylistSourceConfig _youtubePlaylistSourceConfig(
    Map<String, dynamic> config,
  ) {
    final shared = config['shared'] == true;
    return switch (_string(config['kind']).toLowerCase()) {
      'playlist' => source_config.YoutubePlaylistSourceConfig(
        shared: shared,
        playlist: source_config.YoutubePlaylistSourceConfig_Playlist(
          playlistId: _string(config['playlistId']),
        ),
      ),
      'channel' => source_config.YoutubePlaylistSourceConfig(
        shared: shared,
        channel: source_config.YoutubePlaylistSourceConfig_Channel(
          channelId: _string(config['channelId']),
          content: switch (_string(config['content']).toLowerCase()) {
            'shorts' =>
              source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_SHORTS,
            'live' =>
              source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_LIVE,
            _ =>
              source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_VIDEOS,
          },
        ),
      ),
      'search' => source_config.YoutubePlaylistSourceConfig(
        shared: shared,
        search: source_config.YoutubePlaylistSourceConfig_Search(
          query: _string(config['query']),
        ),
      ),
      'subscriptions' => source_config.YoutubePlaylistSourceConfig(
        shared: shared,
        subscriptions:
            source_config.YoutubePlaylistSourceConfig_Subscriptions(),
      ),
      'likedvideos' => source_config.YoutubePlaylistSourceConfig(
        shared: shared,
        likedVideos: source_config.YoutubePlaylistSourceConfig_LikedVideos(),
      ),
      'watchlater' => source_config.YoutubePlaylistSourceConfig(
        shared: shared,
        watchLater: source_config.YoutubePlaylistSourceConfig_WatchLater(),
      ),
      _ => source_config.YoutubePlaylistSourceConfig(shared: shared),
    };
  }

  static source_config.DouyinMediaSourceConfig _douyinMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    return switch (_string(config['kind']).toLowerCase()) {
      'live' => source_config.DouyinMediaSourceConfig(
        live: source_config.DouyinLiveSourceConfig(
          webRid: _string(config['webRid']),
          shared: config['shared'] == true,
        ),
      ),
      _ => source_config.DouyinMediaSourceConfig(
        video: source_config.DouyinVideoSourceConfig(
          awemeId: _string(config['awemeId']),
          shared: config['shared'] == true,
        ),
      ),
    };
  }

  static Map<String, dynamic> _douyinMediaSourceConfigToMap(
    source_config.DouyinMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.DouyinMediaSourceConfig_Source.video => {
        'kind': 'video',
        'awemeId': config.video.awemeId,
        if (config.video.shared) 'shared': true,
      },
      source_config.DouyinMediaSourceConfig_Source.live => {
        'kind': 'live',
        'webRid': config.live.webRid,
        if (config.live.shared) 'shared': true,
      },
      source_config.DouyinMediaSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
  }

  static source_config.TikTokMediaSourceConfig _tiktokMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    return switch (_string(config['kind']).toLowerCase()) {
      'live' => source_config.TikTokMediaSourceConfig(
        live: source_config.TikTokLiveSourceConfig(
          uniqueId: _string(config['uniqueId']),
          shared: config['shared'] == true,
        ),
      ),
      _ => source_config.TikTokMediaSourceConfig(
        video: source_config.TikTokVideoSourceConfig(
          videoId: _string(config['videoId']),
          shared: config['shared'] == true,
        ),
      ),
    };
  }

  static Map<String, dynamic> _tiktokMediaSourceConfigToMap(
    source_config.TikTokMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.TikTokMediaSourceConfig_Source.video => {
        'kind': 'video',
        'videoId': config.video.videoId,
        if (config.video.shared) 'shared': true,
      },
      source_config.TikTokMediaSourceConfig_Source.live => {
        'kind': 'live',
        'uniqueId': config.live.uniqueId,
        if (config.live.shared) 'shared': true,
      },
      source_config.TikTokMediaSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
  }

  static Map<String, dynamic> _youtubePlaylistSourceConfigToMap(
    source_config.YoutubePlaylistSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.YoutubePlaylistSourceConfig_Source.playlist => {
        'kind': 'playlist',
        'playlistId': config.playlist.playlistId,
        if (config.shared) 'shared': true,
      },
      source_config.YoutubePlaylistSourceConfig_Source.channel => {
        'kind': 'channel',
        'channelId': config.channel.channelId,
        'content': switch (config.channel.content) {
          source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_SHORTS =>
            'shorts',
          source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_LIVE =>
            'live',
          _ => 'videos',
        },
        if (config.shared) 'shared': true,
      },
      source_config.YoutubePlaylistSourceConfig_Source.search => {
        'kind': 'search',
        'query': config.search.query,
        if (config.shared) 'shared': true,
      },
      source_config.YoutubePlaylistSourceConfig_Source.subscriptions => {
        'kind': 'subscriptions',
        if (config.shared) 'shared': true,
      },
      source_config.YoutubePlaylistSourceConfig_Source.likedVideos => {
        'kind': 'likedVideos',
        if (config.shared) 'shared': true,
      },
      source_config.YoutubePlaylistSourceConfig_Source.watchLater => {
        'kind': 'watchLater',
        if (config.shared) 'shared': true,
      },
      source_config.YoutubePlaylistSourceConfig_Source.notSet => {
        if (config.shared) 'shared': true,
      },
    };
  }

  static Map<String, dynamic> _synologyMediaSourceConfigToMap(
    source_config.SynologyMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.SynologyMediaSourceConfig_Source.file => {
        'serverId': config.serverId,
        'type': 'file',
        'path': config.file.path,
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.SynologyMediaSourceConfig_Source.libraryItem => {
        'serverId': config.serverId,
        'type': 'libraryItem',
        'kind': _synologyLibraryItemKindName(config.libraryItem.kind),
        'itemId': config.libraryItem.itemId.toInt(),
        'fileId': config.libraryItem.fileId.toInt(),
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.SynologyMediaSourceConfig_Source.notSet => {
        'serverId': config.serverId,
      },
    };
  }

  static source_config.SynologyPlaylistSourceConfig
  _synologyPlaylistSourceConfig(Map<String, dynamic> config) {
    final serverId = _string(config['serverId']);
    final libraryId = Int64(_int(config['libraryId']));
    return switch (_string(config['type'])) {
      'files' => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        files: source_config.SynologyFilesPlaylistSourceConfig(
          path: _string(config['path']),
        ),
      ),
      'movies' => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        movies: source_config.SynologyMoviesPlaylistSourceConfig(
          libraryId: libraryId,
        ),
      ),
      'tvShows' => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        tvShows: source_config.SynologyTvShowsPlaylistSourceConfig(
          libraryId: libraryId,
        ),
      ),
      'episodes' => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        episodes: source_config.SynologyEpisodesPlaylistSourceConfig(
          libraryId: libraryId,
          tvShowId: Int64(_int(config['tvShowId'])),
        ),
      ),
      'homeVideos' => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        homeVideos: source_config.SynologyHomeVideosPlaylistSourceConfig(
          libraryId: libraryId,
        ),
      ),
      'tvRecordings' => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        tvRecordings: source_config.SynologyTvRecordingsPlaylistSourceConfig(
          libraryId: libraryId,
        ),
      ),
      _ => source_config.SynologyPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
      ),
    };
  }

  static Map<String, dynamic> _synologyPlaylistSourceConfigToMap(
    source_config.SynologyPlaylistSourceConfig config,
  ) {
    final base = <String, dynamic>{
      'serverId': config.serverId,
      ..._playbackProxyModeMap(config.proxyMode),
    };
    return switch (config.whichSource()) {
      source_config.SynologyPlaylistSourceConfig_Source.files => {
        ...base,
        'type': 'files',
        'path': config.files.path,
      },
      source_config.SynologyPlaylistSourceConfig_Source.movies => {
        ...base,
        'type': 'movies',
        'libraryId': config.movies.libraryId.toInt(),
      },
      source_config.SynologyPlaylistSourceConfig_Source.tvShows => {
        ...base,
        'type': 'tvShows',
        'libraryId': config.tvShows.libraryId.toInt(),
      },
      source_config.SynologyPlaylistSourceConfig_Source.episodes => {
        ...base,
        'type': 'episodes',
        'libraryId': config.episodes.libraryId.toInt(),
        'tvShowId': config.episodes.tvShowId.toInt(),
      },
      source_config.SynologyPlaylistSourceConfig_Source.homeVideos => {
        ...base,
        'type': 'homeVideos',
        'libraryId': config.homeVideos.libraryId.toInt(),
      },
      source_config.SynologyPlaylistSourceConfig_Source.tvRecordings => {
        ...base,
        'type': 'tvRecordings',
        'libraryId': config.tvRecordings.libraryId.toInt(),
      },
      source_config.SynologyPlaylistSourceConfig_Source.notSet => base,
    };
  }

  static source_enum.SynologyLibraryItemKind _synologyLibraryItemKind(
    Object? value,
  ) {
    return switch (value?.toString()) {
      'episode' =>
        source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE,
      'homeVideo' =>
        source_enum
            .SynologyLibraryItemKind
            .SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO,
      'tvRecording' =>
        source_enum
            .SynologyLibraryItemKind
            .SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING,
      _ => source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_MOVIE,
    };
  }

  static String _synologyLibraryItemKindName(
    source_enum.SynologyLibraryItemKind value,
  ) {
    return switch (value) {
      source_enum.SynologyLibraryItemKind.SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE =>
        'episode',
      source_enum
          .SynologyLibraryItemKind
          .SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO =>
        'homeVideo',
      source_enum
          .SynologyLibraryItemKind
          .SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING =>
        'tvRecording',
      _ => 'movie',
    };
  }

  static source_config.TwitchMediaSourceConfig _twitchMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final shared = config['shared'] == true;
    return switch (_string(config['kind']).toLowerCase()) {
      'live' => source_config.TwitchMediaSourceConfig(
        live: source_config.TwitchLiveSourceConfig(
          channel: _string(config['channel']),
          shared: shared,
        ),
      ),
      'video' => source_config.TwitchMediaSourceConfig(
        video: source_config.TwitchVideoSourceConfig(
          videoId: _string(config['videoId']),
          shared: shared,
        ),
      ),
      'clip' => source_config.TwitchMediaSourceConfig(
        clip: source_config.TwitchClipSourceConfig(
          slug: _string(config['slug']),
          shared: shared,
        ),
      ),
      _ => source_config.TwitchMediaSourceConfig(),
    };
  }

  static Map<String, dynamic> _twitchMediaSourceConfigToMap(
    source_config.TwitchMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.TwitchMediaSourceConfig_Source.live => {
        'kind': 'live',
        'channel': config.live.channel,
        if (config.live.shared) 'shared': true,
      },
      source_config.TwitchMediaSourceConfig_Source.video => {
        'kind': 'video',
        'videoId': config.video.videoId,
        if (config.video.shared) 'shared': true,
      },
      source_config.TwitchMediaSourceConfig_Source.clip => {
        'kind': 'clip',
        'slug': config.clip.slug,
        if (config.clip.shared) 'shared': true,
      },
      source_config.TwitchMediaSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
  }

  static source_enum.TwitchPlaylistContent _twitchPlaylistContent(
    Object? value,
  ) {
    return switch (value?.toString().trim().toLowerCase()) {
      'videos' =>
        source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_VIDEOS,
      'highlights' =>
        source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS,
      'uploads' =>
        source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_UPLOADS,
      'clips' =>
        source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_CLIPS,
      _ =>
        source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_UNSPECIFIED,
    };
  }

  static source_config.TwitchPlaylistSourceConfig _twitchPlaylistSourceConfig(
    Map<String, dynamic> config,
  ) {
    final shared = config['shared'] == true;
    return switch (_string(config['kind']).toLowerCase()) {
      'channel' => source_config.TwitchPlaylistSourceConfig(
        shared: shared,
        channel: source_config.TwitchPlaylistSourceConfig_Channel(
          channel: _string(config['channel']),
          content: _twitchPlaylistContent(config['content']),
        ),
      ),
      'followedlive' => source_config.TwitchPlaylistSourceConfig(
        shared: shared,
        followedLive: source_config.TwitchPlaylistSourceConfig_FollowedLive(),
      ),
      'categorylive' => source_config.TwitchPlaylistSourceConfig(
        shared: shared,
        categoryLive: source_config.TwitchPlaylistSourceConfig_CategoryLive(
          categoryId: _string(config['categoryId']),
          categoryName: _string(config['categoryName']),
        ),
      ),
      'searchlive' => source_config.TwitchPlaylistSourceConfig(
        shared: shared,
        searchLive: source_config.TwitchPlaylistSourceConfig_SearchLive(
          query: _string(config['query']),
        ),
      ),
      _ => source_config.TwitchPlaylistSourceConfig(shared: shared),
    };
  }

  static Map<String, dynamic> _twitchPlaylistSourceConfigToMap(
    source_config.TwitchPlaylistSourceConfig config,
  ) {
    final shared = config.shared;
    return switch (config.whichSource()) {
      source_config.TwitchPlaylistSourceConfig_Source.channel => {
        'kind': 'channel',
        'channel': config.channel.channel,
        'content': _twitchPlaylistContentName(config.channel.content),
        if (shared) 'shared': true,
      },
      source_config.TwitchPlaylistSourceConfig_Source.followedLive => {
        'kind': 'followedLive',
        if (shared) 'shared': true,
      },
      source_config.TwitchPlaylistSourceConfig_Source.categoryLive => {
        'kind': 'categoryLive',
        'categoryId': config.categoryLive.categoryId,
        'categoryName': config.categoryLive.categoryName,
        if (shared) 'shared': true,
      },
      source_config.TwitchPlaylistSourceConfig_Source.searchLive => {
        'kind': 'searchLive',
        'query': config.searchLive.query,
        if (shared) 'shared': true,
      },
      source_config.TwitchPlaylistSourceConfig_Source.notSet =>
        <String, dynamic>{if (shared) 'shared': true},
    };
  }

  static source_config.HuyaMediaSourceConfig _huyaMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    return switch (_string(config['kind']).toLowerCase()) {
      'live' => source_config.HuyaMediaSourceConfig(
        live: source_config.HuyaLiveSourceConfig(
          roomId: _string(config['roomId']),
        ),
      ),
      'video' => source_config.HuyaMediaSourceConfig(
        video: source_config.HuyaVideoSourceConfig(
          videoId: _string(config['videoId']),
        ),
      ),
      _ => source_config.HuyaMediaSourceConfig(),
    };
  }

  static Map<String, dynamic> _huyaMediaSourceConfigToMap(
    source_config.HuyaMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.HuyaMediaSourceConfig_Source.live => {
        'kind': 'live',
        'roomId': config.live.roomId,
      },
      source_config.HuyaMediaSourceConfig_Source.video => {
        'kind': 'video',
        'videoId': config.video.videoId,
      },
      source_config.HuyaMediaSourceConfig_Source.notSet => <String, dynamic>{},
    };
  }

  static source_config.AcFunMediaSourceConfig _acFunMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    return switch (_string(config['kind']).toLowerCase()) {
      'video' => source_config.AcFunMediaSourceConfig(
        video: source_config.AcFunVideoSourceConfig(
          videoId: _string(config['videoId']),
        ),
      ),
      'bangumi' => source_config.AcFunMediaSourceConfig(
        bangumi: source_config.AcFunBangumiSourceConfig(
          bangumiId: _string(config['bangumiId']),
          episodeQuery: _optionalString(config['episodeQuery']),
        ),
      ),
      'live' => source_config.AcFunMediaSourceConfig(
        live: source_config.AcFunLiveSourceConfig(
          authorId: _string(config['authorId']),
        ),
      ),
      _ => source_config.AcFunMediaSourceConfig(),
    };
  }

  static Map<String, dynamic> _acFunMediaSourceConfigToMap(
    source_config.AcFunMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.AcFunMediaSourceConfig_Source.video => {
        'kind': 'video',
        'videoId': config.video.videoId,
      },
      source_config.AcFunMediaSourceConfig_Source.bangumi => {
        'kind': 'bangumi',
        'bangumiId': config.bangumi.bangumiId,
        if (config.bangumi.hasEpisodeQuery())
          'episodeQuery': config.bangumi.episodeQuery,
      },
      source_config.AcFunMediaSourceConfig_Source.live => {
        'kind': 'live',
        'authorId': config.live.authorId,
      },
      source_config.AcFunMediaSourceConfig_Source.notSet => <String, dynamic>{},
    };
  }

  static source_config.FnosMediaSourceConfig _fnosMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final serverId = _string(config['serverId']);
    return switch (_string(config['type'])) {
      'file' => source_config.FnosMediaSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        file: source_config.FnosFileSourceConfig(path: _string(config['path'])),
      ),
      'libraryItem' => source_config.FnosMediaSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        libraryItem: source_config.FnosLibraryItemSourceConfig(
          itemGuid: _string(config['itemGuid']),
          mediaGuid: _optionalString(config['mediaGuid']),
        ),
      ),
      _ => source_config.FnosMediaSourceConfig(serverId: serverId),
    };
  }

  static Map<String, dynamic> _fnosMediaSourceConfigToMap(
    source_config.FnosMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.FnosMediaSourceConfig_Source.file => {
        'serverId': config.serverId,
        'type': 'file',
        'path': config.file.path,
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.FnosMediaSourceConfig_Source.libraryItem => {
        'serverId': config.serverId,
        'type': 'libraryItem',
        'itemGuid': config.libraryItem.itemGuid,
        if (config.libraryItem.hasMediaGuid())
          'mediaGuid': config.libraryItem.mediaGuid,
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.FnosMediaSourceConfig_Source.notSet => {
        'serverId': config.serverId,
      },
    };
  }

  static source_config.FnosPlaylistSourceConfig _fnosPlaylistSourceConfig(
    Map<String, dynamic> config,
  ) {
    final serverId = _string(config['serverId']);
    return switch (_string(config['type'])) {
      'files' => source_config.FnosPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        files: source_config.FnosFilesPlaylistSourceConfig(
          path: _string(config['path']),
        ),
      ),
      'mediaLibrary' => source_config.FnosPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        mediaLibrary: source_config.FnosMediaLibraryPlaylistSourceConfig(
          libraryGuid: _string(config['libraryGuid']),
          mediaTypes: _stringList(config['mediaTypes']),
          parentGuid: _optionalString(config['parentGuid']),
        ),
      ),
      'favorites' => source_config.FnosPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        favorites: source_config.FnosFavoritesPlaylistSourceConfig(
          mediaTypes: _stringList(config['mediaTypes']),
        ),
      ),
      'history' => source_config.FnosPlaylistSourceConfig(
        serverId: serverId,
        proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
        history: source_config.FnosHistoryPlaylistSourceConfig(),
      ),
      _ => source_config.FnosPlaylistSourceConfig(serverId: serverId),
    };
  }

  static Map<String, dynamic> _fnosPlaylistSourceConfigToMap(
    source_config.FnosPlaylistSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.FnosPlaylistSourceConfig_Source.files => {
        'serverId': config.serverId,
        'type': 'files',
        'path': config.files.path,
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.FnosPlaylistSourceConfig_Source.mediaLibrary => {
        'serverId': config.serverId,
        'type': 'mediaLibrary',
        'libraryGuid': config.mediaLibrary.libraryGuid,
        if (config.mediaLibrary.hasParentGuid())
          'parentGuid': config.mediaLibrary.parentGuid,
        if (config.mediaLibrary.mediaTypes.isNotEmpty)
          'mediaTypes': config.mediaLibrary.mediaTypes.toList(),
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.FnosPlaylistSourceConfig_Source.favorites => {
        'serverId': config.serverId,
        'type': 'favorites',
        if (config.favorites.mediaTypes.isNotEmpty)
          'mediaTypes': config.favorites.mediaTypes.toList(),
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.FnosPlaylistSourceConfig_Source.history => {
        'serverId': config.serverId,
        'type': 'history',
        ..._playbackProxyModeMap(config.proxyMode),
      },
      source_config.FnosPlaylistSourceConfig_Source.notSet => {
        'serverId': config.serverId,
      },
    };
  }

  static String _twitchPlaylistContentName(
    source_enum.TwitchPlaylistContent value,
  ) {
    return switch (value) {
      source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_VIDEOS =>
        'videos',
      source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS =>
        'highlights',
      source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_UPLOADS =>
        'uploads',
      source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_CLIPS =>
        'clips',
      _ => '',
    };
  }

  static source_enum.PlaybackKind? _playbackKindFromValue(Object? value) {
    return switch (_string(value).trim().toLowerCase()) {
      'regular' ||
      'playback_kind_regular' ||
      '1' => source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
      'live' ||
      'playback_kind_live' ||
      '2' => source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
      _ => null,
    };
  }

  static String _playbackKindToString(source_enum.PlaybackKind value) {
    return switch (value) {
      source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR => 'regular',
      source_enum.PlaybackKind.PLAYBACK_KIND_LIVE => 'live',
      _ => '',
    };
  }

  static source_enum.PlaybackProxyMode _playbackProxyModeFromValue(
    Object? value,
  ) {
    return switch (_string(value).trim().toLowerCase()) {
      'prefer' ||
      'playback_proxy_mode_prefer' ||
      '1' => source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
      'only' ||
      'playback_proxy_mode_only' ||
      '2' => source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      'directprefer' ||
      'direct_prefer' ||
      'direct-prefer' ||
      'playback_proxy_mode_direct_prefer' ||
      '3' => source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
      'directonly' ||
      'direct_only' ||
      'direct-only' ||
      'playback_proxy_mode_direct_only' ||
      '4' => source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
      _ => source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    };
  }

  static Map<String, dynamic> _playbackProxyModeMap(
    source_enum.PlaybackProxyMode value,
  ) {
    return switch (value) {
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER => const {
        'proxyMode': 'prefer',
      },
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY => const {
        'proxyMode': 'only',
      },
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER => const {
        'proxyMode': 'directPrefer',
      },
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY => const {
        'proxyMode': 'directOnly',
      },
      _ => const <String, dynamic>{},
    };
  }

  static source_enum.RtmpStreamMode _rtmpStreamModeFromValue(Object? value) {
    return switch (_string(value).trim().toLowerCase()) {
      'videoonly' ||
      'video_only' ||
      'rtmp_stream_mode_video_only' ||
      '2' => source_enum.RtmpStreamMode.RTMP_STREAM_MODE_VIDEO_ONLY,
      'audioonly' ||
      'audio_only' ||
      'rtmp_stream_mode_audio_only' ||
      '3' => source_enum.RtmpStreamMode.RTMP_STREAM_MODE_AUDIO_ONLY,
      _ => source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
    };
  }

  static String _rtmpStreamModeToString(source_enum.RtmpStreamMode value) {
    return switch (value) {
      source_enum.RtmpStreamMode.RTMP_STREAM_MODE_VIDEO_ONLY => 'videoOnly',
      source_enum.RtmpStreamMode.RTMP_STREAM_MODE_AUDIO_ONLY => 'audioOnly',
      _ => 'default',
    };
  }

  static source_config.LiveProxyMediaSourceConfig _liveProxyMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final source = _dynamicMap(config['source']);
    final url = _string(source['url']);
    return switch (_string(source['protocol']).trim().toLowerCase()) {
      'rtmp' => source_config.LiveProxyMediaSourceConfig(
        rtmp: source_config.RtmpPullSourceConfig(
          url: url,
          mode: _rtmpStreamModeFromValue(source['mode']),
        ),
      ),
      'rtsp' => source_config.LiveProxyMediaSourceConfig(
        rtsp: source_config.RtspPullSourceConfig(
          url: url,
          transport: _rtspTransportFromValue(source['transport']),
          videoTrack: _rtspTrackSelectionFromMap(source['videoTrack']),
          audioTrack: _rtspTrackSelectionFromMap(source['audioTrack']),
        ),
      ),
      'httpflv' ||
      'http_flv' ||
      'http-flv' => source_config.LiveProxyMediaSourceConfig(
        httpFlv: source_config.HttpFlvPullSourceConfig(url: url),
      ),
      'whep' => source_config.LiveProxyMediaSourceConfig(
        whep: source_config.WhepPullSourceConfig(
          url: url,
          authorization: _optionalString(source['authorization']),
        ),
      ),
      _ => source_config.LiveProxyMediaSourceConfig(),
    };
  }

  static source_enum.RtspTransport _rtspTransportFromValue(Object? value) {
    return switch (_string(value).trim().toLowerCase()) {
      'udp' ||
      'rtsp_transport_udp' ||
      '2' => source_enum.RtspTransport.RTSP_TRANSPORT_UDP,
      _ => source_enum.RtspTransport.RTSP_TRANSPORT_TCP,
    };
  }

  static source_config.RtspTrackSelection _rtspTrackSelectionFromMap(
    Object? value,
  ) {
    final map = _dynamicMap(value);
    return switch (_string(map['mode']).trim().toLowerCase()) {
      'index' => source_config.RtspTrackSelection(
        index: _optionalInt(map['index']) ?? 0,
      ),
      'disabled' => source_config.RtspTrackSelection(disabled: true),
      _ => source_config.RtspTrackSelection(firstCompatible: true),
    };
  }

  static Map<String, dynamic> _liveProxyMediaSourceConfigToMap(
    source_config.LiveProxyMediaSourceConfig config,
  ) {
    final source = switch (config.whichSource()) {
      source_config.LiveProxyMediaSourceConfig_Source.rtmp => {
        'protocol': 'rtmp',
        'url': config.rtmp.url,
        'mode': _rtmpStreamModeToString(config.rtmp.mode),
      },
      source_config.LiveProxyMediaSourceConfig_Source.rtsp => {
        'protocol': 'rtsp',
        'url': config.rtsp.url,
        'transport':
            config.rtsp.transport ==
                source_enum.RtspTransport.RTSP_TRANSPORT_UDP
            ? 'udp'
            : 'tcp',
        'videoTrack': _rtspTrackSelectionToMap(config.rtsp.videoTrack),
        'audioTrack': _rtspTrackSelectionToMap(config.rtsp.audioTrack),
      },
      source_config.LiveProxyMediaSourceConfig_Source.httpFlv => {
        'protocol': 'httpFlv',
        'url': config.httpFlv.url,
      },
      source_config.LiveProxyMediaSourceConfig_Source.whep => {
        'protocol': 'whep',
        'url': config.whep.url,
        if (config.whep.hasAuthorization())
          'authorization': config.whep.authorization,
      },
      source_config.LiveProxyMediaSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
    return {'source': source};
  }

  static Map<String, dynamic> _rtspTrackSelectionToMap(
    source_config.RtspTrackSelection selection,
  ) {
    return switch (selection.whichMode()) {
      source_config.RtspTrackSelection_Mode.index_ => {
        'mode': 'index',
        'index': selection.index,
      },
      source_config.RtspTrackSelection_Mode.disabled => {'mode': 'disabled'},
      _ => {'mode': 'firstCompatible'},
    };
  }

  static source_config.DirectUrlMediaSourceConfig _directUrlMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final mediaMaps = _listMaps(config['medias']);
    final medias = mediaMaps.isEmpty
        ? [
            source_config.DirectUrlMediaResourceConfig(
              url: _string(config['url']),
              headers: _stringMap(config['headers']).entries,
              name: _string(config['name']),
              format: _string(config['format']),
              expiresAt: _optionalInt64(config['expiresAt']),
            ),
          ]
        : mediaMaps.map(_directUrlMediaResourceConfig).toList();
    return source_config.DirectUrlMediaSourceConfig(
      medias: medias,
      defaultMediaIndex: _optionalInt(config['defaultMediaIndex']),
      subtitles: _listMaps(
        config['subtitles'],
      ).map(_directUrlSubtitleSourceConfig).toList(),
      defaultSubtitleIndex: _optionalInt(config['defaultSubtitleIndex']),
      danmakus: _listMaps(
        config['danmakus'],
      ).map(_directUrlDanmakuSourceConfig).toList(),
      defaultDanmakuIndex: _optionalInt(config['defaultDanmakuIndex']),
      playbackKind: _playbackKindFromValue(config['playbackKind']),
      durationSeconds: _optionalDouble(config['durationSeconds']),
      proxyMode: _playbackProxyModeFromValue(config['proxyMode']),
    );
  }

  static source_config.DirectUrlMediaResourceConfig
  _directUrlMediaResourceConfig(Map<String, dynamic> config) {
    return source_config.DirectUrlMediaResourceConfig(
      name: _string(config['name']),
      url: _string(config['url']),
      headers: _stringMap(config['headers']).entries,
      format: _string(config['format']),
      expiresAt: _optionalInt64(config['expiresAt']),
    );
  }

  static source_config.DirectUrlSubtitleSourceConfig
  _directUrlSubtitleSourceConfig(Map<String, dynamic> config) {
    return source_config.DirectUrlSubtitleSourceConfig(
      name: _string(config['name']),
      language: _string(config['language']),
      url: _string(config['url']),
      headers: _stringMap(config['headers']).entries,
      format: _string(config['format']),
      expiresAt: _optionalInt64(config['expiresAt']),
    );
  }

  static source_config.DirectUrlDanmakuSourceConfig
  _directUrlDanmakuSourceConfig(Map<String, dynamic> config) {
    return source_config.DirectUrlDanmakuSourceConfig(
      name: _string(config['name']),
      url: _string(config['url']),
      headers: _stringMap(config['headers']).entries,
      format: _optionalString(config['format']),
      expiresAt: _optionalInt64(config['expiresAt']),
    );
  }

  static source_config.BilibiliMediaSourceConfig _bilibiliMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final kind = _string(config['kind']).isEmpty
        ? _string(config['type'])
        : _string(config['kind']);
    final result = switch (kind) {
      'live' => source_config.BilibiliMediaSourceConfig(
        live: source_config.BilibiliLiveSourceConfig(
          roomId: Int64(_int(config['roomId'])),
          shared: _bool(config['shared']),
        ),
      ),
      'pgc' => source_config.BilibiliMediaSourceConfig(
        pgc: source_config.BilibiliPgcSourceConfig(
          epid: Int64(_int(config['epid'])),
          cid: Int64(_int(config['cid'])),
          shared: _bool(config['shared']),
        ),
      ),
      _ => source_config.BilibiliMediaSourceConfig(
        video: source_config.BilibiliVideoSourceConfig(
          bvid: _optionalString(config['bvid']),
          aid: _optionalInt64(config['aid']),
          cid: Int64(_int(config['cid'])),
          shared: _bool(config['shared']),
        ),
      ),
    };
    result.proxyMode = _playbackProxyModeFromValue(config['proxyMode']);
    return result;
  }

  static Map<String, dynamic> _directUrlMediaSourceConfigToMap(
    source_config.DirectUrlMediaSourceConfig config,
  ) {
    final map = <String, dynamic>{
      if (_shouldKeepDirectUrlMediaList(config))
        'medias': config.medias.map(_mediaResourceToMap).toList(),
      if (config.hasDefaultMediaIndex())
        'defaultMediaIndex': config.defaultMediaIndex,
      if (config.subtitles.isNotEmpty)
        'subtitles': config.subtitles.map(_subtitleToMap).toList(),
      if (config.hasDefaultSubtitleIndex())
        'defaultSubtitleIndex': config.defaultSubtitleIndex,
      if (config.danmakus.isNotEmpty)
        'danmakus': config.danmakus.map(_danmakuToMap).toList(),
      if (config.hasDefaultDanmakuIndex())
        'defaultDanmakuIndex': config.defaultDanmakuIndex,
      if (config.hasPlaybackKind())
        'playbackKind': _playbackKindToString(config.playbackKind),
      if (config.hasDurationSeconds())
        'durationSeconds': config.durationSeconds,
      ..._playbackProxyModeMap(config.proxyMode),
    };
    if (config.medias.length == 1) {
      final media = config.medias.single;
      map['url'] = media.url;
      if (media.headers.isNotEmpty) {
        map['headers'] = Map<String, String>.from(media.headers);
      }
      if (media.name.isNotEmpty) map['name'] = media.name;
      if (media.format.isNotEmpty) map['format'] = media.format;
      if (media.hasExpiresAt()) map['expiresAt'] = media.expiresAt.toInt();
    }
    return map;
  }

  static bool _shouldKeepDirectUrlMediaList(
    source_config.DirectUrlMediaSourceConfig config,
  ) {
    return config.medias.length != 1 ||
        config.hasDefaultMediaIndex() ||
        config.subtitles.isNotEmpty ||
        config.hasDefaultSubtitleIndex() ||
        config.danmakus.isNotEmpty ||
        config.hasDefaultDanmakuIndex() ||
        config.hasPlaybackKind() ||
        config.hasDurationSeconds() ||
        config.proxyMode !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
  }

  static Map<String, dynamic> _mediaResourceToMap(
    source_config.DirectUrlMediaResourceConfig media,
  ) {
    return {
      if (media.name.isNotEmpty) 'name': media.name,
      'url': media.url,
      if (media.headers.isNotEmpty)
        'headers': Map<String, String>.from(media.headers),
      if (media.format.isNotEmpty) 'format': media.format,
      if (media.hasExpiresAt()) 'expiresAt': media.expiresAt.toInt(),
    };
  }

  static Map<String, dynamic> _subtitleToMap(
    source_config.DirectUrlSubtitleSourceConfig subtitle,
  ) {
    return {
      if (subtitle.name.isNotEmpty) 'name': subtitle.name,
      if (subtitle.language.isNotEmpty) 'language': subtitle.language,
      'url': subtitle.url,
      if (subtitle.headers.isNotEmpty)
        'headers': Map<String, String>.from(subtitle.headers),
      if (subtitle.format.isNotEmpty) 'format': subtitle.format,
      if (subtitle.hasExpiresAt()) 'expiresAt': subtitle.expiresAt.toInt(),
    };
  }

  static Map<String, dynamic> _danmakuToMap(
    source_config.DirectUrlDanmakuSourceConfig danmaku,
  ) {
    return {
      if (danmaku.name.isNotEmpty) 'name': danmaku.name,
      'url': danmaku.url,
      if (danmaku.headers.isNotEmpty)
        'headers': Map<String, String>.from(danmaku.headers),
      if (danmaku.hasFormat()) 'format': danmaku.format,
      if (danmaku.hasExpiresAt()) 'expiresAt': danmaku.expiresAt.toInt(),
    };
  }

  static Map<String, dynamic> _bilibiliMediaSourceConfigToMap(
    source_config.BilibiliMediaSourceConfig config,
  ) {
    final result = <String, dynamic>{
      ...switch (config.whichSource()) {
        source_config.BilibiliMediaSourceConfig_Source.video => {
          'kind': 'video',
          'type': 'video',
          if (config.video.hasBvid()) 'bvid': config.video.bvid,
          if (config.video.hasAid()) 'aid': config.video.aid.toInt(),
          'cid': config.video.cid.toInt(),
          'shared': config.video.shared,
        },
        source_config.BilibiliMediaSourceConfig_Source.pgc => {
          'kind': 'pgc',
          'type': 'pgc',
          'epid': config.pgc.epid.toInt(),
          'cid': config.pgc.cid.toInt(),
          'shared': config.pgc.shared,
        },
        source_config.BilibiliMediaSourceConfig_Source.live => {
          'kind': 'live',
          'type': 'live',
          'roomId': config.live.roomId.toInt(),
          'shared': config.live.shared,
        },
        source_config.BilibiliMediaSourceConfig_Source.notSet =>
          <String, dynamic>{},
      },
    };
    result.addAll(_playbackProxyModeMap(config.proxyMode));
    return result;
  }

  static List<Map<String, dynamic>> _listMaps(Object? value) {
    if (value is! Iterable) return const [];
    return value
        .whereType<Map>()
        .map(
          (entry) => entry.map((key, value) => MapEntry(key.toString(), value)),
        )
        .toList();
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is! Map) return const {};
    return value.map(
      (key, entryValue) => MapEntry(key.toString(), entryValue.toString()),
    );
  }

  static Map<String, dynamic> _dynamicMap(Object? value) {
    if (value is! Map) return const {};
    return value.map((key, entryValue) => MapEntry(key.toString(), entryValue));
  }

  static List<String> _stringList(Object? value) {
    if (value is! Iterable) return const [];
    return value.map((entry) => entry.toString()).toList();
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static String? _optionalString(Object? value) {
    final string = _string(value);
    return string.isEmpty ? null : string;
  }

  static bool _bool(Object? value) => _optionalBool(value) ?? false;

  static bool? _optionalBool(Object? value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }

  static int _int(Object? value) => _optionalInt(value) ?? 0;

  static int? _optionalInt(Object? value) {
    if (value is int) return value;
    if (value is Int64) return value.toInt();
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static Int64? _optionalInt64(Object? value) {
    final parsed = _optionalInt(value);
    return parsed == null ? null : Int64(parsed);
  }

  static double? _optionalDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
