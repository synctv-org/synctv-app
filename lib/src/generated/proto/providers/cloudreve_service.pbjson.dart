// This is a generated file - do not edit.
//
// Generated from proto/providers/cloudreve_service.proto.

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

import 'cloudreve.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> CloudreveProviderServiceBase$json =
    {
  '1': 'CloudreveProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.cloudreve.LoginRequest',
      '3': '.synctv.provider.cloudreve.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.cloudreve.ListRequest',
      '3': '.synctv.provider.cloudreve.ListResponse'
    },
    {
      '1': 'Search',
      '2': '.synctv.provider.cloudreve.SearchRequest',
      '3': '.synctv.provider.cloudreve.SearchResponse'
    },
    {
      '1': 'GetMe',
      '2': '.synctv.provider.cloudreve.GetMeRequest',
      '3': '.synctv.provider.cloudreve.GetMeResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.cloudreve.LogoutRequest',
      '3': '.synctv.provider.cloudreve.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.cloudreve.GetBindsRequest',
      '3': '.synctv.provider.cloudreve.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use cloudreveProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    CloudreveProviderServiceBase$messageJson = {
  '.synctv.provider.cloudreve.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.cloudreve.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.cloudreve.ListRequest': $0.ListRequest$json,
  '.synctv.provider.cloudreve.PagePagination': $0.PagePagination$json,
  '.synctv.provider.cloudreve.CursorPagination': $0.CursorPagination$json,
  '.synctv.provider.cloudreve.ListResponse': $0.ListResponse$json,
  '.synctv.provider.cloudreve.FileItem': $0.FileItem$json,
  '.synctv.provider.cloudreve.SearchRequest': $0.SearchRequest$json,
  '.synctv.provider.cloudreve.SearchResponse': $0.SearchResponse$json,
  '.synctv.provider.cloudreve.GetMeRequest': $0.GetMeRequest$json,
  '.synctv.provider.cloudreve.GetMeResponse': $0.GetMeResponse$json,
  '.synctv.provider.cloudreve.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.cloudreve.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.cloudreve.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.cloudreve.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.cloudreve.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `CloudreveProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List cloudreveProviderServiceDescriptor = $convert.base64Decode(
    'ChhDbG91ZHJldmVQcm92aWRlclNlcnZpY2USWgoFTG9naW4SJy5zeW5jdHYucHJvdmlkZXIuY2'
    'xvdWRyZXZlLkxvZ2luUmVxdWVzdBooLnN5bmN0di5wcm92aWRlci5jbG91ZHJldmUuTG9naW5S'
    'ZXNwb25zZRJXCgRMaXN0EiYuc3luY3R2LnByb3ZpZGVyLmNsb3VkcmV2ZS5MaXN0UmVxdWVzdB'
    'onLnN5bmN0di5wcm92aWRlci5jbG91ZHJldmUuTGlzdFJlc3BvbnNlEl0KBlNlYXJjaBIoLnN5'
    'bmN0di5wcm92aWRlci5jbG91ZHJldmUuU2VhcmNoUmVxdWVzdBopLnN5bmN0di5wcm92aWRlci'
    '5jbG91ZHJldmUuU2VhcmNoUmVzcG9uc2USWgoFR2V0TWUSJy5zeW5jdHYucHJvdmlkZXIuY2xv'
    'dWRyZXZlLkdldE1lUmVxdWVzdBooLnN5bmN0di5wcm92aWRlci5jbG91ZHJldmUuR2V0TWVSZX'
    'Nwb25zZRJdCgZMb2dvdXQSKC5zeW5jdHYucHJvdmlkZXIuY2xvdWRyZXZlLkxvZ291dFJlcXVl'
    'c3QaKS5zeW5jdHYucHJvdmlkZXIuY2xvdWRyZXZlLkxvZ291dFJlc3BvbnNlEmMKCEdldEJpbm'
    'RzEiouc3luY3R2LnByb3ZpZGVyLmNsb3VkcmV2ZS5HZXRCaW5kc1JlcXVlc3QaKy5zeW5jdHYu'
    'cHJvdmlkZXIuY2xvdWRyZXZlLkdldEJpbmRzUmVzcG9uc2U=');
