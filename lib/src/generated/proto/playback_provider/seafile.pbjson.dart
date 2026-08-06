// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/seafile.proto.

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

@$core.Deprecated('Use seafileHlsResourceKindDescriptor instead')
const SeafileHlsResourceKind$json = {
  '1': 'SeafileHlsResourceKind',
  '2': [
    {'1': 'SEAFILE_HLS_RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SEAFILE_HLS_RESOURCE_KIND_MEDIA', '2': 1},
    {'1': 'SEAFILE_HLS_RESOURCE_KIND_MANIFEST', '2': 2},
  ],
};

/// Descriptor for `SeafileHlsResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List seafileHlsResourceKindDescriptor = $convert.base64Decode(
    'ChZTZWFmaWxlSGxzUmVzb3VyY2VLaW5kEikKJVNFQUZJTEVfSExTX1JFU09VUkNFX0tJTkRfVU'
    '5TUEVDSUZJRUQQABIjCh9TRUFGSUxFX0hMU19SRVNPVVJDRV9LSU5EX01FRElBEAESJgoiU0VB'
    'RklMRV9ITFNfUkVTT1VSQ0VfS0lORF9NQU5JRkVTVBAC');

@$core.Deprecated('Use getSeafileResourceRequestDescriptor instead')
const GetSeafileResourceRequest$json = {
  '1': 'GetSeafileResourceRequest',
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

/// Descriptor for `GetSeafileResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSeafileResourceRequestDescriptor = $convert.base64Decode(
    'ChlHZXRTZWFmaWxlUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9p'
    'bmRleBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZW'
    'FkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use seafileResourceResponseDescriptor instead')
const SeafileResourceResponse$json = {
  '1': 'SeafileResourceResponse',
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

/// Descriptor for `SeafileResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileResourceResponseDescriptor =
    $convert.base64Decode(
        'ChdTZWFmaWxlUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getSeafileHlsManifestRequestDescriptor instead')
const GetSeafileHlsManifestRequest$json = {
  '1': 'GetSeafileHlsManifestRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 3, '4': 1, '5': 13, '10': 'mediaIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'head', '3': 8, '4': 1, '5': 8, '10': 'head'},
  ],
};

/// Descriptor for `GetSeafileHlsManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSeafileHlsManifestRequestDescriptor = $convert.base64Decode(
    'ChxHZXRTZWFmaWxlSGxzTWFuaWZlc3RSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEA'
    'FSB3ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRp'
    'YV9pbmRleBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCg'
    'N1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNl'
    'eHAYByABKANSA2V4cBISCgRoZWFkGAggASgIUgRoZWFk');

@$core.Deprecated('Use seafileHlsManifestResponseDescriptor instead')
const SeafileHlsManifestResponse$json = {
  '1': 'SeafileHlsManifestResponse',
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

/// Descriptor for `SeafileHlsManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileHlsManifestResponseDescriptor =
    $convert.base64Decode(
        'ChpTZWFmaWxlSGxzTWFuaWZlc3RSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbG'
        'F5YmFja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getSeafileHlsResourceRequestDescriptor instead')
const GetSeafileHlsResourceRequest$json = {
  '1': 'GetSeafileHlsResourceRequest',
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
      '6': '.synctv.playback_provider.seafile.SeafileHlsResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetSeafileHlsResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSeafileHlsResourceRequestDescriptor = $convert.base64Decode(
    'ChxHZXRTZWFmaWxlSGxzUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEA'
    'FSB3ZlcnNpb24SJgoKdGFyZ2V0X3VybBgCIAEoCUIHukgEcgIQAVIJdGFyZ2V0VXJsEhkKA3Np'
    'ZxgDIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZB'
    'gFIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABS'
    'BXJhbmdliAEBEhIKBGhlYWQYCCABKAhSBGhlYWQSJAoJbW9kZV9uYW1lGAkgASgJQge6SARyAh'
    'ABUghtb2RlTmFtZRIfCgttZWRpYV9pbmRleBgKIAEoDVIKbWVkaWFJbmRleBJnCg1yZXNvdXJj'
    'ZV9raW5kGAsgASgOMjguc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnNlYWZpbGUuU2VhZmlsZU'
    'hsc1Jlc291cmNlS2luZEIIukgFggECEAFSDHJlc291cmNlS2luZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use seafileHlsResourceResponseDescriptor instead')
const SeafileHlsResourceResponse$json = {
  '1': 'SeafileHlsResourceResponse',
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

/// Descriptor for `SeafileHlsResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileHlsResourceResponseDescriptor =
    $convert.base64Decode(
        'ChpTZWFmaWxlSGxzUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbG'
        'F5YmFja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getSeafileSubtitleRequestDescriptor instead')
const GetSeafileSubtitleRequest$json = {
  '1': 'GetSeafileSubtitleRequest',
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

/// Descriptor for `GetSeafileSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSeafileSubtitleRequestDescriptor = $convert.base64Decode(
    'ChlHZXRTZWFmaWxlU3VidGl0bGVSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIlCg5zdWJ0aXRs'
    'ZV9pbmRleBgDIAEoDVINc3VidGl0bGVJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZx'
    'IZCgN1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQ'
    'CgNleHAYByABKANSA2V4cA==');

@$core.Deprecated('Use seafileSubtitleResponseDescriptor instead')
const SeafileSubtitleResponse$json = {
  '1': 'SeafileSubtitleResponse',
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

/// Descriptor for `SeafileSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seafileSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChdTZWFmaWxlU3VidGl0bGVSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

const $core.Map<$core.String, $core.dynamic>
    SeafilePlaybackProviderServiceBase$json = {
  '1': 'SeafilePlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.seafile.GetSeafileResourceRequest',
      '3': '.synctv.playback_provider.seafile.SeafileResourceResponse',
      '6': true
    },
    {
      '1': 'GetHlsManifest',
      '2': '.synctv.playback_provider.seafile.GetSeafileHlsManifestRequest',
      '3': '.synctv.playback_provider.seafile.SeafileHlsManifestResponse',
      '6': true
    },
    {
      '1': 'GetHlsResource',
      '2': '.synctv.playback_provider.seafile.GetSeafileHlsResourceRequest',
      '3': '.synctv.playback_provider.seafile.SeafileHlsResourceResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.seafile.GetSeafileSubtitleRequest',
      '3': '.synctv.playback_provider.seafile.SeafileSubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use seafilePlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SeafilePlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.seafile.GetSeafileResourceRequest':
      GetSeafileResourceRequest$json,
  '.synctv.playback_provider.seafile.SeafileResourceResponse':
      SeafileResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.seafile.GetSeafileHlsManifestRequest':
      GetSeafileHlsManifestRequest$json,
  '.synctv.playback_provider.seafile.SeafileHlsManifestResponse':
      SeafileHlsManifestResponse$json,
  '.synctv.playback_provider.seafile.GetSeafileHlsResourceRequest':
      GetSeafileHlsResourceRequest$json,
  '.synctv.playback_provider.seafile.SeafileHlsResourceResponse':
      SeafileHlsResourceResponse$json,
  '.synctv.playback_provider.seafile.GetSeafileSubtitleRequest':
      GetSeafileSubtitleRequest$json,
  '.synctv.playback_provider.seafile.SeafileSubtitleResponse':
      SeafileSubtitleResponse$json,
};

/// Descriptor for `SeafilePlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List seafilePlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch5TZWFmaWxlUGxheWJhY2tQcm92aWRlclNlcnZpY2UShwEKC0dldFJlc291cmNlEjsuc3luY3'
    'R2LnBsYXliYWNrX3Byb3ZpZGVyLnNlYWZpbGUuR2V0U2VhZmlsZVJlc291cmNlUmVxdWVzdBo5'
    'LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5zZWFmaWxlLlNlYWZpbGVSZXNvdXJjZVJlc3Bvbn'
    'NlMAESkAEKDkdldEhsc01hbmlmZXN0Ej4uc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnNlYWZp'
    'bGUuR2V0U2VhZmlsZUhsc01hbmlmZXN0UmVxdWVzdBo8LnN5bmN0di5wbGF5YmFja19wcm92aW'
    'Rlci5zZWFmaWxlLlNlYWZpbGVIbHNNYW5pZmVzdFJlc3BvbnNlMAESkAEKDkdldEhsc1Jlc291'
    'cmNlEj4uc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnNlYWZpbGUuR2V0U2VhZmlsZUhsc1Jlc2'
    '91cmNlUmVxdWVzdBo8LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5zZWFmaWxlLlNlYWZpbGVI'
    'bHNSZXNvdXJjZVJlc3BvbnNlMAEShwEKC0dldFN1YnRpdGxlEjsuc3luY3R2LnBsYXliYWNrX3'
    'Byb3ZpZGVyLnNlYWZpbGUuR2V0U2VhZmlsZVN1YnRpdGxlUmVxdWVzdBo5LnN5bmN0di5wbGF5'
    'YmFja19wcm92aWRlci5zZWFmaWxlLlNlYWZpbGVTdWJ0aXRsZVJlc3BvbnNlMAE=');
