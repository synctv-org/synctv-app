// This is a generated file - do not edit.
//
// Generated from proto/providers/rtmp_service.proto.

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

import 'rtmp.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> RtmpProviderServiceBase$json = {
  '1': 'RtmpProviderService',
  '2': [
    {
      '1': 'CreatePublishKey',
      '2': '.synctv.provider.rtmp.CreatePublishKeyRequest',
      '3': '.synctv.provider.rtmp.CreatePublishKeyResponse'
    },
    {
      '1': 'GetStreamInfo',
      '2': '.synctv.provider.rtmp.GetStreamInfoRequest',
      '3': '.synctv.provider.rtmp.GetStreamInfoResponse'
    },
  ],
};

@$core.Deprecated('Use rtmpProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RtmpProviderServiceBase$messageJson = {
  '.synctv.provider.rtmp.CreatePublishKeyRequest':
      $0.CreatePublishKeyRequest$json,
  '.synctv.provider.rtmp.CreatePublishKeyResponse':
      $0.CreatePublishKeyResponse$json,
  '.synctv.provider.rtmp.GetStreamInfoRequest': $0.GetStreamInfoRequest$json,
  '.synctv.provider.rtmp.GetStreamInfoResponse': $0.GetStreamInfoResponse$json,
  '.synctv.provider.rtmp.StreamPublisherInfo': $0.StreamPublisherInfo$json,
};

/// Descriptor for `RtmpProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List rtmpProviderServiceDescriptor = $convert.base64Decode(
    'ChNSdG1wUHJvdmlkZXJTZXJ2aWNlEnEKEENyZWF0ZVB1Ymxpc2hLZXkSLS5zeW5jdHYucHJvdm'
    'lkZXIucnRtcC5DcmVhdGVQdWJsaXNoS2V5UmVxdWVzdBouLnN5bmN0di5wcm92aWRlci5ydG1w'
    'LkNyZWF0ZVB1Ymxpc2hLZXlSZXNwb25zZRJoCg1HZXRTdHJlYW1JbmZvEiouc3luY3R2LnByb3'
    'ZpZGVyLnJ0bXAuR2V0U3RyZWFtSW5mb1JlcXVlc3QaKy5zeW5jdHYucHJvdmlkZXIucnRtcC5H'
    'ZXRTdHJlYW1JbmZvUmVzcG9uc2U=');
