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
  ],
};

/// Descriptor for `SourceProvider`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sourceProviderDescriptor = $convert.base64Decode(
    'Cg5Tb3VyY2VQcm92aWRlchIfChtTT1VSQ0VfUFJPVklERVJfVU5TUEVDSUZJRUQQABIeChpTT1'
    'VSQ0VfUFJPVklERVJfRElSRUNUX1VSTBABEhwKGFNPVVJDRV9QUk9WSURFUl9CSUxJQklMSRAC'
    'EhkKFVNPVVJDRV9QUk9WSURFUl9BTElTVBADEhgKFFNPVVJDRV9QUk9WSURFUl9FTUJZEAQSGA'
    'oUU09VUkNFX1BST1ZJREVSX1JUTVAQBRIeChpTT1VSQ0VfUFJPVklERVJfTElWRV9QUk9YWRAG'
    'Eh0KGVNPVVJDRV9QUk9WSURFUl9DTE9VRFJFVkUQBw==');

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
  ],
  '3': [DirectUrlMediaResourceConfig_HeadersEntry$json],
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
    '1hdBgEIAEoCVIGZm9ybWF0GjoKDEhlYWRlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2'
    'YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

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
  ],
  '3': [DirectUrlSubtitleSourceConfig_HeadersEntry$json],
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
    'cuSGVhZGVyc0VudHJ5UgdoZWFkZXJzEhYKBmZvcm1hdBgFIAEoCVIGZm9ybWF0GjoKDEhlYWRl'
    'cnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

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
  ],
  '3': [DirectUrlDanmakuSourceConfig_HeadersEntry$json],
  '8': [
    {'1': '_format'},
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
    '1hdBgEIAEoCUgAUgZmb3JtYXSIAQEaOgoMSGVhZGVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5'
    'EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFCCQoHX2Zvcm1hdA==');

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
      '1': 'is_live',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'isLive',
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
      '1': 'prefer_proxy',
      '3': 9,
      '4': 1,
      '5': 8,
      '9': 5,
      '10': 'preferProxy',
      '17': true
    },
  ],
  '8': [
    {'1': '_default_media_index'},
    {'1': '_default_subtitle_index'},
    {'1': '_default_danmaku_index'},
    {'1': '_is_live'},
    {'1': '_duration_seconds'},
    {'1': '_prefer_proxy'},
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
    'x0X2Rhbm1ha3VfaW5kZXgYBiABKA1IAlITZGVmYXVsdERhbm1ha3VJbmRleIgBARIcCgdpc19s'
    'aXZlGAcgASgISANSBmlzTGl2ZYgBARIuChBkdXJhdGlvbl9zZWNvbmRzGAggASgBSARSD2R1cm'
    'F0aW9uU2Vjb25kc4gBARImCgxwcmVmZXJfcHJveHkYCSABKAhIBVILcHJlZmVyUHJveHmIAQFC'
    'FgoUX2RlZmF1bHRfbWVkaWFfaW5kZXhCGQoXX2RlZmF1bHRfc3VidGl0bGVfaW5kZXhCGAoWX2'
    'RlZmF1bHRfZGFubWFrdV9pbmRleEIKCghfaXNfbGl2ZUITChFfZHVyYXRpb25fc2Vjb25kc0IP'
    'Cg1fcHJlZmVyX3Byb3h5');

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
  ],
  '8': [
    {'1': '_password'},
  ],
};

/// Descriptor for `AlistMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChZBbGlzdE1lZGlhU291cmNlQ29uZmlnEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSEg'
    'oEcGF0aBgCIAEoCVIEcGF0aBIfCghwYXNzd29yZBgDIAEoCUgAUghwYXNzd29yZIgBAUILCglf'
    'cGFzc3dvcmQ=');

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
  ],
  '8': [
    {'1': '_password'},
  ],
};

/// Descriptor for `AlistPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistPlaylistSourceConfigDescriptor = $convert.base64Decode(
    'ChlBbGlzdFBsYXlsaXN0U291cmNlQ29uZmlnEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySW'
    'QSEgoEcGF0aBgCIAEoCVIEcGF0aBIfCghwYXNzd29yZBgDIAEoCUgAUghwYXNzd29yZIgBAUIL'
    'CglfcGFzc3dvcmQ=');

@$core.Deprecated('Use cloudreveMediaSourceConfigDescriptor instead')
const CloudreveMediaSourceConfig$json = {
  '1': 'CloudreveMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `CloudreveMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudreveMediaSourceConfigDescriptor =
    $convert.base64Decode(
        'ChpDbG91ZHJldmVNZWRpYVNvdXJjZUNvbmZpZxIbCglzZXJ2ZXJfaWQYASABKAlSCHNlcnZlck'
        'lkEhIKBHBhdGgYAiABKAlSBHBhdGg=');

@$core.Deprecated('Use cloudrevePlaylistSourceConfigDescriptor instead')
const CloudrevePlaylistSourceConfig$json = {
  '1': 'CloudrevePlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `CloudrevePlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudrevePlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'Ch1DbG91ZHJldmVQbGF5bGlzdFNvdXJjZUNvbmZpZxIbCglzZXJ2ZXJfaWQYASABKAlSCHNlcn'
        'ZlcklkEhIKBHBhdGgYAiABKAlSBHBhdGg=');

@$core.Deprecated('Use embyMediaSourceConfigDescriptor instead')
const EmbyMediaSourceConfig$json = {
  '1': 'EmbyMediaSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `EmbyMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyMediaSourceConfigDescriptor = $convert.base64Decode(
    'ChVFbWJ5TWVkaWFTb3VyY2VDb25maWcSGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZBIXCg'
    'dpdGVtX2lkGAIgASgJUgZpdGVtSWQ=');

@$core.Deprecated('Use embyPlaylistSourceConfigDescriptor instead')
const EmbyPlaylistSourceConfig$json = {
  '1': 'EmbyPlaylistSourceConfig',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `EmbyPlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyPlaylistSourceConfigDescriptor =
    $convert.base64Decode(
        'ChhFbWJ5UGxheWxpc3RTb3VyY2VDb25maWcSGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZB'
        'IXCgdpdGVtX2lkGAIgASgJUgZpdGVtSWQ=');

@$core.Deprecated('Use rtmpMediaSourceConfigDescriptor instead')
const RtmpMediaSourceConfig$json = {
  '1': 'RtmpMediaSourceConfig',
};

/// Descriptor for `RtmpMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpMediaSourceConfigDescriptor =
    $convert.base64Decode('ChVSdG1wTWVkaWFTb3VyY2VDb25maWc=');

@$core.Deprecated('Use liveProxyMediaSourceConfigDescriptor instead')
const LiveProxyMediaSourceConfig$json = {
  '1': 'LiveProxyMediaSourceConfig',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `LiveProxyMediaSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveProxyMediaSourceConfigDescriptor =
    $convert.base64Decode(
        'ChpMaXZlUHJveHlNZWRpYVNvdXJjZUNvbmZpZxIQCgN1cmwYASABKAlSA3VybA==');

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
    'ZUNvbmZpZ0gAUgRsaXZlQggKBnNvdXJjZQ==');

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
    'VyY2VfY29uZmlnLkNsb3VkcmV2ZU1lZGlhU291cmNlQ29uZmlnSABSCWNsb3VkcmV2ZUIKCghw'
    'cm92aWRlcg==');

@$core.Deprecated('Use playlistSourceConfigDescriptor instead')
const PlaylistSourceConfig$json = {
  '1': 'PlaylistSourceConfig',
  '2': [
    {
      '1': 'alist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.AlistPlaylistSourceConfig',
      '9': 0,
      '10': 'alist'
    },
    {
      '1': 'emby',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.EmbyPlaylistSourceConfig',
      '9': 0,
      '10': 'emby'
    },
    {
      '1': 'cloudreve',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.CloudrevePlaylistSourceConfig',
      '9': 0,
      '10': 'cloudreve'
    },
  ],
  '8': [
    {'1': 'provider'},
  ],
};

/// Descriptor for `PlaylistSourceConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistSourceConfigDescriptor = $convert.base64Decode(
    'ChRQbGF5bGlzdFNvdXJjZUNvbmZpZxJHCgVhbGlzdBgBIAEoCzIvLnN5bmN0di5zb3VyY2VfY2'
    '9uZmlnLkFsaXN0UGxheWxpc3RTb3VyY2VDb25maWdIAFIFYWxpc3QSRAoEZW1ieRgCIAEoCzIu'
    'LnN5bmN0di5zb3VyY2VfY29uZmlnLkVtYnlQbGF5bGlzdFNvdXJjZUNvbmZpZ0gAUgRlbWJ5El'
    'MKCWNsb3VkcmV2ZRgDIAEoCzIzLnN5bmN0di5zb3VyY2VfY29uZmlnLkNsb3VkcmV2ZVBsYXls'
    'aXN0U291cmNlQ29uZmlnSABSCWNsb3VkcmV2ZUIKCghwcm92aWRlcg==');
