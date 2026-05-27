// This is a generated file - do not edit.
//
// Generated from proto/oauth2.proto.

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

import 'oauth2.pb.dart' as $0;

export 'oauth2.pb.dart';

/// ==================== OAuth2 Service ====================
/// OAuth2/OIDC authentication service
///
/// Frontend-driven flow:
/// 1. Frontend calls GetAuthorizationUrl to get the OAuth2 provider's auth URL
/// 2. Frontend redirects user to the auth URL
/// 3. User authorizes on the OAuth2 provider (e.g., GitHub)
/// 4. Provider redirects to frontend URL with code and state parameters
/// 5. Frontend extracts code and state from URL
/// 6. Frontend calls ExchangeAuthorizationCode with code and state
/// 7. Backend validates state, exchanges code for user info, creates/logs in user
/// 8. Backend returns JWT token to frontend
///
/// Authentication:
/// - GetAuthorizationUrl: None (public)
/// - ExchangeAuthorizationCode: None for login flow; bind flow requires JWT matching OAuth2 state user
/// - GetAuthorizationUrlForBind: JWT Authorization header (user_id)
/// - ListAvailableProviders: None (public)
/// - UnlinkProvider, GetLinkedProviders: JWT Authorization header (user_id)
///
/// Routes: /api/oauth2/*
@$pb.GrpcServiceName('synctv.client.OAuth2Service')
class OAuth2ServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  OAuth2ServiceClient(super.channel, {super.options, super.interceptors});

  /// Get authorization URL for OAuth2 login flow
  /// Returns the URL to redirect the user to for authorization
  $grpc.ResponseFuture<$0.GetAuthorizationUrlResponse> getAuthorizationUrl(
    $0.GetAuthorizationUrlRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAuthorizationUrl, request, options: options);
  }

  /// Get authorization URL for binding OAuth2 provider to existing user account
  /// Requires authentication
  $grpc.ResponseFuture<$0.GetAuthorizationUrlForBindResponse>
      getAuthorizationUrlForBind(
    $0.GetAuthorizationUrlForBindRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAuthorizationUrlForBind, request,
        options: options);
  }

  /// Exchange authorization code for JWT token or complete a bind flow.
  /// Public for login flow. Bind flow requires authentication and the token's
  /// user ID must match the user stored in the OAuth2 state.
  $grpc.ResponseFuture<$0.ExchangeAuthorizationCodeResponse>
      exchangeAuthorizationCode(
    $0.ExchangeAuthorizationCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exchangeAuthorizationCode, request,
        options: options);
  }

  /// List all available OAuth2 provider instances
  $grpc.ResponseFuture<$0.ListAvailableProvidersResponse>
      listAvailableProviders(
    $0.ListAvailableProvidersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAvailableProviders, request,
        options: options);
  }

  /// Unlink OAuth2 provider from user account (requires authentication)
  $grpc.ResponseFuture<$0.UnlinkProviderResponse> unlinkProvider(
    $0.UnlinkProviderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unlinkProvider, request, options: options);
  }

  /// Get linked OAuth2 providers for authenticated user
  $grpc.ResponseFuture<$0.GetLinkedProvidersResponse> getLinkedProviders(
    $0.GetLinkedProvidersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLinkedProviders, request, options: options);
  }

  // method descriptors

  static final _$getAuthorizationUrl = $grpc.ClientMethod<
          $0.GetAuthorizationUrlRequest, $0.GetAuthorizationUrlResponse>(
      '/synctv.client.OAuth2Service/GetAuthorizationUrl',
      ($0.GetAuthorizationUrlRequest value) => value.writeToBuffer(),
      $0.GetAuthorizationUrlResponse.fromBuffer);
  static final _$getAuthorizationUrlForBind = $grpc.ClientMethod<
          $0.GetAuthorizationUrlForBindRequest,
          $0.GetAuthorizationUrlForBindResponse>(
      '/synctv.client.OAuth2Service/GetAuthorizationUrlForBind',
      ($0.GetAuthorizationUrlForBindRequest value) => value.writeToBuffer(),
      $0.GetAuthorizationUrlForBindResponse.fromBuffer);
  static final _$exchangeAuthorizationCode = $grpc.ClientMethod<
          $0.ExchangeAuthorizationCodeRequest,
          $0.ExchangeAuthorizationCodeResponse>(
      '/synctv.client.OAuth2Service/ExchangeAuthorizationCode',
      ($0.ExchangeAuthorizationCodeRequest value) => value.writeToBuffer(),
      $0.ExchangeAuthorizationCodeResponse.fromBuffer);
  static final _$listAvailableProviders = $grpc.ClientMethod<
          $0.ListAvailableProvidersRequest, $0.ListAvailableProvidersResponse>(
      '/synctv.client.OAuth2Service/ListAvailableProviders',
      ($0.ListAvailableProvidersRequest value) => value.writeToBuffer(),
      $0.ListAvailableProvidersResponse.fromBuffer);
  static final _$unlinkProvider =
      $grpc.ClientMethod<$0.UnlinkProviderRequest, $0.UnlinkProviderResponse>(
          '/synctv.client.OAuth2Service/UnlinkProvider',
          ($0.UnlinkProviderRequest value) => value.writeToBuffer(),
          $0.UnlinkProviderResponse.fromBuffer);
  static final _$getLinkedProviders = $grpc.ClientMethod<
          $0.GetLinkedProvidersRequest, $0.GetLinkedProvidersResponse>(
      '/synctv.client.OAuth2Service/GetLinkedProviders',
      ($0.GetLinkedProvidersRequest value) => value.writeToBuffer(),
      $0.GetLinkedProvidersResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.OAuth2Service')
abstract class OAuth2ServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.OAuth2Service';

  OAuth2ServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetAuthorizationUrlRequest,
            $0.GetAuthorizationUrlResponse>(
        'GetAuthorizationUrl',
        getAuthorizationUrl_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAuthorizationUrlRequest.fromBuffer(value),
        ($0.GetAuthorizationUrlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAuthorizationUrlForBindRequest,
            $0.GetAuthorizationUrlForBindResponse>(
        'GetAuthorizationUrlForBind',
        getAuthorizationUrlForBind_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAuthorizationUrlForBindRequest.fromBuffer(value),
        ($0.GetAuthorizationUrlForBindResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExchangeAuthorizationCodeRequest,
            $0.ExchangeAuthorizationCodeResponse>(
        'ExchangeAuthorizationCode',
        exchangeAuthorizationCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExchangeAuthorizationCodeRequest.fromBuffer(value),
        ($0.ExchangeAuthorizationCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAvailableProvidersRequest,
            $0.ListAvailableProvidersResponse>(
        'ListAvailableProviders',
        listAvailableProviders_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListAvailableProvidersRequest.fromBuffer(value),
        ($0.ListAvailableProvidersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnlinkProviderRequest,
            $0.UnlinkProviderResponse>(
        'UnlinkProvider',
        unlinkProvider_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UnlinkProviderRequest.fromBuffer(value),
        ($0.UnlinkProviderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLinkedProvidersRequest,
            $0.GetLinkedProvidersResponse>(
        'GetLinkedProviders',
        getLinkedProviders_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLinkedProvidersRequest.fromBuffer(value),
        ($0.GetLinkedProvidersResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetAuthorizationUrlResponse> getAuthorizationUrl_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetAuthorizationUrlRequest> $request) async {
    return getAuthorizationUrl($call, await $request);
  }

  $async.Future<$0.GetAuthorizationUrlResponse> getAuthorizationUrl(
      $grpc.ServiceCall call, $0.GetAuthorizationUrlRequest request);

  $async.Future<$0.GetAuthorizationUrlForBindResponse>
      getAuthorizationUrlForBind_Pre($grpc.ServiceCall $call,
          $async.Future<$0.GetAuthorizationUrlForBindRequest> $request) async {
    return getAuthorizationUrlForBind($call, await $request);
  }

  $async.Future<$0.GetAuthorizationUrlForBindResponse>
      getAuthorizationUrlForBind(
          $grpc.ServiceCall call, $0.GetAuthorizationUrlForBindRequest request);

  $async.Future<$0.ExchangeAuthorizationCodeResponse>
      exchangeAuthorizationCode_Pre($grpc.ServiceCall $call,
          $async.Future<$0.ExchangeAuthorizationCodeRequest> $request) async {
    return exchangeAuthorizationCode($call, await $request);
  }

  $async.Future<$0.ExchangeAuthorizationCodeResponse> exchangeAuthorizationCode(
      $grpc.ServiceCall call, $0.ExchangeAuthorizationCodeRequest request);

  $async.Future<$0.ListAvailableProvidersResponse> listAvailableProviders_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListAvailableProvidersRequest> $request) async {
    return listAvailableProviders($call, await $request);
  }

  $async.Future<$0.ListAvailableProvidersResponse> listAvailableProviders(
      $grpc.ServiceCall call, $0.ListAvailableProvidersRequest request);

  $async.Future<$0.UnlinkProviderResponse> unlinkProvider_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UnlinkProviderRequest> $request) async {
    return unlinkProvider($call, await $request);
  }

  $async.Future<$0.UnlinkProviderResponse> unlinkProvider(
      $grpc.ServiceCall call, $0.UnlinkProviderRequest request);

  $async.Future<$0.GetLinkedProvidersResponse> getLinkedProviders_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetLinkedProvidersRequest> $request) async {
    return getLinkedProviders($call, await $request);
  }

  $async.Future<$0.GetLinkedProvidersResponse> getLinkedProviders(
      $grpc.ServiceCall call, $0.GetLinkedProvidersRequest request);
}
