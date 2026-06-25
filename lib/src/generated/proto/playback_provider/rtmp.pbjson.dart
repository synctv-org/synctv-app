// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/rtmp.proto.

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

@$core.Deprecated('Use getRtmpFlvStreamRequestDescriptor instead')
const GetRtmpFlvStreamRequest$json = {
  '1': 'GetRtmpFlvStreamRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'head', '3': 6, '4': 1, '5': 8, '10': 'head'},
  ],
};

/// Descriptor for `GetRtmpFlvStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRtmpFlvStreamRequestDescriptor = $convert.base64Decode(
    'ChdHZXRSdG1wRmx2U3RyZWFtUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEhkKA3NpZxgCIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgDIAEoCUIHukgEcgIQAVID'
    'dWlkEhkKA3JpZBgEIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgFIAEoA1IDZXhwEhIKBGhlYW'
    'QYBiABKAhSBGhlYWQ=');

@$core.Deprecated('Use rtmpFlvStreamResponseDescriptor instead')
const RtmpFlvStreamResponse$json = {
  '1': 'RtmpFlvStreamResponse',
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

/// Descriptor for `RtmpFlvStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpFlvStreamResponseDescriptor = $convert.base64Decode(
    'ChVSdG1wRmx2U3RyZWFtUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getRtmpHlsPlaylistRequestDescriptor instead')
const GetRtmpHlsPlaylistRequest$json = {
  '1': 'GetRtmpHlsPlaylistRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetRtmpHlsPlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRtmpHlsPlaylistRequestDescriptor = $convert.base64Decode(
    'ChlHZXRSdG1wSGxzUGxheWxpc3RSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SGQoDc2lnGAIgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAMgASgJQge6SARyAhAB'
    'UgN1aWQSGQoDcmlkGAQgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAUgASgDUgNleHA=');

@$core.Deprecated('Use rtmpHlsPlaylistResponseDescriptor instead')
const RtmpHlsPlaylistResponse$json = {
  '1': 'RtmpHlsPlaylistResponse',
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

/// Descriptor for `RtmpHlsPlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpHlsPlaylistResponseDescriptor =
    $convert.base64Decode(
        'ChdSdG1wSGxzUGxheWxpc3RSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getRtmpHlsSegmentRequestDescriptor instead')
const GetRtmpHlsSegmentRequest$json = {
  '1': 'GetRtmpHlsSegmentRequest',
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

/// Descriptor for `GetRtmpHlsSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRtmpHlsSegmentRequestDescriptor = $convert.base64Decode(
    'ChhHZXRSdG1wSGxzU2VnbWVudFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIqCgxzZWdtZW50X25hbWUYAiABKAlCB7pIBHICEAFSC3NlZ21lbnROYW1lEhkKA3Np'
    'ZxgDIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZB'
    'gFIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABS'
    'BXJhbmdliAEBEhIKBGhlYWQYCCABKAhSBGhlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use rtmpHlsSegmentResponseDescriptor instead')
const RtmpHlsSegmentResponse$json = {
  '1': 'RtmpHlsSegmentResponse',
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

/// Descriptor for `RtmpHlsSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpHlsSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChZSdG1wSGxzU2VnbWVudFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

const $core.Map<$core.String, $core.dynamic>
    RtmpPlaybackProviderServiceBase$json = {
  '1': 'RtmpPlaybackProviderService',
  '2': [
    {
      '1': 'GetFlvStream',
      '2': '.synctv.playback_provider.rtmp.GetRtmpFlvStreamRequest',
      '3': '.synctv.playback_provider.rtmp.RtmpFlvStreamResponse',
      '6': true
    },
    {
      '1': 'GetHlsPlaylist',
      '2': '.synctv.playback_provider.rtmp.GetRtmpHlsPlaylistRequest',
      '3': '.synctv.playback_provider.rtmp.RtmpHlsPlaylistResponse',
      '6': true
    },
    {
      '1': 'GetHlsSegment',
      '2': '.synctv.playback_provider.rtmp.GetRtmpHlsSegmentRequest',
      '3': '.synctv.playback_provider.rtmp.RtmpHlsSegmentResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use rtmpPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RtmpPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.rtmp.GetRtmpFlvStreamRequest':
      GetRtmpFlvStreamRequest$json,
  '.synctv.playback_provider.rtmp.RtmpFlvStreamResponse':
      RtmpFlvStreamResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.rtmp.GetRtmpHlsPlaylistRequest':
      GetRtmpHlsPlaylistRequest$json,
  '.synctv.playback_provider.rtmp.RtmpHlsPlaylistResponse':
      RtmpHlsPlaylistResponse$json,
  '.synctv.playback_provider.rtmp.GetRtmpHlsSegmentRequest':
      GetRtmpHlsSegmentRequest$json,
  '.synctv.playback_provider.rtmp.RtmpHlsSegmentResponse':
      RtmpHlsSegmentResponse$json,
};

/// Descriptor for `RtmpPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List rtmpPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChtSdG1wUGxheWJhY2tQcm92aWRlclNlcnZpY2USfgoMR2V0Rmx2U3RyZWFtEjYuc3luY3R2Ln'
    'BsYXliYWNrX3Byb3ZpZGVyLnJ0bXAuR2V0UnRtcEZsdlN0cmVhbVJlcXVlc3QaNC5zeW5jdHYu'
    'cGxheWJhY2tfcHJvdmlkZXIucnRtcC5SdG1wRmx2U3RyZWFtUmVzcG9uc2UwARKEAQoOR2V0SG'
    'xzUGxheWxpc3QSOC5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIucnRtcC5HZXRSdG1wSGxzUGxh'
    'eWxpc3RSZXF1ZXN0GjYuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnJ0bXAuUnRtcEhsc1BsYX'
    'lsaXN0UmVzcG9uc2UwARKBAQoNR2V0SGxzU2VnbWVudBI3LnN5bmN0di5wbGF5YmFja19wcm92'
    'aWRlci5ydG1wLkdldFJ0bXBIbHNTZWdtZW50UmVxdWVzdBo1LnN5bmN0di5wbGF5YmFja19wcm'
    '92aWRlci5ydG1wLlJ0bXBIbHNTZWdtZW50UmVzcG9uc2UwAQ==');
