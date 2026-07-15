// This is a generated file - do not edit.
//
// Generated from proto/providers/twitch_service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'twitch.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TwitchProviderServiceApi {
  final $pb.RpcClient _client;

  TwitchProviderServiceApi(this._client);

  $async.Future<$0.BindResponse> bind(
          $pb.ClientContext? ctx, $0.BindRequest request) =>
      _client.invoke<$0.BindResponse>(
          ctx, 'TwitchProviderService', 'Bind', request, $0.BindResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'TwitchProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$0.UnbindResponse> unbind(
          $pb.ClientContext? ctx, $0.UnbindRequest request) =>
      _client.invoke<$0.UnbindResponse>(
          ctx, 'TwitchProviderService', 'Unbind', request, $0.UnbindResponse());
  $async.Future<$0.ResolveResponse> resolve(
          $pb.ClientContext? ctx, $0.ResolveRequest request) =>
      _client.invoke<$0.ResolveResponse>(ctx, 'TwitchProviderService',
          'Resolve', request, $0.ResolveResponse());
  $async.Future<$0.ListChannelItemsResponse> listChannelItems(
          $pb.ClientContext? ctx, $0.ListChannelItemsRequest request) =>
      _client.invoke<$0.ListChannelItemsResponse>(ctx, 'TwitchProviderService',
          'ListChannelItems', request, $0.ListChannelItemsResponse());
  $async.Future<$0.ListFollowedLiveResponse> listFollowedLive(
          $pb.ClientContext? ctx, $0.ListFollowedLiveRequest request) =>
      _client.invoke<$0.ListFollowedLiveResponse>(ctx, 'TwitchProviderService',
          'ListFollowedLive', request, $0.ListFollowedLiveResponse());
  $async.Future<$0.ListCategoryStreamsResponse> listCategoryStreams(
          $pb.ClientContext? ctx, $0.ListCategoryStreamsRequest request) =>
      _client.invoke<$0.ListCategoryStreamsResponse>(
          ctx,
          'TwitchProviderService',
          'ListCategoryStreams',
          request,
          $0.ListCategoryStreamsResponse());
  $async.Future<$0.ListTopCategoriesResponse> listTopCategories(
          $pb.ClientContext? ctx, $0.ListTopCategoriesRequest request) =>
      _client.invoke<$0.ListTopCategoriesResponse>(ctx, 'TwitchProviderService',
          'ListTopCategories', request, $0.ListTopCategoriesResponse());
  $async.Future<$0.SearchLiveChannelsResponse> searchLiveChannels(
          $pb.ClientContext? ctx, $0.SearchLiveChannelsRequest request) =>
      _client.invoke<$0.SearchLiveChannelsResponse>(
          ctx,
          'TwitchProviderService',
          'SearchLiveChannels',
          request,
          $0.SearchLiveChannelsResponse());
  $async.Future<$0.ListScheduleResponse> listSchedule(
          $pb.ClientContext? ctx, $0.ListScheduleRequest request) =>
      _client.invoke<$0.ListScheduleResponse>(ctx, 'TwitchProviderService',
          'ListSchedule', request, $0.ListScheduleResponse());
}
