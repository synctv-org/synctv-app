// This is a generated file - do not edit.
//
// Generated from proto/providers/qnap_service.proto.

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
import 'qnap.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class QnapProviderServiceApi {
  final $pb.RpcClient _client;

  QnapProviderServiceApi(this._client);

  $async.Future<$0.LoginResponse> login(
          $pb.ClientContext? ctx, $0.LoginRequest request) =>
      _client.invoke<$0.LoginResponse>(
          ctx, 'QnapProviderService', 'Login', request, $0.LoginResponse());
  $async.Future<$0.ListResponse> list(
          $pb.ClientContext? ctx, $0.ListRequest request) =>
      _client.invoke<$0.ListResponse>(
          ctx, 'QnapProviderService', 'List', request, $0.ListResponse());
  $async.Future<$0.GetCapabilitiesResponse> getCapabilities(
          $pb.ClientContext? ctx, $0.GetCapabilitiesRequest request) =>
      _client.invoke<$0.GetCapabilitiesResponse>(ctx, 'QnapProviderService',
          'GetCapabilities', request, $0.GetCapabilitiesResponse());
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(
          ctx, 'QnapProviderService', 'Logout', request, $0.LogoutResponse());
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'QnapProviderService',
          'GetBinds', request, $0.GetBindsResponse());
  $async.Future<$1.ResourceResponse> getThumbnail(
          $pb.ClientContext? ctx, $0.GetThumbnailRequest request) =>
      _client.invoke<$1.ResourceResponse>(ctx, 'QnapProviderService',
          'GetThumbnail', request, $1.ResourceResponse());
}
