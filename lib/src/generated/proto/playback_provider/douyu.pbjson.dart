// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/douyu.proto.

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

@$core.Deprecated('Use getDouyuResourceRequestDescriptor instead')
const GetDouyuResourceRequest$json = {
  '1': 'GetDouyuResourceRequest',
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

/// Descriptor for `GetDouyuResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDouyuResourceRequestDescriptor = $convert.base64Decode(
    'ChdHZXREb3V5dVJlc291cmNlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSHwoLbWVkaWFfaW5k'
    'ZXgYAyABKA1SCm1lZGlhSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGA'
    'UgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAcg'
    'ASgDUgNleHASGQoFcmFuZ2UYCCABKAlIAFIFcmFuZ2WIAQESEgoEaGVhZBgJIAEoCFIEaGVhZE'
    'IICgZfcmFuZ2U=');

@$core.Deprecated('Use douyuResourceResponseDescriptor instead')
const DouyuResourceResponse$json = {
  '1': 'DouyuResourceResponse',
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

/// Descriptor for `DouyuResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyuResourceResponseDescriptor = $convert.base64Decode(
    'ChVEb3V5dVJlc291cmNlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getDouyuSegmentRequestDescriptor instead')
const GetDouyuSegmentRequest$json = {
  '1': 'GetDouyuSegmentRequest',
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

/// Descriptor for `GetDouyuSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDouyuSegmentRequestDescriptor = $convert.base64Decode(
    'ChZHZXREb3V5dVNlZ21lbnRSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJgoKdGFyZ2V0X3VybBgCIAEoCUIHukgEcgIQAVIJdGFyZ2V0VXJsEhkKA3NpZxgDIAEo'
    'CUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgFIAEoCU'
    'IHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABSBXJhbmdl'
    'iAEBEhIKBGhlYWQYCCABKAhSBGhlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use douyuSegmentResponseDescriptor instead')
const DouyuSegmentResponse$json = {
  '1': 'DouyuSegmentResponse',
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

/// Descriptor for `DouyuSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyuSegmentResponseDescriptor = $convert.base64Decode(
    'ChREb3V5dVNlZ21lbnRSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use watchDouyuDanmakuRequestDescriptor instead')
const WatchDouyuDanmakuRequest$json = {
  '1': 'WatchDouyuDanmakuRequest',
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

/// Descriptor for `WatchDouyuDanmakuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchDouyuDanmakuRequestDescriptor = $convert.base64Decode(
    'ChhXYXRjaERvdXl1RGFubWFrdVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEh8KC21lZGlhX2lu'
    'ZGV4GAMgASgNUgptZWRpYUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZB'
    'gFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgH'
    'IAEoA1IDZXhw');

@$core.Deprecated('Use douyuDanmakuEventDescriptor instead')
const DouyuDanmakuEvent$json = {
  '1': 'DouyuDanmakuEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 'color', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'color', '17': true},
    {'1': 'level', '3': 6, '4': 1, '5': 13, '9': 1, '10': 'level', '17': true},
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
    {'1': '_color'},
    {'1': '_level'},
    {'1': '_badge_name'},
    {'1': '_badge_level'},
    {'1': '_sent_at_ms'},
  ],
};

/// Descriptor for `DouyuDanmakuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyuDanmakuEventDescriptor = $convert.base64Decode(
    'ChFEb3V5dURhbm1ha3VFdmVudBIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdX'
    'NlcklkEhsKCXVzZXJfbmFtZRgDIAEoCVIIdXNlck5hbWUSEgoEdGV4dBgEIAEoCVIEdGV4dBIZ'
    'CgVjb2xvchgFIAEoCUgAUgVjb2xvcogBARIZCgVsZXZlbBgGIAEoDUgBUgVsZXZlbIgBARIiCg'
    'piYWRnZV9uYW1lGAcgASgJSAJSCWJhZGdlTmFtZYgBARIkCgtiYWRnZV9sZXZlbBgIIAEoDUgD'
    'UgpiYWRnZUxldmVsiAEBEiEKCnNlbnRfYXRfbXMYCSABKARIBFIIc2VudEF0TXOIAQFCCAoGX2'
    'NvbG9yQggKBl9sZXZlbEINCgtfYmFkZ2VfbmFtZUIOCgxfYmFkZ2VfbGV2ZWxCDQoLX3NlbnRf'
    'YXRfbXM=');

const $core.Map<$core.String, $core.dynamic>
    DouyuPlaybackProviderServiceBase$json = {
  '1': 'DouyuPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.douyu.GetDouyuResourceRequest',
      '3': '.synctv.playback_provider.douyu.DouyuResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.douyu.GetDouyuSegmentRequest',
      '3': '.synctv.playback_provider.douyu.DouyuSegmentResponse',
      '6': true
    },
    {
      '1': 'WatchDanmaku',
      '2': '.synctv.playback_provider.douyu.WatchDouyuDanmakuRequest',
      '3': '.synctv.playback_provider.douyu.DouyuDanmakuEvent',
      '6': true
    },
  ],
};

@$core.Deprecated('Use douyuPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DouyuPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.douyu.GetDouyuResourceRequest':
      GetDouyuResourceRequest$json,
  '.synctv.playback_provider.douyu.DouyuResourceResponse':
      DouyuResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.douyu.GetDouyuSegmentRequest':
      GetDouyuSegmentRequest$json,
  '.synctv.playback_provider.douyu.DouyuSegmentResponse':
      DouyuSegmentResponse$json,
  '.synctv.playback_provider.douyu.WatchDouyuDanmakuRequest':
      WatchDouyuDanmakuRequest$json,
  '.synctv.playback_provider.douyu.DouyuDanmakuEvent': DouyuDanmakuEvent$json,
};

/// Descriptor for `DouyuPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List douyuPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChxEb3V5dVBsYXliYWNrUHJvdmlkZXJTZXJ2aWNlEn8KC0dldFJlc291cmNlEjcuc3luY3R2Ln'
    'BsYXliYWNrX3Byb3ZpZGVyLmRvdXl1LkdldERvdXl1UmVzb3VyY2VSZXF1ZXN0GjUuc3luY3R2'
    'LnBsYXliYWNrX3Byb3ZpZGVyLmRvdXl1LkRvdXl1UmVzb3VyY2VSZXNwb25zZTABEnwKCkdldF'
    'NlZ21lbnQSNi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZG91eXUuR2V0RG91eXVTZWdtZW50'
    'UmVxdWVzdBo0LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kb3V5dS5Eb3V5dVNlZ21lbnRSZX'
    'Nwb25zZTABEn0KDFdhdGNoRGFubWFrdRI4LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kb3V5'
    'dS5XYXRjaERvdXl1RGFubWFrdVJlcXVlc3QaMS5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZG'
    '91eXUuRG91eXVEYW5tYWt1RXZlbnQwAQ==');
