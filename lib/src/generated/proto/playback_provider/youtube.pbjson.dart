// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/youtube.proto.

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

@$core.Deprecated('Use getYoutubeResourceRequestDescriptor instead')
const GetYoutubeResourceRequest$json = {
  '1': 'GetYoutubeResourceRequest',
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

/// Descriptor for `GetYoutubeResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getYoutubeResourceRequestDescriptor = $convert.base64Decode(
    'ChlHZXRZb3V0dWJlUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9p'
    'bmRleBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZW'
    'FkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use youtubeResourceResponseDescriptor instead')
const YoutubeResourceResponse$json = {
  '1': 'YoutubeResourceResponse',
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

/// Descriptor for `YoutubeResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List youtubeResourceResponseDescriptor =
    $convert.base64Decode(
        'ChdZb3V0dWJlUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getYoutubeSegmentRequestDescriptor instead')
const GetYoutubeSegmentRequest$json = {
  '1': 'GetYoutubeSegmentRequest',
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

/// Descriptor for `GetYoutubeSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getYoutubeSegmentRequestDescriptor = $convert.base64Decode(
    'ChhHZXRZb3V0dWJlU2VnbWVudFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2lnGAMg'
    'ASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAUgAS'
    'gJQge6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIFcmFu'
    'Z2WIAQESEgoEaGVhZBgIIAEoCFIEaGVhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use youtubeSegmentResponseDescriptor instead')
const YoutubeSegmentResponse$json = {
  '1': 'YoutubeSegmentResponse',
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

/// Descriptor for `YoutubeSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List youtubeSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChZZb3V0dWJlU2VnbWVudFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getYoutubeSubtitleRequestDescriptor instead')
const GetYoutubeSubtitleRequest$json = {
  '1': 'GetYoutubeSubtitleRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'subtitle_index', '3': 3, '4': 1, '5': 13, '10': 'subtitleIndex'},
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

/// Descriptor for `GetYoutubeSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getYoutubeSubtitleRequestDescriptor = $convert.base64Decode(
    'ChlHZXRZb3V0dWJlU3VidGl0bGVSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIlCg5zdWJ0aXRs'
    'ZV9pbmRleBgDIAEoDVINc3VidGl0bGVJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZx'
    'IZCgN1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQ'
    'CgNleHAYByABKANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgAS'
    'gIUgRoZWFkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use youtubeSubtitleResponseDescriptor instead')
const YoutubeSubtitleResponse$json = {
  '1': 'YoutubeSubtitleResponse',
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

/// Descriptor for `YoutubeSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List youtubeSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChdZb3V0dWJlU3VidGl0bGVSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

const $core.Map<$core.String, $core.dynamic>
    YoutubePlaybackProviderServiceBase$json = {
  '1': 'YoutubePlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.youtube.GetYoutubeResourceRequest',
      '3': '.synctv.playback_provider.youtube.YoutubeResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.youtube.GetYoutubeSegmentRequest',
      '3': '.synctv.playback_provider.youtube.YoutubeSegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.youtube.GetYoutubeSubtitleRequest',
      '3': '.synctv.playback_provider.youtube.YoutubeSubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use youtubePlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    YoutubePlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.youtube.GetYoutubeResourceRequest':
      GetYoutubeResourceRequest$json,
  '.synctv.playback_provider.youtube.YoutubeResourceResponse':
      YoutubeResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.youtube.GetYoutubeSegmentRequest':
      GetYoutubeSegmentRequest$json,
  '.synctv.playback_provider.youtube.YoutubeSegmentResponse':
      YoutubeSegmentResponse$json,
  '.synctv.playback_provider.youtube.GetYoutubeSubtitleRequest':
      GetYoutubeSubtitleRequest$json,
  '.synctv.playback_provider.youtube.YoutubeSubtitleResponse':
      YoutubeSubtitleResponse$json,
};

/// Descriptor for `YoutubePlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List youtubePlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch5Zb3V0dWJlUGxheWJhY2tQcm92aWRlclNlcnZpY2UShwEKC0dldFJlc291cmNlEjsuc3luY3'
    'R2LnBsYXliYWNrX3Byb3ZpZGVyLnlvdXR1YmUuR2V0WW91dHViZVJlc291cmNlUmVxdWVzdBo5'
    'LnN5bmN0di5wbGF5YmFja19wcm92aWRlci55b3V0dWJlLllvdXR1YmVSZXNvdXJjZVJlc3Bvbn'
    'NlMAEShAEKCkdldFNlZ21lbnQSOi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIueW91dHViZS5H'
    'ZXRZb3V0dWJlU2VnbWVudFJlcXVlc3QaOC5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIueW91dH'
    'ViZS5Zb3V0dWJlU2VnbWVudFJlc3BvbnNlMAEShwEKC0dldFN1YnRpdGxlEjsuc3luY3R2LnBs'
    'YXliYWNrX3Byb3ZpZGVyLnlvdXR1YmUuR2V0WW91dHViZVN1YnRpdGxlUmVxdWVzdBo5LnN5bm'
    'N0di5wbGF5YmFja19wcm92aWRlci55b3V0dWJlLllvdXR1YmVTdWJ0aXRsZVJlc3BvbnNlMAE=');
