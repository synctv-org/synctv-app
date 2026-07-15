// This is a generated file - do not edit.
//
// Generated from proto/providers/douyin_service.proto.

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
import 'douyin.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> DouyinProviderServiceBase$json = {
  '1': 'DouyinProviderService',
  '2': [
    {
      '1': 'Bind',
      '2': '.synctv.provider.douyin.BindRequest',
      '3': '.synctv.provider.douyin.BindResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.douyin.GetBindsRequest',
      '3': '.synctv.provider.douyin.GetBindsResponse'
    },
    {
      '1': 'Unbind',
      '2': '.synctv.provider.douyin.UnbindRequest',
      '3': '.synctv.provider.douyin.UnbindResponse'
    },
    {
      '1': 'Resolve',
      '2': '.synctv.provider.douyin.ResolveRequest',
      '3': '.synctv.provider.douyin.ResolveResponse'
    },
    {
      '1': 'ListUserPosts',
      '2': '.synctv.provider.douyin.ListUserPostsRequest',
      '3': '.synctv.provider.douyin.ListUserPostsResponse'
    },
  ],
};

@$core.Deprecated('Use douyinProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DouyinProviderServiceBase$messageJson = {
  '.synctv.provider.douyin.BindRequest': $0.BindRequest$json,
  '.synctv.provider.douyin.BindResponse': $0.BindResponse$json,
  '.synctv.provider.douyin.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.douyin.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.douyin.BindInfo': $0.BindInfo$json,
  '.synctv.provider.douyin.UnbindRequest': $0.UnbindRequest$json,
  '.synctv.provider.douyin.UnbindResponse': $0.UnbindResponse$json,
  '.synctv.provider.douyin.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.douyin.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.douyin.Metadata': $0.Metadata$json,
  '.synctv.provider.douyin.Author': $0.Author$json,
  '.synctv.provider.douyin.Image': $0.Image$json,
  '.synctv.provider.douyin.Variant': $0.Variant$json,
  '.synctv.source_config.DouyinMediaSourceConfig':
      $1.DouyinMediaSourceConfig$json,
  '.synctv.source_config.DouyinVideoSourceConfig':
      $1.DouyinVideoSourceConfig$json,
  '.synctv.source_config.DouyinLiveSourceConfig':
      $1.DouyinLiveSourceConfig$json,
  '.synctv.provider.douyin.ListUserPostsRequest': $0.ListUserPostsRequest$json,
  '.synctv.provider.douyin.ListUserPostsResponse':
      $0.ListUserPostsResponse$json,
  '.synctv.provider.douyin.ListItem': $0.ListItem$json,
  '.synctv.source_config.DouyinPlaylistSourceConfig':
      $1.DouyinPlaylistSourceConfig$json,
};

/// Descriptor for `DouyinProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List douyinProviderServiceDescriptor = $convert.base64Decode(
    'ChVEb3V5aW5Qcm92aWRlclNlcnZpY2USUQoEQmluZBIjLnN5bmN0di5wcm92aWRlci5kb3V5aW'
    '4uQmluZFJlcXVlc3QaJC5zeW5jdHYucHJvdmlkZXIuZG91eWluLkJpbmRSZXNwb25zZRJdCghH'
    'ZXRCaW5kcxInLnN5bmN0di5wcm92aWRlci5kb3V5aW4uR2V0QmluZHNSZXF1ZXN0Giguc3luY3'
    'R2LnByb3ZpZGVyLmRvdXlpbi5HZXRCaW5kc1Jlc3BvbnNlElcKBlVuYmluZBIlLnN5bmN0di5w'
    'cm92aWRlci5kb3V5aW4uVW5iaW5kUmVxdWVzdBomLnN5bmN0di5wcm92aWRlci5kb3V5aW4uVW'
    '5iaW5kUmVzcG9uc2USWgoHUmVzb2x2ZRImLnN5bmN0di5wcm92aWRlci5kb3V5aW4uUmVzb2x2'
    'ZVJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIuZG91eWluLlJlc29sdmVSZXNwb25zZRJsCg1MaX'
    'N0VXNlclBvc3RzEiwuc3luY3R2LnByb3ZpZGVyLmRvdXlpbi5MaXN0VXNlclBvc3RzUmVxdWVz'
    'dBotLnN5bmN0di5wcm92aWRlci5kb3V5aW4uTGlzdFVzZXJQb3N0c1Jlc3BvbnNl');
