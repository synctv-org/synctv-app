// This is a generated file - do not edit.
//
// Generated from proto/admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class BanTargetType extends $pb.ProtobufEnum {
  static const BanTargetType BAN_TARGET_TYPE_UNSPECIFIED =
      BanTargetType._(0, _omitEnumNames ? '' : 'BAN_TARGET_TYPE_UNSPECIFIED');
  static const BanTargetType BAN_TARGET_TYPE_USER =
      BanTargetType._(1, _omitEnumNames ? '' : 'BAN_TARGET_TYPE_USER');
  static const BanTargetType BAN_TARGET_TYPE_ROOM =
      BanTargetType._(2, _omitEnumNames ? '' : 'BAN_TARGET_TYPE_ROOM');

  static const $core.List<BanTargetType> values = <BanTargetType>[
    BAN_TARGET_TYPE_UNSPECIFIED,
    BAN_TARGET_TYPE_USER,
    BAN_TARGET_TYPE_ROOM,
  ];

  static final $core.List<BanTargetType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static BanTargetType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BanTargetType._(super.value, super.name);
}

class SortDirection extends $pb.ProtobufEnum {
  static const SortDirection SORT_DIRECTION_UNSPECIFIED =
      SortDirection._(0, _omitEnumNames ? '' : 'SORT_DIRECTION_UNSPECIFIED');
  static const SortDirection SORT_DIRECTION_ASC =
      SortDirection._(1, _omitEnumNames ? '' : 'SORT_DIRECTION_ASC');
  static const SortDirection SORT_DIRECTION_DESC =
      SortDirection._(2, _omitEnumNames ? '' : 'SORT_DIRECTION_DESC');

  static const $core.List<SortDirection> values = <SortDirection>[
    SORT_DIRECTION_UNSPECIFIED,
    SORT_DIRECTION_ASC,
    SORT_DIRECTION_DESC,
  ];

  static final $core.List<SortDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SortDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SortDirection._(super.value, super.name);
}

class UserListSortBy extends $pb.ProtobufEnum {
  static const UserListSortBy USER_LIST_SORT_BY_UNSPECIFIED = UserListSortBy._(
      0, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_UNSPECIFIED');
  static const UserListSortBy USER_LIST_SORT_BY_CREATED_AT =
      UserListSortBy._(1, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_CREATED_AT');
  static const UserListSortBy USER_LIST_SORT_BY_UPDATED_AT =
      UserListSortBy._(2, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_UPDATED_AT');
  static const UserListSortBy USER_LIST_SORT_BY_USERNAME =
      UserListSortBy._(3, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_USERNAME');
  static const UserListSortBy USER_LIST_SORT_BY_EMAIL =
      UserListSortBy._(4, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_EMAIL');
  static const UserListSortBy USER_LIST_SORT_BY_STATUS =
      UserListSortBy._(5, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_STATUS');
  static const UserListSortBy USER_LIST_SORT_BY_ROLE =
      UserListSortBy._(6, _omitEnumNames ? '' : 'USER_LIST_SORT_BY_ROLE');

  static const $core.List<UserListSortBy> values = <UserListSortBy>[
    USER_LIST_SORT_BY_UNSPECIFIED,
    USER_LIST_SORT_BY_CREATED_AT,
    USER_LIST_SORT_BY_UPDATED_AT,
    USER_LIST_SORT_BY_USERNAME,
    USER_LIST_SORT_BY_EMAIL,
    USER_LIST_SORT_BY_STATUS,
    USER_LIST_SORT_BY_ROLE,
  ];

  static final $core.List<UserListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static UserListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserListSortBy._(super.value, super.name);
}

class RoomListSortBy extends $pb.ProtobufEnum {
  static const RoomListSortBy ROOM_LIST_SORT_BY_UNSPECIFIED = RoomListSortBy._(
      0, _omitEnumNames ? '' : 'ROOM_LIST_SORT_BY_UNSPECIFIED');
  static const RoomListSortBy ROOM_LIST_SORT_BY_CREATED_AT =
      RoomListSortBy._(1, _omitEnumNames ? '' : 'ROOM_LIST_SORT_BY_CREATED_AT');
  static const RoomListSortBy ROOM_LIST_SORT_BY_UPDATED_AT =
      RoomListSortBy._(2, _omitEnumNames ? '' : 'ROOM_LIST_SORT_BY_UPDATED_AT');
  static const RoomListSortBy ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT =
      RoomListSortBy._(
          3, _omitEnumNames ? '' : 'ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT');
  static const RoomListSortBy ROOM_LIST_SORT_BY_NAME =
      RoomListSortBy._(4, _omitEnumNames ? '' : 'ROOM_LIST_SORT_BY_NAME');

  static const $core.List<RoomListSortBy> values = <RoomListSortBy>[
    ROOM_LIST_SORT_BY_UNSPECIFIED,
    ROOM_LIST_SORT_BY_CREATED_AT,
    ROOM_LIST_SORT_BY_UPDATED_AT,
    ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
    ROOM_LIST_SORT_BY_NAME,
  ];

  static final $core.List<RoomListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RoomListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomListSortBy._(super.value, super.name);
}

class RoomMemberListSortBy extends $pb.ProtobufEnum {
  static const RoomMemberListSortBy ROOM_MEMBER_LIST_SORT_BY_UNSPECIFIED =
      RoomMemberListSortBy._(
          0, _omitEnumNames ? '' : 'ROOM_MEMBER_LIST_SORT_BY_UNSPECIFIED');
  static const RoomMemberListSortBy ROOM_MEMBER_LIST_SORT_BY_JOINED_AT =
      RoomMemberListSortBy._(
          1, _omitEnumNames ? '' : 'ROOM_MEMBER_LIST_SORT_BY_JOINED_AT');
  static const RoomMemberListSortBy ROOM_MEMBER_LIST_SORT_BY_USERNAME =
      RoomMemberListSortBy._(
          2, _omitEnumNames ? '' : 'ROOM_MEMBER_LIST_SORT_BY_USERNAME');
  static const RoomMemberListSortBy ROOM_MEMBER_LIST_SORT_BY_ROLE =
      RoomMemberListSortBy._(
          3, _omitEnumNames ? '' : 'ROOM_MEMBER_LIST_SORT_BY_ROLE');

  static const $core.List<RoomMemberListSortBy> values = <RoomMemberListSortBy>[
    ROOM_MEMBER_LIST_SORT_BY_UNSPECIFIED,
    ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
    ROOM_MEMBER_LIST_SORT_BY_USERNAME,
    ROOM_MEMBER_LIST_SORT_BY_ROLE,
  ];

  static final $core.List<RoomMemberListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RoomMemberListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomMemberListSortBy._(super.value, super.name);
}

class ActiveStreamListSortBy extends $pb.ProtobufEnum {
  static const ActiveStreamListSortBy ACTIVE_STREAM_LIST_SORT_BY_UNSPECIFIED =
      ActiveStreamListSortBy._(
          0, _omitEnumNames ? '' : 'ACTIVE_STREAM_LIST_SORT_BY_UNSPECIFIED');
  static const ActiveStreamListSortBy ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT =
      ActiveStreamListSortBy._(
          1, _omitEnumNames ? '' : 'ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT');
  static const ActiveStreamListSortBy ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID =
      ActiveStreamListSortBy._(
          2, _omitEnumNames ? '' : 'ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID');
  static const ActiveStreamListSortBy ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID =
      ActiveStreamListSortBy._(
          3, _omitEnumNames ? '' : 'ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID');
  static const ActiveStreamListSortBy ACTIVE_STREAM_LIST_SORT_BY_USER_ID =
      ActiveStreamListSortBy._(
          4, _omitEnumNames ? '' : 'ACTIVE_STREAM_LIST_SORT_BY_USER_ID');
  static const ActiveStreamListSortBy ACTIVE_STREAM_LIST_SORT_BY_NODE_ID =
      ActiveStreamListSortBy._(
          5, _omitEnumNames ? '' : 'ACTIVE_STREAM_LIST_SORT_BY_NODE_ID');

  static const $core.List<ActiveStreamListSortBy> values =
      <ActiveStreamListSortBy>[
    ACTIVE_STREAM_LIST_SORT_BY_UNSPECIFIED,
    ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
    ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID,
    ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID,
    ACTIVE_STREAM_LIST_SORT_BY_USER_ID,
    ACTIVE_STREAM_LIST_SORT_BY_NODE_ID,
  ];

  static final $core.List<ActiveStreamListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ActiveStreamListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActiveStreamListSortBy._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
