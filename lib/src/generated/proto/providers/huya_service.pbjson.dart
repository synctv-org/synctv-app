// This is a generated file - do not edit.
//
// Generated from proto/providers/huya_service.proto.

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
import 'huya.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> HuyaProviderServiceBase$json = {
  '1': 'HuyaProviderService',
  '2': [
    {
      '1': 'Resolve',
      '2': '.synctv.provider.huya.ResolveRequest',
      '3': '.synctv.provider.huya.ResolveResponse'
    },
  ],
};

@$core.Deprecated('Use huyaProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    HuyaProviderServiceBase$messageJson = {
  '.synctv.provider.huya.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.huya.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.huya.Metadata': $0.Metadata$json,
  '.synctv.provider.huya.Quality': $0.Quality$json,
  '.synctv.source_config.HuyaMediaSourceConfig': $1.HuyaMediaSourceConfig$json,
  '.synctv.source_config.HuyaLiveSourceConfig': $1.HuyaLiveSourceConfig$json,
  '.synctv.source_config.HuyaVideoSourceConfig': $1.HuyaVideoSourceConfig$json,
};

/// Descriptor for `HuyaProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List huyaProviderServiceDescriptor = $convert.base64Decode(
    'ChNIdXlhUHJvdmlkZXJTZXJ2aWNlElYKB1Jlc29sdmUSJC5zeW5jdHYucHJvdmlkZXIuaHV5YS'
    '5SZXNvbHZlUmVxdWVzdBolLnN5bmN0di5wcm92aWRlci5odXlhLlJlc29sdmVSZXNwb25zZQ==');
