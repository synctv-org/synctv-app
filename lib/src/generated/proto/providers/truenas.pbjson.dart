// This is a generated file - do not edit.
//
// Generated from proto/providers/truenas.proto.

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
    {'1': 'api_key', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'apiKey'},
    {'1': 'instance_name', '3': 3, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSIwoIZW5kcG9pbnQYASABKAlCB7pIBHICEAFSCGVuZHBvaW50EiAKB2'
    'FwaV9rZXkYAiABKAlCB7pIBHICEAFSBmFwaUtleRIjCg1pbnN0YW5jZV9uYW1lGAMgASgJUgxp'
    'bnN0YW5jZU5hbWU=');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'hostname', '3': 2, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {'1': 'system_product', '3': 4, '4': 1, '5': 9, '10': 'systemProduct'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSGgoIaG9zdG5hbW'
    'UYAiABKAlSCGhvc3RuYW1lEhgKB3ZlcnNpb24YAyABKAlSB3ZlcnNpb24SJQoOc3lzdGVtX3By'
    'b2R1Y3QYBCABKAlSDXN5c3RlbVByb2R1Y3Q=');

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

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'realpath', '3': 3, '4': 1, '5': 9, '10': 'realpath'},
    {'1': 'is_dir', '3': 4, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 5, '4': 1, '5': 4, '10': 'size'},
    {'1': 'allocation_size', '3': 6, '4': 1, '5': 4, '10': 'allocationSize'},
    {'1': 'mode', '3': 7, '4': 1, '5': 13, '10': 'mode'},
    {'1': 'uid', '3': 8, '4': 1, '5': 13, '10': 'uid'},
    {'1': 'gid', '3': 9, '4': 1, '5': 13, '10': 'gid'},
    {'1': 'mount_id', '3': 10, '4': 1, '5': 4, '10': 'mountId'},
    {'1': 'acl', '3': 11, '4': 1, '5': 8, '10': 'acl'},
    {'1': 'is_mountpoint', '3': 12, '4': 1, '5': 8, '10': 'isMountpoint'},
    {'1': 'is_ctldir', '3': 13, '4': 1, '5': 8, '10': 'isCtldir'},
    {'1': 'attributes', '3': 14, '4': 3, '5': 9, '10': 'attributes'},
    {'1': 'xattrs', '3': 15, '4': 3, '5': 9, '10': 'xattrs'},
    {'1': 'zfs_attributes', '3': 16, '4': 3, '5': 9, '10': 'zfsAttributes'},
    {
      '1': 'source',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBHBhdGgYAiABKAlSBHBhdGgSGgoIcm'
    'VhbHBhdGgYAyABKAlSCHJlYWxwYXRoEhUKBmlzX2RpchgEIAEoCFIFaXNEaXISEgoEc2l6ZRgF'
    'IAEoBFIEc2l6ZRInCg9hbGxvY2F0aW9uX3NpemUYBiABKARSDmFsbG9jYXRpb25TaXplEhIKBG'
    '1vZGUYByABKA1SBG1vZGUSEAoDdWlkGAggASgNUgN1aWQSEAoDZ2lkGAkgASgNUgNnaWQSGQoI'
    'bW91bnRfaWQYCiABKARSB21vdW50SWQSEAoDYWNsGAsgASgIUgNhY2wSIwoNaXNfbW91bnRwb2'
    'ludBgMIAEoCFIMaXNNb3VudHBvaW50EhsKCWlzX2N0bGRpchgNIAEoCFIIaXNDdGxkaXISHgoK'
    'YXR0cmlidXRlcxgOIAMoCVIKYXR0cmlidXRlcxIWCgZ4YXR0cnMYDyADKAlSBnhhdHRycxIlCg'
    '56ZnNfYXR0cmlidXRlcxgQIAMoCVINemZzQXR0cmlidXRlcxJACgZzb3VyY2UYESABKAsyKC5z'
    'eW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VSBnNvdXJjZQ==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.truenas.FileItem',
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
    'CgxMaXN0UmVzcG9uc2USOwoHY29udGVudBgBIAMoCzIhLnN5bmN0di5wcm92aWRlci50cnVlbm'
    'FzLkZpbGVJdGVtUgdjb250ZW50EhQKBXRvdGFsGAIgASgEUgV0b3RhbBISCgRwYWdlGAMgASgE'
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
    {'1': 'hostname', '3': 4, '4': 1, '5': 9, '10': 'hostname'},
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {'1': 'system_product', '3': 6, '4': 1, '5': 9, '10': 'systemProduct'},
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
    'IaCghlbmRwb2ludBgDIAEoCVIIZW5kcG9pbnQSGgoIaG9zdG5hbWUYBCABKAlSCGhvc3RuYW1l'
    'EhgKB3ZlcnNpb24YBSABKAlSB3ZlcnNpb24SJQoOc3lzdGVtX3Byb2R1Y3QYBiABKAlSDXN5c3'
    'RlbVByb2R1Y3QSHQoKY3JlYXRlZF9hdBgHIAEoA1IJY3JlYXRlZEF0EjQKFnByb3ZpZGVyX2lu'
    'c3RhbmNlX25hbWUYCCABKAlSFHByb3ZpZGVySW5zdGFuY2VOYW1l');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.truenas.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjcKBWJpbmRzGAEgAygLMiEuc3luY3R2LnByb3ZpZGVyLnRydW'
    'VuYXMuQmluZEluZm9SBWJpbmRz');
