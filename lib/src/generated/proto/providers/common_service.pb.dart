// This is a generated file - do not edit.
//
// Generated from proto/providers/common_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ProviderCommonServiceApi {
  final $pb.RpcClient _client;

  ProviderCommonServiceApi(this._client);

  $async.Future<$0.PreparedMediaSource> prepareDirectUrl(
          $pb.ClientContext? ctx, $0.PrepareDirectUrlRequest request) =>
      _client.invoke<$0.PreparedMediaSource>(ctx, 'ProviderCommonService',
          'PrepareDirectUrl', request, $0.PreparedMediaSource());
  $async.Future<$0.PreparedMediaSource> prepareLiveProxy(
          $pb.ClientContext? ctx, $0.PrepareLiveProxyRequest request) =>
      _client.invoke<$0.PreparedMediaSource>(ctx, 'ProviderCommonService',
          'PrepareLiveProxy', request, $0.PreparedMediaSource());
  $async.Future<$0.PreparedMediaSource> prepareRtmp(
          $pb.ClientContext? ctx, $0.PrepareRtmpRequest request) =>
      _client.invoke<$0.PreparedMediaSource>(ctx, 'ProviderCommonService',
          'PrepareRtmp', request, $0.PreparedMediaSource());
  $async.Future<$0.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
          $pb.ClientContext? ctx,
          $0.ResolvePlaybackProxyPolicyRequest request) =>
      _client.invoke<$0.PlaybackProxyPolicy>(ctx, 'ProviderCommonService',
          'ResolvePlaybackProxyPolicy', request, $0.PlaybackProxyPolicy());
  $async.Future<$0.ProviderInstancesResponse> listAvailableProviderInstances(
          $pb.ClientContext? ctx,
          $0.ListAvailableProviderInstancesRequest request) =>
      _client.invoke<$0.ProviderInstancesResponse>(
          ctx,
          'ProviderCommonService',
          'ListAvailableProviderInstances',
          request,
          $0.ProviderInstancesResponse());
  $async.Future<$0.ProviderBackendsResponse> listProviderBackends(
          $pb.ClientContext? ctx, $0.ListProviderBackendsRequest request) =>
      _client.invoke<$0.ProviderBackendsResponse>(ctx, 'ProviderCommonService',
          'ListProviderBackends', request, $0.ProviderBackendsResponse());
  $async.Future<$0.ListProviderInstancesResponse> listProviderInstances(
          $pb.ClientContext? ctx, $0.ListProviderInstancesRequest request) =>
      _client.invoke<$0.ListProviderInstancesResponse>(
          ctx,
          'ProviderCommonService',
          'ListProviderInstances',
          request,
          $0.ListProviderInstancesResponse());
  $async.Future<$0.AddProviderInstanceResponse> addProviderInstance(
          $pb.ClientContext? ctx, $0.AddProviderInstanceRequest request) =>
      _client.invoke<$0.AddProviderInstanceResponse>(
          ctx,
          'ProviderCommonService',
          'AddProviderInstance',
          request,
          $0.AddProviderInstanceResponse());
  $async.Future<$0.UpdateProviderInstanceResponse> updateProviderInstance(
          $pb.ClientContext? ctx, $0.UpdateProviderInstanceRequest request) =>
      _client.invoke<$0.UpdateProviderInstanceResponse>(
          ctx,
          'ProviderCommonService',
          'UpdateProviderInstance',
          request,
          $0.UpdateProviderInstanceResponse());
  $async.Future<$0.DeleteProviderInstanceResponse> deleteProviderInstance(
          $pb.ClientContext? ctx, $0.DeleteProviderInstanceRequest request) =>
      _client.invoke<$0.DeleteProviderInstanceResponse>(
          ctx,
          'ProviderCommonService',
          'DeleteProviderInstance',
          request,
          $0.DeleteProviderInstanceResponse());
  $async.Future<$0.ReconnectProviderInstanceResponse> reconnectProviderInstance(
          $pb.ClientContext? ctx,
          $0.ReconnectProviderInstanceRequest request) =>
      _client.invoke<$0.ReconnectProviderInstanceResponse>(
          ctx,
          'ProviderCommonService',
          'ReconnectProviderInstance',
          request,
          $0.ReconnectProviderInstanceResponse());
  $async.Future<$0.EnableProviderInstanceResponse> enableProviderInstance(
          $pb.ClientContext? ctx, $0.EnableProviderInstanceRequest request) =>
      _client.invoke<$0.EnableProviderInstanceResponse>(
          ctx,
          'ProviderCommonService',
          'EnableProviderInstance',
          request,
          $0.EnableProviderInstanceResponse());
  $async.Future<$0.DisableProviderInstanceResponse> disableProviderInstance(
          $pb.ClientContext? ctx, $0.DisableProviderInstanceRequest request) =>
      _client.invoke<$0.DisableProviderInstanceResponse>(
          ctx,
          'ProviderCommonService',
          'DisableProviderInstance',
          request,
          $0.DisableProviderInstanceResponse());
}
