// This is a generated file - do not edit.
//
// Generated from proto/providers/qnap_service.proto.

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

import 'qnap.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> QnapProviderServiceBase$json = {
  '1': 'QnapProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.qnap.LoginRequest',
      '3': '.synctv.provider.qnap.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.qnap.ListRequest',
      '3': '.synctv.provider.qnap.ListResponse'
    },
    {
      '1': 'GetCapabilities',
      '2': '.synctv.provider.qnap.GetCapabilitiesRequest',
      '3': '.synctv.provider.qnap.GetCapabilitiesResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.qnap.LogoutRequest',
      '3': '.synctv.provider.qnap.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.qnap.GetBindsRequest',
      '3': '.synctv.provider.qnap.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use qnapProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    QnapProviderServiceBase$messageJson = {
  '.synctv.provider.qnap.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.qnap.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.qnap.ListRequest': $0.ListRequest$json,
  '.synctv.provider.qnap.ListResponse': $0.ListResponse$json,
  '.synctv.provider.qnap.FileItem': $0.FileItem$json,
  '.synctv.provider.qnap.GetCapabilitiesRequest':
      $0.GetCapabilitiesRequest$json,
  '.synctv.provider.qnap.GetCapabilitiesResponse':
      $0.GetCapabilitiesResponse$json,
  '.synctv.provider.qnap.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.qnap.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.qnap.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.qnap.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.qnap.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `QnapProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List qnapProviderServiceDescriptor = $convert.base64Decode(
    'ChNRbmFwUHJvdmlkZXJTZXJ2aWNlElAKBUxvZ2luEiIuc3luY3R2LnByb3ZpZGVyLnFuYXAuTG'
    '9naW5SZXF1ZXN0GiMuc3luY3R2LnByb3ZpZGVyLnFuYXAuTG9naW5SZXNwb25zZRJNCgRMaXN0'
    'EiEuc3luY3R2LnByb3ZpZGVyLnFuYXAuTGlzdFJlcXVlc3QaIi5zeW5jdHYucHJvdmlkZXIucW'
    '5hcC5MaXN0UmVzcG9uc2USbgoPR2V0Q2FwYWJpbGl0aWVzEiwuc3luY3R2LnByb3ZpZGVyLnFu'
    'YXAuR2V0Q2FwYWJpbGl0aWVzUmVxdWVzdBotLnN5bmN0di5wcm92aWRlci5xbmFwLkdldENhcG'
    'FiaWxpdGllc1Jlc3BvbnNlElMKBkxvZ291dBIjLnN5bmN0di5wcm92aWRlci5xbmFwLkxvZ291'
    'dFJlcXVlc3QaJC5zeW5jdHYucHJvdmlkZXIucW5hcC5Mb2dvdXRSZXNwb25zZRJZCghHZXRCaW'
    '5kcxIlLnN5bmN0di5wcm92aWRlci5xbmFwLkdldEJpbmRzUmVxdWVzdBomLnN5bmN0di5wcm92'
    'aWRlci5xbmFwLkdldEJpbmRzUmVzcG9uc2U=');
