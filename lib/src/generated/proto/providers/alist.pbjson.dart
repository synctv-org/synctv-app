// This is a generated file - do not edit.
//
// Generated from proto/providers/alist.proto.

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
    {'1': 'username', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'password'},
    {
      '1': 'hashed_password',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'hashedPassword'
    },
    {'1': 'otp_code', '3': 5, '4': 1, '5': 9, '10': 'otpCode'},
    {'1': 'otp_secret', '3': 6, '4': 1, '5': 9, '10': 'otpSecret'},
    {'1': 'instance_name', '3': 7, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': 'credential'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSGwoEaG9zdBgBIAEoCUIHukgEcgIQAVIEaG9zdBIjCgh1c2VybmFtZR'
    'gCIAEoCUIHukgEcgIQAVIIdXNlcm5hbWUSHAoIcGFzc3dvcmQYAyABKAlIAFIIcGFzc3dvcmQS'
    'KQoPaGFzaGVkX3Bhc3N3b3JkGAQgASgJSABSDmhhc2hlZFBhc3N3b3JkEhkKCG90cF9jb2RlGA'
    'UgASgJUgdvdHBDb2RlEh0KCm90cF9zZWNyZXQYBiABKAlSCW90cFNlY3JldBIjCg1pbnN0YW5j'
    'ZV9uYW1lGAcgASgJUgxpbnN0YW5jZU5hbWVCDAoKY3JlZGVudGlhbA==');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhQKBXRva2VuGAEgASgJUgV0b2tlbhIbCglzZXJ2ZXJfaWQYAiABKA'
    'lSCHNlcnZlcklk');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
    {'1': 'page', '3': 4, '4': 1, '5': 4, '10': 'page'},
    {'1': 'per_page', '3': 5, '4': 1, '5': 4, '10': 'perPage'},
    {'1': 'refresh', '3': 6, '4': 1, '5': 8, '10': 'refresh'},
    {'1': 'instance_name', '3': 7, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlcklkEhIKBH'
    'BhdGgYAiABKAlSBHBhdGgSGgoIcGFzc3dvcmQYAyABKAlSCHBhc3N3b3JkEhIKBHBhZ2UYBCAB'
    'KARSBHBhZ2USGQoIcGVyX3BhZ2UYBSABKARSB3BlclBhZ2USGAoHcmVmcmVzaBgGIAEoCFIHcm'
    'VmcmVzaBIjCg1pbnN0YW5jZV9uYW1lGAcgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.alist.FileItem',
      '10': 'content'
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
    'CgxMaXN0UmVzcG9uc2USOQoHY29udGVudBgBIAMoCzIfLnN5bmN0di5wcm92aWRlci5hbGlzdC'
    '5GaWxlSXRlbVIHY29udGVudBIUCgV0b3RhbBgCIAEoBFIFdG90YWwSQAoGc291cmNlGAMgASgL'
    'Miguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'parent', '3': 2, '4': 1, '5': 9, '10': 'parent'},
    {'1': 'keywords', '3': 3, '4': 1, '5': 9, '10': 'keywords'},
    {'1': 'scope', '3': 4, '4': 1, '5': 4, '10': 'scope'},
    {'1': 'page', '3': 5, '4': 1, '5': 4, '10': 'page'},
    {'1': 'per_page', '3': 6, '4': 1, '5': 4, '10': 'perPage'},
    {'1': 'password', '3': 7, '4': 1, '5': 9, '10': 'password'},
    {'1': 'instance_name', '3': 8, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySWQSFg'
    'oGcGFyZW50GAIgASgJUgZwYXJlbnQSGgoIa2V5d29yZHMYAyABKAlSCGtleXdvcmRzEhQKBXNj'
    'b3BlGAQgASgEUgVzY29wZRISCgRwYWdlGAUgASgEUgRwYWdlEhkKCHBlcl9wYWdlGAYgASgEUg'
    'dwZXJQYWdlEhoKCHBhc3N3b3JkGAcgASgJUghwYXNzd29yZBIjCg1pbnN0YW5jZV9uYW1lGAgg'
    'ASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.alist.SearchItem',
      '10': 'content'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
  ],
};

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRI7Cgdjb250ZW50GAEgAygLMiEuc3luY3R2LnByb3ZpZGVyLmFsaX'
    'N0LlNlYXJjaEl0ZW1SB2NvbnRlbnQSFAoFdG90YWwYAiABKARSBXRvdGFs');

@$core.Deprecated('Use searchItemDescriptor instead')
const SearchItem$json = {
  '1': 'SearchItem',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 9, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'is_dir', '3': 3, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 4, '4': 1, '5': 4, '10': 'size'},
    {'1': 'type', '3': 5, '4': 1, '5': 4, '10': 'type'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `SearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemDescriptor = $convert.base64Decode(
    'CgpTZWFyY2hJdGVtEhYKBnBhcmVudBgBIAEoCVIGcGFyZW50EhIKBG5hbWUYAiABKAlSBG5hbW'
    'USFQoGaXNfZGlyGAMgASgIUgVpc0RpchISCgRzaXplGAQgASgEUgRzaXplEhIKBHR5cGUYBSAB'
    'KARSBHR5cGUSQAoGc291cmNlGAYgASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3'
    'ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 2, '4': 1, '5': 4, '10': 'size'},
    {'1': 'is_dir', '3': 3, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'modified', '3': 4, '4': 1, '5': 4, '10': 'modified'},
    {'1': 'sign', '3': 5, '4': 1, '5': 9, '10': 'sign'},
    {'1': 'thumb', '3': 6, '4': 1, '5': 9, '10': 'thumb'},
    {'1': 'type', '3': 7, '4': 1, '5': 4, '10': 'type'},
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBHNpemUYAiABKARSBHNpemUSFQoGaX'
    'NfZGlyGAMgASgIUgVpc0RpchIaCghtb2RpZmllZBgEIAEoBFIIbW9kaWZpZWQSEgoEc2lnbhgF'
    'IAEoCVIEc2lnbhIUCgV0aHVtYhgGIAEoCVIFdGh1bWISEgoEdHlwZRgHIAEoBFIEdHlwZRJACg'
    'Zzb3VyY2UYCCABKAsyKC5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRpc2NvdmVyZWRTb3VyY2VS'
    'BnNvdXJjZQ==');

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
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'base_path', '3': 2, '4': 1, '5': 9, '10': 'basePath'},
  ],
};

/// Descriptor for `GetMeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMeResponseDescriptor = $convert.base64Decode(
    'Cg1HZXRNZVJlc3BvbnNlEhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIbCgliYXNlX3BhdG'
    'gYAiABKAlSCGJhc2VQYXRo');

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
      '6': '.synctv.provider.alist.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjUKBWJpbmRzGAEgAygLMh8uc3luY3R2LnByb3ZpZGVyLmFsaX'
    'N0LkJpbmRJbmZvUgViaW5kcw==');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'host', '3': 3, '4': 1, '5': 9, '10': 'host'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
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
    'ISCgRob3N0GAMgASgJUgRob3N0EhoKCHVzZXJuYW1lGAQgASgJUgh1c2VybmFtZRIdCgpjcmVh'
    'dGVkX2F0GAUgASgDUgljcmVhdGVkQXQSNAoWcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgGIAEoCV'
    'IUcHJvdmlkZXJJbnN0YW5jZU5hbWU=');
