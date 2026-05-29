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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'admin.pbenum.dart';
import 'client.pb.dart' as $0;
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'admin.pbenum.dart';

class AdminUser extends $pb.GeneratedMessage {
  factory AdminUser({
    $core.String? id,
    $core.String? username,
    $core.String? email,
    $1.UserRole? role,
    $1.UserStatus? status,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $core.bool? isBanned,
    $fixnum.Int64? bannedAt,
    $core.String? bannedBy,
    $core.String? bannedReason,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (role != null) result.role = role;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (isBanned != null) result.isBanned = isBanned;
    if (bannedAt != null) result.bannedAt = bannedAt;
    if (bannedBy != null) result.bannedBy = bannedBy;
    if (bannedReason != null) result.bannedReason = bannedReason;
    return result;
  }

  AdminUser._();

  factory AdminUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdminUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdminUser',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aE<$1.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $1.UserRole.values)
    ..aE<$1.UserStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.UserStatus.values)
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(7, _omitFieldNames ? '' : 'updatedAt')
    ..aOB(8, _omitFieldNames ? '' : 'isBanned')
    ..aInt64(9, _omitFieldNames ? '' : 'bannedAt')
    ..aOS(10, _omitFieldNames ? '' : 'bannedBy')
    ..aOS(11, _omitFieldNames ? '' : 'bannedReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminUser copyWith(void Function(AdminUser) updates) =>
      super.copyWith((message) => updates(message as AdminUser)) as AdminUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdminUser create() => AdminUser._();
  @$core.override
  AdminUser createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdminUser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AdminUser>(create);
  static AdminUser? _defaultInstance;

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
  $fixnum.Int64 get updatedAt => $_getI64(6);
  @$pb.TagNumber(7)
  set updatedAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isBanned => $_getBF(7);
  @$pb.TagNumber(8)
  set isBanned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsBanned() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsBanned() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get bannedAt => $_getI64(8);
  @$pb.TagNumber(9)
  set bannedAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBannedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearBannedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get bannedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set bannedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBannedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearBannedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get bannedReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set bannedReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBannedReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearBannedReason() => $_clearField(11);
}

class AdminRoom extends $pb.GeneratedMessage {
  factory AdminRoom({
    $core.String? id,
    $core.String? name,
    $core.String? creatorId,
    $core.String? creatorUsername,
    $1.RoomStatus? status,
    $core.List<$core.int>? settings,
    $core.int? memberCount,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $core.String? description,
    $core.bool? isBanned,
    $1.UserStatus? creatorStatus,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (creatorId != null) result.creatorId = creatorId;
    if (creatorUsername != null) result.creatorUsername = creatorUsername;
    if (status != null) result.status = status;
    if (settings != null) result.settings = settings;
    if (memberCount != null) result.memberCount = memberCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (description != null) result.description = description;
    if (isBanned != null) result.isBanned = isBanned;
    if (creatorStatus != null) result.creatorStatus = creatorStatus;
    if (version != null) result.version = version;
    return result;
  }

  AdminRoom._();

  factory AdminRoom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdminRoom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdminRoom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'creatorId')
    ..aOS(4, _omitFieldNames ? '' : 'creatorUsername')
    ..aE<$1.RoomStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.RoomStatus.values)
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..aI(7, _omitFieldNames ? '' : 'memberCount')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(9, _omitFieldNames ? '' : 'updatedAt')
    ..aOS(10, _omitFieldNames ? '' : 'description')
    ..aOB(11, _omitFieldNames ? '' : 'isBanned')
    ..aE<$1.UserStatus>(12, _omitFieldNames ? '' : 'creatorStatus',
        enumValues: $1.UserStatus.values)
    ..aInt64(13, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminRoom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminRoom copyWith(void Function(AdminRoom) updates) =>
      super.copyWith((message) => updates(message as AdminRoom)) as AdminRoom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdminRoom create() => AdminRoom._();
  @$core.override
  AdminRoom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdminRoom getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AdminRoom>(create);
  static AdminRoom? _defaultInstance;

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
  $core.String get creatorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set creatorId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatorId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creatorUsername => $_getSZ(3);
  @$pb.TagNumber(4)
  set creatorUsername($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatorUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatorUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.RoomStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($1.RoomStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get settings => $_getN(5);
  @$pb.TagNumber(6)
  set settings($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSettings() => $_has(5);
  @$pb.TagNumber(6)
  void clearSettings() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get memberCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set memberCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMemberCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMemberCount() => $_clearField(7);

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
  $core.String get description => $_getSZ(9);
  @$pb.TagNumber(10)
  set description($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDescription() => $_has(9);
  @$pb.TagNumber(10)
  void clearDescription() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isBanned => $_getBF(10);
  @$pb.TagNumber(11)
  set isBanned($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsBanned() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsBanned() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.UserStatus get creatorStatus => $_getN(11);
  @$pb.TagNumber(12)
  set creatorStatus($1.UserStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatorStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatorStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get version => $_getI64(12);
  @$pb.TagNumber(13)
  set version($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVersion() => $_has(12);
  @$pb.TagNumber(13)
  void clearVersion() => $_clearField(13);
}

class SettingsGroup extends $pb.GeneratedMessage {
  factory SettingsGroup({
    $core.String? name,
    $core.List<$core.int>? settings,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (settings != null) result.settings = settings;
    return result;
  }

  SettingsGroup._();

  factory SettingsGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SettingsGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettingsGroup',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingsGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingsGroup copyWith(void Function(SettingsGroup) updates) =>
      super.copyWith((message) => updates(message as SettingsGroup))
          as SettingsGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SettingsGroup create() => SettingsGroup._();
  @$core.override
  SettingsGroup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SettingsGroup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettingsGroup>(create);
  static SettingsGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => $_clearField(2);
}

class UserRegistrationReview extends $pb.GeneratedMessage {
  factory UserRegistrationReview({
    $core.String? id,
    $core.String? username,
    $core.String? email,
    $core.int? signupMethod,
    $1.ReviewStatus? status,
    $fixnum.Int64? requestedAt,
    $fixnum.Int64? reviewedAt,
    $core.String? reviewedBy,
    $core.String? rejectionReason,
    $core.String? oauth2Provider,
    $core.String? oauth2ProviderUserId,
    $core.String? oauth2ProviderUsername,
    $core.String? oauth2AvatarUrl,
    $core.bool? oauth2EmailVerified,
    $core.String? oauth2ProviderInstanceName,
    $core.String? oauth2ProviderIssuer,
    $core.String? webauthnCredentialId,
    $core.String? webauthnCredentialName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (signupMethod != null) result.signupMethod = signupMethod;
    if (status != null) result.status = status;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    if (oauth2Provider != null) result.oauth2Provider = oauth2Provider;
    if (oauth2ProviderUserId != null)
      result.oauth2ProviderUserId = oauth2ProviderUserId;
    if (oauth2ProviderUsername != null)
      result.oauth2ProviderUsername = oauth2ProviderUsername;
    if (oauth2AvatarUrl != null) result.oauth2AvatarUrl = oauth2AvatarUrl;
    if (oauth2EmailVerified != null)
      result.oauth2EmailVerified = oauth2EmailVerified;
    if (oauth2ProviderInstanceName != null)
      result.oauth2ProviderInstanceName = oauth2ProviderInstanceName;
    if (oauth2ProviderIssuer != null)
      result.oauth2ProviderIssuer = oauth2ProviderIssuer;
    if (webauthnCredentialId != null)
      result.webauthnCredentialId = webauthnCredentialId;
    if (webauthnCredentialName != null)
      result.webauthnCredentialName = webauthnCredentialName;
    return result;
  }

  UserRegistrationReview._();

  factory UserRegistrationReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserRegistrationReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserRegistrationReview',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aI(4, _omitFieldNames ? '' : 'signupMethod')
    ..aE<$1.ReviewStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aInt64(6, _omitFieldNames ? '' : 'requestedAt')
    ..aInt64(7, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(8, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(9, _omitFieldNames ? '' : 'rejectionReason')
    ..aOS(10, _omitFieldNames ? '' : 'oauth2Provider')
    ..aOS(11, _omitFieldNames ? '' : 'oauth2ProviderUserId')
    ..aOS(12, _omitFieldNames ? '' : 'oauth2ProviderUsername')
    ..aOS(13, _omitFieldNames ? '' : 'oauth2AvatarUrl')
    ..aOB(14, _omitFieldNames ? '' : 'oauth2EmailVerified')
    ..aOS(15, _omitFieldNames ? '' : 'oauth2ProviderInstanceName')
    ..aOS(16, _omitFieldNames ? '' : 'oauth2ProviderIssuer')
    ..aOS(17, _omitFieldNames ? '' : 'webauthnCredentialId')
    ..aOS(18, _omitFieldNames ? '' : 'webauthnCredentialName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserRegistrationReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserRegistrationReview copyWith(
          void Function(UserRegistrationReview) updates) =>
      super.copyWith((message) => updates(message as UserRegistrationReview))
          as UserRegistrationReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserRegistrationReview create() => UserRegistrationReview._();
  @$core.override
  UserRegistrationReview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserRegistrationReview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserRegistrationReview>(create);
  static UserRegistrationReview? _defaultInstance;

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
  $core.int get signupMethod => $_getIZ(3);
  @$pb.TagNumber(4)
  set signupMethod($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSignupMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignupMethod() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.ReviewStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($1.ReviewStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get requestedAt => $_getI64(5);
  @$pb.TagNumber(6)
  set requestedAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get reviewedAt => $_getI64(6);
  @$pb.TagNumber(7)
  set reviewedAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get reviewedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set reviewedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get rejectionReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set rejectionReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRejectionReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRejectionReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get oauth2Provider => $_getSZ(9);
  @$pb.TagNumber(10)
  set oauth2Provider($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOauth2Provider() => $_has(9);
  @$pb.TagNumber(10)
  void clearOauth2Provider() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get oauth2ProviderUserId => $_getSZ(10);
  @$pb.TagNumber(11)
  set oauth2ProviderUserId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOauth2ProviderUserId() => $_has(10);
  @$pb.TagNumber(11)
  void clearOauth2ProviderUserId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get oauth2ProviderUsername => $_getSZ(11);
  @$pb.TagNumber(12)
  set oauth2ProviderUsername($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOauth2ProviderUsername() => $_has(11);
  @$pb.TagNumber(12)
  void clearOauth2ProviderUsername() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get oauth2AvatarUrl => $_getSZ(12);
  @$pb.TagNumber(13)
  set oauth2AvatarUrl($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasOauth2AvatarUrl() => $_has(12);
  @$pb.TagNumber(13)
  void clearOauth2AvatarUrl() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get oauth2EmailVerified => $_getBF(13);
  @$pb.TagNumber(14)
  set oauth2EmailVerified($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOauth2EmailVerified() => $_has(13);
  @$pb.TagNumber(14)
  void clearOauth2EmailVerified() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get oauth2ProviderInstanceName => $_getSZ(14);
  @$pb.TagNumber(15)
  set oauth2ProviderInstanceName($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOauth2ProviderInstanceName() => $_has(14);
  @$pb.TagNumber(15)
  void clearOauth2ProviderInstanceName() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get oauth2ProviderIssuer => $_getSZ(15);
  @$pb.TagNumber(16)
  set oauth2ProviderIssuer($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasOauth2ProviderIssuer() => $_has(15);
  @$pb.TagNumber(16)
  void clearOauth2ProviderIssuer() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get webauthnCredentialId => $_getSZ(16);
  @$pb.TagNumber(17)
  set webauthnCredentialId($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasWebauthnCredentialId() => $_has(16);
  @$pb.TagNumber(17)
  void clearWebauthnCredentialId() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get webauthnCredentialName => $_getSZ(17);
  @$pb.TagNumber(18)
  set webauthnCredentialName($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasWebauthnCredentialName() => $_has(17);
  @$pb.TagNumber(18)
  void clearWebauthnCredentialName() => $_clearField(18);
}

class RoomCreationReview extends $pb.GeneratedMessage {
  factory RoomCreationReview({
    $core.String? id,
    $core.String? requestedBy,
    $core.String? requestedByUsername,
    $core.String? name,
    $core.String? description,
    $1.ReviewStatus? status,
    $fixnum.Int64? requestedAt,
    $fixnum.Int64? reviewedAt,
    $core.String? reviewedBy,
    $core.String? rejectionReason,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (requestedByUsername != null)
      result.requestedByUsername = requestedByUsername;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (status != null) result.status = status;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    return result;
  }

  RoomCreationReview._();

  factory RoomCreationReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomCreationReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomCreationReview',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'requestedBy')
    ..aOS(3, _omitFieldNames ? '' : 'requestedByUsername')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aE<$1.ReviewStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aInt64(7, _omitFieldNames ? '' : 'requestedAt')
    ..aInt64(8, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(9, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(10, _omitFieldNames ? '' : 'rejectionReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCreationReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCreationReview copyWith(void Function(RoomCreationReview) updates) =>
      super.copyWith((message) => updates(message as RoomCreationReview))
          as RoomCreationReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomCreationReview create() => RoomCreationReview._();
  @$core.override
  RoomCreationReview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomCreationReview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomCreationReview>(create);
  static RoomCreationReview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestedBy($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestedByUsername => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestedByUsername($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestedByUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestedByUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

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

class RoomJoinReview extends $pb.GeneratedMessage {
  factory RoomJoinReview({
    $core.String? id,
    $core.String? roomId,
    $core.String? roomName,
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
    if (roomName != null) result.roomName = roomName;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'roomName')
    ..aOS(4, _omitFieldNames ? '' : 'userId')
    ..aOS(5, _omitFieldNames ? '' : 'username')
    ..aE<$1.RoomMemberRole>(6, _omitFieldNames ? '' : 'requestedRole',
        enumValues: $1.RoomMemberRole.values)
    ..aE<$1.ReviewStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aInt64(8, _omitFieldNames ? '' : 'requestedAt')
    ..aInt64(9, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(10, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(11, _omitFieldNames ? '' : 'rejectionReason')
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
  $core.String get roomName => $_getSZ(2);
  @$pb.TagNumber(3)
  set roomName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get username => $_getSZ(4);
  @$pb.TagNumber(5)
  set username($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUsername() => $_has(4);
  @$pb.TagNumber(5)
  void clearUsername() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.RoomMemberRole get requestedRole => $_getN(5);
  @$pb.TagNumber(6)
  set requestedRole($1.RoomMemberRole value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestedRole() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestedRole() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.ReviewStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status($1.ReviewStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get requestedAt => $_getI64(7);
  @$pb.TagNumber(8)
  set requestedAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRequestedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequestedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get reviewedAt => $_getI64(8);
  @$pb.TagNumber(9)
  set reviewedAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReviewedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get reviewedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set reviewedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReviewedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearReviewedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get rejectionReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set rejectionReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRejectionReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearRejectionReason() => $_clearField(11);
}

class BanRecord extends $pb.GeneratedMessage {
  factory BanRecord({
    $core.String? id,
    BanTargetType? targetType,
    $core.String? userId,
    $core.String? username,
    $core.String? roomId,
    $core.String? roomName,
    $core.String? bannedBy,
    $core.String? bannedByUsername,
    $core.String? reason,
    $fixnum.Int64? startsAt,
    $fixnum.Int64? endsAt,
    $fixnum.Int64? revokedAt,
    $core.String? revokedBy,
    $core.bool? isActive,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (targetType != null) result.targetType = targetType;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (roomId != null) result.roomId = roomId;
    if (roomName != null) result.roomName = roomName;
    if (bannedBy != null) result.bannedBy = bannedBy;
    if (bannedByUsername != null) result.bannedByUsername = bannedByUsername;
    if (reason != null) result.reason = reason;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (revokedAt != null) result.revokedAt = revokedAt;
    if (revokedBy != null) result.revokedBy = revokedBy;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  BanRecord._();

  factory BanRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BanRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BanRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<BanTargetType>(2, _omitFieldNames ? '' : 'targetType',
        enumValues: BanTargetType.values)
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'roomId')
    ..aOS(6, _omitFieldNames ? '' : 'roomName')
    ..aOS(7, _omitFieldNames ? '' : 'bannedBy')
    ..aOS(8, _omitFieldNames ? '' : 'bannedByUsername')
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..aInt64(10, _omitFieldNames ? '' : 'startsAt')
    ..aInt64(11, _omitFieldNames ? '' : 'endsAt')
    ..aInt64(12, _omitFieldNames ? '' : 'revokedAt')
    ..aOS(13, _omitFieldNames ? '' : 'revokedBy')
    ..aOB(14, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanRecord copyWith(void Function(BanRecord) updates) =>
      super.copyWith((message) => updates(message as BanRecord)) as BanRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BanRecord create() => BanRecord._();
  @$core.override
  BanRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BanRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BanRecord>(create);
  static BanRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  BanTargetType get targetType => $_getN(1);
  @$pb.TagNumber(2)
  set targetType(BanTargetType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetType() => $_clearField(2);

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
  $core.String get roomId => $_getSZ(4);
  @$pb.TagNumber(5)
  set roomId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoomId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoomId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get roomName => $_getSZ(5);
  @$pb.TagNumber(6)
  set roomName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoomName() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoomName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get bannedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set bannedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBannedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearBannedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get bannedByUsername => $_getSZ(7);
  @$pb.TagNumber(8)
  set bannedByUsername($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBannedByUsername() => $_has(7);
  @$pb.TagNumber(8)
  void clearBannedByUsername() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get startsAt => $_getI64(9);
  @$pb.TagNumber(10)
  set startsAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStartsAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartsAt() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get endsAt => $_getI64(10);
  @$pb.TagNumber(11)
  set endsAt($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEndsAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearEndsAt() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get revokedAt => $_getI64(11);
  @$pb.TagNumber(12)
  set revokedAt($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRevokedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearRevokedAt() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get revokedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set revokedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRevokedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearRevokedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isActive => $_getBF(13);
  @$pb.TagNumber(14)
  set isActive($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsActive() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsActive() => $_clearField(14);
}

class GetSettingsRequest extends $pb.GeneratedMessage {
  factory GetSettingsRequest() => create();

  GetSettingsRequest._();

  factory GetSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsRequest copyWith(void Function(GetSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsRequest))
          as GetSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest create() => GetSettingsRequest._();
  @$core.override
  GetSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsRequest>(create);
  static GetSettingsRequest? _defaultInstance;
}

class GetSettingsResponse extends $pb.GeneratedMessage {
  factory GetSettingsResponse({
    $core.Iterable<SettingsGroup>? groups,
  }) {
    final result = create();
    if (groups != null) result.groups.addAll(groups);
    return result;
  }

  GetSettingsResponse._();

  factory GetSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<SettingsGroup>(1, _omitFieldNames ? '' : 'groups',
        subBuilder: SettingsGroup.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsResponse copyWith(void Function(GetSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsResponse))
          as GetSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse create() => GetSettingsResponse._();
  @$core.override
  GetSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsResponse>(create);
  static GetSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SettingsGroup> get groups => $_getList(0);
}

class GetSettingsGroupRequest extends $pb.GeneratedMessage {
  factory GetSettingsGroupRequest({
    $core.String? group,
  }) {
    final result = create();
    if (group != null) result.group = group;
    return result;
  }

  GetSettingsGroupRequest._();

  factory GetSettingsGroupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsGroupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsGroupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'group')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsGroupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsGroupRequest copyWith(
          void Function(GetSettingsGroupRequest) updates) =>
      super.copyWith((message) => updates(message as GetSettingsGroupRequest))
          as GetSettingsGroupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsGroupRequest create() => GetSettingsGroupRequest._();
  @$core.override
  GetSettingsGroupRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsGroupRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsGroupRequest>(create);
  static GetSettingsGroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get group => $_getSZ(0);
  @$pb.TagNumber(1)
  set group($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
}

class GetSettingsGroupResponse extends $pb.GeneratedMessage {
  factory GetSettingsGroupResponse({
    SettingsGroup? group,
  }) {
    final result = create();
    if (group != null) result.group = group;
    return result;
  }

  GetSettingsGroupResponse._();

  factory GetSettingsGroupResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSettingsGroupResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSettingsGroupResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<SettingsGroup>(1, _omitFieldNames ? '' : 'group',
        subBuilder: SettingsGroup.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsGroupResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSettingsGroupResponse copyWith(
          void Function(GetSettingsGroupResponse) updates) =>
      super.copyWith((message) => updates(message as GetSettingsGroupResponse))
          as GetSettingsGroupResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSettingsGroupResponse create() => GetSettingsGroupResponse._();
  @$core.override
  GetSettingsGroupResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSettingsGroupResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSettingsGroupResponse>(create);
  static GetSettingsGroupResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SettingsGroup get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(SettingsGroup value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  SettingsGroup ensureGroup() => $_ensure(0);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    $core.String? group,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? settings,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (settings != null) result.settings.addEntries(settings);
    return result;
  }

  UpdateSettingsRequest._();

  factory UpdateSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'group')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'settings',
        entryClassName: 'UpdateSettingsRequest.SettingsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.admin'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsRequest copyWith(
          void Function(UpdateSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsRequest))
          as UpdateSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest create() => UpdateSettingsRequest._();
  @$core.override
  UpdateSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsRequest>(create);
  static UpdateSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get group => $_getSZ(0);
  @$pb.TagNumber(1)
  set group($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get settings => $_getMap(1);
}

class UpdateSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateSettingsResponse({
    SettingsGroup? group,
  }) {
    final result = create();
    if (group != null) result.group = group;
    return result;
  }

  UpdateSettingsResponse._();

  factory UpdateSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<SettingsGroup>(1, _omitFieldNames ? '' : 'group',
        subBuilder: SettingsGroup.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSettingsResponse copyWith(
          void Function(UpdateSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateSettingsResponse))
          as UpdateSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse create() => UpdateSettingsResponse._();
  @$core.override
  UpdateSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSettingsResponse>(create);
  static UpdateSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SettingsGroup get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(SettingsGroup value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  SettingsGroup ensureGroup() => $_ensure(0);
}

class SendTestEmailRequest extends $pb.GeneratedMessage {
  factory SendTestEmailRequest({
    $core.String? to,
  }) {
    final result = create();
    if (to != null) result.to = to;
    return result;
  }

  SendTestEmailRequest._();

  factory SendTestEmailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendTestEmailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendTestEmailRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'to')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendTestEmailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendTestEmailRequest copyWith(void Function(SendTestEmailRequest) updates) =>
      super.copyWith((message) => updates(message as SendTestEmailRequest))
          as SendTestEmailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendTestEmailRequest create() => SendTestEmailRequest._();
  @$core.override
  SendTestEmailRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendTestEmailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendTestEmailRequest>(create);
  static SendTestEmailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get to => $_getSZ(0);
  @$pb.TagNumber(1)
  set to($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTo() => $_has(0);
  @$pb.TagNumber(1)
  void clearTo() => $_clearField(1);
}

class SendTestEmailResponse extends $pb.GeneratedMessage {
  factory SendTestEmailResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  SendTestEmailResponse._();

  factory SendTestEmailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendTestEmailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendTestEmailResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendTestEmailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendTestEmailResponse copyWith(
          void Function(SendTestEmailResponse) updates) =>
      super.copyWith((message) => updates(message as SendTestEmailResponse))
          as SendTestEmailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendTestEmailResponse create() => SendTestEmailResponse._();
  @$core.override
  SendTestEmailResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendTestEmailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendTestEmailResponse>(create);
  static SendTestEmailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

/// SECURITY: password is transmitted as plaintext. TLS MUST be used.
class CreateUserRequest extends $pb.GeneratedMessage {
  factory CreateUserRequest({
    $core.String? username,
    $core.String? password,
    $core.String? email,
    $1.UserRole? role,
    $1.UserStatus? status,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (email != null) result.email = email;
    if (role != null) result.role = role;
    if (status != null) result.status = status;
    return result;
  }

  CreateUserRequest._();

  factory CreateUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aE<$1.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $1.UserRole.values)
    ..aE<$1.UserStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $1.UserStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserRequest copyWith(void Function(CreateUserRequest) updates) =>
      super.copyWith((message) => updates(message as CreateUserRequest))
          as CreateUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateUserRequest create() => CreateUserRequest._();
  @$core.override
  CreateUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateUserRequest>(create);
  static CreateUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

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
}

class CreateUserResponse extends $pb.GeneratedMessage {
  factory CreateUserResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  CreateUserResponse._();

  factory CreateUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateUserResponse copyWith(void Function(CreateUserResponse) updates) =>
      super.copyWith((message) => updates(message as CreateUserResponse))
          as CreateUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateUserResponse create() => CreateUserResponse._();
  @$core.override
  CreateUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateUserResponse>(create);
  static CreateUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class DeleteUserRequest extends $pb.GeneratedMessage {
  factory DeleteUserRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  DeleteUserRequest._();

  factory DeleteUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserRequest copyWith(void Function(DeleteUserRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteUserRequest))
          as DeleteUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteUserRequest create() => DeleteUserRequest._();
  @$core.override
  DeleteUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteUserRequest>(create);
  static DeleteUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class DeleteUserResponse extends $pb.GeneratedMessage {
  factory DeleteUserResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteUserResponse._();

  factory DeleteUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteUserResponse copyWith(void Function(DeleteUserResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteUserResponse))
          as DeleteUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteUserResponse create() => DeleteUserResponse._();
  @$core.override
  DeleteUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteUserResponse>(create);
  static DeleteUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ListUsersRequest extends $pb.GeneratedMessage {
  factory ListUsersRequest({
    $core.int? page,
    $core.int? pageSize,
    $1.UserStatus? status,
    $1.UserRole? role,
    $core.String? search,
    UserListSortBy? sortBy,
    SortDirection? sortDirection,
    $core.bool? isBanned,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (role != null) result.role = role;
    if (search != null) result.search = search;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    if (isBanned != null) result.isBanned = isBanned;
    return result;
  }

  ListUsersRequest._();

  factory ListUsersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUsersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUsersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.UserStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $1.UserStatus.values)
    ..aE<$1.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $1.UserRole.values)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aE<UserListSortBy>(6, _omitFieldNames ? '' : 'sortBy',
        enumValues: UserListSortBy.values)
    ..aE<SortDirection>(7, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..aOB(8, _omitFieldNames ? '' : 'isBanned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersRequest copyWith(void Function(ListUsersRequest) updates) =>
      super.copyWith((message) => updates(message as ListUsersRequest))
          as ListUsersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUsersRequest create() => ListUsersRequest._();
  @$core.override
  ListUsersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUsersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUsersRequest>(create);
  static ListUsersRequest? _defaultInstance;

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
  $1.UserStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($1.UserStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role($1.UserRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get search => $_getSZ(4);
  @$pb.TagNumber(5)
  set search($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearch() => $_clearField(5);

  @$pb.TagNumber(6)
  UserListSortBy get sortBy => $_getN(5);
  @$pb.TagNumber(6)
  set sortBy(UserListSortBy value) => $_setField(6, value);
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

  @$pb.TagNumber(8)
  $core.bool get isBanned => $_getBF(7);
  @$pb.TagNumber(8)
  set isBanned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsBanned() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsBanned() => $_clearField(8);
}

class ListUsersResponse extends $pb.GeneratedMessage {
  factory ListUsersResponse({
    $core.Iterable<AdminUser>? users,
    $core.int? total,
  }) {
    final result = create();
    if (users != null) result.users.addAll(users);
    if (total != null) result.total = total;
    return result;
  }

  ListUsersResponse._();

  factory ListUsersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUsersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUsersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<AdminUser>(1, _omitFieldNames ? '' : 'users',
        subBuilder: AdminUser.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUsersResponse copyWith(void Function(ListUsersResponse) updates) =>
      super.copyWith((message) => updates(message as ListUsersResponse))
          as ListUsersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUsersResponse create() => ListUsersResponse._();
  @$core.override
  ListUsersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUsersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUsersResponse>(create);
  static ListUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AdminUser> get users => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetUserRequest extends $pb.GeneratedMessage {
  factory GetUserRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetUserRequest._();

  factory GetUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRequest copyWith(void Function(GetUserRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserRequest))
          as GetUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserRequest create() => GetUserRequest._();
  @$core.override
  GetUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserRequest>(create);
  static GetUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class UserPathRequest extends $pb.GeneratedMessage {
  factory UserPathRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  UserPathRequest._();

  factory UserPathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserPathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserPathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPathRequest copyWith(void Function(UserPathRequest) updates) =>
      super.copyWith((message) => updates(message as UserPathRequest))
          as UserPathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserPathRequest create() => UserPathRequest._();
  @$core.override
  UserPathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserPathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserPathRequest>(create);
  static UserPathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class GetUserResponse extends $pb.GeneratedMessage {
  factory GetUserResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  GetUserResponse._();

  factory GetUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserResponse copyWith(void Function(GetUserResponse) updates) =>
      super.copyWith((message) => updates(message as GetUserResponse))
          as GetUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserResponse create() => GetUserResponse._();
  @$core.override
  GetUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserResponse>(create);
  static GetUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class GetUserPreferencesRequest extends $pb.GeneratedMessage {
  factory GetUserPreferencesRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  GetUserPreferencesRequest._();

  factory GetUserPreferencesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserPreferencesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserPreferencesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
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

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class GetUserPreferencesResponse extends $pb.GeneratedMessage {
  factory GetUserPreferencesResponse({
    AdminUser? user,
    $0.UserPreferences? preferences,
    $0.UserAuthFactors? authFactors,
  }) {
    final result = create();
    if (user != null) result.user = user;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..aOM<$0.UserPreferences>(2, _omitFieldNames ? '' : 'preferences',
        subBuilder: $0.UserPreferences.create)
    ..aOM<$0.UserAuthFactors>(3, _omitFieldNames ? '' : 'authFactors',
        subBuilder: $0.UserAuthFactors.create)
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
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.UserPreferences get preferences => $_getN(1);
  @$pb.TagNumber(2)
  set preferences($0.UserPreferences value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreferences() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreferences() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.UserPreferences ensurePreferences() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.UserAuthFactors get authFactors => $_getN(2);
  @$pb.TagNumber(3)
  set authFactors($0.UserAuthFactors value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthFactors() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthFactors() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.UserAuthFactors ensureAuthFactors() => $_ensure(2);
}

class UpdateUserPreferencesRequest extends $pb.GeneratedMessage {
  factory UpdateUserPreferencesRequest({
    $core.String? userId,
    $core.bool? twoFactorEnabled,
    $0.UserNotificationPreferences? notifications,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOB(2, _omitFieldNames ? '' : 'twoFactorEnabled')
    ..aOM<$0.UserNotificationPreferences>(
        4, _omitFieldNames ? '' : 'notifications',
        subBuilder: $0.UserNotificationPreferences.create)
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
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get twoFactorEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set twoFactorEnabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTwoFactorEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearTwoFactorEnabled() => $_clearField(2);

  @$pb.TagNumber(4)
  $0.UserNotificationPreferences get notifications => $_getN(2);
  @$pb.TagNumber(4)
  set notifications($0.UserNotificationPreferences value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNotifications() => $_has(2);
  @$pb.TagNumber(4)
  void clearNotifications() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.UserNotificationPreferences ensureNotifications() => $_ensure(2);
}

class UpdateUserPreferencesResponse extends $pb.GeneratedMessage {
  factory UpdateUserPreferencesResponse({
    AdminUser? user,
    $0.UserPreferences? preferences,
    $0.UserAuthFactors? authFactors,
  }) {
    final result = create();
    if (user != null) result.user = user;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..aOM<$0.UserPreferences>(2, _omitFieldNames ? '' : 'preferences',
        subBuilder: $0.UserPreferences.create)
    ..aOM<$0.UserAuthFactors>(3, _omitFieldNames ? '' : 'authFactors',
        subBuilder: $0.UserAuthFactors.create)
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
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.UserPreferences get preferences => $_getN(1);
  @$pb.TagNumber(2)
  set preferences($0.UserPreferences value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreferences() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreferences() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.UserPreferences ensurePreferences() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.UserAuthFactors get authFactors => $_getN(2);
  @$pb.TagNumber(3)
  set authFactors($0.UserAuthFactors value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthFactors() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthFactors() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.UserAuthFactors ensureAuthFactors() => $_ensure(2);
}

/// SECURITY: Admin password reset is a privileged operation. The reason field
/// provides an audit trail for compliance.
class UpdateUserPasswordRequest extends $pb.GeneratedMessage {
  factory UpdateUserPasswordRequest({
    $core.String? userId,
    $core.String? newPassword,
    $core.String? reason,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (newPassword != null) result.newPassword = newPassword;
    if (reason != null) result.reason = reason;
    return result;
  }

  UpdateUserPasswordRequest._();

  factory UpdateUserPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserPasswordRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'newPassword')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPasswordRequest copyWith(
          void Function(UpdateUserPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateUserPasswordRequest))
          as UpdateUserPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserPasswordRequest create() => UpdateUserPasswordRequest._();
  @$core.override
  UpdateUserPasswordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserPasswordRequest>(create);
  static UpdateUserPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPassword => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPassword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class UpdateUserPasswordResponse extends $pb.GeneratedMessage {
  factory UpdateUserPasswordResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  UpdateUserPasswordResponse._();

  factory UpdateUserPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserPasswordResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserPasswordResponse copyWith(
          void Function(UpdateUserPasswordResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateUserPasswordResponse))
          as UpdateUserPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserPasswordResponse create() => UpdateUserPasswordResponse._();
  @$core.override
  UpdateUserPasswordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserPasswordResponse>(create);
  static UpdateUserPasswordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class UpdateUserUsernameRequest extends $pb.GeneratedMessage {
  factory UpdateUserUsernameRequest({
    $core.String? userId,
    $core.String? newUsername,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (newUsername != null) result.newUsername = newUsername;
    return result;
  }

  UpdateUserUsernameRequest._();

  factory UpdateUserUsernameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserUsernameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserUsernameRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'newUsername')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserUsernameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserUsernameRequest copyWith(
          void Function(UpdateUserUsernameRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateUserUsernameRequest))
          as UpdateUserUsernameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserUsernameRequest create() => UpdateUserUsernameRequest._();
  @$core.override
  UpdateUserUsernameRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserUsernameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserUsernameRequest>(create);
  static UpdateUserUsernameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newUsername => $_getSZ(1);
  @$pb.TagNumber(2)
  set newUsername($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewUsername() => $_clearField(2);
}

class UpdateUserUsernameResponse extends $pb.GeneratedMessage {
  factory UpdateUserUsernameResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  UpdateUserUsernameResponse._();

  factory UpdateUserUsernameResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserUsernameResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserUsernameResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserUsernameResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserUsernameResponse copyWith(
          void Function(UpdateUserUsernameResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateUserUsernameResponse))
          as UpdateUserUsernameResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserUsernameResponse create() => UpdateUserUsernameResponse._();
  @$core.override
  UpdateUserUsernameResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserUsernameResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserUsernameResponse>(create);
  static UpdateUserUsernameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class UpdateUserRoleRequest extends $pb.GeneratedMessage {
  factory UpdateUserRoleRequest({
    $core.String? userId,
    $1.UserRole? role,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (role != null) result.role = role;
    return result;
  }

  UpdateUserRoleRequest._();

  factory UpdateUserRoleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserRoleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserRoleRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aE<$1.UserRole>(2, _omitFieldNames ? '' : 'role',
        enumValues: $1.UserRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserRoleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserRoleRequest copyWith(
          void Function(UpdateUserRoleRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateUserRoleRequest))
          as UpdateUserRoleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserRoleRequest create() => UpdateUserRoleRequest._();
  @$core.override
  UpdateUserRoleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserRoleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserRoleRequest>(create);
  static UpdateUserRoleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.UserRole get role => $_getN(1);
  @$pb.TagNumber(2)
  set role($1.UserRole value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);
}

class UpdateUserRoleResponse extends $pb.GeneratedMessage {
  factory UpdateUserRoleResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  UpdateUserRoleResponse._();

  factory UpdateUserRoleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserRoleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserRoleResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserRoleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserRoleResponse copyWith(
          void Function(UpdateUserRoleResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateUserRoleResponse))
          as UpdateUserRoleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserRoleResponse create() => UpdateUserRoleResponse._();
  @$core.override
  UpdateUserRoleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserRoleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserRoleResponse>(create);
  static UpdateUserRoleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class BanUserRequest extends $pb.GeneratedMessage {
  factory BanUserRequest({
    $core.String? userId,
    $core.String? reason,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (reason != null) result.reason = reason;
    return result;
  }

  BanUserRequest._();

  factory BanUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BanUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BanUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanUserRequest copyWith(void Function(BanUserRequest) updates) =>
      super.copyWith((message) => updates(message as BanUserRequest))
          as BanUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BanUserRequest create() => BanUserRequest._();
  @$core.override
  BanUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BanUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BanUserRequest>(create);
  static BanUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class BanUserResponse extends $pb.GeneratedMessage {
  factory BanUserResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  BanUserResponse._();

  factory BanUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BanUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BanUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanUserResponse copyWith(void Function(BanUserResponse) updates) =>
      super.copyWith((message) => updates(message as BanUserResponse))
          as BanUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BanUserResponse create() => BanUserResponse._();
  @$core.override
  BanUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BanUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BanUserResponse>(create);
  static BanUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class UnbanUserRequest extends $pb.GeneratedMessage {
  factory UnbanUserRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  UnbanUserRequest._();

  factory UnbanUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnbanUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnbanUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanUserRequest copyWith(void Function(UnbanUserRequest) updates) =>
      super.copyWith((message) => updates(message as UnbanUserRequest))
          as UnbanUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnbanUserRequest create() => UnbanUserRequest._();
  @$core.override
  UnbanUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnbanUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnbanUserRequest>(create);
  static UnbanUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class UnbanUserResponse extends $pb.GeneratedMessage {
  factory UnbanUserResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  UnbanUserResponse._();

  factory UnbanUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnbanUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnbanUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanUserResponse copyWith(void Function(UnbanUserResponse) updates) =>
      super.copyWith((message) => updates(message as UnbanUserResponse))
          as UnbanUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnbanUserResponse create() => UnbanUserResponse._();
  @$core.override
  UnbanUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnbanUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnbanUserResponse>(create);
  static UnbanUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class GetUserRoomsRequest extends $pb.GeneratedMessage {
  factory GetUserRoomsRequest({
    $core.String? userId,
    $core.int? page,
    $core.int? pageSize,
    $1.RoomStatus? status,
    $core.String? search,
    $core.bool? isBanned,
    RoomListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (search != null) result.search = search;
    if (isBanned != null) result.isBanned = isBanned;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  GetUserRoomsRequest._();

  factory GetUserRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserRoomsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.RoomStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: $1.RoomStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOB(6, _omitFieldNames ? '' : 'isBanned')
    ..aE<RoomListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRoomsRequest copyWith(void Function(GetUserRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserRoomsRequest))
          as GetUserRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserRoomsRequest create() => GetUserRoomsRequest._();
  @$core.override
  GetUserRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserRoomsRequest>(create);
  static GetUserRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

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
  $1.RoomStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status($1.RoomStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get search => $_getSZ(4);
  @$pb.TagNumber(5)
  set search($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isBanned => $_getBF(5);
  @$pb.TagNumber(6)
  set isBanned($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsBanned() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsBanned() => $_clearField(6);

  @$pb.TagNumber(7)
  RoomListSortBy get sortBy => $_getN(6);
  @$pb.TagNumber(7)
  set sortBy(RoomListSortBy value) => $_setField(7, value);
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

class GetUserRoomsResponse extends $pb.GeneratedMessage {
  factory GetUserRoomsResponse({
    $core.Iterable<AdminRoom>? rooms,
    $core.int? total,
  }) {
    final result = create();
    if (rooms != null) result.rooms.addAll(rooms);
    if (total != null) result.total = total;
    return result;
  }

  GetUserRoomsResponse._();

  factory GetUserRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserRoomsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<AdminRoom>(1, _omitFieldNames ? '' : 'rooms',
        subBuilder: AdminRoom.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserRoomsResponse copyWith(void Function(GetUserRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as GetUserRoomsResponse))
          as GetUserRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserRoomsResponse create() => GetUserRoomsResponse._();
  @$core.override
  GetUserRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserRoomsResponse>(create);
  static GetUserRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AdminRoom> get rooms => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class ListUserRegistrationReviewsRequest extends $pb.GeneratedMessage {
  factory ListUserRegistrationReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $1.ReviewStatus? status,
    $core.String? search,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (search != null) result.search = search;
    return result;
  }

  ListUserRegistrationReviewsRequest._();

  factory ListUserRegistrationReviewsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserRegistrationReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserRegistrationReviewsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'search')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserRegistrationReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserRegistrationReviewsRequest copyWith(
          void Function(ListUserRegistrationReviewsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ListUserRegistrationReviewsRequest))
          as ListUserRegistrationReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserRegistrationReviewsRequest create() =>
      ListUserRegistrationReviewsRequest._();
  @$core.override
  ListUserRegistrationReviewsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUserRegistrationReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserRegistrationReviewsRequest>(
          create);
  static ListUserRegistrationReviewsRequest? _defaultInstance;

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
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);
}

class ListUserRegistrationReviewsResponse extends $pb.GeneratedMessage {
  factory ListUserRegistrationReviewsResponse({
    $core.Iterable<UserRegistrationReview>? reviews,
    $core.int? total,
  }) {
    final result = create();
    if (reviews != null) result.reviews.addAll(reviews);
    if (total != null) result.total = total;
    return result;
  }

  ListUserRegistrationReviewsResponse._();

  factory ListUserRegistrationReviewsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserRegistrationReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserRegistrationReviewsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<UserRegistrationReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: UserRegistrationReview.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserRegistrationReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserRegistrationReviewsResponse copyWith(
          void Function(ListUserRegistrationReviewsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ListUserRegistrationReviewsResponse))
          as ListUserRegistrationReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserRegistrationReviewsResponse create() =>
      ListUserRegistrationReviewsResponse._();
  @$core.override
  ListUserRegistrationReviewsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUserRegistrationReviewsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ListUserRegistrationReviewsResponse>(create);
  static ListUserRegistrationReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserRegistrationReview> get reviews => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class ApproveUserRegistrationReviewRequest extends $pb.GeneratedMessage {
  factory ApproveUserRegistrationReviewRequest({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  ApproveUserRegistrationReviewRequest._();

  factory ApproveUserRegistrationReviewRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveUserRegistrationReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveUserRegistrationReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveUserRegistrationReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveUserRegistrationReviewRequest copyWith(
          void Function(ApproveUserRegistrationReviewRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ApproveUserRegistrationReviewRequest))
          as ApproveUserRegistrationReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveUserRegistrationReviewRequest create() =>
      ApproveUserRegistrationReviewRequest._();
  @$core.override
  ApproveUserRegistrationReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveUserRegistrationReviewRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ApproveUserRegistrationReviewRequest>(create);
  static ApproveUserRegistrationReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

class ApproveUserRegistrationReviewResponse extends $pb.GeneratedMessage {
  factory ApproveUserRegistrationReviewResponse({
    UserRegistrationReview? review,
    AdminUser? user,
  }) {
    final result = create();
    if (review != null) result.review = review;
    if (user != null) result.user = user;
    return result;
  }

  ApproveUserRegistrationReviewResponse._();

  factory ApproveUserRegistrationReviewResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveUserRegistrationReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveUserRegistrationReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<UserRegistrationReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: UserRegistrationReview.create)
    ..aOM<AdminUser>(2, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveUserRegistrationReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveUserRegistrationReviewResponse copyWith(
          void Function(ApproveUserRegistrationReviewResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ApproveUserRegistrationReviewResponse))
          as ApproveUserRegistrationReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveUserRegistrationReviewResponse create() =>
      ApproveUserRegistrationReviewResponse._();
  @$core.override
  ApproveUserRegistrationReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveUserRegistrationReviewResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ApproveUserRegistrationReviewResponse>(create);
  static ApproveUserRegistrationReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UserRegistrationReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(UserRegistrationReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  UserRegistrationReview ensureReview() => $_ensure(0);

  @$pb.TagNumber(2)
  AdminUser get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(AdminUser value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  AdminUser ensureUser() => $_ensure(1);
}

class RejectUserRegistrationReviewRequest extends $pb.GeneratedMessage {
  factory RejectUserRegistrationReviewRequest({
    $core.String? requestId,
    $core.String? reason,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RejectUserRegistrationReviewRequest._();

  factory RejectUserRegistrationReviewRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectUserRegistrationReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectUserRegistrationReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectUserRegistrationReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectUserRegistrationReviewRequest copyWith(
          void Function(RejectUserRegistrationReviewRequest) updates) =>
      super.copyWith((message) =>
              updates(message as RejectUserRegistrationReviewRequest))
          as RejectUserRegistrationReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectUserRegistrationReviewRequest create() =>
      RejectUserRegistrationReviewRequest._();
  @$core.override
  RejectUserRegistrationReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectUserRegistrationReviewRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          RejectUserRegistrationReviewRequest>(create);
  static RejectUserRegistrationReviewRequest? _defaultInstance;

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

class RejectUserRegistrationReviewResponse extends $pb.GeneratedMessage {
  factory RejectUserRegistrationReviewResponse({
    UserRegistrationReview? review,
    $core.bool? success,
  }) {
    final result = create();
    if (review != null) result.review = review;
    if (success != null) result.success = success;
    return result;
  }

  RejectUserRegistrationReviewResponse._();

  factory RejectUserRegistrationReviewResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectUserRegistrationReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectUserRegistrationReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<UserRegistrationReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: UserRegistrationReview.create)
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectUserRegistrationReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectUserRegistrationReviewResponse copyWith(
          void Function(RejectUserRegistrationReviewResponse) updates) =>
      super.copyWith((message) =>
              updates(message as RejectUserRegistrationReviewResponse))
          as RejectUserRegistrationReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectUserRegistrationReviewResponse create() =>
      RejectUserRegistrationReviewResponse._();
  @$core.override
  RejectUserRegistrationReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectUserRegistrationReviewResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          RejectUserRegistrationReviewResponse>(create);
  static RejectUserRegistrationReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UserRegistrationReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(UserRegistrationReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  UserRegistrationReview ensureReview() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);
}

class ListRoomCreationReviewsRequest extends $pb.GeneratedMessage {
  factory ListRoomCreationReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $1.ReviewStatus? status,
    $core.String? requestedBy,
    $core.String? search,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (search != null) result.search = search;
    return result;
  }

  ListRoomCreationReviewsRequest._();

  factory ListRoomCreationReviewsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomCreationReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomCreationReviewsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'requestedBy')
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCreationReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCreationReviewsRequest copyWith(
          void Function(ListRoomCreationReviewsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListRoomCreationReviewsRequest))
          as ListRoomCreationReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomCreationReviewsRequest create() =>
      ListRoomCreationReviewsRequest._();
  @$core.override
  ListRoomCreationReviewsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomCreationReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomCreationReviewsRequest>(create);
  static ListRoomCreationReviewsRequest? _defaultInstance;

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
  $core.String get requestedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set requestedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequestedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequestedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get search => $_getSZ(4);
  @$pb.TagNumber(5)
  set search($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearch() => $_clearField(5);
}

class ListRoomCreationReviewsResponse extends $pb.GeneratedMessage {
  factory ListRoomCreationReviewsResponse({
    $core.Iterable<RoomCreationReview>? reviews,
    $core.int? total,
  }) {
    final result = create();
    if (reviews != null) result.reviews.addAll(reviews);
    if (total != null) result.total = total;
    return result;
  }

  ListRoomCreationReviewsResponse._();

  factory ListRoomCreationReviewsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomCreationReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomCreationReviewsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<RoomCreationReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: RoomCreationReview.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCreationReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCreationReviewsResponse copyWith(
          void Function(ListRoomCreationReviewsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRoomCreationReviewsResponse))
          as ListRoomCreationReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomCreationReviewsResponse create() =>
      ListRoomCreationReviewsResponse._();
  @$core.override
  ListRoomCreationReviewsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomCreationReviewsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomCreationReviewsResponse>(
          create);
  static ListRoomCreationReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RoomCreationReview> get reviews => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class ApproveRoomCreationReviewRequest extends $pb.GeneratedMessage {
  factory ApproveRoomCreationReviewRequest({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  ApproveRoomCreationReviewRequest._();

  factory ApproveRoomCreationReviewRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveRoomCreationReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRoomCreationReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomCreationReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomCreationReviewRequest copyWith(
          void Function(ApproveRoomCreationReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApproveRoomCreationReviewRequest))
          as ApproveRoomCreationReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveRoomCreationReviewRequest create() =>
      ApproveRoomCreationReviewRequest._();
  @$core.override
  ApproveRoomCreationReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveRoomCreationReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveRoomCreationReviewRequest>(
          create);
  static ApproveRoomCreationReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

class ApproveRoomCreationReviewResponse extends $pb.GeneratedMessage {
  factory ApproveRoomCreationReviewResponse({
    RoomCreationReview? review,
    AdminRoom? room,
  }) {
    final result = create();
    if (review != null) result.review = review;
    if (room != null) result.room = room;
    return result;
  }

  ApproveRoomCreationReviewResponse._();

  factory ApproveRoomCreationReviewResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveRoomCreationReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveRoomCreationReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<RoomCreationReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: RoomCreationReview.create)
    ..aOM<AdminRoom>(2, _omitFieldNames ? '' : 'room',
        subBuilder: AdminRoom.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomCreationReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveRoomCreationReviewResponse copyWith(
          void Function(ApproveRoomCreationReviewResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ApproveRoomCreationReviewResponse))
          as ApproveRoomCreationReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveRoomCreationReviewResponse create() =>
      ApproveRoomCreationReviewResponse._();
  @$core.override
  ApproveRoomCreationReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveRoomCreationReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveRoomCreationReviewResponse>(
          create);
  static ApproveRoomCreationReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RoomCreationReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(RoomCreationReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomCreationReview ensureReview() => $_ensure(0);

  @$pb.TagNumber(2)
  AdminRoom get room => $_getN(1);
  @$pb.TagNumber(2)
  set room(AdminRoom value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoom() => $_clearField(2);
  @$pb.TagNumber(2)
  AdminRoom ensureRoom() => $_ensure(1);
}

class RejectRoomCreationReviewRequest extends $pb.GeneratedMessage {
  factory RejectRoomCreationReviewRequest({
    $core.String? requestId,
    $core.String? reason,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RejectRoomCreationReviewRequest._();

  factory RejectRoomCreationReviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectRoomCreationReviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectRoomCreationReviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomCreationReviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomCreationReviewRequest copyWith(
          void Function(RejectRoomCreationReviewRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RejectRoomCreationReviewRequest))
          as RejectRoomCreationReviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectRoomCreationReviewRequest create() =>
      RejectRoomCreationReviewRequest._();
  @$core.override
  RejectRoomCreationReviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectRoomCreationReviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectRoomCreationReviewRequest>(
          create);
  static RejectRoomCreationReviewRequest? _defaultInstance;

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

class RejectRoomCreationReviewResponse extends $pb.GeneratedMessage {
  factory RejectRoomCreationReviewResponse({
    RoomCreationReview? review,
    $core.bool? success,
  }) {
    final result = create();
    if (review != null) result.review = review;
    if (success != null) result.success = success;
    return result;
  }

  RejectRoomCreationReviewResponse._();

  factory RejectRoomCreationReviewResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectRoomCreationReviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectRoomCreationReviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<RoomCreationReview>(1, _omitFieldNames ? '' : 'review',
        subBuilder: RoomCreationReview.create)
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomCreationReviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectRoomCreationReviewResponse copyWith(
          void Function(RejectRoomCreationReviewResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RejectRoomCreationReviewResponse))
          as RejectRoomCreationReviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectRoomCreationReviewResponse create() =>
      RejectRoomCreationReviewResponse._();
  @$core.override
  RejectRoomCreationReviewResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectRoomCreationReviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectRoomCreationReviewResponse>(
          create);
  static RejectRoomCreationReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RoomCreationReview get review => $_getN(0);
  @$pb.TagNumber(1)
  set review(RoomCreationReview value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReview() => $_has(0);
  @$pb.TagNumber(1)
  void clearReview() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomCreationReview ensureReview() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);
}

class ListRoomJoinReviewsRequest extends $pb.GeneratedMessage {
  factory ListRoomJoinReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $1.ReviewStatus? status,
    $core.String? roomId,
    $core.String? userId,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (roomId != null) result.roomId = roomId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $1.ReviewStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'roomId')
    ..aOS(5, _omitFieldNames ? '' : 'userId')
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
  $core.String get roomId => $_getSZ(3);
  @$pb.TagNumber(4)
  set roomId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoomId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoomId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userId => $_getSZ(4);
  @$pb.TagNumber(5)
  set userId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserId() => $_clearField(5);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class ListRoomsRequest extends $pb.GeneratedMessage {
  factory ListRoomsRequest({
    $core.int? page,
    $core.int? pageSize,
    $1.RoomStatus? status,
    $core.String? search,
    $core.String? creatorId,
    $core.bool? isBanned,
    RoomListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (search != null) result.search = search;
    if (creatorId != null) result.creatorId = creatorId;
    if (isBanned != null) result.isBanned = isBanned;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$1.RoomStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $1.RoomStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'search')
    ..aOS(5, _omitFieldNames ? '' : 'creatorId')
    ..aOB(6, _omitFieldNames ? '' : 'isBanned')
    ..aE<RoomListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
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
  $1.RoomStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($1.RoomStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creatorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set creatorId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatorId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isBanned => $_getBF(5);
  @$pb.TagNumber(6)
  set isBanned($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsBanned() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsBanned() => $_clearField(6);

  @$pb.TagNumber(7)
  RoomListSortBy get sortBy => $_getN(6);
  @$pb.TagNumber(7)
  set sortBy(RoomListSortBy value) => $_setField(7, value);
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

class ListRoomsResponse extends $pb.GeneratedMessage {
  factory ListRoomsResponse({
    $core.Iterable<AdminRoom>? rooms,
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<AdminRoom>(1, _omitFieldNames ? '' : 'rooms',
        subBuilder: AdminRoom.create)
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
  $pb.PbList<AdminRoom> get rooms => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class GetRoomResponse extends $pb.GeneratedMessage {
  factory GetRoomResponse({
    AdminRoom? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminRoom>(1, _omitFieldNames ? '' : 'room',
        subBuilder: AdminRoom.create)
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
  AdminRoom get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(AdminRoom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminRoom ensureRoom() => $_ensure(0);
}

class GetRoomSettingsRequest extends $pb.GeneratedMessage {
  factory GetRoomSettingsRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  GetRoomSettingsRequest._();

  factory GetRoomSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRoomSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRoomSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
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

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class UpdateRoomSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateRoomSettingsRequest({
    $core.String? roomId,
    $core.List<$core.int>? settings,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'settings', $pb.PbFieldType.OY)
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
}

class UpdateRoomSettingsResponse extends $pb.GeneratedMessage {
  factory UpdateRoomSettingsResponse({
    AdminRoom? room,
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminRoom>(1, _omitFieldNames ? '' : 'room',
        subBuilder: AdminRoom.create)
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
  AdminRoom get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(AdminRoom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminRoom ensureRoom() => $_ensure(0);
}

class ResetRoomSettingsRequest extends $pb.GeneratedMessage {
  factory ResetRoomSettingsRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  ResetRoomSettingsRequest._();

  factory ResetRoomSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetRoomSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResetRoomSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
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

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class ResetRoomSettingsResponse extends $pb.GeneratedMessage {
  factory ResetRoomSettingsResponse({
    AdminRoom? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminRoom>(1, _omitFieldNames ? '' : 'room',
        subBuilder: AdminRoom.create)
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
  AdminRoom get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(AdminRoom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminRoom ensureRoom() => $_ensure(0);
}

class UpdateRoomPasswordRequest extends $pb.GeneratedMessage {
  factory UpdateRoomPasswordRequest({
    $core.String? roomId,
    $core.String? newPassword,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (newPassword != null) result.newPassword = newPassword;
    return result;
  }

  UpdateRoomPasswordRequest._();

  factory UpdateRoomPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomPasswordRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'newPassword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomPasswordRequest copyWith(
          void Function(UpdateRoomPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomPasswordRequest))
          as UpdateRoomPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomPasswordRequest create() => UpdateRoomPasswordRequest._();
  @$core.override
  UpdateRoomPasswordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomPasswordRequest>(create);
  static UpdateRoomPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPassword => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPassword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPassword() => $_clearField(2);
}

class UpdateRoomPasswordResponse extends $pb.GeneratedMessage {
  factory UpdateRoomPasswordResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  UpdateRoomPasswordResponse._();

  factory UpdateRoomPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomPasswordResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomPasswordResponse copyWith(
          void Function(UpdateRoomPasswordResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateRoomPasswordResponse))
          as UpdateRoomPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomPasswordResponse create() => UpdateRoomPasswordResponse._();
  @$core.override
  UpdateRoomPasswordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomPasswordResponse>(create);
  static UpdateRoomPasswordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class DeleteRoomRequest extends $pb.GeneratedMessage {
  factory DeleteRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  DeleteRoomRequest._();

  factory DeleteRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
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

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class BanRoomRequest extends $pb.GeneratedMessage {
  factory BanRoomRequest({
    $core.String? roomId,
    $core.String? reason,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (reason != null) result.reason = reason;
    return result;
  }

  BanRoomRequest._();

  factory BanRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BanRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BanRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanRoomRequest copyWith(void Function(BanRoomRequest) updates) =>
      super.copyWith((message) => updates(message as BanRoomRequest))
          as BanRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BanRoomRequest create() => BanRoomRequest._();
  @$core.override
  BanRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BanRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BanRoomRequest>(create);
  static BanRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class BanRoomResponse extends $pb.GeneratedMessage {
  factory BanRoomResponse({
    AdminRoom? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  BanRoomResponse._();

  factory BanRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BanRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BanRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminRoom>(1, _omitFieldNames ? '' : 'room',
        subBuilder: AdminRoom.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BanRoomResponse copyWith(void Function(BanRoomResponse) updates) =>
      super.copyWith((message) => updates(message as BanRoomResponse))
          as BanRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BanRoomResponse create() => BanRoomResponse._();
  @$core.override
  BanRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BanRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BanRoomResponse>(create);
  static BanRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminRoom get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(AdminRoom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminRoom ensureRoom() => $_ensure(0);
}

class UnbanRoomRequest extends $pb.GeneratedMessage {
  factory UnbanRoomRequest({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  UnbanRoomRequest._();

  factory UnbanRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnbanRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnbanRoomRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanRoomRequest copyWith(void Function(UnbanRoomRequest) updates) =>
      super.copyWith((message) => updates(message as UnbanRoomRequest))
          as UnbanRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnbanRoomRequest create() => UnbanRoomRequest._();
  @$core.override
  UnbanRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnbanRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnbanRoomRequest>(create);
  static UnbanRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class UnbanRoomResponse extends $pb.GeneratedMessage {
  factory UnbanRoomResponse({
    AdminRoom? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  UnbanRoomResponse._();

  factory UnbanRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnbanRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnbanRoomResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminRoom>(1, _omitFieldNames ? '' : 'room',
        subBuilder: AdminRoom.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbanRoomResponse copyWith(void Function(UnbanRoomResponse) updates) =>
      super.copyWith((message) => updates(message as UnbanRoomResponse))
          as UnbanRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnbanRoomResponse create() => UnbanRoomResponse._();
  @$core.override
  UnbanRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnbanRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnbanRoomResponse>(create);
  static UnbanRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminRoom get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(AdminRoom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminRoom ensureRoom() => $_ensure(0);
}

class GetRoomMembersRequest extends $pb.GeneratedMessage {
  factory GetRoomMembersRequest({
    $core.String? roomId,
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    $1.RoomMemberRole? role,
    RoomMemberListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'search')
    ..aE<$1.RoomMemberRole>(5, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..aE<RoomMemberListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomMemberListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
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
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

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
  $1.RoomMemberRole get role => $_getN(4);
  @$pb.TagNumber(5)
  set role($1.RoomMemberRole value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearRole() => $_clearField(5);

  @$pb.TagNumber(7)
  RoomMemberListSortBy get sortBy => $_getN(5);
  @$pb.TagNumber(7)
  set sortBy(RoomMemberListSortBy value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortBy() => $_has(5);
  @$pb.TagNumber(7)
  void clearSortBy() => $_clearField(7);

  @$pb.TagNumber(8)
  SortDirection get sortDirection => $_getN(6);
  @$pb.TagNumber(8)
  set sortDirection(SortDirection value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSortDirection() => $_has(6);
  @$pb.TagNumber(8)
  void clearSortDirection() => $_clearField(8);
}

class GetRoomMembersResponse extends $pb.GeneratedMessage {
  factory GetRoomMembersResponse({
    $core.Iterable<$1.RoomMember>? members,
    $core.int? total,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    if (total != null) result.total = total;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<$1.RoomMember>(1, _omitFieldNames ? '' : 'members',
        subBuilder: $1.RoomMember.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
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
}

class AddMemberRequest extends $pb.GeneratedMessage {
  factory AddMemberRequest({
    $core.String? roomId,
    $core.String? userId,
    $1.RoomMemberRole? role,
    $core.bool? notify,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aE<$1.RoomMemberRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..aOB(4, _omitFieldNames ? '' : 'notify')
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

  @$pb.TagNumber(4)
  $core.bool get notify => $_getBF(3);
  @$pb.TagNumber(4)
  set notify($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNotify() => $_has(3);
  @$pb.TagNumber(4)
  void clearNotify() => $_clearField(4);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class UpdateMemberPermissionsRequest extends $pb.GeneratedMessage {
  factory UpdateMemberPermissionsRequest({
    $core.String? roomId,
    $core.String? userId,
    $1.RoomMemberRole? role,
    $fixnum.Int64? addedPermissions,
    $fixnum.Int64? removedPermissions,
    $fixnum.Int64? adminAddedPermissions,
    $fixnum.Int64? adminRemovedPermissions,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aE<$1.RoomMemberRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $1.RoomMemberRole.values)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'addedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'removedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'adminAddedPermissions', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'adminRemovedPermissions',
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

  @$pb.TagNumber(4)
  $fixnum.Int64 get addedPermissions => $_getI64(3);
  @$pb.TagNumber(4)
  set addedPermissions($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddedPermissions() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddedPermissions() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get removedPermissions => $_getI64(4);
  @$pb.TagNumber(5)
  set removedPermissions($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRemovedPermissions() => $_has(4);
  @$pb.TagNumber(5)
  void clearRemovedPermissions() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get adminAddedPermissions => $_getI64(5);
  @$pb.TagNumber(6)
  set adminAddedPermissions($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAdminAddedPermissions() => $_has(5);
  @$pb.TagNumber(6)
  void clearAdminAddedPermissions() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get adminRemovedPermissions => $_getI64(6);
  @$pb.TagNumber(7)
  set adminRemovedPermissions($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAdminRemovedPermissions() => $_has(6);
  @$pb.TagNumber(7)
  void clearAdminRemovedPermissions() => $_clearField(7);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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
    $core.String? roomId,
    $core.String? userId,
    $fixnum.Int64? kickCooldownSeconds,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aInt64(3, _omitFieldNames ? '' : 'kickCooldownSeconds')
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
  $fixnum.Int64 get kickCooldownSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set kickCooldownSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKickCooldownSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearKickCooldownSeconds() => $_clearField(3);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class AddAdminRequest extends $pb.GeneratedMessage {
  factory AddAdminRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  AddAdminRequest._();

  factory AddAdminRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAdminRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAdminRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminRequest copyWith(void Function(AddAdminRequest) updates) =>
      super.copyWith((message) => updates(message as AddAdminRequest))
          as AddAdminRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAdminRequest create() => AddAdminRequest._();
  @$core.override
  AddAdminRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddAdminRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAdminRequest>(create);
  static AddAdminRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class AddAdminResponse extends $pb.GeneratedMessage {
  factory AddAdminResponse({
    AdminUser? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  AddAdminResponse._();

  factory AddAdminResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAdminResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAdminResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<AdminUser>(1, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminResponse copyWith(void Function(AddAdminResponse) updates) =>
      super.copyWith((message) => updates(message as AddAdminResponse))
          as AddAdminResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAdminResponse create() => AddAdminResponse._();
  @$core.override
  AddAdminResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddAdminResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAdminResponse>(create);
  static AddAdminResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AdminUser get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(AdminUser value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  AdminUser ensureUser() => $_ensure(0);
}

class RemoveAdminRequest extends $pb.GeneratedMessage {
  factory RemoveAdminRequest({
    $core.String? userId,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    return result;
  }

  RemoveAdminRequest._();

  factory RemoveAdminRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveAdminRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveAdminRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAdminRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAdminRequest copyWith(void Function(RemoveAdminRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveAdminRequest))
          as RemoveAdminRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveAdminRequest create() => RemoveAdminRequest._();
  @$core.override
  RemoveAdminRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveAdminRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveAdminRequest>(create);
  static RemoveAdminRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);
}

class RemoveAdminResponse extends $pb.GeneratedMessage {
  factory RemoveAdminResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  RemoveAdminResponse._();

  factory RemoveAdminResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveAdminResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveAdminResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAdminResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveAdminResponse copyWith(void Function(RemoveAdminResponse) updates) =>
      super.copyWith((message) => updates(message as RemoveAdminResponse))
          as RemoveAdminResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveAdminResponse create() => RemoveAdminResponse._();
  @$core.override
  RemoveAdminResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveAdminResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveAdminResponse>(create);
  static RemoveAdminResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ListAdminsRequest extends $pb.GeneratedMessage {
  factory ListAdminsRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    UserListSortBy? sortBy,
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

  ListAdminsRequest._();

  factory ListAdminsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAdminsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAdminsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'search')
    ..aE<UserListSortBy>(4, _omitFieldNames ? '' : 'sortBy',
        enumValues: UserListSortBy.values)
    ..aE<SortDirection>(5, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdminsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdminsRequest copyWith(void Function(ListAdminsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAdminsRequest))
          as ListAdminsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAdminsRequest create() => ListAdminsRequest._();
  @$core.override
  ListAdminsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAdminsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAdminsRequest>(create);
  static ListAdminsRequest? _defaultInstance;

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
  UserListSortBy get sortBy => $_getN(3);
  @$pb.TagNumber(4)
  set sortBy(UserListSortBy value) => $_setField(4, value);
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

class ListAdminsResponse extends $pb.GeneratedMessage {
  factory ListAdminsResponse({
    $core.Iterable<AdminUser>? admins,
    $core.int? total,
  }) {
    final result = create();
    if (admins != null) result.admins.addAll(admins);
    if (total != null) result.total = total;
    return result;
  }

  ListAdminsResponse._();

  factory ListAdminsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAdminsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAdminsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<AdminUser>(1, _omitFieldNames ? '' : 'admins',
        subBuilder: AdminUser.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdminsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdminsResponse copyWith(void Function(ListAdminsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAdminsResponse))
          as ListAdminsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAdminsResponse create() => ListAdminsResponse._();
  @$core.override
  ListAdminsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAdminsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAdminsResponse>(create);
  static ListAdminsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AdminUser> get admins => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetSystemStatsRequest extends $pb.GeneratedMessage {
  factory GetSystemStatsRequest() => create();

  GetSystemStatsRequest._();

  factory GetSystemStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSystemStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSystemStatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSystemStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSystemStatsRequest copyWith(
          void Function(GetSystemStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSystemStatsRequest))
          as GetSystemStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSystemStatsRequest create() => GetSystemStatsRequest._();
  @$core.override
  GetSystemStatsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSystemStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSystemStatsRequest>(create);
  static GetSystemStatsRequest? _defaultInstance;
}

class GetSystemStatsResponse extends $pb.GeneratedMessage {
  factory GetSystemStatsResponse({
    $core.int? totalUsers,
    $core.int? activeUsers,
    $core.int? bannedUsers,
    $core.int? totalRooms,
    $core.int? activeRooms,
    $core.int? bannedRooms,
    $core.int? totalMedia,
    $core.int? providerInstances,
    $core.List<$core.int>? additionalStats,
  }) {
    final result = create();
    if (totalUsers != null) result.totalUsers = totalUsers;
    if (activeUsers != null) result.activeUsers = activeUsers;
    if (bannedUsers != null) result.bannedUsers = bannedUsers;
    if (totalRooms != null) result.totalRooms = totalRooms;
    if (activeRooms != null) result.activeRooms = activeRooms;
    if (bannedRooms != null) result.bannedRooms = bannedRooms;
    if (totalMedia != null) result.totalMedia = totalMedia;
    if (providerInstances != null) result.providerInstances = providerInstances;
    if (additionalStats != null) result.additionalStats = additionalStats;
    return result;
  }

  GetSystemStatsResponse._();

  factory GetSystemStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSystemStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSystemStatsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'totalUsers')
    ..aI(2, _omitFieldNames ? '' : 'activeUsers')
    ..aI(3, _omitFieldNames ? '' : 'bannedUsers')
    ..aI(4, _omitFieldNames ? '' : 'totalRooms')
    ..aI(5, _omitFieldNames ? '' : 'activeRooms')
    ..aI(6, _omitFieldNames ? '' : 'bannedRooms')
    ..aI(7, _omitFieldNames ? '' : 'totalMedia')
    ..aI(8, _omitFieldNames ? '' : 'providerInstances')
    ..a<$core.List<$core.int>>(
        9, _omitFieldNames ? '' : 'additionalStats', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSystemStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSystemStatsResponse copyWith(
          void Function(GetSystemStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetSystemStatsResponse))
          as GetSystemStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSystemStatsResponse create() => GetSystemStatsResponse._();
  @$core.override
  GetSystemStatsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSystemStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSystemStatsResponse>(create);
  static GetSystemStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalUsers => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalUsers($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalUsers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalUsers() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get activeUsers => $_getIZ(1);
  @$pb.TagNumber(2)
  set activeUsers($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveUsers() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveUsers() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get bannedUsers => $_getIZ(2);
  @$pb.TagNumber(3)
  set bannedUsers($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBannedUsers() => $_has(2);
  @$pb.TagNumber(3)
  void clearBannedUsers() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalRooms => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalRooms($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalRooms() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalRooms() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get activeRooms => $_getIZ(4);
  @$pb.TagNumber(5)
  set activeRooms($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActiveRooms() => $_has(4);
  @$pb.TagNumber(5)
  void clearActiveRooms() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get bannedRooms => $_getIZ(5);
  @$pb.TagNumber(6)
  set bannedRooms($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBannedRooms() => $_has(5);
  @$pb.TagNumber(6)
  void clearBannedRooms() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalMedia => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalMedia($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalMedia() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalMedia() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get providerInstances => $_getIZ(7);
  @$pb.TagNumber(8)
  set providerInstances($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProviderInstances() => $_has(7);
  @$pb.TagNumber(8)
  void clearProviderInstances() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get additionalStats => $_getN(8);
  @$pb.TagNumber(9)
  set additionalStats($core.List<$core.int> value) => $_setBytes(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAdditionalStats() => $_has(8);
  @$pb.TagNumber(9)
  void clearAdditionalStats() => $_clearField(9);
}

class ListActiveStreamsRequest extends $pb.GeneratedMessage {
  factory ListActiveStreamsRequest({
    $core.int? page,
    $core.int? pageSize,
    $core.String? roomId,
    $core.String? userId,
    $core.String? nodeId,
    $core.String? search,
    ActiveStreamListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (nodeId != null) result.nodeId = nodeId;
    if (search != null) result.search = search;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListActiveStreamsRequest._();

  factory ListActiveStreamsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListActiveStreamsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListActiveStreamsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'roomId')
    ..aOS(4, _omitFieldNames ? '' : 'userId')
    ..aOS(5, _omitFieldNames ? '' : 'nodeId')
    ..aOS(6, _omitFieldNames ? '' : 'search')
    ..aE<ActiveStreamListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: ActiveStreamListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActiveStreamsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActiveStreamsRequest copyWith(
          void Function(ListActiveStreamsRequest) updates) =>
      super.copyWith((message) => updates(message as ListActiveStreamsRequest))
          as ListActiveStreamsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListActiveStreamsRequest create() => ListActiveStreamsRequest._();
  @$core.override
  ListActiveStreamsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListActiveStreamsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListActiveStreamsRequest>(create);
  static ListActiveStreamsRequest? _defaultInstance;

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
  $core.String get roomId => $_getSZ(2);
  @$pb.TagNumber(3)
  set roomId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nodeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set nodeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNodeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearNodeId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get search => $_getSZ(5);
  @$pb.TagNumber(6)
  set search($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSearch() => $_has(5);
  @$pb.TagNumber(6)
  void clearSearch() => $_clearField(6);

  @$pb.TagNumber(7)
  ActiveStreamListSortBy get sortBy => $_getN(6);
  @$pb.TagNumber(7)
  set sortBy(ActiveStreamListSortBy value) => $_setField(7, value);
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

class ActiveStreamInfo extends $pb.GeneratedMessage {
  factory ActiveStreamInfo({
    $core.String? roomId,
    $core.String? mediaId,
    $core.String? userId,
    $core.String? nodeId,
    $fixnum.Int64? startedAt,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    if (userId != null) result.userId = userId;
    if (nodeId != null) result.nodeId = nodeId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  ActiveStreamInfo._();

  factory ActiveStreamInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ActiveStreamInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActiveStreamInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aOS(4, _omitFieldNames ? '' : 'nodeId')
    ..aInt64(5, _omitFieldNames ? '' : 'startedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActiveStreamInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActiveStreamInfo copyWith(void Function(ActiveStreamInfo) updates) =>
      super.copyWith((message) => updates(message as ActiveStreamInfo))
          as ActiveStreamInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActiveStreamInfo create() => ActiveStreamInfo._();
  @$core.override
  ActiveStreamInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ActiveStreamInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActiveStreamInfo>(create);
  static ActiveStreamInfo? _defaultInstance;

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
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get startedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set startedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartedAt() => $_clearField(5);
}

class ListActiveStreamsResponse extends $pb.GeneratedMessage {
  factory ListActiveStreamsResponse({
    $core.Iterable<ActiveStreamInfo>? streams,
    $core.int? total,
  }) {
    final result = create();
    if (streams != null) result.streams.addAll(streams);
    if (total != null) result.total = total;
    return result;
  }

  ListActiveStreamsResponse._();

  factory ListActiveStreamsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListActiveStreamsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListActiveStreamsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<ActiveStreamInfo>(1, _omitFieldNames ? '' : 'streams',
        subBuilder: ActiveStreamInfo.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActiveStreamsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListActiveStreamsResponse copyWith(
          void Function(ListActiveStreamsResponse) updates) =>
      super.copyWith((message) => updates(message as ListActiveStreamsResponse))
          as ListActiveStreamsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListActiveStreamsResponse create() => ListActiveStreamsResponse._();
  @$core.override
  ListActiveStreamsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListActiveStreamsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListActiveStreamsResponse>(create);
  static ListActiveStreamsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ActiveStreamInfo> get streams => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class KickStreamRequest extends $pb.GeneratedMessage {
  factory KickStreamRequest({
    $core.String? roomId,
    $core.String? mediaId,
    $core.String? reason,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    if (reason != null) result.reason = reason;
    return result;
  }

  KickStreamRequest._();

  factory KickStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickStreamRequest copyWith(void Function(KickStreamRequest) updates) =>
      super.copyWith((message) => updates(message as KickStreamRequest))
          as KickStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickStreamRequest create() => KickStreamRequest._();
  @$core.override
  KickStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickStreamRequest>(create);
  static KickStreamRequest? _defaultInstance;

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
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class KickStreamResponse extends $pb.GeneratedMessage {
  factory KickStreamResponse() => create();

  KickStreamResponse._();

  factory KickStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory KickStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KickStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KickStreamResponse copyWith(void Function(KickStreamResponse) updates) =>
      super.copyWith((message) => updates(message as KickStreamResponse))
          as KickStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KickStreamResponse create() => KickStreamResponse._();
  @$core.override
  KickStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static KickStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KickStreamResponse>(create);
  static KickStreamResponse? _defaultInstance;
}

/// Batch result for a single item
class BatchResultItem extends $pb.GeneratedMessage {
  factory BatchResultItem({
    $core.String? id,
    $core.bool? success,
    $core.String? error,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (success != null) result.success = success;
    if (error != null) result.error = error;
    return result;
  }

  BatchResultItem._();

  factory BatchResultItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchResultItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchResultItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchResultItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchResultItem copyWith(void Function(BatchResultItem) updates) =>
      super.copyWith((message) => updates(message as BatchResultItem))
          as BatchResultItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchResultItem create() => BatchResultItem._();
  @$core.override
  BatchResultItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchResultItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchResultItem>(create);
  static BatchResultItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

/// Batch ban users request
class BatchBanUsersRequest extends $pb.GeneratedMessage {
  factory BatchBanUsersRequest({
    $core.Iterable<$core.String>? userIds,
    $core.String? reason,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    if (reason != null) result.reason = reason;
    return result;
  }

  BatchBanUsersRequest._();

  factory BatchBanUsersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchBanUsersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchBanUsersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIds')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanUsersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanUsersRequest copyWith(void Function(BatchBanUsersRequest) updates) =>
      super.copyWith((message) => updates(message as BatchBanUsersRequest))
          as BatchBanUsersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchBanUsersRequest create() => BatchBanUsersRequest._();
  @$core.override
  BatchBanUsersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchBanUsersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchBanUsersRequest>(create);
  static BatchBanUsersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// Batch ban users response
class BatchBanUsersResponse extends $pb.GeneratedMessage {
  factory BatchBanUsersResponse({
    $core.Iterable<BatchResultItem>? results,
    $core.int? succeeded,
    $core.int? failed,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    if (succeeded != null) result.succeeded = succeeded;
    if (failed != null) result.failed = failed;
    return result;
  }

  BatchBanUsersResponse._();

  factory BatchBanUsersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchBanUsersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchBanUsersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<BatchResultItem>(1, _omitFieldNames ? '' : 'results',
        subBuilder: BatchResultItem.create)
    ..aI(2, _omitFieldNames ? '' : 'succeeded')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanUsersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanUsersResponse copyWith(
          void Function(BatchBanUsersResponse) updates) =>
      super.copyWith((message) => updates(message as BatchBanUsersResponse))
          as BatchBanUsersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchBanUsersResponse create() => BatchBanUsersResponse._();
  @$core.override
  BatchBanUsersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchBanUsersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchBanUsersResponse>(create);
  static BatchBanUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BatchResultItem> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get succeeded => $_getIZ(1);
  @$pb.TagNumber(2)
  set succeeded($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSucceeded() => $_has(1);
  @$pb.TagNumber(2)
  void clearSucceeded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);
}

/// Batch delete users request
class BatchDeleteUsersRequest extends $pb.GeneratedMessage {
  factory BatchDeleteUsersRequest({
    $core.Iterable<$core.String>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  BatchDeleteUsersRequest._();

  factory BatchDeleteUsersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchDeleteUsersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchDeleteUsersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteUsersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteUsersRequest copyWith(
          void Function(BatchDeleteUsersRequest) updates) =>
      super.copyWith((message) => updates(message as BatchDeleteUsersRequest))
          as BatchDeleteUsersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchDeleteUsersRequest create() => BatchDeleteUsersRequest._();
  @$core.override
  BatchDeleteUsersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchDeleteUsersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchDeleteUsersRequest>(create);
  static BatchDeleteUsersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIds => $_getList(0);
}

/// Batch delete users response
class BatchDeleteUsersResponse extends $pb.GeneratedMessage {
  factory BatchDeleteUsersResponse({
    $core.Iterable<BatchResultItem>? results,
    $core.int? succeeded,
    $core.int? failed,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    if (succeeded != null) result.succeeded = succeeded;
    if (failed != null) result.failed = failed;
    return result;
  }

  BatchDeleteUsersResponse._();

  factory BatchDeleteUsersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchDeleteUsersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchDeleteUsersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<BatchResultItem>(1, _omitFieldNames ? '' : 'results',
        subBuilder: BatchResultItem.create)
    ..aI(2, _omitFieldNames ? '' : 'succeeded')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteUsersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteUsersResponse copyWith(
          void Function(BatchDeleteUsersResponse) updates) =>
      super.copyWith((message) => updates(message as BatchDeleteUsersResponse))
          as BatchDeleteUsersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchDeleteUsersResponse create() => BatchDeleteUsersResponse._();
  @$core.override
  BatchDeleteUsersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchDeleteUsersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchDeleteUsersResponse>(create);
  static BatchDeleteUsersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BatchResultItem> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get succeeded => $_getIZ(1);
  @$pb.TagNumber(2)
  set succeeded($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSucceeded() => $_has(1);
  @$pb.TagNumber(2)
  void clearSucceeded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);
}

/// Batch ban rooms request
class BatchBanRoomsRequest extends $pb.GeneratedMessage {
  factory BatchBanRoomsRequest({
    $core.Iterable<$core.String>? roomIds,
    $core.String? reason,
  }) {
    final result = create();
    if (roomIds != null) result.roomIds.addAll(roomIds);
    if (reason != null) result.reason = reason;
    return result;
  }

  BatchBanRoomsRequest._();

  factory BatchBanRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchBanRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchBanRoomsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'roomIds')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanRoomsRequest copyWith(void Function(BatchBanRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as BatchBanRoomsRequest))
          as BatchBanRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchBanRoomsRequest create() => BatchBanRoomsRequest._();
  @$core.override
  BatchBanRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchBanRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchBanRoomsRequest>(create);
  static BatchBanRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get roomIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// Batch ban rooms response
class BatchBanRoomsResponse extends $pb.GeneratedMessage {
  factory BatchBanRoomsResponse({
    $core.Iterable<BatchResultItem>? results,
    $core.int? succeeded,
    $core.int? failed,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    if (succeeded != null) result.succeeded = succeeded;
    if (failed != null) result.failed = failed;
    return result;
  }

  BatchBanRoomsResponse._();

  factory BatchBanRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchBanRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchBanRoomsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<BatchResultItem>(1, _omitFieldNames ? '' : 'results',
        subBuilder: BatchResultItem.create)
    ..aI(2, _omitFieldNames ? '' : 'succeeded')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchBanRoomsResponse copyWith(
          void Function(BatchBanRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as BatchBanRoomsResponse))
          as BatchBanRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchBanRoomsResponse create() => BatchBanRoomsResponse._();
  @$core.override
  BatchBanRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchBanRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchBanRoomsResponse>(create);
  static BatchBanRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BatchResultItem> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get succeeded => $_getIZ(1);
  @$pb.TagNumber(2)
  set succeeded($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSucceeded() => $_has(1);
  @$pb.TagNumber(2)
  void clearSucceeded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);
}

class ListBanRecordsRequest extends $pb.GeneratedMessage {
  factory ListBanRecordsRequest({
    $core.int? page,
    $core.int? pageSize,
    BanTargetType? targetType,
    $core.bool? active,
    $core.String? userId,
    $core.String? roomId,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (targetType != null) result.targetType = targetType;
    if (active != null) result.active = active;
    if (userId != null) result.userId = userId;
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  ListBanRecordsRequest._();

  factory ListBanRecordsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBanRecordsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBanRecordsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<BanTargetType>(3, _omitFieldNames ? '' : 'targetType',
        enumValues: BanTargetType.values)
    ..aOB(4, _omitFieldNames ? '' : 'active')
    ..aOS(5, _omitFieldNames ? '' : 'userId')
    ..aOS(6, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBanRecordsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBanRecordsRequest copyWith(
          void Function(ListBanRecordsRequest) updates) =>
      super.copyWith((message) => updates(message as ListBanRecordsRequest))
          as ListBanRecordsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBanRecordsRequest create() => ListBanRecordsRequest._();
  @$core.override
  ListBanRecordsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBanRecordsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBanRecordsRequest>(create);
  static ListBanRecordsRequest? _defaultInstance;

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
  BanTargetType get targetType => $_getN(2);
  @$pb.TagNumber(3)
  set targetType(BanTargetType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get active => $_getBF(3);
  @$pb.TagNumber(4)
  set active($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActive() => $_has(3);
  @$pb.TagNumber(4)
  void clearActive() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userId => $_getSZ(4);
  @$pb.TagNumber(5)
  set userId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get roomId => $_getSZ(5);
  @$pb.TagNumber(6)
  set roomId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoomId() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoomId() => $_clearField(6);
}

class ListBanRecordsResponse extends $pb.GeneratedMessage {
  factory ListBanRecordsResponse({
    $core.Iterable<BanRecord>? bans,
    $core.int? total,
  }) {
    final result = create();
    if (bans != null) result.bans.addAll(bans);
    if (total != null) result.total = total;
    return result;
  }

  ListBanRecordsResponse._();

  factory ListBanRecordsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBanRecordsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBanRecordsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<BanRecord>(1, _omitFieldNames ? '' : 'bans',
        subBuilder: BanRecord.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBanRecordsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBanRecordsResponse copyWith(
          void Function(ListBanRecordsResponse) updates) =>
      super.copyWith((message) => updates(message as ListBanRecordsResponse))
          as ListBanRecordsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBanRecordsResponse create() => ListBanRecordsResponse._();
  @$core.override
  ListBanRecordsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBanRecordsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBanRecordsResponse>(create);
  static ListBanRecordsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BanRecord> get bans => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

/// Batch delete rooms request
class BatchDeleteRoomsRequest extends $pb.GeneratedMessage {
  factory BatchDeleteRoomsRequest({
    $core.Iterable<$core.String>? roomIds,
  }) {
    final result = create();
    if (roomIds != null) result.roomIds.addAll(roomIds);
    return result;
  }

  BatchDeleteRoomsRequest._();

  factory BatchDeleteRoomsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchDeleteRoomsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchDeleteRoomsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'roomIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteRoomsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteRoomsRequest copyWith(
          void Function(BatchDeleteRoomsRequest) updates) =>
      super.copyWith((message) => updates(message as BatchDeleteRoomsRequest))
          as BatchDeleteRoomsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchDeleteRoomsRequest create() => BatchDeleteRoomsRequest._();
  @$core.override
  BatchDeleteRoomsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchDeleteRoomsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchDeleteRoomsRequest>(create);
  static BatchDeleteRoomsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get roomIds => $_getList(0);
}

/// Batch delete rooms response
class BatchDeleteRoomsResponse extends $pb.GeneratedMessage {
  factory BatchDeleteRoomsResponse({
    $core.Iterable<BatchResultItem>? results,
    $core.int? succeeded,
    $core.int? failed,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    if (succeeded != null) result.succeeded = succeeded;
    if (failed != null) result.failed = failed;
    return result;
  }

  BatchDeleteRoomsResponse._();

  factory BatchDeleteRoomsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchDeleteRoomsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchDeleteRoomsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<BatchResultItem>(1, _omitFieldNames ? '' : 'results',
        subBuilder: BatchResultItem.create)
    ..aI(2, _omitFieldNames ? '' : 'succeeded')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteRoomsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchDeleteRoomsResponse copyWith(
          void Function(BatchDeleteRoomsResponse) updates) =>
      super.copyWith((message) => updates(message as BatchDeleteRoomsResponse))
          as BatchDeleteRoomsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchDeleteRoomsResponse create() => BatchDeleteRoomsResponse._();
  @$core.override
  BatchDeleteRoomsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchDeleteRoomsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchDeleteRoomsResponse>(create);
  static BatchDeleteRoomsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BatchResultItem> get results => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get succeeded => $_getIZ(1);
  @$pb.TagNumber(2)
  set succeeded($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSucceeded() => $_has(1);
  @$pb.TagNumber(2)
  void clearSucceeded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);
}

/// Admin API for SyncTV - Requires admin or root permissions
///
/// SECURITY: Several RPCs (CreateUser, UpdateUserPassword) transmit passwords as
/// plaintext. Deployments MUST use TLS. UpdateUserPassword operations should be
/// logged for audit compliance.
class AdminServiceApi {
  final $pb.RpcClient _client;

  AdminServiceApi(this._client);

  /// =========================
  /// System Settings Management
  /// =========================
  $async.Future<GetSettingsResponse> getSettings(
          $pb.ClientContext? ctx, GetSettingsRequest request) =>
      _client.invoke<GetSettingsResponse>(
          ctx, 'AdminService', 'GetSettings', request, GetSettingsResponse());
  $async.Future<GetSettingsGroupResponse> getSettingsGroup(
          $pb.ClientContext? ctx, GetSettingsGroupRequest request) =>
      _client.invoke<GetSettingsGroupResponse>(ctx, 'AdminService',
          'GetSettingsGroup', request, GetSettingsGroupResponse());
  $async.Future<UpdateSettingsResponse> updateSettings(
          $pb.ClientContext? ctx, UpdateSettingsRequest request) =>
      _client.invoke<UpdateSettingsResponse>(ctx, 'AdminService',
          'UpdateSettings', request, UpdateSettingsResponse());
  $async.Future<SendTestEmailResponse> sendTestEmail(
          $pb.ClientContext? ctx, SendTestEmailRequest request) =>
      _client.invoke<SendTestEmailResponse>(ctx, 'AdminService',
          'SendTestEmail', request, SendTestEmailResponse());

  /// =========================
  /// User Management
  /// =========================
  $async.Future<CreateUserResponse> createUser(
          $pb.ClientContext? ctx, CreateUserRequest request) =>
      _client.invoke<CreateUserResponse>(
          ctx, 'AdminService', 'CreateUser', request, CreateUserResponse());
  $async.Future<DeleteUserResponse> deleteUser(
          $pb.ClientContext? ctx, DeleteUserRequest request) =>
      _client.invoke<DeleteUserResponse>(
          ctx, 'AdminService', 'DeleteUser', request, DeleteUserResponse());
  $async.Future<ListUsersResponse> listUsers(
          $pb.ClientContext? ctx, ListUsersRequest request) =>
      _client.invoke<ListUsersResponse>(
          ctx, 'AdminService', 'ListUsers', request, ListUsersResponse());
  $async.Future<GetUserResponse> getUser(
          $pb.ClientContext? ctx, GetUserRequest request) =>
      _client.invoke<GetUserResponse>(
          ctx, 'AdminService', 'GetUser', request, GetUserResponse());
  $async.Future<GetUserPreferencesResponse> getUserPreferences(
          $pb.ClientContext? ctx, GetUserPreferencesRequest request) =>
      _client.invoke<GetUserPreferencesResponse>(ctx, 'AdminService',
          'GetUserPreferences', request, GetUserPreferencesResponse());
  $async.Future<UpdateUserPreferencesResponse> updateUserPreferences(
          $pb.ClientContext? ctx, UpdateUserPreferencesRequest request) =>
      _client.invoke<UpdateUserPreferencesResponse>(ctx, 'AdminService',
          'UpdateUserPreferences', request, UpdateUserPreferencesResponse());
  $async.Future<UpdateUserPasswordResponse> updateUserPassword(
          $pb.ClientContext? ctx, UpdateUserPasswordRequest request) =>
      _client.invoke<UpdateUserPasswordResponse>(ctx, 'AdminService',
          'UpdateUserPassword', request, UpdateUserPasswordResponse());
  $async.Future<UpdateUserUsernameResponse> updateUserUsername(
          $pb.ClientContext? ctx, UpdateUserUsernameRequest request) =>
      _client.invoke<UpdateUserUsernameResponse>(ctx, 'AdminService',
          'UpdateUserUsername', request, UpdateUserUsernameResponse());
  $async.Future<UpdateUserRoleResponse> updateUserRole(
          $pb.ClientContext? ctx, UpdateUserRoleRequest request) =>
      _client.invoke<UpdateUserRoleResponse>(ctx, 'AdminService',
          'UpdateUserRole', request, UpdateUserRoleResponse());
  $async.Future<BanUserResponse> banUser(
          $pb.ClientContext? ctx, BanUserRequest request) =>
      _client.invoke<BanUserResponse>(
          ctx, 'AdminService', 'BanUser', request, BanUserResponse());
  $async.Future<UnbanUserResponse> unbanUser(
          $pb.ClientContext? ctx, UnbanUserRequest request) =>
      _client.invoke<UnbanUserResponse>(
          ctx, 'AdminService', 'UnbanUser', request, UnbanUserResponse());
  $async.Future<GetUserRoomsResponse> getUserRooms(
          $pb.ClientContext? ctx, GetUserRoomsRequest request) =>
      _client.invoke<GetUserRoomsResponse>(
          ctx, 'AdminService', 'GetUserRooms', request, GetUserRoomsResponse());

  /// =========================
  /// Batch Operations
  /// =========================
  $async.Future<BatchBanUsersResponse> batchBanUsers(
          $pb.ClientContext? ctx, BatchBanUsersRequest request) =>
      _client.invoke<BatchBanUsersResponse>(ctx, 'AdminService',
          'BatchBanUsers', request, BatchBanUsersResponse());
  $async.Future<BatchDeleteUsersResponse> batchDeleteUsers(
          $pb.ClientContext? ctx, BatchDeleteUsersRequest request) =>
      _client.invoke<BatchDeleteUsersResponse>(ctx, 'AdminService',
          'BatchDeleteUsers', request, BatchDeleteUsersResponse());
  $async.Future<BatchBanRoomsResponse> batchBanRooms(
          $pb.ClientContext? ctx, BatchBanRoomsRequest request) =>
      _client.invoke<BatchBanRoomsResponse>(ctx, 'AdminService',
          'BatchBanRooms', request, BatchBanRoomsResponse());
  $async.Future<BatchDeleteRoomsResponse> batchDeleteRooms(
          $pb.ClientContext? ctx, BatchDeleteRoomsRequest request) =>
      _client.invoke<BatchDeleteRoomsResponse>(ctx, 'AdminService',
          'BatchDeleteRooms', request, BatchDeleteRoomsResponse());

  /// =========================
  /// Room Management
  /// =========================
  $async.Future<ListRoomsResponse> listRooms(
          $pb.ClientContext? ctx, ListRoomsRequest request) =>
      _client.invoke<ListRoomsResponse>(
          ctx, 'AdminService', 'ListRooms', request, ListRoomsResponse());
  $async.Future<GetRoomResponse> getRoom(
          $pb.ClientContext? ctx, GetRoomRequest request) =>
      _client.invoke<GetRoomResponse>(
          ctx, 'AdminService', 'GetRoom', request, GetRoomResponse());
  $async.Future<GetRoomSettingsResponse> getRoomSettings(
          $pb.ClientContext? ctx, GetRoomSettingsRequest request) =>
      _client.invoke<GetRoomSettingsResponse>(ctx, 'AdminService',
          'GetRoomSettings', request, GetRoomSettingsResponse());
  $async.Future<UpdateRoomSettingsResponse> updateRoomSettings(
          $pb.ClientContext? ctx, UpdateRoomSettingsRequest request) =>
      _client.invoke<UpdateRoomSettingsResponse>(ctx, 'AdminService',
          'UpdateRoomSettings', request, UpdateRoomSettingsResponse());
  $async.Future<ResetRoomSettingsResponse> resetRoomSettings(
          $pb.ClientContext? ctx, ResetRoomSettingsRequest request) =>
      _client.invoke<ResetRoomSettingsResponse>(ctx, 'AdminService',
          'ResetRoomSettings', request, ResetRoomSettingsResponse());
  $async.Future<UpdateRoomPasswordResponse> updateRoomPassword(
          $pb.ClientContext? ctx, UpdateRoomPasswordRequest request) =>
      _client.invoke<UpdateRoomPasswordResponse>(ctx, 'AdminService',
          'UpdateRoomPassword', request, UpdateRoomPasswordResponse());
  $async.Future<DeleteRoomResponse> deleteRoom(
          $pb.ClientContext? ctx, DeleteRoomRequest request) =>
      _client.invoke<DeleteRoomResponse>(
          ctx, 'AdminService', 'DeleteRoom', request, DeleteRoomResponse());
  $async.Future<BanRoomResponse> banRoom(
          $pb.ClientContext? ctx, BanRoomRequest request) =>
      _client.invoke<BanRoomResponse>(
          ctx, 'AdminService', 'BanRoom', request, BanRoomResponse());
  $async.Future<UnbanRoomResponse> unbanRoom(
          $pb.ClientContext? ctx, UnbanRoomRequest request) =>
      _client.invoke<UnbanRoomResponse>(
          ctx, 'AdminService', 'UnbanRoom', request, UnbanRoomResponse());
  $async.Future<GetRoomMembersResponse> getRoomMembers(
          $pb.ClientContext? ctx, GetRoomMembersRequest request) =>
      _client.invoke<GetRoomMembersResponse>(ctx, 'AdminService',
          'GetRoomMembers', request, GetRoomMembersResponse());
  $async.Future<AddMemberResponse> addMember(
          $pb.ClientContext? ctx, AddMemberRequest request) =>
      _client.invoke<AddMemberResponse>(
          ctx, 'AdminService', 'AddMember', request, AddMemberResponse());
  $async.Future<UpdateMemberPermissionsResponse> updateMemberPermissions(
          $pb.ClientContext? ctx, UpdateMemberPermissionsRequest request) =>
      _client.invoke<UpdateMemberPermissionsResponse>(
          ctx,
          'AdminService',
          'UpdateMemberPermissions',
          request,
          UpdateMemberPermissionsResponse());
  $async.Future<KickMemberResponse> kickMember(
          $pb.ClientContext? ctx, KickMemberRequest request) =>
      _client.invoke<KickMemberResponse>(
          ctx, 'AdminService', 'KickMember', request, KickMemberResponse());

  /// =========================
  /// Admin Management (Root Only)
  /// =========================
  $async.Future<AddAdminResponse> addAdmin(
          $pb.ClientContext? ctx, AddAdminRequest request) =>
      _client.invoke<AddAdminResponse>(
          ctx, 'AdminService', 'AddAdmin', request, AddAdminResponse());
  $async.Future<RemoveAdminResponse> removeAdmin(
          $pb.ClientContext? ctx, RemoveAdminRequest request) =>
      _client.invoke<RemoveAdminResponse>(
          ctx, 'AdminService', 'RemoveAdmin', request, RemoveAdminResponse());
  $async.Future<ListAdminsResponse> listAdmins(
          $pb.ClientContext? ctx, ListAdminsRequest request) =>
      _client.invoke<ListAdminsResponse>(
          ctx, 'AdminService', 'ListAdmins', request, ListAdminsResponse());

  /// =========================
  /// System Statistics
  /// =========================
  $async.Future<GetSystemStatsResponse> getSystemStats(
          $pb.ClientContext? ctx, GetSystemStatsRequest request) =>
      _client.invoke<GetSystemStatsResponse>(ctx, 'AdminService',
          'GetSystemStats', request, GetSystemStatsResponse());

  /// =========================
  /// Livestream Management
  /// =========================
  $async.Future<ListActiveStreamsResponse> listActiveStreams(
          $pb.ClientContext? ctx, ListActiveStreamsRequest request) =>
      _client.invoke<ListActiveStreamsResponse>(ctx, 'AdminService',
          'ListActiveStreams', request, ListActiveStreamsResponse());
  $async.Future<KickStreamResponse> kickStream(
          $pb.ClientContext? ctx, KickStreamRequest request) =>
      _client.invoke<KickStreamResponse>(
          ctx, 'AdminService', 'KickStream', request, KickStreamResponse());

  /// =========================
  /// Review Workflow
  /// =========================
  $async.Future<ListUserRegistrationReviewsResponse>
      listUserRegistrationReviews($pb.ClientContext? ctx,
              ListUserRegistrationReviewsRequest request) =>
          _client.invoke<ListUserRegistrationReviewsResponse>(
              ctx,
              'AdminService',
              'ListUserRegistrationReviews',
              request,
              ListUserRegistrationReviewsResponse());
  $async.Future<ApproveUserRegistrationReviewResponse>
      approveUserRegistrationReview($pb.ClientContext? ctx,
              ApproveUserRegistrationReviewRequest request) =>
          _client.invoke<ApproveUserRegistrationReviewResponse>(
              ctx,
              'AdminService',
              'ApproveUserRegistrationReview',
              request,
              ApproveUserRegistrationReviewResponse());
  $async.Future<RejectUserRegistrationReviewResponse>
      rejectUserRegistrationReview($pb.ClientContext? ctx,
              RejectUserRegistrationReviewRequest request) =>
          _client.invoke<RejectUserRegistrationReviewResponse>(
              ctx,
              'AdminService',
              'RejectUserRegistrationReview',
              request,
              RejectUserRegistrationReviewResponse());
  $async.Future<ListRoomCreationReviewsResponse> listRoomCreationReviews(
          $pb.ClientContext? ctx, ListRoomCreationReviewsRequest request) =>
      _client.invoke<ListRoomCreationReviewsResponse>(
          ctx,
          'AdminService',
          'ListRoomCreationReviews',
          request,
          ListRoomCreationReviewsResponse());
  $async.Future<ApproveRoomCreationReviewResponse> approveRoomCreationReview(
          $pb.ClientContext? ctx, ApproveRoomCreationReviewRequest request) =>
      _client.invoke<ApproveRoomCreationReviewResponse>(
          ctx,
          'AdminService',
          'ApproveRoomCreationReview',
          request,
          ApproveRoomCreationReviewResponse());
  $async.Future<RejectRoomCreationReviewResponse> rejectRoomCreationReview(
          $pb.ClientContext? ctx, RejectRoomCreationReviewRequest request) =>
      _client.invoke<RejectRoomCreationReviewResponse>(
          ctx,
          'AdminService',
          'RejectRoomCreationReview',
          request,
          RejectRoomCreationReviewResponse());
  $async.Future<ListRoomJoinReviewsResponse> listRoomJoinReviews(
          $pb.ClientContext? ctx, ListRoomJoinReviewsRequest request) =>
      _client.invoke<ListRoomJoinReviewsResponse>(ctx, 'AdminService',
          'ListRoomJoinReviews', request, ListRoomJoinReviewsResponse());
  $async.Future<ApproveRoomJoinReviewResponse> approveRoomJoinReview(
          $pb.ClientContext? ctx, ApproveRoomJoinReviewRequest request) =>
      _client.invoke<ApproveRoomJoinReviewResponse>(ctx, 'AdminService',
          'ApproveRoomJoinReview', request, ApproveRoomJoinReviewResponse());
  $async.Future<RejectRoomJoinReviewResponse> rejectRoomJoinReview(
          $pb.ClientContext? ctx, RejectRoomJoinReviewRequest request) =>
      _client.invoke<RejectRoomJoinReviewResponse>(ctx, 'AdminService',
          'RejectRoomJoinReview', request, RejectRoomJoinReviewResponse());

  /// =========================
  /// Moderation Bans
  /// =========================
  $async.Future<ListBanRecordsResponse> listBanRecords(
          $pb.ClientContext? ctx, ListBanRecordsRequest request) =>
      _client.invoke<ListBanRecordsResponse>(ctx, 'AdminService',
          'ListBanRecords', request, ListBanRecordsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
