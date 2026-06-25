// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/direct_url.proto.

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

@$core.Deprecated('Use getDirectUrlStreamRequestDescriptor instead')
const GetDirectUrlStreamRequest$json = {
  '1': 'GetDirectUrlStreamRequest',
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

/// Descriptor for `GetDirectUrlStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlStreamRequestDescriptor = $convert.base64Decode(
    'ChlHZXREaXJlY3RVcmxTdHJlYW1SZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIbCgl1cmxfaW5k'
    'ZXgYAyABKA1SCHVybEluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgFIA'
    'EoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgHIAEo'
    'A1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBGhlYWRCCA'
    'oGX3Jhbmdl');

@$core.Deprecated('Use directUrlStreamResponseDescriptor instead')
const DirectUrlStreamResponse$json = {
  '1': 'DirectUrlStreamResponse',
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

/// Descriptor for `DirectUrlStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlStreamResponseDescriptor =
    $convert.base64Decode(
        'ChdEaXJlY3RVcmxTdHJlYW1SZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getDirectUrlHlsManifestRequestDescriptor instead')
const GetDirectUrlHlsManifestRequest$json = {
  '1': 'GetDirectUrlHlsManifestRequest',
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

/// Descriptor for `GetDirectUrlHlsManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlHlsManifestRequestDescriptor = $convert.base64Decode(
    'Ch5HZXREaXJlY3RVcmxIbHNNYW5pZmVzdFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcg'
    'IQAVIHdmVyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEhsKCXVy'
    'bF9pbmRleBgDIAEoDVIIdXJsSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaWcSGQoDdW'
    'lkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQSEAoDZXhw'
    'GAcgASgDUgNleHA=');

@$core.Deprecated('Use directUrlHlsManifestResponseDescriptor instead')
const DirectUrlHlsManifestResponse$json = {
  '1': 'DirectUrlHlsManifestResponse',
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

/// Descriptor for `DirectUrlHlsManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlHlsManifestResponseDescriptor =
    $convert.base64Decode(
        'ChxEaXJlY3RVcmxIbHNNYW5pZmVzdFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2Ln'
        'BsYXliYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getDirectUrlHlsSegmentRequestDescriptor instead')
const GetDirectUrlHlsSegmentRequest$json = {
  '1': 'GetDirectUrlHlsSegmentRequest',
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

/// Descriptor for `GetDirectUrlHlsSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlHlsSegmentRequestDescriptor = $convert.base64Decode(
    'Ch1HZXREaXJlY3RVcmxIbHNTZWdtZW50UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAh'
    'ABUgd2ZXJzaW9uEiYKCnRhcmdldF91cmwYAiABKAlCB7pIBHICEAFSCXRhcmdldFVybBIZCgNz'
    'aWcYAyABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBCABKAlCB7pIBHICEAFSA3VpZBIZCgNyaW'
    'QYBSABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYBiABKANSA2V4cBIZCgVyYW5nZRgHIAEoCUgA'
    'UgVyYW5nZYgBARISCgRoZWFkGAggASgIUgRoZWFkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use directUrlHlsSegmentResponseDescriptor instead')
const DirectUrlHlsSegmentResponse$json = {
  '1': 'DirectUrlHlsSegmentResponse',
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

/// Descriptor for `DirectUrlHlsSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlHlsSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChtEaXJlY3RVcmxIbHNTZWdtZW50UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucG'
        'xheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getDirectUrlSubtitleRequestDescriptor instead')
const GetDirectUrlSubtitleRequest$json = {
  '1': 'GetDirectUrlSubtitleRequest',
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

/// Descriptor for `GetDirectUrlSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlSubtitleRequestDescriptor = $convert.base64Decode(
    'ChtHZXREaXJlY3RVcmxTdWJ0aXRsZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAV'
    'IHdmVyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEiUKDnN1YnRp'
    'dGxlX2luZGV4GAMgASgNUg1zdWJ0aXRsZUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2'
    'lnEhkKA3VpZBgFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlk'
    'EhAKA2V4cBgHIAEoA1IDZXhw');

@$core.Deprecated('Use directUrlSubtitleResponseDescriptor instead')
const DirectUrlSubtitleResponse$json = {
  '1': 'DirectUrlSubtitleResponse',
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

/// Descriptor for `DirectUrlSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChlEaXJlY3RVcmxTdWJ0aXRsZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYX'
        'liYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

const $core.Map<$core.String, $core.dynamic>
    DirectUrlPlaybackProviderServiceBase$json = {
  '1': 'DirectUrlPlaybackProviderService',
  '2': [
    {
      '1': 'GetStream',
      '2': '.synctv.playback_provider.direct_url.GetDirectUrlStreamRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlStreamResponse',
      '6': true
    },
    {
      '1': 'GetHlsManifest',
      '2':
          '.synctv.playback_provider.direct_url.GetDirectUrlHlsManifestRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlHlsManifestResponse',
      '6': true
    },
    {
      '1': 'GetHlsSegment',
      '2': '.synctv.playback_provider.direct_url.GetDirectUrlHlsSegmentRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlHlsSegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.direct_url.GetDirectUrlSubtitleRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlSubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use directUrlPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DirectUrlPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.direct_url.GetDirectUrlStreamRequest':
      GetDirectUrlStreamRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlStreamResponse':
      DirectUrlStreamResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.direct_url.GetDirectUrlHlsManifestRequest':
      GetDirectUrlHlsManifestRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlHlsManifestResponse':
      DirectUrlHlsManifestResponse$json,
  '.synctv.playback_provider.direct_url.GetDirectUrlHlsSegmentRequest':
      GetDirectUrlHlsSegmentRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlHlsSegmentResponse':
      DirectUrlHlsSegmentResponse$json,
  '.synctv.playback_provider.direct_url.GetDirectUrlSubtitleRequest':
      GetDirectUrlSubtitleRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlSubtitleResponse':
      DirectUrlSubtitleResponse$json,
};

/// Descriptor for `DirectUrlPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List directUrlPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'CiBEaXJlY3RVcmxQbGF5YmFja1Byb3ZpZGVyU2VydmljZRKLAQoJR2V0U3RyZWFtEj4uc3luY3'
    'R2LnBsYXliYWNrX3Byb3ZpZGVyLmRpcmVjdF91cmwuR2V0RGlyZWN0VXJsU3RyZWFtUmVxdWVz'
    'dBo8LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdXJsLkRpcmVjdFVybFN0cmVhbV'
    'Jlc3BvbnNlMAESmgEKDkdldEhsc01hbmlmZXN0EkMuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVy'
    'LmRpcmVjdF91cmwuR2V0RGlyZWN0VXJsSGxzTWFuaWZlc3RSZXF1ZXN0GkEuc3luY3R2LnBsYX'
    'liYWNrX3Byb3ZpZGVyLmRpcmVjdF91cmwuRGlyZWN0VXJsSGxzTWFuaWZlc3RSZXNwb25zZTAB'
    'EpcBCg1HZXRIbHNTZWdtZW50EkIuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmRpcmVjdF91cm'
    'wuR2V0RGlyZWN0VXJsSGxzU2VnbWVudFJlcXVlc3QaQC5zeW5jdHYucGxheWJhY2tfcHJvdmlk'
    'ZXIuZGlyZWN0X3VybC5EaXJlY3RVcmxIbHNTZWdtZW50UmVzcG9uc2UwARKRAQoLR2V0U3VidG'
    'l0bGUSQC5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZGlyZWN0X3VybC5HZXREaXJlY3RVcmxT'
    'dWJ0aXRsZVJlcXVlc3QaPi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZGlyZWN0X3VybC5EaX'
    'JlY3RVcmxTdWJ0aXRsZVJlc3BvbnNlMAE=');
