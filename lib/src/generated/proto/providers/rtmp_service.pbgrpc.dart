// This is a generated file - do not edit.
//
// Generated from proto/providers/rtmp_service.proto.

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

import 'rtmp.pb.dart' as $0;

export 'rtmp_service.pb.dart';

@$pb.GrpcServiceName('synctv.provider.rtmp.RtmpProviderService')
class RtmpProviderServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RtmpProviderServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CreatePublishKeyResponse> createPublishKey(
    $0.CreatePublishKeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPublishKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetStreamInfoResponse> getStreamInfo(
    $0.GetStreamInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStreamInfo, request, options: options);
  }

  // method descriptors

  static final _$createPublishKey = $grpc.ClientMethod<
          $0.CreatePublishKeyRequest, $0.CreatePublishKeyResponse>(
      '/synctv.provider.rtmp.RtmpProviderService/CreatePublishKey',
      ($0.CreatePublishKeyRequest value) => value.writeToBuffer(),
      $0.CreatePublishKeyResponse.fromBuffer);
  static final _$getStreamInfo =
      $grpc.ClientMethod<$0.GetStreamInfoRequest, $0.GetStreamInfoResponse>(
          '/synctv.provider.rtmp.RtmpProviderService/GetStreamInfo',
          ($0.GetStreamInfoRequest value) => value.writeToBuffer(),
          $0.GetStreamInfoResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.provider.rtmp.RtmpProviderService')
abstract class RtmpProviderServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.provider.rtmp.RtmpProviderService';

  RtmpProviderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreatePublishKeyRequest,
            $0.CreatePublishKeyResponse>(
        'CreatePublishKey',
        createPublishKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreatePublishKeyRequest.fromBuffer(value),
        ($0.CreatePublishKeyResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetStreamInfoRequest, $0.GetStreamInfoResponse>(
            'GetStreamInfo',
            getStreamInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetStreamInfoRequest.fromBuffer(value),
            ($0.GetStreamInfoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CreatePublishKeyResponse> createPublishKey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreatePublishKeyRequest> $request) async {
    return createPublishKey($call, await $request);
  }

  $async.Future<$0.CreatePublishKeyResponse> createPublishKey(
      $grpc.ServiceCall call, $0.CreatePublishKeyRequest request);

  $async.Future<$0.GetStreamInfoResponse> getStreamInfo_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetStreamInfoRequest> $request) async {
    return getStreamInfo($call, await $request);
  }

  $async.Future<$0.GetStreamInfoResponse> getStreamInfo(
      $grpc.ServiceCall call, $0.GetStreamInfoRequest request);
}
