// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/truenas.proto.

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

@$core.Deprecated('Use getTrueNasResourceRequestDescriptor instead')
const GetTrueNasResourceRequest$json = {
  '1': 'GetTrueNasResourceRequest',
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

/// Descriptor for `GetTrueNasResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTrueNasResourceRequestDescriptor = $convert.base64Decode(
    'ChlHZXRUcnVlTmFzUmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9p'
    'bmRleBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZW'
    'FkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use trueNasResourceResponseDescriptor instead')
const TrueNasResourceResponse$json = {
  '1': 'TrueNasResourceResponse',
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

/// Descriptor for `TrueNasResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trueNasResourceResponseDescriptor =
    $convert.base64Decode(
        'ChdUcnVlTmFzUmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getTrueNasSubtitleRequestDescriptor instead')
const GetTrueNasSubtitleRequest$json = {
  '1': 'GetTrueNasSubtitleRequest',
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

/// Descriptor for `GetTrueNasSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTrueNasSubtitleRequestDescriptor = $convert.base64Decode(
    'ChlHZXRUcnVlTmFzU3VidGl0bGVSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3'
    'ZlcnNpb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIlCg5zdWJ0aXRs'
    'ZV9pbmRleBgDIAEoDVINc3VidGl0bGVJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZx'
    'IZCgN1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQ'
    'CgNleHAYByABKANSA2V4cA==');

@$core.Deprecated('Use trueNasSubtitleResponseDescriptor instead')
const TrueNasSubtitleResponse$json = {
  '1': 'TrueNasSubtitleResponse',
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

/// Descriptor for `TrueNasSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trueNasSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChdUcnVlTmFzU3VidGl0bGVSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5Ym'
        'Fja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

const $core.Map<$core.String, $core.dynamic>
    TrueNasPlaybackProviderServiceBase$json = {
  '1': 'TrueNasPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.truenas.GetTrueNasResourceRequest',
      '3': '.synctv.playback_provider.truenas.TrueNasResourceResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.truenas.GetTrueNasSubtitleRequest',
      '3': '.synctv.playback_provider.truenas.TrueNasSubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use trueNasPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TrueNasPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.truenas.GetTrueNasResourceRequest':
      GetTrueNasResourceRequest$json,
  '.synctv.playback_provider.truenas.TrueNasResourceResponse':
      TrueNasResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.truenas.GetTrueNasSubtitleRequest':
      GetTrueNasSubtitleRequest$json,
  '.synctv.playback_provider.truenas.TrueNasSubtitleResponse':
      TrueNasSubtitleResponse$json,
};

/// Descriptor for `TrueNasPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List trueNasPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch5UcnVlTmFzUGxheWJhY2tQcm92aWRlclNlcnZpY2UShwEKC0dldFJlc291cmNlEjsuc3luY3'
    'R2LnBsYXliYWNrX3Byb3ZpZGVyLnRydWVuYXMuR2V0VHJ1ZU5hc1Jlc291cmNlUmVxdWVzdBo5'
    'LnN5bmN0di5wbGF5YmFja19wcm92aWRlci50cnVlbmFzLlRydWVOYXNSZXNvdXJjZVJlc3Bvbn'
    'NlMAEShwEKC0dldFN1YnRpdGxlEjsuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnRydWVuYXMu'
    'R2V0VHJ1ZU5hc1N1YnRpdGxlUmVxdWVzdBo5LnN5bmN0di5wbGF5YmFja19wcm92aWRlci50cn'
    'VlbmFzLlRydWVOYXNTdWJ0aXRsZVJlc3BvbnNlMAE=');
