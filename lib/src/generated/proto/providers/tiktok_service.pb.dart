// This is a generated file - do not edit.
//
// Generated from proto/providers/tiktok_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'tiktok.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TikTokProviderServiceApi {
  final $pb.RpcClient _client;

  TikTokProviderServiceApi(this._client);

  $async.Future<$0.BindResponse> bind(
          $pb.ClientContext? ctx, $0.BindRequest request) =>
      _client.invoke<$0.BindResponse>(
          ctx, 'TikTokProviderService', 'Bind', request, $0.BindResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'TikTokProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$0.UnbindResponse> unbind(
          $pb.ClientContext? ctx, $0.UnbindRequest request) =>
      _client.invoke<$0.UnbindResponse>(
          ctx, 'TikTokProviderService', 'Unbind', request, $0.UnbindResponse());
  $async.Future<$0.ResolveResponse> resolve(
          $pb.ClientContext? ctx, $0.ResolveRequest request) =>
      _client.invoke<$0.ResolveResponse>(ctx, 'TikTokProviderService',
          'Resolve', request, $0.ResolveResponse());
  $async.Future<$0.GetUserResponse> getUser(
          $pb.ClientContext? ctx, $0.GetUserRequest request) =>
      _client.invoke<$0.GetUserResponse>(ctx, 'TikTokProviderService',
          'GetUser', request, $0.GetUserResponse());
  $async.Future<$0.ListUserPostsResponse> listUserPosts(
          $pb.ClientContext? ctx, $0.ListUserPostsRequest request) =>
      _client.invoke<$0.ListUserPostsResponse>(ctx, 'TikTokProviderService',
          'ListUserPosts', request, $0.ListUserPostsResponse());
}
