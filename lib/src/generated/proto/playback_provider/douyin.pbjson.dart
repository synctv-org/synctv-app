// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/douyin.proto.

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

@$core.Deprecated('Use douyinHlsResourceKindDescriptor instead')
const DouyinHlsResourceKind$json = {
  '1': 'DouyinHlsResourceKind',
  '2': [
    {'1': 'DOUYIN_HLS_RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DOUYIN_HLS_RESOURCE_KIND_MEDIA', '2': 1},
    {'1': 'DOUYIN_HLS_RESOURCE_KIND_MANIFEST', '2': 2},
  ],
};

/// Descriptor for `DouyinHlsResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List douyinHlsResourceKindDescriptor = $convert.base64Decode(
    'ChVEb3V5aW5IbHNSZXNvdXJjZUtpbmQSKAokRE9VWUlOX0hMU19SRVNPVVJDRV9LSU5EX1VOU1'
    'BFQ0lGSUVEEAASIgoeRE9VWUlOX0hMU19SRVNPVVJDRV9LSU5EX01FRElBEAESJQohRE9VWUlO'
    'X0hMU19SRVNPVVJDRV9LSU5EX01BTklGRVNUEAI=');

@$core.Deprecated('Use getDouyinResourceRequestDescriptor instead')
const GetDouyinResourceRequest$json = {
  '1': 'GetDouyinResourceRequest',
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

/// Descriptor for `GetDouyinResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDouyinResourceRequestDescriptor = $convert.base64Decode(
    'ChhHZXREb3V5aW5SZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEh8KC21lZGlhX2lu'
    'ZGV4GAMgASgNUgptZWRpYUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZB'
    'gFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgH'
    'IAEoA1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBGhlYW'
    'RCCAoGX3Jhbmdl');

@$core.Deprecated('Use douyinResourceResponseDescriptor instead')
const DouyinResourceResponse$json = {
  '1': 'DouyinResourceResponse',
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

/// Descriptor for `DouyinResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinResourceResponseDescriptor =
    $convert.base64Decode(
        'ChZEb3V5aW5SZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getDouyinHlsResourceRequestDescriptor instead')
const GetDouyinHlsResourceRequest$json = {
  '1': 'GetDouyinHlsResourceRequest',
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
      '6': '.synctv.playback_provider.douyin.DouyinHlsResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetDouyinHlsResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDouyinHlsResourceRequestDescriptor = $convert.base64Decode(
    'ChtHZXREb3V5aW5IbHNSZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAV'
    'IHdmVyc2lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2ln'
    'GAMgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGA'
    'UgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIF'
    'cmFuZ2WIAQESEgoEaGVhZBgIIAEoCFIEaGVhZBIkCgltb2RlX25hbWUYCSABKAlCB7pIBHICEA'
    'FSCG1vZGVOYW1lEh8KC21lZGlhX2luZGV4GAogASgNUgptZWRpYUluZGV4EmUKDXJlc291cmNl'
    'X2tpbmQYCyABKA4yNi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZG91eWluLkRvdXlpbkhsc1'
    'Jlc291cmNlS2luZEIIukgFggECEAFSDHJlc291cmNlS2luZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use douyinHlsResourceResponseDescriptor instead')
const DouyinHlsResourceResponse$json = {
  '1': 'DouyinHlsResourceResponse',
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

/// Descriptor for `DouyinHlsResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinHlsResourceResponseDescriptor =
    $convert.base64Decode(
        'ChlEb3V5aW5IbHNSZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYX'
        'liYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use watchDouyinDanmakuRequestDescriptor instead')
const WatchDouyinDanmakuRequest$json = {
  '1': 'WatchDouyinDanmakuRequest',
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

/// Descriptor for `WatchDouyinDanmakuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchDouyinDanmakuRequestDescriptor = $convert.base64Decode(
    'ChlXYXRjaERvdXlpbkRhbm1ha3VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9p'
    'bmRleBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cA==');

@$core.Deprecated('Use chatEventDescriptor instead')
const ChatEvent$json = {
  '1': 'ChatEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 'color', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'color', '17': true},
    {
      '1': 'sent_at_ms',
      '3': 6,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'sentAtMs',
      '17': true
    },
  ],
  '8': [
    {'1': '_color'},
    {'1': '_sent_at_ms'},
  ],
};

/// Descriptor for `ChatEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatEventDescriptor = $convert.base64Decode(
    'CglDaGF0RXZlbnQSDgoCaWQYASABKAlSAmlkEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZBIbCg'
    'l1c2VyX25hbWUYAyABKAlSCHVzZXJOYW1lEhIKBHRleHQYBCABKAlSBHRleHQSGQoFY29sb3IY'
    'BSABKAlIAFIFY29sb3KIAQESIQoKc2VudF9hdF9tcxgGIAEoBEgBUghzZW50QXRNc4gBAUIICg'
    'ZfY29sb3JCDQoLX3NlbnRfYXRfbXM=');

@$core.Deprecated('Use streamClosedEventDescriptor instead')
const StreamClosedEvent$json = {
  '1': 'StreamClosedEvent',
  '2': [
    {'1': 'action', '3': 1, '4': 1, '5': 4, '10': 'action'},
    {
      '1': 'message',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'message',
      '17': true
    },
  ],
  '8': [
    {'1': '_message'},
  ],
};

/// Descriptor for `StreamClosedEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamClosedEventDescriptor = $convert.base64Decode(
    'ChFTdHJlYW1DbG9zZWRFdmVudBIWCgZhY3Rpb24YASABKARSBmFjdGlvbhIdCgdtZXNzYWdlGA'
    'IgASgJSABSB21lc3NhZ2WIAQFCCgoIX21lc3NhZ2U=');

@$core.Deprecated('Use douyinDanmakuEventDescriptor instead')
const DouyinDanmakuEvent$json = {
  '1': 'DouyinDanmakuEvent',
  '2': [
    {
      '1': 'chat',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.douyin.ChatEvent',
      '9': 0,
      '10': 'chat'
    },
    {
      '1': 'stream_closed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.douyin.StreamClosedEvent',
      '9': 0,
      '10': 'streamClosed'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `DouyinDanmakuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List douyinDanmakuEventDescriptor = $convert.base64Decode(
    'ChJEb3V5aW5EYW5tYWt1RXZlbnQSQAoEY2hhdBgBIAEoCzIqLnN5bmN0di5wbGF5YmFja19wcm'
    '92aWRlci5kb3V5aW4uQ2hhdEV2ZW50SABSBGNoYXQSWQoNc3RyZWFtX2Nsb3NlZBgCIAEoCzIy'
    'LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kb3V5aW4uU3RyZWFtQ2xvc2VkRXZlbnRIAFIMc3'
    'RyZWFtQ2xvc2VkQgcKBWV2ZW50');

const $core.Map<$core.String, $core.dynamic>
    DouyinPlaybackProviderServiceBase$json = {
  '1': 'DouyinPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.douyin.GetDouyinResourceRequest',
      '3': '.synctv.playback_provider.douyin.DouyinResourceResponse',
      '6': true
    },
    {
      '1': 'GetHlsResource',
      '2': '.synctv.playback_provider.douyin.GetDouyinHlsResourceRequest',
      '3': '.synctv.playback_provider.douyin.DouyinHlsResourceResponse',
      '6': true
    },
    {
      '1': 'WatchDanmaku',
      '2': '.synctv.playback_provider.douyin.WatchDouyinDanmakuRequest',
      '3': '.synctv.playback_provider.douyin.DouyinDanmakuEvent',
      '6': true
    },
  ],
};

@$core.Deprecated('Use douyinPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DouyinPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.douyin.GetDouyinResourceRequest':
      GetDouyinResourceRequest$json,
  '.synctv.playback_provider.douyin.DouyinResourceResponse':
      DouyinResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.douyin.GetDouyinHlsResourceRequest':
      GetDouyinHlsResourceRequest$json,
  '.synctv.playback_provider.douyin.DouyinHlsResourceResponse':
      DouyinHlsResourceResponse$json,
  '.synctv.playback_provider.douyin.WatchDouyinDanmakuRequest':
      WatchDouyinDanmakuRequest$json,
  '.synctv.playback_provider.douyin.DouyinDanmakuEvent':
      DouyinDanmakuEvent$json,
  '.synctv.playback_provider.douyin.ChatEvent': ChatEvent$json,
  '.synctv.playback_provider.douyin.StreamClosedEvent': StreamClosedEvent$json,
};

/// Descriptor for `DouyinPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List douyinPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch1Eb3V5aW5QbGF5YmFja1Byb3ZpZGVyU2VydmljZRKDAQoLR2V0UmVzb3VyY2USOS5zeW5jdH'
    'YucGxheWJhY2tfcHJvdmlkZXIuZG91eWluLkdldERvdXlpblJlc291cmNlUmVxdWVzdBo3LnN5'
    'bmN0di5wbGF5YmFja19wcm92aWRlci5kb3V5aW4uRG91eWluUmVzb3VyY2VSZXNwb25zZTABEo'
    'wBCg5HZXRIbHNSZXNvdXJjZRI8LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kb3V5aW4uR2V0'
    'RG91eWluSGxzUmVzb3VyY2VSZXF1ZXN0Gjouc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmRvdX'
    'lpbi5Eb3V5aW5IbHNSZXNvdXJjZVJlc3BvbnNlMAESgQEKDFdhdGNoRGFubWFrdRI6LnN5bmN0'
    'di5wbGF5YmFja19wcm92aWRlci5kb3V5aW4uV2F0Y2hEb3V5aW5EYW5tYWt1UmVxdWVzdBozLn'
    'N5bmN0di5wbGF5YmFja19wcm92aWRlci5kb3V5aW4uRG91eWluRGFubWFrdUV2ZW50MAE=');
