// This is a generated file - do not edit.
//
// Generated from proto/providers/fnos.proto.

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

@$core.Deprecated('Use mediaCollectionDescriptor instead')
const MediaCollection$json = {
  '1': 'MediaCollection',
  '2': [
    {'1': 'MEDIA_COLLECTION_UNSPECIFIED', '2': 0},
    {'1': 'MEDIA_COLLECTION_LIBRARY', '2': 1},
    {'1': 'MEDIA_COLLECTION_FAVORITES', '2': 2},
    {'1': 'MEDIA_COLLECTION_HISTORY', '2': 3},
  ],
};

/// Descriptor for `MediaCollection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaCollectionDescriptor = $convert.base64Decode(
    'Cg9NZWRpYUNvbGxlY3Rpb24SIAocTUVESUFfQ09MTEVDVElPTl9VTlNQRUNJRklFRBAAEhwKGE'
    '1FRElBX0NPTExFQ1RJT05fTElCUkFSWRABEh4KGk1FRElBX0NPTExFQ1RJT05fRkFWT1JJVEVT'
    'EAISHAoYTUVESUFfQ09MTEVDVElPTl9ISVNUT1JZEAM=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'endpoint', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'endpoint'},
    {
      '1': 'webdav_endpoint',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'webdavEndpoint',
      '17': true
    },
    {
      '1': 'media_endpoint',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'mediaEndpoint',
      '17': true
    },
    {'1': 'username', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'password', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {
      '1': 'twofa_code',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 2,
      '10': 'twofaCode',
      '17': true
    },
    {'1': 'trust_device', '3': 7, '4': 1, '5': 8, '10': 'trustDevice'},
    {'1': 'instance_name', '3': 8, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_webdav_endpoint'},
    {'1': '_media_endpoint'},
    {'1': '_twofa_code'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSIwoIZW5kcG9pbnQYASABKAlCB7pIBHICEAFSCGVuZHBvaW50EiwKD3'
    'dlYmRhdl9lbmRwb2ludBgCIAEoCUgAUg53ZWJkYXZFbmRwb2ludIgBARIqCg5tZWRpYV9lbmRw'
    'b2ludBgDIAEoCUgBUg1tZWRpYUVuZHBvaW50iAEBEiMKCHVzZXJuYW1lGAQgASgJQge6SARyAh'
    'ABUgh1c2VybmFtZRIjCghwYXNzd29yZBgFIAEoCUIHukgEcgIQAVIIcGFzc3dvcmQSOAoKdHdv'
    'ZmFfY29kZRgGIAEoCUIUukgRcg8yCl5bMC05XXs2fSSYAQZIAlIJdHdvZmFDb2RliAEBEiEKDH'
    'RydXN0X2RldmljZRgHIAEoCFILdHJ1c3REZXZpY2USIwoNaW5zdGFuY2VfbmFtZRgIIAEoCVIM'
    'aW5zdGFuY2VOYW1lQhIKEF93ZWJkYXZfZW5kcG9pbnRCEQoPX21lZGlhX2VuZHBvaW50Qg0KC1'
    '90d29mYV9jb2Rl');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {
      '1': 'authenticated',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.fnos.Authenticated',
      '9': 0,
      '10': 'authenticated'
    },
    {
      '1': 'two_factor_required',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.fnos.TwoFactorRequired',
      '9': 0,
      '10': 'twoFactorRequired'
    },
  ],
  '8': [
    {'1': 'result'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEksKDWF1dGhlbnRpY2F0ZWQYASABKAsyIy5zeW5jdHYucHJvdmlkZX'
    'IuZm5vcy5BdXRoZW50aWNhdGVkSABSDWF1dGhlbnRpY2F0ZWQSWQoTdHdvX2ZhY3Rvcl9yZXF1'
    'aXJlZBgCIAEoCzInLnN5bmN0di5wcm92aWRlci5mbm9zLlR3b0ZhY3RvclJlcXVpcmVkSABSEX'
    'R3b0ZhY3RvclJlcXVpcmVkQggKBnJlc3VsdA==');

@$core.Deprecated('Use authenticatedDescriptor instead')
const Authenticated$json = {
  '1': 'Authenticated',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'host_name', '3': 2, '4': 1, '5': 9, '10': 'hostName'},
    {
      '1': 'version',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'version',
      '17': true
    },
    {'1': 'media_available', '3': 4, '4': 1, '5': 8, '10': 'mediaAvailable'},
  ],
  '8': [
    {'1': '_version'},
  ],
};

/// Descriptor for `Authenticated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authenticatedDescriptor = $convert.base64Decode(
    'Cg1BdXRoZW50aWNhdGVkEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSGwoJaG9zdF9uYW'
    '1lGAIgASgJUghob3N0TmFtZRIdCgd2ZXJzaW9uGAMgASgJSABSB3ZlcnNpb26IAQESJwoPbWVk'
    'aWFfYXZhaWxhYmxlGAQgASgIUg5tZWRpYUF2YWlsYWJsZUIKCghfdmVyc2lvbg==');

@$core.Deprecated('Use twoFactorRequiredDescriptor instead')
const TwoFactorRequired$json = {
  '1': 'TwoFactorRequired',
  '2': [
    {'1': 'setup_required', '3': 1, '4': 1, '5': 8, '10': 'setupRequired'},
  ],
};

/// Descriptor for `TwoFactorRequired`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twoFactorRequiredDescriptor = $convert.base64Decode(
    'ChFUd29GYWN0b3JSZXF1aXJlZBIlCg5zZXR1cF9yZXF1aXJlZBgBIAEoCFINc2V0dXBSZXF1aX'
    'JlZA==');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'page', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlcklkEhIKBH'
    'BhdGgYAiABKAlSBHBhdGgSGwoEcGFnZRgDIAEoDUIHukgEKgIoAVIEcGFnZRInCglwYWdlX3Np'
    'emUYBCABKA1CCrpIByoFGMgBKAFSCHBhZ2VTaXplEhsKBnNlYXJjaBgFIAEoCUgAUgZzZWFyY2'
    'iIAQESIwoNaW5zdGFuY2VfbmFtZRgGIAEoCVIMaW5zdGFuY2VOYW1lQgkKB19zZWFyY2g=');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.fnos.FileItem',
      '10': 'content'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 13, '10': 'page'},
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USOAoHY29udGVudBgBIAMoCzIeLnN5bmN0di5wcm92aWRlci5mbm9zLk'
    'ZpbGVJdGVtUgdjb250ZW50EhQKBXRvdGFsGAIgASgEUgV0b3RhbBISCgRwYWdlGAMgASgNUgRw'
    'YWdlEhkKCGhhc19tb3JlGAQgASgIUgdoYXNNb3JlEkAKBnNvdXJjZRgFIAEoCzIoLnN5bmN0di'
    '5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNl');

@$core.Deprecated('Use listMediaLibrariesRequestDescriptor instead')
const ListMediaLibrariesRequest$json = {
  '1': 'ListMediaLibrariesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ListMediaLibrariesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMediaLibrariesRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0TWVkaWFMaWJyYXJpZXNSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAV'
        'IIc2VydmVySWQSIwoNaW5zdGFuY2VfbmFtZRgCIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use listMediaLibrariesResponseDescriptor instead')
const ListMediaLibrariesResponse$json = {
  '1': 'ListMediaLibrariesResponse',
  '2': [
    {
      '1': 'libraries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.fnos.MediaLibrary',
      '10': 'libraries'
    },
  ],
};

/// Descriptor for `ListMediaLibrariesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMediaLibrariesResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0TWVkaWFMaWJyYXJpZXNSZXNwb25zZRJACglsaWJyYXJpZXMYASADKAsyIi5zeW5jdH'
        'YucHJvdmlkZXIuZm5vcy5NZWRpYUxpYnJhcnlSCWxpYnJhcmllcw==');

@$core.Deprecated('Use mediaLibraryDescriptor instead')
const MediaLibrary$json = {
  '1': 'MediaLibrary',
  '2': [
    {'1': 'guid', '3': 1, '4': 1, '5': 9, '10': 'guid'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'poster', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'poster', '17': true},
    {'1': 'posters', '3': 4, '4': 3, '5': 9, '10': 'posters'},
    {
      '1': 'category',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'category',
      '17': true
    },
    {'1': 'view_type', '3': 6, '4': 1, '5': 5, '10': 'viewType'},
    {'1': 'poster_type', '3': 7, '4': 1, '5': 5, '10': 'posterType'},
  ],
  '8': [
    {'1': '_poster'},
    {'1': '_category'},
  ],
};

/// Descriptor for `MediaLibrary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaLibraryDescriptor = $convert.base64Decode(
    'CgxNZWRpYUxpYnJhcnkSEgoEZ3VpZBgBIAEoCVIEZ3VpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bG'
    'USGwoGcG9zdGVyGAMgASgJSABSBnBvc3RlcogBARIYCgdwb3N0ZXJzGAQgAygJUgdwb3N0ZXJz'
    'Eh8KCGNhdGVnb3J5GAUgASgJSAFSCGNhdGVnb3J5iAEBEhsKCXZpZXdfdHlwZRgGIAEoBVIIdm'
    'lld1R5cGUSHwoLcG9zdGVyX3R5cGUYByABKAVSCnBvc3RlclR5cGVCCQoHX3Bvc3RlckILCglf'
    'Y2F0ZWdvcnk=');

@$core.Deprecated('Use listMediaItemsRequestDescriptor instead')
const ListMediaItemsRequest$json = {
  '1': 'ListMediaItemsRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'collection',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.fnos.MediaCollection',
      '8': {},
      '10': 'collection'
    },
    {
      '1': 'library_guid',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'libraryGuid',
      '17': true
    },
    {'1': 'page', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'media_types', '3': 6, '4': 3, '5': 9, '10': 'mediaTypes'},
    {'1': 'search', '3': 7, '4': 1, '5': 9, '9': 1, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 8, '4': 1, '5': 9, '10': 'instanceName'},
    {
      '1': 'parent_guid',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'parentGuid',
      '17': true
    },
  ],
  '8': [
    {'1': '_library_guid'},
    {'1': '_search'},
    {'1': '_parent_guid'},
  ],
};

/// Descriptor for `ListMediaItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMediaItemsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0TWVkaWFJdGVtc1JlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZX'
    'J2ZXJJZBJTCgpjb2xsZWN0aW9uGAIgASgOMiUuc3luY3R2LnByb3ZpZGVyLmZub3MuTWVkaWFD'
    'b2xsZWN0aW9uQgy6SAmCAQYYARgCGANSCmNvbGxlY3Rpb24SJgoMbGlicmFyeV9ndWlkGAMgAS'
    'gJSABSC2xpYnJhcnlHdWlkiAEBEhsKBHBhZ2UYBCABKA1CB7pIBCoCKAFSBHBhZ2USJwoJcGFn'
    'ZV9zaXplGAUgASgNQgq6SAcqBRjIASgBUghwYWdlU2l6ZRIfCgttZWRpYV90eXBlcxgGIAMoCV'
    'IKbWVkaWFUeXBlcxIbCgZzZWFyY2gYByABKAlIAVIGc2VhcmNoiAEBEiMKDWluc3RhbmNlX25h'
    'bWUYCCABKAlSDGluc3RhbmNlTmFtZRIkCgtwYXJlbnRfZ3VpZBgJIAEoCUgCUgpwYXJlbnRHdW'
    'lkiAEBQg8KDV9saWJyYXJ5X2d1aWRCCQoHX3NlYXJjaEIOCgxfcGFyZW50X2d1aWQ=');

@$core.Deprecated('Use listMediaItemsResponseDescriptor instead')
const ListMediaItemsResponse$json = {
  '1': 'ListMediaItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.fnos.MediaItem',
      '10': 'items'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 13, '10': 'page'},
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ListMediaItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMediaItemsResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0TWVkaWFJdGVtc1Jlc3BvbnNlEjUKBWl0ZW1zGAEgAygLMh8uc3luY3R2LnByb3ZpZG'
    'VyLmZub3MuTWVkaWFJdGVtUgVpdGVtcxIUCgV0b3RhbBgCIAEoBFIFdG90YWwSEgoEcGFnZRgD'
    'IAEoDVIEcGFnZRIZCghoYXNfbW9yZRgEIAEoCFIHaGFzTW9yZRJACgZzb3VyY2UYBSABKAsyKC'
    '5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZQ==');

@$core.Deprecated('Use mediaItemDescriptor instead')
const MediaItem$json = {
  '1': 'MediaItem',
  '2': [
    {'1': 'guid', '3': 1, '4': 1, '5': 9, '10': 'guid'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'item_type', '3': 3, '4': 1, '5': 9, '10': 'itemType'},
    {'1': 'poster', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'poster', '17': true},
    {
      '1': 'media_guid',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'mediaGuid',
      '17': true
    },
    {
      '1': 'parent_guid',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'parentGuid',
      '17': true
    },
    {
      '1': 'overview',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'overview',
      '17': true
    },
    {'1': 'duration_seconds', '3': 8, '4': 1, '5': 4, '10': 'durationSeconds'},
    {'1': 'progress_seconds', '3': 9, '4': 1, '5': 4, '10': 'progressSeconds'},
    {'1': 'watched', '3': 10, '4': 1, '5': 8, '10': 'watched'},
    {'1': 'season_number', '3': 11, '4': 1, '5': 13, '10': 'seasonNumber'},
    {'1': 'episode_number', '3': 12, '4': 1, '5': 13, '10': 'episodeNumber'},
    {'1': 'is_folder', '3': 13, '4': 1, '5': 8, '10': 'isFolder'},
    {'1': 'is_playable', '3': 14, '4': 1, '5': 8, '10': 'isPlayable'},
    {'1': 'favorite', '3': 15, '4': 1, '5': 8, '10': 'favorite'},
    {
      '1': 'source',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
    {
      '1': 'library_guid',
      '3': 17,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'libraryGuid',
      '17': true
    },
  ],
  '8': [
    {'1': '_poster'},
    {'1': '_media_guid'},
    {'1': '_parent_guid'},
    {'1': '_overview'},
    {'1': '_library_guid'},
  ],
};

/// Descriptor for `MediaItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaItemDescriptor = $convert.base64Decode(
    'CglNZWRpYUl0ZW0SEgoEZ3VpZBgBIAEoCVIEZ3VpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSGw'
    'oJaXRlbV90eXBlGAMgASgJUghpdGVtVHlwZRIbCgZwb3N0ZXIYBCABKAlIAFIGcG9zdGVyiAEB'
    'EiIKCm1lZGlhX2d1aWQYBSABKAlIAVIJbWVkaWFHdWlkiAEBEiQKC3BhcmVudF9ndWlkGAYgAS'
    'gJSAJSCnBhcmVudEd1aWSIAQESHwoIb3ZlcnZpZXcYByABKAlIA1IIb3ZlcnZpZXeIAQESKQoQ'
    'ZHVyYXRpb25fc2Vjb25kcxgIIAEoBFIPZHVyYXRpb25TZWNvbmRzEikKEHByb2dyZXNzX3NlY2'
    '9uZHMYCSABKARSD3Byb2dyZXNzU2Vjb25kcxIYCgd3YXRjaGVkGAogASgIUgd3YXRjaGVkEiMK'
    'DXNlYXNvbl9udW1iZXIYCyABKA1SDHNlYXNvbk51bWJlchIlCg5lcGlzb2RlX251bWJlchgMIA'
    'EoDVINZXBpc29kZU51bWJlchIbCglpc19mb2xkZXIYDSABKAhSCGlzRm9sZGVyEh8KC2lzX3Bs'
    'YXlhYmxlGA4gASgIUgppc1BsYXlhYmxlEhoKCGZhdm9yaXRlGA8gASgIUghmYXZvcml0ZRJACg'
    'Zzb3VyY2UYECABKAsyKC5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VS'
    'BnNvdXJjZRImCgxsaWJyYXJ5X2d1aWQYESABKAlIBFILbGlicmFyeUd1aWSIAQFCCQoHX3Bvc3'
    'RlckINCgtfbWVkaWFfZ3VpZEIOCgxfcGFyZW50X2d1aWRCCwoJX292ZXJ2aWV3Qg8KDV9saWJy'
    'YXJ5X2d1aWQ=');

@$core.Deprecated('Use setFavoriteRequestDescriptor instead')
const SetFavoriteRequest$json = {
  '1': 'SetFavoriteRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'item_guid', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'itemGuid'},
    {'1': 'favorite', '3': 3, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `SetFavoriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setFavoriteRequestDescriptor = $convert.base64Decode(
    'ChJTZXRGYXZvcml0ZVJlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZXJ2ZX'
    'JJZBIkCglpdGVtX2d1aWQYAiABKAlCB7pIBHICEAFSCGl0ZW1HdWlkEhoKCGZhdm9yaXRlGAMg'
    'ASgIUghmYXZvcml0ZRIjCg1pbnN0YW5jZV9uYW1lGAQgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use setFavoriteResponseDescriptor instead')
const SetFavoriteResponse$json = {
  '1': 'SetFavoriteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SetFavoriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setFavoriteResponseDescriptor =
    $convert.base64Decode(
        'ChNTZXRGYXZvcml0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use setWatchedRequestDescriptor instead')
const SetWatchedRequest$json = {
  '1': 'SetWatchedRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'item_guid', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'itemGuid'},
    {'1': 'watched', '3': 3, '4': 1, '5': 8, '10': 'watched'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `SetWatchedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setWatchedRequestDescriptor = $convert.base64Decode(
    'ChFTZXRXYXRjaGVkUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlck'
    'lkEiQKCWl0ZW1fZ3VpZBgCIAEoCUIHukgEcgIQAVIIaXRlbUd1aWQSGAoHd2F0Y2hlZBgDIAEo'
    'CFIHd2F0Y2hlZBIjCg1pbnN0YW5jZV9uYW1lGAQgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use setWatchedResponseDescriptor instead')
const SetWatchedResponse$json = {
  '1': 'SetWatchedResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SetWatchedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setWatchedResponseDescriptor =
    $convert.base64Decode(
        'ChJTZXRXYXRjaGVkUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'size', '3': 3, '4': 1, '5': 4, '9': 0, '10': 'size', '17': true},
    {
      '1': 'modified_at',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'modifiedAt',
      '17': true
    },
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'createdAt',
      '17': true
    },
    {'1': 'is_dir', '3': 6, '4': 1, '5': 8, '10': 'isDir'},
    {
      '1': 'storage_id',
      '3': 7,
      '4': 1,
      '5': 4,
      '9': 3,
      '10': 'storageId',
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
    {'1': '_size'},
    {'1': '_modified_at'},
    {'1': '_created_at'},
    {'1': '_storage_id'},
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBHBhdGgYAiABKAlSBHBhdGgSFwoEc2'
    'l6ZRgDIAEoBEgAUgRzaXpliAEBEiQKC21vZGlmaWVkX2F0GAQgASgDSAFSCm1vZGlmaWVkQXSI'
    'AQESIgoKY3JlYXRlZF9hdBgFIAEoA0gCUgljcmVhdGVkQXSIAQESFQoGaXNfZGlyGAYgASgIUg'
    'Vpc0RpchIiCgpzdG9yYWdlX2lkGAcgASgESANSCXN0b3JhZ2VJZIgBARJACgZzb3VyY2UYCCAB'
    'KAsyKC5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZUIHCg'
    'Vfc2l6ZUIOCgxfbW9kaWZpZWRfYXRCDQoLX2NyZWF0ZWRfYXRCDQoLX3N0b3JhZ2VfaWQ=');

@$core.Deprecated('Use getServerInfoRequestDescriptor instead')
const GetServerInfoRequest$json = {
  '1': 'GetServerInfoRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `GetServerInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerInfoRequestDescriptor = $convert.base64Decode(
    'ChRHZXRTZXJ2ZXJJbmZvUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcn'
    'ZlcklkEiMKDWluc3RhbmNlX25hbWUYAiABKAlSDGluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use getServerInfoResponseDescriptor instead')
const GetServerInfoResponse$json = {
  '1': 'GetServerInfoResponse',
  '2': [
    {'1': 'host_name', '3': 1, '4': 1, '5': 9, '10': 'hostName'},
    {
      '1': 'version',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'version',
      '17': true
    },
  ],
  '8': [
    {'1': '_version'},
  ],
};

/// Descriptor for `GetServerInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerInfoResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTZXJ2ZXJJbmZvUmVzcG9uc2USGwoJaG9zdF9uYW1lGAEgASgJUghob3N0TmFtZRIdCg'
    'd2ZXJzaW9uGAIgASgJSABSB3ZlcnNpb26IAQFCCgoIX3ZlcnNpb24=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySWQ=');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

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
      '6': '.synctv.provider.fnos.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjQKBWJpbmRzGAEgAygLMh4uc3luY3R2LnByb3ZpZGVyLmZub3'
    'MuQmluZEluZm9SBWJpbmRz');

@$core.Deprecated('Use getThumbnailRequestDescriptor instead')
const GetThumbnailRequest$json = {
  '1': 'GetThumbnailRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'image_path', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'imagePath'},
    {'1': 'width', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'width'},
  ],
};

/// Descriptor for `GetThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getThumbnailRequestDescriptor = $convert.base64Decode(
    'ChNHZXRUaHVtYm5haWxSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2Vydm'
    'VySWQSJgoKaW1hZ2VfcGF0aBgCIAEoCUIHukgEcgIQAVIJaW1hZ2VQYXRoEh4KBXdpZHRoGAMg'
    'ASgNQgi6SAUqAxiAD1IFd2lkdGg=');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
    {
      '1': 'webdav_endpoint',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'webdavEndpoint',
      '17': true
    },
    {
      '1': 'media_endpoint',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'mediaEndpoint',
      '17': true
    },
    {'1': 'username', '3': 6, '4': 1, '5': 9, '10': 'username'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
    {'1': 'media_available', '3': 9, '4': 1, '5': 8, '10': 'mediaAvailable'},
  ],
  '8': [
    {'1': '_webdav_endpoint'},
    {'1': '_media_endpoint'},
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IaCghlbmRwb2ludBgDIAEoCVIIZW5kcG9pbnQSLAoPd2ViZGF2X2VuZHBvaW50GAQgASgJSABS'
    'DndlYmRhdkVuZHBvaW50iAEBEioKDm1lZGlhX2VuZHBvaW50GAUgASgJSAFSDW1lZGlhRW5kcG'
    '9pbnSIAQESGgoIdXNlcm5hbWUYBiABKAlSCHVzZXJuYW1lEh0KCmNyZWF0ZWRfYXQYByABKANS'
    'CWNyZWF0ZWRBdBI0ChZwcm92aWRlcl9pbnN0YW5jZV9uYW1lGAggASgJUhRwcm92aWRlckluc3'
    'RhbmNlTmFtZRInCg9tZWRpYV9hdmFpbGFibGUYCSABKAhSDm1lZGlhQXZhaWxhYmxlQhIKEF93'
    'ZWJkYXZfZW5kcG9pbnRCEQoPX21lZGlhX2VuZHBvaW50');
