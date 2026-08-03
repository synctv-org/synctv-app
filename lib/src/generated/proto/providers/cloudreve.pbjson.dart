// This is a generated file - do not edit.
//
// Generated from proto/providers/cloudreve.proto.

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
    {'1': 'host', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'host'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGwoEaG9zdBgBIAEoCUIHukgEcgIQAVIEaG9zdBIdCgVlbWFpbBgCIA'
    'EoCUIHukgEcgIQAVIFZW1haWwSIwoIcGFzc3dvcmQYAyABKAlCB7pIBHICEAFSCHBhc3N3b3Jk'
    'EiMKDWluc3RhbmNlX25hbWUYBCABKAlSDGluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQ=');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {
      '1': 'page',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.cloudreve.PagePagination',
      '9': 0,
      '10': 'page'
    },
    {
      '1': 'cursor',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.cloudreve.CursorPagination',
      '9': 0,
      '10': 'cursor'
    },
    {'1': 'per_page', '3': 5, '4': 1, '5': 13, '8': {}, '10': 'perPage'},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': 'pagination'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlcklkEhIKBH'
    'BhdGgYAiABKAlSBHBhdGgSPwoEcGFnZRgDIAEoCzIpLnN5bmN0di5wcm92aWRlci5jbG91ZHJl'
    'dmUuUGFnZVBhZ2luYXRpb25IAFIEcGFnZRJFCgZjdXJzb3IYBCABKAsyKy5zeW5jdHYucHJvdm'
    'lkZXIuY2xvdWRyZXZlLkN1cnNvclBhZ2luYXRpb25IAFIGY3Vyc29yEiUKCHBlcl9wYWdlGAUg'
    'ASgNQgq6SAcqBRjIASgBUgdwZXJQYWdlEiMKDWluc3RhbmNlX25hbWUYBiABKAlSDGluc3Rhbm'
    'NlTmFtZUIMCgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.cloudreve.FileItem',
      '10': 'content'
    },
    {
      '1': 'page',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.cloudreve.PagePagination',
      '9': 0,
      '10': 'page'
    },
    {
      '1': 'cursor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.cloudreve.CursorPagination',
      '9': 0,
      '10': 'cursor'
    },
  ],
  '8': [
    {'1': 'pagination'},
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USPQoHY29udGVudBgBIAMoCzIjLnN5bmN0di5wcm92aWRlci5jbG91ZH'
    'JldmUuRmlsZUl0ZW1SB2NvbnRlbnQSPwoEcGFnZRgCIAEoCzIpLnN5bmN0di5wcm92aWRlci5j'
    'bG91ZHJldmUuUGFnZVBhZ2luYXRpb25IAFIEcGFnZRJFCgZjdXJzb3IYAyABKAsyKy5zeW5jdH'
    'YucHJvdmlkZXIuY2xvdWRyZXZlLkN1cnNvclBhZ2luYXRpb25IAFIGY3Vyc29yQgwKCnBhZ2lu'
    'YXRpb24=');

@$core.Deprecated('Use pagePaginationDescriptor instead')
const PagePagination$json = {
  '1': 'PagePagination',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 13, '8': {}, '10': 'page'},
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
  ],
};

/// Descriptor for `PagePagination`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pagePaginationDescriptor = $convert.base64Decode(
    'Cg5QYWdlUGFnaW5hdGlvbhIbCgRwYWdlGAEgASgNQge6SAQqAigBUgRwYWdlEhQKBXRvdGFsGA'
    'IgASgEUgV0b3RhbA==');

@$core.Deprecated('Use cursorPaginationDescriptor instead')
const CursorPagination$json = {
  '1': 'CursorPagination',
  '2': [
    {'1': 'cursor', '3': 1, '4': 1, '5': 9, '10': 'cursor'},
  ],
};

/// Descriptor for `CursorPagination`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorPaginationDescriptor = $convert
    .base64Decode('ChBDdXJzb3JQYWdpbmF0aW9uEhYKBmN1cnNvchgBIAEoCVIGY3Vyc29y');

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'keywords', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'keywords'},
    {'1': 'offset', '3': 3, '4': 1, '5': 4, '10': 'offset'},
    {'1': 'instance_name', '3': 4, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySWQSIw'
    'oIa2V5d29yZHMYAiABKAlCB7pIBHICEAFSCGtleXdvcmRzEhYKBm9mZnNldBgDIAEoBFIGb2Zm'
    'c2V0EiMKDWluc3RhbmNlX25hbWUYBCABKAlSDGluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.cloudreve.FileItem',
      '10': 'content'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
  ],
};

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRI9Cgdjb250ZW50GAEgAygLMiMuc3luY3R2LnByb3ZpZGVyLmNsb3'
    'VkcmV2ZS5GaWxlSXRlbVIHY29udGVudBIUCgV0b3RhbBgCIAEoBFIFdG90YWw=');

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'size', '3': 4, '4': 1, '5': 4, '10': 'size'},
    {'1': 'is_dir', '3': 5, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'modified', '3': 6, '4': 1, '5': 3, '10': 'modified'},
    {'1': 'thumbnail', '3': 7, '4': 1, '5': 9, '10': 'thumbnail'},
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRwYXRoGA'
    'MgASgJUgRwYXRoEhIKBHNpemUYBCABKARSBHNpemUSFQoGaXNfZGlyGAUgASgIUgVpc0RpchIa'
    'Cghtb2RpZmllZBgGIAEoA1IIbW9kaWZpZWQSHAoJdGh1bWJuYWlsGAcgASgJUgl0aHVtYm5haW'
    'w=');

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
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'nickname', '3': 3, '4': 1, '5': 9, '10': 'nickname'},
  ],
};

/// Descriptor for `GetMeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMeResponseDescriptor = $convert.base64Decode(
    'Cg1HZXRNZVJlc3BvbnNlEg4KAmlkGAEgASgJUgJpZBIUCgVlbWFpbBgCIAEoCVIFZW1haWwSGg'
    'oIbmlja25hbWUYAyABKAlSCG5pY2tuYW1l');

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
      '6': '.synctv.provider.cloudreve.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjkKBWJpbmRzGAEgAygLMiMuc3luY3R2LnByb3ZpZGVyLmNsb3'
    'VkcmV2ZS5CaW5kSW5mb1IFYmluZHM=');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '10': 'email'},
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
    'ISCgRob3N0GAMgASgJUgRob3N0EhQKBWVtYWlsGAQgASgJUgVlbWFpbBIdCgpjcmVhdGVkX2F0'
    'GAUgASgDUgljcmVhdGVkQXQSNAoWcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgGIAEoCVIUcHJvdm'
    'lkZXJJbnN0YW5jZU5hbWU=');
