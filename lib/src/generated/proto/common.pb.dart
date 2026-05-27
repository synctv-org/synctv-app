// This is a generated file - do not edit.
//
// Generated from proto/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

/// Room member information (shared between admin and client APIs)
class RoomMember extends $pb.GeneratedMessage {
  factory RoomMember({
    $core.String? roomId,
    $core.String? userId,
    $core.String? username,
    RoomMemberRole? role,
    $fixnum.Int64? permissions,
    $fixnum.Int64? addedPermissions,
    $fixnum.Int64? removedPermissions,
    $fixnum.Int64? adminAddedPermissions,
    $fixnum.Int64? adminRemovedPermissions,
    $fixnum.Int64? joinedAt,
    $core.bool? isOnline,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (role != null) result.role = role;
    if (permissions != null) result.permissions = permissions;
    if (addedPermissions != null) result.addedPermissions = addedPermissions;
    if (removedPermissions != null)
      result.removedPermissions = removedPermissions;
    if (adminAddedPermissions != null)
      result.adminAddedPermissions = adminAddedPermissions;
    if (adminRemovedPermissions != null)
      result.adminRemovedPermissions = adminRemovedPermissions;
    if (joinedAt != null) result.joinedAt = joinedAt;
    if (isOnline != null) result.isOnline = isOnline;
    return result;
  }

  RoomMember._();

  factory RoomMember.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomMember.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomMember',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'username')
    ..aE<RoomMemberRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: RoomMemberRole.values)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'addedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'removedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'adminAddedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(9, _omitFieldNames ? '' : 'adminRemovedPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(10, _omitFieldNames ? '' : 'joinedAt')
    ..aOB(11, _omitFieldNames ? '' : 'isOnline')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMember copyWith(void Function(RoomMember) updates) =>
      super.copyWith((message) => updates(message as RoomMember)) as RoomMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMember create() => RoomMember._();
  @$core.override
  RoomMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomMember getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomMember>(create);
  static RoomMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  RoomMemberRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role(RoomMemberRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  /// Effective permissions (calculated from role + added/removed)
  @$pb.TagNumber(5)
  $fixnum.Int64 get permissions => $_getI64(4);
  @$pb.TagNumber(5)
  set permissions($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPermissions() => $_has(4);
  @$pb.TagNumber(5)
  void clearPermissions() => $_clearField(5);

  /// Allow/Deny permission pattern fields
  /// For member role: uses added_permissions/removed_permissions
  /// For admin role: uses admin_added_permissions/admin_removed_permissions
  @$pb.TagNumber(6)
  $fixnum.Int64 get addedPermissions => $_getI64(5);
  @$pb.TagNumber(6)
  set addedPermissions($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAddedPermissions() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddedPermissions() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get removedPermissions => $_getI64(6);
  @$pb.TagNumber(7)
  set removedPermissions($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRemovedPermissions() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemovedPermissions() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get adminAddedPermissions => $_getI64(7);
  @$pb.TagNumber(8)
  set adminAddedPermissions($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAdminAddedPermissions() => $_has(7);
  @$pb.TagNumber(8)
  void clearAdminAddedPermissions() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get adminRemovedPermissions => $_getI64(8);
  @$pb.TagNumber(9)
  set adminRemovedPermissions($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAdminRemovedPermissions() => $_has(8);
  @$pb.TagNumber(9)
  void clearAdminRemovedPermissions() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get joinedAt => $_getI64(9);
  @$pb.TagNumber(10)
  set joinedAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasJoinedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearJoinedAt() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isOnline => $_getBF(10);
  @$pb.TagNumber(11)
  set isOnline($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsOnline() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsOnline() => $_clearField(11);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
