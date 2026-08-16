// This is a generated file - do not edit.
//
// Generated from proto/providers/synology_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'synology.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SynologyProviderServiceApi {
  final $pb.RpcClient _client;

  SynologyProviderServiceApi(this._client);

  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(
          ctx, 'SynologyProviderService', 'Login', request, $0.LoginResponse());
  $async.Future<$0.ListFilesResponse> listFiles(
          $pb.ClientContext? ctx, $0.ListFilesRequest request) =>
      _client.invoke<$0.ListFilesResponse>(ctx, 'SynologyProviderService',
          'ListFiles', request, $0.ListFilesResponse());
  $async.Future<$0.ListLibrariesResponse> listLibraries(
          $pb.ClientContext? ctx, $0.ListLibrariesRequest request) =>
      _client.invoke<$0.ListLibrariesResponse>(ctx, 'SynologyProviderService',
          'ListLibraries', request, $0.ListLibrariesResponse());
  $async.Future<$0.ListVideoItemsResponse> listMovies(
          $pb.ClientContext? ctx, $0.ListMoviesRequest request) =>
      _client.invoke<$0.ListVideoItemsResponse>(ctx, 'SynologyProviderService',
          'ListMovies', request, $0.ListVideoItemsResponse());
  $async.Future<$0.ListVideoItemsResponse> listTvShows(
          $pb.ClientContext? ctx, $0.ListTvShowsRequest request) =>
      _client.invoke<$0.ListVideoItemsResponse>(ctx, 'SynologyProviderService',
          'ListTvShows', request, $0.ListVideoItemsResponse());
  $async.Future<$0.ListVideoItemsResponse> listEpisodes(
          $pb.ClientContext? ctx, $0.ListEpisodesRequest request) =>
      _client.invoke<$0.ListVideoItemsResponse>(ctx, 'SynologyProviderService',
          'ListEpisodes', request, $0.ListVideoItemsResponse());
  $async.Future<$0.ListVideoItemsResponse> listHomeVideos(
          $pb.ClientContext? ctx, $0.ListHomeVideosRequest request) =>
      _client.invoke<$0.ListVideoItemsResponse>(ctx, 'SynologyProviderService',
          'ListHomeVideos', request, $0.ListVideoItemsResponse());
  $async.Future<$0.ListVideoItemsResponse> listTvRecordings(
          $pb.ClientContext? ctx, $0.ListTvRecordingsRequest request) =>
      _client.invoke<$0.ListVideoItemsResponse>(ctx, 'SynologyProviderService',
          'ListTvRecordings', request, $0.ListVideoItemsResponse());
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(ctx, 'SynologyProviderService',
          'Logout', request, $0.LogoutResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'SynologyProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$1.ResourceResponse> getImage(
          $pb.ClientContext? ctx, $0.GetImageRequest request) =>
      _client.invoke<$1.ResourceResponse>(ctx, 'SynologyProviderService',
          'GetImage', request, $1.ResourceResponse());
}
