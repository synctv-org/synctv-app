// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/huya.proto.

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

@$core.Deprecated('Use getHuyaResourceRequestDescriptor instead')
const GetHuyaResourceRequest$json = {
  '1': 'GetHuyaResourceRequest',
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

/// Descriptor for `GetHuyaResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHuyaResourceRequestDescriptor = $convert.base64Decode(
    'ChZHZXRIdXlhUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9pbmRl'
    'eBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBS'
    'ABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYByAB'
    'KANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZWFkQg'
    'gKBl9yYW5nZQ==');

@$core.Deprecated('Use huyaResourceResponseDescriptor instead')
const HuyaResourceResponse$json = {
  '1': 'HuyaResourceResponse',
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

/// Descriptor for `HuyaResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huyaResourceResponseDescriptor = $convert.base64Decode(
    'ChRIdXlhUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getHuyaSegmentRequestDescriptor instead')
const GetHuyaSegmentRequest$json = {
  '1': 'GetHuyaSegmentRequest',
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

/// Descriptor for `GetHuyaSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHuyaSegmentRequestDescriptor = $convert.base64Decode(
    'ChVHZXRIdXlhU2VnbWVudFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdmVyc2'
    'lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2lnGAMgASgJ'
    'Qge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAUgASgJQg'
    'e6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIFcmFuZ2WI'
    'AQESEgoEaGVhZBgIIAEoCFIEaGVhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use huyaSegmentResponseDescriptor instead')
const HuyaSegmentResponse$json = {
  '1': 'HuyaSegmentResponse',
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

/// Descriptor for `HuyaSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huyaSegmentResponseDescriptor = $convert.base64Decode(
    'ChNIdXlhU2VnbWVudFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYWNrX3'
    'Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use watchHuyaDanmakuRequestDescriptor instead')
const WatchHuyaDanmakuRequest$json = {
  '1': 'WatchHuyaDanmakuRequest',
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

/// Descriptor for `WatchHuyaDanmakuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchHuyaDanmakuRequestDescriptor = $convert.base64Decode(
    'ChdXYXRjaEh1eWFEYW5tYWt1UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSHwoLbWVkaWFfaW5k'
    'ZXgYAyABKA1SCm1lZGlhSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGA'
    'UgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAcg'
    'ASgDUgNleHA=');

@$core.Deprecated('Use huyaDanmakuEventDescriptor instead')
const HuyaDanmakuEvent$json = {
  '1': 'HuyaDanmakuEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 'color', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'color', '17': true},
    {
      '1': 'avatar_url',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'avatarUrl',
      '17': true
    },
    {
      '1': 'sent_at_ms',
      '3': 7,
      '4': 1,
      '5': 4,
      '9': 2,
      '10': 'sentAtMs',
      '17': true
    },
  ],
  '8': [
    {'1': '_color'},
    {'1': '_avatar_url'},
    {'1': '_sent_at_ms'},
  ],
};

/// Descriptor for `HuyaDanmakuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List huyaDanmakuEventDescriptor = $convert.base64Decode(
    'ChBIdXlhRGFubWFrdUV2ZW50Eg4KAmlkGAEgASgJUgJpZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2'
    'VySWQSGwoJdXNlcl9uYW1lGAMgASgJUgh1c2VyTmFtZRISCgR0ZXh0GAQgASgJUgR0ZXh0EhkK'
    'BWNvbG9yGAUgASgJSABSBWNvbG9yiAEBEiIKCmF2YXRhcl91cmwYBiABKAlIAVIJYXZhdGFyVX'
    'JsiAEBEiEKCnNlbnRfYXRfbXMYByABKARIAlIIc2VudEF0TXOIAQFCCAoGX2NvbG9yQg0KC19h'
    'dmF0YXJfdXJsQg0KC19zZW50X2F0X21z');

const $core.Map<$core.String, $core.dynamic>
    HuyaPlaybackProviderServiceBase$json = {
  '1': 'HuyaPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.huya.GetHuyaResourceRequest',
      '3': '.synctv.playback_provider.huya.HuyaResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.huya.GetHuyaSegmentRequest',
      '3': '.synctv.playback_provider.huya.HuyaSegmentResponse',
      '6': true
    },
    {
      '1': 'WatchDanmaku',
      '2': '.synctv.playback_provider.huya.WatchHuyaDanmakuRequest',
      '3': '.synctv.playback_provider.huya.HuyaDanmakuEvent',
      '6': true
    },
  ],
};

@$core.Deprecated('Use huyaPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    HuyaPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.huya.GetHuyaResourceRequest':
      GetHuyaResourceRequest$json,
  '.synctv.playback_provider.huya.HuyaResourceResponse':
      HuyaResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.huya.GetHuyaSegmentRequest':
      GetHuyaSegmentRequest$json,
  '.synctv.playback_provider.huya.HuyaSegmentResponse':
      HuyaSegmentResponse$json,
  '.synctv.playback_provider.huya.WatchHuyaDanmakuRequest':
      WatchHuyaDanmakuRequest$json,
  '.synctv.playback_provider.huya.HuyaDanmakuEvent': HuyaDanmakuEvent$json,
};

/// Descriptor for `HuyaPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List huyaPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChtIdXlhUGxheWJhY2tQcm92aWRlclNlcnZpY2USewoLR2V0UmVzb3VyY2USNS5zeW5jdHYucG'
    'xheWJhY2tfcHJvdmlkZXIuaHV5YS5HZXRIdXlhUmVzb3VyY2VSZXF1ZXN0GjMuc3luY3R2LnBs'
    'YXliYWNrX3Byb3ZpZGVyLmh1eWEuSHV5YVJlc291cmNlUmVzcG9uc2UwARJ4CgpHZXRTZWdtZW'
    '50EjQuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmh1eWEuR2V0SHV5YVNlZ21lbnRSZXF1ZXN0'
    'GjIuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmh1eWEuSHV5YVNlZ21lbnRSZXNwb25zZTABEn'
    'kKDFdhdGNoRGFubWFrdRI2LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5odXlhLldhdGNoSHV5'
    'YURhbm1ha3VSZXF1ZXN0Gi8uc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmh1eWEuSHV5YURhbm'
    '1ha3VFdmVudDAB');
