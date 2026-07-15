// This is a generated file - do not edit.
//
// Generated from proto/providers/tiktok_service.proto.

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
import 'tiktok.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> TikTokProviderServiceBase$json = {
  '1': 'TikTokProviderService',
  '2': [
    {
      '1': 'Bind',
      '2': '.synctv.provider.tiktok.BindRequest',
      '3': '.synctv.provider.tiktok.BindResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.tiktok.GetBindsRequest',
      '3': '.synctv.provider.tiktok.GetBindsResponse'
    },
    {
      '1': 'Unbind',
      '2': '.synctv.provider.tiktok.UnbindRequest',
      '3': '.synctv.provider.tiktok.UnbindResponse'
    },
    {
      '1': 'Resolve',
      '2': '.synctv.provider.tiktok.ResolveRequest',
      '3': '.synctv.provider.tiktok.ResolveResponse'
    },
    {
      '1': 'GetUser',
      '2': '.synctv.provider.tiktok.GetUserRequest',
      '3': '.synctv.provider.tiktok.GetUserResponse'
    },
    {
      '1': 'ListUserPosts',
      '2': '.synctv.provider.tiktok.ListUserPostsRequest',
      '3': '.synctv.provider.tiktok.ListUserPostsResponse'
    },
  ],
};

@$core.Deprecated('Use tikTokProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TikTokProviderServiceBase$messageJson = {
  '.synctv.provider.tiktok.BindRequest': $0.BindRequest$json,
  '.synctv.provider.tiktok.BindResponse': $0.BindResponse$json,
  '.synctv.provider.tiktok.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.tiktok.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.tiktok.BindInfo': $0.BindInfo$json,
  '.synctv.provider.tiktok.UnbindRequest': $0.UnbindRequest$json,
  '.synctv.provider.tiktok.UnbindResponse': $0.UnbindResponse$json,
  '.synctv.provider.tiktok.ResolveRequest': $0.ResolveRequest$json,
  '.synctv.provider.tiktok.ResolveResponse': $0.ResolveResponse$json,
  '.synctv.provider.tiktok.Metadata': $0.Metadata$json,
  '.synctv.provider.tiktok.Author': $0.Author$json,
  '.synctv.provider.tiktok.Image': $0.Image$json,
  '.synctv.provider.tiktok.Subtitle': $0.Subtitle$json,
  '.synctv.provider.tiktok.Variant': $0.Variant$json,
  '.synctv.source_config.TikTokMediaSourceConfig':
      $1.TikTokMediaSourceConfig$json,
  '.synctv.source_config.TikTokVideoSourceConfig':
      $1.TikTokVideoSourceConfig$json,
  '.synctv.source_config.TikTokLiveSourceConfig':
      $1.TikTokLiveSourceConfig$json,
  '.synctv.provider.tiktok.GetUserRequest': $0.GetUserRequest$json,
  '.synctv.provider.tiktok.GetUserResponse': $0.GetUserResponse$json,
  '.synctv.source_config.TikTokPlaylistSourceConfig':
      $1.TikTokPlaylistSourceConfig$json,
  '.synctv.provider.tiktok.ListUserPostsRequest': $0.ListUserPostsRequest$json,
  '.synctv.provider.tiktok.ListUserPostsResponse':
      $0.ListUserPostsResponse$json,
  '.synctv.provider.tiktok.ListItem': $0.ListItem$json,
};

/// Descriptor for `TikTokProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List tikTokProviderServiceDescriptor = $convert.base64Decode(
    'ChVUaWtUb2tQcm92aWRlclNlcnZpY2USUQoEQmluZBIjLnN5bmN0di5wcm92aWRlci50aWt0b2'
    'suQmluZFJlcXVlc3QaJC5zeW5jdHYucHJvdmlkZXIudGlrdG9rLkJpbmRSZXNwb25zZRJdCghH'
    'ZXRCaW5kcxInLnN5bmN0di5wcm92aWRlci50aWt0b2suR2V0QmluZHNSZXF1ZXN0Giguc3luY3'
    'R2LnByb3ZpZGVyLnRpa3Rvay5HZXRCaW5kc1Jlc3BvbnNlElcKBlVuYmluZBIlLnN5bmN0di5w'
    'cm92aWRlci50aWt0b2suVW5iaW5kUmVxdWVzdBomLnN5bmN0di5wcm92aWRlci50aWt0b2suVW'
    '5iaW5kUmVzcG9uc2USWgoHUmVzb2x2ZRImLnN5bmN0di5wcm92aWRlci50aWt0b2suUmVzb2x2'
    'ZVJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIudGlrdG9rLlJlc29sdmVSZXNwb25zZRJaCgdHZX'
    'RVc2VyEiYuc3luY3R2LnByb3ZpZGVyLnRpa3Rvay5HZXRVc2VyUmVxdWVzdBonLnN5bmN0di5w'
    'cm92aWRlci50aWt0b2suR2V0VXNlclJlc3BvbnNlEmwKDUxpc3RVc2VyUG9zdHMSLC5zeW5jdH'
    'YucHJvdmlkZXIudGlrdG9rLkxpc3RVc2VyUG9zdHNSZXF1ZXN0Gi0uc3luY3R2LnByb3ZpZGVy'
    'LnRpa3Rvay5MaXN0VXNlclBvc3RzUmVzcG9uc2U=');
