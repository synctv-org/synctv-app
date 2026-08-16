// This is a generated file - do not edit.
//
// Generated from proto/providers/huya.proto.

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

@$core.Deprecated('Use resourceKindDescriptor instead')
const ResourceKind$json = {
  '1': 'ResourceKind',
  '2': [
    {'1': 'RESOURCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'RESOURCE_KIND_LIVE', '2': 1},
    {'1': 'RESOURCE_KIND_VIDEO', '2': 2},
  ],
};

/// Descriptor for `ResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceKindDescriptor = $convert.base64Decode(
    'CgxSZXNvdXJjZUtpbmQSHQoZUkVTT1VSQ0VfS0lORF9VTlNQRUNJRklFRBAAEhYKElJFU09VUk'
    'NFX0tJTkRfTElWRRABEhcKE1JFU09VUkNFX0tJTkRfVklERU8QAg==');

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

@$core.Deprecated('Use resolveRequestDescriptor instead')
const ResolveRequest$json = {
  '1': 'ResolveRequest',
  '2': [
    {'1': 'resource', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'resource'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ResolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveRequestDescriptor = $convert.base64Decode(
    'Cg5SZXNvbHZlUmVxdWVzdBIjCghyZXNvdXJjZRgBIAEoCUIHukgEcgIQAVIIcmVzb3VyY2USIw'
    'oNaW5zdGFuY2VfbmFtZRgCIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {
      '1': 'author_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'authorId',
      '17': true
    },
    {
      '1': 'category',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'category',
      '17': true
    },
    {
      '1': 'thumbnail_url',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'thumbnailUrl',
      '17': true
    },
    {
      '1': 'avatar_url',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'avatarUrl',
      '17': true
    },
    {'1': 'is_live', '3': 8, '4': 1, '5': 8, '10': 'isLive'},
    {
      '1': 'description',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'description',
      '17': true
    },
    {
      '1': 'duration_seconds',
      '3': 10,
      '4': 1,
      '5': 4,
      '9': 5,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'view_count',
      '3': 11,
      '4': 1,
      '5': 4,
      '9': 6,
      '10': 'viewCount',
      '17': true
    },
    {
      '1': 'comment_count',
      '3': 12,
      '4': 1,
      '5': 4,
      '9': 7,
      '10': 'commentCount',
      '17': true
    },
    {
      '1': 'like_count',
      '3': 13,
      '4': 1,
      '5': 4,
      '9': 8,
      '10': 'likeCount',
      '17': true
    },
    {
      '1': 'published_at',
      '3': 14,
      '4': 1,
      '5': 3,
      '9': 9,
      '10': 'publishedAt',
      '17': true
    },
  ],
  '8': [
    {'1': '_author_id'},
    {'1': '_category'},
    {'1': '_thumbnail_url'},
    {'1': '_avatar_url'},
    {'1': '_description'},
    {'1': '_duration_seconds'},
    {'1': '_view_count'},
    {'1': '_comment_count'},
    {'1': '_like_count'},
    {'1': '_published_at'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIOCgJpZBgBIAEoCVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhYKBmF1dG'
    'hvchgDIAEoCVIGYXV0aG9yEiAKCWF1dGhvcl9pZBgEIAEoCUgAUghhdXRob3JJZIgBARIfCghj'
    'YXRlZ29yeRgFIAEoCUgBUghjYXRlZ29yeYgBARIoCg10aHVtYm5haWxfdXJsGAYgASgJSAJSDH'
    'RodW1ibmFpbFVybIgBARIiCgphdmF0YXJfdXJsGAcgASgJSANSCWF2YXRhclVybIgBARIXCgdp'
    'c19saXZlGAggASgIUgZpc0xpdmUSJQoLZGVzY3JpcHRpb24YCSABKAlIBFILZGVzY3JpcHRpb2'
    '6IAQESLgoQZHVyYXRpb25fc2Vjb25kcxgKIAEoBEgFUg9kdXJhdGlvblNlY29uZHOIAQESIgoK'
    'dmlld19jb3VudBgLIAEoBEgGUgl2aWV3Q291bnSIAQESKAoNY29tbWVudF9jb3VudBgMIAEoBE'
    'gHUgxjb21tZW50Q291bnSIAQESIgoKbGlrZV9jb3VudBgNIAEoBEgIUglsaWtlQ291bnSIAQES'
    'JgoMcHVibGlzaGVkX2F0GA4gASgDSAlSC3B1Ymxpc2hlZEF0iAEBQgwKCl9hdXRob3JfaWRCCw'
    'oJX2NhdGVnb3J5QhAKDl90aHVtYm5haWxfdXJsQg0KC19hdmF0YXJfdXJsQg4KDF9kZXNjcmlw'
    'dGlvbkITChFfZHVyYXRpb25fc2Vjb25kc0INCgtfdmlld19jb3VudEIQCg5fY29tbWVudF9jb3'
    'VudEINCgtfbGlrZV9jb3VudEIPCg1fcHVibGlzaGVkX2F0');

@$core.Deprecated('Use qualityDescriptor instead')
const Quality$json = {
  '1': 'Quality',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'cdn', '3': 2, '4': 1, '5': 9, '10': 'cdn'},
    {
      '1': 'format',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.huya.StreamFormat',
      '10': 'format'
    },
    {
      '1': 'bitrate',
      '3': 4,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'bitrate',
      '17': true
    },
    {'1': 'width', '3': 5, '4': 1, '5': 13, '9': 1, '10': 'width', '17': true},
    {
      '1': 'height',
      '3': 6,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'height',
      '17': true
    },
  ],
  '8': [
    {'1': '_bitrate'},
    {'1': '_width'},
    {'1': '_height'},
  ],
};

/// Descriptor for `Quality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityDescriptor = $convert.base64Decode(
    'CgdRdWFsaXR5EhIKBG5hbWUYASABKAlSBG5hbWUSEAoDY2RuGAIgASgJUgNjZG4SOgoGZm9ybW'
    'F0GAMgASgOMiIuc3luY3R2LnByb3ZpZGVyLmh1eWEuU3RyZWFtRm9ybWF0UgZmb3JtYXQSHQoH'
    'Yml0cmF0ZRgEIAEoBEgAUgdiaXRyYXRliAEBEhkKBXdpZHRoGAUgASgNSAFSBXdpZHRoiAEBEh'
    'sKBmhlaWdodBgGIAEoDUgCUgZoZWlnaHSIAQFCCgoIX2JpdHJhdGVCCAoGX3dpZHRoQgkKB19o'
    'ZWlnaHQ=');

@$core.Deprecated('Use resolveResponseDescriptor instead')
const ResolveResponse$json = {
  '1': 'ResolveResponse',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.huya.ResourceKind',
      '10': 'kind'
    },
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.huya.Metadata',
      '10': 'metadata'
    },
    {
      '1': 'qualities',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.huya.Quality',
      '10': 'qualities'
    },
    {
      '1': 'source',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ResolveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveResponseDescriptor = $convert.base64Decode(
    'Cg9SZXNvbHZlUmVzcG9uc2USNgoEa2luZBgBIAEoDjIiLnN5bmN0di5wcm92aWRlci5odXlhLl'
    'Jlc291cmNlS2luZFIEa2luZBI6CghtZXRhZGF0YRgCIAEoCzIeLnN5bmN0di5wcm92aWRlci5o'
    'dXlhLk1ldGFkYXRhUghtZXRhZGF0YRI7CglxdWFsaXRpZXMYAyADKAsyHS5zeW5jdHYucHJvdm'
    'lkZXIuaHV5YS5RdWFsaXR5UglxdWFsaXRpZXMSQAoGc291cmNlGAQgASgLMiguc3luY3R2LnBy'
    'b3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');
