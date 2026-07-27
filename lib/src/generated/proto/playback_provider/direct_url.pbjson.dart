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

@$core.Deprecated('Use directUrlManifestResourceKindDescriptor instead')
const DirectUrlManifestResourceKind$json = {
  '1': 'DirectUrlManifestResourceKind',
  '2': [
    {'1': 'DIRECT_URL_MANIFEST_RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DIRECT_URL_MANIFEST_RESOURCE_KIND_MEDIA', '2': 1},
    {'1': 'DIRECT_URL_MANIFEST_RESOURCE_KIND_MANIFEST', '2': 2},
  ],
};

/// Descriptor for `DirectUrlManifestResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List directUrlManifestResourceKindDescriptor = $convert.base64Decode(
    'Ch1EaXJlY3RVcmxNYW5pZmVzdFJlc291cmNlS2luZBIxCi1ESVJFQ1RfVVJMX01BTklGRVNUX1'
    'JFU09VUkNFX0tJTkRfVU5TUEVDSUZJRUQQABIrCidESVJFQ1RfVVJMX01BTklGRVNUX1JFU09V'
    'UkNFX0tJTkRfTUVESUEQARIuCipESVJFQ1RfVVJMX01BTklGRVNUX1JFU09VUkNFX0tJTkRfTU'
    'FOSUZFU1QQAg==');

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

@$core.Deprecated('Use getDirectUrlHlsResourceRequestDescriptor instead')
const GetDirectUrlHlsResourceRequest$json = {
  '1': 'GetDirectUrlHlsResourceRequest',
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
    {'1': 'url_index', '3': 10, '4': 1, '5': 13, '10': 'urlIndex'},
    {
      '1': 'resource_kind',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.synctv.playback_provider.direct_url.DirectUrlManifestResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetDirectUrlHlsResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlHlsResourceRequestDescriptor = $convert.base64Decode(
    'Ch5HZXREaXJlY3RVcmxIbHNSZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcg'
    'IQAVIHdmVyc2lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoD'
    'c2lnGAMgASgJQge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcm'
    'lkGAUgASgJQge6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlI'
    'AFIFcmFuZ2WIAQESEgoEaGVhZBgIIAEoCFIEaGVhZBIkCgltb2RlX25hbWUYCSABKAlCB7pIBH'
    'ICEAFSCG1vZGVOYW1lEhsKCXVybF9pbmRleBgKIAEoDVIIdXJsSW5kZXgScQoNcmVzb3VyY2Vf'
    'a2luZBgLIAEoDjJCLnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdXJsLkRpcmVjdF'
    'VybE1hbmlmZXN0UmVzb3VyY2VLaW5kQgi6SAWCAQIQAVIMcmVzb3VyY2VLaW5kQggKBl9yYW5n'
    'ZQ==');

@$core.Deprecated('Use directUrlHlsResourceResponseDescriptor instead')
const DirectUrlHlsResourceResponse$json = {
  '1': 'DirectUrlHlsResourceResponse',
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

/// Descriptor for `DirectUrlHlsResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlHlsResourceResponseDescriptor =
    $convert.base64Decode(
        'ChxEaXJlY3RVcmxIbHNSZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2Ln'
        'BsYXliYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getDirectUrlDashManifestRequestDescriptor instead')
const GetDirectUrlDashManifestRequest$json = {
  '1': 'GetDirectUrlDashManifestRequest',
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

/// Descriptor for `GetDirectUrlDashManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlDashManifestRequestDescriptor = $convert.base64Decode(
    'Ch9HZXREaXJlY3RVcmxEYXNoTWFuaWZlc3RSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBH'
    'ICEAFSB3ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIbCgl1'
    'cmxfaW5kZXgYAyABKA1SCHVybEluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3'
    'VpZBgFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4'
    'cBgHIAEoA1IDZXhw');

@$core.Deprecated('Use directUrlDashManifestResponseDescriptor instead')
const DirectUrlDashManifestResponse$json = {
  '1': 'DirectUrlDashManifestResponse',
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

/// Descriptor for `DirectUrlDashManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlDashManifestResponseDescriptor =
    $convert.base64Decode(
        'Ch1EaXJlY3RVcmxEYXNoTWFuaWZlc3RSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di'
        '5wbGF5YmFja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getDirectUrlDashResourceRequestDescriptor instead')
const GetDirectUrlDashResourceRequest$json = {
  '1': 'GetDirectUrlDashResourceRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'url_index', '3': 3, '4': 1, '5': 13, '10': 'urlIndex'},
    {'1': 'scope_url', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'scopeUrl'},
    {'1': 'resource_path', '3': 5, '4': 1, '5': 9, '10': 'resourcePath'},
    {
      '1': 'resource_query',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'resourceQuery',
      '17': true
    },
    {
      '1': 'resource_kind',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.playback_provider.direct_url.DirectUrlManifestResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
    {'1': 'sig', '3': 8, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 9, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 10, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 11, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 12, '4': 1, '5': 9, '9': 1, '10': 'range', '17': true},
    {'1': 'head', '3': 13, '4': 1, '5': 8, '10': 'head'},
  ],
  '8': [
    {'1': '_resource_query'},
    {'1': '_range'},
  ],
};

/// Descriptor for `GetDirectUrlDashResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDirectUrlDashResourceRequestDescriptor = $convert.base64Decode(
    'Ch9HZXREaXJlY3RVcmxEYXNoUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBH'
    'ICEAFSB3ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIbCgl1'
    'cmxfaW5kZXgYAyABKA1SCHVybEluZGV4EiQKCXNjb3BlX3VybBgEIAEoCUIHukgEcgIQAVIIc2'
    'NvcGVVcmwSIwoNcmVzb3VyY2VfcGF0aBgFIAEoCVIMcmVzb3VyY2VQYXRoEioKDnJlc291cmNl'
    'X3F1ZXJ5GAYgASgJSABSDXJlc291cmNlUXVlcnmIAQEScQoNcmVzb3VyY2Vfa2luZBgHIAEoDj'
    'JCLnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdXJsLkRpcmVjdFVybE1hbmlmZXN0'
    'UmVzb3VyY2VLaW5kQgi6SAWCAQIQAVIMcmVzb3VyY2VLaW5kEhkKA3NpZxgIIAEoCUIHukgEcg'
    'IQAVIDc2lnEhkKA3VpZBgJIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgKIAEoCUIHukgEcgIQ'
    'AVIDcmlkEhAKA2V4cBgLIAEoA1IDZXhwEhkKBXJhbmdlGAwgASgJSAFSBXJhbmdliAEBEhIKBG'
    'hlYWQYDSABKAhSBGhlYWRCEQoPX3Jlc291cmNlX3F1ZXJ5QggKBl9yYW5nZQ==');

@$core.Deprecated('Use directUrlDashResourceResponseDescriptor instead')
const DirectUrlDashResourceResponse$json = {
  '1': 'DirectUrlDashResourceResponse',
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

/// Descriptor for `DirectUrlDashResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List directUrlDashResourceResponseDescriptor =
    $convert.base64Decode(
        'Ch1EaXJlY3RVcmxEYXNoUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di'
        '5wbGF5YmFja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

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
      '1': 'GetHlsResource',
      '2':
          '.synctv.playback_provider.direct_url.GetDirectUrlHlsResourceRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlHlsResourceResponse',
      '6': true
    },
    {
      '1': 'GetDashManifest',
      '2':
          '.synctv.playback_provider.direct_url.GetDirectUrlDashManifestRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlDashManifestResponse',
      '6': true
    },
    {
      '1': 'GetDashResource',
      '2':
          '.synctv.playback_provider.direct_url.GetDirectUrlDashResourceRequest',
      '3': '.synctv.playback_provider.direct_url.DirectUrlDashResourceResponse',
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
  '.synctv.playback_provider.direct_url.GetDirectUrlHlsResourceRequest':
      GetDirectUrlHlsResourceRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlHlsResourceResponse':
      DirectUrlHlsResourceResponse$json,
  '.synctv.playback_provider.direct_url.GetDirectUrlDashManifestRequest':
      GetDirectUrlDashManifestRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlDashManifestResponse':
      DirectUrlDashManifestResponse$json,
  '.synctv.playback_provider.direct_url.GetDirectUrlDashResourceRequest':
      GetDirectUrlDashResourceRequest$json,
  '.synctv.playback_provider.direct_url.DirectUrlDashResourceResponse':
      DirectUrlDashResourceResponse$json,
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
    'EpoBCg5HZXRIbHNSZXNvdXJjZRJDLnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdX'
    'JsLkdldERpcmVjdFVybEhsc1Jlc291cmNlUmVxdWVzdBpBLnN5bmN0di5wbGF5YmFja19wcm92'
    'aWRlci5kaXJlY3RfdXJsLkRpcmVjdFVybEhsc1Jlc291cmNlUmVzcG9uc2UwARKdAQoPR2V0RG'
    'FzaE1hbmlmZXN0EkQuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmRpcmVjdF91cmwuR2V0RGly'
    'ZWN0VXJsRGFzaE1hbmlmZXN0UmVxdWVzdBpCLnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaX'
    'JlY3RfdXJsLkRpcmVjdFVybERhc2hNYW5pZmVzdFJlc3BvbnNlMAESnQEKD0dldERhc2hSZXNv'
    'dXJjZRJELnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdXJsLkdldERpcmVjdFVybE'
    'Rhc2hSZXNvdXJjZVJlcXVlc3QaQi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuZGlyZWN0X3Vy'
    'bC5EaXJlY3RVcmxEYXNoUmVzb3VyY2VSZXNwb25zZTABEpEBCgtHZXRTdWJ0aXRsZRJALnN5bm'
    'N0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdXJsLkdldERpcmVjdFVybFN1YnRpdGxlUmVx'
    'dWVzdBo+LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5kaXJlY3RfdXJsLkRpcmVjdFVybFN1Yn'
    'RpdGxlUmVzcG9uc2UwAQ==');
