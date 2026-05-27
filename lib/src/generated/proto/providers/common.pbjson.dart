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
    {'1': 'providers', '3': 7, '4': 3, '5': 9, '8': {}, '10': 'providers'},
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
    'MYBiABKAhSC2luc2VjdXJlVGxzEkEKCXByb3ZpZGVycxgHIAMoCUIjukggkgEdCAEYASIXchUY'
    'QDIRXlthLXpdW2EtejAtOV9dKiRSCXByb3ZpZGVycxIYCgdlbmFibGVkGAggASgIUgdlbmFibG'
    'VkEkYKBnN0YXR1cxgJIAEoDjIuLnN5bmN0di5wcm92aWRlci5jb21tb24uUHJvdmlkZXJJbnN0'
    'YW5jZVN0YXR1c1IGc3RhdHVzEh0KCmNyZWF0ZWRfYXQYCiABKANSCWNyZWF0ZWRBdBIdCgp1cG'
    'RhdGVkX2F0GAsgASgDUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use listAvailableProviderInstancesRequestDescriptor instead')
const ListAvailableProviderInstancesRequest$json = {
  '1': 'ListAvailableProviderInstancesRequest',
  '2': [
    {
      '1': 'provider_type',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerType'
    },
  ],
};

/// Descriptor for `ListAvailableProviderInstancesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAvailableProviderInstancesRequestDescriptor =
    $convert.base64Decode(
        'CiVMaXN0QXZhaWxhYmxlUHJvdmlkZXJJbnN0YW5jZXNSZXF1ZXN0EkIKDXByb3ZpZGVyX3R5cG'
        'UYASABKAlCHbpIGnIVGEAyEV5bYS16XVthLXowLTlfXSok2AEBUgxwcm92aWRlclR5cGU=');

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
      '5': 9,
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
    'FnZV9zaXplGAIgASgFUghwYWdlU2l6ZRJCCg1wcm92aWRlcl90eXBlGAMgASgJQh26SBpyFRhA'
    'MhFeW2Etel1bYS16MC05X10qJNgBAVIMcHJvdmlkZXJUeXBlEh8KBnNlYXJjaBgEIAEoCUIHuk'
    'gEcgIYZFIGc2VhcmNoEh0KB2VuYWJsZWQYBSABKAhIAFIHZW5hYmxlZIgBARIVCgN0bHMYBiAB'
    'KAhIAVIDdGxziAEBElUKB3NvcnRfYnkYByABKA4yMi5zeW5jdHYucHJvdmlkZXIuY29tbW9uLl'
    'Byb3ZpZGVySW5zdGFuY2VMaXN0U29ydEJ5Qgi6SAWCAQIQAVIGc29ydEJ5ElYKDnNvcnRfZGly'
    'ZWN0aW9uGAggASgOMiUuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5Tb3J0RGlyZWN0aW9uQgi6SA'
    'WCAQIQAVINc29ydERpcmVjdGlvbjqpArpIpQIadQolcHJvdmlkZXIubGlzdF9wcm92aWRlcl9p'
    'bnN0YW5jZXMucGFnZRIqcGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdC'
    'AxGiB0aGlzLnBhZ2UgPT0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqrAQoqcHJvdmlkZXIubGlzdF9w'
    'cm92aWRlcl9pbnN0YW5jZXMucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZG'
    'VmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwgKHRo'
    'aXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKUIKCghfZW5hYmxlZE'
    'IGCgRfdGxz');

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
    {'1': 'providers', '3': 7, '4': 3, '5': 9, '8': {}, '10': 'providers'},
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
    'VGxzEkEKCXByb3ZpZGVycxgHIAMoCUIjukggkgEdCAEYASIXchUYQDIRXlthLXpdW2EtejAtOV'
    '9dKiRSCXByb3ZpZGVycxIiCgpqd3Rfc2VjcmV0GAggASgJSABSCWp3dFNlY3JldIgBARIgCglj'
    'dXN0b21fY2EYCSABKAlIAVIIY3VzdG9tQ2GIAQFCDQoLX2p3dF9zZWNyZXRCDAoKX2N1c3RvbV'
    '9jYQ==');

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
    {'1': 'providers', '3': 7, '4': 3, '5': 9, '8': {}, '10': 'providers'},
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
    'dXJlX3RscxgGIAEoCEgEUgtpbnNlY3VyZVRsc4gBARI/Cglwcm92aWRlcnMYByADKAlCIbpIHp'
    'IBGxgBIhdyFRhAMhFeW2Etel1bYS16MC05X10qJFIJcHJvdmlkZXJzEiIKCmp3dF9zZWNyZXQY'
    'CCABKAlIBVIJand0U2VjcmV0iAEBEiAKCWN1c3RvbV9jYRgJIAEoCUgGUghjdXN0b21DYYgBAR'
    'IoCg1jbGVhcl9jb21tZW50GAogASgISAdSDGNsZWFyQ29tbWVudIgBARItChBjbGVhcl9qd3Rf'
    'c2VjcmV0GAsgASgISAhSDmNsZWFySnd0U2VjcmV0iAEBEisKD2NsZWFyX2N1c3RvbV9jYRgMIA'
    'EoCEgJUg1jbGVhckN1c3RvbUNhiAEBQgsKCV9lbmRwb2ludEIKCghfY29tbWVudEISChBfdGlt'
    'ZW91dF9zZWNvbmRzQgYKBF90bHNCDwoNX2luc2VjdXJlX3Rsc0INCgtfand0X3NlY3JldEIMCg'
    'pfY3VzdG9tX2NhQhAKDl9jbGVhcl9jb21tZW50QhMKEV9jbGVhcl9qd3Rfc2VjcmV0QhIKEF9j'
    'bGVhcl9jdXN0b21fY2E=');

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
      '5': 9,
      '8': {},
      '10': 'providerType'
    },
  ],
};

/// Descriptor for `ListProviderBackendsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProviderBackendsRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UHJvdmlkZXJCYWNrZW5kc1JlcXVlc3QSPwoNcHJvdmlkZXJfdHlwZRgBIAEoCUIauk'
        'gXchUYQDIRXlthLXpdW2EtejAtOV9dKiRSDHByb3ZpZGVyVHlwZQ==');

@$core.Deprecated('Use providerProxyPathRequestDescriptor instead')
const ProviderProxyPathRequest$json = {
  '1': 'ProviderProxyPathRequest',
  '2': [
    {
      '1': 'provider_name',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerName'
    },
    {'1': 'sub_path', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'subPath'},
  ],
};

/// Descriptor for `ProviderProxyPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List providerProxyPathRequestDescriptor = $convert.base64Decode(
    'ChhQcm92aWRlclByb3h5UGF0aFJlcXVlc3QSQQoNcHJvdmlkZXJfbmFtZRgBIAEoCUIcukgZch'
    'cQARhAMhFeW2Etel1bYS16MC05X10qJFIMcHJvdmlkZXJOYW1lEtYBCghzdWJfcGF0aBgCIAEo'
    'CUK6AbpItgG6AbIBChxwcm92aWRlcl9wcm94eV9wYXRoLnN1Yl9wYXRoEkBzdWJfcGF0aCBtdX'
    'N0IGJlIDEtMjA0OCB2aXNpYmxlIGNoYXJhY3RlcnMgd2l0aG91dCBjb250cm9sIGJ5dGVzGlBz'
    'aXplKHRoaXMpID49IDEgJiYgc2l6ZSh0aGlzKSA8PSAyMDQ4ICYmICF0aGlzLm1hdGNoZXMoJy'
    '4qW1xceDAwLVxceDFGXFx4N0ZdLionKVIHc3ViUGF0aA==');

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
