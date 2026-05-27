// This is a generated file - do not edit.
//
// Generated from proto/client.proto.

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

import 'client.pb.dart' as $0;

export 'client.pb.dart';

/// ==================== Auth Service ====================
/// Authentication: None (public access)
/// Routes: /api/auth/*
@$pb.GrpcServiceName('synctv.client.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  /// Public client local password registration/login uses OPAQUE.
  /// Passwordless email login is confirmed through its dedicated request.
  $grpc.ResponseFuture<$0.LoginResponse> confirmEmailLogin(
    $0.ConfirmEmailLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmEmailLogin, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreateGuestTokenResponse> createGuestToken(
    $0.CreateGuestTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createGuestToken, request, options: options);
  }

  $grpc.ResponseFuture<$0.StartOpaqueRegistrationResponse>
      startOpaqueRegistration(
    $0.StartOpaqueRegistrationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startOpaqueRegistration, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.RegisterResponse> finishOpaqueRegistration(
    $0.FinishOpaqueRegistrationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishOpaqueRegistration, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.StartOpaqueLoginResponse> startOpaqueLogin(
    $0.StartOpaqueLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startOpaqueLogin, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> finishOpaqueLogin(
    $0.FinishOpaqueLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishOpaqueLogin, request, options: options);
  }

  $grpc.ResponseFuture<$0.StartPasskeyRegistrationResponse>
      startPasskeyRegistration(
    $0.StartPasskeyRegistrationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startPasskeyRegistration, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.RegisterResponse> finishPasskeyRegistration(
    $0.FinishPasskeyRegistrationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishPasskeyRegistration, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.StartPasskeyLoginResponse> startPasskeyLogin(
    $0.StartPasskeyLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startPasskeyLogin, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> finishPasskeyLogin(
    $0.FinishPasskeyLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishPasskeyLogin, request, options: options);
  }

  $grpc.ResponseFuture<$0.RequestEmailLoginResponse> requestEmailLogin(
    $0.RequestEmailLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestEmailLogin, request, options: options);
  }

  $grpc.ResponseFuture<$0.RequestMfaEmailCodeResponse> requestMfaEmailCode(
    $0.RequestMfaEmailCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestMfaEmailCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> verifyMfaEmailCode(
    $0.VerifyMfaEmailCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyMfaEmailCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.StartMfaPasskeyResponse> startMfaPasskey(
    $0.StartMfaPasskeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startMfaPasskey, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> finishMfaPasskey(
    $0.FinishMfaPasskeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishMfaPasskey, request, options: options);
  }

  $grpc.ResponseFuture<$0.RefreshTokenResponse> refreshToken(
    $0.RefreshTokenRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$refreshToken, request, options: options);
  }

  // method descriptors

  static final _$confirmEmailLogin =
      $grpc.ClientMethod<$0.ConfirmEmailLoginRequest, $0.LoginResponse>(
          '/synctv.client.AuthService/ConfirmEmailLogin',
          ($0.ConfirmEmailLoginRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$createGuestToken = $grpc.ClientMethod<
          $0.CreateGuestTokenRequest, $0.CreateGuestTokenResponse>(
      '/synctv.client.AuthService/CreateGuestToken',
      ($0.CreateGuestTokenRequest value) => value.writeToBuffer(),
      $0.CreateGuestTokenResponse.fromBuffer);
  static final _$startOpaqueRegistration = $grpc.ClientMethod<
          $0.StartOpaqueRegistrationRequest,
          $0.StartOpaqueRegistrationResponse>(
      '/synctv.client.AuthService/StartOpaqueRegistration',
      ($0.StartOpaqueRegistrationRequest value) => value.writeToBuffer(),
      $0.StartOpaqueRegistrationResponse.fromBuffer);
  static final _$finishOpaqueRegistration = $grpc.ClientMethod<
          $0.FinishOpaqueRegistrationRequest, $0.RegisterResponse>(
      '/synctv.client.AuthService/FinishOpaqueRegistration',
      ($0.FinishOpaqueRegistrationRequest value) => value.writeToBuffer(),
      $0.RegisterResponse.fromBuffer);
  static final _$startOpaqueLogin = $grpc.ClientMethod<
          $0.StartOpaqueLoginRequest, $0.StartOpaqueLoginResponse>(
      '/synctv.client.AuthService/StartOpaqueLogin',
      ($0.StartOpaqueLoginRequest value) => value.writeToBuffer(),
      $0.StartOpaqueLoginResponse.fromBuffer);
  static final _$finishOpaqueLogin =
      $grpc.ClientMethod<$0.FinishOpaqueLoginRequest, $0.LoginResponse>(
          '/synctv.client.AuthService/FinishOpaqueLogin',
          ($0.FinishOpaqueLoginRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$startPasskeyRegistration = $grpc.ClientMethod<
          $0.StartPasskeyRegistrationRequest,
          $0.StartPasskeyRegistrationResponse>(
      '/synctv.client.AuthService/StartPasskeyRegistration',
      ($0.StartPasskeyRegistrationRequest value) => value.writeToBuffer(),
      $0.StartPasskeyRegistrationResponse.fromBuffer);
  static final _$finishPasskeyRegistration = $grpc.ClientMethod<
          $0.FinishPasskeyRegistrationRequest, $0.RegisterResponse>(
      '/synctv.client.AuthService/FinishPasskeyRegistration',
      ($0.FinishPasskeyRegistrationRequest value) => value.writeToBuffer(),
      $0.RegisterResponse.fromBuffer);
  static final _$startPasskeyLogin = $grpc.ClientMethod<
          $0.StartPasskeyLoginRequest, $0.StartPasskeyLoginResponse>(
      '/synctv.client.AuthService/StartPasskeyLogin',
      ($0.StartPasskeyLoginRequest value) => value.writeToBuffer(),
      $0.StartPasskeyLoginResponse.fromBuffer);
  static final _$finishPasskeyLogin =
      $grpc.ClientMethod<$0.FinishPasskeyLoginRequest, $0.LoginResponse>(
          '/synctv.client.AuthService/FinishPasskeyLogin',
          ($0.FinishPasskeyLoginRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$requestEmailLogin = $grpc.ClientMethod<
          $0.RequestEmailLoginRequest, $0.RequestEmailLoginResponse>(
      '/synctv.client.AuthService/RequestEmailLogin',
      ($0.RequestEmailLoginRequest value) => value.writeToBuffer(),
      $0.RequestEmailLoginResponse.fromBuffer);
  static final _$requestMfaEmailCode = $grpc.ClientMethod<
          $0.RequestMfaEmailCodeRequest, $0.RequestMfaEmailCodeResponse>(
      '/synctv.client.AuthService/RequestMfaEmailCode',
      ($0.RequestMfaEmailCodeRequest value) => value.writeToBuffer(),
      $0.RequestMfaEmailCodeResponse.fromBuffer);
  static final _$verifyMfaEmailCode =
      $grpc.ClientMethod<$0.VerifyMfaEmailCodeRequest, $0.LoginResponse>(
          '/synctv.client.AuthService/VerifyMfaEmailCode',
          ($0.VerifyMfaEmailCodeRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$startMfaPasskey =
      $grpc.ClientMethod<$0.StartMfaPasskeyRequest, $0.StartMfaPasskeyResponse>(
          '/synctv.client.AuthService/StartMfaPasskey',
          ($0.StartMfaPasskeyRequest value) => value.writeToBuffer(),
          $0.StartMfaPasskeyResponse.fromBuffer);
  static final _$finishMfaPasskey =
      $grpc.ClientMethod<$0.FinishMfaPasskeyRequest, $0.LoginResponse>(
          '/synctv.client.AuthService/FinishMfaPasskey',
          ($0.FinishMfaPasskeyRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$refreshToken =
      $grpc.ClientMethod<$0.RefreshTokenRequest, $0.RefreshTokenResponse>(
          '/synctv.client.AuthService/RefreshToken',
          ($0.RefreshTokenRequest value) => value.writeToBuffer(),
          $0.RefreshTokenResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.AuthService';

  AuthServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ConfirmEmailLoginRequest, $0.LoginResponse>(
            'ConfirmEmailLogin',
            confirmEmailLogin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ConfirmEmailLoginRequest.fromBuffer(value),
            ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateGuestTokenRequest,
            $0.CreateGuestTokenResponse>(
        'CreateGuestToken',
        createGuestToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateGuestTokenRequest.fromBuffer(value),
        ($0.CreateGuestTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartOpaqueRegistrationRequest,
            $0.StartOpaqueRegistrationResponse>(
        'StartOpaqueRegistration',
        startOpaqueRegistration_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartOpaqueRegistrationRequest.fromBuffer(value),
        ($0.StartOpaqueRegistrationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FinishOpaqueRegistrationRequest,
            $0.RegisterResponse>(
        'FinishOpaqueRegistration',
        finishOpaqueRegistration_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FinishOpaqueRegistrationRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartOpaqueLoginRequest,
            $0.StartOpaqueLoginResponse>(
        'StartOpaqueLogin',
        startOpaqueLogin_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartOpaqueLoginRequest.fromBuffer(value),
        ($0.StartOpaqueLoginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FinishOpaqueLoginRequest, $0.LoginResponse>(
            'FinishOpaqueLogin',
            finishOpaqueLogin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.FinishOpaqueLoginRequest.fromBuffer(value),
            ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartPasskeyRegistrationRequest,
            $0.StartPasskeyRegistrationResponse>(
        'StartPasskeyRegistration',
        startPasskeyRegistration_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartPasskeyRegistrationRequest.fromBuffer(value),
        ($0.StartPasskeyRegistrationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FinishPasskeyRegistrationRequest,
            $0.RegisterResponse>(
        'FinishPasskeyRegistration',
        finishPasskeyRegistration_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FinishPasskeyRegistrationRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartPasskeyLoginRequest,
            $0.StartPasskeyLoginResponse>(
        'StartPasskeyLogin',
        startPasskeyLogin_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartPasskeyLoginRequest.fromBuffer(value),
        ($0.StartPasskeyLoginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FinishPasskeyLoginRequest, $0.LoginResponse>(
            'FinishPasskeyLogin',
            finishPasskeyLogin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.FinishPasskeyLoginRequest.fromBuffer(value),
            ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RequestEmailLoginRequest,
            $0.RequestEmailLoginResponse>(
        'RequestEmailLogin',
        requestEmailLogin_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RequestEmailLoginRequest.fromBuffer(value),
        ($0.RequestEmailLoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RequestMfaEmailCodeRequest,
            $0.RequestMfaEmailCodeResponse>(
        'RequestMfaEmailCode',
        requestMfaEmailCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RequestMfaEmailCodeRequest.fromBuffer(value),
        ($0.RequestMfaEmailCodeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.VerifyMfaEmailCodeRequest, $0.LoginResponse>(
            'VerifyMfaEmailCode',
            verifyMfaEmailCode_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.VerifyMfaEmailCodeRequest.fromBuffer(value),
            ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartMfaPasskeyRequest,
            $0.StartMfaPasskeyResponse>(
        'StartMfaPasskey',
        startMfaPasskey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartMfaPasskeyRequest.fromBuffer(value),
        ($0.StartMfaPasskeyResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FinishMfaPasskeyRequest, $0.LoginResponse>(
            'FinishMfaPasskey',
            finishMfaPasskey_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.FinishMfaPasskeyRequest.fromBuffer(value),
            ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RefreshTokenRequest, $0.RefreshTokenResponse>(
            'RefreshToken',
            refreshToken_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RefreshTokenRequest.fromBuffer(value),
            ($0.RefreshTokenResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> confirmEmailLogin_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ConfirmEmailLoginRequest> $request) async {
    return confirmEmailLogin($call, await $request);
  }

  $async.Future<$0.LoginResponse> confirmEmailLogin(
      $grpc.ServiceCall call, $0.ConfirmEmailLoginRequest request);

  $async.Future<$0.CreateGuestTokenResponse> createGuestToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateGuestTokenRequest> $request) async {
    return createGuestToken($call, await $request);
  }

  $async.Future<$0.CreateGuestTokenResponse> createGuestToken(
      $grpc.ServiceCall call, $0.CreateGuestTokenRequest request);

  $async.Future<$0.StartOpaqueRegistrationResponse> startOpaqueRegistration_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartOpaqueRegistrationRequest> $request) async {
    return startOpaqueRegistration($call, await $request);
  }

  $async.Future<$0.StartOpaqueRegistrationResponse> startOpaqueRegistration(
      $grpc.ServiceCall call, $0.StartOpaqueRegistrationRequest request);

  $async.Future<$0.RegisterResponse> finishOpaqueRegistration_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FinishOpaqueRegistrationRequest> $request) async {
    return finishOpaqueRegistration($call, await $request);
  }

  $async.Future<$0.RegisterResponse> finishOpaqueRegistration(
      $grpc.ServiceCall call, $0.FinishOpaqueRegistrationRequest request);

  $async.Future<$0.StartOpaqueLoginResponse> startOpaqueLogin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartOpaqueLoginRequest> $request) async {
    return startOpaqueLogin($call, await $request);
  }

  $async.Future<$0.StartOpaqueLoginResponse> startOpaqueLogin(
      $grpc.ServiceCall call, $0.StartOpaqueLoginRequest request);

  $async.Future<$0.LoginResponse> finishOpaqueLogin_Pre($grpc.ServiceCall $call,
      $async.Future<$0.FinishOpaqueLoginRequest> $request) async {
    return finishOpaqueLogin($call, await $request);
  }

  $async.Future<$0.LoginResponse> finishOpaqueLogin(
      $grpc.ServiceCall call, $0.FinishOpaqueLoginRequest request);

  $async.Future<$0.StartPasskeyRegistrationResponse>
      startPasskeyRegistration_Pre($grpc.ServiceCall $call,
          $async.Future<$0.StartPasskeyRegistrationRequest> $request) async {
    return startPasskeyRegistration($call, await $request);
  }

  $async.Future<$0.StartPasskeyRegistrationResponse> startPasskeyRegistration(
      $grpc.ServiceCall call, $0.StartPasskeyRegistrationRequest request);

  $async.Future<$0.RegisterResponse> finishPasskeyRegistration_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FinishPasskeyRegistrationRequest> $request) async {
    return finishPasskeyRegistration($call, await $request);
  }

  $async.Future<$0.RegisterResponse> finishPasskeyRegistration(
      $grpc.ServiceCall call, $0.FinishPasskeyRegistrationRequest request);

  $async.Future<$0.StartPasskeyLoginResponse> startPasskeyLogin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartPasskeyLoginRequest> $request) async {
    return startPasskeyLogin($call, await $request);
  }

  $async.Future<$0.StartPasskeyLoginResponse> startPasskeyLogin(
      $grpc.ServiceCall call, $0.StartPasskeyLoginRequest request);

  $async.Future<$0.LoginResponse> finishPasskeyLogin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FinishPasskeyLoginRequest> $request) async {
    return finishPasskeyLogin($call, await $request);
  }

  $async.Future<$0.LoginResponse> finishPasskeyLogin(
      $grpc.ServiceCall call, $0.FinishPasskeyLoginRequest request);

  $async.Future<$0.RequestEmailLoginResponse> requestEmailLogin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RequestEmailLoginRequest> $request) async {
    return requestEmailLogin($call, await $request);
  }

  $async.Future<$0.RequestEmailLoginResponse> requestEmailLogin(
      $grpc.ServiceCall call, $0.RequestEmailLoginRequest request);

  $async.Future<$0.RequestMfaEmailCodeResponse> requestMfaEmailCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RequestMfaEmailCodeRequest> $request) async {
    return requestMfaEmailCode($call, await $request);
  }

  $async.Future<$0.RequestMfaEmailCodeResponse> requestMfaEmailCode(
      $grpc.ServiceCall call, $0.RequestMfaEmailCodeRequest request);

  $async.Future<$0.LoginResponse> verifyMfaEmailCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VerifyMfaEmailCodeRequest> $request) async {
    return verifyMfaEmailCode($call, await $request);
  }

  $async.Future<$0.LoginResponse> verifyMfaEmailCode(
      $grpc.ServiceCall call, $0.VerifyMfaEmailCodeRequest request);

  $async.Future<$0.StartMfaPasskeyResponse> startMfaPasskey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartMfaPasskeyRequest> $request) async {
    return startMfaPasskey($call, await $request);
  }

  $async.Future<$0.StartMfaPasskeyResponse> startMfaPasskey(
      $grpc.ServiceCall call, $0.StartMfaPasskeyRequest request);

  $async.Future<$0.LoginResponse> finishMfaPasskey_Pre($grpc.ServiceCall $call,
      $async.Future<$0.FinishMfaPasskeyRequest> $request) async {
    return finishMfaPasskey($call, await $request);
  }

  $async.Future<$0.LoginResponse> finishMfaPasskey(
      $grpc.ServiceCall call, $0.FinishMfaPasskeyRequest request);

  $async.Future<$0.RefreshTokenResponse> refreshToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RefreshTokenRequest> $request) async {
    return refreshToken($call, await $request);
  }

  $async.Future<$0.RefreshTokenResponse> refreshToken(
      $grpc.ServiceCall call, $0.RefreshTokenRequest request);
}

/// ==================== User Service ====================
/// Authentication: JWT Authorization header (user_id)
/// Routes: /api/user/*
@$pb.GrpcServiceName('synctv.client.UserService')
class UserServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UserServiceClient(super.channel, {super.options, super.interceptors});

  /// Profile Management
  $grpc.ResponseFuture<$0.LogoutResponse> logout(
    $0.LogoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetProfileResponse> getProfile(
    $0.GetProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.SetUsernameResponse> setUsername(
    $0.SetUsernameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setUsername, request, options: options);
  }

  $grpc.ResponseFuture<$0.StartOpaquePasswordUpdateResponse>
      startOpaquePasswordUpdate(
    $0.StartOpaquePasswordUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startOpaquePasswordUpdate, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.FinishOpaquePasswordUpdateResponse>
      finishOpaquePasswordUpdate(
    $0.FinishOpaquePasswordUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishOpaquePasswordUpdate, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.StartPasskeyBindResponse> startPasskeyBind(
    $0.StartPasskeyBindRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startPasskeyBind, request, options: options);
  }

  $grpc.ResponseFuture<$0.PasskeyCredentialResponse> finishPasskeyBind(
    $0.FinishPasskeyBindRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishPasskeyBind, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPasskeysResponse> listPasskeys(
    $0.ListPasskeysRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPasskeys, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeletePasskeyResponse> deletePasskey(
    $0.DeletePasskeyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deletePasskey, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserPreferencesResponse> getUserPreferences(
    $0.GetUserPreferencesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserPreferences, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateUserPreferencesResponse> updateUserPreferences(
    $0.UpdateUserPreferencesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateUserPreferences, request, options: options);
  }

  $grpc.ResponseFuture<$0.CloseAccountResponse> closeAccount(
    $0.CloseAccountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$closeAccount, request, options: options);
  }

  /// User-initiated room lifecycle operations outside room-scoped context
  $grpc.ResponseFuture<$0.CreateRoomResponse> createRoom(
    $0.CreateRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRoomResponse> getRoom(
    $0.GetRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.JoinRoomResponse> joinRoom(
    $0.JoinRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$joinRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListMyRoomsResponse> listMyRooms(
    $0.ListMyRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listMyRooms, request, options: options);
  }

  // method descriptors

  static final _$logout =
      $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
          '/synctv.client.UserService/Logout',
          ($0.LogoutRequest value) => value.writeToBuffer(),
          $0.LogoutResponse.fromBuffer);
  static final _$getProfile =
      $grpc.ClientMethod<$0.GetProfileRequest, $0.GetProfileResponse>(
          '/synctv.client.UserService/GetProfile',
          ($0.GetProfileRequest value) => value.writeToBuffer(),
          $0.GetProfileResponse.fromBuffer);
  static final _$setUsername =
      $grpc.ClientMethod<$0.SetUsernameRequest, $0.SetUsernameResponse>(
          '/synctv.client.UserService/SetUsername',
          ($0.SetUsernameRequest value) => value.writeToBuffer(),
          $0.SetUsernameResponse.fromBuffer);
  static final _$startOpaquePasswordUpdate = $grpc.ClientMethod<
          $0.StartOpaquePasswordUpdateRequest,
          $0.StartOpaquePasswordUpdateResponse>(
      '/synctv.client.UserService/StartOpaquePasswordUpdate',
      ($0.StartOpaquePasswordUpdateRequest value) => value.writeToBuffer(),
      $0.StartOpaquePasswordUpdateResponse.fromBuffer);
  static final _$finishOpaquePasswordUpdate = $grpc.ClientMethod<
          $0.FinishOpaquePasswordUpdateRequest,
          $0.FinishOpaquePasswordUpdateResponse>(
      '/synctv.client.UserService/FinishOpaquePasswordUpdate',
      ($0.FinishOpaquePasswordUpdateRequest value) => value.writeToBuffer(),
      $0.FinishOpaquePasswordUpdateResponse.fromBuffer);
  static final _$startPasskeyBind = $grpc.ClientMethod<
          $0.StartPasskeyBindRequest, $0.StartPasskeyBindResponse>(
      '/synctv.client.UserService/StartPasskeyBind',
      ($0.StartPasskeyBindRequest value) => value.writeToBuffer(),
      $0.StartPasskeyBindResponse.fromBuffer);
  static final _$finishPasskeyBind = $grpc.ClientMethod<
          $0.FinishPasskeyBindRequest, $0.PasskeyCredentialResponse>(
      '/synctv.client.UserService/FinishPasskeyBind',
      ($0.FinishPasskeyBindRequest value) => value.writeToBuffer(),
      $0.PasskeyCredentialResponse.fromBuffer);
  static final _$listPasskeys =
      $grpc.ClientMethod<$0.ListPasskeysRequest, $0.ListPasskeysResponse>(
          '/synctv.client.UserService/ListPasskeys',
          ($0.ListPasskeysRequest value) => value.writeToBuffer(),
          $0.ListPasskeysResponse.fromBuffer);
  static final _$deletePasskey =
      $grpc.ClientMethod<$0.DeletePasskeyRequest, $0.DeletePasskeyResponse>(
          '/synctv.client.UserService/DeletePasskey',
          ($0.DeletePasskeyRequest value) => value.writeToBuffer(),
          $0.DeletePasskeyResponse.fromBuffer);
  static final _$getUserPreferences = $grpc.ClientMethod<
          $0.GetUserPreferencesRequest, $0.GetUserPreferencesResponse>(
      '/synctv.client.UserService/GetUserPreferences',
      ($0.GetUserPreferencesRequest value) => value.writeToBuffer(),
      $0.GetUserPreferencesResponse.fromBuffer);
  static final _$updateUserPreferences = $grpc.ClientMethod<
          $0.UpdateUserPreferencesRequest, $0.UpdateUserPreferencesResponse>(
      '/synctv.client.UserService/UpdateUserPreferences',
      ($0.UpdateUserPreferencesRequest value) => value.writeToBuffer(),
      $0.UpdateUserPreferencesResponse.fromBuffer);
  static final _$closeAccount =
      $grpc.ClientMethod<$0.CloseAccountRequest, $0.CloseAccountResponse>(
          '/synctv.client.UserService/CloseAccount',
          ($0.CloseAccountRequest value) => value.writeToBuffer(),
          $0.CloseAccountResponse.fromBuffer);
  static final _$createRoom =
      $grpc.ClientMethod<$0.CreateRoomRequest, $0.CreateRoomResponse>(
          '/synctv.client.UserService/CreateRoom',
          ($0.CreateRoomRequest value) => value.writeToBuffer(),
          $0.CreateRoomResponse.fromBuffer);
  static final _$getRoom =
      $grpc.ClientMethod<$0.GetRoomRequest, $0.GetRoomResponse>(
          '/synctv.client.UserService/GetRoom',
          ($0.GetRoomRequest value) => value.writeToBuffer(),
          $0.GetRoomResponse.fromBuffer);
  static final _$joinRoom =
      $grpc.ClientMethod<$0.JoinRoomRequest, $0.JoinRoomResponse>(
          '/synctv.client.UserService/JoinRoom',
          ($0.JoinRoomRequest value) => value.writeToBuffer(),
          $0.JoinRoomResponse.fromBuffer);
  static final _$listMyRooms =
      $grpc.ClientMethod<$0.ListMyRoomsRequest, $0.ListMyRoomsResponse>(
          '/synctv.client.UserService/ListMyRooms',
          ($0.ListMyRoomsRequest value) => value.writeToBuffer(),
          $0.ListMyRoomsResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetProfileRequest, $0.GetProfileResponse>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetProfileRequest.fromBuffer(value),
        ($0.GetProfileResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SetUsernameRequest, $0.SetUsernameResponse>(
            'SetUsername',
            setUsername_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SetUsernameRequest.fromBuffer(value),
            ($0.SetUsernameResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartOpaquePasswordUpdateRequest,
            $0.StartOpaquePasswordUpdateResponse>(
        'StartOpaquePasswordUpdate',
        startOpaquePasswordUpdate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartOpaquePasswordUpdateRequest.fromBuffer(value),
        ($0.StartOpaquePasswordUpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FinishOpaquePasswordUpdateRequest,
            $0.FinishOpaquePasswordUpdateResponse>(
        'FinishOpaquePasswordUpdate',
        finishOpaquePasswordUpdate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FinishOpaquePasswordUpdateRequest.fromBuffer(value),
        ($0.FinishOpaquePasswordUpdateResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartPasskeyBindRequest,
            $0.StartPasskeyBindResponse>(
        'StartPasskeyBind',
        startPasskeyBind_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartPasskeyBindRequest.fromBuffer(value),
        ($0.StartPasskeyBindResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FinishPasskeyBindRequest,
            $0.PasskeyCredentialResponse>(
        'FinishPasskeyBind',
        finishPasskeyBind_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FinishPasskeyBindRequest.fromBuffer(value),
        ($0.PasskeyCredentialResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPasskeysRequest, $0.ListPasskeysResponse>(
            'ListPasskeys',
            listPasskeys_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPasskeysRequest.fromBuffer(value),
            ($0.ListPasskeysResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeletePasskeyRequest, $0.DeletePasskeyResponse>(
            'DeletePasskey',
            deletePasskey_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeletePasskeyRequest.fromBuffer(value),
            ($0.DeletePasskeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserPreferencesRequest,
            $0.GetUserPreferencesResponse>(
        'GetUserPreferences',
        getUserPreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUserPreferencesRequest.fromBuffer(value),
        ($0.GetUserPreferencesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateUserPreferencesRequest,
            $0.UpdateUserPreferencesResponse>(
        'UpdateUserPreferences',
        updateUserPreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateUserPreferencesRequest.fromBuffer(value),
        ($0.UpdateUserPreferencesResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.CloseAccountRequest, $0.CloseAccountResponse>(
            'CloseAccount',
            closeAccount_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.CloseAccountRequest.fromBuffer(value),
            ($0.CloseAccountResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateRoomRequest, $0.CreateRoomResponse>(
        'CreateRoom',
        createRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateRoomRequest.fromBuffer(value),
        ($0.CreateRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRoomRequest, $0.GetRoomResponse>(
        'GetRoom',
        getRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRoomRequest.fromBuffer(value),
        ($0.GetRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.JoinRoomRequest, $0.JoinRoomResponse>(
        'JoinRoom',
        joinRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.JoinRoomRequest.fromBuffer(value),
        ($0.JoinRoomResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListMyRoomsRequest, $0.ListMyRoomsResponse>(
            'ListMyRooms',
            listMyRooms_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListMyRoomsRequest.fromBuffer(value),
            ($0.ListMyRoomsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.LogoutResponse> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LogoutRequest> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$0.LogoutResponse> logout(
      $grpc.ServiceCall call, $0.LogoutRequest request);

  $async.Future<$0.GetProfileResponse> getProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetProfileRequest> $request) async {
    return getProfile($call, await $request);
  }

  $async.Future<$0.GetProfileResponse> getProfile(
      $grpc.ServiceCall call, $0.GetProfileRequest request);

  $async.Future<$0.SetUsernameResponse> setUsername_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetUsernameRequest> $request) async {
    return setUsername($call, await $request);
  }

  $async.Future<$0.SetUsernameResponse> setUsername(
      $grpc.ServiceCall call, $0.SetUsernameRequest request);

  $async.Future<$0.StartOpaquePasswordUpdateResponse>
      startOpaquePasswordUpdate_Pre($grpc.ServiceCall $call,
          $async.Future<$0.StartOpaquePasswordUpdateRequest> $request) async {
    return startOpaquePasswordUpdate($call, await $request);
  }

  $async.Future<$0.StartOpaquePasswordUpdateResponse> startOpaquePasswordUpdate(
      $grpc.ServiceCall call, $0.StartOpaquePasswordUpdateRequest request);

  $async.Future<$0.FinishOpaquePasswordUpdateResponse>
      finishOpaquePasswordUpdate_Pre($grpc.ServiceCall $call,
          $async.Future<$0.FinishOpaquePasswordUpdateRequest> $request) async {
    return finishOpaquePasswordUpdate($call, await $request);
  }

  $async.Future<$0.FinishOpaquePasswordUpdateResponse>
      finishOpaquePasswordUpdate(
          $grpc.ServiceCall call, $0.FinishOpaquePasswordUpdateRequest request);

  $async.Future<$0.StartPasskeyBindResponse> startPasskeyBind_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartPasskeyBindRequest> $request) async {
    return startPasskeyBind($call, await $request);
  }

  $async.Future<$0.StartPasskeyBindResponse> startPasskeyBind(
      $grpc.ServiceCall call, $0.StartPasskeyBindRequest request);

  $async.Future<$0.PasskeyCredentialResponse> finishPasskeyBind_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FinishPasskeyBindRequest> $request) async {
    return finishPasskeyBind($call, await $request);
  }

  $async.Future<$0.PasskeyCredentialResponse> finishPasskeyBind(
      $grpc.ServiceCall call, $0.FinishPasskeyBindRequest request);

  $async.Future<$0.ListPasskeysResponse> listPasskeys_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPasskeysRequest> $request) async {
    return listPasskeys($call, await $request);
  }

  $async.Future<$0.ListPasskeysResponse> listPasskeys(
      $grpc.ServiceCall call, $0.ListPasskeysRequest request);

  $async.Future<$0.DeletePasskeyResponse> deletePasskey_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeletePasskeyRequest> $request) async {
    return deletePasskey($call, await $request);
  }

  $async.Future<$0.DeletePasskeyResponse> deletePasskey(
      $grpc.ServiceCall call, $0.DeletePasskeyRequest request);

  $async.Future<$0.GetUserPreferencesResponse> getUserPreferences_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserPreferencesRequest> $request) async {
    return getUserPreferences($call, await $request);
  }

  $async.Future<$0.GetUserPreferencesResponse> getUserPreferences(
      $grpc.ServiceCall call, $0.GetUserPreferencesRequest request);

  $async.Future<$0.UpdateUserPreferencesResponse> updateUserPreferences_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateUserPreferencesRequest> $request) async {
    return updateUserPreferences($call, await $request);
  }

  $async.Future<$0.UpdateUserPreferencesResponse> updateUserPreferences(
      $grpc.ServiceCall call, $0.UpdateUserPreferencesRequest request);

  $async.Future<$0.CloseAccountResponse> closeAccount_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CloseAccountRequest> $request) async {
    return closeAccount($call, await $request);
  }

  $async.Future<$0.CloseAccountResponse> closeAccount(
      $grpc.ServiceCall call, $0.CloseAccountRequest request);

  $async.Future<$0.CreateRoomResponse> createRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateRoomRequest> $request) async {
    return createRoom($call, await $request);
  }

  $async.Future<$0.CreateRoomResponse> createRoom(
      $grpc.ServiceCall call, $0.CreateRoomRequest request);

  $async.Future<$0.GetRoomResponse> getRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRoomRequest> $request) async {
    return getRoom($call, await $request);
  }

  $async.Future<$0.GetRoomResponse> getRoom(
      $grpc.ServiceCall call, $0.GetRoomRequest request);

  $async.Future<$0.JoinRoomResponse> joinRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.JoinRoomRequest> $request) async {
    return joinRoom($call, await $request);
  }

  $async.Future<$0.JoinRoomResponse> joinRoom(
      $grpc.ServiceCall call, $0.JoinRoomRequest request);

  $async.Future<$0.ListMyRoomsResponse> listMyRooms_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListMyRoomsRequest> $request) async {
    return listMyRooms($call, await $request);
  }

  $async.Future<$0.ListMyRoomsResponse> listMyRooms(
      $grpc.ServiceCall call, $0.ListMyRoomsRequest request);
}

/// ==================== Room Service ====================
/// Authentication: JWT Authorization header (user_id) + x-room-id metadata (room context)
/// HTTP routes: /api/rooms/* with room context supplied by path, body, or x-room-id metadata.
@$pb.GrpcServiceName('synctv.client.RoomService')
class RoomServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RoomServiceClient(super.channel, {super.options, super.interceptors});

  /// Room Settings Management
  $grpc.ResponseFuture<$0.GetRoomSettingsResponse> getRoomSettings(
    $0.GetRoomSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateRoomSettingsResponse> updateRoomSettings(
    $0.UpdateRoomSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRoomSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.ResetRoomSettingsResponse> resetRoomSettings(
    $0.ResetRoomSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resetRoomSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.TransferRoomOwnershipResponse> transferRoomOwnership(
    $0.TransferRoomOwnershipRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$transferRoomOwnership, request, options: options);
  }

  $grpc.ResponseFuture<$0.LeaveRoomResponse> leaveRoom(
    $0.LeaveRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$leaveRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteRoomResponse> deleteRoom(
    $0.DeleteRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteRoom, request, options: options);
  }

  /// Room Password Management
  $grpc.ResponseFuture<$0.SetRoomPasswordResponse> setRoomPassword(
    $0.SetRoomPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setRoomPassword, request, options: options);
  }

  /// Member Management (room-scoped operations)
  $grpc.ResponseFuture<$0.GetRoomMembersResponse> getRoomMembers(
    $0.GetRoomMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomMembers, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRoomStreamsResponse> listRoomStreams(
    $0.ListRoomStreamsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRoomStreams, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRoomStreamInfoResponse> getRoomStreamInfo(
    $0.GetRoomStreamInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomStreamInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.KickRoomStreamResponse> kickRoomStream(
    $0.KickRoomStreamRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$kickRoomStream, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddMemberResponse> addMember(
    $0.AddMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addMember, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRoomJoinReviewsResponse> listRoomJoinReviews(
    $0.ListRoomJoinReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRoomJoinReviews, request, options: options);
  }

  $grpc.ResponseFuture<$0.ApproveRoomJoinReviewResponse> approveRoomJoinReview(
    $0.ApproveRoomJoinReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approveRoomJoinReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.RejectRoomJoinReviewResponse> rejectRoomJoinReview(
    $0.RejectRoomJoinReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rejectRoomJoinReview, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateMemberPermissionsResponse>
      updateMemberPermissions(
    $0.UpdateMemberPermissionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateMemberPermissions, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.KickMemberResponse> kickMember(
    $0.KickMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$kickMember, request, options: options);
  }

  /// Real-time Messaging (room-scoped)
  $grpc.ResponseFuture<$0.CreateWebSocketTicketResponse> createWebSocketTicket(
    $0.CreateWebSocketTicketRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createWebSocketTicket, request, options: options);
  }

  $grpc.ResponseStream<$0.ServerMessage> messageStream(
    $async.Stream<$0.ClientMessage> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$messageStream, request, options: options);
  }

  $grpc.ResponseStream<$0.WatchPlaybackStateEvent> watchPlaybackState(
    $0.WatchPlaybackStateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchPlaybackState, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.WatchPlaybackSnapshotEvent> watchPlaybackSnapshot(
    $0.WatchPlaybackSnapshotRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchPlaybackSnapshot, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.WatchRoomSettingsEvent> watchRoomSettings(
    $0.WatchRoomSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchRoomSettings, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.WatchPlaylistItemsEvent> watchPlaylistItems(
    $0.WatchPlaylistItemsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchPlaylistItems, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.WatchRoomMembersEvent> watchRoomMembers(
    $0.WatchRoomMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchRoomMembers, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.GetChatHistoryResponse> getChatHistory(
    $0.GetChatHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getChatHistory, request, options: options);
  }

  /// WebRTC ICE Servers Configuration
  $grpc.ResponseFuture<$0.GetIceServersResponse> getIceServers(
    $0.GetIceServersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getIceServers, request, options: options);
  }

  /// Playlist Management (room-scoped operations)
  $grpc.ResponseFuture<$0.CreatePlaylistResponse> createPlaylist(
    $0.CreatePlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPlaylistResponse> getPlaylist(
    $0.GetPlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdatePlaylistResponse> updatePlaylist(
    $0.UpdatePlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.MovePlaylistResponse> movePlaylist(
    $0.MovePlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$movePlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeletePlaylistResponse> deletePlaylist(
    $0.DeletePlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deletePlaylist, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPlaylistsResponse> listPlaylists(
    $0.ListPlaylistsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPlaylists, request, options: options);
  }

  /// Media Management (room-scoped operations)
  $grpc.ResponseFuture<$0.AddMediaResponse> addMedia(
    $0.AddMediaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addMedia, request, options: options);
  }

  $grpc.ResponseFuture<$0.Media> getMedia(
    $0.GetMediaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMedia, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteMediaResponse> deleteMedia(
    $0.DeleteMediaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteMedia, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteEntriesResponse> deleteEntries(
    $0.DeleteEntriesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteEntries, request, options: options);
  }

  $grpc.ResponseFuture<$0.EditMediaResponse> editMedia(
    $0.EditMediaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$editMedia, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListPlaylistItemsResponse> listPlaylistItems(
    $0.ListPlaylistItemsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPlaylistItems, request, options: options);
  }

  $grpc.ResponseFuture<$0.MoveMediaResponse> moveMedia(
    $0.MoveMediaRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$moveMedia, request, options: options);
  }

  $grpc.ResponseFuture<$0.ClearPlaylistResponse> clearPlaylist(
    $0.ClearPlaylistRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearPlaylist, request, options: options);
  }

  /// Batch Operations (room-scoped)
  $grpc.ResponseFuture<$0.AddMediaBatchResponse> addMediaBatch(
    $0.AddMediaBatchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addMediaBatch, request, options: options);
  }

  /// Playback Control (room-scoped request/response operations)
  /// Real-time playback commands (play/pause/seek/speed) are sent as
  /// ClientMessage frames over the room realtime stream, either WebSocket or
  /// gRPC MessageStream.
  $grpc.ResponseFuture<$0.StartPlaybackResponse> startPlayback(
    $0.StartPlaybackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startPlayback, request, options: options);
  }

  $grpc.ResponseFuture<$0.StopPlaybackResponse> stopPlayback(
    $0.StopPlaybackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$stopPlayback, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPlaybackResponse> getPlayback(
    $0.GetPlaybackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPlayback, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPlaybackResponse> updatePlayback(
    $0.UpdatePlaybackRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePlayback, request, options: options);
  }

  // method descriptors

  static final _$getRoomSettings =
      $grpc.ClientMethod<$0.GetRoomSettingsRequest, $0.GetRoomSettingsResponse>(
          '/synctv.client.RoomService/GetRoomSettings',
          ($0.GetRoomSettingsRequest value) => value.writeToBuffer(),
          $0.GetRoomSettingsResponse.fromBuffer);
  static final _$updateRoomSettings = $grpc.ClientMethod<
          $0.UpdateRoomSettingsRequest, $0.UpdateRoomSettingsResponse>(
      '/synctv.client.RoomService/UpdateRoomSettings',
      ($0.UpdateRoomSettingsRequest value) => value.writeToBuffer(),
      $0.UpdateRoomSettingsResponse.fromBuffer);
  static final _$resetRoomSettings = $grpc.ClientMethod<
          $0.ResetRoomSettingsRequest, $0.ResetRoomSettingsResponse>(
      '/synctv.client.RoomService/ResetRoomSettings',
      ($0.ResetRoomSettingsRequest value) => value.writeToBuffer(),
      $0.ResetRoomSettingsResponse.fromBuffer);
  static final _$transferRoomOwnership = $grpc.ClientMethod<
          $0.TransferRoomOwnershipRequest, $0.TransferRoomOwnershipResponse>(
      '/synctv.client.RoomService/TransferRoomOwnership',
      ($0.TransferRoomOwnershipRequest value) => value.writeToBuffer(),
      $0.TransferRoomOwnershipResponse.fromBuffer);
  static final _$leaveRoom =
      $grpc.ClientMethod<$0.LeaveRoomRequest, $0.LeaveRoomResponse>(
          '/synctv.client.RoomService/LeaveRoom',
          ($0.LeaveRoomRequest value) => value.writeToBuffer(),
          $0.LeaveRoomResponse.fromBuffer);
  static final _$deleteRoom =
      $grpc.ClientMethod<$0.DeleteRoomRequest, $0.DeleteRoomResponse>(
          '/synctv.client.RoomService/DeleteRoom',
          ($0.DeleteRoomRequest value) => value.writeToBuffer(),
          $0.DeleteRoomResponse.fromBuffer);
  static final _$setRoomPassword =
      $grpc.ClientMethod<$0.SetRoomPasswordRequest, $0.SetRoomPasswordResponse>(
          '/synctv.client.RoomService/SetRoomPassword',
          ($0.SetRoomPasswordRequest value) => value.writeToBuffer(),
          $0.SetRoomPasswordResponse.fromBuffer);
  static final _$getRoomMembers =
      $grpc.ClientMethod<$0.GetRoomMembersRequest, $0.GetRoomMembersResponse>(
          '/synctv.client.RoomService/GetRoomMembers',
          ($0.GetRoomMembersRequest value) => value.writeToBuffer(),
          $0.GetRoomMembersResponse.fromBuffer);
  static final _$listRoomStreams =
      $grpc.ClientMethod<$0.ListRoomStreamsRequest, $0.ListRoomStreamsResponse>(
          '/synctv.client.RoomService/ListRoomStreams',
          ($0.ListRoomStreamsRequest value) => value.writeToBuffer(),
          $0.ListRoomStreamsResponse.fromBuffer);
  static final _$getRoomStreamInfo = $grpc.ClientMethod<
          $0.GetRoomStreamInfoRequest, $0.GetRoomStreamInfoResponse>(
      '/synctv.client.RoomService/GetRoomStreamInfo',
      ($0.GetRoomStreamInfoRequest value) => value.writeToBuffer(),
      $0.GetRoomStreamInfoResponse.fromBuffer);
  static final _$kickRoomStream =
      $grpc.ClientMethod<$0.KickRoomStreamRequest, $0.KickRoomStreamResponse>(
          '/synctv.client.RoomService/KickRoomStream',
          ($0.KickRoomStreamRequest value) => value.writeToBuffer(),
          $0.KickRoomStreamResponse.fromBuffer);
  static final _$addMember =
      $grpc.ClientMethod<$0.AddMemberRequest, $0.AddMemberResponse>(
          '/synctv.client.RoomService/AddMember',
          ($0.AddMemberRequest value) => value.writeToBuffer(),
          $0.AddMemberResponse.fromBuffer);
  static final _$listRoomJoinReviews = $grpc.ClientMethod<
          $0.ListRoomJoinReviewsRequest, $0.ListRoomJoinReviewsResponse>(
      '/synctv.client.RoomService/ListRoomJoinReviews',
      ($0.ListRoomJoinReviewsRequest value) => value.writeToBuffer(),
      $0.ListRoomJoinReviewsResponse.fromBuffer);
  static final _$approveRoomJoinReview = $grpc.ClientMethod<
          $0.ApproveRoomJoinReviewRequest, $0.ApproveRoomJoinReviewResponse>(
      '/synctv.client.RoomService/ApproveRoomJoinReview',
      ($0.ApproveRoomJoinReviewRequest value) => value.writeToBuffer(),
      $0.ApproveRoomJoinReviewResponse.fromBuffer);
  static final _$rejectRoomJoinReview = $grpc.ClientMethod<
          $0.RejectRoomJoinReviewRequest, $0.RejectRoomJoinReviewResponse>(
      '/synctv.client.RoomService/RejectRoomJoinReview',
      ($0.RejectRoomJoinReviewRequest value) => value.writeToBuffer(),
      $0.RejectRoomJoinReviewResponse.fromBuffer);
  static final _$updateMemberPermissions = $grpc.ClientMethod<
          $0.UpdateMemberPermissionsRequest,
          $0.UpdateMemberPermissionsResponse>(
      '/synctv.client.RoomService/UpdateMemberPermissions',
      ($0.UpdateMemberPermissionsRequest value) => value.writeToBuffer(),
      $0.UpdateMemberPermissionsResponse.fromBuffer);
  static final _$kickMember =
      $grpc.ClientMethod<$0.KickMemberRequest, $0.KickMemberResponse>(
          '/synctv.client.RoomService/KickMember',
          ($0.KickMemberRequest value) => value.writeToBuffer(),
          $0.KickMemberResponse.fromBuffer);
  static final _$createWebSocketTicket = $grpc.ClientMethod<
          $0.CreateWebSocketTicketRequest, $0.CreateWebSocketTicketResponse>(
      '/synctv.client.RoomService/CreateWebSocketTicket',
      ($0.CreateWebSocketTicketRequest value) => value.writeToBuffer(),
      $0.CreateWebSocketTicketResponse.fromBuffer);
  static final _$messageStream =
      $grpc.ClientMethod<$0.ClientMessage, $0.ServerMessage>(
          '/synctv.client.RoomService/MessageStream',
          ($0.ClientMessage value) => value.writeToBuffer(),
          $0.ServerMessage.fromBuffer);
  static final _$watchPlaybackState = $grpc.ClientMethod<
          $0.WatchPlaybackStateRequest, $0.WatchPlaybackStateEvent>(
      '/synctv.client.RoomService/WatchPlaybackState',
      ($0.WatchPlaybackStateRequest value) => value.writeToBuffer(),
      $0.WatchPlaybackStateEvent.fromBuffer);
  static final _$watchPlaybackSnapshot = $grpc.ClientMethod<
          $0.WatchPlaybackSnapshotRequest, $0.WatchPlaybackSnapshotEvent>(
      '/synctv.client.RoomService/WatchPlaybackSnapshot',
      ($0.WatchPlaybackSnapshotRequest value) => value.writeToBuffer(),
      $0.WatchPlaybackSnapshotEvent.fromBuffer);
  static final _$watchRoomSettings = $grpc.ClientMethod<
          $0.WatchRoomSettingsRequest, $0.WatchRoomSettingsEvent>(
      '/synctv.client.RoomService/WatchRoomSettings',
      ($0.WatchRoomSettingsRequest value) => value.writeToBuffer(),
      $0.WatchRoomSettingsEvent.fromBuffer);
  static final _$watchPlaylistItems = $grpc.ClientMethod<
          $0.WatchPlaylistItemsRequest, $0.WatchPlaylistItemsEvent>(
      '/synctv.client.RoomService/WatchPlaylistItems',
      ($0.WatchPlaylistItemsRequest value) => value.writeToBuffer(),
      $0.WatchPlaylistItemsEvent.fromBuffer);
  static final _$watchRoomMembers =
      $grpc.ClientMethod<$0.WatchRoomMembersRequest, $0.WatchRoomMembersEvent>(
          '/synctv.client.RoomService/WatchRoomMembers',
          ($0.WatchRoomMembersRequest value) => value.writeToBuffer(),
          $0.WatchRoomMembersEvent.fromBuffer);
  static final _$getChatHistory =
      $grpc.ClientMethod<$0.GetChatHistoryRequest, $0.GetChatHistoryResponse>(
          '/synctv.client.RoomService/GetChatHistory',
          ($0.GetChatHistoryRequest value) => value.writeToBuffer(),
          $0.GetChatHistoryResponse.fromBuffer);
  static final _$getIceServers =
      $grpc.ClientMethod<$0.GetIceServersRequest, $0.GetIceServersResponse>(
          '/synctv.client.RoomService/GetIceServers',
          ($0.GetIceServersRequest value) => value.writeToBuffer(),
          $0.GetIceServersResponse.fromBuffer);
  static final _$createPlaylist =
      $grpc.ClientMethod<$0.CreatePlaylistRequest, $0.CreatePlaylistResponse>(
          '/synctv.client.RoomService/CreatePlaylist',
          ($0.CreatePlaylistRequest value) => value.writeToBuffer(),
          $0.CreatePlaylistResponse.fromBuffer);
  static final _$getPlaylist =
      $grpc.ClientMethod<$0.GetPlaylistRequest, $0.GetPlaylistResponse>(
          '/synctv.client.RoomService/GetPlaylist',
          ($0.GetPlaylistRequest value) => value.writeToBuffer(),
          $0.GetPlaylistResponse.fromBuffer);
  static final _$updatePlaylist =
      $grpc.ClientMethod<$0.UpdatePlaylistRequest, $0.UpdatePlaylistResponse>(
          '/synctv.client.RoomService/UpdatePlaylist',
          ($0.UpdatePlaylistRequest value) => value.writeToBuffer(),
          $0.UpdatePlaylistResponse.fromBuffer);
  static final _$movePlaylist =
      $grpc.ClientMethod<$0.MovePlaylistRequest, $0.MovePlaylistResponse>(
          '/synctv.client.RoomService/MovePlaylist',
          ($0.MovePlaylistRequest value) => value.writeToBuffer(),
          $0.MovePlaylistResponse.fromBuffer);
  static final _$deletePlaylist =
      $grpc.ClientMethod<$0.DeletePlaylistRequest, $0.DeletePlaylistResponse>(
          '/synctv.client.RoomService/DeletePlaylist',
          ($0.DeletePlaylistRequest value) => value.writeToBuffer(),
          $0.DeletePlaylistResponse.fromBuffer);
  static final _$listPlaylists =
      $grpc.ClientMethod<$0.ListPlaylistsRequest, $0.ListPlaylistsResponse>(
          '/synctv.client.RoomService/ListPlaylists',
          ($0.ListPlaylistsRequest value) => value.writeToBuffer(),
          $0.ListPlaylistsResponse.fromBuffer);
  static final _$addMedia =
      $grpc.ClientMethod<$0.AddMediaRequest, $0.AddMediaResponse>(
          '/synctv.client.RoomService/AddMedia',
          ($0.AddMediaRequest value) => value.writeToBuffer(),
          $0.AddMediaResponse.fromBuffer);
  static final _$getMedia = $grpc.ClientMethod<$0.GetMediaRequest, $0.Media>(
      '/synctv.client.RoomService/GetMedia',
      ($0.GetMediaRequest value) => value.writeToBuffer(),
      $0.Media.fromBuffer);
  static final _$deleteMedia =
      $grpc.ClientMethod<$0.DeleteMediaRequest, $0.DeleteMediaResponse>(
          '/synctv.client.RoomService/DeleteMedia',
          ($0.DeleteMediaRequest value) => value.writeToBuffer(),
          $0.DeleteMediaResponse.fromBuffer);
  static final _$deleteEntries =
      $grpc.ClientMethod<$0.DeleteEntriesRequest, $0.DeleteEntriesResponse>(
          '/synctv.client.RoomService/DeleteEntries',
          ($0.DeleteEntriesRequest value) => value.writeToBuffer(),
          $0.DeleteEntriesResponse.fromBuffer);
  static final _$editMedia =
      $grpc.ClientMethod<$0.EditMediaRequest, $0.EditMediaResponse>(
          '/synctv.client.RoomService/EditMedia',
          ($0.EditMediaRequest value) => value.writeToBuffer(),
          $0.EditMediaResponse.fromBuffer);
  static final _$listPlaylistItems = $grpc.ClientMethod<
          $0.ListPlaylistItemsRequest, $0.ListPlaylistItemsResponse>(
      '/synctv.client.RoomService/ListPlaylistItems',
      ($0.ListPlaylistItemsRequest value) => value.writeToBuffer(),
      $0.ListPlaylistItemsResponse.fromBuffer);
  static final _$moveMedia =
      $grpc.ClientMethod<$0.MoveMediaRequest, $0.MoveMediaResponse>(
          '/synctv.client.RoomService/MoveMedia',
          ($0.MoveMediaRequest value) => value.writeToBuffer(),
          $0.MoveMediaResponse.fromBuffer);
  static final _$clearPlaylist =
      $grpc.ClientMethod<$0.ClearPlaylistRequest, $0.ClearPlaylistResponse>(
          '/synctv.client.RoomService/ClearPlaylist',
          ($0.ClearPlaylistRequest value) => value.writeToBuffer(),
          $0.ClearPlaylistResponse.fromBuffer);
  static final _$addMediaBatch =
      $grpc.ClientMethod<$0.AddMediaBatchRequest, $0.AddMediaBatchResponse>(
          '/synctv.client.RoomService/AddMediaBatch',
          ($0.AddMediaBatchRequest value) => value.writeToBuffer(),
          $0.AddMediaBatchResponse.fromBuffer);
  static final _$startPlayback =
      $grpc.ClientMethod<$0.StartPlaybackRequest, $0.StartPlaybackResponse>(
          '/synctv.client.RoomService/StartPlayback',
          ($0.StartPlaybackRequest value) => value.writeToBuffer(),
          $0.StartPlaybackResponse.fromBuffer);
  static final _$stopPlayback =
      $grpc.ClientMethod<$0.StopPlaybackRequest, $0.StopPlaybackResponse>(
          '/synctv.client.RoomService/StopPlayback',
          ($0.StopPlaybackRequest value) => value.writeToBuffer(),
          $0.StopPlaybackResponse.fromBuffer);
  static final _$getPlayback =
      $grpc.ClientMethod<$0.GetPlaybackRequest, $0.GetPlaybackResponse>(
          '/synctv.client.RoomService/GetPlayback',
          ($0.GetPlaybackRequest value) => value.writeToBuffer(),
          $0.GetPlaybackResponse.fromBuffer);
  static final _$updatePlayback =
      $grpc.ClientMethod<$0.UpdatePlaybackRequest, $0.GetPlaybackResponse>(
          '/synctv.client.RoomService/UpdatePlayback',
          ($0.UpdatePlaybackRequest value) => value.writeToBuffer(),
          $0.GetPlaybackResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.RoomService')
abstract class RoomServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.RoomService';

  RoomServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetRoomSettingsRequest,
            $0.GetRoomSettingsResponse>(
        'GetRoomSettings',
        getRoomSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRoomSettingsRequest.fromBuffer(value),
        ($0.GetRoomSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateRoomSettingsRequest,
            $0.UpdateRoomSettingsResponse>(
        'UpdateRoomSettings',
        updateRoomSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateRoomSettingsRequest.fromBuffer(value),
        ($0.UpdateRoomSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResetRoomSettingsRequest,
            $0.ResetRoomSettingsResponse>(
        'ResetRoomSettings',
        resetRoomSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ResetRoomSettingsRequest.fromBuffer(value),
        ($0.ResetRoomSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TransferRoomOwnershipRequest,
            $0.TransferRoomOwnershipResponse>(
        'TransferRoomOwnership',
        transferRoomOwnership_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TransferRoomOwnershipRequest.fromBuffer(value),
        ($0.TransferRoomOwnershipResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LeaveRoomRequest, $0.LeaveRoomResponse>(
        'LeaveRoom',
        leaveRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LeaveRoomRequest.fromBuffer(value),
        ($0.LeaveRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRoomRequest, $0.DeleteRoomResponse>(
        'DeleteRoom',
        deleteRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteRoomRequest.fromBuffer(value),
        ($0.DeleteRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetRoomPasswordRequest,
            $0.SetRoomPasswordResponse>(
        'SetRoomPassword',
        setRoomPassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetRoomPasswordRequest.fromBuffer(value),
        ($0.SetRoomPasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRoomMembersRequest,
            $0.GetRoomMembersResponse>(
        'GetRoomMembers',
        getRoomMembers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRoomMembersRequest.fromBuffer(value),
        ($0.GetRoomMembersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRoomStreamsRequest,
            $0.ListRoomStreamsResponse>(
        'ListRoomStreams',
        listRoomStreams_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListRoomStreamsRequest.fromBuffer(value),
        ($0.ListRoomStreamsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRoomStreamInfoRequest,
            $0.GetRoomStreamInfoResponse>(
        'GetRoomStreamInfo',
        getRoomStreamInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRoomStreamInfoRequest.fromBuffer(value),
        ($0.GetRoomStreamInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KickRoomStreamRequest,
            $0.KickRoomStreamResponse>(
        'KickRoomStream',
        kickRoomStream_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.KickRoomStreamRequest.fromBuffer(value),
        ($0.KickRoomStreamResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddMemberRequest, $0.AddMemberResponse>(
        'AddMember',
        addMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddMemberRequest.fromBuffer(value),
        ($0.AddMemberResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRoomJoinReviewsRequest,
            $0.ListRoomJoinReviewsResponse>(
        'ListRoomJoinReviews',
        listRoomJoinReviews_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListRoomJoinReviewsRequest.fromBuffer(value),
        ($0.ListRoomJoinReviewsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApproveRoomJoinReviewRequest,
            $0.ApproveRoomJoinReviewResponse>(
        'ApproveRoomJoinReview',
        approveRoomJoinReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApproveRoomJoinReviewRequest.fromBuffer(value),
        ($0.ApproveRoomJoinReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RejectRoomJoinReviewRequest,
            $0.RejectRoomJoinReviewResponse>(
        'RejectRoomJoinReview',
        rejectRoomJoinReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RejectRoomJoinReviewRequest.fromBuffer(value),
        ($0.RejectRoomJoinReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateMemberPermissionsRequest,
            $0.UpdateMemberPermissionsResponse>(
        'UpdateMemberPermissions',
        updateMemberPermissions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateMemberPermissionsRequest.fromBuffer(value),
        ($0.UpdateMemberPermissionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KickMemberRequest, $0.KickMemberResponse>(
        'KickMember',
        kickMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KickMemberRequest.fromBuffer(value),
        ($0.KickMemberResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateWebSocketTicketRequest,
            $0.CreateWebSocketTicketResponse>(
        'CreateWebSocketTicket',
        createWebSocketTicket_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateWebSocketTicketRequest.fromBuffer(value),
        ($0.CreateWebSocketTicketResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClientMessage, $0.ServerMessage>(
        'MessageStream',
        messageStream,
        true,
        true,
        ($core.List<$core.int> value) => $0.ClientMessage.fromBuffer(value),
        ($0.ServerMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchPlaybackStateRequest,
            $0.WatchPlaybackStateEvent>(
        'WatchPlaybackState',
        watchPlaybackState_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchPlaybackStateRequest.fromBuffer(value),
        ($0.WatchPlaybackStateEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchPlaybackSnapshotRequest,
            $0.WatchPlaybackSnapshotEvent>(
        'WatchPlaybackSnapshot',
        watchPlaybackSnapshot_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchPlaybackSnapshotRequest.fromBuffer(value),
        ($0.WatchPlaybackSnapshotEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchRoomSettingsRequest,
            $0.WatchRoomSettingsEvent>(
        'WatchRoomSettings',
        watchRoomSettings_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchRoomSettingsRequest.fromBuffer(value),
        ($0.WatchRoomSettingsEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchPlaylistItemsRequest,
            $0.WatchPlaylistItemsEvent>(
        'WatchPlaylistItems',
        watchPlaylistItems_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchPlaylistItemsRequest.fromBuffer(value),
        ($0.WatchPlaylistItemsEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchRoomMembersRequest,
            $0.WatchRoomMembersEvent>(
        'WatchRoomMembers',
        watchRoomMembers_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchRoomMembersRequest.fromBuffer(value),
        ($0.WatchRoomMembersEvent value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetChatHistoryRequest,
            $0.GetChatHistoryResponse>(
        'GetChatHistory',
        getChatHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetChatHistoryRequest.fromBuffer(value),
        ($0.GetChatHistoryResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetIceServersRequest, $0.GetIceServersResponse>(
            'GetIceServers',
            getIceServers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetIceServersRequest.fromBuffer(value),
            ($0.GetIceServersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreatePlaylistRequest,
            $0.CreatePlaylistResponse>(
        'CreatePlaylist',
        createPlaylist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreatePlaylistRequest.fromBuffer(value),
        ($0.CreatePlaylistResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPlaylistRequest, $0.GetPlaylistResponse>(
            'GetPlaylist',
            getPlaylist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPlaylistRequest.fromBuffer(value),
            ($0.GetPlaylistResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePlaylistRequest,
            $0.UpdatePlaylistResponse>(
        'UpdatePlaylist',
        updatePlaylist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdatePlaylistRequest.fromBuffer(value),
        ($0.UpdatePlaylistResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.MovePlaylistRequest, $0.MovePlaylistResponse>(
            'MovePlaylist',
            movePlaylist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.MovePlaylistRequest.fromBuffer(value),
            ($0.MovePlaylistResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeletePlaylistRequest,
            $0.DeletePlaylistResponse>(
        'DeletePlaylist',
        deletePlaylist_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeletePlaylistRequest.fromBuffer(value),
        ($0.DeletePlaylistResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListPlaylistsRequest, $0.ListPlaylistsResponse>(
            'ListPlaylists',
            listPlaylists_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListPlaylistsRequest.fromBuffer(value),
            ($0.ListPlaylistsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddMediaRequest, $0.AddMediaResponse>(
        'AddMedia',
        addMedia_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddMediaRequest.fromBuffer(value),
        ($0.AddMediaResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMediaRequest, $0.Media>(
        'GetMedia',
        getMedia_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetMediaRequest.fromBuffer(value),
        ($0.Media value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteMediaRequest, $0.DeleteMediaResponse>(
            'DeleteMedia',
            deleteMedia_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteMediaRequest.fromBuffer(value),
            ($0.DeleteMediaResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteEntriesRequest, $0.DeleteEntriesResponse>(
            'DeleteEntries',
            deleteEntries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteEntriesRequest.fromBuffer(value),
            ($0.DeleteEntriesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EditMediaRequest, $0.EditMediaResponse>(
        'EditMedia',
        editMedia_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EditMediaRequest.fromBuffer(value),
        ($0.EditMediaResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPlaylistItemsRequest,
            $0.ListPlaylistItemsResponse>(
        'ListPlaylistItems',
        listPlaylistItems_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListPlaylistItemsRequest.fromBuffer(value),
        ($0.ListPlaylistItemsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MoveMediaRequest, $0.MoveMediaResponse>(
        'MoveMedia',
        moveMedia_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MoveMediaRequest.fromBuffer(value),
        ($0.MoveMediaResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ClearPlaylistRequest, $0.ClearPlaylistResponse>(
            'ClearPlaylist',
            clearPlaylist_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ClearPlaylistRequest.fromBuffer(value),
            ($0.ClearPlaylistResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddMediaBatchRequest, $0.AddMediaBatchResponse>(
            'AddMediaBatch',
            addMediaBatch_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddMediaBatchRequest.fromBuffer(value),
            ($0.AddMediaBatchResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.StartPlaybackRequest, $0.StartPlaybackResponse>(
            'StartPlayback',
            startPlayback_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.StartPlaybackRequest.fromBuffer(value),
            ($0.StartPlaybackResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.StopPlaybackRequest, $0.StopPlaybackResponse>(
            'StopPlayback',
            stopPlayback_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.StopPlaybackRequest.fromBuffer(value),
            ($0.StopPlaybackResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetPlaybackRequest, $0.GetPlaybackResponse>(
            'GetPlayback',
            getPlayback_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetPlaybackRequest.fromBuffer(value),
            ($0.GetPlaybackResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UpdatePlaybackRequest, $0.GetPlaybackResponse>(
            'UpdatePlayback',
            updatePlayback_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.UpdatePlaybackRequest.fromBuffer(value),
            ($0.GetPlaybackResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetRoomSettingsResponse> getRoomSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRoomSettingsRequest> $request) async {
    return getRoomSettings($call, await $request);
  }

  $async.Future<$0.GetRoomSettingsResponse> getRoomSettings(
      $grpc.ServiceCall call, $0.GetRoomSettingsRequest request);

  $async.Future<$0.UpdateRoomSettingsResponse> updateRoomSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateRoomSettingsRequest> $request) async {
    return updateRoomSettings($call, await $request);
  }

  $async.Future<$0.UpdateRoomSettingsResponse> updateRoomSettings(
      $grpc.ServiceCall call, $0.UpdateRoomSettingsRequest request);

  $async.Future<$0.ResetRoomSettingsResponse> resetRoomSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ResetRoomSettingsRequest> $request) async {
    return resetRoomSettings($call, await $request);
  }

  $async.Future<$0.ResetRoomSettingsResponse> resetRoomSettings(
      $grpc.ServiceCall call, $0.ResetRoomSettingsRequest request);

  $async.Future<$0.TransferRoomOwnershipResponse> transferRoomOwnership_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TransferRoomOwnershipRequest> $request) async {
    return transferRoomOwnership($call, await $request);
  }

  $async.Future<$0.TransferRoomOwnershipResponse> transferRoomOwnership(
      $grpc.ServiceCall call, $0.TransferRoomOwnershipRequest request);

  $async.Future<$0.LeaveRoomResponse> leaveRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.LeaveRoomRequest> $request) async {
    return leaveRoom($call, await $request);
  }

  $async.Future<$0.LeaveRoomResponse> leaveRoom(
      $grpc.ServiceCall call, $0.LeaveRoomRequest request);

  $async.Future<$0.DeleteRoomResponse> deleteRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteRoomRequest> $request) async {
    return deleteRoom($call, await $request);
  }

  $async.Future<$0.DeleteRoomResponse> deleteRoom(
      $grpc.ServiceCall call, $0.DeleteRoomRequest request);

  $async.Future<$0.SetRoomPasswordResponse> setRoomPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetRoomPasswordRequest> $request) async {
    return setRoomPassword($call, await $request);
  }

  $async.Future<$0.SetRoomPasswordResponse> setRoomPassword(
      $grpc.ServiceCall call, $0.SetRoomPasswordRequest request);

  $async.Future<$0.GetRoomMembersResponse> getRoomMembers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRoomMembersRequest> $request) async {
    return getRoomMembers($call, await $request);
  }

  $async.Future<$0.GetRoomMembersResponse> getRoomMembers(
      $grpc.ServiceCall call, $0.GetRoomMembersRequest request);

  $async.Future<$0.ListRoomStreamsResponse> listRoomStreams_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListRoomStreamsRequest> $request) async {
    return listRoomStreams($call, await $request);
  }

  $async.Future<$0.ListRoomStreamsResponse> listRoomStreams(
      $grpc.ServiceCall call, $0.ListRoomStreamsRequest request);

  $async.Future<$0.GetRoomStreamInfoResponse> getRoomStreamInfo_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRoomStreamInfoRequest> $request) async {
    return getRoomStreamInfo($call, await $request);
  }

  $async.Future<$0.GetRoomStreamInfoResponse> getRoomStreamInfo(
      $grpc.ServiceCall call, $0.GetRoomStreamInfoRequest request);

  $async.Future<$0.KickRoomStreamResponse> kickRoomStream_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.KickRoomStreamRequest> $request) async {
    return kickRoomStream($call, await $request);
  }

  $async.Future<$0.KickRoomStreamResponse> kickRoomStream(
      $grpc.ServiceCall call, $0.KickRoomStreamRequest request);

  $async.Future<$0.AddMemberResponse> addMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddMemberRequest> $request) async {
    return addMember($call, await $request);
  }

  $async.Future<$0.AddMemberResponse> addMember(
      $grpc.ServiceCall call, $0.AddMemberRequest request);

  $async.Future<$0.ListRoomJoinReviewsResponse> listRoomJoinReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListRoomJoinReviewsRequest> $request) async {
    return listRoomJoinReviews($call, await $request);
  }

  $async.Future<$0.ListRoomJoinReviewsResponse> listRoomJoinReviews(
      $grpc.ServiceCall call, $0.ListRoomJoinReviewsRequest request);

  $async.Future<$0.ApproveRoomJoinReviewResponse> approveRoomJoinReview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ApproveRoomJoinReviewRequest> $request) async {
    return approveRoomJoinReview($call, await $request);
  }

  $async.Future<$0.ApproveRoomJoinReviewResponse> approveRoomJoinReview(
      $grpc.ServiceCall call, $0.ApproveRoomJoinReviewRequest request);

  $async.Future<$0.RejectRoomJoinReviewResponse> rejectRoomJoinReview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RejectRoomJoinReviewRequest> $request) async {
    return rejectRoomJoinReview($call, await $request);
  }

  $async.Future<$0.RejectRoomJoinReviewResponse> rejectRoomJoinReview(
      $grpc.ServiceCall call, $0.RejectRoomJoinReviewRequest request);

  $async.Future<$0.UpdateMemberPermissionsResponse> updateMemberPermissions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateMemberPermissionsRequest> $request) async {
    return updateMemberPermissions($call, await $request);
  }

  $async.Future<$0.UpdateMemberPermissionsResponse> updateMemberPermissions(
      $grpc.ServiceCall call, $0.UpdateMemberPermissionsRequest request);

  $async.Future<$0.KickMemberResponse> kickMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.KickMemberRequest> $request) async {
    return kickMember($call, await $request);
  }

  $async.Future<$0.KickMemberResponse> kickMember(
      $grpc.ServiceCall call, $0.KickMemberRequest request);

  $async.Future<$0.CreateWebSocketTicketResponse> createWebSocketTicket_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreateWebSocketTicketRequest> $request) async {
    return createWebSocketTicket($call, await $request);
  }

  $async.Future<$0.CreateWebSocketTicketResponse> createWebSocketTicket(
      $grpc.ServiceCall call, $0.CreateWebSocketTicketRequest request);

  $async.Stream<$0.ServerMessage> messageStream(
      $grpc.ServiceCall call, $async.Stream<$0.ClientMessage> request);

  $async.Stream<$0.WatchPlaybackStateEvent> watchPlaybackState_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchPlaybackStateRequest> $request) async* {
    yield* watchPlaybackState($call, await $request);
  }

  $async.Stream<$0.WatchPlaybackStateEvent> watchPlaybackState(
      $grpc.ServiceCall call, $0.WatchPlaybackStateRequest request);

  $async.Stream<$0.WatchPlaybackSnapshotEvent> watchPlaybackSnapshot_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchPlaybackSnapshotRequest> $request) async* {
    yield* watchPlaybackSnapshot($call, await $request);
  }

  $async.Stream<$0.WatchPlaybackSnapshotEvent> watchPlaybackSnapshot(
      $grpc.ServiceCall call, $0.WatchPlaybackSnapshotRequest request);

  $async.Stream<$0.WatchRoomSettingsEvent> watchRoomSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchRoomSettingsRequest> $request) async* {
    yield* watchRoomSettings($call, await $request);
  }

  $async.Stream<$0.WatchRoomSettingsEvent> watchRoomSettings(
      $grpc.ServiceCall call, $0.WatchRoomSettingsRequest request);

  $async.Stream<$0.WatchPlaylistItemsEvent> watchPlaylistItems_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchPlaylistItemsRequest> $request) async* {
    yield* watchPlaylistItems($call, await $request);
  }

  $async.Stream<$0.WatchPlaylistItemsEvent> watchPlaylistItems(
      $grpc.ServiceCall call, $0.WatchPlaylistItemsRequest request);

  $async.Stream<$0.WatchRoomMembersEvent> watchRoomMembers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.WatchRoomMembersRequest> $request) async* {
    yield* watchRoomMembers($call, await $request);
  }

  $async.Stream<$0.WatchRoomMembersEvent> watchRoomMembers(
      $grpc.ServiceCall call, $0.WatchRoomMembersRequest request);

  $async.Future<$0.GetChatHistoryResponse> getChatHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetChatHistoryRequest> $request) async {
    return getChatHistory($call, await $request);
  }

  $async.Future<$0.GetChatHistoryResponse> getChatHistory(
      $grpc.ServiceCall call, $0.GetChatHistoryRequest request);

  $async.Future<$0.GetIceServersResponse> getIceServers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetIceServersRequest> $request) async {
    return getIceServers($call, await $request);
  }

  $async.Future<$0.GetIceServersResponse> getIceServers(
      $grpc.ServiceCall call, $0.GetIceServersRequest request);

  $async.Future<$0.CreatePlaylistResponse> createPlaylist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CreatePlaylistRequest> $request) async {
    return createPlaylist($call, await $request);
  }

  $async.Future<$0.CreatePlaylistResponse> createPlaylist(
      $grpc.ServiceCall call, $0.CreatePlaylistRequest request);

  $async.Future<$0.GetPlaylistResponse> getPlaylist_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPlaylistRequest> $request) async {
    return getPlaylist($call, await $request);
  }

  $async.Future<$0.GetPlaylistResponse> getPlaylist(
      $grpc.ServiceCall call, $0.GetPlaylistRequest request);

  $async.Future<$0.UpdatePlaylistResponse> updatePlaylist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdatePlaylistRequest> $request) async {
    return updatePlaylist($call, await $request);
  }

  $async.Future<$0.UpdatePlaylistResponse> updatePlaylist(
      $grpc.ServiceCall call, $0.UpdatePlaylistRequest request);

  $async.Future<$0.MovePlaylistResponse> movePlaylist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MovePlaylistRequest> $request) async {
    return movePlaylist($call, await $request);
  }

  $async.Future<$0.MovePlaylistResponse> movePlaylist(
      $grpc.ServiceCall call, $0.MovePlaylistRequest request);

  $async.Future<$0.DeletePlaylistResponse> deletePlaylist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeletePlaylistRequest> $request) async {
    return deletePlaylist($call, await $request);
  }

  $async.Future<$0.DeletePlaylistResponse> deletePlaylist(
      $grpc.ServiceCall call, $0.DeletePlaylistRequest request);

  $async.Future<$0.ListPlaylistsResponse> listPlaylists_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPlaylistsRequest> $request) async {
    return listPlaylists($call, await $request);
  }

  $async.Future<$0.ListPlaylistsResponse> listPlaylists(
      $grpc.ServiceCall call, $0.ListPlaylistsRequest request);

  $async.Future<$0.AddMediaResponse> addMedia_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddMediaRequest> $request) async {
    return addMedia($call, await $request);
  }

  $async.Future<$0.AddMediaResponse> addMedia(
      $grpc.ServiceCall call, $0.AddMediaRequest request);

  $async.Future<$0.Media> getMedia_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetMediaRequest> $request) async {
    return getMedia($call, await $request);
  }

  $async.Future<$0.Media> getMedia(
      $grpc.ServiceCall call, $0.GetMediaRequest request);

  $async.Future<$0.DeleteMediaResponse> deleteMedia_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteMediaRequest> $request) async {
    return deleteMedia($call, await $request);
  }

  $async.Future<$0.DeleteMediaResponse> deleteMedia(
      $grpc.ServiceCall call, $0.DeleteMediaRequest request);

  $async.Future<$0.DeleteEntriesResponse> deleteEntries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteEntriesRequest> $request) async {
    return deleteEntries($call, await $request);
  }

  $async.Future<$0.DeleteEntriesResponse> deleteEntries(
      $grpc.ServiceCall call, $0.DeleteEntriesRequest request);

  $async.Future<$0.EditMediaResponse> editMedia_Pre($grpc.ServiceCall $call,
      $async.Future<$0.EditMediaRequest> $request) async {
    return editMedia($call, await $request);
  }

  $async.Future<$0.EditMediaResponse> editMedia(
      $grpc.ServiceCall call, $0.EditMediaRequest request);

  $async.Future<$0.ListPlaylistItemsResponse> listPlaylistItems_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListPlaylistItemsRequest> $request) async {
    return listPlaylistItems($call, await $request);
  }

  $async.Future<$0.ListPlaylistItemsResponse> listPlaylistItems(
      $grpc.ServiceCall call, $0.ListPlaylistItemsRequest request);

  $async.Future<$0.MoveMediaResponse> moveMedia_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MoveMediaRequest> $request) async {
    return moveMedia($call, await $request);
  }

  $async.Future<$0.MoveMediaResponse> moveMedia(
      $grpc.ServiceCall call, $0.MoveMediaRequest request);

  $async.Future<$0.ClearPlaylistResponse> clearPlaylist_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ClearPlaylistRequest> $request) async {
    return clearPlaylist($call, await $request);
  }

  $async.Future<$0.ClearPlaylistResponse> clearPlaylist(
      $grpc.ServiceCall call, $0.ClearPlaylistRequest request);

  $async.Future<$0.AddMediaBatchResponse> addMediaBatch_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AddMediaBatchRequest> $request) async {
    return addMediaBatch($call, await $request);
  }

  $async.Future<$0.AddMediaBatchResponse> addMediaBatch(
      $grpc.ServiceCall call, $0.AddMediaBatchRequest request);

  $async.Future<$0.StartPlaybackResponse> startPlayback_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartPlaybackRequest> $request) async {
    return startPlayback($call, await $request);
  }

  $async.Future<$0.StartPlaybackResponse> startPlayback(
      $grpc.ServiceCall call, $0.StartPlaybackRequest request);

  $async.Future<$0.StopPlaybackResponse> stopPlayback_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StopPlaybackRequest> $request) async {
    return stopPlayback($call, await $request);
  }

  $async.Future<$0.StopPlaybackResponse> stopPlayback(
      $grpc.ServiceCall call, $0.StopPlaybackRequest request);

  $async.Future<$0.GetPlaybackResponse> getPlayback_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPlaybackRequest> $request) async {
    return getPlayback($call, await $request);
  }

  $async.Future<$0.GetPlaybackResponse> getPlayback(
      $grpc.ServiceCall call, $0.GetPlaybackRequest request);

  $async.Future<$0.GetPlaybackResponse> updatePlayback_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdatePlaybackRequest> $request) async {
    return updatePlayback($call, await $request);
  }

  $async.Future<$0.GetPlaybackResponse> updatePlayback(
      $grpc.ServiceCall call, $0.UpdatePlaybackRequest request);
}

/// ==================== Public Service ====================
/// Authentication: None (public access)
/// HTTP routes: public room discovery uses /api/rooms/*, public settings uses /api/public/settings,
/// server identity uses /api/public/server-info.
@$pb.GrpcServiceName('synctv.client.PublicService')
class PublicServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PublicServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CheckRoomResponse> checkRoom(
    $0.CheckRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListRoomsResponse> listRooms(
    $0.ListRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRooms, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetHotRoomsResponse> getHotRooms(
    $0.GetHotRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getHotRooms, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPublicSettingsResponse> getPublicSettings(
    $0.GetPublicSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPublicSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetServerInfoResponse> getServerInfo(
    $0.GetServerInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getServerInfo, request, options: options);
  }

  // method descriptors

  static final _$checkRoom =
      $grpc.ClientMethod<$0.CheckRoomRequest, $0.CheckRoomResponse>(
          '/synctv.client.PublicService/CheckRoom',
          ($0.CheckRoomRequest value) => value.writeToBuffer(),
          $0.CheckRoomResponse.fromBuffer);
  static final _$listRooms =
      $grpc.ClientMethod<$0.ListRoomsRequest, $0.ListRoomsResponse>(
          '/synctv.client.PublicService/ListRooms',
          ($0.ListRoomsRequest value) => value.writeToBuffer(),
          $0.ListRoomsResponse.fromBuffer);
  static final _$getHotRooms =
      $grpc.ClientMethod<$0.GetHotRoomsRequest, $0.GetHotRoomsResponse>(
          '/synctv.client.PublicService/GetHotRooms',
          ($0.GetHotRoomsRequest value) => value.writeToBuffer(),
          $0.GetHotRoomsResponse.fromBuffer);
  static final _$getPublicSettings = $grpc.ClientMethod<
          $0.GetPublicSettingsRequest, $0.GetPublicSettingsResponse>(
      '/synctv.client.PublicService/GetPublicSettings',
      ($0.GetPublicSettingsRequest value) => value.writeToBuffer(),
      $0.GetPublicSettingsResponse.fromBuffer);
  static final _$getServerInfo =
      $grpc.ClientMethod<$0.GetServerInfoRequest, $0.GetServerInfoResponse>(
          '/synctv.client.PublicService/GetServerInfo',
          ($0.GetServerInfoRequest value) => value.writeToBuffer(),
          $0.GetServerInfoResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.PublicService')
abstract class PublicServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.PublicService';

  PublicServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CheckRoomRequest, $0.CheckRoomResponse>(
        'CheckRoom',
        checkRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CheckRoomRequest.fromBuffer(value),
        ($0.CheckRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRoomsRequest, $0.ListRoomsResponse>(
        'ListRooms',
        listRooms_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRoomsRequest.fromBuffer(value),
        ($0.ListRoomsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetHotRoomsRequest, $0.GetHotRoomsResponse>(
            'GetHotRooms',
            getHotRooms_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetHotRoomsRequest.fromBuffer(value),
            ($0.GetHotRoomsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPublicSettingsRequest,
            $0.GetPublicSettingsResponse>(
        'GetPublicSettings',
        getPublicSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPublicSettingsRequest.fromBuffer(value),
        ($0.GetPublicSettingsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetServerInfoRequest, $0.GetServerInfoResponse>(
            'GetServerInfo',
            getServerInfo_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetServerInfoRequest.fromBuffer(value),
            ($0.GetServerInfoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CheckRoomResponse> checkRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CheckRoomRequest> $request) async {
    return checkRoom($call, await $request);
  }

  $async.Future<$0.CheckRoomResponse> checkRoom(
      $grpc.ServiceCall call, $0.CheckRoomRequest request);

  $async.Future<$0.ListRoomsResponse> listRooms_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListRoomsRequest> $request) async {
    return listRooms($call, await $request);
  }

  $async.Future<$0.ListRoomsResponse> listRooms(
      $grpc.ServiceCall call, $0.ListRoomsRequest request);

  $async.Future<$0.GetHotRoomsResponse> getHotRooms_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetHotRoomsRequest> $request) async {
    return getHotRooms($call, await $request);
  }

  $async.Future<$0.GetHotRoomsResponse> getHotRooms(
      $grpc.ServiceCall call, $0.GetHotRoomsRequest request);

  $async.Future<$0.GetPublicSettingsResponse> getPublicSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPublicSettingsRequest> $request) async {
    return getPublicSettings($call, await $request);
  }

  $async.Future<$0.GetPublicSettingsResponse> getPublicSettings(
      $grpc.ServiceCall call, $0.GetPublicSettingsRequest request);

  $async.Future<$0.GetServerInfoResponse> getServerInfo_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetServerInfoRequest> $request) async {
    return getServerInfo($call, await $request);
  }

  $async.Future<$0.GetServerInfoResponse> getServerInfo(
      $grpc.ServiceCall call, $0.GetServerInfoRequest request);
}

/// ==================== Email Service ====================
/// Authentication: None for sending codes, JWT for confirmation
/// Routes: /api/email/*
@$pb.GrpcServiceName('synctv.client.EmailService')
class EmailServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  EmailServiceClient(super.channel, {super.options, super.interceptors});

  /// Email verification
  $grpc.ResponseFuture<$0.SendVerificationEmailResponse> sendVerificationEmail(
    $0.SendVerificationEmailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendVerificationEmail, request, options: options);
  }

  $grpc.ResponseFuture<$0.ConfirmEmailResponse> confirmEmail(
    $0.ConfirmEmailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmEmail, request, options: options);
  }

  /// Password reset
  $grpc.ResponseFuture<$0.RequestPasswordResetResponse> requestPasswordReset(
    $0.RequestPasswordResetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestPasswordReset, request, options: options);
  }

  $grpc.ResponseFuture<$0.StartOpaquePasswordResetResponse>
      startOpaquePasswordReset(
    $0.StartOpaquePasswordResetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startOpaquePasswordReset, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ConfirmPasswordResetResponse>
      finishOpaquePasswordReset(
    $0.FinishOpaquePasswordResetRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$finishOpaquePasswordReset, request,
        options: options);
  }

  // method descriptors

  static final _$sendVerificationEmail = $grpc.ClientMethod<
          $0.SendVerificationEmailRequest, $0.SendVerificationEmailResponse>(
      '/synctv.client.EmailService/SendVerificationEmail',
      ($0.SendVerificationEmailRequest value) => value.writeToBuffer(),
      $0.SendVerificationEmailResponse.fromBuffer);
  static final _$confirmEmail =
      $grpc.ClientMethod<$0.ConfirmEmailRequest, $0.ConfirmEmailResponse>(
          '/synctv.client.EmailService/ConfirmEmail',
          ($0.ConfirmEmailRequest value) => value.writeToBuffer(),
          $0.ConfirmEmailResponse.fromBuffer);
  static final _$requestPasswordReset = $grpc.ClientMethod<
          $0.RequestPasswordResetRequest, $0.RequestPasswordResetResponse>(
      '/synctv.client.EmailService/RequestPasswordReset',
      ($0.RequestPasswordResetRequest value) => value.writeToBuffer(),
      $0.RequestPasswordResetResponse.fromBuffer);
  static final _$startOpaquePasswordReset = $grpc.ClientMethod<
          $0.StartOpaquePasswordResetRequest,
          $0.StartOpaquePasswordResetResponse>(
      '/synctv.client.EmailService/StartOpaquePasswordReset',
      ($0.StartOpaquePasswordResetRequest value) => value.writeToBuffer(),
      $0.StartOpaquePasswordResetResponse.fromBuffer);
  static final _$finishOpaquePasswordReset = $grpc.ClientMethod<
          $0.FinishOpaquePasswordResetRequest, $0.ConfirmPasswordResetResponse>(
      '/synctv.client.EmailService/FinishOpaquePasswordReset',
      ($0.FinishOpaquePasswordResetRequest value) => value.writeToBuffer(),
      $0.ConfirmPasswordResetResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.EmailService')
abstract class EmailServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.EmailService';

  EmailServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SendVerificationEmailRequest,
            $0.SendVerificationEmailResponse>(
        'SendVerificationEmail',
        sendVerificationEmail_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SendVerificationEmailRequest.fromBuffer(value),
        ($0.SendVerificationEmailResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ConfirmEmailRequest, $0.ConfirmEmailResponse>(
            'ConfirmEmail',
            confirmEmail_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ConfirmEmailRequest.fromBuffer(value),
            ($0.ConfirmEmailResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RequestPasswordResetRequest,
            $0.RequestPasswordResetResponse>(
        'RequestPasswordReset',
        requestPasswordReset_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RequestPasswordResetRequest.fromBuffer(value),
        ($0.RequestPasswordResetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StartOpaquePasswordResetRequest,
            $0.StartOpaquePasswordResetResponse>(
        'StartOpaquePasswordReset',
        startOpaquePasswordReset_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.StartOpaquePasswordResetRequest.fromBuffer(value),
        ($0.StartOpaquePasswordResetResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FinishOpaquePasswordResetRequest,
            $0.ConfirmPasswordResetResponse>(
        'FinishOpaquePasswordReset',
        finishOpaquePasswordReset_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FinishOpaquePasswordResetRequest.fromBuffer(value),
        ($0.ConfirmPasswordResetResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SendVerificationEmailResponse> sendVerificationEmail_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendVerificationEmailRequest> $request) async {
    return sendVerificationEmail($call, await $request);
  }

  $async.Future<$0.SendVerificationEmailResponse> sendVerificationEmail(
      $grpc.ServiceCall call, $0.SendVerificationEmailRequest request);

  $async.Future<$0.ConfirmEmailResponse> confirmEmail_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ConfirmEmailRequest> $request) async {
    return confirmEmail($call, await $request);
  }

  $async.Future<$0.ConfirmEmailResponse> confirmEmail(
      $grpc.ServiceCall call, $0.ConfirmEmailRequest request);

  $async.Future<$0.RequestPasswordResetResponse> requestPasswordReset_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RequestPasswordResetRequest> $request) async {
    return requestPasswordReset($call, await $request);
  }

  $async.Future<$0.RequestPasswordResetResponse> requestPasswordReset(
      $grpc.ServiceCall call, $0.RequestPasswordResetRequest request);

  $async.Future<$0.StartOpaquePasswordResetResponse>
      startOpaquePasswordReset_Pre($grpc.ServiceCall $call,
          $async.Future<$0.StartOpaquePasswordResetRequest> $request) async {
    return startOpaquePasswordReset($call, await $request);
  }

  $async.Future<$0.StartOpaquePasswordResetResponse> startOpaquePasswordReset(
      $grpc.ServiceCall call, $0.StartOpaquePasswordResetRequest request);

  $async.Future<$0.ConfirmPasswordResetResponse> finishOpaquePasswordReset_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FinishOpaquePasswordResetRequest> $request) async {
    return finishOpaquePasswordReset($call, await $request);
  }

  $async.Future<$0.ConfirmPasswordResetResponse> finishOpaquePasswordReset(
      $grpc.ServiceCall call, $0.FinishOpaquePasswordResetRequest request);
}

/// ==================== Notification Service ====================
/// Authentication: JWT Authorization header (user_id)
/// Routes: /api/notifications/*
@$pb.GrpcServiceName('synctv.client.NotificationService')
class NotificationServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  NotificationServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ListNotificationsResponse> listNotifications(
    $0.ListNotificationsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listNotifications, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetNotificationResponse> getNotification(
    $0.GetNotificationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getNotification, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkAsReadResponse> markAsRead(
    $0.MarkAsReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markAsRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.MarkAllAsReadResponse> markAllAsRead(
    $0.MarkAllAsReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markAllAsRead, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteNotificationResponse> deleteNotification(
    $0.DeleteNotificationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteNotification, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteAllReadResponse> deleteAllRead(
    $0.DeleteAllReadRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteAllRead, request, options: options);
  }

  // method descriptors

  static final _$listNotifications = $grpc.ClientMethod<
          $0.ListNotificationsRequest, $0.ListNotificationsResponse>(
      '/synctv.client.NotificationService/ListNotifications',
      ($0.ListNotificationsRequest value) => value.writeToBuffer(),
      $0.ListNotificationsResponse.fromBuffer);
  static final _$getNotification =
      $grpc.ClientMethod<$0.GetNotificationRequest, $0.GetNotificationResponse>(
          '/synctv.client.NotificationService/GetNotification',
          ($0.GetNotificationRequest value) => value.writeToBuffer(),
          $0.GetNotificationResponse.fromBuffer);
  static final _$markAsRead =
      $grpc.ClientMethod<$0.MarkAsReadRequest, $0.MarkAsReadResponse>(
          '/synctv.client.NotificationService/MarkAsRead',
          ($0.MarkAsReadRequest value) => value.writeToBuffer(),
          $0.MarkAsReadResponse.fromBuffer);
  static final _$markAllAsRead =
      $grpc.ClientMethod<$0.MarkAllAsReadRequest, $0.MarkAllAsReadResponse>(
          '/synctv.client.NotificationService/MarkAllAsRead',
          ($0.MarkAllAsReadRequest value) => value.writeToBuffer(),
          $0.MarkAllAsReadResponse.fromBuffer);
  static final _$deleteNotification = $grpc.ClientMethod<
          $0.DeleteNotificationRequest, $0.DeleteNotificationResponse>(
      '/synctv.client.NotificationService/DeleteNotification',
      ($0.DeleteNotificationRequest value) => value.writeToBuffer(),
      $0.DeleteNotificationResponse.fromBuffer);
  static final _$deleteAllRead =
      $grpc.ClientMethod<$0.DeleteAllReadRequest, $0.DeleteAllReadResponse>(
          '/synctv.client.NotificationService/DeleteAllRead',
          ($0.DeleteAllReadRequest value) => value.writeToBuffer(),
          $0.DeleteAllReadResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.client.NotificationService')
abstract class NotificationServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.client.NotificationService';

  NotificationServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListNotificationsRequest,
            $0.ListNotificationsResponse>(
        'ListNotifications',
        listNotifications_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListNotificationsRequest.fromBuffer(value),
        ($0.ListNotificationsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetNotificationRequest,
            $0.GetNotificationResponse>(
        'GetNotification',
        getNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetNotificationRequest.fromBuffer(value),
        ($0.GetNotificationResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MarkAsReadRequest, $0.MarkAsReadResponse>(
        'MarkAsRead',
        markAsRead_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MarkAsReadRequest.fromBuffer(value),
        ($0.MarkAsReadResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.MarkAllAsReadRequest, $0.MarkAllAsReadResponse>(
            'MarkAllAsRead',
            markAllAsRead_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.MarkAllAsReadRequest.fromBuffer(value),
            ($0.MarkAllAsReadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteNotificationRequest,
            $0.DeleteNotificationResponse>(
        'DeleteNotification',
        deleteNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteNotificationRequest.fromBuffer(value),
        ($0.DeleteNotificationResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DeleteAllReadRequest, $0.DeleteAllReadResponse>(
            'DeleteAllRead',
            deleteAllRead_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DeleteAllReadRequest.fromBuffer(value),
            ($0.DeleteAllReadResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListNotificationsResponse> listNotifications_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListNotificationsRequest> $request) async {
    return listNotifications($call, await $request);
  }

  $async.Future<$0.ListNotificationsResponse> listNotifications(
      $grpc.ServiceCall call, $0.ListNotificationsRequest request);

  $async.Future<$0.GetNotificationResponse> getNotification_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetNotificationRequest> $request) async {
    return getNotification($call, await $request);
  }

  $async.Future<$0.GetNotificationResponse> getNotification(
      $grpc.ServiceCall call, $0.GetNotificationRequest request);

  $async.Future<$0.MarkAsReadResponse> markAsRead_Pre($grpc.ServiceCall $call,
      $async.Future<$0.MarkAsReadRequest> $request) async {
    return markAsRead($call, await $request);
  }

  $async.Future<$0.MarkAsReadResponse> markAsRead(
      $grpc.ServiceCall call, $0.MarkAsReadRequest request);

  $async.Future<$0.MarkAllAsReadResponse> markAllAsRead_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.MarkAllAsReadRequest> $request) async {
    return markAllAsRead($call, await $request);
  }

  $async.Future<$0.MarkAllAsReadResponse> markAllAsRead(
      $grpc.ServiceCall call, $0.MarkAllAsReadRequest request);

  $async.Future<$0.DeleteNotificationResponse> deleteNotification_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteNotificationRequest> $request) async {
    return deleteNotification($call, await $request);
  }

  $async.Future<$0.DeleteNotificationResponse> deleteNotification(
      $grpc.ServiceCall call, $0.DeleteNotificationRequest request);

  $async.Future<$0.DeleteAllReadResponse> deleteAllRead_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DeleteAllReadRequest> $request) async {
    return deleteAllRead($call, await $request);
  }

  $async.Future<$0.DeleteAllReadResponse> deleteAllRead(
      $grpc.ServiceCall call, $0.DeleteAllReadRequest request);
}
