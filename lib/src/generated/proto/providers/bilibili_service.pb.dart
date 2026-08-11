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

import 'package:protobuf/protobuf.dart' as $pb;

import 'bilibili.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Bilibili Provider Service
///
/// Client-facing API for Bilibili video parsing, login, and user management
class BilibiliProviderServiceApi {
  final $pb.RpcClient _client;

  BilibiliProviderServiceApi(this._client);

  /// Parse Bilibili URL (video, anime, live), using the user's global bind when available
  $async.Future<$0.ParseResponse> parse(
          $pb.ClientContext? ctx, $0.ParseRequest request) =>
      _client.invoke<$0.ParseResponse>(
          ctx, 'BilibiliProviderService', 'Parse', request, $0.ParseResponse());
  $async.Future<$0.ListPlaylistResponse> listPlaylist(
          $pb.ClientContext? ctx, $0.ListPlaylistRequest request) =>
      _client.invoke<$0.ListPlaylistResponse>(ctx, 'BilibiliProviderService',
          'ListPlaylist', request, $0.ListPlaylistResponse());

  /// List live categories available for dynamic playlist creation
  $async.Future<$0.ListLiveAreasResponse> listLiveAreas(
          $pb.ClientContext? ctx, $0.ListLiveAreasRequest request) =>
      _client.invoke<$0.ListLiveAreasResponse>(ctx, 'BilibiliProviderService',
          'ListLiveAreas', request, $0.ListLiveAreasResponse());

  /// List the authenticated user's favorite folders
  $async.Future<$0.ListFavoriteFoldersResponse> listFavoriteFolders(
          $pb.ClientContext? ctx, $0.ListFavoriteFoldersRequest request) =>
      _client.invoke<$0.ListFavoriteFoldersResponse>(
          ctx,
          'BilibiliProviderService',
          'ListFavoriteFolders',
          request,
          $0.ListFavoriteFoldersResponse());

  /// List anime or cinema seasons followed by the authenticated user
  $async.Future<$0.ListFollowedPgcResponse> listFollowedPgc(
          $pb.ClientContext? ctx, $0.ListFollowedPgcRequest request) =>
      _client.invoke<$0.ListFollowedPgcResponse>(ctx, 'BilibiliProviderService',
          'ListFollowedPgc', request, $0.ListFollowedPgcResponse());
  $async.Future<$0.ListHistoryResponse> listHistory(
          $pb.ClientContext? ctx, $0.ListHistoryRequest request) =>
      _client.invoke<$0.ListHistoryResponse>(ctx, 'BilibiliProviderService',
          'ListHistory', request, $0.ListHistoryResponse());
  $async.Future<$0.ListPgcTimelineResponse> listPgcTimeline(
          $pb.ClientContext? ctx, $0.ListPgcTimelineRequest request) =>
      _client.invoke<$0.ListPgcTimelineResponse>(ctx, 'BilibiliProviderService',
          'ListPgcTimeline', request, $0.ListPgcTimelineResponse());
  $async.Future<$0.ListPgcSeasonsResponse> listPgcSeasons(
          $pb.ClientContext? ctx, $0.ListPgcSeasonsRequest request) =>
      _client.invoke<$0.ListPgcSeasonsResponse>(ctx, 'BilibiliProviderService',
          'ListPgcSeasons', request, $0.ListPgcSeasonsResponse());

  /// Generate QR code for login
  $async.Future<$0.QRCodeResponse> loginQR(
          $pb.ClientContext? ctx, $0.LoginQRRequest request) =>
      _client.invoke<$0.QRCodeResponse>(ctx, 'BilibiliProviderService',
          'LoginQR', request, $0.QRCodeResponse());

  /// Check QR code login status (persists credential on success)
  $async.Future<$0.QRStatusResponse> checkQR(
          $pb.ClientContext? ctx, $0.CheckQRRequest request) =>
      _client.invoke<$0.QRStatusResponse>(ctx, 'BilibiliProviderService',
          'CheckQR', request, $0.QRStatusResponse());

  /// Start SMS login and return captcha data for frontend Geetest rendering
  $async.Future<$0.StartSMSLoginResponse> startSMSLogin(
          $pb.ClientContext? ctx, $0.StartSMSLoginRequest request) =>
      _client.invoke<$0.StartSMSLoginResponse>(ctx, 'BilibiliProviderService',
          'StartSMSLogin', request, $0.StartSMSLoginResponse());

  /// Send SMS verification code
  $async.Future<$0.SendSMSResponse> sendSMS(
          $pb.ClientContext? ctx, $0.SendSMSRequest request) =>
      _client.invoke<$0.SendSMSResponse>(ctx, 'BilibiliProviderService',
          'SendSMS', request, $0.SendSMSResponse());

  /// Login with SMS code (persists credential on success)
  $async.Future<$0.LoginSMSResponse> loginSMS(
          $pb.ClientContext? ctx, $0.LoginSMSRequest request) =>
      _client.invoke<$0.LoginSMSResponse>(ctx, 'BilibiliProviderService',
          'LoginSMS', request, $0.LoginSMSResponse());

  /// Get user info from the user's global bind
  $async.Future<$0.UserInfoResponse> getUserInfo(
          $pb.ClientContext? ctx, $0.UserInfoRequest request) =>
      _client.invoke<$0.UserInfoResponse>(ctx, 'BilibiliProviderService',
          'GetUserInfo', request, $0.UserInfoResponse());

  /// Logout (delete stored credential)
  $async.Future<$0.LogoutResponse> logout(
          $pb.ClientContext? ctx, $0.LogoutRequest request) =>
      _client.invoke<$0.LogoutResponse>(ctx, 'BilibiliProviderService',
          'Logout', request, $0.LogoutResponse());

  /// Get saved credentials (binds)
  $async.Future<$0.GetBindsResponse> getBinds(
          $pb.ClientContext? ctx, $0.GetBindsRequest request) =>
      _client.invoke<$0.GetBindsResponse>(ctx, 'BilibiliProviderService',
          'GetBinds', request, $0.GetBindsResponse());
}
