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

@$core.Deprecated('Use getTikTokSegmentRequestDescriptor instead')
const GetTikTokSegmentRequest$json = {
  '1': 'GetTikTokSegmentRequest',
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

/// Descriptor for `GetTikTokSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTikTokSegmentRequestDescriptor = $convert.base64Decode(
    'ChdHZXRUaWtUb2tTZWdtZW50UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEiYKCnRhcmdldF91cmwYAiABKAlCB7pIBHICEAFSCXRhcmdldFVybBIZCgNzaWcYAyAB'
    'KAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBCABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBSABKA'
    'lCB7pIBHICEAFSA3JpZBIQCgNleHAYBiABKANSA2V4cBIZCgVyYW5nZRgHIAEoCUgAUgVyYW5n'
    'ZYgBARISCgRoZWFkGAggASgIUgRoZWFkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use tikTokSegmentResponseDescriptor instead')
const TikTokSegmentResponse$json = {
  '1': 'TikTokSegmentResponse',
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

/// Descriptor for `TikTokSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tikTokSegmentResponseDescriptor = $convert.base64Decode(
    'ChVUaWtUb2tTZWdtZW50UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

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
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.tiktok.GetTikTokSegmentRequest',
      '3': '.synctv.playback_provider.tiktok.TikTokSegmentResponse',
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
  '.synctv.playback_provider.tiktok.GetTikTokSegmentRequest':
      GetTikTokSegmentRequest$json,
  '.synctv.playback_provider.tiktok.TikTokSegmentResponse':
      TikTokSegmentResponse$json,
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
    'ABCgpHZXRTZWdtZW50Ejguc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnRpa3Rvay5HZXRUaWtU'
    'b2tTZWdtZW50UmVxdWVzdBo2LnN5bmN0di5wbGF5YmFja19wcm92aWRlci50aWt0b2suVGlrVG'
    '9rU2VnbWVudFJlc3BvbnNlMAESgwEKC0dldFN1YnRpdGxlEjkuc3luY3R2LnBsYXliYWNrX3By'
    'b3ZpZGVyLnRpa3Rvay5HZXRUaWtUb2tTdWJ0aXRsZVJlcXVlc3QaNy5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIudGlrdG9rLlRpa1Rva1N1YnRpdGxlUmVzcG9uc2UwAQ==');
