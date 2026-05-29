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

import 'package:protobuf/protobuf.dart' as $pb;

import 'rtmp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class RtmpProviderServiceApi {
  final $pb.RpcClient _client;

  RtmpProviderServiceApi(this._client);

  $async.Future<$0.CreatePublishKeyResponse> createPublishKey(
          $pb.ClientContext? ctx, $0.CreatePublishKeyRequest request) =>
      _client.invoke<$0.CreatePublishKeyResponse>(ctx, 'RtmpProviderService',
          'CreatePublishKey', request, $0.CreatePublishKeyResponse());
  $async.Future<$0.GetStreamInfoResponse> getStreamInfo(
          $pb.ClientContext? ctx, $0.GetStreamInfoRequest request) =>
      _client.invoke<$0.GetStreamInfoResponse>(ctx, 'RtmpProviderService',
          'GetStreamInfo', request, $0.GetStreamInfoResponse());
}
