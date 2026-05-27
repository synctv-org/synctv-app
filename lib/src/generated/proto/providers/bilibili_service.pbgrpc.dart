// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili_service.proto.

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

import 'bilibili.pb.dart' as $0;

export 'bilibili_service.pb.dart';

/// Bilibili Provider Service
///
/// Client-facing API for Bilibili video parsing, login, and user management
@$pb.GrpcServiceName('synctv.provider.bilibili.BilibiliProviderService')
class BilibiliProviderServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  BilibiliProviderServiceClient(super.channel,
      {super.options, super.interceptors});

  /// Parse Bilibili URL (video, anime, live), using the user's global bind when available
  $grpc.ResponseFuture<$0.ParseResponse> parse(
    $0.ParseRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$parse, request, options: options);
  }

  /// Generate QR code for login
  $grpc.ResponseFuture<$0.QRCodeResponse> loginQR(
    $0.LoginQRRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$loginQR, request, options: options);
  }

  /// Check QR code login status (persists credential on success)
  $grpc.ResponseFuture<$0.QRStatusResponse> checkQR(
    $0.CheckQRRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkQR, request, options: options);
  }

  /// Start SMS login and return captcha data for frontend Geetest rendering
  $grpc.ResponseFuture<$0.StartSMSLoginResponse> startSMSLogin(
    $0.StartSMSLoginRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$startSMSLogin, request, options: options);
  }

  /// Send SMS verification code
  $grpc.ResponseFuture<$0.SendSMSResponse> sendSMS(
    $0.SendSMSRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendSMS, request, options: options);
  }

  /// Login with SMS code (persists credential on success)
  $grpc.ResponseFuture<$0.LoginSMSResponse> loginSMS(
    $0.LoginSMSRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$loginSMS, request, options: options);
  }

  /// Get user info from the user's global bind
  $grpc.ResponseFuture<$0.UserInfoResponse> getUserInfo(
    $0.UserInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserInfo, request, options: options);
  }

  /// Logout (delete stored credential)
  $grpc.ResponseFuture<$0.LogoutResponse> logout(
    $0.LogoutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  /// Get saved credentials (binds)
  $grpc.ResponseFuture<$0.GetBindsResponse> getBinds(
    $0.GetBindsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBinds, request, options: options);
  }

  // method descriptors

  static final _$parse = $grpc.ClientMethod<$0.ParseRequest, $0.ParseResponse>(
      '/synctv.provider.bilibili.BilibiliProviderService/Parse',
      ($0.ParseRequest value) => value.writeToBuffer(),
      $0.ParseResponse.fromBuffer);
  static final _$loginQR =
      $grpc.ClientMethod<$0.LoginQRRequest, $0.QRCodeResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/LoginQR',
          ($0.LoginQRRequest value) => value.writeToBuffer(),
          $0.QRCodeResponse.fromBuffer);
  static final _$checkQR =
      $grpc.ClientMethod<$0.CheckQRRequest, $0.QRStatusResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/CheckQR',
          ($0.CheckQRRequest value) => value.writeToBuffer(),
          $0.QRStatusResponse.fromBuffer);
  static final _$startSMSLogin =
      $grpc.ClientMethod<$0.StartSMSLoginRequest, $0.StartSMSLoginResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/StartSMSLogin',
          ($0.StartSMSLoginRequest value) => value.writeToBuffer(),
          $0.StartSMSLoginResponse.fromBuffer);
  static final _$sendSMS =
      $grpc.ClientMethod<$0.SendSMSRequest, $0.SendSMSResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/SendSMS',
          ($0.SendSMSRequest value) => value.writeToBuffer(),
          $0.SendSMSResponse.fromBuffer);
  static final _$loginSMS =
      $grpc.ClientMethod<$0.LoginSMSRequest, $0.LoginSMSResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/LoginSMS',
          ($0.LoginSMSRequest value) => value.writeToBuffer(),
          $0.LoginSMSResponse.fromBuffer);
  static final _$getUserInfo =
      $grpc.ClientMethod<$0.UserInfoRequest, $0.UserInfoResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/GetUserInfo',
          ($0.UserInfoRequest value) => value.writeToBuffer(),
          $0.UserInfoResponse.fromBuffer);
  static final _$logout =
      $grpc.ClientMethod<$0.LogoutRequest, $0.LogoutResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/Logout',
          ($0.LogoutRequest value) => value.writeToBuffer(),
          $0.LogoutResponse.fromBuffer);
  static final _$getBinds =
      $grpc.ClientMethod<$0.GetBindsRequest, $0.GetBindsResponse>(
          '/synctv.provider.bilibili.BilibiliProviderService/GetBinds',
          ($0.GetBindsRequest value) => value.writeToBuffer(),
          $0.GetBindsResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.provider.bilibili.BilibiliProviderService')
abstract class BilibiliProviderServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.provider.bilibili.BilibiliProviderService';

  BilibiliProviderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ParseRequest, $0.ParseResponse>(
        'Parse',
        parse_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ParseRequest.fromBuffer(value),
        ($0.ParseResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginQRRequest, $0.QRCodeResponse>(
        'LoginQR',
        loginQR_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginQRRequest.fromBuffer(value),
        ($0.QRCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckQRRequest, $0.QRStatusResponse>(
        'CheckQR',
        checkQR_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CheckQRRequest.fromBuffer(value),
        ($0.QRStatusResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.StartSMSLoginRequest, $0.StartSMSLoginResponse>(
            'StartSMSLogin',
            startSMSLogin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.StartSMSLoginRequest.fromBuffer(value),
            ($0.StartSMSLoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendSMSRequest, $0.SendSMSResponse>(
        'SendSMS',
        sendSMS_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SendSMSRequest.fromBuffer(value),
        ($0.SendSMSResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginSMSRequest, $0.LoginSMSResponse>(
        'LoginSMS',
        loginSMS_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginSMSRequest.fromBuffer(value),
        ($0.LoginSMSResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UserInfoRequest, $0.UserInfoResponse>(
        'GetUserInfo',
        getUserInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UserInfoRequest.fromBuffer(value),
        ($0.UserInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $0.LogoutResponse>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($0.LogoutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetBindsRequest, $0.GetBindsResponse>(
        'GetBinds',
        getBinds_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetBindsRequest.fromBuffer(value),
        ($0.GetBindsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ParseResponse> parse_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ParseRequest> $request) async {
    return parse($call, await $request);
  }

  $async.Future<$0.ParseResponse> parse(
      $grpc.ServiceCall call, $0.ParseRequest request);

  $async.Future<$0.QRCodeResponse> loginQR_Pre($grpc.ServiceCall $call,
      $async.Future<$0.LoginQRRequest> $request) async {
    return loginQR($call, await $request);
  }

  $async.Future<$0.QRCodeResponse> loginQR(
      $grpc.ServiceCall call, $0.LoginQRRequest request);

  $async.Future<$0.QRStatusResponse> checkQR_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CheckQRRequest> $request) async {
    return checkQR($call, await $request);
  }

  $async.Future<$0.QRStatusResponse> checkQR(
      $grpc.ServiceCall call, $0.CheckQRRequest request);

  $async.Future<$0.StartSMSLoginResponse> startSMSLogin_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.StartSMSLoginRequest> $request) async {
    return startSMSLogin($call, await $request);
  }

  $async.Future<$0.StartSMSLoginResponse> startSMSLogin(
      $grpc.ServiceCall call, $0.StartSMSLoginRequest request);

  $async.Future<$0.SendSMSResponse> sendSMS_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SendSMSRequest> $request) async {
    return sendSMS($call, await $request);
  }

  $async.Future<$0.SendSMSResponse> sendSMS(
      $grpc.ServiceCall call, $0.SendSMSRequest request);

  $async.Future<$0.LoginSMSResponse> loginSMS_Pre($grpc.ServiceCall $call,
      $async.Future<$0.LoginSMSRequest> $request) async {
    return loginSMS($call, await $request);
  }

  $async.Future<$0.LoginSMSResponse> loginSMS(
      $grpc.ServiceCall call, $0.LoginSMSRequest request);

  $async.Future<$0.UserInfoResponse> getUserInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UserInfoRequest> $request) async {
    return getUserInfo($call, await $request);
  }

  $async.Future<$0.UserInfoResponse> getUserInfo(
      $grpc.ServiceCall call, $0.UserInfoRequest request);

  $async.Future<$0.LogoutResponse> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.LogoutRequest> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$0.LogoutResponse> logout(
      $grpc.ServiceCall call, $0.LogoutRequest request);

  $async.Future<$0.GetBindsResponse> getBinds_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetBindsRequest> $request) async {
    return getBinds($call, await $request);
  }

  $async.Future<$0.GetBindsResponse> getBinds(
      $grpc.ServiceCall call, $0.GetBindsRequest request);
}
