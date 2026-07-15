// This is a generated file - do not edit.
//
// Generated from proto/providers/synology_service.proto.

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

import 'synology.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> SynologyProviderServiceBase$json =
    {
  '1': 'SynologyProviderService',
  '2': [
    {
      '1': 'Login',
      '2': '.synctv.provider.synology.LoginRequest',
      '3': '.synctv.provider.synology.LoginResponse'
    },
    {
      '1': 'ListFiles',
      '2': '.synctv.provider.synology.ListFilesRequest',
      '3': '.synctv.provider.synology.ListFilesResponse'
    },
    {
      '1': 'ListLibraries',
      '2': '.synctv.provider.synology.ListLibrariesRequest',
      '3': '.synctv.provider.synology.ListLibrariesResponse'
    },
    {
      '1': 'ListMovies',
      '2': '.synctv.provider.synology.ListMoviesRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListTvShows',
      '2': '.synctv.provider.synology.ListTvShowsRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListEpisodes',
      '2': '.synctv.provider.synology.ListEpisodesRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListHomeVideos',
      '2': '.synctv.provider.synology.ListHomeVideosRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'ListTvRecordings',
      '2': '.synctv.provider.synology.ListTvRecordingsRequest',
      '3': '.synctv.provider.synology.ListVideoItemsResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.synology.LogoutRequest',
      '3': '.synctv.provider.synology.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.synology.GetBindsRequest',
      '3': '.synctv.provider.synology.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use synologyProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SynologyProviderServiceBase$messageJson = {
  '.synctv.provider.synology.LoginRequest': $0.LoginRequest$json,
  '.synctv.provider.synology.LoginResponse': $0.LoginResponse$json,
  '.synctv.provider.synology.ListFilesRequest': $0.ListFilesRequest$json,
  '.synctv.provider.synology.ListFilesResponse': $0.ListFilesResponse$json,
  '.synctv.provider.synology.FileItem': $0.FileItem$json,
  '.synctv.provider.synology.ListLibrariesRequest':
      $0.ListLibrariesRequest$json,
  '.synctv.provider.synology.ListLibrariesResponse':
      $0.ListLibrariesResponse$json,
  '.synctv.provider.synology.VideoLibrary': $0.VideoLibrary$json,
  '.synctv.provider.synology.ListMoviesRequest': $0.ListMoviesRequest$json,
  '.synctv.provider.synology.ListVideoItemsResponse':
      $0.ListVideoItemsResponse$json,
  '.synctv.provider.synology.VideoItem': $0.VideoItem$json,
  '.synctv.provider.synology.VideoFile': $0.VideoFile$json,
  '.synctv.provider.synology.ListTvShowsRequest': $0.ListTvShowsRequest$json,
  '.synctv.provider.synology.ListEpisodesRequest': $0.ListEpisodesRequest$json,
  '.synctv.provider.synology.ListHomeVideosRequest':
      $0.ListHomeVideosRequest$json,
  '.synctv.provider.synology.ListTvRecordingsRequest':
      $0.ListTvRecordingsRequest$json,
  '.synctv.provider.synology.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.synology.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.synology.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.synology.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.synology.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `SynologyProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List synologyProviderServiceDescriptor = $convert.base64Decode(
    'ChdTeW5vbG9neVByb3ZpZGVyU2VydmljZRJYCgVMb2dpbhImLnN5bmN0di5wcm92aWRlci5zeW'
    '5vbG9neS5Mb2dpblJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTG9naW5SZXNw'
    'b25zZRJkCglMaXN0RmlsZXMSKi5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdEZpbGVzUm'
    'VxdWVzdBorLnN5bmN0di5wcm92aWRlci5zeW5vbG9neS5MaXN0RmlsZXNSZXNwb25zZRJwCg1M'
    'aXN0TGlicmFyaWVzEi4uc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RMaWJyYXJpZXNSZX'
    'F1ZXN0Gi8uc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RMaWJyYXJpZXNSZXNwb25zZRJr'
    'CgpMaXN0TW92aWVzEisuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RNb3ZpZXNSZXF1ZX'
    'N0GjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RWaWRlb0l0ZW1zUmVzcG9uc2USbQoL'
    'TGlzdFR2U2hvd3MSLC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdFR2U2hvd3NSZXF1ZX'
    'N0GjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RWaWRlb0l0ZW1zUmVzcG9uc2USbwoM'
    'TGlzdEVwaXNvZGVzEi0uc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RFcGlzb2Rlc1JlcX'
    'Vlc3QaMC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdFZpZGVvSXRlbXNSZXNwb25zZRJz'
    'Cg5MaXN0SG9tZVZpZGVvcxIvLnN5bmN0di5wcm92aWRlci5zeW5vbG9neS5MaXN0SG9tZVZpZG'
    'Vvc1JlcXVlc3QaMC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTGlzdFZpZGVvSXRlbXNSZXNw'
    'b25zZRJ3ChBMaXN0VHZSZWNvcmRpbmdzEjEuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3'
    'RUdlJlY29yZGluZ3NSZXF1ZXN0GjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5Lkxpc3RWaWRl'
    'b0l0ZW1zUmVzcG9uc2USWwoGTG9nb3V0Eicuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LkxvZ2'
    '91dFJlcXVlc3QaKC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuTG9nb3V0UmVzcG9uc2USYQoI'
    'R2V0QmluZHMSKS5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuR2V0QmluZHNSZXF1ZXN0Giouc3'
    'luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LkdldEJpbmRzUmVzcG9uc2U=');
