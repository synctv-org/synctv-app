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
    $core.int? connectionCount,
    $core.String? remarkName,
    $core.String? displayTag,
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
    if (connectionCount != null) result.connectionCount = connectionCount;
    if (remarkName != null) result.remarkName = remarkName;
    if (displayTag != null) result.displayTag = displayTag;
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
    ..aI(12, _omitFieldNames ? '' : 'connectionCount')
    ..aOS(13, _omitFieldNames ? '' : 'remarkName')
    ..aOS(14, _omitFieldNames ? '' : 'displayTag')
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

  @$pb.TagNumber(12)
  $core.int get connectionCount => $_getIZ(11);
  @$pb.TagNumber(12)
  set connectionCount($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasConnectionCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearConnectionCount() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get remarkName => $_getSZ(12);
  @$pb.TagNumber(13)
  set remarkName($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRemarkName() => $_has(12);
  @$pb.TagNumber(13)
  void clearRemarkName() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get displayTag => $_getSZ(13);
  @$pb.TagNumber(14)
  set displayTag($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDisplayTag() => $_has(13);
  @$pb.TagNumber(14)
  void clearDisplayTag() => $_clearField(14);
}

class NodeConnectionCount extends $pb.GeneratedMessage {
  factory NodeConnectionCount({
    $core.String? nodeId,
    $core.int? connectionCount,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (connectionCount != null) result.connectionCount = connectionCount;
    return result;
  }

  NodeConnectionCount._();

  factory NodeConnectionCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NodeConnectionCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodeConnectionCount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aI(2, _omitFieldNames ? '' : 'connectionCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodeConnectionCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodeConnectionCount copyWith(void Function(NodeConnectionCount) updates) =>
      super.copyWith((message) => updates(message as NodeConnectionCount))
          as NodeConnectionCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NodeConnectionCount create() => NodeConnectionCount._();
  @$core.override
  NodeConnectionCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NodeConnectionCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NodeConnectionCount>(create);
  static NodeConnectionCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get connectionCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set connectionCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectionCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionCount() => $_clearField(2);
}

class RoomPresenceStats extends $pb.GeneratedMessage {
  factory RoomPresenceStats({
    $core.int? onlineMemberCount,
    $core.int? onlineGuestCount,
    $core.int? connectionCount,
    $core.Iterable<NodeConnectionCount>? nodeConnectionCounts,
    $fixnum.Int64? sampledAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (onlineMemberCount != null) result.onlineMemberCount = onlineMemberCount;
    if (onlineGuestCount != null) result.onlineGuestCount = onlineGuestCount;
    if (connectionCount != null) result.connectionCount = connectionCount;
    if (nodeConnectionCounts != null)
      result.nodeConnectionCounts.addAll(nodeConnectionCounts);
    if (sampledAt != null) result.sampledAt = sampledAt;
    if (version != null) result.version = version;
    return result;
  }

  RoomPresenceStats._();

  factory RoomPresenceStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomPresenceStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomPresenceStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.common'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'onlineMemberCount')
    ..aI(2, _omitFieldNames ? '' : 'onlineGuestCount')
    ..aI(3, _omitFieldNames ? '' : 'connectionCount')
    ..pPM<NodeConnectionCount>(4, _omitFieldNames ? '' : 'nodeConnectionCounts',
        subBuilder: NodeConnectionCount.create)
    ..aInt64(5, _omitFieldNames ? '' : 'sampledAt')
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'version', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomPresenceStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomPresenceStats copyWith(void Function(RoomPresenceStats) updates) =>
      super.copyWith((message) => updates(message as RoomPresenceStats))
          as RoomPresenceStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomPresenceStats create() => RoomPresenceStats._();
  @$core.override
  RoomPresenceStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomPresenceStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomPresenceStats>(create);
  static RoomPresenceStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get onlineMemberCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set onlineMemberCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOnlineMemberCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlineMemberCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get onlineGuestCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set onlineGuestCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnlineGuestCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnlineGuestCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get connectionCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set connectionCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectionCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectionCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<NodeConnectionCount> get nodeConnectionCounts => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get sampledAt => $_getI64(4);
  @$pb.TagNumber(5)
  set sampledAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSampledAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearSampledAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

class UserPresenceStats extends $pb.GeneratedMessage {
  factory UserPresenceStats({
    $core.int? connectionCount,
    $core.Iterable<NodeConnectionCount>? nodeConnectionCounts,
    $core.int? roomCount,
    $core.Iterable<$core.String>? roomIds,
    $fixnum.Int64? sampledAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (connectionCount != null) result.connectionCount = connectionCount;
    if (nodeConnectionCounts != null)
      result.nodeConnectionCounts.addAll(nodeConnectionCounts);
    if (roomCount != null) result.roomCount = roomCount;
    if (roomIds != null) result.roomIds.addAll(roomIds);
    if (sampledAt != null) result.sampledAt = sampledAt;
    if (version != null) result.version = version;
    return result;
  }

  UserPresenceStats._();

  factory UserPresenceStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserPresenceStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserPresenceStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.common'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'connectionCount')
    ..pPM<NodeConnectionCount>(2, _omitFieldNames ? '' : 'nodeConnectionCounts',
        subBuilder: NodeConnectionCount.create)
    ..aI(3, _omitFieldNames ? '' : 'roomCount')
    ..pPS(4, _omitFieldNames ? '' : 'roomIds')
    ..aInt64(5, _omitFieldNames ? '' : 'sampledAt')
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'version', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPresenceStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPresenceStats copyWith(void Function(UserPresenceStats) updates) =>
      super.copyWith((message) => updates(message as UserPresenceStats))
          as UserPresenceStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserPresenceStats create() => UserPresenceStats._();
  @$core.override
  UserPresenceStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserPresenceStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserPresenceStats>(create);
  static UserPresenceStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get connectionCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set connectionCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectionCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectionCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<NodeConnectionCount> get nodeConnectionCounts => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get roomCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set roomCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get roomIds => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get sampledAt => $_getI64(4);
  @$pb.TagNumber(5)
  set sampledAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSampledAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearSampledAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

class NodePresenceStats extends $pb.GeneratedMessage {
  factory NodePresenceStats({
    $core.String? nodeId,
    $core.int? connectionCount,
    $core.int? onlineMemberCount,
    $core.int? onlineGuestCount,
    $core.int? roomCount,
    $fixnum.Int64? sampledAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (connectionCount != null) result.connectionCount = connectionCount;
    if (onlineMemberCount != null) result.onlineMemberCount = onlineMemberCount;
    if (onlineGuestCount != null) result.onlineGuestCount = onlineGuestCount;
    if (roomCount != null) result.roomCount = roomCount;
    if (sampledAt != null) result.sampledAt = sampledAt;
    if (version != null) result.version = version;
    return result;
  }

  NodePresenceStats._();

  factory NodePresenceStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NodePresenceStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodePresenceStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aI(2, _omitFieldNames ? '' : 'connectionCount')
    ..aI(3, _omitFieldNames ? '' : 'onlineMemberCount')
    ..aI(4, _omitFieldNames ? '' : 'onlineGuestCount')
    ..aI(5, _omitFieldNames ? '' : 'roomCount')
    ..aInt64(6, _omitFieldNames ? '' : 'sampledAt')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'version', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePresenceStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodePresenceStats copyWith(void Function(NodePresenceStats) updates) =>
      super.copyWith((message) => updates(message as NodePresenceStats))
          as NodePresenceStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NodePresenceStats create() => NodePresenceStats._();
  @$core.override
  NodePresenceStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NodePresenceStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NodePresenceStats>(create);
  static NodePresenceStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get connectionCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set connectionCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectionCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get onlineMemberCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set onlineMemberCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOnlineMemberCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearOnlineMemberCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get onlineGuestCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set onlineGuestCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOnlineGuestCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOnlineGuestCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get roomCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set roomCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoomCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoomCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sampledAt => $_getI64(5);
  @$pb.TagNumber(6)
  set sampledAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSampledAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearSampledAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get version => $_getI64(6);
  @$pb.TagNumber(7)
  set version($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);
}

class PresenceOverview extends $pb.GeneratedMessage {
  factory PresenceOverview({
    $core.int? onlineMemberCount,
    $core.int? onlineGuestCount,
    $core.int? connectionCount,
    $core.int? activeRoomCount,
    $core.Iterable<NodePresenceStats>? nodes,
    $fixnum.Int64? sampledAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (onlineMemberCount != null) result.onlineMemberCount = onlineMemberCount;
    if (onlineGuestCount != null) result.onlineGuestCount = onlineGuestCount;
    if (connectionCount != null) result.connectionCount = connectionCount;
    if (activeRoomCount != null) result.activeRoomCount = activeRoomCount;
    if (nodes != null) result.nodes.addAll(nodes);
    if (sampledAt != null) result.sampledAt = sampledAt;
    if (version != null) result.version = version;
    return result;
  }

  PresenceOverview._();

  factory PresenceOverview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PresenceOverview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PresenceOverview',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.common'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'onlineMemberCount')
    ..aI(2, _omitFieldNames ? '' : 'onlineGuestCount')
    ..aI(3, _omitFieldNames ? '' : 'connectionCount')
    ..aI(4, _omitFieldNames ? '' : 'activeRoomCount')
    ..pPM<NodePresenceStats>(5, _omitFieldNames ? '' : 'nodes',
        subBuilder: NodePresenceStats.create)
    ..aInt64(6, _omitFieldNames ? '' : 'sampledAt')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'version', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PresenceOverview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PresenceOverview copyWith(void Function(PresenceOverview) updates) =>
      super.copyWith((message) => updates(message as PresenceOverview))
          as PresenceOverview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PresenceOverview create() => PresenceOverview._();
  @$core.override
  PresenceOverview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PresenceOverview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PresenceOverview>(create);
  static PresenceOverview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get onlineMemberCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set onlineMemberCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOnlineMemberCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlineMemberCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get onlineGuestCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set onlineGuestCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnlineGuestCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnlineGuestCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get connectionCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set connectionCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectionCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectionCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get activeRoomCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set activeRoomCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActiveRoomCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveRoomCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<NodePresenceStats> get nodes => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sampledAt => $_getI64(5);
  @$pb.TagNumber(6)
  set sampledAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSampledAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearSampledAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get version => $_getI64(6);
  @$pb.TagNumber(7)
  set version($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
