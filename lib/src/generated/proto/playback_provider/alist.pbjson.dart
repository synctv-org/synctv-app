// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/alist.proto.

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

@$core.Deprecated('Use getAlistFileStreamRequestDescriptor instead')
const GetAlistFileStreamRequest$json = {
  '1': 'GetAlistFileStreamRequest',
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

/// Descriptor for `GetAlistFileStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAlistFileStreamRequestDescriptor = $convert.base64Decode(
    'ChlHZXRBbGlzdEZpbGVTdHJlYW1SZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIbCgl1cmxfaW5k'
    'ZXgYAyABKA1SCHVybEluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgFIA'
    'EoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgHIAEo'
    'A1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBGhlYWRCCA'
    'oGX3Jhbmdl');

@$core.Deprecated('Use alistFileStreamResponseDescriptor instead')
const AlistFileStreamResponse$json = {
  '1': 'AlistFileStreamResponse',
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

/// Descriptor for `AlistFileStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistFileStreamResponseDescriptor =
    $convert.base64Decode(
        'ChdBbGlzdEZpbGVTdHJlYW1SZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getAlistTranscodedHlsManifestRequestDescriptor instead')
const GetAlistTranscodedHlsManifestRequest$json = {
  '1': 'GetAlistTranscodedHlsManifestRequest',
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

/// Descriptor for `GetAlistTranscodedHlsManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAlistTranscodedHlsManifestRequestDescriptor =
    $convert.base64Decode(
        'CiRHZXRBbGlzdFRyYW5zY29kZWRIbHNNYW5pZmVzdFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCU'
        'IHukgEcgIQAVIHdmVyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1l'
        'EhsKCXVybF9pbmRleBgDIAEoDVIIdXJsSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaW'
        'cSGQoDdWlkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQS'
        'EAoDZXhwGAcgASgDUgNleHA=');

@$core.Deprecated('Use alistTranscodedHlsManifestResponseDescriptor instead')
const AlistTranscodedHlsManifestResponse$json = {
  '1': 'AlistTranscodedHlsManifestResponse',
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

/// Descriptor for `AlistTranscodedHlsManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistTranscodedHlsManifestResponseDescriptor =
    $convert.base64Decode(
        'CiJBbGlzdFRyYW5zY29kZWRIbHNNYW5pZmVzdFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3'
        'luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getAlistTranscodedHlsSegmentRequestDescriptor instead')
const GetAlistTranscodedHlsSegmentRequest$json = {
  '1': 'GetAlistTranscodedHlsSegmentRequest',
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

/// Descriptor for `GetAlistTranscodedHlsSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAlistTranscodedHlsSegmentRequestDescriptor =
    $convert.base64Decode(
        'CiNHZXRBbGlzdFRyYW5zY29kZWRIbHNTZWdtZW50UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQg'
        'e6SARyAhABUgd2ZXJzaW9uEiYKCnRhcmdldF91cmwYAiABKAlCB7pIBHICEAFSCXRhcmdldFVy'
        'bBIZCgNzaWcYAyABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBCABKAlCB7pIBHICEAFSA3VpZB'
        'IZCgNyaWQYBSABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYBiABKANSA2V4cBIZCgVyYW5nZRgH'
        'IAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAggASgIUgRoZWFkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use alistTranscodedHlsSegmentResponseDescriptor instead')
const AlistTranscodedHlsSegmentResponse$json = {
  '1': 'AlistTranscodedHlsSegmentResponse',
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

/// Descriptor for `AlistTranscodedHlsSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistTranscodedHlsSegmentResponseDescriptor =
    $convert.base64Decode(
        'CiFBbGlzdFRyYW5zY29kZWRIbHNTZWdtZW50UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW'
        '5jdHYucGxheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getAlistSubtitleRequestDescriptor instead')
const GetAlistSubtitleRequest$json = {
  '1': 'GetAlistSubtitleRequest',
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

/// Descriptor for `GetAlistSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAlistSubtitleRequestDescriptor = $convert.base64Decode(
    'ChdHZXRBbGlzdFN1YnRpdGxlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSJQoOc3VidGl0bGVf'
    'aW5kZXgYAyABKA1SDXN1YnRpdGxlSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQ'
    'oDdWlkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoD'
    'ZXhwGAcgASgDUgNleHA=');

@$core.Deprecated('Use alistSubtitleResponseDescriptor instead')
const AlistSubtitleResponse$json = {
  '1': 'AlistSubtitleResponse',
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

/// Descriptor for `AlistSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistSubtitleResponseDescriptor = $convert.base64Decode(
    'ChVBbGlzdFN1YnRpdGxlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getAlistThumbnailRequestDescriptor instead')
const GetAlistThumbnailRequest$json = {
  '1': 'GetAlistThumbnailRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetAlistThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAlistThumbnailRequestDescriptor = $convert.base64Decode(
    'ChhHZXRBbGlzdFRodW1ibmFpbFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIZCgNzaWcYAiABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYAyABKAlCB7pIBHICEAFS'
    'A3VpZBIZCgNyaWQYBCABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYBSABKANSA2V4cA==');

@$core.Deprecated('Use alistThumbnailResponseDescriptor instead')
const AlistThumbnailResponse$json = {
  '1': 'AlistThumbnailResponse',
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

/// Descriptor for `AlistThumbnailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alistThumbnailResponseDescriptor =
    $convert.base64Decode(
        'ChZBbGlzdFRodW1ibmFpbFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

const $core.Map<$core.String, $core.dynamic>
    AlistPlaybackProviderServiceBase$json = {
  '1': 'AlistPlaybackProviderService',
  '2': [
    {
      '1': 'GetFileStream',
      '2': '.synctv.playback_provider.alist.GetAlistFileStreamRequest',
      '3': '.synctv.playback_provider.alist.AlistFileStreamResponse',
      '6': true
    },
    {
      '1': 'GetTranscodedHlsManifest',
      '2':
          '.synctv.playback_provider.alist.GetAlistTranscodedHlsManifestRequest',
      '3': '.synctv.playback_provider.alist.AlistTranscodedHlsManifestResponse',
      '6': true
    },
    {
      '1': 'GetTranscodedHlsSegment',
      '2':
          '.synctv.playback_provider.alist.GetAlistTranscodedHlsSegmentRequest',
      '3': '.synctv.playback_provider.alist.AlistTranscodedHlsSegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.alist.GetAlistSubtitleRequest',
      '3': '.synctv.playback_provider.alist.AlistSubtitleResponse',
      '6': true
    },
    {
      '1': 'GetThumbnail',
      '2': '.synctv.playback_provider.alist.GetAlistThumbnailRequest',
      '3': '.synctv.playback_provider.alist.AlistThumbnailResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use alistPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AlistPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.alist.GetAlistFileStreamRequest':
      GetAlistFileStreamRequest$json,
  '.synctv.playback_provider.alist.AlistFileStreamResponse':
      AlistFileStreamResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.alist.GetAlistTranscodedHlsManifestRequest':
      GetAlistTranscodedHlsManifestRequest$json,
  '.synctv.playback_provider.alist.AlistTranscodedHlsManifestResponse':
      AlistTranscodedHlsManifestResponse$json,
  '.synctv.playback_provider.alist.GetAlistTranscodedHlsSegmentRequest':
      GetAlistTranscodedHlsSegmentRequest$json,
  '.synctv.playback_provider.alist.AlistTranscodedHlsSegmentResponse':
      AlistTranscodedHlsSegmentResponse$json,
  '.synctv.playback_provider.alist.GetAlistSubtitleRequest':
      GetAlistSubtitleRequest$json,
  '.synctv.playback_provider.alist.AlistSubtitleResponse':
      AlistSubtitleResponse$json,
  '.synctv.playback_provider.alist.GetAlistThumbnailRequest':
      GetAlistThumbnailRequest$json,
  '.synctv.playback_provider.alist.AlistThumbnailResponse':
      AlistThumbnailResponse$json,
};

/// Descriptor for `AlistPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List alistPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChxBbGlzdFBsYXliYWNrUHJvdmlkZXJTZXJ2aWNlEoUBCg1HZXRGaWxlU3RyZWFtEjkuc3luY3'
    'R2LnBsYXliYWNrX3Byb3ZpZGVyLmFsaXN0LkdldEFsaXN0RmlsZVN0cmVhbVJlcXVlc3QaNy5z'
    'eW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYWxpc3QuQWxpc3RGaWxlU3RyZWFtUmVzcG9uc2UwAR'
    'KmAQoYR2V0VHJhbnNjb2RlZEhsc01hbmlmZXN0EkQuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVy'
    'LmFsaXN0LkdldEFsaXN0VHJhbnNjb2RlZEhsc01hbmlmZXN0UmVxdWVzdBpCLnN5bmN0di5wbG'
    'F5YmFja19wcm92aWRlci5hbGlzdC5BbGlzdFRyYW5zY29kZWRIbHNNYW5pZmVzdFJlc3BvbnNl'
    'MAESowEKF0dldFRyYW5zY29kZWRIbHNTZWdtZW50EkMuc3luY3R2LnBsYXliYWNrX3Byb3ZpZG'
    'VyLmFsaXN0LkdldEFsaXN0VHJhbnNjb2RlZEhsc1NlZ21lbnRSZXF1ZXN0GkEuc3luY3R2LnBs'
    'YXliYWNrX3Byb3ZpZGVyLmFsaXN0LkFsaXN0VHJhbnNjb2RlZEhsc1NlZ21lbnRSZXNwb25zZT'
    'ABEn8KC0dldFN1YnRpdGxlEjcuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmFsaXN0LkdldEFs'
    'aXN0U3VidGl0bGVSZXF1ZXN0GjUuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmFsaXN0LkFsaX'
    'N0U3VidGl0bGVSZXNwb25zZTABEoIBCgxHZXRUaHVtYm5haWwSOC5zeW5jdHYucGxheWJhY2tf'
    'cHJvdmlkZXIuYWxpc3QuR2V0QWxpc3RUaHVtYm5haWxSZXF1ZXN0GjYuc3luY3R2LnBsYXliYW'
    'NrX3Byb3ZpZGVyLmFsaXN0LkFsaXN0VGh1bWJuYWlsUmVzcG9uc2UwAQ==');
