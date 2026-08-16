// This is a generated file - do not edit.
//
// Generated from proto/providers/cctv.proto.

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

@$core.Deprecated('Use streamKindDescriptor instead')
const StreamKind$json = {
  '1': 'StreamKind',
  '2': [
    {'1': 'STREAM_KIND_UNSPECIFIED', '2': 0},
    {'1': 'STREAM_KIND_VIDEO_HLS', '2': 1},
    {'1': 'STREAM_KIND_AUDIO_HLS', '2': 2},
    {'1': 'STREAM_KIND_HTTP', '2': 3},
  ],
};

/// Descriptor for `StreamKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List streamKindDescriptor = $convert.base64Decode(
    'CgpTdHJlYW1LaW5kEhsKF1NUUkVBTV9LSU5EX1VOU1BFQ0lGSUVEEAASGQoVU1RSRUFNX0tJTk'
    'RfVklERU9fSExTEAESGQoVU1RSRUFNX0tJTkRfQVVESU9fSExTEAISFAoQU1RSRUFNX0tJTkRf'
    'SFRUUBAD');

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

@$core.Deprecated('Use chapterDescriptor instead')
const Chapter$json = {
  '1': 'Chapter',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'start_ms', '3': 3, '4': 1, '5': 4, '10': 'startMs'},
    {'1': 'end_ms', '3': 4, '4': 1, '5': 4, '10': 'endMs'},
  ],
};

/// Descriptor for `Chapter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chapterDescriptor = $convert.base64Decode(
    'CgdDaGFwdGVyEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSGQoIc3Rhcn'
    'RfbXMYAyABKARSB3N0YXJ0TXMSFQoGZW5kX21zGAQgASgEUgVlbmRNcw==');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '10': 'videoId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'description',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'description',
      '17': true
    },
    {
      '1': 'uploader',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'uploader',
      '17': true
    },
    {
      '1': 'producer',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'producer',
      '17': true
    },
    {
      '1': 'channel',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'channel',
      '17': true
    },
    {'1': 'column', '3': 7, '4': 1, '5': 9, '9': 4, '10': 'column', '17': true},
    {'1': 'tags', '3': 8, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'thumbnail_url',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'thumbnailUrl',
      '17': true
    },
    {
      '1': 'duration_seconds',
      '3': 10,
      '4': 1,
      '5': 1,
      '9': 6,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'published_at',
      '3': 11,
      '4': 1,
      '5': 3,
      '9': 7,
      '10': 'publishedAt',
      '17': true
    },
    {
      '1': 'chapters',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.cctv.Chapter',
      '10': 'chapters'
    },
    {'1': 'protected', '3': 13, '4': 1, '5': 8, '10': 'protected'},
  ],
  '8': [
    {'1': '_description'},
    {'1': '_uploader'},
    {'1': '_producer'},
    {'1': '_channel'},
    {'1': '_column'},
    {'1': '_thumbnail_url'},
    {'1': '_duration_seconds'},
    {'1': '_published_at'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIZCgh2aWRlb19pZBgBIAEoCVIHdmlkZW9JZBIUCgV0aXRsZRgCIAEoCVIFdG'
    'l0bGUSJQoLZGVzY3JpcHRpb24YAyABKAlIAFILZGVzY3JpcHRpb26IAQESHwoIdXBsb2FkZXIY'
    'BCABKAlIAVIIdXBsb2FkZXKIAQESHwoIcHJvZHVjZXIYBSABKAlIAlIIcHJvZHVjZXKIAQESHQ'
    'oHY2hhbm5lbBgGIAEoCUgDUgdjaGFubmVsiAEBEhsKBmNvbHVtbhgHIAEoCUgEUgZjb2x1bW6I'
    'AQESEgoEdGFncxgIIAMoCVIEdGFncxIoCg10aHVtYm5haWxfdXJsGAkgASgJSAVSDHRodW1ibm'
    'FpbFVybIgBARIuChBkdXJhdGlvbl9zZWNvbmRzGAogASgBSAZSD2R1cmF0aW9uU2Vjb25kc4gB'
    'ARImCgxwdWJsaXNoZWRfYXQYCyABKANIB1ILcHVibGlzaGVkQXSIAQESOQoIY2hhcHRlcnMYDC'
    'ADKAsyHS5zeW5jdHYucHJvdmlkZXIuY2N0di5DaGFwdGVyUghjaGFwdGVycxIcCglwcm90ZWN0'
    'ZWQYDSABKAhSCXByb3RlY3RlZEIOCgxfZGVzY3JpcHRpb25CCwoJX3VwbG9hZGVyQgsKCV9wcm'
    '9kdWNlckIKCghfY2hhbm5lbEIJCgdfY29sdW1uQhAKDl90aHVtYm5haWxfdXJsQhMKEV9kdXJh'
    'dGlvbl9zZWNvbmRzQg8KDV9wdWJsaXNoZWRfYXQ=');

@$core.Deprecated('Use streamDescriptor instead')
const Stream$json = {
  '1': 'Stream',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.cctv.StreamKind',
      '10': 'kind'
    },
  ],
};

/// Descriptor for `Stream`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamDescriptor = $convert.base64Decode(
    'CgZTdHJlYW0SEgoEbmFtZRgBIAEoCVIEbmFtZRI0CgRraW5kGAIgASgOMiAuc3luY3R2LnByb3'
    'ZpZGVyLmNjdHYuU3RyZWFtS2luZFIEa2luZA==');

@$core.Deprecated('Use resolveResponseDescriptor instead')
const ResolveResponse$json = {
  '1': 'ResolveResponse',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.cctv.Metadata',
      '10': 'metadata'
    },
    {
      '1': 'streams',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.cctv.Stream',
      '10': 'streams'
    },
    {
      '1': 'source',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ResolveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveResponseDescriptor = $convert.base64Decode(
    'Cg9SZXNvbHZlUmVzcG9uc2USOgoIbWV0YWRhdGEYASABKAsyHi5zeW5jdHYucHJvdmlkZXIuY2'
    'N0di5NZXRhZGF0YVIIbWV0YWRhdGESNgoHc3RyZWFtcxgCIAMoCzIcLnN5bmN0di5wcm92aWRl'
    'ci5jY3R2LlN0cmVhbVIHc3RyZWFtcxJACgZzb3VyY2UYAyABKAsyKC5zeW5jdHYucHJvdmlkZX'
    'IuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZQ==');
