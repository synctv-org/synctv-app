// This is a generated file - do not edit.
//
// Generated from proto/providers/seafile.proto.

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
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSIwoIZW5kcG9pbnQYASABKAlCB7pIBHICEAFSCGVuZHBvaW50EiMKCH'
    'VzZXJuYW1lGAIgASgJQge6SARyAhABUgh1c2VybmFtZRIjCghwYXNzd29yZBgDIAEoCUIHukgE'
    'cgIQAVIIcGFzc3dvcmQSIwoNaW5zdGFuY2VfbmFtZRgEIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {'1': 'features', '3': 5, '4': 3, '5': 9, '10': 'features'},
    {'1': 'quota_total', '3': 6, '4': 1, '5': 3, '10': 'quotaTotal'},
    {'1': 'quota_usage', '3': 7, '4': 1, '5': 3, '10': 'quotaUsage'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSFAoFZW1haWwYAi'
    'ABKAlSBWVtYWlsEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSGAoHdmVyc2lv'
    'bhgEIAEoCVIHdmVyc2lvbhIaCghmZWF0dXJlcxgFIAMoCVIIZmVhdHVyZXMSHwoLcXVvdGFfdG'
    '90YWwYBiABKANSCnF1b3RhVG90YWwSHwoLcXVvdGFfdXNhZ2UYByABKANSCnF1b3RhVXNhZ2U=');

@$core.Deprecated('Use unlockLibraryRequestDescriptor instead')
const UnlockLibraryRequest$json = {
  '1': 'UnlockLibraryRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'repository_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'repositoryId'
    },
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `UnlockLibraryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlockLibraryRequestDescriptor = $convert.base64Decode(
    'ChRVbmxvY2tMaWJyYXJ5UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcn'
    'ZlcklkEiwKDXJlcG9zaXRvcnlfaWQYAiABKAlCB7pIBHICEAFSDHJlcG9zaXRvcnlJZBIjCghw'
    'YXNzd29yZBgDIAEoCUIHukgEcgIQAVIIcGFzc3dvcmQSIwoNaW5zdGFuY2VfbmFtZRgEIAEoCV'
    'IMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use unlockLibraryResponseDescriptor instead')
const UnlockLibraryResponse$json = {
  '1': 'UnlockLibraryResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UnlockLibraryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlockLibraryResponseDescriptor =
    $convert.base64Decode(
        'ChVVbmxvY2tMaWJyYXJ5UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use listRepositoriesRequestDescriptor instead')
const ListRepositoriesRequest$json = {
  '1': 'ListRepositoriesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'page', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ListRepositoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRepositoriesRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0UmVwb3NpdG9yaWVzUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCH'
    'NlcnZlcklkEhsKBHBhZ2UYAiABKARCB7pIBDICKAFSBHBhZ2USJwoJcGFnZV9zaXplGAMgASgN'
    'Qgq6SAcqBRjIASgBUghwYWdlU2l6ZRIjCg1pbnN0YW5jZV9uYW1lGAQgASgJUgxpbnN0YW5jZU'
    '5hbWU=');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'repository_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'repositoryId'
    },
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'page', '3': 4, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 7, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlcklkEiwKDX'
    'JlcG9zaXRvcnlfaWQYAiABKAlCB7pIBHICEAFSDHJlcG9zaXRvcnlJZBISCgRwYXRoGAMgASgJ'
    'UgRwYXRoEhsKBHBhZ2UYBCABKARCB7pIBDICKAFSBHBhZ2USJwoJcGFnZV9zaXplGAUgASgNQg'
    'q6SAcqBRjIASgBUghwYWdlU2l6ZRIbCgZzZWFyY2gYBiABKAlIAFIGc2VhcmNoiAEBEiMKDWlu'
    'c3RhbmNlX25hbWUYByABKAlSDGluc3RhbmNlTmFtZUIJCgdfc2VhcmNo');

@$core.Deprecated('Use listStarredRequestDescriptor instead')
const ListStarredRequest$json = {
  '1': 'ListStarredRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'page', '3': 2, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ListStarredRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStarredRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0U3RhcnJlZFJlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZXJ2ZX'
    'JJZBIbCgRwYWdlGAIgASgEQge6SAQyAigBUgRwYWdlEicKCXBhZ2Vfc2l6ZRgDIAEoDUIKukgH'
    'KgUYyAEoAVIIcGFnZVNpemUSIwoNaW5zdGFuY2VfbmFtZRgEIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'repository_id', '3': 1, '4': 1, '5': 9, '10': 'repositoryId'},
    {'1': 'repository_name', '3': 2, '4': 1, '5': 9, '10': 'repositoryName'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'object_id', '3': 5, '4': 1, '5': 9, '10': 'objectId'},
    {'1': 'is_dir', '3': 6, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 7, '4': 1, '5': 4, '10': 'size'},
    {'1': 'modified_at', '3': 8, '4': 1, '5': 9, '10': 'modifiedAt'},
    {'1': 'permission', '3': 9, '4': 1, '5': 9, '10': 'permission'},
    {'1': 'modifier_name', '3': 10, '4': 1, '5': 9, '10': 'modifierName'},
    {'1': 'starred', '3': 11, '4': 1, '5': 8, '10': 'starred'},
    {'1': 'has_thumbnail', '3': 12, '4': 1, '5': 8, '10': 'hasThumbnail'},
    {
      '1': 'repository_encrypted',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'repositoryEncrypted'
    },
    {
      '1': 'password_required',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'passwordRequired'
    },
    {
      '1': 'source',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRIjCg1yZXBvc2l0b3J5X2lkGAEgASgJUgxyZXBvc2l0b3J5SWQSJwoPcmVwb3'
    'NpdG9yeV9uYW1lGAIgASgJUg5yZXBvc2l0b3J5TmFtZRISCgRwYXRoGAMgASgJUgRwYXRoEhIK'
    'BG5hbWUYBCABKAlSBG5hbWUSGwoJb2JqZWN0X2lkGAUgASgJUghvYmplY3RJZBIVCgZpc19kaX'
    'IYBiABKAhSBWlzRGlyEhIKBHNpemUYByABKARSBHNpemUSHwoLbW9kaWZpZWRfYXQYCCABKAlS'
    'Cm1vZGlmaWVkQXQSHgoKcGVybWlzc2lvbhgJIAEoCVIKcGVybWlzc2lvbhIjCg1tb2RpZmllcl'
    '9uYW1lGAogASgJUgxtb2RpZmllck5hbWUSGAoHc3RhcnJlZBgLIAEoCFIHc3RhcnJlZBIjCg1o'
    'YXNfdGh1bWJuYWlsGAwgASgIUgxoYXNUaHVtYm5haWwSMQoUcmVwb3NpdG9yeV9lbmNyeXB0ZW'
    'QYDSABKAhSE3JlcG9zaXRvcnlFbmNyeXB0ZWQSKwoRcGFzc3dvcmRfcmVxdWlyZWQYDiABKAhS'
    'EHBhc3N3b3JkUmVxdWlyZWQSQAoGc291cmNlGA8gASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW'
    '1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.seafile.FileItem',
      '10': 'content'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
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
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USOwoHY29udGVudBgBIAMoCzIhLnN5bmN0di5wcm92aWRlci5zZWFmaW'
    'xlLkZpbGVJdGVtUgdjb250ZW50EhQKBXRvdGFsGAIgASgEUgV0b3RhbBISCgRwYWdlGAMgASgE'
    'UgRwYWdlEhkKCGhhc19tb3JlGAQgASgIUgdoYXNNb3JlEkAKBnNvdXJjZRgFIAEoCzIoLnN5bm'
    'N0di5wcm92aWRlci5jb21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNl');

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
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {'1': 'features', '3': 6, '4': 3, '5': 9, '10': 'features'},
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
    'IaCghlbmRwb2ludBgDIAEoCVIIZW5kcG9pbnQSGgoIdXNlcm5hbWUYBCABKAlSCHVzZXJuYW1l'
    'EhgKB3ZlcnNpb24YBSABKAlSB3ZlcnNpb24SGgoIZmVhdHVyZXMYBiADKAlSCGZlYXR1cmVzEh'
    '0KCmNyZWF0ZWRfYXQYByABKANSCWNyZWF0ZWRBdBI0ChZwcm92aWRlcl9pbnN0YW5jZV9uYW1l'
    'GAggASgJUhRwcm92aWRlckluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.seafile.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjcKBWJpbmRzGAEgAygLMiEuc3luY3R2LnByb3ZpZGVyLnNlYW'
    'ZpbGUuQmluZEluZm9SBWJpbmRz');

@$core.Deprecated('Use getThumbnailRequestDescriptor instead')
const GetThumbnailRequest$json = {
  '1': 'GetThumbnailRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'repository_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'repositoryId'
    },
    {'1': 'path', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {'1': 'size', '3': 4, '4': 1, '5': 13, '10': 'size'},
  ],
  '7': {},
};

/// Descriptor for `GetThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getThumbnailRequestDescriptor = $convert.base64Decode(
    'ChNHZXRUaHVtYm5haWxSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2Vydm'
    'VySWQSLAoNcmVwb3NpdG9yeV9pZBgCIAEoCUIHukgEcgIQAVIMcmVwb3NpdG9yeUlkEhsKBHBh'
    'dGgYAyABKAlCB7pIBHICEAFSBHBhdGgSEgoEc2l6ZRgEIAEoDVIEc2l6ZTqSAbpIjgEaiwEKGn'
    'NlYWZpbGUuZ2V0X3RodW1ibmFpbC5zaXplEjNzaXplIG11c3QgYmUgMCAodXNlIGRlZmF1bHQp'
    'IG9yIGJldHdlZW4gMzIgYW5kIDIwNDgaOHRoaXMuc2l6ZSA9PSAwIHx8ICh0aGlzLnNpemUgPj'
    '0gMzIgJiYgdGhpcy5zaXplIDw9IDIwNDgp');
