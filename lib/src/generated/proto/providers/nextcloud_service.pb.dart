// This is a generated file - do not edit.
//
// Generated from proto/providers/nextcloud_service.proto.

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
import 'nextcloud.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class NextcloudProviderServiceApi {
  final $pb.RpcClient _client;

  NextcloudProviderServiceApi(this._client);

  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(ctx, 'NextcloudProviderService', 'Login',
          request, $0.LoginResponse());
  $async.Future<$0.StartLoginFlowResponse> startLoginFlow(
          $pb.ClientContext? ctx, $0.StartLoginFlowRequest request) =>
      _client.invoke<$0.StartLoginFlowResponse>(ctx, 'NextcloudProviderService',
          'StartLoginFlow', request, $0.StartLoginFlowResponse());
  $async.Future<$0.LoginResponse> pollLoginFlow(
          $pb.ClientContext? ctx, $0.PollLoginFlowRequest request) =>
      _client.invoke<$0.LoginResponse>(ctx, 'NextcloudProviderService',
          'PollLoginFlow', request, $0.LoginResponse());
  $async.Future<$0.ListResponse> list(
          $pb.ClientContext? ctx, $0.ListRequest request) =>
      _client.invoke<$0.ListResponse>(
          ctx, 'NextcloudProviderService', 'List', request, $0.ListResponse());
  $async.Future<$0.ListResponse> listFavorites(
          $pb.ClientContext? ctx, $0.ListFavoritesRequest request) =>
      _client.invoke<$0.ListResponse>(ctx, 'NextcloudProviderService',
          'ListFavorites', request, $0.ListResponse());
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(ctx, 'NextcloudProviderService',
          'Logout', request, $0.LogoutResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'NextcloudProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$1.ResourceResponse> getPreview(
          $pb.ClientContext? ctx, $0.GetPreviewRequest request) =>
      _client.invoke<$1.ResourceResponse>(ctx, 'NextcloudProviderService',
          'GetPreview', request, $1.ResourceResponse());
}
