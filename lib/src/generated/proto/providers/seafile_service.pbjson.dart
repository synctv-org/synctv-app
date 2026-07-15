// This is a generated file - do not edit.
//
// Generated from proto/providers/seafile_service.proto.

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

import 'seafile.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> SeafileProviderServiceBase$json = {
  '1': 'SeafileProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.seafile.LoginRequest',
      '3': '.synctv.provider.seafile.LoginResponse'
    },
    {
      '1': 'UnlockLibrary',
      '2': '.synctv.provider.seafile.UnlockLibraryRequest',
      '3': '.synctv.provider.seafile.UnlockLibraryResponse'
    },
    {
      '1': 'ListRepositories',
      '2': '.synctv.provider.seafile.ListRepositoriesRequest',
      '3': '.synctv.provider.seafile.ListResponse'
    },
    {
      '1': 'List',
      '2': '.synctv.provider.seafile.ListRequest',
      '3': '.synctv.provider.seafile.ListResponse'
    },
    {
      '1': 'ListStarred',
      '2': '.synctv.provider.seafile.ListStarredRequest',
      '3': '.synctv.provider.seafile.ListResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.seafile.LogoutRequest',
      '3': '.synctv.provider.seafile.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.seafile.GetBindsRequest',
      '3': '.synctv.provider.seafile.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use seafileProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SeafileProviderServiceBase$messageJson = {
  '.synctv.provider.seafile.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.seafile.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.seafile.UnlockLibraryRequest': $0.UnlockLibraryRequest$json,
  '.synctv.provider.seafile.UnlockLibraryResponse':
      $0.UnlockLibraryResponse$json,
  '.synctv.provider.seafile.ListRepositoriesRequest':
      $0.ListRepositoriesRequest$json,
  '.synctv.provider.seafile.ListResponse': $0.ListResponse$json,
  '.synctv.provider.seafile.FileItem': $0.FileItem$json,
  '.synctv.provider.seafile.ListRequest': $0.ListRequest$json,
  '.synctv.provider.seafile.ListStarredRequest': $0.ListStarredRequest$json,
  '.synctv.provider.seafile.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.seafile.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.seafile.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.seafile.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.seafile.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `SeafileProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List seafileProviderServiceDescriptor = $convert.base64Decode(
    'ChZTZWFmaWxlUHJvdmlkZXJTZXJ2aWNlElYKBUxvZ2luEiUuc3luY3R2LnByb3ZpZGVyLnNlYW'
    'ZpbGUuTG9naW5SZXF1ZXN0GiYuc3luY3R2LnByb3ZpZGVyLnNlYWZpbGUuTG9naW5SZXNwb25z'
    'ZRJuCg1VbmxvY2tMaWJyYXJ5Ei0uc3luY3R2LnByb3ZpZGVyLnNlYWZpbGUuVW5sb2NrTGlicm'
    'FyeVJlcXVlc3QaLi5zeW5jdHYucHJvdmlkZXIuc2VhZmlsZS5VbmxvY2tMaWJyYXJ5UmVzcG9u'
    'c2USawoQTGlzdFJlcG9zaXRvcmllcxIwLnN5bmN0di5wcm92aWRlci5zZWFmaWxlLkxpc3RSZX'
    'Bvc2l0b3JpZXNSZXF1ZXN0GiUuc3luY3R2LnByb3ZpZGVyLnNlYWZpbGUuTGlzdFJlc3BvbnNl'
    'ElMKBExpc3QSJC5zeW5jdHYucHJvdmlkZXIuc2VhZmlsZS5MaXN0UmVxdWVzdBolLnN5bmN0di'
    '5wcm92aWRlci5zZWFmaWxlLkxpc3RSZXNwb25zZRJhCgtMaXN0U3RhcnJlZBIrLnN5bmN0di5w'
    'cm92aWRlci5zZWFmaWxlLkxpc3RTdGFycmVkUmVxdWVzdBolLnN5bmN0di5wcm92aWRlci5zZW'
    'FmaWxlLkxpc3RSZXNwb25zZRJZCgZMb2dvdXQSJi5zeW5jdHYucHJvdmlkZXIuc2VhZmlsZS5M'
    'b2dvdXRSZXF1ZXN0Gicuc3luY3R2LnByb3ZpZGVyLnNlYWZpbGUuTG9nb3V0UmVzcG9uc2USXw'
    'oIR2V0QmluZHMSKC5zeW5jdHYucHJvdmlkZXIuc2VhZmlsZS5HZXRCaW5kc1JlcXVlc3QaKS5z'
    'eW5jdHYucHJvdmlkZXIuc2VhZmlsZS5HZXRCaW5kc1Jlc3BvbnNl');
