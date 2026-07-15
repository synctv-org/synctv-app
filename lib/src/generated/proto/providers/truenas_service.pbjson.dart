// This is a generated file - do not edit.
//
// Generated from proto/providers/truenas_service.proto.

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

import 'truenas.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> TrueNasProviderServiceBase$json = {
  '1': 'TrueNasProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.truenas.LoginRequest',
      '3': '.synctv.provider.truenas.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.truenas.ListRequest',
      '3': '.synctv.provider.truenas.ListResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.truenas.LogoutRequest',
      '3': '.synctv.provider.truenas.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.truenas.GetBindsRequest',
      '3': '.synctv.provider.truenas.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use trueNasProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TrueNasProviderServiceBase$messageJson = {
  '.synctv.provider.truenas.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.truenas.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.truenas.ListRequest': $0.ListRequest$json,
  '.synctv.provider.truenas.ListResponse': $0.ListResponse$json,
  '.synctv.provider.truenas.FileItem': $0.FileItem$json,
  '.synctv.provider.truenas.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.truenas.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.truenas.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.truenas.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.truenas.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `TrueNasProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List trueNasProviderServiceDescriptor = $convert.base64Decode(
    'ChZUcnVlTmFzUHJvdmlkZXJTZXJ2aWNlElYKBUxvZ2luEiUuc3luY3R2LnByb3ZpZGVyLnRydW'
    'VuYXMuTG9naW5SZXF1ZXN0GiYuc3luY3R2LnByb3ZpZGVyLnRydWVuYXMuTG9naW5SZXNwb25z'
    'ZRJTCgRMaXN0EiQuc3luY3R2LnByb3ZpZGVyLnRydWVuYXMuTGlzdFJlcXVlc3QaJS5zeW5jdH'
    'YucHJvdmlkZXIudHJ1ZW5hcy5MaXN0UmVzcG9uc2USWQoGTG9nb3V0EiYuc3luY3R2LnByb3Zp'
    'ZGVyLnRydWVuYXMuTG9nb3V0UmVxdWVzdBonLnN5bmN0di5wcm92aWRlci50cnVlbmFzLkxvZ2'
    '91dFJlc3BvbnNlEl8KCEdldEJpbmRzEiguc3luY3R2LnByb3ZpZGVyLnRydWVuYXMuR2V0Qmlu'
    'ZHNSZXF1ZXN0Gikuc3luY3R2LnByb3ZpZGVyLnRydWVuYXMuR2V0QmluZHNSZXNwb25zZQ==');
