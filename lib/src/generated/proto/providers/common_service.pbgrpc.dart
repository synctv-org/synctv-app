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

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;

export 'common_service.pb.dart';

@$pb.GrpcServiceName('synctv.provider.common.ProviderCommonService')
class ProviderCommonServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ProviderCommonServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ProviderInstancesResponse>
      listAvailableProviderInstances(
    $0.ListAvailableProviderInstancesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAvailableProviderInstances, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ProviderBackendsResponse> listProviderBackends(
    $0.ListProviderBackendsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listProviderBackends, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListProviderInstancesResponse> listProviderInstances(
    $0.ListProviderInstancesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listProviderInstances, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddProviderInstanceResponse> addProviderInstance(
    $0.AddProviderInstanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addProviderInstance, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateProviderInstanceResponse>
      updateProviderInstance(
    $0.UpdateProviderInstanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateProviderInstance, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.DeleteProviderInstanceResponse>
      deleteProviderInstance(
    $0.DeleteProviderInstanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteProviderInstance, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ReconnectProviderInstanceResponse>
      reconnectProviderInstance(
    $0.ReconnectProviderInstanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reconnectProviderInstance, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.EnableProviderInstanceResponse>
      enableProviderInstance(
    $0.EnableProviderInstanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$enableProviderInstance, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.DisableProviderInstanceResponse>
      disableProviderInstance(
    $0.DisableProviderInstanceRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disableProviderInstance, request,
        options: options);
  }

  // method descriptors

  static final _$listAvailableProviderInstances = $grpc.ClientMethod<
          $0.ListAvailableProviderInstancesRequest,
          $0.ProviderInstancesResponse>(
      '/synctv.provider.common.ProviderCommonService/ListAvailableProviderInstances',
      ($0.ListAvailableProviderInstancesRequest value) => value.writeToBuffer(),
      $0.ProviderInstancesResponse.fromBuffer);
  static final _$listProviderBackends = $grpc.ClientMethod<
          $0.ListProviderBackendsRequest, $0.ProviderBackendsResponse>(
      '/synctv.provider.common.ProviderCommonService/ListProviderBackends',
      ($0.ListProviderBackendsRequest value) => value.writeToBuffer(),
      $0.ProviderBackendsResponse.fromBuffer);
  static final _$listProviderInstances = $grpc.ClientMethod<
          $0.ListProviderInstancesRequest, $0.ListProviderInstancesResponse>(
      '/synctv.provider.common.ProviderCommonService/ListProviderInstances',
      ($0.ListProviderInstancesRequest value) => value.writeToBuffer(),
      $0.ListProviderInstancesResponse.fromBuffer);
  static final _$addProviderInstance = $grpc.ClientMethod<
          $0.AddProviderInstanceRequest, $0.AddProviderInstanceResponse>(
      '/synctv.provider.common.ProviderCommonService/AddProviderInstance',
      ($0.AddProviderInstanceRequest value) => value.writeToBuffer(),
      $0.AddProviderInstanceResponse.fromBuffer);
  static final _$updateProviderInstance = $grpc.ClientMethod<
          $0.UpdateProviderInstanceRequest, $0.UpdateProviderInstanceResponse>(
      '/synctv.provider.common.ProviderCommonService/UpdateProviderInstance',
      ($0.UpdateProviderInstanceRequest value) => value.writeToBuffer(),
      $0.UpdateProviderInstanceResponse.fromBuffer);
  static final _$deleteProviderInstance = $grpc.ClientMethod<
          $0.DeleteProviderInstanceRequest, $0.DeleteProviderInstanceResponse>(
      '/synctv.provider.common.ProviderCommonService/DeleteProviderInstance',
      ($0.DeleteProviderInstanceRequest value) => value.writeToBuffer(),
      $0.DeleteProviderInstanceResponse.fromBuffer);
  static final _$reconnectProviderInstance = $grpc.ClientMethod<
          $0.ReconnectProviderInstanceRequest,
          $0.ReconnectProviderInstanceResponse>(
      '/synctv.provider.common.ProviderCommonService/ReconnectProviderInstance',
      ($0.ReconnectProviderInstanceRequest value) => value.writeToBuffer(),
      $0.ReconnectProviderInstanceResponse.fromBuffer);
  static final _$enableProviderInstance = $grpc.ClientMethod<
          $0.EnableProviderInstanceRequest, $0.EnableProviderInstanceResponse>(
      '/synctv.provider.common.ProviderCommonService/EnableProviderInstance',
      ($0.EnableProviderInstanceRequest value) => value.writeToBuffer(),
      $0.EnableProviderInstanceResponse.fromBuffer);
  static final _$disableProviderInstance = $grpc.ClientMethod<
          $0.DisableProviderInstanceRequest,
          $0.DisableProviderInstanceResponse>(
      '/synctv.provider.common.ProviderCommonService/DisableProviderInstance',
      ($0.DisableProviderInstanceRequest value) => value.writeToBuffer(),
      $0.DisableProviderInstanceResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.provider.common.ProviderCommonService')
abstract class ProviderCommonServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.provider.common.ProviderCommonService';

  ProviderCommonServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListAvailableProviderInstancesRequest,
            $0.ProviderInstancesResponse>(
        'ListAvailableProviderInstances',
        listAvailableProviderInstances_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListAvailableProviderInstancesRequest.fromBuffer(value),
        ($0.ProviderInstancesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListProviderBackendsRequest,
            $0.ProviderBackendsResponse>(
        'ListProviderBackends',
        listProviderBackends_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListProviderBackendsRequest.fromBuffer(value),
        ($0.ProviderBackendsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListProviderInstancesRequest,
            $0.ListProviderInstancesResponse>(
        'ListProviderInstances',
        listProviderInstances_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListProviderInstancesRequest.fromBuffer(value),
        ($0.ListProviderInstancesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddProviderInstanceRequest,
            $0.AddProviderInstanceResponse>(
        'AddProviderInstance',
        addProviderInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AddProviderInstanceRequest.fromBuffer(value),
        ($0.AddProviderInstanceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateProviderInstanceRequest,
            $0.UpdateProviderInstanceResponse>(
        'UpdateProviderInstance',
        updateProviderInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateProviderInstanceRequest.fromBuffer(value),
        ($0.UpdateProviderInstanceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteProviderInstanceRequest,
            $0.DeleteProviderInstanceResponse>(
        'DeleteProviderInstance',
        deleteProviderInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteProviderInstanceRequest.fromBuffer(value),
        ($0.DeleteProviderInstanceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconnectProviderInstanceRequest,
            $0.ReconnectProviderInstanceResponse>(
        'ReconnectProviderInstance',
        reconnectProviderInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ReconnectProviderInstanceRequest.fromBuffer(value),
        ($0.ReconnectProviderInstanceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EnableProviderInstanceRequest,
            $0.EnableProviderInstanceResponse>(
        'EnableProviderInstance',
        enableProviderInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.EnableProviderInstanceRequest.fromBuffer(value),
        ($0.EnableProviderInstanceResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DisableProviderInstanceRequest,
            $0.DisableProviderInstanceResponse>(
        'DisableProviderInstance',
        disableProviderInstance_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DisableProviderInstanceRequest.fromBuffer(value),
        ($0.DisableProviderInstanceResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ProviderInstancesResponse>
      listAvailableProviderInstances_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.ListAvailableProviderInstancesRequest>
              $request) async {
    return listAvailableProviderInstances($call, await $request);
  }

  $async.Future<$0.ProviderInstancesResponse> listAvailableProviderInstances(
      $grpc.ServiceCall call, $0.ListAvailableProviderInstancesRequest request);

  $async.Future<$0.ProviderBackendsResponse> listProviderBackends_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListProviderBackendsRequest> $request) async {
    return listProviderBackends($call, await $request);
  }

  $async.Future<$0.ProviderBackendsResponse> listProviderBackends(
      $grpc.ServiceCall call, $0.ListProviderBackendsRequest request);

  $async.Future<$0.ListProviderInstancesResponse> listProviderInstances_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListProviderInstancesRequest> $request) async {
    return listProviderInstances($call, await $request);
  }

  $async.Future<$0.ListProviderInstancesResponse> listProviderInstances(
      $grpc.ServiceCall call, $0.ListProviderInstancesRequest request);

  $async.Future<$0.AddProviderInstanceResponse> addProviderInstance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AddProviderInstanceRequest> $request) async {
    return addProviderInstance($call, await $request);
  }

  $async.Future<$0.AddProviderInstanceResponse> addProviderInstance(
      $grpc.ServiceCall call, $0.AddProviderInstanceRequest request);

  $async.Future<$0.UpdateProviderInstanceResponse> updateProviderInstance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateProviderInstanceRequest> $request) async {
    return updateProviderInstance($call, await $request);
  }

  $async.Future<$0.UpdateProviderInstanceResponse> updateProviderInstance(
      $grpc.ServiceCall call, $0.UpdateProviderInstanceRequest request);

  $async.Future<$0.DeleteProviderInstanceResponse> deleteProviderInstance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteProviderInstanceRequest> $request) async {
    return deleteProviderInstance($call, await $request);
  }

  $async.Future<$0.DeleteProviderInstanceResponse> deleteProviderInstance(
      $grpc.ServiceCall call, $0.DeleteProviderInstanceRequest request);

  $async.Future<$0.ReconnectProviderInstanceResponse>
      reconnectProviderInstance_Pre($grpc.ServiceCall $call,
          $async.Future<$0.ReconnectProviderInstanceRequest> $request) async {
    return reconnectProviderInstance($call, await $request);
  }

  $async.Future<$0.ReconnectProviderInstanceResponse> reconnectProviderInstance(
      $grpc.ServiceCall call, $0.ReconnectProviderInstanceRequest request);

  $async.Future<$0.EnableProviderInstanceResponse> enableProviderInstance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.EnableProviderInstanceRequest> $request) async {
    return enableProviderInstance($call, await $request);
  }

  $async.Future<$0.EnableProviderInstanceResponse> enableProviderInstance(
      $grpc.ServiceCall call, $0.EnableProviderInstanceRequest request);

  $async.Future<$0.DisableProviderInstanceResponse> disableProviderInstance_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DisableProviderInstanceRequest> $request) async {
    return disableProviderInstance($call, await $request);
  }

  $async.Future<$0.DisableProviderInstanceResponse> disableProviderInstance(
      $grpc.ServiceCall call, $0.DisableProviderInstanceRequest request);
}
