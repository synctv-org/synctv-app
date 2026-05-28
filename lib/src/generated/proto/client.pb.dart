// This is a generated file - do not edit.
//
// Generated from proto/client.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'client.pbenum.dart';
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'client.pbenum.dart';

/// Full user profile - only returned to the authenticated user themselves (e.g., GetProfile, Register, Login).
/// SECURITY: Contains PII (email). Never return this message for other users.
class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? username,
    $core.String? email,
    $1.UserRole? role,
    $1.UserStatus? status,
    $fixnum.Int64? createdAt,
    $core.bool? emailVerified,
    $core.bool? isBanned,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (role != null) result.role = role;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (emailVerified != null) result.emailVerified = emailVerified;
    if (isBanned != null) result.isBanned = isBanned;
    return result;
  }

  User._();

  factory User.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory User.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aE<$1.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $1.UserRole.values)
    ..aE<$1.UserStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.UserStatus.values)
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..aOB(7, _omitFieldNames ? '' : 'emailVerified')
    ..aOB(8, _omitFieldNames ? '' : 'isBanned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  @$core.override
  User createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static User getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role($1.UserRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.UserStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($1.UserStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get emailVerified => $_getBF(6);
  @$pb.TagNumber(7)
  set emailVerified($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEmailVerified() => $_has(6);
  @$pb.TagNumber(7)
  void clearEmailVerified() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isBanned => $_getBF(7);
  @$pb.TagNumber(8)
  set isBanned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsBanned() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsBanned() => $_clearField(8);
}

/// Public user view - safe to return in any context (room member lists, chat, etc.).
/// Does not contain email or other PII.
class UserPublicView extends $pb.GeneratedMessage {
  factory UserPublicView({
    $core.String? id,
    $core.String? username,
    $1.UserRole? role,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (username != null) result.username = username;
    if (role != null) result.role = role;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  UserPublicView._();

  factory UserPublicView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserPublicView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserPublicView',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aE<$1.UserRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $1.UserRole.values)
    ..aInt64(4, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPublicView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPublicView copyWith(void Function(UserPublicView) updates) =>
      super.copyWith((message) => updates(message as UserPublicView))
          as UserPublicView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserPublicView create() => UserPublicView._();
  @$core.override
  UserPublicView createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserPublicView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserPublicView>(create);
  static UserPublicView? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.UserRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($1.UserRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdAt => $_getI64(3);
  @$pb.TagNumber(4)
  set createdAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);
}

class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? id,
    $core.String? name,
    $core.String? createdBy,
    $1.RoomStatus? status,
    $core.List<$core.int>? settings,
    $fixnum.Int64? createdAt,
    $core.int? memberCount,
    $core.String? description,
    $fixnum.Int64? updatedAt,
    $core.bool? isBanned,
    ResourceAvailability? availability,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (createdBy != null) result.createdBy = createdBy;
    if (status != null) result.status = status;
    if (settings != null) result.settings = settings;
    if (createdAt != null) result.createdAt = createdAt;
    if (memberCount != null) result.memberCount = memberCount;
    if (description != null) result.description = description;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (isBanned != null) result.isBanned = isBanned;
    if (availability != null) result.availability = availability;
    if (version != null) result.version = version;
    return result;
  }

  Room._();

  factory Room.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Room.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Room',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'createdBy')
    ..aE<$1.RoomStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: $1.RoomStatus.values)
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..aI(7, _omitFieldNames ? '' : 'memberCount')
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..aInt64(9, _omitFieldNames ? '' : 'updatedAt')
    ..aOB(10, _omitFieldNames ? '' : 'isBanned')
    ..aE<ResourceAvailability>(11, _omitFieldNames ? '' : 'availability',
        enumValues: ResourceAvailability.values)
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room copyWith(void Function(Room) updates) =>
      super.copyWith((message) => updates(message as Room)) as Room;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Room create() => Room._();
  @$core.override
  Room createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Room getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Room>(create);
  static Room? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get createdBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set createdBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.RoomStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status($1.RoomStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get settings => $_getN(4);
  @$pb.TagNumber(5)
  set settings($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSettings() => $_has(4);
  @$pb.TagNumber(5)
  void clearSettings() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get memberCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set memberCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMemberCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMemberCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get updatedAt => $_getI64(8);
  @$pb.TagNumber(9)
  set updatedAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isBanned => $_getBF(9);
  @$pb.TagNumber(10)
  set isBanned($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsBanned() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsBanned() => $_clearField(10);

  @$pb.TagNumber(11)
  ResourceAvailability get availability => $_getN(10);
  @$pb.TagNumber(11)
  set availability(ResourceAvailability value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAvailability() => $_has(10);
  @$pb.TagNumber(11)
  void clearAvailability() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

class Media extends $pb.GeneratedMessage {
  factory Media({
    $core.String? id,
    $core.String? roomId,
    $core.String? sourceProvider,
    $core.String? name,
    $core.List<$core.int>? metadata,
    $core.double? position,
    $fixnum.Int64? addedAt,
    $core.String? creatorId,
    $core.String? providerInstanceName,
    $core.List<$core.int>? sourceConfig,
    ResourceAvailability? availability,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (roomId != null) result.roomId = roomId;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (name != null) result.name = name;
    if (metadata != null) result.metadata = metadata;
    if (position != null) result.position = position;
    if (addedAt != null) result.addedAt = addedAt;
    if (creatorId != null) result.creatorId = creatorId;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    if (availability != null) result.availability = availability;
    if (version != null) result.version = version;
    return result;
  }

  Media._();

  factory Media.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Media.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Media',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(4, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'metadata', $pb.PbFieldType.OY)
    ..aD(7, _omitFieldNames ? '' : 'position')
    ..aInt64(8, _omitFieldNames ? '' : 'addedAt')
    ..aOS(9, _omitFieldNames ? '' : 'creatorId')
    ..aOS(10, _omitFieldNames ? '' : 'providerInstanceName')
    ..a<$core.List<$core.int>>(
        11, _omitFieldNames ? '' : 'sourceConfig', $pb.PbFieldType.OY)
    ..aE<ResourceAvailability>(12, _omitFieldNames ? '' : 'availability',
        enumValues: ResourceAvailability.values)
    ..aInt64(13, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Media clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Media copyWith(void Function(Media) updates) =>
      super.copyWith((message) => updates(message as Media)) as Media;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Media create() => Media._();
  @$core.override
  Media createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Media getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Media>(create);
  static Media? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.String get sourceProvider => $_getSZ(2);
  @$pb.TagNumber(4)
  set sourceProvider($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceProvider() => $_has(2);
  @$pb.TagNumber(4)
  void clearSourceProvider() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get metadata => $_getN(4);
  @$pb.TagNumber(6)
  set metadata($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(6)
  $core.bool hasMetadata() => $_has(4);
  @$pb.TagNumber(6)
  void clearMetadata() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get position => $_getN(5);
  @$pb.TagNumber(7)
  set position($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(7)
  $core.bool hasPosition() => $_has(5);
  @$pb.TagNumber(7)
  void clearPosition() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get addedAt => $_getI64(6);
  @$pb.TagNumber(8)
  set addedAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(8)
  $core.bool hasAddedAt() => $_has(6);
  @$pb.TagNumber(8)
  void clearAddedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get creatorId => $_getSZ(7);
  @$pb.TagNumber(9)
  set creatorId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatorId() => $_has(7);
  @$pb.TagNumber(9)
  void clearCreatorId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get providerInstanceName => $_getSZ(8);
  @$pb.TagNumber(10)
  set providerInstanceName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(10)
  $core.bool hasProviderInstanceName() => $_has(8);
  @$pb.TagNumber(10)
  void clearProviderInstanceName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.int> get sourceConfig => $_getN(9);
  @$pb.TagNumber(11)
  set sourceConfig($core.List<$core.int> value) => $_setBytes(9, value);
  @$pb.TagNumber(11)
  $core.bool hasSourceConfig() => $_has(9);
  @$pb.TagNumber(11)
  void clearSourceConfig() => $_clearField(11);

  @$pb.TagNumber(12)
  ResourceAvailability get availability => $_getN(10);
  @$pb.TagNumber(12)
  set availability(ResourceAvailability value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAvailability() => $_has(10);
  @$pb.TagNumber(12)
  void clearAvailability() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(13)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(13)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(13)
  void clearVersion() => $_clearField(13);
}

class Playlist extends $pb.GeneratedMessage {
  factory Playlist({
    $core.String? id,
    $core.String? roomId,
    $core.String? name,
    $core.String? parentId,
    $core.double? position,
    $core.bool? isDynamic,
    $core.int? itemCount,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    ResourceAvailability? availability,
    $fixnum.Int64? version,
    $core.List<$core.int>? sourceConfig,
    $core.String? sourceProvider,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (roomId != null) result.roomId = roomId;
    if (name != null) result.name = name;
    if (parentId != null) result.parentId = parentId;
    if (position != null) result.position = position;
    if (isDynamic != null) result.isDynamic = isDynamic;
    if (itemCount != null) result.itemCount = itemCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (availability != null) result.availability = availability;
    if (version != null) result.version = version;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    return result;
  }

  Playlist._();

  factory Playlist.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Playlist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Playlist',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'parentId')
    ..aD(5, _omitFieldNames ? '' : 'position')
    ..aOB(6, _omitFieldNames ? '' : 'isDynamic')
    ..aI(7, _omitFieldNames ? '' : 'itemCount')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(9, _omitFieldNames ? '' : 'updatedAt')
    ..aE<ResourceAvailability>(10, _omitFieldNames ? '' : 'availability',
        enumValues: ResourceAvailability.values)
    ..aInt64(11, _omitFieldNames ? '' : 'version')
    ..a<$core.List<$core.int>>(
        12, _omitFieldNames ? '' : 'sourceConfig', $pb.PbFieldType.OY)
    ..aOS(13, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(14, _omitFieldNames ? '' : 'providerInstanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Playlist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Playlist copyWith(void Function(Playlist) updates) =>
      super.copyWith((message) => updates(message as Playlist)) as Playlist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Playlist create() => Playlist._();
  @$core.override
  Playlist createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Playlist getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Playlist>(create);
  static Playlist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get position => $_getN(4);
  @$pb.TagNumber(5)
  set position($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPosition() => $_has(4);
  @$pb.TagNumber(5)
  void clearPosition() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isDynamic => $_getBF(5);
  @$pb.TagNumber(6)
  set isDynamic($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsDynamic() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsDynamic() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get itemCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set itemCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasItemCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearItemCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAt => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get updatedAt => $_getI64(8);
  @$pb.TagNumber(9)
  set updatedAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  ResourceAvailability get availability => $_getN(9);
  @$pb.TagNumber(10)
  set availability(ResourceAvailability value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAvailability() => $_has(9);
  @$pb.TagNumber(10)
  void clearAvailability() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get version => $_getI64(10);
  @$pb.TagNumber(11)
  set version($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVersion() => $_has(10);
  @$pb.TagNumber(11)
  void clearVersion() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.int> get sourceConfig => $_getN(11);
  @$pb.TagNumber(12)
  set sourceConfig($core.List<$core.int> value) => $_setBytes(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSourceConfig() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceConfig() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get sourceProvider => $_getSZ(12);
  @$pb.TagNumber(13)
  set sourceProvider($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSourceProvider() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceProvider() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get providerInstanceName => $_getSZ(13);
  @$pb.TagNumber(14)
  set providerInstanceName($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasProviderInstanceName() => $_has(13);
  @$pb.TagNumber(14)
  void clearProviderInstanceName() => $_clearField(14);
}

class PlaybackState extends $pb.GeneratedMessage {
  factory PlaybackState({
    $core.String? roomId,
    $core.String? playingMediaId,
    $core.double? position,
    $core.double? speed,
    $core.bool? isPlaying,
    $fixnum.Int64? updatedAt,
    $fixnum.Int64? version,
    $core.String? playingPlaylistId,
    $core.List<$core.int>? target,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (playingMediaId != null) result.playingMediaId = playingMediaId;
    if (position != null) result.position = position;
    if (speed != null) result.speed = speed;
    if (isPlaying != null) result.isPlaying = isPlaying;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    if (playingPlaylistId != null) result.playingPlaylistId = playingPlaylistId;
    if (target != null) result.target = target;
    return result;
  }

  PlaybackState._();

  factory PlaybackState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'playingMediaId')
    ..aD(3, _omitFieldNames ? '' : 'position')
    ..aD(4, _omitFieldNames ? '' : 'speed')
    ..aOB(5, _omitFieldNames ? '' : 'isPlaying')
    ..aInt64(6, _omitFieldNames ? '' : 'updatedAt')
    ..aInt64(7, _omitFieldNames ? '' : 'version')
    ..aOS(8, _omitFieldNames ? '' : 'playingPlaylistId')
    ..a<$core.List<$core.int>>(
        9, _omitFieldNames ? '' : 'target', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackState copyWith(void Function(PlaybackState) updates) =>
      super.copyWith((message) => updates(message as PlaybackState))
          as PlaybackState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackState create() => PlaybackState._();
  @$core.override
  PlaybackState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackState>(create);
  static PlaybackState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playingMediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playingMediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayingMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayingMediaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get position => $_getN(2);
  @$pb.TagNumber(3)
  set position($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get speed => $_getN(3);
  @$pb.TagNumber(4)
  set speed($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeed() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isPlaying => $_getBF(4);
  @$pb.TagNumber(5)
  set isPlaying($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsPlaying() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsPlaying() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get updatedAt => $_getI64(5);
  @$pb.TagNumber(6)
  set updatedAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get version => $_getI64(6);
  @$pb.TagNumber(7)
  set version($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get playingPlaylistId => $_getSZ(7);
  @$pb.TagNumber(8)
  set playingPlaylistId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayingPlaylistId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayingPlaylistId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get target => $_getN(8);
  @$pb.TagNumber(9)
  set target($core.List<$core.int> value) => $_setBytes(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTarget() => $_has(8);
  @$pb.TagNumber(9)
  void clearTarget() => $_clearField(9);
}

class RegisterResponse extends $pb.GeneratedMessage {
  factory RegisterResponse({
    User? user,
    $core.String? accessToken,
    $core.String? refreshToken,
  }) {
    final result = create();
    if (user != null) result.user = user;
    if (accessToken != null) result.accessToken = accessToken;
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  RegisterResponse._();

  factory RegisterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..aOS(2, _omitFieldNames ? '' : 'accessToken')
    ..aOS(3, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterResponse copyWith(void Function(RegisterResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterResponse))
          as RegisterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterResponse create() => RegisterResponse._();
  @$core.override
  RegisterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterResponse>(create);
  static RegisterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get accessToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set accessToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccessToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccessToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get refreshToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set refreshToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefreshToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefreshToken() => $_clearField(3);
}

/// Start a real OPAQUE account registration. The server receives only the
/// OPAQUE registration request, never the plaintext password.
class StartOpaqueRegistrationRequest extends $pb.GeneratedMessage {
  factory StartOpaqueRegistrationRequest({
    $core.String? username,
    $core.String? email,
    $core.List<$core.int>? registrationRequest,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (registrationRequest != null)
      result.registrationRequest = registrationRequest;
    return result;
  }

  StartOpaqueRegistrationRequest._();

  factory StartOpaqueRegistrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaqueRegistrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaqueRegistrationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'registrationRequest', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueRegistrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueRegistrationRequest copyWith(
          void Function(StartOpaqueRegistrationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartOpaqueRegistrationRequest))
          as StartOpaqueRegistrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaqueRegistrationRequest create() =>
      StartOpaqueRegistrationRequest._();
  @$core.override
  StartOpaqueRegistrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaqueRegistrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaqueRegistrationRequest>(create);
  static StartOpaqueRegistrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get registrationRequest => $_getN(2);
  @$pb.TagNumber(3)
  set registrationRequest($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegistrationRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegistrationRequest() => $_clearField(3);
}

class StartOpaqueRegistrationResponse extends $pb.GeneratedMessage {
  factory StartOpaqueRegistrationResponse({
    $core.String? sessionId,
    $core.List<$core.int>? registrationResponse,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (registrationResponse != null)
      result.registrationResponse = registrationResponse;
    return result;
  }

  StartOpaqueRegistrationResponse._();

  factory StartOpaqueRegistrationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaqueRegistrationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaqueRegistrationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'registrationResponse', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueRegistrationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueRegistrationResponse copyWith(
          void Function(StartOpaqueRegistrationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartOpaqueRegistrationResponse))
          as StartOpaqueRegistrationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaqueRegistrationResponse create() =>
      StartOpaqueRegistrationResponse._();
  @$core.override
  StartOpaqueRegistrationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaqueRegistrationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaqueRegistrationResponse>(
          create);
  static StartOpaqueRegistrationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationResponse => $_getN(1);
  @$pb.TagNumber(2)
  set registrationResponse($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationResponse() => $_clearField(2);
}

class FinishOpaqueRegistrationRequest extends $pb.GeneratedMessage {
  factory FinishOpaqueRegistrationRequest({
    $core.String? sessionId,
    $core.List<$core.int>? registrationUpload,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (registrationUpload != null)
      result.registrationUpload = registrationUpload;
    return result;
  }

  FinishOpaqueRegistrationRequest._();

  factory FinishOpaqueRegistrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishOpaqueRegistrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishOpaqueRegistrationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'registrationUpload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaqueRegistrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaqueRegistrationRequest copyWith(
          void Function(FinishOpaqueRegistrationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FinishOpaqueRegistrationRequest))
          as FinishOpaqueRegistrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishOpaqueRegistrationRequest create() =>
      FinishOpaqueRegistrationRequest._();
  @$core.override
  FinishOpaqueRegistrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishOpaqueRegistrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishOpaqueRegistrationRequest>(
          create);
  static FinishOpaqueRegistrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationUpload => $_getN(1);
  @$pb.TagNumber(2)
  set registrationUpload($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationUpload() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationUpload() => $_clearField(2);
}

/// Confirm a passwordless email login token. Password login uses
/// StartOpaqueLogin / FinishOpaqueLogin.
class ConfirmEmailLoginRequest extends $pb.GeneratedMessage {
  factory ConfirmEmailLoginRequest({
    $core.String? email,
    $core.String? emailToken,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (emailToken != null) result.emailToken = emailToken;
    return result;
  }

  ConfirmEmailLoginRequest._();

  factory ConfirmEmailLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmEmailLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmEmailLoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOS(4, _omitFieldNames ? '' : 'emailToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmEmailLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmEmailLoginRequest copyWith(
          void Function(ConfirmEmailLoginRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmEmailLoginRequest))
          as ConfirmEmailLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmEmailLoginRequest create() => ConfirmEmailLoginRequest._();
  @$core.override
  ConfirmEmailLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmEmailLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmEmailLoginRequest>(create);
  static ConfirmEmailLoginRequest? _defaultInstance;

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get emailToken => $_getSZ(1);
  @$pb.TagNumber(4)
  set emailToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(4)
  $core.bool hasEmailToken() => $_has(1);
  @$pb.TagNumber(4)
  void clearEmailToken() => $_clearField(4);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    User? user,
    $core.String? accessToken,
    $core.String? refreshToken,
    MfaChallenge? mfa,
  }) {
    final result = create();
    if (user != null) result.user = user;
    if (accessToken != null) result.accessToken = accessToken;
    if (refreshToken != null) result.refreshToken = refreshToken;
    if (mfa != null) result.mfa = mfa;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..aOS(2, _omitFieldNames ? '' : 'accessToken')
    ..aOS(3, _omitFieldNames ? '' : 'refreshToken')
    ..aOM<MfaChallenge>(4, _omitFieldNames ? '' : 'mfa',
        subBuilder: MfaChallenge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get accessToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set accessToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccessToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccessToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get refreshToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set refreshToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefreshToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefreshToken() => $_clearField(3);

  @$pb.TagNumber(4)
  MfaChallenge get mfa => $_getN(3);
  @$pb.TagNumber(4)
  set mfa(MfaChallenge value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMfa() => $_has(3);
  @$pb.TagNumber(4)
  void clearMfa() => $_clearField(4);
  @$pb.TagNumber(4)
  MfaChallenge ensureMfa() => $_ensure(3);
}

class MfaChallenge extends $pb.GeneratedMessage {
  factory MfaChallenge({
    $core.bool? required,
    $core.String? sessionId,
    $core.Iterable<MfaMethod>? availableMethods,
    $core.String? maskedEmail,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (required != null) result.required = required;
    if (sessionId != null) result.sessionId = sessionId;
    if (availableMethods != null)
      result.availableMethods.addAll(availableMethods);
    if (maskedEmail != null) result.maskedEmail = maskedEmail;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  MfaChallenge._();

  factory MfaChallenge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MfaChallenge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MfaChallenge',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'required')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..pc<MfaMethod>(
        3, _omitFieldNames ? '' : 'availableMethods', $pb.PbFieldType.KE,
        valueOf: MfaMethod.valueOf,
        enumValues: MfaMethod.values,
        defaultEnumValue: MfaMethod.MFA_METHOD_UNSPECIFIED)
    ..aOS(4, _omitFieldNames ? '' : 'maskedEmail')
    ..aInt64(5, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MfaChallenge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MfaChallenge copyWith(void Function(MfaChallenge) updates) =>
      super.copyWith((message) => updates(message as MfaChallenge))
          as MfaChallenge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MfaChallenge create() => MfaChallenge._();
  @$core.override
  MfaChallenge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MfaChallenge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MfaChallenge>(create);
  static MfaChallenge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get required => $_getBF(0);
  @$pb.TagNumber(1)
  set required($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequired() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequired() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<MfaMethod> get availableMethods => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get maskedEmail => $_getSZ(3);
  @$pb.TagNumber(4)
  set maskedEmail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaskedEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaskedEmail() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiresAt => $_getI64(4);
  @$pb.TagNumber(5)
  set expiresAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
}

/// Start a real OPAQUE password login. The server receives only the OPAQUE
/// credential request, never the plaintext password. Provide exactly one login
/// identifier: `username` or `email`.
class StartOpaqueLoginRequest extends $pb.GeneratedMessage {
  factory StartOpaqueLoginRequest({
    $core.String? username,
    $core.String? email,
    $core.List<$core.int>? credentialRequest,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (credentialRequest != null) result.credentialRequest = credentialRequest;
    return result;
  }

  StartOpaqueLoginRequest._();

  factory StartOpaqueLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaqueLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaqueLoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'credentialRequest', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueLoginRequest copyWith(
          void Function(StartOpaqueLoginRequest) updates) =>
      super.copyWith((message) => updates(message as StartOpaqueLoginRequest))
          as StartOpaqueLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaqueLoginRequest create() => StartOpaqueLoginRequest._();
  @$core.override
  StartOpaqueLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaqueLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaqueLoginRequest>(create);
  static StartOpaqueLoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get credentialRequest => $_getN(2);
  @$pb.TagNumber(3)
  set credentialRequest($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredentialRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredentialRequest() => $_clearField(3);
}

class StartOpaqueLoginResponse extends $pb.GeneratedMessage {
  factory StartOpaqueLoginResponse({
    $core.String? sessionId,
    $core.List<$core.int>? credentialResponse,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credentialResponse != null)
      result.credentialResponse = credentialResponse;
    return result;
  }

  StartOpaqueLoginResponse._();

  factory StartOpaqueLoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaqueLoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaqueLoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credentialResponse', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueLoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaqueLoginResponse copyWith(
          void Function(StartOpaqueLoginResponse) updates) =>
      super.copyWith((message) => updates(message as StartOpaqueLoginResponse))
          as StartOpaqueLoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaqueLoginResponse create() => StartOpaqueLoginResponse._();
  @$core.override
  StartOpaqueLoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaqueLoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaqueLoginResponse>(create);
  static StartOpaqueLoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credentialResponse => $_getN(1);
  @$pb.TagNumber(2)
  set credentialResponse($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredentialResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredentialResponse() => $_clearField(2);
}

class FinishOpaqueLoginRequest extends $pb.GeneratedMessage {
  factory FinishOpaqueLoginRequest({
    $core.String? sessionId,
    $core.List<$core.int>? credentialFinalization,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credentialFinalization != null)
      result.credentialFinalization = credentialFinalization;
    return result;
  }

  FinishOpaqueLoginRequest._();

  factory FinishOpaqueLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishOpaqueLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishOpaqueLoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credentialFinalization', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaqueLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaqueLoginRequest copyWith(
          void Function(FinishOpaqueLoginRequest) updates) =>
      super.copyWith((message) => updates(message as FinishOpaqueLoginRequest))
          as FinishOpaqueLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishOpaqueLoginRequest create() => FinishOpaqueLoginRequest._();
  @$core.override
  FinishOpaqueLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishOpaqueLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishOpaqueLoginRequest>(create);
  static FinishOpaqueLoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credentialFinalization => $_getN(1);
  @$pb.TagNumber(2)
  set credentialFinalization($core.List<$core.int> value) =>
      $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredentialFinalization() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredentialFinalization() => $_clearField(2);
}

/// Start a passkey login. If username or email is provided, the challenge is
/// bound to that account's passkeys. If both are empty, the challenge uses
/// discoverable credentials with conditional mediation.
class StartPasskeyLoginRequest extends $pb.GeneratedMessage {
  factory StartPasskeyLoginRequest({
    $core.String? username,
    $core.String? email,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    return result;
  }

  StartPasskeyLoginRequest._();

  factory StartPasskeyLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPasskeyLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPasskeyLoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyLoginRequest copyWith(
          void Function(StartPasskeyLoginRequest) updates) =>
      super.copyWith((message) => updates(message as StartPasskeyLoginRequest))
          as StartPasskeyLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPasskeyLoginRequest create() => StartPasskeyLoginRequest._();
  @$core.override
  StartPasskeyLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPasskeyLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPasskeyLoginRequest>(create);
  static StartPasskeyLoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);
}

class StartPasskeyLoginResponse extends $pb.GeneratedMessage {
  factory StartPasskeyLoginResponse({
    $core.String? sessionId,
    $core.List<$core.int>? options,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (options != null) result.options = options;
    return result;
  }

  StartPasskeyLoginResponse._();

  factory StartPasskeyLoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPasskeyLoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPasskeyLoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'options', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyLoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyLoginResponse copyWith(
          void Function(StartPasskeyLoginResponse) updates) =>
      super.copyWith((message) => updates(message as StartPasskeyLoginResponse))
          as StartPasskeyLoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPasskeyLoginResponse create() => StartPasskeyLoginResponse._();
  @$core.override
  StartPasskeyLoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPasskeyLoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPasskeyLoginResponse>(create);
  static StartPasskeyLoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// WebAuthn PublicKeyCredentialRequestOptions JSON.
  @$pb.TagNumber(2)
  $core.List<$core.int> get options => $_getN(1);
  @$pb.TagNumber(2)
  set options($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
}

/// Finish a passkey login. `credential` is the browser WebAuthn
/// PublicKeyCredential JSON returned by navigator.credentials.get().
class FinishPasskeyLoginRequest extends $pb.GeneratedMessage {
  factory FinishPasskeyLoginRequest({
    $core.String? sessionId,
    $core.List<$core.int>? credential,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credential != null) result.credential = credential;
    return result;
  }

  FinishPasskeyLoginRequest._();

  factory FinishPasskeyLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishPasskeyLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishPasskeyLoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credential', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishPasskeyLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishPasskeyLoginRequest copyWith(
          void Function(FinishPasskeyLoginRequest) updates) =>
      super.copyWith((message) => updates(message as FinishPasskeyLoginRequest))
          as FinishPasskeyLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishPasskeyLoginRequest create() => FinishPasskeyLoginRequest._();
  @$core.override
  FinishPasskeyLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishPasskeyLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishPasskeyLoginRequest>(create);
  static FinishPasskeyLoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credential => $_getN(1);
  @$pb.TagNumber(2)
  set credential($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredential() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredential() => $_clearField(2);
}

/// Start a WebAuthn/passkey account registration. The response `options` is the
/// PublicKeyCredentialCreationOptions JSON that must be passed to the browser's
/// navigator.credentials.create().
class StartPasskeyRegistrationRequest extends $pb.GeneratedMessage {
  factory StartPasskeyRegistrationRequest({
    $core.String? username,
    $core.String? email,
    $core.String? name,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (name != null) result.name = name;
    return result;
  }

  StartPasskeyRegistrationRequest._();

  factory StartPasskeyRegistrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPasskeyRegistrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPasskeyRegistrationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyRegistrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyRegistrationRequest copyWith(
          void Function(StartPasskeyRegistrationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartPasskeyRegistrationRequest))
          as StartPasskeyRegistrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPasskeyRegistrationRequest create() =>
      StartPasskeyRegistrationRequest._();
  @$core.override
  StartPasskeyRegistrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPasskeyRegistrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPasskeyRegistrationRequest>(
          create);
  static StartPasskeyRegistrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

/// Finish a WebAuthn/passkey account registration. `credential` is the browser
/// PublicKeyCredential JSON returned by navigator.credentials.create().
class FinishPasskeyRegistrationRequest extends $pb.GeneratedMessage {
  factory FinishPasskeyRegistrationRequest({
    $core.String? sessionId,
    $core.List<$core.int>? credential,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credential != null) result.credential = credential;
    return result;
  }

  FinishPasskeyRegistrationRequest._();

  factory FinishPasskeyRegistrationRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishPasskeyRegistrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishPasskeyRegistrationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credential', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishPasskeyRegistrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishPasskeyRegistrationRequest copyWith(
          void Function(FinishPasskeyRegistrationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FinishPasskeyRegistrationRequest))
          as FinishPasskeyRegistrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishPasskeyRegistrationRequest create() =>
      FinishPasskeyRegistrationRequest._();
  @$core.override
  FinishPasskeyRegistrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishPasskeyRegistrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishPasskeyRegistrationRequest>(
          create);
  static FinishPasskeyRegistrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credential => $_getN(1);
  @$pb.TagNumber(2)
  set credential($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredential() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredential() => $_clearField(2);
}

class StartPasskeyBindRequest extends $pb.GeneratedMessage {
  factory StartPasskeyBindRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  StartPasskeyBindRequest._();

  factory StartPasskeyBindRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPasskeyBindRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPasskeyBindRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyBindRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyBindRequest copyWith(
          void Function(StartPasskeyBindRequest) updates) =>
      super.copyWith((message) => updates(message as StartPasskeyBindRequest))
          as StartPasskeyBindRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPasskeyBindRequest create() => StartPasskeyBindRequest._();
  @$core.override
  StartPasskeyBindRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPasskeyBindRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPasskeyBindRequest>(create);
  static StartPasskeyBindRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class StartPasskeyRegistrationResponse extends $pb.GeneratedMessage {
  factory StartPasskeyRegistrationResponse({
    $core.String? sessionId,
    $core.List<$core.int>? options,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (options != null) result.options = options;
    return result;
  }

  StartPasskeyRegistrationResponse._();

  factory StartPasskeyRegistrationResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPasskeyRegistrationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPasskeyRegistrationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'options', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyRegistrationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyRegistrationResponse copyWith(
          void Function(StartPasskeyRegistrationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartPasskeyRegistrationResponse))
          as StartPasskeyRegistrationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPasskeyRegistrationResponse create() =>
      StartPasskeyRegistrationResponse._();
  @$core.override
  StartPasskeyRegistrationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPasskeyRegistrationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPasskeyRegistrationResponse>(
          create);
  static StartPasskeyRegistrationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// WebAuthn PublicKeyCredentialCreationOptions JSON.
  @$pb.TagNumber(2)
  $core.List<$core.int> get options => $_getN(1);
  @$pb.TagNumber(2)
  set options($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
}

class StartPasskeyBindResponse extends $pb.GeneratedMessage {
  factory StartPasskeyBindResponse({
    $core.String? sessionId,
    $core.List<$core.int>? options,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (options != null) result.options = options;
    return result;
  }

  StartPasskeyBindResponse._();

  factory StartPasskeyBindResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPasskeyBindResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPasskeyBindResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'options', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyBindResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPasskeyBindResponse copyWith(
          void Function(StartPasskeyBindResponse) updates) =>
      super.copyWith((message) => updates(message as StartPasskeyBindResponse))
          as StartPasskeyBindResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPasskeyBindResponse create() => StartPasskeyBindResponse._();
  @$core.override
  StartPasskeyBindResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPasskeyBindResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPasskeyBindResponse>(create);
  static StartPasskeyBindResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  /// WebAuthn PublicKeyCredentialCreationOptions JSON.
  @$pb.TagNumber(2)
  $core.List<$core.int> get options => $_getN(1);
  @$pb.TagNumber(2)
  set options($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
}

/// Finish a passkey bind. `credential` is the browser WebAuthn
/// PublicKeyCredential JSON returned by navigator.credentials.create().
class FinishPasskeyBindRequest extends $pb.GeneratedMessage {
  factory FinishPasskeyBindRequest({
    $core.String? sessionId,
    $core.List<$core.int>? credential,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credential != null) result.credential = credential;
    return result;
  }

  FinishPasskeyBindRequest._();

  factory FinishPasskeyBindRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishPasskeyBindRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishPasskeyBindRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credential', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishPasskeyBindRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishPasskeyBindRequest copyWith(
          void Function(FinishPasskeyBindRequest) updates) =>
      super.copyWith((message) => updates(message as FinishPasskeyBindRequest))
          as FinishPasskeyBindRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishPasskeyBindRequest create() => FinishPasskeyBindRequest._();
  @$core.override
  FinishPasskeyBindRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishPasskeyBindRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishPasskeyBindRequest>(create);
  static FinishPasskeyBindRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credential => $_getN(1);
  @$pb.TagNumber(2)
  set credential($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredential() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredential() => $_clearField(2);
}

class PasskeyCredential extends $pb.GeneratedMessage {
  factory PasskeyCredential({
    $core.String? credentialId,
    $core.String? name,
    $fixnum.Int64? signCount,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $fixnum.Int64? lastUsedAt,
  }) {
    final result = create();
    if (credentialId != null) result.credentialId = credentialId;
    if (name != null) result.name = name;
    if (signCount != null) result.signCount = signCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (lastUsedAt != null) result.lastUsedAt = lastUsedAt;
    return result;
  }

  PasskeyCredential._();

  factory PasskeyCredential.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyCredential.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyCredential',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'credentialId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'signCount')
    ..aInt64(4, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(5, _omitFieldNames ? '' : 'updatedAt')
    ..aInt64(6, _omitFieldNames ? '' : 'lastUsedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredential clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredential copyWith(void Function(PasskeyCredential) updates) =>
      super.copyWith((message) => updates(message as PasskeyCredential))
          as PasskeyCredential;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyCredential create() => PasskeyCredential._();
  @$core.override
  PasskeyCredential createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyCredential getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyCredential>(create);
  static PasskeyCredential? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get credentialId => $_getSZ(0);
  @$pb.TagNumber(1)
  set credentialId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCredentialId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentialId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get signCount => $_getI64(2);
  @$pb.TagNumber(3)
  set signCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdAt => $_getI64(3);
  @$pb.TagNumber(4)
  set createdAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get updatedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set updatedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get lastUsedAt => $_getI64(5);
  @$pb.TagNumber(6)
  set lastUsedAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLastUsedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastUsedAt() => $_clearField(6);
}

class PasskeyCredentialResponse extends $pb.GeneratedMessage {
  factory PasskeyCredentialResponse({
    PasskeyCredential? credential,
  }) {
    final result = create();
    if (credential != null) result.credential = credential;
    return result;
  }

  PasskeyCredentialResponse._();

  factory PasskeyCredentialResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyCredentialResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyCredentialResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PasskeyCredential>(1, _omitFieldNames ? '' : 'credential',
        subBuilder: PasskeyCredential.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredentialResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredentialResponse copyWith(
          void Function(PasskeyCredentialResponse) updates) =>
      super.copyWith((message) => updates(message as PasskeyCredentialResponse))
          as PasskeyCredentialResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyCredentialResponse create() => PasskeyCredentialResponse._();
  @$core.override
  PasskeyCredentialResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyCredentialResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyCredentialResponse>(create);
  static PasskeyCredentialResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyCredential get credential => $_getN(0);
  @$pb.TagNumber(1)
  set credential(PasskeyCredential value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCredential() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredential() => $_clearField(1);
  @$pb.TagNumber(1)
  PasskeyCredential ensureCredential() => $_ensure(0);
}

class ListPasskeysRequest extends $pb.GeneratedMessage {
  factory ListPasskeysRequest() => create();

  ListPasskeysRequest._();

  factory ListPasskeysRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPasskeysRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPasskeysRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPasskeysRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPasskeysRequest copyWith(void Function(ListPasskeysRequest) updates) =>
      super.copyWith((message) => updates(message as ListPasskeysRequest))
          as ListPasskeysRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPasskeysRequest create() => ListPasskeysRequest._();
  @$core.override
  ListPasskeysRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPasskeysRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPasskeysRequest>(create);
  static ListPasskeysRequest? _defaultInstance;
}

class ListPasskeysResponse extends $pb.GeneratedMessage {
  factory ListPasskeysResponse({
    $core.Iterable<PasskeyCredential>? credentials,
  }) {
    final result = create();
    if (credentials != null) result.credentials.addAll(credentials);
    return result;
  }

  ListPasskeysResponse._();

  factory ListPasskeysResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPasskeysResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPasskeysResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<PasskeyCredential>(1, _omitFieldNames ? '' : 'credentials',
        subBuilder: PasskeyCredential.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPasskeysResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPasskeysResponse copyWith(void Function(ListPasskeysResponse) updates) =>
      super.copyWith((message) => updates(message as ListPasskeysResponse))
          as ListPasskeysResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPasskeysResponse create() => ListPasskeysResponse._();
  @$core.override
  ListPasskeysResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPasskeysResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPasskeysResponse>(create);
  static ListPasskeysResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PasskeyCredential> get credentials => $_getList(0);
}

class DeletePasskeyRequest extends $pb.GeneratedMessage {
  factory DeletePasskeyRequest({
    $core.String? credentialId,
  }) {
    final result = create();
    if (credentialId != null) result.credentialId = credentialId;
    return result;
  }

  DeletePasskeyRequest._();

  factory DeletePasskeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePasskeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePasskeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'credentialId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePasskeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePasskeyRequest copyWith(void Function(DeletePasskeyRequest) updates) =>
      super.copyWith((message) => updates(message as DeletePasskeyRequest))
          as DeletePasskeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePasskeyRequest create() => DeletePasskeyRequest._();
  @$core.override
  DeletePasskeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeletePasskeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePasskeyRequest>(create);
  static DeletePasskeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get credentialId => $_getSZ(0);
  @$pb.TagNumber(1)
  set credentialId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCredentialId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentialId() => $_clearField(1);
}

class DeletePasskeyResponse extends $pb.GeneratedMessage {
  factory DeletePasskeyResponse({
    $core.bool? deleted,
  }) {
    final result = create();
    if (deleted != null) result.deleted = deleted;
    return result;
  }

  DeletePasskeyResponse._();

  factory DeletePasskeyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePasskeyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePasskeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'deleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePasskeyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePasskeyResponse copyWith(
          void Function(DeletePasskeyResponse) updates) =>
      super.copyWith((message) => updates(message as DeletePasskeyResponse))
          as DeletePasskeyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePasskeyResponse create() => DeletePasskeyResponse._();
  @$core.override
  DeletePasskeyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeletePasskeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePasskeyResponse>(create);
  static DeletePasskeyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get deleted => $_getBF(0);
  @$pb.TagNumber(1)
  set deleted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeleted() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeleted() => $_clearField(1);
}

class UserAuthFactors extends $pb.GeneratedMessage {
  factory UserAuthFactors({
    $core.bool? password,
    $core.bool? webauthn,
    $core.bool? email,
    $core.int? eligibleCount,
  }) {
    final result = create();
    if (password != null) result.password = password;
    if (webauthn != null) result.webauthn = webauthn;
    if (email != null) result.email = email;
    if (eligibleCount != null) result.eligibleCount = eligibleCount;
    return result;
  }

  UserAuthFactors._();

  factory UserAuthFactors.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserAuthFactors.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserAuthFactors',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'password')
    ..aOB(2, _omitFieldNames ? '' : 'webauthn')
    ..aOB(3, _omitFieldNames ? '' : 'email')
    ..aI(4, _omitFieldNames ? '' : 'eligibleCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserAuthFactors clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserAuthFactors copyWith(void Function(UserAuthFactors) updates) =>
      super.copyWith((message) => updates(message as UserAuthFactors))
          as UserAuthFactors;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserAuthFactors create() => UserAuthFactors._();
  @$core.override
  UserAuthFactors createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserAuthFactors getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserAuthFactors>(create);
  static UserAuthFactors? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get password => $_getBF(0);
  @$pb.TagNumber(1)
  set password($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get webauthn => $_getBF(1);
  @$pb.TagNumber(2)
  set webauthn($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWebauthn() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebauthn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get email => $_getBF(2);
  @$pb.TagNumber(3)
  set email($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get eligibleCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set eligibleCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEligibleCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearEligibleCount() => $_clearField(4);
}

class UserPreferences extends $pb.GeneratedMessage {
  factory UserPreferences({
    $core.bool? twoFactorEnabled,
    UserNotificationPreferences? notifications,
    $core.List<$core.int>? settings,
  }) {
    final result = create();
    if (twoFactorEnabled != null) result.twoFactorEnabled = twoFactorEnabled;
    if (notifications != null) result.notifications = notifications;
    if (settings != null) result.settings = settings;
    return result;
  }

  UserPreferences._();

  factory UserPreferences.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserPreferences.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserPreferences',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'twoFactorEnabled')
    ..aOM<UserNotificationPreferences>(
        3, _omitFieldNames ? '' : 'notifications',
        subBuilder: UserNotificationPreferences.create)
    ..a<$core.List<$core.int>>(
        15, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPreferences clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPreferences copyWith(void Function(UserPreferences) updates) =>
      super.copyWith((message) => updates(message as UserPreferences))
          as UserPreferences;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserPreferences create() => UserPreferences._();
  @$core.override
  UserPreferences createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserPreferences getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserPreferences>(create);
  static UserPreferences? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get twoFactorEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set twoFactorEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTwoFactorEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwoFactorEnabled() => $_clearField(1);

  @$pb.TagNumber(3)
  UserNotificationPreferences get notifications => $_getN(1);
  @$pb.TagNumber(3)
  set notifications(UserNotificationPreferences value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNotifications() => $_has(1);
  @$pb.TagNumber(3)
  void clearNotifications() => $_clearField(3);
  @$pb.TagNumber(3)
  UserNotificationPreferences ensureNotifications() => $_ensure(1);

  /// Low-priority extension payload; core preferences use typed fields.
  @$pb.TagNumber(15)
  $core.List<$core.int> get settings => $_getN(2);
  @$pb.TagNumber(15)
  set settings($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(15)
  $core.bool hasSettings() => $_has(2);
  @$pb.TagNumber(15)
  void clearSettings() => $_clearField(15);
}

class UserNotificationPreferences extends $pb.GeneratedMessage {
  factory UserNotificationPreferences({
    $core.bool? roomInvitationInApp,
    $core.bool? roomEventInApp,
    $core.bool? systemAnnouncementInApp,
    $core.bool? roomInvitationEmail,
    $core.bool? roomEventEmail,
    $core.bool? systemAnnouncementEmail,
  }) {
    final result = create();
    if (roomInvitationInApp != null)
      result.roomInvitationInApp = roomInvitationInApp;
    if (roomEventInApp != null) result.roomEventInApp = roomEventInApp;
    if (systemAnnouncementInApp != null)
      result.systemAnnouncementInApp = systemAnnouncementInApp;
    if (roomInvitationEmail != null)
      result.roomInvitationEmail = roomInvitationEmail;
    if (roomEventEmail != null) result.roomEventEmail = roomEventEmail;
    if (systemAnnouncementEmail != null)
      result.systemAnnouncementEmail = systemAnnouncementEmail;
    return result;
  }

  UserNotificationPreferences._();

  factory UserNotificationPreferences.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserNotificationPreferences.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserNotificationPreferences',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'roomInvitationInApp')
    ..aOB(2, _omitFieldNames ? '' : 'roomEventInApp')
    ..aOB(3, _omitFieldNames ? '' : 'systemAnnouncementInApp')
    ..aOB(4, _omitFieldNames ? '' : 'roomInvitationEmail')
    ..aOB(5, _omitFieldNames ? '' : 'roomEventEmail')
    ..aOB(6, _omitFieldNames ? '' : 'systemAnnouncementEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserNotificationPreferences clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserNotificationPreferences copyWith(
          void Function(UserNotificationPreferences) updates) =>
      super.copyWith(
              (message) => updates(message as UserNotificationPreferences))
          as UserNotificationPreferences;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserNotificationPreferences create() =>
      UserNotificationPreferences._();
  @$core.override
  UserNotificationPreferences createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserNotificationPreferences getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserNotificationPreferences>(create);
  static UserNotificationPreferences? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get roomInvitationInApp => $_getBF(0);
  @$pb.TagNumber(1)
  set roomInvitationInApp($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomInvitationInApp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomInvitationInApp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get roomEventInApp => $_getBF(1);
  @$pb.TagNumber(2)
  set roomEventInApp($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomEventInApp() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomEventInApp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get systemAnnouncementInApp => $_getBF(2);
  @$pb.TagNumber(3)
  set systemAnnouncementInApp($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSystemAnnouncementInApp() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystemAnnouncementInApp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get roomInvitationEmail => $_getBF(3);
  @$pb.TagNumber(4)
  set roomInvitationEmail($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoomInvitationEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoomInvitationEmail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get roomEventEmail => $_getBF(4);
  @$pb.TagNumber(5)
  set roomEventEmail($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoomEventEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoomEventEmail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get systemAnnouncementEmail => $_getBF(5);
  @$pb.TagNumber(6)
  set systemAnnouncementEmail($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSystemAnnouncementEmail() => $_has(5);
  @$pb.TagNumber(6)
  void clearSystemAnnouncementEmail() => $_clearField(6);
}

class GetUserPreferencesRequest extends $pb.GeneratedMessage {
  factory GetUserPreferencesRequest() => create();

  GetUserPreferencesRequest._();

  factory GetUserPreferencesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserPreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserPreferencesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferencesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferencesRequest copyWith(
          void Function(GetUserPreferencesRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserPreferencesRequest))
          as GetUserPreferencesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserPreferencesRequest create() => GetUserPreferencesRequest._();
  @$core.override
  GetUserPreferencesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserPreferencesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserPreferencesRequest>(create);
  static GetUserPreferencesRequest? _defaultInstance;
}

class GetUserPreferencesResponse extends $pb.GeneratedMessage {
  factory GetUserPreferencesResponse({
    UserPreferences? preferences,
    UserAuthFactors? authFactors,
  }) {
    final result = create();
    if (preferences != null) result.preferences = preferences;
    if (authFactors != null) result.authFactors = authFactors;
    return result;
  }

  GetUserPreferencesResponse._();

  factory GetUserPreferencesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserPreferencesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserPreferencesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<UserPreferences>(1, _omitFieldNames ? '' : 'preferences',
        subBuilder: UserPreferences.create)
    ..aOM<UserAuthFactors>(2, _omitFieldNames ? '' : 'authFactors',
        subBuilder: UserAuthFactors.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferencesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferencesResponse copyWith(
          void Function(GetUserPreferencesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetUserPreferencesResponse))
          as GetUserPreferencesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserPreferencesResponse create() => GetUserPreferencesResponse._();
  @$core.override
  GetUserPreferencesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserPreferencesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserPreferencesResponse>(create);
  static GetUserPreferencesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UserPreferences get preferences => $_getN(0);
  @$pb.TagNumber(1)
  set preferences(UserPreferences value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferences() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferences() => $_clearField(1);
  @$pb.TagNumber(1)
  UserPreferences ensurePreferences() => $_ensure(0);

  @$pb.TagNumber(2)
  UserAuthFactors get authFactors => $_getN(1);
  @$pb.TagNumber(2)
  set authFactors(UserAuthFactors value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthFactors() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthFactors() => $_clearField(2);
  @$pb.TagNumber(2)
  UserAuthFactors ensureAuthFactors() => $_ensure(1);
}

class UpdateUserPreferencesRequest extends $pb.GeneratedMessage {
  factory UpdateUserPreferencesRequest({
    $core.bool? twoFactorEnabled,
    UserNotificationPreferences? notifications,
  }) {
    final result = create();
    if (twoFactorEnabled != null) result.twoFactorEnabled = twoFactorEnabled;
    if (notifications != null) result.notifications = notifications;
    return result;
  }

  UpdateUserPreferencesRequest._();

  factory UpdateUserPreferencesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserPreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserPreferencesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'twoFactorEnabled')
    ..aOM<UserNotificationPreferences>(
        3, _omitFieldNames ? '' : 'notifications',
        subBuilder: UserNotificationPreferences.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPreferencesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPreferencesRequest copyWith(
          void Function(UpdateUserPreferencesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateUserPreferencesRequest))
          as UpdateUserPreferencesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserPreferencesRequest create() =>
      UpdateUserPreferencesRequest._();
  @$core.override
  UpdateUserPreferencesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserPreferencesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserPreferencesRequest>(create);
  static UpdateUserPreferencesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get twoFactorEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set twoFactorEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTwoFactorEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwoFactorEnabled() => $_clearField(1);

  @$pb.TagNumber(3)
  UserNotificationPreferences get notifications => $_getN(1);
  @$pb.TagNumber(3)
  set notifications(UserNotificationPreferences value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNotifications() => $_has(1);
  @$pb.TagNumber(3)
  void clearNotifications() => $_clearField(3);
  @$pb.TagNumber(3)
  UserNotificationPreferences ensureNotifications() => $_ensure(1);
}

class UpdateUserPreferencesResponse extends $pb.GeneratedMessage {
  factory UpdateUserPreferencesResponse({
    UserPreferences? preferences,
    UserAuthFactors? authFactors,
  }) {
    final result = create();
    if (preferences != null) result.preferences = preferences;
    if (authFactors != null) result.authFactors = authFactors;
    return result;
  }

  UpdateUserPreferencesResponse._();

  factory UpdateUserPreferencesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserPreferencesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserPreferencesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<UserPreferences>(1, _omitFieldNames ? '' : 'preferences',
        subBuilder: UserPreferences.create)
    ..aOM<UserAuthFactors>(2, _omitFieldNames ? '' : 'authFactors',
        subBuilder: UserAuthFactors.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPreferencesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPreferencesResponse copyWith(
          void Function(UpdateUserPreferencesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateUserPreferencesResponse))
          as UpdateUserPreferencesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserPreferencesResponse create() =>
      UpdateUserPreferencesResponse._();
  @$core.override
  UpdateUserPreferencesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserPreferencesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserPreferencesResponse>(create);
  static UpdateUserPreferencesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UserPreferences get preferences => $_getN(0);
  @$pb.TagNumber(1)
  set preferences(UserPreferences value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferences() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferences() => $_clearField(1);
  @$pb.TagNumber(1)
  UserPreferences ensurePreferences() => $_ensure(0);

  @$pb.TagNumber(2)
  UserAuthFactors get authFactors => $_getN(1);
  @$pb.TagNumber(2)
  set authFactors(UserAuthFactors value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthFactors() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthFactors() => $_clearField(2);
  @$pb.TagNumber(2)
  UserAuthFactors ensureAuthFactors() => $_ensure(1);
}

class RequestEmailLoginRequest extends $pb.GeneratedMessage {
  factory RequestEmailLoginRequest({
    $core.String? email,
  }) {
    final result = create();
    if (email != null) result.email = email;
    return result;
  }

  RequestEmailLoginRequest._();

  factory RequestEmailLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestEmailLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestEmailLoginRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestEmailLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestEmailLoginRequest copyWith(
          void Function(RequestEmailLoginRequest) updates) =>
      super.copyWith((message) => updates(message as RequestEmailLoginRequest))
          as RequestEmailLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestEmailLoginRequest create() => RequestEmailLoginRequest._();
  @$core.override
  RequestEmailLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestEmailLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestEmailLoginRequest>(create);
  static RequestEmailLoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class RequestEmailLoginResponse extends $pb.GeneratedMessage {
  factory RequestEmailLoginResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  RequestEmailLoginResponse._();

  factory RequestEmailLoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestEmailLoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestEmailLoginResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestEmailLoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestEmailLoginResponse copyWith(
          void Function(RequestEmailLoginResponse) updates) =>
      super.copyWith((message) => updates(message as RequestEmailLoginResponse))
          as RequestEmailLoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestEmailLoginResponse create() => RequestEmailLoginResponse._();
  @$core.override
  RequestEmailLoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestEmailLoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestEmailLoginResponse>(create);
  static RequestEmailLoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class RequestMfaEmailCodeRequest extends $pb.GeneratedMessage {
  factory RequestMfaEmailCodeRequest({
    $core.String? mfaSessionId,
  }) {
    final result = create();
    if (mfaSessionId != null) result.mfaSessionId = mfaSessionId;
    return result;
  }

  RequestMfaEmailCodeRequest._();

  factory RequestMfaEmailCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMfaEmailCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMfaEmailCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mfaSessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMfaEmailCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMfaEmailCodeRequest copyWith(
          void Function(RequestMfaEmailCodeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RequestMfaEmailCodeRequest))
          as RequestMfaEmailCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMfaEmailCodeRequest create() => RequestMfaEmailCodeRequest._();
  @$core.override
  RequestMfaEmailCodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMfaEmailCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMfaEmailCodeRequest>(create);
  static RequestMfaEmailCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mfaSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mfaSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMfaSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMfaSessionId() => $_clearField(1);
}

class RequestMfaEmailCodeResponse extends $pb.GeneratedMessage {
  factory RequestMfaEmailCodeResponse({
    $core.String? message,
    $core.String? maskedEmail,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (maskedEmail != null) result.maskedEmail = maskedEmail;
    return result;
  }

  RequestMfaEmailCodeResponse._();

  factory RequestMfaEmailCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestMfaEmailCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestMfaEmailCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aOS(2, _omitFieldNames ? '' : 'maskedEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMfaEmailCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestMfaEmailCodeResponse copyWith(
          void Function(RequestMfaEmailCodeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RequestMfaEmailCodeResponse))
          as RequestMfaEmailCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestMfaEmailCodeResponse create() =>
      RequestMfaEmailCodeResponse._();
  @$core.override
  RequestMfaEmailCodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestMfaEmailCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestMfaEmailCodeResponse>(create);
  static RequestMfaEmailCodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get maskedEmail => $_getSZ(1);
  @$pb.TagNumber(2)
  set maskedEmail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaskedEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaskedEmail() => $_clearField(2);
}

class VerifyMfaEmailCodeRequest extends $pb.GeneratedMessage {
  factory VerifyMfaEmailCodeRequest({
    $core.String? mfaSessionId,
    $core.String? emailToken,
  }) {
    final result = create();
    if (mfaSessionId != null) result.mfaSessionId = mfaSessionId;
    if (emailToken != null) result.emailToken = emailToken;
    return result;
  }

  VerifyMfaEmailCodeRequest._();

  factory VerifyMfaEmailCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyMfaEmailCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyMfaEmailCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mfaSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'emailToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyMfaEmailCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyMfaEmailCodeRequest copyWith(
          void Function(VerifyMfaEmailCodeRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyMfaEmailCodeRequest))
          as VerifyMfaEmailCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyMfaEmailCodeRequest create() => VerifyMfaEmailCodeRequest._();
  @$core.override
  VerifyMfaEmailCodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyMfaEmailCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyMfaEmailCodeRequest>(create);
  static VerifyMfaEmailCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mfaSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mfaSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMfaSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMfaSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get emailToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set emailToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmailToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmailToken() => $_clearField(2);
}

class StartMfaPasskeyRequest extends $pb.GeneratedMessage {
  factory StartMfaPasskeyRequest({
    $core.String? mfaSessionId,
  }) {
    final result = create();
    if (mfaSessionId != null) result.mfaSessionId = mfaSessionId;
    return result;
  }

  StartMfaPasskeyRequest._();

  factory StartMfaPasskeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartMfaPasskeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartMfaPasskeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mfaSessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMfaPasskeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMfaPasskeyRequest copyWith(
          void Function(StartMfaPasskeyRequest) updates) =>
      super.copyWith((message) => updates(message as StartMfaPasskeyRequest))
          as StartMfaPasskeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartMfaPasskeyRequest create() => StartMfaPasskeyRequest._();
  @$core.override
  StartMfaPasskeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartMfaPasskeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartMfaPasskeyRequest>(create);
  static StartMfaPasskeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mfaSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mfaSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMfaSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMfaSessionId() => $_clearField(1);
}

class StartMfaPasskeyResponse extends $pb.GeneratedMessage {
  factory StartMfaPasskeyResponse({
    $core.String? passkeySessionId,
    $core.List<$core.int>? options,
  }) {
    final result = create();
    if (passkeySessionId != null) result.passkeySessionId = passkeySessionId;
    if (options != null) result.options = options;
    return result;
  }

  StartMfaPasskeyResponse._();

  factory StartMfaPasskeyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartMfaPasskeyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartMfaPasskeyResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'passkeySessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'options', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMfaPasskeyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartMfaPasskeyResponse copyWith(
          void Function(StartMfaPasskeyResponse) updates) =>
      super.copyWith((message) => updates(message as StartMfaPasskeyResponse))
          as StartMfaPasskeyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartMfaPasskeyResponse create() => StartMfaPasskeyResponse._();
  @$core.override
  StartMfaPasskeyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartMfaPasskeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartMfaPasskeyResponse>(create);
  static StartMfaPasskeyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get passkeySessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set passkeySessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPasskeySessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPasskeySessionId() => $_clearField(1);

  /// WebAuthn PublicKeyCredentialRequestOptions JSON.
  @$pb.TagNumber(2)
  $core.List<$core.int> get options => $_getN(1);
  @$pb.TagNumber(2)
  set options($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptions() => $_clearField(2);
}

class FinishMfaPasskeyRequest extends $pb.GeneratedMessage {
  factory FinishMfaPasskeyRequest({
    $core.String? mfaSessionId,
    $core.String? passkeySessionId,
    $core.List<$core.int>? credential,
  }) {
    final result = create();
    if (mfaSessionId != null) result.mfaSessionId = mfaSessionId;
    if (passkeySessionId != null) result.passkeySessionId = passkeySessionId;
    if (credential != null) result.credential = credential;
    return result;
  }

  FinishMfaPasskeyRequest._();

  factory FinishMfaPasskeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishMfaPasskeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishMfaPasskeyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mfaSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'passkeySessionId')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'credential', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishMfaPasskeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishMfaPasskeyRequest copyWith(
          void Function(FinishMfaPasskeyRequest) updates) =>
      super.copyWith((message) => updates(message as FinishMfaPasskeyRequest))
          as FinishMfaPasskeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishMfaPasskeyRequest create() => FinishMfaPasskeyRequest._();
  @$core.override
  FinishMfaPasskeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishMfaPasskeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishMfaPasskeyRequest>(create);
  static FinishMfaPasskeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mfaSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mfaSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMfaSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMfaSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get passkeySessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set passkeySessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPasskeySessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPasskeySessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get credential => $_getN(2);
  @$pb.TagNumber(3)
  set credential($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredential() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredential() => $_clearField(3);
}

class RefreshTokenRequest extends $pb.GeneratedMessage {
  factory RefreshTokenRequest({
    $core.String? refreshToken,
  }) {
    final result = create();
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  RefreshTokenRequest._();

  factory RefreshTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefreshTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefreshTokenRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokenRequest copyWith(void Function(RefreshTokenRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshTokenRequest))
          as RefreshTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest create() => RefreshTokenRequest._();
  @$core.override
  RefreshTokenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshTokenRequest>(create);
  static RefreshTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refreshToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set refreshToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefreshToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefreshToken() => $_clearField(1);
}

class RefreshTokenResponse extends $pb.GeneratedMessage {
  factory RefreshTokenResponse({
    $core.String? accessToken,
    $core.String? refreshToken,
  }) {
    final result = create();
    if (accessToken != null) result.accessToken = accessToken;
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  RefreshTokenResponse._();

  factory RefreshTokenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefreshTokenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefreshTokenResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accessToken')
    ..aOS(2, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefreshTokenResponse copyWith(void Function(RefreshTokenResponse) updates) =>
      super.copyWith((message) => updates(message as RefreshTokenResponse))
          as RefreshTokenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefreshTokenResponse create() => RefreshTokenResponse._();
  @$core.override
  RefreshTokenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefreshTokenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshTokenResponse>(create);
  static RefreshTokenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set accessToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccessToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get refreshToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set refreshToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefreshToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefreshToken() => $_clearField(2);
}

class GetProfileRequest extends $pb.GeneratedMessage {
  factory GetProfileRequest() => create();

  GetProfileRequest._();

  factory GetProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProfileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProfileRequest copyWith(void Function(GetProfileRequest) updates) =>
      super.copyWith((message) => updates(message as GetProfileRequest))
          as GetProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProfileRequest create() => GetProfileRequest._();
  @$core.override
  GetProfileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProfileRequest>(create);
  static GetProfileRequest? _defaultInstance;
}

class GetProfileResponse extends $pb.GeneratedMessage {
  factory GetProfileResponse({
    User? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  GetProfileResponse._();

  factory GetProfileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProfileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProfileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProfileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProfileResponse copyWith(void Function(GetProfileResponse) updates) =>
      super.copyWith((message) => updates(message as GetProfileResponse))
          as GetProfileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProfileResponse create() => GetProfileResponse._();
  @$core.override
  GetProfileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProfileResponse>(create);
  static GetProfileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class CloseAccountRequest extends $pb.GeneratedMessage {
  factory CloseAccountRequest() => create();

  CloseAccountRequest._();

  factory CloseAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseAccountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountRequest copyWith(void Function(CloseAccountRequest) updates) =>
      super.copyWith((message) => updates(message as CloseAccountRequest))
          as CloseAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseAccountRequest create() => CloseAccountRequest._();
  @$core.override
  CloseAccountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseAccountRequest>(create);
  static CloseAccountRequest? _defaultInstance;
}

class CloseAccountResponse extends $pb.GeneratedMessage {
  factory CloseAccountResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  CloseAccountResponse._();

  factory CloseAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseAccountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountResponse copyWith(void Function(CloseAccountResponse) updates) =>
      super.copyWith((message) => updates(message as CloseAccountResponse))
          as CloseAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseAccountResponse create() => CloseAccountResponse._();
  @$core.override
  CloseAccountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseAccountResponse>(create);
  static CloseAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class StartOpaquePasswordUpdateRequest extends $pb.GeneratedMessage {
  factory StartOpaquePasswordUpdateRequest({
    $core.List<$core.int>? credentialRequest,
    $core.List<$core.int>? registrationRequest,
    OpaquePasswordUpdateVerificationMethod? verificationMethod,
    $core.String? emailToken,
  }) {
    final result = create();
    if (credentialRequest != null) result.credentialRequest = credentialRequest;
    if (registrationRequest != null)
      result.registrationRequest = registrationRequest;
    if (verificationMethod != null)
      result.verificationMethod = verificationMethod;
    if (emailToken != null) result.emailToken = emailToken;
    return result;
  }

  StartOpaquePasswordUpdateRequest._();

  factory StartOpaquePasswordUpdateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaquePasswordUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaquePasswordUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'credentialRequest', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'registrationRequest', $pb.PbFieldType.OY)
    ..aE<OpaquePasswordUpdateVerificationMethod>(
        4, _omitFieldNames ? '' : 'verificationMethod',
        enumValues: OpaquePasswordUpdateVerificationMethod.values)
    ..aOS(6, _omitFieldNames ? '' : 'emailToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordUpdateRequest copyWith(
          void Function(StartOpaquePasswordUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartOpaquePasswordUpdateRequest))
          as StartOpaquePasswordUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordUpdateRequest create() =>
      StartOpaquePasswordUpdateRequest._();
  @$core.override
  StartOpaquePasswordUpdateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaquePasswordUpdateRequest>(
          create);
  static StartOpaquePasswordUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get credentialRequest => $_getN(0);
  @$pb.TagNumber(1)
  set credentialRequest($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCredentialRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentialRequest() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationRequest => $_getN(1);
  @$pb.TagNumber(2)
  set registrationRequest($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationRequest() => $_clearField(2);

  @$pb.TagNumber(4)
  OpaquePasswordUpdateVerificationMethod get verificationMethod => $_getN(2);
  @$pb.TagNumber(4)
  set verificationMethod(OpaquePasswordUpdateVerificationMethod value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVerificationMethod() => $_has(2);
  @$pb.TagNumber(4)
  void clearVerificationMethod() => $_clearField(4);

  @$pb.TagNumber(6)
  $core.String get emailToken => $_getSZ(3);
  @$pb.TagNumber(6)
  set emailToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(6)
  $core.bool hasEmailToken() => $_has(3);
  @$pb.TagNumber(6)
  void clearEmailToken() => $_clearField(6);
}

class StartOpaquePasswordUpdateResponse extends $pb.GeneratedMessage {
  factory StartOpaquePasswordUpdateResponse({
    $core.String? sessionId,
    $core.List<$core.int>? credentialResponse,
    $core.List<$core.int>? registrationResponse,
    $core.String? passkeySessionId,
    $core.List<$core.int>? passkeyOptions,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credentialResponse != null)
      result.credentialResponse = credentialResponse;
    if (registrationResponse != null)
      result.registrationResponse = registrationResponse;
    if (passkeySessionId != null) result.passkeySessionId = passkeySessionId;
    if (passkeyOptions != null) result.passkeyOptions = passkeyOptions;
    return result;
  }

  StartOpaquePasswordUpdateResponse._();

  factory StartOpaquePasswordUpdateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaquePasswordUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaquePasswordUpdateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credentialResponse', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'registrationResponse', $pb.PbFieldType.OY)
    ..aOS(4, _omitFieldNames ? '' : 'passkeySessionId')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'passkeyOptions', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordUpdateResponse copyWith(
          void Function(StartOpaquePasswordUpdateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as StartOpaquePasswordUpdateResponse))
          as StartOpaquePasswordUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordUpdateResponse create() =>
      StartOpaquePasswordUpdateResponse._();
  @$core.override
  StartOpaquePasswordUpdateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaquePasswordUpdateResponse>(
          create);
  static StartOpaquePasswordUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credentialResponse => $_getN(1);
  @$pb.TagNumber(2)
  set credentialResponse($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredentialResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredentialResponse() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get registrationResponse => $_getN(2);
  @$pb.TagNumber(3)
  set registrationResponse($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegistrationResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegistrationResponse() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get passkeySessionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set passkeySessionId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPasskeySessionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPasskeySessionId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get passkeyOptions => $_getN(4);
  @$pb.TagNumber(5)
  set passkeyOptions($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPasskeyOptions() => $_has(4);
  @$pb.TagNumber(5)
  void clearPasskeyOptions() => $_clearField(5);
}

class FinishOpaquePasswordUpdateRequest extends $pb.GeneratedMessage {
  factory FinishOpaquePasswordUpdateRequest({
    $core.String? sessionId,
    $core.List<$core.int>? credentialFinalization,
    $core.List<$core.int>? registrationUpload,
    $core.String? passkeySessionId,
    $core.List<$core.int>? passkeyCredential,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (credentialFinalization != null)
      result.credentialFinalization = credentialFinalization;
    if (registrationUpload != null)
      result.registrationUpload = registrationUpload;
    if (passkeySessionId != null) result.passkeySessionId = passkeySessionId;
    if (passkeyCredential != null) result.passkeyCredential = passkeyCredential;
    return result;
  }

  FinishOpaquePasswordUpdateRequest._();

  factory FinishOpaquePasswordUpdateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishOpaquePasswordUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishOpaquePasswordUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'credentialFinalization', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'registrationUpload', $pb.PbFieldType.OY)
    ..aOS(5, _omitFieldNames ? '' : 'passkeySessionId')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'passkeyCredential', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaquePasswordUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaquePasswordUpdateRequest copyWith(
          void Function(FinishOpaquePasswordUpdateRequest) updates) =>
      super.copyWith((message) =>
              updates(message as FinishOpaquePasswordUpdateRequest))
          as FinishOpaquePasswordUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishOpaquePasswordUpdateRequest create() =>
      FinishOpaquePasswordUpdateRequest._();
  @$core.override
  FinishOpaquePasswordUpdateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishOpaquePasswordUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishOpaquePasswordUpdateRequest>(
          create);
  static FinishOpaquePasswordUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get credentialFinalization => $_getN(1);
  @$pb.TagNumber(2)
  set credentialFinalization($core.List<$core.int> value) =>
      $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCredentialFinalization() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredentialFinalization() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get registrationUpload => $_getN(2);
  @$pb.TagNumber(3)
  set registrationUpload($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegistrationUpload() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegistrationUpload() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.String get passkeySessionId => $_getSZ(3);
  @$pb.TagNumber(5)
  set passkeySessionId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasPasskeySessionId() => $_has(3);
  @$pb.TagNumber(5)
  void clearPasskeySessionId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get passkeyCredential => $_getN(4);
  @$pb.TagNumber(6)
  set passkeyCredential($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(6)
  $core.bool hasPasskeyCredential() => $_has(4);
  @$pb.TagNumber(6)
  void clearPasskeyCredential() => $_clearField(6);
}

class FinishOpaquePasswordUpdateResponse extends $pb.GeneratedMessage {
  factory FinishOpaquePasswordUpdateResponse({
    User? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  FinishOpaquePasswordUpdateResponse._();

  factory FinishOpaquePasswordUpdateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishOpaquePasswordUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishOpaquePasswordUpdateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaquePasswordUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaquePasswordUpdateResponse copyWith(
          void Function(FinishOpaquePasswordUpdateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as FinishOpaquePasswordUpdateResponse))
          as FinishOpaquePasswordUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishOpaquePasswordUpdateResponse create() =>
      FinishOpaquePasswordUpdateResponse._();
  @$core.override
  FinishOpaquePasswordUpdateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishOpaquePasswordUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishOpaquePasswordUpdateResponse>(
          create);
  static FinishOpaquePasswordUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class CreateWebSocketTicketRequest extends $pb.GeneratedMessage {
  factory CreateWebSocketTicketRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CreateWebSocketTicketRequest._();

  factory CreateWebSocketTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateWebSocketTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWebSocketTicketRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebSocketTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebSocketTicketRequest copyWith(
          void Function(CreateWebSocketTicketRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CreateWebSocketTicketRequest))
          as CreateWebSocketTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateWebSocketTicketRequest create() =>
      CreateWebSocketTicketRequest._();
  @$core.override
  CreateWebSocketTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateWebSocketTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWebSocketTicketRequest>(create);
  static CreateWebSocketTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class CreateWebSocketTicketResponse extends $pb.GeneratedMessage {
  factory CreateWebSocketTicketResponse({
    $core.String? ticket,
    $core.String? roomId,
    $fixnum.Int64? expiresInSecs,
    $core.String? usage,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    if (roomId != null) result.roomId = roomId;
    if (expiresInSecs != null) result.expiresInSecs = expiresInSecs;
    if (usage != null) result.usage = usage;
    return result;
  }

  CreateWebSocketTicketResponse._();

  factory CreateWebSocketTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateWebSocketTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateWebSocketTicketResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticket')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'expiresInSecs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, _omitFieldNames ? '' : 'usage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebSocketTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateWebSocketTicketResponse copyWith(
          void Function(CreateWebSocketTicketResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CreateWebSocketTicketResponse))
          as CreateWebSocketTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateWebSocketTicketResponse create() =>
      CreateWebSocketTicketResponse._();
  @$core.override
  CreateWebSocketTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateWebSocketTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateWebSocketTicketResponse>(create);
  static CreateWebSocketTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticket => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticket($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresInSecs => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresInSecs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresInSecs() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresInSecs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get usage => $_getSZ(3);
  @$pb.TagNumber(4)
  set usage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsage() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsage() => $_clearField(4);
}

class CreateGuestTokenRequest extends $pb.GeneratedMessage {
  factory CreateGuestTokenRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CreateGuestTokenRequest._();

  factory CreateGuestTokenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateGuestTokenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateGuestTokenRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGuestTokenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGuestTokenRequest copyWith(
          void Function(CreateGuestTokenRequest) updates) =>
      super.copyWith((message) => updates(message as CreateGuestTokenRequest))
          as CreateGuestTokenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateGuestTokenRequest create() => CreateGuestTokenRequest._();
  @$core.override
  CreateGuestTokenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateGuestTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateGuestTokenRequest>(create);
  static CreateGuestTokenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class CreateGuestTokenResponse extends $pb.GeneratedMessage {
  factory CreateGuestTokenResponse({
    $core.String? token,
    $core.String? roomId,
    $core.String? guestId,
    $core.String? displayName,
    $fixnum.Int64? expiresAt,
    $fixnum.Int64? expiresInSecs,
    $core.String? usage,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (roomId != null) result.roomId = roomId;
    if (guestId != null) result.guestId = guestId;
    if (displayName != null) result.displayName = displayName;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (expiresInSecs != null) result.expiresInSecs = expiresInSecs;
    if (usage != null) result.usage = usage;
    return result;
  }

  CreateGuestTokenResponse._();

  factory CreateGuestTokenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateGuestTokenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateGuestTokenResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'guestId')
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aInt64(5, _omitFieldNames ? '' : 'expiresAt')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'expiresInSecs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, _omitFieldNames ? '' : 'usage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGuestTokenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateGuestTokenResponse copyWith(
          void Function(CreateGuestTokenResponse) updates) =>
      super.copyWith((message) => updates(message as CreateGuestTokenResponse))
          as CreateGuestTokenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateGuestTokenResponse create() => CreateGuestTokenResponse._();
  @$core.override
  CreateGuestTokenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateGuestTokenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateGuestTokenResponse>(create);
  static CreateGuestTokenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get guestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set guestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGuestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGuestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiresAt => $_getI64(4);
  @$pb.TagNumber(5)
  set expiresAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiresInSecs => $_getI64(5);
  @$pb.TagNumber(6)
  set expiresInSecs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresInSecs() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresInSecs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get usage => $_getSZ(6);
  @$pb.TagNumber(7)
  set usage($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUsage() => $_has(6);
  @$pb.TagNumber(7)
  void clearUsage() => $_clearField(7);
}

class WebSocketConnectRequest extends $pb.GeneratedMessage {
  factory WebSocketConnectRequest({
    $core.String? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  WebSocketConnectRequest._();

  factory WebSocketConnectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebSocketConnectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebSocketConnectRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticket')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebSocketConnectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebSocketConnectRequest copyWith(
          void Function(WebSocketConnectRequest) updates) =>
      super.copyWith((message) => updates(message as WebSocketConnectRequest))
          as WebSocketConnectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebSocketConnectRequest create() => WebSocketConnectRequest._();
  @$core.override
  WebSocketConnectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebSocketConnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebSocketConnectRequest>(create);
  static WebSocketConnectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticket => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticket($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
}

/// Room Management Messages
class CreateRoomRequest extends $pb.GeneratedMessage {
  factory CreateRoomRequest({
    $core.String? name,
    $core.String? password,
    $core.List<$core.int>? settings,
    $core.String? description,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (password != null) result.password = password;
    if (settings != null) result.settings = settings;
    if (description != null) result.description = description;
    return result;
  }

  CreateRoomRequest._();

  factory CreateRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomRequest copyWith(void Function(CreateRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRoomRequest))
          as CreateRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest create() => CreateRoomRequest._();
  @$core.override
  CreateRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomRequest>(create);
  static CreateRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get settings => $_getN(2);
  @$pb.TagNumber(3)
  set settings($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSettings() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettings() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);
}

class CreateRoomResponse extends $pb.GeneratedMessage {
  factory CreateRoomResponse({
    Room? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  CreateRoomResponse._();

  factory CreateRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoomResponse copyWith(void Function(CreateRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CreateRoomResponse))
          as CreateRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse create() => CreateRoomResponse._();
  @$core.override
  CreateRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRoomResponse>(create);
  static CreateRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);
}

/// Note: UserService room-scoped resource request; room_id is carried in payload.
class GetRoomRequest extends $pb.GeneratedMessage {
  factory GetRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  GetRoomRequest._();

  factory GetRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomRequest copyWith(void Function(GetRoomRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomRequest))
          as GetRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomRequest create() => GetRoomRequest._();
  @$core.override
  GetRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomRequest>(create);
  static GetRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class GetRoomResponse extends $pb.GeneratedMessage {
  factory GetRoomResponse({
    Room? room,
    PlaybackState? playbackState,
  }) {
    final result = create();
    if (room != null) result.room = room;
    if (playbackState != null) result.playbackState = playbackState;
    return result;
  }

  GetRoomResponse._();

  factory GetRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..aOM<PlaybackState>(2, _omitFieldNames ? '' : 'playbackState',
        subBuilder: PlaybackState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomResponse copyWith(void Function(GetRoomResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomResponse))
          as GetRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomResponse create() => GetRoomResponse._();
  @$core.override
  GetRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomResponse>(create);
  static GetRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  PlaybackState get playbackState => $_getN(1);
  @$pb.TagNumber(2)
  set playbackState(PlaybackState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaybackState() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaybackState() => $_clearField(2);
  @$pb.TagNumber(2)
  PlaybackState ensurePlaybackState() => $_ensure(1);
}

class JoinRoomRequest extends $pb.GeneratedMessage {
  factory JoinRoomRequest({
    $core.String? password,
    $core.String? roomId,
  }) {
    final result = create();
    if (password != null) result.password = password;
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  JoinRoomRequest._();

  factory JoinRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'password')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomRequest copyWith(void Function(JoinRoomRequest) updates) =>
      super.copyWith((message) => updates(message as JoinRoomRequest))
          as JoinRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest create() => JoinRoomRequest._();
  @$core.override
  JoinRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomRequest>(create);
  static JoinRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get password => $_getSZ(0);
  @$pb.TagNumber(1)
  set password($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);
}

class JoinRoomResponse extends $pb.GeneratedMessage {
  factory JoinRoomResponse({
    Room? room,
    PlaybackState? playbackState,
    $core.Iterable<$1.RoomMember>? members,
    $1.MemberStatus? membershipStatus,
    $core.bool? requiresApproval,
  }) {
    final result = create();
    if (room != null) result.room = room;
    if (playbackState != null) result.playbackState = playbackState;
    if (members != null) result.members.addAll(members);
    if (membershipStatus != null) result.membershipStatus = membershipStatus;
    if (requiresApproval != null) result.requiresApproval = requiresApproval;
    return result;
  }

  JoinRoomResponse._();

  factory JoinRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..aOM<PlaybackState>(2, _omitFieldNames ? '' : 'playbackState',
        subBuilder: PlaybackState.create)
    ..pPM<$1.RoomMember>(3, _omitFieldNames ? '' : 'members',
        subBuilder: $1.RoomMember.create)
    ..aE<$1.MemberStatus>(4, _omitFieldNames ? '' : 'membershipStatus',
        enumValues: $1.MemberStatus.values)
    ..aOB(5, _omitFieldNames ? '' : 'requiresApproval')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinRoomResponse copyWith(void Function(JoinRoomResponse) updates) =>
      super.copyWith((message) => updates(message as JoinRoomResponse))
          as JoinRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse create() => JoinRoomResponse._();
  @$core.override
  JoinRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinRoomResponse>(create);
  static JoinRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  PlaybackState get playbackState => $_getN(1);
  @$pb.TagNumber(2)
  set playbackState(PlaybackState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaybackState() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaybackState() => $_clearField(2);
  @$pb.TagNumber(2)
  PlaybackState ensurePlaybackState() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$1.RoomMember> get members => $_getList(2);

  @$pb.TagNumber(4)
  $1.MemberStatus get membershipStatus => $_getN(3);
  @$pb.TagNumber(4)
  set membershipStatus($1.MemberStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMembershipStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearMembershipStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get requiresApproval => $_getBF(4);
  @$pb.TagNumber(5)
  set requiresApproval($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequiresApproval() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequiresApproval() => $_clearField(5);
}

class LeaveRoomRequest extends $pb.GeneratedMessage {
  factory LeaveRoomRequest() => create();

  LeaveRoomRequest._();

  factory LeaveRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomRequest copyWith(void Function(LeaveRoomRequest) updates) =>
      super.copyWith((message) => updates(message as LeaveRoomRequest))
          as LeaveRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest create() => LeaveRoomRequest._();
  @$core.override
  LeaveRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveRoomRequest>(create);
  static LeaveRoomRequest? _defaultInstance;
}

class LeaveRoomResponse extends $pb.GeneratedMessage {
  factory LeaveRoomResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  LeaveRoomResponse._();

  factory LeaveRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LeaveRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LeaveRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LeaveRoomResponse copyWith(void Function(LeaveRoomResponse) updates) =>
      super.copyWith((message) => updates(message as LeaveRoomResponse))
          as LeaveRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse create() => LeaveRoomResponse._();
  @$core.override
  LeaveRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LeaveRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LeaveRoomResponse>(create);
  static LeaveRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ListRoomsRequest extends $pb.GeneratedMessage {
  factory ListRoomsRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    RoomListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListRoomsRequest._();

  factory ListRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'search')
    ..aE<RoomListSortBy>(4, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomListSortBy.values)
    ..aE<SortDirection>(5, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsRequest copyWith(void Function(ListRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRoomsRequest))
          as ListRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomsRequest create() => ListRoomsRequest._();
  @$core.override
  ListRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomsRequest>(create);
  static ListRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get search => $_getSZ(2);
  @$pb.TagNumber(3)
  set search($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSearch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearch() => $_clearField(3);

  @$pb.TagNumber(4)
  RoomListSortBy get sortBy => $_getN(3);
  @$pb.TagNumber(4)
  set sortBy(RoomListSortBy value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSortBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearSortBy() => $_clearField(4);

  @$pb.TagNumber(5)
  SortDirection get sortDirection => $_getN(4);
  @$pb.TagNumber(5)
  set sortDirection(SortDirection value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSortDirection() => $_has(4);
  @$pb.TagNumber(5)
  void clearSortDirection() => $_clearField(5);
}

class ListRoomsResponse extends $pb.GeneratedMessage {
  factory ListRoomsResponse({
    $core.Iterable<Room>? rooms,
    $core.int? total,
  }) {
    final result = create();
    if (rooms != null) result.rooms.addAll(rooms);
    if (total != null) result.total = total;
    return result;
  }

  ListRoomsResponse._();

  factory ListRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<Room>(1, _omitFieldNames ? '' : 'rooms', subBuilder: Room.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomsResponse copyWith(void Function(ListRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRoomsResponse))
          as ListRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomsResponse create() => ListRoomsResponse._();
  @$core.override
  ListRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomsResponse>(create);
  static ListRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Room> get rooms => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class DeleteRoomRequest extends $pb.GeneratedMessage {
  factory DeleteRoomRequest() => create();

  DeleteRoomRequest._();

  factory DeleteRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomRequest copyWith(void Function(DeleteRoomRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRoomRequest))
          as DeleteRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoomRequest create() => DeleteRoomRequest._();
  @$core.override
  DeleteRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoomRequest>(create);
  static DeleteRoomRequest? _defaultInstance;
}

class DeleteRoomResponse extends $pb.GeneratedMessage {
  factory DeleteRoomResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteRoomResponse._();

  factory DeleteRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomResponse copyWith(void Function(DeleteRoomResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteRoomResponse))
          as DeleteRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoomResponse create() => DeleteRoomResponse._();
  @$core.override
  DeleteRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoomResponse>(create);
  static DeleteRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class UpdateRoomSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateRoomSettingsRequest({
    $core.List<$core.int>? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  UpdateRoomSettingsRequest._();

  factory UpdateRoomSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomSettingsRequest copyWith(
          void Function(UpdateRoomSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomSettingsRequest))
          as UpdateRoomSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomSettingsRequest create() => UpdateRoomSettingsRequest._();
  @$core.override
  UpdateRoomSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomSettingsRequest>(create);
  static UpdateRoomSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
}

class UpdateRoomSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateRoomSettingsResponse({
    Room? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  UpdateRoomSettingsResponse._();

  factory UpdateRoomSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomSettingsResponse copyWith(
          void Function(UpdateRoomSettingsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateRoomSettingsResponse))
          as UpdateRoomSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomSettingsResponse create() => UpdateRoomSettingsResponse._();
  @$core.override
  UpdateRoomSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomSettingsResponse>(create);
  static UpdateRoomSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);
}

/// Get room settings
class GetRoomSettingsRequest extends $pb.GeneratedMessage {
  factory GetRoomSettingsRequest() => create();

  GetRoomSettingsRequest._();

  factory GetRoomSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomSettingsRequest copyWith(
          void Function(GetRoomSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomSettingsRequest))
          as GetRoomSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomSettingsRequest create() => GetRoomSettingsRequest._();
  @$core.override
  GetRoomSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomSettingsRequest>(create);
  static GetRoomSettingsRequest? _defaultInstance;
}

class GetRoomSettingsResponse extends $pb.GeneratedMessage {
  factory GetRoomSettingsResponse({
    $core.List<$core.int>? settings,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    if (version != null) result.version = version;
    return result;
  }

  GetRoomSettingsResponse._();

  factory GetRoomSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomSettingsResponse copyWith(
          void Function(GetRoomSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomSettingsResponse))
          as GetRoomSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomSettingsResponse create() => GetRoomSettingsResponse._();
  @$core.override
  GetRoomSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomSettingsResponse>(create);
  static GetRoomSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

/// Reset room settings to default
class ResetRoomSettingsRequest extends $pb.GeneratedMessage {
  factory ResetRoomSettingsRequest() => create();

  ResetRoomSettingsRequest._();

  factory ResetRoomSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetRoomSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetRoomSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetRoomSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetRoomSettingsRequest copyWith(
          void Function(ResetRoomSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as ResetRoomSettingsRequest))
          as ResetRoomSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetRoomSettingsRequest create() => ResetRoomSettingsRequest._();
  @$core.override
  ResetRoomSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResetRoomSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetRoomSettingsRequest>(create);
  static ResetRoomSettingsRequest? _defaultInstance;
}

class ResetRoomSettingsResponse extends $pb.GeneratedMessage {
  factory ResetRoomSettingsResponse({
    $core.List<$core.int>? settings,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    return result;
  }

  ResetRoomSettingsResponse._();

  factory ResetRoomSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetRoomSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetRoomSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetRoomSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetRoomSettingsResponse copyWith(
          void Function(ResetRoomSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as ResetRoomSettingsResponse))
          as ResetRoomSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetRoomSettingsResponse create() => ResetRoomSettingsResponse._();
  @$core.override
  ResetRoomSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResetRoomSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResetRoomSettingsResponse>(create);
  static ResetRoomSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
}

class TransferRoomOwnershipRequest extends $pb.GeneratedMessage {
  factory TransferRoomOwnershipRequest({
    $core.String? newOwnerUserId,
  }) {
    final result = create();
    if (newOwnerUserId != null) result.newOwnerUserId = newOwnerUserId;
    return result;
  }

  TransferRoomOwnershipRequest._();

  factory TransferRoomOwnershipRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferRoomOwnershipRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferRoomOwnershipRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'newOwnerUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRoomOwnershipRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRoomOwnershipRequest copyWith(
          void Function(TransferRoomOwnershipRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TransferRoomOwnershipRequest))
          as TransferRoomOwnershipRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferRoomOwnershipRequest create() =>
      TransferRoomOwnershipRequest._();
  @$core.override
  TransferRoomOwnershipRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferRoomOwnershipRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferRoomOwnershipRequest>(create);
  static TransferRoomOwnershipRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get newOwnerUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set newOwnerUserId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNewOwnerUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewOwnerUserId() => $_clearField(1);
}

class TransferRoomOwnershipResponse extends $pb.GeneratedMessage {
  factory TransferRoomOwnershipResponse({
    Room? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  TransferRoomOwnershipResponse._();

  factory TransferRoomOwnershipResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferRoomOwnershipResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferRoomOwnershipResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRoomOwnershipResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRoomOwnershipResponse copyWith(
          void Function(TransferRoomOwnershipResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TransferRoomOwnershipResponse))
          as TransferRoomOwnershipResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferRoomOwnershipResponse create() =>
      TransferRoomOwnershipResponse._();
  @$core.override
  TransferRoomOwnershipResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferRoomOwnershipResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferRoomOwnershipResponse>(create);
  static TransferRoomOwnershipResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);
}

/// Room Password Messages
class SetRoomPasswordRequest extends $pb.GeneratedMessage {
  factory SetRoomPasswordRequest({
    $core.String? password,
  }) {
    final result = create();
    if (password != null) result.password = password;
    return result;
  }

  SetRoomPasswordRequest._();

  factory SetRoomPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetRoomPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetRoomPasswordRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRoomPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRoomPasswordRequest copyWith(
          void Function(SetRoomPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as SetRoomPasswordRequest))
          as SetRoomPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetRoomPasswordRequest create() => SetRoomPasswordRequest._();
  @$core.override
  SetRoomPasswordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetRoomPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetRoomPasswordRequest>(create);
  static SetRoomPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get password => $_getSZ(0);
  @$pb.TagNumber(1)
  set password($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassword() => $_clearField(1);
}

class SetRoomPasswordResponse extends $pb.GeneratedMessage {
  factory SetRoomPasswordResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SetRoomPasswordResponse._();

  factory SetRoomPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetRoomPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetRoomPasswordResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRoomPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetRoomPasswordResponse copyWith(
          void Function(SetRoomPasswordResponse) updates) =>
      super.copyWith((message) => updates(message as SetRoomPasswordResponse))
          as SetRoomPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetRoomPasswordResponse create() => SetRoomPasswordResponse._();
  @$core.override
  SetRoomPasswordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetRoomPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetRoomPasswordResponse>(create);
  static SetRoomPasswordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// Room Members Messages
/// Note: room_id extracted from x-room-id metadata
class GetRoomMembersRequest extends $pb.GeneratedMessage {
  factory GetRoomMembersRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    $1.RoomMemberRole? role,
    RoomMemberListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (role != null) result.role = role;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  GetRoomMembersRequest._();

  factory GetRoomMembersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomMembersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomMembersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'search')
    ..aE<$1.RoomMemberRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..aE<RoomMemberListSortBy>(6, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomMemberListSortBy.values)
    ..aE<SortDirection>(7, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersRequest copyWith(
          void Function(GetRoomMembersRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomMembersRequest))
          as GetRoomMembersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomMembersRequest create() => GetRoomMembersRequest._();
  @$core.override
  GetRoomMembersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomMembersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomMembersRequest>(create);
  static GetRoomMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get search => $_getSZ(2);
  @$pb.TagNumber(3)
  set search($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSearch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearch() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.RoomMemberRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role($1.RoomMemberRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(6)
  RoomMemberListSortBy get sortBy => $_getN(4);
  @$pb.TagNumber(6)
  set sortBy(RoomMemberListSortBy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSortBy() => $_has(4);
  @$pb.TagNumber(6)
  void clearSortBy() => $_clearField(6);

  @$pb.TagNumber(7)
  SortDirection get sortDirection => $_getN(5);
  @$pb.TagNumber(7)
  set sortDirection(SortDirection value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortDirection() => $_has(5);
  @$pb.TagNumber(7)
  void clearSortDirection() => $_clearField(7);
}

class GetRoomMembersResponse extends $pb.GeneratedMessage {
  factory GetRoomMembersResponse({
    $core.Iterable<$1.RoomMember>? members,
    $core.int? total,
    $core.String? version,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    if (total != null) result.total = total;
    if (version != null) result.version = version;
    return result;
  }

  GetRoomMembersResponse._();

  factory GetRoomMembersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomMembersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomMembersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<$1.RoomMember>(1, _omitFieldNames ? '' : 'members',
        subBuilder: $1.RoomMember.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomMembersResponse copyWith(
          void Function(GetRoomMembersResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomMembersResponse))
          as GetRoomMembersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomMembersResponse create() => GetRoomMembersResponse._();
  @$core.override
  GetRoomMembersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomMembersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomMembersResponse>(create);
  static GetRoomMembersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.RoomMember> get members => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

/// Room live streams
/// Note: room_id extracted from x-room-id metadata
class ListRoomStreamsRequest extends $pb.GeneratedMessage {
  factory ListRoomStreamsRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    RoomStreamListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListRoomStreamsRequest._();

  factory ListRoomStreamsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomStreamsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomStreamsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'search')
    ..aE<RoomStreamListSortBy>(4, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomStreamListSortBy.values)
    ..aE<SortDirection>(5, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomStreamsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomStreamsRequest copyWith(
          void Function(ListRoomStreamsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRoomStreamsRequest))
          as ListRoomStreamsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomStreamsRequest create() => ListRoomStreamsRequest._();
  @$core.override
  ListRoomStreamsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomStreamsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomStreamsRequest>(create);
  static ListRoomStreamsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get search => $_getSZ(2);
  @$pb.TagNumber(3)
  set search($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSearch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearch() => $_clearField(3);

  @$pb.TagNumber(4)
  RoomStreamListSortBy get sortBy => $_getN(3);
  @$pb.TagNumber(4)
  set sortBy(RoomStreamListSortBy value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSortBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearSortBy() => $_clearField(4);

  @$pb.TagNumber(5)
  SortDirection get sortDirection => $_getN(4);
  @$pb.TagNumber(5)
  set sortDirection(SortDirection value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSortDirection() => $_has(4);
  @$pb.TagNumber(5)
  void clearSortDirection() => $_clearField(5);
}

class StreamEntry extends $pb.GeneratedMessage {
  factory StreamEntry({
    $core.String? mediaId,
    $core.bool? active,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (active != null) result.active = active;
    return result;
  }

  StreamEntry._();

  factory StreamEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOB(2, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntry copyWith(void Function(StreamEntry) updates) =>
      super.copyWith((message) => updates(message as StreamEntry))
          as StreamEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamEntry create() => StreamEntry._();
  @$core.override
  StreamEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamEntry>(create);
  static StreamEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get active => $_getBF(1);
  @$pb.TagNumber(2)
  set active($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearActive() => $_clearField(2);
}

class ListRoomStreamsResponse extends $pb.GeneratedMessage {
  factory ListRoomStreamsResponse({
    $core.Iterable<StreamEntry>? streams,
    $core.int? total,
  }) {
    final result = create();
    if (streams != null) result.streams.addAll(streams);
    if (total != null) result.total = total;
    return result;
  }

  ListRoomStreamsResponse._();

  factory ListRoomStreamsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomStreamsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomStreamsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<StreamEntry>(1, _omitFieldNames ? '' : 'streams',
        subBuilder: StreamEntry.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomStreamsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomStreamsResponse copyWith(
          void Function(ListRoomStreamsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRoomStreamsResponse))
          as ListRoomStreamsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomStreamsResponse create() => ListRoomStreamsResponse._();
  @$core.override
  ListRoomStreamsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomStreamsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomStreamsResponse>(create);
  static ListRoomStreamsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StreamEntry> get streams => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetRoomStreamInfoRequest extends $pb.GeneratedMessage {
  factory GetRoomStreamInfoRequest({
    $core.String? mediaId,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  GetRoomStreamInfoRequest._();

  factory GetRoomStreamInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomStreamInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomStreamInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomStreamInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomStreamInfoRequest copyWith(
          void Function(GetRoomStreamInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetRoomStreamInfoRequest))
          as GetRoomStreamInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomStreamInfoRequest create() => GetRoomStreamInfoRequest._();
  @$core.override
  GetRoomStreamInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomStreamInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomStreamInfoRequest>(create);
  static GetRoomStreamInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);
}

class RoomStreamPublisherInfo extends $pb.GeneratedMessage {
  factory RoomStreamPublisherInfo({
    $core.String? userId,
    $fixnum.Int64? startedAt,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  RoomStreamPublisherInfo._();

  factory RoomStreamPublisherInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomStreamPublisherInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomStreamPublisherInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aInt64(2, _omitFieldNames ? '' : 'startedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomStreamPublisherInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomStreamPublisherInfo copyWith(
          void Function(RoomStreamPublisherInfo) updates) =>
      super.copyWith((message) => updates(message as RoomStreamPublisherInfo))
          as RoomStreamPublisherInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomStreamPublisherInfo create() => RoomStreamPublisherInfo._();
  @$core.override
  RoomStreamPublisherInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomStreamPublisherInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomStreamPublisherInfo>(create);
  static RoomStreamPublisherInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get startedAt => $_getI64(1);
  @$pb.TagNumber(2)
  set startedAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartedAt() => $_clearField(2);
}

class GetRoomStreamInfoResponse extends $pb.GeneratedMessage {
  factory GetRoomStreamInfoResponse({
    $core.bool? active,
    RoomStreamPublisherInfo? publisher,
  }) {
    final result = create();
    if (active != null) result.active = active;
    if (publisher != null) result.publisher = publisher;
    return result;
  }

  GetRoomStreamInfoResponse._();

  factory GetRoomStreamInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomStreamInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomStreamInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..aOM<RoomStreamPublisherInfo>(2, _omitFieldNames ? '' : 'publisher',
        subBuilder: RoomStreamPublisherInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomStreamInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRoomStreamInfoResponse copyWith(
          void Function(GetRoomStreamInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetRoomStreamInfoResponse))
          as GetRoomStreamInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRoomStreamInfoResponse create() => GetRoomStreamInfoResponse._();
  @$core.override
  GetRoomStreamInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRoomStreamInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRoomStreamInfoResponse>(create);
  static GetRoomStreamInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => $_clearField(1);

  @$pb.TagNumber(2)
  RoomStreamPublisherInfo get publisher => $_getN(1);
  @$pb.TagNumber(2)
  set publisher(RoomStreamPublisherInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPublisher() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublisher() => $_clearField(2);
  @$pb.TagNumber(2)
  RoomStreamPublisherInfo ensurePublisher() => $_ensure(1);
}

class KickRoomStreamRequest extends $pb.GeneratedMessage {
  factory KickRoomStreamRequest({
    $core.String? mediaId,
    $core.String? reason,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (reason != null) result.reason = reason;
    return result;
  }

  KickRoomStreamRequest._();

  factory KickRoomStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickRoomStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickRoomStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickRoomStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickRoomStreamRequest copyWith(
          void Function(KickRoomStreamRequest) updates) =>
      super.copyWith((message) => updates(message as KickRoomStreamRequest))
          as KickRoomStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickRoomStreamRequest create() => KickRoomStreamRequest._();
  @$core.override
  KickRoomStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickRoomStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickRoomStreamRequest>(create);
  static KickRoomStreamRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class KickRoomStreamResponse extends $pb.GeneratedMessage {
  factory KickRoomStreamResponse() => create();

  KickRoomStreamResponse._();

  factory KickRoomStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickRoomStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickRoomStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickRoomStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickRoomStreamResponse copyWith(
          void Function(KickRoomStreamResponse) updates) =>
      super.copyWith((message) => updates(message as KickRoomStreamResponse))
          as KickRoomStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickRoomStreamResponse create() => KickRoomStreamResponse._();
  @$core.override
  KickRoomStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickRoomStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickRoomStreamResponse>(create);
  static KickRoomStreamResponse? _defaultInstance;
}

class AddMemberRequest extends $pb.GeneratedMessage {
  factory AddMemberRequest({
    $core.String? userId,
    $1.RoomMemberRole? role,
    $core.bool? notify,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (role != null) result.role = role;
    if (notify != null) result.notify = notify;
    return result;
  }

  AddMemberRequest._();

  factory AddMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aE<$1.RoomMemberRole>(2, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..aOB(3, _omitFieldNames ? '' : 'notify')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMemberRequest copyWith(void Function(AddMemberRequest) updates) =>
      super.copyWith((message) => updates(message as AddMemberRequest))
          as AddMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMemberRequest create() => AddMemberRequest._();
  @$core.override
  AddMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMemberRequest>(create);
  static AddMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RoomMemberRole get role => $_getN(1);
  @$pb.TagNumber(2)
  set role($1.RoomMemberRole value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get notify => $_getBF(2);
  @$pb.TagNumber(3)
  set notify($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotify() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotify() => $_clearField(3);
}

class AddMemberResponse extends $pb.GeneratedMessage {
  factory AddMemberResponse({
    $1.RoomMember? member,
  }) {
    final result = create();
    if (member != null) result.member = member;
    return result;
  }

  AddMemberResponse._();

  factory AddMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<$1.RoomMember>(1, _omitFieldNames ? '' : 'member',
        subBuilder: $1.RoomMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMemberResponse copyWith(void Function(AddMemberResponse) updates) =>
      super.copyWith((message) => updates(message as AddMemberResponse))
          as AddMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMemberResponse create() => AddMemberResponse._();
  @$core.override
  AddMemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMemberResponse>(create);
  static AddMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.RoomMember get member => $_getN(0);
  @$pb.TagNumber(1)
  set member($1.RoomMember value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.RoomMember ensureMember() => $_ensure(0);
}

class RoomJoinReview extends $pb.GeneratedMessage {
  factory RoomJoinReview({
    $core.String? id,
    $core.String? roomId,
    $core.String? userId,
    $core.String? username,
    $1.RoomMemberRole? requestedRole,
    $1.ReviewStatus? status,
    $fixnum.Int64? requestedAt,
    $fixnum.Int64? reviewedAt,
    $core.String? reviewedBy,
    $core.String? rejectionReason,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (requestedRole != null) result.requestedRole = requestedRole;
    if (status != null) result.status = status;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    return result;
  }

  RoomJoinReview._();

  factory RoomJoinReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomJoinReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomJoinReview',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aE<$1.RoomMemberRole>(5, _omitFieldNames ? '' : 'requestedRole',
        enumValues: $1.RoomMemberRole.values)
    ..aE<$1.ReviewStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aInt64(7, _omitFieldNames ? '' : 'requestedAt')
    ..aInt64(8, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(9, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(10, _omitFieldNames ? '' : 'rejectionReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomJoinReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomJoinReview copyWith(void Function(RoomJoinReview) updates) =>
      super.copyWith((message) => updates(message as RoomJoinReview))
          as RoomJoinReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomJoinReview create() => RoomJoinReview._();
  @$core.override
  RoomJoinReview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomJoinReview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomJoinReview>(create);
  static RoomJoinReview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.RoomMemberRole get requestedRole => $_getN(4);
  @$pb.TagNumber(5)
  set requestedRole($1.RoomMemberRole value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRequestedRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestedRole() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.ReviewStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status($1.ReviewStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get requestedAt => $_getI64(6);
  @$pb.TagNumber(7)
  set requestedAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRequestedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearRequestedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get reviewedAt => $_getI64(7);
  @$pb.TagNumber(8)
  set reviewedAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reviewedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set reviewedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReviewedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get rejectionReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set rejectionReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRejectionReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearRejectionReason() => $_clearField(10);
}

class ListRoomJoinReviewsRequest extends $pb.GeneratedMessage {
  factory ListRoomJoinReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $1.ReviewStatus? status,
    $core.String? userId,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (userId != null) result.userId = userId;
    return result;
  }

  ListRoomJoinReviewsRequest._();

  factory ListRoomJoinReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomJoinReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomJoinReviewsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomJoinReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomJoinReviewsRequest copyWith(
          void Function(ListRoomJoinReviewsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListRoomJoinReviewsRequest))
          as ListRoomJoinReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomJoinReviewsRequest create() => ListRoomJoinReviewsRequest._();
  @$core.override
  ListRoomJoinReviewsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomJoinReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomJoinReviewsRequest>(create);
  static ListRoomJoinReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.ReviewStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($1.ReviewStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);
}

class ListRoomJoinReviewsResponse extends $pb.GeneratedMessage {
  factory ListRoomJoinReviewsResponse({
    $core.Iterable<RoomJoinReview>? reviews,
    $core.int? total,
  }) {
    final result = create();
    if (reviews != null) result.reviews.addAll(reviews);
    if (total != null) result.total = total;
    return result;
  }

  ListRoomJoinReviewsResponse._();

  factory ListRoomJoinReviewsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomJoinReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomJoinReviewsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<RoomJoinReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: RoomJoinReview.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomJoinReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomJoinReviewsResponse copyWith(
          void Function(ListRoomJoinReviewsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRoomJoinReviewsResponse))
          as ListRoomJoinReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomJoinReviewsResponse create() =>
      ListRoomJoinReviewsResponse._();
  @$core.override
  ListRoomJoinReviewsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomJoinReviewsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomJoinReviewsResponse>(create);
  static ListRoomJoinReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RoomJoinReview> get reviews => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class ApproveRoomJoinReviewRequest extends $pb.GeneratedMessage {
  factory ApproveRoomJoinReviewRequest({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  ApproveRoomJoinReviewRequest._();

  factory ApproveRoomJoinReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveRoomJoinReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRoomJoinReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomJoinReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomJoinReviewRequest copyWith(
          void Function(ApproveRoomJoinReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveRoomJoinReviewRequest))
          as ApproveRoomJoinReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveRoomJoinReviewRequest create() =>
      ApproveRoomJoinReviewRequest._();
  @$core.override
  ApproveRoomJoinReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveRoomJoinReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveRoomJoinReviewRequest>(create);
  static ApproveRoomJoinReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

class ApproveRoomJoinReviewResponse extends $pb.GeneratedMessage {
  factory ApproveRoomJoinReviewResponse({
    RoomJoinReview? review,
    $1.RoomMember? member,
  }) {
    final result = create();
    if (review != null) result.review = review;
    if (member != null) result.member = member;
    return result;
  }

  ApproveRoomJoinReviewResponse._();

  factory ApproveRoomJoinReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveRoomJoinReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRoomJoinReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<RoomJoinReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: RoomJoinReview.create)
    ..aOM<$1.RoomMember>(2, _omitFieldNames ? '' : 'member',
        subBuilder: $1.RoomMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomJoinReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomJoinReviewResponse copyWith(
          void Function(ApproveRoomJoinReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveRoomJoinReviewResponse))
          as ApproveRoomJoinReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveRoomJoinReviewResponse create() =>
      ApproveRoomJoinReviewResponse._();
  @$core.override
  ApproveRoomJoinReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveRoomJoinReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveRoomJoinReviewResponse>(create);
  static ApproveRoomJoinReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RoomJoinReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(RoomJoinReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomJoinReview ensureReview() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.RoomMember get member => $_getN(1);
  @$pb.TagNumber(2)
  set member($1.RoomMember value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMember() => $_has(1);
  @$pb.TagNumber(2)
  void clearMember() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RoomMember ensureMember() => $_ensure(1);
}

class RejectRoomJoinReviewRequest extends $pb.GeneratedMessage {
  factory RejectRoomJoinReviewRequest({
    $core.String? requestId,
    $core.String? reason,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RejectRoomJoinReviewRequest._();

  factory RejectRoomJoinReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectRoomJoinReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectRoomJoinReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomJoinReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomJoinReviewRequest copyWith(
          void Function(RejectRoomJoinReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RejectRoomJoinReviewRequest))
          as RejectRoomJoinReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectRoomJoinReviewRequest create() =>
      RejectRoomJoinReviewRequest._();
  @$core.override
  RejectRoomJoinReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectRoomJoinReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectRoomJoinReviewRequest>(create);
  static RejectRoomJoinReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RejectRoomJoinReviewResponse extends $pb.GeneratedMessage {
  factory RejectRoomJoinReviewResponse({
    RoomJoinReview? review,
    $core.bool? success,
  }) {
    final result = create();
    if (review != null) result.review = review;
    if (success != null) result.success = success;
    return result;
  }

  RejectRoomJoinReviewResponse._();

  factory RejectRoomJoinReviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectRoomJoinReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectRoomJoinReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<RoomJoinReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: RoomJoinReview.create)
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomJoinReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomJoinReviewResponse copyWith(
          void Function(RejectRoomJoinReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RejectRoomJoinReviewResponse))
          as RejectRoomJoinReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectRoomJoinReviewResponse create() =>
      RejectRoomJoinReviewResponse._();
  @$core.override
  RejectRoomJoinReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectRoomJoinReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectRoomJoinReviewResponse>(create);
  static RejectRoomJoinReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RoomJoinReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(RoomJoinReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomJoinReview ensureReview() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);
}

class UpdateMemberPermissionsRequest extends $pb.GeneratedMessage {
  factory UpdateMemberPermissionsRequest({
    $core.String? userId,
    $1.RoomMemberRole? role,
    $fixnum.Int64? addedPermissions,
    $fixnum.Int64? removedPermissions,
    $fixnum.Int64? adminAddedPermissions,
    $fixnum.Int64? adminRemovedPermissions,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (role != null) result.role = role;
    if (addedPermissions != null) result.addedPermissions = addedPermissions;
    if (removedPermissions != null)
      result.removedPermissions = removedPermissions;
    if (adminAddedPermissions != null)
      result.adminAddedPermissions = adminAddedPermissions;
    if (adminRemovedPermissions != null)
      result.adminRemovedPermissions = adminRemovedPermissions;
    return result;
  }

  UpdateMemberPermissionsRequest._();

  factory UpdateMemberPermissionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMemberPermissionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberPermissionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aE<$1.RoomMemberRole>(2, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'addedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'removedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'adminAddedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'adminRemovedPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberPermissionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberPermissionsRequest copyWith(
          void Function(UpdateMemberPermissionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateMemberPermissionsRequest))
          as UpdateMemberPermissionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMemberPermissionsRequest create() =>
      UpdateMemberPermissionsRequest._();
  @$core.override
  UpdateMemberPermissionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberPermissionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberPermissionsRequest>(create);
  static UpdateMemberPermissionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RoomMemberRole get role => $_getN(1);
  @$pb.TagNumber(2)
  set role($1.RoomMemberRole value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);

  /// Allow/Deny permission pattern fields
  /// Only set the fields you want to update
  /// For member role: use added_permissions/removed_permissions
  /// For admin role: use admin_added_permissions/admin_removed_permissions
  @$pb.TagNumber(3)
  $fixnum.Int64 get addedPermissions => $_getI64(2);
  @$pb.TagNumber(3)
  set addedPermissions($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddedPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddedPermissions() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get removedPermissions => $_getI64(3);
  @$pb.TagNumber(4)
  set removedPermissions($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRemovedPermissions() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemovedPermissions() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get adminAddedPermissions => $_getI64(4);
  @$pb.TagNumber(5)
  set adminAddedPermissions($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdminAddedPermissions() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdminAddedPermissions() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get adminRemovedPermissions => $_getI64(5);
  @$pb.TagNumber(6)
  set adminRemovedPermissions($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAdminRemovedPermissions() => $_has(5);
  @$pb.TagNumber(6)
  void clearAdminRemovedPermissions() => $_clearField(6);
}

class UpdateMemberPermissionsResponse extends $pb.GeneratedMessage {
  factory UpdateMemberPermissionsResponse({
    $1.RoomMember? member,
  }) {
    final result = create();
    if (member != null) result.member = member;
    return result;
  }

  UpdateMemberPermissionsResponse._();

  factory UpdateMemberPermissionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMemberPermissionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberPermissionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<$1.RoomMember>(1, _omitFieldNames ? '' : 'member',
        subBuilder: $1.RoomMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberPermissionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberPermissionsResponse copyWith(
          void Function(UpdateMemberPermissionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateMemberPermissionsResponse))
          as UpdateMemberPermissionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMemberPermissionsResponse create() =>
      UpdateMemberPermissionsResponse._();
  @$core.override
  UpdateMemberPermissionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberPermissionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberPermissionsResponse>(
          create);
  static UpdateMemberPermissionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.RoomMember get member => $_getN(0);
  @$pb.TagNumber(1)
  set member($1.RoomMember value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.RoomMember ensureMember() => $_ensure(0);
}

class KickMemberRequest extends $pb.GeneratedMessage {
  factory KickMemberRequest({
    $core.String? userId,
    $fixnum.Int64? kickCooldownSeconds,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (kickCooldownSeconds != null)
      result.kickCooldownSeconds = kickCooldownSeconds;
    return result;
  }

  KickMemberRequest._();

  factory KickMemberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickMemberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickMemberRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aInt64(2, _omitFieldNames ? '' : 'kickCooldownSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberRequest copyWith(void Function(KickMemberRequest) updates) =>
      super.copyWith((message) => updates(message as KickMemberRequest))
          as KickMemberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickMemberRequest create() => KickMemberRequest._();
  @$core.override
  KickMemberRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickMemberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickMemberRequest>(create);
  static KickMemberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get kickCooldownSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set kickCooldownSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKickCooldownSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearKickCooldownSeconds() => $_clearField(2);
}

class KickMemberResponse extends $pb.GeneratedMessage {
  factory KickMemberResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  KickMemberResponse._();

  factory KickMemberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickMemberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickMemberResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickMemberResponse copyWith(void Function(KickMemberResponse) updates) =>
      super.copyWith((message) => updates(message as KickMemberResponse))
          as KickMemberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickMemberResponse create() => KickMemberResponse._();
  @$core.override
  KickMemberResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickMemberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickMemberResponse>(create);
  static KickMemberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CreatePlaylistRequest extends $pb.GeneratedMessage {
  factory CreatePlaylistRequest({
    $core.String? name,
    $core.String? parentId,
    $core.String? sourceProvider,
    $core.List<$core.int>? sourceConfig,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (parentId != null) result.parentId = parentId;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    return result;
  }

  CreatePlaylistRequest._();

  factory CreatePlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'parentId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceProvider')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'sourceConfig', $pb.PbFieldType.OY)
    ..aOS(5, _omitFieldNames ? '' : 'providerInstanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePlaylistRequest copyWith(
          void Function(CreatePlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePlaylistRequest))
          as CreatePlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePlaylistRequest create() => CreatePlaylistRequest._();
  @$core.override
  CreatePlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePlaylistRequest>(create);
  static CreatePlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceProvider => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceProvider($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceProvider() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceProvider() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get sourceConfig => $_getN(3);
  @$pb.TagNumber(4)
  set sourceConfig($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceConfig() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get providerInstanceName => $_getSZ(4);
  @$pb.TagNumber(5)
  set providerInstanceName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProviderInstanceName() => $_has(4);
  @$pb.TagNumber(5)
  void clearProviderInstanceName() => $_clearField(5);
}

class CreatePlaylistResponse extends $pb.GeneratedMessage {
  factory CreatePlaylistResponse({
    Playlist? playlist,
  }) {
    final result = create();
    if (playlist != null) result.playlist = playlist;
    return result;
  }

  CreatePlaylistResponse._();

  factory CreatePlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Playlist>(1, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePlaylistResponse copyWith(
          void Function(CreatePlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePlaylistResponse))
          as CreatePlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePlaylistResponse create() => CreatePlaylistResponse._();
  @$core.override
  CreatePlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePlaylistResponse>(create);
  static CreatePlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Playlist get playlist => $_getN(0);
  @$pb.TagNumber(1)
  set playlist(Playlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylist() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylist() => $_clearField(1);
  @$pb.TagNumber(1)
  Playlist ensurePlaylist() => $_ensure(0);
}

class UpdatePlaylistRequest extends $pb.GeneratedMessage {
  factory UpdatePlaylistRequest({
    $core.String? playlistId,
    $core.String? name,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (name != null) result.name = name;
    return result;
  }

  UpdatePlaylistRequest._();

  factory UpdatePlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlaylistRequest copyWith(
          void Function(UpdatePlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePlaylistRequest))
          as UpdatePlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePlaylistRequest create() => UpdatePlaylistRequest._();
  @$core.override
  UpdatePlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatePlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePlaylistRequest>(create);
  static UpdatePlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class UpdatePlaylistResponse extends $pb.GeneratedMessage {
  factory UpdatePlaylistResponse({
    Playlist? playlist,
  }) {
    final result = create();
    if (playlist != null) result.playlist = playlist;
    return result;
  }

  UpdatePlaylistResponse._();

  factory UpdatePlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Playlist>(1, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlaylistResponse copyWith(
          void Function(UpdatePlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as UpdatePlaylistResponse))
          as UpdatePlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePlaylistResponse create() => UpdatePlaylistResponse._();
  @$core.override
  UpdatePlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatePlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePlaylistResponse>(create);
  static UpdatePlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Playlist get playlist => $_getN(0);
  @$pb.TagNumber(1)
  set playlist(Playlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylist() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylist() => $_clearField(1);
  @$pb.TagNumber(1)
  Playlist ensurePlaylist() => $_ensure(0);
}

enum MovePlaylistRequest_Anchor { beforePlaylistId, afterPlaylistId, notSet }

class MovePlaylistRequest extends $pb.GeneratedMessage {
  factory MovePlaylistRequest({
    $core.String? playlistId,
    $core.String? beforePlaylistId,
    $core.String? afterPlaylistId,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (beforePlaylistId != null) result.beforePlaylistId = beforePlaylistId;
    if (afterPlaylistId != null) result.afterPlaylistId = afterPlaylistId;
    return result;
  }

  MovePlaylistRequest._();

  factory MovePlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MovePlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, MovePlaylistRequest_Anchor>
      _MovePlaylistRequest_AnchorByTag = {
    2: MovePlaylistRequest_Anchor.beforePlaylistId,
    3: MovePlaylistRequest_Anchor.afterPlaylistId,
    0: MovePlaylistRequest_Anchor.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MovePlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOS(2, _omitFieldNames ? '' : 'beforePlaylistId')
    ..aOS(3, _omitFieldNames ? '' : 'afterPlaylistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MovePlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MovePlaylistRequest copyWith(void Function(MovePlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as MovePlaylistRequest))
          as MovePlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MovePlaylistRequest create() => MovePlaylistRequest._();
  @$core.override
  MovePlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MovePlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MovePlaylistRequest>(create);
  static MovePlaylistRequest? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  MovePlaylistRequest_Anchor whichAnchor() =>
      _MovePlaylistRequest_AnchorByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearAnchor() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get beforePlaylistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set beforePlaylistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBeforePlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforePlaylistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get afterPlaylistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set afterPlaylistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterPlaylistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterPlaylistId() => $_clearField(3);
}

class MovePlaylistResponse extends $pb.GeneratedMessage {
  factory MovePlaylistResponse({
    Playlist? playlist,
  }) {
    final result = create();
    if (playlist != null) result.playlist = playlist;
    return result;
  }

  MovePlaylistResponse._();

  factory MovePlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MovePlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MovePlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Playlist>(1, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MovePlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MovePlaylistResponse copyWith(void Function(MovePlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as MovePlaylistResponse))
          as MovePlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MovePlaylistResponse create() => MovePlaylistResponse._();
  @$core.override
  MovePlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MovePlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MovePlaylistResponse>(create);
  static MovePlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Playlist get playlist => $_getN(0);
  @$pb.TagNumber(1)
  set playlist(Playlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylist() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylist() => $_clearField(1);
  @$pb.TagNumber(1)
  Playlist ensurePlaylist() => $_ensure(0);
}

class DeletePlaylistRequest extends $pb.GeneratedMessage {
  factory DeletePlaylistRequest({
    $core.String? playlistId,
    $core.bool? force,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (force != null) result.force = force;
    return result;
  }

  DeletePlaylistRequest._();

  factory DeletePlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOB(2, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePlaylistRequest copyWith(
          void Function(DeletePlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as DeletePlaylistRequest))
          as DeletePlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePlaylistRequest create() => DeletePlaylistRequest._();
  @$core.override
  DeletePlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeletePlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePlaylistRequest>(create);
  static DeletePlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get force => $_getBF(1);
  @$pb.TagNumber(2)
  set force($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasForce() => $_has(1);
  @$pb.TagNumber(2)
  void clearForce() => $_clearField(2);
}

class DeletePlaylistQuery extends $pb.GeneratedMessage {
  factory DeletePlaylistQuery({
    $core.bool? force,
  }) {
    final result = create();
    if (force != null) result.force = force;
    return result;
  }

  DeletePlaylistQuery._();

  factory DeletePlaylistQuery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePlaylistQuery.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePlaylistQuery',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePlaylistQuery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePlaylistQuery copyWith(void Function(DeletePlaylistQuery) updates) =>
      super.copyWith((message) => updates(message as DeletePlaylistQuery))
          as DeletePlaylistQuery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePlaylistQuery create() => DeletePlaylistQuery._();
  @$core.override
  DeletePlaylistQuery createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeletePlaylistQuery getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePlaylistQuery>(create);
  static DeletePlaylistQuery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get force => $_getBF(0);
  @$pb.TagNumber(1)
  set force($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasForce() => $_has(0);
  @$pb.TagNumber(1)
  void clearForce() => $_clearField(1);
}

class DeletePlaylistResponse extends $pb.GeneratedMessage {
  factory DeletePlaylistResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeletePlaylistResponse._();

  factory DeletePlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeletePlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeletePlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeletePlaylistResponse copyWith(
          void Function(DeletePlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as DeletePlaylistResponse))
          as DeletePlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePlaylistResponse create() => DeletePlaylistResponse._();
  @$core.override
  DeletePlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeletePlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeletePlaylistResponse>(create);
  static DeletePlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// Get single playlist info
class GetPlaylistRequest extends $pb.GeneratedMessage {
  factory GetPlaylistRequest({
    $core.String? playlistId,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    return result;
  }

  GetPlaylistRequest._();

  factory GetPlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaylistRequest copyWith(void Function(GetPlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as GetPlaylistRequest))
          as GetPlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlaylistRequest create() => GetPlaylistRequest._();
  @$core.override
  GetPlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlaylistRequest>(create);
  static GetPlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);
}

class GetPlaylistResponse extends $pb.GeneratedMessage {
  factory GetPlaylistResponse({
    Playlist? playlist,
    $core.int? childFolderCount,
    $core.int? mediaCount,
  }) {
    final result = create();
    if (playlist != null) result.playlist = playlist;
    if (childFolderCount != null) result.childFolderCount = childFolderCount;
    if (mediaCount != null) result.mediaCount = mediaCount;
    return result;
  }

  GetPlaylistResponse._();

  factory GetPlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Playlist>(1, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..aI(2, _omitFieldNames ? '' : 'childFolderCount')
    ..aI(3, _omitFieldNames ? '' : 'mediaCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaylistResponse copyWith(void Function(GetPlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as GetPlaylistResponse))
          as GetPlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlaylistResponse create() => GetPlaylistResponse._();
  @$core.override
  GetPlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlaylistResponse>(create);
  static GetPlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Playlist get playlist => $_getN(0);
  @$pb.TagNumber(1)
  set playlist(Playlist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylist() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylist() => $_clearField(1);
  @$pb.TagNumber(1)
  Playlist ensurePlaylist() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get childFolderCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set childFolderCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChildFolderCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearChildFolderCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mediaCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set mediaCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaCount() => $_clearField(3);
}

/// List playlists (folders) in a room or under a parent
class ListPlaylistsRequest extends $pb.GeneratedMessage {
  factory ListPlaylistsRequest({
    $core.String? parentId,
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? sourceProvider,
    $core.String? providerInstanceName,
    $core.bool? dynamicOnly,
    PlaylistListSortBy? sortBy,
    SortDirection? sortDirection,
    ResourceAvailabilityFilter? availability,
  }) {
    final result = create();
    if (parentId != null) result.parentId = parentId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (dynamicOnly != null) result.dynamicOnly = dynamicOnly;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    if (availability != null) result.availability = availability;
    return result;
  }

  ListPlaylistsRequest._();

  factory ListPlaylistsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPlaylistsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlaylistsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parentId')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'search')
    ..aOS(5, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(6, _omitFieldNames ? '' : 'providerInstanceName')
    ..aOB(7, _omitFieldNames ? '' : 'dynamicOnly')
    ..aE<PlaylistListSortBy>(8, _omitFieldNames ? '' : 'sortBy',
        enumValues: PlaylistListSortBy.values)
    ..aE<SortDirection>(9, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..aE<ResourceAvailabilityFilter>(10, _omitFieldNames ? '' : 'availability',
        enumValues: ResourceAvailabilityFilter.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistsRequest copyWith(void Function(ListPlaylistsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPlaylistsRequest))
          as ListPlaylistsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPlaylistsRequest create() => ListPlaylistsRequest._();
  @$core.override
  ListPlaylistsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPlaylistsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlaylistsRequest>(create);
  static ListPlaylistsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set parentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get page => $_getIZ(1);
  @$pb.TagNumber(2)
  set page($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceProvider => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceProvider($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceProvider() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceProvider() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get providerInstanceName => $_getSZ(5);
  @$pb.TagNumber(6)
  set providerInstanceName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProviderInstanceName() => $_has(5);
  @$pb.TagNumber(6)
  void clearProviderInstanceName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get dynamicOnly => $_getBF(6);
  @$pb.TagNumber(7)
  set dynamicOnly($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDynamicOnly() => $_has(6);
  @$pb.TagNumber(7)
  void clearDynamicOnly() => $_clearField(7);

  @$pb.TagNumber(8)
  PlaylistListSortBy get sortBy => $_getN(7);
  @$pb.TagNumber(8)
  set sortBy(PlaylistListSortBy value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSortBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearSortBy() => $_clearField(8);

  @$pb.TagNumber(9)
  SortDirection get sortDirection => $_getN(8);
  @$pb.TagNumber(9)
  set sortDirection(SortDirection value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSortDirection() => $_has(8);
  @$pb.TagNumber(9)
  void clearSortDirection() => $_clearField(9);

  @$pb.TagNumber(10)
  ResourceAvailabilityFilter get availability => $_getN(9);
  @$pb.TagNumber(10)
  set availability(ResourceAvailabilityFilter value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAvailability() => $_has(9);
  @$pb.TagNumber(10)
  void clearAvailability() => $_clearField(10);
}

class ListPlaylistsResponse extends $pb.GeneratedMessage {
  factory ListPlaylistsResponse({
    $core.Iterable<Playlist>? playlists,
    $core.int? total,
  }) {
    final result = create();
    if (playlists != null) result.playlists.addAll(playlists);
    if (total != null) result.total = total;
    return result;
  }

  ListPlaylistsResponse._();

  factory ListPlaylistsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPlaylistsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlaylistsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<Playlist>(1, _omitFieldNames ? '' : 'playlists',
        subBuilder: Playlist.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistsResponse copyWith(
          void Function(ListPlaylistsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPlaylistsResponse))
          as ListPlaylistsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPlaylistsResponse create() => ListPlaylistsResponse._();
  @$core.override
  ListPlaylistsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPlaylistsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlaylistsResponse>(create);
  static ListPlaylistsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Playlist> get playlists => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

/// HTTP API: Start playback of either:
/// 1. A concrete media item (`media_id`)
/// 2. A dynamic playlist item (`playlist_id` + `target`)
class StartPlaybackRequest extends $pb.GeneratedMessage {
  factory StartPlaybackRequest({
    $core.String? mediaId,
    $core.String? playlistId,
    $core.List<$core.int>? target,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (playlistId != null) result.playlistId = playlistId;
    if (target != null) result.target = target;
    return result;
  }

  StartPlaybackRequest._();

  factory StartPlaybackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPlaybackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPlaybackRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'playlistId')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'target', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPlaybackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPlaybackRequest copyWith(void Function(StartPlaybackRequest) updates) =>
      super.copyWith((message) => updates(message as StartPlaybackRequest))
          as StartPlaybackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPlaybackRequest create() => StartPlaybackRequest._();
  @$core.override
  StartPlaybackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPlaybackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPlaybackRequest>(create);
  static StartPlaybackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get target => $_getN(2);
  @$pb.TagNumber(3)
  set target($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);
}

class StartPlaybackResponse extends $pb.GeneratedMessage {
  factory StartPlaybackResponse() => create();

  StartPlaybackResponse._();

  factory StartPlaybackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartPlaybackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartPlaybackResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPlaybackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartPlaybackResponse copyWith(
          void Function(StartPlaybackResponse) updates) =>
      super.copyWith((message) => updates(message as StartPlaybackResponse))
          as StartPlaybackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartPlaybackResponse create() => StartPlaybackResponse._();
  @$core.override
  StartPlaybackResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartPlaybackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartPlaybackResponse>(create);
  static StartPlaybackResponse? _defaultInstance;
}

/// HTTP API: Stop current playback
class StopPlaybackRequest extends $pb.GeneratedMessage {
  factory StopPlaybackRequest() => create();

  StopPlaybackRequest._();

  factory StopPlaybackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopPlaybackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopPlaybackRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPlaybackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPlaybackRequest copyWith(void Function(StopPlaybackRequest) updates) =>
      super.copyWith((message) => updates(message as StopPlaybackRequest))
          as StopPlaybackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopPlaybackRequest create() => StopPlaybackRequest._();
  @$core.override
  StopPlaybackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopPlaybackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopPlaybackRequest>(create);
  static StopPlaybackRequest? _defaultInstance;
}

class StopPlaybackResponse extends $pb.GeneratedMessage {
  factory StopPlaybackResponse() => create();

  StopPlaybackResponse._();

  factory StopPlaybackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StopPlaybackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopPlaybackResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPlaybackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopPlaybackResponse copyWith(void Function(StopPlaybackResponse) updates) =>
      super.copyWith((message) => updates(message as StopPlaybackResponse))
          as StopPlaybackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopPlaybackResponse create() => StopPlaybackResponse._();
  @$core.override
  StopPlaybackResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StopPlaybackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopPlaybackResponse>(create);
  static StopPlaybackResponse? _defaultInstance;
}

class AddMediaRequest extends $pb.GeneratedMessage {
  factory AddMediaRequest({
    $core.String? playlistId,
    $core.String? sourceProvider,
    $core.String? providerInstanceName,
    $core.List<$core.int>? sourceConfig,
    $core.String? name,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    if (name != null) result.name = name;
    return result;
  }

  AddMediaRequest._();

  factory AddMediaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMediaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMediaRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOS(2, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(3, _omitFieldNames ? '' : 'providerInstanceName')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'sourceConfig', $pb.PbFieldType.OY)
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaRequest copyWith(void Function(AddMediaRequest) updates) =>
      super.copyWith((message) => updates(message as AddMediaRequest))
          as AddMediaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMediaRequest create() => AddMediaRequest._();
  @$core.override
  AddMediaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMediaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMediaRequest>(create);
  static AddMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceProvider => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceProvider($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceProvider() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceProvider() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get providerInstanceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set providerInstanceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProviderInstanceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearProviderInstanceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get sourceConfig => $_getN(3);
  @$pb.TagNumber(4)
  set sourceConfig($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceConfig() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);
}

class AddMediaResponse extends $pb.GeneratedMessage {
  factory AddMediaResponse({
    Media? media,
  }) {
    final result = create();
    if (media != null) result.media = media;
    return result;
  }

  AddMediaResponse._();

  factory AddMediaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMediaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMediaResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Media>(1, _omitFieldNames ? '' : 'media', subBuilder: Media.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaResponse copyWith(void Function(AddMediaResponse) updates) =>
      super.copyWith((message) => updates(message as AddMediaResponse))
          as AddMediaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMediaResponse create() => AddMediaResponse._();
  @$core.override
  AddMediaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMediaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMediaResponse>(create);
  static AddMediaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Media get media => $_getN(0);
  @$pb.TagNumber(1)
  set media(Media value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMedia() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedia() => $_clearField(1);
  @$pb.TagNumber(1)
  Media ensureMedia() => $_ensure(0);
}

class GetMediaRequest extends $pb.GeneratedMessage {
  factory GetMediaRequest({
    $core.String? mediaId,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  GetMediaRequest._();

  factory GetMediaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMediaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMediaRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMediaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMediaRequest copyWith(void Function(GetMediaRequest) updates) =>
      super.copyWith((message) => updates(message as GetMediaRequest))
          as GetMediaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMediaRequest create() => GetMediaRequest._();
  @$core.override
  GetMediaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMediaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMediaRequest>(create);
  static GetMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);
}

class DeleteMediaRequest extends $pb.GeneratedMessage {
  factory DeleteMediaRequest({
    $core.String? mediaId,
    $core.bool? force,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (force != null) result.force = force;
    return result;
  }

  DeleteMediaRequest._();

  factory DeleteMediaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMediaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMediaRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOB(2, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMediaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMediaRequest copyWith(void Function(DeleteMediaRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteMediaRequest))
          as DeleteMediaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMediaRequest create() => DeleteMediaRequest._();
  @$core.override
  DeleteMediaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMediaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMediaRequest>(create);
  static DeleteMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get force => $_getBF(1);
  @$pb.TagNumber(2)
  set force($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasForce() => $_has(1);
  @$pb.TagNumber(2)
  void clearForce() => $_clearField(2);
}

class DeleteMediaQuery extends $pb.GeneratedMessage {
  factory DeleteMediaQuery({
    $core.bool? force,
  }) {
    final result = create();
    if (force != null) result.force = force;
    return result;
  }

  DeleteMediaQuery._();

  factory DeleteMediaQuery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMediaQuery.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMediaQuery',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMediaQuery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMediaQuery copyWith(void Function(DeleteMediaQuery) updates) =>
      super.copyWith((message) => updates(message as DeleteMediaQuery))
          as DeleteMediaQuery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMediaQuery create() => DeleteMediaQuery._();
  @$core.override
  DeleteMediaQuery createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMediaQuery getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMediaQuery>(create);
  static DeleteMediaQuery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get force => $_getBF(0);
  @$pb.TagNumber(1)
  set force($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasForce() => $_has(0);
  @$pb.TagNumber(1)
  void clearForce() => $_clearField(1);
}

class DeleteMediaResponse extends $pb.GeneratedMessage {
  factory DeleteMediaResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteMediaResponse._();

  factory DeleteMediaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMediaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMediaResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMediaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMediaResponse copyWith(void Function(DeleteMediaResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteMediaResponse))
          as DeleteMediaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMediaResponse create() => DeleteMediaResponse._();
  @$core.override
  DeleteMediaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMediaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMediaResponse>(create);
  static DeleteMediaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class DeleteEntriesRequest extends $pb.GeneratedMessage {
  factory DeleteEntriesRequest({
    $core.Iterable<$core.String>? playlistIds,
    $core.Iterable<$core.String>? mediaIds,
    $core.bool? force,
  }) {
    final result = create();
    if (playlistIds != null) result.playlistIds.addAll(playlistIds);
    if (mediaIds != null) result.mediaIds.addAll(mediaIds);
    if (force != null) result.force = force;
    return result;
  }

  DeleteEntriesRequest._();

  factory DeleteEntriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteEntriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteEntriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'playlistIds')
    ..pPS(2, _omitFieldNames ? '' : 'mediaIds')
    ..aOB(3, _omitFieldNames ? '' : 'force')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntriesRequest copyWith(void Function(DeleteEntriesRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteEntriesRequest))
          as DeleteEntriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteEntriesRequest create() => DeleteEntriesRequest._();
  @$core.override
  DeleteEntriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteEntriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteEntriesRequest>(create);
  static DeleteEntriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get playlistIds => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get mediaIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get force => $_getBF(2);
  @$pb.TagNumber(3)
  set force($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForce() => $_has(2);
  @$pb.TagNumber(3)
  void clearForce() => $_clearField(3);
}

class DeleteEntriesResponse extends $pb.GeneratedMessage {
  factory DeleteEntriesResponse({
    $core.int? deletedPlaylists,
    $core.int? deletedMedia,
  }) {
    final result = create();
    if (deletedPlaylists != null) result.deletedPlaylists = deletedPlaylists;
    if (deletedMedia != null) result.deletedMedia = deletedMedia;
    return result;
  }

  DeleteEntriesResponse._();

  factory DeleteEntriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteEntriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteEntriesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'deletedPlaylists')
    ..aI(2, _omitFieldNames ? '' : 'deletedMedia')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteEntriesResponse copyWith(
          void Function(DeleteEntriesResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteEntriesResponse))
          as DeleteEntriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteEntriesResponse create() => DeleteEntriesResponse._();
  @$core.override
  DeleteEntriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteEntriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteEntriesResponse>(create);
  static DeleteEntriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get deletedPlaylists => $_getIZ(0);
  @$pb.TagNumber(1)
  set deletedPlaylists($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeletedPlaylists() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeletedPlaylists() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get deletedMedia => $_getIZ(1);
  @$pb.TagNumber(2)
  set deletedMedia($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeletedMedia() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeletedMedia() => $_clearField(2);
}

class ListPlaylistItemsRequest extends $pb.GeneratedMessage {
  factory ListPlaylistItemsRequest({
    $core.String? playlistId,
    $core.List<$core.int>? target,
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? sourceProvider,
    $core.String? providerInstanceName,
    MediaListSortBy? sortBy,
    SortDirection? sortDirection,
    ResourceAvailabilityFilter? availability,
    $core.bool? refresh,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (target != null) result.target = target;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (sourceProvider != null) result.sourceProvider = sourceProvider;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    if (availability != null) result.availability = availability;
    if (refresh != null) result.refresh = refresh;
    return result;
  }

  ListPlaylistItemsRequest._();

  factory ListPlaylistItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPlaylistItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlaylistItemsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'target', $pb.PbFieldType.OY)
    ..aI(3, _omitFieldNames ? '' : 'page')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOS(6, _omitFieldNames ? '' : 'sourceProvider')
    ..aOS(7, _omitFieldNames ? '' : 'providerInstanceName')
    ..aE<MediaListSortBy>(8, _omitFieldNames ? '' : 'sortBy',
        enumValues: MediaListSortBy.values)
    ..aE<SortDirection>(9, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..aE<ResourceAvailabilityFilter>(10, _omitFieldNames ? '' : 'availability',
        enumValues: ResourceAvailabilityFilter.values)
    ..aOB(11, _omitFieldNames ? '' : 'refresh')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistItemsRequest copyWith(
          void Function(ListPlaylistItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPlaylistItemsRequest))
          as ListPlaylistItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPlaylistItemsRequest create() => ListPlaylistItemsRequest._();
  @$core.override
  ListPlaylistItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPlaylistItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlaylistItemsRequest>(create);
  static ListPlaylistItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get target => $_getN(1);
  @$pb.TagNumber(2)
  set target($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTarget() => $_has(1);
  @$pb.TagNumber(2)
  void clearTarget() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get page => $_getIZ(2);
  @$pb.TagNumber(3)
  set page($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get search => $_getSZ(4);
  @$pb.TagNumber(5)
  set search($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceProvider => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceProvider($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceProvider() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceProvider() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get providerInstanceName => $_getSZ(6);
  @$pb.TagNumber(7)
  set providerInstanceName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProviderInstanceName() => $_has(6);
  @$pb.TagNumber(7)
  void clearProviderInstanceName() => $_clearField(7);

  @$pb.TagNumber(8)
  MediaListSortBy get sortBy => $_getN(7);
  @$pb.TagNumber(8)
  set sortBy(MediaListSortBy value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSortBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearSortBy() => $_clearField(8);

  @$pb.TagNumber(9)
  SortDirection get sortDirection => $_getN(8);
  @$pb.TagNumber(9)
  set sortDirection(SortDirection value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSortDirection() => $_has(8);
  @$pb.TagNumber(9)
  void clearSortDirection() => $_clearField(9);

  @$pb.TagNumber(10)
  ResourceAvailabilityFilter get availability => $_getN(9);
  @$pb.TagNumber(10)
  set availability(ResourceAvailabilityFilter value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAvailability() => $_has(9);
  @$pb.TagNumber(10)
  void clearAvailability() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get refresh => $_getBF(10);
  @$pb.TagNumber(11)
  set refresh($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRefresh() => $_has(10);
  @$pb.TagNumber(11)
  void clearRefresh() => $_clearField(11);
}

class ListPlaylistItemsResponse extends $pb.GeneratedMessage {
  factory ListPlaylistItemsResponse({
    $core.Iterable<Playlist>? playlists,
    $core.Iterable<Media>? media,
    $core.int? total,
    $core.int? folderCount,
    $core.int? fileCount,
    $core.Iterable<PlaylistItem>? dynamicItems,
    $core.Iterable<PlaylistBrowsePathNode>? currentPath,
    $core.String? version,
  }) {
    final result = create();
    if (playlists != null) result.playlists.addAll(playlists);
    if (media != null) result.media.addAll(media);
    if (total != null) result.total = total;
    if (folderCount != null) result.folderCount = folderCount;
    if (fileCount != null) result.fileCount = fileCount;
    if (dynamicItems != null) result.dynamicItems.addAll(dynamicItems);
    if (currentPath != null) result.currentPath.addAll(currentPath);
    if (version != null) result.version = version;
    return result;
  }

  ListPlaylistItemsResponse._();

  factory ListPlaylistItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPlaylistItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlaylistItemsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<Playlist>(1, _omitFieldNames ? '' : 'playlists',
        subBuilder: Playlist.create)
    ..pPM<Media>(2, _omitFieldNames ? '' : 'media', subBuilder: Media.create)
    ..aI(3, _omitFieldNames ? '' : 'total')
    ..aI(4, _omitFieldNames ? '' : 'folderCount')
    ..aI(5, _omitFieldNames ? '' : 'fileCount')
    ..pPM<PlaylistItem>(6, _omitFieldNames ? '' : 'dynamicItems',
        subBuilder: PlaylistItem.create)
    ..pPM<PlaylistBrowsePathNode>(7, _omitFieldNames ? '' : 'currentPath',
        subBuilder: PlaylistBrowsePathNode.create)
    ..aOS(8, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlaylistItemsResponse copyWith(
          void Function(ListPlaylistItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPlaylistItemsResponse))
          as ListPlaylistItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPlaylistItemsResponse create() => ListPlaylistItemsResponse._();
  @$core.override
  ListPlaylistItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPlaylistItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlaylistItemsResponse>(create);
  static ListPlaylistItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Playlist> get playlists => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Media> get media => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get total => $_getIZ(2);
  @$pb.TagNumber(3)
  set total($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotal() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get folderCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set folderCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFolderCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearFolderCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fileCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set fileCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFileCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileCount() => $_clearField(5);

  /// For dynamic playlists only
  @$pb.TagNumber(6)
  $pb.PbList<PlaylistItem> get dynamicItems => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<PlaylistBrowsePathNode> get currentPath => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get version => $_getSZ(7);
  @$pb.TagNumber(8)
  set version($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);
}

class PlaylistItem extends $pb.GeneratedMessage {
  factory PlaylistItem({
    $core.String? name,
    ItemType? itemType,
    $core.List<$core.int>? target,
    $fixnum.Int64? size,
    $core.String? thumbnail,
    $fixnum.Int64? modifiedAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (itemType != null) result.itemType = itemType;
    if (target != null) result.target = target;
    if (size != null) result.size = size;
    if (thumbnail != null) result.thumbnail = thumbnail;
    if (modifiedAt != null) result.modifiedAt = modifiedAt;
    return result;
  }

  PlaylistItem._();

  factory PlaylistItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<ItemType>(2, _omitFieldNames ? '' : 'itemType',
        enumValues: ItemType.values)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'target', $pb.PbFieldType.OY)
    ..aInt64(4, _omitFieldNames ? '' : 'size')
    ..aOS(5, _omitFieldNames ? '' : 'thumbnail')
    ..aInt64(6, _omitFieldNames ? '' : 'modifiedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistItem copyWith(void Function(PlaylistItem) updates) =>
      super.copyWith((message) => updates(message as PlaylistItem))
          as PlaylistItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistItem create() => PlaylistItem._();
  @$core.override
  PlaylistItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistItem>(create);
  static PlaylistItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  ItemType get itemType => $_getN(1);
  @$pb.TagNumber(2)
  set itemType(ItemType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItemType() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get target => $_getN(2);
  @$pb.TagNumber(3)
  set target($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get size => $_getI64(3);
  @$pb.TagNumber(4)
  set size($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get thumbnail => $_getSZ(4);
  @$pb.TagNumber(5)
  set thumbnail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasThumbnail() => $_has(4);
  @$pb.TagNumber(5)
  void clearThumbnail() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get modifiedAt => $_getI64(5);
  @$pb.TagNumber(6)
  set modifiedAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModifiedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearModifiedAt() => $_clearField(6);
}

class PlaylistBrowsePathNode extends $pb.GeneratedMessage {
  factory PlaylistBrowsePathNode({
    $core.String? playlistId,
    $core.String? name,
    $core.List<$core.int>? target,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    if (name != null) result.name = name;
    if (target != null) result.target = target;
    return result;
  }

  PlaylistBrowsePathNode._();

  factory PlaylistBrowsePathNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistBrowsePathNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistBrowsePathNode',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'target', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistBrowsePathNode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistBrowsePathNode copyWith(
          void Function(PlaylistBrowsePathNode) updates) =>
      super.copyWith((message) => updates(message as PlaylistBrowsePathNode))
          as PlaylistBrowsePathNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistBrowsePathNode create() => PlaylistBrowsePathNode._();
  @$core.override
  PlaylistBrowsePathNode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistBrowsePathNode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistBrowsePathNode>(create);
  static PlaylistBrowsePathNode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get target => $_getN(2);
  @$pb.TagNumber(3)
  set target($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);
}

class MoveMediaRequest extends $pb.GeneratedMessage {
  factory MoveMediaRequest({
    $core.Iterable<$core.String>? mediaIds,
    $core.String? sourcePlaylistId,
    $core.String? targetPlaylistId,
    $core.bool? allFromScope,
    $core.String? beforeMediaId,
    $core.String? afterMediaId,
  }) {
    final result = create();
    if (mediaIds != null) result.mediaIds.addAll(mediaIds);
    if (sourcePlaylistId != null) result.sourcePlaylistId = sourcePlaylistId;
    if (targetPlaylistId != null) result.targetPlaylistId = targetPlaylistId;
    if (allFromScope != null) result.allFromScope = allFromScope;
    if (beforeMediaId != null) result.beforeMediaId = beforeMediaId;
    if (afterMediaId != null) result.afterMediaId = afterMediaId;
    return result;
  }

  MoveMediaRequest._();

  factory MoveMediaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveMediaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveMediaRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'mediaIds')
    ..aOS(2, _omitFieldNames ? '' : 'sourcePlaylistId')
    ..aOS(3, _omitFieldNames ? '' : 'targetPlaylistId')
    ..aOB(4, _omitFieldNames ? '' : 'allFromScope')
    ..aOS(5, _omitFieldNames ? '' : 'beforeMediaId')
    ..aOS(6, _omitFieldNames ? '' : 'afterMediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveMediaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveMediaRequest copyWith(void Function(MoveMediaRequest) updates) =>
      super.copyWith((message) => updates(message as MoveMediaRequest))
          as MoveMediaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveMediaRequest create() => MoveMediaRequest._();
  @$core.override
  MoveMediaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveMediaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveMediaRequest>(create);
  static MoveMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get mediaIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get sourcePlaylistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourcePlaylistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourcePlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourcePlaylistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetPlaylistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetPlaylistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetPlaylistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetPlaylistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get allFromScope => $_getBF(3);
  @$pb.TagNumber(4)
  set allFromScope($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAllFromScope() => $_has(3);
  @$pb.TagNumber(4)
  void clearAllFromScope() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get beforeMediaId => $_getSZ(4);
  @$pb.TagNumber(5)
  set beforeMediaId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBeforeMediaId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBeforeMediaId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get afterMediaId => $_getSZ(5);
  @$pb.TagNumber(6)
  set afterMediaId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAfterMediaId() => $_has(5);
  @$pb.TagNumber(6)
  void clearAfterMediaId() => $_clearField(6);
}

class MoveMediaResponse extends $pb.GeneratedMessage {
  factory MoveMediaResponse({
    $core.int? movedCount,
    $core.Iterable<Media>? media,
  }) {
    final result = create();
    if (movedCount != null) result.movedCount = movedCount;
    if (media != null) result.media.addAll(media);
    return result;
  }

  MoveMediaResponse._();

  factory MoveMediaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveMediaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveMediaResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'movedCount')
    ..pPM<Media>(2, _omitFieldNames ? '' : 'media', subBuilder: Media.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveMediaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveMediaResponse copyWith(void Function(MoveMediaResponse) updates) =>
      super.copyWith((message) => updates(message as MoveMediaResponse))
          as MoveMediaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveMediaResponse create() => MoveMediaResponse._();
  @$core.override
  MoveMediaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveMediaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveMediaResponse>(create);
  static MoveMediaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get movedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set movedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMovedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearMovedCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Media> get media => $_getList(1);
}

/// Edit Media
class EditMediaRequest extends $pb.GeneratedMessage {
  factory EditMediaRequest({
    $core.String? mediaId,
    $core.String? name,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (name != null) result.name = name;
    return result;
  }

  EditMediaRequest._();

  factory EditMediaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EditMediaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EditMediaRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EditMediaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EditMediaRequest copyWith(void Function(EditMediaRequest) updates) =>
      super.copyWith((message) => updates(message as EditMediaRequest))
          as EditMediaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EditMediaRequest create() => EditMediaRequest._();
  @$core.override
  EditMediaRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EditMediaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EditMediaRequest>(create);
  static EditMediaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class EditMediaResponse extends $pb.GeneratedMessage {
  factory EditMediaResponse({
    Media? media,
  }) {
    final result = create();
    if (media != null) result.media = media;
    return result;
  }

  EditMediaResponse._();

  factory EditMediaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EditMediaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EditMediaResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Media>(1, _omitFieldNames ? '' : 'media', subBuilder: Media.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EditMediaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EditMediaResponse copyWith(void Function(EditMediaResponse) updates) =>
      super.copyWith((message) => updates(message as EditMediaResponse))
          as EditMediaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EditMediaResponse create() => EditMediaResponse._();
  @$core.override
  EditMediaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EditMediaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EditMediaResponse>(create);
  static EditMediaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Media get media => $_getN(0);
  @$pb.TagNumber(1)
  set media(Media value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMedia() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedia() => $_clearField(1);
  @$pb.TagNumber(1)
  Media ensureMedia() => $_ensure(0);
}

/// Clear Playlist
class ClearPlaylistRequest extends $pb.GeneratedMessage {
  factory ClearPlaylistRequest({
    $core.String? playlistId,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    return result;
  }

  ClearPlaylistRequest._();

  factory ClearPlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearPlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearPlaylistRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearPlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearPlaylistRequest copyWith(void Function(ClearPlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as ClearPlaylistRequest))
          as ClearPlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearPlaylistRequest create() => ClearPlaylistRequest._();
  @$core.override
  ClearPlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearPlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearPlaylistRequest>(create);
  static ClearPlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);
}

class ClearPlaylistResponse extends $pb.GeneratedMessage {
  factory ClearPlaylistResponse({
    $core.bool? success,
    $core.int? deletedCount,
    $core.int? deletedPlaylists,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (deletedCount != null) result.deletedCount = deletedCount;
    if (deletedPlaylists != null) result.deletedPlaylists = deletedPlaylists;
    return result;
  }

  ClearPlaylistResponse._();

  factory ClearPlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearPlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearPlaylistResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'deletedCount')
    ..aI(3, _omitFieldNames ? '' : 'deletedPlaylists')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearPlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearPlaylistResponse copyWith(
          void Function(ClearPlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as ClearPlaylistResponse))
          as ClearPlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearPlaylistResponse create() => ClearPlaylistResponse._();
  @$core.override
  ClearPlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearPlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearPlaylistResponse>(create);
  static ClearPlaylistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get deletedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set deletedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeletedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeletedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get deletedPlaylists => $_getIZ(2);
  @$pb.TagNumber(3)
  set deletedPlaylists($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeletedPlaylists() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeletedPlaylists() => $_clearField(3);
}

/// Batch Media Operations
class AddMediaBatchRequest extends $pb.GeneratedMessage {
  factory AddMediaBatchRequest({
    $core.Iterable<AddMediaRequest>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  AddMediaBatchRequest._();

  factory AddMediaBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMediaBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMediaBatchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<AddMediaRequest>(1, _omitFieldNames ? '' : 'items',
        subBuilder: AddMediaRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaBatchRequest copyWith(void Function(AddMediaBatchRequest) updates) =>
      super.copyWith((message) => updates(message as AddMediaBatchRequest))
          as AddMediaBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMediaBatchRequest create() => AddMediaBatchRequest._();
  @$core.override
  AddMediaBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMediaBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMediaBatchRequest>(create);
  static AddMediaBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AddMediaRequest> get items => $_getList(0);
}

class AddMediaBatchResponse extends $pb.GeneratedMessage {
  factory AddMediaBatchResponse({
    $core.Iterable<AddMediaResponse>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  AddMediaBatchResponse._();

  factory AddMediaBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMediaBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMediaBatchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<AddMediaResponse>(1, _omitFieldNames ? '' : 'results',
        subBuilder: AddMediaResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMediaBatchResponse copyWith(
          void Function(AddMediaBatchResponse) updates) =>
      super.copyWith((message) => updates(message as AddMediaBatchResponse))
          as AddMediaBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMediaBatchResponse create() => AddMediaBatchResponse._();
  @$core.override
  AddMediaBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMediaBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMediaBatchResponse>(create);
  static AddMediaBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AddMediaResponse> get results => $_getList(0);
}

class UpdatePlaybackRequest extends $pb.GeneratedMessage {
  factory UpdatePlaybackRequest({
    PlaybackUpdateType? type,
    $core.bool? playing,
    $core.double? position,
    $core.double? speed,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (playing != null) result.playing = playing;
    if (position != null) result.position = position;
    if (speed != null) result.speed = speed;
    if (version != null) result.version = version;
    return result;
  }

  UpdatePlaybackRequest._();

  factory UpdatePlaybackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatePlaybackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePlaybackRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<PlaybackUpdateType>(1, _omitFieldNames ? '' : 'type',
        enumValues: PlaybackUpdateType.values)
    ..aOB(2, _omitFieldNames ? '' : 'playing')
    ..aD(3, _omitFieldNames ? '' : 'position')
    ..aD(4, _omitFieldNames ? '' : 'speed')
    ..aInt64(5, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlaybackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePlaybackRequest copyWith(
          void Function(UpdatePlaybackRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePlaybackRequest))
          as UpdatePlaybackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePlaybackRequest create() => UpdatePlaybackRequest._();
  @$core.override
  UpdatePlaybackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatePlaybackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePlaybackRequest>(create);
  static UpdatePlaybackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PlaybackUpdateType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(PlaybackUpdateType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get playing => $_getBF(1);
  @$pb.TagNumber(2)
  set playing($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaying() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaying() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get position => $_getN(2);
  @$pb.TagNumber(3)
  set position($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get speed => $_getN(3);
  @$pb.TagNumber(4)
  set speed($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeed() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeed() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get version => $_getI64(4);
  @$pb.TagNumber(5)
  set version($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);
}

class PlaybackClientProfile extends $pb.GeneratedMessage {
  factory PlaybackClientProfile({
    PlaybackDeliveryPreference? deliveryPreference,
    $fixnum.Int64? maxStreamingBitrate,
    $core.int? maxAudioChannels,
    $core.Iterable<PlaybackVideoCodec>? supportedVideoCodecs,
    $core.Iterable<PlaybackContainer>? supportedContainers,
    PlaybackAudioCapability? audioCapability,
    PlaybackSubtitlePreference? subtitlePreference,
  }) {
    final result = create();
    if (deliveryPreference != null)
      result.deliveryPreference = deliveryPreference;
    if (maxStreamingBitrate != null)
      result.maxStreamingBitrate = maxStreamingBitrate;
    if (maxAudioChannels != null) result.maxAudioChannels = maxAudioChannels;
    if (supportedVideoCodecs != null)
      result.supportedVideoCodecs.addAll(supportedVideoCodecs);
    if (supportedContainers != null)
      result.supportedContainers.addAll(supportedContainers);
    if (audioCapability != null) result.audioCapability = audioCapability;
    if (subtitlePreference != null)
      result.subtitlePreference = subtitlePreference;
    return result;
  }

  PlaybackClientProfile._();

  factory PlaybackClientProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackClientProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackClientProfile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<PlaybackDeliveryPreference>(
        1, _omitFieldNames ? '' : 'deliveryPreference',
        enumValues: PlaybackDeliveryPreference.values)
    ..aInt64(2, _omitFieldNames ? '' : 'maxStreamingBitrate')
    ..aI(3, _omitFieldNames ? '' : 'maxAudioChannels')
    ..pc<PlaybackVideoCodec>(
        4, _omitFieldNames ? '' : 'supportedVideoCodecs', $pb.PbFieldType.KE,
        valueOf: PlaybackVideoCodec.valueOf,
        enumValues: PlaybackVideoCodec.values,
        defaultEnumValue: PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_UNSPECIFIED)
    ..pc<PlaybackContainer>(
        5, _omitFieldNames ? '' : 'supportedContainers', $pb.PbFieldType.KE,
        valueOf: PlaybackContainer.valueOf,
        enumValues: PlaybackContainer.values,
        defaultEnumValue: PlaybackContainer.PLAYBACK_CONTAINER_UNSPECIFIED)
    ..aE<PlaybackAudioCapability>(6, _omitFieldNames ? '' : 'audioCapability',
        enumValues: PlaybackAudioCapability.values)
    ..aE<PlaybackSubtitlePreference>(
        7, _omitFieldNames ? '' : 'subtitlePreference',
        enumValues: PlaybackSubtitlePreference.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackClientProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackClientProfile copyWith(
          void Function(PlaybackClientProfile) updates) =>
      super.copyWith((message) => updates(message as PlaybackClientProfile))
          as PlaybackClientProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackClientProfile create() => PlaybackClientProfile._();
  @$core.override
  PlaybackClientProfile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackClientProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackClientProfile>(create);
  static PlaybackClientProfile? _defaultInstance;

  @$pb.TagNumber(1)
  PlaybackDeliveryPreference get deliveryPreference => $_getN(0);
  @$pb.TagNumber(1)
  set deliveryPreference(PlaybackDeliveryPreference value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeliveryPreference() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeliveryPreference() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxStreamingBitrate => $_getI64(1);
  @$pb.TagNumber(2)
  set maxStreamingBitrate($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxStreamingBitrate() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxStreamingBitrate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxAudioChannels => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxAudioChannels($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxAudioChannels() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxAudioChannels() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PlaybackVideoCodec> get supportedVideoCodecs => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<PlaybackContainer> get supportedContainers => $_getList(4);

  @$pb.TagNumber(6)
  PlaybackAudioCapability get audioCapability => $_getN(5);
  @$pb.TagNumber(6)
  set audioCapability(PlaybackAudioCapability value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAudioCapability() => $_has(5);
  @$pb.TagNumber(6)
  void clearAudioCapability() => $_clearField(6);

  @$pb.TagNumber(7)
  PlaybackSubtitlePreference get subtitlePreference => $_getN(6);
  @$pb.TagNumber(7)
  set subtitlePreference(PlaybackSubtitlePreference value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSubtitlePreference() => $_has(6);
  @$pb.TagNumber(7)
  void clearSubtitlePreference() => $_clearField(7);
}

class GetPlaybackRequest extends $pb.GeneratedMessage {
  factory GetPlaybackRequest({
    PlaybackClientProfile? playbackClientProfile,
  }) {
    final result = create();
    if (playbackClientProfile != null)
      result.playbackClientProfile = playbackClientProfile;
    return result;
  }

  GetPlaybackRequest._();

  factory GetPlaybackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlaybackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlaybackRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PlaybackClientProfile>(
        1, _omitFieldNames ? '' : 'playbackClientProfile',
        subBuilder: PlaybackClientProfile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaybackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaybackRequest copyWith(void Function(GetPlaybackRequest) updates) =>
      super.copyWith((message) => updates(message as GetPlaybackRequest))
          as GetPlaybackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlaybackRequest create() => GetPlaybackRequest._();
  @$core.override
  GetPlaybackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlaybackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlaybackRequest>(create);
  static GetPlaybackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PlaybackClientProfile get playbackClientProfile => $_getN(0);
  @$pb.TagNumber(1)
  set playbackClientProfile(PlaybackClientProfile value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaybackClientProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaybackClientProfile() => $_clearField(1);
  @$pb.TagNumber(1)
  PlaybackClientProfile ensurePlaybackClientProfile() => $_ensure(0);
}

class GetPlaybackResponse extends $pb.GeneratedMessage {
  factory GetPlaybackResponse({
    PlaybackState? playbackState,
    PlaybackSnapshot? playbackSnapshot,
  }) {
    final result = create();
    if (playbackState != null) result.playbackState = playbackState;
    if (playbackSnapshot != null) result.playbackSnapshot = playbackSnapshot;
    return result;
  }

  GetPlaybackResponse._();

  factory GetPlaybackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPlaybackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlaybackResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PlaybackState>(1, _omitFieldNames ? '' : 'playbackState',
        subBuilder: PlaybackState.create)
    ..aOM<PlaybackSnapshot>(2, _omitFieldNames ? '' : 'playbackSnapshot',
        subBuilder: PlaybackSnapshot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaybackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlaybackResponse copyWith(void Function(GetPlaybackResponse) updates) =>
      super.copyWith((message) => updates(message as GetPlaybackResponse))
          as GetPlaybackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPlaybackResponse create() => GetPlaybackResponse._();
  @$core.override
  GetPlaybackResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPlaybackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlaybackResponse>(create);
  static GetPlaybackResponse? _defaultInstance;

  /// Playback state (current time, speed, is_playing, etc.)
  @$pb.TagNumber(1)
  PlaybackState get playbackState => $_getN(0);
  @$pb.TagNumber(1)
  set playbackState(PlaybackState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaybackState() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaybackState() => $_clearField(1);
  @$pb.TagNumber(1)
  PlaybackState ensurePlaybackState() => $_ensure(0);

  /// Versioned playback snapshot for the current source.
  @$pb.TagNumber(2)
  PlaybackSnapshot get playbackSnapshot => $_getN(1);
  @$pb.TagNumber(2)
  set playbackSnapshot(PlaybackSnapshot value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaybackSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaybackSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  PlaybackSnapshot ensurePlaybackSnapshot() => $_ensure(1);
}

/// Versioned playback information for the current source.
class PlaybackSnapshot extends $pb.GeneratedMessage {
  factory PlaybackSnapshot({
    $core.String? mediaId,
    $core.String? playlistId,
    $core.String? roomId,
    $core.String? name,
    $core.double? position,
    $core.Iterable<$core.MapEntry<$core.String, PlaybackInfo>>? playbackInfos,
    $core.String? defaultMode,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
    $core.String? version,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (playlistId != null) result.playlistId = playlistId;
    if (roomId != null) result.roomId = roomId;
    if (name != null) result.name = name;
    if (position != null) result.position = position;
    if (playbackInfos != null) result.playbackInfos.addEntries(playbackInfos);
    if (defaultMode != null) result.defaultMode = defaultMode;
    if (metadata != null) result.metadata.addEntries(metadata);
    if (version != null) result.version = version;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  PlaybackSnapshot._();

  factory PlaybackSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackSnapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'playlistId')
    ..aOS(3, _omitFieldNames ? '' : 'roomId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aD(5, _omitFieldNames ? '' : 'position')
    ..m<$core.String, PlaybackInfo>(6, _omitFieldNames ? '' : 'playbackInfos',
        entryClassName: 'PlaybackSnapshot.PlaybackInfosEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PlaybackInfo.create,
        valueDefaultOrMaker: PlaybackInfo.getDefault,
        packageName: const $pb.PackageName('synctv.client'))
    ..aOS(7, _omitFieldNames ? '' : 'defaultMode')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'PlaybackSnapshot.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.client'))
    ..aOS(9, _omitFieldNames ? '' : 'version')
    ..aInt64(10, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackSnapshot copyWith(void Function(PlaybackSnapshot) updates) =>
      super.copyWith((message) => updates(message as PlaybackSnapshot))
          as PlaybackSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackSnapshot create() => PlaybackSnapshot._();
  @$core.override
  PlaybackSnapshot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackSnapshot>(create);
  static PlaybackSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get roomId => $_getSZ(2);
  @$pb.TagNumber(3)
  set roomId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get position => $_getN(4);
  @$pb.TagNumber(5)
  set position($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPosition() => $_has(4);
  @$pb.TagNumber(5)
  void clearPosition() => $_clearField(5);

  /// Multiple playback modes (e.g., "direct", "proxied", "cdn1", "cdn2")
  /// Provider can define arbitrary mode names
  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, PlaybackInfo> get playbackInfos => $_getMap(5);

  /// Default mode name (must be a key in playback_infos)
  @$pb.TagNumber(7)
  $core.String get defaultMode => $_getSZ(6);
  @$pb.TagNumber(7)
  set defaultMode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDefaultMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearDefaultMode() => $_clearField(7);

  /// Media-level metadata (duration, thumbnail, title, author, etc.)
  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(7);

  /// Version scoped to playback snapshots.
  @$pb.TagNumber(9)
  $core.String get version => $_getSZ(8);
  @$pb.TagNumber(9)
  set version($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);

  /// Earliest URL expiration across the snapshot, if any.
  @$pb.TagNumber(10)
  $fixnum.Int64 get expiresAt => $_getI64(9);
  @$pb.TagNumber(10)
  set expiresAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExpiresAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearExpiresAt() => $_clearField(10);
}

/// Playback information for a single mode
class PlaybackInfo extends $pb.GeneratedMessage {
  factory PlaybackInfo({
    $core.Iterable<PlaybackUrl>? urls,
    $core.int? defaultUrlIndex,
    $core.Iterable<Subtitle>? subtitles,
    $core.int? defaultSubtitleIndex,
    $core.Iterable<Danmaku>? danmakus,
    $core.String? format,
  }) {
    final result = create();
    if (urls != null) result.urls.addAll(urls);
    if (defaultUrlIndex != null) result.defaultUrlIndex = defaultUrlIndex;
    if (subtitles != null) result.subtitles.addAll(subtitles);
    if (defaultSubtitleIndex != null)
      result.defaultSubtitleIndex = defaultSubtitleIndex;
    if (danmakus != null) result.danmakus.addAll(danmakus);
    if (format != null) result.format = format;
    return result;
  }

  PlaybackInfo._();

  factory PlaybackInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<PlaybackUrl>(1, _omitFieldNames ? '' : 'urls',
        subBuilder: PlaybackUrl.create)
    ..aI(2, _omitFieldNames ? '' : 'defaultUrlIndex')
    ..pPM<Subtitle>(3, _omitFieldNames ? '' : 'subtitles',
        subBuilder: Subtitle.create)
    ..aI(4, _omitFieldNames ? '' : 'defaultSubtitleIndex')
    ..pPM<Danmaku>(5, _omitFieldNames ? '' : 'danmakus',
        subBuilder: Danmaku.create)
    ..aOS(6, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackInfo copyWith(void Function(PlaybackInfo) updates) =>
      super.copyWith((message) => updates(message as PlaybackInfo))
          as PlaybackInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackInfo create() => PlaybackInfo._();
  @$core.override
  PlaybackInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackInfo>(create);
  static PlaybackInfo? _defaultInstance;

  /// List of playback URLs (different qualities, codecs)
  @$pb.TagNumber(1)
  $pb.PbList<PlaybackUrl> get urls => $_getList(0);

  /// Default URL index
  @$pb.TagNumber(2)
  $core.int get defaultUrlIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set defaultUrlIndex($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultUrlIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultUrlIndex() => $_clearField(2);

  /// Subtitle list
  @$pb.TagNumber(3)
  $pb.PbList<Subtitle> get subtitles => $_getList(2);

  /// Default subtitle index (optional)
  @$pb.TagNumber(4)
  $core.int get defaultSubtitleIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set defaultSubtitleIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefaultSubtitleIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultSubtitleIndex() => $_clearField(4);

  /// Danmaku list
  @$pb.TagNumber(5)
  $pb.PbList<Danmaku> get danmakus => $_getList(4);

  /// Format type (e.g., "m3u8", "mp4", "flv")
  @$pb.TagNumber(6)
  $core.String get format => $_getSZ(5);
  @$pb.TagNumber(6)
  set format($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFormat() => $_has(5);
  @$pb.TagNumber(6)
  void clearFormat() => $_clearField(6);
}

/// Playback URL (represents a quality/codec option)
class PlaybackUrl extends $pb.GeneratedMessage {
  factory PlaybackUrl({
    $core.String? name,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $fixnum.Int64? expireAt,
    PlaybackUrlMetadata? metadata,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (expireAt != null) result.expireAt = expireAt;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  PlaybackUrl._();

  factory PlaybackUrl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackUrl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackUrl',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'headers',
        entryClassName: 'PlaybackUrl.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.client'))
    ..aInt64(4, _omitFieldNames ? '' : 'expireAt')
    ..aOM<PlaybackUrlMetadata>(5, _omitFieldNames ? '' : 'metadata',
        subBuilder: PlaybackUrlMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackUrl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackUrl copyWith(void Function(PlaybackUrl) updates) =>
      super.copyWith((message) => updates(message as PlaybackUrl))
          as PlaybackUrl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackUrl create() => PlaybackUrl._();
  @$core.override
  PlaybackUrl createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackUrl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackUrl>(create);
  static PlaybackUrl? _defaultInstance;

  /// Display name (e.g., "1080P", "HEVC 4K", "720P")
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Complete URL
  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  /// Request headers (if needed)
  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(2);

  /// Expiration time (Unix timestamp, optional)
  @$pb.TagNumber(4)
  $fixnum.Int64 get expireAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expireAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpireAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpireAt() => $_clearField(4);

  /// URL-level metadata (resolution, codec, bitrate, fps, etc.)
  @$pb.TagNumber(5)
  PlaybackUrlMetadata get metadata => $_getN(4);
  @$pb.TagNumber(5)
  set metadata(PlaybackUrlMetadata value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMetadata() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadata() => $_clearField(5);
  @$pb.TagNumber(5)
  PlaybackUrlMetadata ensureMetadata() => $_ensure(4);
}

/// URL-level metadata
class PlaybackUrlMetadata extends $pb.GeneratedMessage {
  factory PlaybackUrlMetadata({
    $core.String? resolution,
    $fixnum.Int64? bitrate,
    $core.String? codec,
    $core.int? fps,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? extra,
  }) {
    final result = create();
    if (resolution != null) result.resolution = resolution;
    if (bitrate != null) result.bitrate = bitrate;
    if (codec != null) result.codec = codec;
    if (fps != null) result.fps = fps;
    if (extra != null) result.extra.addEntries(extra);
    return result;
  }

  PlaybackUrlMetadata._();

  factory PlaybackUrlMetadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackUrlMetadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackUrlMetadata',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resolution')
    ..aInt64(2, _omitFieldNames ? '' : 'bitrate')
    ..aOS(3, _omitFieldNames ? '' : 'codec')
    ..aI(4, _omitFieldNames ? '' : 'fps')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'extra',
        entryClassName: 'PlaybackUrlMetadata.ExtraEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.client'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackUrlMetadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackUrlMetadata copyWith(void Function(PlaybackUrlMetadata) updates) =>
      super.copyWith((message) => updates(message as PlaybackUrlMetadata))
          as PlaybackUrlMetadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackUrlMetadata create() => PlaybackUrlMetadata._();
  @$core.override
  PlaybackUrlMetadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackUrlMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackUrlMetadata>(create);
  static PlaybackUrlMetadata? _defaultInstance;

  /// Resolution (e.g., "1920x1080", "1280x720")
  @$pb.TagNumber(1)
  $core.String get resolution => $_getSZ(0);
  @$pb.TagNumber(1)
  set resolution($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResolution() => $_has(0);
  @$pb.TagNumber(1)
  void clearResolution() => $_clearField(1);

  /// Bitrate in bps
  @$pb.TagNumber(2)
  $fixnum.Int64 get bitrate => $_getI64(1);
  @$pb.TagNumber(2)
  set bitrate($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBitrate() => $_has(1);
  @$pb.TagNumber(2)
  void clearBitrate() => $_clearField(2);

  /// Video codec (e.g., "avc", "hevc", "av1")
  @$pb.TagNumber(3)
  $core.String get codec => $_getSZ(2);
  @$pb.TagNumber(3)
  set codec($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCodec() => $_has(2);
  @$pb.TagNumber(3)
  void clearCodec() => $_clearField(3);

  /// Frame rate
  @$pb.TagNumber(4)
  $core.int get fps => $_getIZ(3);
  @$pb.TagNumber(4)
  set fps($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFps() => $_has(3);
  @$pb.TagNumber(4)
  void clearFps() => $_clearField(4);

  /// Additional metadata
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get extra => $_getMap(4);
}

/// Subtitle information
class Subtitle extends $pb.GeneratedMessage {
  factory Subtitle({
    $core.String? name,
    $core.String? language,
    $core.Iterable<SubtitleUrl>? urls,
    $core.int? defaultUrlIndex,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (language != null) result.language = language;
    if (urls != null) result.urls.addAll(urls);
    if (defaultUrlIndex != null) result.defaultUrlIndex = defaultUrlIndex;
    return result;
  }

  Subtitle._();

  factory Subtitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Subtitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Subtitle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'language')
    ..pPM<SubtitleUrl>(3, _omitFieldNames ? '' : 'urls',
        subBuilder: SubtitleUrl.create)
    ..aI(4, _omitFieldNames ? '' : 'defaultUrlIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subtitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subtitle copyWith(void Function(Subtitle) updates) =>
      super.copyWith((message) => updates(message as Subtitle)) as Subtitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subtitle create() => Subtitle._();
  @$core.override
  Subtitle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Subtitle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subtitle>(create);
  static Subtitle? _defaultInstance;

  /// Display name (e.g., "Chinese (Simplified)", "English")
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Language code (e.g., "zh-CN", "en-US")
  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => $_clearField(2);

  /// Subtitle URL list (multiple sources/formats)
  @$pb.TagNumber(3)
  $pb.PbList<SubtitleUrl> get urls => $_getList(2);

  /// Default URL index
  @$pb.TagNumber(4)
  $core.int get defaultUrlIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set defaultUrlIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefaultUrlIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultUrlIndex() => $_clearField(4);
}

/// Subtitle URL
class SubtitleUrl extends $pb.GeneratedMessage {
  factory SubtitleUrl({
    $core.String? name,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
    return result;
  }

  SubtitleUrl._();

  factory SubtitleUrl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubtitleUrl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubtitleUrl',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'headers',
        entryClassName: 'SubtitleUrl.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.client'))
    ..aOS(4, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubtitleUrl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubtitleUrl copyWith(void Function(SubtitleUrl) updates) =>
      super.copyWith((message) => updates(message as SubtitleUrl))
          as SubtitleUrl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubtitleUrl create() => SubtitleUrl._();
  @$core.override
  SubtitleUrl createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubtitleUrl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubtitleUrl>(create);
  static SubtitleUrl? _defaultInstance;

  /// Display name (e.g., "Original", "AI Translation")
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Subtitle file URL
  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  /// Request headers (if needed)
  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(2);

  /// Format (e.g., "json", "srt", "vtt")
  @$pb.TagNumber(4)
  $core.String get format => $_getSZ(3);
  @$pb.TagNumber(4)
  set format($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);
}

/// Danmaku (bullet comments) information
class Danmaku extends $pb.GeneratedMessage {
  factory Danmaku({
    $core.String? name,
    $core.String? url,
    $core.String? format,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (format != null) result.format = format;
    if (headers != null) result.headers.addEntries(headers);
    return result;
  }

  Danmaku._();

  factory Danmaku.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Danmaku.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Danmaku',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'format')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'headers',
        entryClassName: 'Danmaku.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.client'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Danmaku clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Danmaku copyWith(void Function(Danmaku) updates) =>
      super.copyWith((message) => updates(message as Danmaku)) as Danmaku;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Danmaku create() => Danmaku._();
  @$core.override
  Danmaku createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Danmaku getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Danmaku>(create);
  static Danmaku? _defaultInstance;

  /// Display name (e.g., "Bilibili Danmaku", "Local Danmaku")
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Danmaku API URL or file URL
  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  /// Format type (e.g., "bilibili", "ass", "xml")
  @$pb.TagNumber(3)
  $core.String get format => $_getSZ(2);
  @$pb.TagNumber(3)
  set format($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);

  /// Request headers (if needed)
  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(3);
}

enum ClientMessage_Message {
  chat,
  heartbeat,
  playbackProgress,
  playbackUpdate,
  observeResource,
  unobserveResource,
  webrtcOffer,
  webrtcAnswer,
  webrtcIceCandidate,
  webrtcJoin,
  webrtcLeave,
  notSet
}

/// Real-time Messaging
class ClientMessage extends $pb.GeneratedMessage {
  factory ClientMessage({
    ChatMessageSend? chat,
    HeartbeatMessage? heartbeat,
    PlaybackProgressReport? playbackProgress,
    UpdatePlaybackRequest? playbackUpdate,
    ObserveResource? observeResource,
    UnobserveResource? unobserveResource,
    WebRTCOffer? webrtcOffer,
    WebRTCAnswer? webrtcAnswer,
    WebRTCIceCandidate? webrtcIceCandidate,
    WebRTCJoin? webrtcJoin,
    WebRTCLeave? webrtcLeave,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    if (heartbeat != null) result.heartbeat = heartbeat;
    if (playbackProgress != null) result.playbackProgress = playbackProgress;
    if (playbackUpdate != null) result.playbackUpdate = playbackUpdate;
    if (observeResource != null) result.observeResource = observeResource;
    if (unobserveResource != null) result.unobserveResource = unobserveResource;
    if (webrtcOffer != null) result.webrtcOffer = webrtcOffer;
    if (webrtcAnswer != null) result.webrtcAnswer = webrtcAnswer;
    if (webrtcIceCandidate != null)
      result.webrtcIceCandidate = webrtcIceCandidate;
    if (webrtcJoin != null) result.webrtcJoin = webrtcJoin;
    if (webrtcLeave != null) result.webrtcLeave = webrtcLeave;
    return result;
  }

  ClientMessage._();

  factory ClientMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientMessage_Message>
      _ClientMessage_MessageByTag = {
    1: ClientMessage_Message.chat,
    2: ClientMessage_Message.heartbeat,
    3: ClientMessage_Message.playbackProgress,
    4: ClientMessage_Message.playbackUpdate,
    5: ClientMessage_Message.observeResource,
    6: ClientMessage_Message.unobserveResource,
    7: ClientMessage_Message.webrtcOffer,
    8: ClientMessage_Message.webrtcAnswer,
    9: ClientMessage_Message.webrtcIceCandidate,
    10: ClientMessage_Message.webrtcJoin,
    11: ClientMessage_Message.webrtcLeave,
    0: ClientMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    ..aOM<ChatMessageSend>(1, _omitFieldNames ? '' : 'chat',
        subBuilder: ChatMessageSend.create)
    ..aOM<HeartbeatMessage>(2, _omitFieldNames ? '' : 'heartbeat',
        subBuilder: HeartbeatMessage.create)
    ..aOM<PlaybackProgressReport>(3, _omitFieldNames ? '' : 'playbackProgress',
        subBuilder: PlaybackProgressReport.create)
    ..aOM<UpdatePlaybackRequest>(4, _omitFieldNames ? '' : 'playbackUpdate',
        subBuilder: UpdatePlaybackRequest.create)
    ..aOM<ObserveResource>(5, _omitFieldNames ? '' : 'observeResource',
        subBuilder: ObserveResource.create)
    ..aOM<UnobserveResource>(6, _omitFieldNames ? '' : 'unobserveResource',
        subBuilder: UnobserveResource.create)
    ..aOM<WebRTCOffer>(7, _omitFieldNames ? '' : 'webrtcOffer',
        subBuilder: WebRTCOffer.create)
    ..aOM<WebRTCAnswer>(8, _omitFieldNames ? '' : 'webrtcAnswer',
        subBuilder: WebRTCAnswer.create)
    ..aOM<WebRTCIceCandidate>(9, _omitFieldNames ? '' : 'webrtcIceCandidate',
        subBuilder: WebRTCIceCandidate.create)
    ..aOM<WebRTCJoin>(10, _omitFieldNames ? '' : 'webrtcJoin',
        subBuilder: WebRTCJoin.create)
    ..aOM<WebRTCLeave>(11, _omitFieldNames ? '' : 'webrtcLeave',
        subBuilder: WebRTCLeave.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientMessage copyWith(void Function(ClientMessage) updates) =>
      super.copyWith((message) => updates(message as ClientMessage))
          as ClientMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientMessage create() => ClientMessage._();
  @$core.override
  ClientMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientMessage>(create);
  static ClientMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  ClientMessage_Message whichMessage() =>
      _ClientMessage_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  void clearMessage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ChatMessageSend get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(ChatMessageSend value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessageSend ensureChat() => $_ensure(0);

  @$pb.TagNumber(2)
  HeartbeatMessage get heartbeat => $_getN(1);
  @$pb.TagNumber(2)
  set heartbeat(HeartbeatMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHeartbeat() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeartbeat() => $_clearField(2);
  @$pb.TagNumber(2)
  HeartbeatMessage ensureHeartbeat() => $_ensure(1);

  /// Playback progress heartbeat: client periodically reports playback position
  @$pb.TagNumber(3)
  PlaybackProgressReport get playbackProgress => $_getN(2);
  @$pb.TagNumber(3)
  set playbackProgress(PlaybackProgressReport value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlaybackProgress() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlaybackProgress() => $_clearField(3);
  @$pb.TagNumber(3)
  PlaybackProgressReport ensurePlaybackProgress() => $_ensure(2);

  /// Playback state update command (real-time)
  @$pb.TagNumber(4)
  UpdatePlaybackRequest get playbackUpdate => $_getN(3);
  @$pb.TagNumber(4)
  set playbackUpdate(UpdatePlaybackRequest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlaybackUpdate() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaybackUpdate() => $_clearField(4);
  @$pb.TagNumber(4)
  UpdatePlaybackRequest ensurePlaybackUpdate() => $_ensure(3);

  @$pb.TagNumber(5)
  ObserveResource get observeResource => $_getN(4);
  @$pb.TagNumber(5)
  set observeResource(ObserveResource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasObserveResource() => $_has(4);
  @$pb.TagNumber(5)
  void clearObserveResource() => $_clearField(5);
  @$pb.TagNumber(5)
  ObserveResource ensureObserveResource() => $_ensure(4);

  @$pb.TagNumber(6)
  UnobserveResource get unobserveResource => $_getN(5);
  @$pb.TagNumber(6)
  set unobserveResource(UnobserveResource value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUnobserveResource() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnobserveResource() => $_clearField(6);
  @$pb.TagNumber(6)
  UnobserveResource ensureUnobserveResource() => $_ensure(5);

  /// WebRTC signaling messages (P2P)
  @$pb.TagNumber(7)
  WebRTCOffer get webrtcOffer => $_getN(6);
  @$pb.TagNumber(7)
  set webrtcOffer(WebRTCOffer value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWebrtcOffer() => $_has(6);
  @$pb.TagNumber(7)
  void clearWebrtcOffer() => $_clearField(7);
  @$pb.TagNumber(7)
  WebRTCOffer ensureWebrtcOffer() => $_ensure(6);

  @$pb.TagNumber(8)
  WebRTCAnswer get webrtcAnswer => $_getN(7);
  @$pb.TagNumber(8)
  set webrtcAnswer(WebRTCAnswer value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWebrtcAnswer() => $_has(7);
  @$pb.TagNumber(8)
  void clearWebrtcAnswer() => $_clearField(8);
  @$pb.TagNumber(8)
  WebRTCAnswer ensureWebrtcAnswer() => $_ensure(7);

  @$pb.TagNumber(9)
  WebRTCIceCandidate get webrtcIceCandidate => $_getN(8);
  @$pb.TagNumber(9)
  set webrtcIceCandidate(WebRTCIceCandidate value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasWebrtcIceCandidate() => $_has(8);
  @$pb.TagNumber(9)
  void clearWebrtcIceCandidate() => $_clearField(9);
  @$pb.TagNumber(9)
  WebRTCIceCandidate ensureWebrtcIceCandidate() => $_ensure(8);

  @$pb.TagNumber(10)
  WebRTCJoin get webrtcJoin => $_getN(9);
  @$pb.TagNumber(10)
  set webrtcJoin(WebRTCJoin value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasWebrtcJoin() => $_has(9);
  @$pb.TagNumber(10)
  void clearWebrtcJoin() => $_clearField(10);
  @$pb.TagNumber(10)
  WebRTCJoin ensureWebrtcJoin() => $_ensure(9);

  @$pb.TagNumber(11)
  WebRTCLeave get webrtcLeave => $_getN(10);
  @$pb.TagNumber(11)
  set webrtcLeave(WebRTCLeave value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasWebrtcLeave() => $_has(10);
  @$pb.TagNumber(11)
  void clearWebrtcLeave() => $_clearField(11);
  @$pb.TagNumber(11)
  WebRTCLeave ensureWebrtcLeave() => $_ensure(10);
}

enum ObserveResource_Resource {
  playbackState,
  playbackSnapshot,
  roomSettings,
  playlistItems,
  roomMembers,
  notSet
}

class ObserveResource extends $pb.GeneratedMessage {
  factory ObserveResource({
    $core.String? observeId,
    $core.String? version,
    ResourceDeliveryMode? deliveryMode,
    ObservePlaybackState? playbackState,
    ObservePlaybackSnapshot? playbackSnapshot,
    ObserveRoomSettings? roomSettings,
    ObservePlaylistItems? playlistItems,
    ObserveRoomMembers? roomMembers,
  }) {
    final result = create();
    if (observeId != null) result.observeId = observeId;
    if (version != null) result.version = version;
    if (deliveryMode != null) result.deliveryMode = deliveryMode;
    if (playbackState != null) result.playbackState = playbackState;
    if (playbackSnapshot != null) result.playbackSnapshot = playbackSnapshot;
    if (roomSettings != null) result.roomSettings = roomSettings;
    if (playlistItems != null) result.playlistItems = playlistItems;
    if (roomMembers != null) result.roomMembers = roomMembers;
    return result;
  }

  ObserveResource._();

  factory ObserveResource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveResource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ObserveResource_Resource>
      _ObserveResource_ResourceByTag = {
    4: ObserveResource_Resource.playbackState,
    5: ObserveResource_Resource.playbackSnapshot,
    6: ObserveResource_Resource.roomSettings,
    7: ObserveResource_Resource.playlistItems,
    8: ObserveResource_Resource.roomMembers,
    0: ObserveResource_Resource.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveResource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7, 8])
    ..aOS(1, _omitFieldNames ? '' : 'observeId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aE<ResourceDeliveryMode>(3, _omitFieldNames ? '' : 'deliveryMode',
        enumValues: ResourceDeliveryMode.values)
    ..aOM<ObservePlaybackState>(4, _omitFieldNames ? '' : 'playbackState',
        subBuilder: ObservePlaybackState.create)
    ..aOM<ObservePlaybackSnapshot>(5, _omitFieldNames ? '' : 'playbackSnapshot',
        subBuilder: ObservePlaybackSnapshot.create)
    ..aOM<ObserveRoomSettings>(6, _omitFieldNames ? '' : 'roomSettings',
        subBuilder: ObserveRoomSettings.create)
    ..aOM<ObservePlaylistItems>(7, _omitFieldNames ? '' : 'playlistItems',
        subBuilder: ObservePlaylistItems.create)
    ..aOM<ObserveRoomMembers>(8, _omitFieldNames ? '' : 'roomMembers',
        subBuilder: ObserveRoomMembers.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveResource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveResource copyWith(void Function(ObserveResource) updates) =>
      super.copyWith((message) => updates(message as ObserveResource))
          as ObserveResource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveResource create() => ObserveResource._();
  @$core.override
  ObserveResource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveResource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveResource>(create);
  static ObserveResource? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  ObserveResource_Resource whichResource() =>
      _ObserveResource_ResourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearResource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get observeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObserveId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserveId() => $_clearField(1);

  /// Empty means the client has no local version yet.
  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  ResourceDeliveryMode get deliveryMode => $_getN(2);
  @$pb.TagNumber(3)
  set deliveryMode(ResourceDeliveryMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDeliveryMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeliveryMode() => $_clearField(3);

  @$pb.TagNumber(4)
  ObservePlaybackState get playbackState => $_getN(3);
  @$pb.TagNumber(4)
  set playbackState(ObservePlaybackState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlaybackState() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaybackState() => $_clearField(4);
  @$pb.TagNumber(4)
  ObservePlaybackState ensurePlaybackState() => $_ensure(3);

  @$pb.TagNumber(5)
  ObservePlaybackSnapshot get playbackSnapshot => $_getN(4);
  @$pb.TagNumber(5)
  set playbackSnapshot(ObservePlaybackSnapshot value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlaybackSnapshot() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlaybackSnapshot() => $_clearField(5);
  @$pb.TagNumber(5)
  ObservePlaybackSnapshot ensurePlaybackSnapshot() => $_ensure(4);

  @$pb.TagNumber(6)
  ObserveRoomSettings get roomSettings => $_getN(5);
  @$pb.TagNumber(6)
  set roomSettings(ObserveRoomSettings value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRoomSettings() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoomSettings() => $_clearField(6);
  @$pb.TagNumber(6)
  ObserveRoomSettings ensureRoomSettings() => $_ensure(5);

  @$pb.TagNumber(7)
  ObservePlaylistItems get playlistItems => $_getN(6);
  @$pb.TagNumber(7)
  set playlistItems(ObservePlaylistItems value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlaylistItems() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlaylistItems() => $_clearField(7);
  @$pb.TagNumber(7)
  ObservePlaylistItems ensurePlaylistItems() => $_ensure(6);

  @$pb.TagNumber(8)
  ObserveRoomMembers get roomMembers => $_getN(7);
  @$pb.TagNumber(8)
  set roomMembers(ObserveRoomMembers value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRoomMembers() => $_has(7);
  @$pb.TagNumber(8)
  void clearRoomMembers() => $_clearField(8);
  @$pb.TagNumber(8)
  ObserveRoomMembers ensureRoomMembers() => $_ensure(7);
}

class UnobserveResource extends $pb.GeneratedMessage {
  factory UnobserveResource({
    $core.String? observeId,
  }) {
    final result = create();
    if (observeId != null) result.observeId = observeId;
    return result;
  }

  UnobserveResource._();

  factory UnobserveResource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnobserveResource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnobserveResource',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnobserveResource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnobserveResource copyWith(void Function(UnobserveResource) updates) =>
      super.copyWith((message) => updates(message as UnobserveResource))
          as UnobserveResource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnobserveResource create() => UnobserveResource._();
  @$core.override
  UnobserveResource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnobserveResource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnobserveResource>(create);
  static UnobserveResource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObserveId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserveId() => $_clearField(1);
}

class ObservePlaybackState extends $pb.GeneratedMessage {
  factory ObservePlaybackState() => create();

  ObservePlaybackState._();

  factory ObservePlaybackState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObservePlaybackState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObservePlaybackState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservePlaybackState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservePlaybackState copyWith(void Function(ObservePlaybackState) updates) =>
      super.copyWith((message) => updates(message as ObservePlaybackState))
          as ObservePlaybackState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObservePlaybackState create() => ObservePlaybackState._();
  @$core.override
  ObservePlaybackState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObservePlaybackState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObservePlaybackState>(create);
  static ObservePlaybackState? _defaultInstance;
}

class ObservePlaybackSnapshot extends $pb.GeneratedMessage {
  factory ObservePlaybackSnapshot({
    $core.String? mediaId,
    $core.String? playlistId,
    $core.List<$core.int>? target,
    PlaybackClientProfile? playbackClientProfile,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (playlistId != null) result.playlistId = playlistId;
    if (target != null) result.target = target;
    if (playbackClientProfile != null)
      result.playbackClientProfile = playbackClientProfile;
    return result;
  }

  ObservePlaybackSnapshot._();

  factory ObservePlaybackSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObservePlaybackSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObservePlaybackSnapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..aOS(2, _omitFieldNames ? '' : 'playlistId')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'target', $pb.PbFieldType.OY)
    ..aOM<PlaybackClientProfile>(
        4, _omitFieldNames ? '' : 'playbackClientProfile',
        subBuilder: PlaybackClientProfile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservePlaybackSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservePlaybackSnapshot copyWith(
          void Function(ObservePlaybackSnapshot) updates) =>
      super.copyWith((message) => updates(message as ObservePlaybackSnapshot))
          as ObservePlaybackSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObservePlaybackSnapshot create() => ObservePlaybackSnapshot._();
  @$core.override
  ObservePlaybackSnapshot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObservePlaybackSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObservePlaybackSnapshot>(create);
  static ObservePlaybackSnapshot? _defaultInstance;

  /// Client-side cached playback source identity. Used together with `version`
  /// so reconnects don't suppress required refreshes when the source changed
  /// but the DB-derived version collided.
  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get target => $_getN(2);
  @$pb.TagNumber(3)
  set target($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTarget() => $_has(2);
  @$pb.TagNumber(3)
  void clearTarget() => $_clearField(3);

  @$pb.TagNumber(4)
  PlaybackClientProfile get playbackClientProfile => $_getN(3);
  @$pb.TagNumber(4)
  set playbackClientProfile(PlaybackClientProfile value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlaybackClientProfile() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaybackClientProfile() => $_clearField(4);
  @$pb.TagNumber(4)
  PlaybackClientProfile ensurePlaybackClientProfile() => $_ensure(3);
}

class ObserveRoomSettings extends $pb.GeneratedMessage {
  factory ObserveRoomSettings() => create();

  ObserveRoomSettings._();

  factory ObserveRoomSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveRoomSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveRoomSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveRoomSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveRoomSettings copyWith(void Function(ObserveRoomSettings) updates) =>
      super.copyWith((message) => updates(message as ObserveRoomSettings))
          as ObserveRoomSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveRoomSettings create() => ObserveRoomSettings._();
  @$core.override
  ObserveRoomSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveRoomSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveRoomSettings>(create);
  static ObserveRoomSettings? _defaultInstance;
}

class ObservePlaylistItems extends $pb.GeneratedMessage {
  factory ObservePlaylistItems({
    ListPlaylistItemsRequest? request,
  }) {
    final result = create();
    if (request != null) result.request = request;
    return result;
  }

  ObservePlaylistItems._();

  factory ObservePlaylistItems.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObservePlaylistItems.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObservePlaylistItems',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<ListPlaylistItemsRequest>(1, _omitFieldNames ? '' : 'request',
        subBuilder: ListPlaylistItemsRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservePlaylistItems clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservePlaylistItems copyWith(void Function(ObservePlaylistItems) updates) =>
      super.copyWith((message) => updates(message as ObservePlaylistItems))
          as ObservePlaylistItems;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObservePlaylistItems create() => ObservePlaylistItems._();
  @$core.override
  ObservePlaylistItems createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObservePlaylistItems getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObservePlaylistItems>(create);
  static ObservePlaylistItems? _defaultInstance;

  @$pb.TagNumber(1)
  ListPlaylistItemsRequest get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(ListPlaylistItemsRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  ListPlaylistItemsRequest ensureRequest() => $_ensure(0);
}

class ObserveRoomMembers extends $pb.GeneratedMessage {
  factory ObserveRoomMembers({
    GetRoomMembersRequest? request,
  }) {
    final result = create();
    if (request != null) result.request = request;
    return result;
  }

  ObserveRoomMembers._();

  factory ObserveRoomMembers.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveRoomMembers.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveRoomMembers',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<GetRoomMembersRequest>(1, _omitFieldNames ? '' : 'request',
        subBuilder: GetRoomMembersRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveRoomMembers clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveRoomMembers copyWith(void Function(ObserveRoomMembers) updates) =>
      super.copyWith((message) => updates(message as ObserveRoomMembers))
          as ObserveRoomMembers;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveRoomMembers create() => ObserveRoomMembers._();
  @$core.override
  ObserveRoomMembers createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveRoomMembers getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveRoomMembers>(create);
  static ObserveRoomMembers? _defaultInstance;

  @$pb.TagNumber(1)
  GetRoomMembersRequest get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(GetRoomMembersRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  GetRoomMembersRequest ensureRequest() => $_ensure(0);
}

class WatchOptions extends $pb.GeneratedMessage {
  factory WatchOptions({
    $core.String? version,
    ResourceDeliveryMode? deliveryMode,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (deliveryMode != null) result.deliveryMode = deliveryMode;
    return result;
  }

  WatchOptions._();

  factory WatchOptions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aE<ResourceDeliveryMode>(2, _omitFieldNames ? '' : 'deliveryMode',
        enumValues: ResourceDeliveryMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchOptions copyWith(void Function(WatchOptions) updates) =>
      super.copyWith((message) => updates(message as WatchOptions))
          as WatchOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchOptions create() => WatchOptions._();
  @$core.override
  WatchOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchOptions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchOptions>(create);
  static WatchOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  ResourceDeliveryMode get deliveryMode => $_getN(1);
  @$pb.TagNumber(2)
  set deliveryMode(ResourceDeliveryMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDeliveryMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeliveryMode() => $_clearField(2);
}

class WatchPlaybackStateRequest extends $pb.GeneratedMessage {
  factory WatchPlaybackStateRequest({
    WatchOptions? options,
  }) {
    final result = create();
    if (options != null) result.options = options;
    return result;
  }

  WatchPlaybackStateRequest._();

  factory WatchPlaybackStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPlaybackStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPlaybackStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<WatchOptions>(1, _omitFieldNames ? '' : 'options',
        subBuilder: WatchOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackStateRequest copyWith(
          void Function(WatchPlaybackStateRequest) updates) =>
      super.copyWith((message) => updates(message as WatchPlaybackStateRequest))
          as WatchPlaybackStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPlaybackStateRequest create() => WatchPlaybackStateRequest._();
  @$core.override
  WatchPlaybackStateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPlaybackStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPlaybackStateRequest>(create);
  static WatchPlaybackStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  WatchOptions get options => $_getN(0);
  @$pb.TagNumber(1)
  set options(WatchOptions value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptions() => $_clearField(1);
  @$pb.TagNumber(1)
  WatchOptions ensureOptions() => $_ensure(0);
}

class WatchPlaybackSnapshotRequest extends $pb.GeneratedMessage {
  factory WatchPlaybackSnapshotRequest({
    WatchOptions? options,
    ObservePlaybackSnapshot? playbackSnapshot,
  }) {
    final result = create();
    if (options != null) result.options = options;
    if (playbackSnapshot != null) result.playbackSnapshot = playbackSnapshot;
    return result;
  }

  WatchPlaybackSnapshotRequest._();

  factory WatchPlaybackSnapshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPlaybackSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPlaybackSnapshotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<WatchOptions>(1, _omitFieldNames ? '' : 'options',
        subBuilder: WatchOptions.create)
    ..aOM<ObservePlaybackSnapshot>(2, _omitFieldNames ? '' : 'playbackSnapshot',
        subBuilder: ObservePlaybackSnapshot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackSnapshotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackSnapshotRequest copyWith(
          void Function(WatchPlaybackSnapshotRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchPlaybackSnapshotRequest))
          as WatchPlaybackSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPlaybackSnapshotRequest create() =>
      WatchPlaybackSnapshotRequest._();
  @$core.override
  WatchPlaybackSnapshotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPlaybackSnapshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPlaybackSnapshotRequest>(create);
  static WatchPlaybackSnapshotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  WatchOptions get options => $_getN(0);
  @$pb.TagNumber(1)
  set options(WatchOptions value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptions() => $_clearField(1);
  @$pb.TagNumber(1)
  WatchOptions ensureOptions() => $_ensure(0);

  @$pb.TagNumber(2)
  ObservePlaybackSnapshot get playbackSnapshot => $_getN(1);
  @$pb.TagNumber(2)
  set playbackSnapshot(ObservePlaybackSnapshot value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaybackSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaybackSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  ObservePlaybackSnapshot ensurePlaybackSnapshot() => $_ensure(1);
}

class WatchRoomSettingsRequest extends $pb.GeneratedMessage {
  factory WatchRoomSettingsRequest({
    WatchOptions? options,
  }) {
    final result = create();
    if (options != null) result.options = options;
    return result;
  }

  WatchRoomSettingsRequest._();

  factory WatchRoomSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchRoomSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchRoomSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<WatchOptions>(1, _omitFieldNames ? '' : 'options',
        subBuilder: WatchOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomSettingsRequest copyWith(
          void Function(WatchRoomSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as WatchRoomSettingsRequest))
          as WatchRoomSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchRoomSettingsRequest create() => WatchRoomSettingsRequest._();
  @$core.override
  WatchRoomSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchRoomSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchRoomSettingsRequest>(create);
  static WatchRoomSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  WatchOptions get options => $_getN(0);
  @$pb.TagNumber(1)
  set options(WatchOptions value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptions() => $_clearField(1);
  @$pb.TagNumber(1)
  WatchOptions ensureOptions() => $_ensure(0);
}

class WatchPlaylistItemsRequest extends $pb.GeneratedMessage {
  factory WatchPlaylistItemsRequest({
    WatchOptions? options,
    ListPlaylistItemsRequest? request,
  }) {
    final result = create();
    if (options != null) result.options = options;
    if (request != null) result.request = request;
    return result;
  }

  WatchPlaylistItemsRequest._();

  factory WatchPlaylistItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPlaylistItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPlaylistItemsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<WatchOptions>(1, _omitFieldNames ? '' : 'options',
        subBuilder: WatchOptions.create)
    ..aOM<ListPlaylistItemsRequest>(2, _omitFieldNames ? '' : 'request',
        subBuilder: ListPlaylistItemsRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaylistItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaylistItemsRequest copyWith(
          void Function(WatchPlaylistItemsRequest) updates) =>
      super.copyWith((message) => updates(message as WatchPlaylistItemsRequest))
          as WatchPlaylistItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPlaylistItemsRequest create() => WatchPlaylistItemsRequest._();
  @$core.override
  WatchPlaylistItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPlaylistItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPlaylistItemsRequest>(create);
  static WatchPlaylistItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  WatchOptions get options => $_getN(0);
  @$pb.TagNumber(1)
  set options(WatchOptions value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptions() => $_clearField(1);
  @$pb.TagNumber(1)
  WatchOptions ensureOptions() => $_ensure(0);

  @$pb.TagNumber(2)
  ListPlaylistItemsRequest get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(ListPlaylistItemsRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  ListPlaylistItemsRequest ensureRequest() => $_ensure(1);
}

class WatchRoomMembersRequest extends $pb.GeneratedMessage {
  factory WatchRoomMembersRequest({
    WatchOptions? options,
    GetRoomMembersRequest? request,
  }) {
    final result = create();
    if (options != null) result.options = options;
    if (request != null) result.request = request;
    return result;
  }

  WatchRoomMembersRequest._();

  factory WatchRoomMembersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchRoomMembersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchRoomMembersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<WatchOptions>(1, _omitFieldNames ? '' : 'options',
        subBuilder: WatchOptions.create)
    ..aOM<GetRoomMembersRequest>(2, _omitFieldNames ? '' : 'request',
        subBuilder: GetRoomMembersRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomMembersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomMembersRequest copyWith(
          void Function(WatchRoomMembersRequest) updates) =>
      super.copyWith((message) => updates(message as WatchRoomMembersRequest))
          as WatchRoomMembersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchRoomMembersRequest create() => WatchRoomMembersRequest._();
  @$core.override
  WatchRoomMembersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchRoomMembersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchRoomMembersRequest>(create);
  static WatchRoomMembersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  WatchOptions get options => $_getN(0);
  @$pb.TagNumber(1)
  set options(WatchOptions value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOptions() => $_has(0);
  @$pb.TagNumber(1)
  void clearOptions() => $_clearField(1);
  @$pb.TagNumber(1)
  WatchOptions ensureOptions() => $_ensure(0);

  @$pb.TagNumber(2)
  GetRoomMembersRequest get request => $_getN(1);
  @$pb.TagNumber(2)
  set request(GetRoomMembersRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  GetRoomMembersRequest ensureRequest() => $_ensure(1);
}

enum WatchPlaybackStateEvent_Event { observed, changed, error, notSet }

class WatchPlaybackStateEvent extends $pb.GeneratedMessage {
  factory WatchPlaybackStateEvent({
    ResourceObserved? observed,
    ResourceChanged? changed,
    ResourceObserveError? error,
  }) {
    final result = create();
    if (observed != null) result.observed = observed;
    if (changed != null) result.changed = changed;
    if (error != null) result.error = error;
    return result;
  }

  WatchPlaybackStateEvent._();

  factory WatchPlaybackStateEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPlaybackStateEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, WatchPlaybackStateEvent_Event>
      _WatchPlaybackStateEvent_EventByTag = {
    1: WatchPlaybackStateEvent_Event.observed,
    2: WatchPlaybackStateEvent_Event.changed,
    3: WatchPlaybackStateEvent_Event.error,
    0: WatchPlaybackStateEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPlaybackStateEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ResourceObserved>(1, _omitFieldNames ? '' : 'observed',
        subBuilder: ResourceObserved.create)
    ..aOM<ResourceChanged>(2, _omitFieldNames ? '' : 'changed',
        subBuilder: ResourceChanged.create)
    ..aOM<ResourceObserveError>(3, _omitFieldNames ? '' : 'error',
        subBuilder: ResourceObserveError.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackStateEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackStateEvent copyWith(
          void Function(WatchPlaybackStateEvent) updates) =>
      super.copyWith((message) => updates(message as WatchPlaybackStateEvent))
          as WatchPlaybackStateEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPlaybackStateEvent create() => WatchPlaybackStateEvent._();
  @$core.override
  WatchPlaybackStateEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPlaybackStateEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPlaybackStateEvent>(create);
  static WatchPlaybackStateEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  WatchPlaybackStateEvent_Event whichEvent() =>
      _WatchPlaybackStateEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceObserved get observed => $_getN(0);
  @$pb.TagNumber(1)
  set observed(ResourceObserved value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObserved() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserved() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceObserved ensureObserved() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceChanged get changed => $_getN(1);
  @$pb.TagNumber(2)
  set changed(ResourceChanged value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanged() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceChanged ensureChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  ResourceObserveError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(ResourceObserveError value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceObserveError ensureError() => $_ensure(2);
}

enum WatchPlaybackSnapshotEvent_Event { observed, changed, error, notSet }

class WatchPlaybackSnapshotEvent extends $pb.GeneratedMessage {
  factory WatchPlaybackSnapshotEvent({
    ResourceObserved? observed,
    ResourceChanged? changed,
    ResourceObserveError? error,
  }) {
    final result = create();
    if (observed != null) result.observed = observed;
    if (changed != null) result.changed = changed;
    if (error != null) result.error = error;
    return result;
  }

  WatchPlaybackSnapshotEvent._();

  factory WatchPlaybackSnapshotEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPlaybackSnapshotEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, WatchPlaybackSnapshotEvent_Event>
      _WatchPlaybackSnapshotEvent_EventByTag = {
    1: WatchPlaybackSnapshotEvent_Event.observed,
    2: WatchPlaybackSnapshotEvent_Event.changed,
    3: WatchPlaybackSnapshotEvent_Event.error,
    0: WatchPlaybackSnapshotEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPlaybackSnapshotEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ResourceObserved>(1, _omitFieldNames ? '' : 'observed',
        subBuilder: ResourceObserved.create)
    ..aOM<ResourceChanged>(2, _omitFieldNames ? '' : 'changed',
        subBuilder: ResourceChanged.create)
    ..aOM<ResourceObserveError>(3, _omitFieldNames ? '' : 'error',
        subBuilder: ResourceObserveError.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackSnapshotEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaybackSnapshotEvent copyWith(
          void Function(WatchPlaybackSnapshotEvent) updates) =>
      super.copyWith(
              (message) => updates(message as WatchPlaybackSnapshotEvent))
          as WatchPlaybackSnapshotEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPlaybackSnapshotEvent create() => WatchPlaybackSnapshotEvent._();
  @$core.override
  WatchPlaybackSnapshotEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPlaybackSnapshotEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPlaybackSnapshotEvent>(create);
  static WatchPlaybackSnapshotEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  WatchPlaybackSnapshotEvent_Event whichEvent() =>
      _WatchPlaybackSnapshotEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceObserved get observed => $_getN(0);
  @$pb.TagNumber(1)
  set observed(ResourceObserved value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObserved() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserved() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceObserved ensureObserved() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceChanged get changed => $_getN(1);
  @$pb.TagNumber(2)
  set changed(ResourceChanged value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanged() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceChanged ensureChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  ResourceObserveError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(ResourceObserveError value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceObserveError ensureError() => $_ensure(2);
}

enum WatchRoomSettingsEvent_Event { observed, changed, error, notSet }

class WatchRoomSettingsEvent extends $pb.GeneratedMessage {
  factory WatchRoomSettingsEvent({
    ResourceObserved? observed,
    ResourceChanged? changed,
    ResourceObserveError? error,
  }) {
    final result = create();
    if (observed != null) result.observed = observed;
    if (changed != null) result.changed = changed;
    if (error != null) result.error = error;
    return result;
  }

  WatchRoomSettingsEvent._();

  factory WatchRoomSettingsEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchRoomSettingsEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, WatchRoomSettingsEvent_Event>
      _WatchRoomSettingsEvent_EventByTag = {
    1: WatchRoomSettingsEvent_Event.observed,
    2: WatchRoomSettingsEvent_Event.changed,
    3: WatchRoomSettingsEvent_Event.error,
    0: WatchRoomSettingsEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchRoomSettingsEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ResourceObserved>(1, _omitFieldNames ? '' : 'observed',
        subBuilder: ResourceObserved.create)
    ..aOM<ResourceChanged>(2, _omitFieldNames ? '' : 'changed',
        subBuilder: ResourceChanged.create)
    ..aOM<ResourceObserveError>(3, _omitFieldNames ? '' : 'error',
        subBuilder: ResourceObserveError.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomSettingsEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomSettingsEvent copyWith(
          void Function(WatchRoomSettingsEvent) updates) =>
      super.copyWith((message) => updates(message as WatchRoomSettingsEvent))
          as WatchRoomSettingsEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchRoomSettingsEvent create() => WatchRoomSettingsEvent._();
  @$core.override
  WatchRoomSettingsEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchRoomSettingsEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchRoomSettingsEvent>(create);
  static WatchRoomSettingsEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  WatchRoomSettingsEvent_Event whichEvent() =>
      _WatchRoomSettingsEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceObserved get observed => $_getN(0);
  @$pb.TagNumber(1)
  set observed(ResourceObserved value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObserved() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserved() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceObserved ensureObserved() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceChanged get changed => $_getN(1);
  @$pb.TagNumber(2)
  set changed(ResourceChanged value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanged() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceChanged ensureChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  ResourceObserveError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(ResourceObserveError value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceObserveError ensureError() => $_ensure(2);
}

enum WatchPlaylistItemsEvent_Event { observed, changed, error, notSet }

class WatchPlaylistItemsEvent extends $pb.GeneratedMessage {
  factory WatchPlaylistItemsEvent({
    ResourceObserved? observed,
    ResourceChanged? changed,
    ResourceObserveError? error,
  }) {
    final result = create();
    if (observed != null) result.observed = observed;
    if (changed != null) result.changed = changed;
    if (error != null) result.error = error;
    return result;
  }

  WatchPlaylistItemsEvent._();

  factory WatchPlaylistItemsEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchPlaylistItemsEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, WatchPlaylistItemsEvent_Event>
      _WatchPlaylistItemsEvent_EventByTag = {
    1: WatchPlaylistItemsEvent_Event.observed,
    2: WatchPlaylistItemsEvent_Event.changed,
    3: WatchPlaylistItemsEvent_Event.error,
    0: WatchPlaylistItemsEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchPlaylistItemsEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ResourceObserved>(1, _omitFieldNames ? '' : 'observed',
        subBuilder: ResourceObserved.create)
    ..aOM<ResourceChanged>(2, _omitFieldNames ? '' : 'changed',
        subBuilder: ResourceChanged.create)
    ..aOM<ResourceObserveError>(3, _omitFieldNames ? '' : 'error',
        subBuilder: ResourceObserveError.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaylistItemsEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchPlaylistItemsEvent copyWith(
          void Function(WatchPlaylistItemsEvent) updates) =>
      super.copyWith((message) => updates(message as WatchPlaylistItemsEvent))
          as WatchPlaylistItemsEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchPlaylistItemsEvent create() => WatchPlaylistItemsEvent._();
  @$core.override
  WatchPlaylistItemsEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchPlaylistItemsEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchPlaylistItemsEvent>(create);
  static WatchPlaylistItemsEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  WatchPlaylistItemsEvent_Event whichEvent() =>
      _WatchPlaylistItemsEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceObserved get observed => $_getN(0);
  @$pb.TagNumber(1)
  set observed(ResourceObserved value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObserved() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserved() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceObserved ensureObserved() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceChanged get changed => $_getN(1);
  @$pb.TagNumber(2)
  set changed(ResourceChanged value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanged() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceChanged ensureChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  ResourceObserveError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(ResourceObserveError value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceObserveError ensureError() => $_ensure(2);
}

enum WatchRoomMembersEvent_Event { observed, changed, error, notSet }

class WatchRoomMembersEvent extends $pb.GeneratedMessage {
  factory WatchRoomMembersEvent({
    ResourceObserved? observed,
    ResourceChanged? changed,
    ResourceObserveError? error,
  }) {
    final result = create();
    if (observed != null) result.observed = observed;
    if (changed != null) result.changed = changed;
    if (error != null) result.error = error;
    return result;
  }

  WatchRoomMembersEvent._();

  factory WatchRoomMembersEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchRoomMembersEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, WatchRoomMembersEvent_Event>
      _WatchRoomMembersEvent_EventByTag = {
    1: WatchRoomMembersEvent_Event.observed,
    2: WatchRoomMembersEvent_Event.changed,
    3: WatchRoomMembersEvent_Event.error,
    0: WatchRoomMembersEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchRoomMembersEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ResourceObserved>(1, _omitFieldNames ? '' : 'observed',
        subBuilder: ResourceObserved.create)
    ..aOM<ResourceChanged>(2, _omitFieldNames ? '' : 'changed',
        subBuilder: ResourceChanged.create)
    ..aOM<ResourceObserveError>(3, _omitFieldNames ? '' : 'error',
        subBuilder: ResourceObserveError.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomMembersEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchRoomMembersEvent copyWith(
          void Function(WatchRoomMembersEvent) updates) =>
      super.copyWith((message) => updates(message as WatchRoomMembersEvent))
          as WatchRoomMembersEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchRoomMembersEvent create() => WatchRoomMembersEvent._();
  @$core.override
  WatchRoomMembersEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchRoomMembersEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchRoomMembersEvent>(create);
  static WatchRoomMembersEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  WatchRoomMembersEvent_Event whichEvent() =>
      _WatchRoomMembersEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceObserved get observed => $_getN(0);
  @$pb.TagNumber(1)
  set observed(ResourceObserved value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObserved() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserved() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceObserved ensureObserved() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceChanged get changed => $_getN(1);
  @$pb.TagNumber(2)
  set changed(ResourceChanged value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChanged() => $_has(1);
  @$pb.TagNumber(2)
  void clearChanged() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceChanged ensureChanged() => $_ensure(1);

  @$pb.TagNumber(3)
  ResourceObserveError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(ResourceObserveError value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceObserveError ensureError() => $_ensure(2);
}

/// Client -> Server: periodic playback progress heartbeat
/// Sent every few seconds by clients that are actively playing media.
/// The server uses these reports to track actual client playback positions,
/// detect drift between clients, and provide accurate positions to new joiners.
class PlaybackProgressReport extends $pb.GeneratedMessage {
  factory PlaybackProgressReport({
    $core.double? position,
    $core.bool? isPlaying,
  }) {
    final result = create();
    if (position != null) result.position = position;
    if (isPlaying != null) result.isPlaying = isPlaying;
    return result;
  }

  PlaybackProgressReport._();

  factory PlaybackProgressReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackProgressReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackProgressReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'position')
    ..aOB(2, _omitFieldNames ? '' : 'isPlaying')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackProgressReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackProgressReport copyWith(
          void Function(PlaybackProgressReport) updates) =>
      super.copyWith((message) => updates(message as PlaybackProgressReport))
          as PlaybackProgressReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackProgressReport create() => PlaybackProgressReport._();
  @$core.override
  PlaybackProgressReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackProgressReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackProgressReport>(create);
  static PlaybackProgressReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get position => $_getN(0);
  @$pb.TagNumber(1)
  set position($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isPlaying => $_getBF(1);
  @$pb.TagNumber(2)
  set isPlaying($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsPlaying() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsPlaying() => $_clearField(2);
}

enum ServerMessage_Message {
  chat,
  playbackState,
  userJoined,
  userLeft,
  roomSettings,
  heartbeatAck,
  error,
  mediaAdded,
  mediaRemoved,
  mediaRemovedBatch,
  permissionChanged,
  playlistCreated,
  playlistUpdated,
  playlistDeleted,
  playlistReordered,
  playingChanged,
  webrtcOffer,
  webrtcAnswer,
  webrtcIceCandidate,
  webrtcJoin,
  webrtcLeave,
  notification,
  mediaUpdated,
  playbackSnapshot,
  playlistItems,
  roomMembers,
  resourceObserved,
  resourceChanged,
  resourceObserveError,
  notSet
}

class ServerMessage extends $pb.GeneratedMessage {
  factory ServerMessage({
    ChatMessageReceive? chat,
    PlaybackStateChanged? playbackState,
    UserJoinedRoom? userJoined,
    UserLeftRoom? userLeft,
    RoomSettingsChanged? roomSettings,
    HeartbeatAck? heartbeatAck,
    ErrorMessage? error,
    MediaAdded? mediaAdded,
    MediaRemoved? mediaRemoved,
    MediaRemovedBatch? mediaRemovedBatch,
    PermissionChanged? permissionChanged,
    PlaylistCreated? playlistCreated,
    PlaylistUpdated? playlistUpdated,
    PlaylistDeleted? playlistDeleted,
    PlaylistReordered? playlistReordered,
    PlayingChanged? playingChanged,
    WebRTCOffer? webrtcOffer,
    WebRTCAnswer? webrtcAnswer,
    WebRTCIceCandidate? webrtcIceCandidate,
    WebRTCJoin? webrtcJoin,
    WebRTCLeave? webrtcLeave,
    UserNotification? notification,
    MediaUpdated? mediaUpdated,
    PlaybackSnapshotChanged? playbackSnapshot,
    PlaylistItemsChanged? playlistItems,
    RoomMembersChanged? roomMembers,
    ResourceObserved? resourceObserved,
    ResourceChanged? resourceChanged,
    ResourceObserveError? resourceObserveError,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    if (playbackState != null) result.playbackState = playbackState;
    if (userJoined != null) result.userJoined = userJoined;
    if (userLeft != null) result.userLeft = userLeft;
    if (roomSettings != null) result.roomSettings = roomSettings;
    if (heartbeatAck != null) result.heartbeatAck = heartbeatAck;
    if (error != null) result.error = error;
    if (mediaAdded != null) result.mediaAdded = mediaAdded;
    if (mediaRemoved != null) result.mediaRemoved = mediaRemoved;
    if (mediaRemovedBatch != null) result.mediaRemovedBatch = mediaRemovedBatch;
    if (permissionChanged != null) result.permissionChanged = permissionChanged;
    if (playlistCreated != null) result.playlistCreated = playlistCreated;
    if (playlistUpdated != null) result.playlistUpdated = playlistUpdated;
    if (playlistDeleted != null) result.playlistDeleted = playlistDeleted;
    if (playlistReordered != null) result.playlistReordered = playlistReordered;
    if (playingChanged != null) result.playingChanged = playingChanged;
    if (webrtcOffer != null) result.webrtcOffer = webrtcOffer;
    if (webrtcAnswer != null) result.webrtcAnswer = webrtcAnswer;
    if (webrtcIceCandidate != null)
      result.webrtcIceCandidate = webrtcIceCandidate;
    if (webrtcJoin != null) result.webrtcJoin = webrtcJoin;
    if (webrtcLeave != null) result.webrtcLeave = webrtcLeave;
    if (notification != null) result.notification = notification;
    if (mediaUpdated != null) result.mediaUpdated = mediaUpdated;
    if (playbackSnapshot != null) result.playbackSnapshot = playbackSnapshot;
    if (playlistItems != null) result.playlistItems = playlistItems;
    if (roomMembers != null) result.roomMembers = roomMembers;
    if (resourceObserved != null) result.resourceObserved = resourceObserved;
    if (resourceChanged != null) result.resourceChanged = resourceChanged;
    if (resourceObserveError != null)
      result.resourceObserveError = resourceObserveError;
    return result;
  }

  ServerMessage._();

  factory ServerMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerMessage_Message>
      _ServerMessage_MessageByTag = {
    1: ServerMessage_Message.chat,
    2: ServerMessage_Message.playbackState,
    3: ServerMessage_Message.userJoined,
    4: ServerMessage_Message.userLeft,
    5: ServerMessage_Message.roomSettings,
    6: ServerMessage_Message.heartbeatAck,
    7: ServerMessage_Message.error,
    8: ServerMessage_Message.mediaAdded,
    9: ServerMessage_Message.mediaRemoved,
    10: ServerMessage_Message.mediaRemovedBatch,
    11: ServerMessage_Message.permissionChanged,
    12: ServerMessage_Message.playlistCreated,
    13: ServerMessage_Message.playlistUpdated,
    14: ServerMessage_Message.playlistDeleted,
    15: ServerMessage_Message.playlistReordered,
    16: ServerMessage_Message.playingChanged,
    17: ServerMessage_Message.webrtcOffer,
    18: ServerMessage_Message.webrtcAnswer,
    19: ServerMessage_Message.webrtcIceCandidate,
    20: ServerMessage_Message.webrtcJoin,
    21: ServerMessage_Message.webrtcLeave,
    24: ServerMessage_Message.notification,
    25: ServerMessage_Message.mediaUpdated,
    26: ServerMessage_Message.playbackSnapshot,
    27: ServerMessage_Message.playlistItems,
    28: ServerMessage_Message.roomMembers,
    29: ServerMessage_Message.resourceObserved,
    30: ServerMessage_Message.resourceChanged,
    31: ServerMessage_Message.resourceObserveError,
    0: ServerMessage_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31
    ])
    ..aOM<ChatMessageReceive>(1, _omitFieldNames ? '' : 'chat',
        subBuilder: ChatMessageReceive.create)
    ..aOM<PlaybackStateChanged>(2, _omitFieldNames ? '' : 'playbackState',
        subBuilder: PlaybackStateChanged.create)
    ..aOM<UserJoinedRoom>(3, _omitFieldNames ? '' : 'userJoined',
        subBuilder: UserJoinedRoom.create)
    ..aOM<UserLeftRoom>(4, _omitFieldNames ? '' : 'userLeft',
        subBuilder: UserLeftRoom.create)
    ..aOM<RoomSettingsChanged>(5, _omitFieldNames ? '' : 'roomSettings',
        subBuilder: RoomSettingsChanged.create)
    ..aOM<HeartbeatAck>(6, _omitFieldNames ? '' : 'heartbeatAck',
        subBuilder: HeartbeatAck.create)
    ..aOM<ErrorMessage>(7, _omitFieldNames ? '' : 'error',
        subBuilder: ErrorMessage.create)
    ..aOM<MediaAdded>(8, _omitFieldNames ? '' : 'mediaAdded',
        subBuilder: MediaAdded.create)
    ..aOM<MediaRemoved>(9, _omitFieldNames ? '' : 'mediaRemoved',
        subBuilder: MediaRemoved.create)
    ..aOM<MediaRemovedBatch>(10, _omitFieldNames ? '' : 'mediaRemovedBatch',
        subBuilder: MediaRemovedBatch.create)
    ..aOM<PermissionChanged>(11, _omitFieldNames ? '' : 'permissionChanged',
        subBuilder: PermissionChanged.create)
    ..aOM<PlaylistCreated>(12, _omitFieldNames ? '' : 'playlistCreated',
        subBuilder: PlaylistCreated.create)
    ..aOM<PlaylistUpdated>(13, _omitFieldNames ? '' : 'playlistUpdated',
        subBuilder: PlaylistUpdated.create)
    ..aOM<PlaylistDeleted>(14, _omitFieldNames ? '' : 'playlistDeleted',
        subBuilder: PlaylistDeleted.create)
    ..aOM<PlaylistReordered>(15, _omitFieldNames ? '' : 'playlistReordered',
        subBuilder: PlaylistReordered.create)
    ..aOM<PlayingChanged>(16, _omitFieldNames ? '' : 'playingChanged',
        subBuilder: PlayingChanged.create)
    ..aOM<WebRTCOffer>(17, _omitFieldNames ? '' : 'webrtcOffer',
        subBuilder: WebRTCOffer.create)
    ..aOM<WebRTCAnswer>(18, _omitFieldNames ? '' : 'webrtcAnswer',
        subBuilder: WebRTCAnswer.create)
    ..aOM<WebRTCIceCandidate>(19, _omitFieldNames ? '' : 'webrtcIceCandidate',
        subBuilder: WebRTCIceCandidate.create)
    ..aOM<WebRTCJoin>(20, _omitFieldNames ? '' : 'webrtcJoin',
        subBuilder: WebRTCJoin.create)
    ..aOM<WebRTCLeave>(21, _omitFieldNames ? '' : 'webrtcLeave',
        subBuilder: WebRTCLeave.create)
    ..aOM<UserNotification>(24, _omitFieldNames ? '' : 'notification',
        subBuilder: UserNotification.create)
    ..aOM<MediaUpdated>(25, _omitFieldNames ? '' : 'mediaUpdated',
        subBuilder: MediaUpdated.create)
    ..aOM<PlaybackSnapshotChanged>(
        26, _omitFieldNames ? '' : 'playbackSnapshot',
        subBuilder: PlaybackSnapshotChanged.create)
    ..aOM<PlaylistItemsChanged>(27, _omitFieldNames ? '' : 'playlistItems',
        subBuilder: PlaylistItemsChanged.create)
    ..aOM<RoomMembersChanged>(28, _omitFieldNames ? '' : 'roomMembers',
        subBuilder: RoomMembersChanged.create)
    ..aOM<ResourceObserved>(29, _omitFieldNames ? '' : 'resourceObserved',
        subBuilder: ResourceObserved.create)
    ..aOM<ResourceChanged>(30, _omitFieldNames ? '' : 'resourceChanged',
        subBuilder: ResourceChanged.create)
    ..aOM<ResourceObserveError>(
        31, _omitFieldNames ? '' : 'resourceObserveError',
        subBuilder: ResourceObserveError.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerMessage copyWith(void Function(ServerMessage) updates) =>
      super.copyWith((message) => updates(message as ServerMessage))
          as ServerMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerMessage create() => ServerMessage._();
  @$core.override
  ServerMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerMessage>(create);
  static ServerMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  ServerMessage_Message whichMessage() =>
      _ServerMessage_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  void clearMessage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ChatMessageReceive get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(ChatMessageReceive value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessageReceive ensureChat() => $_ensure(0);

  @$pb.TagNumber(2)
  PlaybackStateChanged get playbackState => $_getN(1);
  @$pb.TagNumber(2)
  set playbackState(PlaybackStateChanged value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaybackState() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaybackState() => $_clearField(2);
  @$pb.TagNumber(2)
  PlaybackStateChanged ensurePlaybackState() => $_ensure(1);

  @$pb.TagNumber(3)
  UserJoinedRoom get userJoined => $_getN(2);
  @$pb.TagNumber(3)
  set userJoined(UserJoinedRoom value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUserJoined() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserJoined() => $_clearField(3);
  @$pb.TagNumber(3)
  UserJoinedRoom ensureUserJoined() => $_ensure(2);

  @$pb.TagNumber(4)
  UserLeftRoom get userLeft => $_getN(3);
  @$pb.TagNumber(4)
  set userLeft(UserLeftRoom value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUserLeft() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserLeft() => $_clearField(4);
  @$pb.TagNumber(4)
  UserLeftRoom ensureUserLeft() => $_ensure(3);

  @$pb.TagNumber(5)
  RoomSettingsChanged get roomSettings => $_getN(4);
  @$pb.TagNumber(5)
  set roomSettings(RoomSettingsChanged value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRoomSettings() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoomSettings() => $_clearField(5);
  @$pb.TagNumber(5)
  RoomSettingsChanged ensureRoomSettings() => $_ensure(4);

  @$pb.TagNumber(6)
  HeartbeatAck get heartbeatAck => $_getN(5);
  @$pb.TagNumber(6)
  set heartbeatAck(HeartbeatAck value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasHeartbeatAck() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeartbeatAck() => $_clearField(6);
  @$pb.TagNumber(6)
  HeartbeatAck ensureHeartbeatAck() => $_ensure(5);

  @$pb.TagNumber(7)
  ErrorMessage get error => $_getN(6);
  @$pb.TagNumber(7)
  set error(ErrorMessage value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => $_clearField(7);
  @$pb.TagNumber(7)
  ErrorMessage ensureError() => $_ensure(6);

  @$pb.TagNumber(8)
  MediaAdded get mediaAdded => $_getN(7);
  @$pb.TagNumber(8)
  set mediaAdded(MediaAdded value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMediaAdded() => $_has(7);
  @$pb.TagNumber(8)
  void clearMediaAdded() => $_clearField(8);
  @$pb.TagNumber(8)
  MediaAdded ensureMediaAdded() => $_ensure(7);

  @$pb.TagNumber(9)
  MediaRemoved get mediaRemoved => $_getN(8);
  @$pb.TagNumber(9)
  set mediaRemoved(MediaRemoved value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMediaRemoved() => $_has(8);
  @$pb.TagNumber(9)
  void clearMediaRemoved() => $_clearField(9);
  @$pb.TagNumber(9)
  MediaRemoved ensureMediaRemoved() => $_ensure(8);

  @$pb.TagNumber(10)
  MediaRemovedBatch get mediaRemovedBatch => $_getN(9);
  @$pb.TagNumber(10)
  set mediaRemovedBatch(MediaRemovedBatch value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasMediaRemovedBatch() => $_has(9);
  @$pb.TagNumber(10)
  void clearMediaRemovedBatch() => $_clearField(10);
  @$pb.TagNumber(10)
  MediaRemovedBatch ensureMediaRemovedBatch() => $_ensure(9);

  @$pb.TagNumber(11)
  PermissionChanged get permissionChanged => $_getN(10);
  @$pb.TagNumber(11)
  set permissionChanged(PermissionChanged value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPermissionChanged() => $_has(10);
  @$pb.TagNumber(11)
  void clearPermissionChanged() => $_clearField(11);
  @$pb.TagNumber(11)
  PermissionChanged ensurePermissionChanged() => $_ensure(10);

  @$pb.TagNumber(12)
  PlaylistCreated get playlistCreated => $_getN(11);
  @$pb.TagNumber(12)
  set playlistCreated(PlaylistCreated value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPlaylistCreated() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlaylistCreated() => $_clearField(12);
  @$pb.TagNumber(12)
  PlaylistCreated ensurePlaylistCreated() => $_ensure(11);

  @$pb.TagNumber(13)
  PlaylistUpdated get playlistUpdated => $_getN(12);
  @$pb.TagNumber(13)
  set playlistUpdated(PlaylistUpdated value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPlaylistUpdated() => $_has(12);
  @$pb.TagNumber(13)
  void clearPlaylistUpdated() => $_clearField(13);
  @$pb.TagNumber(13)
  PlaylistUpdated ensurePlaylistUpdated() => $_ensure(12);

  @$pb.TagNumber(14)
  PlaylistDeleted get playlistDeleted => $_getN(13);
  @$pb.TagNumber(14)
  set playlistDeleted(PlaylistDeleted value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPlaylistDeleted() => $_has(13);
  @$pb.TagNumber(14)
  void clearPlaylistDeleted() => $_clearField(14);
  @$pb.TagNumber(14)
  PlaylistDeleted ensurePlaylistDeleted() => $_ensure(13);

  @$pb.TagNumber(15)
  PlaylistReordered get playlistReordered => $_getN(14);
  @$pb.TagNumber(15)
  set playlistReordered(PlaylistReordered value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasPlaylistReordered() => $_has(14);
  @$pb.TagNumber(15)
  void clearPlaylistReordered() => $_clearField(15);
  @$pb.TagNumber(15)
  PlaylistReordered ensurePlaylistReordered() => $_ensure(14);

  @$pb.TagNumber(16)
  PlayingChanged get playingChanged => $_getN(15);
  @$pb.TagNumber(16)
  set playingChanged(PlayingChanged value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasPlayingChanged() => $_has(15);
  @$pb.TagNumber(16)
  void clearPlayingChanged() => $_clearField(16);
  @$pb.TagNumber(16)
  PlayingChanged ensurePlayingChanged() => $_ensure(15);

  /// WebRTC signaling messages (forwarded from other peers)
  @$pb.TagNumber(17)
  WebRTCOffer get webrtcOffer => $_getN(16);
  @$pb.TagNumber(17)
  set webrtcOffer(WebRTCOffer value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasWebrtcOffer() => $_has(16);
  @$pb.TagNumber(17)
  void clearWebrtcOffer() => $_clearField(17);
  @$pb.TagNumber(17)
  WebRTCOffer ensureWebrtcOffer() => $_ensure(16);

  @$pb.TagNumber(18)
  WebRTCAnswer get webrtcAnswer => $_getN(17);
  @$pb.TagNumber(18)
  set webrtcAnswer(WebRTCAnswer value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasWebrtcAnswer() => $_has(17);
  @$pb.TagNumber(18)
  void clearWebrtcAnswer() => $_clearField(18);
  @$pb.TagNumber(18)
  WebRTCAnswer ensureWebrtcAnswer() => $_ensure(17);

  @$pb.TagNumber(19)
  WebRTCIceCandidate get webrtcIceCandidate => $_getN(18);
  @$pb.TagNumber(19)
  set webrtcIceCandidate(WebRTCIceCandidate value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasWebrtcIceCandidate() => $_has(18);
  @$pb.TagNumber(19)
  void clearWebrtcIceCandidate() => $_clearField(19);
  @$pb.TagNumber(19)
  WebRTCIceCandidate ensureWebrtcIceCandidate() => $_ensure(18);

  @$pb.TagNumber(20)
  WebRTCJoin get webrtcJoin => $_getN(19);
  @$pb.TagNumber(20)
  set webrtcJoin(WebRTCJoin value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasWebrtcJoin() => $_has(19);
  @$pb.TagNumber(20)
  void clearWebrtcJoin() => $_clearField(20);
  @$pb.TagNumber(20)
  WebRTCJoin ensureWebrtcJoin() => $_ensure(19);

  @$pb.TagNumber(21)
  WebRTCLeave get webrtcLeave => $_getN(20);
  @$pb.TagNumber(21)
  set webrtcLeave(WebRTCLeave value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasWebrtcLeave() => $_has(20);
  @$pb.TagNumber(21)
  void clearWebrtcLeave() => $_clearField(21);
  @$pb.TagNumber(21)
  WebRTCLeave ensureWebrtcLeave() => $_ensure(20);

  /// User notification push (replaces NOTIFICATION_PUSH error code abuse)
  @$pb.TagNumber(24)
  UserNotification get notification => $_getN(21);
  @$pb.TagNumber(24)
  set notification(UserNotification value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasNotification() => $_has(21);
  @$pb.TagNumber(24)
  void clearNotification() => $_clearField(24);
  @$pb.TagNumber(24)
  UserNotification ensureNotification() => $_ensure(21);

  @$pb.TagNumber(25)
  MediaUpdated get mediaUpdated => $_getN(22);
  @$pb.TagNumber(25)
  set mediaUpdated(MediaUpdated value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasMediaUpdated() => $_has(22);
  @$pb.TagNumber(25)
  void clearMediaUpdated() => $_clearField(25);
  @$pb.TagNumber(25)
  MediaUpdated ensureMediaUpdated() => $_ensure(22);

  @$pb.TagNumber(26)
  PlaybackSnapshotChanged get playbackSnapshot => $_getN(23);
  @$pb.TagNumber(26)
  set playbackSnapshot(PlaybackSnapshotChanged value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasPlaybackSnapshot() => $_has(23);
  @$pb.TagNumber(26)
  void clearPlaybackSnapshot() => $_clearField(26);
  @$pb.TagNumber(26)
  PlaybackSnapshotChanged ensurePlaybackSnapshot() => $_ensure(23);

  @$pb.TagNumber(27)
  PlaylistItemsChanged get playlistItems => $_getN(24);
  @$pb.TagNumber(27)
  set playlistItems(PlaylistItemsChanged value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasPlaylistItems() => $_has(24);
  @$pb.TagNumber(27)
  void clearPlaylistItems() => $_clearField(27);
  @$pb.TagNumber(27)
  PlaylistItemsChanged ensurePlaylistItems() => $_ensure(24);

  @$pb.TagNumber(28)
  RoomMembersChanged get roomMembers => $_getN(25);
  @$pb.TagNumber(28)
  set roomMembers(RoomMembersChanged value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasRoomMembers() => $_has(25);
  @$pb.TagNumber(28)
  void clearRoomMembers() => $_clearField(28);
  @$pb.TagNumber(28)
  RoomMembersChanged ensureRoomMembers() => $_ensure(25);

  @$pb.TagNumber(29)
  ResourceObserved get resourceObserved => $_getN(26);
  @$pb.TagNumber(29)
  set resourceObserved(ResourceObserved value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasResourceObserved() => $_has(26);
  @$pb.TagNumber(29)
  void clearResourceObserved() => $_clearField(29);
  @$pb.TagNumber(29)
  ResourceObserved ensureResourceObserved() => $_ensure(26);

  @$pb.TagNumber(30)
  ResourceChanged get resourceChanged => $_getN(27);
  @$pb.TagNumber(30)
  set resourceChanged(ResourceChanged value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasResourceChanged() => $_has(27);
  @$pb.TagNumber(30)
  void clearResourceChanged() => $_clearField(30);
  @$pb.TagNumber(30)
  ResourceChanged ensureResourceChanged() => $_ensure(27);

  @$pb.TagNumber(31)
  ResourceObserveError get resourceObserveError => $_getN(28);
  @$pb.TagNumber(31)
  set resourceObserveError(ResourceObserveError value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasResourceObserveError() => $_has(28);
  @$pb.TagNumber(31)
  void clearResourceObserveError() => $_clearField(31);
  @$pb.TagNumber(31)
  ResourceObserveError ensureResourceObserveError() => $_ensure(28);
}

class ResourceObserved extends $pb.GeneratedMessage {
  factory ResourceObserved({
    $core.String? observeId,
    $core.String? version,
    $core.bool? changed,
  }) {
    final result = create();
    if (observeId != null) result.observeId = observeId;
    if (version != null) result.version = version;
    if (changed != null) result.changed = changed;
    return result;
  }

  ResourceObserved._();

  factory ResourceObserved.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceObserved.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceObserved',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observeId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOB(3, _omitFieldNames ? '' : 'changed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceObserved clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceObserved copyWith(void Function(ResourceObserved) updates) =>
      super.copyWith((message) => updates(message as ResourceObserved))
          as ResourceObserved;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceObserved create() => ResourceObserved._();
  @$core.override
  ResourceObserved createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResourceObserved getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceObserved>(create);
  static ResourceObserved? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObserveId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserveId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get changed => $_getBF(2);
  @$pb.TagNumber(3)
  set changed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChanged() => $_has(2);
  @$pb.TagNumber(3)
  void clearChanged() => $_clearField(3);
}

class ResourceChangedOnly extends $pb.GeneratedMessage {
  factory ResourceChangedOnly() => create();

  ResourceChangedOnly._();

  factory ResourceChangedOnly.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceChangedOnly.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceChangedOnly',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceChangedOnly clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceChangedOnly copyWith(void Function(ResourceChangedOnly) updates) =>
      super.copyWith((message) => updates(message as ResourceChangedOnly))
          as ResourceChangedOnly;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceChangedOnly create() => ResourceChangedOnly._();
  @$core.override
  ResourceChangedOnly createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResourceChangedOnly getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceChangedOnly>(create);
  static ResourceChangedOnly? _defaultInstance;
}

enum ResourceChanged_Payload {
  changedOnly,
  playbackState,
  playbackSnapshot,
  roomSettings,
  playlistItems,
  roomMembers,
  notSet
}

class ResourceChanged extends $pb.GeneratedMessage {
  factory ResourceChanged({
    $core.String? observeId,
    $core.String? version,
    ResourceChangedOnly? changedOnly,
    PlaybackState? playbackState,
    PlaybackSnapshot? playbackSnapshot,
    RoomSettingsChanged? roomSettings,
    ListPlaylistItemsResponse? playlistItems,
    GetRoomMembersResponse? roomMembers,
  }) {
    final result = create();
    if (observeId != null) result.observeId = observeId;
    if (version != null) result.version = version;
    if (changedOnly != null) result.changedOnly = changedOnly;
    if (playbackState != null) result.playbackState = playbackState;
    if (playbackSnapshot != null) result.playbackSnapshot = playbackSnapshot;
    if (roomSettings != null) result.roomSettings = roomSettings;
    if (playlistItems != null) result.playlistItems = playlistItems;
    if (roomMembers != null) result.roomMembers = roomMembers;
    return result;
  }

  ResourceChanged._();

  factory ResourceChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResourceChanged_Payload>
      _ResourceChanged_PayloadByTag = {
    3: ResourceChanged_Payload.changedOnly,
    4: ResourceChanged_Payload.playbackState,
    5: ResourceChanged_Payload.playbackSnapshot,
    6: ResourceChanged_Payload.roomSettings,
    7: ResourceChanged_Payload.playlistItems,
    8: ResourceChanged_Payload.roomMembers,
    0: ResourceChanged_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8])
    ..aOS(1, _omitFieldNames ? '' : 'observeId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOM<ResourceChangedOnly>(3, _omitFieldNames ? '' : 'changedOnly',
        subBuilder: ResourceChangedOnly.create)
    ..aOM<PlaybackState>(4, _omitFieldNames ? '' : 'playbackState',
        subBuilder: PlaybackState.create)
    ..aOM<PlaybackSnapshot>(5, _omitFieldNames ? '' : 'playbackSnapshot',
        subBuilder: PlaybackSnapshot.create)
    ..aOM<RoomSettingsChanged>(6, _omitFieldNames ? '' : 'roomSettings',
        subBuilder: RoomSettingsChanged.create)
    ..aOM<ListPlaylistItemsResponse>(7, _omitFieldNames ? '' : 'playlistItems',
        subBuilder: ListPlaylistItemsResponse.create)
    ..aOM<GetRoomMembersResponse>(8, _omitFieldNames ? '' : 'roomMembers',
        subBuilder: GetRoomMembersResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceChanged copyWith(void Function(ResourceChanged) updates) =>
      super.copyWith((message) => updates(message as ResourceChanged))
          as ResourceChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceChanged create() => ResourceChanged._();
  @$core.override
  ResourceChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResourceChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceChanged>(create);
  static ResourceChanged? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  ResourceChanged_Payload whichPayload() =>
      _ResourceChanged_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get observeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObserveId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserveId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  ResourceChangedOnly get changedOnly => $_getN(2);
  @$pb.TagNumber(3)
  set changedOnly(ResourceChangedOnly value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChangedOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearChangedOnly() => $_clearField(3);
  @$pb.TagNumber(3)
  ResourceChangedOnly ensureChangedOnly() => $_ensure(2);

  @$pb.TagNumber(4)
  PlaybackState get playbackState => $_getN(3);
  @$pb.TagNumber(4)
  set playbackState(PlaybackState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlaybackState() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaybackState() => $_clearField(4);
  @$pb.TagNumber(4)
  PlaybackState ensurePlaybackState() => $_ensure(3);

  @$pb.TagNumber(5)
  PlaybackSnapshot get playbackSnapshot => $_getN(4);
  @$pb.TagNumber(5)
  set playbackSnapshot(PlaybackSnapshot value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlaybackSnapshot() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlaybackSnapshot() => $_clearField(5);
  @$pb.TagNumber(5)
  PlaybackSnapshot ensurePlaybackSnapshot() => $_ensure(4);

  @$pb.TagNumber(6)
  RoomSettingsChanged get roomSettings => $_getN(5);
  @$pb.TagNumber(6)
  set roomSettings(RoomSettingsChanged value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRoomSettings() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoomSettings() => $_clearField(6);
  @$pb.TagNumber(6)
  RoomSettingsChanged ensureRoomSettings() => $_ensure(5);

  @$pb.TagNumber(7)
  ListPlaylistItemsResponse get playlistItems => $_getN(6);
  @$pb.TagNumber(7)
  set playlistItems(ListPlaylistItemsResponse value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlaylistItems() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlaylistItems() => $_clearField(7);
  @$pb.TagNumber(7)
  ListPlaylistItemsResponse ensurePlaylistItems() => $_ensure(6);

  @$pb.TagNumber(8)
  GetRoomMembersResponse get roomMembers => $_getN(7);
  @$pb.TagNumber(8)
  set roomMembers(GetRoomMembersResponse value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRoomMembers() => $_has(7);
  @$pb.TagNumber(8)
  void clearRoomMembers() => $_clearField(8);
  @$pb.TagNumber(8)
  GetRoomMembersResponse ensureRoomMembers() => $_ensure(7);
}

class ResourceObserveError extends $pb.GeneratedMessage {
  factory ResourceObserveError({
    $core.String? observeId,
    ErrorMessage? error,
  }) {
    final result = create();
    if (observeId != null) result.observeId = observeId;
    if (error != null) result.error = error;
    return result;
  }

  ResourceObserveError._();

  factory ResourceObserveError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceObserveError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceObserveError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observeId')
    ..aOM<ErrorMessage>(2, _omitFieldNames ? '' : 'error',
        subBuilder: ErrorMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceObserveError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceObserveError copyWith(void Function(ResourceObserveError) updates) =>
      super.copyWith((message) => updates(message as ResourceObserveError))
          as ResourceObserveError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceObserveError create() => ResourceObserveError._();
  @$core.override
  ResourceObserveError createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResourceObserveError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceObserveError>(create);
  static ResourceObserveError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObserveId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObserveId() => $_clearField(1);

  @$pb.TagNumber(2)
  ErrorMessage get error => $_getN(1);
  @$pb.TagNumber(2)
  set error(ErrorMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
  @$pb.TagNumber(2)
  ErrorMessage ensureError() => $_ensure(1);
}

class PlaylistItemsChanged extends $pb.GeneratedMessage {
  factory PlaylistItemsChanged({
    $core.String? roomId,
    ListPlaylistItemsResponse? snapshot,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  PlaylistItemsChanged._();

  factory PlaylistItemsChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistItemsChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistItemsChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<ListPlaylistItemsResponse>(2, _omitFieldNames ? '' : 'snapshot',
        subBuilder: ListPlaylistItemsResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistItemsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistItemsChanged copyWith(void Function(PlaylistItemsChanged) updates) =>
      super.copyWith((message) => updates(message as PlaylistItemsChanged))
          as PlaylistItemsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistItemsChanged create() => PlaylistItemsChanged._();
  @$core.override
  PlaylistItemsChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistItemsChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistItemsChanged>(create);
  static PlaylistItemsChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  ListPlaylistItemsResponse get snapshot => $_getN(1);
  @$pb.TagNumber(2)
  set snapshot(ListPlaylistItemsResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  ListPlaylistItemsResponse ensureSnapshot() => $_ensure(1);
}

class RoomMembersChanged extends $pb.GeneratedMessage {
  factory RoomMembersChanged({
    $core.String? roomId,
    GetRoomMembersResponse? snapshot,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  RoomMembersChanged._();

  factory RoomMembersChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomMembersChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomMembersChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<GetRoomMembersResponse>(2, _omitFieldNames ? '' : 'snapshot',
        subBuilder: GetRoomMembersResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMembersChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMembersChanged copyWith(void Function(RoomMembersChanged) updates) =>
      super.copyWith((message) => updates(message as RoomMembersChanged))
          as RoomMembersChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMembersChanged create() => RoomMembersChanged._();
  @$core.override
  RoomMembersChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomMembersChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomMembersChanged>(create);
  static RoomMembersChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  GetRoomMembersResponse get snapshot => $_getN(1);
  @$pb.TagNumber(2)
  set snapshot(GetRoomMembersResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  GetRoomMembersResponse ensureSnapshot() => $_ensure(1);
}

/// Note: room_id extracted from x-room-id metadata in MessageStream context
/// If position is set, client may display this as a danmaku (bullet comment)
class ChatMessageSend extends $pb.GeneratedMessage {
  factory ChatMessageSend({
    $core.String? content,
    $core.double? position,
    $core.String? color,
  }) {
    final result = create();
    if (content != null) result.content = content;
    if (position != null) result.position = position;
    if (color != null) result.color = color;
    return result;
  }

  ChatMessageSend._();

  factory ChatMessageSend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessageSend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatMessageSend',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..aD(2, _omitFieldNames ? '' : 'position')
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessageSend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessageSend copyWith(void Function(ChatMessageSend) updates) =>
      super.copyWith((message) => updates(message as ChatMessageSend))
          as ChatMessageSend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessageSend create() => ChatMessageSend._();
  @$core.override
  ChatMessageSend createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessageSend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatMessageSend>(create);
  static ChatMessageSend? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get position => $_getN(1);
  @$pb.TagNumber(2)
  set position($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);
}

class ChatMessageReceive extends $pb.GeneratedMessage {
  factory ChatMessageReceive({
    $core.String? id,
    $core.String? roomId,
    $core.String? userId,
    $core.String? username,
    $core.String? content,
    $fixnum.Int64? timestamp,
    $core.double? position,
    $core.String? color,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (content != null) result.content = content;
    if (timestamp != null) result.timestamp = timestamp;
    if (position != null) result.position = position;
    if (color != null) result.color = color;
    return result;
  }

  ChatMessageReceive._();

  factory ChatMessageReceive.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessageReceive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatMessageReceive',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aInt64(6, _omitFieldNames ? '' : 'timestamp')
    ..aD(7, _omitFieldNames ? '' : 'position')
    ..aOS(8, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessageReceive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessageReceive copyWith(void Function(ChatMessageReceive) updates) =>
      super.copyWith((message) => updates(message as ChatMessageReceive))
          as ChatMessageReceive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessageReceive create() => ChatMessageReceive._();
  @$core.override
  ChatMessageReceive createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessageReceive getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatMessageReceive>(create);
  static ChatMessageReceive? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get position => $_getN(6);
  @$pb.TagNumber(7)
  set position($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPosition() => $_has(6);
  @$pb.TagNumber(7)
  void clearPosition() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get color => $_getSZ(7);
  @$pb.TagNumber(8)
  set color($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasColor() => $_has(7);
  @$pb.TagNumber(8)
  void clearColor() => $_clearField(8);
}

class HeartbeatMessage extends $pb.GeneratedMessage {
  factory HeartbeatMessage({
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  HeartbeatMessage._();

  factory HeartbeatMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartbeatMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeartbeatMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatMessage copyWith(void Function(HeartbeatMessage) updates) =>
      super.copyWith((message) => updates(message as HeartbeatMessage))
          as HeartbeatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatMessage create() => HeartbeatMessage._();
  @$core.override
  HeartbeatMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeartbeatMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeartbeatMessage>(create);
  static HeartbeatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);
}

class HeartbeatAck extends $pb.GeneratedMessage {
  factory HeartbeatAck({
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  HeartbeatAck._();

  factory HeartbeatAck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HeartbeatAck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HeartbeatAck',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HeartbeatAck copyWith(void Function(HeartbeatAck) updates) =>
      super.copyWith((message) => updates(message as HeartbeatAck))
          as HeartbeatAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HeartbeatAck create() => HeartbeatAck._();
  @$core.override
  HeartbeatAck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HeartbeatAck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HeartbeatAck>(create);
  static HeartbeatAck? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestamp => $_getI64(0);
  @$pb.TagNumber(1)
  set timestamp($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);
}

class PlaybackStateChanged extends $pb.GeneratedMessage {
  factory PlaybackStateChanged({
    $core.String? roomId,
    PlaybackState? state,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (state != null) result.state = state;
    return result;
  }

  PlaybackStateChanged._();

  factory PlaybackStateChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackStateChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackStateChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<PlaybackState>(2, _omitFieldNames ? '' : 'state',
        subBuilder: PlaybackState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackStateChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackStateChanged copyWith(void Function(PlaybackStateChanged) updates) =>
      super.copyWith((message) => updates(message as PlaybackStateChanged))
          as PlaybackStateChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackStateChanged create() => PlaybackStateChanged._();
  @$core.override
  PlaybackStateChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackStateChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackStateChanged>(create);
  static PlaybackStateChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  PlaybackState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(PlaybackState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
  @$pb.TagNumber(2)
  PlaybackState ensureState() => $_ensure(1);
}

class PlaybackSnapshotChanged extends $pb.GeneratedMessage {
  factory PlaybackSnapshotChanged({
    $core.String? roomId,
    PlaybackSnapshot? snapshot,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  PlaybackSnapshotChanged._();

  factory PlaybackSnapshotChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackSnapshotChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackSnapshotChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<PlaybackSnapshot>(2, _omitFieldNames ? '' : 'snapshot',
        subBuilder: PlaybackSnapshot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackSnapshotChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackSnapshotChanged copyWith(
          void Function(PlaybackSnapshotChanged) updates) =>
      super.copyWith((message) => updates(message as PlaybackSnapshotChanged))
          as PlaybackSnapshotChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackSnapshotChanged create() => PlaybackSnapshotChanged._();
  @$core.override
  PlaybackSnapshotChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackSnapshotChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackSnapshotChanged>(create);
  static PlaybackSnapshotChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  PlaybackSnapshot get snapshot => $_getN(1);
  @$pb.TagNumber(2)
  set snapshot(PlaybackSnapshot value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshot() => $_clearField(2);
  @$pb.TagNumber(2)
  PlaybackSnapshot ensureSnapshot() => $_ensure(1);
}

class UserJoinedRoom extends $pb.GeneratedMessage {
  factory UserJoinedRoom({
    $core.String? roomId,
    $1.RoomMember? member,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (member != null) result.member = member;
    return result;
  }

  UserJoinedRoom._();

  factory UserJoinedRoom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserJoinedRoom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserJoinedRoom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<$1.RoomMember>(2, _omitFieldNames ? '' : 'member',
        subBuilder: $1.RoomMember.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserJoinedRoom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserJoinedRoom copyWith(void Function(UserJoinedRoom) updates) =>
      super.copyWith((message) => updates(message as UserJoinedRoom))
          as UserJoinedRoom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserJoinedRoom create() => UserJoinedRoom._();
  @$core.override
  UserJoinedRoom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserJoinedRoom getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserJoinedRoom>(create);
  static UserJoinedRoom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RoomMember get member => $_getN(1);
  @$pb.TagNumber(2)
  set member($1.RoomMember value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMember() => $_has(1);
  @$pb.TagNumber(2)
  void clearMember() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RoomMember ensureMember() => $_ensure(1);
}

class UserLeftRoom extends $pb.GeneratedMessage {
  factory UserLeftRoom({
    $core.String? roomId,
    $core.String? userId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    return result;
  }

  UserLeftRoom._();

  factory UserLeftRoom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserLeftRoom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserLeftRoom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLeftRoom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLeftRoom copyWith(void Function(UserLeftRoom) updates) =>
      super.copyWith((message) => updates(message as UserLeftRoom))
          as UserLeftRoom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserLeftRoom create() => UserLeftRoom._();
  @$core.override
  UserLeftRoom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserLeftRoom getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserLeftRoom>(create);
  static UserLeftRoom? _defaultInstance;

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
}

class RoomSettingsChanged extends $pb.GeneratedMessage {
  factory RoomSettingsChanged({
    $core.String? roomId,
    $core.List<$core.int>? settings,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (settings != null) result.settings = settings;
    if (version != null) result.version = version;
    return result;
  }

  RoomSettingsChanged._();

  factory RoomSettingsChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomSettingsChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomSettingsChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomSettingsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomSettingsChanged copyWith(void Function(RoomSettingsChanged) updates) =>
      super.copyWith((message) => updates(message as RoomSettingsChanged))
          as RoomSettingsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomSettingsChanged create() => RoomSettingsChanged._();
  @$core.override
  RoomSettingsChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomSettingsChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomSettingsChanged>(create);
  static RoomSettingsChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class ErrorMessage extends $pb.GeneratedMessage {
  factory ErrorMessage({
    $core.String? message,
    $core.int? code,
    $core.String? detail,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    return result;
  }

  ErrorMessage._();

  factory ErrorMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aI(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorMessage copyWith(void Function(ErrorMessage) updates) =>
      super.copyWith((message) => updates(message as ErrorMessage))
          as ErrorMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorMessage create() => ErrorMessage._();
  @$core.override
  ErrorMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorMessage>(create);
  static ErrorMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get code => $_getIZ(1);
  @$pb.TagNumber(2)
  set code($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get detail => $_getSZ(2);
  @$pb.TagNumber(3)
  set detail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetail() => $_clearField(3);
}

/// User Notification
/// Push notification delivered to user's WebSocket connection.
///
/// This message type replaces the historical abuse of ErrorMessage with code 5000
/// (NOTIFICATION_PUSH). Clients should handle this variant separately from errors.
///
/// The notification is pushed in real-time when a database-backed notification is
/// created via UserNotificationService. The notification_id allows clients to
/// deduplicate notifications if they receive them multiple times (e.g., during
/// reconnection).
///
/// Example notification types:
/// - "room_invitation": User invited to join a room
/// - "system": System-wide announcement
/// - "room_event": Room-specific event (e.g., room closed, settings changed)
class UserNotification extends $pb.GeneratedMessage {
  factory UserNotification({
    $core.String? notificationId,
    $core.String? notificationType,
    $core.String? title,
    $core.String? content,
    $core.String? data,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (notificationId != null) result.notificationId = notificationId;
    if (notificationType != null) result.notificationType = notificationType;
    if (title != null) result.title = title;
    if (content != null) result.content = content;
    if (data != null) result.data = data;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  UserNotification._();

  factory UserNotification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserNotification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserNotification',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'notificationId')
    ..aOS(2, _omitFieldNames ? '' : 'notificationType')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOS(5, _omitFieldNames ? '' : 'data')
    ..aInt64(6, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserNotification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserNotification copyWith(void Function(UserNotification) updates) =>
      super.copyWith((message) => updates(message as UserNotification))
          as UserNotification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserNotification create() => UserNotification._();
  @$core.override
  UserNotification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserNotification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserNotification>(create);
  static UserNotification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get notificationType => $_getSZ(1);
  @$pb.TagNumber(2)
  set notificationType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNotificationType() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotificationType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get data => $_getSZ(4);
  @$pb.TagNumber(5)
  set data($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasData() => $_has(4);
  @$pb.TagNumber(5)
  void clearData() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get timestamp => $_getI64(5);
  @$pb.TagNumber(6)
  set timestamp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => $_clearField(6);
}

/// Chat History
/// Note: room_id extracted from x-room-id metadata
class GetChatHistoryRequest extends $pb.GeneratedMessage {
  factory GetChatHistoryRequest({
    $core.int? limit,
    $core.String? cursor,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    if (cursor != null) result.cursor = cursor;
    return result;
  }

  GetChatHistoryRequest._();

  factory GetChatHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChatHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChatHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatHistoryRequest copyWith(
          void Function(GetChatHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetChatHistoryRequest))
          as GetChatHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChatHistoryRequest create() => GetChatHistoryRequest._();
  @$core.override
  GetChatHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetChatHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChatHistoryRequest>(create);
  static GetChatHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);
}

class GetChatHistoryResponse extends $pb.GeneratedMessage {
  factory GetChatHistoryResponse({
    $core.Iterable<ChatMessageReceive>? messages,
    $core.String? nextCursor,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    if (nextCursor != null) result.nextCursor = nextCursor;
    return result;
  }

  GetChatHistoryResponse._();

  factory GetChatHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetChatHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetChatHistoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<ChatMessageReceive>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: ChatMessageReceive.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextCursor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetChatHistoryResponse copyWith(
          void Function(GetChatHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as GetChatHistoryResponse))
          as GetChatHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetChatHistoryResponse create() => GetChatHistoryResponse._();
  @$core.override
  GetChatHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetChatHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetChatHistoryResponse>(create);
  static GetChatHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessageReceive> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextCursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextCursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextCursor() => $_clearField(2);
}

/// User Profile Management
class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => create();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutRequest create() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(create);
  static LogoutRequest? _defaultInstance;
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  /// Non-empty when logout succeeded but token invalidation may be delayed
  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class SetUsernameRequest extends $pb.GeneratedMessage {
  factory SetUsernameRequest({
    $core.String? newUsername,
  }) {
    final result = create();
    if (newUsername != null) result.newUsername = newUsername;
    return result;
  }

  SetUsernameRequest._();

  factory SetUsernameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetUsernameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetUsernameRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'newUsername')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUsernameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUsernameRequest copyWith(void Function(SetUsernameRequest) updates) =>
      super.copyWith((message) => updates(message as SetUsernameRequest))
          as SetUsernameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetUsernameRequest create() => SetUsernameRequest._();
  @$core.override
  SetUsernameRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetUsernameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetUsernameRequest>(create);
  static SetUsernameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get newUsername => $_getSZ(0);
  @$pb.TagNumber(1)
  set newUsername($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNewUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearNewUsername() => $_clearField(1);
}

class SetUsernameResponse extends $pb.GeneratedMessage {
  factory SetUsernameResponse({
    User? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  SetUsernameResponse._();

  factory SetUsernameResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetUsernameResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetUsernameResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<User>(1, _omitFieldNames ? '' : 'user', subBuilder: User.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUsernameResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUsernameResponse copyWith(void Function(SetUsernameResponse) updates) =>
      super.copyWith((message) => updates(message as SetUsernameResponse))
          as SetUsernameResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetUsernameResponse create() => SetUsernameResponse._();
  @$core.override
  SetUsernameResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetUsernameResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetUsernameResponse>(create);
  static SetUsernameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  User get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(User value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  User ensureUser() => $_ensure(0);
}

class ListMyRoomsRequest extends $pb.GeneratedMessage {
  factory ListMyRoomsRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    $1.RoomStatus? status,
    $core.bool? isBanned,
    MyRoomRelation? relation,
    MyRoomListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (status != null) result.status = status;
    if (isBanned != null) result.isBanned = isBanned;
    if (relation != null) result.relation = relation;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListMyRoomsRequest._();

  factory ListMyRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMyRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyRoomsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'search')
    ..aE<$1.RoomStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: $1.RoomStatus.values)
    ..aOB(5, _omitFieldNames ? '' : 'isBanned')
    ..aE<MyRoomRelation>(6, _omitFieldNames ? '' : 'relation',
        enumValues: MyRoomRelation.values)
    ..aE<MyRoomListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: MyRoomListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyRoomsRequest copyWith(void Function(ListMyRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as ListMyRoomsRequest))
          as ListMyRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMyRoomsRequest create() => ListMyRoomsRequest._();
  @$core.override
  ListMyRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMyRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyRoomsRequest>(create);
  static ListMyRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get search => $_getSZ(2);
  @$pb.TagNumber(3)
  set search($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSearch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearch() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.RoomStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status($1.RoomStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isBanned => $_getBF(4);
  @$pb.TagNumber(5)
  set isBanned($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsBanned() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsBanned() => $_clearField(5);

  @$pb.TagNumber(6)
  MyRoomRelation get relation => $_getN(5);
  @$pb.TagNumber(6)
  set relation(MyRoomRelation value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRelation() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelation() => $_clearField(6);

  @$pb.TagNumber(7)
  MyRoomListSortBy get sortBy => $_getN(6);
  @$pb.TagNumber(7)
  set sortBy(MyRoomListSortBy value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortBy() => $_clearField(7);

  @$pb.TagNumber(8)
  SortDirection get sortDirection => $_getN(7);
  @$pb.TagNumber(8)
  set sortDirection(SortDirection value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSortDirection() => $_has(7);
  @$pb.TagNumber(8)
  void clearSortDirection() => $_clearField(8);
}

class ListMyRoomsResponse extends $pb.GeneratedMessage {
  factory ListMyRoomsResponse({
    $core.Iterable<MyRoom>? rooms,
    $core.int? total,
  }) {
    final result = create();
    if (rooms != null) result.rooms.addAll(rooms);
    if (total != null) result.total = total;
    return result;
  }

  ListMyRoomsResponse._();

  factory ListMyRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMyRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMyRoomsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<MyRoom>(1, _omitFieldNames ? '' : 'rooms', subBuilder: MyRoom.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMyRoomsResponse copyWith(void Function(ListMyRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as ListMyRoomsResponse))
          as ListMyRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMyRoomsResponse create() => ListMyRoomsResponse._();
  @$core.override
  ListMyRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMyRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMyRoomsResponse>(create);
  static ListMyRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MyRoom> get rooms => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class MyRoom extends $pb.GeneratedMessage {
  factory MyRoom({
    Room? room,
    $fixnum.Int64? permissions,
    $1.RoomMemberRole? role,
    MyRoomRelation? relation,
  }) {
    final result = create();
    if (room != null) result.room = room;
    if (permissions != null) result.permissions = permissions;
    if (role != null) result.role = role;
    if (relation != null) result.relation = relation;
    return result;
  }

  MyRoom._();

  factory MyRoom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MyRoom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MyRoom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'permissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<$1.RoomMemberRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..aE<MyRoomRelation>(4, _omitFieldNames ? '' : 'relation',
        enumValues: MyRoomRelation.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyRoom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MyRoom copyWith(void Function(MyRoom) updates) =>
      super.copyWith((message) => updates(message as MyRoom)) as MyRoom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MyRoom create() => MyRoom._();
  @$core.override
  MyRoom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MyRoom getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MyRoom>(create);
  static MyRoom? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get permissions => $_getI64(1);
  @$pb.TagNumber(2)
  set permissions($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPermissions() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissions() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.RoomMemberRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($1.RoomMemberRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  MyRoomRelation get relation => $_getN(3);
  @$pb.TagNumber(4)
  set relation(MyRoomRelation value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRelation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRelation() => $_clearField(4);
}

/// Room Discovery
class CheckRoomRequest extends $pb.GeneratedMessage {
  factory CheckRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  CheckRoomRequest._();

  factory CheckRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomRequest copyWith(void Function(CheckRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CheckRoomRequest))
          as CheckRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRoomRequest create() => CheckRoomRequest._();
  @$core.override
  CheckRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRoomRequest>(create);
  static CheckRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class RoomMemberTargetPathRequest extends $pb.GeneratedMessage {
  factory RoomMemberTargetPathRequest({
    $core.String? roomId,
    $core.String? userId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    return result;
  }

  RoomMemberTargetPathRequest._();

  factory RoomMemberTargetPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomMemberTargetPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomMemberTargetPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMemberTargetPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMemberTargetPathRequest copyWith(
          void Function(RoomMemberTargetPathRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RoomMemberTargetPathRequest))
          as RoomMemberTargetPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMemberTargetPathRequest create() =>
      RoomMemberTargetPathRequest._();
  @$core.override
  RoomMemberTargetPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomMemberTargetPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomMemberTargetPathRequest>(create);
  static RoomMemberTargetPathRequest? _defaultInstance;

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
}

class RoomJoinReviewPathRequest extends $pb.GeneratedMessage {
  factory RoomJoinReviewPathRequest({
    $core.String? roomId,
    $core.String? requestId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  RoomJoinReviewPathRequest._();

  factory RoomJoinReviewPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomJoinReviewPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomJoinReviewPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomJoinReviewPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomJoinReviewPathRequest copyWith(
          void Function(RoomJoinReviewPathRequest) updates) =>
      super.copyWith((message) => updates(message as RoomJoinReviewPathRequest))
          as RoomJoinReviewPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomJoinReviewPathRequest create() => RoomJoinReviewPathRequest._();
  @$core.override
  RoomJoinReviewPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomJoinReviewPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomJoinReviewPathRequest>(create);
  static RoomJoinReviewPathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);
}

class RoomPathRequest extends $pb.GeneratedMessage {
  factory RoomPathRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  RoomPathRequest._();

  factory RoomPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomPathRequest copyWith(void Function(RoomPathRequest) updates) =>
      super.copyWith((message) => updates(message as RoomPathRequest))
          as RoomPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomPathRequest create() => RoomPathRequest._();
  @$core.override
  RoomPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomPathRequest>(create);
  static RoomPathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class RoomMediaTargetPathRequest extends $pb.GeneratedMessage {
  factory RoomMediaTargetPathRequest({
    $core.String? roomId,
    $core.String? mediaId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  RoomMediaTargetPathRequest._();

  factory RoomMediaTargetPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomMediaTargetPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomMediaTargetPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMediaTargetPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomMediaTargetPathRequest copyWith(
          void Function(RoomMediaTargetPathRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RoomMediaTargetPathRequest))
          as RoomMediaTargetPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomMediaTargetPathRequest create() => RoomMediaTargetPathRequest._();
  @$core.override
  RoomMediaTargetPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomMediaTargetPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomMediaTargetPathRequest>(create);
  static RoomMediaTargetPathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);
}

class RoomPlaylistTargetPathRequest extends $pb.GeneratedMessage {
  factory RoomPlaylistTargetPathRequest({
    $core.String? roomId,
    $core.String? playlistId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (playlistId != null) result.playlistId = playlistId;
    return result;
  }

  RoomPlaylistTargetPathRequest._();

  factory RoomPlaylistTargetPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomPlaylistTargetPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomPlaylistTargetPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'playlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomPlaylistTargetPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomPlaylistTargetPathRequest copyWith(
          void Function(RoomPlaylistTargetPathRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RoomPlaylistTargetPathRequest))
          as RoomPlaylistTargetPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomPlaylistTargetPathRequest create() =>
      RoomPlaylistTargetPathRequest._();
  @$core.override
  RoomPlaylistTargetPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomPlaylistTargetPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomPlaylistTargetPathRequest>(create);
  static RoomPlaylistTargetPathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylistId() => $_clearField(2);
}

class CheckRoomResponse extends $pb.GeneratedMessage {
  factory CheckRoomResponse({
    $core.bool? exists,
    $core.bool? requiresPassword,
    $core.String? name,
    ResourceAvailability? availability,
  }) {
    final result = create();
    if (exists != null) result.exists = exists;
    if (requiresPassword != null) result.requiresPassword = requiresPassword;
    if (name != null) result.name = name;
    if (availability != null) result.availability = availability;
    return result;
  }

  CheckRoomResponse._();

  factory CheckRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'exists')
    ..aOB(2, _omitFieldNames ? '' : 'requiresPassword')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aE<ResourceAvailability>(4, _omitFieldNames ? '' : 'availability',
        enumValues: ResourceAvailability.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRoomResponse copyWith(void Function(CheckRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CheckRoomResponse))
          as CheckRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRoomResponse create() => CheckRoomResponse._();
  @$core.override
  CheckRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRoomResponse>(create);
  static CheckRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get exists => $_getBF(0);
  @$pb.TagNumber(1)
  set exists($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExists() => $_has(0);
  @$pb.TagNumber(1)
  void clearExists() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get requiresPassword => $_getBF(1);
  @$pb.TagNumber(2)
  set requiresPassword($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequiresPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequiresPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  ResourceAvailability get availability => $_getN(3);
  @$pb.TagNumber(4)
  set availability(ResourceAvailability value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAvailability() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvailability() => $_clearField(4);
}

class GetHotRoomsRequest extends $pb.GeneratedMessage {
  factory GetHotRoomsRequest({
    $core.int? limit,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    return result;
  }

  GetHotRoomsRequest._();

  factory GetHotRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHotRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHotRoomsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHotRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHotRoomsRequest copyWith(void Function(GetHotRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as GetHotRoomsRequest))
          as GetHotRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHotRoomsRequest create() => GetHotRoomsRequest._();
  @$core.override
  GetHotRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHotRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHotRoomsRequest>(create);
  static GetHotRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class GetHotRoomsResponse extends $pb.GeneratedMessage {
  factory GetHotRoomsResponse({
    $core.Iterable<RoomWithStats>? rooms,
  }) {
    final result = create();
    if (rooms != null) result.rooms.addAll(rooms);
    return result;
  }

  GetHotRoomsResponse._();

  factory GetHotRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetHotRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHotRoomsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<RoomWithStats>(1, _omitFieldNames ? '' : 'rooms',
        subBuilder: RoomWithStats.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHotRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHotRoomsResponse copyWith(void Function(GetHotRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as GetHotRoomsResponse))
          as GetHotRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHotRoomsResponse create() => GetHotRoomsResponse._();
  @$core.override
  GetHotRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetHotRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHotRoomsResponse>(create);
  static GetHotRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RoomWithStats> get rooms => $_getList(0);
}

class RoomWithStats extends $pb.GeneratedMessage {
  factory RoomWithStats({
    Room? room,
    $core.int? onlineCount,
    $core.int? totalMembers,
  }) {
    final result = create();
    if (room != null) result.room = room;
    if (onlineCount != null) result.onlineCount = onlineCount;
    if (totalMembers != null) result.totalMembers = totalMembers;
    return result;
  }

  RoomWithStats._();

  factory RoomWithStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomWithStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomWithStats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..aI(2, _omitFieldNames ? '' : 'onlineCount')
    ..aI(3, _omitFieldNames ? '' : 'totalMembers')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomWithStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomWithStats copyWith(void Function(RoomWithStats) updates) =>
      super.copyWith((message) => updates(message as RoomWithStats))
          as RoomWithStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomWithStats create() => RoomWithStats._();
  @$core.override
  RoomWithStats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomWithStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomWithStats>(create);
  static RoomWithStats? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get onlineCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set onlineCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnlineCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnlineCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalMembers => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalMembers($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalMembers() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalMembers() => $_clearField(3);
}

class GetPublicSettingsRequest extends $pb.GeneratedMessage {
  factory GetPublicSettingsRequest() => create();

  GetPublicSettingsRequest._();

  factory GetPublicSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPublicSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPublicSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicSettingsRequest copyWith(
          void Function(GetPublicSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPublicSettingsRequest))
          as GetPublicSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPublicSettingsRequest create() => GetPublicSettingsRequest._();
  @$core.override
  GetPublicSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPublicSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPublicSettingsRequest>(create);
  static GetPublicSettingsRequest? _defaultInstance;
}

class GetPublicSettingsResponse extends $pb.GeneratedMessage {
  factory GetPublicSettingsResponse({
    $core.bool? allowRoomCreation,
    $fixnum.Int64? maxRoomsPerUser,
    $fixnum.Int64? maxMembersPerRoom,
    $core.bool? disableCreateRoom,
    $core.bool? createRoomNeedReview,
    $core.String? roomPasswordPolicy,
    $core.bool? enablePasswordSignup,
    $core.bool? movieProxy,
    $core.bool? liveProxy,
    $core.bool? tsDisguisedAsPng,
    $core.String? customPublishHost,
    $core.bool? emailWhitelistEnabled,
    $core.bool? passwordSignupNeedReview,
    $core.bool? enableEmailSignup,
    $core.bool? enableGuest,
    $core.bool? emailSignupNeedReview,
    $core.bool? enableWebauthnSignup,
    $core.bool? webauthnSignupNeedReview,
  }) {
    final result = create();
    if (allowRoomCreation != null) result.allowRoomCreation = allowRoomCreation;
    if (maxRoomsPerUser != null) result.maxRoomsPerUser = maxRoomsPerUser;
    if (maxMembersPerRoom != null) result.maxMembersPerRoom = maxMembersPerRoom;
    if (disableCreateRoom != null) result.disableCreateRoom = disableCreateRoom;
    if (createRoomNeedReview != null)
      result.createRoomNeedReview = createRoomNeedReview;
    if (roomPasswordPolicy != null)
      result.roomPasswordPolicy = roomPasswordPolicy;
    if (enablePasswordSignup != null)
      result.enablePasswordSignup = enablePasswordSignup;
    if (movieProxy != null) result.movieProxy = movieProxy;
    if (liveProxy != null) result.liveProxy = liveProxy;
    if (tsDisguisedAsPng != null) result.tsDisguisedAsPng = tsDisguisedAsPng;
    if (customPublishHost != null) result.customPublishHost = customPublishHost;
    if (emailWhitelistEnabled != null)
      result.emailWhitelistEnabled = emailWhitelistEnabled;
    if (passwordSignupNeedReview != null)
      result.passwordSignupNeedReview = passwordSignupNeedReview;
    if (enableEmailSignup != null) result.enableEmailSignup = enableEmailSignup;
    if (enableGuest != null) result.enableGuest = enableGuest;
    if (emailSignupNeedReview != null)
      result.emailSignupNeedReview = emailSignupNeedReview;
    if (enableWebauthnSignup != null)
      result.enableWebauthnSignup = enableWebauthnSignup;
    if (webauthnSignupNeedReview != null)
      result.webauthnSignupNeedReview = webauthnSignupNeedReview;
    return result;
  }

  GetPublicSettingsResponse._();

  factory GetPublicSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPublicSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPublicSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(2, _omitFieldNames ? '' : 'allowRoomCreation')
    ..aInt64(3, _omitFieldNames ? '' : 'maxRoomsPerUser')
    ..aInt64(4, _omitFieldNames ? '' : 'maxMembersPerRoom')
    ..aOB(5, _omitFieldNames ? '' : 'disableCreateRoom')
    ..aOB(6, _omitFieldNames ? '' : 'createRoomNeedReview')
    ..aOS(8, _omitFieldNames ? '' : 'roomPasswordPolicy')
    ..aOB(10, _omitFieldNames ? '' : 'enablePasswordSignup')
    ..aOB(11, _omitFieldNames ? '' : 'movieProxy')
    ..aOB(12, _omitFieldNames ? '' : 'liveProxy')
    ..aOB(13, _omitFieldNames ? '' : 'tsDisguisedAsPng')
    ..aOS(14, _omitFieldNames ? '' : 'customPublishHost')
    ..aOB(15, _omitFieldNames ? '' : 'emailWhitelistEnabled')
    ..aOB(16, _omitFieldNames ? '' : 'passwordSignupNeedReview')
    ..aOB(17, _omitFieldNames ? '' : 'enableEmailSignup')
    ..aOB(18, _omitFieldNames ? '' : 'enableGuest')
    ..aOB(19, _omitFieldNames ? '' : 'emailSignupNeedReview')
    ..aOB(22, _omitFieldNames ? '' : 'enableWebauthnSignup')
    ..aOB(23, _omitFieldNames ? '' : 'webauthnSignupNeedReview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPublicSettingsResponse copyWith(
          void Function(GetPublicSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetPublicSettingsResponse))
          as GetPublicSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPublicSettingsResponse create() => GetPublicSettingsResponse._();
  @$core.override
  GetPublicSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPublicSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPublicSettingsResponse>(create);
  static GetPublicSettingsResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.bool get allowRoomCreation => $_getBF(0);
  @$pb.TagNumber(2)
  set allowRoomCreation($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(2)
  $core.bool hasAllowRoomCreation() => $_has(0);
  @$pb.TagNumber(2)
  void clearAllowRoomCreation() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxRoomsPerUser => $_getI64(1);
  @$pb.TagNumber(3)
  set maxRoomsPerUser($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxRoomsPerUser() => $_has(1);
  @$pb.TagNumber(3)
  void clearMaxRoomsPerUser() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get maxMembersPerRoom => $_getI64(2);
  @$pb.TagNumber(4)
  set maxMembersPerRoom($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxMembersPerRoom() => $_has(2);
  @$pb.TagNumber(4)
  void clearMaxMembersPerRoom() => $_clearField(4);

  /// Room settings
  @$pb.TagNumber(5)
  $core.bool get disableCreateRoom => $_getBF(3);
  @$pb.TagNumber(5)
  set disableCreateRoom($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(5)
  $core.bool hasDisableCreateRoom() => $_has(3);
  @$pb.TagNumber(5)
  void clearDisableCreateRoom() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get createRoomNeedReview => $_getBF(4);
  @$pb.TagNumber(6)
  set createRoomNeedReview($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(6)
  $core.bool hasCreateRoomNeedReview() => $_has(4);
  @$pb.TagNumber(6)
  void clearCreateRoomNeedReview() => $_clearField(6);

  @$pb.TagNumber(8)
  $core.String get roomPasswordPolicy => $_getSZ(5);
  @$pb.TagNumber(8)
  set roomPasswordPolicy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(8)
  $core.bool hasRoomPasswordPolicy() => $_has(5);
  @$pb.TagNumber(8)
  void clearRoomPasswordPolicy() => $_clearField(8);

  /// User settings
  @$pb.TagNumber(10)
  $core.bool get enablePasswordSignup => $_getBF(6);
  @$pb.TagNumber(10)
  set enablePasswordSignup($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(10)
  $core.bool hasEnablePasswordSignup() => $_has(6);
  @$pb.TagNumber(10)
  void clearEnablePasswordSignup() => $_clearField(10);

  /// Proxy settings
  @$pb.TagNumber(11)
  $core.bool get movieProxy => $_getBF(7);
  @$pb.TagNumber(11)
  set movieProxy($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(11)
  $core.bool hasMovieProxy() => $_has(7);
  @$pb.TagNumber(11)
  void clearMovieProxy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get liveProxy => $_getBF(8);
  @$pb.TagNumber(12)
  set liveProxy($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(12)
  $core.bool hasLiveProxy() => $_has(8);
  @$pb.TagNumber(12)
  void clearLiveProxy() => $_clearField(12);

  /// RTMP settings
  @$pb.TagNumber(13)
  $core.bool get tsDisguisedAsPng => $_getBF(9);
  @$pb.TagNumber(13)
  set tsDisguisedAsPng($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(13)
  $core.bool hasTsDisguisedAsPng() => $_has(9);
  @$pb.TagNumber(13)
  void clearTsDisguisedAsPng() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get customPublishHost => $_getSZ(10);
  @$pb.TagNumber(14)
  set customPublishHost($core.String value) => $_setString(10, value);
  @$pb.TagNumber(14)
  $core.bool hasCustomPublishHost() => $_has(10);
  @$pb.TagNumber(14)
  void clearCustomPublishHost() => $_clearField(14);

  /// Email settings
  @$pb.TagNumber(15)
  $core.bool get emailWhitelistEnabled => $_getBF(11);
  @$pb.TagNumber(15)
  set emailWhitelistEnabled($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(15)
  $core.bool hasEmailWhitelistEnabled() => $_has(11);
  @$pb.TagNumber(15)
  void clearEmailWhitelistEnabled() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get passwordSignupNeedReview => $_getBF(12);
  @$pb.TagNumber(16)
  set passwordSignupNeedReview($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(16)
  $core.bool hasPasswordSignupNeedReview() => $_has(12);
  @$pb.TagNumber(16)
  void clearPasswordSignupNeedReview() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get enableEmailSignup => $_getBF(13);
  @$pb.TagNumber(17)
  set enableEmailSignup($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(17)
  $core.bool hasEnableEmailSignup() => $_has(13);
  @$pb.TagNumber(17)
  void clearEnableEmailSignup() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get enableGuest => $_getBF(14);
  @$pb.TagNumber(18)
  set enableGuest($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(18)
  $core.bool hasEnableGuest() => $_has(14);
  @$pb.TagNumber(18)
  void clearEnableGuest() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get emailSignupNeedReview => $_getBF(15);
  @$pb.TagNumber(19)
  set emailSignupNeedReview($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(19)
  $core.bool hasEmailSignupNeedReview() => $_has(15);
  @$pb.TagNumber(19)
  void clearEmailSignupNeedReview() => $_clearField(19);

  @$pb.TagNumber(22)
  $core.bool get enableWebauthnSignup => $_getBF(16);
  @$pb.TagNumber(22)
  set enableWebauthnSignup($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(22)
  $core.bool hasEnableWebauthnSignup() => $_has(16);
  @$pb.TagNumber(22)
  void clearEnableWebauthnSignup() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.bool get webauthnSignupNeedReview => $_getBF(17);
  @$pb.TagNumber(23)
  set webauthnSignupNeedReview($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(23)
  $core.bool hasWebauthnSignupNeedReview() => $_has(17);
  @$pb.TagNumber(23)
  void clearWebauthnSignupNeedReview() => $_clearField(23);
}

class GetServerInfoRequest extends $pb.GeneratedMessage {
  factory GetServerInfoRequest() => create();

  GetServerInfoRequest._();

  factory GetServerInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoRequest copyWith(void Function(GetServerInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetServerInfoRequest))
          as GetServerInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerInfoRequest create() => GetServerInfoRequest._();
  @$core.override
  GetServerInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServerInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerInfoRequest>(create);
  static GetServerInfoRequest? _defaultInstance;
}

class GetServerInfoResponse extends $pb.GeneratedMessage {
  factory GetServerInfoResponse({
    $core.String? serverId,
    $core.String? serverName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (serverName != null) result.serverName = serverName;
    return result;
  }

  GetServerInfoResponse._();

  factory GetServerInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'serverName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoResponse copyWith(
          void Function(GetServerInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetServerInfoResponse))
          as GetServerInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerInfoResponse create() => GetServerInfoResponse._();
  @$core.override
  GetServerInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServerInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerInfoResponse>(create);
  static GetServerInfoResponse? _defaultInstance;

  /// Stable logical server identity. The server automatically initializes it
  /// in runtime settings storage; clients only read it.
  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverName => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerName() => $_clearField(2);
}

class SendVerificationEmailRequest extends $pb.GeneratedMessage {
  factory SendVerificationEmailRequest({
    $core.String? email,
  }) {
    final result = create();
    if (email != null) result.email = email;
    return result;
  }

  SendVerificationEmailRequest._();

  factory SendVerificationEmailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationEmailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationEmailRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailRequest copyWith(
          void Function(SendVerificationEmailRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SendVerificationEmailRequest))
          as SendVerificationEmailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailRequest create() =>
      SendVerificationEmailRequest._();
  @$core.override
  SendVerificationEmailRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendVerificationEmailRequest>(create);
  static SendVerificationEmailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class SendVerificationEmailResponse extends $pb.GeneratedMessage {
  factory SendVerificationEmailResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  SendVerificationEmailResponse._();

  factory SendVerificationEmailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationEmailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationEmailResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailResponse copyWith(
          void Function(SendVerificationEmailResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SendVerificationEmailResponse))
          as SendVerificationEmailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailResponse create() =>
      SendVerificationEmailResponse._();
  @$core.override
  SendVerificationEmailResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendVerificationEmailResponse>(create);
  static SendVerificationEmailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class ConfirmEmailRequest extends $pb.GeneratedMessage {
  factory ConfirmEmailRequest({
    $core.String? email,
    $core.String? token,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (token != null) result.token = token;
    return result;
  }

  ConfirmEmailRequest._();

  factory ConfirmEmailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmEmailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmEmailRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmEmailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmEmailRequest copyWith(void Function(ConfirmEmailRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmEmailRequest))
          as ConfirmEmailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmEmailRequest create() => ConfirmEmailRequest._();
  @$core.override
  ConfirmEmailRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmEmailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmEmailRequest>(create);
  static ConfirmEmailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

class ConfirmEmailResponse extends $pb.GeneratedMessage {
  factory ConfirmEmailResponse({
    $core.String? message,
    $core.String? userId,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (userId != null) result.userId = userId;
    return result;
  }

  ConfirmEmailResponse._();

  factory ConfirmEmailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmEmailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmEmailResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmEmailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmEmailResponse copyWith(void Function(ConfirmEmailResponse) updates) =>
      super.copyWith((message) => updates(message as ConfirmEmailResponse))
          as ConfirmEmailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmEmailResponse create() => ConfirmEmailResponse._();
  @$core.override
  ConfirmEmailResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmEmailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmEmailResponse>(create);
  static ConfirmEmailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class RequestPasswordResetRequest extends $pb.GeneratedMessage {
  factory RequestPasswordResetRequest({
    $core.String? email,
  }) {
    final result = create();
    if (email != null) result.email = email;
    return result;
  }

  RequestPasswordResetRequest._();

  factory RequestPasswordResetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestPasswordResetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestPasswordResetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPasswordResetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPasswordResetRequest copyWith(
          void Function(RequestPasswordResetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RequestPasswordResetRequest))
          as RequestPasswordResetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestPasswordResetRequest create() =>
      RequestPasswordResetRequest._();
  @$core.override
  RequestPasswordResetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestPasswordResetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestPasswordResetRequest>(create);
  static RequestPasswordResetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class RequestPasswordResetResponse extends $pb.GeneratedMessage {
  factory RequestPasswordResetResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  RequestPasswordResetResponse._();

  factory RequestPasswordResetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestPasswordResetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestPasswordResetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPasswordResetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPasswordResetResponse copyWith(
          void Function(RequestPasswordResetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RequestPasswordResetResponse))
          as RequestPasswordResetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestPasswordResetResponse create() =>
      RequestPasswordResetResponse._();
  @$core.override
  RequestPasswordResetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestPasswordResetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestPasswordResetResponse>(create);
  static RequestPasswordResetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

/// Start resetting a password with an email reset token. The reset token is
/// consumed here and exchanged for a short-lived OPAQUE registration session.
/// The server receives only the OPAQUE registration request for the new password.
class StartOpaquePasswordResetRequest extends $pb.GeneratedMessage {
  factory StartOpaquePasswordResetRequest({
    $core.String? email,
    $core.String? token,
    $core.List<$core.int>? registrationRequest,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (token != null) result.token = token;
    if (registrationRequest != null)
      result.registrationRequest = registrationRequest;
    return result;
  }

  StartOpaquePasswordResetRequest._();

  factory StartOpaquePasswordResetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaquePasswordResetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaquePasswordResetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'registrationRequest', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordResetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordResetRequest copyWith(
          void Function(StartOpaquePasswordResetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StartOpaquePasswordResetRequest))
          as StartOpaquePasswordResetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordResetRequest create() =>
      StartOpaquePasswordResetRequest._();
  @$core.override
  StartOpaquePasswordResetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordResetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaquePasswordResetRequest>(
          create);
  static StartOpaquePasswordResetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get registrationRequest => $_getN(2);
  @$pb.TagNumber(3)
  set registrationRequest($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegistrationRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegistrationRequest() => $_clearField(3);
}

class StartOpaquePasswordResetResponse extends $pb.GeneratedMessage {
  factory StartOpaquePasswordResetResponse({
    $core.String? sessionId,
    $core.List<$core.int>? registrationResponse,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (registrationResponse != null)
      result.registrationResponse = registrationResponse;
    return result;
  }

  StartOpaquePasswordResetResponse._();

  factory StartOpaquePasswordResetResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOpaquePasswordResetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOpaquePasswordResetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'registrationResponse', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordResetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOpaquePasswordResetResponse copyWith(
          void Function(StartOpaquePasswordResetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StartOpaquePasswordResetResponse))
          as StartOpaquePasswordResetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordResetResponse create() =>
      StartOpaquePasswordResetResponse._();
  @$core.override
  StartOpaquePasswordResetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOpaquePasswordResetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOpaquePasswordResetResponse>(
          create);
  static StartOpaquePasswordResetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationResponse => $_getN(1);
  @$pb.TagNumber(2)
  set registrationResponse($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationResponse() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationResponse() => $_clearField(2);
}

class FinishOpaquePasswordResetRequest extends $pb.GeneratedMessage {
  factory FinishOpaquePasswordResetRequest({
    $core.String? sessionId,
    $core.List<$core.int>? registrationUpload,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (registrationUpload != null)
      result.registrationUpload = registrationUpload;
    return result;
  }

  FinishOpaquePasswordResetRequest._();

  factory FinishOpaquePasswordResetRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FinishOpaquePasswordResetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinishOpaquePasswordResetRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'registrationUpload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaquePasswordResetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinishOpaquePasswordResetRequest copyWith(
          void Function(FinishOpaquePasswordResetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as FinishOpaquePasswordResetRequest))
          as FinishOpaquePasswordResetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinishOpaquePasswordResetRequest create() =>
      FinishOpaquePasswordResetRequest._();
  @$core.override
  FinishOpaquePasswordResetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FinishOpaquePasswordResetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FinishOpaquePasswordResetRequest>(
          create);
  static FinishOpaquePasswordResetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get registrationUpload => $_getN(1);
  @$pb.TagNumber(2)
  set registrationUpload($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistrationUpload() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistrationUpload() => $_clearField(2);
}

class ConfirmPasswordResetResponse extends $pb.GeneratedMessage {
  factory ConfirmPasswordResetResponse({
    $core.String? message,
    $core.String? userId,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (userId != null) result.userId = userId;
    return result;
  }

  ConfirmPasswordResetResponse._();

  factory ConfirmPasswordResetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfirmPasswordResetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmPasswordResetResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPasswordResetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPasswordResetResponse copyWith(
          void Function(ConfirmPasswordResetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConfirmPasswordResetResponse))
          as ConfirmPasswordResetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfirmPasswordResetResponse create() =>
      ConfirmPasswordResetResponse._();
  @$core.override
  ConfirmPasswordResetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfirmPasswordResetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmPasswordResetResponse>(create);
  static ConfirmPasswordResetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
}

class MediaAdded extends $pb.GeneratedMessage {
  factory MediaAdded({
    $core.String? roomId,
    $core.String? mediaId,
    $core.String? name,
    $core.String? creatorUsername,
    $core.String? creatorId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    if (name != null) result.name = name;
    if (creatorUsername != null) result.creatorUsername = creatorUsername;
    if (creatorId != null) result.creatorId = creatorId;
    return result;
  }

  MediaAdded._();

  factory MediaAdded.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaAdded.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaAdded',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'creatorUsername')
    ..aOS(5, _omitFieldNames ? '' : 'creatorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaAdded clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaAdded copyWith(void Function(MediaAdded) updates) =>
      super.copyWith((message) => updates(message as MediaAdded)) as MediaAdded;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaAdded create() => MediaAdded._();
  @$core.override
  MediaAdded createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaAdded getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaAdded>(create);
  static MediaAdded? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorUsername => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorUsername($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorId() => $_clearField(5);
}

class MediaRemoved extends $pb.GeneratedMessage {
  factory MediaRemoved({
    $core.String? roomId,
    $core.String? mediaId,
    $core.String? removedBy,
    $core.String? removedByUserId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    if (removedBy != null) result.removedBy = removedBy;
    if (removedByUserId != null) result.removedByUserId = removedByUserId;
    return result;
  }

  MediaRemoved._();

  factory MediaRemoved.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaRemoved.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaRemoved',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..aOS(4, _omitFieldNames ? '' : 'removedBy')
    ..aOS(5, _omitFieldNames ? '' : 'removedByUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRemoved clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRemoved copyWith(void Function(MediaRemoved) updates) =>
      super.copyWith((message) => updates(message as MediaRemoved))
          as MediaRemoved;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaRemoved create() => MediaRemoved._();
  @$core.override
  MediaRemoved createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaRemoved getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaRemoved>(create);
  static MediaRemoved? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.String get removedBy => $_getSZ(2);
  @$pb.TagNumber(4)
  set removedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasRemovedBy() => $_has(2);
  @$pb.TagNumber(4)
  void clearRemovedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get removedByUserId => $_getSZ(3);
  @$pb.TagNumber(5)
  set removedByUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasRemovedByUserId() => $_has(3);
  @$pb.TagNumber(5)
  void clearRemovedByUserId() => $_clearField(5);
}

class MediaRemovedBatch extends $pb.GeneratedMessage {
  factory MediaRemovedBatch({
    $core.String? roomId,
    $core.Iterable<$core.String>? mediaIds,
    $core.String? removedBy,
    $core.String? removedByUserId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaIds != null) result.mediaIds.addAll(mediaIds);
    if (removedBy != null) result.removedBy = removedBy;
    if (removedByUserId != null) result.removedByUserId = removedByUserId;
    return result;
  }

  MediaRemovedBatch._();

  factory MediaRemovedBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaRemovedBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaRemovedBatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..pPS(2, _omitFieldNames ? '' : 'mediaIds')
    ..aOS(4, _omitFieldNames ? '' : 'removedBy')
    ..aOS(5, _omitFieldNames ? '' : 'removedByUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRemovedBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRemovedBatch copyWith(void Function(MediaRemovedBatch) updates) =>
      super.copyWith((message) => updates(message as MediaRemovedBatch))
          as MediaRemovedBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaRemovedBatch create() => MediaRemovedBatch._();
  @$core.override
  MediaRemovedBatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaRemovedBatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaRemovedBatch>(create);
  static MediaRemovedBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get mediaIds => $_getList(1);

  @$pb.TagNumber(4)
  $core.String get removedBy => $_getSZ(2);
  @$pb.TagNumber(4)
  set removedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasRemovedBy() => $_has(2);
  @$pb.TagNumber(4)
  void clearRemovedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get removedByUserId => $_getSZ(3);
  @$pb.TagNumber(5)
  set removedByUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasRemovedByUserId() => $_has(3);
  @$pb.TagNumber(5)
  void clearRemovedByUserId() => $_clearField(5);
}

class MediaUpdated extends $pb.GeneratedMessage {
  factory MediaUpdated({
    $core.String? roomId,
    $core.String? mediaId,
    $core.String? name,
    $core.String? updatedBy,
    $core.String? updatedByUserId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    if (name != null) result.name = name;
    if (updatedBy != null) result.updatedBy = updatedBy;
    if (updatedByUserId != null) result.updatedByUserId = updatedByUserId;
    return result;
  }

  MediaUpdated._();

  factory MediaUpdated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaUpdated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaUpdated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'updatedBy')
    ..aOS(5, _omitFieldNames ? '' : 'updatedByUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaUpdated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaUpdated copyWith(void Function(MediaUpdated) updates) =>
      super.copyWith((message) => updates(message as MediaUpdated))
          as MediaUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaUpdated create() => MediaUpdated._();
  @$core.override
  MediaUpdated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaUpdated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaUpdated>(create);
  static MediaUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get updatedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set updatedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdatedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get updatedByUserId => $_getSZ(4);
  @$pb.TagNumber(5)
  set updatedByUserId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUpdatedByUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpdatedByUserId() => $_clearField(5);
}

class PermissionChanged extends $pb.GeneratedMessage {
  factory PermissionChanged({
    $core.String? roomId,
    $core.String? userId,
    $1.RoomMemberRole? role,
    $fixnum.Int64? effectivePermissions,
    $fixnum.Int64? addedPermissions,
    $fixnum.Int64? removedPermissions,
    $fixnum.Int64? adminAddedPermissions,
    $fixnum.Int64? adminRemovedPermissions,
    $core.String? updatedBy,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (role != null) result.role = role;
    if (effectivePermissions != null)
      result.effectivePermissions = effectivePermissions;
    if (addedPermissions != null) result.addedPermissions = addedPermissions;
    if (removedPermissions != null)
      result.removedPermissions = removedPermissions;
    if (adminAddedPermissions != null)
      result.adminAddedPermissions = adminAddedPermissions;
    if (adminRemovedPermissions != null)
      result.adminRemovedPermissions = adminRemovedPermissions;
    if (updatedBy != null) result.updatedBy = updatedBy;
    return result;
  }

  PermissionChanged._();

  factory PermissionChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aE<$1.RoomMemberRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'effectivePermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'addedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'removedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'adminAddedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'adminRemovedPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(9, _omitFieldNames ? '' : 'updatedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionChanged copyWith(void Function(PermissionChanged) updates) =>
      super.copyWith((message) => updates(message as PermissionChanged))
          as PermissionChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionChanged create() => PermissionChanged._();
  @$core.override
  PermissionChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionChanged>(create);
  static PermissionChanged? _defaultInstance;

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
  $1.RoomMemberRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($1.RoomMemberRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  /// All permission fields for full state sync
  @$pb.TagNumber(4)
  $fixnum.Int64 get effectivePermissions => $_getI64(3);
  @$pb.TagNumber(4)
  set effectivePermissions($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEffectivePermissions() => $_has(3);
  @$pb.TagNumber(4)
  void clearEffectivePermissions() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get addedPermissions => $_getI64(4);
  @$pb.TagNumber(5)
  set addedPermissions($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddedPermissions() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddedPermissions() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get removedPermissions => $_getI64(5);
  @$pb.TagNumber(6)
  set removedPermissions($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRemovedPermissions() => $_has(5);
  @$pb.TagNumber(6)
  void clearRemovedPermissions() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get adminAddedPermissions => $_getI64(6);
  @$pb.TagNumber(7)
  set adminAddedPermissions($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAdminAddedPermissions() => $_has(6);
  @$pb.TagNumber(7)
  void clearAdminAddedPermissions() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get adminRemovedPermissions => $_getI64(7);
  @$pb.TagNumber(8)
  set adminRemovedPermissions($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAdminRemovedPermissions() => $_has(7);
  @$pb.TagNumber(8)
  void clearAdminRemovedPermissions() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get updatedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set updatedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedBy() => $_clearField(9);
}

class PlaylistCreated extends $pb.GeneratedMessage {
  factory PlaylistCreated({
    $core.String? roomId,
    Playlist? playlist,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (playlist != null) result.playlist = playlist;
    return result;
  }

  PlaylistCreated._();

  factory PlaylistCreated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistCreated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistCreated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<Playlist>(2, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistCreated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistCreated copyWith(void Function(PlaylistCreated) updates) =>
      super.copyWith((message) => updates(message as PlaylistCreated))
          as PlaylistCreated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistCreated create() => PlaylistCreated._();
  @$core.override
  PlaylistCreated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistCreated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistCreated>(create);
  static PlaylistCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  Playlist get playlist => $_getN(1);
  @$pb.TagNumber(2)
  set playlist(Playlist value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylist() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylist() => $_clearField(2);
  @$pb.TagNumber(2)
  Playlist ensurePlaylist() => $_ensure(1);
}

class PlaylistUpdated extends $pb.GeneratedMessage {
  factory PlaylistUpdated({
    $core.String? roomId,
    Playlist? playlist,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (playlist != null) result.playlist = playlist;
    return result;
  }

  PlaylistUpdated._();

  factory PlaylistUpdated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistUpdated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistUpdated',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<Playlist>(2, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistUpdated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistUpdated copyWith(void Function(PlaylistUpdated) updates) =>
      super.copyWith((message) => updates(message as PlaylistUpdated))
          as PlaylistUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistUpdated create() => PlaylistUpdated._();
  @$core.override
  PlaylistUpdated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistUpdated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistUpdated>(create);
  static PlaylistUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  Playlist get playlist => $_getN(1);
  @$pb.TagNumber(2)
  set playlist(Playlist value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylist() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylist() => $_clearField(2);
  @$pb.TagNumber(2)
  Playlist ensurePlaylist() => $_ensure(1);
}

class PlaylistDeleted extends $pb.GeneratedMessage {
  factory PlaylistDeleted({
    $core.String? roomId,
    $core.String? playlistId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (playlistId != null) result.playlistId = playlistId;
    return result;
  }

  PlaylistDeleted._();

  factory PlaylistDeleted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistDeleted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistDeleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'playlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistDeleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistDeleted copyWith(void Function(PlaylistDeleted) updates) =>
      super.copyWith((message) => updates(message as PlaylistDeleted))
          as PlaylistDeleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistDeleted create() => PlaylistDeleted._();
  @$core.override
  PlaylistDeleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistDeleted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistDeleted>(create);
  static PlaylistDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylistId() => $_clearField(2);
}

class PlaylistReordered extends $pb.GeneratedMessage {
  factory PlaylistReordered({
    $core.String? roomId,
    $core.Iterable<$core.String>? mediaIds,
    $core.String? reorderedBy,
    $core.String? reorderedByUserId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaIds != null) result.mediaIds.addAll(mediaIds);
    if (reorderedBy != null) result.reorderedBy = reorderedBy;
    if (reorderedByUserId != null) result.reorderedByUserId = reorderedByUserId;
    return result;
  }

  PlaylistReordered._();

  factory PlaylistReordered.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistReordered.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistReordered',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..pPS(2, _omitFieldNames ? '' : 'mediaIds')
    ..aOS(3, _omitFieldNames ? '' : 'reorderedBy')
    ..aOS(4, _omitFieldNames ? '' : 'reorderedByUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistReordered clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistReordered copyWith(void Function(PlaylistReordered) updates) =>
      super.copyWith((message) => updates(message as PlaylistReordered))
          as PlaylistReordered;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistReordered create() => PlaylistReordered._();
  @$core.override
  PlaylistReordered createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistReordered getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistReordered>(create);
  static PlaylistReordered? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get mediaIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get reorderedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set reorderedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReorderedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearReorderedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reorderedByUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set reorderedByUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReorderedByUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReorderedByUserId() => $_clearField(4);
}

class PlayingChanged extends $pb.GeneratedMessage {
  factory PlayingChanged({
    $core.String? roomId,
    Playlist? playlist,
    Media? playingMedia,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (playlist != null) result.playlist = playlist;
    if (playingMedia != null) result.playingMedia = playingMedia;
    return result;
  }

  PlayingChanged._();

  factory PlayingChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayingChanged.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayingChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOM<Playlist>(2, _omitFieldNames ? '' : 'playlist',
        subBuilder: Playlist.create)
    ..aOM<Media>(3, _omitFieldNames ? '' : 'playingMedia',
        subBuilder: Media.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayingChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayingChanged copyWith(void Function(PlayingChanged) updates) =>
      super.copyWith((message) => updates(message as PlayingChanged))
          as PlayingChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayingChanged create() => PlayingChanged._();
  @$core.override
  PlayingChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlayingChanged getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayingChanged>(create);
  static PlayingChanged? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  Playlist get playlist => $_getN(1);
  @$pb.TagNumber(2)
  set playlist(Playlist value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylist() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylist() => $_clearField(2);
  @$pb.TagNumber(2)
  Playlist ensurePlaylist() => $_ensure(1);

  @$pb.TagNumber(3)
  Media get playingMedia => $_getN(2);
  @$pb.TagNumber(3)
  set playingMedia(Media value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayingMedia() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayingMedia() => $_clearField(3);
  @$pb.TagNumber(3)
  Media ensurePlayingMedia() => $_ensure(2);
}

/// WebRTC Offer (SDP offer from initiator)
/// Client sends this to another specific peer through the server
class WebRTCOffer extends $pb.GeneratedMessage {
  factory WebRTCOffer({
    $core.String? to,
    $core.String? from,
    $core.String? data,
  }) {
    final result = create();
    if (to != null) result.to = to;
    if (from != null) result.from = from;
    if (data != null) result.data = data;
    return result;
  }

  WebRTCOffer._();

  factory WebRTCOffer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCOffer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCOffer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'to')
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aOS(3, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCOffer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCOffer copyWith(void Function(WebRTCOffer) updates) =>
      super.copyWith((message) => updates(message as WebRTCOffer))
          as WebRTCOffer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCOffer create() => WebRTCOffer._();
  @$core.override
  WebRTCOffer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCOffer>(create);
  static WebRTCOffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get to => $_getSZ(0);
  @$pb.TagNumber(1)
  set to($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTo() => $_has(0);
  @$pb.TagNumber(1)
  void clearTo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get data => $_getSZ(2);
  @$pb.TagNumber(3)
  set data($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
}

/// WebRTC Answer (SDP answer from receiver)
/// Response to an offer
class WebRTCAnswer extends $pb.GeneratedMessage {
  factory WebRTCAnswer({
    $core.String? to,
    $core.String? from,
    $core.String? data,
  }) {
    final result = create();
    if (to != null) result.to = to;
    if (from != null) result.from = from;
    if (data != null) result.data = data;
    return result;
  }

  WebRTCAnswer._();

  factory WebRTCAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCAnswer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'to')
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aOS(3, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCAnswer copyWith(void Function(WebRTCAnswer) updates) =>
      super.copyWith((message) => updates(message as WebRTCAnswer))
          as WebRTCAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCAnswer create() => WebRTCAnswer._();
  @$core.override
  WebRTCAnswer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCAnswer>(create);
  static WebRTCAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get to => $_getSZ(0);
  @$pb.TagNumber(1)
  set to($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTo() => $_has(0);
  @$pb.TagNumber(1)
  void clearTo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get data => $_getSZ(2);
  @$pb.TagNumber(3)
  set data($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
}

/// WebRTC ICE Candidate
/// Sent repeatedly during ICE negotiation
class WebRTCIceCandidate extends $pb.GeneratedMessage {
  factory WebRTCIceCandidate({
    $core.String? to,
    $core.String? from,
    $core.String? data,
  }) {
    final result = create();
    if (to != null) result.to = to;
    if (from != null) result.from = from;
    if (data != null) result.data = data;
    return result;
  }

  WebRTCIceCandidate._();

  factory WebRTCIceCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCIceCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCIceCandidate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'to')
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aOS(3, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCIceCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCIceCandidate copyWith(void Function(WebRTCIceCandidate) updates) =>
      super.copyWith((message) => updates(message as WebRTCIceCandidate))
          as WebRTCIceCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCIceCandidate create() => WebRTCIceCandidate._();
  @$core.override
  WebRTCIceCandidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCIceCandidate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCIceCandidate>(create);
  static WebRTCIceCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get to => $_getSZ(0);
  @$pb.TagNumber(1)
  set to($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTo() => $_has(0);
  @$pb.TagNumber(1)
  void clearTo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get data => $_getSZ(2);
  @$pb.TagNumber(3)
  set data($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => $_clearField(3);
}

/// WebRTC Join (user joins WebRTC session)
/// Broadcast to all users who already joined RTC in the room
class WebRTCJoin extends $pb.GeneratedMessage {
  factory WebRTCJoin({
    $core.String? userId,
    $core.String? connId,
    $core.String? username,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (connId != null) result.connId = connId;
    if (username != null) result.username = username;
    return result;
  }

  WebRTCJoin._();

  factory WebRTCJoin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCJoin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCJoin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'connId')
    ..aOS(3, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCJoin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCJoin copyWith(void Function(WebRTCJoin) updates) =>
      super.copyWith((message) => updates(message as WebRTCJoin)) as WebRTCJoin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCJoin create() => WebRTCJoin._();
  @$core.override
  WebRTCJoin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCJoin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCJoin>(create);
  static WebRTCJoin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get connId => $_getSZ(1);
  @$pb.TagNumber(2)
  set connId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);
}

/// WebRTC Leave (user leaves WebRTC session)
/// Broadcast to all users in the WebRTC session
class WebRTCLeave extends $pb.GeneratedMessage {
  factory WebRTCLeave({
    $core.String? userId,
    $core.String? connId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (connId != null) result.connId = connId;
    return result;
  }

  WebRTCLeave._();

  factory WebRTCLeave.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCLeave.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCLeave',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'connId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCLeave clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCLeave copyWith(void Function(WebRTCLeave) updates) =>
      super.copyWith((message) => updates(message as WebRTCLeave))
          as WebRTCLeave;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCLeave create() => WebRTCLeave._();
  @$core.override
  WebRTCLeave createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCLeave getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCLeave>(create);
  static WebRTCLeave? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get connId => $_getSZ(1);
  @$pb.TagNumber(2)
  set connId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnId() => $_clearField(2);
}

/// ICE Servers Configuration
/// Server sends this to client upon request or connection
/// Contains ICE server URLs for NAT traversal
class IceServersConfig extends $pb.GeneratedMessage {
  factory IceServersConfig({
    $core.Iterable<IceServer>? servers,
  }) {
    final result = create();
    if (servers != null) result.servers.addAll(servers);
    return result;
  }

  IceServersConfig._();

  factory IceServersConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IceServersConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IceServersConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<IceServer>(1, _omitFieldNames ? '' : 'servers',
        subBuilder: IceServer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceServersConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceServersConfig copyWith(void Function(IceServersConfig) updates) =>
      super.copyWith((message) => updates(message as IceServersConfig))
          as IceServersConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IceServersConfig create() => IceServersConfig._();
  @$core.override
  IceServersConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IceServersConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IceServersConfig>(create);
  static IceServersConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IceServer> get servers => $_getList(0);
}

class IceServer extends $pb.GeneratedMessage {
  factory IceServer({
    $core.Iterable<$core.String>? urls,
    $core.String? username,
    $core.String? credential,
  }) {
    final result = create();
    if (urls != null) result.urls.addAll(urls);
    if (username != null) result.username = username;
    if (credential != null) result.credential = credential;
    return result;
  }

  IceServer._();

  factory IceServer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IceServer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IceServer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'urls')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'credential')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceServer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceServer copyWith(void Function(IceServer) updates) =>
      super.copyWith((message) => updates(message as IceServer)) as IceServer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IceServer create() => IceServer._();
  @$core.override
  IceServer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IceServer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IceServer>(create);
  static IceServer? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get urls => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get credential => $_getSZ(2);
  @$pb.TagNumber(3)
  set credential($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredential() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredential() => $_clearField(3);
}

/// Request/Response for GetIceServers RPC
class GetIceServersRequest extends $pb.GeneratedMessage {
  factory GetIceServersRequest() => create();

  GetIceServersRequest._();

  factory GetIceServersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIceServersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIceServersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIceServersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIceServersRequest copyWith(void Function(GetIceServersRequest) updates) =>
      super.copyWith((message) => updates(message as GetIceServersRequest))
          as GetIceServersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIceServersRequest create() => GetIceServersRequest._();
  @$core.override
  GetIceServersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIceServersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIceServersRequest>(create);
  static GetIceServersRequest? _defaultInstance;
}

class GetIceServersResponse extends $pb.GeneratedMessage {
  factory GetIceServersResponse({
    $core.Iterable<IceServer>? servers,
    WebRtcStatus? webrtc,
  }) {
    final result = create();
    if (servers != null) result.servers.addAll(servers);
    if (webrtc != null) result.webrtc = webrtc;
    return result;
  }

  GetIceServersResponse._();

  factory GetIceServersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIceServersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIceServersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<IceServer>(1, _omitFieldNames ? '' : 'servers',
        subBuilder: IceServer.create)
    ..aOM<WebRtcStatus>(2, _omitFieldNames ? '' : 'webrtc',
        subBuilder: WebRtcStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIceServersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIceServersResponse copyWith(
          void Function(GetIceServersResponse) updates) =>
      super.copyWith((message) => updates(message as GetIceServersResponse))
          as GetIceServersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIceServersResponse create() => GetIceServersResponse._();
  @$core.override
  GetIceServersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIceServersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIceServersResponse>(create);
  static GetIceServersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IceServer> get servers => $_getList(0);

  @$pb.TagNumber(2)
  WebRtcStatus get webrtc => $_getN(1);
  @$pb.TagNumber(2)
  set webrtc(WebRtcStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWebrtc() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebrtc() => $_clearField(2);
  @$pb.TagNumber(2)
  WebRtcStatus ensureWebrtc() => $_ensure(1);
}

class MemoryHealth extends $pb.GeneratedMessage {
  factory MemoryHealth({
    $core.double? usagePercent,
    $core.String? status,
  }) {
    final result = create();
    if (usagePercent != null) result.usagePercent = usagePercent;
    if (status != null) result.status = status;
    return result;
  }

  MemoryHealth._();

  factory MemoryHealth.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemoryHealth.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemoryHealth',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'usagePercent')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemoryHealth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemoryHealth copyWith(void Function(MemoryHealth) updates) =>
      super.copyWith((message) => updates(message as MemoryHealth))
          as MemoryHealth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemoryHealth create() => MemoryHealth._();
  @$core.override
  MemoryHealth createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemoryHealth getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemoryHealth>(create);
  static MemoryHealth? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get usagePercent => $_getN(0);
  @$pb.TagNumber(1)
  set usagePercent($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsagePercent() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsagePercent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class WebRtcStatus extends $pb.GeneratedMessage {
  factory WebRtcStatus({
    $core.String? mode,
    $core.String? builtinStunState,
    $core.bool? builtinStunConfigured,
    $core.String? reason,
    $core.String? localAddr,
    $core.String? externalAddr,
    $core.String? message,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    if (builtinStunState != null) result.builtinStunState = builtinStunState;
    if (builtinStunConfigured != null)
      result.builtinStunConfigured = builtinStunConfigured;
    if (reason != null) result.reason = reason;
    if (localAddr != null) result.localAddr = localAddr;
    if (externalAddr != null) result.externalAddr = externalAddr;
    if (message != null) result.message = message;
    return result;
  }

  WebRtcStatus._();

  factory WebRtcStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRtcStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRtcStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mode')
    ..aOS(2, _omitFieldNames ? '' : 'builtinStunState')
    ..aOB(3, _omitFieldNames ? '' : 'builtinStunConfigured')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'localAddr')
    ..aOS(6, _omitFieldNames ? '' : 'externalAddr')
    ..aOS(7, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRtcStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRtcStatus copyWith(void Function(WebRtcStatus) updates) =>
      super.copyWith((message) => updates(message as WebRtcStatus))
          as WebRtcStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRtcStatus create() => WebRtcStatus._();
  @$core.override
  WebRtcStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRtcStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRtcStatus>(create);
  static WebRtcStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mode => $_getSZ(0);
  @$pb.TagNumber(1)
  set mode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get builtinStunState => $_getSZ(1);
  @$pb.TagNumber(2)
  set builtinStunState($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBuiltinStunState() => $_has(1);
  @$pb.TagNumber(2)
  void clearBuiltinStunState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get builtinStunConfigured => $_getBF(2);
  @$pb.TagNumber(3)
  set builtinStunConfigured($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBuiltinStunConfigured() => $_has(2);
  @$pb.TagNumber(3)
  void clearBuiltinStunConfigured() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get localAddr => $_getSZ(4);
  @$pb.TagNumber(5)
  set localAddr($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocalAddr() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocalAddr() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get externalAddr => $_getSZ(5);
  @$pb.TagNumber(6)
  set externalAddr($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExternalAddr() => $_has(5);
  @$pb.TagNumber(6)
  void clearExternalAddr() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => $_clearField(7);
}

class HealthDetails extends $pb.GeneratedMessage {
  factory HealthDetails({
    $core.String? database,
    $core.String? redis,
    $core.String? cluster,
    $core.String? wsTicket,
    $core.String? email,
    $core.String? livestream,
    MemoryHealth? memory,
    $core.String? message,
    WebRtcStatus? webrtc,
  }) {
    final result = create();
    if (database != null) result.database = database;
    if (redis != null) result.redis = redis;
    if (cluster != null) result.cluster = cluster;
    if (wsTicket != null) result.wsTicket = wsTicket;
    if (email != null) result.email = email;
    if (livestream != null) result.livestream = livestream;
    if (memory != null) result.memory = memory;
    if (message != null) result.message = message;
    if (webrtc != null) result.webrtc = webrtc;
    return result;
  }

  HealthDetails._();

  factory HealthDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'database')
    ..aOS(2, _omitFieldNames ? '' : 'redis')
    ..aOS(3, _omitFieldNames ? '' : 'cluster')
    ..aOS(4, _omitFieldNames ? '' : 'wsTicket')
    ..aOS(5, _omitFieldNames ? '' : 'email')
    ..aOS(6, _omitFieldNames ? '' : 'livestream')
    ..aOM<MemoryHealth>(7, _omitFieldNames ? '' : 'memory',
        subBuilder: MemoryHealth.create)
    ..aOS(8, _omitFieldNames ? '' : 'message')
    ..aOM<WebRtcStatus>(9, _omitFieldNames ? '' : 'webrtc',
        subBuilder: WebRtcStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthDetails copyWith(void Function(HealthDetails) updates) =>
      super.copyWith((message) => updates(message as HealthDetails))
          as HealthDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthDetails create() => HealthDetails._();
  @$core.override
  HealthDetails createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HealthDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthDetails>(create);
  static HealthDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get database => $_getSZ(0);
  @$pb.TagNumber(1)
  set database($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDatabase() => $_has(0);
  @$pb.TagNumber(1)
  void clearDatabase() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get redis => $_getSZ(1);
  @$pb.TagNumber(2)
  set redis($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRedis() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedis() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cluster => $_getSZ(2);
  @$pb.TagNumber(3)
  set cluster($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCluster() => $_has(2);
  @$pb.TagNumber(3)
  void clearCluster() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get wsTicket => $_getSZ(3);
  @$pb.TagNumber(4)
  set wsTicket($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWsTicket() => $_has(3);
  @$pb.TagNumber(4)
  void clearWsTicket() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get email => $_getSZ(4);
  @$pb.TagNumber(5)
  set email($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearEmail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get livestream => $_getSZ(5);
  @$pb.TagNumber(6)
  set livestream($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLivestream() => $_has(5);
  @$pb.TagNumber(6)
  void clearLivestream() => $_clearField(6);

  @$pb.TagNumber(7)
  MemoryHealth get memory => $_getN(6);
  @$pb.TagNumber(7)
  set memory(MemoryHealth value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMemory() => $_has(6);
  @$pb.TagNumber(7)
  void clearMemory() => $_clearField(7);
  @$pb.TagNumber(7)
  MemoryHealth ensureMemory() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get message => $_getSZ(7);
  @$pb.TagNumber(8)
  set message($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  WebRtcStatus get webrtc => $_getN(8);
  @$pb.TagNumber(9)
  set webrtc(WebRtcStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasWebrtc() => $_has(8);
  @$pb.TagNumber(9)
  void clearWebrtc() => $_clearField(9);
  @$pb.TagNumber(9)
  WebRtcStatus ensureWebrtc() => $_ensure(8);
}

class HealthResponse extends $pb.GeneratedMessage {
  factory HealthResponse({
    $core.String? status,
    HealthDetails? details,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (details != null) result.details = details;
    return result;
  }

  HealthResponse._();

  factory HealthResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HealthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'status')
    ..aOM<HealthDetails>(2, _omitFieldNames ? '' : 'details',
        subBuilder: HealthDetails.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthResponse copyWith(void Function(HealthResponse) updates) =>
      super.copyWith((message) => updates(message as HealthResponse))
          as HealthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HealthResponse create() => HealthResponse._();
  @$core.override
  HealthResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HealthResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthResponse>(create);
  static HealthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  HealthDetails get details => $_getN(1);
  @$pb.TagNumber(2)
  set details(HealthDetails value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetails() => $_clearField(2);
  @$pb.TagNumber(2)
  HealthDetails ensureDetails() => $_ensure(1);
}

class NotificationProto extends $pb.GeneratedMessage {
  factory NotificationProto({
    $core.String? id,
    $core.String? userId,
    NotificationType? notificationType,
    $core.String? title,
    $core.String? content,
    $core.List<$core.int>? data,
    $core.bool? isRead,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (notificationType != null) result.notificationType = notificationType;
    if (title != null) result.title = title;
    if (content != null) result.content = content;
    if (data != null) result.data = data;
    if (isRead != null) result.isRead = isRead;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  NotificationProto._();

  factory NotificationProto.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationProto.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationProto',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aE<NotificationType>(3, _omitFieldNames ? '' : 'notificationType',
        enumValues: NotificationType.values)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aOB(7, _omitFieldNames ? '' : 'isRead')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(9, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationProto clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationProto copyWith(void Function(NotificationProto) updates) =>
      super.copyWith((message) => updates(message as NotificationProto))
          as NotificationProto;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationProto create() => NotificationProto._();
  @$core.override
  NotificationProto createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotificationProto getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationProto>(create);
  static NotificationProto? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  NotificationType get notificationType => $_getN(2);
  @$pb.TagNumber(3)
  set notificationType(NotificationType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNotificationType() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotificationType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get data => $_getN(5);
  @$pb.TagNumber(6)
  set data($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasData() => $_has(5);
  @$pb.TagNumber(6)
  void clearData() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isRead => $_getBF(6);
  @$pb.TagNumber(7)
  set isRead($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsRead() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsRead() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAt => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get updatedAt => $_getI64(8);
  @$pb.TagNumber(9)
  set updatedAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
}

class ListNotificationsRequest extends $pb.GeneratedMessage {
  factory ListNotificationsRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.bool? isRead,
    NotificationType? notificationType,
    $core.String? search,
    NotificationListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (isRead != null) result.isRead = isRead;
    if (notificationType != null) result.notificationType = notificationType;
    if (search != null) result.search = search;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListNotificationsRequest._();

  factory ListNotificationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNotificationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotificationsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOB(3, _omitFieldNames ? '' : 'isRead')
    ..aE<NotificationType>(4, _omitFieldNames ? '' : 'notificationType',
        enumValues: NotificationType.values)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aE<NotificationListSortBy>(6, _omitFieldNames ? '' : 'sortBy',
        enumValues: NotificationListSortBy.values)
    ..aE<SortDirection>(7, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsRequest copyWith(
          void Function(ListNotificationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListNotificationsRequest))
          as ListNotificationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNotificationsRequest create() => ListNotificationsRequest._();
  @$core.override
  ListNotificationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNotificationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotificationsRequest>(create);
  static ListNotificationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isRead => $_getBF(2);
  @$pb.TagNumber(3)
  set isRead($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsRead() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsRead() => $_clearField(3);

  @$pb.TagNumber(4)
  NotificationType get notificationType => $_getN(3);
  @$pb.TagNumber(4)
  set notificationType(NotificationType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNotificationType() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotificationType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get search => $_getSZ(4);
  @$pb.TagNumber(5)
  set search($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearch() => $_clearField(5);

  @$pb.TagNumber(6)
  NotificationListSortBy get sortBy => $_getN(5);
  @$pb.TagNumber(6)
  set sortBy(NotificationListSortBy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSortBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearSortBy() => $_clearField(6);

  @$pb.TagNumber(7)
  SortDirection get sortDirection => $_getN(6);
  @$pb.TagNumber(7)
  set sortDirection(SortDirection value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortDirection() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortDirection() => $_clearField(7);
}

class ListNotificationsResponse extends $pb.GeneratedMessage {
  factory ListNotificationsResponse({
    $core.Iterable<NotificationProto>? notifications,
    $core.int? total,
    $core.int? unreadCount,
  }) {
    final result = create();
    if (notifications != null) result.notifications.addAll(notifications);
    if (total != null) result.total = total;
    if (unreadCount != null) result.unreadCount = unreadCount;
    return result;
  }

  ListNotificationsResponse._();

  factory ListNotificationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNotificationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotificationsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<NotificationProto>(1, _omitFieldNames ? '' : 'notifications',
        subBuilder: NotificationProto.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..aI(3, _omitFieldNames ? '' : 'unreadCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsResponse copyWith(
          void Function(ListNotificationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListNotificationsResponse))
          as ListNotificationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNotificationsResponse create() => ListNotificationsResponse._();
  @$core.override
  ListNotificationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNotificationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotificationsResponse>(create);
  static ListNotificationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NotificationProto> get notifications => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unreadCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadCount() => $_clearField(3);
}

class GetNotificationRequest extends $pb.GeneratedMessage {
  factory GetNotificationRequest({
    $fixnum.Int64? notificationId,
  }) {
    final result = create();
    if (notificationId != null) result.notificationId = notificationId;
    return result;
  }

  GetNotificationRequest._();

  factory GetNotificationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetNotificationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNotificationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'notificationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNotificationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNotificationRequest copyWith(
          void Function(GetNotificationRequest) updates) =>
      super.copyWith((message) => updates(message as GetNotificationRequest))
          as GetNotificationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNotificationRequest create() => GetNotificationRequest._();
  @$core.override
  GetNotificationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetNotificationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNotificationRequest>(create);
  static GetNotificationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get notificationId => $_getI64(0);
  @$pb.TagNumber(1)
  set notificationId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);
}

class GetNotificationResponse extends $pb.GeneratedMessage {
  factory GetNotificationResponse({
    NotificationProto? notification,
  }) {
    final result = create();
    if (notification != null) result.notification = notification;
    return result;
  }

  GetNotificationResponse._();

  factory GetNotificationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetNotificationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNotificationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<NotificationProto>(1, _omitFieldNames ? '' : 'notification',
        subBuilder: NotificationProto.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNotificationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNotificationResponse copyWith(
          void Function(GetNotificationResponse) updates) =>
      super.copyWith((message) => updates(message as GetNotificationResponse))
          as GetNotificationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNotificationResponse create() => GetNotificationResponse._();
  @$core.override
  GetNotificationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetNotificationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNotificationResponse>(create);
  static GetNotificationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NotificationProto get notification => $_getN(0);
  @$pb.TagNumber(1)
  set notification(NotificationProto value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotification() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotification() => $_clearField(1);
  @$pb.TagNumber(1)
  NotificationProto ensureNotification() => $_ensure(0);
}

class MarkAsReadRequest extends $pb.GeneratedMessage {
  factory MarkAsReadRequest({
    $core.Iterable<$fixnum.Int64>? notificationIds,
  }) {
    final result = create();
    if (notificationIds != null) result.notificationIds.addAll(notificationIds);
    return result;
  }

  MarkAsReadRequest._();

  factory MarkAsReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkAsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAsReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'notificationIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadRequest copyWith(void Function(MarkAsReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkAsReadRequest))
          as MarkAsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkAsReadRequest create() => MarkAsReadRequest._();
  @$core.override
  MarkAsReadRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkAsReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAsReadRequest>(create);
  static MarkAsReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get notificationIds => $_getList(0);
}

class MarkAsReadResponse extends $pb.GeneratedMessage {
  factory MarkAsReadResponse() => create();

  MarkAsReadResponse._();

  factory MarkAsReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkAsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAsReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadResponse copyWith(void Function(MarkAsReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkAsReadResponse))
          as MarkAsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkAsReadResponse create() => MarkAsReadResponse._();
  @$core.override
  MarkAsReadResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkAsReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAsReadResponse>(create);
  static MarkAsReadResponse? _defaultInstance;
}

class MarkAllAsReadRequest extends $pb.GeneratedMessage {
  factory MarkAllAsReadRequest({
    $fixnum.Int64? before,
  }) {
    final result = create();
    if (before != null) result.before = before;
    return result;
  }

  MarkAllAsReadRequest._();

  factory MarkAllAsReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkAllAsReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAllAsReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'before')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadRequest copyWith(void Function(MarkAllAsReadRequest) updates) =>
      super.copyWith((message) => updates(message as MarkAllAsReadRequest))
          as MarkAllAsReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkAllAsReadRequest create() => MarkAllAsReadRequest._();
  @$core.override
  MarkAllAsReadRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkAllAsReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAllAsReadRequest>(create);
  static MarkAllAsReadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get before => $_getI64(0);
  @$pb.TagNumber(1)
  set before($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBefore() => $_has(0);
  @$pb.TagNumber(1)
  void clearBefore() => $_clearField(1);
}

class MarkAllAsReadResponse extends $pb.GeneratedMessage {
  factory MarkAllAsReadResponse() => create();

  MarkAllAsReadResponse._();

  factory MarkAllAsReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkAllAsReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAllAsReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAllAsReadResponse copyWith(
          void Function(MarkAllAsReadResponse) updates) =>
      super.copyWith((message) => updates(message as MarkAllAsReadResponse))
          as MarkAllAsReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkAllAsReadResponse create() => MarkAllAsReadResponse._();
  @$core.override
  MarkAllAsReadResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkAllAsReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAllAsReadResponse>(create);
  static MarkAllAsReadResponse? _defaultInstance;
}

class ApiErrorResponse extends $pb.GeneratedMessage {
  factory ApiErrorResponse({
    $core.String? error,
    $core.int? status,
    $core.int? code,
    $core.String? requestId,
  }) {
    final result = create();
    if (error != null) result.error = error;
    if (status != null) result.status = status;
    if (code != null) result.code = code;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  ApiErrorResponse._();

  factory ApiErrorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApiErrorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApiErrorResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..aI(2, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApiErrorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApiErrorResponse copyWith(void Function(ApiErrorResponse) updates) =>
      super.copyWith((message) => updates(message as ApiErrorResponse))
          as ApiErrorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApiErrorResponse create() => ApiErrorResponse._();
  @$core.override
  ApiErrorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApiErrorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApiErrorResponse>(create);
  static ApiErrorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get code => $_getIZ(2);
  @$pb.TagNumber(3)
  set code($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get requestId => $_getSZ(3);
  @$pb.TagNumber(4)
  set requestId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequestId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequestId() => $_clearField(4);
}

class DeleteNotificationRequest extends $pb.GeneratedMessage {
  factory DeleteNotificationRequest({
    $fixnum.Int64? notificationId,
  }) {
    final result = create();
    if (notificationId != null) result.notificationId = notificationId;
    return result;
  }

  DeleteNotificationRequest._();

  factory DeleteNotificationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteNotificationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNotificationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'notificationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationRequest copyWith(
          void Function(DeleteNotificationRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteNotificationRequest))
          as DeleteNotificationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteNotificationRequest create() => DeleteNotificationRequest._();
  @$core.override
  DeleteNotificationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteNotificationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNotificationRequest>(create);
  static DeleteNotificationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get notificationId => $_getI64(0);
  @$pb.TagNumber(1)
  set notificationId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);
}

class DeleteNotificationResponse extends $pb.GeneratedMessage {
  factory DeleteNotificationResponse() => create();

  DeleteNotificationResponse._();

  factory DeleteNotificationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteNotificationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteNotificationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteNotificationResponse copyWith(
          void Function(DeleteNotificationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteNotificationResponse))
          as DeleteNotificationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteNotificationResponse create() => DeleteNotificationResponse._();
  @$core.override
  DeleteNotificationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteNotificationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteNotificationResponse>(create);
  static DeleteNotificationResponse? _defaultInstance;
}

class DeleteAllReadRequest extends $pb.GeneratedMessage {
  factory DeleteAllReadRequest() => create();

  DeleteAllReadRequest._();

  factory DeleteAllReadRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAllReadRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAllReadRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAllReadRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAllReadRequest copyWith(void Function(DeleteAllReadRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteAllReadRequest))
          as DeleteAllReadRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAllReadRequest create() => DeleteAllReadRequest._();
  @$core.override
  DeleteAllReadRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteAllReadRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAllReadRequest>(create);
  static DeleteAllReadRequest? _defaultInstance;
}

class DeleteAllReadResponse extends $pb.GeneratedMessage {
  factory DeleteAllReadResponse() => create();

  DeleteAllReadResponse._();

  factory DeleteAllReadResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAllReadResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAllReadResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAllReadResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAllReadResponse copyWith(
          void Function(DeleteAllReadResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteAllReadResponse))
          as DeleteAllReadResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAllReadResponse create() => DeleteAllReadResponse._();
  @$core.override
  DeleteAllReadResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteAllReadResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAllReadResponse>(create);
  static DeleteAllReadResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
