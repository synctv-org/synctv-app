import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as pb;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

class SourceConfigCodec {
  const SourceConfigCodec._();

  static source_enum.SourceProvider providerFromString(String value) {
    return switch (value.trim().toLowerCase()) {
      '' ||
      'unspecified' =>
        source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
      'direct_url' ||
      'directurl' =>
        source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL,
      'bilibili' => source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI,
      'alist' => source_enum.SourceProvider.SOURCE_PROVIDER_ALIST,
      'emby' => source_enum.SourceProvider.SOURCE_PROVIDER_EMBY,
      'rtmp' => source_enum.SourceProvider.SOURCE_PROVIDER_RTMP,
      'live_proxy' ||
      'liveproxy' =>
        source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY,
      _ => source_enum.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED,
    };
  }

  static String providerToString(source_enum.SourceProvider value) {
    return switch (value) {
      source_enum.SourceProvider.SOURCE_PROVIDER_DIRECT_URL => 'direct_url',
      source_enum.SourceProvider.SOURCE_PROVIDER_BILIBILI => 'bilibili',
      source_enum.SourceProvider.SOURCE_PROVIDER_ALIST => 'alist',
      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY => 'emby',
      source_enum.SourceProvider.SOURCE_PROVIDER_RTMP => 'rtmp',
      source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY => 'live_proxy',
      _ => '',
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
    required String sourceProvider,
    required Map<String, dynamic> sourceConfig,
  }) {
    final provider = providerFromString(sourceProvider);
    return mediaSourceConfigForProvider(provider, sourceConfig);
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
            serverId: _string(config['server_id']),
            path: _string(config['path']),
            password: _optionalString(config['password']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY =>
        source_config.MediaSourceConfig(
          emby: source_config.EmbyMediaSourceConfig(
            serverId: _string(config['server_id']),
            itemId: _string(config['item_id']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_RTMP =>
        source_config.MediaSourceConfig(
            rtmp: source_config.RtmpMediaSourceConfig()),
      source_enum.SourceProvider.SOURCE_PROVIDER_LIVE_PROXY =>
        source_config.MediaSourceConfig(
          liveProxy: source_config.LiveProxyMediaSourceConfig(
              url: _string(config['url'])),
        ),
      _ => null,
    };
  }

  static source_config.PlaylistSourceConfig? playlistSourceConfigFromMap({
    required String sourceProvider,
    required Map<String, dynamic> sourceConfig,
  }) {
    final provider = providerFromString(sourceProvider);
    return playlistSourceConfigForProvider(provider, sourceConfig);
  }

  static source_config.PlaylistSourceConfig? playlistSourceConfigForProvider(
    source_enum.SourceProvider provider,
    Map<String, dynamic> config,
  ) {
    return switch (provider) {
      source_enum.SourceProvider.SOURCE_PROVIDER_ALIST =>
        source_config.PlaylistSourceConfig(
          alist: source_config.AlistPlaylistSourceConfig(
            serverId: _string(config['server_id']),
            path: _string(config['path']),
            password: _optionalString(config['password']),
          ),
        ),
      source_enum.SourceProvider.SOURCE_PROVIDER_EMBY =>
        source_config.PlaylistSourceConfig(
          emby: source_config.EmbyPlaylistSourceConfig(
            serverId: _string(config['server_id']),
            itemId: _string(config['item_id']),
          ),
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
          if (config.alist.serverId.isNotEmpty)
            'server_id': config.alist.serverId,
          'path': config.alist.path,
          if (config.alist.hasPassword()) 'password': config.alist.password,
        },
      source_config.MediaSourceConfig_Provider.emby => {
          if (config.emby.serverId.isNotEmpty)
            'server_id': config.emby.serverId,
          'item_id': config.emby.itemId,
        },
      source_config.MediaSourceConfig_Provider.rtmp => <String, dynamic>{},
      source_config.MediaSourceConfig_Provider.liveProxy => {
          'url': config.liveProxy.url,
        },
      source_config.MediaSourceConfig_Provider.notSet => <String, dynamic>{},
    };
  }

  static Map<String, dynamic> playlistSourceConfigToMap(
    source_config.PlaylistSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.PlaylistSourceConfig_Provider.alist => {
          if (config.alist.serverId.isNotEmpty)
            'server_id': config.alist.serverId,
          'path': config.alist.path,
          if (config.alist.hasPassword()) 'password': config.alist.password,
        },
      source_config.PlaylistSourceConfig_Provider.emby => {
          if (config.emby.serverId.isNotEmpty)
            'server_id': config.emby.serverId,
          'item_id': config.emby.itemId,
        },
      source_config.PlaylistSourceConfig_Provider.notSet => <String, dynamic>{},
    };
  }

  static Map<String, dynamic> mediaSourceConfigJson(
    source_config.MediaSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.MediaSourceConfig_Provider.directUrl => {
          'direct_url': _directUrlMediaSourceConfigHttpJson(config.directUrl),
        },
      source_config.MediaSourceConfig_Provider.bilibili => {
          'bilibili': _bilibiliMediaSourceConfigHttpJson(config.bilibili),
        },
      source_config.MediaSourceConfig_Provider.alist => {
          'alist': mediaSourceConfigToMap(config),
        },
      source_config.MediaSourceConfig_Provider.emby => {
          'emby': mediaSourceConfigToMap(config),
        },
      source_config.MediaSourceConfig_Provider.rtmp => {
          'rtmp': <String, dynamic>{}
        },
      source_config.MediaSourceConfig_Provider.liveProxy => {
          'live_proxy': mediaSourceConfigToMap(config),
        },
      source_config.MediaSourceConfig_Provider.notSet => <String, dynamic>{},
    };
  }

  static Map<String, dynamic> playlistSourceConfigJson(
    source_config.PlaylistSourceConfig config,
  ) {
    return switch (config.whichProvider()) {
      source_config.PlaylistSourceConfig_Provider.alist => {
          'alist': playlistSourceConfigToMap(config),
        },
      source_config.PlaylistSourceConfig_Provider.emby => {
          'emby': playlistSourceConfigToMap(config),
        },
      source_config.PlaylistSourceConfig_Provider.notSet => <String, dynamic>{},
    };
  }

  static source_config.DirectUrlMediaSourceConfig _directUrlMediaSourceConfig(
      Map<String, dynamic> config) {
    final mediaMaps = _listMaps(config['medias']);
    final medias = mediaMaps.isEmpty
        ? [
            source_config.DirectUrlMediaResourceConfig(
              url: _string(config['url']),
              headers: _stringMap(config['headers']).entries,
              name: _string(config['name']),
              format: _string(config['format']),
            ),
          ]
        : mediaMaps.map(_directUrlMediaResourceConfig).toList();
    return source_config.DirectUrlMediaSourceConfig(
      medias: medias,
      defaultMediaIndex: _optionalInt(config['default_media_index']),
      subtitles: _listMaps(config['subtitles'])
          .map(_directUrlSubtitleSourceConfig)
          .toList(),
      defaultSubtitleIndex: _optionalInt(config['default_subtitle_index']),
      danmakus: _listMaps(config['danmakus'])
          .map(_directUrlDanmakuSourceConfig)
          .toList(),
      defaultDanmakuIndex: _optionalInt(config['default_danmaku_index']),
      isLive: _optionalBool(config['is_live']),
      durationSeconds: _optionalDouble(config['duration_seconds']),
      preferProxy: _optionalBool(config['prefer_proxy']),
    );
  }

  static source_config.DirectUrlMediaResourceConfig
      _directUrlMediaResourceConfig(Map<String, dynamic> config) {
    return source_config.DirectUrlMediaResourceConfig(
      name: _string(config['name']),
      url: _string(config['url']),
      headers: _stringMap(config['headers']).entries,
      format: _string(config['format']),
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
    );
  }

  static source_config.DirectUrlDanmakuSourceConfig
      _directUrlDanmakuSourceConfig(Map<String, dynamic> config) {
    return source_config.DirectUrlDanmakuSourceConfig(
      name: _string(config['name']),
      url: _string(config['url']),
      headers: _stringMap(config['headers']).entries,
      format: _optionalString(config['format']),
    );
  }

  static source_config.BilibiliMediaSourceConfig _bilibiliMediaSourceConfig(
    Map<String, dynamic> config,
  ) {
    final kind = _string(config['kind']).isEmpty
        ? _string(config['type'])
        : _string(config['kind']);
    return switch (kind) {
      'live' => source_config.BilibiliMediaSourceConfig(
          live: source_config.BilibiliLiveSourceConfig(
            roomId: Int64(_int(config['room_id'])),
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
  }

  static Map<String, dynamic> _directUrlMediaSourceConfigToMap(
    source_config.DirectUrlMediaSourceConfig config,
  ) {
    final map = <String, dynamic>{
      if (_shouldKeepDirectUrlMediaList(config))
        'medias': config.medias.map(_mediaResourceToMap).toList(),
      if (config.hasDefaultMediaIndex())
        'default_media_index': config.defaultMediaIndex,
      if (config.subtitles.isNotEmpty)
        'subtitles': config.subtitles.map(_subtitleToMap).toList(),
      if (config.hasDefaultSubtitleIndex())
        'default_subtitle_index': config.defaultSubtitleIndex,
      if (config.danmakus.isNotEmpty)
        'danmakus': config.danmakus.map(_danmakuToMap).toList(),
      if (config.hasDefaultDanmakuIndex())
        'default_danmaku_index': config.defaultDanmakuIndex,
      if (config.hasIsLive()) 'is_live': config.isLive,
      if (config.hasDurationSeconds())
        'duration_seconds': config.durationSeconds,
      if (config.hasPreferProxy()) 'prefer_proxy': config.preferProxy,
    };
    if (config.medias.length == 1) {
      final media = config.medias.single;
      map['url'] = media.url;
      if (media.headers.isNotEmpty) {
        map['headers'] = Map<String, String>.from(media.headers);
      }
      if (media.name.isNotEmpty) map['name'] = media.name;
      if (media.format.isNotEmpty) map['format'] = media.format;
    }
    return map;
  }

  static Map<String, dynamic> _directUrlMediaSourceConfigHttpJson(
    source_config.DirectUrlMediaSourceConfig config,
  ) {
    final map = _directUrlMediaSourceConfigToMap(config);
    map['medias'] = config.medias.map(_mediaResourceToMap).toList();
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
        config.hasIsLive() ||
        config.hasDurationSeconds() ||
        config.hasPreferProxy();
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
    };
  }

  static Map<String, dynamic> _bilibiliMediaSourceConfigToMap(
    source_config.BilibiliMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
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
          'room_id': config.live.roomId.toInt(),
          'shared': config.live.shared,
        },
      source_config.BilibiliMediaSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
  }

  static Map<String, dynamic> _bilibiliMediaSourceConfigHttpJson(
    source_config.BilibiliMediaSourceConfig config,
  ) {
    return switch (config.whichSource()) {
      source_config.BilibiliMediaSourceConfig_Source.video => {
          'video': _bilibiliMediaSourceConfigToMap(config)
            ..remove('kind')
            ..remove('type'),
        },
      source_config.BilibiliMediaSourceConfig_Source.pgc => {
          'pgc': _bilibiliMediaSourceConfigToMap(config)
            ..remove('kind')
            ..remove('type'),
        },
      source_config.BilibiliMediaSourceConfig_Source.live => {
          'live': _bilibiliMediaSourceConfigToMap(config)
            ..remove('kind')
            ..remove('type'),
        },
      source_config.BilibiliMediaSourceConfig_Source.notSet =>
        <String, dynamic>{},
    };
  }

  static List<Map<String, dynamic>> _listMaps(Object? value) {
    if (value is! Iterable) return const [];
    return value
        .whereType<Map>()
        .map((entry) =>
            entry.map((key, value) => MapEntry(key.toString(), value)))
        .toList();
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is! Map) return const {};
    return value.map(
      (key, entryValue) => MapEntry(key.toString(), entryValue.toString()),
    );
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
