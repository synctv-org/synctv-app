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

@$core.Deprecated('Use getAcFunSegmentRequestDescriptor instead')
const GetAcFunSegmentRequest$json = {
  '1': 'GetAcFunSegmentRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'target_url', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'targetUrl'},
    {'1': 'sig', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 6, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 7, '4': 1, '5': 9, '9': 0, '10': 'range', '17': true},
    {'1': 'head', '3': 8, '4': 1, '5': 8, '10': 'head'},
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetAcFunSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAcFunSegmentRequestDescriptor = $convert.base64Decode(
    'ChZHZXRBY0Z1blNlZ21lbnRSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJgoKdGFyZ2V0X3VybBgCIAEoCUIHukgEcgIQAVIJdGFyZ2V0VXJsEhkKA3NpZxgDIAEo'
    'CUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgFIAEoCU'
    'IHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABSBXJhbmdl'
    'iAEBEhIKBGhlYWQYCCABKAhSBGhlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use acFunSegmentResponseDescriptor instead')
const AcFunSegmentResponse$json = {
  '1': 'AcFunSegmentResponse',
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

/// Descriptor for `AcFunSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acFunSegmentResponseDescriptor = $convert.base64Decode(
    'ChRBY0Z1blNlZ21lbnRSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

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
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.acfun.GetAcFunSegmentRequest',
      '3': '.synctv.playback_provider.acfun.AcFunSegmentResponse',
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
  '.synctv.playback_provider.acfun.GetAcFunSegmentRequest':
      GetAcFunSegmentRequest$json,
  '.synctv.playback_provider.acfun.AcFunSegmentResponse':
      AcFunSegmentResponse$json,
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
    'LnBsYXliYWNrX3Byb3ZpZGVyLmFjZnVuLkFjRnVuUmVzb3VyY2VSZXNwb25zZTABEnwKCkdldF'
    'NlZ21lbnQSNi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYWNmdW4uR2V0QWNGdW5TZWdtZW50'
    'UmVxdWVzdBo0LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5hY2Z1bi5BY0Z1blNlZ21lbnRSZX'
    'Nwb25zZTABEogBCg5HZXREYW5tYWt1RmlsZRI6LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5h'
    'Y2Z1bi5HZXRBY0Z1bkRhbm1ha3VGaWxlUmVxdWVzdBo4LnN5bmN0di5wbGF5YmFja19wcm92aW'
    'Rlci5hY2Z1bi5BY0Z1bkRhbm1ha3VGaWxlUmVzcG9uc2UwARJ9CgxXYXRjaERhbm1ha3USOC5z'
    'eW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYWNmdW4uV2F0Y2hBY0Z1bkRhbm1ha3VSZXF1ZXN0Gj'
    'Euc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmFjZnVuLkFjRnVuRGFubWFrdUV2ZW50MAE=');
