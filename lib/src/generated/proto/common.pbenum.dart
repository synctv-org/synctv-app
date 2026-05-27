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

import 'package:protobuf/protobuf.dart' as $pb;

/// Global user role for RBAC
class UserRole extends $pb.ProtobufEnum {
  static const UserRole USER_ROLE_UNSPECIFIED =
      UserRole._(0, _omitEnumNames ? '' : 'USER_ROLE_UNSPECIFIED');
  static const UserRole USER_ROLE_ROOT =
      UserRole._(1, _omitEnumNames ? '' : 'USER_ROLE_ROOT');
  static const UserRole USER_ROLE_ADMIN =
      UserRole._(2, _omitEnumNames ? '' : 'USER_ROLE_ADMIN');
  static const UserRole USER_ROLE_USER =
      UserRole._(3, _omitEnumNames ? '' : 'USER_ROLE_USER');

  static const $core.List<UserRole> values = <UserRole>[
    USER_ROLE_UNSPECIFIED,
    USER_ROLE_ROOT,
    USER_ROLE_ADMIN,
    USER_ROLE_USER,
  ];

  static final $core.List<UserRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static UserRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserRole._(super.value, super.name);
}

/// Effective account availability. Registration review is represented by ReviewStatus on request APIs.
class UserStatus extends $pb.ProtobufEnum {
  static const UserStatus USER_STATUS_UNSPECIFIED =
      UserStatus._(0, _omitEnumNames ? '' : 'USER_STATUS_UNSPECIFIED');
  static const UserStatus USER_STATUS_ACTIVE =
      UserStatus._(1, _omitEnumNames ? '' : 'USER_STATUS_ACTIVE');
  static const UserStatus USER_STATUS_BANNED =
      UserStatus._(2, _omitEnumNames ? '' : 'USER_STATUS_BANNED');

  static const $core.List<UserStatus> values = <UserStatus>[
    USER_STATUS_UNSPECIFIED,
    USER_STATUS_ACTIVE,
    USER_STATUS_BANNED,
  ];

  static final $core.List<UserStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static UserStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserStatus._(super.value, super.name);
}

/// Room member role
class RoomMemberRole extends $pb.ProtobufEnum {
  static const RoomMemberRole ROOM_MEMBER_ROLE_UNSPECIFIED =
      RoomMemberRole._(0, _omitEnumNames ? '' : 'ROOM_MEMBER_ROLE_UNSPECIFIED');
  static const RoomMemberRole ROOM_MEMBER_ROLE_CREATOR =
      RoomMemberRole._(1, _omitEnumNames ? '' : 'ROOM_MEMBER_ROLE_CREATOR');
  static const RoomMemberRole ROOM_MEMBER_ROLE_ADMIN =
      RoomMemberRole._(2, _omitEnumNames ? '' : 'ROOM_MEMBER_ROLE_ADMIN');
  static const RoomMemberRole ROOM_MEMBER_ROLE_MEMBER =
      RoomMemberRole._(3, _omitEnumNames ? '' : 'ROOM_MEMBER_ROLE_MEMBER');
  static const RoomMemberRole ROOM_MEMBER_ROLE_GUEST =
      RoomMemberRole._(4, _omitEnumNames ? '' : 'ROOM_MEMBER_ROLE_GUEST');

  static const $core.List<RoomMemberRole> values = <RoomMemberRole>[
    ROOM_MEMBER_ROLE_UNSPECIFIED,
    ROOM_MEMBER_ROLE_CREATOR,
    ROOM_MEMBER_ROLE_ADMIN,
    ROOM_MEMBER_ROLE_MEMBER,
    ROOM_MEMBER_ROLE_GUEST,
  ];

  static final $core.List<RoomMemberRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RoomMemberRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomMemberRole._(super.value, super.name);
}

class MemberStatus extends $pb.ProtobufEnum {
  static const MemberStatus MEMBER_STATUS_UNSPECIFIED =
      MemberStatus._(0, _omitEnumNames ? '' : 'MEMBER_STATUS_UNSPECIFIED');
  static const MemberStatus MEMBER_STATUS_ACTIVE =
      MemberStatus._(1, _omitEnumNames ? '' : 'MEMBER_STATUS_ACTIVE');

  static const $core.List<MemberStatus> values = <MemberStatus>[
    MEMBER_STATUS_UNSPECIFIED,
    MEMBER_STATUS_ACTIVE,
  ];

  static final $core.List<MemberStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static MemberStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MemberStatus._(super.value, super.name);
}

/// Room lifecycle status. Banned state is tracked via is_banned.
class RoomStatus extends $pb.ProtobufEnum {
  static const RoomStatus ROOM_STATUS_UNSPECIFIED =
      RoomStatus._(0, _omitEnumNames ? '' : 'ROOM_STATUS_UNSPECIFIED');
  static const RoomStatus ROOM_STATUS_ACTIVE =
      RoomStatus._(1, _omitEnumNames ? '' : 'ROOM_STATUS_ACTIVE');
  static const RoomStatus ROOM_STATUS_CLOSED =
      RoomStatus._(2, _omitEnumNames ? '' : 'ROOM_STATUS_CLOSED');

  static const $core.List<RoomStatus> values = <RoomStatus>[
    ROOM_STATUS_UNSPECIFIED,
    ROOM_STATUS_ACTIVE,
    ROOM_STATUS_CLOSED,
  ];

  static final $core.List<RoomStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RoomStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomStatus._(super.value, super.name);
}

/// Human review workflow status for request resources.
class ReviewStatus extends $pb.ProtobufEnum {
  static const ReviewStatus REVIEW_STATUS_UNSPECIFIED =
      ReviewStatus._(0, _omitEnumNames ? '' : 'REVIEW_STATUS_UNSPECIFIED');
  static const ReviewStatus REVIEW_STATUS_PENDING =
      ReviewStatus._(1, _omitEnumNames ? '' : 'REVIEW_STATUS_PENDING');
  static const ReviewStatus REVIEW_STATUS_APPROVED =
      ReviewStatus._(2, _omitEnumNames ? '' : 'REVIEW_STATUS_APPROVED');
  static const ReviewStatus REVIEW_STATUS_REJECTED =
      ReviewStatus._(3, _omitEnumNames ? '' : 'REVIEW_STATUS_REJECTED');

  static const $core.List<ReviewStatus> values = <ReviewStatus>[
    REVIEW_STATUS_UNSPECIFIED,
    REVIEW_STATUS_PENDING,
    REVIEW_STATUS_APPROVED,
    REVIEW_STATUS_REJECTED,
  ];

  static final $core.List<ReviewStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ReviewStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReviewStatus._(super.value, super.name);
}

class ListSortDirection extends $pb.ProtobufEnum {
  static const ListSortDirection LIST_SORT_DIRECTION_UNSPECIFIED =
      ListSortDirection._(
          0, _omitEnumNames ? '' : 'LIST_SORT_DIRECTION_UNSPECIFIED');
  static const ListSortDirection LIST_SORT_DIRECTION_ASC =
      ListSortDirection._(1, _omitEnumNames ? '' : 'LIST_SORT_DIRECTION_ASC');
  static const ListSortDirection LIST_SORT_DIRECTION_DESC =
      ListSortDirection._(2, _omitEnumNames ? '' : 'LIST_SORT_DIRECTION_DESC');

  static const $core.List<ListSortDirection> values = <ListSortDirection>[
    LIST_SORT_DIRECTION_UNSPECIFIED,
    LIST_SORT_DIRECTION_ASC,
    LIST_SORT_DIRECTION_DESC,
  ];

  static final $core.List<ListSortDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ListSortDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ListSortDirection._(super.value, super.name);
}

/// Error codes for ErrorMessage
class ErrorCode extends $pb.ProtobufEnum {
  static const ErrorCode ERROR_CODE_UNSPECIFIED =
      ErrorCode._(0, _omitEnumNames ? '' : 'ERROR_CODE_UNSPECIFIED');
  static const ErrorCode ERROR_CODE_UNAUTHORIZED =
      ErrorCode._(1, _omitEnumNames ? '' : 'ERROR_CODE_UNAUTHORIZED');
  static const ErrorCode ERROR_CODE_FORBIDDEN =
      ErrorCode._(2, _omitEnumNames ? '' : 'ERROR_CODE_FORBIDDEN');
  static const ErrorCode ERROR_CODE_NOT_FOUND =
      ErrorCode._(3, _omitEnumNames ? '' : 'ERROR_CODE_NOT_FOUND');
  static const ErrorCode ERROR_CODE_RATE_LIMITED =
      ErrorCode._(4, _omitEnumNames ? '' : 'ERROR_CODE_RATE_LIMITED');
  static const ErrorCode ERROR_CODE_VALIDATION_FAILED =
      ErrorCode._(5, _omitEnumNames ? '' : 'ERROR_CODE_VALIDATION_FAILED');
  static const ErrorCode ERROR_CODE_INTERNAL =
      ErrorCode._(6, _omitEnumNames ? '' : 'ERROR_CODE_INTERNAL');

  static const $core.List<ErrorCode> values = <ErrorCode>[
    ERROR_CODE_UNSPECIFIED,
    ERROR_CODE_UNAUTHORIZED,
    ERROR_CODE_FORBIDDEN,
    ERROR_CODE_NOT_FOUND,
    ERROR_CODE_RATE_LIMITED,
    ERROR_CODE_VALIDATION_FAILED,
    ERROR_CODE_INTERNAL,
  ];

  static final $core.List<ErrorCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ErrorCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ErrorCode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
