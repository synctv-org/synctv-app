// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/acfun.proto.

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

import 'common.pbjson.dart' as $0;

@$core.Deprecated('Use acFunHlsResourceKindDescriptor instead')
const AcFunHlsResourceKind$json = {
  '1': 'AcFunHlsResourceKind',
  '2': [
    {'1': 'AC_FUN_HLS_RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'AC_FUN_HLS_RESOURCE_KIND_MEDIA', '2': 1},
    {'1': 'AC_FUN_HLS_RESOURCE_KIND_MANIFEST', '2': 2},
  ],
};

/// Descriptor for `AcFunHlsResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List acFunHlsResourceKindDescriptor = $convert.base64Decode(
    'ChRBY0Z1bkhsc1Jlc291cmNlS2luZBIoCiRBQ19GVU5fSExTX1JFU09VUkNFX0tJTkRfVU5TUE'
    'VDSUZJRUQQABIiCh5BQ19GVU5fSExTX1JFU09VUkNFX0tJTkRfTUVESUEQARIlCiFBQ19GVU5f'
    'SExTX1JFU09VUkNFX0tJTkRfTUFOSUZFU1QQAg==');

@$core.Deprecated('Use getAcFunResourceRequestDescriptor instead')
const GetAcFunResourceRequest$json = {
  '1': 'GetAcFunResourceRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 3, '4': 1, '5': 13, '10': 'mediaIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 8, '4': 1, '5': 9, '9': 0, '10': 'range', '17': true},
    {'1': 'head', '3': 9, '4': 1, '5': 8, '10': 'head'},
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetAcFunResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAcFunResourceRequestDescriptor = $convert.base64Decode(
    'ChdHZXRBY0Z1blJlc291cmNlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSHwoLbWVkaWFfaW5k'
    'ZXgYAyABKA1SCm1lZGlhSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGA'
    'UgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAcg'
    'ASgDUgNleHASGQoFcmFuZ2UYCCABKAlIAFIFcmFuZ2WIAQESEgoEaGVhZBgJIAEoCFIEaGVhZE'
    'IICgZfcmFuZ2U=');

@$core.Deprecated('Use acFunResourceResponseDescriptor instead')
const AcFunResourceResponse$json = {
  '1': 'AcFunResourceResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `AcFunResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunResourceResponseDescriptor = $convert.base64Decode(
    'ChVBY0Z1blJlc291cmNlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getAcFunHlsResourceRequestDescriptor instead')
const GetAcFunHlsResourceRequest$json = {
  '1': 'GetAcFunHlsResourceRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'target_url', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'targetUrl'},
    {'1': 'sig', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 6, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 7, '4': 1, '5': 9, '9': 0, '10': 'range', '17': true},
    {'1': 'head', '3': 8, '4': 1, '5': 8, '10': 'head'},
    {'1': 'mode_name', '3': 9, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 10, '4': 1, '5': 13, '10': 'mediaIndex'},
    {
      '1': 'resource_kind',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.synctv.playback_provider.acfun.AcFunHlsResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetAcFunHlsResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAcFunHlsResourceRequestDescriptor = $convert.base64Decode(
    'ChpHZXRBY0Z1bkhsc1Jlc291cmNlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUg'
    'd2ZXJzaW9uEiYKCnRhcmdldF91cmwYAiABKAlCB7pIBHICEAFSCXRhcmdldFVybBIZCgNzaWcY'
    'AyABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBCABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBS'
    'ABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYBiABKANSA2V4cBIZCgVyYW5nZRgHIAEoCUgAUgVy'
    'YW5nZYgBARISCgRoZWFkGAggASgIUgRoZWFkEiQKCW1vZGVfbmFtZRgJIAEoCUIHukgEcgIQAV'
    'IIbW9kZU5hbWUSHwoLbWVkaWFfaW5kZXgYCiABKA1SCm1lZGlhSW5kZXgSYwoNcmVzb3VyY2Vf'
    'a2luZBgLIAEoDjI0LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5hY2Z1bi5BY0Z1bkhsc1Jlc2'
    '91cmNlS2luZEIIukgFggECEAFSDHJlc291cmNlS2luZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use acFunHlsResourceResponseDescriptor instead')
const AcFunHlsResourceResponse$json = {
  '1': 'AcFunHlsResourceResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `AcFunHlsResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunHlsResourceResponseDescriptor =
    $convert.base64Decode(
        'ChhBY0Z1bkhsc1Jlc291cmNlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheW'
        'JhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getAcFunDanmakuFileRequestDescriptor instead')
const GetAcFunDanmakuFileRequest$json = {
  '1': 'GetAcFunDanmakuFileRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 3, '4': 1, '5': 13, '10': 'mediaIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'head', '3': 8, '4': 1, '5': 8, '10': 'head'},
  ],
};

/// Descriptor for `GetAcFunDanmakuFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAcFunDanmakuFileRequestDescriptor = $convert.base64Decode(
    'ChpHZXRBY0Z1bkRhbm1ha3VGaWxlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUg'
    'd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSHwoLbWVkaWFf'
    'aW5kZXgYAyABKA1SCm1lZGlhSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQoDdW'
    'lkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoDZXhw'
    'GAcgASgDUgNleHASEgoEaGVhZBgIIAEoCFIEaGVhZA==');

@$core.Deprecated('Use acFunDanmakuFileResponseDescriptor instead')
const AcFunDanmakuFileResponse$json = {
  '1': 'AcFunDanmakuFileResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `AcFunDanmakuFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunDanmakuFileResponseDescriptor =
    $convert.base64Decode(
        'ChhBY0Z1bkRhbm1ha3VGaWxlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheW'
        'JhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use watchAcFunDanmakuRequestDescriptor instead')
const WatchAcFunDanmakuRequest$json = {
  '1': 'WatchAcFunDanmakuRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 3, '4': 1, '5': 13, '10': 'mediaIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `WatchAcFunDanmakuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchAcFunDanmakuRequestDescriptor = $convert.base64Decode(
    'ChhXYXRjaEFjRnVuRGFubWFrdVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEh8KC21lZGlhX2lu'
    'ZGV4GAMgASgNUgptZWRpYUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZB'
    'gFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgH'
    'IAEoA1IDZXhw');

@$core.Deprecated('Use acFunDanmakuEventDescriptor instead')
const AcFunDanmakuEvent$json = {
  '1': 'AcFunDanmakuEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {
      '1': 'avatar_url',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'avatarUrl',
      '17': true
    },
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'color', '3': 6, '4': 1, '5': 9, '9': 1, '10': 'color', '17': true},
    {
      '1': 'badge_name',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'badgeName',
      '17': true
    },
    {
      '1': 'badge_level',
      '3': 8,
      '4': 1,
      '5': 13,
      '9': 3,
      '10': 'badgeLevel',
      '17': true
    },
    {
      '1': 'sent_at_ms',
      '3': 9,
      '4': 1,
      '5': 4,
      '9': 4,
      '10': 'sentAtMs',
      '17': true
    },
  ],
  '8': [
    {'1': '_avatar_url'},
    {'1': '_color'},
    {'1': '_badge_name'},
    {'1': '_badge_level'},
    {'1': '_sent_at_ms'},
  ],
};

/// Descriptor for `AcFunDanmakuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunDanmakuEventDescriptor = $convert.base64Decode(
    'ChFBY0Z1bkRhbm1ha3VFdmVudBIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdX'
    'NlcklkEhsKCXVzZXJfbmFtZRgDIAEoCVIIdXNlck5hbWUSIgoKYXZhdGFyX3VybBgEIAEoCUgA'
    'UglhdmF0YXJVcmyIAQESEgoEdGV4dBgFIAEoCVIEdGV4dBIZCgVjb2xvchgGIAEoCUgBUgVjb2'
    'xvcogBARIiCgpiYWRnZV9uYW1lGAcgASgJSAJSCWJhZGdlTmFtZYgBARIkCgtiYWRnZV9sZXZl'
    'bBgIIAEoDUgDUgpiYWRnZUxldmVsiAEBEiEKCnNlbnRfYXRfbXMYCSABKARIBFIIc2VudEF0TX'
    'OIAQFCDQoLX2F2YXRhcl91cmxCCAoGX2NvbG9yQg0KC19iYWRnZV9uYW1lQg4KDF9iYWRnZV9s'
    'ZXZlbEINCgtfc2VudF9hdF9tcw==');

const $core.Map<$core.String, $core.dynamic>
    AcFunPlaybackProviderServiceBase$json = {
  '1': 'AcFunPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.acfun.GetAcFunResourceRequest',
      '3': '.synctv.playback_provider.acfun.AcFunResourceResponse',
      '6': true
    },
    {
      '1': 'GetHlsResource',
      '2': '.synctv.playback_provider.acfun.GetAcFunHlsResourceRequest',
      '3': '.synctv.playback_provider.acfun.AcFunHlsResourceResponse',
      '6': true
    },
    {
      '1': 'GetDanmakuFile',
      '2': '.synctv.playback_provider.acfun.GetAcFunDanmakuFileRequest',
      '3': '.synctv.playback_provider.acfun.AcFunDanmakuFileResponse',
      '6': true
    },
    {
      '1': 'WatchDanmaku',
      '2': '.synctv.playback_provider.acfun.WatchAcFunDanmakuRequest',
      '3': '.synctv.playback_provider.acfun.AcFunDanmakuEvent',
      '6': true
    },
  ],
};

@$core.Deprecated('Use acFunPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AcFunPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.acfun.GetAcFunResourceRequest':
      GetAcFunResourceRequest$json,
  '.synctv.playback_provider.acfun.AcFunResourceResponse':
      AcFunResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.acfun.GetAcFunHlsResourceRequest':
      GetAcFunHlsResourceRequest$json,
  '.synctv.playback_provider.acfun.AcFunHlsResourceResponse':
      AcFunHlsResourceResponse$json,
  '.synctv.playback_provider.acfun.GetAcFunDanmakuFileRequest':
      GetAcFunDanmakuFileRequest$json,
  '.synctv.playback_provider.acfun.AcFunDanmakuFileResponse':
      AcFunDanmakuFileResponse$json,
  '.synctv.playback_provider.acfun.WatchAcFunDanmakuRequest':
      WatchAcFunDanmakuRequest$json,
  '.synctv.playback_provider.acfun.AcFunDanmakuEvent': AcFunDanmakuEvent$json,
};

/// Descriptor for `AcFunPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List acFunPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChxBY0Z1blBsYXliYWNrUHJvdmlkZXJTZXJ2aWNlEn8KC0dldFJlc291cmNlEjcuc3luY3R2Ln'
    'BsYXliYWNrX3Byb3ZpZGVyLmFjZnVuLkdldEFjRnVuUmVzb3VyY2VSZXF1ZXN0GjUuc3luY3R2'
    'LnBsYXliYWNrX3Byb3ZpZGVyLmFjZnVuLkFjRnVuUmVzb3VyY2VSZXNwb25zZTABEogBCg5HZX'
    'RIbHNSZXNvdXJjZRI6LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5hY2Z1bi5HZXRBY0Z1bkhs'
    'c1Jlc291cmNlUmVxdWVzdBo4LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5hY2Z1bi5BY0Z1bk'
    'hsc1Jlc291cmNlUmVzcG9uc2UwARKIAQoOR2V0RGFubWFrdUZpbGUSOi5zeW5jdHYucGxheWJh'
    'Y2tfcHJvdmlkZXIuYWNmdW4uR2V0QWNGdW5EYW5tYWt1RmlsZVJlcXVlc3QaOC5zeW5jdHYucG'
    'xheWJhY2tfcHJvdmlkZXIuYWNmdW4uQWNGdW5EYW5tYWt1RmlsZVJlc3BvbnNlMAESfQoMV2F0'
    'Y2hEYW5tYWt1Ejguc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmFjZnVuLldhdGNoQWNGdW5EYW'
    '5tYWt1UmVxdWVzdBoxLnN5bmN0di5wbGF5YmFja19wcm92aWRlci5hY2Z1bi5BY0Z1bkRhbm1h'
    'a3VFdmVudDAB');
