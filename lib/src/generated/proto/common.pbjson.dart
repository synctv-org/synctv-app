// This is a generated file - do not edit.
//
// Generated from proto/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userRoleDescriptor instead')
const UserRole$json = {
  '1': 'UserRole',
  '2': [
    {'1': 'USER_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'USER_ROLE_ROOT', '2': 1},
    {'1': 'USER_ROLE_ADMIN', '2': 2},
    {'1': 'USER_ROLE_USER', '2': 3},
  ],
};

/// Descriptor for `UserRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userRoleDescriptor = $convert.base64Decode(
    'CghVc2VyUm9sZRIZChVVU0VSX1JPTEVfVU5TUEVDSUZJRUQQABISCg5VU0VSX1JPTEVfUk9PVB'
    'ABEhMKD1VTRVJfUk9MRV9BRE1JThACEhIKDlVTRVJfUk9MRV9VU0VSEAM=');

@$core.Deprecated('Use userStatusDescriptor instead')
const UserStatus$json = {
  '1': 'UserStatus',
  '2': [
    {'1': 'USER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'USER_STATUS_ACTIVE', '2': 1},
    {'1': 'USER_STATUS_BANNED', '2': 2},
  ],
};

/// Descriptor for `UserStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userStatusDescriptor = $convert.base64Decode(
    'CgpVc2VyU3RhdHVzEhsKF1VTRVJfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFgoSVVNFUl9TVEFUVV'
    'NfQUNUSVZFEAESFgoSVVNFUl9TVEFUVVNfQkFOTkVEEAI=');

@$core.Deprecated('Use roomMemberRoleDescriptor instead')
const RoomMemberRole$json = {
  '1': 'RoomMemberRole',
  '2': [
    {'1': 'ROOM_MEMBER_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_MEMBER_ROLE_CREATOR', '2': 1},
    {'1': 'ROOM_MEMBER_ROLE_ADMIN', '2': 2},
    {'1': 'ROOM_MEMBER_ROLE_MEMBER', '2': 3},
    {'1': 'ROOM_MEMBER_ROLE_GUEST', '2': 4},
  ],
};

/// Descriptor for `RoomMemberRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomMemberRoleDescriptor = $convert.base64Decode(
    'Cg5Sb29tTWVtYmVyUm9sZRIgChxST09NX01FTUJFUl9ST0xFX1VOU1BFQ0lGSUVEEAASHAoYUk'
    '9PTV9NRU1CRVJfUk9MRV9DUkVBVE9SEAESGgoWUk9PTV9NRU1CRVJfUk9MRV9BRE1JThACEhsK'
    'F1JPT01fTUVNQkVSX1JPTEVfTUVNQkVSEAMSGgoWUk9PTV9NRU1CRVJfUk9MRV9HVUVTVBAE');

@$core.Deprecated('Use memberStatusDescriptor instead')
const MemberStatus$json = {
  '1': 'MemberStatus',
  '2': [
    {'1': 'MEMBER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MEMBER_STATUS_ACTIVE', '2': 1},
  ],
};

/// Descriptor for `MemberStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List memberStatusDescriptor = $convert.base64Decode(
    'CgxNZW1iZXJTdGF0dXMSHQoZTUVNQkVSX1NUQVRVU19VTlNQRUNJRklFRBAAEhgKFE1FTUJFUl'
    '9TVEFUVVNfQUNUSVZFEAE=');

@$core.Deprecated('Use roomStatusDescriptor instead')
const RoomStatus$json = {
  '1': 'RoomStatus',
  '2': [
    {'1': 'ROOM_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_STATUS_ACTIVE', '2': 1},
    {'1': 'ROOM_STATUS_CLOSED', '2': 2},
  ],
};

/// Descriptor for `RoomStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomStatusDescriptor = $convert.base64Decode(
    'CgpSb29tU3RhdHVzEhsKF1JPT01fU1RBVFVTX1VOU1BFQ0lGSUVEEAASFgoSUk9PTV9TVEFUVV'
    'NfQUNUSVZFEAESFgoSUk9PTV9TVEFUVVNfQ0xPU0VEEAI=');

@$core.Deprecated('Use reviewStatusDescriptor instead')
const ReviewStatus$json = {
  '1': 'ReviewStatus',
  '2': [
    {'1': 'REVIEW_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_STATUS_PENDING', '2': 1},
    {'1': 'REVIEW_STATUS_APPROVED', '2': 2},
    {'1': 'REVIEW_STATUS_REJECTED', '2': 3},
  ],
};

/// Descriptor for `ReviewStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStatusDescriptor = $convert.base64Decode(
    'CgxSZXZpZXdTdGF0dXMSHQoZUkVWSUVXX1NUQVRVU19VTlNQRUNJRklFRBAAEhkKFVJFVklFV1'
    '9TVEFUVVNfUEVORElORxABEhoKFlJFVklFV19TVEFUVVNfQVBQUk9WRUQQAhIaChZSRVZJRVdf'
    'U1RBVFVTX1JFSkVDVEVEEAM=');

@$core.Deprecated('Use listSortDirectionDescriptor instead')
const ListSortDirection$json = {
  '1': 'ListSortDirection',
  '2': [
    {'1': 'LIST_SORT_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'LIST_SORT_DIRECTION_ASC', '2': 1},
    {'1': 'LIST_SORT_DIRECTION_DESC', '2': 2},
  ],
};

/// Descriptor for `ListSortDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List listSortDirectionDescriptor = $convert.base64Decode(
    'ChFMaXN0U29ydERpcmVjdGlvbhIjCh9MSVNUX1NPUlRfRElSRUNUSU9OX1VOU1BFQ0lGSUVEEA'
    'ASGwoXTElTVF9TT1JUX0RJUkVDVElPTl9BU0MQARIcChhMSVNUX1NPUlRfRElSRUNUSU9OX0RF'
    'U0MQAg==');

@$core.Deprecated('Use errorCodeDescriptor instead')
const ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'ERROR_CODE_UNSPECIFIED', '2': 0},
    {'1': 'ERROR_CODE_UNAUTHORIZED', '2': 1},
    {'1': 'ERROR_CODE_FORBIDDEN', '2': 2},
    {'1': 'ERROR_CODE_NOT_FOUND', '2': 3},
    {'1': 'ERROR_CODE_RATE_LIMITED', '2': 4},
    {'1': 'ERROR_CODE_VALIDATION_FAILED', '2': 5},
    {'1': 'ERROR_CODE_INTERNAL', '2': 6},
  ],
};

/// Descriptor for `ErrorCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorCodeDescriptor = $convert.base64Decode(
    'CglFcnJvckNvZGUSGgoWRVJST1JfQ09ERV9VTlNQRUNJRklFRBAAEhsKF0VSUk9SX0NPREVfVU'
    '5BVVRIT1JJWkVEEAESGAoURVJST1JfQ09ERV9GT1JCSURERU4QAhIYChRFUlJPUl9DT0RFX05P'
    'VF9GT1VORBADEhsKF0VSUk9SX0NPREVfUkFURV9MSU1JVEVEEAQSIAocRVJST1JfQ09ERV9WQU'
    'xJREFUSU9OX0ZBSUxFRBAFEhcKE0VSUk9SX0NPREVfSU5URVJOQUwQBg==');

@$core.Deprecated('Use roomMemberDescriptor instead')
const RoomMember$json = {
  '1': 'RoomMember',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {'1': 'permissions', '3': 5, '4': 1, '5': 4, '10': 'permissions'},
    {
      '1': 'added_permissions',
      '3': 6,
      '4': 1,
      '5': 4,
      '10': 'addedPermissions'
    },
    {
      '1': 'removed_permissions',
      '3': 7,
      '4': 1,
      '5': 4,
      '10': 'removedPermissions'
    },
    {
      '1': 'admin_added_permissions',
      '3': 8,
      '4': 1,
      '5': 4,
      '10': 'adminAddedPermissions'
    },
    {
      '1': 'admin_removed_permissions',
      '3': 9,
      '4': 1,
      '5': 4,
      '10': 'adminRemovedPermissions'
    },
    {'1': 'joined_at', '3': 10, '4': 1, '5': 3, '10': 'joinedAt'},
    {'1': 'is_online', '3': 11, '4': 1, '5': 8, '10': 'isOnline'},
  ],
};

/// Descriptor for `RoomMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMemberDescriptor = $convert.base64Decode(
    'CgpSb29tTWVtYmVyEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIXCgd1c2VyX2lkGAIgASgJUg'
    'Z1c2VySWQSGgoIdXNlcm5hbWUYAyABKAlSCHVzZXJuYW1lEjEKBHJvbGUYBCABKA4yHS5zeW5j'
    'dHYuY29tbW9uLlJvb21NZW1iZXJSb2xlUgRyb2xlEiAKC3Blcm1pc3Npb25zGAUgASgEUgtwZX'
    'JtaXNzaW9ucxIrChFhZGRlZF9wZXJtaXNzaW9ucxgGIAEoBFIQYWRkZWRQZXJtaXNzaW9ucxIv'
    'ChNyZW1vdmVkX3Blcm1pc3Npb25zGAcgASgEUhJyZW1vdmVkUGVybWlzc2lvbnMSNgoXYWRtaW'
    '5fYWRkZWRfcGVybWlzc2lvbnMYCCABKARSFWFkbWluQWRkZWRQZXJtaXNzaW9ucxI6ChlhZG1p'
    'bl9yZW1vdmVkX3Blcm1pc3Npb25zGAkgASgEUhdhZG1pblJlbW92ZWRQZXJtaXNzaW9ucxIbCg'
    'lqb2luZWRfYXQYCiABKANSCGpvaW5lZEF0EhsKCWlzX29ubGluZRgLIAEoCFIIaXNPbmxpbmU=');
