// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/live_proxy.proto.

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

@$core.Deprecated('Use getLiveProxyFlvStreamRequestDescriptor instead')
const GetLiveProxyFlvStreamRequest$json = {
  '1': 'GetLiveProxyFlvStreamRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'head', '3': 6, '4': 1, '5': 8, '10': 'head'},
  ],
};

/// Descriptor for `GetLiveProxyFlvStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLiveProxyFlvStreamRequestDescriptor = $convert.base64Decode(
    'ChxHZXRMaXZlUHJveHlGbHZTdHJlYW1SZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEA'
    'FSB3ZlcnNpb24SGQoDc2lnGAIgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAMgASgJQge6SARy'
    'AhABUgN1aWQSGQoDcmlkGAQgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAUgASgDUgNleHASEg'
    'oEaGVhZBgGIAEoCFIEaGVhZA==');

@$core.Deprecated('Use liveProxyFlvStreamResponseDescriptor instead')
const LiveProxyFlvStreamResponse$json = {
  '1': 'LiveProxyFlvStreamResponse',
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

/// Descriptor for `LiveProxyFlvStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveProxyFlvStreamResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXZlUHJveHlGbHZTdHJlYW1SZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbG'
        'F5YmFja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getLiveProxyHlsPlaylistRequestDescriptor instead')
const GetLiveProxyHlsPlaylistRequest$json = {
  '1': 'GetLiveProxyHlsPlaylistRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetLiveProxyHlsPlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLiveProxyHlsPlaylistRequestDescriptor =
    $convert.base64Decode(
        'Ch5HZXRMaXZlUHJveHlIbHNQbGF5bGlzdFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcg'
        'IQAVIHdmVyc2lvbhIZCgNzaWcYAiABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYAyABKAlCB7pI'
        'BHICEAFSA3VpZBIZCgNyaWQYBCABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYBSABKANSA2V4cA'
        '==');

@$core.Deprecated('Use liveProxyHlsPlaylistResponseDescriptor instead')
const LiveProxyHlsPlaylistResponse$json = {
  '1': 'LiveProxyHlsPlaylistResponse',
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

/// Descriptor for `LiveProxyHlsPlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveProxyHlsPlaylistResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXZlUHJveHlIbHNQbGF5bGlzdFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2Ln'
        'BsYXliYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getLiveProxyHlsSegmentRequestDescriptor instead')
const GetLiveProxyHlsSegmentRequest$json = {
  '1': 'GetLiveProxyHlsSegmentRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'segment_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'segmentName'},
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

/// Descriptor for `GetLiveProxyHlsSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLiveProxyHlsSegmentRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRMaXZlUHJveHlIbHNTZWdtZW50UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAh'
    'ABUgd2ZXJzaW9uEioKDHNlZ21lbnRfbmFtZRgCIAEoCUIHukgEcgIQAVILc2VnbWVudE5hbWUS'
    'GQoDc2lnGAMgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQ'
    'oDcmlkGAUgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByAB'
    'KAlIAFIFcmFuZ2WIAQESEgoEaGVhZBgIIAEoCFIEaGVhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use liveProxyHlsSegmentResponseDescriptor instead')
const LiveProxyHlsSegmentResponse$json = {
  '1': 'LiveProxyHlsSegmentResponse',
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

/// Descriptor for `LiveProxyHlsSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveProxyHlsSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXZlUHJveHlIbHNTZWdtZW50UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucG'
        'xheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

const $core.Map<$core.String, $core.dynamic>
    LiveProxyPlaybackProviderServiceBase$json = {
  '1': 'LiveProxyPlaybackProviderService',
  '2': [
    {
      '1': 'GetFlvStream',
      '2': '.synctv.playback_provider.live_proxy.GetLiveProxyFlvStreamRequest',
      '3': '.synctv.playback_provider.live_proxy.LiveProxyFlvStreamResponse',
      '6': true
    },
    {
      '1': 'GetHlsPlaylist',
      '2':
          '.synctv.playback_provider.live_proxy.GetLiveProxyHlsPlaylistRequest',
      '3': '.synctv.playback_provider.live_proxy.LiveProxyHlsPlaylistResponse',
      '6': true
    },
    {
      '1': 'GetHlsSegment',
      '2': '.synctv.playback_provider.live_proxy.GetLiveProxyHlsSegmentRequest',
      '3': '.synctv.playback_provider.live_proxy.LiveProxyHlsSegmentResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use liveProxyPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    LiveProxyPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.live_proxy.GetLiveProxyFlvStreamRequest':
      GetLiveProxyFlvStreamRequest$json,
  '.synctv.playback_provider.live_proxy.LiveProxyFlvStreamResponse':
      LiveProxyFlvStreamResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.live_proxy.GetLiveProxyHlsPlaylistRequest':
      GetLiveProxyHlsPlaylistRequest$json,
  '.synctv.playback_provider.live_proxy.LiveProxyHlsPlaylistResponse':
      LiveProxyHlsPlaylistResponse$json,
  '.synctv.playback_provider.live_proxy.GetLiveProxyHlsSegmentRequest':
      GetLiveProxyHlsSegmentRequest$json,
  '.synctv.playback_provider.live_proxy.LiveProxyHlsSegmentResponse':
      LiveProxyHlsSegmentResponse$json,
};

/// Descriptor for `LiveProxyPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List liveProxyPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'CiBMaXZlUHJveHlQbGF5YmFja1Byb3ZpZGVyU2VydmljZRKUAQoMR2V0Rmx2U3RyZWFtEkEuc3'
    'luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmxpdmVfcHJveHkuR2V0TGl2ZVByb3h5Rmx2U3RyZWFt'
    'UmVxdWVzdBo/LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5saXZlX3Byb3h5LkxpdmVQcm94eU'
    'ZsdlN0cmVhbVJlc3BvbnNlMAESmgEKDkdldEhsc1BsYXlsaXN0EkMuc3luY3R2LnBsYXliYWNr'
    'X3Byb3ZpZGVyLmxpdmVfcHJveHkuR2V0TGl2ZVByb3h5SGxzUGxheWxpc3RSZXF1ZXN0GkEuc3'
    'luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmxpdmVfcHJveHkuTGl2ZVByb3h5SGxzUGxheWxpc3RS'
    'ZXNwb25zZTABEpcBCg1HZXRIbHNTZWdtZW50EkIuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLm'
    'xpdmVfcHJveHkuR2V0TGl2ZVByb3h5SGxzU2VnbWVudFJlcXVlc3QaQC5zeW5jdHYucGxheWJh'
    'Y2tfcHJvdmlkZXIubGl2ZV9wcm94eS5MaXZlUHJveHlIbHNTZWdtZW50UmVzcG9uc2UwAQ==');
