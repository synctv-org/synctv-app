// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/emby.proto.

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

@$core.Deprecated('Use getEmbyMediaStreamRequestDescriptor instead')
const GetEmbyMediaStreamRequest$json = {
  '1': 'GetEmbyMediaStreamRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'url_index', '3': 3, '4': 1, '5': 13, '10': 'urlIndex'},
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

/// Descriptor for `GetEmbyMediaStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEmbyMediaStreamRequestDescriptor = $convert.base64Decode(
    'ChlHZXRFbWJ5TWVkaWFTdHJlYW1SZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIbCgl1cmxfaW5k'
    'ZXgYAyABKA1SCHVybEluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgFIA'
    'EoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgHIAEo'
    'A1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBGhlYWRCCA'
    'oGX3Jhbmdl');

@$core.Deprecated('Use embyMediaStreamResponseDescriptor instead')
const EmbyMediaStreamResponse$json = {
  '1': 'EmbyMediaStreamResponse',
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

/// Descriptor for `EmbyMediaStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyMediaStreamResponseDescriptor =
    $convert.base64Decode(
        'ChdFbWJ5TWVkaWFTdHJlYW1SZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getEmbyHlsManifestRequestDescriptor instead')
const GetEmbyHlsManifestRequest$json = {
  '1': 'GetEmbyHlsManifestRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'url_index', '3': 3, '4': 1, '5': 13, '10': 'urlIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetEmbyHlsManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEmbyHlsManifestRequestDescriptor = $convert.base64Decode(
    'ChlHZXRFbWJ5SGxzTWFuaWZlc3RSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIbCgl1cmxfaW5k'
    'ZXgYAyABKA1SCHVybEluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgFIA'
    'EoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgHIAEo'
    'A1IDZXhw');

@$core.Deprecated('Use embyHlsManifestResponseDescriptor instead')
const EmbyHlsManifestResponse$json = {
  '1': 'EmbyHlsManifestResponse',
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

/// Descriptor for `EmbyHlsManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyHlsManifestResponseDescriptor =
    $convert.base64Decode(
        'ChdFbWJ5SGxzTWFuaWZlc3RSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getEmbyHlsSegmentRequestDescriptor instead')
const GetEmbyHlsSegmentRequest$json = {
  '1': 'GetEmbyHlsSegmentRequest',
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

/// Descriptor for `GetEmbyHlsSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEmbyHlsSegmentRequestDescriptor = $convert.base64Decode(
    'ChhHZXRFbWJ5SGxzU2VnbWVudFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2lnGAMg'
    'ASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAUgAS'
    'gJQge6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIFcmFu'
    'Z2WIAQESEgoEaGVhZBgIIAEoCFIEaGVhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use embyHlsSegmentResponseDescriptor instead')
const EmbyHlsSegmentResponse$json = {
  '1': 'EmbyHlsSegmentResponse',
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

/// Descriptor for `EmbyHlsSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embyHlsSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChZFbWJ5SGxzU2VnbWVudFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getEmbySubtitleRequestDescriptor instead')
const GetEmbySubtitleRequest$json = {
  '1': 'GetEmbySubtitleRequest',
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

/// Descriptor for `GetEmbySubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEmbySubtitleRequestDescriptor = $convert.base64Decode(
    'ChZHZXRFbWJ5U3VidGl0bGVSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIlCg5zdWJ0aXRsZV9p'
    'bmRleBgDIAEoDVINc3VidGl0bGVJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCg'
    'N1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNl'
    'eHAYByABKANSA2V4cA==');

@$core.Deprecated('Use embySubtitleResponseDescriptor instead')
const EmbySubtitleResponse$json = {
  '1': 'EmbySubtitleResponse',
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

/// Descriptor for `EmbySubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List embySubtitleResponseDescriptor = $convert.base64Decode(
    'ChRFbWJ5U3VidGl0bGVSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

const $core.Map<$core.String, $core.dynamic>
    EmbyPlaybackProviderServiceBase$json = {
  '1': 'EmbyPlaybackProviderService',
  '2': [
    {
      '1': 'GetMediaStream',
      '2': '.synctv.playback_provider.emby.GetEmbyMediaStreamRequest',
      '3': '.synctv.playback_provider.emby.EmbyMediaStreamResponse',
      '6': true
    },
    {
      '1': 'GetHlsManifest',
      '2': '.synctv.playback_provider.emby.GetEmbyHlsManifestRequest',
      '3': '.synctv.playback_provider.emby.EmbyHlsManifestResponse',
      '6': true
    },
    {
      '1': 'GetHlsSegment',
      '2': '.synctv.playback_provider.emby.GetEmbyHlsSegmentRequest',
      '3': '.synctv.playback_provider.emby.EmbyHlsSegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.emby.GetEmbySubtitleRequest',
      '3': '.synctv.playback_provider.emby.EmbySubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use embyPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    EmbyPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.emby.GetEmbyMediaStreamRequest':
      GetEmbyMediaStreamRequest$json,
  '.synctv.playback_provider.emby.EmbyMediaStreamResponse':
      EmbyMediaStreamResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.emby.GetEmbyHlsManifestRequest':
      GetEmbyHlsManifestRequest$json,
  '.synctv.playback_provider.emby.EmbyHlsManifestResponse':
      EmbyHlsManifestResponse$json,
  '.synctv.playback_provider.emby.GetEmbyHlsSegmentRequest':
      GetEmbyHlsSegmentRequest$json,
  '.synctv.playback_provider.emby.EmbyHlsSegmentResponse':
      EmbyHlsSegmentResponse$json,
  '.synctv.playback_provider.emby.GetEmbySubtitleRequest':
      GetEmbySubtitleRequest$json,
  '.synctv.playback_provider.emby.EmbySubtitleResponse':
      EmbySubtitleResponse$json,
};

/// Descriptor for `EmbyPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List embyPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChtFbWJ5UGxheWJhY2tQcm92aWRlclNlcnZpY2UShAEKDkdldE1lZGlhU3RyZWFtEjguc3luY3'
    'R2LnBsYXliYWNrX3Byb3ZpZGVyLmVtYnkuR2V0RW1ieU1lZGlhU3RyZWFtUmVxdWVzdBo2LnN5'
    'bmN0di5wbGF5YmFja19wcm92aWRlci5lbWJ5LkVtYnlNZWRpYVN0cmVhbVJlc3BvbnNlMAEShA'
    'EKDkdldEhsc01hbmlmZXN0Ejguc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmVtYnkuR2V0RW1i'
    'eUhsc01hbmlmZXN0UmVxdWVzdBo2LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5lbWJ5LkVtYn'
    'lIbHNNYW5pZmVzdFJlc3BvbnNlMAESgQEKDUdldEhsc1NlZ21lbnQSNy5zeW5jdHYucGxheWJh'
    'Y2tfcHJvdmlkZXIuZW1ieS5HZXRFbWJ5SGxzU2VnbWVudFJlcXVlc3QaNS5zeW5jdHYucGxheW'
    'JhY2tfcHJvdmlkZXIuZW1ieS5FbWJ5SGxzU2VnbWVudFJlc3BvbnNlMAESewoLR2V0U3VidGl0'
    'bGUSNS5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZW1ieS5HZXRFbWJ5U3VidGl0bGVSZXF1ZX'
    'N0GjMuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmVtYnkuRW1ieVN1YnRpdGxlUmVzcG9uc2Uw'
    'AQ==');
