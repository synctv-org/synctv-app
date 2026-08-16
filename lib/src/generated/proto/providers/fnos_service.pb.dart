// This is a generated file - do not edit.
//
// Generated from proto/providers/fnos_service.proto.

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
import 'fnos.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class FnosProviderServiceApi {
  final $pb.RpcClient _client;

  FnosProviderServiceApi(this._client);

  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(
          ctx, 'FnosProviderService', 'Login', request, $0.LoginResponse());
  $async.Future<$0.ListResponse> list(
          $pb.ClientContext? ctx, $0.ListRequest request) =>
      _client.invoke<$0.ListResponse>(
          ctx, 'FnosProviderService', 'List', request, $0.ListResponse());
  $async.Future<$0.ListMediaLibrariesResponse> listMediaLibraries(
          $pb.ClientContext? ctx, $0.ListMediaLibrariesRequest request) =>
      _client.invoke<$0.ListMediaLibrariesResponse>(ctx, 'FnosProviderService',
          'ListMediaLibraries', request, $0.ListMediaLibrariesResponse());
  $async.Future<$0.ListMediaItemsResponse> listMediaItems(
          $pb.ClientContext? ctx, $0.ListMediaItemsRequest request) =>
      _client.invoke<$0.ListMediaItemsResponse>(ctx, 'FnosProviderService',
          'ListMediaItems', request, $0.ListMediaItemsResponse());
  $async.Future<$0.SetFavoriteResponse> setFavorite(
          $pb.ClientContext? ctx, $0.SetFavoriteRequest request) =>
      _client.invoke<$0.SetFavoriteResponse>(ctx, 'FnosProviderService',
          'SetFavorite', request, $0.SetFavoriteResponse());
  $async.Future<$0.SetWatchedResponse> setWatched(
          $pb.ClientContext? ctx, $0.SetWatchedRequest request) =>
      _client.invoke<$0.SetWatchedResponse>(ctx, 'FnosProviderService',
          'SetWatched', request, $0.SetWatchedResponse());
  $async.Future<$0.GetServerInfoResponse> getServerInfo(
          $pb.ClientContext? ctx, $0.GetServerInfoRequest request) =>
      _client.invoke<$0.GetServerInfoResponse>(ctx, 'FnosProviderService',
          'GetServerInfo', request, $0.GetServerInfoResponse());
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(
          ctx, 'FnosProviderService', 'Logout', request, $0.LogoutResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'FnosProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$1.ResourceResponse> getThumbnail(
          $pb.ClientContext? ctx, $0.GetThumbnailRequest request) =>
      _client.invoke<$1.ResourceResponse>(ctx, 'FnosProviderService',
          'GetThumbnail', request, $1.ResourceResponse());
}
