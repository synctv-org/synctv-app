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

@$core.Deprecated('Use roomPasswordPolicyDescriptor instead')
const RoomPasswordPolicy$json = {
  '1': 'RoomPasswordPolicy',
  '2': [
    {'1': 'ROOM_PASSWORD_POLICY_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_PASSWORD_POLICY_OPTIONAL', '2': 1},
    {'1': 'ROOM_PASSWORD_POLICY_REQUIRED', '2': 2},
    {'1': 'ROOM_PASSWORD_POLICY_FORBIDDEN', '2': 3},
  ],
};

/// Descriptor for `RoomPasswordPolicy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomPasswordPolicyDescriptor = $convert.base64Decode(
    'ChJSb29tUGFzc3dvcmRQb2xpY3kSJAogUk9PTV9QQVNTV09SRF9QT0xJQ1lfVU5TUEVDSUZJRU'
    'QQABIhCh1ST09NX1BBU1NXT1JEX1BPTElDWV9PUFRJT05BTBABEiEKHVJPT01fUEFTU1dPUkRf'
    'UE9MSUNZX1JFUVVJUkVEEAISIgoeUk9PTV9QQVNTV09SRF9QT0xJQ1lfRk9SQklEREVOEAM=');

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
    {'1': 'connection_count', '3': 12, '4': 1, '5': 5, '10': 'connectionCount'},
    {'1': 'remark_name', '3': 13, '4': 1, '5': 9, '10': 'remarkName'},
    {'1': 'display_tag', '3': 14, '4': 1, '5': 9, '10': 'displayTag'},
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
    'lqb2luZWRfYXQYCiABKANSCGpvaW5lZEF0EhsKCWlzX29ubGluZRgLIAEoCFIIaXNPbmxpbmUS'
    'KQoQY29ubmVjdGlvbl9jb3VudBgMIAEoBVIPY29ubmVjdGlvbkNvdW50Eh8KC3JlbWFya19uYW'
    '1lGA0gASgJUgpyZW1hcmtOYW1lEh8KC2Rpc3BsYXlfdGFnGA4gASgJUgpkaXNwbGF5VGFn');

@$core.Deprecated('Use nodeConnectionCountDescriptor instead')
const NodeConnectionCount$json = {
  '1': 'NodeConnectionCount',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'connection_count', '3': 2, '4': 1, '5': 5, '10': 'connectionCount'},
  ],
};

/// Descriptor for `NodeConnectionCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodeConnectionCountDescriptor = $convert.base64Decode(
    'ChNOb2RlQ29ubmVjdGlvbkNvdW50EhcKB25vZGVfaWQYASABKAlSBm5vZGVJZBIpChBjb25uZW'
    'N0aW9uX2NvdW50GAIgASgFUg9jb25uZWN0aW9uQ291bnQ=');

@$core.Deprecated('Use roomPresenceStatsDescriptor instead')
const RoomPresenceStats$json = {
  '1': 'RoomPresenceStats',
  '2': [
    {
      '1': 'online_member_count',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'onlineMemberCount'
    },
    {
      '1': 'online_guest_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'onlineGuestCount'
    },
    {'1': 'connection_count', '3': 3, '4': 1, '5': 5, '10': 'connectionCount'},
    {
      '1': 'node_connection_counts',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.common.NodeConnectionCount',
      '10': 'nodeConnectionCounts'
    },
    {'1': 'sampled_at', '3': 5, '4': 1, '5': 3, '10': 'sampledAt'},
    {'1': 'version', '3': 6, '4': 1, '5': 4, '10': 'version'},
  ],
};

/// Descriptor for `RoomPresenceStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomPresenceStatsDescriptor = $convert.base64Decode(
    'ChFSb29tUHJlc2VuY2VTdGF0cxIuChNvbmxpbmVfbWVtYmVyX2NvdW50GAEgASgFUhFvbmxpbm'
    'VNZW1iZXJDb3VudBIsChJvbmxpbmVfZ3Vlc3RfY291bnQYAiABKAVSEG9ubGluZUd1ZXN0Q291'
    'bnQSKQoQY29ubmVjdGlvbl9jb3VudBgDIAEoBVIPY29ubmVjdGlvbkNvdW50ElgKFm5vZGVfY2'
    '9ubmVjdGlvbl9jb3VudHMYBCADKAsyIi5zeW5jdHYuY29tbW9uLk5vZGVDb25uZWN0aW9uQ291'
    'bnRSFG5vZGVDb25uZWN0aW9uQ291bnRzEh0KCnNhbXBsZWRfYXQYBSABKANSCXNhbXBsZWRBdB'
    'IYCgd2ZXJzaW9uGAYgASgEUgd2ZXJzaW9u');

@$core.Deprecated('Use userPresenceStatsDescriptor instead')
const UserPresenceStats$json = {
  '1': 'UserPresenceStats',
  '2': [
    {'1': 'connection_count', '3': 1, '4': 1, '5': 5, '10': 'connectionCount'},
    {
      '1': 'node_connection_counts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.common.NodeConnectionCount',
      '10': 'nodeConnectionCounts'
    },
    {'1': 'room_count', '3': 3, '4': 1, '5': 5, '10': 'roomCount'},
    {'1': 'room_ids', '3': 4, '4': 3, '5': 9, '10': 'roomIds'},
    {'1': 'sampled_at', '3': 5, '4': 1, '5': 3, '10': 'sampledAt'},
    {'1': 'version', '3': 6, '4': 1, '5': 4, '10': 'version'},
  ],
};

/// Descriptor for `UserPresenceStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPresenceStatsDescriptor = $convert.base64Decode(
    'ChFVc2VyUHJlc2VuY2VTdGF0cxIpChBjb25uZWN0aW9uX2NvdW50GAEgASgFUg9jb25uZWN0aW'
    '9uQ291bnQSWAoWbm9kZV9jb25uZWN0aW9uX2NvdW50cxgCIAMoCzIiLnN5bmN0di5jb21tb24u'
    'Tm9kZUNvbm5lY3Rpb25Db3VudFIUbm9kZUNvbm5lY3Rpb25Db3VudHMSHQoKcm9vbV9jb3VudB'
    'gDIAEoBVIJcm9vbUNvdW50EhkKCHJvb21faWRzGAQgAygJUgdyb29tSWRzEh0KCnNhbXBsZWRf'
    'YXQYBSABKANSCXNhbXBsZWRBdBIYCgd2ZXJzaW9uGAYgASgEUgd2ZXJzaW9u');

@$core.Deprecated('Use nodePresenceStatsDescriptor instead')
const NodePresenceStats$json = {
  '1': 'NodePresenceStats',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'connection_count', '3': 2, '4': 1, '5': 5, '10': 'connectionCount'},
    {
      '1': 'online_member_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'onlineMemberCount'
    },
    {
      '1': 'online_guest_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'onlineGuestCount'
    },
    {'1': 'room_count', '3': 5, '4': 1, '5': 5, '10': 'roomCount'},
    {'1': 'sampled_at', '3': 6, '4': 1, '5': 3, '10': 'sampledAt'},
    {'1': 'version', '3': 7, '4': 1, '5': 4, '10': 'version'},
  ],
};

/// Descriptor for `NodePresenceStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nodePresenceStatsDescriptor = $convert.base64Decode(
    'ChFOb2RlUHJlc2VuY2VTdGF0cxIXCgdub2RlX2lkGAEgASgJUgZub2RlSWQSKQoQY29ubmVjdG'
    'lvbl9jb3VudBgCIAEoBVIPY29ubmVjdGlvbkNvdW50Ei4KE29ubGluZV9tZW1iZXJfY291bnQY'
    'AyABKAVSEW9ubGluZU1lbWJlckNvdW50EiwKEm9ubGluZV9ndWVzdF9jb3VudBgEIAEoBVIQb2'
    '5saW5lR3Vlc3RDb3VudBIdCgpyb29tX2NvdW50GAUgASgFUglyb29tQ291bnQSHQoKc2FtcGxl'
    'ZF9hdBgGIAEoA1IJc2FtcGxlZEF0EhgKB3ZlcnNpb24YByABKARSB3ZlcnNpb24=');

@$core.Deprecated('Use presenceOverviewDescriptor instead')
const PresenceOverview$json = {
  '1': 'PresenceOverview',
  '2': [
    {
      '1': 'online_member_count',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'onlineMemberCount'
    },
    {
      '1': 'online_guest_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'onlineGuestCount'
    },
    {'1': 'connection_count', '3': 3, '4': 1, '5': 5, '10': 'connectionCount'},
    {'1': 'active_room_count', '3': 4, '4': 1, '5': 5, '10': 'activeRoomCount'},
    {
      '1': 'nodes',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.common.NodePresenceStats',
      '10': 'nodes'
    },
    {'1': 'sampled_at', '3': 6, '4': 1, '5': 3, '10': 'sampledAt'},
    {'1': 'version', '3': 7, '4': 1, '5': 4, '10': 'version'},
  ],
};

/// Descriptor for `PresenceOverview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List presenceOverviewDescriptor = $convert.base64Decode(
    'ChBQcmVzZW5jZU92ZXJ2aWV3Ei4KE29ubGluZV9tZW1iZXJfY291bnQYASABKAVSEW9ubGluZU'
    '1lbWJlckNvdW50EiwKEm9ubGluZV9ndWVzdF9jb3VudBgCIAEoBVIQb25saW5lR3Vlc3RDb3Vu'
    'dBIpChBjb25uZWN0aW9uX2NvdW50GAMgASgFUg9jb25uZWN0aW9uQ291bnQSKgoRYWN0aXZlX3'
    'Jvb21fY291bnQYBCABKAVSD2FjdGl2ZVJvb21Db3VudBI2CgVub2RlcxgFIAMoCzIgLnN5bmN0'
    'di5jb21tb24uTm9kZVByZXNlbmNlU3RhdHNSBW5vZGVzEh0KCnNhbXBsZWRfYXQYBiABKANSCX'
    'NhbXBsZWRBdBIYCgd2ZXJzaW9uGAcgASgEUgd2ZXJzaW9u');
