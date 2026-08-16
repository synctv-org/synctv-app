// This is a generated file - do not edit.
//
// Generated from proto/providers/seafile_service.proto.

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
import 'seafile.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SeafileProviderServiceApi {
  final $pb.RpcClient _client;

  SeafileProviderServiceApi(this._client);

  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(
          ctx, 'SeafileProviderService', 'Login', request, $0.LoginResponse());
  $async.Future<$0.UnlockLibraryResponse> unlockLibrary(
          $pb.ClientContext? ctx, $0.UnlockLibraryRequest request) =>
      _client.invoke<$0.UnlockLibraryResponse>(ctx, 'SeafileProviderService',
          'UnlockLibrary', request, $0.UnlockLibraryResponse());
  $async.Future<$0.ListResponse> listRepositories(
          $pb.ClientContext? ctx, $0.ListRepositoriesRequest request) =>
      _client.invoke<$0.ListResponse>(ctx, 'SeafileProviderService',
          'ListRepositories', request, $0.ListResponse());
  $async.Future<$0.ListResponse> list(
          $pb.ClientContext? ctx, $0.ListRequest request) =>
      _client.invoke<$0.ListResponse>(
          ctx, 'SeafileProviderService', 'List', request, $0.ListResponse());
  $async.Future<$0.ListResponse> listStarred(
          $pb.ClientContext? ctx, $0.ListStarredRequest request) =>
      _client.invoke<$0.ListResponse>(ctx, 'SeafileProviderService',
          'ListStarred', request, $0.ListResponse());
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(ctx, 'SeafileProviderService', 'Logout',
          request, $0.LogoutResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'SeafileProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$1.ResourceResponse> getThumbnail(
          $pb.ClientContext? ctx, $0.GetThumbnailRequest request) =>
      _client.invoke<$1.ResourceResponse>(ctx, 'SeafileProviderService',
          'GetThumbnail', request, $1.ResourceResponse());
}
