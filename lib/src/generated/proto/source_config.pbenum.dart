// This is a generated file - do not edit.
//
// Generated from proto/source_config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SourceProvider extends $pb.ProtobufEnum {
  static const SourceProvider SOURCE_PROVIDER_UNSPECIFIED =
      SourceProvider._(0, _omitEnumNames ? '' : 'SOURCE_PROVIDER_UNSPECIFIED');
  static const SourceProvider SOURCE_PROVIDER_DIRECT_URL =
      SourceProvider._(1, _omitEnumNames ? '' : 'SOURCE_PROVIDER_DIRECT_URL');
  static const SourceProvider SOURCE_PROVIDER_BILIBILI =
      SourceProvider._(2, _omitEnumNames ? '' : 'SOURCE_PROVIDER_BILIBILI');
  static const SourceProvider SOURCE_PROVIDER_ALIST =
      SourceProvider._(3, _omitEnumNames ? '' : 'SOURCE_PROVIDER_ALIST');
  static const SourceProvider SOURCE_PROVIDER_EMBY =
      SourceProvider._(4, _omitEnumNames ? '' : 'SOURCE_PROVIDER_EMBY');
  static const SourceProvider SOURCE_PROVIDER_RTMP =
      SourceProvider._(5, _omitEnumNames ? '' : 'SOURCE_PROVIDER_RTMP');
  static const SourceProvider SOURCE_PROVIDER_LIVE_PROXY =
      SourceProvider._(6, _omitEnumNames ? '' : 'SOURCE_PROVIDER_LIVE_PROXY');
  static const SourceProvider SOURCE_PROVIDER_CLOUDREVE =
      SourceProvider._(7, _omitEnumNames ? '' : 'SOURCE_PROVIDER_CLOUDREVE');
  static const SourceProvider SOURCE_PROVIDER_TWITCH =
      SourceProvider._(8, _omitEnumNames ? '' : 'SOURCE_PROVIDER_TWITCH');
  static const SourceProvider SOURCE_PROVIDER_HUYA =
      SourceProvider._(9, _omitEnumNames ? '' : 'SOURCE_PROVIDER_HUYA');
  static const SourceProvider SOURCE_PROVIDER_DOUYU =
      SourceProvider._(10, _omitEnumNames ? '' : 'SOURCE_PROVIDER_DOUYU');
  static const SourceProvider SOURCE_PROVIDER_DOUYIN =
      SourceProvider._(11, _omitEnumNames ? '' : 'SOURCE_PROVIDER_DOUYIN');
  static const SourceProvider SOURCE_PROVIDER_ACFUN =
      SourceProvider._(12, _omitEnumNames ? '' : 'SOURCE_PROVIDER_ACFUN');
  static const SourceProvider SOURCE_PROVIDER_CCTV =
      SourceProvider._(13, _omitEnumNames ? '' : 'SOURCE_PROVIDER_CCTV');
  static const SourceProvider SOURCE_PROVIDER_FNOS =
      SourceProvider._(14, _omitEnumNames ? '' : 'SOURCE_PROVIDER_FNOS');
  static const SourceProvider SOURCE_PROVIDER_QNAP =
      SourceProvider._(15, _omitEnumNames ? '' : 'SOURCE_PROVIDER_QNAP');
  static const SourceProvider SOURCE_PROVIDER_SYNOLOGY =
      SourceProvider._(16, _omitEnumNames ? '' : 'SOURCE_PROVIDER_SYNOLOGY');
  static const SourceProvider SOURCE_PROVIDER_NEXTCLOUD =
      SourceProvider._(17, _omitEnumNames ? '' : 'SOURCE_PROVIDER_NEXTCLOUD');
  static const SourceProvider SOURCE_PROVIDER_SEAFILE =
      SourceProvider._(18, _omitEnumNames ? '' : 'SOURCE_PROVIDER_SEAFILE');
  static const SourceProvider SOURCE_PROVIDER_TRUENAS =
      SourceProvider._(19, _omitEnumNames ? '' : 'SOURCE_PROVIDER_TRUENAS');
  static const SourceProvider SOURCE_PROVIDER_YOUTUBE =
      SourceProvider._(20, _omitEnumNames ? '' : 'SOURCE_PROVIDER_YOUTUBE');
  static const SourceProvider SOURCE_PROVIDER_TIKTOK =
      SourceProvider._(21, _omitEnumNames ? '' : 'SOURCE_PROVIDER_TIKTOK');

  static const $core.List<SourceProvider> values = <SourceProvider>[
    SOURCE_PROVIDER_UNSPECIFIED,
    SOURCE_PROVIDER_DIRECT_URL,
    SOURCE_PROVIDER_BILIBILI,
    SOURCE_PROVIDER_ALIST,
    SOURCE_PROVIDER_EMBY,
    SOURCE_PROVIDER_RTMP,
    SOURCE_PROVIDER_LIVE_PROXY,
    SOURCE_PROVIDER_CLOUDREVE,
    SOURCE_PROVIDER_TWITCH,
    SOURCE_PROVIDER_HUYA,
    SOURCE_PROVIDER_DOUYU,
    SOURCE_PROVIDER_DOUYIN,
    SOURCE_PROVIDER_ACFUN,
    SOURCE_PROVIDER_CCTV,
    SOURCE_PROVIDER_FNOS,
    SOURCE_PROVIDER_QNAP,
    SOURCE_PROVIDER_SYNOLOGY,
    SOURCE_PROVIDER_NEXTCLOUD,
    SOURCE_PROVIDER_SEAFILE,
    SOURCE_PROVIDER_TRUENAS,
    SOURCE_PROVIDER_YOUTUBE,
    SOURCE_PROVIDER_TIKTOK,
  ];

  static final $core.List<SourceProvider?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 21);
  static SourceProvider? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SourceProvider._(super.value, super.name);
}

class PlaybackKind extends $pb.ProtobufEnum {
  static const PlaybackKind PLAYBACK_KIND_UNSPECIFIED =
      PlaybackKind._(0, _omitEnumNames ? '' : 'PLAYBACK_KIND_UNSPECIFIED');
  static const PlaybackKind PLAYBACK_KIND_REGULAR =
      PlaybackKind._(1, _omitEnumNames ? '' : 'PLAYBACK_KIND_REGULAR');
  static const PlaybackKind PLAYBACK_KIND_LIVE =
      PlaybackKind._(2, _omitEnumNames ? '' : 'PLAYBACK_KIND_LIVE');

  static const $core.List<PlaybackKind> values = <PlaybackKind>[
    PLAYBACK_KIND_UNSPECIFIED,
    PLAYBACK_KIND_REGULAR,
    PLAYBACK_KIND_LIVE,
  ];

  static final $core.List<PlaybackKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PlaybackKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackKind._(super.value, super.name);
}

class PlaybackProxyMode extends $pb.ProtobufEnum {
  static const PlaybackProxyMode PLAYBACK_PROXY_MODE_AUTO =
      PlaybackProxyMode._(0, _omitEnumNames ? '' : 'PLAYBACK_PROXY_MODE_AUTO');
  static const PlaybackProxyMode PLAYBACK_PROXY_MODE_PREFER =
      PlaybackProxyMode._(
          1, _omitEnumNames ? '' : 'PLAYBACK_PROXY_MODE_PREFER');
  static const PlaybackProxyMode PLAYBACK_PROXY_MODE_ONLY =
      PlaybackProxyMode._(2, _omitEnumNames ? '' : 'PLAYBACK_PROXY_MODE_ONLY');
  static const PlaybackProxyMode PLAYBACK_PROXY_MODE_DIRECT_PREFER =
      PlaybackProxyMode._(
          3, _omitEnumNames ? '' : 'PLAYBACK_PROXY_MODE_DIRECT_PREFER');
  static const PlaybackProxyMode PLAYBACK_PROXY_MODE_DIRECT_ONLY =
      PlaybackProxyMode._(
          4, _omitEnumNames ? '' : 'PLAYBACK_PROXY_MODE_DIRECT_ONLY');

  static const $core.List<PlaybackProxyMode> values = <PlaybackProxyMode>[
    PLAYBACK_PROXY_MODE_AUTO,
    PLAYBACK_PROXY_MODE_PREFER,
    PLAYBACK_PROXY_MODE_ONLY,
    PLAYBACK_PROXY_MODE_DIRECT_PREFER,
    PLAYBACK_PROXY_MODE_DIRECT_ONLY,
  ];

  static final $core.List<PlaybackProxyMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PlaybackProxyMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackProxyMode._(super.value, super.name);
}

class RtmpStreamMode extends $pb.ProtobufEnum {
  static const RtmpStreamMode RTMP_STREAM_MODE_UNSPECIFIED =
      RtmpStreamMode._(0, _omitEnumNames ? '' : 'RTMP_STREAM_MODE_UNSPECIFIED');
  static const RtmpStreamMode RTMP_STREAM_MODE_DEFAULT =
      RtmpStreamMode._(1, _omitEnumNames ? '' : 'RTMP_STREAM_MODE_DEFAULT');
  static const RtmpStreamMode RTMP_STREAM_MODE_VIDEO_ONLY =
      RtmpStreamMode._(2, _omitEnumNames ? '' : 'RTMP_STREAM_MODE_VIDEO_ONLY');
  static const RtmpStreamMode RTMP_STREAM_MODE_AUDIO_ONLY =
      RtmpStreamMode._(3, _omitEnumNames ? '' : 'RTMP_STREAM_MODE_AUDIO_ONLY');

  static const $core.List<RtmpStreamMode> values = <RtmpStreamMode>[
    RTMP_STREAM_MODE_UNSPECIFIED,
    RTMP_STREAM_MODE_DEFAULT,
    RTMP_STREAM_MODE_VIDEO_ONLY,
    RTMP_STREAM_MODE_AUDIO_ONLY,
  ];

  static final $core.List<RtmpStreamMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RtmpStreamMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RtmpStreamMode._(super.value, super.name);
}

class RtspTransport extends $pb.ProtobufEnum {
  static const RtspTransport RTSP_TRANSPORT_UNSPECIFIED =
      RtspTransport._(0, _omitEnumNames ? '' : 'RTSP_TRANSPORT_UNSPECIFIED');
  static const RtspTransport RTSP_TRANSPORT_TCP =
      RtspTransport._(1, _omitEnumNames ? '' : 'RTSP_TRANSPORT_TCP');
  static const RtspTransport RTSP_TRANSPORT_UDP =
      RtspTransport._(2, _omitEnumNames ? '' : 'RTSP_TRANSPORT_UDP');

  static const $core.List<RtspTransport> values = <RtspTransport>[
    RTSP_TRANSPORT_UNSPECIFIED,
    RTSP_TRANSPORT_TCP,
    RTSP_TRANSPORT_UDP,
  ];

  static final $core.List<RtspTransport?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RtspTransport? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RtspTransport._(super.value, super.name);
}

class BilibiliHistoryType extends $pb.ProtobufEnum {
  static const BilibiliHistoryType BILIBILI_HISTORY_TYPE_ALL =
      BilibiliHistoryType._(
          0, _omitEnumNames ? '' : 'BILIBILI_HISTORY_TYPE_ALL');
  static const BilibiliHistoryType BILIBILI_HISTORY_TYPE_ARCHIVE =
      BilibiliHistoryType._(
          1, _omitEnumNames ? '' : 'BILIBILI_HISTORY_TYPE_ARCHIVE');
  static const BilibiliHistoryType BILIBILI_HISTORY_TYPE_LIVE =
      BilibiliHistoryType._(
          2, _omitEnumNames ? '' : 'BILIBILI_HISTORY_TYPE_LIVE');

  static const $core.List<BilibiliHistoryType> values = <BilibiliHistoryType>[
    BILIBILI_HISTORY_TYPE_ALL,
    BILIBILI_HISTORY_TYPE_ARCHIVE,
    BILIBILI_HISTORY_TYPE_LIVE,
  ];

  static final $core.List<BilibiliHistoryType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static BilibiliHistoryType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliHistoryType._(super.value, super.name);
}

class BilibiliPgcTimelineType extends $pb.ProtobufEnum {
  static const BilibiliPgcTimelineType BILIBILI_PGC_TIMELINE_TYPE_UNSPECIFIED =
      BilibiliPgcTimelineType._(
          0, _omitEnumNames ? '' : 'BILIBILI_PGC_TIMELINE_TYPE_UNSPECIFIED');
  static const BilibiliPgcTimelineType BILIBILI_PGC_TIMELINE_TYPE_ANIME =
      BilibiliPgcTimelineType._(
          1, _omitEnumNames ? '' : 'BILIBILI_PGC_TIMELINE_TYPE_ANIME');
  static const BilibiliPgcTimelineType BILIBILI_PGC_TIMELINE_TYPE_CINEMA =
      BilibiliPgcTimelineType._(
          3, _omitEnumNames ? '' : 'BILIBILI_PGC_TIMELINE_TYPE_CINEMA');
  static const BilibiliPgcTimelineType BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG =
      BilibiliPgcTimelineType._(
          4, _omitEnumNames ? '' : 'BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG');

  static const $core.List<BilibiliPgcTimelineType> values =
      <BilibiliPgcTimelineType>[
    BILIBILI_PGC_TIMELINE_TYPE_UNSPECIFIED,
    BILIBILI_PGC_TIMELINE_TYPE_ANIME,
    BILIBILI_PGC_TIMELINE_TYPE_CINEMA,
    BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG,
  ];

  static final $core.List<BilibiliPgcTimelineType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static BilibiliPgcTimelineType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliPgcTimelineType._(super.value, super.name);
}

class TwitchPlaylistContent extends $pb.ProtobufEnum {
  static const TwitchPlaylistContent TWITCH_PLAYLIST_CONTENT_UNSPECIFIED =
      TwitchPlaylistContent._(
          0, _omitEnumNames ? '' : 'TWITCH_PLAYLIST_CONTENT_UNSPECIFIED');
  static const TwitchPlaylistContent TWITCH_PLAYLIST_CONTENT_VIDEOS =
      TwitchPlaylistContent._(
          1, _omitEnumNames ? '' : 'TWITCH_PLAYLIST_CONTENT_VIDEOS');
  static const TwitchPlaylistContent TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS =
      TwitchPlaylistContent._(
          2, _omitEnumNames ? '' : 'TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS');
  static const TwitchPlaylistContent TWITCH_PLAYLIST_CONTENT_UPLOADS =
      TwitchPlaylistContent._(
          3, _omitEnumNames ? '' : 'TWITCH_PLAYLIST_CONTENT_UPLOADS');
  static const TwitchPlaylistContent TWITCH_PLAYLIST_CONTENT_CLIPS =
      TwitchPlaylistContent._(
          4, _omitEnumNames ? '' : 'TWITCH_PLAYLIST_CONTENT_CLIPS');

  static const $core.List<TwitchPlaylistContent> values =
      <TwitchPlaylistContent>[
    TWITCH_PLAYLIST_CONTENT_UNSPECIFIED,
    TWITCH_PLAYLIST_CONTENT_VIDEOS,
    TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS,
    TWITCH_PLAYLIST_CONTENT_UPLOADS,
    TWITCH_PLAYLIST_CONTENT_CLIPS,
  ];

  static final $core.List<TwitchPlaylistContent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TwitchPlaylistContent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TwitchPlaylistContent._(super.value, super.name);
}

class YoutubeChannelContent extends $pb.ProtobufEnum {
  static const YoutubeChannelContent YOUTUBE_CHANNEL_CONTENT_UNSPECIFIED =
      YoutubeChannelContent._(
          0, _omitEnumNames ? '' : 'YOUTUBE_CHANNEL_CONTENT_UNSPECIFIED');
  static const YoutubeChannelContent YOUTUBE_CHANNEL_CONTENT_VIDEOS =
      YoutubeChannelContent._(
          1, _omitEnumNames ? '' : 'YOUTUBE_CHANNEL_CONTENT_VIDEOS');
  static const YoutubeChannelContent YOUTUBE_CHANNEL_CONTENT_SHORTS =
      YoutubeChannelContent._(
          2, _omitEnumNames ? '' : 'YOUTUBE_CHANNEL_CONTENT_SHORTS');
  static const YoutubeChannelContent YOUTUBE_CHANNEL_CONTENT_LIVE =
      YoutubeChannelContent._(
          3, _omitEnumNames ? '' : 'YOUTUBE_CHANNEL_CONTENT_LIVE');

  static const $core.List<YoutubeChannelContent> values =
      <YoutubeChannelContent>[
    YOUTUBE_CHANNEL_CONTENT_UNSPECIFIED,
    YOUTUBE_CHANNEL_CONTENT_VIDEOS,
    YOUTUBE_CHANNEL_CONTENT_SHORTS,
    YOUTUBE_CHANNEL_CONTENT_LIVE,
  ];

  static final $core.List<YoutubeChannelContent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static YoutubeChannelContent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const YoutubeChannelContent._(super.value, super.name);
}

class SynologyLibraryItemKind extends $pb.ProtobufEnum {
  static const SynologyLibraryItemKind SYNOLOGY_LIBRARY_ITEM_KIND_UNSPECIFIED =
      SynologyLibraryItemKind._(
          0, _omitEnumNames ? '' : 'SYNOLOGY_LIBRARY_ITEM_KIND_UNSPECIFIED');
  static const SynologyLibraryItemKind SYNOLOGY_LIBRARY_ITEM_KIND_MOVIE =
      SynologyLibraryItemKind._(
          1, _omitEnumNames ? '' : 'SYNOLOGY_LIBRARY_ITEM_KIND_MOVIE');
  static const SynologyLibraryItemKind SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE =
      SynologyLibraryItemKind._(
          2, _omitEnumNames ? '' : 'SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE');
  static const SynologyLibraryItemKind SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO =
      SynologyLibraryItemKind._(
          3, _omitEnumNames ? '' : 'SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO');
  static const SynologyLibraryItemKind SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING =
      SynologyLibraryItemKind._(
          4, _omitEnumNames ? '' : 'SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING');

  static const $core.List<SynologyLibraryItemKind> values =
      <SynologyLibraryItemKind>[
    SYNOLOGY_LIBRARY_ITEM_KIND_UNSPECIFIED,
    SYNOLOGY_LIBRARY_ITEM_KIND_MOVIE,
    SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE,
    SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO,
    SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING,
  ];

  static final $core.List<SynologyLibraryItemKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SynologyLibraryItemKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SynologyLibraryItemKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
