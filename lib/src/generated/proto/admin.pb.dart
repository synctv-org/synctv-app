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
import 'package:protobuf/well_known_types/google/protobuf/field_mask.pb.dart'
    as $2;

import 'admin.pbenum.dart';
import 'client.pb.dart' as $1;
import 'common.pb.dart' as $0;
import 'oauth2.pbenum.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'admin.pbenum.dart';

class AdminUser extends $pb.GeneratedMessage {
  factory AdminUser({
    $core.String? id,
    $core.String? username,
    $core.String? email,
    $0.UserRole? role,
    $0.UserStatus? status,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $core.bool? isBanned,
    $fixnum.Int64? bannedAt,
    $core.String? bannedBy,
    $core.String? bannedReason,
    $core.String? avatarUrl,
    $0.UserPresenceStats? presence,
    $fixnum.Int64? deletedAt,
    $core.String? deletionReason,
    $fixnum.Int64? restoredAt,
    $core.String? deletionSource,
    $core.String? deletedBy,
    $core.String? restoredBy,
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
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (presence != null) result.presence = presence;
    if (deletedAt != null) result.deletedAt = deletedAt;
    if (deletionReason != null) result.deletionReason = deletionReason;
    if (restoredAt != null) result.restoredAt = restoredAt;
    if (deletionSource != null) result.deletionSource = deletionSource;
    if (deletedBy != null) result.deletedBy = deletedBy;
    if (restoredBy != null) result.restoredBy = restoredBy;
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
    ..aE<$0.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $0.UserRole.values)
    ..aE<$0.UserStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $0.UserStatus.values)
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(7, _omitFieldNames ? '' : 'updatedAt')
    ..aOB(8, _omitFieldNames ? '' : 'isBanned')
    ..aInt64(9, _omitFieldNames ? '' : 'bannedAt')
    ..aOS(10, _omitFieldNames ? '' : 'bannedBy')
    ..aOS(11, _omitFieldNames ? '' : 'bannedReason')
    ..aOS(12, _omitFieldNames ? '' : 'avatarUrl')
    ..aOM<$0.UserPresenceStats>(13, _omitFieldNames ? '' : 'presence',
        subBuilder: $0.UserPresenceStats.create)
    ..aInt64(14, _omitFieldNames ? '' : 'deletedAt')
    ..aOS(15, _omitFieldNames ? '' : 'deletionReason')
    ..aInt64(16, _omitFieldNames ? '' : 'restoredAt')
    ..aOS(17, _omitFieldNames ? '' : 'deletionSource')
    ..aOS(18, _omitFieldNames ? '' : 'deletedBy')
    ..aOS(19, _omitFieldNames ? '' : 'restoredBy')
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
  $0.UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role($0.UserRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.UserStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($0.UserStatus value) => $_setField(5, value);
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

  @$pb.TagNumber(12)
  $core.String get avatarUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set avatarUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAvatarUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearAvatarUrl() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.UserPresenceStats get presence => $_getN(12);
  @$pb.TagNumber(13)
  set presence($0.UserPresenceStats value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPresence() => $_has(12);
  @$pb.TagNumber(13)
  void clearPresence() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.UserPresenceStats ensurePresence() => $_ensure(12);

  @$pb.TagNumber(14)
  $fixnum.Int64 get deletedAt => $_getI64(13);
  @$pb.TagNumber(14)
  set deletedAt($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDeletedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeletedAt() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get deletionReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set deletionReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDeletionReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeletionReason() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get restoredAt => $_getI64(15);
  @$pb.TagNumber(16)
  set restoredAt($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRestoredAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearRestoredAt() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get deletionSource => $_getSZ(16);
  @$pb.TagNumber(17)
  set deletionSource($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDeletionSource() => $_has(16);
  @$pb.TagNumber(17)
  void clearDeletionSource() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get deletedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set deletedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasDeletedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearDeletedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get restoredBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set restoredBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasRestoredBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearRestoredBy() => $_clearField(19);
}

class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? id,
    $core.String? name,
    $core.String? creatorId,
    $core.String? creatorUsername,
    $0.RoomStatus? status,
    $1.RoomSettings? settings,
    $core.int? memberCount,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
    $core.String? description,
    $core.bool? isBanned,
    $0.UserStatus? creatorStatus,
    $fixnum.Int64? version,
    $0.RoomPresenceStats? presence,
    $core.String? creatorAvatarUrl,
    $1.ResourceCover? cover,
    $1.RoomCategory? category,
    $core.Iterable<$1.RoomLabel>? labels,
    $core.bool? isPublic,
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
    if (presence != null) result.presence = presence;
    if (creatorAvatarUrl != null) result.creatorAvatarUrl = creatorAvatarUrl;
    if (cover != null) result.cover = cover;
    if (category != null) result.category = category;
    if (labels != null) result.labels.addAll(labels);
    if (isPublic != null) result.isPublic = isPublic;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'creatorId')
    ..aOS(4, _omitFieldNames ? '' : 'creatorUsername')
    ..aE<$0.RoomStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $0.RoomStatus.values)
    ..aOM<$1.RoomSettings>(6, _omitFieldNames ? '' : 'settings',
        subBuilder: $1.RoomSettings.create)
    ..aI(7, _omitFieldNames ? '' : 'memberCount')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(9, _omitFieldNames ? '' : 'updatedAt')
    ..aOS(10, _omitFieldNames ? '' : 'description')
    ..aOB(11, _omitFieldNames ? '' : 'isBanned')
    ..aE<$0.UserStatus>(12, _omitFieldNames ? '' : 'creatorStatus',
        enumValues: $0.UserStatus.values)
    ..aInt64(13, _omitFieldNames ? '' : 'version')
    ..aOM<$0.RoomPresenceStats>(14, _omitFieldNames ? '' : 'presence',
        subBuilder: $0.RoomPresenceStats.create)
    ..aOS(15, _omitFieldNames ? '' : 'creatorAvatarUrl')
    ..aOM<$1.ResourceCover>(16, _omitFieldNames ? '' : 'cover',
        subBuilder: $1.ResourceCover.create)
    ..aOM<$1.RoomCategory>(17, _omitFieldNames ? '' : 'category',
        subBuilder: $1.RoomCategory.create)
    ..pPM<$1.RoomLabel>(18, _omitFieldNames ? '' : 'labels',
        subBuilder: $1.RoomLabel.create)
    ..aOB(19, _omitFieldNames ? '' : 'isPublic')
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
  $0.RoomStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($0.RoomStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.RoomSettings get settings => $_getN(5);
  @$pb.TagNumber(6)
  set settings($1.RoomSettings value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSettings() => $_has(5);
  @$pb.TagNumber(6)
  void clearSettings() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.RoomSettings ensureSettings() => $_ensure(5);

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
  $0.UserStatus get creatorStatus => $_getN(11);
  @$pb.TagNumber(12)
  set creatorStatus($0.UserStatus value) => $_setField(12, value);
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

  @$pb.TagNumber(14)
  $0.RoomPresenceStats get presence => $_getN(13);
  @$pb.TagNumber(14)
  set presence($0.RoomPresenceStats value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPresence() => $_has(13);
  @$pb.TagNumber(14)
  void clearPresence() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.RoomPresenceStats ensurePresence() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get creatorAvatarUrl => $_getSZ(14);
  @$pb.TagNumber(15)
  set creatorAvatarUrl($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatorAvatarUrl() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatorAvatarUrl() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.ResourceCover get cover => $_getN(15);
  @$pb.TagNumber(16)
  set cover($1.ResourceCover value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCover() => $_has(15);
  @$pb.TagNumber(16)
  void clearCover() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.ResourceCover ensureCover() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.RoomCategory get category => $_getN(16);
  @$pb.TagNumber(17)
  set category($1.RoomCategory value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCategory() => $_has(16);
  @$pb.TagNumber(17)
  void clearCategory() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.RoomCategory ensureCategory() => $_ensure(16);

  @$pb.TagNumber(18)
  $pb.PbList<$1.RoomLabel> get labels => $_getList(17);

  @$pb.TagNumber(19)
  $core.bool get isPublic => $_getBF(18);
  @$pb.TagNumber(19)
  set isPublic($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasIsPublic() => $_has(18);
  @$pb.TagNumber(19)
  void clearIsPublic() => $_clearField(19);
}

class RuntimeSettings extends $pb.GeneratedMessage {
  factory RuntimeSettings({
    RoomDefaultsSettings? roomDefaults,
    PermissionSettings? permissions,
    RoomCreationSettings? roomCreation,
    UserSettings? user,
    OAuth2Settings? oauth2,
    RtmpSettings? rtmp,
    EmailSettings? email,
    WebRTCSettings? webrtc,
    ChatSettings? chat,
    CorsSettings? cors,
    ServerSettings? server,
    PlaybackHistorySettings? playbackHistory,
  }) {
    final result = create();
    if (roomDefaults != null) result.roomDefaults = roomDefaults;
    if (permissions != null) result.permissions = permissions;
    if (roomCreation != null) result.roomCreation = roomCreation;
    if (user != null) result.user = user;
    if (oauth2 != null) result.oauth2 = oauth2;
    if (rtmp != null) result.rtmp = rtmp;
    if (email != null) result.email = email;
    if (webrtc != null) result.webrtc = webrtc;
    if (chat != null) result.chat = chat;
    if (cors != null) result.cors = cors;
    if (server != null) result.server = server;
    if (playbackHistory != null) result.playbackHistory = playbackHistory;
    return result;
  }

  RuntimeSettings._();

  factory RuntimeSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<RoomDefaultsSettings>(1, _omitFieldNames ? '' : 'roomDefaults',
        subBuilder: RoomDefaultsSettings.create)
    ..aOM<PermissionSettings>(2, _omitFieldNames ? '' : 'permissions',
        subBuilder: PermissionSettings.create)
    ..aOM<RoomCreationSettings>(3, _omitFieldNames ? '' : 'roomCreation',
        subBuilder: RoomCreationSettings.create)
    ..aOM<UserSettings>(4, _omitFieldNames ? '' : 'user',
        subBuilder: UserSettings.create)
    ..aOM<OAuth2Settings>(5, _omitFieldNames ? '' : 'oauth2',
        subBuilder: OAuth2Settings.create)
    ..aOM<RtmpSettings>(6, _omitFieldNames ? '' : 'rtmp',
        subBuilder: RtmpSettings.create)
    ..aOM<EmailSettings>(7, _omitFieldNames ? '' : 'email',
        subBuilder: EmailSettings.create)
    ..aOM<WebRTCSettings>(8, _omitFieldNames ? '' : 'webrtc',
        subBuilder: WebRTCSettings.create)
    ..aOM<ChatSettings>(9, _omitFieldNames ? '' : 'chat',
        subBuilder: ChatSettings.create)
    ..aOM<CorsSettings>(10, _omitFieldNames ? '' : 'cors',
        subBuilder: CorsSettings.create)
    ..aOM<ServerSettings>(11, _omitFieldNames ? '' : 'server',
        subBuilder: ServerSettings.create)
    ..aOM<PlaybackHistorySettings>(12, _omitFieldNames ? '' : 'playbackHistory',
        subBuilder: PlaybackHistorySettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettings copyWith(void Function(RuntimeSettings) updates) =>
      super.copyWith((message) => updates(message as RuntimeSettings))
          as RuntimeSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeSettings create() => RuntimeSettings._();
  @$core.override
  RuntimeSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeSettings>(create);
  static RuntimeSettings? _defaultInstance;

  @$pb.TagNumber(1)
  RoomDefaultsSettings get roomDefaults => $_getN(0);
  @$pb.TagNumber(1)
  set roomDefaults(RoomDefaultsSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomDefaults() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomDefaults() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomDefaultsSettings ensureRoomDefaults() => $_ensure(0);

  @$pb.TagNumber(2)
  PermissionSettings get permissions => $_getN(1);
  @$pb.TagNumber(2)
  set permissions(PermissionSettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPermissions() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissions() => $_clearField(2);
  @$pb.TagNumber(2)
  PermissionSettings ensurePermissions() => $_ensure(1);

  @$pb.TagNumber(3)
  RoomCreationSettings get roomCreation => $_getN(2);
  @$pb.TagNumber(3)
  set roomCreation(RoomCreationSettings value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomCreation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomCreation() => $_clearField(3);
  @$pb.TagNumber(3)
  RoomCreationSettings ensureRoomCreation() => $_ensure(2);

  @$pb.TagNumber(4)
  UserSettings get user => $_getN(3);
  @$pb.TagNumber(4)
  set user(UserSettings value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);
  @$pb.TagNumber(4)
  UserSettings ensureUser() => $_ensure(3);

  @$pb.TagNumber(5)
  OAuth2Settings get oauth2 => $_getN(4);
  @$pb.TagNumber(5)
  set oauth2(OAuth2Settings value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOauth2() => $_has(4);
  @$pb.TagNumber(5)
  void clearOauth2() => $_clearField(5);
  @$pb.TagNumber(5)
  OAuth2Settings ensureOauth2() => $_ensure(4);

  @$pb.TagNumber(6)
  RtmpSettings get rtmp => $_getN(5);
  @$pb.TagNumber(6)
  set rtmp(RtmpSettings value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRtmp() => $_has(5);
  @$pb.TagNumber(6)
  void clearRtmp() => $_clearField(6);
  @$pb.TagNumber(6)
  RtmpSettings ensureRtmp() => $_ensure(5);

  @$pb.TagNumber(7)
  EmailSettings get email => $_getN(6);
  @$pb.TagNumber(7)
  set email(EmailSettings value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearEmail() => $_clearField(7);
  @$pb.TagNumber(7)
  EmailSettings ensureEmail() => $_ensure(6);

  @$pb.TagNumber(8)
  WebRTCSettings get webrtc => $_getN(7);
  @$pb.TagNumber(8)
  set webrtc(WebRTCSettings value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWebrtc() => $_has(7);
  @$pb.TagNumber(8)
  void clearWebrtc() => $_clearField(8);
  @$pb.TagNumber(8)
  WebRTCSettings ensureWebrtc() => $_ensure(7);

  @$pb.TagNumber(9)
  ChatSettings get chat => $_getN(8);
  @$pb.TagNumber(9)
  set chat(ChatSettings value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasChat() => $_has(8);
  @$pb.TagNumber(9)
  void clearChat() => $_clearField(9);
  @$pb.TagNumber(9)
  ChatSettings ensureChat() => $_ensure(8);

  @$pb.TagNumber(10)
  CorsSettings get cors => $_getN(9);
  @$pb.TagNumber(10)
  set cors(CorsSettings value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCors() => $_has(9);
  @$pb.TagNumber(10)
  void clearCors() => $_clearField(10);
  @$pb.TagNumber(10)
  CorsSettings ensureCors() => $_ensure(9);

  @$pb.TagNumber(11)
  ServerSettings get server => $_getN(10);
  @$pb.TagNumber(11)
  set server(ServerSettings value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasServer() => $_has(10);
  @$pb.TagNumber(11)
  void clearServer() => $_clearField(11);
  @$pb.TagNumber(11)
  ServerSettings ensureServer() => $_ensure(10);

  @$pb.TagNumber(12)
  PlaybackHistorySettings get playbackHistory => $_getN(11);
  @$pb.TagNumber(12)
  set playbackHistory(PlaybackHistorySettings value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPlaybackHistory() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlaybackHistory() => $_clearField(12);
  @$pb.TagNumber(12)
  PlaybackHistorySettings ensurePlaybackHistory() => $_ensure(11);
}

/// Portable, versioned backup document for all database-backed runtime settings.
/// The document contains credentials and must be handled as a secret.
class RuntimeSettingsSnapshot extends $pb.GeneratedMessage {
  factory RuntimeSettingsSnapshot({
    $core.int? formatVersion,
    RuntimeSettings? settings,
  }) {
    final result = create();
    if (formatVersion != null) result.formatVersion = formatVersion;
    if (settings != null) result.settings = settings;
    return result;
  }

  RuntimeSettingsSnapshot._();

  factory RuntimeSettingsSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeSettingsSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeSettingsSnapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'formatVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..aOM<RuntimeSettings>(2, _omitFieldNames ? '' : 'settings',
        subBuilder: RuntimeSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettingsSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettingsSnapshot copyWith(
          void Function(RuntimeSettingsSnapshot) updates) =>
      super.copyWith((message) => updates(message as RuntimeSettingsSnapshot))
          as RuntimeSettingsSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeSettingsSnapshot create() => RuntimeSettingsSnapshot._();
  @$core.override
  RuntimeSettingsSnapshot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeSettingsSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeSettingsSnapshot>(create);
  static RuntimeSettingsSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get formatVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set formatVersion($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormatVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormatVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  RuntimeSettings get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings(RuntimeSettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => $_clearField(2);
  @$pb.TagNumber(2)
  RuntimeSettings ensureSettings() => $_ensure(1);
}

class ExportSettingsRequest extends $pb.GeneratedMessage {
  factory ExportSettingsRequest() => create();

  ExportSettingsRequest._();

  factory ExportSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExportSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportSettingsRequest copyWith(
          void Function(ExportSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as ExportSettingsRequest))
          as ExportSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportSettingsRequest create() => ExportSettingsRequest._();
  @$core.override
  ExportSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExportSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportSettingsRequest>(create);
  static ExportSettingsRequest? _defaultInstance;
}

class ImportSettingsRequest extends $pb.GeneratedMessage {
  factory ImportSettingsRequest({
    RuntimeSettingsSnapshot? snapshot,
    $core.bool? dryRun,
  }) {
    final result = create();
    if (snapshot != null) result.snapshot = snapshot;
    if (dryRun != null) result.dryRun = dryRun;
    return result;
  }

  ImportSettingsRequest._();

  factory ImportSettingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImportSettingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportSettingsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<RuntimeSettingsSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: RuntimeSettingsSnapshot.create)
    ..aOB(2, _omitFieldNames ? '' : 'dryRun')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSettingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSettingsRequest copyWith(
          void Function(ImportSettingsRequest) updates) =>
      super.copyWith((message) => updates(message as ImportSettingsRequest))
          as ImportSettingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportSettingsRequest create() => ImportSettingsRequest._();
  @$core.override
  ImportSettingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ImportSettingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportSettingsRequest>(create);
  static ImportSettingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeSettingsSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(RuntimeSettingsSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeSettingsSnapshot ensureSnapshot() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get dryRun => $_getBF(1);
  @$pb.TagNumber(2)
  set dryRun($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDryRun() => $_has(1);
  @$pb.TagNumber(2)
  void clearDryRun() => $_clearField(2);
}

class ImportSettingsResponse extends $pb.GeneratedMessage {
  factory ImportSettingsResponse({
    $core.bool? applied,
    $core.Iterable<$core.String>? changedSections,
  }) {
    final result = create();
    if (applied != null) result.applied = applied;
    if (changedSections != null) result.changedSections.addAll(changedSections);
    return result;
  }

  ImportSettingsResponse._();

  factory ImportSettingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImportSettingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImportSettingsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'applied')
    ..pPS(2, _omitFieldNames ? '' : 'changedSections')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSettingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImportSettingsResponse copyWith(
          void Function(ImportSettingsResponse) updates) =>
      super.copyWith((message) => updates(message as ImportSettingsResponse))
          as ImportSettingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportSettingsResponse create() => ImportSettingsResponse._();
  @$core.override
  ImportSettingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ImportSettingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImportSettingsResponse>(create);
  static ImportSettingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get applied => $_getBF(0);
  @$pb.TagNumber(1)
  set applied($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApplied() => $_has(0);
  @$pb.TagNumber(1)
  void clearApplied() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get changedSections => $_getList(1);
}

class ServerSettings extends $pb.GeneratedMessage {
  factory ServerSettings({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  ServerSettings._();

  factory ServerSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerSettings copyWith(void Function(ServerSettings) updates) =>
      super.copyWith((message) => updates(message as ServerSettings))
          as ServerSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerSettings create() => ServerSettings._();
  @$core.override
  ServerSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerSettings>(create);
  static ServerSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class RoomDefaultsSettings extends $pb.GeneratedMessage {
  factory RoomDefaultsSettings({
    $fixnum.Int64? defaultMaxMembers,
    $fixnum.Int64? defaultMaxChatMessages,
  }) {
    final result = create();
    if (defaultMaxMembers != null) result.defaultMaxMembers = defaultMaxMembers;
    if (defaultMaxChatMessages != null)
      result.defaultMaxChatMessages = defaultMaxChatMessages;
    return result;
  }

  RoomDefaultsSettings._();

  factory RoomDefaultsSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomDefaultsSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomDefaultsSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'defaultMaxMembers')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'defaultMaxChatMessages', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomDefaultsSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomDefaultsSettings copyWith(void Function(RoomDefaultsSettings) updates) =>
      super.copyWith((message) => updates(message as RoomDefaultsSettings))
          as RoomDefaultsSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomDefaultsSettings create() => RoomDefaultsSettings._();
  @$core.override
  RoomDefaultsSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomDefaultsSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomDefaultsSettings>(create);
  static RoomDefaultsSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get defaultMaxMembers => $_getI64(0);
  @$pb.TagNumber(1)
  set defaultMaxMembers($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDefaultMaxMembers() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefaultMaxMembers() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get defaultMaxChatMessages => $_getI64(1);
  @$pb.TagNumber(2)
  set defaultMaxChatMessages($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultMaxChatMessages() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultMaxChatMessages() => $_clearField(2);
}

class PermissionSettings extends $pb.GeneratedMessage {
  factory PermissionSettings({
    $fixnum.Int64? adminDefaultPermissions,
    $fixnum.Int64? memberDefaultPermissions,
    $fixnum.Int64? guestDefaultPermissions,
  }) {
    final result = create();
    if (adminDefaultPermissions != null)
      result.adminDefaultPermissions = adminDefaultPermissions;
    if (memberDefaultPermissions != null)
      result.memberDefaultPermissions = memberDefaultPermissions;
    if (guestDefaultPermissions != null)
      result.guestDefaultPermissions = guestDefaultPermissions;
    return result;
  }

  PermissionSettings._();

  factory PermissionSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'adminDefaultPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'memberDefaultPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'guestDefaultPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionSettings copyWith(void Function(PermissionSettings) updates) =>
      super.copyWith((message) => updates(message as PermissionSettings))
          as PermissionSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionSettings create() => PermissionSettings._();
  @$core.override
  PermissionSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionSettings>(create);
  static PermissionSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get adminDefaultPermissions => $_getI64(0);
  @$pb.TagNumber(1)
  set adminDefaultPermissions($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAdminDefaultPermissions() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdminDefaultPermissions() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get memberDefaultPermissions => $_getI64(1);
  @$pb.TagNumber(2)
  set memberDefaultPermissions($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMemberDefaultPermissions() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberDefaultPermissions() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get guestDefaultPermissions => $_getI64(2);
  @$pb.TagNumber(3)
  set guestDefaultPermissions($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGuestDefaultPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearGuestDefaultPermissions() => $_clearField(3);
}

class RoomCreationSettings extends $pb.GeneratedMessage {
  factory RoomCreationSettings({
    $core.bool? enabled,
    $core.bool? approvalRequired,
    $0.RoomPasswordPolicy? passwordPolicy,
    $fixnum.Int64? maxRoomsPerUser,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (approvalRequired != null) result.approvalRequired = approvalRequired;
    if (passwordPolicy != null) result.passwordPolicy = passwordPolicy;
    if (maxRoomsPerUser != null) result.maxRoomsPerUser = maxRoomsPerUser;
    return result;
  }

  RoomCreationSettings._();

  factory RoomCreationSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomCreationSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomCreationSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOB(2, _omitFieldNames ? '' : 'approvalRequired')
    ..aE<$0.RoomPasswordPolicy>(3, _omitFieldNames ? '' : 'passwordPolicy',
        enumValues: $0.RoomPasswordPolicy.values)
    ..aInt64(4, _omitFieldNames ? '' : 'maxRoomsPerUser')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCreationSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCreationSettings copyWith(void Function(RoomCreationSettings) updates) =>
      super.copyWith((message) => updates(message as RoomCreationSettings))
          as RoomCreationSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomCreationSettings create() => RoomCreationSettings._();
  @$core.override
  RoomCreationSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomCreationSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomCreationSettings>(create);
  static RoomCreationSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get approvalRequired => $_getBF(1);
  @$pb.TagNumber(2)
  set approvalRequired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApprovalRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovalRequired() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.RoomPasswordPolicy get passwordPolicy => $_getN(2);
  @$pb.TagNumber(3)
  set passwordPolicy($0.RoomPasswordPolicy value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPasswordPolicy() => $_has(2);
  @$pb.TagNumber(3)
  void clearPasswordPolicy() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get maxRoomsPerUser => $_getI64(3);
  @$pb.TagNumber(4)
  set maxRoomsPerUser($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxRoomsPerUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxRoomsPerUser() => $_clearField(4);
}

class UserSettings extends $pb.GeneratedMessage {
  factory UserSettings({
    $core.bool? enablePasswordSignup,
    $core.bool? passwordSignupNeedReview,
    $core.bool? enableEmailSignup,
    $core.bool? emailSignupNeedReview,
    $core.bool? enableWebauthnSignup,
    $core.bool? webauthnSignupNeedReview,
    $core.bool? enableGuest,
  }) {
    final result = create();
    if (enablePasswordSignup != null)
      result.enablePasswordSignup = enablePasswordSignup;
    if (passwordSignupNeedReview != null)
      result.passwordSignupNeedReview = passwordSignupNeedReview;
    if (enableEmailSignup != null) result.enableEmailSignup = enableEmailSignup;
    if (emailSignupNeedReview != null)
      result.emailSignupNeedReview = emailSignupNeedReview;
    if (enableWebauthnSignup != null)
      result.enableWebauthnSignup = enableWebauthnSignup;
    if (webauthnSignupNeedReview != null)
      result.webauthnSignupNeedReview = webauthnSignupNeedReview;
    if (enableGuest != null) result.enableGuest = enableGuest;
    return result;
  }

  UserSettings._();

  factory UserSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enablePasswordSignup')
    ..aOB(2, _omitFieldNames ? '' : 'passwordSignupNeedReview')
    ..aOB(3, _omitFieldNames ? '' : 'enableEmailSignup')
    ..aOB(4, _omitFieldNames ? '' : 'emailSignupNeedReview')
    ..aOB(5, _omitFieldNames ? '' : 'enableWebauthnSignup')
    ..aOB(6, _omitFieldNames ? '' : 'webauthnSignupNeedReview')
    ..aOB(7, _omitFieldNames ? '' : 'enableGuest')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettings copyWith(void Function(UserSettings) updates) =>
      super.copyWith((message) => updates(message as UserSettings))
          as UserSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserSettings create() => UserSettings._();
  @$core.override
  UserSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserSettings>(create);
  static UserSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enablePasswordSignup => $_getBF(0);
  @$pb.TagNumber(1)
  set enablePasswordSignup($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnablePasswordSignup() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnablePasswordSignup() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get passwordSignupNeedReview => $_getBF(1);
  @$pb.TagNumber(2)
  set passwordSignupNeedReview($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPasswordSignupNeedReview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPasswordSignupNeedReview() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get enableEmailSignup => $_getBF(2);
  @$pb.TagNumber(3)
  set enableEmailSignup($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnableEmailSignup() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnableEmailSignup() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get emailSignupNeedReview => $_getBF(3);
  @$pb.TagNumber(4)
  set emailSignupNeedReview($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmailSignupNeedReview() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmailSignupNeedReview() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get enableWebauthnSignup => $_getBF(4);
  @$pb.TagNumber(5)
  set enableWebauthnSignup($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnableWebauthnSignup() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnableWebauthnSignup() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get webauthnSignupNeedReview => $_getBF(5);
  @$pb.TagNumber(6)
  set webauthnSignupNeedReview($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWebauthnSignupNeedReview() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebauthnSignupNeedReview() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get enableGuest => $_getBF(6);
  @$pb.TagNumber(7)
  set enableGuest($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEnableGuest() => $_has(6);
  @$pb.TagNumber(7)
  void clearEnableGuest() => $_clearField(7);
}

class OAuth2Settings extends $pb.GeneratedMessage {
  factory OAuth2Settings({
    $core.Iterable<OAuth2ProviderSettings>? providers,
    $core.Iterable<$core.String>? allowedRedirectUrls,
  }) {
    final result = create();
    if (providers != null) result.providers.addAll(providers);
    if (allowedRedirectUrls != null)
      result.allowedRedirectUrls.addAll(allowedRedirectUrls);
    return result;
  }

  OAuth2Settings._();

  factory OAuth2Settings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2Settings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2Settings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<OAuth2ProviderSettings>(1, _omitFieldNames ? '' : 'providers',
        subBuilder: OAuth2ProviderSettings.create)
    ..pPS(2, _omitFieldNames ? '' : 'allowedRedirectUrls')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2Settings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2Settings copyWith(void Function(OAuth2Settings) updates) =>
      super.copyWith((message) => updates(message as OAuth2Settings))
          as OAuth2Settings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2Settings create() => OAuth2Settings._();
  @$core.override
  OAuth2Settings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2Settings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2Settings>(create);
  static OAuth2Settings? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OAuth2ProviderSettings> get providers => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get allowedRedirectUrls => $_getList(1);
}

enum OAuth2ProviderSettings_Config {
  qq,
  github,
  google,
  microsoft,
  discord,
  casdoor,
  logto,
  oidc,
  feishu,
  gitee,
  apple,
  notSet
}

class OAuth2ProviderSettings extends $pb.GeneratedMessage {
  factory OAuth2ProviderSettings({
    $core.String? name,
    $core.bool? enableSignup,
    $core.bool? signupNeedReview,
    OAuth2QqProviderConfig? qq,
    OAuth2GithubProviderConfig? github,
    OAuth2GoogleProviderConfig? google,
    OAuth2MicrosoftProviderConfig? microsoft,
    OAuth2DiscordProviderConfig? discord,
    OAuth2CasdoorProviderConfig? casdoor,
    OAuth2LogtoProviderConfig? logto,
    OAuth2OidcProviderConfig? oidc,
    OAuth2FeishuProviderConfig? feishu,
    OAuth2GiteeProviderConfig? gitee,
    OAuth2AppleProviderConfig? apple,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (enableSignup != null) result.enableSignup = enableSignup;
    if (signupNeedReview != null) result.signupNeedReview = signupNeedReview;
    if (qq != null) result.qq = qq;
    if (github != null) result.github = github;
    if (google != null) result.google = google;
    if (microsoft != null) result.microsoft = microsoft;
    if (discord != null) result.discord = discord;
    if (casdoor != null) result.casdoor = casdoor;
    if (logto != null) result.logto = logto;
    if (oidc != null) result.oidc = oidc;
    if (feishu != null) result.feishu = feishu;
    if (gitee != null) result.gitee = gitee;
    if (apple != null) result.apple = apple;
    return result;
  }

  OAuth2ProviderSettings._();

  factory OAuth2ProviderSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2ProviderSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, OAuth2ProviderSettings_Config>
      _OAuth2ProviderSettings_ConfigByTag = {
    4: OAuth2ProviderSettings_Config.qq,
    5: OAuth2ProviderSettings_Config.github,
    6: OAuth2ProviderSettings_Config.google,
    7: OAuth2ProviderSettings_Config.microsoft,
    8: OAuth2ProviderSettings_Config.discord,
    9: OAuth2ProviderSettings_Config.casdoor,
    10: OAuth2ProviderSettings_Config.logto,
    11: OAuth2ProviderSettings_Config.oidc,
    12: OAuth2ProviderSettings_Config.feishu,
    13: OAuth2ProviderSettings_Config.gitee,
    14: OAuth2ProviderSettings_Config.apple,
    0: OAuth2ProviderSettings_Config.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2ProviderSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOB(2, _omitFieldNames ? '' : 'enableSignup')
    ..aOB(3, _omitFieldNames ? '' : 'signupNeedReview')
    ..aOM<OAuth2QqProviderConfig>(4, _omitFieldNames ? '' : 'qq',
        subBuilder: OAuth2QqProviderConfig.create)
    ..aOM<OAuth2GithubProviderConfig>(5, _omitFieldNames ? '' : 'github',
        subBuilder: OAuth2GithubProviderConfig.create)
    ..aOM<OAuth2GoogleProviderConfig>(6, _omitFieldNames ? '' : 'google',
        subBuilder: OAuth2GoogleProviderConfig.create)
    ..aOM<OAuth2MicrosoftProviderConfig>(7, _omitFieldNames ? '' : 'microsoft',
        subBuilder: OAuth2MicrosoftProviderConfig.create)
    ..aOM<OAuth2DiscordProviderConfig>(8, _omitFieldNames ? '' : 'discord',
        subBuilder: OAuth2DiscordProviderConfig.create)
    ..aOM<OAuth2CasdoorProviderConfig>(9, _omitFieldNames ? '' : 'casdoor',
        subBuilder: OAuth2CasdoorProviderConfig.create)
    ..aOM<OAuth2LogtoProviderConfig>(10, _omitFieldNames ? '' : 'logto',
        subBuilder: OAuth2LogtoProviderConfig.create)
    ..aOM<OAuth2OidcProviderConfig>(11, _omitFieldNames ? '' : 'oidc',
        subBuilder: OAuth2OidcProviderConfig.create)
    ..aOM<OAuth2FeishuProviderConfig>(12, _omitFieldNames ? '' : 'feishu',
        subBuilder: OAuth2FeishuProviderConfig.create)
    ..aOM<OAuth2GiteeProviderConfig>(13, _omitFieldNames ? '' : 'gitee',
        subBuilder: OAuth2GiteeProviderConfig.create)
    ..aOM<OAuth2AppleProviderConfig>(14, _omitFieldNames ? '' : 'apple',
        subBuilder: OAuth2AppleProviderConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderSettings copyWith(
          void Function(OAuth2ProviderSettings) updates) =>
      super.copyWith((message) => updates(message as OAuth2ProviderSettings))
          as OAuth2ProviderSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderSettings create() => OAuth2ProviderSettings._();
  @$core.override
  OAuth2ProviderSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2ProviderSettings>(create);
  static OAuth2ProviderSettings? _defaultInstance;

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
  OAuth2ProviderSettings_Config whichConfig() =>
      _OAuth2ProviderSettings_ConfigByTag[$_whichOneof(0)]!;
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
  void clearConfig() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enableSignup => $_getBF(1);
  @$pb.TagNumber(2)
  set enableSignup($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnableSignup() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnableSignup() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get signupNeedReview => $_getBF(2);
  @$pb.TagNumber(3)
  set signupNeedReview($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignupNeedReview() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignupNeedReview() => $_clearField(3);

  @$pb.TagNumber(4)
  OAuth2QqProviderConfig get qq => $_getN(3);
  @$pb.TagNumber(4)
  set qq(OAuth2QqProviderConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQq() => $_has(3);
  @$pb.TagNumber(4)
  void clearQq() => $_clearField(4);
  @$pb.TagNumber(4)
  OAuth2QqProviderConfig ensureQq() => $_ensure(3);

  @$pb.TagNumber(5)
  OAuth2GithubProviderConfig get github => $_getN(4);
  @$pb.TagNumber(5)
  set github(OAuth2GithubProviderConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGithub() => $_has(4);
  @$pb.TagNumber(5)
  void clearGithub() => $_clearField(5);
  @$pb.TagNumber(5)
  OAuth2GithubProviderConfig ensureGithub() => $_ensure(4);

  @$pb.TagNumber(6)
  OAuth2GoogleProviderConfig get google => $_getN(5);
  @$pb.TagNumber(6)
  set google(OAuth2GoogleProviderConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGoogle() => $_has(5);
  @$pb.TagNumber(6)
  void clearGoogle() => $_clearField(6);
  @$pb.TagNumber(6)
  OAuth2GoogleProviderConfig ensureGoogle() => $_ensure(5);

  @$pb.TagNumber(7)
  OAuth2MicrosoftProviderConfig get microsoft => $_getN(6);
  @$pb.TagNumber(7)
  set microsoft(OAuth2MicrosoftProviderConfig value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMicrosoft() => $_has(6);
  @$pb.TagNumber(7)
  void clearMicrosoft() => $_clearField(7);
  @$pb.TagNumber(7)
  OAuth2MicrosoftProviderConfig ensureMicrosoft() => $_ensure(6);

  @$pb.TagNumber(8)
  OAuth2DiscordProviderConfig get discord => $_getN(7);
  @$pb.TagNumber(8)
  set discord(OAuth2DiscordProviderConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDiscord() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiscord() => $_clearField(8);
  @$pb.TagNumber(8)
  OAuth2DiscordProviderConfig ensureDiscord() => $_ensure(7);

  @$pb.TagNumber(9)
  OAuth2CasdoorProviderConfig get casdoor => $_getN(8);
  @$pb.TagNumber(9)
  set casdoor(OAuth2CasdoorProviderConfig value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCasdoor() => $_has(8);
  @$pb.TagNumber(9)
  void clearCasdoor() => $_clearField(9);
  @$pb.TagNumber(9)
  OAuth2CasdoorProviderConfig ensureCasdoor() => $_ensure(8);

  @$pb.TagNumber(10)
  OAuth2LogtoProviderConfig get logto => $_getN(9);
  @$pb.TagNumber(10)
  set logto(OAuth2LogtoProviderConfig value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLogto() => $_has(9);
  @$pb.TagNumber(10)
  void clearLogto() => $_clearField(10);
  @$pb.TagNumber(10)
  OAuth2LogtoProviderConfig ensureLogto() => $_ensure(9);

  @$pb.TagNumber(11)
  OAuth2OidcProviderConfig get oidc => $_getN(10);
  @$pb.TagNumber(11)
  set oidc(OAuth2OidcProviderConfig value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasOidc() => $_has(10);
  @$pb.TagNumber(11)
  void clearOidc() => $_clearField(11);
  @$pb.TagNumber(11)
  OAuth2OidcProviderConfig ensureOidc() => $_ensure(10);

  @$pb.TagNumber(12)
  OAuth2FeishuProviderConfig get feishu => $_getN(11);
  @$pb.TagNumber(12)
  set feishu(OAuth2FeishuProviderConfig value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasFeishu() => $_has(11);
  @$pb.TagNumber(12)
  void clearFeishu() => $_clearField(12);
  @$pb.TagNumber(12)
  OAuth2FeishuProviderConfig ensureFeishu() => $_ensure(11);

  @$pb.TagNumber(13)
  OAuth2GiteeProviderConfig get gitee => $_getN(12);
  @$pb.TagNumber(13)
  set gitee(OAuth2GiteeProviderConfig value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasGitee() => $_has(12);
  @$pb.TagNumber(13)
  void clearGitee() => $_clearField(13);
  @$pb.TagNumber(13)
  OAuth2GiteeProviderConfig ensureGitee() => $_ensure(12);

  @$pb.TagNumber(14)
  OAuth2AppleProviderConfig get apple => $_getN(13);
  @$pb.TagNumber(14)
  set apple(OAuth2AppleProviderConfig value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasApple() => $_has(13);
  @$pb.TagNumber(14)
  void clearApple() => $_clearField(14);
  @$pb.TagNumber(14)
  OAuth2AppleProviderConfig ensureApple() => $_ensure(13);
}

class OAuth2GithubProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2GithubProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    return result;
  }

  OAuth2GithubProviderConfig._();

  factory OAuth2GithubProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2GithubProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2GithubProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2GithubProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2GithubProviderConfig copyWith(
          void Function(OAuth2GithubProviderConfig) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2GithubProviderConfig))
          as OAuth2GithubProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2GithubProviderConfig create() => OAuth2GithubProviderConfig._();
  @$core.override
  OAuth2GithubProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2GithubProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2GithubProviderConfig>(create);
  static OAuth2GithubProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);
}

class OAuth2GoogleProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2GoogleProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    return result;
  }

  OAuth2GoogleProviderConfig._();

  factory OAuth2GoogleProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2GoogleProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2GoogleProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2GoogleProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2GoogleProviderConfig copyWith(
          void Function(OAuth2GoogleProviderConfig) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2GoogleProviderConfig))
          as OAuth2GoogleProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2GoogleProviderConfig create() => OAuth2GoogleProviderConfig._();
  @$core.override
  OAuth2GoogleProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2GoogleProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2GoogleProviderConfig>(create);
  static OAuth2GoogleProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);
}

class OAuth2LogtoProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2LogtoProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
    $core.String? endpoint,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    if (endpoint != null) result.endpoint = endpoint;
    return result;
  }

  OAuth2LogtoProviderConfig._();

  factory OAuth2LogtoProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2LogtoProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2LogtoProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2LogtoProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2LogtoProviderConfig copyWith(
          void Function(OAuth2LogtoProviderConfig) updates) =>
      super.copyWith((message) => updates(message as OAuth2LogtoProviderConfig))
          as OAuth2LogtoProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2LogtoProviderConfig create() => OAuth2LogtoProviderConfig._();
  @$core.override
  OAuth2LogtoProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2LogtoProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2LogtoProviderConfig>(create);
  static OAuth2LogtoProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set endpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndpoint() => $_clearField(3);
}

class OAuth2OidcProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2OidcProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
    $core.String? issuer,
    $core.String? authUrl,
    $core.String? tokenUrl,
    $core.String? userinfoUrl,
    $core.String? jwksUrl,
    $core.Iterable<$core.String>? scopes,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    if (issuer != null) result.issuer = issuer;
    if (authUrl != null) result.authUrl = authUrl;
    if (tokenUrl != null) result.tokenUrl = tokenUrl;
    if (userinfoUrl != null) result.userinfoUrl = userinfoUrl;
    if (jwksUrl != null) result.jwksUrl = jwksUrl;
    if (scopes != null) result.scopes.addAll(scopes);
    return result;
  }

  OAuth2OidcProviderConfig._();

  factory OAuth2OidcProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2OidcProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2OidcProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'issuer')
    ..aOS(4, _omitFieldNames ? '' : 'authUrl')
    ..aOS(5, _omitFieldNames ? '' : 'tokenUrl')
    ..aOS(6, _omitFieldNames ? '' : 'userinfoUrl')
    ..aOS(7, _omitFieldNames ? '' : 'jwksUrl')
    ..pPS(8, _omitFieldNames ? '' : 'scopes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2OidcProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2OidcProviderConfig copyWith(
          void Function(OAuth2OidcProviderConfig) updates) =>
      super.copyWith((message) => updates(message as OAuth2OidcProviderConfig))
          as OAuth2OidcProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2OidcProviderConfig create() => OAuth2OidcProviderConfig._();
  @$core.override
  OAuth2OidcProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2OidcProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2OidcProviderConfig>(create);
  static OAuth2OidcProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get issuer => $_getSZ(2);
  @$pb.TagNumber(3)
  set issuer($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuer() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuer() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set authUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get tokenUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set tokenUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTokenUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearTokenUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get userinfoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set userinfoUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUserinfoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUserinfoUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get jwksUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set jwksUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasJwksUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearJwksUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get scopes => $_getList(7);
}

class OAuth2CasdoorProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2CasdoorProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
    $core.String? issuer,
    $core.String? authUrl,
    $core.String? tokenUrl,
    $core.String? userinfoUrl,
    $core.String? jwksUrl,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    if (issuer != null) result.issuer = issuer;
    if (authUrl != null) result.authUrl = authUrl;
    if (tokenUrl != null) result.tokenUrl = tokenUrl;
    if (userinfoUrl != null) result.userinfoUrl = userinfoUrl;
    if (jwksUrl != null) result.jwksUrl = jwksUrl;
    return result;
  }

  OAuth2CasdoorProviderConfig._();

  factory OAuth2CasdoorProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2CasdoorProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2CasdoorProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'issuer')
    ..aOS(4, _omitFieldNames ? '' : 'authUrl')
    ..aOS(5, _omitFieldNames ? '' : 'tokenUrl')
    ..aOS(6, _omitFieldNames ? '' : 'userinfoUrl')
    ..aOS(7, _omitFieldNames ? '' : 'jwksUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2CasdoorProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2CasdoorProviderConfig copyWith(
          void Function(OAuth2CasdoorProviderConfig) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2CasdoorProviderConfig))
          as OAuth2CasdoorProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2CasdoorProviderConfig create() =>
      OAuth2CasdoorProviderConfig._();
  @$core.override
  OAuth2CasdoorProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2CasdoorProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2CasdoorProviderConfig>(create);
  static OAuth2CasdoorProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get issuer => $_getSZ(2);
  @$pb.TagNumber(3)
  set issuer($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuer() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuer() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set authUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get tokenUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set tokenUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTokenUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearTokenUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get userinfoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set userinfoUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUserinfoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUserinfoUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get jwksUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set jwksUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasJwksUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearJwksUrl() => $_clearField(7);
}

class OAuth2AppleProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2AppleProviderConfig({
    $core.String? webClientId,
    $core.String? webClientSecret,
    $core.String? nativeClientId,
    $core.String? nativeClientSecret,
  }) {
    final result = create();
    if (webClientId != null) result.webClientId = webClientId;
    if (webClientSecret != null) result.webClientSecret = webClientSecret;
    if (nativeClientId != null) result.nativeClientId = nativeClientId;
    if (nativeClientSecret != null)
      result.nativeClientSecret = nativeClientSecret;
    return result;
  }

  OAuth2AppleProviderConfig._();

  factory OAuth2AppleProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2AppleProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2AppleProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'webClientId')
    ..aOS(2, _omitFieldNames ? '' : 'webClientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'nativeClientId')
    ..aOS(4, _omitFieldNames ? '' : 'nativeClientSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2AppleProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2AppleProviderConfig copyWith(
          void Function(OAuth2AppleProviderConfig) updates) =>
      super.copyWith((message) => updates(message as OAuth2AppleProviderConfig))
          as OAuth2AppleProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2AppleProviderConfig create() => OAuth2AppleProviderConfig._();
  @$core.override
  OAuth2AppleProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2AppleProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2AppleProviderConfig>(create);
  static OAuth2AppleProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get webClientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set webClientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWebClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWebClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get webClientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set webClientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWebClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nativeClientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nativeClientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNativeClientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNativeClientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nativeClientSecret => $_getSZ(3);
  @$pb.TagNumber(4)
  set nativeClientSecret($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNativeClientSecret() => $_has(3);
  @$pb.TagNumber(4)
  void clearNativeClientSecret() => $_clearField(4);
}

class OAuth2QqProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2QqProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    return result;
  }

  OAuth2QqProviderConfig._();

  factory OAuth2QqProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2QqProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2QqProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2QqProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2QqProviderConfig copyWith(
          void Function(OAuth2QqProviderConfig) updates) =>
      super.copyWith((message) => updates(message as OAuth2QqProviderConfig))
          as OAuth2QqProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2QqProviderConfig create() => OAuth2QqProviderConfig._();
  @$core.override
  OAuth2QqProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2QqProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2QqProviderConfig>(create);
  static OAuth2QqProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);
}

class OAuth2MicrosoftProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2MicrosoftProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
    $core.String? tenant,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    if (tenant != null) result.tenant = tenant;
    return result;
  }

  OAuth2MicrosoftProviderConfig._();

  factory OAuth2MicrosoftProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2MicrosoftProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2MicrosoftProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'tenant')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2MicrosoftProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2MicrosoftProviderConfig copyWith(
          void Function(OAuth2MicrosoftProviderConfig) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2MicrosoftProviderConfig))
          as OAuth2MicrosoftProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2MicrosoftProviderConfig create() =>
      OAuth2MicrosoftProviderConfig._();
  @$core.override
  OAuth2MicrosoftProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2MicrosoftProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2MicrosoftProviderConfig>(create);
  static OAuth2MicrosoftProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tenant => $_getSZ(2);
  @$pb.TagNumber(3)
  set tenant($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTenant() => $_has(2);
  @$pb.TagNumber(3)
  void clearTenant() => $_clearField(3);
}

class OAuth2DiscordProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2DiscordProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    return result;
  }

  OAuth2DiscordProviderConfig._();

  factory OAuth2DiscordProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2DiscordProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2DiscordProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2DiscordProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2DiscordProviderConfig copyWith(
          void Function(OAuth2DiscordProviderConfig) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2DiscordProviderConfig))
          as OAuth2DiscordProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2DiscordProviderConfig create() =>
      OAuth2DiscordProviderConfig._();
  @$core.override
  OAuth2DiscordProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2DiscordProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2DiscordProviderConfig>(create);
  static OAuth2DiscordProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);
}

class OAuth2FeishuProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2FeishuProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
    $core.String? endpoint,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    if (endpoint != null) result.endpoint = endpoint;
    return result;
  }

  OAuth2FeishuProviderConfig._();

  factory OAuth2FeishuProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2FeishuProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2FeishuProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2FeishuProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2FeishuProviderConfig copyWith(
          void Function(OAuth2FeishuProviderConfig) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2FeishuProviderConfig))
          as OAuth2FeishuProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2FeishuProviderConfig create() => OAuth2FeishuProviderConfig._();
  @$core.override
  OAuth2FeishuProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2FeishuProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2FeishuProviderConfig>(create);
  static OAuth2FeishuProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set endpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndpoint() => $_clearField(3);
}

class OAuth2GiteeProviderConfig extends $pb.GeneratedMessage {
  factory OAuth2GiteeProviderConfig({
    $core.String? clientId,
    $core.String? clientSecret,
  }) {
    final result = create();
    if (clientId != null) result.clientId = clientId;
    if (clientSecret != null) result.clientSecret = clientSecret;
    return result;
  }

  OAuth2GiteeProviderConfig._();

  factory OAuth2GiteeProviderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2GiteeProviderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2GiteeProviderConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'clientId')
    ..aOS(2, _omitFieldNames ? '' : 'clientSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2GiteeProviderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2GiteeProviderConfig copyWith(
          void Function(OAuth2GiteeProviderConfig) updates) =>
      super.copyWith((message) => updates(message as OAuth2GiteeProviderConfig))
          as OAuth2GiteeProviderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2GiteeProviderConfig create() => OAuth2GiteeProviderConfig._();
  @$core.override
  OAuth2GiteeProviderConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2GiteeProviderConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2GiteeProviderConfig>(create);
  static OAuth2GiteeProviderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);
}

class RtmpSettings extends $pb.GeneratedMessage {
  factory RtmpSettings({
    $core.String? advertiseAddress,
    $core.bool? tsDisguisedAsPng,
  }) {
    final result = create();
    if (advertiseAddress != null) result.advertiseAddress = advertiseAddress;
    if (tsDisguisedAsPng != null) result.tsDisguisedAsPng = tsDisguisedAsPng;
    return result;
  }

  RtmpSettings._();

  factory RtmpSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'advertiseAddress')
    ..aOB(2, _omitFieldNames ? '' : 'tsDisguisedAsPng')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpSettings copyWith(void Function(RtmpSettings) updates) =>
      super.copyWith((message) => updates(message as RtmpSettings))
          as RtmpSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpSettings create() => RtmpSettings._();
  @$core.override
  RtmpSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpSettings>(create);
  static RtmpSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get advertiseAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set advertiseAddress($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAdvertiseAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdvertiseAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get tsDisguisedAsPng => $_getBF(1);
  @$pb.TagNumber(2)
  set tsDisguisedAsPng($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTsDisguisedAsPng() => $_has(1);
  @$pb.TagNumber(2)
  void clearTsDisguisedAsPng() => $_clearField(2);
}

class EmailSettings extends $pb.GeneratedMessage {
  factory EmailSettings({
    $core.bool? enabled,
    $core.String? smtpHost,
    $core.int? smtpPort,
    SmtpCredentials? smtpCredentials,
    SmtpProxy? smtpProxy,
    $core.bool? useTls,
    $core.String? fromEmail,
    $core.String? fromName,
    $core.bool? whitelistEnabled,
    $core.Iterable<$core.String>? whitelistDomains,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (smtpHost != null) result.smtpHost = smtpHost;
    if (smtpPort != null) result.smtpPort = smtpPort;
    if (smtpCredentials != null) result.smtpCredentials = smtpCredentials;
    if (smtpProxy != null) result.smtpProxy = smtpProxy;
    if (useTls != null) result.useTls = useTls;
    if (fromEmail != null) result.fromEmail = fromEmail;
    if (fromName != null) result.fromName = fromName;
    if (whitelistEnabled != null) result.whitelistEnabled = whitelistEnabled;
    if (whitelistDomains != null)
      result.whitelistDomains.addAll(whitelistDomains);
    return result;
  }

  EmailSettings._();

  factory EmailSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmailSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmailSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'smtpHost')
    ..aI(3, _omitFieldNames ? '' : 'smtpPort', fieldType: $pb.PbFieldType.OU3)
    ..aOM<SmtpCredentials>(4, _omitFieldNames ? '' : 'smtpCredentials',
        subBuilder: SmtpCredentials.create)
    ..aOM<SmtpProxy>(5, _omitFieldNames ? '' : 'smtpProxy',
        subBuilder: SmtpProxy.create)
    ..aOB(6, _omitFieldNames ? '' : 'useTls')
    ..aOS(7, _omitFieldNames ? '' : 'fromEmail')
    ..aOS(8, _omitFieldNames ? '' : 'fromName')
    ..aOB(9, _omitFieldNames ? '' : 'whitelistEnabled')
    ..pPS(10, _omitFieldNames ? '' : 'whitelistDomains')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmailSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmailSettings copyWith(void Function(EmailSettings) updates) =>
      super.copyWith((message) => updates(message as EmailSettings))
          as EmailSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmailSettings create() => EmailSettings._();
  @$core.override
  EmailSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmailSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmailSettings>(create);
  static EmailSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get smtpHost => $_getSZ(1);
  @$pb.TagNumber(2)
  set smtpHost($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSmtpHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearSmtpHost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get smtpPort => $_getIZ(2);
  @$pb.TagNumber(3)
  set smtpPort($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSmtpPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearSmtpPort() => $_clearField(3);

  @$pb.TagNumber(4)
  SmtpCredentials get smtpCredentials => $_getN(3);
  @$pb.TagNumber(4)
  set smtpCredentials(SmtpCredentials value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSmtpCredentials() => $_has(3);
  @$pb.TagNumber(4)
  void clearSmtpCredentials() => $_clearField(4);
  @$pb.TagNumber(4)
  SmtpCredentials ensureSmtpCredentials() => $_ensure(3);

  @$pb.TagNumber(5)
  SmtpProxy get smtpProxy => $_getN(4);
  @$pb.TagNumber(5)
  set smtpProxy(SmtpProxy value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSmtpProxy() => $_has(4);
  @$pb.TagNumber(5)
  void clearSmtpProxy() => $_clearField(5);
  @$pb.TagNumber(5)
  SmtpProxy ensureSmtpProxy() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get useTls => $_getBF(5);
  @$pb.TagNumber(6)
  set useTls($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUseTls() => $_has(5);
  @$pb.TagNumber(6)
  void clearUseTls() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get fromEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set fromEmail($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFromEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearFromEmail() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fromName => $_getSZ(7);
  @$pb.TagNumber(8)
  set fromName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFromName() => $_has(7);
  @$pb.TagNumber(8)
  void clearFromName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get whitelistEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set whitelistEnabled($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWhitelistEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearWhitelistEnabled() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get whitelistDomains => $_getList(9);
}

class SmtpCredentials extends $pb.GeneratedMessage {
  factory SmtpCredentials({
    $core.String? username,
    $core.String? password,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    return result;
  }

  SmtpCredentials._();

  factory SmtpCredentials.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmtpCredentials.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmtpCredentials',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmtpCredentials clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmtpCredentials copyWith(void Function(SmtpCredentials) updates) =>
      super.copyWith((message) => updates(message as SmtpCredentials))
          as SmtpCredentials;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmtpCredentials create() => SmtpCredentials._();
  @$core.override
  SmtpCredentials createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmtpCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmtpCredentials>(create);
  static SmtpCredentials? _defaultInstance;

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
}

class SmtpProxy extends $pb.GeneratedMessage {
  factory SmtpProxy({
    $core.String? url,
    SmtpCredentials? credentials,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (credentials != null) result.credentials = credentials;
    return result;
  }

  SmtpProxy._();

  factory SmtpProxy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmtpProxy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmtpProxy',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOM<SmtpCredentials>(2, _omitFieldNames ? '' : 'credentials',
        subBuilder: SmtpCredentials.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmtpProxy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmtpProxy copyWith(void Function(SmtpProxy) updates) =>
      super.copyWith((message) => updates(message as SmtpProxy)) as SmtpProxy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmtpProxy create() => SmtpProxy._();
  @$core.override
  SmtpProxy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SmtpProxy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SmtpProxy>(create);
  static SmtpProxy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  SmtpCredentials get credentials => $_getN(1);
  @$pb.TagNumber(2)
  set credentials(SmtpCredentials value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCredentials() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredentials() => $_clearField(2);
  @$pb.TagNumber(2)
  SmtpCredentials ensureCredentials() => $_ensure(1);
}

class WebRTCSettings extends $pb.GeneratedMessage {
  factory WebRTCSettings({
    $core.Iterable<$1.IceServer>? externalIceServers,
    $core.int? maxVoiceParticipantsPerRoom,
  }) {
    final result = create();
    if (externalIceServers != null)
      result.externalIceServers.addAll(externalIceServers);
    if (maxVoiceParticipantsPerRoom != null)
      result.maxVoiceParticipantsPerRoom = maxVoiceParticipantsPerRoom;
    return result;
  }

  WebRTCSettings._();

  factory WebRTCSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<$1.IceServer>(1, _omitFieldNames ? '' : 'externalIceServers',
        subBuilder: $1.IceServer.create)
    ..aI(2, _omitFieldNames ? '' : 'maxVoiceParticipantsPerRoom',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCSettings copyWith(void Function(WebRTCSettings) updates) =>
      super.copyWith((message) => updates(message as WebRTCSettings))
          as WebRTCSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCSettings create() => WebRTCSettings._();
  @$core.override
  WebRTCSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCSettings>(create);
  static WebRTCSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.IceServer> get externalIceServers => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get maxVoiceParticipantsPerRoom => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxVoiceParticipantsPerRoom($core.int value) =>
      $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxVoiceParticipantsPerRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxVoiceParticipantsPerRoom() => $_clearField(2);
}

class ChatSettings extends $pb.GeneratedMessage {
  factory ChatSettings({
    $fixnum.Int64? maxMessagesPerRoom,
    $fixnum.Int64? maxPinnedMessagesPerRoom,
    $fixnum.Int64? messageRetentionDays,
  }) {
    final result = create();
    if (maxMessagesPerRoom != null)
      result.maxMessagesPerRoom = maxMessagesPerRoom;
    if (maxPinnedMessagesPerRoom != null)
      result.maxPinnedMessagesPerRoom = maxPinnedMessagesPerRoom;
    if (messageRetentionDays != null)
      result.messageRetentionDays = messageRetentionDays;
    return result;
  }

  ChatSettings._();

  factory ChatSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'maxMessagesPerRoom', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'maxPinnedMessagesPerRoom',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(3, _omitFieldNames ? '' : 'messageRetentionDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSettings copyWith(void Function(ChatSettings) updates) =>
      super.copyWith((message) => updates(message as ChatSettings))
          as ChatSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatSettings create() => ChatSettings._();
  @$core.override
  ChatSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatSettings>(create);
  static ChatSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get maxMessagesPerRoom => $_getI64(0);
  @$pb.TagNumber(1)
  set maxMessagesPerRoom($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxMessagesPerRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxMessagesPerRoom() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxPinnedMessagesPerRoom => $_getI64(1);
  @$pb.TagNumber(2)
  set maxPinnedMessagesPerRoom($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxPinnedMessagesPerRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxPinnedMessagesPerRoom() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get messageRetentionDays => $_getI64(2);
  @$pb.TagNumber(3)
  set messageRetentionDays($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageRetentionDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageRetentionDays() => $_clearField(3);
}

class PlaybackHistorySettings extends $pb.GeneratedMessage {
  factory PlaybackHistorySettings({
    $core.int? retentionDays,
    $fixnum.Int64? maxEntriesPerRoom,
  }) {
    final result = create();
    if (retentionDays != null) result.retentionDays = retentionDays;
    if (maxEntriesPerRoom != null) result.maxEntriesPerRoom = maxEntriesPerRoom;
    return result;
  }

  PlaybackHistorySettings._();

  factory PlaybackHistorySettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackHistorySettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackHistorySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'retentionDays',
        fieldType: $pb.PbFieldType.OU3)
    ..aInt64(2, _omitFieldNames ? '' : 'maxEntriesPerRoom')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackHistorySettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackHistorySettings copyWith(
          void Function(PlaybackHistorySettings) updates) =>
      super.copyWith((message) => updates(message as PlaybackHistorySettings))
          as PlaybackHistorySettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackHistorySettings create() => PlaybackHistorySettings._();
  @$core.override
  PlaybackHistorySettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackHistorySettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackHistorySettings>(create);
  static PlaybackHistorySettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get retentionDays => $_getIZ(0);
  @$pb.TagNumber(1)
  set retentionDays($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRetentionDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearRetentionDays() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxEntriesPerRoom => $_getI64(1);
  @$pb.TagNumber(2)
  set maxEntriesPerRoom($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxEntriesPerRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxEntriesPerRoom() => $_clearField(2);
}

class CorsSettings extends $pb.GeneratedMessage {
  factory CorsSettings({
    $core.Iterable<$core.String>? allowedOrigins,
  }) {
    final result = create();
    if (allowedOrigins != null) result.allowedOrigins.addAll(allowedOrigins);
    return result;
  }

  CorsSettings._();

  factory CorsSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorsSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorsSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'allowedOrigins')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorsSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorsSettings copyWith(void Function(CorsSettings) updates) =>
      super.copyWith((message) => updates(message as CorsSettings))
          as CorsSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorsSettings create() => CorsSettings._();
  @$core.override
  CorsSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorsSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorsSettings>(create);
  static CorsSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get allowedOrigins => $_getList(0);
}

class UpdateSettingsRequest extends $pb.GeneratedMessage {
  factory UpdateSettingsRequest({
    RuntimeSettingsPatch? settings,
    $2.FieldMask? updateMask,
  }) {
    final result = create();
    if (settings != null) result.settings = settings;
    if (updateMask != null) result.updateMask = updateMask;
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
    ..aOM<RuntimeSettingsPatch>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: RuntimeSettingsPatch.create)
    ..aOM<$2.FieldMask>(2, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $2.FieldMask.create)
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
  RuntimeSettingsPatch get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings(RuntimeSettingsPatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeSettingsPatch ensureSettings() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.FieldMask get updateMask => $_getN(1);
  @$pb.TagNumber(2)
  set updateMask($2.FieldMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateMask() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.FieldMask ensureUpdateMask() => $_ensure(1);
}

class RuntimeSettingsPatch extends $pb.GeneratedMessage {
  factory RuntimeSettingsPatch({
    RoomDefaultsSettingsPatch? roomDefaults,
    PermissionSettingsPatch? permissions,
    RoomCreationSettingsPatch? roomCreation,
    UserSettingsPatch? user,
    OAuth2SettingsPatch? oauth2,
    RtmpSettingsPatch? rtmp,
    EmailSettingsPatch? email,
    WebRTCSettingsPatch? webrtc,
    ChatSettingsPatch? chat,
    CorsSettingsPatch? cors,
    ServerSettingsPatch? server,
    PlaybackHistorySettingsPatch? playbackHistory,
  }) {
    final result = create();
    if (roomDefaults != null) result.roomDefaults = roomDefaults;
    if (permissions != null) result.permissions = permissions;
    if (roomCreation != null) result.roomCreation = roomCreation;
    if (user != null) result.user = user;
    if (oauth2 != null) result.oauth2 = oauth2;
    if (rtmp != null) result.rtmp = rtmp;
    if (email != null) result.email = email;
    if (webrtc != null) result.webrtc = webrtc;
    if (chat != null) result.chat = chat;
    if (cors != null) result.cors = cors;
    if (server != null) result.server = server;
    if (playbackHistory != null) result.playbackHistory = playbackHistory;
    return result;
  }

  RuntimeSettingsPatch._();

  factory RuntimeSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<RoomDefaultsSettingsPatch>(1, _omitFieldNames ? '' : 'roomDefaults',
        subBuilder: RoomDefaultsSettingsPatch.create)
    ..aOM<PermissionSettingsPatch>(2, _omitFieldNames ? '' : 'permissions',
        subBuilder: PermissionSettingsPatch.create)
    ..aOM<RoomCreationSettingsPatch>(3, _omitFieldNames ? '' : 'roomCreation',
        subBuilder: RoomCreationSettingsPatch.create)
    ..aOM<UserSettingsPatch>(4, _omitFieldNames ? '' : 'user',
        subBuilder: UserSettingsPatch.create)
    ..aOM<OAuth2SettingsPatch>(5, _omitFieldNames ? '' : 'oauth2',
        subBuilder: OAuth2SettingsPatch.create)
    ..aOM<RtmpSettingsPatch>(6, _omitFieldNames ? '' : 'rtmp',
        subBuilder: RtmpSettingsPatch.create)
    ..aOM<EmailSettingsPatch>(7, _omitFieldNames ? '' : 'email',
        subBuilder: EmailSettingsPatch.create)
    ..aOM<WebRTCSettingsPatch>(8, _omitFieldNames ? '' : 'webrtc',
        subBuilder: WebRTCSettingsPatch.create)
    ..aOM<ChatSettingsPatch>(9, _omitFieldNames ? '' : 'chat',
        subBuilder: ChatSettingsPatch.create)
    ..aOM<CorsSettingsPatch>(10, _omitFieldNames ? '' : 'cors',
        subBuilder: CorsSettingsPatch.create)
    ..aOM<ServerSettingsPatch>(11, _omitFieldNames ? '' : 'server',
        subBuilder: ServerSettingsPatch.create)
    ..aOM<PlaybackHistorySettingsPatch>(
        12, _omitFieldNames ? '' : 'playbackHistory',
        subBuilder: PlaybackHistorySettingsPatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeSettingsPatch copyWith(void Function(RuntimeSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as RuntimeSettingsPatch))
          as RuntimeSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeSettingsPatch create() => RuntimeSettingsPatch._();
  @$core.override
  RuntimeSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeSettingsPatch>(create);
  static RuntimeSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  RoomDefaultsSettingsPatch get roomDefaults => $_getN(0);
  @$pb.TagNumber(1)
  set roomDefaults(RoomDefaultsSettingsPatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomDefaults() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomDefaults() => $_clearField(1);
  @$pb.TagNumber(1)
  RoomDefaultsSettingsPatch ensureRoomDefaults() => $_ensure(0);

  @$pb.TagNumber(2)
  PermissionSettingsPatch get permissions => $_getN(1);
  @$pb.TagNumber(2)
  set permissions(PermissionSettingsPatch value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPermissions() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermissions() => $_clearField(2);
  @$pb.TagNumber(2)
  PermissionSettingsPatch ensurePermissions() => $_ensure(1);

  @$pb.TagNumber(3)
  RoomCreationSettingsPatch get roomCreation => $_getN(2);
  @$pb.TagNumber(3)
  set roomCreation(RoomCreationSettingsPatch value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomCreation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomCreation() => $_clearField(3);
  @$pb.TagNumber(3)
  RoomCreationSettingsPatch ensureRoomCreation() => $_ensure(2);

  @$pb.TagNumber(4)
  UserSettingsPatch get user => $_getN(3);
  @$pb.TagNumber(4)
  set user(UserSettingsPatch value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);
  @$pb.TagNumber(4)
  UserSettingsPatch ensureUser() => $_ensure(3);

  @$pb.TagNumber(5)
  OAuth2SettingsPatch get oauth2 => $_getN(4);
  @$pb.TagNumber(5)
  set oauth2(OAuth2SettingsPatch value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOauth2() => $_has(4);
  @$pb.TagNumber(5)
  void clearOauth2() => $_clearField(5);
  @$pb.TagNumber(5)
  OAuth2SettingsPatch ensureOauth2() => $_ensure(4);

  @$pb.TagNumber(6)
  RtmpSettingsPatch get rtmp => $_getN(5);
  @$pb.TagNumber(6)
  set rtmp(RtmpSettingsPatch value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRtmp() => $_has(5);
  @$pb.TagNumber(6)
  void clearRtmp() => $_clearField(6);
  @$pb.TagNumber(6)
  RtmpSettingsPatch ensureRtmp() => $_ensure(5);

  @$pb.TagNumber(7)
  EmailSettingsPatch get email => $_getN(6);
  @$pb.TagNumber(7)
  set email(EmailSettingsPatch value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearEmail() => $_clearField(7);
  @$pb.TagNumber(7)
  EmailSettingsPatch ensureEmail() => $_ensure(6);

  @$pb.TagNumber(8)
  WebRTCSettingsPatch get webrtc => $_getN(7);
  @$pb.TagNumber(8)
  set webrtc(WebRTCSettingsPatch value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWebrtc() => $_has(7);
  @$pb.TagNumber(8)
  void clearWebrtc() => $_clearField(8);
  @$pb.TagNumber(8)
  WebRTCSettingsPatch ensureWebrtc() => $_ensure(7);

  @$pb.TagNumber(9)
  ChatSettingsPatch get chat => $_getN(8);
  @$pb.TagNumber(9)
  set chat(ChatSettingsPatch value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasChat() => $_has(8);
  @$pb.TagNumber(9)
  void clearChat() => $_clearField(9);
  @$pb.TagNumber(9)
  ChatSettingsPatch ensureChat() => $_ensure(8);

  @$pb.TagNumber(10)
  CorsSettingsPatch get cors => $_getN(9);
  @$pb.TagNumber(10)
  set cors(CorsSettingsPatch value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCors() => $_has(9);
  @$pb.TagNumber(10)
  void clearCors() => $_clearField(10);
  @$pb.TagNumber(10)
  CorsSettingsPatch ensureCors() => $_ensure(9);

  @$pb.TagNumber(11)
  ServerSettingsPatch get server => $_getN(10);
  @$pb.TagNumber(11)
  set server(ServerSettingsPatch value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasServer() => $_has(10);
  @$pb.TagNumber(11)
  void clearServer() => $_clearField(11);
  @$pb.TagNumber(11)
  ServerSettingsPatch ensureServer() => $_ensure(10);

  @$pb.TagNumber(12)
  PlaybackHistorySettingsPatch get playbackHistory => $_getN(11);
  @$pb.TagNumber(12)
  set playbackHistory(PlaybackHistorySettingsPatch value) =>
      $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPlaybackHistory() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlaybackHistory() => $_clearField(12);
  @$pb.TagNumber(12)
  PlaybackHistorySettingsPatch ensurePlaybackHistory() => $_ensure(11);
}

class ServerSettingsPatch extends $pb.GeneratedMessage {
  factory ServerSettingsPatch({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  ServerSettingsPatch._();

  factory ServerSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerSettingsPatch copyWith(void Function(ServerSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as ServerSettingsPatch))
          as ServerSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerSettingsPatch create() => ServerSettingsPatch._();
  @$core.override
  ServerSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerSettingsPatch>(create);
  static ServerSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class RoomDefaultsSettingsPatch extends $pb.GeneratedMessage {
  factory RoomDefaultsSettingsPatch({
    $fixnum.Int64? defaultMaxMembers,
    $fixnum.Int64? defaultMaxChatMessages,
  }) {
    final result = create();
    if (defaultMaxMembers != null) result.defaultMaxMembers = defaultMaxMembers;
    if (defaultMaxChatMessages != null)
      result.defaultMaxChatMessages = defaultMaxChatMessages;
    return result;
  }

  RoomDefaultsSettingsPatch._();

  factory RoomDefaultsSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomDefaultsSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomDefaultsSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'defaultMaxMembers')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'defaultMaxChatMessages', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomDefaultsSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomDefaultsSettingsPatch copyWith(
          void Function(RoomDefaultsSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as RoomDefaultsSettingsPatch))
          as RoomDefaultsSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomDefaultsSettingsPatch create() => RoomDefaultsSettingsPatch._();
  @$core.override
  RoomDefaultsSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomDefaultsSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomDefaultsSettingsPatch>(create);
  static RoomDefaultsSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get defaultMaxMembers => $_getI64(0);
  @$pb.TagNumber(1)
  set defaultMaxMembers($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDefaultMaxMembers() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefaultMaxMembers() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get defaultMaxChatMessages => $_getI64(1);
  @$pb.TagNumber(2)
  set defaultMaxChatMessages($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultMaxChatMessages() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultMaxChatMessages() => $_clearField(2);
}

class PermissionSettingsPatch extends $pb.GeneratedMessage {
  factory PermissionSettingsPatch({
    $fixnum.Int64? adminDefaultPermissions,
    $fixnum.Int64? memberDefaultPermissions,
    $fixnum.Int64? guestDefaultPermissions,
  }) {
    final result = create();
    if (adminDefaultPermissions != null)
      result.adminDefaultPermissions = adminDefaultPermissions;
    if (memberDefaultPermissions != null)
      result.memberDefaultPermissions = memberDefaultPermissions;
    if (guestDefaultPermissions != null)
      result.guestDefaultPermissions = guestDefaultPermissions;
    return result;
  }

  PermissionSettingsPatch._();

  factory PermissionSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PermissionSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PermissionSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'adminDefaultPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'memberDefaultPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'guestDefaultPermissions',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PermissionSettingsPatch copyWith(
          void Function(PermissionSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as PermissionSettingsPatch))
          as PermissionSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PermissionSettingsPatch create() => PermissionSettingsPatch._();
  @$core.override
  PermissionSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PermissionSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PermissionSettingsPatch>(create);
  static PermissionSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get adminDefaultPermissions => $_getI64(0);
  @$pb.TagNumber(1)
  set adminDefaultPermissions($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAdminDefaultPermissions() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdminDefaultPermissions() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get memberDefaultPermissions => $_getI64(1);
  @$pb.TagNumber(2)
  set memberDefaultPermissions($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMemberDefaultPermissions() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberDefaultPermissions() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get guestDefaultPermissions => $_getI64(2);
  @$pb.TagNumber(3)
  set guestDefaultPermissions($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGuestDefaultPermissions() => $_has(2);
  @$pb.TagNumber(3)
  void clearGuestDefaultPermissions() => $_clearField(3);
}

class RoomCreationSettingsPatch extends $pb.GeneratedMessage {
  factory RoomCreationSettingsPatch({
    $core.bool? enabled,
    $core.bool? approvalRequired,
    $0.RoomPasswordPolicy? passwordPolicy,
    $fixnum.Int64? maxRoomsPerUser,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (approvalRequired != null) result.approvalRequired = approvalRequired;
    if (passwordPolicy != null) result.passwordPolicy = passwordPolicy;
    if (maxRoomsPerUser != null) result.maxRoomsPerUser = maxRoomsPerUser;
    return result;
  }

  RoomCreationSettingsPatch._();

  factory RoomCreationSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomCreationSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomCreationSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOB(2, _omitFieldNames ? '' : 'approvalRequired')
    ..aE<$0.RoomPasswordPolicy>(3, _omitFieldNames ? '' : 'passwordPolicy',
        enumValues: $0.RoomPasswordPolicy.values)
    ..aInt64(4, _omitFieldNames ? '' : 'maxRoomsPerUser')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCreationSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomCreationSettingsPatch copyWith(
          void Function(RoomCreationSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as RoomCreationSettingsPatch))
          as RoomCreationSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomCreationSettingsPatch create() => RoomCreationSettingsPatch._();
  @$core.override
  RoomCreationSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomCreationSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoomCreationSettingsPatch>(create);
  static RoomCreationSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get approvalRequired => $_getBF(1);
  @$pb.TagNumber(2)
  set approvalRequired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApprovalRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovalRequired() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.RoomPasswordPolicy get passwordPolicy => $_getN(2);
  @$pb.TagNumber(3)
  set passwordPolicy($0.RoomPasswordPolicy value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPasswordPolicy() => $_has(2);
  @$pb.TagNumber(3)
  void clearPasswordPolicy() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get maxRoomsPerUser => $_getI64(3);
  @$pb.TagNumber(4)
  set maxRoomsPerUser($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxRoomsPerUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxRoomsPerUser() => $_clearField(4);
}

class UserSettingsPatch extends $pb.GeneratedMessage {
  factory UserSettingsPatch({
    $core.bool? enablePasswordSignup,
    $core.bool? passwordSignupNeedReview,
    $core.bool? enableEmailSignup,
    $core.bool? emailSignupNeedReview,
    $core.bool? enableWebauthnSignup,
    $core.bool? webauthnSignupNeedReview,
    $core.bool? enableGuest,
  }) {
    final result = create();
    if (enablePasswordSignup != null)
      result.enablePasswordSignup = enablePasswordSignup;
    if (passwordSignupNeedReview != null)
      result.passwordSignupNeedReview = passwordSignupNeedReview;
    if (enableEmailSignup != null) result.enableEmailSignup = enableEmailSignup;
    if (emailSignupNeedReview != null)
      result.emailSignupNeedReview = emailSignupNeedReview;
    if (enableWebauthnSignup != null)
      result.enableWebauthnSignup = enableWebauthnSignup;
    if (webauthnSignupNeedReview != null)
      result.webauthnSignupNeedReview = webauthnSignupNeedReview;
    if (enableGuest != null) result.enableGuest = enableGuest;
    return result;
  }

  UserSettingsPatch._();

  factory UserSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enablePasswordSignup')
    ..aOB(2, _omitFieldNames ? '' : 'passwordSignupNeedReview')
    ..aOB(3, _omitFieldNames ? '' : 'enableEmailSignup')
    ..aOB(4, _omitFieldNames ? '' : 'emailSignupNeedReview')
    ..aOB(5, _omitFieldNames ? '' : 'enableWebauthnSignup')
    ..aOB(6, _omitFieldNames ? '' : 'webauthnSignupNeedReview')
    ..aOB(7, _omitFieldNames ? '' : 'enableGuest')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettingsPatch copyWith(void Function(UserSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as UserSettingsPatch))
          as UserSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserSettingsPatch create() => UserSettingsPatch._();
  @$core.override
  UserSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserSettingsPatch>(create);
  static UserSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enablePasswordSignup => $_getBF(0);
  @$pb.TagNumber(1)
  set enablePasswordSignup($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnablePasswordSignup() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnablePasswordSignup() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get passwordSignupNeedReview => $_getBF(1);
  @$pb.TagNumber(2)
  set passwordSignupNeedReview($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPasswordSignupNeedReview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPasswordSignupNeedReview() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get enableEmailSignup => $_getBF(2);
  @$pb.TagNumber(3)
  set enableEmailSignup($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnableEmailSignup() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnableEmailSignup() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get emailSignupNeedReview => $_getBF(3);
  @$pb.TagNumber(4)
  set emailSignupNeedReview($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmailSignupNeedReview() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmailSignupNeedReview() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get enableWebauthnSignup => $_getBF(4);
  @$pb.TagNumber(5)
  set enableWebauthnSignup($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnableWebauthnSignup() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnableWebauthnSignup() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get webauthnSignupNeedReview => $_getBF(5);
  @$pb.TagNumber(6)
  set webauthnSignupNeedReview($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWebauthnSignupNeedReview() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebauthnSignupNeedReview() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get enableGuest => $_getBF(6);
  @$pb.TagNumber(7)
  set enableGuest($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEnableGuest() => $_has(6);
  @$pb.TagNumber(7)
  void clearEnableGuest() => $_clearField(7);
}

class OAuth2SettingsPatch extends $pb.GeneratedMessage {
  factory OAuth2SettingsPatch({
    $core.Iterable<OAuth2ProviderSettings>? providers,
    $core.Iterable<$core.String>? allowedRedirectUrls,
  }) {
    final result = create();
    if (providers != null) result.providers.addAll(providers);
    if (allowedRedirectUrls != null)
      result.allowedRedirectUrls.addAll(allowedRedirectUrls);
    return result;
  }

  OAuth2SettingsPatch._();

  factory OAuth2SettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2SettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2SettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<OAuth2ProviderSettings>(1, _omitFieldNames ? '' : 'providers',
        subBuilder: OAuth2ProviderSettings.create)
    ..pPS(2, _omitFieldNames ? '' : 'allowedRedirectUrls')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2SettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2SettingsPatch copyWith(void Function(OAuth2SettingsPatch) updates) =>
      super.copyWith((message) => updates(message as OAuth2SettingsPatch))
          as OAuth2SettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2SettingsPatch create() => OAuth2SettingsPatch._();
  @$core.override
  OAuth2SettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2SettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2SettingsPatch>(create);
  static OAuth2SettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OAuth2ProviderSettings> get providers => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get allowedRedirectUrls => $_getList(1);
}

class RtmpSettingsPatch extends $pb.GeneratedMessage {
  factory RtmpSettingsPatch({
    $core.String? advertiseAddress,
    $core.bool? tsDisguisedAsPng,
  }) {
    final result = create();
    if (advertiseAddress != null) result.advertiseAddress = advertiseAddress;
    if (tsDisguisedAsPng != null) result.tsDisguisedAsPng = tsDisguisedAsPng;
    return result;
  }

  RtmpSettingsPatch._();

  factory RtmpSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'advertiseAddress')
    ..aOB(2, _omitFieldNames ? '' : 'tsDisguisedAsPng')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpSettingsPatch copyWith(void Function(RtmpSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as RtmpSettingsPatch))
          as RtmpSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpSettingsPatch create() => RtmpSettingsPatch._();
  @$core.override
  RtmpSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpSettingsPatch>(create);
  static RtmpSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get advertiseAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set advertiseAddress($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAdvertiseAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdvertiseAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get tsDisguisedAsPng => $_getBF(1);
  @$pb.TagNumber(2)
  set tsDisguisedAsPng($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTsDisguisedAsPng() => $_has(1);
  @$pb.TagNumber(2)
  void clearTsDisguisedAsPng() => $_clearField(2);
}

class EmailSettingsPatch extends $pb.GeneratedMessage {
  factory EmailSettingsPatch({
    $core.bool? enabled,
    $core.String? smtpHost,
    $core.int? smtpPort,
    SmtpCredentials? smtpCredentials,
    SmtpProxy? smtpProxy,
    $core.bool? useTls,
    $core.String? fromEmail,
    $core.String? fromName,
    $core.bool? whitelistEnabled,
    $core.Iterable<$core.String>? whitelistDomains,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (smtpHost != null) result.smtpHost = smtpHost;
    if (smtpPort != null) result.smtpPort = smtpPort;
    if (smtpCredentials != null) result.smtpCredentials = smtpCredentials;
    if (smtpProxy != null) result.smtpProxy = smtpProxy;
    if (useTls != null) result.useTls = useTls;
    if (fromEmail != null) result.fromEmail = fromEmail;
    if (fromName != null) result.fromName = fromName;
    if (whitelistEnabled != null) result.whitelistEnabled = whitelistEnabled;
    if (whitelistDomains != null)
      result.whitelistDomains.addAll(whitelistDomains);
    return result;
  }

  EmailSettingsPatch._();

  factory EmailSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmailSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmailSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'smtpHost')
    ..aI(3, _omitFieldNames ? '' : 'smtpPort', fieldType: $pb.PbFieldType.OU3)
    ..aOM<SmtpCredentials>(4, _omitFieldNames ? '' : 'smtpCredentials',
        subBuilder: SmtpCredentials.create)
    ..aOM<SmtpProxy>(5, _omitFieldNames ? '' : 'smtpProxy',
        subBuilder: SmtpProxy.create)
    ..aOB(6, _omitFieldNames ? '' : 'useTls')
    ..aOS(7, _omitFieldNames ? '' : 'fromEmail')
    ..aOS(8, _omitFieldNames ? '' : 'fromName')
    ..aOB(9, _omitFieldNames ? '' : 'whitelistEnabled')
    ..pPS(10, _omitFieldNames ? '' : 'whitelistDomains')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmailSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmailSettingsPatch copyWith(void Function(EmailSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as EmailSettingsPatch))
          as EmailSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmailSettingsPatch create() => EmailSettingsPatch._();
  @$core.override
  EmailSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmailSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmailSettingsPatch>(create);
  static EmailSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get smtpHost => $_getSZ(1);
  @$pb.TagNumber(2)
  set smtpHost($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSmtpHost() => $_has(1);
  @$pb.TagNumber(2)
  void clearSmtpHost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get smtpPort => $_getIZ(2);
  @$pb.TagNumber(3)
  set smtpPort($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSmtpPort() => $_has(2);
  @$pb.TagNumber(3)
  void clearSmtpPort() => $_clearField(3);

  @$pb.TagNumber(4)
  SmtpCredentials get smtpCredentials => $_getN(3);
  @$pb.TagNumber(4)
  set smtpCredentials(SmtpCredentials value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSmtpCredentials() => $_has(3);
  @$pb.TagNumber(4)
  void clearSmtpCredentials() => $_clearField(4);
  @$pb.TagNumber(4)
  SmtpCredentials ensureSmtpCredentials() => $_ensure(3);

  @$pb.TagNumber(5)
  SmtpProxy get smtpProxy => $_getN(4);
  @$pb.TagNumber(5)
  set smtpProxy(SmtpProxy value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSmtpProxy() => $_has(4);
  @$pb.TagNumber(5)
  void clearSmtpProxy() => $_clearField(5);
  @$pb.TagNumber(5)
  SmtpProxy ensureSmtpProxy() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get useTls => $_getBF(5);
  @$pb.TagNumber(6)
  set useTls($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUseTls() => $_has(5);
  @$pb.TagNumber(6)
  void clearUseTls() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get fromEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set fromEmail($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFromEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearFromEmail() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fromName => $_getSZ(7);
  @$pb.TagNumber(8)
  set fromName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFromName() => $_has(7);
  @$pb.TagNumber(8)
  void clearFromName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get whitelistEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set whitelistEnabled($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWhitelistEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearWhitelistEnabled() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get whitelistDomains => $_getList(9);
}

class WebRTCSettingsPatch extends $pb.GeneratedMessage {
  factory WebRTCSettingsPatch({
    $core.Iterable<$1.IceServer>? externalIceServers,
    $core.int? maxVoiceParticipantsPerRoom,
  }) {
    final result = create();
    if (externalIceServers != null)
      result.externalIceServers.addAll(externalIceServers);
    if (maxVoiceParticipantsPerRoom != null)
      result.maxVoiceParticipantsPerRoom = maxVoiceParticipantsPerRoom;
    return result;
  }

  WebRTCSettingsPatch._();

  factory WebRTCSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WebRTCSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebRTCSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<$1.IceServer>(1, _omitFieldNames ? '' : 'externalIceServers',
        subBuilder: $1.IceServer.create)
    ..aI(2, _omitFieldNames ? '' : 'maxVoiceParticipantsPerRoom',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebRTCSettingsPatch copyWith(void Function(WebRTCSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as WebRTCSettingsPatch))
          as WebRTCSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WebRTCSettingsPatch create() => WebRTCSettingsPatch._();
  @$core.override
  WebRTCSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WebRTCSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebRTCSettingsPatch>(create);
  static WebRTCSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.IceServer> get externalIceServers => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get maxVoiceParticipantsPerRoom => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxVoiceParticipantsPerRoom($core.int value) =>
      $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxVoiceParticipantsPerRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxVoiceParticipantsPerRoom() => $_clearField(2);
}

class ChatSettingsPatch extends $pb.GeneratedMessage {
  factory ChatSettingsPatch({
    $fixnum.Int64? maxMessagesPerRoom,
    $fixnum.Int64? maxPinnedMessagesPerRoom,
    $fixnum.Int64? messageRetentionDays,
  }) {
    final result = create();
    if (maxMessagesPerRoom != null)
      result.maxMessagesPerRoom = maxMessagesPerRoom;
    if (maxPinnedMessagesPerRoom != null)
      result.maxPinnedMessagesPerRoom = maxPinnedMessagesPerRoom;
    if (messageRetentionDays != null)
      result.messageRetentionDays = messageRetentionDays;
    return result;
  }

  ChatSettingsPatch._();

  factory ChatSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChatSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'maxMessagesPerRoom', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'maxPinnedMessagesPerRoom',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(3, _omitFieldNames ? '' : 'messageRetentionDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatSettingsPatch copyWith(void Function(ChatSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as ChatSettingsPatch))
          as ChatSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatSettingsPatch create() => ChatSettingsPatch._();
  @$core.override
  ChatSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChatSettingsPatch>(create);
  static ChatSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get maxMessagesPerRoom => $_getI64(0);
  @$pb.TagNumber(1)
  set maxMessagesPerRoom($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxMessagesPerRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxMessagesPerRoom() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxPinnedMessagesPerRoom => $_getI64(1);
  @$pb.TagNumber(2)
  set maxPinnedMessagesPerRoom($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxPinnedMessagesPerRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxPinnedMessagesPerRoom() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get messageRetentionDays => $_getI64(2);
  @$pb.TagNumber(3)
  set messageRetentionDays($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageRetentionDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageRetentionDays() => $_clearField(3);
}

class PlaybackHistorySettingsPatch extends $pb.GeneratedMessage {
  factory PlaybackHistorySettingsPatch({
    $core.int? retentionDays,
    $fixnum.Int64? maxEntriesPerRoom,
  }) {
    final result = create();
    if (retentionDays != null) result.retentionDays = retentionDays;
    if (maxEntriesPerRoom != null) result.maxEntriesPerRoom = maxEntriesPerRoom;
    return result;
  }

  PlaybackHistorySettingsPatch._();

  factory PlaybackHistorySettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackHistorySettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackHistorySettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'retentionDays',
        fieldType: $pb.PbFieldType.OU3)
    ..aInt64(2, _omitFieldNames ? '' : 'maxEntriesPerRoom')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackHistorySettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackHistorySettingsPatch copyWith(
          void Function(PlaybackHistorySettingsPatch) updates) =>
      super.copyWith(
              (message) => updates(message as PlaybackHistorySettingsPatch))
          as PlaybackHistorySettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackHistorySettingsPatch create() =>
      PlaybackHistorySettingsPatch._();
  @$core.override
  PlaybackHistorySettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackHistorySettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackHistorySettingsPatch>(create);
  static PlaybackHistorySettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get retentionDays => $_getIZ(0);
  @$pb.TagNumber(1)
  set retentionDays($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRetentionDays() => $_has(0);
  @$pb.TagNumber(1)
  void clearRetentionDays() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxEntriesPerRoom => $_getI64(1);
  @$pb.TagNumber(2)
  set maxEntriesPerRoom($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxEntriesPerRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxEntriesPerRoom() => $_clearField(2);
}

class CorsSettingsPatch extends $pb.GeneratedMessage {
  factory CorsSettingsPatch({
    $core.Iterable<$core.String>? allowedOrigins,
  }) {
    final result = create();
    if (allowedOrigins != null) result.allowedOrigins.addAll(allowedOrigins);
    return result;
  }

  CorsSettingsPatch._();

  factory CorsSettingsPatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorsSettingsPatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorsSettingsPatch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'allowedOrigins')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorsSettingsPatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorsSettingsPatch copyWith(void Function(CorsSettingsPatch) updates) =>
      super.copyWith((message) => updates(message as CorsSettingsPatch))
          as CorsSettingsPatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorsSettingsPatch create() => CorsSettingsPatch._();
  @$core.override
  CorsSettingsPatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorsSettingsPatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorsSettingsPatch>(create);
  static CorsSettingsPatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get allowedOrigins => $_getList(0);
}

class UserRegistrationReview extends $pb.GeneratedMessage {
  factory UserRegistrationReview({
    $core.String? id,
    $core.String? username,
    $core.String? email,
    SignupMethod? signupMethod,
    $0.ReviewStatus? status,
    $fixnum.Int64? requestedAt,
    $fixnum.Int64? reviewedAt,
    $core.String? reviewedBy,
    $core.String? rejectionReason,
    $3.OAuth2ProviderType? oauth2Provider,
    $core.String? oauth2ProviderUserId,
    $core.String? oauth2ProviderUsername,
    $core.String? oauth2AvatarUrl,
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
    ..aE<SignupMethod>(4, _omitFieldNames ? '' : 'signupMethod',
        enumValues: SignupMethod.values)
    ..aE<$0.ReviewStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $0.ReviewStatus.values)
    ..aInt64(6, _omitFieldNames ? '' : 'requestedAt')
    ..aInt64(7, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(8, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(9, _omitFieldNames ? '' : 'rejectionReason')
    ..aE<$3.OAuth2ProviderType>(10, _omitFieldNames ? '' : 'oauth2Provider',
        enumValues: $3.OAuth2ProviderType.values)
    ..aOS(11, _omitFieldNames ? '' : 'oauth2ProviderUserId')
    ..aOS(12, _omitFieldNames ? '' : 'oauth2ProviderUsername')
    ..aOS(13, _omitFieldNames ? '' : 'oauth2AvatarUrl')
    ..aOS(14, _omitFieldNames ? '' : 'oauth2ProviderInstanceName')
    ..aOS(15, _omitFieldNames ? '' : 'oauth2ProviderIssuer')
    ..aOS(16, _omitFieldNames ? '' : 'webauthnCredentialId')
    ..aOS(17, _omitFieldNames ? '' : 'webauthnCredentialName')
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
  SignupMethod get signupMethod => $_getN(3);
  @$pb.TagNumber(4)
  set signupMethod(SignupMethod value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSignupMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignupMethod() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.ReviewStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($0.ReviewStatus value) => $_setField(5, value);
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
  $3.OAuth2ProviderType get oauth2Provider => $_getN(9);
  @$pb.TagNumber(10)
  set oauth2Provider($3.OAuth2ProviderType value) => $_setField(10, value);
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
  $core.String get oauth2ProviderInstanceName => $_getSZ(13);
  @$pb.TagNumber(14)
  set oauth2ProviderInstanceName($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOauth2ProviderInstanceName() => $_has(13);
  @$pb.TagNumber(14)
  void clearOauth2ProviderInstanceName() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get oauth2ProviderIssuer => $_getSZ(14);
  @$pb.TagNumber(15)
  set oauth2ProviderIssuer($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOauth2ProviderIssuer() => $_has(14);
  @$pb.TagNumber(15)
  void clearOauth2ProviderIssuer() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get webauthnCredentialId => $_getSZ(15);
  @$pb.TagNumber(16)
  set webauthnCredentialId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasWebauthnCredentialId() => $_has(15);
  @$pb.TagNumber(16)
  void clearWebauthnCredentialId() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get webauthnCredentialName => $_getSZ(16);
  @$pb.TagNumber(17)
  set webauthnCredentialName($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasWebauthnCredentialName() => $_has(16);
  @$pb.TagNumber(17)
  void clearWebauthnCredentialName() => $_clearField(17);
}

class RoomCreationReview extends $pb.GeneratedMessage {
  factory RoomCreationReview({
    $core.String? id,
    $core.String? requestedBy,
    $core.String? requestedByUsername,
    $core.String? name,
    $core.String? description,
    $0.ReviewStatus? status,
    $fixnum.Int64? requestedAt,
    $fixnum.Int64? reviewedAt,
    $core.String? reviewedBy,
    $core.String? rejectionReason,
    $1.RoomCategory? category,
    $core.Iterable<$1.RoomLabel>? labels,
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
    if (category != null) result.category = category;
    if (labels != null) result.labels.addAll(labels);
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
    ..aE<$0.ReviewStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: $0.ReviewStatus.values)
    ..aInt64(7, _omitFieldNames ? '' : 'requestedAt')
    ..aInt64(8, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(9, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(10, _omitFieldNames ? '' : 'rejectionReason')
    ..aOM<$1.RoomCategory>(11, _omitFieldNames ? '' : 'category',
        subBuilder: $1.RoomCategory.create)
    ..pPM<$1.RoomLabel>(12, _omitFieldNames ? '' : 'labels',
        subBuilder: $1.RoomLabel.create)
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
  $0.ReviewStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status($0.ReviewStatus value) => $_setField(6, value);
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

  @$pb.TagNumber(11)
  $1.RoomCategory get category => $_getN(10);
  @$pb.TagNumber(11)
  set category($1.RoomCategory value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCategory() => $_has(10);
  @$pb.TagNumber(11)
  void clearCategory() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.RoomCategory ensureCategory() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbList<$1.RoomLabel> get labels => $_getList(11);
}

class RoomJoinReview extends $pb.GeneratedMessage {
  factory RoomJoinReview({
    $core.String? id,
    $core.String? roomId,
    $core.String? roomName,
    $core.String? userId,
    $core.String? username,
    $0.RoomMemberRole? requestedRole,
    $0.ReviewStatus? status,
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
    ..aE<$0.RoomMemberRole>(6, _omitFieldNames ? '' : 'requestedRole',
        enumValues: $0.RoomMemberRole.values)
    ..aE<$0.ReviewStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: $0.ReviewStatus.values)
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
  $0.RoomMemberRole get requestedRole => $_getN(5);
  @$pb.TagNumber(6)
  set requestedRole($0.RoomMemberRole value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestedRole() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestedRole() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.ReviewStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status($0.ReviewStatus value) => $_setField(7, value);
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

class ContentReport extends $pb.GeneratedMessage {
  factory ContentReport({
    $core.String? id,
    $core.String? reporterUserId,
    $core.String? reporterUsername,
    $core.String? roomId,
    $core.String? roomName,
    ContentReportTargetType? targetType,
    $core.String? targetRoomId,
    $core.String? targetRoomName,
    $core.String? targetUserId,
    $core.String? targetUsername,
    $core.String? targetMemberRoomId,
    $core.String? targetMemberRoomName,
    $core.String? targetMemberUserId,
    $core.String? targetMemberUsername,
    $fixnum.Int64? targetChatMessageId,
    $fixnum.Int64? targetChatMessageCreatedAt,
    $core.String? targetChatMessagePreview,
    $core.String? reasonCode,
    $core.String? reason,
    $1.ContentReportMetadata? metadata,
    ContentReportStatus? status,
    $core.String? reviewedBy,
    $core.String? reviewedByUsername,
    $fixnum.Int64? reviewedAt,
    $core.String? resolutionNote,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (reporterUserId != null) result.reporterUserId = reporterUserId;
    if (reporterUsername != null) result.reporterUsername = reporterUsername;
    if (roomId != null) result.roomId = roomId;
    if (roomName != null) result.roomName = roomName;
    if (targetType != null) result.targetType = targetType;
    if (targetRoomId != null) result.targetRoomId = targetRoomId;
    if (targetRoomName != null) result.targetRoomName = targetRoomName;
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (targetUsername != null) result.targetUsername = targetUsername;
    if (targetMemberRoomId != null)
      result.targetMemberRoomId = targetMemberRoomId;
    if (targetMemberRoomName != null)
      result.targetMemberRoomName = targetMemberRoomName;
    if (targetMemberUserId != null)
      result.targetMemberUserId = targetMemberUserId;
    if (targetMemberUsername != null)
      result.targetMemberUsername = targetMemberUsername;
    if (targetChatMessageId != null)
      result.targetChatMessageId = targetChatMessageId;
    if (targetChatMessageCreatedAt != null)
      result.targetChatMessageCreatedAt = targetChatMessageCreatedAt;
    if (targetChatMessagePreview != null)
      result.targetChatMessagePreview = targetChatMessagePreview;
    if (reasonCode != null) result.reasonCode = reasonCode;
    if (reason != null) result.reason = reason;
    if (metadata != null) result.metadata = metadata;
    if (status != null) result.status = status;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedByUsername != null)
      result.reviewedByUsername = reviewedByUsername;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (resolutionNote != null) result.resolutionNote = resolutionNote;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ContentReport._();

  factory ContentReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContentReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContentReport',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'reporterUserId')
    ..aOS(3, _omitFieldNames ? '' : 'reporterUsername')
    ..aOS(4, _omitFieldNames ? '' : 'roomId')
    ..aOS(5, _omitFieldNames ? '' : 'roomName')
    ..aE<ContentReportTargetType>(6, _omitFieldNames ? '' : 'targetType',
        enumValues: ContentReportTargetType.values)
    ..aOS(7, _omitFieldNames ? '' : 'targetRoomId')
    ..aOS(8, _omitFieldNames ? '' : 'targetRoomName')
    ..aOS(9, _omitFieldNames ? '' : 'targetUserId')
    ..aOS(10, _omitFieldNames ? '' : 'targetUsername')
    ..aOS(11, _omitFieldNames ? '' : 'targetMemberRoomId')
    ..aOS(12, _omitFieldNames ? '' : 'targetMemberRoomName')
    ..aOS(13, _omitFieldNames ? '' : 'targetMemberUserId')
    ..aOS(14, _omitFieldNames ? '' : 'targetMemberUsername')
    ..aInt64(15, _omitFieldNames ? '' : 'targetChatMessageId')
    ..aInt64(16, _omitFieldNames ? '' : 'targetChatMessageCreatedAt')
    ..aOS(17, _omitFieldNames ? '' : 'targetChatMessagePreview')
    ..aOS(18, _omitFieldNames ? '' : 'reasonCode')
    ..aOS(19, _omitFieldNames ? '' : 'reason')
    ..aOM<$1.ContentReportMetadata>(20, _omitFieldNames ? '' : 'metadata',
        subBuilder: $1.ContentReportMetadata.create)
    ..aE<ContentReportStatus>(21, _omitFieldNames ? '' : 'status',
        enumValues: ContentReportStatus.values)
    ..aOS(22, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(23, _omitFieldNames ? '' : 'reviewedByUsername')
    ..aInt64(24, _omitFieldNames ? '' : 'reviewedAt')
    ..aOS(25, _omitFieldNames ? '' : 'resolutionNote')
    ..aInt64(26, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(27, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentReport copyWith(void Function(ContentReport) updates) =>
      super.copyWith((message) => updates(message as ContentReport))
          as ContentReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContentReport create() => ContentReport._();
  @$core.override
  ContentReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContentReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContentReport>(create);
  static ContentReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reporterUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set reporterUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReporterUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReporterUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reporterUsername => $_getSZ(2);
  @$pb.TagNumber(3)
  set reporterUsername($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReporterUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearReporterUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get roomId => $_getSZ(3);
  @$pb.TagNumber(4)
  set roomId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoomId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoomId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get roomName => $_getSZ(4);
  @$pb.TagNumber(5)
  set roomName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoomName() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoomName() => $_clearField(5);

  @$pb.TagNumber(6)
  ContentReportTargetType get targetType => $_getN(5);
  @$pb.TagNumber(6)
  set targetType(ContentReportTargetType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetType() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get targetRoomId => $_getSZ(6);
  @$pb.TagNumber(7)
  set targetRoomId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetRoomId() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetRoomId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get targetRoomName => $_getSZ(7);
  @$pb.TagNumber(8)
  set targetRoomName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTargetRoomName() => $_has(7);
  @$pb.TagNumber(8)
  void clearTargetRoomName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get targetUserId => $_getSZ(8);
  @$pb.TagNumber(9)
  set targetUserId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTargetUserId() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetUserId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get targetUsername => $_getSZ(9);
  @$pb.TagNumber(10)
  set targetUsername($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTargetUsername() => $_has(9);
  @$pb.TagNumber(10)
  void clearTargetUsername() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get targetMemberRoomId => $_getSZ(10);
  @$pb.TagNumber(11)
  set targetMemberRoomId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTargetMemberRoomId() => $_has(10);
  @$pb.TagNumber(11)
  void clearTargetMemberRoomId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get targetMemberRoomName => $_getSZ(11);
  @$pb.TagNumber(12)
  set targetMemberRoomName($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTargetMemberRoomName() => $_has(11);
  @$pb.TagNumber(12)
  void clearTargetMemberRoomName() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get targetMemberUserId => $_getSZ(12);
  @$pb.TagNumber(13)
  set targetMemberUserId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTargetMemberUserId() => $_has(12);
  @$pb.TagNumber(13)
  void clearTargetMemberUserId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get targetMemberUsername => $_getSZ(13);
  @$pb.TagNumber(14)
  set targetMemberUsername($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTargetMemberUsername() => $_has(13);
  @$pb.TagNumber(14)
  void clearTargetMemberUsername() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get targetChatMessageId => $_getI64(14);
  @$pb.TagNumber(15)
  set targetChatMessageId($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTargetChatMessageId() => $_has(14);
  @$pb.TagNumber(15)
  void clearTargetChatMessageId() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get targetChatMessageCreatedAt => $_getI64(15);
  @$pb.TagNumber(16)
  set targetChatMessageCreatedAt($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTargetChatMessageCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearTargetChatMessageCreatedAt() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get targetChatMessagePreview => $_getSZ(16);
  @$pb.TagNumber(17)
  set targetChatMessagePreview($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasTargetChatMessagePreview() => $_has(16);
  @$pb.TagNumber(17)
  void clearTargetChatMessagePreview() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get reasonCode => $_getSZ(17);
  @$pb.TagNumber(18)
  set reasonCode($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasReasonCode() => $_has(17);
  @$pb.TagNumber(18)
  void clearReasonCode() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get reason => $_getSZ(18);
  @$pb.TagNumber(19)
  set reason($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasReason() => $_has(18);
  @$pb.TagNumber(19)
  void clearReason() => $_clearField(19);

  @$pb.TagNumber(20)
  $1.ContentReportMetadata get metadata => $_getN(19);
  @$pb.TagNumber(20)
  set metadata($1.ContentReportMetadata value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasMetadata() => $_has(19);
  @$pb.TagNumber(20)
  void clearMetadata() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.ContentReportMetadata ensureMetadata() => $_ensure(19);

  @$pb.TagNumber(21)
  ContentReportStatus get status => $_getN(20);
  @$pb.TagNumber(21)
  set status(ContentReportStatus value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasStatus() => $_has(20);
  @$pb.TagNumber(21)
  void clearStatus() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get reviewedBy => $_getSZ(21);
  @$pb.TagNumber(22)
  set reviewedBy($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasReviewedBy() => $_has(21);
  @$pb.TagNumber(22)
  void clearReviewedBy() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get reviewedByUsername => $_getSZ(22);
  @$pb.TagNumber(23)
  set reviewedByUsername($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasReviewedByUsername() => $_has(22);
  @$pb.TagNumber(23)
  void clearReviewedByUsername() => $_clearField(23);

  @$pb.TagNumber(24)
  $fixnum.Int64 get reviewedAt => $_getI64(23);
  @$pb.TagNumber(24)
  set reviewedAt($fixnum.Int64 value) => $_setInt64(23, value);
  @$pb.TagNumber(24)
  $core.bool hasReviewedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearReviewedAt() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get resolutionNote => $_getSZ(24);
  @$pb.TagNumber(25)
  set resolutionNote($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasResolutionNote() => $_has(24);
  @$pb.TagNumber(25)
  void clearResolutionNote() => $_clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get createdAt => $_getI64(25);
  @$pb.TagNumber(26)
  set createdAt($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasCreatedAt() => $_has(25);
  @$pb.TagNumber(26)
  void clearCreatedAt() => $_clearField(26);

  @$pb.TagNumber(27)
  $fixnum.Int64 get updatedAt => $_getI64(26);
  @$pb.TagNumber(27)
  set updatedAt($fixnum.Int64 value) => $_setInt64(26, value);
  @$pb.TagNumber(27)
  $core.bool hasUpdatedAt() => $_has(26);
  @$pb.TagNumber(27)
  void clearUpdatedAt() => $_clearField(27);
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

class CreateUserRequest extends $pb.GeneratedMessage {
  factory CreateUserRequest({
    $core.String? username,
    $core.String? email,
    $0.UserRole? role,
    $0.UserStatus? status,
    $core.String? password,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (email != null) result.email = email;
    if (role != null) result.role = role;
    if (status != null) result.status = status;
    if (password != null) result.password = password;
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
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aE<$0.UserRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $0.UserRole.values)
    ..aE<$0.UserStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: $0.UserStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'password')
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
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.UserRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($0.UserRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.UserStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status($0.UserStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get password => $_getSZ(4);
  @$pb.TagNumber(5)
  set password($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassword() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassword() => $_clearField(5);
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

class RestoreUserRequest extends $pb.GeneratedMessage {
  factory RestoreUserRequest({
    $core.String? userId,
    $core.bool? ignoreIdentityConflicts,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (ignoreIdentityConflicts != null)
      result.ignoreIdentityConflicts = ignoreIdentityConflicts;
    return result;
  }

  RestoreUserRequest._();

  factory RestoreUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOB(2, _omitFieldNames ? '' : 'ignoreIdentityConflicts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreUserRequest copyWith(void Function(RestoreUserRequest) updates) =>
      super.copyWith((message) => updates(message as RestoreUserRequest))
          as RestoreUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreUserRequest create() => RestoreUserRequest._();
  @$core.override
  RestoreUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestoreUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreUserRequest>(create);
  static RestoreUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get ignoreIdentityConflicts => $_getBF(1);
  @$pb.TagNumber(2)
  set ignoreIdentityConflicts($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIgnoreIdentityConflicts() => $_has(1);
  @$pb.TagNumber(2)
  void clearIgnoreIdentityConflicts() => $_clearField(2);
}

class RestoreUserResponse extends $pb.GeneratedMessage {
  factory RestoreUserResponse({
    $core.bool? success,
    AdminUser? user,
    $core.Iterable<$core.String>? releasedIdentities,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (user != null) result.user = user;
    if (releasedIdentities != null)
      result.releasedIdentities.addAll(releasedIdentities);
    return result;
  }

  RestoreUserResponse._();

  factory RestoreUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<AdminUser>(2, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..pPS(3, _omitFieldNames ? '' : 'releasedIdentities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreUserResponse copyWith(void Function(RestoreUserResponse) updates) =>
      super.copyWith((message) => updates(message as RestoreUserResponse))
          as RestoreUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreUserResponse create() => RestoreUserResponse._();
  @$core.override
  RestoreUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestoreUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreUserResponse>(create);
  static RestoreUserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

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

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get releasedIdentities => $_getList(2);
}

class ListUsersRequest extends $pb.GeneratedMessage {
  factory ListUsersRequest({
    $core.int? page,
    $core.int? pageSize,
    $0.UserStatus? status,
    $0.UserRole? role,
    $core.String? search,
    UserListSortBy? sortBy,
    SortDirection? sortDirection,
    $core.bool? isBanned,
    $core.bool? includeDeleted,
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
    if (includeDeleted != null) result.includeDeleted = includeDeleted;
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
    ..aE<$0.UserStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $0.UserStatus.values)
    ..aE<$0.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $0.UserRole.values)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aE<UserListSortBy>(6, _omitFieldNames ? '' : 'sortBy',
        enumValues: UserListSortBy.values)
    ..aE<SortDirection>(7, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..aOB(8, _omitFieldNames ? '' : 'isBanned')
    ..aOB(9, _omitFieldNames ? '' : 'includeDeleted')
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
  $0.UserStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($0.UserStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role($0.UserRole value) => $_setField(4, value);
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

  @$pb.TagNumber(9)
  $core.bool get includeDeleted => $_getBF(8);
  @$pb.TagNumber(9)
  set includeDeleted($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIncludeDeleted() => $_has(8);
  @$pb.TagNumber(9)
  void clearIncludeDeleted() => $_clearField(9);
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
    $1.UserPreferences? preferences,
    $1.UserAuthFactors? authFactors,
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
    ..aOM<$1.UserPreferences>(2, _omitFieldNames ? '' : 'preferences',
        subBuilder: $1.UserPreferences.create)
    ..aOM<$1.UserAuthFactors>(3, _omitFieldNames ? '' : 'authFactors',
        subBuilder: $1.UserAuthFactors.create)
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
  $1.UserPreferences get preferences => $_getN(1);
  @$pb.TagNumber(2)
  set preferences($1.UserPreferences value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreferences() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreferences() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UserPreferences ensurePreferences() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UserAuthFactors get authFactors => $_getN(2);
  @$pb.TagNumber(3)
  set authFactors($1.UserAuthFactors value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthFactors() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthFactors() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UserAuthFactors ensureAuthFactors() => $_ensure(2);
}

class UpdateUserPreferencesRequest extends $pb.GeneratedMessage {
  factory UpdateUserPreferencesRequest({
    $core.String? userId,
    $core.bool? twoFactorEnabled,
    $1.UserNotificationPreferences? notifications,
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
    ..aOM<$1.UserNotificationPreferences>(
        4, _omitFieldNames ? '' : 'notifications',
        subBuilder: $1.UserNotificationPreferences.create)
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
  $1.UserNotificationPreferences get notifications => $_getN(2);
  @$pb.TagNumber(4)
  set notifications($1.UserNotificationPreferences value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNotifications() => $_has(2);
  @$pb.TagNumber(4)
  void clearNotifications() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.UserNotificationPreferences ensureNotifications() => $_ensure(2);
}

class UpdateUserPreferencesResponse extends $pb.GeneratedMessage {
  factory UpdateUserPreferencesResponse({
    AdminUser? user,
    $1.UserPreferences? preferences,
    $1.UserAuthFactors? authFactors,
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
    ..aOM<$1.UserPreferences>(2, _omitFieldNames ? '' : 'preferences',
        subBuilder: $1.UserPreferences.create)
    ..aOM<$1.UserAuthFactors>(3, _omitFieldNames ? '' : 'authFactors',
        subBuilder: $1.UserAuthFactors.create)
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
  $1.UserPreferences get preferences => $_getN(1);
  @$pb.TagNumber(2)
  set preferences($1.UserPreferences value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreferences() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreferences() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UserPreferences ensurePreferences() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UserAuthFactors get authFactors => $_getN(2);
  @$pb.TagNumber(3)
  set authFactors($1.UserAuthFactors value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthFactors() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthFactors() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UserAuthFactors ensureAuthFactors() => $_ensure(2);
}

class SetUserPasswordRequest extends $pb.GeneratedMessage {
  factory SetUserPasswordRequest({
    $core.String? userId,
    $core.String? password,
    $core.String? reason,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (password != null) result.password = password;
    if (reason != null) result.reason = reason;
    return result;
  }

  SetUserPasswordRequest._();

  factory SetUserPasswordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetUserPasswordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetUserPasswordRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUserPasswordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUserPasswordRequest copyWith(
          void Function(SetUserPasswordRequest) updates) =>
      super.copyWith((message) => updates(message as SetUserPasswordRequest))
          as SetUserPasswordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetUserPasswordRequest create() => SetUserPasswordRequest._();
  @$core.override
  SetUserPasswordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetUserPasswordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetUserPasswordRequest>(create);
  static SetUserPasswordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class SetUserPasswordResponse extends $pb.GeneratedMessage {
  factory SetUserPasswordResponse({
    $core.bool? success,
    AdminUser? user,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (user != null) result.user = user;
    return result;
  }

  SetUserPasswordResponse._();

  factory SetUserPasswordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetUserPasswordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetUserPasswordResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<AdminUser>(2, _omitFieldNames ? '' : 'user',
        subBuilder: AdminUser.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUserPasswordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetUserPasswordResponse copyWith(
          void Function(SetUserPasswordResponse) updates) =>
      super.copyWith((message) => updates(message as SetUserPasswordResponse))
          as SetUserPasswordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetUserPasswordResponse create() => SetUserPasswordResponse._();
  @$core.override
  SetUserPasswordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetUserPasswordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetUserPasswordResponse>(create);
  static SetUserPasswordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

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

class UpdateUserRoleRequest extends $pb.GeneratedMessage {
  factory UpdateUserRoleRequest({
    $core.String? userId,
    $0.UserRole? role,
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
    ..aE<$0.UserRole>(2, _omitFieldNames ? '' : 'role',
        enumValues: $0.UserRole.values)
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
  $0.UserRole get role => $_getN(1);
  @$pb.TagNumber(2)
  set role($0.UserRole value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => $_clearField(2);
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

class ModerateRoomChatUserRequest extends $pb.GeneratedMessage {
  factory ModerateRoomChatUserRequest({
    $core.String? roomId,
    $core.String? userId,
    $core.bool? deleteAllMessages,
    $core.bool? banUser,
    $core.String? reason,
    $core.bool? deleteAllReactions,
    $core.String? messageId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (deleteAllMessages != null) result.deleteAllMessages = deleteAllMessages;
    if (banUser != null) result.banUser = banUser;
    if (reason != null) result.reason = reason;
    if (deleteAllReactions != null)
      result.deleteAllReactions = deleteAllReactions;
    if (messageId != null) result.messageId = messageId;
    return result;
  }

  ModerateRoomChatUserRequest._();

  factory ModerateRoomChatUserRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModerateRoomChatUserRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateRoomChatUserRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOB(3, _omitFieldNames ? '' : 'deleteAllMessages')
    ..aOB(4, _omitFieldNames ? '' : 'banUser')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOB(6, _omitFieldNames ? '' : 'deleteAllReactions')
    ..aOS(7, _omitFieldNames ? '' : 'messageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateRoomChatUserRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateRoomChatUserRequest copyWith(
          void Function(ModerateRoomChatUserRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateRoomChatUserRequest))
          as ModerateRoomChatUserRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModerateRoomChatUserRequest create() =>
      ModerateRoomChatUserRequest._();
  @$core.override
  ModerateRoomChatUserRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ModerateRoomChatUserRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateRoomChatUserRequest>(create);
  static ModerateRoomChatUserRequest? _defaultInstance;

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
  $core.bool get deleteAllMessages => $_getBF(2);
  @$pb.TagNumber(3)
  set deleteAllMessages($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeleteAllMessages() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeleteAllMessages() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get banUser => $_getBF(3);
  @$pb.TagNumber(4)
  set banUser($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBanUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearBanUser() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get deleteAllReactions => $_getBF(5);
  @$pb.TagNumber(6)
  set deleteAllReactions($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeleteAllReactions() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeleteAllReactions() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get messageId => $_getSZ(6);
  @$pb.TagNumber(7)
  set messageId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessageId() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessageId() => $_clearField(7);
}

class ModerateRoomChatUserResponse extends $pb.GeneratedMessage {
  factory ModerateRoomChatUserResponse() => create();

  ModerateRoomChatUserResponse._();

  factory ModerateRoomChatUserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModerateRoomChatUserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModerateRoomChatUserResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateRoomChatUserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModerateRoomChatUserResponse copyWith(
          void Function(ModerateRoomChatUserResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ModerateRoomChatUserResponse))
          as ModerateRoomChatUserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModerateRoomChatUserResponse create() =>
      ModerateRoomChatUserResponse._();
  @$core.override
  ModerateRoomChatUserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ModerateRoomChatUserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModerateRoomChatUserResponse>(create);
  static ModerateRoomChatUserResponse? _defaultInstance;
}

class GetUserRoomsRequest extends $pb.GeneratedMessage {
  factory GetUserRoomsRequest({
    $core.String? userId,
    $core.int? page,
    $core.int? pageSize,
    $0.RoomStatus? status,
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
    ..aE<$0.RoomStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: $0.RoomStatus.values)
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
  $0.RoomStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status($0.RoomStatus value) => $_setField(4, value);
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
    $core.Iterable<Room>? rooms,
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
    ..pPM<Room>(1, _omitFieldNames ? '' : 'rooms', subBuilder: Room.create)
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

class ListUserRegistrationReviewsRequest extends $pb.GeneratedMessage {
  factory ListUserRegistrationReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $0.ReviewStatus? status,
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
    ..aE<$0.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $0.ReviewStatus.values)
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
  $0.ReviewStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($0.ReviewStatus value) => $_setField(3, value);
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

class ListRoomCreationReviewsRequest extends $pb.GeneratedMessage {
  factory ListRoomCreationReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $0.ReviewStatus? status,
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
    ..aE<$0.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $0.ReviewStatus.values)
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
  $0.ReviewStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($0.ReviewStatus value) => $_setField(3, value);
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
    Room? room,
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
    ..aOM<Room>(2, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
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
  Room get room => $_getN(1);
  @$pb.TagNumber(2)
  set room(Room value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoom() => $_clearField(2);
  @$pb.TagNumber(2)
  Room ensureRoom() => $_ensure(1);
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

class ListRoomJoinReviewsRequest extends $pb.GeneratedMessage {
  factory ListRoomJoinReviewsRequest({
    $core.int? page,
    $core.int? pageSize,
    $0.ReviewStatus? status,
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
    ..aE<$0.ReviewStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $0.ReviewStatus.values)
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
  $0.ReviewStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($0.ReviewStatus value) => $_setField(3, value);
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
    $0.RoomMember? member,
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
    ..aOM<$0.RoomMember>(2, _omitFieldNames ? '' : 'member',
        subBuilder: $0.RoomMember.create)
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
  $0.RoomMember get member => $_getN(1);
  @$pb.TagNumber(2)
  set member($0.RoomMember value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMember() => $_has(1);
  @$pb.TagNumber(2)
  void clearMember() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.RoomMember ensureMember() => $_ensure(1);
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

class ListRoomsRequest extends $pb.GeneratedMessage {
  factory ListRoomsRequest({
    $core.int? page,
    $core.int? pageSize,
    $0.RoomStatus? status,
    $core.String? search,
    $core.String? creatorId,
    $core.bool? isBanned,
    RoomListSortBy? sortBy,
    SortDirection? sortDirection,
    $core.String? categoryId,
    $core.Iterable<$core.String>? labelIds,
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
    if (categoryId != null) result.categoryId = categoryId;
    if (labelIds != null) result.labelIds.addAll(labelIds);
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
    ..aE<$0.RoomStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: $0.RoomStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'search')
    ..aOS(5, _omitFieldNames ? '' : 'creatorId')
    ..aOB(6, _omitFieldNames ? '' : 'isBanned')
    ..aE<RoomListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: RoomListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..aOS(9, _omitFieldNames ? '' : 'categoryId')
    ..pPS(10, _omitFieldNames ? '' : 'labelIds')
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
  $0.RoomStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status($0.RoomStatus value) => $_setField(3, value);
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

  @$pb.TagNumber(9)
  $core.String get categoryId => $_getSZ(8);
  @$pb.TagNumber(9)
  set categoryId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCategoryId() => $_has(8);
  @$pb.TagNumber(9)
  void clearCategoryId() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get labelIds => $_getList(9);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
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

class ListRoomCategoriesRequest extends $pb.GeneratedMessage {
  factory ListRoomCategoriesRequest({
    $core.bool? includeDisabled,
  }) {
    final result = create();
    if (includeDisabled != null) result.includeDisabled = includeDisabled;
    return result;
  }

  ListRoomCategoriesRequest._();

  factory ListRoomCategoriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomCategoriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomCategoriesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeDisabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCategoriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCategoriesRequest copyWith(
          void Function(ListRoomCategoriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListRoomCategoriesRequest))
          as ListRoomCategoriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomCategoriesRequest create() => ListRoomCategoriesRequest._();
  @$core.override
  ListRoomCategoriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomCategoriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomCategoriesRequest>(create);
  static ListRoomCategoriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includeDisabled => $_getBF(0);
  @$pb.TagNumber(1)
  set includeDisabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeDisabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeDisabled() => $_clearField(1);
}

class ListRoomCategoriesResponse extends $pb.GeneratedMessage {
  factory ListRoomCategoriesResponse({
    $core.Iterable<$1.RoomCategory>? categories,
  }) {
    final result = create();
    if (categories != null) result.categories.addAll(categories);
    return result;
  }

  ListRoomCategoriesResponse._();

  factory ListRoomCategoriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomCategoriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomCategoriesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<$1.RoomCategory>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: $1.RoomCategory.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCategoriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomCategoriesResponse copyWith(
          void Function(ListRoomCategoriesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRoomCategoriesResponse))
          as ListRoomCategoriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomCategoriesResponse create() => ListRoomCategoriesResponse._();
  @$core.override
  ListRoomCategoriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomCategoriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomCategoriesResponse>(create);
  static ListRoomCategoriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.RoomCategory> get categories => $_getList(0);
}

class UpsertRoomCategoryRequest extends $pb.GeneratedMessage {
  factory UpsertRoomCategoryRequest({
    $core.String? key,
    $core.String? name,
    $core.String? description,
    $core.int? sortOrder,
    $core.bool? isEnabled,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (sortOrder != null) result.sortOrder = sortOrder;
    if (isEnabled != null) result.isEnabled = isEnabled;
    return result;
  }

  UpsertRoomCategoryRequest._();

  factory UpsertRoomCategoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpsertRoomCategoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpsertRoomCategoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aI(4, _omitFieldNames ? '' : 'sortOrder')
    ..aOB(5, _omitFieldNames ? '' : 'isEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertRoomCategoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertRoomCategoryRequest copyWith(
          void Function(UpsertRoomCategoryRequest) updates) =>
      super.copyWith((message) => updates(message as UpsertRoomCategoryRequest))
          as UpsertRoomCategoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertRoomCategoryRequest create() => UpsertRoomCategoryRequest._();
  @$core.override
  UpsertRoomCategoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpsertRoomCategoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpsertRoomCategoryRequest>(create);
  static UpsertRoomCategoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get sortOrder => $_getIZ(3);
  @$pb.TagNumber(4)
  set sortOrder($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSortOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearSortOrder() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isEnabled => $_getBF(4);
  @$pb.TagNumber(5)
  set isEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsEnabled() => $_clearField(5);
}

class DeleteRoomCategoryRequest extends $pb.GeneratedMessage {
  factory DeleteRoomCategoryRequest({
    $core.String? categoryId,
  }) {
    final result = create();
    if (categoryId != null) result.categoryId = categoryId;
    return result;
  }

  DeleteRoomCategoryRequest._();

  factory DeleteRoomCategoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomCategoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomCategoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'categoryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomCategoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomCategoryRequest copyWith(
          void Function(DeleteRoomCategoryRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRoomCategoryRequest))
          as DeleteRoomCategoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoomCategoryRequest create() => DeleteRoomCategoryRequest._();
  @$core.override
  DeleteRoomCategoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRoomCategoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoomCategoryRequest>(create);
  static DeleteRoomCategoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get categoryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set categoryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryId() => $_clearField(1);
}

class DeleteRoomCategoryResponse extends $pb.GeneratedMessage {
  factory DeleteRoomCategoryResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteRoomCategoryResponse._();

  factory DeleteRoomCategoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomCategoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomCategoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomCategoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomCategoryResponse copyWith(
          void Function(DeleteRoomCategoryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteRoomCategoryResponse))
          as DeleteRoomCategoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoomCategoryResponse create() => DeleteRoomCategoryResponse._();
  @$core.override
  DeleteRoomCategoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRoomCategoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoomCategoryResponse>(create);
  static DeleteRoomCategoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ListRoomLabelsRequest extends $pb.GeneratedMessage {
  factory ListRoomLabelsRequest({
    $core.bool? includeDisabled,
    $core.String? categoryId,
  }) {
    final result = create();
    if (includeDisabled != null) result.includeDisabled = includeDisabled;
    if (categoryId != null) result.categoryId = categoryId;
    return result;
  }

  ListRoomLabelsRequest._();

  factory ListRoomLabelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomLabelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomLabelsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'includeDisabled')
    ..aOS(2, _omitFieldNames ? '' : 'categoryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomLabelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomLabelsRequest copyWith(
          void Function(ListRoomLabelsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRoomLabelsRequest))
          as ListRoomLabelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomLabelsRequest create() => ListRoomLabelsRequest._();
  @$core.override
  ListRoomLabelsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomLabelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomLabelsRequest>(create);
  static ListRoomLabelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get includeDisabled => $_getBF(0);
  @$pb.TagNumber(1)
  set includeDisabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIncludeDisabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearIncludeDisabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get categoryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set categoryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryId() => $_clearField(2);
}

class ListRoomLabelsResponse extends $pb.GeneratedMessage {
  factory ListRoomLabelsResponse({
    $core.Iterable<$1.RoomLabel>? labels,
  }) {
    final result = create();
    if (labels != null) result.labels.addAll(labels);
    return result;
  }

  ListRoomLabelsResponse._();

  factory ListRoomLabelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRoomLabelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRoomLabelsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<$1.RoomLabel>(1, _omitFieldNames ? '' : 'labels',
        subBuilder: $1.RoomLabel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomLabelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRoomLabelsResponse copyWith(
          void Function(ListRoomLabelsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRoomLabelsResponse))
          as ListRoomLabelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoomLabelsResponse create() => ListRoomLabelsResponse._();
  @$core.override
  ListRoomLabelsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRoomLabelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRoomLabelsResponse>(create);
  static ListRoomLabelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.RoomLabel> get labels => $_getList(0);
}

class UpsertRoomLabelRequest extends $pb.GeneratedMessage {
  factory UpsertRoomLabelRequest({
    $core.String? key,
    $core.String? name,
    $core.String? description,
    $core.String? color,
    $core.String? categoryId,
    $core.int? sortOrder,
    $core.bool? isEnabled,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (color != null) result.color = color;
    if (categoryId != null) result.categoryId = categoryId;
    if (sortOrder != null) result.sortOrder = sortOrder;
    if (isEnabled != null) result.isEnabled = isEnabled;
    return result;
  }

  UpsertRoomLabelRequest._();

  factory UpsertRoomLabelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpsertRoomLabelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpsertRoomLabelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'color')
    ..aOS(5, _omitFieldNames ? '' : 'categoryId')
    ..aI(6, _omitFieldNames ? '' : 'sortOrder')
    ..aOB(7, _omitFieldNames ? '' : 'isEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertRoomLabelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpsertRoomLabelRequest copyWith(
          void Function(UpsertRoomLabelRequest) updates) =>
      super.copyWith((message) => updates(message as UpsertRoomLabelRequest))
          as UpsertRoomLabelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertRoomLabelRequest create() => UpsertRoomLabelRequest._();
  @$core.override
  UpsertRoomLabelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpsertRoomLabelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpsertRoomLabelRequest>(create);
  static UpsertRoomLabelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get categoryId => $_getSZ(4);
  @$pb.TagNumber(5)
  set categoryId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategoryId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategoryId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get sortOrder => $_getIZ(5);
  @$pb.TagNumber(6)
  set sortOrder($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSortOrder() => $_has(5);
  @$pb.TagNumber(6)
  void clearSortOrder() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isEnabled => $_getBF(6);
  @$pb.TagNumber(7)
  set isEnabled($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsEnabled() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsEnabled() => $_clearField(7);
}

class DeleteRoomLabelRequest extends $pb.GeneratedMessage {
  factory DeleteRoomLabelRequest({
    $core.String? labelId,
  }) {
    final result = create();
    if (labelId != null) result.labelId = labelId;
    return result;
  }

  DeleteRoomLabelRequest._();

  factory DeleteRoomLabelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomLabelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomLabelRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'labelId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomLabelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomLabelRequest copyWith(
          void Function(DeleteRoomLabelRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRoomLabelRequest))
          as DeleteRoomLabelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoomLabelRequest create() => DeleteRoomLabelRequest._();
  @$core.override
  DeleteRoomLabelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRoomLabelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoomLabelRequest>(create);
  static DeleteRoomLabelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get labelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set labelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLabelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabelId() => $_clearField(1);
}

class DeleteRoomLabelResponse extends $pb.GeneratedMessage {
  factory DeleteRoomLabelResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteRoomLabelResponse._();

  factory DeleteRoomLabelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteRoomLabelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRoomLabelResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomLabelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRoomLabelResponse copyWith(
          void Function(DeleteRoomLabelResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteRoomLabelResponse))
          as DeleteRoomLabelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRoomLabelResponse create() => DeleteRoomLabelResponse._();
  @$core.override
  DeleteRoomLabelResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteRoomLabelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteRoomLabelResponse>(create);
  static DeleteRoomLabelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class UpdateRoomTaxonomyRequest extends $pb.GeneratedMessage {
  factory UpdateRoomTaxonomyRequest({
    $core.String? roomId,
    $core.String? categoryId,
    $core.Iterable<$core.String>? labelIds,
    $core.bool? clearCategory,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (categoryId != null) result.categoryId = categoryId;
    if (labelIds != null) result.labelIds.addAll(labelIds);
    if (clearCategory != null) result.clearCategory = clearCategory;
    return result;
  }

  UpdateRoomTaxonomyRequest._();

  factory UpdateRoomTaxonomyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRoomTaxonomyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRoomTaxonomyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'categoryId')
    ..pPS(3, _omitFieldNames ? '' : 'labelIds')
    ..aOB(4, _omitFieldNames ? '' : 'clearCategory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomTaxonomyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoomTaxonomyRequest copyWith(
          void Function(UpdateRoomTaxonomyRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRoomTaxonomyRequest))
          as UpdateRoomTaxonomyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoomTaxonomyRequest create() => UpdateRoomTaxonomyRequest._();
  @$core.override
  UpdateRoomTaxonomyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRoomTaxonomyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRoomTaxonomyRequest>(create);
  static UpdateRoomTaxonomyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get categoryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set categoryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get labelIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get clearCategory => $_getBF(3);
  @$pb.TagNumber(4)
  set clearCategory($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClearCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearClearCategory() => $_clearField(4);
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
    $1.RoomSettings? settings,
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
    ..aOM<$1.RoomSettings>(1, _omitFieldNames ? '' : 'settings',
        subBuilder: $1.RoomSettings.create)
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
  $1.RoomSettings get settings => $_getN(0);
  @$pb.TagNumber(1)
  set settings($1.RoomSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettings() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettings() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.RoomSettings ensureSettings() => $_ensure(0);

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
    $1.RoomSettingsPatch? settings,
    $2.FieldMask? updateMask,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (settings != null) result.settings = settings;
    if (updateMask != null) result.updateMask = updateMask;
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
    ..aOM<$1.RoomSettingsPatch>(2, _omitFieldNames ? '' : 'settings',
        subBuilder: $1.RoomSettingsPatch.create)
    ..aOM<$2.FieldMask>(3, _omitFieldNames ? '' : 'updateMask',
        subBuilder: $2.FieldMask.create)
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
  $1.RoomSettingsPatch get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings($1.RoomSettingsPatch value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RoomSettingsPatch ensureSettings() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.FieldMask get updateMask => $_getN(2);
  @$pb.TagNumber(3)
  set updateMask($2.FieldMask value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdateMask() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdateMask() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.FieldMask ensureUpdateMask() => $_ensure(2);
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

class GetRoomMembersRequest extends $pb.GeneratedMessage {
  factory GetRoomMembersRequest({
    $core.String? roomId,
    $core.int? page,
    $core.int? pageSize,
    $core.String? search,
    $0.RoomMemberRole? role,
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
    ..aE<$0.RoomMemberRole>(5, _omitFieldNames ? '' : 'role',
        enumValues: $0.RoomMemberRole.values)
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
  $0.RoomMemberRole get role => $_getN(4);
  @$pb.TagNumber(5)
  set role($0.RoomMemberRole value) => $_setField(5, value);
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
    $core.Iterable<$0.RoomMember>? members,
    $core.int? total,
    $0.RoomPresenceStats? presence,
  }) {
    final result = create();
    if (members != null) result.members.addAll(members);
    if (total != null) result.total = total;
    if (presence != null) result.presence = presence;
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
    ..pPM<$0.RoomMember>(1, _omitFieldNames ? '' : 'members',
        subBuilder: $0.RoomMember.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..aOM<$0.RoomPresenceStats>(3, _omitFieldNames ? '' : 'presence',
        subBuilder: $0.RoomPresenceStats.create)
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
  $pb.PbList<$0.RoomMember> get members => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.RoomPresenceStats get presence => $_getN(2);
  @$pb.TagNumber(3)
  set presence($0.RoomPresenceStats value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPresence() => $_has(2);
  @$pb.TagNumber(3)
  void clearPresence() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.RoomPresenceStats ensurePresence() => $_ensure(2);
}

class AddMemberRequest extends $pb.GeneratedMessage {
  factory AddMemberRequest({
    $core.String? roomId,
    $core.String? userId,
    $0.RoomMemberRole? role,
    $core.bool? notify,
    $core.String? remarkName,
    $core.String? displayTag,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (role != null) result.role = role;
    if (notify != null) result.notify = notify;
    if (remarkName != null) result.remarkName = remarkName;
    if (displayTag != null) result.displayTag = displayTag;
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
    ..aE<$0.RoomMemberRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $0.RoomMemberRole.values)
    ..aOB(4, _omitFieldNames ? '' : 'notify')
    ..aOS(5, _omitFieldNames ? '' : 'remarkName')
    ..aOS(6, _omitFieldNames ? '' : 'displayTag')
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
  $0.RoomMemberRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($0.RoomMemberRole value) => $_setField(3, value);
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

  @$pb.TagNumber(5)
  $core.String get remarkName => $_getSZ(4);
  @$pb.TagNumber(5)
  set remarkName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRemarkName() => $_has(4);
  @$pb.TagNumber(5)
  void clearRemarkName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get displayTag => $_getSZ(5);
  @$pb.TagNumber(6)
  set displayTag($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayTag() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayTag() => $_clearField(6);
}

class UpdateMemberRemarkNameRequest extends $pb.GeneratedMessage {
  factory UpdateMemberRemarkNameRequest({
    $core.String? roomId,
    $core.String? userId,
    $core.String? remarkName,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (remarkName != null) result.remarkName = remarkName;
    return result;
  }

  UpdateMemberRemarkNameRequest._();

  factory UpdateMemberRemarkNameRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMemberRemarkNameRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberRemarkNameRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'remarkName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRemarkNameRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberRemarkNameRequest copyWith(
          void Function(UpdateMemberRemarkNameRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateMemberRemarkNameRequest))
          as UpdateMemberRemarkNameRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMemberRemarkNameRequest create() =>
      UpdateMemberRemarkNameRequest._();
  @$core.override
  UpdateMemberRemarkNameRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberRemarkNameRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberRemarkNameRequest>(create);
  static UpdateMemberRemarkNameRequest? _defaultInstance;

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
  $core.String get remarkName => $_getSZ(2);
  @$pb.TagNumber(3)
  set remarkName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemarkName() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemarkName() => $_clearField(3);
}

class UpdateMemberDisplayTagRequest extends $pb.GeneratedMessage {
  factory UpdateMemberDisplayTagRequest({
    $core.String? roomId,
    $core.String? userId,
    $core.String? displayTag,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (displayTag != null) result.displayTag = displayTag;
    return result;
  }

  UpdateMemberDisplayTagRequest._();

  factory UpdateMemberDisplayTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateMemberDisplayTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMemberDisplayTagRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'displayTag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberDisplayTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMemberDisplayTagRequest copyWith(
          void Function(UpdateMemberDisplayTagRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateMemberDisplayTagRequest))
          as UpdateMemberDisplayTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateMemberDisplayTagRequest create() =>
      UpdateMemberDisplayTagRequest._();
  @$core.override
  UpdateMemberDisplayTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateMemberDisplayTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMemberDisplayTagRequest>(create);
  static UpdateMemberDisplayTagRequest? _defaultInstance;

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
  $core.String get displayTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayTag() => $_clearField(3);
}

class UpdateMemberPermissionsRequest extends $pb.GeneratedMessage {
  factory UpdateMemberPermissionsRequest({
    $core.String? roomId,
    $core.String? userId,
    $0.RoomMemberRole? role,
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
    ..aE<$0.RoomMemberRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: $0.RoomMemberRole.values)
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
  $0.RoomMemberRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role($0.RoomMemberRole value) => $_setField(3, value);
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

class GetServiceStateRequest extends $pb.GeneratedMessage {
  factory GetServiceStateRequest() => create();

  GetServiceStateRequest._();

  factory GetServiceStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServiceStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServiceStateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceStateRequest copyWith(
          void Function(GetServiceStateRequest) updates) =>
      super.copyWith((message) => updates(message as GetServiceStateRequest))
          as GetServiceStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServiceStateRequest create() => GetServiceStateRequest._();
  @$core.override
  GetServiceStateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServiceStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServiceStateRequest>(create);
  static GetServiceStateRequest? _defaultInstance;
}

class GetServiceStateResponse extends $pb.GeneratedMessage {
  factory GetServiceStateResponse({
    $fixnum.Int64? totalUsers,
    $fixnum.Int64? activeUsers,
    $fixnum.Int64? bannedUsers,
    $fixnum.Int64? totalRooms,
    $fixnum.Int64? activeRooms,
    $fixnum.Int64? bannedRooms,
    $fixnum.Int64? totalMedia,
    $fixnum.Int64? providerInstances,
    ServiceAdditionalState? additionalState,
    $0.PresenceOverview? presence,
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
    if (additionalState != null) result.additionalState = additionalState;
    if (presence != null) result.presence = presence;
    return result;
  }

  GetServiceStateResponse._();

  factory GetServiceStateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServiceStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServiceStateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'totalUsers')
    ..aInt64(2, _omitFieldNames ? '' : 'activeUsers')
    ..aInt64(3, _omitFieldNames ? '' : 'bannedUsers')
    ..aInt64(4, _omitFieldNames ? '' : 'totalRooms')
    ..aInt64(5, _omitFieldNames ? '' : 'activeRooms')
    ..aInt64(6, _omitFieldNames ? '' : 'bannedRooms')
    ..aInt64(7, _omitFieldNames ? '' : 'totalMedia')
    ..aInt64(8, _omitFieldNames ? '' : 'providerInstances')
    ..aOM<ServiceAdditionalState>(9, _omitFieldNames ? '' : 'additionalState',
        subBuilder: ServiceAdditionalState.create)
    ..aOM<$0.PresenceOverview>(10, _omitFieldNames ? '' : 'presence',
        subBuilder: $0.PresenceOverview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceStateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceStateResponse copyWith(
          void Function(GetServiceStateResponse) updates) =>
      super.copyWith((message) => updates(message as GetServiceStateResponse))
          as GetServiceStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServiceStateResponse create() => GetServiceStateResponse._();
  @$core.override
  GetServiceStateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServiceStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServiceStateResponse>(create);
  static GetServiceStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalUsers => $_getI64(0);
  @$pb.TagNumber(1)
  set totalUsers($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalUsers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalUsers() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get activeUsers => $_getI64(1);
  @$pb.TagNumber(2)
  set activeUsers($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveUsers() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveUsers() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get bannedUsers => $_getI64(2);
  @$pb.TagNumber(3)
  set bannedUsers($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBannedUsers() => $_has(2);
  @$pb.TagNumber(3)
  void clearBannedUsers() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalRooms => $_getI64(3);
  @$pb.TagNumber(4)
  set totalRooms($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalRooms() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalRooms() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get activeRooms => $_getI64(4);
  @$pb.TagNumber(5)
  set activeRooms($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActiveRooms() => $_has(4);
  @$pb.TagNumber(5)
  void clearActiveRooms() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get bannedRooms => $_getI64(5);
  @$pb.TagNumber(6)
  set bannedRooms($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBannedRooms() => $_has(5);
  @$pb.TagNumber(6)
  void clearBannedRooms() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get totalMedia => $_getI64(6);
  @$pb.TagNumber(7)
  set totalMedia($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalMedia() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalMedia() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get providerInstances => $_getI64(7);
  @$pb.TagNumber(8)
  set providerInstances($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProviderInstances() => $_has(7);
  @$pb.TagNumber(8)
  void clearProviderInstances() => $_clearField(8);

  @$pb.TagNumber(9)
  ServiceAdditionalState get additionalState => $_getN(8);
  @$pb.TagNumber(9)
  set additionalState(ServiceAdditionalState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAdditionalState() => $_has(8);
  @$pb.TagNumber(9)
  void clearAdditionalState() => $_clearField(9);
  @$pb.TagNumber(9)
  ServiceAdditionalState ensureAdditionalState() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.PresenceOverview get presence => $_getN(9);
  @$pb.TagNumber(10)
  set presence($0.PresenceOverview value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPresence() => $_has(9);
  @$pb.TagNumber(10)
  void clearPresence() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.PresenceOverview ensurePresence() => $_ensure(9);
}

class ServiceAdditionalState extends $pb.GeneratedMessage {
  factory ServiceAdditionalState({
    $fixnum.Int64? activeStreams,
    $fixnum.Int64? openReports,
  }) {
    final result = create();
    if (activeStreams != null) result.activeStreams = activeStreams;
    if (openReports != null) result.openReports = openReports;
    return result;
  }

  ServiceAdditionalState._();

  factory ServiceAdditionalState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceAdditionalState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceAdditionalState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'activeStreams')
    ..aInt64(2, _omitFieldNames ? '' : 'openReports')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceAdditionalState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceAdditionalState copyWith(
          void Function(ServiceAdditionalState) updates) =>
      super.copyWith((message) => updates(message as ServiceAdditionalState))
          as ServiceAdditionalState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceAdditionalState create() => ServiceAdditionalState._();
  @$core.override
  ServiceAdditionalState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceAdditionalState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceAdditionalState>(create);
  static ServiceAdditionalState? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get activeStreams => $_getI64(0);
  @$pb.TagNumber(1)
  set activeStreams($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveStreams() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveStreams() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get openReports => $_getI64(1);
  @$pb.TagNumber(2)
  set openReports($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenReports() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenReports() => $_clearField(2);
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

class GetSliceCacheStatsRequest extends $pb.GeneratedMessage {
  factory GetSliceCacheStatsRequest({
    $core.String? nodeId,
    $core.bool? allNodes,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (allNodes != null) result.allNodes = allNodes;
    return result;
  }

  GetSliceCacheStatsRequest._();

  factory GetSliceCacheStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSliceCacheStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSliceCacheStatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'allNodes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSliceCacheStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSliceCacheStatsRequest copyWith(
          void Function(GetSliceCacheStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetSliceCacheStatsRequest))
          as GetSliceCacheStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSliceCacheStatsRequest create() => GetSliceCacheStatsRequest._();
  @$core.override
  GetSliceCacheStatsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSliceCacheStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSliceCacheStatsRequest>(create);
  static GetSliceCacheStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get allNodes => $_getBF(1);
  @$pb.TagNumber(2)
  set allNodes($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllNodes() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllNodes() => $_clearField(2);
}

class PurgeSliceCacheRequest extends $pb.GeneratedMessage {
  factory PurgeSliceCacheRequest({
    $core.String? nodeId,
    $core.bool? allNodes,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (allNodes != null) result.allNodes = allNodes;
    return result;
  }

  PurgeSliceCacheRequest._();

  factory PurgeSliceCacheRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurgeSliceCacheRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurgeSliceCacheRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'allNodes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeSliceCacheRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeSliceCacheRequest copyWith(
          void Function(PurgeSliceCacheRequest) updates) =>
      super.copyWith((message) => updates(message as PurgeSliceCacheRequest))
          as PurgeSliceCacheRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurgeSliceCacheRequest create() => PurgeSliceCacheRequest._();
  @$core.override
  PurgeSliceCacheRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurgeSliceCacheRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurgeSliceCacheRequest>(create);
  static PurgeSliceCacheRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get allNodes => $_getBF(1);
  @$pb.TagNumber(2)
  set allNodes($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllNodes() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllNodes() => $_clearField(2);
}

class EvictExpiredSliceCacheRequest extends $pb.GeneratedMessage {
  factory EvictExpiredSliceCacheRequest({
    $core.String? nodeId,
    $core.bool? allNodes,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (allNodes != null) result.allNodes = allNodes;
    return result;
  }

  EvictExpiredSliceCacheRequest._();

  factory EvictExpiredSliceCacheRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvictExpiredSliceCacheRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvictExpiredSliceCacheRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'allNodes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvictExpiredSliceCacheRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvictExpiredSliceCacheRequest copyWith(
          void Function(EvictExpiredSliceCacheRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EvictExpiredSliceCacheRequest))
          as EvictExpiredSliceCacheRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvictExpiredSliceCacheRequest create() =>
      EvictExpiredSliceCacheRequest._();
  @$core.override
  EvictExpiredSliceCacheRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvictExpiredSliceCacheRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvictExpiredSliceCacheRequest>(create);
  static EvictExpiredSliceCacheRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get allNodes => $_getBF(1);
  @$pb.TagNumber(2)
  set allNodes($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllNodes() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllNodes() => $_clearField(2);
}

class SliceCacheConfigInfo extends $pb.GeneratedMessage {
  factory SliceCacheConfigInfo({
    $core.bool? engineEnabled,
    $core.String? backend,
    $core.String? fileCacheDir,
    $fixnum.Int64? sliceSize,
    $fixnum.Int64? maxCacheSize,
    $fixnum.Int64? segmentTtlSecs,
    $fixnum.Int64? staleMaxAgeSecs,
    $core.bool? staleWhileRevalidate,
    $fixnum.Int64? evictionIntervalSecs,
    $core.double? watermarkRatio,
  }) {
    final result = create();
    if (engineEnabled != null) result.engineEnabled = engineEnabled;
    if (backend != null) result.backend = backend;
    if (fileCacheDir != null) result.fileCacheDir = fileCacheDir;
    if (sliceSize != null) result.sliceSize = sliceSize;
    if (maxCacheSize != null) result.maxCacheSize = maxCacheSize;
    if (segmentTtlSecs != null) result.segmentTtlSecs = segmentTtlSecs;
    if (staleMaxAgeSecs != null) result.staleMaxAgeSecs = staleMaxAgeSecs;
    if (staleWhileRevalidate != null)
      result.staleWhileRevalidate = staleWhileRevalidate;
    if (evictionIntervalSecs != null)
      result.evictionIntervalSecs = evictionIntervalSecs;
    if (watermarkRatio != null) result.watermarkRatio = watermarkRatio;
    return result;
  }

  SliceCacheConfigInfo._();

  factory SliceCacheConfigInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SliceCacheConfigInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SliceCacheConfigInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'engineEnabled')
    ..aOS(2, _omitFieldNames ? '' : 'backend')
    ..aOS(3, _omitFieldNames ? '' : 'fileCacheDir')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'sliceSize', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'maxCacheSize', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'segmentTtlSecs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'staleMaxAgeSecs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(8, _omitFieldNames ? '' : 'staleWhileRevalidate')
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'evictionIntervalSecs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(10, _omitFieldNames ? '' : 'watermarkRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SliceCacheConfigInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SliceCacheConfigInfo copyWith(void Function(SliceCacheConfigInfo) updates) =>
      super.copyWith((message) => updates(message as SliceCacheConfigInfo))
          as SliceCacheConfigInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SliceCacheConfigInfo create() => SliceCacheConfigInfo._();
  @$core.override
  SliceCacheConfigInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SliceCacheConfigInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SliceCacheConfigInfo>(create);
  static SliceCacheConfigInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get engineEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set engineEnabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEngineEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEngineEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get backend => $_getSZ(1);
  @$pb.TagNumber(2)
  set backend($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBackend() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackend() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileCacheDir => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileCacheDir($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileCacheDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileCacheDir() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get sliceSize => $_getI64(3);
  @$pb.TagNumber(4)
  set sliceSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSliceSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSliceSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get maxCacheSize => $_getI64(4);
  @$pb.TagNumber(5)
  set maxCacheSize($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxCacheSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxCacheSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get segmentTtlSecs => $_getI64(5);
  @$pb.TagNumber(6)
  set segmentTtlSecs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSegmentTtlSecs() => $_has(5);
  @$pb.TagNumber(6)
  void clearSegmentTtlSecs() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get staleMaxAgeSecs => $_getI64(6);
  @$pb.TagNumber(7)
  set staleMaxAgeSecs($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStaleMaxAgeSecs() => $_has(6);
  @$pb.TagNumber(7)
  void clearStaleMaxAgeSecs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get staleWhileRevalidate => $_getBF(7);
  @$pb.TagNumber(8)
  set staleWhileRevalidate($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStaleWhileRevalidate() => $_has(7);
  @$pb.TagNumber(8)
  void clearStaleWhileRevalidate() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get evictionIntervalSecs => $_getI64(8);
  @$pb.TagNumber(9)
  set evictionIntervalSecs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEvictionIntervalSecs() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvictionIntervalSecs() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get watermarkRatio => $_getN(9);
  @$pb.TagNumber(10)
  set watermarkRatio($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWatermarkRatio() => $_has(9);
  @$pb.TagNumber(10)
  void clearWatermarkRatio() => $_clearField(10);
}

class SliceCacheStatsNode extends $pb.GeneratedMessage {
  factory SliceCacheStatsNode({
    $core.String? nodeId,
    SliceCacheConfigInfo? config,
    $fixnum.Int64? currentSizeBytes,
    $fixnum.Int64? entryCount,
    $fixnum.Int64? metadataEntries,
    $fixnum.Int64? updatingEntries,
    $fixnum.Int64? lockCount,
    $core.double? usageRatio,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (config != null) result.config = config;
    if (currentSizeBytes != null) result.currentSizeBytes = currentSizeBytes;
    if (entryCount != null) result.entryCount = entryCount;
    if (metadataEntries != null) result.metadataEntries = metadataEntries;
    if (updatingEntries != null) result.updatingEntries = updatingEntries;
    if (lockCount != null) result.lockCount = lockCount;
    if (usageRatio != null) result.usageRatio = usageRatio;
    return result;
  }

  SliceCacheStatsNode._();

  factory SliceCacheStatsNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SliceCacheStatsNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SliceCacheStatsNode',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOM<SliceCacheConfigInfo>(2, _omitFieldNames ? '' : 'config',
        subBuilder: SliceCacheConfigInfo.create)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'currentSizeBytes', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'entryCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'metadataEntries', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'updatingEntries', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'lockCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(8, _omitFieldNames ? '' : 'usageRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SliceCacheStatsNode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SliceCacheStatsNode copyWith(void Function(SliceCacheStatsNode) updates) =>
      super.copyWith((message) => updates(message as SliceCacheStatsNode))
          as SliceCacheStatsNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SliceCacheStatsNode create() => SliceCacheStatsNode._();
  @$core.override
  SliceCacheStatsNode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SliceCacheStatsNode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SliceCacheStatsNode>(create);
  static SliceCacheStatsNode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  SliceCacheConfigInfo get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(SliceCacheConfigInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  SliceCacheConfigInfo ensureConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get currentSizeBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set currentSizeBytes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentSizeBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentSizeBytes() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get entryCount => $_getI64(3);
  @$pb.TagNumber(4)
  set entryCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntryCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntryCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get metadataEntries => $_getI64(4);
  @$pb.TagNumber(5)
  set metadataEntries($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMetadataEntries() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadataEntries() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get updatingEntries => $_getI64(5);
  @$pb.TagNumber(6)
  set updatingEntries($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpdatingEntries() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatingEntries() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get lockCount => $_getI64(6);
  @$pb.TagNumber(7)
  set lockCount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLockCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearLockCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get usageRatio => $_getN(7);
  @$pb.TagNumber(8)
  set usageRatio($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUsageRatio() => $_has(7);
  @$pb.TagNumber(8)
  void clearUsageRatio() => $_clearField(8);
}

class SliceCacheNodeFailure extends $pb.GeneratedMessage {
  factory SliceCacheNodeFailure({
    $core.String? nodeId,
    $core.String? error,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (error != null) result.error = error;
    return result;
  }

  SliceCacheNodeFailure._();

  factory SliceCacheNodeFailure.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SliceCacheNodeFailure.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SliceCacheNodeFailure',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOS(2, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SliceCacheNodeFailure clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SliceCacheNodeFailure copyWith(
          void Function(SliceCacheNodeFailure) updates) =>
      super.copyWith((message) => updates(message as SliceCacheNodeFailure))
          as SliceCacheNodeFailure;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SliceCacheNodeFailure create() => SliceCacheNodeFailure._();
  @$core.override
  SliceCacheNodeFailure createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SliceCacheNodeFailure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SliceCacheNodeFailure>(create);
  static SliceCacheNodeFailure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get error => $_getSZ(1);
  @$pb.TagNumber(2)
  set error($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

class GetSliceCacheStatsResponse extends $pb.GeneratedMessage {
  factory GetSliceCacheStatsResponse({
    $core.Iterable<SliceCacheStatsNode>? nodes,
    $core.Iterable<SliceCacheNodeFailure>? failures,
  }) {
    final result = create();
    if (nodes != null) result.nodes.addAll(nodes);
    if (failures != null) result.failures.addAll(failures);
    return result;
  }

  GetSliceCacheStatsResponse._();

  factory GetSliceCacheStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSliceCacheStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSliceCacheStatsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<SliceCacheStatsNode>(1, _omitFieldNames ? '' : 'nodes',
        subBuilder: SliceCacheStatsNode.create)
    ..pPM<SliceCacheNodeFailure>(2, _omitFieldNames ? '' : 'failures',
        subBuilder: SliceCacheNodeFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSliceCacheStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSliceCacheStatsResponse copyWith(
          void Function(GetSliceCacheStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetSliceCacheStatsResponse))
          as GetSliceCacheStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSliceCacheStatsResponse create() => GetSliceCacheStatsResponse._();
  @$core.override
  GetSliceCacheStatsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSliceCacheStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSliceCacheStatsResponse>(create);
  static GetSliceCacheStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SliceCacheStatsNode> get nodes => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<SliceCacheNodeFailure> get failures => $_getList(1);
}

class PurgeSliceCacheNodeResult extends $pb.GeneratedMessage {
  factory PurgeSliceCacheNodeResult({
    $core.String? nodeId,
    $core.bool? success,
    $fixnum.Int64? removedEntries,
    $fixnum.Int64? freedBytes,
    SliceCacheStatsNode? stats,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (success != null) result.success = success;
    if (removedEntries != null) result.removedEntries = removedEntries;
    if (freedBytes != null) result.freedBytes = freedBytes;
    if (stats != null) result.stats = stats;
    return result;
  }

  PurgeSliceCacheNodeResult._();

  factory PurgeSliceCacheNodeResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurgeSliceCacheNodeResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurgeSliceCacheNodeResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'removedEntries', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'freedBytes', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<SliceCacheStatsNode>(5, _omitFieldNames ? '' : 'stats',
        subBuilder: SliceCacheStatsNode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeSliceCacheNodeResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeSliceCacheNodeResult copyWith(
          void Function(PurgeSliceCacheNodeResult) updates) =>
      super.copyWith((message) => updates(message as PurgeSliceCacheNodeResult))
          as PurgeSliceCacheNodeResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurgeSliceCacheNodeResult create() => PurgeSliceCacheNodeResult._();
  @$core.override
  PurgeSliceCacheNodeResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurgeSliceCacheNodeResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurgeSliceCacheNodeResult>(create);
  static PurgeSliceCacheNodeResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get removedEntries => $_getI64(2);
  @$pb.TagNumber(3)
  set removedEntries($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemovedEntries() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemovedEntries() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get freedBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set freedBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFreedBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearFreedBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  SliceCacheStatsNode get stats => $_getN(4);
  @$pb.TagNumber(5)
  set stats(SliceCacheStatsNode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStats() => $_has(4);
  @$pb.TagNumber(5)
  void clearStats() => $_clearField(5);
  @$pb.TagNumber(5)
  SliceCacheStatsNode ensureStats() => $_ensure(4);
}

class PurgeSliceCacheResponse extends $pb.GeneratedMessage {
  factory PurgeSliceCacheResponse({
    $core.bool? success,
    $fixnum.Int64? removedEntries,
    $fixnum.Int64? freedBytes,
    SliceCacheStatsNode? stats,
    $core.Iterable<PurgeSliceCacheNodeResult>? nodes,
    $core.Iterable<SliceCacheNodeFailure>? failures,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (removedEntries != null) result.removedEntries = removedEntries;
    if (freedBytes != null) result.freedBytes = freedBytes;
    if (stats != null) result.stats = stats;
    if (nodes != null) result.nodes.addAll(nodes);
    if (failures != null) result.failures.addAll(failures);
    return result;
  }

  PurgeSliceCacheResponse._();

  factory PurgeSliceCacheResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurgeSliceCacheResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurgeSliceCacheResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'removedEntries', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'freedBytes', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<SliceCacheStatsNode>(4, _omitFieldNames ? '' : 'stats',
        subBuilder: SliceCacheStatsNode.create)
    ..pPM<PurgeSliceCacheNodeResult>(5, _omitFieldNames ? '' : 'nodes',
        subBuilder: PurgeSliceCacheNodeResult.create)
    ..pPM<SliceCacheNodeFailure>(6, _omitFieldNames ? '' : 'failures',
        subBuilder: SliceCacheNodeFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeSliceCacheResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeSliceCacheResponse copyWith(
          void Function(PurgeSliceCacheResponse) updates) =>
      super.copyWith((message) => updates(message as PurgeSliceCacheResponse))
          as PurgeSliceCacheResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurgeSliceCacheResponse create() => PurgeSliceCacheResponse._();
  @$core.override
  PurgeSliceCacheResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurgeSliceCacheResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurgeSliceCacheResponse>(create);
  static PurgeSliceCacheResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get removedEntries => $_getI64(1);
  @$pb.TagNumber(2)
  set removedEntries($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemovedEntries() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemovedEntries() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get freedBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set freedBytes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFreedBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearFreedBytes() => $_clearField(3);

  @$pb.TagNumber(4)
  SliceCacheStatsNode get stats => $_getN(3);
  @$pb.TagNumber(4)
  set stats(SliceCacheStatsNode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStats() => $_has(3);
  @$pb.TagNumber(4)
  void clearStats() => $_clearField(4);
  @$pb.TagNumber(4)
  SliceCacheStatsNode ensureStats() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<PurgeSliceCacheNodeResult> get nodes => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<SliceCacheNodeFailure> get failures => $_getList(5);
}

class EvictExpiredSliceCacheNodeResult extends $pb.GeneratedMessage {
  factory EvictExpiredSliceCacheNodeResult({
    $core.String? nodeId,
    $core.bool? success,
    $fixnum.Int64? removedExpiredEntries,
    SliceCacheStatsNode? stats,
  }) {
    final result = create();
    if (nodeId != null) result.nodeId = nodeId;
    if (success != null) result.success = success;
    if (removedExpiredEntries != null)
      result.removedExpiredEntries = removedExpiredEntries;
    if (stats != null) result.stats = stats;
    return result;
  }

  EvictExpiredSliceCacheNodeResult._();

  factory EvictExpiredSliceCacheNodeResult.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvictExpiredSliceCacheNodeResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvictExpiredSliceCacheNodeResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'removedExpiredEntries', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<SliceCacheStatsNode>(4, _omitFieldNames ? '' : 'stats',
        subBuilder: SliceCacheStatsNode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvictExpiredSliceCacheNodeResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvictExpiredSliceCacheNodeResult copyWith(
          void Function(EvictExpiredSliceCacheNodeResult) updates) =>
      super.copyWith(
              (message) => updates(message as EvictExpiredSliceCacheNodeResult))
          as EvictExpiredSliceCacheNodeResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvictExpiredSliceCacheNodeResult create() =>
      EvictExpiredSliceCacheNodeResult._();
  @$core.override
  EvictExpiredSliceCacheNodeResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvictExpiredSliceCacheNodeResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvictExpiredSliceCacheNodeResult>(
          create);
  static EvictExpiredSliceCacheNodeResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get removedExpiredEntries => $_getI64(2);
  @$pb.TagNumber(3)
  set removedExpiredEntries($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRemovedExpiredEntries() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemovedExpiredEntries() => $_clearField(3);

  @$pb.TagNumber(4)
  SliceCacheStatsNode get stats => $_getN(3);
  @$pb.TagNumber(4)
  set stats(SliceCacheStatsNode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStats() => $_has(3);
  @$pb.TagNumber(4)
  void clearStats() => $_clearField(4);
  @$pb.TagNumber(4)
  SliceCacheStatsNode ensureStats() => $_ensure(3);
}

class EvictExpiredSliceCacheResponse extends $pb.GeneratedMessage {
  factory EvictExpiredSliceCacheResponse({
    $core.bool? success,
    $fixnum.Int64? removedExpiredEntries,
    SliceCacheStatsNode? stats,
    $core.Iterable<EvictExpiredSliceCacheNodeResult>? nodes,
    $core.Iterable<SliceCacheNodeFailure>? failures,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (removedExpiredEntries != null)
      result.removedExpiredEntries = removedExpiredEntries;
    if (stats != null) result.stats = stats;
    if (nodes != null) result.nodes.addAll(nodes);
    if (failures != null) result.failures.addAll(failures);
    return result;
  }

  EvictExpiredSliceCacheResponse._();

  factory EvictExpiredSliceCacheResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvictExpiredSliceCacheResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvictExpiredSliceCacheResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'removedExpiredEntries', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<SliceCacheStatsNode>(3, _omitFieldNames ? '' : 'stats',
        subBuilder: SliceCacheStatsNode.create)
    ..pPM<EvictExpiredSliceCacheNodeResult>(4, _omitFieldNames ? '' : 'nodes',
        subBuilder: EvictExpiredSliceCacheNodeResult.create)
    ..pPM<SliceCacheNodeFailure>(5, _omitFieldNames ? '' : 'failures',
        subBuilder: SliceCacheNodeFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvictExpiredSliceCacheResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvictExpiredSliceCacheResponse copyWith(
          void Function(EvictExpiredSliceCacheResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EvictExpiredSliceCacheResponse))
          as EvictExpiredSliceCacheResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvictExpiredSliceCacheResponse create() =>
      EvictExpiredSliceCacheResponse._();
  @$core.override
  EvictExpiredSliceCacheResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvictExpiredSliceCacheResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvictExpiredSliceCacheResponse>(create);
  static EvictExpiredSliceCacheResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get removedExpiredEntries => $_getI64(1);
  @$pb.TagNumber(2)
  set removedExpiredEntries($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemovedExpiredEntries() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemovedExpiredEntries() => $_clearField(2);

  @$pb.TagNumber(3)
  SliceCacheStatsNode get stats => $_getN(2);
  @$pb.TagNumber(3)
  set stats(SliceCacheStatsNode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStats() => $_has(2);
  @$pb.TagNumber(3)
  void clearStats() => $_clearField(3);
  @$pb.TagNumber(3)
  SliceCacheStatsNode ensureStats() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<EvictExpiredSliceCacheNodeResult> get nodes => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<SliceCacheNodeFailure> get failures => $_getList(4);
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

class ListContentReportsRequest extends $pb.GeneratedMessage {
  factory ListContentReportsRequest({
    $core.int? page,
    $core.int? pageSize,
    ContentReportStatus? status,
    ContentReportTargetType? targetType,
    $core.String? reporterUserId,
    $core.String? roomId,
    $core.String? search,
    $core.String? targetUserId,
    $core.String? targetMemberUserId,
    $fixnum.Int64? targetChatMessageId,
    $core.String? targetRoomId,
    $core.String? targetMemberRoomId,
    ContentReportScope? scope,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (status != null) result.status = status;
    if (targetType != null) result.targetType = targetType;
    if (reporterUserId != null) result.reporterUserId = reporterUserId;
    if (roomId != null) result.roomId = roomId;
    if (search != null) result.search = search;
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (targetMemberUserId != null)
      result.targetMemberUserId = targetMemberUserId;
    if (targetChatMessageId != null)
      result.targetChatMessageId = targetChatMessageId;
    if (targetRoomId != null) result.targetRoomId = targetRoomId;
    if (targetMemberRoomId != null)
      result.targetMemberRoomId = targetMemberRoomId;
    if (scope != null) result.scope = scope;
    return result;
  }

  ListContentReportsRequest._();

  factory ListContentReportsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListContentReportsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContentReportsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<ContentReportStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: ContentReportStatus.values)
    ..aE<ContentReportTargetType>(4, _omitFieldNames ? '' : 'targetType',
        enumValues: ContentReportTargetType.values)
    ..aOS(5, _omitFieldNames ? '' : 'reporterUserId')
    ..aOS(6, _omitFieldNames ? '' : 'roomId')
    ..aOS(7, _omitFieldNames ? '' : 'search')
    ..aOS(8, _omitFieldNames ? '' : 'targetUserId')
    ..aOS(9, _omitFieldNames ? '' : 'targetMemberUserId')
    ..aInt64(10, _omitFieldNames ? '' : 'targetChatMessageId')
    ..aOS(11, _omitFieldNames ? '' : 'targetRoomId')
    ..aOS(12, _omitFieldNames ? '' : 'targetMemberRoomId')
    ..aE<ContentReportScope>(13, _omitFieldNames ? '' : 'scope',
        enumValues: ContentReportScope.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentReportsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentReportsRequest copyWith(
          void Function(ListContentReportsRequest) updates) =>
      super.copyWith((message) => updates(message as ListContentReportsRequest))
          as ListContentReportsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListContentReportsRequest create() => ListContentReportsRequest._();
  @$core.override
  ListContentReportsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListContentReportsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContentReportsRequest>(create);
  static ListContentReportsRequest? _defaultInstance;

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
  ContentReportStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(ContentReportStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  ContentReportTargetType get targetType => $_getN(3);
  @$pb.TagNumber(4)
  set targetType(ContentReportTargetType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetType() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reporterUserId => $_getSZ(4);
  @$pb.TagNumber(5)
  set reporterUserId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReporterUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearReporterUserId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get roomId => $_getSZ(5);
  @$pb.TagNumber(6)
  set roomId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoomId() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoomId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get search => $_getSZ(6);
  @$pb.TagNumber(7)
  set search($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSearch() => $_has(6);
  @$pb.TagNumber(7)
  void clearSearch() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get targetUserId => $_getSZ(7);
  @$pb.TagNumber(8)
  set targetUserId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTargetUserId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTargetUserId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get targetMemberUserId => $_getSZ(8);
  @$pb.TagNumber(9)
  set targetMemberUserId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTargetMemberUserId() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetMemberUserId() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get targetChatMessageId => $_getI64(9);
  @$pb.TagNumber(10)
  set targetChatMessageId($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTargetChatMessageId() => $_has(9);
  @$pb.TagNumber(10)
  void clearTargetChatMessageId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get targetRoomId => $_getSZ(10);
  @$pb.TagNumber(11)
  set targetRoomId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTargetRoomId() => $_has(10);
  @$pb.TagNumber(11)
  void clearTargetRoomId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get targetMemberRoomId => $_getSZ(11);
  @$pb.TagNumber(12)
  set targetMemberRoomId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTargetMemberRoomId() => $_has(11);
  @$pb.TagNumber(12)
  void clearTargetMemberRoomId() => $_clearField(12);

  @$pb.TagNumber(13)
  ContentReportScope get scope => $_getN(12);
  @$pb.TagNumber(13)
  set scope(ContentReportScope value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasScope() => $_has(12);
  @$pb.TagNumber(13)
  void clearScope() => $_clearField(13);
}

class ListContentReportsResponse extends $pb.GeneratedMessage {
  factory ListContentReportsResponse({
    $core.Iterable<ContentReport>? reports,
    $core.int? total,
  }) {
    final result = create();
    if (reports != null) result.reports.addAll(reports);
    if (total != null) result.total = total;
    return result;
  }

  ListContentReportsResponse._();

  factory ListContentReportsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListContentReportsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContentReportsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..pPM<ContentReport>(1, _omitFieldNames ? '' : 'reports',
        subBuilder: ContentReport.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentReportsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContentReportsResponse copyWith(
          void Function(ListContentReportsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListContentReportsResponse))
          as ListContentReportsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListContentReportsResponse create() => ListContentReportsResponse._();
  @$core.override
  ListContentReportsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListContentReportsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContentReportsResponse>(create);
  static ListContentReportsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContentReport> get reports => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class GetContentReportRequest extends $pb.GeneratedMessage {
  factory GetContentReportRequest({
    $core.String? reportId,
  }) {
    final result = create();
    if (reportId != null) result.reportId = reportId;
    return result;
  }

  GetContentReportRequest._();

  factory GetContentReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetContentReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetContentReportRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContentReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContentReportRequest copyWith(
          void Function(GetContentReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetContentReportRequest))
          as GetContentReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetContentReportRequest create() => GetContentReportRequest._();
  @$core.override
  GetContentReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetContentReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetContentReportRequest>(create);
  static GetContentReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);
}

class UpdateContentReportStatusRequest extends $pb.GeneratedMessage {
  factory UpdateContentReportStatusRequest({
    $core.String? reportId,
    ContentReportStatus? status,
    $core.String? resolutionNote,
  }) {
    final result = create();
    if (reportId != null) result.reportId = reportId;
    if (status != null) result.status = status;
    if (resolutionNote != null) result.resolutionNote = resolutionNote;
    return result;
  }

  UpdateContentReportStatusRequest._();

  factory UpdateContentReportStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateContentReportStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateContentReportStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aE<ContentReportStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ContentReportStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'resolutionNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentReportStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentReportStatusRequest copyWith(
          void Function(UpdateContentReportStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateContentReportStatusRequest))
          as UpdateContentReportStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateContentReportStatusRequest create() =>
      UpdateContentReportStatusRequest._();
  @$core.override
  UpdateContentReportStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateContentReportStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateContentReportStatusRequest>(
          create);
  static UpdateContentReportStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  ContentReportStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ContentReportStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resolutionNote => $_getSZ(2);
  @$pb.TagNumber(3)
  set resolutionNote($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResolutionNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionNote() => $_clearField(3);
}

class UpdateContentReportStatusResponse extends $pb.GeneratedMessage {
  factory UpdateContentReportStatusResponse({
    ContentReport? report,
    $core.bool? success,
  }) {
    final result = create();
    if (report != null) result.report = report;
    if (success != null) result.success = success;
    return result;
  }

  UpdateContentReportStatusResponse._();

  factory UpdateContentReportStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateContentReportStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateContentReportStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.admin'),
      createEmptyInstance: create)
    ..aOM<ContentReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: ContentReport.create)
    ..aOB(2, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentReportStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateContentReportStatusResponse copyWith(
          void Function(UpdateContentReportStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as UpdateContentReportStatusResponse))
          as UpdateContentReportStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateContentReportStatusResponse create() =>
      UpdateContentReportStatusResponse._();
  @$core.override
  UpdateContentReportStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateContentReportStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateContentReportStatusResponse>(
          create);
  static UpdateContentReportStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContentReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(ContentReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  ContentReport ensureReport() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get success => $_getBF(1);
  @$pb.TagNumber(2)
  set success($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccess() => $_clearField(2);
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
/// SECURITY: User password operations revoke or initialize credentials through
/// the OPAQUE password reset flow. Admin APIs never receive user replacement
/// passwords.
class AdminServiceApi {
  final $pb.RpcClient _client;

  AdminServiceApi(this._client);

  /// =========================
  /// System Settings Management
  /// =========================
  $async.Future<RuntimeSettings> getSettings(
          $pb.ClientContext? ctx, GetSettingsRequest request) =>
      _client.invoke<RuntimeSettings>(
          ctx, 'AdminService', 'GetSettings', request, RuntimeSettings());
  $async.Future<RuntimeSettings> updateSettings(
          $pb.ClientContext? ctx, UpdateSettingsRequest request) =>
      _client.invoke<RuntimeSettings>(
          ctx, 'AdminService', 'UpdateSettings', request, RuntimeSettings());

  /// Root-only because the snapshot contains OAuth and SMTP credentials.
  $async.Future<RuntimeSettingsSnapshot> exportSettings(
          $pb.ClientContext? ctx, ExportSettingsRequest request) =>
      _client.invoke<RuntimeSettingsSnapshot>(ctx, 'AdminService',
          'ExportSettings', request, RuntimeSettingsSnapshot());

  /// Root-only because the import replaces all runtime settings.
  $async.Future<ImportSettingsResponse> importSettings(
          $pb.ClientContext? ctx, ImportSettingsRequest request) =>
      _client.invoke<ImportSettingsResponse>(ctx, 'AdminService',
          'ImportSettings', request, ImportSettingsResponse());
  $async.Future<SendTestEmailResponse> sendTestEmail(
          $pb.ClientContext? ctx, SendTestEmailRequest request) =>
      _client.invoke<SendTestEmailResponse>(ctx, 'AdminService',
          'SendTestEmail', request, SendTestEmailResponse());

  /// =========================
  /// User Management
  /// =========================
  $async.Future<AdminUser> createUser(
          $pb.ClientContext? ctx, CreateUserRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'CreateUser', request, AdminUser());
  $async.Future<DeleteUserResponse> deleteUser(
          $pb.ClientContext? ctx, DeleteUserRequest request) =>
      _client.invoke<DeleteUserResponse>(
          ctx, 'AdminService', 'DeleteUser', request, DeleteUserResponse());
  $async.Future<RestoreUserResponse> restoreUser(
          $pb.ClientContext? ctx, RestoreUserRequest request) =>
      _client.invoke<RestoreUserResponse>(
          ctx, 'AdminService', 'RestoreUser', request, RestoreUserResponse());
  $async.Future<ListUsersResponse> listUsers(
          $pb.ClientContext? ctx, ListUsersRequest request) =>
      _client.invoke<ListUsersResponse>(
          ctx, 'AdminService', 'ListUsers', request, ListUsersResponse());
  $async.Future<AdminUser> getUser(
          $pb.ClientContext? ctx, GetUserRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'GetUser', request, AdminUser());
  $async.Future<GetUserPreferencesResponse> getUserPreferences(
          $pb.ClientContext? ctx, GetUserPreferencesRequest request) =>
      _client.invoke<GetUserPreferencesResponse>(ctx, 'AdminService',
          'GetUserPreferences', request, GetUserPreferencesResponse());
  $async.Future<UpdateUserPreferencesResponse> updateUserPreferences(
          $pb.ClientContext? ctx, UpdateUserPreferencesRequest request) =>
      _client.invoke<UpdateUserPreferencesResponse>(ctx, 'AdminService',
          'UpdateUserPreferences', request, UpdateUserPreferencesResponse());
  $async.Future<SetUserPasswordResponse> setUserPassword(
          $pb.ClientContext? ctx, SetUserPasswordRequest request) =>
      _client.invoke<SetUserPasswordResponse>(ctx, 'AdminService',
          'SetUserPassword', request, SetUserPasswordResponse());
  $async.Future<AdminUser> updateUserUsername(
          $pb.ClientContext? ctx, UpdateUserUsernameRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'UpdateUserUsername', request, AdminUser());
  $async.Future<AdminUser> updateUserRole(
          $pb.ClientContext? ctx, UpdateUserRoleRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'UpdateUserRole', request, AdminUser());
  $async.Future<AdminUser> banUser(
          $pb.ClientContext? ctx, BanUserRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'BanUser', request, AdminUser());
  $async.Future<AdminUser> unbanUser(
          $pb.ClientContext? ctx, UnbanUserRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'UnbanUser', request, AdminUser());
  $async.Future<ModerateRoomChatUserResponse> moderateRoomChatUser(
          $pb.ClientContext? ctx, ModerateRoomChatUserRequest request) =>
      _client.invoke<ModerateRoomChatUserResponse>(ctx, 'AdminService',
          'ModerateRoomChatUser', request, ModerateRoomChatUserResponse());
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
  $async.Future<Room> getRoom($pb.ClientContext? ctx, GetRoomRequest request) =>
      _client.invoke<Room>(ctx, 'AdminService', 'GetRoom', request, Room());
  $async.Future<GetRoomSettingsResponse> getRoomSettings(
          $pb.ClientContext? ctx, GetRoomSettingsRequest request) =>
      _client.invoke<GetRoomSettingsResponse>(ctx, 'AdminService',
          'GetRoomSettings', request, GetRoomSettingsResponse());
  $async.Future<Room> updateRoomSettings(
          $pb.ClientContext? ctx, UpdateRoomSettingsRequest request) =>
      _client.invoke<Room>(
          ctx, 'AdminService', 'UpdateRoomSettings', request, Room());
  $async.Future<Room> resetRoomSettings(
          $pb.ClientContext? ctx, ResetRoomSettingsRequest request) =>
      _client.invoke<Room>(
          ctx, 'AdminService', 'ResetRoomSettings', request, Room());
  $async.Future<UpdateRoomPasswordResponse> updateRoomPassword(
          $pb.ClientContext? ctx, UpdateRoomPasswordRequest request) =>
      _client.invoke<UpdateRoomPasswordResponse>(ctx, 'AdminService',
          'UpdateRoomPassword', request, UpdateRoomPasswordResponse());
  $async.Future<DeleteRoomResponse> deleteRoom(
          $pb.ClientContext? ctx, DeleteRoomRequest request) =>
      _client.invoke<DeleteRoomResponse>(
          ctx, 'AdminService', 'DeleteRoom', request, DeleteRoomResponse());
  $async.Future<Room> banRoom($pb.ClientContext? ctx, BanRoomRequest request) =>
      _client.invoke<Room>(ctx, 'AdminService', 'BanRoom', request, Room());
  $async.Future<Room> unbanRoom(
          $pb.ClientContext? ctx, UnbanRoomRequest request) =>
      _client.invoke<Room>(ctx, 'AdminService', 'UnbanRoom', request, Room());
  $async.Future<GetRoomMembersResponse> getRoomMembers(
          $pb.ClientContext? ctx, GetRoomMembersRequest request) =>
      _client.invoke<GetRoomMembersResponse>(ctx, 'AdminService',
          'GetRoomMembers', request, GetRoomMembersResponse());
  $async.Future<$0.RoomMember> addMember(
          $pb.ClientContext? ctx, AddMemberRequest request) =>
      _client.invoke<$0.RoomMember>(
          ctx, 'AdminService', 'AddMember', request, $0.RoomMember());
  $async.Future<$0.RoomMember> updateMemberRemarkName(
          $pb.ClientContext? ctx, UpdateMemberRemarkNameRequest request) =>
      _client.invoke<$0.RoomMember>(ctx, 'AdminService',
          'UpdateMemberRemarkName', request, $0.RoomMember());
  $async.Future<$0.RoomMember> updateMemberDisplayTag(
          $pb.ClientContext? ctx, UpdateMemberDisplayTagRequest request) =>
      _client.invoke<$0.RoomMember>(ctx, 'AdminService',
          'UpdateMemberDisplayTag', request, $0.RoomMember());
  $async.Future<$0.RoomMember> updateMemberPermissions(
          $pb.ClientContext? ctx, UpdateMemberPermissionsRequest request) =>
      _client.invoke<$0.RoomMember>(ctx, 'AdminService',
          'UpdateMemberPermissions', request, $0.RoomMember());
  $async.Future<KickMemberResponse> kickMember(
          $pb.ClientContext? ctx, KickMemberRequest request) =>
      _client.invoke<KickMemberResponse>(
          ctx, 'AdminService', 'KickMember', request, KickMemberResponse());
  $async.Future<ListRoomCategoriesResponse> listRoomCategories(
          $pb.ClientContext? ctx, ListRoomCategoriesRequest request) =>
      _client.invoke<ListRoomCategoriesResponse>(ctx, 'AdminService',
          'ListRoomCategories', request, ListRoomCategoriesResponse());
  $async.Future<$1.RoomCategory> upsertRoomCategory(
          $pb.ClientContext? ctx, UpsertRoomCategoryRequest request) =>
      _client.invoke<$1.RoomCategory>(ctx, 'AdminService', 'UpsertRoomCategory',
          request, $1.RoomCategory());
  $async.Future<DeleteRoomCategoryResponse> deleteRoomCategory(
          $pb.ClientContext? ctx, DeleteRoomCategoryRequest request) =>
      _client.invoke<DeleteRoomCategoryResponse>(ctx, 'AdminService',
          'DeleteRoomCategory', request, DeleteRoomCategoryResponse());
  $async.Future<ListRoomLabelsResponse> listRoomLabels(
          $pb.ClientContext? ctx, ListRoomLabelsRequest request) =>
      _client.invoke<ListRoomLabelsResponse>(ctx, 'AdminService',
          'ListRoomLabels', request, ListRoomLabelsResponse());
  $async.Future<$1.RoomLabel> upsertRoomLabel(
          $pb.ClientContext? ctx, UpsertRoomLabelRequest request) =>
      _client.invoke<$1.RoomLabel>(
          ctx, 'AdminService', 'UpsertRoomLabel', request, $1.RoomLabel());
  $async.Future<DeleteRoomLabelResponse> deleteRoomLabel(
          $pb.ClientContext? ctx, DeleteRoomLabelRequest request) =>
      _client.invoke<DeleteRoomLabelResponse>(ctx, 'AdminService',
          'DeleteRoomLabel', request, DeleteRoomLabelResponse());
  $async.Future<Room> updateRoomTaxonomy(
          $pb.ClientContext? ctx, UpdateRoomTaxonomyRequest request) =>
      _client.invoke<Room>(
          ctx, 'AdminService', 'UpdateRoomTaxonomy', request, Room());

  /// =========================
  /// Admin Management (Root Only)
  /// =========================
  $async.Future<AdminUser> addAdmin(
          $pb.ClientContext? ctx, AddAdminRequest request) =>
      _client.invoke<AdminUser>(
          ctx, 'AdminService', 'AddAdmin', request, AdminUser());
  $async.Future<RemoveAdminResponse> removeAdmin(
          $pb.ClientContext? ctx, RemoveAdminRequest request) =>
      _client.invoke<RemoveAdminResponse>(
          ctx, 'AdminService', 'RemoveAdmin', request, RemoveAdminResponse());
  $async.Future<ListAdminsResponse> listAdmins(
          $pb.ClientContext? ctx, ListAdminsRequest request) =>
      _client.invoke<ListAdminsResponse>(
          ctx, 'AdminService', 'ListAdmins', request, ListAdminsResponse());

  /// =========================
  /// Service State
  /// =========================
  $async.Future<GetServiceStateResponse> getServiceState(
          $pb.ClientContext? ctx, GetServiceStateRequest request) =>
      _client.invoke<GetServiceStateResponse>(ctx, 'AdminService',
          'GetServiceState', request, GetServiceStateResponse());

  /// =========================
  /// Slice Cache Management
  /// =========================
  $async.Future<GetSliceCacheStatsResponse> getSliceCacheStats(
          $pb.ClientContext? ctx, GetSliceCacheStatsRequest request) =>
      _client.invoke<GetSliceCacheStatsResponse>(ctx, 'AdminService',
          'GetSliceCacheStats', request, GetSliceCacheStatsResponse());
  $async.Future<PurgeSliceCacheResponse> purgeSliceCache(
          $pb.ClientContext? ctx, PurgeSliceCacheRequest request) =>
      _client.invoke<PurgeSliceCacheResponse>(ctx, 'AdminService',
          'PurgeSliceCache', request, PurgeSliceCacheResponse());
  $async.Future<EvictExpiredSliceCacheResponse> evictExpiredSliceCache(
          $pb.ClientContext? ctx, EvictExpiredSliceCacheRequest request) =>
      _client.invoke<EvictExpiredSliceCacheResponse>(ctx, 'AdminService',
          'EvictExpiredSliceCache', request, EvictExpiredSliceCacheResponse());

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
  $async.Future<UserRegistrationReview> rejectUserRegistrationReview(
          $pb.ClientContext? ctx,
          RejectUserRegistrationReviewRequest request) =>
      _client.invoke<UserRegistrationReview>(ctx, 'AdminService',
          'RejectUserRegistrationReview', request, UserRegistrationReview());
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
  $async.Future<RoomCreationReview> rejectRoomCreationReview(
          $pb.ClientContext? ctx, RejectRoomCreationReviewRequest request) =>
      _client.invoke<RoomCreationReview>(ctx, 'AdminService',
          'RejectRoomCreationReview', request, RoomCreationReview());
  $async.Future<ListRoomJoinReviewsResponse> listRoomJoinReviews(
          $pb.ClientContext? ctx, ListRoomJoinReviewsRequest request) =>
      _client.invoke<ListRoomJoinReviewsResponse>(ctx, 'AdminService',
          'ListRoomJoinReviews', request, ListRoomJoinReviewsResponse());
  $async.Future<ApproveRoomJoinReviewResponse> approveRoomJoinReview(
          $pb.ClientContext? ctx, ApproveRoomJoinReviewRequest request) =>
      _client.invoke<ApproveRoomJoinReviewResponse>(ctx, 'AdminService',
          'ApproveRoomJoinReview', request, ApproveRoomJoinReviewResponse());
  $async.Future<RoomJoinReview> rejectRoomJoinReview(
          $pb.ClientContext? ctx, RejectRoomJoinReviewRequest request) =>
      _client.invoke<RoomJoinReview>(ctx, 'AdminService',
          'RejectRoomJoinReview', request, RoomJoinReview());

  /// =========================
  /// Moderation Bans
  /// =========================
  $async.Future<ListBanRecordsResponse> listBanRecords(
          $pb.ClientContext? ctx, ListBanRecordsRequest request) =>
      _client.invoke<ListBanRecordsResponse>(ctx, 'AdminService',
          'ListBanRecords', request, ListBanRecordsResponse());

  /// =========================
  /// Moderation Reports
  /// =========================
  $async.Future<ListContentReportsResponse> listContentReports(
          $pb.ClientContext? ctx, ListContentReportsRequest request) =>
      _client.invoke<ListContentReportsResponse>(ctx, 'AdminService',
          'ListContentReports', request, ListContentReportsResponse());
  $async.Future<ContentReport> getContentReport(
          $pb.ClientContext? ctx, GetContentReportRequest request) =>
      _client.invoke<ContentReport>(
          ctx, 'AdminService', 'GetContentReport', request, ContentReport());
  $async.Future<UpdateContentReportStatusResponse> updateContentReportStatus(
          $pb.ClientContext? ctx, UpdateContentReportStatusRequest request) =>
      _client.invoke<UpdateContentReportStatusResponse>(
          ctx,
          'AdminService',
          'UpdateContentReportStatus',
          request,
          UpdateContentReportStatusResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
