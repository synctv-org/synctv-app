// This is a generated file - do not edit.
//
// Generated from proto/providers/acfun_service.proto.

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
import 'acfun.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> AcFunProviderServiceBase$json = {
  '1': 'AcFunProviderService',
  '2': [
    {
      '1': 'Resolve',
      '2': '.synctv.provider.acfun.ResolveRequest',
      '3': '.synctv.provider.acfun.ResolveResponse'
    },
  ],
};

@$core.Deprecated('Use acFunProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AcFunProviderServiceBase$messageJson = {
  '.synctv.provider.acfun.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.acfun.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.acfun.Metadata': $0.Metadata$json,
  '.synctv.provider.acfun.Quality': $0.Quality$json,
  '.synctv.source_config.AcFunMediaSourceConfig':
      $1.AcFunMediaSourceConfig$json,
  '.synctv.source_config.AcFunVideoSourceConfig':
      $1.AcFunVideoSourceConfig$json,
  '.synctv.source_config.AcFunBangumiSourceConfig':
      $1.AcFunBangumiSourceConfig$json,
  '.synctv.source_config.AcFunLiveSourceConfig': $1.AcFunLiveSourceConfig$json,
};

/// Descriptor for `AcFunProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List acFunProviderServiceDescriptor = $convert.base64Decode(
    'ChRBY0Z1blByb3ZpZGVyU2VydmljZRJYCgdSZXNvbHZlEiUuc3luY3R2LnByb3ZpZGVyLmFjZn'
    'VuLlJlc29sdmVSZXF1ZXN0GiYuc3luY3R2LnByb3ZpZGVyLmFjZnVuLlJlc29sdmVSZXNwb25z'
    'ZQ==');
