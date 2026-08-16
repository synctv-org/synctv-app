// This is a generated file - do not edit.
//
// Generated from proto/providers/qnap.proto.

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
    {'1': 'server_name', '3': 2, '4': 1, '5': 9, '10': 'serverName'},
    {
      '1': 'version',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'version',
      '17': true
    },
    {'1': 'support_rtt', '3': 4, '4': 1, '5': 8, '10': 'supportRtt'},
  ],
  '8': [
    {'1': '_version'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSHwoLc2VydmVyX2'
    '5hbWUYAiABKAlSCnNlcnZlck5hbWUSHQoHdmVyc2lvbhgDIAEoCUgAUgd2ZXJzaW9uiAEBEh8K'
    'C3N1cHBvcnRfcnR0GAQgASgIUgpzdXBwb3J0UnR0QgoKCF92ZXJzaW9u');

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
    {'1': 'is_dir', '3': 3, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 4, '4': 1, '5': 4, '10': 'size'},
    {'1': 'modified_at', '3': 5, '4': 1, '5': 4, '10': 'modifiedAt'},
    {'1': 'file_type', '3': 6, '4': 1, '5': 4, '10': 'fileType'},
    {
      '1': 'pre_transcoded_heights',
      '3': 7,
      '4': 3,
      '5': 13,
      '10': 'preTranscodedHeights'
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
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBHBhdGgYAiABKAlSBHBhdGgSFQoGaX'
    'NfZGlyGAMgASgIUgVpc0RpchISCgRzaXplGAQgASgEUgRzaXplEh8KC21vZGlmaWVkX2F0GAUg'
    'ASgEUgptb2RpZmllZEF0EhsKCWZpbGVfdHlwZRgGIAEoBFIIZmlsZVR5cGUSNAoWcHJlX3RyYW'
    '5zY29kZWRfaGVpZ2h0cxgHIAMoDVIUcHJlVHJhbnNjb2RlZEhlaWdodHMSQAoGc291cmNlGAgg'
    'ASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'content',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.qnap.FileItem',
      '10': 'content'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '10': 'page'},
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'realtime_transcode',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'realtimeTranscode'
    },
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

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USOAoHY29udGVudBgBIAMoCzIeLnN5bmN0di5wcm92aWRlci5xbmFwLk'
    'ZpbGVJdGVtUgdjb250ZW50EhQKBXRvdGFsGAIgASgEUgV0b3RhbBISCgRwYWdlGAMgASgEUgRw'
    'YWdlEhkKCGhhc19tb3JlGAQgASgIUgdoYXNNb3JlEi0KEnJlYWx0aW1lX3RyYW5zY29kZRgFIA'
    'EoCFIRcmVhbHRpbWVUcmFuc2NvZGUSQAoGc291cmNlGAYgASgLMiguc3luY3R2LnByb3ZpZGVy'
    'LmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use getCapabilitiesRequestDescriptor instead')
const GetCapabilitiesRequest$json = {
  '1': 'GetCapabilitiesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `GetCapabilitiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCapabilitiesRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDYXBhYmlsaXRpZXNSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2'
        'VydmVySWQSIwoNaW5zdGFuY2VfbmFtZRgCIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use getCapabilitiesResponseDescriptor instead')
const GetCapabilitiesResponse$json = {
  '1': 'GetCapabilitiesResponse',
  '2': [
    {'1': 'support_rtt', '3': 1, '4': 1, '5': 8, '10': 'supportRtt'},
    {
      '1': 'hardware_transcode',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'hardwareTranscode'
    },
    {'1': 'qtranscode', '3': 3, '4': 1, '5': 8, '10': 'qtranscode'},
    {'1': 'multimedia_codec', '3': 4, '4': 1, '5': 8, '10': 'multimediaCodec'},
    {
      '1': 'hd_station_support',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'hdStationSupport'
    },
  ],
};

/// Descriptor for `GetCapabilitiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCapabilitiesResponseDescriptor = $convert.base64Decode(
    'ChdHZXRDYXBhYmlsaXRpZXNSZXNwb25zZRIfCgtzdXBwb3J0X3J0dBgBIAEoCFIKc3VwcG9ydF'
    'J0dBItChJoYXJkd2FyZV90cmFuc2NvZGUYAiABKAhSEWhhcmR3YXJlVHJhbnNjb2RlEh4KCnF0'
    'cmFuc2NvZGUYAyABKAhSCnF0cmFuc2NvZGUSKQoQbXVsdGltZWRpYV9jb2RlYxgEIAEoCFIPbX'
    'VsdGltZWRpYUNvZGVjEiwKEmhkX3N0YXRpb25fc3VwcG9ydBgFIAEoCFIQaGRTdGF0aW9uU3Vw'
    'cG9ydA==');

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
    {'1': 'server_name', '3': 5, '4': 1, '5': 9, '10': 'serverName'},
    {
      '1': 'version',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'version',
      '17': true
    },
    {'1': 'support_rtt', '3': 7, '4': 1, '5': 8, '10': 'supportRtt'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
  '8': [
    {'1': '_version'},
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IaCghlbmRwb2ludBgDIAEoCVIIZW5kcG9pbnQSGgoIdXNlcm5hbWUYBCABKAlSCHVzZXJuYW1l'
    'Eh8KC3NlcnZlcl9uYW1lGAUgASgJUgpzZXJ2ZXJOYW1lEh0KB3ZlcnNpb24YBiABKAlIAFIHdm'
    'Vyc2lvbogBARIfCgtzdXBwb3J0X3J0dBgHIAEoCFIKc3VwcG9ydFJ0dBIdCgpjcmVhdGVkX2F0'
    'GAggASgDUgljcmVhdGVkQXQSNAoWcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgJIAEoCVIUcHJvdm'
    'lkZXJJbnN0YW5jZU5hbWVCCgoIX3ZlcnNpb24=');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.qnap.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjQKBWJpbmRzGAEgAygLMh4uc3luY3R2LnByb3ZpZGVyLnFuYX'
    'AuQmluZEluZm9SBWJpbmRz');

@$core.Deprecated('Use getThumbnailRequestDescriptor instead')
const GetThumbnailRequest$json = {
  '1': 'GetThumbnailRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {'1': 'size', '3': 3, '4': 1, '5': 13, '8': {}, '10': 'size'},
  ],
};

/// Descriptor for `GetThumbnailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getThumbnailRequestDescriptor = $convert.base64Decode(
    'ChNHZXRUaHVtYm5haWxSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2Vydm'
    'VySWQSGwoEcGF0aBgCIAEoCUIHukgEcgIQAVIEcGF0aBIcCgRzaXplGAMgASgNQgi6SAUqAxiA'
    'BVIEc2l6ZQ==');
