// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/fnos.proto.

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

@$core.Deprecated('Use getFnosResourceRequestDescriptor instead')
const GetFnosResourceRequest$json = {
  '1': 'GetFnosResourceRequest',
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

/// Descriptor for `GetFnosResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFnosResourceRequestDescriptor = $convert.base64Decode(
    'ChZHZXRGbm9zUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9pbmRl'
    'eBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBS'
    'ABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYByAB'
    'KANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZWFkQg'
    'gKBl9yYW5nZQ==');

@$core.Deprecated('Use fnosResourceResponseDescriptor instead')
const FnosResourceResponse$json = {
  '1': 'FnosResourceResponse',
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

/// Descriptor for `FnosResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosResourceResponseDescriptor = $convert.base64Decode(
    'ChRGbm9zUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getFnosSegmentRequestDescriptor instead')
const GetFnosSegmentRequest$json = {
  '1': 'GetFnosSegmentRequest',
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

/// Descriptor for `GetFnosSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFnosSegmentRequestDescriptor = $convert.base64Decode(
    'ChVHZXRGbm9zU2VnbWVudFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdmVyc2'
    'lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2lnGAMgASgJ'
    'Qge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAUgASgJQg'
    'e6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIFcmFuZ2WI'
    'AQESEgoEaGVhZBgIIAEoCFIEaGVhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use fnosSegmentResponseDescriptor instead')
const FnosSegmentResponse$json = {
  '1': 'FnosSegmentResponse',
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

/// Descriptor for `FnosSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosSegmentResponseDescriptor = $convert.base64Decode(
    'ChNGbm9zU2VnbWVudFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYWNrX3'
    'Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getFnosSubtitleRequestDescriptor instead')
const GetFnosSubtitleRequest$json = {
  '1': 'GetFnosSubtitleRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'subtitle_index', '3': 3, '4': 1, '5': 13, '10': 'subtitleIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetFnosSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFnosSubtitleRequestDescriptor = $convert.base64Decode(
    'ChZHZXRGbm9zU3VidGl0bGVSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIlCg5zdWJ0aXRsZV9p'
    'bmRleBgDIAEoDVINc3VidGl0bGVJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCg'
    'N1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNl'
    'eHAYByABKANSA2V4cA==');

@$core.Deprecated('Use fnosSubtitleResponseDescriptor instead')
const FnosSubtitleResponse$json = {
  '1': 'FnosSubtitleResponse',
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

/// Descriptor for `FnosSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosSubtitleResponseDescriptor = $convert.base64Decode(
    'ChRGbm9zU3VidGl0bGVSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getFnosThumbnailRequestDescriptor instead')
const GetFnosThumbnailRequest$json = {
  '1': 'GetFnosThumbnailRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetFnosThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFnosThumbnailRequestDescriptor = $convert.base64Decode(
    'ChdHZXRGbm9zVGh1bWJuYWlsUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEhkKA3NpZxgCIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgDIAEoCUIHukgEcgIQAVID'
    'dWlkEhkKA3JpZBgEIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgFIAEoA1IDZXhw');

@$core.Deprecated('Use fnosThumbnailResponseDescriptor instead')
const FnosThumbnailResponse$json = {
  '1': 'FnosThumbnailResponse',
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

/// Descriptor for `FnosThumbnailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fnosThumbnailResponseDescriptor = $convert.base64Decode(
    'ChVGbm9zVGh1bWJuYWlsUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

const $core.Map<$core.String, $core.dynamic>
    FnosPlaybackProviderServiceBase$json = {
  '1': 'FnosPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.fnos.GetFnosResourceRequest',
      '3': '.synctv.playback_provider.fnos.FnosResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.fnos.GetFnosSegmentRequest',
      '3': '.synctv.playback_provider.fnos.FnosSegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.fnos.GetFnosSubtitleRequest',
      '3': '.synctv.playback_provider.fnos.FnosSubtitleResponse',
      '6': true
    },
    {
      '1': 'GetThumbnail',
      '2': '.synctv.playback_provider.fnos.GetFnosThumbnailRequest',
      '3': '.synctv.playback_provider.fnos.FnosThumbnailResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use fnosPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    FnosPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.fnos.GetFnosResourceRequest':
      GetFnosResourceRequest$json,
  '.synctv.playback_provider.fnos.FnosResourceResponse':
      FnosResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.fnos.GetFnosSegmentRequest':
      GetFnosSegmentRequest$json,
  '.synctv.playback_provider.fnos.FnosSegmentResponse':
      FnosSegmentResponse$json,
  '.synctv.playback_provider.fnos.GetFnosSubtitleRequest':
      GetFnosSubtitleRequest$json,
  '.synctv.playback_provider.fnos.FnosSubtitleResponse':
      FnosSubtitleResponse$json,
  '.synctv.playback_provider.fnos.GetFnosThumbnailRequest':
      GetFnosThumbnailRequest$json,
  '.synctv.playback_provider.fnos.FnosThumbnailResponse':
      FnosThumbnailResponse$json,
};

/// Descriptor for `FnosPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List fnosPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChtGbm9zUGxheWJhY2tQcm92aWRlclNlcnZpY2USewoLR2V0UmVzb3VyY2USNS5zeW5jdHYucG'
    'xheWJhY2tfcHJvdmlkZXIuZm5vcy5HZXRGbm9zUmVzb3VyY2VSZXF1ZXN0GjMuc3luY3R2LnBs'
    'YXliYWNrX3Byb3ZpZGVyLmZub3MuRm5vc1Jlc291cmNlUmVzcG9uc2UwARJ4CgpHZXRTZWdtZW'
    '50EjQuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmZub3MuR2V0Rm5vc1NlZ21lbnRSZXF1ZXN0'
    'GjIuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmZub3MuRm5vc1NlZ21lbnRSZXNwb25zZTABEn'
    'sKC0dldFN1YnRpdGxlEjUuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmZub3MuR2V0Rm5vc1N1'
    'YnRpdGxlUmVxdWVzdBozLnN5bmN0di5wbGF5YmFja19wcm92aWRlci5mbm9zLkZub3NTdWJ0aX'
    'RsZVJlc3BvbnNlMAESfgoMR2V0VGh1bWJuYWlsEjYuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVy'
    'LmZub3MuR2V0Rm5vc1RodW1ibmFpbFJlcXVlc3QaNC5zeW5jdHYucGxheWJhY2tfcHJvdmlkZX'
    'IuZm5vcy5Gbm9zVGh1bWJuYWlsUmVzcG9uc2UwAQ==');
