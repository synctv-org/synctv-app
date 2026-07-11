// This is a generated file - do not edit.
//
// Generated from proto/providers/cloudreve_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'cloudreve.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CloudreveProviderServiceApi {
  final $pb.RpcClient _client;

  CloudreveProviderServiceApi(this._client);

  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(ctx, 'CloudreveProviderService', 'Login',
          request, $0.LoginResponse());
  $async.Future<$0.ListResponse> list(
          $pb.ClientContext? ctx, $0.ListRequest request) =>
      _client.invoke<$0.ListResponse>(
          ctx, 'CloudreveProviderService', 'List', request, $0.ListResponse());
  $async.Future<$0.SearchResponse> search(
          $pb.ClientContext? ctx, $0.SearchRequest request) =>
      _client.invoke<$0.SearchResponse>(ctx, 'CloudreveProviderService',
          'Search', request, $0.SearchResponse());
  $async.Future<$0.GetMeResponse> getMe(
          $pb.ClientContext? ctx, $0.GetMeRequest request) =>
      _client.invoke<$0.GetMeResponse>(ctx, 'CloudreveProviderService', 'GetMe',
          request, $0.GetMeResponse());
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(ctx, 'CloudreveProviderService',
          'Logout', request, $0.LogoutResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'CloudreveProviderService',
          'GetBinds', request, $0.GetBindsResponse());
}
