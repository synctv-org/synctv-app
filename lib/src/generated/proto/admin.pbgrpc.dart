// This is a generated file - do not edit.
//
// Generated from proto/admin.proto.

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

import 'admin.pb.dart' as $0;

export 'admin.pb.dart';

/// Admin API for SyncTV - Requires admin or root permissions
///
/// SECURITY: Several RPCs (CreateUser, UpdateUserPassword) transmit passwords as
/// plaintext. Deployments MUST use TLS. UpdateUserPassword operations should be
/// logged for audit compliance.
@$pb.GrpcServiceName('synctv.admin.AdminService')
class AdminServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AdminServiceClient(super.channel, {super.options, super.interceptors});

  /// =========================
  /// System Settings Management
  /// =========================
  $grpc.ResponseFuture<$0.GetSettingsResponse> getSettings(
    $0.GetSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetSettingsGroupResponse> getSettingsGroup(
    $0.GetSettingsGroupRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSettingsGroup, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateSettingsResponse> updateSettings(
    $0.UpdateSettingsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.SendTestEmailResponse> sendTestEmail(
    $0.SendTestEmailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendTestEmail, request, options: options);
  }

  /// =========================
  /// User Management
  /// =========================
  $grpc.ResponseFuture<$0.CreateUserResponse> createUser(
    $0.CreateUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteUserResponse> deleteUser(
    $0.DeleteUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListUsersResponse> listUsers(
    $0.ListUsersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listUsers, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserResponse> getUser(
    $0.GetUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUser, request, options: options);
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

  $grpc.ResponseFuture<$0.UpdateUserPasswordResponse> updateUserPassword(
    $0.UpdateUserPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateUserPassword, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateUserUsernameResponse> updateUserUsername(
    $0.UpdateUserUsernameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateUserUsername, request, options: options);
  }

  $grpc.ResponseFuture<$0.UpdateUserRoleResponse> updateUserRole(
    $0.UpdateUserRoleRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateUserRole, request, options: options);
  }

  $grpc.ResponseFuture<$0.BanUserResponse> banUser(
    $0.BanUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$banUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.UnbanUserResponse> unbanUser(
    $0.UnbanUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unbanUser, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserRoomsResponse> getUserRooms(
    $0.GetUserRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserRooms, request, options: options);
  }

  /// =========================
  /// Batch Operations
  /// =========================
  $grpc.ResponseFuture<$0.BatchBanUsersResponse> batchBanUsers(
    $0.BatchBanUsersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$batchBanUsers, request, options: options);
  }

  $grpc.ResponseFuture<$0.BatchDeleteUsersResponse> batchDeleteUsers(
    $0.BatchDeleteUsersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$batchDeleteUsers, request, options: options);
  }

  $grpc.ResponseFuture<$0.BatchBanRoomsResponse> batchBanRooms(
    $0.BatchBanRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$batchBanRooms, request, options: options);
  }

  $grpc.ResponseFuture<$0.BatchDeleteRoomsResponse> batchDeleteRooms(
    $0.BatchDeleteRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$batchDeleteRooms, request, options: options);
  }

  /// =========================
  /// Room Management
  /// =========================
  $grpc.ResponseFuture<$0.ListRoomsResponse> listRooms(
    $0.ListRoomsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRooms, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRoomResponse> getRoom(
    $0.GetRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoom, request, options: options);
  }

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

  $grpc.ResponseFuture<$0.UpdateRoomPasswordResponse> updateRoomPassword(
    $0.UpdateRoomPasswordRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateRoomPassword, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteRoomResponse> deleteRoom(
    $0.DeleteRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.BanRoomResponse> banRoom(
    $0.BanRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$banRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.UnbanRoomResponse> unbanRoom(
    $0.UnbanRoomRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unbanRoom, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRoomMembersResponse> getRoomMembers(
    $0.GetRoomMembersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRoomMembers, request, options: options);
  }

  $grpc.ResponseFuture<$0.AddMemberResponse> addMember(
    $0.AddMemberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addMember, request, options: options);
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

  /// =========================
  /// Admin Management (Root Only)
  /// =========================
  $grpc.ResponseFuture<$0.AddAdminResponse> addAdmin(
    $0.AddAdminRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$addAdmin, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveAdminResponse> removeAdmin(
    $0.RemoveAdminRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeAdmin, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListAdminsResponse> listAdmins(
    $0.ListAdminsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listAdmins, request, options: options);
  }

  /// =========================
  /// System Statistics
  /// =========================
  $grpc.ResponseFuture<$0.GetSystemStatsResponse> getSystemStats(
    $0.GetSystemStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSystemStats, request, options: options);
  }

  /// =========================
  /// Livestream Management
  /// =========================
  $grpc.ResponseFuture<$0.ListActiveStreamsResponse> listActiveStreams(
    $0.ListActiveStreamsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listActiveStreams, request, options: options);
  }

  $grpc.ResponseFuture<$0.KickStreamResponse> kickStream(
    $0.KickStreamRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$kickStream, request, options: options);
  }

  /// =========================
  /// Review Workflow
  /// =========================
  $grpc.ResponseFuture<$0.ListUserRegistrationReviewsResponse>
      listUserRegistrationReviews(
    $0.ListUserRegistrationReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listUserRegistrationReviews, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ApproveUserRegistrationReviewResponse>
      approveUserRegistrationReview(
    $0.ApproveUserRegistrationReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approveUserRegistrationReview, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.RejectUserRegistrationReviewResponse>
      rejectUserRegistrationReview(
    $0.RejectUserRegistrationReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rejectUserRegistrationReview, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ListRoomCreationReviewsResponse>
      listRoomCreationReviews(
    $0.ListRoomCreationReviewsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listRoomCreationReviews, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.ApproveRoomCreationReviewResponse>
      approveRoomCreationReview(
    $0.ApproveRoomCreationReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$approveRoomCreationReview, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.RejectRoomCreationReviewResponse>
      rejectRoomCreationReview(
    $0.RejectRoomCreationReviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rejectRoomCreationReview, request,
        options: options);
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

  /// =========================
  /// Moderation Bans
  /// =========================
  $grpc.ResponseFuture<$0.ListBanRecordsResponse> listBanRecords(
    $0.ListBanRecordsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listBanRecords, request, options: options);
  }

  // method descriptors

  static final _$getSettings =
      $grpc.ClientMethod<$0.GetSettingsRequest, $0.GetSettingsResponse>(
          '/synctv.admin.AdminService/GetSettings',
          ($0.GetSettingsRequest value) => value.writeToBuffer(),
          $0.GetSettingsResponse.fromBuffer);
  static final _$getSettingsGroup = $grpc.ClientMethod<
          $0.GetSettingsGroupRequest, $0.GetSettingsGroupResponse>(
      '/synctv.admin.AdminService/GetSettingsGroup',
      ($0.GetSettingsGroupRequest value) => value.writeToBuffer(),
      $0.GetSettingsGroupResponse.fromBuffer);
  static final _$updateSettings =
      $grpc.ClientMethod<$0.UpdateSettingsRequest, $0.UpdateSettingsResponse>(
          '/synctv.admin.AdminService/UpdateSettings',
          ($0.UpdateSettingsRequest value) => value.writeToBuffer(),
          $0.UpdateSettingsResponse.fromBuffer);
  static final _$sendTestEmail =
      $grpc.ClientMethod<$0.SendTestEmailRequest, $0.SendTestEmailResponse>(
          '/synctv.admin.AdminService/SendTestEmail',
          ($0.SendTestEmailRequest value) => value.writeToBuffer(),
          $0.SendTestEmailResponse.fromBuffer);
  static final _$createUser =
      $grpc.ClientMethod<$0.CreateUserRequest, $0.CreateUserResponse>(
          '/synctv.admin.AdminService/CreateUser',
          ($0.CreateUserRequest value) => value.writeToBuffer(),
          $0.CreateUserResponse.fromBuffer);
  static final _$deleteUser =
      $grpc.ClientMethod<$0.DeleteUserRequest, $0.DeleteUserResponse>(
          '/synctv.admin.AdminService/DeleteUser',
          ($0.DeleteUserRequest value) => value.writeToBuffer(),
          $0.DeleteUserResponse.fromBuffer);
  static final _$listUsers =
      $grpc.ClientMethod<$0.ListUsersRequest, $0.ListUsersResponse>(
          '/synctv.admin.AdminService/ListUsers',
          ($0.ListUsersRequest value) => value.writeToBuffer(),
          $0.ListUsersResponse.fromBuffer);
  static final _$getUser =
      $grpc.ClientMethod<$0.GetUserRequest, $0.GetUserResponse>(
          '/synctv.admin.AdminService/GetUser',
          ($0.GetUserRequest value) => value.writeToBuffer(),
          $0.GetUserResponse.fromBuffer);
  static final _$getUserPreferences = $grpc.ClientMethod<
          $0.GetUserPreferencesRequest, $0.GetUserPreferencesResponse>(
      '/synctv.admin.AdminService/GetUserPreferences',
      ($0.GetUserPreferencesRequest value) => value.writeToBuffer(),
      $0.GetUserPreferencesResponse.fromBuffer);
  static final _$updateUserPreferences = $grpc.ClientMethod<
          $0.UpdateUserPreferencesRequest, $0.UpdateUserPreferencesResponse>(
      '/synctv.admin.AdminService/UpdateUserPreferences',
      ($0.UpdateUserPreferencesRequest value) => value.writeToBuffer(),
      $0.UpdateUserPreferencesResponse.fromBuffer);
  static final _$updateUserPassword = $grpc.ClientMethod<
          $0.UpdateUserPasswordRequest, $0.UpdateUserPasswordResponse>(
      '/synctv.admin.AdminService/UpdateUserPassword',
      ($0.UpdateUserPasswordRequest value) => value.writeToBuffer(),
      $0.UpdateUserPasswordResponse.fromBuffer);
  static final _$updateUserUsername = $grpc.ClientMethod<
          $0.UpdateUserUsernameRequest, $0.UpdateUserUsernameResponse>(
      '/synctv.admin.AdminService/UpdateUserUsername',
      ($0.UpdateUserUsernameRequest value) => value.writeToBuffer(),
      $0.UpdateUserUsernameResponse.fromBuffer);
  static final _$updateUserRole =
      $grpc.ClientMethod<$0.UpdateUserRoleRequest, $0.UpdateUserRoleResponse>(
          '/synctv.admin.AdminService/UpdateUserRole',
          ($0.UpdateUserRoleRequest value) => value.writeToBuffer(),
          $0.UpdateUserRoleResponse.fromBuffer);
  static final _$banUser =
      $grpc.ClientMethod<$0.BanUserRequest, $0.BanUserResponse>(
          '/synctv.admin.AdminService/BanUser',
          ($0.BanUserRequest value) => value.writeToBuffer(),
          $0.BanUserResponse.fromBuffer);
  static final _$unbanUser =
      $grpc.ClientMethod<$0.UnbanUserRequest, $0.UnbanUserResponse>(
          '/synctv.admin.AdminService/UnbanUser',
          ($0.UnbanUserRequest value) => value.writeToBuffer(),
          $0.UnbanUserResponse.fromBuffer);
  static final _$getUserRooms =
      $grpc.ClientMethod<$0.GetUserRoomsRequest, $0.GetUserRoomsResponse>(
          '/synctv.admin.AdminService/GetUserRooms',
          ($0.GetUserRoomsRequest value) => value.writeToBuffer(),
          $0.GetUserRoomsResponse.fromBuffer);
  static final _$batchBanUsers =
      $grpc.ClientMethod<$0.BatchBanUsersRequest, $0.BatchBanUsersResponse>(
          '/synctv.admin.AdminService/BatchBanUsers',
          ($0.BatchBanUsersRequest value) => value.writeToBuffer(),
          $0.BatchBanUsersResponse.fromBuffer);
  static final _$batchDeleteUsers = $grpc.ClientMethod<
          $0.BatchDeleteUsersRequest, $0.BatchDeleteUsersResponse>(
      '/synctv.admin.AdminService/BatchDeleteUsers',
      ($0.BatchDeleteUsersRequest value) => value.writeToBuffer(),
      $0.BatchDeleteUsersResponse.fromBuffer);
  static final _$batchBanRooms =
      $grpc.ClientMethod<$0.BatchBanRoomsRequest, $0.BatchBanRoomsResponse>(
          '/synctv.admin.AdminService/BatchBanRooms',
          ($0.BatchBanRoomsRequest value) => value.writeToBuffer(),
          $0.BatchBanRoomsResponse.fromBuffer);
  static final _$batchDeleteRooms = $grpc.ClientMethod<
          $0.BatchDeleteRoomsRequest, $0.BatchDeleteRoomsResponse>(
      '/synctv.admin.AdminService/BatchDeleteRooms',
      ($0.BatchDeleteRoomsRequest value) => value.writeToBuffer(),
      $0.BatchDeleteRoomsResponse.fromBuffer);
  static final _$listRooms =
      $grpc.ClientMethod<$0.ListRoomsRequest, $0.ListRoomsResponse>(
          '/synctv.admin.AdminService/ListRooms',
          ($0.ListRoomsRequest value) => value.writeToBuffer(),
          $0.ListRoomsResponse.fromBuffer);
  static final _$getRoom =
      $grpc.ClientMethod<$0.GetRoomRequest, $0.GetRoomResponse>(
          '/synctv.admin.AdminService/GetRoom',
          ($0.GetRoomRequest value) => value.writeToBuffer(),
          $0.GetRoomResponse.fromBuffer);
  static final _$getRoomSettings =
      $grpc.ClientMethod<$0.GetRoomSettingsRequest, $0.GetRoomSettingsResponse>(
          '/synctv.admin.AdminService/GetRoomSettings',
          ($0.GetRoomSettingsRequest value) => value.writeToBuffer(),
          $0.GetRoomSettingsResponse.fromBuffer);
  static final _$updateRoomSettings = $grpc.ClientMethod<
          $0.UpdateRoomSettingsRequest, $0.UpdateRoomSettingsResponse>(
      '/synctv.admin.AdminService/UpdateRoomSettings',
      ($0.UpdateRoomSettingsRequest value) => value.writeToBuffer(),
      $0.UpdateRoomSettingsResponse.fromBuffer);
  static final _$resetRoomSettings = $grpc.ClientMethod<
          $0.ResetRoomSettingsRequest, $0.ResetRoomSettingsResponse>(
      '/synctv.admin.AdminService/ResetRoomSettings',
      ($0.ResetRoomSettingsRequest value) => value.writeToBuffer(),
      $0.ResetRoomSettingsResponse.fromBuffer);
  static final _$updateRoomPassword = $grpc.ClientMethod<
          $0.UpdateRoomPasswordRequest, $0.UpdateRoomPasswordResponse>(
      '/synctv.admin.AdminService/UpdateRoomPassword',
      ($0.UpdateRoomPasswordRequest value) => value.writeToBuffer(),
      $0.UpdateRoomPasswordResponse.fromBuffer);
  static final _$deleteRoom =
      $grpc.ClientMethod<$0.DeleteRoomRequest, $0.DeleteRoomResponse>(
          '/synctv.admin.AdminService/DeleteRoom',
          ($0.DeleteRoomRequest value) => value.writeToBuffer(),
          $0.DeleteRoomResponse.fromBuffer);
  static final _$banRoom =
      $grpc.ClientMethod<$0.BanRoomRequest, $0.BanRoomResponse>(
          '/synctv.admin.AdminService/BanRoom',
          ($0.BanRoomRequest value) => value.writeToBuffer(),
          $0.BanRoomResponse.fromBuffer);
  static final _$unbanRoom =
      $grpc.ClientMethod<$0.UnbanRoomRequest, $0.UnbanRoomResponse>(
          '/synctv.admin.AdminService/UnbanRoom',
          ($0.UnbanRoomRequest value) => value.writeToBuffer(),
          $0.UnbanRoomResponse.fromBuffer);
  static final _$getRoomMembers =
      $grpc.ClientMethod<$0.GetRoomMembersRequest, $0.GetRoomMembersResponse>(
          '/synctv.admin.AdminService/GetRoomMembers',
          ($0.GetRoomMembersRequest value) => value.writeToBuffer(),
          $0.GetRoomMembersResponse.fromBuffer);
  static final _$addMember =
      $grpc.ClientMethod<$0.AddMemberRequest, $0.AddMemberResponse>(
          '/synctv.admin.AdminService/AddMember',
          ($0.AddMemberRequest value) => value.writeToBuffer(),
          $0.AddMemberResponse.fromBuffer);
  static final _$updateMemberPermissions = $grpc.ClientMethod<
          $0.UpdateMemberPermissionsRequest,
          $0.UpdateMemberPermissionsResponse>(
      '/synctv.admin.AdminService/UpdateMemberPermissions',
      ($0.UpdateMemberPermissionsRequest value) => value.writeToBuffer(),
      $0.UpdateMemberPermissionsResponse.fromBuffer);
  static final _$kickMember =
      $grpc.ClientMethod<$0.KickMemberRequest, $0.KickMemberResponse>(
          '/synctv.admin.AdminService/KickMember',
          ($0.KickMemberRequest value) => value.writeToBuffer(),
          $0.KickMemberResponse.fromBuffer);
  static final _$addAdmin =
      $grpc.ClientMethod<$0.AddAdminRequest, $0.AddAdminResponse>(
          '/synctv.admin.AdminService/AddAdmin',
          ($0.AddAdminRequest value) => value.writeToBuffer(),
          $0.AddAdminResponse.fromBuffer);
  static final _$removeAdmin =
      $grpc.ClientMethod<$0.RemoveAdminRequest, $0.RemoveAdminResponse>(
          '/synctv.admin.AdminService/RemoveAdmin',
          ($0.RemoveAdminRequest value) => value.writeToBuffer(),
          $0.RemoveAdminResponse.fromBuffer);
  static final _$listAdmins =
      $grpc.ClientMethod<$0.ListAdminsRequest, $0.ListAdminsResponse>(
          '/synctv.admin.AdminService/ListAdmins',
          ($0.ListAdminsRequest value) => value.writeToBuffer(),
          $0.ListAdminsResponse.fromBuffer);
  static final _$getSystemStats =
      $grpc.ClientMethod<$0.GetSystemStatsRequest, $0.GetSystemStatsResponse>(
          '/synctv.admin.AdminService/GetSystemStats',
          ($0.GetSystemStatsRequest value) => value.writeToBuffer(),
          $0.GetSystemStatsResponse.fromBuffer);
  static final _$listActiveStreams = $grpc.ClientMethod<
          $0.ListActiveStreamsRequest, $0.ListActiveStreamsResponse>(
      '/synctv.admin.AdminService/ListActiveStreams',
      ($0.ListActiveStreamsRequest value) => value.writeToBuffer(),
      $0.ListActiveStreamsResponse.fromBuffer);
  static final _$kickStream =
      $grpc.ClientMethod<$0.KickStreamRequest, $0.KickStreamResponse>(
          '/synctv.admin.AdminService/KickStream',
          ($0.KickStreamRequest value) => value.writeToBuffer(),
          $0.KickStreamResponse.fromBuffer);
  static final _$listUserRegistrationReviews = $grpc.ClientMethod<
          $0.ListUserRegistrationReviewsRequest,
          $0.ListUserRegistrationReviewsResponse>(
      '/synctv.admin.AdminService/ListUserRegistrationReviews',
      ($0.ListUserRegistrationReviewsRequest value) => value.writeToBuffer(),
      $0.ListUserRegistrationReviewsResponse.fromBuffer);
  static final _$approveUserRegistrationReview = $grpc.ClientMethod<
          $0.ApproveUserRegistrationReviewRequest,
          $0.ApproveUserRegistrationReviewResponse>(
      '/synctv.admin.AdminService/ApproveUserRegistrationReview',
      ($0.ApproveUserRegistrationReviewRequest value) => value.writeToBuffer(),
      $0.ApproveUserRegistrationReviewResponse.fromBuffer);
  static final _$rejectUserRegistrationReview = $grpc.ClientMethod<
          $0.RejectUserRegistrationReviewRequest,
          $0.RejectUserRegistrationReviewResponse>(
      '/synctv.admin.AdminService/RejectUserRegistrationReview',
      ($0.RejectUserRegistrationReviewRequest value) => value.writeToBuffer(),
      $0.RejectUserRegistrationReviewResponse.fromBuffer);
  static final _$listRoomCreationReviews = $grpc.ClientMethod<
          $0.ListRoomCreationReviewsRequest,
          $0.ListRoomCreationReviewsResponse>(
      '/synctv.admin.AdminService/ListRoomCreationReviews',
      ($0.ListRoomCreationReviewsRequest value) => value.writeToBuffer(),
      $0.ListRoomCreationReviewsResponse.fromBuffer);
  static final _$approveRoomCreationReview = $grpc.ClientMethod<
          $0.ApproveRoomCreationReviewRequest,
          $0.ApproveRoomCreationReviewResponse>(
      '/synctv.admin.AdminService/ApproveRoomCreationReview',
      ($0.ApproveRoomCreationReviewRequest value) => value.writeToBuffer(),
      $0.ApproveRoomCreationReviewResponse.fromBuffer);
  static final _$rejectRoomCreationReview = $grpc.ClientMethod<
          $0.RejectRoomCreationReviewRequest,
          $0.RejectRoomCreationReviewResponse>(
      '/synctv.admin.AdminService/RejectRoomCreationReview',
      ($0.RejectRoomCreationReviewRequest value) => value.writeToBuffer(),
      $0.RejectRoomCreationReviewResponse.fromBuffer);
  static final _$listRoomJoinReviews = $grpc.ClientMethod<
          $0.ListRoomJoinReviewsRequest, $0.ListRoomJoinReviewsResponse>(
      '/synctv.admin.AdminService/ListRoomJoinReviews',
      ($0.ListRoomJoinReviewsRequest value) => value.writeToBuffer(),
      $0.ListRoomJoinReviewsResponse.fromBuffer);
  static final _$approveRoomJoinReview = $grpc.ClientMethod<
          $0.ApproveRoomJoinReviewRequest, $0.ApproveRoomJoinReviewResponse>(
      '/synctv.admin.AdminService/ApproveRoomJoinReview',
      ($0.ApproveRoomJoinReviewRequest value) => value.writeToBuffer(),
      $0.ApproveRoomJoinReviewResponse.fromBuffer);
  static final _$rejectRoomJoinReview = $grpc.ClientMethod<
          $0.RejectRoomJoinReviewRequest, $0.RejectRoomJoinReviewResponse>(
      '/synctv.admin.AdminService/RejectRoomJoinReview',
      ($0.RejectRoomJoinReviewRequest value) => value.writeToBuffer(),
      $0.RejectRoomJoinReviewResponse.fromBuffer);
  static final _$listBanRecords =
      $grpc.ClientMethod<$0.ListBanRecordsRequest, $0.ListBanRecordsResponse>(
          '/synctv.admin.AdminService/ListBanRecords',
          ($0.ListBanRecordsRequest value) => value.writeToBuffer(),
          $0.ListBanRecordsResponse.fromBuffer);
}

@$pb.GrpcServiceName('synctv.admin.AdminService')
abstract class AdminServiceBase extends $grpc.Service {
  $core.String get $name => 'synctv.admin.AdminService';

  AdminServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetSettingsRequest, $0.GetSettingsResponse>(
            'GetSettings',
            getSettings_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSettingsRequest.fromBuffer(value),
            ($0.GetSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSettingsGroupRequest,
            $0.GetSettingsGroupResponse>(
        'GetSettingsGroup',
        getSettingsGroup_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSettingsGroupRequest.fromBuffer(value),
        ($0.GetSettingsGroupResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateSettingsRequest,
            $0.UpdateSettingsResponse>(
        'UpdateSettings',
        updateSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateSettingsRequest.fromBuffer(value),
        ($0.UpdateSettingsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.SendTestEmailRequest, $0.SendTestEmailResponse>(
            'SendTestEmail',
            sendTestEmail_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.SendTestEmailRequest.fromBuffer(value),
            ($0.SendTestEmailResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CreateUserRequest, $0.CreateUserResponse>(
        'CreateUser',
        createUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CreateUserRequest.fromBuffer(value),
        ($0.CreateUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteUserRequest, $0.DeleteUserResponse>(
        'DeleteUser',
        deleteUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteUserRequest.fromBuffer(value),
        ($0.DeleteUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListUsersRequest, $0.ListUsersResponse>(
        'ListUsers',
        listUsers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListUsersRequest.fromBuffer(value),
        ($0.ListUsersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserRequest, $0.GetUserResponse>(
        'GetUser',
        getUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetUserRequest.fromBuffer(value),
        ($0.GetUserResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.UpdateUserPasswordRequest,
            $0.UpdateUserPasswordResponse>(
        'UpdateUserPassword',
        updateUserPassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateUserPasswordRequest.fromBuffer(value),
        ($0.UpdateUserPasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateUserUsernameRequest,
            $0.UpdateUserUsernameResponse>(
        'UpdateUserUsername',
        updateUserUsername_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateUserUsernameRequest.fromBuffer(value),
        ($0.UpdateUserUsernameResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateUserRoleRequest,
            $0.UpdateUserRoleResponse>(
        'UpdateUserRole',
        updateUserRole_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateUserRoleRequest.fromBuffer(value),
        ($0.UpdateUserRoleResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BanUserRequest, $0.BanUserResponse>(
        'BanUser',
        banUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.BanUserRequest.fromBuffer(value),
        ($0.BanUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnbanUserRequest, $0.UnbanUserResponse>(
        'UnbanUser',
        unbanUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnbanUserRequest.fromBuffer(value),
        ($0.UnbanUserResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetUserRoomsRequest, $0.GetUserRoomsResponse>(
            'GetUserRooms',
            getUserRooms_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetUserRoomsRequest.fromBuffer(value),
            ($0.GetUserRoomsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.BatchBanUsersRequest, $0.BatchBanUsersResponse>(
            'BatchBanUsers',
            batchBanUsers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.BatchBanUsersRequest.fromBuffer(value),
            ($0.BatchBanUsersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BatchDeleteUsersRequest,
            $0.BatchDeleteUsersResponse>(
        'BatchDeleteUsers',
        batchDeleteUsers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BatchDeleteUsersRequest.fromBuffer(value),
        ($0.BatchDeleteUsersResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.BatchBanRoomsRequest, $0.BatchBanRoomsResponse>(
            'BatchBanRooms',
            batchBanRooms_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.BatchBanRoomsRequest.fromBuffer(value),
            ($0.BatchBanRoomsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BatchDeleteRoomsRequest,
            $0.BatchDeleteRoomsResponse>(
        'BatchDeleteRooms',
        batchDeleteRooms_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.BatchDeleteRoomsRequest.fromBuffer(value),
        ($0.BatchDeleteRoomsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRoomsRequest, $0.ListRoomsResponse>(
        'ListRooms',
        listRooms_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListRoomsRequest.fromBuffer(value),
        ($0.ListRoomsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRoomRequest, $0.GetRoomResponse>(
        'GetRoom',
        getRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetRoomRequest.fromBuffer(value),
        ($0.GetRoomResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.UpdateRoomPasswordRequest,
            $0.UpdateRoomPasswordResponse>(
        'UpdateRoomPassword',
        updateRoomPassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateRoomPasswordRequest.fromBuffer(value),
        ($0.UpdateRoomPasswordResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteRoomRequest, $0.DeleteRoomResponse>(
        'DeleteRoom',
        deleteRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteRoomRequest.fromBuffer(value),
        ($0.DeleteRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BanRoomRequest, $0.BanRoomResponse>(
        'BanRoom',
        banRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.BanRoomRequest.fromBuffer(value),
        ($0.BanRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnbanRoomRequest, $0.UnbanRoomResponse>(
        'UnbanRoom',
        unbanRoom_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnbanRoomRequest.fromBuffer(value),
        ($0.UnbanRoomResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRoomMembersRequest,
            $0.GetRoomMembersResponse>(
        'GetRoomMembers',
        getRoomMembers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRoomMembersRequest.fromBuffer(value),
        ($0.GetRoomMembersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AddMemberRequest, $0.AddMemberResponse>(
        'AddMember',
        addMember_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddMemberRequest.fromBuffer(value),
        ($0.AddMemberResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.AddAdminRequest, $0.AddAdminResponse>(
        'AddAdmin',
        addAdmin_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AddAdminRequest.fromBuffer(value),
        ($0.AddAdminResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RemoveAdminRequest, $0.RemoveAdminResponse>(
            'RemoveAdmin',
            removeAdmin_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RemoveAdminRequest.fromBuffer(value),
            ($0.RemoveAdminResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListAdminsRequest, $0.ListAdminsResponse>(
        'ListAdmins',
        listAdmins_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListAdminsRequest.fromBuffer(value),
        ($0.ListAdminsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetSystemStatsRequest,
            $0.GetSystemStatsResponse>(
        'GetSystemStats',
        getSystemStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetSystemStatsRequest.fromBuffer(value),
        ($0.GetSystemStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListActiveStreamsRequest,
            $0.ListActiveStreamsResponse>(
        'ListActiveStreams',
        listActiveStreams_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListActiveStreamsRequest.fromBuffer(value),
        ($0.ListActiveStreamsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.KickStreamRequest, $0.KickStreamResponse>(
        'KickStream',
        kickStream_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.KickStreamRequest.fromBuffer(value),
        ($0.KickStreamResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListUserRegistrationReviewsRequest,
            $0.ListUserRegistrationReviewsResponse>(
        'ListUserRegistrationReviews',
        listUserRegistrationReviews_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListUserRegistrationReviewsRequest.fromBuffer(value),
        ($0.ListUserRegistrationReviewsResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApproveUserRegistrationReviewRequest,
            $0.ApproveUserRegistrationReviewResponse>(
        'ApproveUserRegistrationReview',
        approveUserRegistrationReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApproveUserRegistrationReviewRequest.fromBuffer(value),
        ($0.ApproveUserRegistrationReviewResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RejectUserRegistrationReviewRequest,
            $0.RejectUserRegistrationReviewResponse>(
        'RejectUserRegistrationReview',
        rejectUserRegistrationReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RejectUserRegistrationReviewRequest.fromBuffer(value),
        ($0.RejectUserRegistrationReviewResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListRoomCreationReviewsRequest,
            $0.ListRoomCreationReviewsResponse>(
        'ListRoomCreationReviews',
        listRoomCreationReviews_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListRoomCreationReviewsRequest.fromBuffer(value),
        ($0.ListRoomCreationReviewsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApproveRoomCreationReviewRequest,
            $0.ApproveRoomCreationReviewResponse>(
        'ApproveRoomCreationReview',
        approveRoomCreationReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApproveRoomCreationReviewRequest.fromBuffer(value),
        ($0.ApproveRoomCreationReviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RejectRoomCreationReviewRequest,
            $0.RejectRoomCreationReviewResponse>(
        'RejectRoomCreationReview',
        rejectRoomCreationReview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RejectRoomCreationReviewRequest.fromBuffer(value),
        ($0.RejectRoomCreationReviewResponse value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.ListBanRecordsRequest,
            $0.ListBanRecordsResponse>(
        'ListBanRecords',
        listBanRecords_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ListBanRecordsRequest.fromBuffer(value),
        ($0.ListBanRecordsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetSettingsResponse> getSettings_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetSettingsRequest> $request) async {
    return getSettings($call, await $request);
  }

  $async.Future<$0.GetSettingsResponse> getSettings(
      $grpc.ServiceCall call, $0.GetSettingsRequest request);

  $async.Future<$0.GetSettingsGroupResponse> getSettingsGroup_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSettingsGroupRequest> $request) async {
    return getSettingsGroup($call, await $request);
  }

  $async.Future<$0.GetSettingsGroupResponse> getSettingsGroup(
      $grpc.ServiceCall call, $0.GetSettingsGroupRequest request);

  $async.Future<$0.UpdateSettingsResponse> updateSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateSettingsRequest> $request) async {
    return updateSettings($call, await $request);
  }

  $async.Future<$0.UpdateSettingsResponse> updateSettings(
      $grpc.ServiceCall call, $0.UpdateSettingsRequest request);

  $async.Future<$0.SendTestEmailResponse> sendTestEmail_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendTestEmailRequest> $request) async {
    return sendTestEmail($call, await $request);
  }

  $async.Future<$0.SendTestEmailResponse> sendTestEmail(
      $grpc.ServiceCall call, $0.SendTestEmailRequest request);

  $async.Future<$0.CreateUserResponse> createUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateUserRequest> $request) async {
    return createUser($call, await $request);
  }

  $async.Future<$0.CreateUserResponse> createUser(
      $grpc.ServiceCall call, $0.CreateUserRequest request);

  $async.Future<$0.DeleteUserResponse> deleteUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteUserRequest> $request) async {
    return deleteUser($call, await $request);
  }

  $async.Future<$0.DeleteUserResponse> deleteUser(
      $grpc.ServiceCall call, $0.DeleteUserRequest request);

  $async.Future<$0.ListUsersResponse> listUsers_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListUsersRequest> $request) async {
    return listUsers($call, await $request);
  }

  $async.Future<$0.ListUsersResponse> listUsers(
      $grpc.ServiceCall call, $0.ListUsersRequest request);

  $async.Future<$0.GetUserResponse> getUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetUserRequest> $request) async {
    return getUser($call, await $request);
  }

  $async.Future<$0.GetUserResponse> getUser(
      $grpc.ServiceCall call, $0.GetUserRequest request);

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

  $async.Future<$0.UpdateUserPasswordResponse> updateUserPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateUserPasswordRequest> $request) async {
    return updateUserPassword($call, await $request);
  }

  $async.Future<$0.UpdateUserPasswordResponse> updateUserPassword(
      $grpc.ServiceCall call, $0.UpdateUserPasswordRequest request);

  $async.Future<$0.UpdateUserUsernameResponse> updateUserUsername_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateUserUsernameRequest> $request) async {
    return updateUserUsername($call, await $request);
  }

  $async.Future<$0.UpdateUserUsernameResponse> updateUserUsername(
      $grpc.ServiceCall call, $0.UpdateUserUsernameRequest request);

  $async.Future<$0.UpdateUserRoleResponse> updateUserRole_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateUserRoleRequest> $request) async {
    return updateUserRole($call, await $request);
  }

  $async.Future<$0.UpdateUserRoleResponse> updateUserRole(
      $grpc.ServiceCall call, $0.UpdateUserRoleRequest request);

  $async.Future<$0.BanUserResponse> banUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.BanUserRequest> $request) async {
    return banUser($call, await $request);
  }

  $async.Future<$0.BanUserResponse> banUser(
      $grpc.ServiceCall call, $0.BanUserRequest request);

  $async.Future<$0.UnbanUserResponse> unbanUser_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UnbanUserRequest> $request) async {
    return unbanUser($call, await $request);
  }

  $async.Future<$0.UnbanUserResponse> unbanUser(
      $grpc.ServiceCall call, $0.UnbanUserRequest request);

  $async.Future<$0.GetUserRoomsResponse> getUserRooms_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserRoomsRequest> $request) async {
    return getUserRooms($call, await $request);
  }

  $async.Future<$0.GetUserRoomsResponse> getUserRooms(
      $grpc.ServiceCall call, $0.GetUserRoomsRequest request);

  $async.Future<$0.BatchBanUsersResponse> batchBanUsers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BatchBanUsersRequest> $request) async {
    return batchBanUsers($call, await $request);
  }

  $async.Future<$0.BatchBanUsersResponse> batchBanUsers(
      $grpc.ServiceCall call, $0.BatchBanUsersRequest request);

  $async.Future<$0.BatchDeleteUsersResponse> batchDeleteUsers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BatchDeleteUsersRequest> $request) async {
    return batchDeleteUsers($call, await $request);
  }

  $async.Future<$0.BatchDeleteUsersResponse> batchDeleteUsers(
      $grpc.ServiceCall call, $0.BatchDeleteUsersRequest request);

  $async.Future<$0.BatchBanRoomsResponse> batchBanRooms_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BatchBanRoomsRequest> $request) async {
    return batchBanRooms($call, await $request);
  }

  $async.Future<$0.BatchBanRoomsResponse> batchBanRooms(
      $grpc.ServiceCall call, $0.BatchBanRoomsRequest request);

  $async.Future<$0.BatchDeleteRoomsResponse> batchDeleteRooms_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.BatchDeleteRoomsRequest> $request) async {
    return batchDeleteRooms($call, await $request);
  }

  $async.Future<$0.BatchDeleteRoomsResponse> batchDeleteRooms(
      $grpc.ServiceCall call, $0.BatchDeleteRoomsRequest request);

  $async.Future<$0.ListRoomsResponse> listRooms_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListRoomsRequest> $request) async {
    return listRooms($call, await $request);
  }

  $async.Future<$0.ListRoomsResponse> listRooms(
      $grpc.ServiceCall call, $0.ListRoomsRequest request);

  $async.Future<$0.GetRoomResponse> getRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetRoomRequest> $request) async {
    return getRoom($call, await $request);
  }

  $async.Future<$0.GetRoomResponse> getRoom(
      $grpc.ServiceCall call, $0.GetRoomRequest request);

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

  $async.Future<$0.UpdateRoomPasswordResponse> updateRoomPassword_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.UpdateRoomPasswordRequest> $request) async {
    return updateRoomPassword($call, await $request);
  }

  $async.Future<$0.UpdateRoomPasswordResponse> updateRoomPassword(
      $grpc.ServiceCall call, $0.UpdateRoomPasswordRequest request);

  $async.Future<$0.DeleteRoomResponse> deleteRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteRoomRequest> $request) async {
    return deleteRoom($call, await $request);
  }

  $async.Future<$0.DeleteRoomResponse> deleteRoom(
      $grpc.ServiceCall call, $0.DeleteRoomRequest request);

  $async.Future<$0.BanRoomResponse> banRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.BanRoomRequest> $request) async {
    return banRoom($call, await $request);
  }

  $async.Future<$0.BanRoomResponse> banRoom(
      $grpc.ServiceCall call, $0.BanRoomRequest request);

  $async.Future<$0.UnbanRoomResponse> unbanRoom_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UnbanRoomRequest> $request) async {
    return unbanRoom($call, await $request);
  }

  $async.Future<$0.UnbanRoomResponse> unbanRoom(
      $grpc.ServiceCall call, $0.UnbanRoomRequest request);

  $async.Future<$0.GetRoomMembersResponse> getRoomMembers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRoomMembersRequest> $request) async {
    return getRoomMembers($call, await $request);
  }

  $async.Future<$0.GetRoomMembersResponse> getRoomMembers(
      $grpc.ServiceCall call, $0.GetRoomMembersRequest request);

  $async.Future<$0.AddMemberResponse> addMember_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddMemberRequest> $request) async {
    return addMember($call, await $request);
  }

  $async.Future<$0.AddMemberResponse> addMember(
      $grpc.ServiceCall call, $0.AddMemberRequest request);

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

  $async.Future<$0.AddAdminResponse> addAdmin_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AddAdminRequest> $request) async {
    return addAdmin($call, await $request);
  }

  $async.Future<$0.AddAdminResponse> addAdmin(
      $grpc.ServiceCall call, $0.AddAdminRequest request);

  $async.Future<$0.RemoveAdminResponse> removeAdmin_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveAdminRequest> $request) async {
    return removeAdmin($call, await $request);
  }

  $async.Future<$0.RemoveAdminResponse> removeAdmin(
      $grpc.ServiceCall call, $0.RemoveAdminRequest request);

  $async.Future<$0.ListAdminsResponse> listAdmins_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListAdminsRequest> $request) async {
    return listAdmins($call, await $request);
  }

  $async.Future<$0.ListAdminsResponse> listAdmins(
      $grpc.ServiceCall call, $0.ListAdminsRequest request);

  $async.Future<$0.GetSystemStatsResponse> getSystemStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSystemStatsRequest> $request) async {
    return getSystemStats($call, await $request);
  }

  $async.Future<$0.GetSystemStatsResponse> getSystemStats(
      $grpc.ServiceCall call, $0.GetSystemStatsRequest request);

  $async.Future<$0.ListActiveStreamsResponse> listActiveStreams_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListActiveStreamsRequest> $request) async {
    return listActiveStreams($call, await $request);
  }

  $async.Future<$0.ListActiveStreamsResponse> listActiveStreams(
      $grpc.ServiceCall call, $0.ListActiveStreamsRequest request);

  $async.Future<$0.KickStreamResponse> kickStream_Pre($grpc.ServiceCall $call,
      $async.Future<$0.KickStreamRequest> $request) async {
    return kickStream($call, await $request);
  }

  $async.Future<$0.KickStreamResponse> kickStream(
      $grpc.ServiceCall call, $0.KickStreamRequest request);

  $async.Future<$0.ListUserRegistrationReviewsResponse>
      listUserRegistrationReviews_Pre($grpc.ServiceCall $call,
          $async.Future<$0.ListUserRegistrationReviewsRequest> $request) async {
    return listUserRegistrationReviews($call, await $request);
  }

  $async.Future<$0.ListUserRegistrationReviewsResponse>
      listUserRegistrationReviews($grpc.ServiceCall call,
          $0.ListUserRegistrationReviewsRequest request);

  $async.Future<$0.ApproveUserRegistrationReviewResponse>
      approveUserRegistrationReview_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.ApproveUserRegistrationReviewRequest>
              $request) async {
    return approveUserRegistrationReview($call, await $request);
  }

  $async.Future<$0.ApproveUserRegistrationReviewResponse>
      approveUserRegistrationReview($grpc.ServiceCall call,
          $0.ApproveUserRegistrationReviewRequest request);

  $async.Future<$0.RejectUserRegistrationReviewResponse>
      rejectUserRegistrationReview_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.RejectUserRegistrationReviewRequest>
              $request) async {
    return rejectUserRegistrationReview($call, await $request);
  }

  $async.Future<$0.RejectUserRegistrationReviewResponse>
      rejectUserRegistrationReview($grpc.ServiceCall call,
          $0.RejectUserRegistrationReviewRequest request);

  $async.Future<$0.ListRoomCreationReviewsResponse> listRoomCreationReviews_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListRoomCreationReviewsRequest> $request) async {
    return listRoomCreationReviews($call, await $request);
  }

  $async.Future<$0.ListRoomCreationReviewsResponse> listRoomCreationReviews(
      $grpc.ServiceCall call, $0.ListRoomCreationReviewsRequest request);

  $async.Future<$0.ApproveRoomCreationReviewResponse>
      approveRoomCreationReview_Pre($grpc.ServiceCall $call,
          $async.Future<$0.ApproveRoomCreationReviewRequest> $request) async {
    return approveRoomCreationReview($call, await $request);
  }

  $async.Future<$0.ApproveRoomCreationReviewResponse> approveRoomCreationReview(
      $grpc.ServiceCall call, $0.ApproveRoomCreationReviewRequest request);

  $async.Future<$0.RejectRoomCreationReviewResponse>
      rejectRoomCreationReview_Pre($grpc.ServiceCall $call,
          $async.Future<$0.RejectRoomCreationReviewRequest> $request) async {
    return rejectRoomCreationReview($call, await $request);
  }

  $async.Future<$0.RejectRoomCreationReviewResponse> rejectRoomCreationReview(
      $grpc.ServiceCall call, $0.RejectRoomCreationReviewRequest request);

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

  $async.Future<$0.ListBanRecordsResponse> listBanRecords_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListBanRecordsRequest> $request) async {
    return listBanRecords($call, await $request);
  }

  $async.Future<$0.ListBanRecordsResponse> listBanRecords(
      $grpc.ServiceCall call, $0.ListBanRecordsRequest request);
}
