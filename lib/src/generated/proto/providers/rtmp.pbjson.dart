// This is a generated file - do not edit.
//
// Generated from proto/providers/rtmp.proto.

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

@$core.Deprecated('Use createPublishKeyRequestDescriptor instead')
const CreatePublishKeyRequest$json = {
  '1': 'CreatePublishKeyRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `CreatePublishKeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPublishKeyRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVQdWJsaXNoS2V5UmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE1'
    '5yb29tX1tBLVphLXowLTldKyRSBnJvb21JZBI4CghtZWRpYV9pZBgCIAEoCUIdukgachgQARhA'
    'MhJebWVkX1tBLVphLXowLTldKyRSB21lZGlhSWQ=');

@$core.Deprecated('Use createPublishKeyResponseDescriptor instead')
const CreatePublishKeyResponse$json = {
  '1': 'CreatePublishKeyResponse',
  '2': [
    {'1': 'publish_key', '3': 1, '4': 1, '5': 9, '10': 'publishKey'},
    {'1': 'rtmp_url', '3': 2, '4': 1, '5': 9, '10': 'rtmpUrl'},
    {'1': 'stream_key', '3': 3, '4': 1, '5': 9, '10': 'streamKey'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `CreatePublishKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPublishKeyResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVQdWJsaXNoS2V5UmVzcG9uc2USHwoLcHVibGlzaF9rZXkYASABKAlSCnB1Ymxpc2'
    'hLZXkSGQoIcnRtcF91cmwYAiABKAlSB3J0bXBVcmwSHQoKc3RyZWFtX2tleRgDIAEoCVIJc3Ry'
    'ZWFtS2V5Eh0KCmV4cGlyZXNfYXQYBCABKANSCWV4cGlyZXNBdA==');

@$core.Deprecated('Use getStreamInfoRequestDescriptor instead')
const GetStreamInfoRequest$json = {
  '1': 'GetStreamInfoRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `GetStreamInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStreamInfoRequestDescriptor = $convert.base64Decode(
    'ChRHZXRTdHJlYW1JbmZvUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE15yb2'
    '9tX1tBLVphLXowLTldKyRSBnJvb21JZBI4CghtZWRpYV9pZBgCIAEoCUIdukgachgQARhAMhJe'
    'bWVkX1tBLVphLXowLTldKyRSB21lZGlhSWQ=');

@$core.Deprecated('Use streamPublisherInfoDescriptor instead')
const StreamPublisherInfo$json = {
  '1': 'StreamPublisherInfo',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'started_at', '3': 2, '4': 1, '5': 3, '10': 'startedAt'},
  ],
};

/// Descriptor for `StreamPublisherInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamPublisherInfoDescriptor = $convert.base64Decode(
    'ChNTdHJlYW1QdWJsaXNoZXJJbmZvEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIdCgpzdGFydG'
    'VkX2F0GAIgASgDUglzdGFydGVkQXQ=');

@$core.Deprecated('Use getStreamInfoResponseDescriptor instead')
const GetStreamInfoResponse$json = {
  '1': 'GetStreamInfoResponse',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'publisher',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.rtmp.StreamPublisherInfo',
      '10': 'publisher'
    },
  ],
};

/// Descriptor for `GetStreamInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStreamInfoResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTdHJlYW1JbmZvUmVzcG9uc2USFgoGYWN0aXZlGAEgASgIUgZhY3RpdmUSRwoJcHVibG'
    'lzaGVyGAIgASgLMikuc3luY3R2LnByb3ZpZGVyLnJ0bXAuU3RyZWFtUHVibGlzaGVySW5mb1IJ'
    'cHVibGlzaGVy');
