// This is a generated file - do not edit.
//
// Generated from proto/providers/common_service.proto.

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

import 'common.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> ProviderCommonServiceBase$json = {
  '1': 'ProviderCommonService',
  '2': [
    {
      '1': 'ListAvailableProviderInstances',
      '2': '.synctv.provider.common.ListAvailableProviderInstancesRequest',
      '3': '.synctv.provider.common.ProviderInstancesResponse'
    },
    {
      '1': 'ListProviderBackends',
      '2': '.synctv.provider.common.ListProviderBackendsRequest',
      '3': '.synctv.provider.common.ProviderBackendsResponse'
    },
    {
      '1': 'ListProviderInstances',
      '2': '.synctv.provider.common.ListProviderInstancesRequest',
      '3': '.synctv.provider.common.ListProviderInstancesResponse'
    },
    {
      '1': 'AddProviderInstance',
      '2': '.synctv.provider.common.AddProviderInstanceRequest',
      '3': '.synctv.provider.common.AddProviderInstanceResponse'
    },
    {
      '1': 'UpdateProviderInstance',
      '2': '.synctv.provider.common.UpdateProviderInstanceRequest',
      '3': '.synctv.provider.common.UpdateProviderInstanceResponse'
    },
    {
      '1': 'DeleteProviderInstance',
      '2': '.synctv.provider.common.DeleteProviderInstanceRequest',
      '3': '.synctv.provider.common.DeleteProviderInstanceResponse'
    },
    {
      '1': 'ReconnectProviderInstance',
      '2': '.synctv.provider.common.ReconnectProviderInstanceRequest',
      '3': '.synctv.provider.common.ReconnectProviderInstanceResponse'
    },
    {
      '1': 'EnableProviderInstance',
      '2': '.synctv.provider.common.EnableProviderInstanceRequest',
      '3': '.synctv.provider.common.EnableProviderInstanceResponse'
    },
    {
      '1': 'DisableProviderInstance',
      '2': '.synctv.provider.common.DisableProviderInstanceRequest',
      '3': '.synctv.provider.common.DisableProviderInstanceResponse'
    },
  ],
};

@$core.Deprecated('Use providerCommonServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ProviderCommonServiceBase$messageJson = {
  '.synctv.provider.common.ListAvailableProviderInstancesRequest':
      $0.ListAvailableProviderInstancesRequest$json,
  '.synctv.provider.common.ProviderInstancesResponse':
      $0.ProviderInstancesResponse$json,
  '.synctv.provider.common.ListProviderBackendsRequest':
      $0.ListProviderBackendsRequest$json,
  '.synctv.provider.common.ProviderBackendsResponse':
      $0.ProviderBackendsResponse$json,
  '.synctv.provider.common.ListProviderInstancesRequest':
      $0.ListProviderInstancesRequest$json,
  '.synctv.provider.common.ListProviderInstancesResponse':
      $0.ListProviderInstancesResponse$json,
  '.synctv.provider.common.ProviderInstance': $0.ProviderInstance$json,
  '.synctv.provider.common.AddProviderInstanceRequest':
      $0.AddProviderInstanceRequest$json,
  '.synctv.provider.common.AddProviderInstanceResponse':
      $0.AddProviderInstanceResponse$json,
  '.synctv.provider.common.UpdateProviderInstanceRequest':
      $0.UpdateProviderInstanceRequest$json,
  '.synctv.provider.common.UpdateProviderInstanceResponse':
      $0.UpdateProviderInstanceResponse$json,
  '.synctv.provider.common.DeleteProviderInstanceRequest':
      $0.DeleteProviderInstanceRequest$json,
  '.synctv.provider.common.DeleteProviderInstanceResponse':
      $0.DeleteProviderInstanceResponse$json,
  '.synctv.provider.common.ReconnectProviderInstanceRequest':
      $0.ReconnectProviderInstanceRequest$json,
  '.synctv.provider.common.ReconnectProviderInstanceResponse':
      $0.ReconnectProviderInstanceResponse$json,
  '.synctv.provider.common.EnableProviderInstanceRequest':
      $0.EnableProviderInstanceRequest$json,
  '.synctv.provider.common.EnableProviderInstanceResponse':
      $0.EnableProviderInstanceResponse$json,
  '.synctv.provider.common.DisableProviderInstanceRequest':
      $0.DisableProviderInstanceRequest$json,
  '.synctv.provider.common.DisableProviderInstanceResponse':
      $0.DisableProviderInstanceResponse$json,
};

/// Descriptor for `ProviderCommonService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List providerCommonServiceDescriptor = $convert.base64Decode(
    'ChVQcm92aWRlckNvbW1vblNlcnZpY2USkgEKHkxpc3RBdmFpbGFibGVQcm92aWRlckluc3Rhbm'
    'NlcxI9LnN5bmN0di5wcm92aWRlci5jb21tb24uTGlzdEF2YWlsYWJsZVByb3ZpZGVySW5zdGFu'
    'Y2VzUmVxdWVzdBoxLnN5bmN0di5wcm92aWRlci5jb21tb24uUHJvdmlkZXJJbnN0YW5jZXNSZX'
    'Nwb25zZRJ9ChRMaXN0UHJvdmlkZXJCYWNrZW5kcxIzLnN5bmN0di5wcm92aWRlci5jb21tb24u'
    'TGlzdFByb3ZpZGVyQmFja2VuZHNSZXF1ZXN0GjAuc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5Qcm'
    '92aWRlckJhY2tlbmRzUmVzcG9uc2UShAEKFUxpc3RQcm92aWRlckluc3RhbmNlcxI0LnN5bmN0'
    'di5wcm92aWRlci5jb21tb24uTGlzdFByb3ZpZGVySW5zdGFuY2VzUmVxdWVzdBo1LnN5bmN0di'
    '5wcm92aWRlci5jb21tb24uTGlzdFByb3ZpZGVySW5zdGFuY2VzUmVzcG9uc2USfgoTQWRkUHJv'
    'dmlkZXJJbnN0YW5jZRIyLnN5bmN0di5wcm92aWRlci5jb21tb24uQWRkUHJvdmlkZXJJbnN0YW'
    '5jZVJlcXVlc3QaMy5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkFkZFByb3ZpZGVySW5zdGFuY2VS'
    'ZXNwb25zZRKHAQoWVXBkYXRlUHJvdmlkZXJJbnN0YW5jZRI1LnN5bmN0di5wcm92aWRlci5jb2'
    '1tb24uVXBkYXRlUHJvdmlkZXJJbnN0YW5jZVJlcXVlc3QaNi5zeW5jdHYucHJvdmlkZXIuY29t'
    'bW9uLlVwZGF0ZVByb3ZpZGVySW5zdGFuY2VSZXNwb25zZRKHAQoWRGVsZXRlUHJvdmlkZXJJbn'
    'N0YW5jZRI1LnN5bmN0di5wcm92aWRlci5jb21tb24uRGVsZXRlUHJvdmlkZXJJbnN0YW5jZVJl'
    'cXVlc3QaNi5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkRlbGV0ZVByb3ZpZGVySW5zdGFuY2VSZX'
    'Nwb25zZRKQAQoZUmVjb25uZWN0UHJvdmlkZXJJbnN0YW5jZRI4LnN5bmN0di5wcm92aWRlci5j'
    'b21tb24uUmVjb25uZWN0UHJvdmlkZXJJbnN0YW5jZVJlcXVlc3QaOS5zeW5jdHYucHJvdmlkZX'
    'IuY29tbW9uLlJlY29ubmVjdFByb3ZpZGVySW5zdGFuY2VSZXNwb25zZRKHAQoWRW5hYmxlUHJv'
    'dmlkZXJJbnN0YW5jZRI1LnN5bmN0di5wcm92aWRlci5jb21tb24uRW5hYmxlUHJvdmlkZXJJbn'
    'N0YW5jZVJlcXVlc3QaNi5zeW5jdHYucHJvdmlkZXIuY29tbW9uLkVuYWJsZVByb3ZpZGVySW5z'
    'dGFuY2VSZXNwb25zZRKKAQoXRGlzYWJsZVByb3ZpZGVySW5zdGFuY2USNi5zeW5jdHYucHJvdm'
    'lkZXIuY29tbW9uLkRpc2FibGVQcm92aWRlckluc3RhbmNlUmVxdWVzdBo3LnN5bmN0di5wcm92'
    'aWRlci5jb21tb24uRGlzYWJsZVByb3ZpZGVySW5zdGFuY2VSZXNwb25zZQ==');
