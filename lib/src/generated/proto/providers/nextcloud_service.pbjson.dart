// This is a generated file - do not edit.
//
// Generated from proto/providers/nextcloud_service.proto.

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

import 'nextcloud.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> NextcloudProviderServiceBase$json =
    {
  '1': 'NextcloudProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.nextcloud.LoginRequest',
      '3': '.synctv.provider.nextcloud.LoginResponse'
    },
    {
      '1': 'StartLoginFlow',
      '2': '.synctv.provider.nextcloud.StartLoginFlowRequest',
      '3': '.synctv.provider.nextcloud.StartLoginFlowResponse'
    },
    {
      '1': 'PollLoginFlow',
      '2': '.synctv.provider.nextcloud.PollLoginFlowRequest',
      '3': '.synctv.provider.nextcloud.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.nextcloud.ListRequest',
      '3': '.synctv.provider.nextcloud.ListResponse'
    },
    {
      '1': 'ListFavorites',
      '2': '.synctv.provider.nextcloud.ListFavoritesRequest',
      '3': '.synctv.provider.nextcloud.ListResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.nextcloud.LogoutRequest',
      '3': '.synctv.provider.nextcloud.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.nextcloud.GetBindsRequest',
      '3': '.synctv.provider.nextcloud.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use nextcloudProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    NextcloudProviderServiceBase$messageJson = {
  '.synctv.provider.nextcloud.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.nextcloud.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.nextcloud.StartLoginFlowRequest':
      $0.StartLoginFlowRequest$json,
  '.synctv.provider.nextcloud.StartLoginFlowResponse':
      $0.StartLoginFlowResponse$json,
  '.synctv.provider.nextcloud.PollLoginFlowRequest':
      $0.PollLoginFlowRequest$json,
  '.synctv.provider.nextcloud.ListRequest': $0.ListRequest$json,
  '.synctv.provider.nextcloud.ListResponse': $0.ListResponse$json,
  '.synctv.provider.nextcloud.FileItem': $0.FileItem$json,
  '.synctv.provider.nextcloud.ListFavoritesRequest':
      $0.ListFavoritesRequest$json,
  '.synctv.provider.nextcloud.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.nextcloud.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.nextcloud.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.nextcloud.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.nextcloud.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `NextcloudProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List nextcloudProviderServiceDescriptor = $convert.base64Decode(
    'ChhOZXh0Y2xvdWRQcm92aWRlclNlcnZpY2USWgoFTG9naW4SJy5zeW5jdHYucHJvdmlkZXIubm'
    'V4dGNsb3VkLkxvZ2luUmVxdWVzdBooLnN5bmN0di5wcm92aWRlci5uZXh0Y2xvdWQuTG9naW5S'
    'ZXNwb25zZRJ1Cg5TdGFydExvZ2luRmxvdxIwLnN5bmN0di5wcm92aWRlci5uZXh0Y2xvdWQuU3'
    'RhcnRMb2dpbkZsb3dSZXF1ZXN0GjEuc3luY3R2LnByb3ZpZGVyLm5leHRjbG91ZC5TdGFydExv'
    'Z2luRmxvd1Jlc3BvbnNlEmoKDVBvbGxMb2dpbkZsb3cSLy5zeW5jdHYucHJvdmlkZXIubmV4dG'
    'Nsb3VkLlBvbGxMb2dpbkZsb3dSZXF1ZXN0Giguc3luY3R2LnByb3ZpZGVyLm5leHRjbG91ZC5M'
    'b2dpblJlc3BvbnNlElcKBExpc3QSJi5zeW5jdHYucHJvdmlkZXIubmV4dGNsb3VkLkxpc3RSZX'
    'F1ZXN0Gicuc3luY3R2LnByb3ZpZGVyLm5leHRjbG91ZC5MaXN0UmVzcG9uc2USaQoNTGlzdEZh'
    'dm9yaXRlcxIvLnN5bmN0di5wcm92aWRlci5uZXh0Y2xvdWQuTGlzdEZhdm9yaXRlc1JlcXVlc3'
    'QaJy5zeW5jdHYucHJvdmlkZXIubmV4dGNsb3VkLkxpc3RSZXNwb25zZRJdCgZMb2dvdXQSKC5z'
    'eW5jdHYucHJvdmlkZXIubmV4dGNsb3VkLkxvZ291dFJlcXVlc3QaKS5zeW5jdHYucHJvdmlkZX'
    'IubmV4dGNsb3VkLkxvZ291dFJlc3BvbnNlEmMKCEdldEJpbmRzEiouc3luY3R2LnByb3ZpZGVy'
    'Lm5leHRjbG91ZC5HZXRCaW5kc1JlcXVlc3QaKy5zeW5jdHYucHJvdmlkZXIubmV4dGNsb3VkLk'
    'dldEJpbmRzUmVzcG9uc2U=');
