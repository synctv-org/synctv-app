// This is a generated file - do not edit.
//
// Generated from proto/providers/emby_service.proto.

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
import 'emby.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Emby-compatible Provider Service
///
/// Client-facing API for Emby media server access
class EmbyProviderServiceApi {
  final $pb.RpcClient _client;

  EmbyProviderServiceApi(this._client);

  /// Login to Emby server (validate API key and persist credential)
  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(
          ctx, 'EmbyProviderService', 'Login', request, $0.LoginResponse());

  /// List library items (uses stored credential via server_id)
  $async.Future<$0.ListResponse> list(
          $pb.ClientContext? ctx, $0.ListRequest request) =>
      _client.invoke<$0.ListResponse>(
          ctx, 'EmbyProviderService', 'List', request, $0.ListResponse());

  /// Get current user info (uses stored credential via server_id)
  $async.Future<$0.GetMeResponse> getMe(
          $pb.ClientContext? ctx, $0.GetMeRequest request) =>
      _client.invoke<$0.GetMeResponse>(
          ctx, 'EmbyProviderService', 'GetMe', request, $0.GetMeResponse());

  /// Logout from an Emby-compatible server (delete stored credential)
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(
          ctx, 'EmbyProviderService', 'Logout', request, $0.LogoutResponse());

  /// Get saved credentials (binds)
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'EmbyProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$1.ResourceResponse> getThumbnail(
          $pb.ClientContext? ctx, $0.GetThumbnailRequest request) =>
      _client.invoke<$1.ResourceResponse>(ctx, 'EmbyProviderService',
          'GetThumbnail', request, $1.ResourceResponse());
}
