// This is a generated file - do not edit.
//
// Generated from proto/providers/douyin_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'douyin.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class DouyinProviderServiceApi {
  final $pb.RpcClient _client;

  DouyinProviderServiceApi(this._client);

  $async.Future<$0.BindResponse> bind(
          $pb.ClientContext? ctx, $0.BindRequest request) =>
      _client.invoke<$0.BindResponse>(
          ctx, 'DouyinProviderService', 'Bind', request, $0.BindResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'DouyinProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$0.UnbindResponse> unbind(
          $pb.ClientContext? ctx, $0.UnbindRequest request) =>
      _client.invoke<$0.UnbindResponse>(
          ctx, 'DouyinProviderService', 'Unbind', request, $0.UnbindResponse());
  $async.Future<$0.ResolveResponse> resolve(
          $pb.ClientContext? ctx, $0.ResolveRequest request) =>
      _client.invoke<$0.ResolveResponse>(ctx, 'DouyinProviderService',
          'Resolve', request, $0.ResolveResponse());
  $async.Future<$0.ListUserPostsResponse> listUserPosts(
          $pb.ClientContext? ctx, $0.ListUserPostsRequest request) =>
      _client.invoke<$0.ListUserPostsResponse>(ctx, 'DouyinProviderService',
          'ListUserPosts', request, $0.ListUserPostsResponse());
}
