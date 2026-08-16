// This is a generated file - do not edit.
//
// Generated from proto/providers/twitch.proto.

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
    {'1': 'RESOURCE_KIND_CHANNEL', '2': 1},
    {'1': 'RESOURCE_KIND_VIDEO', '2': 2},
    {'1': 'RESOURCE_KIND_CLIP', '2': 3},
  ],
};

/// Descriptor for `ResourceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceKindDescriptor = $convert.base64Decode(
    'CgxSZXNvdXJjZUtpbmQSHQoZUkVTT1VSQ0VfS0lORF9VTlNQRUNJRklFRBAAEhkKFVJFU09VUk'
    'NFX0tJTkRfQ0hBTk5FTBABEhcKE1JFU09VUkNFX0tJTkRfVklERU8QAhIWChJSRVNPVVJDRV9L'
    'SU5EX0NMSVAQAw==');

@$core.Deprecated('Use bindRequestDescriptor instead')
const BindRequest$json = {
  '1': 'BindRequest',
  '2': [
    {'1': 'auth_token', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'authToken'},
    {
      '1': 'device_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'deviceId',
      '17': true
    },
    {
      '1': 'client_integrity',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'clientIntegrity',
      '17': true
    },
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_device_id'},
    {'1': '_client_integrity'},
  ],
};

/// Descriptor for `BindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindRequestDescriptor = $convert.base64Decode(
    'CgtCaW5kUmVxdWVzdBImCgphdXRoX3Rva2VuGAEgASgJQge6SARyAhABUglhdXRoVG9rZW4SIA'
    'oJZGV2aWNlX2lkGAIgASgJSABSCGRldmljZUlkiAEBEi4KEGNsaWVudF9pbnRlZ3JpdHkYAyAB'
    'KAlIAVIPY2xpZW50SW50ZWdyaXR5iAEBEiMKDWluc3RhbmNlX25hbWUYBCABKAlSDGluc3Rhbm'
    'NlTmFtZUIMCgpfZGV2aWNlX2lkQhMKEV9jbGllbnRfaW50ZWdyaXR5');

@$core.Deprecated('Use bindResponseDescriptor instead')
const BindResponse$json = {
  '1': 'BindResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'login', '3': 2, '4': 1, '5': 9, '10': 'login'},
    {'1': 'twitch_user_id', '3': 3, '4': 1, '5': 9, '10': 'twitchUserId'},
    {'1': 'client_id', '3': 4, '4': 1, '5': 9, '10': 'clientId'},
    {'1': 'scopes', '3': 5, '4': 3, '5': 9, '10': 'scopes'},
    {
      '1': 'expires_in',
      '3': 6,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'expiresIn',
      '17': true
    },
  ],
  '8': [
    {'1': '_expires_in'},
  ],
};

/// Descriptor for `BindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindResponseDescriptor = $convert.base64Decode(
    'CgxCaW5kUmVzcG9uc2USGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZBIUCgVsb2dpbhgCIA'
    'EoCVIFbG9naW4SJAoOdHdpdGNoX3VzZXJfaWQYAyABKAlSDHR3aXRjaFVzZXJJZBIbCgljbGll'
    'bnRfaWQYBCABKAlSCGNsaWVudElkEhYKBnNjb3BlcxgFIAMoCVIGc2NvcGVzEiIKCmV4cGlyZX'
    'NfaW4YBiABKARIAFIJZXhwaXJlc0luiAEBQg0KC19leHBpcmVzX2lu');

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
      '6': '.synctv.provider.twitch.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjYKBWJpbmRzGAEgAygLMiAuc3luY3R2LnByb3ZpZGVyLnR3aX'
    'RjaC5CaW5kSW5mb1IFYmluZHM=');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'login', '3': 3, '4': 1, '5': 9, '10': 'login'},
    {'1': 'twitch_user_id', '3': 4, '4': 1, '5': 9, '10': 'twitchUserId'},
    {'1': 'client_id', '3': 5, '4': 1, '5': 9, '10': 'clientId'},
    {'1': 'scopes', '3': 6, '4': 3, '5': 9, '10': 'scopes'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IUCgVsb2dpbhgDIAEoCVIFbG9naW4SJAoOdHdpdGNoX3VzZXJfaWQYBCABKAlSDHR3aXRjaFVz'
    'ZXJJZBIbCgljbGllbnRfaWQYBSABKAlSCGNsaWVudElkEhYKBnNjb3BlcxgGIAMoCVIGc2NvcG'
    'VzEh0KCmNyZWF0ZWRfYXQYByABKANSCWNyZWF0ZWRBdBI0ChZwcm92aWRlcl9pbnN0YW5jZV9u'
    'YW1lGAggASgJUhRwcm92aWRlckluc3RhbmNlTmFtZQ==');

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

@$core.Deprecated('Use chapterDescriptor instead')
const Chapter$json = {
  '1': 'Chapter',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'start_seconds', '3': 2, '4': 1, '5': 4, '10': 'startSeconds'},
    {'1': 'end_seconds', '3': 3, '4': 1, '5': 4, '10': 'endSeconds'},
  ],
};

/// Descriptor for `Chapter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chapterDescriptor = $convert.base64Decode(
    'CgdDaGFwdGVyEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIjCg1zdGFydF9zZWNvbmRzGAIgASgEUg'
    'xzdGFydFNlY29uZHMSHwoLZW5kX3NlY29uZHMYAyABKARSCmVuZFNlY29uZHM=');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
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
    {'1': 'is_live', '3': 6, '4': 1, '5': 8, '10': 'isLive'},
    {
      '1': 'description',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'description',
      '17': true
    },
    {
      '1': 'duration_seconds',
      '3': 8,
      '4': 1,
      '5': 4,
      '9': 3,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'view_count',
      '3': 9,
      '4': 1,
      '5': 4,
      '9': 4,
      '10': 'viewCount',
      '17': true
    },
    {
      '1': 'published_at',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'publishedAt',
      '17': true
    },
    {
      '1': 'chapters',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.Chapter',
      '10': 'chapters'
    },
  ],
  '8': [
    {'1': '_category'},
    {'1': '_thumbnail_url'},
    {'1': '_description'},
    {'1': '_duration_seconds'},
    {'1': '_view_count'},
    {'1': '_published_at'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIOCgJpZBgBIAEoCVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhYKBmF1dG'
    'hvchgDIAEoCVIGYXV0aG9yEh8KCGNhdGVnb3J5GAQgASgJSABSCGNhdGVnb3J5iAEBEigKDXRo'
    'dW1ibmFpbF91cmwYBSABKAlIAVIMdGh1bWJuYWlsVXJsiAEBEhcKB2lzX2xpdmUYBiABKAhSBm'
    'lzTGl2ZRIlCgtkZXNjcmlwdGlvbhgHIAEoCUgCUgtkZXNjcmlwdGlvbogBARIuChBkdXJhdGlv'
    'bl9zZWNvbmRzGAggASgESANSD2R1cmF0aW9uU2Vjb25kc4gBARIiCgp2aWV3X2NvdW50GAkgAS'
    'gESARSCXZpZXdDb3VudIgBARImCgxwdWJsaXNoZWRfYXQYCiABKAlIBVILcHVibGlzaGVkQXSI'
    'AQESOwoIY2hhcHRlcnMYCyADKAsyHy5zeW5jdHYucHJvdmlkZXIudHdpdGNoLkNoYXB0ZXJSCG'
    'NoYXB0ZXJzQgsKCV9jYXRlZ29yeUIQCg5fdGh1bWJuYWlsX3VybEIOCgxfZGVzY3JpcHRpb25C'
    'EwoRX2R1cmF0aW9uX3NlY29uZHNCDQoLX3ZpZXdfY291bnRCDwoNX3B1Ymxpc2hlZF9hdA==');

@$core.Deprecated('Use qualityDescriptor instead')
const Quality$json = {
  '1': 'Quality',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'bandwidth',
      '3': 2,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'bandwidth',
      '17': true
    },
    {'1': 'width', '3': 3, '4': 1, '5': 13, '9': 1, '10': 'width', '17': true},
    {
      '1': 'height',
      '3': 4,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'height',
      '17': true
    },
    {
      '1': 'frame_rate',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'frameRate',
      '17': true
    },
    {'1': 'codecs', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'codecs', '17': true},
  ],
  '8': [
    {'1': '_bandwidth'},
    {'1': '_width'},
    {'1': '_height'},
    {'1': '_frame_rate'},
    {'1': '_codecs'},
  ],
};

/// Descriptor for `Quality`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qualityDescriptor = $convert.base64Decode(
    'CgdRdWFsaXR5EhIKBG5hbWUYASABKAlSBG5hbWUSIQoJYmFuZHdpZHRoGAIgASgESABSCWJhbm'
    'R3aWR0aIgBARIZCgV3aWR0aBgDIAEoDUgBUgV3aWR0aIgBARIbCgZoZWlnaHQYBCABKA1IAlIG'
    'aGVpZ2h0iAEBEiIKCmZyYW1lX3JhdGUYBSABKAlIA1IJZnJhbWVSYXRliAEBEhsKBmNvZGVjcx'
    'gGIAEoCUgEUgZjb2RlY3OIAQFCDAoKX2JhbmR3aWR0aEIICgZfd2lkdGhCCQoHX2hlaWdodEIN'
    'CgtfZnJhbWVfcmF0ZUIJCgdfY29kZWNz');

@$core.Deprecated('Use resolveResponseDescriptor instead')
const ResolveResponse$json = {
  '1': 'ResolveResponse',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.twitch.ResourceKind',
      '10': 'kind'
    },
    {
      '1': 'metadata',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.twitch.Metadata',
      '10': 'metadata'
    },
    {
      '1': 'qualities',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.Quality',
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
    'Cg9SZXNvbHZlUmVzcG9uc2USOAoEa2luZBgBIAEoDjIkLnN5bmN0di5wcm92aWRlci50d2l0Y2'
    'guUmVzb3VyY2VLaW5kUgRraW5kEjwKCG1ldGFkYXRhGAIgASgLMiAuc3luY3R2LnByb3ZpZGVy'
    'LnR3aXRjaC5NZXRhZGF0YVIIbWV0YWRhdGESPQoJcXVhbGl0aWVzGAMgAygLMh8uc3luY3R2Ln'
    'Byb3ZpZGVyLnR3aXRjaC5RdWFsaXR5UglxdWFsaXRpZXMSQAoGc291cmNlGAQgASgLMiguc3lu'
    'Y3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listChannelItemsRequestDescriptor instead')
const ListChannelItemsRequest$json = {
  '1': 'ListChannelItemsRequest',
  '2': [
    {'1': 'resource', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'resource'},
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.TwitchPlaylistContent',
      '10': 'content'
    },
    {'1': 'cursor', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 5, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 6, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListChannelItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChannelItemsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Q2hhbm5lbEl0ZW1zUmVxdWVzdBImCghyZXNvdXJjZRgBIAEoCUIKukgHcgUQARiABF'
    'IIcmVzb3VyY2USRQoHY29udGVudBgCIAEoDjIrLnN5bmN0di5zb3VyY2VfY29uZmlnLlR3aXRj'
    'aFBsYXlsaXN0Q29udGVudFIHY29udGVudBIbCgZjdXJzb3IYAyABKAlIAFIGY3Vyc29yiAEBEi'
    'QKCXBhZ2Vfc2l6ZRgEIAEoDUIHukgEKgIYZFIIcGFnZVNpemUSIwoNaW5zdGFuY2VfbmFtZRgF'
    'IAEoCVIMaW5zdGFuY2VOYW1lEhYKBnNoYXJlZBgGIAEoCFIGc2hhcmVkQgkKB19jdXJzb3I=');

@$core.Deprecated('Use listItemDescriptor instead')
const ListItem$json = {
  '1': 'ListItem',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.twitch.ResourceKind',
      '10': 'kind'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'thumbnail_url',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'thumbnailUrl',
      '17': true
    },
    {
      '1': 'duration_seconds',
      '3': 5,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'view_count',
      '3': 6,
      '4': 1,
      '5': 4,
      '9': 2,
      '10': 'viewCount',
      '17': true
    },
    {
      '1': 'published_at',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'publishedAt',
      '17': true
    },
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_thumbnail_url'},
    {'1': '_duration_seconds'},
    {'1': '_view_count'},
    {'1': '_published_at'},
  ],
};

/// Descriptor for `ListItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemDescriptor = $convert.base64Decode(
    'CghMaXN0SXRlbRI4CgRraW5kGAEgASgOMiQuc3luY3R2LnByb3ZpZGVyLnR3aXRjaC5SZXNvdX'
    'JjZUtpbmRSBGtpbmQSDgoCaWQYAiABKAlSAmlkEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIoCg10'
    'aHVtYm5haWxfdXJsGAQgASgJSABSDHRodW1ibmFpbFVybIgBARIuChBkdXJhdGlvbl9zZWNvbm'
    'RzGAUgASgESAFSD2R1cmF0aW9uU2Vjb25kc4gBARIiCgp2aWV3X2NvdW50GAYgASgESAJSCXZp'
    'ZXdDb3VudIgBARImCgxwdWJsaXNoZWRfYXQYByABKAlIA1ILcHVibGlzaGVkQXSIAQESQAoGc2'
    '91cmNlGAggASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZz'
    'b3VyY2VCEAoOX3RodW1ibmFpbF91cmxCEwoRX2R1cmF0aW9uX3NlY29uZHNCDQoLX3ZpZXdfY2'
    '91bnRCDwoNX3B1Ymxpc2hlZF9hdA==');

@$core.Deprecated('Use listChannelItemsResponseDescriptor instead')
const ListChannelItemsResponse$json = {
  '1': 'ListChannelItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.ListItem',
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

/// Descriptor for `ListChannelItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChannelItemsResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0Q2hhbm5lbEl0ZW1zUmVzcG9uc2USNgoFaXRlbXMYASADKAsyIC5zeW5jdHYucHJvdm'
    'lkZXIudHdpdGNoLkxpc3RJdGVtUgVpdGVtcxIbCgZjdXJzb3IYAiABKAlIAFIGY3Vyc29yiAEB'
    'EhkKCGhhc19tb3JlGAMgASgIUgdoYXNNb3JlEkAKBnNvdXJjZRgEIAEoCzIoLnN5bmN0di5wcm'
    '92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNlQgkKB19jdXJzb3I=');

@$core.Deprecated('Use streamItemDescriptor instead')
const StreamItem$json = {
  '1': 'StreamItem',
  '2': [
    {'1': 'stream_id', '3': 1, '4': 1, '5': 9, '10': 'streamId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'channel', '3': 3, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'category_id', '3': 6, '4': 1, '5': 9, '10': 'categoryId'},
    {'1': 'category_name', '3': 7, '4': 1, '5': 9, '10': 'categoryName'},
    {'1': 'thumbnail_url', '3': 8, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'viewer_count', '3': 9, '4': 1, '5': 4, '10': 'viewerCount'},
    {'1': 'started_at', '3': 10, '4': 1, '5': 9, '10': 'startedAt'},
    {'1': 'language', '3': 11, '4': 1, '5': 9, '10': 'language'},
    {'1': 'tags', '3': 12, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'is_mature', '3': 13, '4': 1, '5': 8, '10': 'isMature'},
    {
      '1': 'source',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `StreamItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamItemDescriptor = $convert.base64Decode(
    'CgpTdHJlYW1JdGVtEhsKCXN0cmVhbV9pZBgBIAEoCVIIc3RyZWFtSWQSFwoHdXNlcl9pZBgCIA'
    'EoCVIGdXNlcklkEhgKB2NoYW5uZWwYAyABKAlSB2NoYW5uZWwSIQoMZGlzcGxheV9uYW1lGAQg'
    'ASgJUgtkaXNwbGF5TmFtZRIUCgV0aXRsZRgFIAEoCVIFdGl0bGUSHwoLY2F0ZWdvcnlfaWQYBi'
    'ABKAlSCmNhdGVnb3J5SWQSIwoNY2F0ZWdvcnlfbmFtZRgHIAEoCVIMY2F0ZWdvcnlOYW1lEiMK'
    'DXRodW1ibmFpbF91cmwYCCABKAlSDHRodW1ibmFpbFVybBIhCgx2aWV3ZXJfY291bnQYCSABKA'
    'RSC3ZpZXdlckNvdW50Eh0KCnN0YXJ0ZWRfYXQYCiABKAlSCXN0YXJ0ZWRBdBIaCghsYW5ndWFn'
    'ZRgLIAEoCVIIbGFuZ3VhZ2USEgoEdGFncxgMIAMoCVIEdGFncxIbCglpc19tYXR1cmUYDSABKA'
    'hSCGlzTWF0dXJlEkAKBnNvdXJjZRgOIAEoCzIoLnN5bmN0di5wcm92aWRlci5jb21tb24uRGlz'
    'Y292ZXJlZFNvdXJjZVIGc291cmNl');

@$core.Deprecated('Use listFollowedLiveRequestDescriptor instead')
const ListFollowedLiveRequest$json = {
  '1': 'ListFollowedLiveRequest',
  '2': [
    {'1': 'cursor', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 2, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 3, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 4, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListFollowedLiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFollowedLiveRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Rm9sbG93ZWRMaXZlUmVxdWVzdBIbCgZjdXJzb3IYASABKAlIAFIGY3Vyc29yiAEBEi'
    'QKCXBhZ2Vfc2l6ZRgCIAEoDUIHukgEKgIYZFIIcGFnZVNpemUSIwoNaW5zdGFuY2VfbmFtZRgD'
    'IAEoCVIMaW5zdGFuY2VOYW1lEhYKBnNoYXJlZBgEIAEoCFIGc2hhcmVkQgkKB19jdXJzb3I=');

@$core.Deprecated('Use listFollowedLiveResponseDescriptor instead')
const ListFollowedLiveResponse$json = {
  '1': 'ListFollowedLiveResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.StreamItem',
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

/// Descriptor for `ListFollowedLiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFollowedLiveResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0Rm9sbG93ZWRMaXZlUmVzcG9uc2USOAoFaXRlbXMYASADKAsyIi5zeW5jdHYucHJvdm'
    'lkZXIudHdpdGNoLlN0cmVhbUl0ZW1SBWl0ZW1zEhsKBmN1cnNvchgCIAEoCUgAUgZjdXJzb3KI'
    'AQESGQoIaGFzX21vcmUYAyABKAhSB2hhc01vcmUSQAoGc291cmNlGAQgASgLMiguc3luY3R2Ln'
    'Byb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2VCCQoHX2N1cnNvcg==');

@$core.Deprecated('Use listCategoryStreamsRequestDescriptor instead')
const ListCategoryStreamsRequest$json = {
  '1': 'ListCategoryStreamsRequest',
  '2': [
    {'1': 'category_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'categoryId'},
    {'1': 'category_name', '3': 2, '4': 1, '5': 9, '10': 'categoryName'},
    {'1': 'cursor', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 5, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 6, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListCategoryStreamsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCategoryStreamsRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0Q2F0ZWdvcnlTdHJlYW1zUmVxdWVzdBIoCgtjYXRlZ29yeV9pZBgBIAEoCUIHukgEcg'
    'IQAVIKY2F0ZWdvcnlJZBIjCg1jYXRlZ29yeV9uYW1lGAIgASgJUgxjYXRlZ29yeU5hbWUSGwoG'
    'Y3Vyc29yGAMgASgJSABSBmN1cnNvcogBARIkCglwYWdlX3NpemUYBCABKA1CB7pIBCoCGGRSCH'
    'BhZ2VTaXplEiMKDWluc3RhbmNlX25hbWUYBSABKAlSDGluc3RhbmNlTmFtZRIWCgZzaGFyZWQY'
    'BiABKAhSBnNoYXJlZEIJCgdfY3Vyc29y');

@$core.Deprecated('Use listCategoryStreamsResponseDescriptor instead')
const ListCategoryStreamsResponse$json = {
  '1': 'ListCategoryStreamsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.StreamItem',
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

/// Descriptor for `ListCategoryStreamsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCategoryStreamsResponseDescriptor = $convert.base64Decode(
    'ChtMaXN0Q2F0ZWdvcnlTdHJlYW1zUmVzcG9uc2USOAoFaXRlbXMYASADKAsyIi5zeW5jdHYucH'
    'JvdmlkZXIudHdpdGNoLlN0cmVhbUl0ZW1SBWl0ZW1zEhsKBmN1cnNvchgCIAEoCUgAUgZjdXJz'
    'b3KIAQESGQoIaGFzX21vcmUYAyABKAhSB2hhc01vcmUSQAoGc291cmNlGAQgASgLMiguc3luY3'
    'R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2VCCQoHX2N1cnNvcg==');

@$core.Deprecated('Use categoryItemDescriptor instead')
const CategoryItem$json = {
  '1': 'CategoryItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'box_art_url', '3': 3, '4': 1, '5': 9, '10': 'boxArtUrl'},
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

/// Descriptor for `CategoryItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryItemDescriptor = $convert.base64Decode(
    'CgxDYXRlZ29yeUl0ZW0SDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHgoLYm'
    '94X2FydF91cmwYAyABKAlSCWJveEFydFVybBJACgZzb3VyY2UYBCABKAsyKC5zeW5jdHYucHJv'
    'dmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZQ==');

@$core.Deprecated('Use listTopCategoriesRequestDescriptor instead')
const ListTopCategoriesRequest$json = {
  '1': 'ListTopCategoriesRequest',
  '2': [
    {'1': 'cursor', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 2, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 3, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 4, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListTopCategoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTopCategoriesRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0VG9wQ2F0ZWdvcmllc1JlcXVlc3QSGwoGY3Vyc29yGAEgASgJSABSBmN1cnNvcogBAR'
    'IkCglwYWdlX3NpemUYAiABKA1CB7pIBCoCGGRSCHBhZ2VTaXplEiMKDWluc3RhbmNlX25hbWUY'
    'AyABKAlSDGluc3RhbmNlTmFtZRIWCgZzaGFyZWQYBCABKAhSBnNoYXJlZEIJCgdfY3Vyc29y');

@$core.Deprecated('Use listTopCategoriesResponseDescriptor instead')
const ListTopCategoriesResponse$json = {
  '1': 'ListTopCategoriesResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.CategoryItem',
      '10': 'items'
    },
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListTopCategoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTopCategoriesResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0VG9wQ2F0ZWdvcmllc1Jlc3BvbnNlEjoKBWl0ZW1zGAEgAygLMiQuc3luY3R2LnByb3'
    'ZpZGVyLnR3aXRjaC5DYXRlZ29yeUl0ZW1SBWl0ZW1zEhsKBmN1cnNvchgCIAEoCUgAUgZjdXJz'
    'b3KIAQESGQoIaGFzX21vcmUYAyABKAhSB2hhc01vcmVCCQoHX2N1cnNvcg==');

@$core.Deprecated('Use searchLiveChannelsRequestDescriptor instead')
const SearchLiveChannelsRequest$json = {
  '1': 'SearchLiveChannelsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'query'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 5, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `SearchLiveChannelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchLiveChannelsRequestDescriptor = $convert.base64Decode(
    'ChlTZWFyY2hMaXZlQ2hhbm5lbHNSZXF1ZXN0Eh0KBXF1ZXJ5GAEgASgJQge6SARyAhABUgVxdW'
    'VyeRIbCgZjdXJzb3IYAiABKAlIAFIGY3Vyc29yiAEBEiQKCXBhZ2Vfc2l6ZRgDIAEoDUIHukgE'
    'KgIYZFIIcGFnZVNpemUSIwoNaW5zdGFuY2VfbmFtZRgEIAEoCVIMaW5zdGFuY2VOYW1lEhYKBn'
    'NoYXJlZBgFIAEoCFIGc2hhcmVkQgkKB19jdXJzb3I=');

@$core.Deprecated('Use searchChannelItemDescriptor instead')
const SearchChannelItem$json = {
  '1': 'SearchChannelItem',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'channel', '3': 2, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'category_id', '3': 5, '4': 1, '5': 9, '10': 'categoryId'},
    {'1': 'category_name', '3': 6, '4': 1, '5': 9, '10': 'categoryName'},
    {'1': 'thumbnail_url', '3': 7, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'is_live', '3': 8, '4': 1, '5': 8, '10': 'isLive'},
    {'1': 'started_at', '3': 9, '4': 1, '5': 9, '10': 'startedAt'},
    {'1': 'language', '3': 10, '4': 1, '5': 9, '10': 'language'},
    {'1': 'tags', '3': 11, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'source',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `SearchChannelItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchChannelItemDescriptor = $convert.base64Decode(
    'ChFTZWFyY2hDaGFubmVsSXRlbRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGAoHY2hhbm5lbB'
    'gCIAEoCVIHY2hhbm5lbBIhCgxkaXNwbGF5X25hbWUYAyABKAlSC2Rpc3BsYXlOYW1lEhQKBXRp'
    'dGxlGAQgASgJUgV0aXRsZRIfCgtjYXRlZ29yeV9pZBgFIAEoCVIKY2F0ZWdvcnlJZBIjCg1jYX'
    'RlZ29yeV9uYW1lGAYgASgJUgxjYXRlZ29yeU5hbWUSIwoNdGh1bWJuYWlsX3VybBgHIAEoCVIM'
    'dGh1bWJuYWlsVXJsEhcKB2lzX2xpdmUYCCABKAhSBmlzTGl2ZRIdCgpzdGFydGVkX2F0GAkgAS'
    'gJUglzdGFydGVkQXQSGgoIbGFuZ3VhZ2UYCiABKAlSCGxhbmd1YWdlEhIKBHRhZ3MYCyADKAlS'
    'BHRhZ3MSQAoGc291cmNlGAwgASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3Zlcm'
    'VkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use searchLiveChannelsResponseDescriptor instead')
const SearchLiveChannelsResponse$json = {
  '1': 'SearchLiveChannelsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.SearchChannelItem',
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

/// Descriptor for `SearchLiveChannelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchLiveChannelsResponseDescriptor = $convert.base64Decode(
    'ChpTZWFyY2hMaXZlQ2hhbm5lbHNSZXNwb25zZRI/CgVpdGVtcxgBIAMoCzIpLnN5bmN0di5wcm'
    '92aWRlci50d2l0Y2guU2VhcmNoQ2hhbm5lbEl0ZW1SBWl0ZW1zEhsKBmN1cnNvchgCIAEoCUgA'
    'UgZjdXJzb3KIAQESGQoIaGFzX21vcmUYAyABKAhSB2hhc01vcmUSQAoGc291cmNlGAQgASgLMi'
    'guc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2VCCQoHX2N1'
    'cnNvcg==');

@$core.Deprecated('Use listScheduleRequestDescriptor instead')
const ListScheduleRequest$json = {
  '1': 'ListScheduleRequest',
  '2': [
    {
      '1': 'broadcaster_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'broadcasterId'
    },
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'shared', '3': 5, '4': 1, '5': 8, '10': 'shared'},
  ],
  '8': [
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listScheduleRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0U2NoZWR1bGVSZXF1ZXN0Ei4KDmJyb2FkY2FzdGVyX2lkGAEgASgJQge6SARyAhABUg'
    '1icm9hZGNhc3RlcklkEhsKBmN1cnNvchgCIAEoCUgAUgZjdXJzb3KIAQESJAoJcGFnZV9zaXpl'
    'GAMgASgNQge6SAQqAhgZUghwYWdlU2l6ZRIjCg1pbnN0YW5jZV9uYW1lGAQgASgJUgxpbnN0YW'
    '5jZU5hbWUSFgoGc2hhcmVkGAUgASgIUgZzaGFyZWRCCQoHX2N1cnNvcg==');

@$core.Deprecated('Use scheduleSegmentDescriptor instead')
const ScheduleSegment$json = {
  '1': 'ScheduleSegment',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'start_time', '3': 2, '4': 1, '5': 9, '10': 'startTime'},
    {'1': 'end_time', '3': 3, '4': 1, '5': 9, '10': 'endTime'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'category_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'categoryId',
      '17': true
    },
    {
      '1': 'category_name',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'categoryName',
      '17': true
    },
    {
      '1': 'canceled_until',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'canceledUntil',
      '17': true
    },
    {'1': 'is_recurring', '3': 8, '4': 1, '5': 8, '10': 'isRecurring'},
  ],
  '8': [
    {'1': '_category_id'},
    {'1': '_category_name'},
    {'1': '_canceled_until'},
  ],
};

/// Descriptor for `ScheduleSegment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleSegmentDescriptor = $convert.base64Decode(
    'Cg9TY2hlZHVsZVNlZ21lbnQSDgoCaWQYASABKAlSAmlkEh0KCnN0YXJ0X3RpbWUYAiABKAlSCX'
    'N0YXJ0VGltZRIZCghlbmRfdGltZRgDIAEoCVIHZW5kVGltZRIUCgV0aXRsZRgEIAEoCVIFdGl0'
    'bGUSJAoLY2F0ZWdvcnlfaWQYBSABKAlIAFIKY2F0ZWdvcnlJZIgBARIoCg1jYXRlZ29yeV9uYW'
    '1lGAYgASgJSAFSDGNhdGVnb3J5TmFtZYgBARIqCg5jYW5jZWxlZF91bnRpbBgHIAEoCUgCUg1j'
    'YW5jZWxlZFVudGlsiAEBEiEKDGlzX3JlY3VycmluZxgIIAEoCFILaXNSZWN1cnJpbmdCDgoMX2'
    'NhdGVnb3J5X2lkQhAKDl9jYXRlZ29yeV9uYW1lQhEKD19jYW5jZWxlZF91bnRpbA==');

@$core.Deprecated('Use listScheduleResponseDescriptor instead')
const ListScheduleResponse$json = {
  '1': 'ListScheduleResponse',
  '2': [
    {'1': 'broadcaster_id', '3': 1, '4': 1, '5': 9, '10': 'broadcasterId'},
    {
      '1': 'broadcaster_login',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'broadcasterLogin'
    },
    {'1': 'broadcaster_name', '3': 3, '4': 1, '5': 9, '10': 'broadcasterName'},
    {
      '1': 'segments',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.twitch.ScheduleSegment',
      '10': 'segments'
    },
    {'1': 'cursor', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'cursor', '17': true},
    {'1': 'has_more', '3': 6, '4': 1, '5': 8, '10': 'hasMore'},
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
    {'1': '_cursor'},
  ],
};

/// Descriptor for `ListScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listScheduleResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0U2NoZWR1bGVSZXNwb25zZRIlCg5icm9hZGNhc3Rlcl9pZBgBIAEoCVINYnJvYWRjYX'
    'N0ZXJJZBIrChFicm9hZGNhc3Rlcl9sb2dpbhgCIAEoCVIQYnJvYWRjYXN0ZXJMb2dpbhIpChBi'
    'cm9hZGNhc3Rlcl9uYW1lGAMgASgJUg9icm9hZGNhc3Rlck5hbWUSQwoIc2VnbWVudHMYBCADKA'
    'syJy5zeW5jdHYucHJvdmlkZXIudHdpdGNoLlNjaGVkdWxlU2VnbWVudFIIc2VnbWVudHMSGwoG'
    'Y3Vyc29yGAUgASgJSABSBmN1cnNvcogBARIZCghoYXNfbW9yZRgGIAEoCFIHaGFzTW9yZRJACg'
    'Zzb3VyY2UYByABKAsyKC5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VS'
    'BnNvdXJjZUIJCgdfY3Vyc29y');
