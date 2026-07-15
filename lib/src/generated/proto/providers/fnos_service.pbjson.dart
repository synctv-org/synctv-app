// This is a generated file - do not edit.
//
// Generated from proto/providers/fnos_service.proto.

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

import 'fnos.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> FnosProviderServiceBase$json = {
  '1': 'FnosProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.fnos.LoginRequest',
      '3': '.synctv.provider.fnos.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.fnos.ListRequest',
      '3': '.synctv.provider.fnos.ListResponse'
    },
    {
      '1': 'ListMediaLibraries',
      '2': '.synctv.provider.fnos.ListMediaLibrariesRequest',
      '3': '.synctv.provider.fnos.ListMediaLibrariesResponse'
    },
    {
      '1': 'ListMediaItems',
      '2': '.synctv.provider.fnos.ListMediaItemsRequest',
      '3': '.synctv.provider.fnos.ListMediaItemsResponse'
    },
    {
      '1': 'SetFavorite',
      '2': '.synctv.provider.fnos.SetFavoriteRequest',
      '3': '.synctv.provider.fnos.SetFavoriteResponse'
    },
    {
      '1': 'SetWatched',
      '2': '.synctv.provider.fnos.SetWatchedRequest',
      '3': '.synctv.provider.fnos.SetWatchedResponse'
    },
    {
      '1': 'GetServerInfo',
      '2': '.synctv.provider.fnos.GetServerInfoRequest',
      '3': '.synctv.provider.fnos.GetServerInfoResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.fnos.LogoutRequest',
      '3': '.synctv.provider.fnos.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.fnos.GetBindsRequest',
      '3': '.synctv.provider.fnos.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use fnosProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    FnosProviderServiceBase$messageJson = {
  '.synctv.provider.fnos.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.fnos.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.fnos.Authenticated': $0.Authenticated$json,
  '.synctv.provider.fnos.TwoFactorRequired': $0.TwoFactorRequired$json,
  '.synctv.provider.fnos.ListRequest': $0.ListRequest$json,
  '.synctv.provider.fnos.ListResponse': $0.ListResponse$json,
  '.synctv.provider.fnos.FileItem': $0.FileItem$json,
  '.synctv.provider.fnos.ListMediaLibrariesRequest':
      $0.ListMediaLibrariesRequest$json,
  '.synctv.provider.fnos.ListMediaLibrariesResponse':
      $0.ListMediaLibrariesResponse$json,
  '.synctv.provider.fnos.MediaLibrary': $0.MediaLibrary$json,
  '.synctv.provider.fnos.ListMediaItemsRequest': $0.ListMediaItemsRequest$json,
  '.synctv.provider.fnos.ListMediaItemsResponse':
      $0.ListMediaItemsResponse$json,
  '.synctv.provider.fnos.MediaItem': $0.MediaItem$json,
  '.synctv.provider.fnos.SetFavoriteRequest': $0.SetFavoriteRequest$json,
  '.synctv.provider.fnos.SetFavoriteResponse': $0.SetFavoriteResponse$json,
  '.synctv.provider.fnos.SetWatchedRequest': $0.SetWatchedRequest$json,
  '.synctv.provider.fnos.SetWatchedResponse': $0.SetWatchedResponse$json,
  '.synctv.provider.fnos.GetServerInfoRequest': $0.GetServerInfoRequest$json,
  '.synctv.provider.fnos.GetServerInfoResponse': $0.GetServerInfoResponse$json,
  '.synctv.provider.fnos.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.fnos.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.fnos.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.fnos.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.fnos.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `FnosProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List fnosProviderServiceDescriptor = $convert.base64Decode(
    'ChNGbm9zUHJvdmlkZXJTZXJ2aWNlElAKBUxvZ2luEiIuc3luY3R2LnByb3ZpZGVyLmZub3MuTG'
    '9naW5SZXF1ZXN0GiMuc3luY3R2LnByb3ZpZGVyLmZub3MuTG9naW5SZXNwb25zZRJNCgRMaXN0'
    'EiEuc3luY3R2LnByb3ZpZGVyLmZub3MuTGlzdFJlcXVlc3QaIi5zeW5jdHYucHJvdmlkZXIuZm'
    '5vcy5MaXN0UmVzcG9uc2USdwoSTGlzdE1lZGlhTGlicmFyaWVzEi8uc3luY3R2LnByb3ZpZGVy'
    'LmZub3MuTGlzdE1lZGlhTGlicmFyaWVzUmVxdWVzdBowLnN5bmN0di5wcm92aWRlci5mbm9zLk'
    'xpc3RNZWRpYUxpYnJhcmllc1Jlc3BvbnNlEmsKDkxpc3RNZWRpYUl0ZW1zEisuc3luY3R2LnBy'
    'b3ZpZGVyLmZub3MuTGlzdE1lZGlhSXRlbXNSZXF1ZXN0Giwuc3luY3R2LnByb3ZpZGVyLmZub3'
    'MuTGlzdE1lZGlhSXRlbXNSZXNwb25zZRJiCgtTZXRGYXZvcml0ZRIoLnN5bmN0di5wcm92aWRl'
    'ci5mbm9zLlNldEZhdm9yaXRlUmVxdWVzdBopLnN5bmN0di5wcm92aWRlci5mbm9zLlNldEZhdm'
    '9yaXRlUmVzcG9uc2USXwoKU2V0V2F0Y2hlZBInLnN5bmN0di5wcm92aWRlci5mbm9zLlNldFdh'
    'dGNoZWRSZXF1ZXN0Giguc3luY3R2LnByb3ZpZGVyLmZub3MuU2V0V2F0Y2hlZFJlc3BvbnNlEm'
    'gKDUdldFNlcnZlckluZm8SKi5zeW5jdHYucHJvdmlkZXIuZm5vcy5HZXRTZXJ2ZXJJbmZvUmVx'
    'dWVzdBorLnN5bmN0di5wcm92aWRlci5mbm9zLkdldFNlcnZlckluZm9SZXNwb25zZRJTCgZMb2'
    'dvdXQSIy5zeW5jdHYucHJvdmlkZXIuZm5vcy5Mb2dvdXRSZXF1ZXN0GiQuc3luY3R2LnByb3Zp'
    'ZGVyLmZub3MuTG9nb3V0UmVzcG9uc2USWQoIR2V0QmluZHMSJS5zeW5jdHYucHJvdmlkZXIuZm'
    '5vcy5HZXRCaW5kc1JlcXVlc3QaJi5zeW5jdHYucHJvdmlkZXIuZm5vcy5HZXRCaW5kc1Jlc3Bv'
    'bnNl');
