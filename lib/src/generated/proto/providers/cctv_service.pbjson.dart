// This is a generated file - do not edit.
//
// Generated from proto/providers/cctv_service.proto.

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
import 'cctv.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> CctvProviderServiceBase$json = {
  '1': 'CctvProviderService',
  '2': [
    {
      '1': 'Resolve',
      '2': '.synctv.provider.cctv.ResolveRequest',
      '3': '.synctv.provider.cctv.ResolveResponse'
    },
  ],
};

@$core.Deprecated('Use cctvProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CctvProviderServiceBase$messageJson = {
  '.synctv.provider.cctv.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.cctv.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.cctv.Metadata': $0.Metadata$json,
  '.synctv.provider.cctv.Chapter': $0.Chapter$json,
  '.synctv.provider.cctv.Stream': $0.Stream$json,
  '.synctv.source_config.CctvMediaSourceConfig': $1.CctvMediaSourceConfig$json,
};

/// Descriptor for `CctvProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List cctvProviderServiceDescriptor = $convert.base64Decode(
    'ChNDY3R2UHJvdmlkZXJTZXJ2aWNlElYKB1Jlc29sdmUSJC5zeW5jdHYucHJvdmlkZXIuY2N0di'
    '5SZXNvbHZlUmVxdWVzdBolLnN5bmN0di5wcm92aWRlci5jY3R2LlJlc29sdmVSZXNwb25zZQ==');
