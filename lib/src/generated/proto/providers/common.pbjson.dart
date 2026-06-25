// This is a generated file - do not edit.
//
// Generated from proto/providers/common.proto.

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

@$core.Deprecated('Use providerInstanceStatusDescriptor instead')
const ProviderInstanceStatus$json = {
  '1': 'ProviderInstanceStatus',
  '2': [
    {'1': 'PROVIDER_INSTANCE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PROVIDER_INSTANCE_STATUS_CONNECTED', '2': 1},
    {'1': 'PROVIDER_INSTANCE_STATUS_DISCONNECTED', '2': 2},
    {'1': 'PROVIDER_INSTANCE_STATUS_ERROR', '2': 3},
  ],
};

/// Descriptor for `ProviderInstanceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List providerInstanceStatusDescriptor = $convert.base64Decode(
    'ChZQcm92aWRlckluc3RhbmNlU3RhdHVzEigKJFBST1ZJREVSX0lOU1RBTkNFX1NUQVRVU19VTl'
    'NQRUNJRklFRBAAEiYKIlBST1ZJREVSX0lOU1RBTkNFX1NUQVRVU19DT05ORUNURUQQARIpCiVQ'
    'Uk9WSURFUl9JTlNUQU5DRV9TVEFUVVNfRElTQ09OTkVDVEVEEAISIgoeUFJPVklERVJfSU5TVE'
    'FOQ0VfU1RBVFVTX0VSUk9SEAM=');

@$core.Deprecated('Use providerInstanceListSortByDescriptor instead')
const ProviderInstanceListSortBy$json = {
  '1': 'ProviderInstanceListSortBy',
  '2': [
    {'1': 'PROVIDER_INSTANCE_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'PROVIDER_INSTANCE_LIST_SORT_BY_NAME', '2': 1},
    {'1': 'PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT', '2': 2},
    {'1': 'PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT', '2': 3},
    {'1': 'PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT', '2': 4},
  ],
};

/// Descriptor for `ProviderInstanceListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List providerInstanceListSortByDescriptor = $convert.base64Decode(
    'ChpQcm92aWRlckluc3RhbmNlTGlzdFNvcnRCeRIuCipQUk9WSURFUl9JTlNUQU5DRV9MSVNUX1'
    'NPUlRfQllfVU5TUEVDSUZJRUQQABInCiNQUk9WSURFUl9JTlNUQU5DRV9MSVNUX1NPUlRfQllf'
    'TkFNRRABEisKJ1BST1ZJREVSX0lOU1RBTkNFX0xJU1RfU09SVF9CWV9FTkRQT0lOVBACEi0KKV'
    'BST1ZJREVSX0lOU1RBTkNFX0xJU1RfU09SVF9CWV9DUkVBVEVEX0FUEAMSLQopUFJPVklERVJf'
    'SU5TVEFOQ0VfTElTVF9TT1JUX0JZX1VQREFURURfQVQQBA==');

@$core.Deprecated('Use sortDirectionDescriptor instead')
const SortDirection$json = {
  '1': 'SortDirection',
  '2': [
    {'1': 'SORT_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'SORT_DIRECTION_ASC', '2': 1},
    {'1': 'SORT_DIRECTION_DESC', '2': 2},
  ],
};

/// Descriptor for `SortDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sortDirectionDescriptor = $convert.base64Decode(
    'Cg1Tb3J0RGlyZWN0aW9uEh4KGlNPUlRfRElSRUNUSU9OX1VOU1BFQ0lGSUVEEAASFgoSU09SVF'
    '9ESVJFQ1RJT05fQVNDEAESFwoTU09SVF9ESVJFQ1RJT05fREVTQxAC');

@$core.Deprecated('Use providerInstanceQueryDescriptor instead')
const ProviderInstanceQuery$json = {
  '1': 'ProviderInstanceQuery',
  '2': [
    {
      '1': 'instance_name',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'instanceName'
    },
  ],
};

/// Descriptor for `ProviderInstanceQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerInstanceQueryDescriptor = $convert.base64Decode(
    'ChVQcm92aWRlckluc3RhbmNlUXVlcnkS+AEKDWluc3RhbmNlX25hbWUYASABKAlC0gG6SM4Bug'
    'HKAQolcHJvdmlkZXJfaW5zdGFuY2VfcXVlcnkuaW5zdGFuY2VfbmFtZRJbaW5zdGFuY2VfbmFt'
    'ZSBtdXN0IGJlIGVtcHR5IG9yIDEtNjQgY2hhcmFjdGVycyBvZiBsZXR0ZXJzLCBudW1iZXJzLC'
    'B1bmRlcnNjb3Jlcywgb3IgaHlwaGVucxpEdGhpcyA9PSAnJyB8fCAoc2l6ZSh0aGlzKSA8PSA2'
    'NCAmJiB0aGlzLm1hdGNoZXMoJ15bQS1aYS16MC05Xy1dKyQnKSlSDGluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use providerInstanceDescriptor instead')
const ProviderInstance$json = {
  '1': 'ProviderInstance',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'endpoint', '3': 2, '4': 1, '5': 9, '10': 'endpoint'},
    {'1': 'comment', '3': 3, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'timeout_seconds', '3': 4, '4': 1, '5': 13, '10': 'timeoutSeconds'},
    {'1': 'tls', '3': 5, '4': 1, '5': 8, '10': 'tls'},
    {'1': 'insecure_tls', '3': 6, '4': 1, '5': 8, '10': 'insecureTls'},
    {
      '1': 'providers',
      '3': 7,
      '4': 3,
      '5': 14,
      '6': '.synctv.source_config.SourceProvider',
      '8': {},
      '10': 'providers'
    },
    {'1': 'enabled', '3': 8, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.common.ProviderInstanceStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 10, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 11, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `ProviderInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerInstanceDescriptor = $convert.base64Decode(
    'ChBQcm92aWRlckluc3RhbmNlEhIKBG5hbWUYASABKAlSBG5hbWUSGgoIZW5kcG9pbnQYAiABKA'
    'lSCGVuZHBvaW50EhgKB2NvbW1lbnQYAyABKAlSB2NvbW1lbnQSJwoPdGltZW91dF9zZWNvbmRz'
    'GAQgASgNUg50aW1lb3V0U2Vjb25kcxIQCgN0bHMYBSABKAhSA3RscxIhCgxpbnNlY3VyZV90bH'
    'MYBiABKAhSC2luc2VjdXJlVGxzElcKCXByb3ZpZGVycxgHIAMoDjIkLnN5bmN0di5zb3VyY2Vf'
    'Y29uZmlnLlNvdXJjZVByb3ZpZGVyQhO6SBCSAQ0IARgBIgeCAQQQASAAUglwcm92aWRlcnMSGA'
    'oHZW5hYmxlZBgIIAEoCFIHZW5hYmxlZBJGCgZzdGF0dXMYCSABKA4yLi5zeW5jdHYucHJvdmlk'
    'ZXIuY29tbW9uLlByb3ZpZGVySW5zdGFuY2VTdGF0dXNSBnN0YXR1cxIdCgpjcmVhdGVkX2F0GA'
    'ogASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgLIAEoA1IJdXBkYXRlZEF0');

@$core.Deprecated('Use listAvailableProviderInstancesRequestDescriptor instead')
const ListAvailableProviderInstancesRequest$json = {
  '1': 'ListAvailableProviderInstancesRequest',
  '2': [
    {
      '1': 'provider_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.SourceProvider',
      '8': {},
      '10': 'providerType'
    },
  ],
};

/// Descriptor for `ListAvailableProviderInstancesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAvailableProviderInstancesRequestDescriptor =
    $convert.base64Decode(
        'CiVMaXN0QXZhaWxhYmxlUHJvdmlkZXJJbnN0YW5jZXNSZXF1ZXN0ElMKDXByb3ZpZGVyX3R5cG'
        'UYASABKA4yJC5zeW5jdHYuc291cmNlX2NvbmZpZy5Tb3VyY2VQcm92aWRlckIIukgFggECEAFS'
        'DHByb3ZpZGVyVHlwZQ==');

@$core.Deprecated('Use listProviderInstancesRequestDescriptor instead')
const ListProviderInstancesRequest$json = {
  '1': 'ListProviderInstancesRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'provider_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.SourceProvider',
      '8': {},
      '10': 'providerType'
    },
    {'1': 'search', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'enabled',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
    {'1': 'tls', '3': 6, '4': 1, '5': 8, '9': 1, '10': 'tls', '17': true},
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.common.ProviderInstanceListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.common.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
  '8': [
    {'1': '_enabled'},
    {'1': '_tls'},
  ],
};

/// Descriptor for `ListProviderInstancesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProviderInstancesRequestDescriptor = $convert.base64Decode(
    'ChxMaXN0UHJvdmlkZXJJbnN0YW5jZXNSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USGwoJcG'
    'FnZV9zaXplGAIgASgFUghwYWdlU2l6ZRJTCg1wcm92aWRlcl90eXBlGAMgASgOMiQuc3luY3R2'
    'LnNvdXJjZV9jb25maWcuU291cmNlUHJvdmlkZXJCCLpIBYIBAhABUgxwcm92aWRlclR5cGUSHw'
    'oGc2VhcmNoGAQgASgJQge6SARyAhhkUgZzZWFyY2gSHQoHZW5hYmxlZBgFIAEoCEgAUgdlbmFi'
    'bGVkiAEBEhUKA3RscxgGIAEoCEgBUgN0bHOIAQESVQoHc29ydF9ieRgHIAEoDjIyLnN5bmN0di'
    '5wcm92aWRlci5jb21tb24uUHJvdmlkZXJJbnN0YW5jZUxpc3RTb3J0QnlCCLpIBYIBAhABUgZz'
    'b3J0QnkSVgoOc29ydF9kaXJlY3Rpb24YCCABKA4yJS5zeW5jdHYucHJvdmlkZXIuY29tbW9uLl'
    'NvcnREaXJlY3Rpb25CCLpIBYIBAhABUg1zb3J0RGlyZWN0aW9uOqkCukilAhp1CiVwcm92aWRl'
    'ci5saXN0X3Byb3ZpZGVyX2luc3RhbmNlcy5wYWdlEipwYWdlIG11c3QgYmUgMCAodXNlIGRlZm'
    'F1bHQpIG9yIGF0IGxlYXN0IDEaIHRoaXMucGFnZSA9PSAwIHx8IHRoaXMucGFnZSA+PSAxGqsB'
    'Cipwcm92aWRlci5saXN0X3Byb3ZpZGVyX2luc3RhbmNlcy5wYWdlX3NpemUSNnBhZ2Vfc2l6ZS'
    'BtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBpFdGhpcy5wYWdl'
    'X3NpemUgPT0gMCB8fCAodGhpcy5wYWdlX3NpemUgPj0gMSAmJiB0aGlzLnBhZ2Vfc2l6ZSA8PS'
    'AxMDApQgoKCF9lbmFibGVkQgYKBF90bHM=');

@$core.Deprecated('Use listProviderInstancesResponseDescriptor instead')
const ListProviderInstancesResponse$json = {
  '1': 'ListProviderInstancesResponse',
  '2': [
    {
      '1': 'instances',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.common.ProviderInstance',
      '10': 'instances'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListProviderInstancesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProviderInstancesResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0UHJvdmlkZXJJbnN0YW5jZXNSZXNwb25zZRJGCglpbnN0YW5jZXMYASADKAsyKC5zeW'
        '5jdHYucHJvdmlkZXIuY29tbW9uLlByb3ZpZGVySW5zdGFuY2VSCWluc3RhbmNlcxIUCgV0b3Rh'
        'bBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use addProviderInstanceRequestDescriptor instead')
const AddProviderInstanceRequest$json = {
  '1': 'AddProviderInstanceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'endpoint', '3': 2, '4': 1, '5': 9, '10': 'endpoint'},
    {'1': 'comment', '3': 3, '4': 1, '5': 9, '10': 'comment'},
    {'1': 'timeout_seconds', '3': 4, '4': 1, '5': 13, '10': 'timeoutSeconds'},
    {'1': 'tls', '3': 5, '4': 1, '5': 8, '10': 'tls'},
    {'1': 'insecure_tls', '3': 6, '4': 1, '5': 8, '10': 'insecureTls'},
    {
      '1': 'providers',
      '3': 7,
      '4': 3,
      '5': 14,
      '6': '.synctv.source_config.SourceProvider',
      '8': {},
      '10': 'providers'
    },
    {
      '1': 'jwt_secret',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'jwtSecret',
      '17': true
    },
    {
      '1': 'custom_ca',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'customCa',
      '17': true
    },
  ],
  '8': [
    {'1': '_jwt_secret'},
    {'1': '_custom_ca'},
  ],
};

/// Descriptor for `AddProviderInstanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addProviderInstanceRequestDescriptor = $convert.base64Decode(
    'ChpBZGRQcm92aWRlckluc3RhbmNlUmVxdWVzdBIvCgRuYW1lGAEgASgJQhu6SBhyFhABGEAyEF'
    '5bQS1aYS16MC05Xy1dKyRSBG5hbWUSGgoIZW5kcG9pbnQYAiABKAlSCGVuZHBvaW50EhgKB2Nv'
    'bW1lbnQYAyABKAlSB2NvbW1lbnQSJwoPdGltZW91dF9zZWNvbmRzGAQgASgNUg50aW1lb3V0U2'
    'Vjb25kcxIQCgN0bHMYBSABKAhSA3RscxIhCgxpbnNlY3VyZV90bHMYBiABKAhSC2luc2VjdXJl'
    'VGxzElcKCXByb3ZpZGVycxgHIAMoDjIkLnN5bmN0di5zb3VyY2VfY29uZmlnLlNvdXJjZVByb3'
    'ZpZGVyQhO6SBCSAQ0IARgBIgeCAQQQASAAUglwcm92aWRlcnMSIgoKand0X3NlY3JldBgIIAEo'
    'CUgAUglqd3RTZWNyZXSIAQESIAoJY3VzdG9tX2NhGAkgASgJSAFSCGN1c3RvbUNhiAEBQg0KC1'
    '9qd3Rfc2VjcmV0QgwKCl9jdXN0b21fY2E=');

@$core.Deprecated('Use addProviderInstanceResponseDescriptor instead')
const AddProviderInstanceResponse$json = {
  '1': 'AddProviderInstanceResponse',
  '2': [
    {
      '1': 'instance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.ProviderInstance',
      '10': 'instance'
    },
  ],
};

/// Descriptor for `AddProviderInstanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addProviderInstanceResponseDescriptor =
    $convert.base64Decode(
        'ChtBZGRQcm92aWRlckluc3RhbmNlUmVzcG9uc2USRAoIaW5zdGFuY2UYASABKAsyKC5zeW5jdH'
        'YucHJvdmlkZXIuY29tbW9uLlByb3ZpZGVySW5zdGFuY2VSCGluc3RhbmNl');

@$core.Deprecated('Use updateProviderInstanceRequestDescriptor instead')
const UpdateProviderInstanceRequest$json = {
  '1': 'UpdateProviderInstanceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {
      '1': 'endpoint',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'endpoint',
      '17': true
    },
    {
      '1': 'comment',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'comment',
      '17': true
    },
    {
      '1': 'timeout_seconds',
      '3': 4,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'timeoutSeconds',
      '17': true
    },
    {'1': 'tls', '3': 5, '4': 1, '5': 8, '9': 3, '10': 'tls', '17': true},
    {
      '1': 'insecure_tls',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 4,
      '10': 'insecureTls',
      '17': true
    },
    {
      '1': 'providers',
      '3': 7,
      '4': 3,
      '5': 14,
      '6': '.synctv.source_config.SourceProvider',
      '8': {},
      '10': 'providers'
    },
    {
      '1': 'jwt_secret',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'jwtSecret',
      '17': true
    },
    {
      '1': 'custom_ca',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'customCa',
      '17': true
    },
    {
      '1': 'clear_comment',
      '3': 10,
      '4': 1,
      '5': 8,
      '9': 7,
      '10': 'clearComment',
      '17': true
    },
    {
      '1': 'clear_jwt_secret',
      '3': 11,
      '4': 1,
      '5': 8,
      '9': 8,
      '10': 'clearJwtSecret',
      '17': true
    },
    {
      '1': 'clear_custom_ca',
      '3': 12,
      '4': 1,
      '5': 8,
      '9': 9,
      '10': 'clearCustomCa',
      '17': true
    },
  ],
  '8': [
    {'1': '_endpoint'},
    {'1': '_comment'},
    {'1': '_timeout_seconds'},
    {'1': '_tls'},
    {'1': '_insecure_tls'},
    {'1': '_jwt_secret'},
    {'1': '_custom_ca'},
    {'1': '_clear_comment'},
    {'1': '_clear_jwt_secret'},
    {'1': '_clear_custom_ca'},
  ],
};

/// Descriptor for `UpdateProviderInstanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProviderInstanceRequestDescriptor = $convert.base64Decode(
    'Ch1VcGRhdGVQcm92aWRlckluc3RhbmNlUmVxdWVzdBIvCgRuYW1lGAEgASgJQhu6SBhyFhABGE'
    'AyEF5bQS1aYS16MC05Xy1dKyRSBG5hbWUSHwoIZW5kcG9pbnQYAiABKAlIAFIIZW5kcG9pbnSI'
    'AQESHQoHY29tbWVudBgDIAEoCUgBUgdjb21tZW50iAEBEiwKD3RpbWVvdXRfc2Vjb25kcxgEIA'
    'EoDUgCUg50aW1lb3V0U2Vjb25kc4gBARIVCgN0bHMYBSABKAhIA1IDdGxziAEBEiYKDGluc2Vj'
    'dXJlX3RscxgGIAEoCEgEUgtpbnNlY3VyZVRsc4gBARJVCglwcm92aWRlcnMYByADKA4yJC5zeW'
    '5jdHYuc291cmNlX2NvbmZpZy5Tb3VyY2VQcm92aWRlckIRukgOkgELGAEiB4IBBBABIABSCXBy'
    'b3ZpZGVycxIiCgpqd3Rfc2VjcmV0GAggASgJSAVSCWp3dFNlY3JldIgBARIgCgljdXN0b21fY2'
    'EYCSABKAlIBlIIY3VzdG9tQ2GIAQESKAoNY2xlYXJfY29tbWVudBgKIAEoCEgHUgxjbGVhckNv'
    'bW1lbnSIAQESLQoQY2xlYXJfand0X3NlY3JldBgLIAEoCEgIUg5jbGVhckp3dFNlY3JldIgBAR'
    'IrCg9jbGVhcl9jdXN0b21fY2EYDCABKAhICVINY2xlYXJDdXN0b21DYYgBAUILCglfZW5kcG9p'
    'bnRCCgoIX2NvbW1lbnRCEgoQX3RpbWVvdXRfc2Vjb25kc0IGCgRfdGxzQg8KDV9pbnNlY3VyZV'
    '90bHNCDQoLX2p3dF9zZWNyZXRCDAoKX2N1c3RvbV9jYUIQCg5fY2xlYXJfY29tbWVudEITChFf'
    'Y2xlYXJfand0X3NlY3JldEISChBfY2xlYXJfY3VzdG9tX2Nh');

@$core.Deprecated('Use updateProviderInstanceResponseDescriptor instead')
const UpdateProviderInstanceResponse$json = {
  '1': 'UpdateProviderInstanceResponse',
  '2': [
    {
      '1': 'instance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.ProviderInstance',
      '10': 'instance'
    },
  ],
};

/// Descriptor for `UpdateProviderInstanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProviderInstanceResponseDescriptor =
    $convert.base64Decode(
        'Ch5VcGRhdGVQcm92aWRlckluc3RhbmNlUmVzcG9uc2USRAoIaW5zdGFuY2UYASABKAsyKC5zeW'
        '5jdHYucHJvdmlkZXIuY29tbW9uLlByb3ZpZGVySW5zdGFuY2VSCGluc3RhbmNl');

@$core.Deprecated('Use deleteProviderInstanceRequestDescriptor instead')
const DeleteProviderInstanceRequest$json = {
  '1': 'DeleteProviderInstanceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `DeleteProviderInstanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProviderInstanceRequestDescriptor =
    $convert.base64Decode(
        'Ch1EZWxldGVQcm92aWRlckluc3RhbmNlUmVxdWVzdBIvCgRuYW1lGAEgASgJQhu6SBhyFhABGE'
        'AyEF5bQS1aYS16MC05Xy1dKyRSBG5hbWU=');

@$core.Deprecated('Use deleteProviderInstanceResponseDescriptor instead')
const DeleteProviderInstanceResponse$json = {
  '1': 'DeleteProviderInstanceResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteProviderInstanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProviderInstanceResponseDescriptor =
    $convert.base64Decode(
        'Ch5EZWxldGVQcm92aWRlckluc3RhbmNlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'Vzcw==');

@$core.Deprecated('Use reconnectProviderInstanceRequestDescriptor instead')
const ReconnectProviderInstanceRequest$json = {
  '1': 'ReconnectProviderInstanceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `ReconnectProviderInstanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconnectProviderInstanceRequestDescriptor =
    $convert.base64Decode(
        'CiBSZWNvbm5lY3RQcm92aWRlckluc3RhbmNlUmVxdWVzdBIvCgRuYW1lGAEgASgJQhu6SBhyFh'
        'ABGEAyEF5bQS1aYS16MC05Xy1dKyRSBG5hbWU=');

@$core.Deprecated('Use reconnectProviderInstanceResponseDescriptor instead')
const ReconnectProviderInstanceResponse$json = {
  '1': 'ReconnectProviderInstanceResponse',
  '2': [
    {
      '1': 'instance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.ProviderInstance',
      '10': 'instance'
    },
  ],
};

/// Descriptor for `ReconnectProviderInstanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconnectProviderInstanceResponseDescriptor =
    $convert.base64Decode(
        'CiFSZWNvbm5lY3RQcm92aWRlckluc3RhbmNlUmVzcG9uc2USRAoIaW5zdGFuY2UYASABKAsyKC'
        '5zeW5jdHYucHJvdmlkZXIuY29tbW9uLlByb3ZpZGVySW5zdGFuY2VSCGluc3RhbmNl');

@$core.Deprecated('Use enableProviderInstanceRequestDescriptor instead')
const EnableProviderInstanceRequest$json = {
  '1': 'EnableProviderInstanceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `EnableProviderInstanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enableProviderInstanceRequestDescriptor =
    $convert.base64Decode(
        'Ch1FbmFibGVQcm92aWRlckluc3RhbmNlUmVxdWVzdBIvCgRuYW1lGAEgASgJQhu6SBhyFhABGE'
        'AyEF5bQS1aYS16MC05Xy1dKyRSBG5hbWU=');

@$core.Deprecated('Use enableProviderInstanceResponseDescriptor instead')
const EnableProviderInstanceResponse$json = {
  '1': 'EnableProviderInstanceResponse',
  '2': [
    {
      '1': 'instance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.ProviderInstance',
      '10': 'instance'
    },
  ],
};

/// Descriptor for `EnableProviderInstanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enableProviderInstanceResponseDescriptor =
    $convert.base64Decode(
        'Ch5FbmFibGVQcm92aWRlckluc3RhbmNlUmVzcG9uc2USRAoIaW5zdGFuY2UYASABKAsyKC5zeW'
        '5jdHYucHJvdmlkZXIuY29tbW9uLlByb3ZpZGVySW5zdGFuY2VSCGluc3RhbmNl');

@$core.Deprecated('Use disableProviderInstanceRequestDescriptor instead')
const DisableProviderInstanceRequest$json = {
  '1': 'DisableProviderInstanceRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `DisableProviderInstanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disableProviderInstanceRequestDescriptor =
    $convert.base64Decode(
        'Ch5EaXNhYmxlUHJvdmlkZXJJbnN0YW5jZVJlcXVlc3QSLwoEbmFtZRgBIAEoCUIbukgYchYQAR'
        'hAMhBeW0EtWmEtejAtOV8tXSskUgRuYW1l');

@$core.Deprecated('Use disableProviderInstanceResponseDescriptor instead')
const DisableProviderInstanceResponse$json = {
  '1': 'DisableProviderInstanceResponse',
  '2': [
    {
      '1': 'instance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.ProviderInstance',
      '10': 'instance'
    },
  ],
};

/// Descriptor for `DisableProviderInstanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disableProviderInstanceResponseDescriptor =
    $convert.base64Decode(
        'Ch9EaXNhYmxlUHJvdmlkZXJJbnN0YW5jZVJlc3BvbnNlEkQKCGluc3RhbmNlGAEgASgLMiguc3'
        'luY3R2LnByb3ZpZGVyLmNvbW1vbi5Qcm92aWRlckluc3RhbmNlUghpbnN0YW5jZQ==');

@$core.Deprecated('Use listProviderBackendsRequestDescriptor instead')
const ListProviderBackendsRequest$json = {
  '1': 'ListProviderBackendsRequest',
  '2': [
    {
      '1': 'provider_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.source_config.SourceProvider',
      '8': {},
      '10': 'providerType'
    },
  ],
};

/// Descriptor for `ListProviderBackendsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProviderBackendsRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UHJvdmlkZXJCYWNrZW5kc1JlcXVlc3QSVQoNcHJvdmlkZXJfdHlwZRgBIAEoDjIkLn'
        'N5bmN0di5zb3VyY2VfY29uZmlnLlNvdXJjZVByb3ZpZGVyQgq6SAeCAQQQASAAUgxwcm92aWRl'
        'clR5cGU=');

@$core.Deprecated('Use providerInstancesResponseDescriptor instead')
const ProviderInstancesResponse$json = {
  '1': 'ProviderInstancesResponse',
  '2': [
    {'1': 'instances', '3': 1, '4': 3, '5': 9, '10': 'instances'},
  ],
};

/// Descriptor for `ProviderInstancesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerInstancesResponseDescriptor =
    $convert.base64Decode(
        'ChlQcm92aWRlckluc3RhbmNlc1Jlc3BvbnNlEhwKCWluc3RhbmNlcxgBIAMoCVIJaW5zdGFuY2'
        'Vz');

@$core.Deprecated('Use providerBackendsResponseDescriptor instead')
const ProviderBackendsResponse$json = {
  '1': 'ProviderBackendsResponse',
  '2': [
    {'1': 'backends', '3': 1, '4': 3, '5': 9, '10': 'backends'},
  ],
};

/// Descriptor for `ProviderBackendsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerBackendsResponseDescriptor =
    $convert.base64Decode(
        'ChhQcm92aWRlckJhY2tlbmRzUmVzcG9uc2USGgoIYmFja2VuZHMYASADKAlSCGJhY2tlbmRz');
