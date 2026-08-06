// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/qnap.proto.

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

@$core.Deprecated('Use qnapHlsResourceKindDescriptor instead')
const QnapHlsResourceKind$json = {
  '1': 'QnapHlsResourceKind',
  '2': [
    {'1': 'QNAP_HLS_RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'QNAP_HLS_RESOURCE_KIND_MEDIA', '2': 1},
    {'1': 'QNAP_HLS_RESOURCE_KIND_MANIFEST', '2': 2},
  ],
};

/// Descriptor for `QnapHlsResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List qnapHlsResourceKindDescriptor = $convert.base64Decode(
    'ChNRbmFwSGxzUmVzb3VyY2VLaW5kEiYKIlFOQVBfSExTX1JFU09VUkNFX0tJTkRfVU5TUEVDSU'
    'ZJRUQQABIgChxRTkFQX0hMU19SRVNPVVJDRV9LSU5EX01FRElBEAESIwofUU5BUF9ITFNfUkVT'
    'T1VSQ0VfS0lORF9NQU5JRkVTVBAC');

@$core.Deprecated('Use getQnapResourceRequestDescriptor instead')
const GetQnapResourceRequest$json = {
  '1': 'GetQnapResourceRequest',
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

/// Descriptor for `GetQnapResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQnapResourceRequestDescriptor = $convert.base64Decode(
    'ChZHZXRRbmFwUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9pbmRl'
    'eBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBS'
    'ABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYByAB'
    'KANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZWFkQg'
    'gKBl9yYW5nZQ==');

@$core.Deprecated('Use qnapResourceResponseDescriptor instead')
const QnapResourceResponse$json = {
  '1': 'QnapResourceResponse',
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

/// Descriptor for `QnapResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapResourceResponseDescriptor = $convert.base64Decode(
    'ChRRbmFwUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getQnapHlsManifestRequestDescriptor instead')
const GetQnapHlsManifestRequest$json = {
  '1': 'GetQnapHlsManifestRequest',
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

/// Descriptor for `GetQnapHlsManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQnapHlsManifestRequestDescriptor = $convert.base64Decode(
    'ChlHZXRRbmFwSGxzTWFuaWZlc3RSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9p'
    'bmRleBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cBISCgRoZWFkGAggASgIUgRoZWFk');

@$core.Deprecated('Use qnapHlsManifestResponseDescriptor instead')
const QnapHlsManifestResponse$json = {
  '1': 'QnapHlsManifestResponse',
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

/// Descriptor for `QnapHlsManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapHlsManifestResponseDescriptor =
    $convert.base64Decode(
        'ChdRbmFwSGxzTWFuaWZlc3RSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getQnapHlsResourceRequestDescriptor instead')
const GetQnapHlsResourceRequest$json = {
  '1': 'GetQnapHlsResourceRequest',
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
      '6': '.synctv.playback_provider.qnap.QnapHlsResourceKind',
      '8': {},
      '10': 'resourceKind'
    },
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetQnapHlsResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQnapHlsResourceRequestDescriptor = $convert.base64Decode(
    'ChlHZXRRbmFwSGxzUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJgoKdGFyZ2V0X3VybBgCIAEoCUIHukgEcgIQAVIJdGFyZ2V0VXJsEhkKA3NpZxgD'
    'IAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgFIA'
    'EoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABSBXJh'
    'bmdliAEBEhIKBGhlYWQYCCABKAhSBGhlYWQSJAoJbW9kZV9uYW1lGAkgASgJQge6SARyAhABUg'
    'htb2RlTmFtZRIfCgttZWRpYV9pbmRleBgKIAEoDVIKbWVkaWFJbmRleBJhCg1yZXNvdXJjZV9r'
    'aW5kGAsgASgOMjIuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnFuYXAuUW5hcEhsc1Jlc291cm'
    'NlS2luZEIIukgFggECEAFSDHJlc291cmNlS2luZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use qnapHlsResourceResponseDescriptor instead')
const QnapHlsResourceResponse$json = {
  '1': 'QnapHlsResourceResponse',
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

/// Descriptor for `QnapHlsResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapHlsResourceResponseDescriptor =
    $convert.base64Decode(
        'ChdRbmFwSGxzUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getQnapSubtitleRequestDescriptor instead')
const GetQnapSubtitleRequest$json = {
  '1': 'GetQnapSubtitleRequest',
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

/// Descriptor for `GetQnapSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQnapSubtitleRequestDescriptor = $convert.base64Decode(
    'ChZHZXRRbmFwU3VidGl0bGVSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIlCg5zdWJ0aXRsZV9p'
    'bmRleBgDIAEoDVINc3VidGl0bGVJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCg'
    'N1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNl'
    'eHAYByABKANSA2V4cA==');

@$core.Deprecated('Use qnapSubtitleResponseDescriptor instead')
const QnapSubtitleResponse$json = {
  '1': 'QnapSubtitleResponse',
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

/// Descriptor for `QnapSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapSubtitleResponseDescriptor = $convert.base64Decode(
    'ChRRbmFwU3VidGl0bGVSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getQnapThumbnailRequestDescriptor instead')
const GetQnapThumbnailRequest$json = {
  '1': 'GetQnapThumbnailRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'sig', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 5, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetQnapThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQnapThumbnailRequestDescriptor = $convert.base64Decode(
    'ChdHZXRRbmFwVGh1bWJuYWlsUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEhkKA3NpZxgCIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgDIAEoCUIHukgEcgIQAVID'
    'dWlkEhkKA3JpZBgEIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgFIAEoA1IDZXhw');

@$core.Deprecated('Use qnapThumbnailResponseDescriptor instead')
const QnapThumbnailResponse$json = {
  '1': 'QnapThumbnailResponse',
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

/// Descriptor for `QnapThumbnailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qnapThumbnailResponseDescriptor = $convert.base64Decode(
    'ChVRbmFwVGh1bWJuYWlsUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

const $core.Map<$core.String, $core.dynamic>
    QnapPlaybackProviderServiceBase$json = {
  '1': 'QnapPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.qnap.GetQnapResourceRequest',
      '3': '.synctv.playback_provider.qnap.QnapResourceResponse',
      '6': true
    },
    {
      '1': 'GetHlsManifest',
      '2': '.synctv.playback_provider.qnap.GetQnapHlsManifestRequest',
      '3': '.synctv.playback_provider.qnap.QnapHlsManifestResponse',
      '6': true
    },
    {
      '1': 'GetHlsResource',
      '2': '.synctv.playback_provider.qnap.GetQnapHlsResourceRequest',
      '3': '.synctv.playback_provider.qnap.QnapHlsResourceResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.qnap.GetQnapSubtitleRequest',
      '3': '.synctv.playback_provider.qnap.QnapSubtitleResponse',
      '6': true
    },
    {
      '1': 'GetThumbnail',
      '2': '.synctv.playback_provider.qnap.GetQnapThumbnailRequest',
      '3': '.synctv.playback_provider.qnap.QnapThumbnailResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use qnapPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    QnapPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.qnap.GetQnapResourceRequest':
      GetQnapResourceRequest$json,
  '.synctv.playback_provider.qnap.QnapResourceResponse':
      QnapResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.qnap.GetQnapHlsManifestRequest':
      GetQnapHlsManifestRequest$json,
  '.synctv.playback_provider.qnap.QnapHlsManifestResponse':
      QnapHlsManifestResponse$json,
  '.synctv.playback_provider.qnap.GetQnapHlsResourceRequest':
      GetQnapHlsResourceRequest$json,
  '.synctv.playback_provider.qnap.QnapHlsResourceResponse':
      QnapHlsResourceResponse$json,
  '.synctv.playback_provider.qnap.GetQnapSubtitleRequest':
      GetQnapSubtitleRequest$json,
  '.synctv.playback_provider.qnap.QnapSubtitleResponse':
      QnapSubtitleResponse$json,
  '.synctv.playback_provider.qnap.GetQnapThumbnailRequest':
      GetQnapThumbnailRequest$json,
  '.synctv.playback_provider.qnap.QnapThumbnailResponse':
      QnapThumbnailResponse$json,
};

/// Descriptor for `QnapPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List qnapPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChtRbmFwUGxheWJhY2tQcm92aWRlclNlcnZpY2USewoLR2V0UmVzb3VyY2USNS5zeW5jdHYucG'
    'xheWJhY2tfcHJvdmlkZXIucW5hcC5HZXRRbmFwUmVzb3VyY2VSZXF1ZXN0GjMuc3luY3R2LnBs'
    'YXliYWNrX3Byb3ZpZGVyLnFuYXAuUW5hcFJlc291cmNlUmVzcG9uc2UwARKEAQoOR2V0SGxzTW'
    'FuaWZlc3QSOC5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIucW5hcC5HZXRRbmFwSGxzTWFuaWZl'
    'c3RSZXF1ZXN0GjYuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnFuYXAuUW5hcEhsc01hbmlmZX'
    'N0UmVzcG9uc2UwARKEAQoOR2V0SGxzUmVzb3VyY2USOC5zeW5jdHYucGxheWJhY2tfcHJvdmlk'
    'ZXIucW5hcC5HZXRRbmFwSGxzUmVzb3VyY2VSZXF1ZXN0GjYuc3luY3R2LnBsYXliYWNrX3Byb3'
    'ZpZGVyLnFuYXAuUW5hcEhsc1Jlc291cmNlUmVzcG9uc2UwARJ7CgtHZXRTdWJ0aXRsZRI1LnN5'
    'bmN0di5wbGF5YmFja19wcm92aWRlci5xbmFwLkdldFFuYXBTdWJ0aXRsZVJlcXVlc3QaMy5zeW'
    '5jdHYucGxheWJhY2tfcHJvdmlkZXIucW5hcC5RbmFwU3VidGl0bGVSZXNwb25zZTABEn4KDEdl'
    'dFRodW1ibmFpbBI2LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5xbmFwLkdldFFuYXBUaHVtYm'
    '5haWxSZXF1ZXN0GjQuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnFuYXAuUW5hcFRodW1ibmFp'
    'bFJlc3BvbnNlMAE=');
