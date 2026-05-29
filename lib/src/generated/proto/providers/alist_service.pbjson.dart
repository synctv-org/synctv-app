// This is a generated file - do not edit.
//
// Generated from proto/providers/alist_service.proto.

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

import 'alist.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> AlistProviderServiceBase$json = {
  '1': 'AlistProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.alist.LoginRequest',
      '3': '.synctv.provider.alist.LoginResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.alist.ListRequest',
      '3': '.synctv.provider.alist.ListResponse'
    },
    {
      '1': 'Search',
      '2': '.synctv.provider.alist.SearchRequest',
      '3': '.synctv.provider.alist.SearchResponse'
    },
    {
      '1': 'GetMe',
      '2': '.synctv.provider.alist.GetMeRequest',
      '3': '.synctv.provider.alist.GetMeResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.alist.LogoutRequest',
      '3': '.synctv.provider.alist.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.alist.GetBindsRequest',
      '3': '.synctv.provider.alist.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use alistProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AlistProviderServiceBase$messageJson = {
  '.synctv.provider.alist.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.alist.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.alist.ListRequest': $0.ListRequest$json,
  '.synctv.provider.alist.ListResponse': $0.ListResponse$json,
  '.synctv.provider.alist.FileItem': $0.FileItem$json,
  '.synctv.provider.alist.SearchRequest': $0.SearchRequest$json,
  '.synctv.provider.alist.SearchResponse': $0.SearchResponse$json,
  '.synctv.provider.alist.SearchItem': $0.SearchItem$json,
  '.synctv.provider.alist.GetMeRequest': $0.GetMeRequest$json,
  '.synctv.provider.alist.GetMeResponse': $0.GetMeResponse$json,
  '.synctv.provider.alist.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.alist.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.alist.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.alist.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.alist.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `AlistProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List alistProviderServiceDescriptor = $convert.base64Decode(
    'ChRBbGlzdFByb3ZpZGVyU2VydmljZRJSCgVMb2dpbhIjLnN5bmN0di5wcm92aWRlci5hbGlzdC'
    '5Mb2dpblJlcXVlc3QaJC5zeW5jdHYucHJvdmlkZXIuYWxpc3QuTG9naW5SZXNwb25zZRJPCgRM'
    'aXN0EiIuc3luY3R2LnByb3ZpZGVyLmFsaXN0Lkxpc3RSZXF1ZXN0GiMuc3luY3R2LnByb3ZpZG'
    'VyLmFsaXN0Lkxpc3RSZXNwb25zZRJVCgZTZWFyY2gSJC5zeW5jdHYucHJvdmlkZXIuYWxpc3Qu'
    'U2VhcmNoUmVxdWVzdBolLnN5bmN0di5wcm92aWRlci5hbGlzdC5TZWFyY2hSZXNwb25zZRJSCg'
    'VHZXRNZRIjLnN5bmN0di5wcm92aWRlci5hbGlzdC5HZXRNZVJlcXVlc3QaJC5zeW5jdHYucHJv'
    'dmlkZXIuYWxpc3QuR2V0TWVSZXNwb25zZRJVCgZMb2dvdXQSJC5zeW5jdHYucHJvdmlkZXIuYW'
    'xpc3QuTG9nb3V0UmVxdWVzdBolLnN5bmN0di5wcm92aWRlci5hbGlzdC5Mb2dvdXRSZXNwb25z'
    'ZRJbCghHZXRCaW5kcxImLnN5bmN0di5wcm92aWRlci5hbGlzdC5HZXRCaW5kc1JlcXVlc3QaJy'
    '5zeW5jdHYucHJvdmlkZXIuYWxpc3QuR2V0QmluZHNSZXNwb25zZQ==');
