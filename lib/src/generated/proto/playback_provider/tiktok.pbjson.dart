// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/tiktok.proto.

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

@$core.Deprecated('Use tikTokHlsResourceKindDescriptor instead')
const TikTokHlsResourceKind$json = {
  '1': 'TikTokHlsResourceKind',
  '2': [
    {'1': 'TIK_TOK_HLS_RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TIK_TOK_HLS_RESOURCE_KIND_MEDIA', '2': 1},
    {'1': 'TIK_TOK_HLS_RESOURCE_KIND_MANIFEST', '2': 2},
  ],
};

/// Descriptor for `TikTokHlsResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tikTokHlsResourceKindDescriptor = $convert.base64Decode(
    'ChVUaWtUb2tIbHNSZXNvdXJjZUtpbmQSKQolVElLX1RPS19ITFNfUkVTT1VSQ0VfS0lORF9VTl'
    'NQRUNJRklFRBAAEiMKH1RJS19UT0tfSExTX1JFU09VUkNFX0tJTkRfTUVESUEQARImCiJUSUtf'
    'VE9LX0hMU19SRVNPVVJDRV9LSU5EX01BTklGRVNUEAI=');

@$core.Deprecated('Use getTikTokResourceRequestDescriptor instead')
const GetTikTokResourceRequest$json = {
  '1': 'GetTikTokResourceRequest',
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

/// Descriptor for `GetTikTokResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTikTokResourceRequestDescriptor = $convert.base64Decode(
    'ChhHZXRUaWtUb2tSZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEh8KC21lZGlhX2lu'
    'ZGV4GAMgASgNUgptZWRpYUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZB'
    'gFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgH'
    'IAEoA1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBGhlYW'
    'RCCAoGX3Jhbmdl');

@$core.Deprecated('Use tikTokResourceResponseDescriptor instead')
const TikTokResourceResponse$json = {
  '1': 'TikTokResourceResponse',
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

/// Descriptor for `TikTokResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokResourceResponseDescriptor =
    $convert.base64Decode(
        'ChZUaWtUb2tSZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getTikTokHlsResourceRequestDescriptor instead')
const GetTikTokHlsResourceRequest$json = {
  '1': 'GetTikTokHlsResourceRequest',
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
      '6': '.synctv.playback_provider.tiktok.TikTokHlsResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetTikTokHlsResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTikTokHlsResourceRequestDescriptor = $convert.base64Decode(
    'ChtHZXRUaWtUb2tIbHNSZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAV'
    'IHdmVyc2lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2ln'
    'GAMgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGA'
    'UgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIF'
    'cmFuZ2WIAQESEgoEaGVhZBgIIAEoCFIEaGVhZBIkCgltb2RlX25hbWUYCSABKAlCB7pIBHICEA'
    'FSCG1vZGVOYW1lEh8KC21lZGlhX2luZGV4GAogASgNUgptZWRpYUluZGV4EmUKDXJlc291cmNl'
    'X2tpbmQYCyABKA4yNi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIudGlrdG9rLlRpa1Rva0hsc1'
    'Jlc291cmNlS2luZEIIukgFggECEAFSDHJlc291cmNlS2luZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use tikTokHlsResourceResponseDescriptor instead')
const TikTokHlsResourceResponse$json = {
  '1': 'TikTokHlsResourceResponse',
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

/// Descriptor for `TikTokHlsResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokHlsResourceResponseDescriptor =
    $convert.base64Decode(
        'ChlUaWtUb2tIbHNSZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYX'
        'liYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getTikTokSubtitleRequestDescriptor instead')
const GetTikTokSubtitleRequest$json = {
  '1': 'GetTikTokSubtitleRequest',
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

/// Descriptor for `GetTikTokSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTikTokSubtitleRequestDescriptor = $convert.base64Decode(
    'ChhHZXRUaWtUb2tTdWJ0aXRsZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEiUKDnN1YnRpdGxl'
    'X2luZGV4GAMgASgNUg1zdWJ0aXRsZUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEh'
    'kKA3VpZBgFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAK'
    'A2V4cBgHIAEoA1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKA'
    'hSBGhlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use tikTokSubtitleResponseDescriptor instead')
const TikTokSubtitleResponse$json = {
  '1': 'TikTokSubtitleResponse',
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

/// Descriptor for `TikTokSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChZUaWtUb2tTdWJ0aXRsZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

const $core.Map<$core.String, $core.dynamic>
    TikTokPlaybackProviderServiceBase$json = {
  '1': 'TikTokPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.tiktok.GetTikTokResourceRequest',
      '3': '.synctv.playback_provider.tiktok.TikTokResourceResponse',
      '6': true
    },
    {
      '1': 'GetHlsResource',
      '2': '.synctv.playback_provider.tiktok.GetTikTokHlsResourceRequest',
      '3': '.synctv.playback_provider.tiktok.TikTokHlsResourceResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.tiktok.GetTikTokSubtitleRequest',
      '3': '.synctv.playback_provider.tiktok.TikTokSubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use tikTokPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TikTokPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.tiktok.GetTikTokResourceRequest':
      GetTikTokResourceRequest$json,
  '.synctv.playback_provider.tiktok.TikTokResourceResponse':
      TikTokResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.tiktok.GetTikTokHlsResourceRequest':
      GetTikTokHlsResourceRequest$json,
  '.synctv.playback_provider.tiktok.TikTokHlsResourceResponse':
      TikTokHlsResourceResponse$json,
  '.synctv.playback_provider.tiktok.GetTikTokSubtitleRequest':
      GetTikTokSubtitleRequest$json,
  '.synctv.playback_provider.tiktok.TikTokSubtitleResponse':
      TikTokSubtitleResponse$json,
};

/// Descriptor for `TikTokPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List tikTokPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch1UaWtUb2tQbGF5YmFja1Byb3ZpZGVyU2VydmljZRKDAQoLR2V0UmVzb3VyY2USOS5zeW5jdH'
    'YucGxheWJhY2tfcHJvdmlkZXIudGlrdG9rLkdldFRpa1Rva1Jlc291cmNlUmVxdWVzdBo3LnN5'
    'bmN0di5wbGF5YmFja19wcm92aWRlci50aWt0b2suVGlrVG9rUmVzb3VyY2VSZXNwb25zZTABEo'
    'wBCg5HZXRIbHNSZXNvdXJjZRI8LnN5bmN0di5wbGF5YmFja19wcm92aWRlci50aWt0b2suR2V0'
    'VGlrVG9rSGxzUmVzb3VyY2VSZXF1ZXN0Gjouc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnRpa3'
    'Rvay5UaWtUb2tIbHNSZXNvdXJjZVJlc3BvbnNlMAESgwEKC0dldFN1YnRpdGxlEjkuc3luY3R2'
    'LnBsYXliYWNrX3Byb3ZpZGVyLnRpa3Rvay5HZXRUaWtUb2tTdWJ0aXRsZVJlcXVlc3QaNy5zeW'
    '5jdHYucGxheWJhY2tfcHJvdmlkZXIudGlrdG9rLlRpa1Rva1N1YnRpdGxlUmVzcG9uc2UwAQ==');
