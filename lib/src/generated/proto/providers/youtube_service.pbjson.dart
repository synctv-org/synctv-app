// This is a generated file - do not edit.
//
// Generated from proto/providers/youtube_service.proto.

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
import 'youtube.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> YoutubeProviderServiceBase$json = {
  '1': 'YoutubeProviderService',
  '2': [
    {
      '1': 'Bind',
      '2': '.synctv.provider.youtube.BindRequest',
      '3': '.synctv.provider.youtube.BindResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.youtube.GetBindsRequest',
      '3': '.synctv.provider.youtube.GetBindsResponse'
    },
    {
      '1': 'Unbind',
      '2': '.synctv.provider.youtube.UnbindRequest',
      '3': '.synctv.provider.youtube.UnbindResponse'
    },
    {
      '1': 'Resolve',
      '2': '.synctv.provider.youtube.ResolveRequest',
      '3': '.synctv.provider.youtube.ResolveResponse'
    },
  ],
};

@$core.Deprecated('Use youtubeProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    YoutubeProviderServiceBase$messageJson = {
  '.synctv.provider.youtube.BindRequest': $0.BindRequest$json,
  '.synctv.provider.youtube.BindResponse': $0.BindResponse$json,
  '.synctv.provider.youtube.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.youtube.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.youtube.BindInfo': $0.BindInfo$json,
  '.synctv.provider.youtube.UnbindRequest': $0.UnbindRequest$json,
  '.synctv.provider.youtube.UnbindResponse': $0.UnbindResponse$json,
  '.synctv.provider.youtube.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.youtube.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.youtube.Metadata': $0.Metadata$json,
  '.synctv.provider.youtube.Format': $0.Format$json,
  '.synctv.provider.youtube.Subtitle': $0.Subtitle$json,
  '.synctv.source_config.YoutubeMediaSourceConfig':
      $1.YoutubeMediaSourceConfig$json,
};

/// Descriptor for `YoutubeProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List youtubeProviderServiceDescriptor = $convert.base64Decode(
    'ChZZb3V0dWJlUHJvdmlkZXJTZXJ2aWNlElMKBEJpbmQSJC5zeW5jdHYucHJvdmlkZXIueW91dH'
    'ViZS5CaW5kUmVxdWVzdBolLnN5bmN0di5wcm92aWRlci55b3V0dWJlLkJpbmRSZXNwb25zZRJf'
    'CghHZXRCaW5kcxIoLnN5bmN0di5wcm92aWRlci55b3V0dWJlLkdldEJpbmRzUmVxdWVzdBopLn'
    'N5bmN0di5wcm92aWRlci55b3V0dWJlLkdldEJpbmRzUmVzcG9uc2USWQoGVW5iaW5kEiYuc3lu'
    'Y3R2LnByb3ZpZGVyLnlvdXR1YmUuVW5iaW5kUmVxdWVzdBonLnN5bmN0di5wcm92aWRlci55b3'
    'V0dWJlLlVuYmluZFJlc3BvbnNlElwKB1Jlc29sdmUSJy5zeW5jdHYucHJvdmlkZXIueW91dHVi'
    'ZS5SZXNvbHZlUmVxdWVzdBooLnN5bmN0di5wcm92aWRlci55b3V0dWJlLlJlc29sdmVSZXNwb2'
    '5zZQ==');
