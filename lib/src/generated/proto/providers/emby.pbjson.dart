// This is a generated file - do not edit.
//
// Generated from proto/providers/emby.proto.

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

@$core.Deprecated('Use listModeDescriptor instead')
const ListMode$json = {
  '1': 'ListMode',
  '2': [
    {'1': 'LIST_MODE_FOLDER', '2': 0},
    {'1': 'LIST_MODE_FAVORITE_ITEMS', '2': 1},
    {'1': 'LIST_MODE_FAVORITE_PEOPLE', '2': 2},
    {'1': 'LIST_MODE_PERSON_ITEMS', '2': 3},
    {'1': 'LIST_MODE_CONTINUE_WATCHING', '2': 4},
    {'1': 'LIST_MODE_NEXT_UP', '2': 5},
    {'1': 'LIST_MODE_RECENTLY_ADDED', '2': 6},
    {'1': 'LIST_MODE_PLAYLISTS', '2': 7},
    {'1': 'LIST_MODE_COLLECTIONS', '2': 8},
    {'1': 'LIST_MODE_GENRES', '2': 9},
    {'1': 'LIST_MODE_GENRE_ITEMS', '2': 10},
  ],
};

/// Descriptor for `ListMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List listModeDescriptor = $convert.base64Decode(
    'CghMaXN0TW9kZRIUChBMSVNUX01PREVfRk9MREVSEAASHAoYTElTVF9NT0RFX0ZBVk9SSVRFX0'
    'lURU1TEAESHQoZTElTVF9NT0RFX0ZBVk9SSVRFX1BFT1BMRRACEhoKFkxJU1RfTU9ERV9QRVJT'
    'T05fSVRFTVMQAxIfChtMSVNUX01PREVfQ09OVElOVUVfV0FUQ0hJTkcQBBIVChFMSVNUX01PRE'
    'VfTkVYVF9VUBAFEhwKGExJU1RfTU9ERV9SRUNFTlRMWV9BRERFRBAGEhcKE0xJU1RfTU9ERV9Q'
    'TEFZTElTVFMQBxIZChVMSVNUX01PREVfQ09MTEVDVElPTlMQCBIUChBMSVNUX01PREVfR0VOUk'
    'VTEAkSGQoVTElTVF9NT0RFX0dFTlJFX0lURU1TEAo=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'host', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'host'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'password'},
    {'1': 'api_key', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'apiKey'},
    {'1': 'instance_name', '3': 5, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': 'credential'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGwoEaG9zdBgBIAEoCUIHukgEcgIQAVIEaG9zdBIjCgh1c2VybmFtZR'
    'gCIAEoCUIHukgEcgIQAVIIdXNlcm5hbWUSHAoIcGFzc3dvcmQYAyABKAlIAFIIcGFzc3dvcmQS'
    'GQoHYXBpX2tleRgEIAEoCUgAUgZhcGlLZXkSIwoNaW5zdGFuY2VfbmFtZRgFIAEoCVIMaW5zdG'
    'FuY2VOYW1lQgwKCmNyZWRlbnRpYWw=');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'is_admin', '3': 3, '4': 1, '5': 8, '10': 'isAdmin'},
    {'1': 'server_id', '3': 4, '4': 1, '5': 9, '10': 'serverId'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIaCgh1c2VybmFtZRgCIA'
    'EoCVIIdXNlcm5hbWUSGQoIaXNfYWRtaW4YAyABKAhSB2lzQWRtaW4SGwoJc2VydmVyX2lkGAQg'
    'ASgJUghzZXJ2ZXJJZA==');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.emby.ListMode',
      '10': 'mode'
    },
    {'1': 'start_index', '3': 3, '4': 1, '5': 4, '10': 'startIndex'},
    {'1': 'limit', '3': 4, '4': 1, '5': 4, '10': 'limit'},
    {'1': 'search_term', '3': 5, '4': 1, '5': 9, '10': 'searchTerm'},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
    {'1': 'target_id', '3': 7, '4': 1, '5': 9, '10': 'targetId'},
    {'1': 'item_types', '3': 8, '4': 3, '5': 9, '10': 'itemTypes'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlcklkEjIKBG'
    '1vZGUYAiABKA4yHi5zeW5jdHYucHJvdmlkZXIuZW1ieS5MaXN0TW9kZVIEbW9kZRIfCgtzdGFy'
    'dF9pbmRleBgDIAEoBFIKc3RhcnRJbmRleBIUCgVsaW1pdBgEIAEoBFIFbGltaXQSHwoLc2Vhcm'
    'NoX3Rlcm0YBSABKAlSCnNlYXJjaFRlcm0SIwoNaW5zdGFuY2VfbmFtZRgGIAEoCVIMaW5zdGFu'
    'Y2VOYW1lEhsKCXRhcmdldF9pZBgHIAEoCVIIdGFyZ2V0SWQSHQoKaXRlbV90eXBlcxgIIAMoCV'
    'IJaXRlbVR5cGVz');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.emby.MediaItem',
      '10': 'items'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
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

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USNQoFaXRlbXMYASADKAsyHy5zeW5jdHYucHJvdmlkZXIuZW1ieS5NZW'
    'RpYUl0ZW1SBWl0ZW1zEhQKBXRvdGFsGAIgASgEUgV0b3RhbBJACgZzb3VyY2UYAyABKAsyKC5z'
    'eW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZQ==');

@$core.Deprecated('Use mediaItemDescriptor instead')
const MediaItem$json = {
  '1': 'MediaItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'parent_id', '3': 4, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'series_name', '3': 5, '4': 1, '5': 9, '10': 'seriesName'},
    {'1': 'series_id', '3': 6, '4': 1, '5': 9, '10': 'seriesId'},
    {'1': 'season_name', '3': 7, '4': 1, '5': 9, '10': 'seasonName'},
    {'1': 'thumbnail', '3': 8, '4': 1, '5': 9, '10': 'thumbnail'},
    {'1': 'description', '3': 9, '4': 1, '5': 9, '10': 'description'},
    {'1': 'is_container', '3': 10, '4': 1, '5': 8, '10': 'isContainer'},
    {
      '1': 'source',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `MediaItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaItemDescriptor = $convert.base64Decode(
    'CglNZWRpYUl0ZW0SDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEgoEdHlwZR'
    'gDIAEoCVIEdHlwZRIbCglwYXJlbnRfaWQYBCABKAlSCHBhcmVudElkEh8KC3Nlcmllc19uYW1l'
    'GAUgASgJUgpzZXJpZXNOYW1lEhsKCXNlcmllc19pZBgGIAEoCVIIc2VyaWVzSWQSHwoLc2Vhc2'
    '9uX25hbWUYByABKAlSCnNlYXNvbk5hbWUSHAoJdGh1bWJuYWlsGAggASgJUgl0aHVtYm5haWwS'
    'IAoLZGVzY3JpcHRpb24YCSABKAlSC2Rlc2NyaXB0aW9uEiEKDGlzX2NvbnRhaW5lchgKIAEoCF'
    'ILaXNDb250YWluZXISQAoGc291cmNlGAsgASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5E'
    'aXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use getMeRequestDescriptor instead')
const GetMeRequest$json = {
  '1': 'GetMeRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `GetMeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMeRequestDescriptor = $convert.base64Decode(
    'CgxHZXRNZVJlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZXJ2ZXJJZBIjCg'
    '1pbnN0YW5jZV9uYW1lGAIgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use getMeResponseDescriptor instead')
const GetMeResponse$json = {
  '1': 'GetMeResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `GetMeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMeResponseDescriptor = $convert.base64Decode(
    'Cg1HZXRNZVJlc3BvbnNlEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1l');

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
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

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
      '6': '.synctv.provider.emby.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjQKBWJpbmRzGAEgAygLMh4uc3luY3R2LnByb3ZpZGVyLmVtYn'
    'kuQmluZEluZm9SBWJpbmRz');

@$core.Deprecated('Use getThumbnailRequestDescriptor instead')
const GetThumbnailRequest$json = {
  '1': 'GetThumbnailRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'itemId'},
    {'1': 'max_height', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'maxHeight'},
    {'1': 'max_width', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'maxWidth'},
  ],
};

/// Descriptor for `GetThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getThumbnailRequestDescriptor = $convert.base64Decode(
    'ChNHZXRUaHVtYm5haWxSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2Vydm'
    'VySWQSIAoHaXRlbV9pZBgCIAEoCUIHukgEcgIQAVIGaXRlbUlkEicKCm1heF9oZWlnaHQYAyAB'
    'KA1CCLpIBSoDGIAPUgltYXhIZWlnaHQSJQoJbWF4X3dpZHRoGAQgASgNQgi6SAUqAxiAD1IIbW'
    'F4V2lkdGg=');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
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
    'ISCgRob3N0GAMgASgJUgRob3N0EhcKB3VzZXJfaWQYBCABKAlSBnVzZXJJZBIdCgpjcmVhdGVk'
    'X2F0GAUgASgDUgljcmVhdGVkQXQSNAoWcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgGIAEoCVIUcH'
    'JvdmlkZXJJbnN0YW5jZU5hbWU=');
