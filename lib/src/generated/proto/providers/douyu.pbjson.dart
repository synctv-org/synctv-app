// This is a generated file - do not edit.
//
// Generated from proto/providers/douyu.proto.

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

@$core.Deprecated('Use streamFormatDescriptor instead')
const StreamFormat$json = {
  '1': 'StreamFormat',
  '2': [
    {'1': 'STREAM_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'STREAM_FORMAT_FLV', '2': 1},
    {'1': 'STREAM_FORMAT_HLS', '2': 2},
  ],
};

/// Descriptor for `StreamFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List streamFormatDescriptor = $convert.base64Decode(
    'CgxTdHJlYW1Gb3JtYXQSHQoZU1RSRUFNX0ZPUk1BVF9VTlNQRUNJRklFRBAAEhUKEVNUUkVBTV'
    '9GT1JNQVRfRkxWEAESFQoRU1RSRUFNX0ZPUk1BVF9ITFMQAg==');

@$core.Deprecated('Use codecDescriptor instead')
const Codec$json = {
  '1': 'Codec',
  '2': [
    {'1': 'CODEC_UNSPECIFIED', '2': 0},
    {'1': 'CODEC_AVC', '2': 1},
    {'1': 'CODEC_HEVC', '2': 2},
    {'1': 'CODEC_AAC', '2': 3},
  ],
};

/// Descriptor for `Codec`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List codecDescriptor = $convert.base64Decode(
    'CgVDb2RlYxIVChFDT0RFQ19VTlNQRUNJRklFRBAAEg0KCUNPREVDX0FWQxABEg4KCkNPREVDX0'
    'hFVkMQAhINCglDT0RFQ19BQUMQAw==');

@$core.Deprecated('Use resolveRequestDescriptor instead')
const ResolveRequest$json = {
  '1': 'ResolveRequest',
  '2': [
    {'1': 'resource', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'resource'},
  ],
};

/// Descriptor for `ResolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveRequestDescriptor = $convert.base64Decode(
    'Cg5SZXNvbHZlUmVxdWVzdBIjCghyZXNvdXJjZRgBIAEoCUIHukgEcgIQAVIIcmVzb3VyY2U=');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {
      '1': 'category',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'category',
      '17': true
    },
    {
      '1': 'thumbnail_url',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'thumbnailUrl',
      '17': true
    },
    {
      '1': 'avatar_url',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'avatarUrl',
      '17': true
    },
    {'1': 'is_live', '3': 7, '4': 1, '5': 8, '10': 'isLive'},
    {'1': 'is_replay', '3': 8, '4': 1, '5': 8, '10': 'isReplay'},
    {'1': 'is_vip', '3': 9, '4': 1, '5': 8, '10': 'isVip'},
    {
      '1': 'viewer_count',
      '3': 10,
      '4': 1,
      '5': 4,
      '9': 3,
      '10': 'viewerCount',
      '17': true
    },
    {
      '1': 'started_at',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'startedAt',
      '17': true
    },
  ],
  '8': [
    {'1': '_category'},
    {'1': '_thumbnail_url'},
    {'1': '_avatar_url'},
    {'1': '_viewer_count'},
    {'1': '_started_at'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSFAoFdGl0bGUYAiABKAlSBXRpdG'
    'xlEhYKBmF1dGhvchgDIAEoCVIGYXV0aG9yEh8KCGNhdGVnb3J5GAQgASgJSABSCGNhdGVnb3J5'
    'iAEBEigKDXRodW1ibmFpbF91cmwYBSABKAlIAVIMdGh1bWJuYWlsVXJsiAEBEiIKCmF2YXRhcl'
    '91cmwYBiABKAlIAlIJYXZhdGFyVXJsiAEBEhcKB2lzX2xpdmUYByABKAhSBmlzTGl2ZRIbCglp'
    'c19yZXBsYXkYCCABKAhSCGlzUmVwbGF5EhUKBmlzX3ZpcBgJIAEoCFIFaXNWaXASJgoMdmlld2'
    'VyX2NvdW50GAogASgESANSC3ZpZXdlckNvdW50iAEBEiIKCnN0YXJ0ZWRfYXQYCyABKAlIBFIJ'
    'c3RhcnRlZEF0iAEBQgsKCV9jYXRlZ29yeUIQCg5fdGh1bWJuYWlsX3VybEINCgtfYXZhdGFyX3'
    'VybEIPCg1fdmlld2VyX2NvdW50Qg0KC19zdGFydGVkX2F0');

@$core.Deprecated('Use qualityDescriptor instead')
const Quality$json = {
  '1': 'Quality',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'cdn', '3': 2, '4': 1, '5': 9, '10': 'cdn'},
    {'1': 'cdn_name', '3': 3, '4': 1, '5': 9, '10': 'cdnName'},
    {'1': 'rate', '3': 4, '4': 1, '5': 3, '10': 'rate'},
    {
      '1': 'bitrate',
      '3': 5,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'bitrate',
      '17': true
    },
    {
      '1': 'codec',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.douyu.Codec',
      '10': 'codec'
    },
    {
      '1': 'format',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.douyu.StreamFormat',
      '10': 'format'
    },
  ],
  '8': [
    {'1': '_bitrate'},
  ],
};

/// Descriptor for `Quality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityDescriptor = $convert.base64Decode(
    'CgdRdWFsaXR5EhIKBG5hbWUYASABKAlSBG5hbWUSEAoDY2RuGAIgASgJUgNjZG4SGQoIY2RuX2'
    '5hbWUYAyABKAlSB2Nkbk5hbWUSEgoEcmF0ZRgEIAEoA1IEcmF0ZRIdCgdiaXRyYXRlGAUgASgE'
    'SABSB2JpdHJhdGWIAQESMgoFY29kZWMYBiABKA4yHC5zeW5jdHYucHJvdmlkZXIuZG91eXUuQ2'
    '9kZWNSBWNvZGVjEjsKBmZvcm1hdBgHIAEoDjIjLnN5bmN0di5wcm92aWRlci5kb3V5dS5TdHJl'
    'YW1Gb3JtYXRSBmZvcm1hdEIKCghfYml0cmF0ZQ==');

@$core.Deprecated('Use resolveResponseDescriptor instead')
const ResolveResponse$json = {
  '1': 'ResolveResponse',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyu.Metadata',
      '10': 'metadata'
    },
    {
      '1': 'qualities',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.douyu.Quality',
      '10': 'qualities'
    },
    {
      '1': 'source_config',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.DouyuMediaSourceConfig',
      '10': 'sourceConfig'
    },
  ],
};

/// Descriptor for `ResolveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveResponseDescriptor = $convert.base64Decode(
    'Cg9SZXNvbHZlUmVzcG9uc2USOwoIbWV0YWRhdGEYASABKAsyHy5zeW5jdHYucHJvdmlkZXIuZG'
    '91eXUuTWV0YWRhdGFSCG1ldGFkYXRhEjwKCXF1YWxpdGllcxgCIAMoCzIeLnN5bmN0di5wcm92'
    'aWRlci5kb3V5dS5RdWFsaXR5UglxdWFsaXRpZXMSUQoNc291cmNlX2NvbmZpZxgDIAEoCzIsLn'
    'N5bmN0di5zb3VyY2VfY29uZmlnLkRvdXl1TWVkaWFTb3VyY2VDb25maWdSDHNvdXJjZUNvbmZp'
    'Zw==');
