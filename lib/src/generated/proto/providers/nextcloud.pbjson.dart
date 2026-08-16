// This is a generated file - do not edit.
//
// Generated from proto/providers/nextcloud.proto.

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

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'endpoint', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'endpoint'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'app_password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'appPassword'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSIwoIZW5kcG9pbnQYASABKAlCB7pIBHICEAFSCGVuZHBvaW50EiMKCH'
    'VzZXJuYW1lGAIgASgJQge6SARyAhABUgh1c2VybmFtZRIqCgxhcHBfcGFzc3dvcmQYAyABKAlC'
    'B7pIBHICEAFSC2FwcFBhc3N3b3JkEiMKDWluc3RhbmNlX25hbWUYBCABKAlSDGluc3RhbmNlTm'
    'FtZQ==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {'1': 'edition', '3': 5, '4': 1, '5': 9, '10': 'edition'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSFwoHdXNlcl9pZB'
    'gCIAEoCVIGdXNlcklkEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSGAoHdmVy'
    'c2lvbhgEIAEoCVIHdmVyc2lvbhIYCgdlZGl0aW9uGAUgASgJUgdlZGl0aW9u');

@$core.Deprecated('Use startLoginFlowRequestDescriptor instead')
const StartLoginFlowRequest$json = {
  '1': 'StartLoginFlowRequest',
  '2': [
    {'1': 'endpoint', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'endpoint'},
  ],
};

/// Descriptor for `StartLoginFlowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startLoginFlowRequestDescriptor = $convert.base64Decode(
    'ChVTdGFydExvZ2luRmxvd1JlcXVlc3QSIwoIZW5kcG9pbnQYASABKAlCB7pIBHICEAFSCGVuZH'
    'BvaW50');

@$core.Deprecated('Use startLoginFlowResponseDescriptor instead')
const StartLoginFlowResponse$json = {
  '1': 'StartLoginFlowResponse',
  '2': [
    {'1': 'login_url', '3': 1, '4': 1, '5': 9, '10': 'loginUrl'},
    {'1': 'poll_endpoint', '3': 2, '4': 1, '5': 9, '10': 'pollEndpoint'},
    {'1': 'poll_token', '3': 3, '4': 1, '5': 9, '10': 'pollToken'},
  ],
};

/// Descriptor for `StartLoginFlowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startLoginFlowResponseDescriptor = $convert.base64Decode(
    'ChZTdGFydExvZ2luRmxvd1Jlc3BvbnNlEhsKCWxvZ2luX3VybBgBIAEoCVIIbG9naW5VcmwSIw'
    'oNcG9sbF9lbmRwb2ludBgCIAEoCVIMcG9sbEVuZHBvaW50Eh0KCnBvbGxfdG9rZW4YAyABKAlS'
    'CXBvbGxUb2tlbg==');

@$core.Deprecated('Use pollLoginFlowRequestDescriptor instead')
const PollLoginFlowRequest$json = {
  '1': 'PollLoginFlowRequest',
  '2': [
    {'1': 'endpoint', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'endpoint'},
    {
      '1': 'poll_endpoint',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'pollEndpoint'
    },
    {'1': 'poll_token', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'pollToken'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `PollLoginFlowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollLoginFlowRequestDescriptor = $convert.base64Decode(
    'ChRQb2xsTG9naW5GbG93UmVxdWVzdBIjCghlbmRwb2ludBgBIAEoCUIHukgEcgIQAVIIZW5kcG'
    '9pbnQSLAoNcG9sbF9lbmRwb2ludBgCIAEoCUIHukgEcgIQAVIMcG9sbEVuZHBvaW50EiYKCnBv'
    'bGxfdG9rZW4YAyABKAlCB7pIBHICEAFSCXBvbGxUb2tlbhIjCg1pbnN0YW5jZV9uYW1lGAQgAS'
    'gJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
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
    'BhdGgYAiABKAlSBHBhdGgSGwoEcGFnZRgDIAEoBEIHukgEMgIoAVIEcGFnZRInCglwYWdlX3Np'
    'emUYBCABKA1CCrpIByoFGMgBKAFSCHBhZ2VTaXplEhsKBnNlYXJjaBgFIAEoCUgAUgZzZWFyY2'
    'iIAQESIwoNaW5zdGFuY2VfbmFtZRgGIAEoCVIMaW5zdGFuY2VOYW1lQgkKB19zZWFyY2g=');

@$core.Deprecated('Use listFavoritesRequestDescriptor instead')
const ListFavoritesRequest$json = {
  '1': 'ListFavoritesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'page', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ListFavoritesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFavoritesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RmF2b3JpdGVzUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcn'
    'ZlcklkEhsKBHBhZ2UYAiABKARCB7pIBDICKAFSBHBhZ2USJwoJcGFnZV9zaXplGAMgASgNQgq6'
    'SAcqBRjIASgBUghwYWdlU2l6ZRIjCg1pbnN0YW5jZV9uYW1lGAQgASgJUgxpbnN0YW5jZU5hbW'
    'U=');

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'file_id', '3': 3, '4': 1, '5': 4, '10': 'fileId'},
    {'1': 'is_dir', '3': 4, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 5, '4': 1, '5': 4, '10': 'size'},
    {
      '1': 'modified_at',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'modifiedAt',
      '17': true
    },
    {
      '1': 'content_type',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'contentType',
      '17': true
    },
    {'1': 'etag', '3': 8, '4': 1, '5': 9, '9': 2, '10': 'etag', '17': true},
    {
      '1': 'permissions',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'permissions',
      '17': true
    },
    {
      '1': 'owner_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'ownerId',
      '17': true
    },
    {
      '1': 'owner_display_name',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'ownerDisplayName',
      '17': true
    },
    {'1': 'favorite', '3': 12, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'has_preview', '3': 13, '4': 1, '5': 8, '10': 'hasPreview'},
    {
      '1': 'blurhash',
      '3': 14,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'blurhash',
      '17': true
    },
    {'1': 'width', '3': 15, '4': 1, '5': 13, '9': 7, '10': 'width', '17': true},
    {
      '1': 'height',
      '3': 16,
      '4': 1,
      '5': 13,
      '9': 8,
      '10': 'height',
      '17': true
    },
    {
      '1': 'duration_millis',
      '3': 17,
      '4': 1,
      '5': 4,
      '9': 9,
      '10': 'durationMillis',
      '17': true
    },
    {
      '1': 'source',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_modified_at'},
    {'1': '_content_type'},
    {'1': '_etag'},
    {'1': '_permissions'},
    {'1': '_owner_id'},
    {'1': '_owner_display_name'},
    {'1': '_blurhash'},
    {'1': '_width'},
    {'1': '_height'},
    {'1': '_duration_millis'},
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBHBhdGgYAiABKAlSBHBhdGgSFwoHZm'
    'lsZV9pZBgDIAEoBFIGZmlsZUlkEhUKBmlzX2RpchgEIAEoCFIFaXNEaXISEgoEc2l6ZRgFIAEo'
    'BFIEc2l6ZRIkCgttb2RpZmllZF9hdBgGIAEoCUgAUgptb2RpZmllZEF0iAEBEiYKDGNvbnRlbn'
    'RfdHlwZRgHIAEoCUgBUgtjb250ZW50VHlwZYgBARIXCgRldGFnGAggASgJSAJSBGV0YWeIAQES'
    'JQoLcGVybWlzc2lvbnMYCSABKAlIA1ILcGVybWlzc2lvbnOIAQESHgoIb3duZXJfaWQYCiABKA'
    'lIBFIHb3duZXJJZIgBARIxChJvd25lcl9kaXNwbGF5X25hbWUYCyABKAlIBVIQb3duZXJEaXNw'
    'bGF5TmFtZYgBARIaCghmYXZvcml0ZRgMIAEoCFIIZmF2b3JpdGUSHwoLaGFzX3ByZXZpZXcYDS'
    'ABKAhSCmhhc1ByZXZpZXcSHwoIYmx1cmhhc2gYDiABKAlIBlIIYmx1cmhhc2iIAQESGQoFd2lk'
    'dGgYDyABKA1IB1IFd2lkdGiIAQESGwoGaGVpZ2h0GBAgASgNSAhSBmhlaWdodIgBARIsCg9kdX'
    'JhdGlvbl9taWxsaXMYESABKARICVIOZHVyYXRpb25NaWxsaXOIAQESQAoGc291cmNlGBIgASgL'
    'Miguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2VCDgoMX2'
    '1vZGlmaWVkX2F0Qg8KDV9jb250ZW50X3R5cGVCBwoFX2V0YWdCDgoMX3Blcm1pc3Npb25zQgsK'
    'CV9vd25lcl9pZEIVChNfb3duZXJfZGlzcGxheV9uYW1lQgsKCV9ibHVyaGFzaEIICgZfd2lkdG'
    'hCCQoHX2hlaWdodEISChBfZHVyYXRpb25fbWlsbGlz');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.nextcloud.FileItem',
      '10': 'content'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '9': 0, '10': 'total', '17': true},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '10': 'page'},
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
  '8': [
    {'1': '_total'},
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USPQoHY29udGVudBgBIAMoCzIjLnN5bmN0di5wcm92aWRlci5uZXh0Y2'
    'xvdWQuRmlsZUl0ZW1SB2NvbnRlbnQSGQoFdG90YWwYAiABKARIAFIFdG90YWyIAQESEgoEcGFn'
    'ZRgDIAEoBFIEcGFnZRIZCghoYXNfbW9yZRgEIAEoCFIHaGFzTW9yZRJACgZzb3VyY2UYBSABKA'
    'syKC5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZUIICgZf'
    'dG90YWw=');

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

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {'1': 'user_id', '3': 5, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'version', '3': 6, '4': 1, '5': 9, '10': 'version'},
    {'1': 'edition', '3': 7, '4': 1, '5': 9, '10': 'edition'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IaCghlbmRwb2ludBgDIAEoCVIIZW5kcG9pbnQSGgoIdXNlcm5hbWUYBCABKAlSCHVzZXJuYW1l'
    'EhcKB3VzZXJfaWQYBSABKAlSBnVzZXJJZBIYCgd2ZXJzaW9uGAYgASgJUgd2ZXJzaW9uEhgKB2'
    'VkaXRpb24YByABKAlSB2VkaXRpb24SHQoKY3JlYXRlZF9hdBgIIAEoA1IJY3JlYXRlZEF0EjQK'
    'FnByb3ZpZGVyX2luc3RhbmNlX25hbWUYCSABKAlSFHByb3ZpZGVySW5zdGFuY2VOYW1l');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.nextcloud.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjkKBWJpbmRzGAEgAygLMiMuc3luY3R2LnByb3ZpZGVyLm5leH'
    'RjbG91ZC5CaW5kSW5mb1IFYmluZHM=');

@$core.Deprecated('Use getPreviewRequestDescriptor instead')
const GetPreviewRequest$json = {
  '1': 'GetPreviewRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'file_id', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'fileId'},
    {'1': 'width', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'height'},
    {'1': 'crop', '3': 5, '4': 1, '5': 8, '9': 0, '10': 'crop', '17': true},
  ],
  '8': [
    {'1': '_crop'},
  ],
};

/// Descriptor for `GetPreviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPreviewRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcmV2aWV3UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlck'
    'lkEiAKB2ZpbGVfaWQYAiABKARCB7pIBDICIABSBmZpbGVJZBIeCgV3aWR0aBgDIAEoDUIIukgF'
    'KgMYgBBSBXdpZHRoEiAKBmhlaWdodBgEIAEoDUIIukgFKgMYgBBSBmhlaWdodBIXCgRjcm9wGA'
    'UgASgISABSBGNyb3CIAQFCBwoFX2Nyb3A=');
