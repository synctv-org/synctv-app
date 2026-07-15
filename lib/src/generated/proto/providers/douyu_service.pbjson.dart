// This is a generated file - do not edit.
//
// Generated from proto/providers/douyu_service.proto.

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

import '../source_config.pbjson.dart' as $1;
import 'douyu.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> DouyuProviderServiceBase$json = {
  '1': 'DouyuProviderService',
  '2': [
    {
      '1': 'Resolve',
      '2': '.synctv.provider.douyu.ResolveRequest',
      '3': '.synctv.provider.douyu.ResolveResponse'
    },
  ],
};

@$core.Deprecated('Use douyuProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DouyuProviderServiceBase$messageJson = {
  '.synctv.provider.douyu.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.douyu.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.douyu.Metadata': $0.Metadata$json,
  '.synctv.provider.douyu.Quality': $0.Quality$json,
  '.synctv.source_config.DouyuMediaSourceConfig':
      $1.DouyuMediaSourceConfig$json,
};

/// Descriptor for `DouyuProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List douyuProviderServiceDescriptor = $convert.base64Decode(
    'ChREb3V5dVByb3ZpZGVyU2VydmljZRJYCgdSZXNvbHZlEiUuc3luY3R2LnByb3ZpZGVyLmRvdX'
    'l1LlJlc29sdmVSZXF1ZXN0GiYuc3luY3R2LnByb3ZpZGVyLmRvdXl1LlJlc29sdmVSZXNwb25z'
    'ZQ==');
