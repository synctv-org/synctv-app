// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/cctv.proto.

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

@$core.Deprecated('Use getCctvResourceRequestDescriptor instead')
const GetCctvResourceRequest$json = {
  '1': 'GetCctvResourceRequest',
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

/// Descriptor for `GetCctvResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCctvResourceRequestDescriptor = $convert.base64Decode(
    'ChZHZXRDY3R2UmVzb3VyY2VSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9pbmRl'
    'eBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBS'
    'ABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYByAB'
    'KANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZWFkQg'
    'gKBl9yYW5nZQ==');

@$core.Deprecated('Use cctvResourceResponseDescriptor instead')
const CctvResourceResponse$json = {
  '1': 'CctvResourceResponse',
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

/// Descriptor for `CctvResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cctvResourceResponseDescriptor = $convert.base64Decode(
    'ChRDY3R2UmVzb3VyY2VSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbGF5YmFja1'
    '9wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getCctvSegmentRequestDescriptor instead')
const GetCctvSegmentRequest$json = {
  '1': 'GetCctvSegmentRequest',
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

/// Descriptor for `GetCctvSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCctvSegmentRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDY3R2U2VnbWVudFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdmVyc2'
    'lvbhImCgp0YXJnZXRfdXJsGAIgASgJQge6SARyAhABUgl0YXJnZXRVcmwSGQoDc2lnGAMgASgJ'
    'Qge6SARyAhABUgNzaWcSGQoDdWlkGAQgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAUgASgJQg'
    'e6SARyAhABUgNyaWQSEAoDZXhwGAYgASgDUgNleHASGQoFcmFuZ2UYByABKAlIAFIFcmFuZ2WI'
    'AQESEgoEaGVhZBgIIAEoCFIEaGVhZEIICgZfcmFuZ2U=');

@$core.Deprecated('Use cctvSegmentResponseDescriptor instead')
const CctvSegmentResponse$json = {
  '1': 'CctvSegmentResponse',
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

/// Descriptor for `CctvSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cctvSegmentResponseDescriptor = $convert.base64Decode(
    'ChNDY3R2U2VnbWVudFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYWNrX3'
    'Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

const $core.Map<$core.String, $core.dynamic>
    CctvPlaybackProviderServiceBase$json = {
  '1': 'CctvPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.cctv.GetCctvResourceRequest',
      '3': '.synctv.playback_provider.cctv.CctvResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.cctv.GetCctvSegmentRequest',
      '3': '.synctv.playback_provider.cctv.CctvSegmentResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use cctvPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CctvPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.cctv.GetCctvResourceRequest':
      GetCctvResourceRequest$json,
  '.synctv.playback_provider.cctv.CctvResourceResponse':
      CctvResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.cctv.GetCctvSegmentRequest':
      GetCctvSegmentRequest$json,
  '.synctv.playback_provider.cctv.CctvSegmentResponse':
      CctvSegmentResponse$json,
};

/// Descriptor for `CctvPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List cctvPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'ChtDY3R2UGxheWJhY2tQcm92aWRlclNlcnZpY2USewoLR2V0UmVzb3VyY2USNS5zeW5jdHYucG'
    'xheWJhY2tfcHJvdmlkZXIuY2N0di5HZXRDY3R2UmVzb3VyY2VSZXF1ZXN0GjMuc3luY3R2LnBs'
    'YXliYWNrX3Byb3ZpZGVyLmNjdHYuQ2N0dlJlc291cmNlUmVzcG9uc2UwARJ4CgpHZXRTZWdtZW'
    '50EjQuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmNjdHYuR2V0Q2N0dlNlZ21lbnRSZXF1ZXN0'
    'GjIuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmNjdHYuQ2N0dlNlZ21lbnRSZXNwb25zZTAB');
