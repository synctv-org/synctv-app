// This is a generated file - do not edit.
//
// Generated from proto/providers/youtube_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'youtube.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class YoutubeProviderServiceApi {
  final $pb.RpcClient _client;

  YoutubeProviderServiceApi(this._client);

  $async.Future<$0.BindResponse> bind(
          $pb.ClientContext? ctx, $0.BindRequest request) =>
      _client.invoke<$0.BindResponse>(
          ctx, 'YoutubeProviderService', 'Bind', request, $0.BindResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'YoutubeProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$0.UnbindResponse> unbind(
          $pb.ClientContext? ctx, $0.UnbindRequest request) =>
      _client.invoke<$0.UnbindResponse>(ctx, 'YoutubeProviderService', 'Unbind',
          request, $0.UnbindResponse());
  $async.Future<$0.ResolveResponse> resolve(
          $pb.ClientContext? ctx, $0.ResolveRequest request) =>
      _client.invoke<$0.ResolveResponse>(ctx, 'YoutubeProviderService',
          'Resolve', request, $0.ResolveResponse());
}
