// This is a generated file - do not edit.
//
// Generated from proto/providers/douyin.proto.

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

@$core.Deprecated('Use mediaKindDescriptor instead')
const MediaKind$json = {
  '1': 'MediaKind',
  '2': [
    {'1': 'MEDIA_KIND_UNSPECIFIED', '2': 0},
    {'1': 'MEDIA_KIND_VIDEO', '2': 1},
    {'1': 'MEDIA_KIND_LIVE', '2': 2},
  ],
};

/// Descriptor for `MediaKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaKindDescriptor = $convert.base64Decode(
    'CglNZWRpYUtpbmQSGgoWTUVESUFfS0lORF9VTlNQRUNJRklFRBAAEhQKEE1FRElBX0tJTkRfVk'
    'lERU8QARITCg9NRURJQV9LSU5EX0xJVkUQAg==');

@$core.Deprecated('Use streamFormatDescriptor instead')
const StreamFormat$json = {
  '1': 'StreamFormat',
  '2': [
    {'1': 'STREAM_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'STREAM_FORMAT_MP4', '2': 1},
    {'1': 'STREAM_FORMAT_FLV', '2': 2},
    {'1': 'STREAM_FORMAT_HLS', '2': 3},
    {'1': 'STREAM_FORMAT_DASH', '2': 4},
    {'1': 'STREAM_FORMAT_CMAF', '2': 5},
    {'1': 'STREAM_FORMAT_LL_HLS', '2': 6},
    {'1': 'STREAM_FORMAT_HTTP_TS', '2': 7},
  ],
};

/// Descriptor for `StreamFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List streamFormatDescriptor = $convert.base64Decode(
    'CgxTdHJlYW1Gb3JtYXQSHQoZU1RSRUFNX0ZPUk1BVF9VTlNQRUNJRklFRBAAEhUKEVNUUkVBTV'
    '9GT1JNQVRfTVA0EAESFQoRU1RSRUFNX0ZPUk1BVF9GTFYQAhIVChFTVFJFQU1fRk9STUFUX0hM'
    'UxADEhYKElNUUkVBTV9GT1JNQVRfREFTSBAEEhYKElNUUkVBTV9GT1JNQVRfQ01BRhAFEhgKFF'
    'NUUkVBTV9GT1JNQVRfTExfSExTEAYSGQoVU1RSRUFNX0ZPUk1BVF9IVFRQX1RTEAc=');

@$core.Deprecated('Use bindRequestDescriptor instead')
const BindRequest$json = {
  '1': 'BindRequest',
  '2': [
    {'1': 'label', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'label'},
    {'1': 'cookie', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'cookie'},
    {'1': 'instance_name', '3': 3, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `BindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindRequestDescriptor = $convert.base64Decode(
    'CgtCaW5kUmVxdWVzdBIdCgVsYWJlbBgBIAEoCUIHukgEcgIQAVIFbGFiZWwSHwoGY29va2llGA'
    'IgASgJQge6SARyAhABUgZjb29raWUSIwoNaW5zdGFuY2VfbmFtZRgDIAEoCVIMaW5zdGFuY2VO'
    'YW1l');

@$core.Deprecated('Use bindResponseDescriptor instead')
const BindResponse$json = {
  '1': 'BindResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
  ],
};

/// Descriptor for `BindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindResponseDescriptor = $convert.base64Decode(
    'CgxCaW5kUmVzcG9uc2USGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZA==');

@$core.Deprecated('Use getBindsRequestDescriptor instead')
const GetBindsRequest$json = {
  '1': 'GetBindsRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `GetBindsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCaW5kc1JlcXVlc3QSIwoNaW5zdGFuY2VfbmFtZRgBIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.douyin.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjYKBWJpbmRzGAEgAygLMiAuc3luY3R2LnByb3ZpZGVyLmRvdX'
    'lpbi5CaW5kSW5mb1IFYmluZHM=');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'has_cookie', '3': 4, '4': 1, '5': 8, '10': 'hasCookie'},
    {'1': 'created_at', '3': 5, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IUCgVsYWJlbBgDIAEoCVIFbGFiZWwSHQoKaGFzX2Nvb2tpZRgEIAEoCFIJaGFzQ29va2llEh0K'
    'CmNyZWF0ZWRfYXQYBSABKANSCWNyZWF0ZWRBdBI0ChZwcm92aWRlcl9pbnN0YW5jZV9uYW1lGA'
    'YgASgJUhRwcm92aWRlckluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use unbindRequestDescriptor instead')
const UnbindRequest$json = {
  '1': 'UnbindRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
  ],
};

/// Descriptor for `UnbindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbindRequestDescriptor = $convert.base64Decode(
    'Cg1VbmJpbmRSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySWQ=');

@$core.Deprecated('Use unbindResponseDescriptor instead')
const UnbindResponse$json = {
  '1': 'UnbindResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 8, '10': 'removed'},
  ],
};

/// Descriptor for `UnbindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbindResponseDescriptor = $convert
    .base64Decode('Cg5VbmJpbmRSZXNwb25zZRIYCgdyZW1vdmVkGAEgASgIUgdyZW1vdmVk');

@$core.Deprecated('Use resolveRequestDescriptor instead')
const ResolveRequest$json = {
  '1': 'ResolveRequest',
  '2': [
    {'1': 'resource', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'resource'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 3, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `ResolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveRequestDescriptor = $convert.base64Decode(
    'Cg5SZXNvbHZlUmVxdWVzdBIjCghyZXNvdXJjZRgBIAEoCUIHukgEcgIQAVIIcmVzb3VyY2USIw'
    'oNaW5zdGFuY2VfbmFtZRgCIAEoCVIMaW5zdGFuY2VOYW1lEhYKBnNoYXJlZBgDIAEoCFIGc2hh'
    'cmVk');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'width', '3': 2, '4': 1, '5': 13, '9': 0, '10': 'width', '17': true},
    {
      '1': 'height',
      '3': 3,
      '4': 1,
      '5': 13,
      '9': 1,
      '10': 'height',
      '17': true
    },
  ],
  '8': [
    {'1': '_width'},
    {'1': '_height'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIQCgN1cmwYASABKAlSA3VybBIZCgV3aWR0aBgCIAEoDUgAUgV3aWR0aIgBARIbCg'
    'ZoZWlnaHQYAyABKA1IAVIGaGVpZ2h0iAEBQggKBl93aWR0aEIJCgdfaGVpZ2h0');

@$core.Deprecated('Use authorDescriptor instead')
const Author$json = {
  '1': 'Author',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'sec_uid', '3': 2, '4': 1, '5': 9, '10': 'secUid'},
    {
      '1': 'unique_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'uniqueId',
      '17': true
    },
    {'1': 'nickname', '3': 4, '4': 1, '5': 9, '10': 'nickname'},
    {
      '1': 'avatar',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Image',
      '9': 1,
      '10': 'avatar',
      '17': true
    },
  ],
  '8': [
    {'1': '_unique_id'},
    {'1': '_avatar'},
  ],
};

/// Descriptor for `Author`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorDescriptor = $convert.base64Decode(
    'CgZBdXRob3ISDgoCaWQYASABKAlSAmlkEhcKB3NlY191aWQYAiABKAlSBnNlY1VpZBIgCgl1bm'
    'lxdWVfaWQYAyABKAlIAFIIdW5pcXVlSWSIAQESGgoIbmlja25hbWUYBCABKAlSCG5pY2tuYW1l'
    'EjoKBmF2YXRhchgFIAEoCzIdLnN5bmN0di5wcm92aWRlci5kb3V5aW4uSW1hZ2VIAVIGYXZhdG'
    'FyiAEBQgwKCl91bmlxdWVfaWRCCQoHX2F2YXRhcg==');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.douyin.MediaKind',
      '10': 'kind'
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'author',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Author',
      '10': 'author'
    },
    {
      '1': 'cover',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Image',
      '9': 0,
      '10': 'cover',
      '17': true
    },
    {
      '1': 'dynamic_cover',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Image',
      '9': 1,
      '10': 'dynamicCover',
      '17': true
    },
    {
      '1': 'duration_ms',
      '3': 8,
      '4': 1,
      '5': 4,
      '9': 2,
      '10': 'durationMs',
      '17': true
    },
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'createdAt',
      '17': true
    },
    {'1': 'is_live', '3': 10, '4': 1, '5': 8, '10': 'isLive'},
    {
      '1': 'view_count',
      '3': 11,
      '4': 1,
      '5': 4,
      '9': 4,
      '10': 'viewCount',
      '17': true
    },
    {
      '1': 'like_count',
      '3': 12,
      '4': 1,
      '5': 4,
      '9': 5,
      '10': 'likeCount',
      '17': true
    },
    {
      '1': 'comment_count',
      '3': 13,
      '4': 1,
      '5': 4,
      '9': 6,
      '10': 'commentCount',
      '17': true
    },
    {
      '1': 'share_count',
      '3': 14,
      '4': 1,
      '5': 4,
      '9': 7,
      '10': 'shareCount',
      '17': true
    },
    {
      '1': 'collect_count',
      '3': 15,
      '4': 1,
      '5': 4,
      '9': 8,
      '10': 'collectCount',
      '17': true
    },
    {
      '1': 'music_title',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 9,
      '10': 'musicTitle',
      '17': true
    },
    {
      '1': 'music_author',
      '3': 17,
      '4': 1,
      '5': 9,
      '9': 10,
      '10': 'musicAuthor',
      '17': true
    },
  ],
  '8': [
    {'1': '_cover'},
    {'1': '_dynamic_cover'},
    {'1': '_duration_ms'},
    {'1': '_created_at'},
    {'1': '_view_count'},
    {'1': '_like_count'},
    {'1': '_comment_count'},
    {'1': '_share_count'},
    {'1': '_collect_count'},
    {'1': '_music_title'},
    {'1': '_music_author'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIOCgJpZBgBIAEoCVICaWQSNQoEa2luZBgCIAEoDjIhLnN5bmN0di5wcm92aW'
    'Rlci5kb3V5aW4uTWVkaWFLaW5kUgRraW5kEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIgCgtkZXNj'
    'cmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SNgoGYXV0aG9yGAUgASgLMh4uc3luY3R2LnByb3'
    'ZpZGVyLmRvdXlpbi5BdXRob3JSBmF1dGhvchI4CgVjb3ZlchgGIAEoCzIdLnN5bmN0di5wcm92'
    'aWRlci5kb3V5aW4uSW1hZ2VIAFIFY292ZXKIAQESRwoNZHluYW1pY19jb3ZlchgHIAEoCzIdLn'
    'N5bmN0di5wcm92aWRlci5kb3V5aW4uSW1hZ2VIAVIMZHluYW1pY0NvdmVyiAEBEiQKC2R1cmF0'
    'aW9uX21zGAggASgESAJSCmR1cmF0aW9uTXOIAQESIgoKY3JlYXRlZF9hdBgJIAEoA0gDUgljcm'
    'VhdGVkQXSIAQESFwoHaXNfbGl2ZRgKIAEoCFIGaXNMaXZlEiIKCnZpZXdfY291bnQYCyABKARI'
    'BFIJdmlld0NvdW50iAEBEiIKCmxpa2VfY291bnQYDCABKARIBVIJbGlrZUNvdW50iAEBEigKDW'
    'NvbW1lbnRfY291bnQYDSABKARIBlIMY29tbWVudENvdW50iAEBEiQKC3NoYXJlX2NvdW50GA4g'
    'ASgESAdSCnNoYXJlQ291bnSIAQESKAoNY29sbGVjdF9jb3VudBgPIAEoBEgIUgxjb2xsZWN0Q2'
    '91bnSIAQESJAoLbXVzaWNfdGl0bGUYECABKAlICVIKbXVzaWNUaXRsZYgBARImCgxtdXNpY19h'
    'dXRob3IYESABKAlIClILbXVzaWNBdXRob3KIAQFCCAoGX2NvdmVyQhAKDl9keW5hbWljX2Nvdm'
    'VyQg4KDF9kdXJhdGlvbl9tc0INCgtfY3JlYXRlZF9hdEINCgtfdmlld19jb3VudEINCgtfbGlr'
    'ZV9jb3VudEIQCg5fY29tbWVudF9jb3VudEIOCgxfc2hhcmVfY291bnRCEAoOX2NvbGxlY3RfY2'
    '91bnRCDgoMX211c2ljX3RpdGxlQg8KDV9tdXNpY19hdXRob3I=');

@$core.Deprecated('Use variantDescriptor instead')
const Variant$json = {
  '1': 'Variant',
  '2': [
    {
      '1': 'format',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.douyin.StreamFormat',
      '10': 'format'
    },
    {'1': 'quality', '3': 2, '4': 1, '5': 9, '10': 'quality'},
    {'1': 'codec', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'codec', '17': true},
    {'1': 'width', '3': 4, '4': 1, '5': 13, '9': 1, '10': 'width', '17': true},
    {
      '1': 'height',
      '3': 5,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'height',
      '17': true
    },
    {'1': 'fps', '3': 6, '4': 1, '5': 13, '9': 3, '10': 'fps', '17': true},
    {
      '1': 'bitrate',
      '3': 7,
      '4': 1,
      '5': 4,
      '9': 4,
      '10': 'bitrate',
      '17': true
    },
    {'1': 'audio_only', '3': 8, '4': 1, '5': 8, '10': 'audioOnly'},
    {'1': 'headers_required', '3': 9, '4': 1, '5': 8, '10': 'headersRequired'},
  ],
  '8': [
    {'1': '_codec'},
    {'1': '_width'},
    {'1': '_height'},
    {'1': '_fps'},
    {'1': '_bitrate'},
  ],
};

/// Descriptor for `Variant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List variantDescriptor = $convert.base64Decode(
    'CgdWYXJpYW50EjwKBmZvcm1hdBgBIAEoDjIkLnN5bmN0di5wcm92aWRlci5kb3V5aW4uU3RyZW'
    'FtRm9ybWF0UgZmb3JtYXQSGAoHcXVhbGl0eRgCIAEoCVIHcXVhbGl0eRIZCgVjb2RlYxgDIAEo'
    'CUgAUgVjb2RlY4gBARIZCgV3aWR0aBgEIAEoDUgBUgV3aWR0aIgBARIbCgZoZWlnaHQYBSABKA'
    '1IAlIGaGVpZ2h0iAEBEhUKA2ZwcxgGIAEoDUgDUgNmcHOIAQESHQoHYml0cmF0ZRgHIAEoBEgE'
    'UgdiaXRyYXRliAEBEh0KCmF1ZGlvX29ubHkYCCABKAhSCWF1ZGlvT25seRIpChBoZWFkZXJzX3'
    'JlcXVpcmVkGAkgASgIUg9oZWFkZXJzUmVxdWlyZWRCCAoGX2NvZGVjQggKBl93aWR0aEIJCgdf'
    'aGVpZ2h0QgYKBF9mcHNCCgoIX2JpdHJhdGU=');

@$core.Deprecated('Use resolveResponseDescriptor instead')
const ResolveResponse$json = {
  '1': 'ResolveResponse',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Metadata',
      '10': 'metadata'
    },
    {
      '1': 'variants',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.douyin.Variant',
      '10': 'variants'
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
    'Cg9SZXNvbHZlUmVzcG9uc2USPAoIbWV0YWRhdGEYASABKAsyIC5zeW5jdHYucHJvdmlkZXIuZG'
    '91eWluLk1ldGFkYXRhUghtZXRhZGF0YRI7Cgh2YXJpYW50cxgCIAMoCzIfLnN5bmN0di5wcm92'
    'aWRlci5kb3V5aW4uVmFyaWFudFIIdmFyaWFudHMSQAoGc291cmNlGAMgASgLMiguc3luY3R2Ln'
    'Byb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listUserPostsRequestDescriptor instead')
const ListUserPostsRequest$json = {
  '1': 'ListUserPostsRequest',
  '2': [
    {'1': 'sec_uid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'secUid'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 5, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListUserPostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserPostsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0VXNlclBvc3RzUmVxdWVzdBIjCgdzZWNfdWlkGAEgASgJQgq6SAdyBRABGIACUgZzZW'
    'NVaWQSGwoGY3Vyc29yGAIgASgJSABSBmN1cnNvcogBARIkCglwYWdlX3NpemUYAyABKA1CB7pI'
    'BCoCGDJSCHBhZ2VTaXplEiMKDWluc3RhbmNlX25hbWUYBCABKAlSDGluc3RhbmNlTmFtZRIWCg'
    'ZzaGFyZWQYBSABKAhSBnNoYXJlZEIJCgdfY3Vyc29y');

@$core.Deprecated('Use listItemDescriptor instead')
const ListItem$json = {
  '1': 'ListItem',
  '2': [
    {'1': 'aweme_id', '3': 1, '4': 1, '5': 9, '10': 'awemeId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'author',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Author',
      '10': 'author'
    },
    {
      '1': 'cover',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.douyin.Image',
      '9': 0,
      '10': 'cover',
      '17': true
    },
    {
      '1': 'duration_ms',
      '3': 5,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'durationMs',
      '17': true
    },
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'createdAt',
      '17': true
    },
    {
      '1': 'source',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_cover'},
    {'1': '_duration_ms'},
    {'1': '_created_at'},
  ],
};

/// Descriptor for `ListItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemDescriptor = $convert.base64Decode(
    'CghMaXN0SXRlbRIZCghhd2VtZV9pZBgBIAEoCVIHYXdlbWVJZBIUCgV0aXRsZRgCIAEoCVIFdG'
    'l0bGUSNgoGYXV0aG9yGAMgASgLMh4uc3luY3R2LnByb3ZpZGVyLmRvdXlpbi5BdXRob3JSBmF1'
    'dGhvchI4CgVjb3ZlchgEIAEoCzIdLnN5bmN0di5wcm92aWRlci5kb3V5aW4uSW1hZ2VIAFIFY2'
    '92ZXKIAQESJAoLZHVyYXRpb25fbXMYBSABKARIAVIKZHVyYXRpb25Nc4gBARIiCgpjcmVhdGVk'
    'X2F0GAYgASgDSAJSCWNyZWF0ZWRBdIgBARJACgZzb3VyY2UYByABKAsyKC5zeW5jdHYucHJvdm'
    'lkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZUIICgZfY292ZXJCDgoMX2R1cmF0'
    'aW9uX21zQg0KC19jcmVhdGVkX2F0');

@$core.Deprecated('Use listUserPostsResponseDescriptor instead')
const ListUserPostsResponse$json = {
  '1': 'ListUserPostsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.douyin.ListItem',
      '10': 'items'
    },
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'source',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListUserPostsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserPostsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0VXNlclBvc3RzUmVzcG9uc2USNgoFaXRlbXMYASADKAsyIC5zeW5jdHYucHJvdmlkZX'
    'IuZG91eWluLkxpc3RJdGVtUgVpdGVtcxIbCgZjdXJzb3IYAiABKAlIAFIGY3Vyc29yiAEBEhkK'
    'CGhhc19tb3JlGAMgASgIUgdoYXNNb3JlEkAKBnNvdXJjZRgEIAEoCzIoLnN5bmN0di5wcm92aW'
    'Rlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNlQgkKB19jdXJzb3I=');
