// This is a generated file - do not edit.
//
// Generated from proto/source_config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sourceProviderDescriptor instead')
const SourceProvider$json = {
  '1': 'SourceProvider',
  '2': [
    {'1': 'SOURCE_PROVIDER_UNSPECIFIED', '2': 0},
    {'1': 'SOURCE_PROVIDER_DIRECT_URL', '2': 1},
    {'1': 'SOURCE_PROVIDER_BILIBILI', '2': 2},
    {'1': 'SOURCE_PROVIDER_ALIST', '2': 3},
    {'1': 'SOURCE_PROVIDER_EMBY', '2': 4},
    {'1': 'SOURCE_PROVIDER_RTMP', '2': 5},
    {'1': 'SOURCE_PROVIDER_LIVE_PROXY', '2': 6},
    {'1': 'SOURCE_PROVIDER_CLOUDREVE', '2': 7},
    {'1': 'SOURCE_PROVIDER_TWITCH', '2': 8},
    {'1': 'SOURCE_PROVIDER_HUYA', '2': 9},
    {'1': 'SOURCE_PROVIDER_DOUYU', '2': 10},
    {'1': 'SOURCE_PROVIDER_DOUYIN', '2': 11},
    {'1': 'SOURCE_PROVIDER_ACFUN', '2': 12},
    {'1': 'SOURCE_PROVIDER_CCTV', '2': 13},
    {'1': 'SOURCE_PROVIDER_FNOS', '2': 14},
    {'1': 'SOURCE_PROVIDER_QNAP', '2': 15},
    {'1': 'SOURCE_PROVIDER_SYNOLOGY', '2': 16},
    {'1': 'SOURCE_PROVIDER_NEXTCLOUD', '2': 17},
    {'1': 'SOURCE_PROVIDER_SEAFILE', '2': 18},
    {'1': 'SOURCE_PROVIDER_TRUENAS', '2': 19},
    {'1': 'SOURCE_PROVIDER_YOUTUBE', '2': 20},
    {'1': 'SOURCE_PROVIDER_TIKTOK', '2': 21},
  ],
};

/// Descriptor for `SourceProvider`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sourceProviderDescriptor = $convert.base64Decode(
    'Cg5Tb3VyY2VQcm92aWRlchIfChtTT1VSQ0VfUFJPVklERVJfVU5TUEVDSUZJRUQQABIeChpTT1'
    'VSQ0VfUFJPVklERVJfRElSRUNUX1VSTBABEhwKGFNPVVJDRV9QUk9WSURFUl9CSUxJQklMSRAC'
    'EhkKFVNPVVJDRV9QUk9WSURFUl9BTElTVBADEhgKFFNPVVJDRV9QUk9WSURFUl9FTUJZEAQSGA'
    'oUU09VUkNFX1BST1ZJREVSX1JUTVAQBRIeChpTT1VSQ0VfUFJPVklERVJfTElWRV9QUk9YWRAG'
    'Eh0KGVNPVVJDRV9QUk9WSURFUl9DTE9VRFJFVkUQBxIaChZTT1VSQ0VfUFJPVklERVJfVFdJVE'
    'NIEAgSGAoUU09VUkNFX1BST1ZJREVSX0hVWUEQCRIZChVTT1VSQ0VfUFJPVklERVJfRE9VWVUQ'
    'ChIaChZTT1VSQ0VfUFJPVklERVJfRE9VWUlOEAsSGQoVU09VUkNFX1BST1ZJREVSX0FDRlVOEA'
    'wSGAoUU09VUkNFX1BST1ZJREVSX0NDVFYQDRIYChRTT1VSQ0VfUFJPVklERVJfRk5PUxAOEhgK'
    'FFNPVVJDRV9QUk9WSURFUl9RTkFQEA8SHAoYU09VUkNFX1BST1ZJREVSX1NZTk9MT0dZEBASHQ'
    'oZU09VUkNFX1BST1ZJREVSX05FWFRDTE9VRBAREhsKF1NPVVJDRV9QUk9WSURFUl9TRUFGSUxF'
    'EBISGwoXU09VUkNFX1BST1ZJREVSX1RSVUVOQVMQExIbChdTT1VSQ0VfUFJPVklERVJfWU9VVF'
    'VCRRAUEhoKFlNPVVJDRV9QUk9WSURFUl9USUtUT0sQFQ==');

@$core.Deprecated('Use playbackKindDescriptor instead')
const PlaybackKind$json = {
  '1': 'PlaybackKind',
  '2': [
    {'1': 'PLAYBACK_KIND_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_KIND_REGULAR', '2': 1},
    {'1': 'PLAYBACK_KIND_LIVE', '2': 2},
  ],
};

/// Descriptor for `PlaybackKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackKindDescriptor = $convert.base64Decode(
    'CgxQbGF5YmFja0tpbmQSHQoZUExBWUJBQ0tfS0lORF9VTlNQRUNJRklFRBAAEhkKFVBMQVlCQU'
    'NLX0tJTkRfUkVHVUxBUhABEhYKElBMQVlCQUNLX0tJTkRfTElWRRAC');

@$core.Deprecated('Use playbackProxyModeDescriptor instead')
const PlaybackProxyMode$json = {
  '1': 'PlaybackProxyMode',
  '2': [
    {'1': 'PLAYBACK_PROXY_MODE_AUTO', '2': 0},
    {'1': 'PLAYBACK_PROXY_MODE_PREFER', '2': 1},
    {'1': 'PLAYBACK_PROXY_MODE_ONLY', '2': 2},
    {'1': 'PLAYBACK_PROXY_MODE_DIRECT_PREFER', '2': 3},
    {'1': 'PLAYBACK_PROXY_MODE_DIRECT_ONLY', '2': 4},
  ],
};

/// Descriptor for `PlaybackProxyMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackProxyModeDescriptor = $convert.base64Decode(
    'ChFQbGF5YmFja1Byb3h5TW9kZRIcChhQTEFZQkFDS19QUk9YWV9NT0RFX0FVVE8QABIeChpQTE'
    'FZQkFDS19QUk9YWV9NT0RFX1BSRUZFUhABEhwKGFBMQVlCQUNLX1BST1hZX01PREVfT05MWRAC'
    'EiUKIVBMQVlCQUNLX1BST1hZX01PREVfRElSRUNUX1BSRUZFUhADEiMKH1BMQVlCQUNLX1BST1'
    'hZX01PREVfRElSRUNUX09OTFkQBA==');

@$core.Deprecated('Use rtmpStreamModeDescriptor instead')
const RtmpStreamMode$json = {
  '1': 'RtmpStreamMode',
  '2': [
    {'1': 'RTMP_STREAM_MODE_UNSPECIFIED', '2': 0},
    {'1': 'RTMP_STREAM_MODE_DEFAULT', '2': 1},
    {'1': 'RTMP_STREAM_MODE_VIDEO_ONLY', '2': 2},
    {'1': 'RTMP_STREAM_MODE_AUDIO_ONLY', '2': 3},
  ],
};

/// Descriptor for `RtmpStreamMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List rtmpStreamModeDescriptor = $convert.base64Decode(
    'Cg5SdG1wU3RyZWFtTW9kZRIgChxSVE1QX1NUUkVBTV9NT0RFX1VOU1BFQ0lGSUVEEAASHAoYUl'
    'RNUF9TVFJFQU1fTU9ERV9ERUZBVUxUEAESHwobUlRNUF9TVFJFQU1fTU9ERV9WSURFT19PTkxZ'
    'EAISHwobUlRNUF9TVFJFQU1fTU9ERV9BVURJT19PTkxZEAM=');

@$core.Deprecated('Use rtspTransportDescriptor instead')
const RtspTransport$json = {
  '1': 'RtspTransport',
  '2': [
    {'1': 'RTSP_TRANSPORT_UNSPECIFIED', '2': 0},
    {'1': 'RTSP_TRANSPORT_TCP', '2': 1},
    {'1': 'RTSP_TRANSPORT_UDP', '2': 2},
  ],
};

/// Descriptor for `RtspTransport`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List rtspTransportDescriptor = $convert.base64Decode(
    'Cg1SdHNwVHJhbnNwb3J0Eh4KGlJUU1BfVFJBTlNQT1JUX1VOU1BFQ0lGSUVEEAASFgoSUlRTUF'
    '9UUkFOU1BPUlRfVENQEAESFgoSUlRTUF9UUkFOU1BPUlRfVURQEAI=');

@$core.Deprecated('Use bilibiliHistoryTypeDescriptor instead')
const BilibiliHistoryType$json = {
  '1': 'BilibiliHistoryType',
  '2': [
    {'1': 'BILIBILI_HISTORY_TYPE_ALL', '2': 0},
    {'1': 'BILIBILI_HISTORY_TYPE_ARCHIVE', '2': 1},
    {'1': 'BILIBILI_HISTORY_TYPE_LIVE', '2': 2},
  ],
};

/// Descriptor for `BilibiliHistoryType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bilibiliHistoryTypeDescriptor = $convert.base64Decode(
    'ChNCaWxpYmlsaUhpc3RvcnlUeXBlEh0KGUJJTElCSUxJX0hJU1RPUllfVFlQRV9BTEwQABIhCh'
    '1CSUxJQklMSV9ISVNUT1JZX1RZUEVfQVJDSElWRRABEh4KGkJJTElCSUxJX0hJU1RPUllfVFlQ'
    'RV9MSVZFEAI=');

@$core.Deprecated('Use bilibiliPgcTimelineTypeDescriptor instead')
const BilibiliPgcTimelineType$json = {
  '1': 'BilibiliPgcTimelineType',
  '2': [
    {'1': 'BILIBILI_PGC_TIMELINE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'BILIBILI_PGC_TIMELINE_TYPE_ANIME', '2': 1},
    {'1': 'BILIBILI_PGC_TIMELINE_TYPE_CINEMA', '2': 3},
    {'1': 'BILIBILI_PGC_TIMELINE_TYPE_GUOCHUANG', '2': 4},
  ],
};

/// Descriptor for `BilibiliPgcTimelineType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bilibiliPgcTimelineTypeDescriptor = $convert.base64Decode(
    'ChdCaWxpYmlsaVBnY1RpbWVsaW5lVHlwZRIqCiZCSUxJQklMSV9QR0NfVElNRUxJTkVfVFlQRV'
    '9VTlNQRUNJRklFRBAAEiQKIEJJTElCSUxJX1BHQ19USU1FTElORV9UWVBFX0FOSU1FEAESJQoh'
    'QklMSUJJTElfUEdDX1RJTUVMSU5FX1RZUEVfQ0lORU1BEAMSKAokQklMSUJJTElfUEdDX1RJTU'
    'VMSU5FX1RZUEVfR1VPQ0hVQU5HEAQ=');

@$core.Deprecated('Use twitchPlaylistContentDescriptor instead')
const TwitchPlaylistContent$json = {
  '1': 'TwitchPlaylistContent',
  '2': [
    {'1': 'TWITCH_PLAYLIST_CONTENT_UNSPECIFIED', '2': 0},
    {'1': 'TWITCH_PLAYLIST_CONTENT_VIDEOS', '2': 1},
    {'1': 'TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS', '2': 2},
    {'1': 'TWITCH_PLAYLIST_CONTENT_UPLOADS', '2': 3},
    {'1': 'TWITCH_PLAYLIST_CONTENT_CLIPS', '2': 4},
  ],
};

/// Descriptor for `TwitchPlaylistContent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List twitchPlaylistContentDescriptor = $convert.base64Decode(
    'ChVUd2l0Y2hQbGF5bGlzdENvbnRlbnQSJwojVFdJVENIX1BMQVlMSVNUX0NPTlRFTlRfVU5TUE'
    'VDSUZJRUQQABIiCh5UV0lUQ0hfUExBWUxJU1RfQ09OVEVOVF9WSURFT1MQARImCiJUV0lUQ0hf'
    'UExBWUxJU1RfQ09OVEVOVF9ISUdITElHSFRTEAISIwofVFdJVENIX1BMQVlMSVNUX0NPTlRFTl'
    'RfVVBMT0FEUxADEiEKHVRXSVRDSF9QTEFZTElTVF9DT05URU5UX0NMSVBTEAQ=');

@$core.Deprecated('Use youtubeChannelContentDescriptor instead')
const YoutubeChannelContent$json = {
  '1': 'YoutubeChannelContent',
  '2': [
    {'1': 'YOUTUBE_CHANNEL_CONTENT_UNSPECIFIED', '2': 0},
    {'1': 'YOUTUBE_CHANNEL_CONTENT_VIDEOS', '2': 1},
    {'1': 'YOUTUBE_CHANNEL_CONTENT_SHORTS', '2': 2},
    {'1': 'YOUTUBE_CHANNEL_CONTENT_LIVE', '2': 3},
  ],
};

/// Descriptor for `YoutubeChannelContent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List youtubeChannelContentDescriptor = $convert.base64Decode(
    'ChVZb3V0dWJlQ2hhbm5lbENvbnRlbnQSJwojWU9VVFVCRV9DSEFOTkVMX0NPTlRFTlRfVU5TUE'
    'VDSUZJRUQQABIiCh5ZT1VUVUJFX0NIQU5ORUxfQ09OVEVOVF9WSURFT1MQARIiCh5ZT1VUVUJF'
    'X0NIQU5ORUxfQ09OVEVOVF9TSE9SVFMQAhIgChxZT1VUVUJFX0NIQU5ORUxfQ09OVEVOVF9MSV'
    'ZFEAM=');

@$core.Deprecated('Use synologyLibraryItemKindDescriptor instead')
const SynologyLibraryItemKind$json = {
  '1': 'SynologyLibraryItemKind',
  '2': [
    {'1': 'SYNOLOGY_LIBRARY_ITEM_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SYNOLOGY_LIBRARY_ITEM_KIND_MOVIE', '2': 1},
    {'1': 'SYNOLOGY_LIBRARY_ITEM_KIND_EPISODE', '2': 2},
    {'1': 'SYNOLOGY_LIBRARY_ITEM_KIND_HOME_VIDEO', '2': 3},
    {'1': 'SYNOLOGY_LIBRARY_ITEM_KIND_TV_RECORDING', '2': 4},
  ],
};

/// Descriptor for `SynologyLibraryItemKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List synologyLibraryItemKindDescriptor = $convert.base64Decode(
    'ChdTeW5vbG9neUxpYnJhcnlJdGVtS2luZBIqCiZTWU5PTE9HWV9MSUJSQVJZX0lURU1fS0lORF'
    '9VTlNQRUNJRklFRBAAEiQKIFNZTk9MT0dZX0xJQlJBUllfSVRFTV9LSU5EX01PVklFEAESJgoi'
    'U1lOT0xPR1lfTElCUkFSWV9JVEVNX0tJTkRfRVBJU09ERRACEikKJVNZTk9MT0dZX0xJQlJBUl'
    'lfSVRFTV9LSU5EX0hPTUVfVklERU8QAxIrCidTWU5PTE9HWV9MSUJSQVJZX0lURU1fS0lORF9U'
    'Vl9SRUNPUkRJTkcQBA==');

@$core.Deprecated('Use directUrlMediaResourceConfigDescriptor instead')
const DirectUrlMediaResourceConfig$json = {
  '1': 'DirectUrlMediaResourceConfig',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'headers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlMediaResourceConfig.HeadersEntry',
      '10': 'headers'
    },
    {'1': 'format', '3': 4, '4': 1, '5': 9, '10': 'format'},
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'expiresAt',
      '17': true
    },
  ],
  '3': [DirectUrlMediaResourceConfig_HeadersEntry$json],
  '8': [
    {'1': '_expires_at'},
  ],
};

@$core.Deprecated('Use directUrlMediaResourceConfigDescriptor instead')
const DirectUrlMediaResourceConfig_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `DirectUrlMediaResourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlMediaResourceConfigDescriptor = $convert.base64Decode(
    'ChxEaXJlY3RVcmxNZWRpYVJlc291cmNlQ29uZmlnEhIKBG5hbWUYASABKAlSBG5hbWUSEAoDdX'
    'JsGAIgASgJUgN1cmwSWQoHaGVhZGVycxgDIAMoCzI/LnN5bmN0di5zb3VyY2VfY29uZmlnLkRp'
    'cmVjdFVybE1lZGlhUmVzb3VyY2VDb25maWcuSGVhZGVyc0VudHJ5UgdoZWFkZXJzEhYKBmZvcm'
    '1hdBgEIAEoCVIGZm9ybWF0EiIKCmV4cGlyZXNfYXQYBSABKANIAFIJZXhwaXJlc0F0iAEBGjoK'
    'DEhlYWRlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6Aj'
    'gBQg0KC19leHBpcmVzX2F0');

@$core.Deprecated('Use directUrlSubtitleSourceConfigDescriptor instead')
const DirectUrlSubtitleSourceConfig$json = {
  '1': 'DirectUrlSubtitleSourceConfig',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'headers',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlSubtitleSourceConfig.HeadersEntry',
      '10': 'headers'
    },
    {'1': 'format', '3': 5, '4': 1, '5': 9, '10': 'format'},
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'expiresAt',
      '17': true
    },
  ],
  '3': [DirectUrlSubtitleSourceConfig_HeadersEntry$json],
  '8': [
    {'1': '_expires_at'},
  ],
};

@$core.Deprecated('Use directUrlSubtitleSourceConfigDescriptor instead')
const DirectUrlSubtitleSourceConfig_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `DirectUrlSubtitleSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlSubtitleSourceConfigDescriptor = $convert.base64Decode(
    'Ch1EaXJlY3RVcmxTdWJ0aXRsZVNvdXJjZUNvbmZpZxISCgRuYW1lGAEgASgJUgRuYW1lEhoKCG'
    'xhbmd1YWdlGAIgASgJUghsYW5ndWFnZRIQCgN1cmwYAyABKAlSA3VybBJaCgdoZWFkZXJzGAQg'
    'AygLMkAuc3luY3R2LnNvdXJjZV9jb25maWcuRGlyZWN0VXJsU3VidGl0bGVTb3VyY2VDb25maW'
    'cuSGVhZGVyc0VudHJ5UgdoZWFkZXJzEhYKBmZvcm1hdBgFIAEoCVIGZm9ybWF0EiIKCmV4cGly'
    'ZXNfYXQYBiABKANIAFIJZXhwaXJlc0F0iAEBGjoKDEhlYWRlcnNFbnRyeRIQCgNrZXkYASABKA'
    'lSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBQg0KC19leHBpcmVzX2F0');

@$core.Deprecated('Use directUrlDanmakuSourceConfigDescriptor instead')
const DirectUrlDanmakuSourceConfig$json = {
  '1': 'DirectUrlDanmakuSourceConfig',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'headers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlDanmakuSourceConfig.HeadersEntry',
      '10': 'headers'
    },
    {'1': 'format', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'format', '17': true},
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'expiresAt',
      '17': true
    },
  ],
  '3': [DirectUrlDanmakuSourceConfig_HeadersEntry$json],
  '8': [
    {'1': '_format'},
    {'1': '_expires_at'},
  ],
};

@$core.Deprecated('Use directUrlDanmakuSourceConfigDescriptor instead')
const DirectUrlDanmakuSourceConfig_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `DirectUrlDanmakuSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlDanmakuSourceConfigDescriptor = $convert.base64Decode(
    'ChxEaXJlY3RVcmxEYW5tYWt1U291cmNlQ29uZmlnEhIKBG5hbWUYASABKAlSBG5hbWUSEAoDdX'
    'JsGAIgASgJUgN1cmwSWQoHaGVhZGVycxgDIAMoCzI/LnN5bmN0di5zb3VyY2VfY29uZmlnLkRp'
    'cmVjdFVybERhbm1ha3VTb3VyY2VDb25maWcuSGVhZGVyc0VudHJ5UgdoZWFkZXJzEhsKBmZvcm'
    '1hdBgEIAEoCUgAUgZmb3JtYXSIAQESIgoKZXhwaXJlc19hdBgFIAEoA0gBUglleHBpcmVzQXSI'
    'AQEaOgoMSGVhZGVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YW'
    'x1ZToCOAFCCQoHX2Zvcm1hdEINCgtfZXhwaXJlc19hdA==');

@$core.Deprecated('Use directUrlMediaSourceConfigDescriptor instead')
const DirectUrlMediaSourceConfig$json = {
  '1': 'DirectUrlMediaSourceConfig',
  '2': [
    {
      '1': 'medias',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlMediaResourceConfig',
      '10': 'medias'
    },
    {
      '1': 'default_media_index',
      '3': 2,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'defaultMediaIndex',
      '17': true
    },
    {
      '1': 'subtitles',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlSubtitleSourceConfig',
      '10': 'subtitles'
    },
    {
      '1': 'default_subtitle_index',
      '3': 4,
      '4': 1,
      '5': 13,
      '9': 1,
      '10': 'defaultSubtitleIndex',
      '17': true
    },
    {
      '1': 'danmakus',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlDanmakuSourceConfig',
      '10': 'danmakus'
    },
    {
      '1': 'default_danmaku_index',
      '3': 6,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'defaultDanmakuIndex',
      '17': true
    },
    {
      '1': 'playback_kind',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackKind',
      '8': {},
      '9': 3,
      '10': 'playbackKind',
      '17': true
    },
    {
      '1': 'duration_seconds',
      '3': 8,
      '4': 1,
      '5': 1,
      '9': 4,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'proxy_mode',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': '_default_media_index'},
    {'1': '_default_subtitle_index'},
    {'1': '_default_danmaku_index'},
    {'1': '_playback_kind'},
    {'1': '_duration_seconds'},
  ],
};

/// Descriptor for `DirectUrlMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChpEaXJlY3RVcmxNZWRpYVNvdXJjZUNvbmZpZxJKCgZtZWRpYXMYASADKAsyMi5zeW5jdHYuc2'
    '91cmNlX2NvbmZpZy5EaXJlY3RVcmxNZWRpYVJlc291cmNlQ29uZmlnUgZtZWRpYXMSMwoTZGVm'
    'YXVsdF9tZWRpYV9pbmRleBgCIAEoDUgAUhFkZWZhdWx0TWVkaWFJbmRleIgBARJRCglzdWJ0aX'
    'RsZXMYAyADKAsyMy5zeW5jdHYuc291cmNlX2NvbmZpZy5EaXJlY3RVcmxTdWJ0aXRsZVNvdXJj'
    'ZUNvbmZpZ1IJc3VidGl0bGVzEjkKFmRlZmF1bHRfc3VidGl0bGVfaW5kZXgYBCABKA1IAVIUZG'
    'VmYXVsdFN1YnRpdGxlSW5kZXiIAQESTgoIZGFubWFrdXMYBSADKAsyMi5zeW5jdHYuc291cmNl'
    'X2NvbmZpZy5EaXJlY3RVcmxEYW5tYWt1U291cmNlQ29uZmlnUghkYW5tYWt1cxI3ChVkZWZhdW'
    'x0X2Rhbm1ha3VfaW5kZXgYBiABKA1IAlITZGVmYXVsdERhbm1ha3VJbmRleIgBARJWCg1wbGF5'
    'YmFja19raW5kGAcgASgOMiIuc3luY3R2LnNvdXJjZV9jb25maWcuUGxheWJhY2tLaW5kQgi6SA'
    'WCAQIQAUgDUgxwbGF5YmFja0tpbmSIAQESLgoQZHVyYXRpb25fc2Vjb25kcxgIIAEoAUgEUg9k'
    'dXJhdGlvblNlY29uZHOIAQESUAoKcHJveHlfbW9kZRgJIAEoDjInLnN5bmN0di5zb3VyY2VfY2'
    '9uZmlnLlBsYXliYWNrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2RlQhYKFF9kZWZhdWx0'
    'X21lZGlhX2luZGV4QhkKF19kZWZhdWx0X3N1YnRpdGxlX2luZGV4QhgKFl9kZWZhdWx0X2Rhbm'
    '1ha3VfaW5kZXhCEAoOX3BsYXliYWNrX2tpbmRCEwoRX2R1cmF0aW9uX3NlY29uZHM=');

@$core.Deprecated('Use alistMediaSourceConfigDescriptor instead')
const AlistMediaSourceConfig$json = {
  '1': 'AlistMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'password',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'password',
      '17': true
    },
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': '_password'},
  ],
};

/// Descriptor for `AlistMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChZBbGlzdE1lZGlhU291cmNlQ29uZmlnEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSEg'
    'oEcGF0aBgCIAEoCVIEcGF0aBIfCghwYXNzd29yZBgDIAEoCUgAUghwYXNzd29yZIgBARJQCgpw'
    'cm94eV9tb2RlGAQgASgOMicuc3luY3R2LnNvdXJjZV9jb25maWcuUGxheWJhY2tQcm94eU1vZG'
    'VCCLpIBYIBAhABUglwcm94eU1vZGVCCwoJX3Bhc3N3b3Jk');

@$core.Deprecated('Use alistPlaylistSourceConfigDescriptor instead')
const AlistPlaylistSourceConfig$json = {
  '1': 'AlistPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'password',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'password',
      '17': true
    },
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': '_password'},
  ],
};

/// Descriptor for `AlistPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChlBbGlzdFBsYXlsaXN0U291cmNlQ29uZmlnEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySW'
    'QSEgoEcGF0aBgCIAEoCVIEcGF0aBIfCghwYXNzd29yZBgDIAEoCUgAUghwYXNzd29yZIgBARJQ'
    'Cgpwcm94eV9tb2RlGAQgASgOMicuc3luY3R2LnNvdXJjZV9jb25maWcuUGxheWJhY2tQcm94eU'
    '1vZGVCCLpIBYIBAhABUglwcm94eU1vZGVCCwoJX3Bhc3N3b3Jk');

@$core.Deprecated('Use cloudreveMediaSourceConfigDescriptor instead')
const CloudreveMediaSourceConfig$json = {
  '1': 'CloudreveMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `CloudreveMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudreveMediaSourceConfigDescriptor =
    $convert.base64Decode(
        'ChpDbG91ZHJldmVNZWRpYVNvdXJjZUNvbmZpZxIbCglzZXJ2ZXJfaWQYASABKAlSCHNlcnZlck'
        'lkEhIKBHBhdGgYAiABKAlSBHBhdGgSUAoKcHJveHlfbW9kZRgDIAEoDjInLnN5bmN0di5zb3Vy'
        'Y2VfY29uZmlnLlBsYXliYWNrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2Rl');

@$core.Deprecated('Use cloudrevePlaylistSourceConfigDescriptor instead')
const CloudrevePlaylistSourceConfig$json = {
  '1': 'CloudrevePlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `CloudrevePlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudrevePlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'Ch1DbG91ZHJldmVQbGF5bGlzdFNvdXJjZUNvbmZpZxIbCglzZXJ2ZXJfaWQYASABKAlSCHNlcn'
        'ZlcklkEhIKBHBhdGgYAiABKAlSBHBhdGgSUAoKcHJveHlfbW9kZRgDIAEoDjInLnN5bmN0di5z'
        'b3VyY2VfY29uZmlnLlBsYXliYWNrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2Rl');

@$core.Deprecated('Use embyMediaSourceConfigDescriptor instead')
const EmbyMediaSourceConfig$json = {
  '1': 'EmbyMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `EmbyMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVFbWJ5TWVkaWFTb3VyY2VDb25maWcSGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZBIXCg'
    'dpdGVtX2lkGAIgASgJUgZpdGVtSWQSUAoKcHJveHlfbW9kZRgDIAEoDjInLnN5bmN0di5zb3Vy'
    'Y2VfY29uZmlnLlBsYXliYWNrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2Rl');

@$core.Deprecated('Use embyPlaylistSourceConfigDescriptor instead')
const EmbyPlaylistSourceConfig$json = {
  '1': 'EmbyPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {
      '1': 'folder',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyFolderPlaylistSource',
      '9': 0,
      '10': 'folder'
    },
    {
      '1': 'favorite_items',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyFavoriteItemsPlaylistSource',
      '9': 0,
      '10': 'favoriteItems'
    },
    {
      '1': 'favorite_people',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyFavoritePeoplePlaylistSource',
      '9': 0,
      '10': 'favoritePeople'
    },
    {
      '1': 'person_items',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyPersonItemsPlaylistSource',
      '9': 0,
      '10': 'personItems'
    },
    {
      '1': 'continue_watching',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyContinueWatchingPlaylistSource',
      '9': 0,
      '10': 'continueWatching'
    },
    {
      '1': 'next_up',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyNextUpPlaylistSource',
      '9': 0,
      '10': 'nextUp'
    },
    {
      '1': 'recently_added',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyRecentlyAddedPlaylistSource',
      '9': 0,
      '10': 'recentlyAdded'
    },
    {
      '1': 'playlists',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyPlaylistsPlaylistSource',
      '9': 0,
      '10': 'playlists'
    },
    {
      '1': 'collections',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyCollectionsPlaylistSource',
      '9': 0,
      '10': 'collections'
    },
    {
      '1': 'genres',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyGenresPlaylistSource',
      '9': 0,
      '10': 'genres'
    },
    {
      '1': 'genre_items',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyGenreItemsPlaylistSource',
      '9': 0,
      '10': 'genreItems'
    },
    {
      '1': 'proxy_mode',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `EmbyPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChhFbWJ5UGxheWxpc3RTb3VyY2VDb25maWcSGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZB'
    'JICgZmb2xkZXIYAiABKAsyLi5zeW5jdHYuc291cmNlX2NvbmZpZy5FbWJ5Rm9sZGVyUGxheWxp'
    'c3RTb3VyY2VIAFIGZm9sZGVyEl4KDmZhdm9yaXRlX2l0ZW1zGAMgASgLMjUuc3luY3R2LnNvdX'
    'JjZV9jb25maWcuRW1ieUZhdm9yaXRlSXRlbXNQbGF5bGlzdFNvdXJjZUgAUg1mYXZvcml0ZUl0'
    'ZW1zEmEKD2Zhdm9yaXRlX3Blb3BsZRgEIAEoCzI2LnN5bmN0di5zb3VyY2VfY29uZmlnLkVtYn'
    'lGYXZvcml0ZVBlb3BsZVBsYXlsaXN0U291cmNlSABSDmZhdm9yaXRlUGVvcGxlElgKDHBlcnNv'
    'bl9pdGVtcxgFIAEoCzIzLnN5bmN0di5zb3VyY2VfY29uZmlnLkVtYnlQZXJzb25JdGVtc1BsYX'
    'lsaXN0U291cmNlSABSC3BlcnNvbkl0ZW1zEmcKEWNvbnRpbnVlX3dhdGNoaW5nGAYgASgLMjgu'
    'c3luY3R2LnNvdXJjZV9jb25maWcuRW1ieUNvbnRpbnVlV2F0Y2hpbmdQbGF5bGlzdFNvdXJjZU'
    'gAUhBjb250aW51ZVdhdGNoaW5nEkkKB25leHRfdXAYByABKAsyLi5zeW5jdHYuc291cmNlX2Nv'
    'bmZpZy5FbWJ5TmV4dFVwUGxheWxpc3RTb3VyY2VIAFIGbmV4dFVwEl4KDnJlY2VudGx5X2FkZG'
    'VkGAggASgLMjUuc3luY3R2LnNvdXJjZV9jb25maWcuRW1ieVJlY2VudGx5QWRkZWRQbGF5bGlz'
    'dFNvdXJjZUgAUg1yZWNlbnRseUFkZGVkElEKCXBsYXlsaXN0cxgJIAEoCzIxLnN5bmN0di5zb3'
    'VyY2VfY29uZmlnLkVtYnlQbGF5bGlzdHNQbGF5bGlzdFNvdXJjZUgAUglwbGF5bGlzdHMSVwoL'
    'Y29sbGVjdGlvbnMYCiABKAsyMy5zeW5jdHYuc291cmNlX2NvbmZpZy5FbWJ5Q29sbGVjdGlvbn'
    'NQbGF5bGlzdFNvdXJjZUgAUgtjb2xsZWN0aW9ucxJICgZnZW5yZXMYCyABKAsyLi5zeW5jdHYu'
    'c291cmNlX2NvbmZpZy5FbWJ5R2VucmVzUGxheWxpc3RTb3VyY2VIAFIGZ2VucmVzElUKC2dlbn'
    'JlX2l0ZW1zGAwgASgLMjIuc3luY3R2LnNvdXJjZV9jb25maWcuRW1ieUdlbnJlSXRlbXNQbGF5'
    'bGlzdFNvdXJjZUgAUgpnZW5yZUl0ZW1zElAKCnByb3h5X21vZGUYDSABKA4yJy5zeW5jdHYuc2'
    '91cmNlX2NvbmZpZy5QbGF5YmFja1Byb3h5TW9kZUIIukgFggECEAFSCXByb3h5TW9kZUIICgZz'
    'b3VyY2U=');

@$core.Deprecated('Use embyFolderPlaylistSourceDescriptor instead')
const EmbyFolderPlaylistSource$json = {
  '1': 'EmbyFolderPlaylistSource',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `EmbyFolderPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyFolderPlaylistSourceDescriptor =
    $convert.base64Decode(
        'ChhFbWJ5Rm9sZGVyUGxheWxpc3RTb3VyY2USFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlk');

@$core.Deprecated('Use embyFavoriteItemsPlaylistSourceDescriptor instead')
const EmbyFavoriteItemsPlaylistSource$json = {
  '1': 'EmbyFavoriteItemsPlaylistSource',
  '2': [
    {'1': 'item_types', '3': 1, '4': 3, '5': 9, '10': 'itemTypes'},
  ],
};

/// Descriptor for `EmbyFavoriteItemsPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyFavoriteItemsPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch9FbWJ5RmF2b3JpdGVJdGVtc1BsYXlsaXN0U291cmNlEh0KCml0ZW1fdHlwZXMYASADKAlSCW'
        'l0ZW1UeXBlcw==');

@$core.Deprecated('Use embyFavoritePeoplePlaylistSourceDescriptor instead')
const EmbyFavoritePeoplePlaylistSource$json = {
  '1': 'EmbyFavoritePeoplePlaylistSource',
};

/// Descriptor for `EmbyFavoritePeoplePlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyFavoritePeoplePlaylistSourceDescriptor =
    $convert.base64Decode('CiBFbWJ5RmF2b3JpdGVQZW9wbGVQbGF5bGlzdFNvdXJjZQ==');

@$core.Deprecated('Use embyPersonItemsPlaylistSourceDescriptor instead')
const EmbyPersonItemsPlaylistSource$json = {
  '1': 'EmbyPersonItemsPlaylistSource',
  '2': [
    {'1': 'person_id', '3': 1, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'item_types', '3': 2, '4': 3, '5': 9, '10': 'itemTypes'},
  ],
};

/// Descriptor for `EmbyPersonItemsPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyPersonItemsPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch1FbWJ5UGVyc29uSXRlbXNQbGF5bGlzdFNvdXJjZRIbCglwZXJzb25faWQYASABKAlSCHBlcn'
        'NvbklkEh0KCml0ZW1fdHlwZXMYAiADKAlSCWl0ZW1UeXBlcw==');

@$core.Deprecated('Use embyContinueWatchingPlaylistSourceDescriptor instead')
const EmbyContinueWatchingPlaylistSource$json = {
  '1': 'EmbyContinueWatchingPlaylistSource',
};

/// Descriptor for `EmbyContinueWatchingPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyContinueWatchingPlaylistSourceDescriptor =
    $convert.base64Decode('CiJFbWJ5Q29udGludWVXYXRjaGluZ1BsYXlsaXN0U291cmNl');

@$core.Deprecated('Use embyNextUpPlaylistSourceDescriptor instead')
const EmbyNextUpPlaylistSource$json = {
  '1': 'EmbyNextUpPlaylistSource',
};

/// Descriptor for `EmbyNextUpPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyNextUpPlaylistSourceDescriptor =
    $convert.base64Decode('ChhFbWJ5TmV4dFVwUGxheWxpc3RTb3VyY2U=');

@$core.Deprecated('Use embyRecentlyAddedPlaylistSourceDescriptor instead')
const EmbyRecentlyAddedPlaylistSource$json = {
  '1': 'EmbyRecentlyAddedPlaylistSource',
  '2': [
    {'1': 'item_types', '3': 1, '4': 3, '5': 9, '10': 'itemTypes'},
  ],
};

/// Descriptor for `EmbyRecentlyAddedPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyRecentlyAddedPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch9FbWJ5UmVjZW50bHlBZGRlZFBsYXlsaXN0U291cmNlEh0KCml0ZW1fdHlwZXMYASADKAlSCW'
        'l0ZW1UeXBlcw==');

@$core.Deprecated('Use embyPlaylistsPlaylistSourceDescriptor instead')
const EmbyPlaylistsPlaylistSource$json = {
  '1': 'EmbyPlaylistsPlaylistSource',
};

/// Descriptor for `EmbyPlaylistsPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyPlaylistsPlaylistSourceDescriptor =
    $convert.base64Decode('ChtFbWJ5UGxheWxpc3RzUGxheWxpc3RTb3VyY2U=');

@$core.Deprecated('Use embyCollectionsPlaylistSourceDescriptor instead')
const EmbyCollectionsPlaylistSource$json = {
  '1': 'EmbyCollectionsPlaylistSource',
};

/// Descriptor for `EmbyCollectionsPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyCollectionsPlaylistSourceDescriptor =
    $convert.base64Decode('Ch1FbWJ5Q29sbGVjdGlvbnNQbGF5bGlzdFNvdXJjZQ==');

@$core.Deprecated('Use embyGenresPlaylistSourceDescriptor instead')
const EmbyGenresPlaylistSource$json = {
  '1': 'EmbyGenresPlaylistSource',
  '2': [
    {'1': 'item_types', '3': 1, '4': 3, '5': 9, '10': 'itemTypes'},
  ],
};

/// Descriptor for `EmbyGenresPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyGenresPlaylistSourceDescriptor =
    $convert.base64Decode(
        'ChhFbWJ5R2VucmVzUGxheWxpc3RTb3VyY2USHQoKaXRlbV90eXBlcxgBIAMoCVIJaXRlbVR5cG'
        'Vz');

@$core.Deprecated('Use embyGenreItemsPlaylistSourceDescriptor instead')
const EmbyGenreItemsPlaylistSource$json = {
  '1': 'EmbyGenreItemsPlaylistSource',
  '2': [
    {'1': 'genre_id', '3': 1, '4': 1, '5': 9, '10': 'genreId'},
    {'1': 'item_types', '3': 2, '4': 3, '5': 9, '10': 'itemTypes'},
  ],
};

/// Descriptor for `EmbyGenreItemsPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyGenreItemsPlaylistSourceDescriptor =
    $convert.base64Decode(
        'ChxFbWJ5R2VucmVJdGVtc1BsYXlsaXN0U291cmNlEhkKCGdlbnJlX2lkGAEgASgJUgdnZW5yZU'
        'lkEh0KCml0ZW1fdHlwZXMYAiADKAlSCWl0ZW1UeXBlcw==');

@$core.Deprecated('Use rtmpMediaSourceConfigDescriptor instead')
const RtmpMediaSourceConfig$json = {
  '1': 'RtmpMediaSourceConfig',
  '2': [
    {
      '1': 'mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.RtmpStreamMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `RtmpMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVSdG1wTWVkaWFTb3VyY2VDb25maWcSOAoEbW9kZRgBIAEoDjIkLnN5bmN0di5zb3VyY2VfY2'
    '9uZmlnLlJ0bXBTdHJlYW1Nb2RlUgRtb2Rl');

@$core.Deprecated('Use rtspTrackSelectionDescriptor instead')
const RtspTrackSelection$json = {
  '1': 'RtspTrackSelection',
  '2': [
    {
      '1': 'first_compatible',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'firstCompatible'
    },
    {'1': 'index', '3': 2, '4': 1, '5': 13, '9': 0, '10': 'index'},
    {'1': 'disabled', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'disabled'},
  ],
  '8': [
    {'1': 'mode'},
  ],
};

/// Descriptor for `RtspTrackSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtspTrackSelectionDescriptor = $convert.base64Decode(
    'ChJSdHNwVHJhY2tTZWxlY3Rpb24SKwoQZmlyc3RfY29tcGF0aWJsZRgBIAEoCEgAUg9maXJzdE'
    'NvbXBhdGlibGUSFgoFaW5kZXgYAiABKA1IAFIFaW5kZXgSHAoIZGlzYWJsZWQYAyABKAhIAFII'
    'ZGlzYWJsZWRCBgoEbW9kZQ==');

@$core.Deprecated('Use rtmpPullSourceConfigDescriptor instead')
const RtmpPullSourceConfig$json = {
  '1': 'RtmpPullSourceConfig',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.RtmpStreamMode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `RtmpPullSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpPullSourceConfigDescriptor = $convert.base64Decode(
    'ChRSdG1wUHVsbFNvdXJjZUNvbmZpZxIQCgN1cmwYASABKAlSA3VybBI4CgRtb2RlGAIgASgOMi'
    'Quc3luY3R2LnNvdXJjZV9jb25maWcuUnRtcFN0cmVhbU1vZGVSBG1vZGU=');

@$core.Deprecated('Use rtspPullSourceConfigDescriptor instead')
const RtspPullSourceConfig$json = {
  '1': 'RtspPullSourceConfig',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'transport',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.RtspTransport',
      '10': 'transport'
    },
    {
      '1': 'video_track',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.RtspTrackSelection',
      '10': 'videoTrack'
    },
    {
      '1': 'audio_track',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.RtspTrackSelection',
      '10': 'audioTrack'
    },
  ],
};

/// Descriptor for `RtspPullSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtspPullSourceConfigDescriptor = $convert.base64Decode(
    'ChRSdHNwUHVsbFNvdXJjZUNvbmZpZxIQCgN1cmwYASABKAlSA3VybBJBCgl0cmFuc3BvcnQYAi'
    'ABKA4yIy5zeW5jdHYuc291cmNlX2NvbmZpZy5SdHNwVHJhbnNwb3J0Ugl0cmFuc3BvcnQSSQoL'
    'dmlkZW9fdHJhY2sYAyABKAsyKC5zeW5jdHYuc291cmNlX2NvbmZpZy5SdHNwVHJhY2tTZWxlY3'
    'Rpb25SCnZpZGVvVHJhY2sSSQoLYXVkaW9fdHJhY2sYBCABKAsyKC5zeW5jdHYuc291cmNlX2Nv'
    'bmZpZy5SdHNwVHJhY2tTZWxlY3Rpb25SCmF1ZGlvVHJhY2s=');

@$core.Deprecated('Use httpFlvPullSourceConfigDescriptor instead')
const HttpFlvPullSourceConfig$json = {
  '1': 'HttpFlvPullSourceConfig',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `HttpFlvPullSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List httpFlvPullSourceConfigDescriptor =
    $convert.base64Decode(
        'ChdIdHRwRmx2UHVsbFNvdXJjZUNvbmZpZxIQCgN1cmwYASABKAlSA3VybA==');

@$core.Deprecated('Use whepPullSourceConfigDescriptor instead')
const WhepPullSourceConfig$json = {
  '1': 'WhepPullSourceConfig',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'authorization',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'authorization',
      '17': true
    },
  ],
  '8': [
    {'1': '_authorization'},
  ],
};

/// Descriptor for `WhepPullSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List whepPullSourceConfigDescriptor = $convert.base64Decode(
    'ChRXaGVwUHVsbFNvdXJjZUNvbmZpZxIQCgN1cmwYASABKAlSA3VybBIzCg1hdXRob3JpemF0aW'
    '9uGAIgASgJQgi6SAVyAxiAIEgAUg1hdXRob3JpemF0aW9uiAEBQhAKDl9hdXRob3JpemF0aW9u');

@$core.Deprecated('Use liveProxyMediaSourceConfigDescriptor instead')
const LiveProxyMediaSourceConfig$json = {
  '1': 'LiveProxyMediaSourceConfig',
  '2': [
    {
      '1': 'rtmp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.RtmpPullSourceConfig',
      '9': 0,
      '10': 'rtmp'
    },
    {
      '1': 'rtsp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.RtspPullSourceConfig',
      '9': 0,
      '10': 'rtsp'
    },
    {
      '1': 'http_flv',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.HttpFlvPullSourceConfig',
      '9': 0,
      '10': 'httpFlv'
    },
    {
      '1': 'whep',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.WhepPullSourceConfig',
      '9': 0,
      '10': 'whep'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `LiveProxyMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveProxyMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChpMaXZlUHJveHlNZWRpYVNvdXJjZUNvbmZpZxJACgRydG1wGAEgASgLMiouc3luY3R2LnNvdX'
    'JjZV9jb25maWcuUnRtcFB1bGxTb3VyY2VDb25maWdIAFIEcnRtcBJACgRydHNwGAIgASgLMiou'
    'c3luY3R2LnNvdXJjZV9jb25maWcuUnRzcFB1bGxTb3VyY2VDb25maWdIAFIEcnRzcBJKCghodH'
    'RwX2ZsdhgDIAEoCzItLnN5bmN0di5zb3VyY2VfY29uZmlnLkh0dHBGbHZQdWxsU291cmNlQ29u'
    'ZmlnSABSB2h0dHBGbHYSQAoEd2hlcBgEIAEoCzIqLnN5bmN0di5zb3VyY2VfY29uZmlnLldoZX'
    'BQdWxsU291cmNlQ29uZmlnSABSBHdoZXBCCAoGc291cmNl');

@$core.Deprecated('Use bilibiliVideoSourceConfigDescriptor instead')
const BilibiliVideoSourceConfig$json = {
  '1': 'BilibiliVideoSourceConfig',
  '2': [
    {'1': 'bvid', '3': 1, '4': 1, '5': 9, '10': 'bvid'},
    {'1': 'aid', '3': 2, '4': 1, '5': 4, '9': 0, '10': 'aid', '17': true},
    {'1': 'cid', '3': 3, '4': 1, '5': 4, '10': 'cid'},
    {'1': 'shared', '3': 4, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_aid'},
  ],
};

/// Descriptor for `BilibiliVideoSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliVideoSourceConfigDescriptor = $convert.base64Decode(
    'ChlCaWxpYmlsaVZpZGVvU291cmNlQ29uZmlnEhIKBGJ2aWQYASABKAlSBGJ2aWQSFQoDYWlkGA'
    'IgASgESABSA2FpZIgBARIQCgNjaWQYAyABKARSA2NpZBIWCgZzaGFyZWQYBCABKAhSBnNoYXJl'
    'ZEIGCgRfYWlk');

@$core.Deprecated('Use bilibiliPgcSourceConfigDescriptor instead')
const BilibiliPgcSourceConfig$json = {
  '1': 'BilibiliPgcSourceConfig',
  '2': [
    {'1': 'epid', '3': 1, '4': 1, '5': 4, '10': 'epid'},
    {'1': 'cid', '3': 2, '4': 1, '5': 4, '10': 'cid'},
    {'1': 'shared', '3': 3, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `BilibiliPgcSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliPgcSourceConfigDescriptor =
    $convert.base64Decode(
        'ChdCaWxpYmlsaVBnY1NvdXJjZUNvbmZpZxISCgRlcGlkGAEgASgEUgRlcGlkEhAKA2NpZBgCIA'
        'EoBFIDY2lkEhYKBnNoYXJlZBgDIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use bilibiliLiveSourceConfigDescriptor instead')
const BilibiliLiveSourceConfig$json = {
  '1': 'BilibiliLiveSourceConfig',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 4, '10': 'roomId'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `BilibiliLiveSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliLiveSourceConfigDescriptor =
    $convert.base64Decode(
        'ChhCaWxpYmlsaUxpdmVTb3VyY2VDb25maWcSFwoHcm9vbV9pZBgBIAEoBFIGcm9vbUlkEhYKBn'
        'NoYXJlZBgCIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use bilibiliMediaSourceConfigDescriptor instead')
const BilibiliMediaSourceConfig$json = {
  '1': 'BilibiliMediaSourceConfig',
  '2': [
    {
      '1': 'video',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliVideoSourceConfig',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'pgc',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliPgcSourceConfig',
      '9': 0,
      '10': 'pgc'
    },
    {
      '1': 'live',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliLiveSourceConfig',
      '9': 0,
      '10': 'live'
    },
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `BilibiliMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChlCaWxpYmlsaU1lZGlhU291cmNlQ29uZmlnEkcKBXZpZGVvGAEgASgLMi8uc3luY3R2LnNvdX'
    'JjZV9jb25maWcuQmlsaWJpbGlWaWRlb1NvdXJjZUNvbmZpZ0gAUgV2aWRlbxJBCgNwZ2MYAiAB'
    'KAsyLS5zeW5jdHYuc291cmNlX2NvbmZpZy5CaWxpYmlsaVBnY1NvdXJjZUNvbmZpZ0gAUgNwZ2'
    'MSRAoEbGl2ZRgDIAEoCzIuLnN5bmN0di5zb3VyY2VfY29uZmlnLkJpbGliaWxpTGl2ZVNvdXJj'
    'ZUNvbmZpZ0gAUgRsaXZlElAKCnByb3h5X21vZGUYBCABKA4yJy5zeW5jdHYuc291cmNlX2Nvbm'
    'ZpZy5QbGF5YmFja1Byb3h5TW9kZUIIukgFggECEAFSCXByb3h5TW9kZUIICgZzb3VyY2U=');

@$core.Deprecated('Use bilibiliPopularPlaylistSourceDescriptor instead')
const BilibiliPopularPlaylistSource$json = {
  '1': 'BilibiliPopularPlaylistSource',
};

/// Descriptor for `BilibiliPopularPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliPopularPlaylistSourceDescriptor =
    $convert.base64Decode('Ch1CaWxpYmlsaVBvcHVsYXJQbGF5bGlzdFNvdXJjZQ==');

@$core.Deprecated('Use bilibiliRecommendedPlaylistSourceDescriptor instead')
const BilibiliRecommendedPlaylistSource$json = {
  '1': 'BilibiliRecommendedPlaylistSource',
};

/// Descriptor for `BilibiliRecommendedPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliRecommendedPlaylistSourceDescriptor =
    $convert.base64Decode('CiFCaWxpYmlsaVJlY29tbWVuZGVkUGxheWxpc3RTb3VyY2U=');

@$core.Deprecated('Use bilibiliVideoPartsPlaylistSourceDescriptor instead')
const BilibiliVideoPartsPlaylistSource$json = {
  '1': 'BilibiliVideoPartsPlaylistSource',
  '2': [
    {'1': 'bvid', '3': 1, '4': 1, '5': 9, '10': 'bvid'},
    {'1': 'aid', '3': 2, '4': 1, '5': 4, '9': 0, '10': 'aid', '17': true},
  ],
  '8': [
    {'1': '_aid'},
  ],
};

/// Descriptor for `BilibiliVideoPartsPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliVideoPartsPlaylistSourceDescriptor =
    $convert.base64Decode(
        'CiBCaWxpYmlsaVZpZGVvUGFydHNQbGF5bGlzdFNvdXJjZRISCgRidmlkGAEgASgJUgRidmlkEh'
        'UKA2FpZBgCIAEoBEgAUgNhaWSIAQFCBgoEX2FpZA==');

@$core.Deprecated('Use bilibiliUpVideosPlaylistSourceDescriptor instead')
const BilibiliUpVideosPlaylistSource$json = {
  '1': 'BilibiliUpVideosPlaylistSource',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 4, '10': 'mid'},
    {'1': 'keyword', '3': 2, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `BilibiliUpVideosPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliUpVideosPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch5CaWxpYmlsaVVwVmlkZW9zUGxheWxpc3RTb3VyY2USEAoDbWlkGAEgASgEUgNtaWQSGAoHa2'
        'V5d29yZBgCIAEoCVIHa2V5d29yZA==');

@$core.Deprecated('Use bilibiliFavoriteVideosPlaylistSourceDescriptor instead')
const BilibiliFavoriteVideosPlaylistSource$json = {
  '1': 'BilibiliFavoriteVideosPlaylistSource',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 4, '10': 'mediaId'},
  ],
};

/// Descriptor for `BilibiliFavoriteVideosPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliFavoriteVideosPlaylistSourceDescriptor =
    $convert.base64Decode(
        'CiRCaWxpYmlsaUZhdm9yaXRlVmlkZW9zUGxheWxpc3RTb3VyY2USGQoIbWVkaWFfaWQYASABKA'
        'RSB21lZGlhSWQ=');

@$core
    .Deprecated('Use bilibiliCollectionVideosPlaylistSourceDescriptor instead')
const BilibiliCollectionVideosPlaylistSource$json = {
  '1': 'BilibiliCollectionVideosPlaylistSource',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 4, '10': 'mid'},
    {'1': 'season_id', '3': 2, '4': 1, '5': 4, '10': 'seasonId'},
  ],
};

/// Descriptor for `BilibiliCollectionVideosPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliCollectionVideosPlaylistSourceDescriptor =
    $convert.base64Decode(
        'CiZCaWxpYmlsaUNvbGxlY3Rpb25WaWRlb3NQbGF5bGlzdFNvdXJjZRIQCgNtaWQYASABKARSA2'
        '1pZBIbCglzZWFzb25faWQYAiABKARSCHNlYXNvbklk');

@$core.Deprecated('Use bilibiliSeriesVideosPlaylistSourceDescriptor instead')
const BilibiliSeriesVideosPlaylistSource$json = {
  '1': 'BilibiliSeriesVideosPlaylistSource',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 4, '10': 'mid'},
    {'1': 'series_id', '3': 2, '4': 1, '5': 4, '10': 'seriesId'},
  ],
};

/// Descriptor for `BilibiliSeriesVideosPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliSeriesVideosPlaylistSourceDescriptor =
    $convert.base64Decode(
        'CiJCaWxpYmlsaVNlcmllc1ZpZGVvc1BsYXlsaXN0U291cmNlEhAKA21pZBgBIAEoBFIDbWlkEh'
        'sKCXNlcmllc19pZBgCIAEoBFIIc2VyaWVzSWQ=');

@$core.Deprecated('Use bilibiliWatchLaterPlaylistSourceDescriptor instead')
const BilibiliWatchLaterPlaylistSource$json = {
  '1': 'BilibiliWatchLaterPlaylistSource',
};

/// Descriptor for `BilibiliWatchLaterPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliWatchLaterPlaylistSourceDescriptor =
    $convert.base64Decode('CiBCaWxpYmlsaVdhdGNoTGF0ZXJQbGF5bGlzdFNvdXJjZQ==');

@$core.Deprecated('Use bilibiliPgcSeasonPlaylistSourceDescriptor instead')
const BilibiliPgcSeasonPlaylistSource$json = {
  '1': 'BilibiliPgcSeasonPlaylistSource',
  '2': [
    {'1': 'season_id', '3': 1, '4': 1, '5': 4, '10': 'seasonId'},
  ],
};

/// Descriptor for `BilibiliPgcSeasonPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliPgcSeasonPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch9CaWxpYmlsaVBnY1NlYXNvblBsYXlsaXN0U291cmNlEhsKCXNlYXNvbl9pZBgBIAEoBFIIc2'
        'Vhc29uSWQ=');

@$core.Deprecated('Use bilibiliLiveRecommendedPlaylistSourceDescriptor instead')
const BilibiliLiveRecommendedPlaylistSource$json = {
  '1': 'BilibiliLiveRecommendedPlaylistSource',
};

/// Descriptor for `BilibiliLiveRecommendedPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliLiveRecommendedPlaylistSourceDescriptor =
    $convert
        .base64Decode('CiVCaWxpYmlsaUxpdmVSZWNvbW1lbmRlZFBsYXlsaXN0U291cmNl');

@$core.Deprecated('Use bilibiliLiveFollowedPlaylistSourceDescriptor instead')
const BilibiliLiveFollowedPlaylistSource$json = {
  '1': 'BilibiliLiveFollowedPlaylistSource',
};

/// Descriptor for `BilibiliLiveFollowedPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliLiveFollowedPlaylistSourceDescriptor =
    $convert.base64Decode('CiJCaWxpYmlsaUxpdmVGb2xsb3dlZFBsYXlsaXN0U291cmNl');

@$core.Deprecated('Use bilibiliLiveAreaPlaylistSourceDescriptor instead')
const BilibiliLiveAreaPlaylistSource$json = {
  '1': 'BilibiliLiveAreaPlaylistSource',
  '2': [
    {'1': 'parent_area_id', '3': 1, '4': 1, '5': 4, '10': 'parentAreaId'},
    {'1': 'area_id', '3': 2, '4': 1, '5': 4, '10': 'areaId'},
  ],
};

/// Descriptor for `BilibiliLiveAreaPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliLiveAreaPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch5CaWxpYmlsaUxpdmVBcmVhUGxheWxpc3RTb3VyY2USJAoOcGFyZW50X2FyZWFfaWQYASABKA'
        'RSDHBhcmVudEFyZWFJZBIXCgdhcmVhX2lkGAIgASgEUgZhcmVhSWQ=');

@$core.Deprecated('Use bilibiliHistoryPlaylistSourceDescriptor instead')
const BilibiliHistoryPlaylistSource$json = {
  '1': 'BilibiliHistoryPlaylistSource',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.BilibiliHistoryType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `BilibiliHistoryPlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliHistoryPlaylistSourceDescriptor =
    $convert.base64Decode(
        'Ch1CaWxpYmlsaUhpc3RvcnlQbGF5bGlzdFNvdXJjZRI9CgR0eXBlGAEgASgOMikuc3luY3R2Ln'
        'NvdXJjZV9jb25maWcuQmlsaWJpbGlIaXN0b3J5VHlwZVIEdHlwZQ==');

@$core.Deprecated('Use bilibiliPgcTimelinePlaylistSourceDescriptor instead')
const BilibiliPgcTimelinePlaylistSource$json = {
  '1': 'BilibiliPgcTimelinePlaylistSource',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.BilibiliPgcTimelineType',
      '10': 'type'
    },
    {'1': 'before_days', '3': 2, '4': 1, '5': 13, '8': {}, '10': 'beforeDays'},
    {'1': 'after_days', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'afterDays'},
  ],
};

/// Descriptor for `BilibiliPgcTimelinePlaylistSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliPgcTimelinePlaylistSourceDescriptor =
    $convert.base64Decode(
        'CiFCaWxpYmlsaVBnY1RpbWVsaW5lUGxheWxpc3RTb3VyY2USQQoEdHlwZRgBIAEoDjItLnN5bm'
        'N0di5zb3VyY2VfY29uZmlnLkJpbGliaWxpUGdjVGltZWxpbmVUeXBlUgR0eXBlEigKC2JlZm9y'
        'ZV9kYXlzGAIgASgNQge6SAQqAhgHUgpiZWZvcmVEYXlzEiYKCmFmdGVyX2RheXMYAyABKA1CB7'
        'pIBCoCGAdSCWFmdGVyRGF5cw==');

@$core.Deprecated('Use bilibiliPlaylistSourceConfigDescriptor instead')
const BilibiliPlaylistSourceConfig$json = {
  '1': 'BilibiliPlaylistSourceConfig',
  '2': [
    {
      '1': 'video_parts',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliVideoPartsPlaylistSource',
      '9': 0,
      '10': 'videoParts'
    },
    {
      '1': 'popular',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliPopularPlaylistSource',
      '9': 0,
      '10': 'popular'
    },
    {
      '1': 'recommended',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliRecommendedPlaylistSource',
      '9': 0,
      '10': 'recommended'
    },
    {
      '1': 'up_videos',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliUpVideosPlaylistSource',
      '9': 0,
      '10': 'upVideos'
    },
    {
      '1': 'favorite_videos',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliFavoriteVideosPlaylistSource',
      '9': 0,
      '10': 'favoriteVideos'
    },
    {
      '1': 'collection_videos',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliCollectionVideosPlaylistSource',
      '9': 0,
      '10': 'collectionVideos'
    },
    {
      '1': 'series_videos',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliSeriesVideosPlaylistSource',
      '9': 0,
      '10': 'seriesVideos'
    },
    {
      '1': 'watch_later',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliWatchLaterPlaylistSource',
      '9': 0,
      '10': 'watchLater'
    },
    {
      '1': 'pgc_season',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliPgcSeasonPlaylistSource',
      '9': 0,
      '10': 'pgcSeason'
    },
    {
      '1': 'live_recommended',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliLiveRecommendedPlaylistSource',
      '9': 0,
      '10': 'liveRecommended'
    },
    {
      '1': 'live_followed',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliLiveFollowedPlaylistSource',
      '9': 0,
      '10': 'liveFollowed'
    },
    {
      '1': 'live_area',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliLiveAreaPlaylistSource',
      '9': 0,
      '10': 'liveArea'
    },
    {
      '1': 'history',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliHistoryPlaylistSource',
      '9': 0,
      '10': 'history'
    },
    {
      '1': 'pgc_timeline',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliPgcTimelinePlaylistSource',
      '9': 0,
      '10': 'pgcTimeline'
    },
    {'1': 'shared', '3': 15, '4': 1, '5': 8, '10': 'shared'},
    {
      '1': 'proxy_mode',
      '3': 16,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `BilibiliPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChxCaWxpYmlsaVBsYXlsaXN0U291cmNlQ29uZmlnElkKC3ZpZGVvX3BhcnRzGAEgASgLMjYuc3'
    'luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlWaWRlb1BhcnRzUGxheWxpc3RTb3VyY2VIAFIK'
    'dmlkZW9QYXJ0cxJPCgdwb3B1bGFyGAIgASgLMjMuc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaW'
    'JpbGlQb3B1bGFyUGxheWxpc3RTb3VyY2VIAFIHcG9wdWxhchJbCgtyZWNvbW1lbmRlZBgDIAEo'
    'CzI3LnN5bmN0di5zb3VyY2VfY29uZmlnLkJpbGliaWxpUmVjb21tZW5kZWRQbGF5bGlzdFNvdX'
    'JjZUgAUgtyZWNvbW1lbmRlZBJTCgl1cF92aWRlb3MYBCABKAsyNC5zeW5jdHYuc291cmNlX2Nv'
    'bmZpZy5CaWxpYmlsaVVwVmlkZW9zUGxheWxpc3RTb3VyY2VIAFIIdXBWaWRlb3MSZQoPZmF2b3'
    'JpdGVfdmlkZW9zGAUgASgLMjouc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlGYXZvcml0'
    'ZVZpZGVvc1BsYXlsaXN0U291cmNlSABSDmZhdm9yaXRlVmlkZW9zEmsKEWNvbGxlY3Rpb25fdm'
    'lkZW9zGAYgASgLMjwuc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlDb2xsZWN0aW9uVmlk'
    'ZW9zUGxheWxpc3RTb3VyY2VIAFIQY29sbGVjdGlvblZpZGVvcxJfCg1zZXJpZXNfdmlkZW9zGA'
    'cgASgLMjguc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlTZXJpZXNWaWRlb3NQbGF5bGlz'
    'dFNvdXJjZUgAUgxzZXJpZXNWaWRlb3MSWQoLd2F0Y2hfbGF0ZXIYCCABKAsyNi5zeW5jdHYuc2'
    '91cmNlX2NvbmZpZy5CaWxpYmlsaVdhdGNoTGF0ZXJQbGF5bGlzdFNvdXJjZUgAUgp3YXRjaExh'
    'dGVyElYKCnBnY19zZWFzb24YCSABKAsyNS5zeW5jdHYuc291cmNlX2NvbmZpZy5CaWxpYmlsaV'
    'BnY1NlYXNvblBsYXlsaXN0U291cmNlSABSCXBnY1NlYXNvbhJoChBsaXZlX3JlY29tbWVuZGVk'
    'GAogASgLMjsuc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlMaXZlUmVjb21tZW5kZWRQbG'
    'F5bGlzdFNvdXJjZUgAUg9saXZlUmVjb21tZW5kZWQSXwoNbGl2ZV9mb2xsb3dlZBgLIAEoCzI4'
    'LnN5bmN0di5zb3VyY2VfY29uZmlnLkJpbGliaWxpTGl2ZUZvbGxvd2VkUGxheWxpc3RTb3VyY2'
    'VIAFIMbGl2ZUZvbGxvd2VkElMKCWxpdmVfYXJlYRgMIAEoCzI0LnN5bmN0di5zb3VyY2VfY29u'
    'ZmlnLkJpbGliaWxpTGl2ZUFyZWFQbGF5bGlzdFNvdXJjZUgAUghsaXZlQXJlYRJPCgdoaXN0b3'
    'J5GA0gASgLMjMuc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlIaXN0b3J5UGxheWxpc3RT'
    'b3VyY2VIAFIHaGlzdG9yeRJcCgxwZ2NfdGltZWxpbmUYDiABKAsyNy5zeW5jdHYuc291cmNlX2'
    'NvbmZpZy5CaWxpYmlsaVBnY1RpbWVsaW5lUGxheWxpc3RTb3VyY2VIAFILcGdjVGltZWxpbmUS'
    'FgoGc2hhcmVkGA8gASgIUgZzaGFyZWQSUAoKcHJveHlfbW9kZRgQIAEoDjInLnN5bmN0di5zb3'
    'VyY2VfY29uZmlnLlBsYXliYWNrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2RlQggKBnNv'
    'dXJjZQ==');

@$core.Deprecated('Use twitchLiveSourceConfigDescriptor instead')
const TwitchLiveSourceConfig$json = {
  '1': 'TwitchLiveSourceConfig',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `TwitchLiveSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchLiveSourceConfigDescriptor =
    $convert.base64Decode(
        'ChZUd2l0Y2hMaXZlU291cmNlQ29uZmlnEhgKB2NoYW5uZWwYASABKAlSB2NoYW5uZWwSFgoGc2'
        'hhcmVkGAIgASgIUgZzaGFyZWQ=');

@$core.Deprecated('Use twitchVideoSourceConfigDescriptor instead')
const TwitchVideoSourceConfig$json = {
  '1': 'TwitchVideoSourceConfig',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '10': 'videoId'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `TwitchVideoSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchVideoSourceConfigDescriptor =
    $convert.base64Decode(
        'ChdUd2l0Y2hWaWRlb1NvdXJjZUNvbmZpZxIZCgh2aWRlb19pZBgBIAEoCVIHdmlkZW9JZBIWCg'
        'ZzaGFyZWQYAiABKAhSBnNoYXJlZA==');

@$core.Deprecated('Use twitchClipSourceConfigDescriptor instead')
const TwitchClipSourceConfig$json = {
  '1': 'TwitchClipSourceConfig',
  '2': [
    {'1': 'slug', '3': 1, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `TwitchClipSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchClipSourceConfigDescriptor =
    $convert.base64Decode(
        'ChZUd2l0Y2hDbGlwU291cmNlQ29uZmlnEhIKBHNsdWcYASABKAlSBHNsdWcSFgoGc2hhcmVkGA'
        'IgASgIUgZzaGFyZWQ=');

@$core.Deprecated('Use twitchMediaSourceConfigDescriptor instead')
const TwitchMediaSourceConfig$json = {
  '1': 'TwitchMediaSourceConfig',
  '2': [
    {
      '1': 'live',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchLiveSourceConfig',
      '9': 0,
      '10': 'live'
    },
    {
      '1': 'video',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchVideoSourceConfig',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'clip',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchClipSourceConfig',
      '9': 0,
      '10': 'clip'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `TwitchMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChdUd2l0Y2hNZWRpYVNvdXJjZUNvbmZpZxJCCgRsaXZlGAEgASgLMiwuc3luY3R2LnNvdXJjZV'
    '9jb25maWcuVHdpdGNoTGl2ZVNvdXJjZUNvbmZpZ0gAUgRsaXZlEkUKBXZpZGVvGAIgASgLMi0u'
    'c3luY3R2LnNvdXJjZV9jb25maWcuVHdpdGNoVmlkZW9Tb3VyY2VDb25maWdIAFIFdmlkZW8SQg'
    'oEY2xpcBgDIAEoCzIsLnN5bmN0di5zb3VyY2VfY29uZmlnLlR3aXRjaENsaXBTb3VyY2VDb25m'
    'aWdIAFIEY2xpcEIICgZzb3VyY2U=');

@$core.Deprecated('Use twitchPlaylistSourceConfigDescriptor instead')
const TwitchPlaylistSourceConfig$json = {
  '1': 'TwitchPlaylistSourceConfig',
  '2': [
    {'1': 'shared', '3': 1, '4': 1, '5': 8, '10': 'shared'},
    {
      '1': 'channel',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchPlaylistSourceConfig.Channel',
      '9': 0,
      '10': 'channel'
    },
    {
      '1': 'followed_live',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchPlaylistSourceConfig.FollowedLive',
      '9': 0,
      '10': 'followedLive'
    },
    {
      '1': 'category_live',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchPlaylistSourceConfig.CategoryLive',
      '9': 0,
      '10': 'categoryLive'
    },
    {
      '1': 'search_live',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchPlaylistSourceConfig.SearchLive',
      '9': 0,
      '10': 'searchLive'
    },
  ],
  '3': [
    TwitchPlaylistSourceConfig_Channel$json,
    TwitchPlaylistSourceConfig_FollowedLive$json,
    TwitchPlaylistSourceConfig_CategoryLive$json,
    TwitchPlaylistSourceConfig_SearchLive$json
  ],
  '8': [
    {'1': 'source'},
  ],
};

@$core.Deprecated('Use twitchPlaylistSourceConfigDescriptor instead')
const TwitchPlaylistSourceConfig_Channel$json = {
  '1': 'Channel',
  '2': [
    {'1': 'channel', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'channel'},
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.TwitchPlaylistContent',
      '8': {},
      '10': 'content'
    },
  ],
};

@$core.Deprecated('Use twitchPlaylistSourceConfigDescriptor instead')
const TwitchPlaylistSourceConfig_FollowedLive$json = {
  '1': 'FollowedLive',
};

@$core.Deprecated('Use twitchPlaylistSourceConfigDescriptor instead')
const TwitchPlaylistSourceConfig_CategoryLive$json = {
  '1': 'CategoryLive',
  '2': [
    {'1': 'category_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'categoryId'},
    {'1': 'category_name', '3': 2, '4': 1, '5': 9, '10': 'categoryName'},
  ],
};

@$core.Deprecated('Use twitchPlaylistSourceConfigDescriptor instead')
const TwitchPlaylistSourceConfig_SearchLive$json = {
  '1': 'SearchLive',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'query'},
  ],
};

/// Descriptor for `TwitchPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChpUd2l0Y2hQbGF5bGlzdFNvdXJjZUNvbmZpZxIWCgZzaGFyZWQYASABKAhSBnNoYXJlZBJUCg'
    'djaGFubmVsGAIgASgLMjguc3luY3R2LnNvdXJjZV9jb25maWcuVHdpdGNoUGxheWxpc3RTb3Vy'
    'Y2VDb25maWcuQ2hhbm5lbEgAUgdjaGFubmVsEmQKDWZvbGxvd2VkX2xpdmUYAyABKAsyPS5zeW'
    '5jdHYuc291cmNlX2NvbmZpZy5Ud2l0Y2hQbGF5bGlzdFNvdXJjZUNvbmZpZy5Gb2xsb3dlZExp'
    'dmVIAFIMZm9sbG93ZWRMaXZlEmQKDWNhdGVnb3J5X2xpdmUYBCABKAsyPS5zeW5jdHYuc291cm'
    'NlX2NvbmZpZy5Ud2l0Y2hQbGF5bGlzdFNvdXJjZUNvbmZpZy5DYXRlZ29yeUxpdmVIAFIMY2F0'
    'ZWdvcnlMaXZlEl4KC3NlYXJjaF9saXZlGAUgASgLMjsuc3luY3R2LnNvdXJjZV9jb25maWcuVH'
    'dpdGNoUGxheWxpc3RTb3VyY2VDb25maWcuU2VhcmNoTGl2ZUgAUgpzZWFyY2hMaXZlGoEBCgdD'
    'aGFubmVsEiMKB2NoYW5uZWwYASABKAlCCbpIBnIEEAMYGVIHY2hhbm5lbBJRCgdjb250ZW50GA'
    'IgASgOMisuc3luY3R2LnNvdXJjZV9jb25maWcuVHdpdGNoUGxheWxpc3RDb250ZW50Qgq6SAeC'
    'AQQQASAAUgdjb250ZW50Gg4KDEZvbGxvd2VkTGl2ZRpdCgxDYXRlZ29yeUxpdmUSKAoLY2F0ZW'
    'dvcnlfaWQYASABKAlCB7pIBHICEAFSCmNhdGVnb3J5SWQSIwoNY2F0ZWdvcnlfbmFtZRgCIAEo'
    'CVIMY2F0ZWdvcnlOYW1lGisKClNlYXJjaExpdmUSHQoFcXVlcnkYASABKAlCB7pIBHICEAFSBX'
    'F1ZXJ5QggKBnNvdXJjZQ==');

@$core.Deprecated('Use youtubeMediaSourceConfigDescriptor instead')
const YoutubeMediaSourceConfig$json = {
  '1': 'YoutubeMediaSourceConfig',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'videoId'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `YoutubeMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List youtubeMediaSourceConfigDescriptor =
    $convert.base64Decode(
        'ChhZb3V0dWJlTWVkaWFTb3VyY2VDb25maWcSIwoIdmlkZW9faWQYASABKAlCCLpIBXIDmAELUg'
        'd2aWRlb0lkEhYKBnNoYXJlZBgCIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig$json = {
  '1': 'YoutubePlaylistSourceConfig',
  '2': [
    {'1': 'shared', '3': 1, '4': 1, '5': 8, '10': 'shared'},
    {
      '1': 'playlist',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig.Playlist',
      '9': 0,
      '10': 'playlist'
    },
    {
      '1': 'channel',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig.Channel',
      '9': 0,
      '10': 'channel'
    },
    {
      '1': 'search',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig.Search',
      '9': 0,
      '10': 'search'
    },
    {
      '1': 'subscriptions',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig.Subscriptions',
      '9': 0,
      '10': 'subscriptions'
    },
    {
      '1': 'liked_videos',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig.LikedVideos',
      '9': 0,
      '10': 'likedVideos'
    },
    {
      '1': 'watch_later',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig.WatchLater',
      '9': 0,
      '10': 'watchLater'
    },
  ],
  '3': [
    YoutubePlaylistSourceConfig_Playlist$json,
    YoutubePlaylistSourceConfig_Channel$json,
    YoutubePlaylistSourceConfig_Search$json,
    YoutubePlaylistSourceConfig_Subscriptions$json,
    YoutubePlaylistSourceConfig_LikedVideos$json,
    YoutubePlaylistSourceConfig_WatchLater$json
  ],
  '8': [
    {'1': 'source'},
  ],
};

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig_Playlist$json = {
  '1': 'Playlist',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
  ],
};

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig_Channel$json = {
  '1': 'Channel',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'channelId'},
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.YoutubeChannelContent',
      '8': {},
      '10': 'content'
    },
  ],
};

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig_Search$json = {
  '1': 'Search',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'query'},
  ],
};

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig_Subscriptions$json = {
  '1': 'Subscriptions',
};

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig_LikedVideos$json = {
  '1': 'LikedVideos',
};

@$core.Deprecated('Use youtubePlaylistSourceConfigDescriptor instead')
const YoutubePlaylistSourceConfig_WatchLater$json = {
  '1': 'WatchLater',
};

/// Descriptor for `YoutubePlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List youtubePlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChtZb3V0dWJlUGxheWxpc3RTb3VyY2VDb25maWcSFgoGc2hhcmVkGAEgASgIUgZzaGFyZWQSWA'
    'oIcGxheWxpc3QYAiABKAsyOi5zeW5jdHYuc291cmNlX2NvbmZpZy5Zb3V0dWJlUGxheWxpc3RT'
    'b3VyY2VDb25maWcuUGxheWxpc3RIAFIIcGxheWxpc3QSVQoHY2hhbm5lbBgDIAEoCzI5LnN5bm'
    'N0di5zb3VyY2VfY29uZmlnLllvdXR1YmVQbGF5bGlzdFNvdXJjZUNvbmZpZy5DaGFubmVsSABS'
    'B2NoYW5uZWwSUgoGc2VhcmNoGAQgASgLMjguc3luY3R2LnNvdXJjZV9jb25maWcuWW91dHViZV'
    'BsYXlsaXN0U291cmNlQ29uZmlnLlNlYXJjaEgAUgZzZWFyY2gSZwoNc3Vic2NyaXB0aW9ucxgF'
    'IAEoCzI/LnN5bmN0di5zb3VyY2VfY29uZmlnLllvdXR1YmVQbGF5bGlzdFNvdXJjZUNvbmZpZy'
    '5TdWJzY3JpcHRpb25zSABSDXN1YnNjcmlwdGlvbnMSYgoMbGlrZWRfdmlkZW9zGAYgASgLMj0u'
    'c3luY3R2LnNvdXJjZV9jb25maWcuWW91dHViZVBsYXlsaXN0U291cmNlQ29uZmlnLkxpa2VkVm'
    'lkZW9zSABSC2xpa2VkVmlkZW9zEl8KC3dhdGNoX2xhdGVyGAcgASgLMjwuc3luY3R2LnNvdXJj'
    'ZV9jb25maWcuWW91dHViZVBsYXlsaXN0U291cmNlQ29uZmlnLldhdGNoTGF0ZXJIAFIKd2F0Y2'
    'hMYXRlcho0CghQbGF5bGlzdBIoCgtwbGF5bGlzdF9pZBgBIAEoCUIHukgEcgIQAVIKcGxheWxp'
    'c3RJZBqCAQoHQ2hhbm5lbBImCgpjaGFubmVsX2lkGAEgASgJQge6SARyAhABUgljaGFubmVsSW'
    'QSTwoHY29udGVudBgCIAEoDjIrLnN5bmN0di5zb3VyY2VfY29uZmlnLllvdXR1YmVDaGFubmVs'
    'Q29udGVudEIIukgFggECEAFSB2NvbnRlbnQaJwoGU2VhcmNoEh0KBXF1ZXJ5GAEgASgJQge6SA'
    'RyAhABUgVxdWVyeRoPCg1TdWJzY3JpcHRpb25zGg0KC0xpa2VkVmlkZW9zGgwKCldhdGNoTGF0'
    'ZXJCCAoGc291cmNl');

@$core.Deprecated('Use huyaLiveSourceConfigDescriptor instead')
const HuyaLiveSourceConfig$json = {
  '1': 'HuyaLiveSourceConfig',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `HuyaLiveSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huyaLiveSourceConfigDescriptor =
    $convert.base64Decode(
        'ChRIdXlhTGl2ZVNvdXJjZUNvbmZpZxIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQ=');

@$core.Deprecated('Use huyaVideoSourceConfigDescriptor instead')
const HuyaVideoSourceConfig$json = {
  '1': 'HuyaVideoSourceConfig',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '10': 'videoId'},
  ],
};

/// Descriptor for `HuyaVideoSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huyaVideoSourceConfigDescriptor =
    $convert.base64Decode(
        'ChVIdXlhVmlkZW9Tb3VyY2VDb25maWcSGQoIdmlkZW9faWQYASABKAlSB3ZpZGVvSWQ=');

@$core.Deprecated('Use huyaMediaSourceConfigDescriptor instead')
const HuyaMediaSourceConfig$json = {
  '1': 'HuyaMediaSourceConfig',
  '2': [
    {
      '1': 'live',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.HuyaLiveSourceConfig',
      '9': 0,
      '10': 'live'
    },
    {
      '1': 'video',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.HuyaVideoSourceConfig',
      '9': 0,
      '10': 'video'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `HuyaMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huyaMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVIdXlhTWVkaWFTb3VyY2VDb25maWcSQAoEbGl2ZRgBIAEoCzIqLnN5bmN0di5zb3VyY2VfY2'
    '9uZmlnLkh1eWFMaXZlU291cmNlQ29uZmlnSABSBGxpdmUSQwoFdmlkZW8YAiABKAsyKy5zeW5j'
    'dHYuc291cmNlX2NvbmZpZy5IdXlhVmlkZW9Tb3VyY2VDb25maWdIAFIFdmlkZW9CCAoGc291cm'
    'Nl');

@$core.Deprecated('Use douyuMediaSourceConfigDescriptor instead')
const DouyuMediaSourceConfig$json = {
  '1': 'DouyuMediaSourceConfig',
  '2': [
    {'1': 'room', '3': 1, '4': 1, '5': 9, '10': 'room'},
  ],
};

/// Descriptor for `DouyuMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyuMediaSourceConfigDescriptor =
    $convert.base64Decode(
        'ChZEb3V5dU1lZGlhU291cmNlQ29uZmlnEhIKBHJvb20YASABKAlSBHJvb20=');

@$core.Deprecated('Use douyinVideoSourceConfigDescriptor instead')
const DouyinVideoSourceConfig$json = {
  '1': 'DouyinVideoSourceConfig',
  '2': [
    {'1': 'aweme_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'awemeId'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `DouyinVideoSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinVideoSourceConfigDescriptor =
    $convert.base64Decode(
        'ChdEb3V5aW5WaWRlb1NvdXJjZUNvbmZpZxIkCghhd2VtZV9pZBgBIAEoCUIJukgGcgQQARggUg'
        'dhd2VtZUlkEhYKBnNoYXJlZBgCIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use douyinLiveSourceConfigDescriptor instead')
const DouyinLiveSourceConfig$json = {
  '1': 'DouyinLiveSourceConfig',
  '2': [
    {'1': 'web_rid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'webRid'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `DouyinLiveSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinLiveSourceConfigDescriptor =
    $convert.base64Decode(
        'ChZEb3V5aW5MaXZlU291cmNlQ29uZmlnEiMKB3dlYl9yaWQYASABKAlCCrpIB3IFEAEYgAFSBn'
        'dlYlJpZBIWCgZzaGFyZWQYAiABKAhSBnNoYXJlZA==');

@$core.Deprecated('Use douyinMediaSourceConfigDescriptor instead')
const DouyinMediaSourceConfig$json = {
  '1': 'DouyinMediaSourceConfig',
  '2': [
    {
      '1': 'video',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DouyinVideoSourceConfig',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'live',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DouyinLiveSourceConfig',
      '9': 0,
      '10': 'live'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `DouyinMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChdEb3V5aW5NZWRpYVNvdXJjZUNvbmZpZxJFCgV2aWRlbxgBIAEoCzItLnN5bmN0di5zb3VyY2'
    'VfY29uZmlnLkRvdXlpblZpZGVvU291cmNlQ29uZmlnSABSBXZpZGVvEkIKBGxpdmUYAiABKAsy'
    'LC5zeW5jdHYuc291cmNlX2NvbmZpZy5Eb3V5aW5MaXZlU291cmNlQ29uZmlnSABSBGxpdmVCCA'
    'oGc291cmNl');

@$core.Deprecated('Use douyinPlaylistSourceConfigDescriptor instead')
const DouyinPlaylistSourceConfig$json = {
  '1': 'DouyinPlaylistSourceConfig',
  '2': [
    {'1': 'sec_uid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'secUid'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `DouyinPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'ChpEb3V5aW5QbGF5bGlzdFNvdXJjZUNvbmZpZxIjCgdzZWNfdWlkGAEgASgJQgq6SAdyBRABGI'
        'ACUgZzZWNVaWQSFgoGc2hhcmVkGAIgASgIUgZzaGFyZWQ=');

@$core.Deprecated('Use acFunVideoSourceConfigDescriptor instead')
const AcFunVideoSourceConfig$json = {
  '1': 'AcFunVideoSourceConfig',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '10': 'videoId'},
  ],
};

/// Descriptor for `AcFunVideoSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunVideoSourceConfigDescriptor =
    $convert.base64Decode(
        'ChZBY0Z1blZpZGVvU291cmNlQ29uZmlnEhkKCHZpZGVvX2lkGAEgASgJUgd2aWRlb0lk');

@$core.Deprecated('Use acFunBangumiSourceConfigDescriptor instead')
const AcFunBangumiSourceConfig$json = {
  '1': 'AcFunBangumiSourceConfig',
  '2': [
    {'1': 'bangumi_id', '3': 1, '4': 1, '5': 9, '10': 'bangumiId'},
    {
      '1': 'episode_query',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'episodeQuery',
      '17': true
    },
  ],
  '8': [
    {'1': '_episode_query'},
  ],
};

/// Descriptor for `AcFunBangumiSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunBangumiSourceConfigDescriptor = $convert.base64Decode(
    'ChhBY0Z1bkJhbmd1bWlTb3VyY2VDb25maWcSHQoKYmFuZ3VtaV9pZBgBIAEoCVIJYmFuZ3VtaU'
    'lkEigKDWVwaXNvZGVfcXVlcnkYAiABKAlIAFIMZXBpc29kZVF1ZXJ5iAEBQhAKDl9lcGlzb2Rl'
    'X3F1ZXJ5');

@$core.Deprecated('Use acFunLiveSourceConfigDescriptor instead')
const AcFunLiveSourceConfig$json = {
  '1': 'AcFunLiveSourceConfig',
  '2': [
    {'1': 'author_id', '3': 1, '4': 1, '5': 9, '10': 'authorId'},
  ],
};

/// Descriptor for `AcFunLiveSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunLiveSourceConfigDescriptor = $convert.base64Decode(
    'ChVBY0Z1bkxpdmVTb3VyY2VDb25maWcSGwoJYXV0aG9yX2lkGAEgASgJUghhdXRob3JJZA==');

@$core.Deprecated('Use acFunMediaSourceConfigDescriptor instead')
const AcFunMediaSourceConfig$json = {
  '1': 'AcFunMediaSourceConfig',
  '2': [
    {
      '1': 'video',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AcFunVideoSourceConfig',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'bangumi',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AcFunBangumiSourceConfig',
      '9': 0,
      '10': 'bangumi'
    },
    {
      '1': 'live',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AcFunLiveSourceConfig',
      '9': 0,
      '10': 'live'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `AcFunMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChZBY0Z1bk1lZGlhU291cmNlQ29uZmlnEkQKBXZpZGVvGAEgASgLMiwuc3luY3R2LnNvdXJjZV'
    '9jb25maWcuQWNGdW5WaWRlb1NvdXJjZUNvbmZpZ0gAUgV2aWRlbxJKCgdiYW5ndW1pGAIgASgL'
    'Mi4uc3luY3R2LnNvdXJjZV9jb25maWcuQWNGdW5CYW5ndW1pU291cmNlQ29uZmlnSABSB2Jhbm'
    'd1bWkSQQoEbGl2ZRgDIAEoCzIrLnN5bmN0di5zb3VyY2VfY29uZmlnLkFjRnVuTGl2ZVNvdXJj'
    'ZUNvbmZpZ0gAUgRsaXZlQggKBnNvdXJjZQ==');

@$core.Deprecated('Use cctvMediaSourceConfigDescriptor instead')
const CctvMediaSourceConfig$json = {
  '1': 'CctvMediaSourceConfig',
  '2': [
    {'1': 'resource', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'resource'},
  ],
};

/// Descriptor for `CctvMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cctvMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVDY3R2TWVkaWFTb3VyY2VDb25maWcSIwoIcmVzb3VyY2UYASABKAlCB7pIBHICEAFSCHJlc2'
    '91cmNl');

@$core.Deprecated('Use fnosFileSourceConfigDescriptor instead')
const FnosFileSourceConfig$json = {
  '1': 'FnosFileSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'path'},
  ],
};

/// Descriptor for `FnosFileSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosFileSourceConfigDescriptor =
    $convert.base64Decode(
        'ChRGbm9zRmlsZVNvdXJjZUNvbmZpZxIbCgRwYXRoGAEgASgJQge6SARyAhABUgRwYXRo');

@$core.Deprecated('Use fnosLibraryItemSourceConfigDescriptor instead')
const FnosLibraryItemSourceConfig$json = {
  '1': 'FnosLibraryItemSourceConfig',
  '2': [
    {'1': 'item_guid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'itemGuid'},
    {
      '1': 'media_guid',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'mediaGuid',
      '17': true
    },
  ],
  '8': [
    {'1': '_media_guid'},
  ],
};

/// Descriptor for `FnosLibraryItemSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosLibraryItemSourceConfigDescriptor =
    $convert.base64Decode(
        'ChtGbm9zTGlicmFyeUl0ZW1Tb3VyY2VDb25maWcSJAoJaXRlbV9ndWlkGAEgASgJQge6SARyAh'
        'ABUghpdGVtR3VpZBIiCgptZWRpYV9ndWlkGAIgASgJSABSCW1lZGlhR3VpZIgBAUINCgtfbWVk'
        'aWFfZ3VpZA==');

@$core.Deprecated('Use fnosMediaSourceConfigDescriptor instead')
const FnosMediaSourceConfig$json = {
  '1': 'FnosMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'file',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosFileSourceConfig',
      '9': 0,
      '10': 'file'
    },
    {
      '1': 'library_item',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosLibraryItemSourceConfig',
      '9': 0,
      '10': 'libraryItem'
    },
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `FnosMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVGbm9zTWVkaWFTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZX'
    'J2ZXJJZBJACgRmaWxlGAIgASgLMiouc3luY3R2LnNvdXJjZV9jb25maWcuRm5vc0ZpbGVTb3Vy'
    'Y2VDb25maWdIAFIEZmlsZRJWCgxsaWJyYXJ5X2l0ZW0YAyABKAsyMS5zeW5jdHYuc291cmNlX2'
    'NvbmZpZy5Gbm9zTGlicmFyeUl0ZW1Tb3VyY2VDb25maWdIAFILbGlicmFyeUl0ZW0SUAoKcHJv'
    'eHlfbW9kZRgEIAEoDjInLnN5bmN0di5zb3VyY2VfY29uZmlnLlBsYXliYWNrUHJveHlNb2RlQg'
    'i6SAWCAQIQAVIJcHJveHlNb2RlQggKBnNvdXJjZQ==');

@$core.Deprecated('Use fnosFilesPlaylistSourceConfigDescriptor instead')
const FnosFilesPlaylistSourceConfig$json = {
  '1': 'FnosFilesPlaylistSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `FnosFilesPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosFilesPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'Ch1Gbm9zRmlsZXNQbGF5bGlzdFNvdXJjZUNvbmZpZxISCgRwYXRoGAEgASgJUgRwYXRo');

@$core.Deprecated('Use fnosMediaLibraryPlaylistSourceConfigDescriptor instead')
const FnosMediaLibraryPlaylistSourceConfig$json = {
  '1': 'FnosMediaLibraryPlaylistSourceConfig',
  '2': [
    {'1': 'library_guid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'libraryGuid'},
    {'1': 'media_types', '3': 2, '4': 3, '5': 9, '10': 'mediaTypes'},
    {
      '1': 'parent_guid',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'parentGuid',
      '17': true
    },
  ],
  '8': [
    {'1': '_parent_guid'},
  ],
};

/// Descriptor for `FnosMediaLibraryPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosMediaLibraryPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiRGbm9zTWVkaWFMaWJyYXJ5UGxheWxpc3RTb3VyY2VDb25maWcSKgoMbGlicmFyeV9ndWlkGA'
        'EgASgJQge6SARyAhABUgtsaWJyYXJ5R3VpZBIfCgttZWRpYV90eXBlcxgCIAMoCVIKbWVkaWFU'
        'eXBlcxIkCgtwYXJlbnRfZ3VpZBgDIAEoCUgAUgpwYXJlbnRHdWlkiAEBQg4KDF9wYXJlbnRfZ3'
        'VpZA==');

@$core.Deprecated('Use fnosFavoritesPlaylistSourceConfigDescriptor instead')
const FnosFavoritesPlaylistSourceConfig$json = {
  '1': 'FnosFavoritesPlaylistSourceConfig',
  '2': [
    {'1': 'media_types', '3': 1, '4': 3, '5': 9, '10': 'mediaTypes'},
  ],
};

/// Descriptor for `FnosFavoritesPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosFavoritesPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiFGbm9zRmF2b3JpdGVzUGxheWxpc3RTb3VyY2VDb25maWcSHwoLbWVkaWFfdHlwZXMYASADKA'
        'lSCm1lZGlhVHlwZXM=');

@$core.Deprecated('Use fnosHistoryPlaylistSourceConfigDescriptor instead')
const FnosHistoryPlaylistSourceConfig$json = {
  '1': 'FnosHistoryPlaylistSourceConfig',
};

/// Descriptor for `FnosHistoryPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosHistoryPlaylistSourceConfigDescriptor =
    $convert.base64Decode('Ch9Gbm9zSGlzdG9yeVBsYXlsaXN0U291cmNlQ29uZmln');

@$core.Deprecated('Use fnosPlaylistSourceConfigDescriptor instead')
const FnosPlaylistSourceConfig$json = {
  '1': 'FnosPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'files',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosFilesPlaylistSourceConfig',
      '9': 0,
      '10': 'files'
    },
    {
      '1': 'media_library',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosMediaLibraryPlaylistSourceConfig',
      '9': 0,
      '10': 'mediaLibrary'
    },
    {
      '1': 'favorites',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosFavoritesPlaylistSourceConfig',
      '9': 0,
      '10': 'favorites'
    },
    {
      '1': 'history',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosHistoryPlaylistSourceConfig',
      '9': 0,
      '10': 'history'
    },
    {
      '1': 'proxy_mode',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `FnosPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChhGbm9zUGxheWxpc3RTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUg'
    'hzZXJ2ZXJJZBJLCgVmaWxlcxgCIAEoCzIzLnN5bmN0di5zb3VyY2VfY29uZmlnLkZub3NGaWxl'
    'c1BsYXlsaXN0U291cmNlQ29uZmlnSABSBWZpbGVzEmEKDW1lZGlhX2xpYnJhcnkYAyABKAsyOi'
    '5zeW5jdHYuc291cmNlX2NvbmZpZy5Gbm9zTWVkaWFMaWJyYXJ5UGxheWxpc3RTb3VyY2VDb25m'
    'aWdIAFIMbWVkaWFMaWJyYXJ5ElcKCWZhdm9yaXRlcxgEIAEoCzI3LnN5bmN0di5zb3VyY2VfY2'
    '9uZmlnLkZub3NGYXZvcml0ZXNQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUglmYXZvcml0ZXMSUQoH'
    'aGlzdG9yeRgFIAEoCzI1LnN5bmN0di5zb3VyY2VfY29uZmlnLkZub3NIaXN0b3J5UGxheWxpc3'
    'RTb3VyY2VDb25maWdIAFIHaGlzdG9yeRJQCgpwcm94eV9tb2RlGAYgASgOMicuc3luY3R2LnNv'
    'dXJjZV9jb25maWcuUGxheWJhY2tQcm94eU1vZGVCCLpIBYIBAhABUglwcm94eU1vZGVCCAoGc2'
    '91cmNl');

@$core.Deprecated('Use qnapMediaSourceConfigDescriptor instead')
const QnapMediaSourceConfig$json = {
  '1': 'QnapMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `QnapMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVRbmFwTWVkaWFTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZX'
    'J2ZXJJZBIbCgRwYXRoGAIgASgJQge6SARyAhABUgRwYXRoElAKCnByb3h5X21vZGUYAyABKA4y'
    'Jy5zeW5jdHYuc291cmNlX2NvbmZpZy5QbGF5YmFja1Byb3h5TW9kZUIIukgFggECEAFSCXByb3'
    'h5TW9kZQ==');

@$core.Deprecated('Use qnapPlaylistSourceConfigDescriptor instead')
const QnapPlaylistSourceConfig$json = {
  '1': 'QnapPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `QnapPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChhRbmFwUGxheWxpc3RTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUg'
    'hzZXJ2ZXJJZBISCgRwYXRoGAIgASgJUgRwYXRoElAKCnByb3h5X21vZGUYAyABKA4yJy5zeW5j'
    'dHYuc291cmNlX2NvbmZpZy5QbGF5YmFja1Byb3h5TW9kZUIIukgFggECEAFSCXByb3h5TW9kZQ'
    '==');

@$core.Deprecated('Use synologyFileSourceConfigDescriptor instead')
const SynologyFileSourceConfig$json = {
  '1': 'SynologyFileSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'path'},
  ],
};

/// Descriptor for `SynologyFileSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyFileSourceConfigDescriptor =
    $convert.base64Decode(
        'ChhTeW5vbG9neUZpbGVTb3VyY2VDb25maWcSGwoEcGF0aBgBIAEoCUIHukgEcgIQAVIEcGF0aA'
        '==');

@$core.Deprecated('Use synologyLibraryItemSourceConfigDescriptor instead')
const SynologyLibraryItemSourceConfig$json = {
  '1': 'SynologyLibraryItemSourceConfig',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.SynologyLibraryItemKind',
      '8': {},
      '10': 'kind'
    },
    {'1': 'item_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'itemId'},
    {'1': 'file_id', '3': 3, '4': 1, '5': 3, '8': {}, '10': 'fileId'},
  ],
};

/// Descriptor for `SynologyLibraryItemSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyLibraryItemSourceConfigDescriptor =
    $convert.base64Decode(
        'Ch9TeW5vbG9neUxpYnJhcnlJdGVtU291cmNlQ29uZmlnEk0KBGtpbmQYASABKA4yLS5zeW5jdH'
        'Yuc291cmNlX2NvbmZpZy5TeW5vbG9neUxpYnJhcnlJdGVtS2luZEIKukgHggEEEAEgAFIEa2lu'
        'ZBIgCgdpdGVtX2lkGAIgASgDQge6SAQiAiAAUgZpdGVtSWQSIAoHZmlsZV9pZBgDIAEoA0IHuk'
        'gEIgIgAFIGZmlsZUlk');

@$core.Deprecated('Use synologyMediaSourceConfigDescriptor instead')
const SynologyMediaSourceConfig$json = {
  '1': 'SynologyMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'file',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyFileSourceConfig',
      '9': 0,
      '10': 'file'
    },
    {
      '1': 'library_item',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyLibraryItemSourceConfig',
      '9': 0,
      '10': 'libraryItem'
    },
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `SynologyMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChlTeW5vbG9neU1lZGlhU291cmNlQ29uZmlnEiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAV'
    'IIc2VydmVySWQSRAoEZmlsZRgCIAEoCzIuLnN5bmN0di5zb3VyY2VfY29uZmlnLlN5bm9sb2d5'
    'RmlsZVNvdXJjZUNvbmZpZ0gAUgRmaWxlEloKDGxpYnJhcnlfaXRlbRgDIAEoCzI1LnN5bmN0di'
    '5zb3VyY2VfY29uZmlnLlN5bm9sb2d5TGlicmFyeUl0ZW1Tb3VyY2VDb25maWdIAFILbGlicmFy'
    'eUl0ZW0SUAoKcHJveHlfbW9kZRgEIAEoDjInLnN5bmN0di5zb3VyY2VfY29uZmlnLlBsYXliYW'
    'NrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2RlQggKBnNvdXJjZQ==');

@$core.Deprecated('Use synologyFilesPlaylistSourceConfigDescriptor instead')
const SynologyFilesPlaylistSourceConfig$json = {
  '1': 'SynologyFilesPlaylistSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `SynologyFilesPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyFilesPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiFTeW5vbG9neUZpbGVzUGxheWxpc3RTb3VyY2VDb25maWcSEgoEcGF0aBgBIAEoCVIEcGF0aA'
        '==');

@$core.Deprecated('Use synologyMoviesPlaylistSourceConfigDescriptor instead')
const SynologyMoviesPlaylistSourceConfig$json = {
  '1': 'SynologyMoviesPlaylistSourceConfig',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
  ],
};

/// Descriptor for `SynologyMoviesPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyMoviesPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiJTeW5vbG9neU1vdmllc1BsYXlsaXN0U291cmNlQ29uZmlnEiYKCmxpYnJhcnlfaWQYASABKA'
        'NCB7pIBCICKABSCWxpYnJhcnlJZA==');

@$core.Deprecated('Use synologyTvShowsPlaylistSourceConfigDescriptor instead')
const SynologyTvShowsPlaylistSourceConfig$json = {
  '1': 'SynologyTvShowsPlaylistSourceConfig',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
  ],
};

/// Descriptor for `SynologyTvShowsPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyTvShowsPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiNTeW5vbG9neVR2U2hvd3NQbGF5bGlzdFNvdXJjZUNvbmZpZxImCgpsaWJyYXJ5X2lkGAEgAS'
        'gDQge6SAQiAigAUglsaWJyYXJ5SWQ=');

@$core.Deprecated('Use synologyEpisodesPlaylistSourceConfigDescriptor instead')
const SynologyEpisodesPlaylistSourceConfig$json = {
  '1': 'SynologyEpisodesPlaylistSourceConfig',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
    {'1': 'tv_show_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'tvShowId'},
  ],
};

/// Descriptor for `SynologyEpisodesPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyEpisodesPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiRTeW5vbG9neUVwaXNvZGVzUGxheWxpc3RTb3VyY2VDb25maWcSJgoKbGlicmFyeV9pZBgBIA'
        'EoA0IHukgEIgIoAFIJbGlicmFyeUlkEiUKCnR2X3Nob3dfaWQYAiABKANCB7pIBCICIABSCHR2'
        'U2hvd0lk');

@$core
    .Deprecated('Use synologyHomeVideosPlaylistSourceConfigDescriptor instead')
const SynologyHomeVideosPlaylistSourceConfig$json = {
  '1': 'SynologyHomeVideosPlaylistSourceConfig',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
  ],
};

/// Descriptor for `SynologyHomeVideosPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyHomeVideosPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiZTeW5vbG9neUhvbWVWaWRlb3NQbGF5bGlzdFNvdXJjZUNvbmZpZxImCgpsaWJyYXJ5X2lkGA'
        'EgASgDQge6SAQiAigAUglsaWJyYXJ5SWQ=');

@$core.Deprecated(
    'Use synologyTvRecordingsPlaylistSourceConfigDescriptor instead')
const SynologyTvRecordingsPlaylistSourceConfig$json = {
  '1': 'SynologyTvRecordingsPlaylistSourceConfig',
  '2': [
    {'1': 'library_id', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
  ],
};

/// Descriptor for `SynologyTvRecordingsPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyTvRecordingsPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CihTeW5vbG9neVR2UmVjb3JkaW5nc1BsYXlsaXN0U291cmNlQ29uZmlnEiYKCmxpYnJhcnlfaW'
        'QYASABKANCB7pIBCICKABSCWxpYnJhcnlJZA==');

@$core.Deprecated('Use synologyPlaylistSourceConfigDescriptor instead')
const SynologyPlaylistSourceConfig$json = {
  '1': 'SynologyPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'files',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyFilesPlaylistSourceConfig',
      '9': 0,
      '10': 'files'
    },
    {
      '1': 'movies',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyMoviesPlaylistSourceConfig',
      '9': 0,
      '10': 'movies'
    },
    {
      '1': 'tv_shows',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyTvShowsPlaylistSourceConfig',
      '9': 0,
      '10': 'tvShows'
    },
    {
      '1': 'episodes',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyEpisodesPlaylistSourceConfig',
      '9': 0,
      '10': 'episodes'
    },
    {
      '1': 'home_videos',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyHomeVideosPlaylistSourceConfig',
      '9': 0,
      '10': 'homeVideos'
    },
    {
      '1': 'tv_recordings',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyTvRecordingsPlaylistSourceConfig',
      '9': 0,
      '10': 'tvRecordings'
    },
    {
      '1': 'proxy_mode',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `SynologyPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List synologyPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChxTeW5vbG9neVBsYXlsaXN0U291cmNlQ29uZmlnEiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcg'
    'IQAVIIc2VydmVySWQSTwoFZmlsZXMYAiABKAsyNy5zeW5jdHYuc291cmNlX2NvbmZpZy5TeW5v'
    'bG9neUZpbGVzUGxheWxpc3RTb3VyY2VDb25maWdIAFIFZmlsZXMSUgoGbW92aWVzGAMgASgLMj'
    'guc3luY3R2LnNvdXJjZV9jb25maWcuU3lub2xvZ3lNb3ZpZXNQbGF5bGlzdFNvdXJjZUNvbmZp'
    'Z0gAUgZtb3ZpZXMSVgoIdHZfc2hvd3MYBCABKAsyOS5zeW5jdHYuc291cmNlX2NvbmZpZy5TeW'
    '5vbG9neVR2U2hvd3NQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUgd0dlNob3dzElgKCGVwaXNvZGVz'
    'GAUgASgLMjouc3luY3R2LnNvdXJjZV9jb25maWcuU3lub2xvZ3lFcGlzb2Rlc1BsYXlsaXN0U2'
    '91cmNlQ29uZmlnSABSCGVwaXNvZGVzEl8KC2hvbWVfdmlkZW9zGAYgASgLMjwuc3luY3R2LnNv'
    'dXJjZV9jb25maWcuU3lub2xvZ3lIb21lVmlkZW9zUGxheWxpc3RTb3VyY2VDb25maWdIAFIKaG'
    '9tZVZpZGVvcxJlCg10dl9yZWNvcmRpbmdzGAcgASgLMj4uc3luY3R2LnNvdXJjZV9jb25maWcu'
    'U3lub2xvZ3lUdlJlY29yZGluZ3NQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUgx0dlJlY29yZGluZ3'
    'MSUAoKcHJveHlfbW9kZRgIIAEoDjInLnN5bmN0di5zb3VyY2VfY29uZmlnLlBsYXliYWNrUHJv'
    'eHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2RlQggKBnNvdXJjZQ==');

@$core.Deprecated('Use nextcloudMediaSourceConfigDescriptor instead')
const NextcloudMediaSourceConfig$json = {
  '1': 'NextcloudMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {'1': 'file_id', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'fileId'},
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `NextcloudMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChpOZXh0Y2xvdWRNZWRpYVNvdXJjZUNvbmZpZxIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEA'
    'FSCHNlcnZlcklkEhsKBHBhdGgYAiABKAlCB7pIBHICEAFSBHBhdGgSIAoHZmlsZV9pZBgDIAEo'
    'BEIHukgEMgIgAFIGZmlsZUlkElAKCnByb3h5X21vZGUYBCABKA4yJy5zeW5jdHYuc291cmNlX2'
    'NvbmZpZy5QbGF5YmFja1Byb3h5TW9kZUIIukgFggECEAFSCXByb3h5TW9kZQ==');

@$core.Deprecated('Use nextcloudFolderPlaylistSourceConfigDescriptor instead')
const NextcloudFolderPlaylistSourceConfig$json = {
  '1': 'NextcloudFolderPlaylistSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `NextcloudFolderPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudFolderPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiNOZXh0Y2xvdWRGb2xkZXJQbGF5bGlzdFNvdXJjZUNvbmZpZxISCgRwYXRoGAEgASgJUgRwYX'
        'Ro');

@$core
    .Deprecated('Use nextcloudFavoritesPlaylistSourceConfigDescriptor instead')
const NextcloudFavoritesPlaylistSourceConfig$json = {
  '1': 'NextcloudFavoritesPlaylistSourceConfig',
};

/// Descriptor for `NextcloudFavoritesPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudFavoritesPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiZOZXh0Y2xvdWRGYXZvcml0ZXNQbGF5bGlzdFNvdXJjZUNvbmZpZw==');

@$core.Deprecated('Use nextcloudSearchPlaylistSourceConfigDescriptor instead')
const NextcloudSearchPlaylistSourceConfig$json = {
  '1': 'NextcloudSearchPlaylistSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'query'},
  ],
};

/// Descriptor for `NextcloudSearchPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudSearchPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiNOZXh0Y2xvdWRTZWFyY2hQbGF5bGlzdFNvdXJjZUNvbmZpZxISCgRwYXRoGAEgASgJUgRwYX'
        'RoEh0KBXF1ZXJ5GAIgASgJQge6SARyAhADUgVxdWVyeQ==');

@$core.Deprecated('Use nextcloudPlaylistSourceConfigDescriptor instead')
const NextcloudPlaylistSourceConfig$json = {
  '1': 'NextcloudPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'folder',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.NextcloudFolderPlaylistSourceConfig',
      '9': 0,
      '10': 'folder'
    },
    {
      '1': 'favorites',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.NextcloudFavoritesPlaylistSourceConfig',
      '9': 0,
      '10': 'favorites'
    },
    {
      '1': 'search',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.NextcloudSearchPlaylistSourceConfig',
      '9': 0,
      '10': 'search'
    },
    {
      '1': 'proxy_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `NextcloudPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'Ch1OZXh0Y2xvdWRQbGF5bGlzdFNvdXJjZUNvbmZpZxIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBH'
    'ICEAFSCHNlcnZlcklkElMKBmZvbGRlchgCIAEoCzI5LnN5bmN0di5zb3VyY2VfY29uZmlnLk5l'
    'eHRjbG91ZEZvbGRlclBsYXlsaXN0U291cmNlQ29uZmlnSABSBmZvbGRlchJcCglmYXZvcml0ZX'
    'MYAyABKAsyPC5zeW5jdHYuc291cmNlX2NvbmZpZy5OZXh0Y2xvdWRGYXZvcml0ZXNQbGF5bGlz'
    'dFNvdXJjZUNvbmZpZ0gAUglmYXZvcml0ZXMSUwoGc2VhcmNoGAQgASgLMjkuc3luY3R2LnNvdX'
    'JjZV9jb25maWcuTmV4dGNsb3VkU2VhcmNoUGxheWxpc3RTb3VyY2VDb25maWdIAFIGc2VhcmNo'
    'ElAKCnByb3h5X21vZGUYBSABKA4yJy5zeW5jdHYuc291cmNlX2NvbmZpZy5QbGF5YmFja1Byb3'
    'h5TW9kZUIIukgFggECEAFSCXByb3h5TW9kZUIICgZzb3VyY2U=');

@$core.Deprecated('Use seafileMediaSourceConfigDescriptor instead')
const SeafileMediaSourceConfig$json = {
  '1': 'SeafileMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'repository_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'repositoryId'
    },
    {'1': 'path', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {'1': 'object_id', '3': 4, '4': 1, '5': 9, '10': 'objectId'},
    {'1': 'has_thumbnail', '3': 5, '4': 1, '5': 8, '10': 'hasThumbnail'},
    {
      '1': 'proxy_mode',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `SeafileMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChhTZWFmaWxlTWVkaWFTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUg'
    'hzZXJ2ZXJJZBIsCg1yZXBvc2l0b3J5X2lkGAIgASgJQge6SARyAhABUgxyZXBvc2l0b3J5SWQS'
    'GwoEcGF0aBgDIAEoCUIHukgEcgIQAVIEcGF0aBIbCglvYmplY3RfaWQYBCABKAlSCG9iamVjdE'
    'lkEiMKDWhhc190aHVtYm5haWwYBSABKAhSDGhhc1RodW1ibmFpbBJQCgpwcm94eV9tb2RlGAYg'
    'ASgOMicuc3luY3R2LnNvdXJjZV9jb25maWcuUGxheWJhY2tQcm94eU1vZGVCCLpIBYIBAhABUg'
    'lwcm94eU1vZGU=');

@$core.Deprecated('Use seafileFolderPlaylistSourceConfigDescriptor instead')
const SeafileFolderPlaylistSourceConfig$json = {
  '1': 'SeafileFolderPlaylistSourceConfig',
  '2': [
    {
      '1': 'repository_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'repositoryId'
    },
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `SeafileFolderPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileFolderPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiFTZWFmaWxlRm9sZGVyUGxheWxpc3RTb3VyY2VDb25maWcSLAoNcmVwb3NpdG9yeV9pZBgBIA'
        'EoCUIHukgEcgIQAVIMcmVwb3NpdG9yeUlkEhIKBHBhdGgYAiABKAlSBHBhdGg=');

@$core.Deprecated('Use seafileStarredPlaylistSourceConfigDescriptor instead')
const SeafileStarredPlaylistSourceConfig$json = {
  '1': 'SeafileStarredPlaylistSourceConfig',
};

/// Descriptor for `SeafileStarredPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileStarredPlaylistSourceConfigDescriptor =
    $convert.base64Decode('CiJTZWFmaWxlU3RhcnJlZFBsYXlsaXN0U291cmNlQ29uZmln');

@$core.Deprecated('Use seafileSearchPlaylistSourceConfigDescriptor instead')
const SeafileSearchPlaylistSourceConfig$json = {
  '1': 'SeafileSearchPlaylistSourceConfig',
  '2': [
    {
      '1': 'repository_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'repositoryId'
    },
    {'1': 'query', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'query'},
  ],
};

/// Descriptor for `SeafileSearchPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileSearchPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiFTZWFmaWxlU2VhcmNoUGxheWxpc3RTb3VyY2VDb25maWcSLAoNcmVwb3NpdG9yeV9pZBgBIA'
        'EoCUIHukgEcgIQAVIMcmVwb3NpdG9yeUlkEh0KBXF1ZXJ5GAIgASgJQge6SARyAhABUgVxdWVy'
        'eQ==');

@$core.Deprecated('Use seafilePlaylistSourceConfigDescriptor instead')
const SeafilePlaylistSourceConfig$json = {
  '1': 'SeafilePlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'folder',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SeafileFolderPlaylistSourceConfig',
      '9': 0,
      '10': 'folder'
    },
    {
      '1': 'starred',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SeafileStarredPlaylistSourceConfig',
      '9': 0,
      '10': 'starred'
    },
    {
      '1': 'search',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SeafileSearchPlaylistSourceConfig',
      '9': 0,
      '10': 'search'
    },
    {
      '1': 'proxy_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `SeafilePlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafilePlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChtTZWFmaWxlUGxheWxpc3RTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAh'
    'ABUghzZXJ2ZXJJZBJRCgZmb2xkZXIYAiABKAsyNy5zeW5jdHYuc291cmNlX2NvbmZpZy5TZWFm'
    'aWxlRm9sZGVyUGxheWxpc3RTb3VyY2VDb25maWdIAFIGZm9sZGVyElQKB3N0YXJyZWQYAyABKA'
    'syOC5zeW5jdHYuc291cmNlX2NvbmZpZy5TZWFmaWxlU3RhcnJlZFBsYXlsaXN0U291cmNlQ29u'
    'ZmlnSABSB3N0YXJyZWQSUQoGc2VhcmNoGAQgASgLMjcuc3luY3R2LnNvdXJjZV9jb25maWcuU2'
    'VhZmlsZVNlYXJjaFBsYXlsaXN0U291cmNlQ29uZmlnSABSBnNlYXJjaBJQCgpwcm94eV9tb2Rl'
    'GAUgASgOMicuc3luY3R2LnNvdXJjZV9jb25maWcuUGxheWJhY2tQcm94eU1vZGVCCLpIBYIBAh'
    'ABUglwcm94eU1vZGVCCAoGc291cmNl');

@$core.Deprecated('Use trueNasMediaSourceConfigDescriptor instead')
const TrueNasMediaSourceConfig$json = {
  '1': 'TrueNasMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {
      '1': 'proxy_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
};

/// Descriptor for `TrueNasMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trueNasMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChhUcnVlTmFzTWVkaWFTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUg'
    'hzZXJ2ZXJJZBIbCgRwYXRoGAIgASgJQge6SARyAhABUgRwYXRoElAKCnByb3h5X21vZGUYAyAB'
    'KA4yJy5zeW5jdHYuc291cmNlX2NvbmZpZy5QbGF5YmFja1Byb3h5TW9kZUIIukgFggECEAFSCX'
    'Byb3h5TW9kZQ==');

@$core.Deprecated('Use trueNasFolderPlaylistSourceConfigDescriptor instead')
const TrueNasFolderPlaylistSourceConfig$json = {
  '1': 'TrueNasFolderPlaylistSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `TrueNasFolderPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trueNasFolderPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiFUcnVlTmFzRm9sZGVyUGxheWxpc3RTb3VyY2VDb25maWcSEgoEcGF0aBgBIAEoCVIEcGF0aA'
        '==');

@$core.Deprecated('Use trueNasSearchPlaylistSourceConfigDescriptor instead')
const TrueNasSearchPlaylistSourceConfig$json = {
  '1': 'TrueNasSearchPlaylistSourceConfig',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'query'},
  ],
};

/// Descriptor for `TrueNasSearchPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trueNasSearchPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'CiFUcnVlTmFzU2VhcmNoUGxheWxpc3RTb3VyY2VDb25maWcSEgoEcGF0aBgBIAEoCVIEcGF0aB'
        'IdCgVxdWVyeRgCIAEoCUIHukgEcgIQAVIFcXVlcnk=');

@$core.Deprecated('Use trueNasPlaylistSourceConfigDescriptor instead')
const TrueNasPlaylistSourceConfig$json = {
  '1': 'TrueNasPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'folder',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TrueNasFolderPlaylistSourceConfig',
      '9': 0,
      '10': 'folder'
    },
    {
      '1': 'search',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TrueNasSearchPlaylistSourceConfig',
      '9': 0,
      '10': 'search'
    },
    {
      '1': 'proxy_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.PlaybackProxyMode',
      '8': {},
      '10': 'proxyMode'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `TrueNasPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trueNasPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChtUcnVlTmFzUGxheWxpc3RTb3VyY2VDb25maWcSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAh'
    'ABUghzZXJ2ZXJJZBJRCgZmb2xkZXIYAiABKAsyNy5zeW5jdHYuc291cmNlX2NvbmZpZy5UcnVl'
    'TmFzRm9sZGVyUGxheWxpc3RTb3VyY2VDb25maWdIAFIGZm9sZGVyElEKBnNlYXJjaBgDIAEoCz'
    'I3LnN5bmN0di5zb3VyY2VfY29uZmlnLlRydWVOYXNTZWFyY2hQbGF5bGlzdFNvdXJjZUNvbmZp'
    'Z0gAUgZzZWFyY2gSUAoKcHJveHlfbW9kZRgEIAEoDjInLnN5bmN0di5zb3VyY2VfY29uZmlnLl'
    'BsYXliYWNrUHJveHlNb2RlQgi6SAWCAQIQAVIJcHJveHlNb2RlQggKBnNvdXJjZQ==');

@$core.Deprecated('Use tikTokVideoSourceConfigDescriptor instead')
const TikTokVideoSourceConfig$json = {
  '1': 'TikTokVideoSourceConfig',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'videoId'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `TikTokVideoSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokVideoSourceConfigDescriptor =
    $convert.base64Decode(
        'ChdUaWtUb2tWaWRlb1NvdXJjZUNvbmZpZxIkCgh2aWRlb19pZBgBIAEoCUIJukgGcgQQARggUg'
        'd2aWRlb0lkEhYKBnNoYXJlZBgCIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use tikTokLiveSourceConfigDescriptor instead')
const TikTokLiveSourceConfig$json = {
  '1': 'TikTokLiveSourceConfig',
  '2': [
    {'1': 'unique_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'uniqueId'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `TikTokLiveSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokLiveSourceConfigDescriptor =
    $convert.base64Decode(
        'ChZUaWtUb2tMaXZlU291cmNlQ29uZmlnEiYKCXVuaXF1ZV9pZBgBIAEoCUIJukgGcgQQARhAUg'
        'h1bmlxdWVJZBIWCgZzaGFyZWQYAiABKAhSBnNoYXJlZA==');

@$core.Deprecated('Use tikTokMediaSourceConfigDescriptor instead')
const TikTokMediaSourceConfig$json = {
  '1': 'TikTokMediaSourceConfig',
  '2': [
    {
      '1': 'video',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TikTokVideoSourceConfig',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'live',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TikTokLiveSourceConfig',
      '9': 0,
      '10': 'live'
    },
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `TikTokMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChdUaWtUb2tNZWRpYVNvdXJjZUNvbmZpZxJFCgV2aWRlbxgBIAEoCzItLnN5bmN0di5zb3VyY2'
    'VfY29uZmlnLlRpa1Rva1ZpZGVvU291cmNlQ29uZmlnSABSBXZpZGVvEkIKBGxpdmUYAiABKAsy'
    'LC5zeW5jdHYuc291cmNlX2NvbmZpZy5UaWtUb2tMaXZlU291cmNlQ29uZmlnSABSBGxpdmVCCA'
    'oGc291cmNl');

@$core.Deprecated('Use tikTokPlaylistSourceConfigDescriptor instead')
const TikTokPlaylistSourceConfig$json = {
  '1': 'TikTokPlaylistSourceConfig',
  '2': [
    {'1': 'sec_uid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'secUid'},
    {'1': 'shared', '3': 2, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `TikTokPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'ChpUaWtUb2tQbGF5bGlzdFNvdXJjZUNvbmZpZxIjCgdzZWNfdWlkGAEgASgJQgq6SAdyBRABGI'
        'ACUgZzZWNVaWQSFgoGc2hhcmVkGAIgASgIUgZzaGFyZWQ=');

@$core.Deprecated('Use mediaSourceConfigDescriptor instead')
const MediaSourceConfig$json = {
  '1': 'MediaSourceConfig',
  '2': [
    {
      '1': 'direct_url',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DirectUrlMediaSourceConfig',
      '9': 0,
      '10': 'directUrl'
    },
    {
      '1': 'bilibili',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliMediaSourceConfig',
      '9': 0,
      '10': 'bilibili'
    },
    {
      '1': 'alist',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AlistMediaSourceConfig',
      '9': 0,
      '10': 'alist'
    },
    {
      '1': 'emby',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyMediaSourceConfig',
      '9': 0,
      '10': 'emby'
    },
    {
      '1': 'rtmp',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.RtmpMediaSourceConfig',
      '9': 0,
      '10': 'rtmp'
    },
    {
      '1': 'live_proxy',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.LiveProxyMediaSourceConfig',
      '9': 0,
      '10': 'liveProxy'
    },
    {
      '1': 'cloudreve',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.CloudreveMediaSourceConfig',
      '9': 0,
      '10': 'cloudreve'
    },
    {
      '1': 'twitch',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchMediaSourceConfig',
      '9': 0,
      '10': 'twitch'
    },
    {
      '1': 'huya',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.HuyaMediaSourceConfig',
      '9': 0,
      '10': 'huya'
    },
    {
      '1': 'douyu',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DouyuMediaSourceConfig',
      '9': 0,
      '10': 'douyu'
    },
    {
      '1': 'douyin',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DouyinMediaSourceConfig',
      '9': 0,
      '10': 'douyin'
    },
    {
      '1': 'ac_fun',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AcFunMediaSourceConfig',
      '9': 0,
      '10': 'acFun'
    },
    {
      '1': 'cctv',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.CctvMediaSourceConfig',
      '9': 0,
      '10': 'cctv'
    },
    {
      '1': 'fnos',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosMediaSourceConfig',
      '9': 0,
      '10': 'fnos'
    },
    {
      '1': 'qnap',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.QnapMediaSourceConfig',
      '9': 0,
      '10': 'qnap'
    },
    {
      '1': 'synology',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyMediaSourceConfig',
      '9': 0,
      '10': 'synology'
    },
    {
      '1': 'nextcloud',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.NextcloudMediaSourceConfig',
      '9': 0,
      '10': 'nextcloud'
    },
    {
      '1': 'seafile',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SeafileMediaSourceConfig',
      '9': 0,
      '10': 'seafile'
    },
    {
      '1': 'truenas',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TrueNasMediaSourceConfig',
      '9': 0,
      '10': 'truenas'
    },
    {
      '1': 'youtube',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubeMediaSourceConfig',
      '9': 0,
      '10': 'youtube'
    },
    {
      '1': 'tiktok',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TikTokMediaSourceConfig',
      '9': 0,
      '10': 'tiktok'
    },
  ],
  '8': [
    {'1': 'provider'},
  ],
};

/// Descriptor for `MediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaSourceConfigDescriptor = $convert.base64Decode(
    'ChFNZWRpYVNvdXJjZUNvbmZpZxJRCgpkaXJlY3RfdXJsGAEgASgLMjAuc3luY3R2LnNvdXJjZV'
    '9jb25maWcuRGlyZWN0VXJsTWVkaWFTb3VyY2VDb25maWdIAFIJZGlyZWN0VXJsEk0KCGJpbGli'
    'aWxpGAIgASgLMi8uc3luY3R2LnNvdXJjZV9jb25maWcuQmlsaWJpbGlNZWRpYVNvdXJjZUNvbm'
    'ZpZ0gAUghiaWxpYmlsaRJECgVhbGlzdBgDIAEoCzIsLnN5bmN0di5zb3VyY2VfY29uZmlnLkFs'
    'aXN0TWVkaWFTb3VyY2VDb25maWdIAFIFYWxpc3QSQQoEZW1ieRgEIAEoCzIrLnN5bmN0di5zb3'
    'VyY2VfY29uZmlnLkVtYnlNZWRpYVNvdXJjZUNvbmZpZ0gAUgRlbWJ5EkEKBHJ0bXAYBSABKAsy'
    'Ky5zeW5jdHYuc291cmNlX2NvbmZpZy5SdG1wTWVkaWFTb3VyY2VDb25maWdIAFIEcnRtcBJRCg'
    'psaXZlX3Byb3h5GAYgASgLMjAuc3luY3R2LnNvdXJjZV9jb25maWcuTGl2ZVByb3h5TWVkaWFT'
    'b3VyY2VDb25maWdIAFIJbGl2ZVByb3h5ElAKCWNsb3VkcmV2ZRgHIAEoCzIwLnN5bmN0di5zb3'
    'VyY2VfY29uZmlnLkNsb3VkcmV2ZU1lZGlhU291cmNlQ29uZmlnSABSCWNsb3VkcmV2ZRJHCgZ0'
    'd2l0Y2gYCCABKAsyLS5zeW5jdHYuc291cmNlX2NvbmZpZy5Ud2l0Y2hNZWRpYVNvdXJjZUNvbm'
    'ZpZ0gAUgZ0d2l0Y2gSQQoEaHV5YRgJIAEoCzIrLnN5bmN0di5zb3VyY2VfY29uZmlnLkh1eWFN'
    'ZWRpYVNvdXJjZUNvbmZpZ0gAUgRodXlhEkQKBWRvdXl1GAogASgLMiwuc3luY3R2LnNvdXJjZV'
    '9jb25maWcuRG91eXVNZWRpYVNvdXJjZUNvbmZpZ0gAUgVkb3V5dRJHCgZkb3V5aW4YCyABKAsy'
    'LS5zeW5jdHYuc291cmNlX2NvbmZpZy5Eb3V5aW5NZWRpYVNvdXJjZUNvbmZpZ0gAUgZkb3V5aW'
    '4SRQoGYWNfZnVuGAwgASgLMiwuc3luY3R2LnNvdXJjZV9jb25maWcuQWNGdW5NZWRpYVNvdXJj'
    'ZUNvbmZpZ0gAUgVhY0Z1bhJBCgRjY3R2GA0gASgLMisuc3luY3R2LnNvdXJjZV9jb25maWcuQ2'
    'N0dk1lZGlhU291cmNlQ29uZmlnSABSBGNjdHYSQQoEZm5vcxgOIAEoCzIrLnN5bmN0di5zb3Vy'
    'Y2VfY29uZmlnLkZub3NNZWRpYVNvdXJjZUNvbmZpZ0gAUgRmbm9zEkEKBHFuYXAYDyABKAsyKy'
    '5zeW5jdHYuc291cmNlX2NvbmZpZy5RbmFwTWVkaWFTb3VyY2VDb25maWdIAFIEcW5hcBJNCghz'
    'eW5vbG9neRgQIAEoCzIvLnN5bmN0di5zb3VyY2VfY29uZmlnLlN5bm9sb2d5TWVkaWFTb3VyY2'
    'VDb25maWdIAFIIc3lub2xvZ3kSUAoJbmV4dGNsb3VkGBEgASgLMjAuc3luY3R2LnNvdXJjZV9j'
    'b25maWcuTmV4dGNsb3VkTWVkaWFTb3VyY2VDb25maWdIAFIJbmV4dGNsb3VkEkoKB3NlYWZpbG'
    'UYEiABKAsyLi5zeW5jdHYuc291cmNlX2NvbmZpZy5TZWFmaWxlTWVkaWFTb3VyY2VDb25maWdI'
    'AFIHc2VhZmlsZRJKCgd0cnVlbmFzGBMgASgLMi4uc3luY3R2LnNvdXJjZV9jb25maWcuVHJ1ZU'
    '5hc01lZGlhU291cmNlQ29uZmlnSABSB3RydWVuYXMSSgoHeW91dHViZRgUIAEoCzIuLnN5bmN0'
    'di5zb3VyY2VfY29uZmlnLllvdXR1YmVNZWRpYVNvdXJjZUNvbmZpZ0gAUgd5b3V0dWJlEkcKBn'
    'Rpa3RvaxgVIAEoCzItLnN5bmN0di5zb3VyY2VfY29uZmlnLlRpa1Rva01lZGlhU291cmNlQ29u'
    'ZmlnSABSBnRpa3Rva0IKCghwcm92aWRlcg==');

@$core.Deprecated('Use playlistSourceConfigDescriptor instead')
const PlaylistSourceConfig$json = {
  '1': 'PlaylistSourceConfig',
  '2': [
    {
      '1': 'bilibili',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.BilibiliPlaylistSourceConfig',
      '9': 0,
      '10': 'bilibili'
    },
    {
      '1': 'alist',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AlistPlaylistSourceConfig',
      '9': 0,
      '10': 'alist'
    },
    {
      '1': 'emby',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyPlaylistSourceConfig',
      '9': 0,
      '10': 'emby'
    },
    {
      '1': 'cloudreve',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.CloudrevePlaylistSourceConfig',
      '9': 0,
      '10': 'cloudreve'
    },
    {
      '1': 'twitch',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TwitchPlaylistSourceConfig',
      '9': 0,
      '10': 'twitch'
    },
    {
      '1': 'douyin',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DouyinPlaylistSourceConfig',
      '9': 0,
      '10': 'douyin'
    },
    {
      '1': 'fnos',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.FnosPlaylistSourceConfig',
      '9': 0,
      '10': 'fnos'
    },
    {
      '1': 'qnap',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.QnapPlaylistSourceConfig',
      '9': 0,
      '10': 'qnap'
    },
    {
      '1': 'synology',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SynologyPlaylistSourceConfig',
      '9': 0,
      '10': 'synology'
    },
    {
      '1': 'nextcloud',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.NextcloudPlaylistSourceConfig',
      '9': 0,
      '10': 'nextcloud'
    },
    {
      '1': 'seafile',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.SeafilePlaylistSourceConfig',
      '9': 0,
      '10': 'seafile'
    },
    {
      '1': 'truenas',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TrueNasPlaylistSourceConfig',
      '9': 0,
      '10': 'truenas'
    },
    {
      '1': 'youtube',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubePlaylistSourceConfig',
      '9': 0,
      '10': 'youtube'
    },
    {
      '1': 'tiktok',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.TikTokPlaylistSourceConfig',
      '9': 0,
      '10': 'tiktok'
    },
  ],
  '8': [
    {'1': 'provider'},
  ],
};

/// Descriptor for `PlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistSourceConfigDescriptor = $convert.base64Decode(
    'ChRQbGF5bGlzdFNvdXJjZUNvbmZpZxJQCghiaWxpYmlsaRgCIAEoCzIyLnN5bmN0di5zb3VyY2'
    'VfY29uZmlnLkJpbGliaWxpUGxheWxpc3RTb3VyY2VDb25maWdIAFIIYmlsaWJpbGkSRwoFYWxp'
    'c3QYAyABKAsyLy5zeW5jdHYuc291cmNlX2NvbmZpZy5BbGlzdFBsYXlsaXN0U291cmNlQ29uZm'
    'lnSABSBWFsaXN0EkQKBGVtYnkYBCABKAsyLi5zeW5jdHYuc291cmNlX2NvbmZpZy5FbWJ5UGxh'
    'eWxpc3RTb3VyY2VDb25maWdIAFIEZW1ieRJTCgljbG91ZHJldmUYByABKAsyMy5zeW5jdHYuc2'
    '91cmNlX2NvbmZpZy5DbG91ZHJldmVQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUgljbG91ZHJldmUS'
    'SgoGdHdpdGNoGAggASgLMjAuc3luY3R2LnNvdXJjZV9jb25maWcuVHdpdGNoUGxheWxpc3RTb3'
    'VyY2VDb25maWdIAFIGdHdpdGNoEkoKBmRvdXlpbhgLIAEoCzIwLnN5bmN0di5zb3VyY2VfY29u'
    'ZmlnLkRvdXlpblBsYXlsaXN0U291cmNlQ29uZmlnSABSBmRvdXlpbhJECgRmbm9zGA4gASgLMi'
    '4uc3luY3R2LnNvdXJjZV9jb25maWcuRm5vc1BsYXlsaXN0U291cmNlQ29uZmlnSABSBGZub3MS'
    'RAoEcW5hcBgPIAEoCzIuLnN5bmN0di5zb3VyY2VfY29uZmlnLlFuYXBQbGF5bGlzdFNvdXJjZU'
    'NvbmZpZ0gAUgRxbmFwElAKCHN5bm9sb2d5GBAgASgLMjIuc3luY3R2LnNvdXJjZV9jb25maWcu'
    'U3lub2xvZ3lQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUghzeW5vbG9neRJTCgluZXh0Y2xvdWQYES'
    'ABKAsyMy5zeW5jdHYuc291cmNlX2NvbmZpZy5OZXh0Y2xvdWRQbGF5bGlzdFNvdXJjZUNvbmZp'
    'Z0gAUgluZXh0Y2xvdWQSTQoHc2VhZmlsZRgSIAEoCzIxLnN5bmN0di5zb3VyY2VfY29uZmlnLl'
    'NlYWZpbGVQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUgdzZWFmaWxlEk0KB3RydWVuYXMYEyABKAsy'
    'MS5zeW5jdHYuc291cmNlX2NvbmZpZy5UcnVlTmFzUGxheWxpc3RTb3VyY2VDb25maWdIAFIHdH'
    'J1ZW5hcxJNCgd5b3V0dWJlGBQgASgLMjEuc3luY3R2LnNvdXJjZV9jb25maWcuWW91dHViZVBs'
    'YXlsaXN0U291cmNlQ29uZmlnSABSB3lvdXR1YmUSSgoGdGlrdG9rGBUgASgLMjAuc3luY3R2Ln'
    'NvdXJjZV9jb25maWcuVGlrVG9rUGxheWxpc3RTb3VyY2VDb25maWdIAFIGdGlrdG9rQgoKCHBy'
    'b3ZpZGVy');
