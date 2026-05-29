// This is a generated file - do not edit.
//
// Generated from proto/providers/emby_service.proto.

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

import 'emby.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> EmbyProviderServiceBase$json = {
  '1': 'EmbyProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.emby.LoginRequest',
      '3': '.synctv.provider.emby.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.emby.ListRequest',
      '3': '.synctv.provider.emby.ListResponse'
    },
    {
      '1': 'GetMe',
      '2': '.synctv.provider.emby.GetMeRequest',
      '3': '.synctv.provider.emby.GetMeResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.emby.LogoutRequest',
      '3': '.synctv.provider.emby.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.emby.GetBindsRequest',
      '3': '.synctv.provider.emby.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use embyProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    EmbyProviderServiceBase$messageJson = {
  '.synctv.provider.emby.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.emby.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.emby.ListRequest': $0.ListRequest$json,
  '.synctv.provider.emby.ListResponse': $0.ListResponse$json,
  '.synctv.provider.emby.MediaItem': $0.MediaItem$json,
  '.synctv.provider.emby.GetMeRequest': $0.GetMeRequest$json,
  '.synctv.provider.emby.GetMeResponse': $0.GetMeResponse$json,
  '.synctv.provider.emby.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.emby.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.emby.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.emby.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.emby.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `EmbyProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List embyProviderServiceDescriptor = $convert.base64Decode(
    'ChNFbWJ5UHJvdmlkZXJTZXJ2aWNlElAKBUxvZ2luEiIuc3luY3R2LnByb3ZpZGVyLmVtYnkuTG'
    '9naW5SZXF1ZXN0GiMuc3luY3R2LnByb3ZpZGVyLmVtYnkuTG9naW5SZXNwb25zZRJNCgRMaXN0'
    'EiEuc3luY3R2LnByb3ZpZGVyLmVtYnkuTGlzdFJlcXVlc3QaIi5zeW5jdHYucHJvdmlkZXIuZW'
    '1ieS5MaXN0UmVzcG9uc2USUAoFR2V0TWUSIi5zeW5jdHYucHJvdmlkZXIuZW1ieS5HZXRNZVJl'
    'cXVlc3QaIy5zeW5jdHYucHJvdmlkZXIuZW1ieS5HZXRNZVJlc3BvbnNlElMKBkxvZ291dBIjLn'
    'N5bmN0di5wcm92aWRlci5lbWJ5LkxvZ291dFJlcXVlc3QaJC5zeW5jdHYucHJvdmlkZXIuZW1i'
    'eS5Mb2dvdXRSZXNwb25zZRJZCghHZXRCaW5kcxIlLnN5bmN0di5wcm92aWRlci5lbWJ5LkdldE'
    'JpbmRzUmVxdWVzdBomLnN5bmN0di5wcm92aWRlci5lbWJ5LkdldEJpbmRzUmVzcG9uc2U=');
