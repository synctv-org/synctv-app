// This is a generated file - do not edit.
//
// Generated from proto/admin.proto.

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

import 'package:protobuf/well_known_types/google/protobuf/field_mask.pbjson.dart'
    as $2;

import 'client.pbjson.dart' as $1;
import 'common.pbjson.dart' as $0;

@$core.Deprecated('Use banTargetTypeDescriptor instead')
const BanTargetType$json = {
  '1': 'BanTargetType',
  '2': [
    {'1': 'BAN_TARGET_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'BAN_TARGET_TYPE_USER', '2': 1},
    {'1': 'BAN_TARGET_TYPE_ROOM', '2': 2},
  ],
};

/// Descriptor for `BanTargetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List banTargetTypeDescriptor = $convert.base64Decode(
    'Cg1CYW5UYXJnZXRUeXBlEh8KG0JBTl9UQVJHRVRfVFlQRV9VTlNQRUNJRklFRBAAEhgKFEJBTl'
    '9UQVJHRVRfVFlQRV9VU0VSEAESGAoUQkFOX1RBUkdFVF9UWVBFX1JPT00QAg==');

@$core.Deprecated('Use contentReportTargetTypeDescriptor instead')
const ContentReportTargetType$json = {
  '1': 'ContentReportTargetType',
  '2': [
    {'1': 'CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CONTENT_REPORT_TARGET_TYPE_ROOM', '2': 1},
    {'1': 'CONTENT_REPORT_TARGET_TYPE_USER', '2': 2},
    {'1': 'CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER', '2': 3},
    {'1': 'CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE', '2': 4},
  ],
};

/// Descriptor for `ContentReportTargetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List contentReportTargetTypeDescriptor = $convert.base64Decode(
    'ChdDb250ZW50UmVwb3J0VGFyZ2V0VHlwZRIqCiZDT05URU5UX1JFUE9SVF9UQVJHRVRfVFlQRV'
    '9VTlNQRUNJRklFRBAAEiMKH0NPTlRFTlRfUkVQT1JUX1RBUkdFVF9UWVBFX1JPT00QARIjCh9D'
    'T05URU5UX1JFUE9SVF9UQVJHRVRfVFlQRV9VU0VSEAISKgomQ09OVEVOVF9SRVBPUlRfVEFSR0'
    'VUX1RZUEVfUk9PTV9NRU1CRVIQAxIrCidDT05URU5UX1JFUE9SVF9UQVJHRVRfVFlQRV9DSEFU'
    'X01FU1NBR0UQBA==');

@$core.Deprecated('Use contentReportStatusDescriptor instead')
const ContentReportStatus$json = {
  '1': 'ContentReportStatus',
  '2': [
    {'1': 'CONTENT_REPORT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CONTENT_REPORT_STATUS_OPEN', '2': 1},
    {'1': 'CONTENT_REPORT_STATUS_REVIEWING', '2': 2},
    {'1': 'CONTENT_REPORT_STATUS_RESOLVED', '2': 3},
    {'1': 'CONTENT_REPORT_STATUS_DISMISSED', '2': 4},
  ],
};

/// Descriptor for `ContentReportStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List contentReportStatusDescriptor = $convert.base64Decode(
    'ChNDb250ZW50UmVwb3J0U3RhdHVzEiUKIUNPTlRFTlRfUkVQT1JUX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEh4KGkNPTlRFTlRfUkVQT1JUX1NUQVRVU19PUEVOEAESIwofQ09OVEVOVF9SRVBPUlRf'
    'U1RBVFVTX1JFVklFV0lORxACEiIKHkNPTlRFTlRfUkVQT1JUX1NUQVRVU19SRVNPTFZFRBADEi'
    'MKH0NPTlRFTlRfUkVQT1JUX1NUQVRVU19ESVNNSVNTRUQQBA==');

@$core.Deprecated('Use contentReportScopeDescriptor instead')
const ContentReportScope$json = {
  '1': 'ContentReportScope',
  '2': [
    {'1': 'CONTENT_REPORT_SCOPE_UNSPECIFIED', '2': 0},
    {'1': 'CONTENT_REPORT_SCOPE_ANY_RELATED', '2': 1},
    {'1': 'CONTENT_REPORT_SCOPE_ROOM_CONTEXT', '2': 2},
    {'1': 'CONTENT_REPORT_SCOPE_TARGET_ROOM', '2': 3},
    {'1': 'CONTENT_REPORT_SCOPE_TARGET_USER', '2': 4},
    {'1': 'CONTENT_REPORT_SCOPE_TARGET_MEMBER', '2': 5},
    {'1': 'CONTENT_REPORT_SCOPE_TARGET_CHAT_MESSAGE', '2': 6},
  ],
};

/// Descriptor for `ContentReportScope`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List contentReportScopeDescriptor = $convert.base64Decode(
    'ChJDb250ZW50UmVwb3J0U2NvcGUSJAogQ09OVEVOVF9SRVBPUlRfU0NPUEVfVU5TUEVDSUZJRU'
    'QQABIkCiBDT05URU5UX1JFUE9SVF9TQ09QRV9BTllfUkVMQVRFRBABEiUKIUNPTlRFTlRfUkVQ'
    'T1JUX1NDT1BFX1JPT01fQ09OVEVYVBACEiQKIENPTlRFTlRfUkVQT1JUX1NDT1BFX1RBUkdFVF'
    '9ST09NEAMSJAogQ09OVEVOVF9SRVBPUlRfU0NPUEVfVEFSR0VUX1VTRVIQBBImCiJDT05URU5U'
    'X1JFUE9SVF9TQ09QRV9UQVJHRVRfTUVNQkVSEAUSLAooQ09OVEVOVF9SRVBPUlRfU0NPUEVfVE'
    'FSR0VUX0NIQVRfTUVTU0FHRRAG');

@$core.Deprecated('Use signupMethodDescriptor instead')
const SignupMethod$json = {
  '1': 'SignupMethod',
  '2': [
    {'1': 'SIGNUP_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'SIGNUP_METHOD_EMAIL', '2': 1},
    {'1': 'SIGNUP_METHOD_PASSWORD', '2': 2},
    {'1': 'SIGNUP_METHOD_OAUTH2', '2': 3},
    {'1': 'SIGNUP_METHOD_ADMIN_CREATED', '2': 4},
    {'1': 'SIGNUP_METHOD_WEBAUTHN', '2': 5},
  ],
};

/// Descriptor for `SignupMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List signupMethodDescriptor = $convert.base64Decode(
    'CgxTaWdudXBNZXRob2QSHQoZU0lHTlVQX01FVEhPRF9VTlNQRUNJRklFRBAAEhcKE1NJR05VUF'
    '9NRVRIT0RfRU1BSUwQARIaChZTSUdOVVBfTUVUSE9EX1BBU1NXT1JEEAISGAoUU0lHTlVQX01F'
    'VEhPRF9PQVVUSDIQAxIfChtTSUdOVVBfTUVUSE9EX0FETUlOX0NSRUFURUQQBBIaChZTSUdOVV'
    'BfTUVUSE9EX1dFQkFVVEhOEAU=');

@$core.Deprecated('Use sortDirectionDescriptor instead')
const SortDirection$json = {
  '1': 'SortDirection',
  '2': [
    {'1': 'SORT_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'SORT_DIRECTION_ASC', '2': 1},
    {'1': 'SORT_DIRECTION_DESC', '2': 2},
  ],
};

/// Descriptor for `SortDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sortDirectionDescriptor = $convert.base64Decode(
    'Cg1Tb3J0RGlyZWN0aW9uEh4KGlNPUlRfRElSRUNUSU9OX1VOU1BFQ0lGSUVEEAASFgoSU09SVF'
    '9ESVJFQ1RJT05fQVNDEAESFwoTU09SVF9ESVJFQ1RJT05fREVTQxAC');

@$core.Deprecated('Use userListSortByDescriptor instead')
const UserListSortBy$json = {
  '1': 'UserListSortBy',
  '2': [
    {'1': 'USER_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'USER_LIST_SORT_BY_CREATED_AT', '2': 1},
    {'1': 'USER_LIST_SORT_BY_UPDATED_AT', '2': 2},
    {'1': 'USER_LIST_SORT_BY_USERNAME', '2': 3},
    {'1': 'USER_LIST_SORT_BY_EMAIL', '2': 4},
    {'1': 'USER_LIST_SORT_BY_STATUS', '2': 5},
    {'1': 'USER_LIST_SORT_BY_ROLE', '2': 6},
  ],
};

/// Descriptor for `UserListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userListSortByDescriptor = $convert.base64Decode(
    'Cg5Vc2VyTGlzdFNvcnRCeRIhCh1VU0VSX0xJU1RfU09SVF9CWV9VTlNQRUNJRklFRBAAEiAKHF'
    'VTRVJfTElTVF9TT1JUX0JZX0NSRUFURURfQVQQARIgChxVU0VSX0xJU1RfU09SVF9CWV9VUERB'
    'VEVEX0FUEAISHgoaVVNFUl9MSVNUX1NPUlRfQllfVVNFUk5BTUUQAxIbChdVU0VSX0xJU1RfU0'
    '9SVF9CWV9FTUFJTBAEEhwKGFVTRVJfTElTVF9TT1JUX0JZX1NUQVRVUxAFEhoKFlVTRVJfTElT'
    'VF9TT1JUX0JZX1JPTEUQBg==');

@$core.Deprecated('Use roomListSortByDescriptor instead')
const RoomListSortBy$json = {
  '1': 'RoomListSortBy',
  '2': [
    {'1': 'ROOM_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_LIST_SORT_BY_CREATED_AT', '2': 1},
    {'1': 'ROOM_LIST_SORT_BY_UPDATED_AT', '2': 2},
    {'1': 'ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT', '2': 3},
    {'1': 'ROOM_LIST_SORT_BY_NAME', '2': 4},
  ],
};

/// Descriptor for `RoomListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomListSortByDescriptor = $convert.base64Decode(
    'Cg5Sb29tTGlzdFNvcnRCeRIhCh1ST09NX0xJU1RfU09SVF9CWV9VTlNQRUNJRklFRBAAEiAKHF'
    'JPT01fTElTVF9TT1JUX0JZX0NSRUFURURfQVQQARIgChxST09NX0xJU1RfU09SVF9CWV9VUERB'
    'VEVEX0FUEAISJgoiUk9PTV9MSVNUX1NPUlRfQllfTEFTVF9BQ1RJVklUWV9BVBADEhoKFlJPT0'
    '1fTElTVF9TT1JUX0JZX05BTUUQBA==');

@$core.Deprecated('Use roomMemberListSortByDescriptor instead')
const RoomMemberListSortBy$json = {
  '1': 'RoomMemberListSortBy',
  '2': [
    {'1': 'ROOM_MEMBER_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_MEMBER_LIST_SORT_BY_JOINED_AT', '2': 1},
    {'1': 'ROOM_MEMBER_LIST_SORT_BY_USERNAME', '2': 2},
    {'1': 'ROOM_MEMBER_LIST_SORT_BY_ROLE', '2': 3},
  ],
};

/// Descriptor for `RoomMemberListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomMemberListSortByDescriptor = $convert.base64Decode(
    'ChRSb29tTWVtYmVyTGlzdFNvcnRCeRIoCiRST09NX01FTUJFUl9MSVNUX1NPUlRfQllfVU5TUE'
    'VDSUZJRUQQABImCiJST09NX01FTUJFUl9MSVNUX1NPUlRfQllfSk9JTkVEX0FUEAESJQohUk9P'
    'TV9NRU1CRVJfTElTVF9TT1JUX0JZX1VTRVJOQU1FEAISIQodUk9PTV9NRU1CRVJfTElTVF9TT1'
    'JUX0JZX1JPTEUQAw==');

@$core.Deprecated('Use activeStreamListSortByDescriptor instead')
const ActiveStreamListSortBy$json = {
  '1': 'ActiveStreamListSortBy',
  '2': [
    {'1': 'ACTIVE_STREAM_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT', '2': 1},
    {'1': 'ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID', '2': 2},
    {'1': 'ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID', '2': 3},
    {'1': 'ACTIVE_STREAM_LIST_SORT_BY_USER_ID', '2': 4},
    {'1': 'ACTIVE_STREAM_LIST_SORT_BY_NODE_ID', '2': 5},
  ],
};

/// Descriptor for `ActiveStreamListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List activeStreamListSortByDescriptor = $convert.base64Decode(
    'ChZBY3RpdmVTdHJlYW1MaXN0U29ydEJ5EioKJkFDVElWRV9TVFJFQU1fTElTVF9TT1JUX0JZX1'
    'VOU1BFQ0lGSUVEEAASKQolQUNUSVZFX1NUUkVBTV9MSVNUX1NPUlRfQllfU1RBUlRFRF9BVBAB'
    'EiYKIkFDVElWRV9TVFJFQU1fTElTVF9TT1JUX0JZX1JPT01fSUQQAhInCiNBQ1RJVkVfU1RSRU'
    'FNX0xJU1RfU09SVF9CWV9NRURJQV9JRBADEiYKIkFDVElWRV9TVFJFQU1fTElTVF9TT1JUX0JZ'
    'X1VTRVJfSUQQBBImCiJBQ1RJVkVfU1RSRUFNX0xJU1RfU09SVF9CWV9OT0RFX0lEEAU=');

@$core.Deprecated('Use adminUserDescriptor instead')
const AdminUser$json = {
  '1': 'AdminUser',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '10': 'role'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 7, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'is_banned', '3': 8, '4': 1, '5': 8, '10': 'isBanned'},
    {'1': 'banned_at', '3': 9, '4': 1, '5': 3, '10': 'bannedAt'},
    {'1': 'banned_by', '3': 10, '4': 1, '5': 9, '10': 'bannedBy'},
    {'1': 'banned_reason', '3': 11, '4': 1, '5': 9, '10': 'bannedReason'},
    {'1': 'avatar_url', '3': 12, '4': 1, '5': 9, '10': 'avatarUrl'},
    {
      '1': 'presence',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.UserPresenceStats',
      '10': 'presence'
    },
  ],
};

/// Descriptor for `AdminUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminUserDescriptor = $convert.base64Decode(
    'CglBZG1pblVzZXISDgoCaWQYASABKAlSAmlkEhoKCHVzZXJuYW1lGAIgASgJUgh1c2VybmFtZR'
    'IUCgVlbWFpbBgDIAEoCVIFZW1haWwSKwoEcm9sZRgEIAEoDjIXLnN5bmN0di5jb21tb24uVXNl'
    'clJvbGVSBHJvbGUSMQoGc3RhdHVzGAUgASgOMhkuc3luY3R2LmNvbW1vbi5Vc2VyU3RhdHVzUg'
    'ZzdGF0dXMSHQoKY3JlYXRlZF9hdBgGIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYByAB'
    'KANSCXVwZGF0ZWRBdBIbCglpc19iYW5uZWQYCCABKAhSCGlzQmFubmVkEhsKCWJhbm5lZF9hdB'
    'gJIAEoA1IIYmFubmVkQXQSGwoJYmFubmVkX2J5GAogASgJUghiYW5uZWRCeRIjCg1iYW5uZWRf'
    'cmVhc29uGAsgASgJUgxiYW5uZWRSZWFzb24SHQoKYXZhdGFyX3VybBgMIAEoCVIJYXZhdGFyVX'
    'JsEjwKCHByZXNlbmNlGA0gASgLMiAuc3luY3R2LmNvbW1vbi5Vc2VyUHJlc2VuY2VTdGF0c1II'
    'cHJlc2VuY2U=');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'creator_id', '3': 3, '4': 1, '5': 9, '10': 'creatorId'},
    {'1': 'creator_username', '3': 4, '4': 1, '5': 9, '10': 'creatorUsername'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomStatus',
      '10': 'status'
    },
    {
      '1': 'settings',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomSettings',
      '10': 'settings'
    },
    {'1': 'member_count', '3': 7, '4': 1, '5': 5, '10': 'memberCount'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'description', '3': 10, '4': 1, '5': 9, '10': 'description'},
    {'1': 'is_banned', '3': 11, '4': 1, '5': 8, '10': 'isBanned'},
    {
      '1': 'creator_status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '10': 'creatorStatus'
    },
    {'1': 'version', '3': 13, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'presence',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomPresenceStats',
      '10': 'presence'
    },
    {
      '1': 'creator_avatar_url',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'creatorAvatarUrl'
    },
    {
      '1': 'cover',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceCover',
      '10': 'cover'
    },
    {
      '1': 'category',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomCategory',
      '10': 'category'
    },
    {
      '1': 'labels',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomLabel',
      '10': 'labels'
    },
    {
      '1': 'is_public',
      '3': 19,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isPublic',
      '17': true
    },
  ],
  '8': [
    {'1': '_is_public'},
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh0KCmNyZWF0b3JfaW'
    'QYAyABKAlSCWNyZWF0b3JJZBIpChBjcmVhdG9yX3VzZXJuYW1lGAQgASgJUg9jcmVhdG9yVXNl'
    'cm5hbWUSMQoGc3RhdHVzGAUgASgOMhkuc3luY3R2LmNvbW1vbi5Sb29tU3RhdHVzUgZzdGF0dX'
    'MSNwoIc2V0dGluZ3MYBiABKAsyGy5zeW5jdHYuY2xpZW50LlJvb21TZXR0aW5nc1IIc2V0dGlu'
    'Z3MSIQoMbWVtYmVyX2NvdW50GAcgASgFUgttZW1iZXJDb3VudBIdCgpjcmVhdGVkX2F0GAggAS'
    'gDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF9hdBgJIAEoA1IJdXBkYXRlZEF0EiAKC2Rlc2NyaXB0'
    'aW9uGAogASgJUgtkZXNjcmlwdGlvbhIbCglpc19iYW5uZWQYCyABKAhSCGlzQmFubmVkEkAKDm'
    'NyZWF0b3Jfc3RhdHVzGAwgASgOMhkuc3luY3R2LmNvbW1vbi5Vc2VyU3RhdHVzUg1jcmVhdG9y'
    'U3RhdHVzEhgKB3ZlcnNpb24YDSABKANSB3ZlcnNpb24SPAoIcHJlc2VuY2UYDiABKAsyIC5zeW'
    '5jdHYuY29tbW9uLlJvb21QcmVzZW5jZVN0YXRzUghwcmVzZW5jZRIsChJjcmVhdG9yX2F2YXRh'
    'cl91cmwYDyABKAlSEGNyZWF0b3JBdmF0YXJVcmwSMgoFY292ZXIYECABKAsyHC5zeW5jdHYuY2'
    'xpZW50LlJlc291cmNlQ292ZXJSBWNvdmVyEjcKCGNhdGVnb3J5GBEgASgLMhsuc3luY3R2LmNs'
    'aWVudC5Sb29tQ2F0ZWdvcnlSCGNhdGVnb3J5EjAKBmxhYmVscxgSIAMoCzIYLnN5bmN0di5jbG'
    'llbnQuUm9vbUxhYmVsUgZsYWJlbHMSIAoJaXNfcHVibGljGBMgASgISABSCGlzUHVibGljiAEB'
    'QgwKCl9pc19wdWJsaWM=');

@$core.Deprecated('Use runtimeSettingsDescriptor instead')
const RuntimeSettings$json = {
  '1': 'RuntimeSettings',
  '2': [
    {
      '1': 'room_defaults',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomDefaultsSettings',
      '8': {},
      '10': 'roomDefaults'
    },
    {
      '1': 'permissions',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.PermissionSettings',
      '8': {},
      '10': 'permissions'
    },
    {
      '1': 'room_creation',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomCreationSettings',
      '8': {},
      '10': 'roomCreation'
    },
    {
      '1': 'user',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.UserSettings',
      '8': {},
      '10': 'user'
    },
    {
      '1': 'oauth2',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2Settings',
      '8': {},
      '10': 'oauth2'
    },
    {
      '1': 'rtmp',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RtmpSettings',
      '8': {},
      '10': 'rtmp'
    },
    {
      '1': 'email',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.EmailSettings',
      '8': {},
      '10': 'email'
    },
    {
      '1': 'webrtc',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.WebRTCSettings',
      '8': {},
      '10': 'webrtc'
    },
    {
      '1': 'chat',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.ChatSettings',
      '8': {},
      '10': 'chat'
    },
    {
      '1': 'cors',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.CorsSettings',
      '8': {},
      '10': 'cors'
    },
    {
      '1': 'server',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.ServerSettings',
      '8': {},
      '10': 'server'
    },
    {
      '1': 'playback_history',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.PlaybackHistorySettings',
      '8': {},
      '10': 'playbackHistory'
    },
  ],
};

/// Descriptor for `RuntimeSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeSettingsDescriptor = $convert.base64Decode(
    'Cg9SdW50aW1lU2V0dGluZ3MSTwoNcm9vbV9kZWZhdWx0cxgBIAEoCzIiLnN5bmN0di5hZG1pbi'
    '5Sb29tRGVmYXVsdHNTZXR0aW5nc0IGukgDyAEBUgxyb29tRGVmYXVsdHMSSgoLcGVybWlzc2lv'
    'bnMYAiABKAsyIC5zeW5jdHYuYWRtaW4uUGVybWlzc2lvblNldHRpbmdzQga6SAPIAQFSC3Blcm'
    '1pc3Npb25zEk8KDXJvb21fY3JlYXRpb24YAyABKAsyIi5zeW5jdHYuYWRtaW4uUm9vbUNyZWF0'
    'aW9uU2V0dGluZ3NCBrpIA8gBAVIMcm9vbUNyZWF0aW9uEjYKBHVzZXIYBCABKAsyGi5zeW5jdH'
    'YuYWRtaW4uVXNlclNldHRpbmdzQga6SAPIAQFSBHVzZXISPAoGb2F1dGgyGAUgASgLMhwuc3lu'
    'Y3R2LmFkbWluLk9BdXRoMlNldHRpbmdzQga6SAPIAQFSBm9hdXRoMhI2CgRydG1wGAYgASgLMh'
    'ouc3luY3R2LmFkbWluLlJ0bXBTZXR0aW5nc0IGukgDyAEBUgRydG1wEjkKBWVtYWlsGAcgASgL'
    'Mhsuc3luY3R2LmFkbWluLkVtYWlsU2V0dGluZ3NCBrpIA8gBAVIFZW1haWwSPAoGd2VicnRjGA'
    'ggASgLMhwuc3luY3R2LmFkbWluLldlYlJUQ1NldHRpbmdzQga6SAPIAQFSBndlYnJ0YxI2CgRj'
    'aGF0GAkgASgLMhouc3luY3R2LmFkbWluLkNoYXRTZXR0aW5nc0IGukgDyAEBUgRjaGF0EjYKBG'
    'NvcnMYCiABKAsyGi5zeW5jdHYuYWRtaW4uQ29yc1NldHRpbmdzQga6SAPIAQFSBGNvcnMSPAoG'
    'c2VydmVyGAsgASgLMhwuc3luY3R2LmFkbWluLlNlcnZlclNldHRpbmdzQga6SAPIAQFSBnNlcn'
    'ZlchJYChBwbGF5YmFja19oaXN0b3J5GAwgASgLMiUuc3luY3R2LmFkbWluLlBsYXliYWNrSGlz'
    'dG9yeVNldHRpbmdzQga6SAPIAQFSD3BsYXliYWNrSGlzdG9yeQ==');

@$core.Deprecated('Use runtimeSettingsSnapshotDescriptor instead')
const RuntimeSettingsSnapshot$json = {
  '1': 'RuntimeSettingsSnapshot',
  '2': [
    {
      '1': 'format_version',
      '3': 1,
      '4': 1,
      '5': 13,
      '8': {},
      '10': 'formatVersion'
    },
    {
      '1': 'settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RuntimeSettings',
      '8': {},
      '10': 'settings'
    },
  ],
};

/// Descriptor for `RuntimeSettingsSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeSettingsSnapshotDescriptor = $convert.base64Decode(
    'ChdSdW50aW1lU2V0dGluZ3NTbmFwc2hvdBIuCg5mb3JtYXRfdmVyc2lvbhgBIAEoDUIHukgEKg'
    'IIAVINZm9ybWF0VmVyc2lvbhJBCghzZXR0aW5ncxgCIAEoCzIdLnN5bmN0di5hZG1pbi5SdW50'
    'aW1lU2V0dGluZ3NCBrpIA8gBAVIIc2V0dGluZ3M=');

@$core.Deprecated('Use exportSettingsRequestDescriptor instead')
const ExportSettingsRequest$json = {
  '1': 'ExportSettingsRequest',
};

/// Descriptor for `ExportSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportSettingsRequestDescriptor =
    $convert.base64Decode('ChVFeHBvcnRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use importSettingsRequestDescriptor instead')
const ImportSettingsRequest$json = {
  '1': 'ImportSettingsRequest',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RuntimeSettingsSnapshot',
      '8': {},
      '10': 'snapshot'
    },
    {'1': 'dry_run', '3': 2, '4': 1, '5': 8, '10': 'dryRun'},
  ],
};

/// Descriptor for `ImportSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importSettingsRequestDescriptor = $convert.base64Decode(
    'ChVJbXBvcnRTZXR0aW5nc1JlcXVlc3QSSQoIc25hcHNob3QYASABKAsyJS5zeW5jdHYuYWRtaW'
    '4uUnVudGltZVNldHRpbmdzU25hcHNob3RCBrpIA8gBAVIIc25hcHNob3QSFwoHZHJ5X3J1bhgC'
    'IAEoCFIGZHJ5UnVu');

@$core.Deprecated('Use importSettingsResponseDescriptor instead')
const ImportSettingsResponse$json = {
  '1': 'ImportSettingsResponse',
  '2': [
    {'1': 'applied', '3': 1, '4': 1, '5': 8, '10': 'applied'},
    {'1': 'changed_sections', '3': 2, '4': 3, '5': 9, '10': 'changedSections'},
  ],
};

/// Descriptor for `ImportSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChZJbXBvcnRTZXR0aW5nc1Jlc3BvbnNlEhgKB2FwcGxpZWQYASABKAhSB2FwcGxpZWQSKQoQY2'
        'hhbmdlZF9zZWN0aW9ucxgCIAMoCVIPY2hhbmdlZFNlY3Rpb25z');

@$core.Deprecated('Use serverSettingsDescriptor instead')
const ServerSettings$json = {
  '1': 'ServerSettings',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `ServerSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverSettingsDescriptor = $convert.base64Decode(
    'Cg5TZXJ2ZXJTZXR0aW5ncxIeCgRuYW1lGAEgASgJQgq6SAdyBRABGIABUgRuYW1l');

@$core.Deprecated('Use roomDefaultsSettingsDescriptor instead')
const RoomDefaultsSettings$json = {
  '1': 'RoomDefaultsSettings',
  '2': [
    {
      '1': 'default_max_members',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'defaultMaxMembers'
    },
    {
      '1': 'default_max_chat_messages',
      '3': 2,
      '4': 1,
      '5': 4,
      '10': 'defaultMaxChatMessages'
    },
  ],
};

/// Descriptor for `RoomDefaultsSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDefaultsSettingsDescriptor = $convert.base64Decode(
    'ChRSb29tRGVmYXVsdHNTZXR0aW5ncxIuChNkZWZhdWx0X21heF9tZW1iZXJzGAEgASgDUhFkZW'
    'ZhdWx0TWF4TWVtYmVycxI5ChlkZWZhdWx0X21heF9jaGF0X21lc3NhZ2VzGAIgASgEUhZkZWZh'
    'dWx0TWF4Q2hhdE1lc3NhZ2Vz');

@$core.Deprecated('Use permissionSettingsDescriptor instead')
const PermissionSettings$json = {
  '1': 'PermissionSettings',
  '2': [
    {
      '1': 'admin_default_permissions',
      '3': 1,
      '4': 1,
      '5': 4,
      '10': 'adminDefaultPermissions'
    },
    {
      '1': 'member_default_permissions',
      '3': 2,
      '4': 1,
      '5': 4,
      '10': 'memberDefaultPermissions'
    },
    {
      '1': 'guest_default_permissions',
      '3': 3,
      '4': 1,
      '5': 4,
      '10': 'guestDefaultPermissions'
    },
  ],
};

/// Descriptor for `PermissionSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionSettingsDescriptor = $convert.base64Decode(
    'ChJQZXJtaXNzaW9uU2V0dGluZ3MSOgoZYWRtaW5fZGVmYXVsdF9wZXJtaXNzaW9ucxgBIAEoBF'
    'IXYWRtaW5EZWZhdWx0UGVybWlzc2lvbnMSPAoabWVtYmVyX2RlZmF1bHRfcGVybWlzc2lvbnMY'
    'AiABKARSGG1lbWJlckRlZmF1bHRQZXJtaXNzaW9ucxI6ChlndWVzdF9kZWZhdWx0X3Blcm1pc3'
    'Npb25zGAMgASgEUhdndWVzdERlZmF1bHRQZXJtaXNzaW9ucw==');

@$core.Deprecated('Use roomCreationSettingsDescriptor instead')
const RoomCreationSettings$json = {
  '1': 'RoomCreationSettings',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'approval_required',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'approvalRequired'
    },
    {
      '1': 'password_policy',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomPasswordPolicy',
      '8': {},
      '10': 'passwordPolicy'
    },
    {
      '1': 'max_rooms_per_user',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'maxRoomsPerUser'
    },
  ],
};

/// Descriptor for `RoomCreationSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomCreationSettingsDescriptor = $convert.base64Decode(
    'ChRSb29tQ3JlYXRpb25TZXR0aW5ncxIYCgdlbmFibGVkGAEgASgIUgdlbmFibGVkEisKEWFwcH'
    'JvdmFsX3JlcXVpcmVkGAIgASgIUhBhcHByb3ZhbFJlcXVpcmVkElQKD3Bhc3N3b3JkX3BvbGlj'
    'eRgDIAEoDjIhLnN5bmN0di5jb21tb24uUm9vbVBhc3N3b3JkUG9saWN5Qgi6SAWCAQIQAVIOcG'
    'Fzc3dvcmRQb2xpY3kSKwoSbWF4X3Jvb21zX3Blcl91c2VyGAQgASgDUg9tYXhSb29tc1BlclVz'
    'ZXI=');

@$core.Deprecated('Use userSettingsDescriptor instead')
const UserSettings$json = {
  '1': 'UserSettings',
  '2': [
    {
      '1': 'enable_password_signup',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'enablePasswordSignup'
    },
    {
      '1': 'password_signup_need_review',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'passwordSignupNeedReview'
    },
    {
      '1': 'enable_email_signup',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'enableEmailSignup'
    },
    {
      '1': 'email_signup_need_review',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'emailSignupNeedReview'
    },
    {
      '1': 'enable_webauthn_signup',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'enableWebauthnSignup'
    },
    {
      '1': 'webauthn_signup_need_review',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'webauthnSignupNeedReview'
    },
    {'1': 'enable_guest', '3': 7, '4': 1, '5': 8, '10': 'enableGuest'},
  ],
};

/// Descriptor for `UserSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSettingsDescriptor = $convert.base64Decode(
    'CgxVc2VyU2V0dGluZ3MSNAoWZW5hYmxlX3Bhc3N3b3JkX3NpZ251cBgBIAEoCFIUZW5hYmxlUG'
    'Fzc3dvcmRTaWdudXASPQobcGFzc3dvcmRfc2lnbnVwX25lZWRfcmV2aWV3GAIgASgIUhhwYXNz'
    'd29yZFNpZ251cE5lZWRSZXZpZXcSLgoTZW5hYmxlX2VtYWlsX3NpZ251cBgDIAEoCFIRZW5hYm'
    'xlRW1haWxTaWdudXASNwoYZW1haWxfc2lnbnVwX25lZWRfcmV2aWV3GAQgASgIUhVlbWFpbFNp'
    'Z251cE5lZWRSZXZpZXcSNAoWZW5hYmxlX3dlYmF1dGhuX3NpZ251cBgFIAEoCFIUZW5hYmxlV2'
    'ViYXV0aG5TaWdudXASPQobd2ViYXV0aG5fc2lnbnVwX25lZWRfcmV2aWV3GAYgASgIUhh3ZWJh'
    'dXRoblNpZ251cE5lZWRSZXZpZXcSIQoMZW5hYmxlX2d1ZXN0GAcgASgIUgtlbmFibGVHdWVzdA'
    '==');

@$core.Deprecated('Use oAuth2SettingsDescriptor instead')
const OAuth2Settings$json = {
  '1': 'OAuth2Settings',
  '2': [
    {
      '1': 'providers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.OAuth2ProviderSettings',
      '10': 'providers'
    },
    {
      '1': 'allowed_redirect_urls',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'allowedRedirectUrls'
    },
  ],
};

/// Descriptor for `OAuth2Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2SettingsDescriptor = $convert.base64Decode(
    'Cg5PQXV0aDJTZXR0aW5ncxJCCglwcm92aWRlcnMYASADKAsyJC5zeW5jdHYuYWRtaW4uT0F1dG'
    'gyUHJvdmlkZXJTZXR0aW5nc1IJcHJvdmlkZXJzEjIKFWFsbG93ZWRfcmVkaXJlY3RfdXJscxgC'
    'IAMoCVITYWxsb3dlZFJlZGlyZWN0VXJscw==');

@$core.Deprecated('Use oAuth2ProviderSettingsDescriptor instead')
const OAuth2ProviderSettings$json = {
  '1': 'OAuth2ProviderSettings',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'enable_signup', '3': 2, '4': 1, '5': 8, '10': 'enableSignup'},
    {
      '1': 'signup_need_review',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'signupNeedReview'
    },
    {
      '1': 'qq',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2QqProviderConfig',
      '9': 0,
      '10': 'qq'
    },
    {
      '1': 'github',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2GithubProviderConfig',
      '9': 0,
      '10': 'github'
    },
    {
      '1': 'google',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2GoogleProviderConfig',
      '9': 0,
      '10': 'google'
    },
    {
      '1': 'microsoft',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2MicrosoftProviderConfig',
      '9': 0,
      '10': 'microsoft'
    },
    {
      '1': 'discord',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2DiscordProviderConfig',
      '9': 0,
      '10': 'discord'
    },
    {
      '1': 'casdoor',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2CasdoorProviderConfig',
      '9': 0,
      '10': 'casdoor'
    },
    {
      '1': 'logto',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2LogtoProviderConfig',
      '9': 0,
      '10': 'logto'
    },
    {
      '1': 'oidc',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2OidcProviderConfig',
      '9': 0,
      '10': 'oidc'
    },
    {
      '1': 'feishu',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2FeishuProviderConfig',
      '9': 0,
      '10': 'feishu'
    },
    {
      '1': 'gitee',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2GiteeProviderConfig',
      '9': 0,
      '10': 'gitee'
    },
    {
      '1': 'apple',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2AppleProviderConfig',
      '9': 0,
      '10': 'apple'
    },
  ],
  '8': [
    {'1': 'config', '2': {}},
  ],
};

/// Descriptor for `OAuth2ProviderSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2ProviderSettingsDescriptor = $convert.base64Decode(
    'ChZPQXV0aDJQcm92aWRlclNldHRpbmdzEi8KBG5hbWUYASABKAlCG7pIGHIWEAEYQDIQXltBLV'
    'phLXowLTlfLV0rJFIEbmFtZRIjCg1lbmFibGVfc2lnbnVwGAIgASgIUgxlbmFibGVTaWdudXAS'
    'LAoSc2lnbnVwX25lZWRfcmV2aWV3GAMgASgIUhBzaWdudXBOZWVkUmV2aWV3EjYKAnFxGAQgAS'
    'gLMiQuc3luY3R2LmFkbWluLk9BdXRoMlFxUHJvdmlkZXJDb25maWdIAFICcXESQgoGZ2l0aHVi'
    'GAUgASgLMiguc3luY3R2LmFkbWluLk9BdXRoMkdpdGh1YlByb3ZpZGVyQ29uZmlnSABSBmdpdG'
    'h1YhJCCgZnb29nbGUYBiABKAsyKC5zeW5jdHYuYWRtaW4uT0F1dGgyR29vZ2xlUHJvdmlkZXJD'
    'b25maWdIAFIGZ29vZ2xlEksKCW1pY3Jvc29mdBgHIAEoCzIrLnN5bmN0di5hZG1pbi5PQXV0aD'
    'JNaWNyb3NvZnRQcm92aWRlckNvbmZpZ0gAUgltaWNyb3NvZnQSRQoHZGlzY29yZBgIIAEoCzIp'
    'LnN5bmN0di5hZG1pbi5PQXV0aDJEaXNjb3JkUHJvdmlkZXJDb25maWdIAFIHZGlzY29yZBJFCg'
    'djYXNkb29yGAkgASgLMikuc3luY3R2LmFkbWluLk9BdXRoMkNhc2Rvb3JQcm92aWRlckNvbmZp'
    'Z0gAUgdjYXNkb29yEj8KBWxvZ3RvGAogASgLMicuc3luY3R2LmFkbWluLk9BdXRoMkxvZ3RvUH'
    'JvdmlkZXJDb25maWdIAFIFbG9ndG8SPAoEb2lkYxgLIAEoCzImLnN5bmN0di5hZG1pbi5PQXV0'
    'aDJPaWRjUHJvdmlkZXJDb25maWdIAFIEb2lkYxJCCgZmZWlzaHUYDCABKAsyKC5zeW5jdHYuYW'
    'RtaW4uT0F1dGgyRmVpc2h1UHJvdmlkZXJDb25maWdIAFIGZmVpc2h1Ej8KBWdpdGVlGA0gASgL'
    'Micuc3luY3R2LmFkbWluLk9BdXRoMkdpdGVlUHJvdmlkZXJDb25maWdIAFIFZ2l0ZWUSPwoFYX'
    'BwbGUYDiABKAsyJy5zeW5jdHYuYWRtaW4uT0F1dGgyQXBwbGVQcm92aWRlckNvbmZpZ0gAUgVh'
    'cHBsZUIPCgZjb25maWcSBbpIAggB');

@$core.Deprecated('Use oAuth2GithubProviderConfigDescriptor instead')
const OAuth2GithubProviderConfig$json = {
  '1': 'OAuth2GithubProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2GithubProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2GithubProviderConfigDescriptor =
    $convert.base64Decode(
        'ChpPQXV0aDJHaXRodWJQcm92aWRlckNvbmZpZxIbCgljbGllbnRfaWQYASABKAlSCGNsaWVudE'
        'lkEigKDWNsaWVudF9zZWNyZXQYAiABKAlIAFIMY2xpZW50U2VjcmV0iAEBQhAKDl9jbGllbnRf'
        'c2VjcmV0');

@$core.Deprecated('Use oAuth2GoogleProviderConfigDescriptor instead')
const OAuth2GoogleProviderConfig$json = {
  '1': 'OAuth2GoogleProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2GoogleProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2GoogleProviderConfigDescriptor =
    $convert.base64Decode(
        'ChpPQXV0aDJHb29nbGVQcm92aWRlckNvbmZpZxIbCgljbGllbnRfaWQYASABKAlSCGNsaWVudE'
        'lkEigKDWNsaWVudF9zZWNyZXQYAiABKAlIAFIMY2xpZW50U2VjcmV0iAEBQhAKDl9jbGllbnRf'
        'c2VjcmV0');

@$core.Deprecated('Use oAuth2LogtoProviderConfigDescriptor instead')
const OAuth2LogtoProviderConfig$json = {
  '1': 'OAuth2LogtoProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2LogtoProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2LogtoProviderConfigDescriptor = $convert.base64Decode(
    'ChlPQXV0aDJMb2d0b1Byb3ZpZGVyQ29uZmlnEhsKCWNsaWVudF9pZBgBIAEoCVIIY2xpZW50SW'
    'QSKAoNY2xpZW50X3NlY3JldBgCIAEoCUgAUgxjbGllbnRTZWNyZXSIAQESGgoIZW5kcG9pbnQY'
    'AyABKAlSCGVuZHBvaW50QhAKDl9jbGllbnRfc2VjcmV0');

@$core.Deprecated('Use oAuth2OidcProviderConfigDescriptor instead')
const OAuth2OidcProviderConfig$json = {
  '1': 'OAuth2OidcProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
    {'1': 'issuer', '3': 3, '4': 1, '5': 9, '10': 'issuer'},
    {
      '1': 'auth_url',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'authUrl',
      '17': true
    },
    {
      '1': 'token_url',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'tokenUrl',
      '17': true
    },
    {
      '1': 'userinfo_url',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'userinfoUrl',
      '17': true
    },
    {
      '1': 'jwks_url',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'jwksUrl',
      '17': true
    },
    {'1': 'scopes', '3': 8, '4': 3, '5': 9, '10': 'scopes'},
  ],
  '8': [
    {'1': '_client_secret'},
    {'1': '_auth_url'},
    {'1': '_token_url'},
    {'1': '_userinfo_url'},
    {'1': '_jwks_url'},
  ],
};

/// Descriptor for `OAuth2OidcProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2OidcProviderConfigDescriptor = $convert.base64Decode(
    'ChhPQXV0aDJPaWRjUHJvdmlkZXJDb25maWcSGwoJY2xpZW50X2lkGAEgASgJUghjbGllbnRJZB'
    'IoCg1jbGllbnRfc2VjcmV0GAIgASgJSABSDGNsaWVudFNlY3JldIgBARIWCgZpc3N1ZXIYAyAB'
    'KAlSBmlzc3VlchIeCghhdXRoX3VybBgEIAEoCUgBUgdhdXRoVXJsiAEBEiAKCXRva2VuX3VybB'
    'gFIAEoCUgCUgh0b2tlblVybIgBARImCgx1c2VyaW5mb191cmwYBiABKAlIA1ILdXNlcmluZm9V'
    'cmyIAQESHgoIandrc191cmwYByABKAlIBFIHandrc1VybIgBARIWCgZzY29wZXMYCCADKAlSBn'
    'Njb3Blc0IQCg5fY2xpZW50X3NlY3JldEILCglfYXV0aF91cmxCDAoKX3Rva2VuX3VybEIPCg1f'
    'dXNlcmluZm9fdXJsQgsKCV9qd2tzX3VybA==');

@$core.Deprecated('Use oAuth2CasdoorProviderConfigDescriptor instead')
const OAuth2CasdoorProviderConfig$json = {
  '1': 'OAuth2CasdoorProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
    {'1': 'issuer', '3': 3, '4': 1, '5': 9, '10': 'issuer'},
    {
      '1': 'auth_url',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'authUrl',
      '17': true
    },
    {
      '1': 'token_url',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'tokenUrl',
      '17': true
    },
    {
      '1': 'userinfo_url',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'userinfoUrl',
      '17': true
    },
    {
      '1': 'jwks_url',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'jwksUrl',
      '17': true
    },
  ],
  '8': [
    {'1': '_client_secret'},
    {'1': '_auth_url'},
    {'1': '_token_url'},
    {'1': '_userinfo_url'},
    {'1': '_jwks_url'},
  ],
};

/// Descriptor for `OAuth2CasdoorProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2CasdoorProviderConfigDescriptor = $convert.base64Decode(
    'ChtPQXV0aDJDYXNkb29yUHJvdmlkZXJDb25maWcSGwoJY2xpZW50X2lkGAEgASgJUghjbGllbn'
    'RJZBIoCg1jbGllbnRfc2VjcmV0GAIgASgJSABSDGNsaWVudFNlY3JldIgBARIWCgZpc3N1ZXIY'
    'AyABKAlSBmlzc3VlchIeCghhdXRoX3VybBgEIAEoCUgBUgdhdXRoVXJsiAEBEiAKCXRva2VuX3'
    'VybBgFIAEoCUgCUgh0b2tlblVybIgBARImCgx1c2VyaW5mb191cmwYBiABKAlIA1ILdXNlcmlu'
    'Zm9VcmyIAQESHgoIandrc191cmwYByABKAlIBFIHandrc1VybIgBAUIQCg5fY2xpZW50X3NlY3'
    'JldEILCglfYXV0aF91cmxCDAoKX3Rva2VuX3VybEIPCg1fdXNlcmluZm9fdXJsQgsKCV9qd2tz'
    'X3VybA==');

@$core.Deprecated('Use oAuth2AppleProviderConfigDescriptor instead')
const OAuth2AppleProviderConfig$json = {
  '1': 'OAuth2AppleProviderConfig',
  '2': [
    {'1': 'web_client_id', '3': 1, '4': 1, '5': 9, '10': 'webClientId'},
    {
      '1': 'web_client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'webClientSecret',
      '17': true
    },
    {'1': 'native_client_id', '3': 3, '4': 1, '5': 9, '10': 'nativeClientId'},
    {
      '1': 'native_client_secret',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'nativeClientSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_web_client_secret'},
    {'1': '_native_client_secret'},
  ],
};

/// Descriptor for `OAuth2AppleProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2AppleProviderConfigDescriptor = $convert.base64Decode(
    'ChlPQXV0aDJBcHBsZVByb3ZpZGVyQ29uZmlnEiIKDXdlYl9jbGllbnRfaWQYASABKAlSC3dlYk'
    'NsaWVudElkEi8KEXdlYl9jbGllbnRfc2VjcmV0GAIgASgJSABSD3dlYkNsaWVudFNlY3JldIgB'
    'ARIoChBuYXRpdmVfY2xpZW50X2lkGAMgASgJUg5uYXRpdmVDbGllbnRJZBI1ChRuYXRpdmVfY2'
    'xpZW50X3NlY3JldBgEIAEoCUgBUhJuYXRpdmVDbGllbnRTZWNyZXSIAQFCFAoSX3dlYl9jbGll'
    'bnRfc2VjcmV0QhcKFV9uYXRpdmVfY2xpZW50X3NlY3JldA==');

@$core.Deprecated('Use oAuth2QqProviderConfigDescriptor instead')
const OAuth2QqProviderConfig$json = {
  '1': 'OAuth2QqProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2QqProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2QqProviderConfigDescriptor = $convert.base64Decode(
    'ChZPQXV0aDJRcVByb3ZpZGVyQ29uZmlnEhsKCWNsaWVudF9pZBgBIAEoCVIIY2xpZW50SWQSKA'
    'oNY2xpZW50X3NlY3JldBgCIAEoCUgAUgxjbGllbnRTZWNyZXSIAQFCEAoOX2NsaWVudF9zZWNy'
    'ZXQ=');

@$core.Deprecated('Use oAuth2MicrosoftProviderConfigDescriptor instead')
const OAuth2MicrosoftProviderConfig$json = {
  '1': 'OAuth2MicrosoftProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
    {'1': 'tenant', '3': 3, '4': 1, '5': 9, '10': 'tenant'},
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2MicrosoftProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2MicrosoftProviderConfigDescriptor =
    $convert.base64Decode(
        'Ch1PQXV0aDJNaWNyb3NvZnRQcm92aWRlckNvbmZpZxIbCgljbGllbnRfaWQYASABKAlSCGNsaW'
        'VudElkEigKDWNsaWVudF9zZWNyZXQYAiABKAlIAFIMY2xpZW50U2VjcmV0iAEBEhYKBnRlbmFu'
        'dBgDIAEoCVIGdGVuYW50QhAKDl9jbGllbnRfc2VjcmV0');

@$core.Deprecated('Use oAuth2DiscordProviderConfigDescriptor instead')
const OAuth2DiscordProviderConfig$json = {
  '1': 'OAuth2DiscordProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2DiscordProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2DiscordProviderConfigDescriptor =
    $convert.base64Decode(
        'ChtPQXV0aDJEaXNjb3JkUHJvdmlkZXJDb25maWcSGwoJY2xpZW50X2lkGAEgASgJUghjbGllbn'
        'RJZBIoCg1jbGllbnRfc2VjcmV0GAIgASgJSABSDGNsaWVudFNlY3JldIgBAUIQCg5fY2xpZW50'
        'X3NlY3JldA==');

@$core.Deprecated('Use oAuth2FeishuProviderConfigDescriptor instead')
const OAuth2FeishuProviderConfig$json = {
  '1': 'OAuth2FeishuProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2FeishuProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2FeishuProviderConfigDescriptor =
    $convert.base64Decode(
        'ChpPQXV0aDJGZWlzaHVQcm92aWRlckNvbmZpZxIbCgljbGllbnRfaWQYASABKAlSCGNsaWVudE'
        'lkEigKDWNsaWVudF9zZWNyZXQYAiABKAlIAFIMY2xpZW50U2VjcmV0iAEBEhoKCGVuZHBvaW50'
        'GAMgASgJUghlbmRwb2ludEIQCg5fY2xpZW50X3NlY3JldA==');

@$core.Deprecated('Use oAuth2GiteeProviderConfigDescriptor instead')
const OAuth2GiteeProviderConfig$json = {
  '1': 'OAuth2GiteeProviderConfig',
  '2': [
    {'1': 'client_id', '3': 1, '4': 1, '5': 9, '10': 'clientId'},
    {
      '1': 'client_secret',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'clientSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_client_secret'},
  ],
};

/// Descriptor for `OAuth2GiteeProviderConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2GiteeProviderConfigDescriptor = $convert.base64Decode(
    'ChlPQXV0aDJHaXRlZVByb3ZpZGVyQ29uZmlnEhsKCWNsaWVudF9pZBgBIAEoCVIIY2xpZW50SW'
    'QSKAoNY2xpZW50X3NlY3JldBgCIAEoCUgAUgxjbGllbnRTZWNyZXSIAQFCEAoOX2NsaWVudF9z'
    'ZWNyZXQ=');

@$core.Deprecated('Use rtmpSettingsDescriptor instead')
const RtmpSettings$json = {
  '1': 'RtmpSettings',
  '2': [
    {
      '1': 'advertise_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'advertiseAddress',
      '17': true
    },
    {
      '1': 'ts_disguised_as_png',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'tsDisguisedAsPng'
    },
  ],
  '8': [
    {'1': '_advertise_address'},
  ],
};

/// Descriptor for `RtmpSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpSettingsDescriptor = $convert.base64Decode(
    'CgxSdG1wU2V0dGluZ3MSMAoRYWR2ZXJ0aXNlX2FkZHJlc3MYASABKAlIAFIQYWR2ZXJ0aXNlQW'
    'RkcmVzc4gBARItChN0c19kaXNndWlzZWRfYXNfcG5nGAIgASgIUhB0c0Rpc2d1aXNlZEFzUG5n'
    'QhQKEl9hZHZlcnRpc2VfYWRkcmVzcw==');

@$core.Deprecated('Use emailSettingsDescriptor instead')
const EmailSettings$json = {
  '1': 'EmailSettings',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'smtp_host',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'smtpHost',
      '17': true
    },
    {'1': 'smtp_port', '3': 3, '4': 1, '5': 13, '10': 'smtpPort'},
    {
      '1': 'smtp_credentials',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SmtpCredentials',
      '10': 'smtpCredentials'
    },
    {
      '1': 'smtp_proxy',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SmtpProxy',
      '10': 'smtpProxy'
    },
    {'1': 'use_tls', '3': 6, '4': 1, '5': 8, '10': 'useTls'},
    {
      '1': 'from_email',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'fromEmail',
      '17': true
    },
    {'1': 'from_name', '3': 8, '4': 1, '5': 9, '10': 'fromName'},
    {
      '1': 'whitelist_enabled',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'whitelistEnabled'
    },
    {
      '1': 'whitelist_domains',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'whitelistDomains'
    },
  ],
  '8': [
    {'1': '_smtp_host'},
    {'1': '_from_email'},
  ],
};

/// Descriptor for `EmailSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emailSettingsDescriptor = $convert.base64Decode(
    'Cg1FbWFpbFNldHRpbmdzEhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZWQSIAoJc210cF9ob3N0GA'
    'IgASgJSABSCHNtdHBIb3N0iAEBEhsKCXNtdHBfcG9ydBgDIAEoDVIIc210cFBvcnQSSAoQc210'
    'cF9jcmVkZW50aWFscxgEIAEoCzIdLnN5bmN0di5hZG1pbi5TbXRwQ3JlZGVudGlhbHNSD3NtdH'
    'BDcmVkZW50aWFscxI2CgpzbXRwX3Byb3h5GAUgASgLMhcuc3luY3R2LmFkbWluLlNtdHBQcm94'
    'eVIJc210cFByb3h5EhcKB3VzZV90bHMYBiABKAhSBnVzZVRscxIiCgpmcm9tX2VtYWlsGAcgAS'
    'gJSAFSCWZyb21FbWFpbIgBARIbCglmcm9tX25hbWUYCCABKAlSCGZyb21OYW1lEisKEXdoaXRl'
    'bGlzdF9lbmFibGVkGAkgASgIUhB3aGl0ZWxpc3RFbmFibGVkEisKEXdoaXRlbGlzdF9kb21haW'
    '5zGAogAygJUhB3aGl0ZWxpc3REb21haW5zQgwKCl9zbXRwX2hvc3RCDQoLX2Zyb21fZW1haWw=');

@$core.Deprecated('Use smtpCredentialsDescriptor instead')
const SmtpCredentials$json = {
  '1': 'SmtpCredentials',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'password',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'password',
      '17': true
    },
  ],
  '8': [
    {'1': '_password'},
  ],
};

/// Descriptor for `SmtpCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smtpCredentialsDescriptor = $convert.base64Decode(
    'Cg9TbXRwQ3JlZGVudGlhbHMSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEh8KCHBhc3N3b3'
    'JkGAIgASgJSABSCHBhc3N3b3JkiAEBQgsKCV9wYXNzd29yZA==');

@$core.Deprecated('Use smtpProxyDescriptor instead')
const SmtpProxy$json = {
  '1': 'SmtpProxy',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'credentials',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SmtpCredentials',
      '10': 'credentials'
    },
  ],
};

/// Descriptor for `SmtpProxy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smtpProxyDescriptor = $convert.base64Decode(
    'CglTbXRwUHJveHkSEAoDdXJsGAEgASgJUgN1cmwSPwoLY3JlZGVudGlhbHMYAiABKAsyHS5zeW'
    '5jdHYuYWRtaW4uU210cENyZWRlbnRpYWxzUgtjcmVkZW50aWFscw==');

@$core.Deprecated('Use webRTCSettingsDescriptor instead')
const WebRTCSettings$json = {
  '1': 'WebRTCSettings',
  '2': [
    {
      '1': 'external_ice_servers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.IceServer',
      '10': 'externalIceServers'
    },
    {
      '1': 'max_voice_participants_per_room',
      '3': 2,
      '4': 1,
      '5': 13,
      '10': 'maxVoiceParticipantsPerRoom'
    },
  ],
};

/// Descriptor for `WebRTCSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCSettingsDescriptor = $convert.base64Decode(
    'Cg5XZWJSVENTZXR0aW5ncxJKChRleHRlcm5hbF9pY2Vfc2VydmVycxgBIAMoCzIYLnN5bmN0di'
    '5jbGllbnQuSWNlU2VydmVyUhJleHRlcm5hbEljZVNlcnZlcnMSRAofbWF4X3ZvaWNlX3BhcnRp'
    'Y2lwYW50c19wZXJfcm9vbRgCIAEoDVIbbWF4Vm9pY2VQYXJ0aWNpcGFudHNQZXJSb29t');

@$core.Deprecated('Use chatSettingsDescriptor instead')
const ChatSettings$json = {
  '1': 'ChatSettings',
  '2': [
    {
      '1': 'max_messages_per_room',
      '3': 1,
      '4': 1,
      '5': 4,
      '10': 'maxMessagesPerRoom'
    },
    {
      '1': 'max_pinned_messages_per_room',
      '3': 2,
      '4': 1,
      '5': 4,
      '10': 'maxPinnedMessagesPerRoom'
    },
    {
      '1': 'message_retention_days',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'messageRetentionDays'
    },
  ],
};

/// Descriptor for `ChatSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatSettingsDescriptor = $convert.base64Decode(
    'CgxDaGF0U2V0dGluZ3MSMQoVbWF4X21lc3NhZ2VzX3Blcl9yb29tGAEgASgEUhJtYXhNZXNzYW'
    'dlc1BlclJvb20SPgocbWF4X3Bpbm5lZF9tZXNzYWdlc19wZXJfcm9vbRgCIAEoBFIYbWF4UGlu'
    'bmVkTWVzc2FnZXNQZXJSb29tEjQKFm1lc3NhZ2VfcmV0ZW50aW9uX2RheXMYAyABKANSFG1lc3'
    'NhZ2VSZXRlbnRpb25EYXlz');

@$core.Deprecated('Use playbackHistorySettingsDescriptor instead')
const PlaybackHistorySettings$json = {
  '1': 'PlaybackHistorySettings',
  '2': [
    {'1': 'retention_days', '3': 1, '4': 1, '5': 13, '10': 'retentionDays'},
    {
      '1': 'max_entries_per_room',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'maxEntriesPerRoom'
    },
  ],
};

/// Descriptor for `PlaybackHistorySettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackHistorySettingsDescriptor = $convert.base64Decode(
    'ChdQbGF5YmFja0hpc3RvcnlTZXR0aW5ncxIlCg5yZXRlbnRpb25fZGF5cxgBIAEoDVINcmV0ZW'
    '50aW9uRGF5cxIvChRtYXhfZW50cmllc19wZXJfcm9vbRgCIAEoA1IRbWF4RW50cmllc1BlclJv'
    'b20=');

@$core.Deprecated('Use corsSettingsDescriptor instead')
const CorsSettings$json = {
  '1': 'CorsSettings',
  '2': [
    {'1': 'allowed_origins', '3': 1, '4': 3, '5': 9, '10': 'allowedOrigins'},
  ],
};

/// Descriptor for `CorsSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List corsSettingsDescriptor = $convert.base64Decode(
    'CgxDb3JzU2V0dGluZ3MSJwoPYWxsb3dlZF9vcmlnaW5zGAEgAygJUg5hbGxvd2VkT3JpZ2lucw'
    '==');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RuntimeSettingsPatch',
      '8': {},
      '10': 'settings'
    },
    {
      '1': 'update_mask',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '8': {},
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSRgoIc2V0dGluZ3MYASABKAsyIi5zeW5jdHYuYWRtaW'
    '4uUnVudGltZVNldHRpbmdzUGF0Y2hCBrpIA8gBAVIIc2V0dGluZ3MSQwoLdXBkYXRlX21hc2sY'
    'AiABKAsyGi5nb29nbGUucHJvdG9idWYuRmllbGRNYXNrQga6SAPIAQFSCnVwZGF0ZU1hc2s=');

@$core.Deprecated('Use runtimeSettingsPatchDescriptor instead')
const RuntimeSettingsPatch$json = {
  '1': 'RuntimeSettingsPatch',
  '2': [
    {
      '1': 'room_defaults',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomDefaultsSettingsPatch',
      '10': 'roomDefaults'
    },
    {
      '1': 'permissions',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.PermissionSettingsPatch',
      '10': 'permissions'
    },
    {
      '1': 'room_creation',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomCreationSettingsPatch',
      '10': 'roomCreation'
    },
    {
      '1': 'user',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.UserSettingsPatch',
      '10': 'user'
    },
    {
      '1': 'oauth2',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.OAuth2SettingsPatch',
      '10': 'oauth2'
    },
    {
      '1': 'rtmp',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RtmpSettingsPatch',
      '10': 'rtmp'
    },
    {
      '1': 'email',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.EmailSettingsPatch',
      '10': 'email'
    },
    {
      '1': 'webrtc',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.WebRTCSettingsPatch',
      '10': 'webrtc'
    },
    {
      '1': 'chat',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.ChatSettingsPatch',
      '10': 'chat'
    },
    {
      '1': 'cors',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.CorsSettingsPatch',
      '10': 'cors'
    },
    {
      '1': 'server',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.ServerSettingsPatch',
      '10': 'server'
    },
    {
      '1': 'playback_history',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.PlaybackHistorySettingsPatch',
      '10': 'playbackHistory'
    },
  ],
};

/// Descriptor for `RuntimeSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeSettingsPatchDescriptor = $convert.base64Decode(
    'ChRSdW50aW1lU2V0dGluZ3NQYXRjaBJMCg1yb29tX2RlZmF1bHRzGAEgASgLMicuc3luY3R2Lm'
    'FkbWluLlJvb21EZWZhdWx0c1NldHRpbmdzUGF0Y2hSDHJvb21EZWZhdWx0cxJHCgtwZXJtaXNz'
    'aW9ucxgCIAEoCzIlLnN5bmN0di5hZG1pbi5QZXJtaXNzaW9uU2V0dGluZ3NQYXRjaFILcGVybW'
    'lzc2lvbnMSTAoNcm9vbV9jcmVhdGlvbhgDIAEoCzInLnN5bmN0di5hZG1pbi5Sb29tQ3JlYXRp'
    'b25TZXR0aW5nc1BhdGNoUgxyb29tQ3JlYXRpb24SMwoEdXNlchgEIAEoCzIfLnN5bmN0di5hZG'
    '1pbi5Vc2VyU2V0dGluZ3NQYXRjaFIEdXNlchI5CgZvYXV0aDIYBSABKAsyIS5zeW5jdHYuYWRt'
    'aW4uT0F1dGgyU2V0dGluZ3NQYXRjaFIGb2F1dGgyEjMKBHJ0bXAYBiABKAsyHy5zeW5jdHYuYW'
    'RtaW4uUnRtcFNldHRpbmdzUGF0Y2hSBHJ0bXASNgoFZW1haWwYByABKAsyIC5zeW5jdHYuYWRt'
    'aW4uRW1haWxTZXR0aW5nc1BhdGNoUgVlbWFpbBI5CgZ3ZWJydGMYCCABKAsyIS5zeW5jdHYuYW'
    'RtaW4uV2ViUlRDU2V0dGluZ3NQYXRjaFIGd2VicnRjEjMKBGNoYXQYCSABKAsyHy5zeW5jdHYu'
    'YWRtaW4uQ2hhdFNldHRpbmdzUGF0Y2hSBGNoYXQSMwoEY29ycxgKIAEoCzIfLnN5bmN0di5hZG'
    '1pbi5Db3JzU2V0dGluZ3NQYXRjaFIEY29ycxI5CgZzZXJ2ZXIYCyABKAsyIS5zeW5jdHYuYWRt'
    'aW4uU2VydmVyU2V0dGluZ3NQYXRjaFIGc2VydmVyElUKEHBsYXliYWNrX2hpc3RvcnkYDCABKA'
    'syKi5zeW5jdHYuYWRtaW4uUGxheWJhY2tIaXN0b3J5U2V0dGluZ3NQYXRjaFIPcGxheWJhY2tI'
    'aXN0b3J5');

@$core.Deprecated('Use serverSettingsPatchDescriptor instead')
const ServerSettingsPatch$json = {
  '1': 'ServerSettingsPatch',
  '2': [
    {
      '1': 'name',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'name',
      '17': true
    },
  ],
  '8': [
    {'1': '_name'},
  ],
};

/// Descriptor for `ServerSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverSettingsPatchDescriptor = $convert.base64Decode(
    'ChNTZXJ2ZXJTZXR0aW5nc1BhdGNoEiMKBG5hbWUYASABKAlCCrpIB3IFEAEYgAFIAFIEbmFtZY'
    'gBAUIHCgVfbmFtZQ==');

@$core.Deprecated('Use roomDefaultsSettingsPatchDescriptor instead')
const RoomDefaultsSettingsPatch$json = {
  '1': 'RoomDefaultsSettingsPatch',
  '2': [
    {
      '1': 'default_max_members',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'defaultMaxMembers',
      '17': true
    },
    {
      '1': 'default_max_chat_messages',
      '3': 2,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'defaultMaxChatMessages',
      '17': true
    },
  ],
  '8': [
    {'1': '_default_max_members'},
    {'1': '_default_max_chat_messages'},
  ],
};

/// Descriptor for `RoomDefaultsSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDefaultsSettingsPatchDescriptor = $convert.base64Decode(
    'ChlSb29tRGVmYXVsdHNTZXR0aW5nc1BhdGNoEjMKE2RlZmF1bHRfbWF4X21lbWJlcnMYASABKA'
    'NIAFIRZGVmYXVsdE1heE1lbWJlcnOIAQESPgoZZGVmYXVsdF9tYXhfY2hhdF9tZXNzYWdlcxgC'
    'IAEoBEgBUhZkZWZhdWx0TWF4Q2hhdE1lc3NhZ2VziAEBQhYKFF9kZWZhdWx0X21heF9tZW1iZX'
    'JzQhwKGl9kZWZhdWx0X21heF9jaGF0X21lc3NhZ2Vz');

@$core.Deprecated('Use permissionSettingsPatchDescriptor instead')
const PermissionSettingsPatch$json = {
  '1': 'PermissionSettingsPatch',
  '2': [
    {
      '1': 'admin_default_permissions',
      '3': 1,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'adminDefaultPermissions',
      '17': true
    },
    {
      '1': 'member_default_permissions',
      '3': 2,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'memberDefaultPermissions',
      '17': true
    },
    {
      '1': 'guest_default_permissions',
      '3': 3,
      '4': 1,
      '5': 4,
      '9': 2,
      '10': 'guestDefaultPermissions',
      '17': true
    },
  ],
  '8': [
    {'1': '_admin_default_permissions'},
    {'1': '_member_default_permissions'},
    {'1': '_guest_default_permissions'},
  ],
};

/// Descriptor for `PermissionSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionSettingsPatchDescriptor = $convert.base64Decode(
    'ChdQZXJtaXNzaW9uU2V0dGluZ3NQYXRjaBI/ChlhZG1pbl9kZWZhdWx0X3Blcm1pc3Npb25zGA'
    'EgASgESABSF2FkbWluRGVmYXVsdFBlcm1pc3Npb25ziAEBEkEKGm1lbWJlcl9kZWZhdWx0X3Bl'
    'cm1pc3Npb25zGAIgASgESAFSGG1lbWJlckRlZmF1bHRQZXJtaXNzaW9uc4gBARI/ChlndWVzdF'
    '9kZWZhdWx0X3Blcm1pc3Npb25zGAMgASgESAJSF2d1ZXN0RGVmYXVsdFBlcm1pc3Npb25ziAEB'
    'QhwKGl9hZG1pbl9kZWZhdWx0X3Blcm1pc3Npb25zQh0KG19tZW1iZXJfZGVmYXVsdF9wZXJtaX'
    'NzaW9uc0IcChpfZ3Vlc3RfZGVmYXVsdF9wZXJtaXNzaW9ucw==');

@$core.Deprecated('Use roomCreationSettingsPatchDescriptor instead')
const RoomCreationSettingsPatch$json = {
  '1': 'RoomCreationSettingsPatch',
  '2': [
    {
      '1': 'enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
    {
      '1': 'approval_required',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'approvalRequired',
      '17': true
    },
    {
      '1': 'password_policy',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomPasswordPolicy',
      '8': {},
      '9': 2,
      '10': 'passwordPolicy',
      '17': true
    },
    {
      '1': 'max_rooms_per_user',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'maxRoomsPerUser',
      '17': true
    },
  ],
  '8': [
    {'1': '_enabled'},
    {'1': '_approval_required'},
    {'1': '_password_policy'},
    {'1': '_max_rooms_per_user'},
  ],
};

/// Descriptor for `RoomCreationSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomCreationSettingsPatchDescriptor = $convert.base64Decode(
    'ChlSb29tQ3JlYXRpb25TZXR0aW5nc1BhdGNoEh0KB2VuYWJsZWQYASABKAhIAFIHZW5hYmxlZI'
    'gBARIwChFhcHByb3ZhbF9yZXF1aXJlZBgCIAEoCEgBUhBhcHByb3ZhbFJlcXVpcmVkiAEBElkK'
    'D3Bhc3N3b3JkX3BvbGljeRgDIAEoDjIhLnN5bmN0di5jb21tb24uUm9vbVBhc3N3b3JkUG9saW'
    'N5Qgi6SAWCAQIQAUgCUg5wYXNzd29yZFBvbGljeYgBARIwChJtYXhfcm9vbXNfcGVyX3VzZXIY'
    'BCABKANIA1IPbWF4Um9vbXNQZXJVc2VyiAEBQgoKCF9lbmFibGVkQhQKEl9hcHByb3ZhbF9yZX'
    'F1aXJlZEISChBfcGFzc3dvcmRfcG9saWN5QhUKE19tYXhfcm9vbXNfcGVyX3VzZXI=');

@$core.Deprecated('Use userSettingsPatchDescriptor instead')
const UserSettingsPatch$json = {
  '1': 'UserSettingsPatch',
  '2': [
    {
      '1': 'enable_password_signup',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enablePasswordSignup',
      '17': true
    },
    {
      '1': 'password_signup_need_review',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'passwordSignupNeedReview',
      '17': true
    },
    {
      '1': 'enable_email_signup',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'enableEmailSignup',
      '17': true
    },
    {
      '1': 'email_signup_need_review',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'emailSignupNeedReview',
      '17': true
    },
    {
      '1': 'enable_webauthn_signup',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 4,
      '10': 'enableWebauthnSignup',
      '17': true
    },
    {
      '1': 'webauthn_signup_need_review',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 5,
      '10': 'webauthnSignupNeedReview',
      '17': true
    },
    {
      '1': 'enable_guest',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 6,
      '10': 'enableGuest',
      '17': true
    },
  ],
  '8': [
    {'1': '_enable_password_signup'},
    {'1': '_password_signup_need_review'},
    {'1': '_enable_email_signup'},
    {'1': '_email_signup_need_review'},
    {'1': '_enable_webauthn_signup'},
    {'1': '_webauthn_signup_need_review'},
    {'1': '_enable_guest'},
  ],
};

/// Descriptor for `UserSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSettingsPatchDescriptor = $convert.base64Decode(
    'ChFVc2VyU2V0dGluZ3NQYXRjaBI5ChZlbmFibGVfcGFzc3dvcmRfc2lnbnVwGAEgASgISABSFG'
    'VuYWJsZVBhc3N3b3JkU2lnbnVwiAEBEkIKG3Bhc3N3b3JkX3NpZ251cF9uZWVkX3JldmlldxgC'
    'IAEoCEgBUhhwYXNzd29yZFNpZ251cE5lZWRSZXZpZXeIAQESMwoTZW5hYmxlX2VtYWlsX3NpZ2'
    '51cBgDIAEoCEgCUhFlbmFibGVFbWFpbFNpZ251cIgBARI8ChhlbWFpbF9zaWdudXBfbmVlZF9y'
    'ZXZpZXcYBCABKAhIA1IVZW1haWxTaWdudXBOZWVkUmV2aWV3iAEBEjkKFmVuYWJsZV93ZWJhdX'
    'Robl9zaWdudXAYBSABKAhIBFIUZW5hYmxlV2ViYXV0aG5TaWdudXCIAQESQgobd2ViYXV0aG5f'
    'c2lnbnVwX25lZWRfcmV2aWV3GAYgASgISAVSGHdlYmF1dGhuU2lnbnVwTmVlZFJldmlld4gBAR'
    'ImCgxlbmFibGVfZ3Vlc3QYByABKAhIBlILZW5hYmxlR3Vlc3SIAQFCGQoXX2VuYWJsZV9wYXNz'
    'd29yZF9zaWdudXBCHgocX3Bhc3N3b3JkX3NpZ251cF9uZWVkX3Jldmlld0IWChRfZW5hYmxlX2'
    'VtYWlsX3NpZ251cEIbChlfZW1haWxfc2lnbnVwX25lZWRfcmV2aWV3QhkKF19lbmFibGVfd2Vi'
    'YXV0aG5fc2lnbnVwQh4KHF93ZWJhdXRobl9zaWdudXBfbmVlZF9yZXZpZXdCDwoNX2VuYWJsZV'
    '9ndWVzdA==');

@$core.Deprecated('Use oAuth2SettingsPatchDescriptor instead')
const OAuth2SettingsPatch$json = {
  '1': 'OAuth2SettingsPatch',
  '2': [
    {
      '1': 'providers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.OAuth2ProviderSettings',
      '10': 'providers'
    },
    {
      '1': 'allowed_redirect_urls',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'allowedRedirectUrls'
    },
  ],
};

/// Descriptor for `OAuth2SettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2SettingsPatchDescriptor = $convert.base64Decode(
    'ChNPQXV0aDJTZXR0aW5nc1BhdGNoEkIKCXByb3ZpZGVycxgBIAMoCzIkLnN5bmN0di5hZG1pbi'
    '5PQXV0aDJQcm92aWRlclNldHRpbmdzUglwcm92aWRlcnMSMgoVYWxsb3dlZF9yZWRpcmVjdF91'
    'cmxzGAIgAygJUhNhbGxvd2VkUmVkaXJlY3RVcmxz');

@$core.Deprecated('Use rtmpSettingsPatchDescriptor instead')
const RtmpSettingsPatch$json = {
  '1': 'RtmpSettingsPatch',
  '2': [
    {
      '1': 'advertise_address',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'advertiseAddress',
      '17': true
    },
    {
      '1': 'ts_disguised_as_png',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'tsDisguisedAsPng',
      '17': true
    },
  ],
  '8': [
    {'1': '_advertise_address'},
    {'1': '_ts_disguised_as_png'},
  ],
};

/// Descriptor for `RtmpSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtmpSettingsPatchDescriptor = $convert.base64Decode(
    'ChFSdG1wU2V0dGluZ3NQYXRjaBIwChFhZHZlcnRpc2VfYWRkcmVzcxgBIAEoCUgAUhBhZHZlcn'
    'Rpc2VBZGRyZXNziAEBEjIKE3RzX2Rpc2d1aXNlZF9hc19wbmcYAiABKAhIAVIQdHNEaXNndWlz'
    'ZWRBc1BuZ4gBAUIUChJfYWR2ZXJ0aXNlX2FkZHJlc3NCFgoUX3RzX2Rpc2d1aXNlZF9hc19wbm'
    'c=');

@$core.Deprecated('Use emailSettingsPatchDescriptor instead')
const EmailSettingsPatch$json = {
  '1': 'EmailSettingsPatch',
  '2': [
    {
      '1': 'enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enabled',
      '17': true
    },
    {
      '1': 'smtp_host',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'smtpHost',
      '17': true
    },
    {
      '1': 'smtp_port',
      '3': 3,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'smtpPort',
      '17': true
    },
    {
      '1': 'smtp_credentials',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SmtpCredentials',
      '10': 'smtpCredentials'
    },
    {
      '1': 'smtp_proxy',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SmtpProxy',
      '10': 'smtpProxy'
    },
    {
      '1': 'use_tls',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'useTls',
      '17': true
    },
    {
      '1': 'from_email',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'fromEmail',
      '17': true
    },
    {
      '1': 'from_name',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'fromName',
      '17': true
    },
    {
      '1': 'whitelist_enabled',
      '3': 9,
      '4': 1,
      '5': 8,
      '9': 6,
      '10': 'whitelistEnabled',
      '17': true
    },
    {
      '1': 'whitelist_domains',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'whitelistDomains'
    },
  ],
  '8': [
    {'1': '_enabled'},
    {'1': '_smtp_host'},
    {'1': '_smtp_port'},
    {'1': '_use_tls'},
    {'1': '_from_email'},
    {'1': '_from_name'},
    {'1': '_whitelist_enabled'},
  ],
};

/// Descriptor for `EmailSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emailSettingsPatchDescriptor = $convert.base64Decode(
    'ChJFbWFpbFNldHRpbmdzUGF0Y2gSHQoHZW5hYmxlZBgBIAEoCEgAUgdlbmFibGVkiAEBEiAKCX'
    'NtdHBfaG9zdBgCIAEoCUgBUghzbXRwSG9zdIgBARIgCglzbXRwX3BvcnQYAyABKA1IAlIIc210'
    'cFBvcnSIAQESSAoQc210cF9jcmVkZW50aWFscxgEIAEoCzIdLnN5bmN0di5hZG1pbi5TbXRwQ3'
    'JlZGVudGlhbHNSD3NtdHBDcmVkZW50aWFscxI2CgpzbXRwX3Byb3h5GAUgASgLMhcuc3luY3R2'
    'LmFkbWluLlNtdHBQcm94eVIJc210cFByb3h5EhwKB3VzZV90bHMYBiABKAhIA1IGdXNlVGxziA'
    'EBEiIKCmZyb21fZW1haWwYByABKAlIBFIJZnJvbUVtYWlsiAEBEiAKCWZyb21fbmFtZRgIIAEo'
    'CUgFUghmcm9tTmFtZYgBARIwChF3aGl0ZWxpc3RfZW5hYmxlZBgJIAEoCEgGUhB3aGl0ZWxpc3'
    'RFbmFibGVkiAEBEisKEXdoaXRlbGlzdF9kb21haW5zGAogAygJUhB3aGl0ZWxpc3REb21haW5z'
    'QgoKCF9lbmFibGVkQgwKCl9zbXRwX2hvc3RCDAoKX3NtdHBfcG9ydEIKCghfdXNlX3Rsc0INCg'
    'tfZnJvbV9lbWFpbEIMCgpfZnJvbV9uYW1lQhQKEl93aGl0ZWxpc3RfZW5hYmxlZA==');

@$core.Deprecated('Use webRTCSettingsPatchDescriptor instead')
const WebRTCSettingsPatch$json = {
  '1': 'WebRTCSettingsPatch',
  '2': [
    {
      '1': 'external_ice_servers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.IceServer',
      '10': 'externalIceServers'
    },
    {
      '1': 'max_voice_participants_per_room',
      '3': 2,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'maxVoiceParticipantsPerRoom',
      '17': true
    },
  ],
  '8': [
    {'1': '_max_voice_participants_per_room'},
  ],
};

/// Descriptor for `WebRTCSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCSettingsPatchDescriptor = $convert.base64Decode(
    'ChNXZWJSVENTZXR0aW5nc1BhdGNoEkoKFGV4dGVybmFsX2ljZV9zZXJ2ZXJzGAEgAygLMhguc3'
    'luY3R2LmNsaWVudC5JY2VTZXJ2ZXJSEmV4dGVybmFsSWNlU2VydmVycxJJCh9tYXhfdm9pY2Vf'
    'cGFydGljaXBhbnRzX3Blcl9yb29tGAIgASgNSABSG21heFZvaWNlUGFydGljaXBhbnRzUGVyUm'
    '9vbYgBAUIiCiBfbWF4X3ZvaWNlX3BhcnRpY2lwYW50c19wZXJfcm9vbQ==');

@$core.Deprecated('Use chatSettingsPatchDescriptor instead')
const ChatSettingsPatch$json = {
  '1': 'ChatSettingsPatch',
  '2': [
    {
      '1': 'max_messages_per_room',
      '3': 1,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'maxMessagesPerRoom',
      '17': true
    },
    {
      '1': 'max_pinned_messages_per_room',
      '3': 2,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'maxPinnedMessagesPerRoom',
      '17': true
    },
    {
      '1': 'message_retention_days',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'messageRetentionDays',
      '17': true
    },
  ],
  '8': [
    {'1': '_max_messages_per_room'},
    {'1': '_max_pinned_messages_per_room'},
    {'1': '_message_retention_days'},
  ],
};

/// Descriptor for `ChatSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatSettingsPatchDescriptor = $convert.base64Decode(
    'ChFDaGF0U2V0dGluZ3NQYXRjaBI2ChVtYXhfbWVzc2FnZXNfcGVyX3Jvb20YASABKARIAFISbW'
    'F4TWVzc2FnZXNQZXJSb29tiAEBEkMKHG1heF9waW5uZWRfbWVzc2FnZXNfcGVyX3Jvb20YAiAB'
    'KARIAVIYbWF4UGlubmVkTWVzc2FnZXNQZXJSb29tiAEBEjkKFm1lc3NhZ2VfcmV0ZW50aW9uX2'
    'RheXMYAyABKANIAlIUbWVzc2FnZVJldGVudGlvbkRheXOIAQFCGAoWX21heF9tZXNzYWdlc19w'
    'ZXJfcm9vbUIfCh1fbWF4X3Bpbm5lZF9tZXNzYWdlc19wZXJfcm9vbUIZChdfbWVzc2FnZV9yZX'
    'RlbnRpb25fZGF5cw==');

@$core.Deprecated('Use playbackHistorySettingsPatchDescriptor instead')
const PlaybackHistorySettingsPatch$json = {
  '1': 'PlaybackHistorySettingsPatch',
  '2': [
    {
      '1': 'retention_days',
      '3': 1,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'retentionDays',
      '17': true
    },
    {
      '1': 'max_entries_per_room',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'maxEntriesPerRoom',
      '17': true
    },
  ],
  '8': [
    {'1': '_retention_days'},
    {'1': '_max_entries_per_room'},
  ],
};

/// Descriptor for `PlaybackHistorySettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackHistorySettingsPatchDescriptor = $convert.base64Decode(
    'ChxQbGF5YmFja0hpc3RvcnlTZXR0aW5nc1BhdGNoEioKDnJldGVudGlvbl9kYXlzGAEgASgNSA'
    'BSDXJldGVudGlvbkRheXOIAQESNAoUbWF4X2VudHJpZXNfcGVyX3Jvb20YAiABKANIAVIRbWF4'
    'RW50cmllc1BlclJvb22IAQFCEQoPX3JldGVudGlvbl9kYXlzQhcKFV9tYXhfZW50cmllc19wZX'
    'Jfcm9vbQ==');

@$core.Deprecated('Use corsSettingsPatchDescriptor instead')
const CorsSettingsPatch$json = {
  '1': 'CorsSettingsPatch',
  '2': [
    {'1': 'allowed_origins', '3': 1, '4': 3, '5': 9, '10': 'allowedOrigins'},
  ],
};

/// Descriptor for `CorsSettingsPatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List corsSettingsPatchDescriptor = $convert.base64Decode(
    'ChFDb3JzU2V0dGluZ3NQYXRjaBInCg9hbGxvd2VkX29yaWdpbnMYASADKAlSDmFsbG93ZWRPcm'
    'lnaW5z');

@$core.Deprecated('Use userRegistrationReviewDescriptor instead')
const UserRegistrationReview$json = {
  '1': 'UserRegistrationReview',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {
      '1': 'signup_method',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SignupMethod',
      '10': 'signupMethod'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.ReviewStatus',
      '10': 'status'
    },
    {'1': 'requested_at', '3': 6, '4': 1, '5': 3, '10': 'requestedAt'},
    {'1': 'reviewed_at', '3': 7, '4': 1, '5': 3, '10': 'reviewedAt'},
    {
      '1': 'reviewed_by',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'reviewedBy',
      '17': true
    },
    {
      '1': 'rejection_reason',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'rejectionReason',
      '17': true
    },
    {
      '1': 'oauth2_provider',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2ProviderType',
      '9': 2,
      '10': 'oauth2Provider',
      '17': true
    },
    {
      '1': 'oauth2_provider_user_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'oauth2ProviderUserId',
      '17': true
    },
    {
      '1': 'oauth2_provider_username',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'oauth2ProviderUsername',
      '17': true
    },
    {
      '1': 'oauth2_avatar_url',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'oauth2AvatarUrl',
      '17': true
    },
    {
      '1': 'oauth2_provider_instance_name',
      '3': 14,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'oauth2ProviderInstanceName',
      '17': true
    },
    {
      '1': 'oauth2_provider_issuer',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 7,
      '10': 'oauth2ProviderIssuer',
      '17': true
    },
    {
      '1': 'webauthn_credential_id',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 8,
      '10': 'webauthnCredentialId',
      '17': true
    },
    {
      '1': 'webauthn_credential_name',
      '3': 17,
      '4': 1,
      '5': 9,
      '9': 9,
      '10': 'webauthnCredentialName',
      '17': true
    },
  ],
  '8': [
    {'1': '_reviewed_by'},
    {'1': '_rejection_reason'},
    {'1': '_oauth2_provider'},
    {'1': '_oauth2_provider_user_id'},
    {'1': '_oauth2_provider_username'},
    {'1': '_oauth2_avatar_url'},
    {'1': '_oauth2_provider_instance_name'},
    {'1': '_oauth2_provider_issuer'},
    {'1': '_webauthn_credential_id'},
    {'1': '_webauthn_credential_name'},
  ],
};

/// Descriptor for `UserRegistrationReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userRegistrationReviewDescriptor = $convert.base64Decode(
    'ChZVc2VyUmVnaXN0cmF0aW9uUmV2aWV3Eg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIA'
    'EoCVIIdXNlcm5hbWUSFAoFZW1haWwYAyABKAlSBWVtYWlsEj8KDXNpZ251cF9tZXRob2QYBCAB'
    'KA4yGi5zeW5jdHYuYWRtaW4uU2lnbnVwTWV0aG9kUgxzaWdudXBNZXRob2QSMwoGc3RhdHVzGA'
    'UgASgOMhsuc3luY3R2LmNvbW1vbi5SZXZpZXdTdGF0dXNSBnN0YXR1cxIhCgxyZXF1ZXN0ZWRf'
    'YXQYBiABKANSC3JlcXVlc3RlZEF0Eh8KC3Jldmlld2VkX2F0GAcgASgDUgpyZXZpZXdlZEF0Ei'
    'QKC3Jldmlld2VkX2J5GAggASgJSABSCnJldmlld2VkQnmIAQESLgoQcmVqZWN0aW9uX3JlYXNv'
    'bhgJIAEoCUgBUg9yZWplY3Rpb25SZWFzb26IAQESTwoPb2F1dGgyX3Byb3ZpZGVyGAogASgOMi'
    'Euc3luY3R2LmNsaWVudC5PQXV0aDJQcm92aWRlclR5cGVIAlIOb2F1dGgyUHJvdmlkZXKIAQES'
    'OgoXb2F1dGgyX3Byb3ZpZGVyX3VzZXJfaWQYCyABKAlIA1IUb2F1dGgyUHJvdmlkZXJVc2VySW'
    'SIAQESPQoYb2F1dGgyX3Byb3ZpZGVyX3VzZXJuYW1lGAwgASgJSARSFm9hdXRoMlByb3ZpZGVy'
    'VXNlcm5hbWWIAQESLwoRb2F1dGgyX2F2YXRhcl91cmwYDSABKAlIBVIPb2F1dGgyQXZhdGFyVX'
    'JsiAEBEkYKHW9hdXRoMl9wcm92aWRlcl9pbnN0YW5jZV9uYW1lGA4gASgJSAZSGm9hdXRoMlBy'
    'b3ZpZGVySW5zdGFuY2VOYW1liAEBEjkKFm9hdXRoMl9wcm92aWRlcl9pc3N1ZXIYDyABKAlIB1'
    'IUb2F1dGgyUHJvdmlkZXJJc3N1ZXKIAQESOQoWd2ViYXV0aG5fY3JlZGVudGlhbF9pZBgQIAEo'
    'CUgIUhR3ZWJhdXRobkNyZWRlbnRpYWxJZIgBARI9Chh3ZWJhdXRobl9jcmVkZW50aWFsX25hbW'
    'UYESABKAlICVIWd2ViYXV0aG5DcmVkZW50aWFsTmFtZYgBAUIOCgxfcmV2aWV3ZWRfYnlCEwoR'
    'X3JlamVjdGlvbl9yZWFzb25CEgoQX29hdXRoMl9wcm92aWRlckIaChhfb2F1dGgyX3Byb3ZpZG'
    'VyX3VzZXJfaWRCGwoZX29hdXRoMl9wcm92aWRlcl91c2VybmFtZUIUChJfb2F1dGgyX2F2YXRh'
    'cl91cmxCIAoeX29hdXRoMl9wcm92aWRlcl9pbnN0YW5jZV9uYW1lQhkKF19vYXV0aDJfcHJvdm'
    'lkZXJfaXNzdWVyQhkKF193ZWJhdXRobl9jcmVkZW50aWFsX2lkQhsKGV93ZWJhdXRobl9jcmVk'
    'ZW50aWFsX25hbWU=');

@$core.Deprecated('Use roomCreationReviewDescriptor instead')
const RoomCreationReview$json = {
  '1': 'RoomCreationReview',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'requested_by', '3': 2, '4': 1, '5': 9, '10': 'requestedBy'},
    {
      '1': 'requested_by_username',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'requestedByUsername'
    },
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.ReviewStatus',
      '10': 'status'
    },
    {'1': 'requested_at', '3': 7, '4': 1, '5': 3, '10': 'requestedAt'},
    {'1': 'reviewed_at', '3': 8, '4': 1, '5': 3, '10': 'reviewedAt'},
    {
      '1': 'reviewed_by',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'reviewedBy',
      '17': true
    },
    {
      '1': 'rejection_reason',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'rejectionReason',
      '17': true
    },
    {
      '1': 'category',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomCategory',
      '10': 'category'
    },
    {
      '1': 'labels',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomLabel',
      '10': 'labels'
    },
  ],
  '8': [
    {'1': '_reviewed_by'},
    {'1': '_rejection_reason'},
  ],
};

/// Descriptor for `RoomCreationReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomCreationReviewDescriptor = $convert.base64Decode(
    'ChJSb29tQ3JlYXRpb25SZXZpZXcSDgoCaWQYASABKAlSAmlkEiEKDHJlcXVlc3RlZF9ieRgCIA'
    'EoCVILcmVxdWVzdGVkQnkSMgoVcmVxdWVzdGVkX2J5X3VzZXJuYW1lGAMgASgJUhNyZXF1ZXN0'
    'ZWRCeVVzZXJuYW1lEhIKBG5hbWUYBCABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2'
    'Rlc2NyaXB0aW9uEjMKBnN0YXR1cxgGIAEoDjIbLnN5bmN0di5jb21tb24uUmV2aWV3U3RhdHVz'
    'UgZzdGF0dXMSIQoMcmVxdWVzdGVkX2F0GAcgASgDUgtyZXF1ZXN0ZWRBdBIfCgtyZXZpZXdlZF'
    '9hdBgIIAEoA1IKcmV2aWV3ZWRBdBIkCgtyZXZpZXdlZF9ieRgJIAEoCUgAUgpyZXZpZXdlZEJ5'
    'iAEBEi4KEHJlamVjdGlvbl9yZWFzb24YCiABKAlIAVIPcmVqZWN0aW9uUmVhc29uiAEBEjcKCG'
    'NhdGVnb3J5GAsgASgLMhsuc3luY3R2LmNsaWVudC5Sb29tQ2F0ZWdvcnlSCGNhdGVnb3J5EjAK'
    'BmxhYmVscxgMIAMoCzIYLnN5bmN0di5jbGllbnQuUm9vbUxhYmVsUgZsYWJlbHNCDgoMX3Jldm'
    'lld2VkX2J5QhMKEV9yZWplY3Rpb25fcmVhc29u');

@$core.Deprecated('Use roomJoinReviewDescriptor instead')
const RoomJoinReview$json = {
  '1': 'RoomJoinReview',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'room_name', '3': 3, '4': 1, '5': 9, '10': 'roomName'},
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 5, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'requested_role',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'requestedRole'
    },
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.ReviewStatus',
      '10': 'status'
    },
    {'1': 'requested_at', '3': 8, '4': 1, '5': 3, '10': 'requestedAt'},
    {'1': 'reviewed_at', '3': 9, '4': 1, '5': 3, '10': 'reviewedAt'},
    {
      '1': 'reviewed_by',
      '3': 10,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'reviewedBy',
      '17': true
    },
    {
      '1': 'rejection_reason',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'rejectionReason',
      '17': true
    },
  ],
  '8': [
    {'1': '_reviewed_by'},
    {'1': '_rejection_reason'},
  ],
};

/// Descriptor for `RoomJoinReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomJoinReviewDescriptor = $convert.base64Decode(
    'Cg5Sb29tSm9pblJldmlldxIOCgJpZBgBIAEoCVICaWQSFwoHcm9vbV9pZBgCIAEoCVIGcm9vbU'
    'lkEhsKCXJvb21fbmFtZRgDIAEoCVIIcm9vbU5hbWUSFwoHdXNlcl9pZBgEIAEoCVIGdXNlcklk'
    'EhoKCHVzZXJuYW1lGAUgASgJUgh1c2VybmFtZRJECg5yZXF1ZXN0ZWRfcm9sZRgGIAEoDjIdLn'
    'N5bmN0di5jb21tb24uUm9vbU1lbWJlclJvbGVSDXJlcXVlc3RlZFJvbGUSMwoGc3RhdHVzGAcg'
    'ASgOMhsuc3luY3R2LmNvbW1vbi5SZXZpZXdTdGF0dXNSBnN0YXR1cxIhCgxyZXF1ZXN0ZWRfYX'
    'QYCCABKANSC3JlcXVlc3RlZEF0Eh8KC3Jldmlld2VkX2F0GAkgASgDUgpyZXZpZXdlZEF0EiQK'
    'C3Jldmlld2VkX2J5GAogASgJSABSCnJldmlld2VkQnmIAQESLgoQcmVqZWN0aW9uX3JlYXNvbh'
    'gLIAEoCUgBUg9yZWplY3Rpb25SZWFzb26IAQFCDgoMX3Jldmlld2VkX2J5QhMKEV9yZWplY3Rp'
    'b25fcmVhc29u');

@$core.Deprecated('Use banRecordDescriptor instead')
const BanRecord$json = {
  '1': 'BanRecord',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'target_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.BanTargetType',
      '10': 'targetType'
    },
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {'1': 'room_id', '3': 5, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'room_name', '3': 6, '4': 1, '5': 9, '10': 'roomName'},
    {'1': 'banned_by', '3': 7, '4': 1, '5': 9, '10': 'bannedBy'},
    {
      '1': 'banned_by_username',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'bannedByUsername'
    },
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'starts_at', '3': 10, '4': 1, '5': 3, '10': 'startsAt'},
    {'1': 'ends_at', '3': 11, '4': 1, '5': 3, '10': 'endsAt'},
    {'1': 'revoked_at', '3': 12, '4': 1, '5': 3, '10': 'revokedAt'},
    {'1': 'revoked_by', '3': 13, '4': 1, '5': 9, '10': 'revokedBy'},
    {'1': 'is_active', '3': 14, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `BanRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banRecordDescriptor = $convert.base64Decode(
    'CglCYW5SZWNvcmQSDgoCaWQYASABKAlSAmlkEjwKC3RhcmdldF90eXBlGAIgASgOMhsuc3luY3'
    'R2LmFkbWluLkJhblRhcmdldFR5cGVSCnRhcmdldFR5cGUSFwoHdXNlcl9pZBgDIAEoCVIGdXNl'
    'cklkEhoKCHVzZXJuYW1lGAQgASgJUgh1c2VybmFtZRIXCgdyb29tX2lkGAUgASgJUgZyb29tSW'
    'QSGwoJcm9vbV9uYW1lGAYgASgJUghyb29tTmFtZRIbCgliYW5uZWRfYnkYByABKAlSCGJhbm5l'
    'ZEJ5EiwKEmJhbm5lZF9ieV91c2VybmFtZRgIIAEoCVIQYmFubmVkQnlVc2VybmFtZRIWCgZyZW'
    'Fzb24YCSABKAlSBnJlYXNvbhIbCglzdGFydHNfYXQYCiABKANSCHN0YXJ0c0F0EhcKB2VuZHNf'
    'YXQYCyABKANSBmVuZHNBdBIdCgpyZXZva2VkX2F0GAwgASgDUglyZXZva2VkQXQSHQoKcmV2b2'
    'tlZF9ieRgNIAEoCVIJcmV2b2tlZEJ5EhsKCWlzX2FjdGl2ZRgOIAEoCFIIaXNBY3RpdmU=');

@$core.Deprecated('Use contentReportDescriptor instead')
const ContentReport$json = {
  '1': 'ContentReport',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'reporter_user_id', '3': 2, '4': 1, '5': 9, '10': 'reporterUserId'},
    {
      '1': 'reporter_username',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'reporterUsername'
    },
    {'1': 'room_id', '3': 4, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'room_name', '3': 5, '4': 1, '5': 9, '10': 'roomName'},
    {
      '1': 'target_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ContentReportTargetType',
      '10': 'targetType'
    },
    {'1': 'target_room_id', '3': 7, '4': 1, '5': 9, '10': 'targetRoomId'},
    {'1': 'target_room_name', '3': 8, '4': 1, '5': 9, '10': 'targetRoomName'},
    {'1': 'target_user_id', '3': 9, '4': 1, '5': 9, '10': 'targetUserId'},
    {'1': 'target_username', '3': 10, '4': 1, '5': 9, '10': 'targetUsername'},
    {
      '1': 'target_member_room_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'targetMemberRoomId'
    },
    {
      '1': 'target_member_room_name',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'targetMemberRoomName'
    },
    {
      '1': 'target_member_user_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'targetMemberUserId'
    },
    {
      '1': 'target_member_username',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'targetMemberUsername'
    },
    {
      '1': 'target_chat_message_id',
      '3': 15,
      '4': 1,
      '5': 3,
      '10': 'targetChatMessageId'
    },
    {
      '1': 'target_chat_message_created_at',
      '3': 16,
      '4': 1,
      '5': 3,
      '10': 'targetChatMessageCreatedAt'
    },
    {
      '1': 'target_chat_message_preview',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'targetChatMessagePreview'
    },
    {'1': 'reason_code', '3': 18, '4': 1, '5': 9, '10': 'reasonCode'},
    {'1': 'reason', '3': 19, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'metadata',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ContentReportMetadata',
      '10': 'metadata'
    },
    {
      '1': 'status',
      '3': 21,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ContentReportStatus',
      '10': 'status'
    },
    {'1': 'reviewed_by', '3': 22, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_by_username',
      '3': 23,
      '4': 1,
      '5': 9,
      '10': 'reviewedByUsername'
    },
    {'1': 'reviewed_at', '3': 24, '4': 1, '5': 3, '10': 'reviewedAt'},
    {'1': 'resolution_note', '3': 25, '4': 1, '5': 9, '10': 'resolutionNote'},
    {'1': 'created_at', '3': 26, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 27, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `ContentReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentReportDescriptor = $convert.base64Decode(
    'Cg1Db250ZW50UmVwb3J0Eg4KAmlkGAEgASgJUgJpZBIoChByZXBvcnRlcl91c2VyX2lkGAIgAS'
    'gJUg5yZXBvcnRlclVzZXJJZBIrChFyZXBvcnRlcl91c2VybmFtZRgDIAEoCVIQcmVwb3J0ZXJV'
    'c2VybmFtZRIXCgdyb29tX2lkGAQgASgJUgZyb29tSWQSGwoJcm9vbV9uYW1lGAUgASgJUghyb2'
    '9tTmFtZRJGCgt0YXJnZXRfdHlwZRgGIAEoDjIlLnN5bmN0di5hZG1pbi5Db250ZW50UmVwb3J0'
    'VGFyZ2V0VHlwZVIKdGFyZ2V0VHlwZRIkCg50YXJnZXRfcm9vbV9pZBgHIAEoCVIMdGFyZ2V0Um'
    '9vbUlkEigKEHRhcmdldF9yb29tX25hbWUYCCABKAlSDnRhcmdldFJvb21OYW1lEiQKDnRhcmdl'
    'dF91c2VyX2lkGAkgASgJUgx0YXJnZXRVc2VySWQSJwoPdGFyZ2V0X3VzZXJuYW1lGAogASgJUg'
    '50YXJnZXRVc2VybmFtZRIxChV0YXJnZXRfbWVtYmVyX3Jvb21faWQYCyABKAlSEnRhcmdldE1l'
    'bWJlclJvb21JZBI1Chd0YXJnZXRfbWVtYmVyX3Jvb21fbmFtZRgMIAEoCVIUdGFyZ2V0TWVtYm'
    'VyUm9vbU5hbWUSMQoVdGFyZ2V0X21lbWJlcl91c2VyX2lkGA0gASgJUhJ0YXJnZXRNZW1iZXJV'
    'c2VySWQSNAoWdGFyZ2V0X21lbWJlcl91c2VybmFtZRgOIAEoCVIUdGFyZ2V0TWVtYmVyVXNlcm'
    '5hbWUSMwoWdGFyZ2V0X2NoYXRfbWVzc2FnZV9pZBgPIAEoA1ITdGFyZ2V0Q2hhdE1lc3NhZ2VJ'
    'ZBJCCh50YXJnZXRfY2hhdF9tZXNzYWdlX2NyZWF0ZWRfYXQYECABKANSGnRhcmdldENoYXRNZX'
    'NzYWdlQ3JlYXRlZEF0Ej0KG3RhcmdldF9jaGF0X21lc3NhZ2VfcHJldmlldxgRIAEoCVIYdGFy'
    'Z2V0Q2hhdE1lc3NhZ2VQcmV2aWV3Eh8KC3JlYXNvbl9jb2RlGBIgASgJUgpyZWFzb25Db2RlEh'
    'YKBnJlYXNvbhgTIAEoCVIGcmVhc29uEkAKCG1ldGFkYXRhGBQgASgLMiQuc3luY3R2LmNsaWVu'
    'dC5Db250ZW50UmVwb3J0TWV0YWRhdGFSCG1ldGFkYXRhEjkKBnN0YXR1cxgVIAEoDjIhLnN5bm'
    'N0di5hZG1pbi5Db250ZW50UmVwb3J0U3RhdHVzUgZzdGF0dXMSHwoLcmV2aWV3ZWRfYnkYFiAB'
    'KAlSCnJldmlld2VkQnkSMAoUcmV2aWV3ZWRfYnlfdXNlcm5hbWUYFyABKAlSEnJldmlld2VkQn'
    'lVc2VybmFtZRIfCgtyZXZpZXdlZF9hdBgYIAEoA1IKcmV2aWV3ZWRBdBInCg9yZXNvbHV0aW9u'
    'X25vdGUYGSABKAlSDnJlc29sdXRpb25Ob3RlEh0KCmNyZWF0ZWRfYXQYGiABKANSCWNyZWF0ZW'
    'RBdBIdCgp1cGRhdGVkX2F0GBsgASgDUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor =
    $convert.base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use sendTestEmailRequestDescriptor instead')
const SendTestEmailRequest$json = {
  '1': 'SendTestEmailRequest',
  '2': [
    {'1': 'to', '3': 1, '4': 1, '5': 9, '10': 'to'},
  ],
};

/// Descriptor for `SendTestEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendTestEmailRequestDescriptor = $convert
    .base64Decode('ChRTZW5kVGVzdEVtYWlsUmVxdWVzdBIOCgJ0bxgBIAEoCVICdG8=');

@$core.Deprecated('Use sendTestEmailResponseDescriptor instead')
const SendTestEmailResponse$json = {
  '1': 'SendTestEmailResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SendTestEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendTestEmailResponseDescriptor = $convert.base64Decode(
    'ChVTZW5kVGVzdEVtYWlsUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZX'
    'NzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use createUserRequestDescriptor instead')
const CreateUserRequest$json = {
  '1': 'CreateUserRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '8': {},
      '10': 'role'
    },
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '8': {},
      '10': 'status'
    },
    {'1': 'password', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'password'},
  ],
};

/// Descriptor for `CreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVVc2VyUmVxdWVzdBI4Cgh1c2VybmFtZRgBIAEoCUIcukgZchcQAxgyMhFeW1xwe0'
    'x9XHB7Tn1fLV0rJFIIdXNlcm5hbWUSIwoFZW1haWwYAiABKAlCDbpICnIFGP4BYAHYAQFSBWVt'
    'YWlsEjUKBHJvbGUYAyABKA4yFy5zeW5jdHYuY29tbW9uLlVzZXJSb2xlQgi6SAWCAQIQAVIEcm'
    '9sZRI7CgZzdGF0dXMYBCABKA4yGS5zeW5jdHYuY29tbW9uLlVzZXJTdGF0dXNCCLpIBYIBAhAB'
    'UgZzdGF0dXMSKQoIcGFzc3dvcmQYBSABKAlCDbpICnIFEAgYgAHYAQFSCHBhc3N3b3Jk');

@$core.Deprecated('Use deleteUserRequestDescriptor instead')
const DeleteUserRequest$json = {
  '1': 'DeleteUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `DeleteUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVVc2VyUmVxdWVzdBI2Cgd1c2VyX2lkGAEgASgJQh26SBpyGBABGEAyEl51c3JfW0'
    'EtWmEtejAtOV0rJFIGdXNlcklk');

@$core.Deprecated('Use deleteUserResponseDescriptor instead')
const DeleteUserResponse$json = {
  '1': 'DeleteUserResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUserResponseDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVVc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use listUsersRequestDescriptor instead')
const ListUsersRequest$json = {
  '1': 'ListUsersRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '8': {},
      '10': 'status'
    },
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '8': {},
      '10': 'role'
    },
    {'1': 'search', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'sort_by',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.UserListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
    {
      '1': 'is_banned',
      '3': 8,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isBanned',
      '17': true
    },
  ],
  '7': {},
  '8': [
    {'1': '_is_banned'},
  ],
};

/// Descriptor for `ListUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VXNlcnNSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAIgAS'
    'gFUghwYWdlU2l6ZRI7CgZzdGF0dXMYAyABKA4yGS5zeW5jdHYuY29tbW9uLlVzZXJTdGF0dXNC'
    'CLpIBYIBAhABUgZzdGF0dXMSNQoEcm9sZRgEIAEoDjIXLnN5bmN0di5jb21tb24uVXNlclJvbG'
    'VCCLpIBYIBAhABUgRyb2xlEh8KBnNlYXJjaBgFIAEoCUIHukgEcgIYZFIGc2VhcmNoEj8KB3Nv'
    'cnRfYnkYBiABKA4yHC5zeW5jdHYuYWRtaW4uVXNlckxpc3RTb3J0QnlCCLpIBYIBAhABUgZzb3'
    'J0QnkSTAoOc29ydF9kaXJlY3Rpb24YByABKA4yGy5zeW5jdHYuYWRtaW4uU29ydERpcmVjdGlv'
    'bkIIukgFggECEAFSDXNvcnREaXJlY3Rpb24SIAoJaXNfYmFubmVkGAggASgISABSCGlzQmFubm'
    'VkiAEBOokCukiFAhplChVhZG1pbi5saXN0X3VzZXJzLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1'
    'c2UgZGVmYXVsdCkgb3IgYXQgbGVhc3QgMRogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID'
    '49IDEamwEKGmFkbWluLmxpc3RfdXNlcnMucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAw'
    'ICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09ID'
    'AgfHwgKHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKUIMCgpf'
    'aXNfYmFubmVk');

@$core.Deprecated('Use listUsersResponseDescriptor instead')
const ListUsersResponse$json = {
  '1': 'ListUsersResponse',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'users'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUsersResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VXNlcnNSZXNwb25zZRItCgV1c2VycxgBIAMoCzIXLnN5bmN0di5hZG1pbi5BZG1pbl'
    'VzZXJSBXVzZXJzEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

@$core.Deprecated('Use getUserRequestDescriptor instead')
const GetUserRequest$json = {
  '1': 'GetUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRVc2VyUmVxdWVzdBI2Cgd1c2VyX2lkGAEgASgJQh26SBpyGBABGEAyEl51c3JfW0EtWm'
    'EtejAtOV0rJFIGdXNlcklk');

@$core.Deprecated('Use userPathRequestDescriptor instead')
const UserPathRequest$json = {
  '1': 'UserPathRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `UserPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPathRequestDescriptor = $convert.base64Decode(
    'Cg9Vc2VyUGF0aFJlcXVlc3QSNgoHdXNlcl9pZBgBIAEoCUIdukgachgQARhAMhJedXNyX1tBLV'
    'phLXowLTldKyRSBnVzZXJJZA==');

@$core.Deprecated('Use getUserPreferencesRequestDescriptor instead')
const GetUserPreferencesRequest$json = {
  '1': 'GetUserPreferencesRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `GetUserPreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserPreferencesRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRVc2VyUHJlZmVyZW5jZXNSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQD'
        'ISXnVzcl9bQS1aYS16MC05XSskUgZ1c2VySWQ=');

@$core.Deprecated('Use getUserPreferencesResponseDescriptor instead')
const GetUserPreferencesResponse$json = {
  '1': 'GetUserPreferencesResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
    {
      '1': 'preferences',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPreferences',
      '10': 'preferences'
    },
    {
      '1': 'auth_factors',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAuthFactors',
      '10': 'authFactors'
    },
  ],
};

/// Descriptor for `GetUserPreferencesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserPreferencesResponseDescriptor = $convert.base64Decode(
    'ChpHZXRVc2VyUHJlZmVyZW5jZXNSZXNwb25zZRIrCgR1c2VyGAEgASgLMhcuc3luY3R2LmFkbW'
    'luLkFkbWluVXNlclIEdXNlchJACgtwcmVmZXJlbmNlcxgCIAEoCzIeLnN5bmN0di5jbGllbnQu'
    'VXNlclByZWZlcmVuY2VzUgtwcmVmZXJlbmNlcxJBCgxhdXRoX2ZhY3RvcnMYAyABKAsyHi5zeW'
    '5jdHYuY2xpZW50LlVzZXJBdXRoRmFjdG9yc1ILYXV0aEZhY3RvcnM=');

@$core.Deprecated('Use updateUserPreferencesRequestDescriptor instead')
const UpdateUserPreferencesRequest$json = {
  '1': 'UpdateUserPreferencesRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'two_factor_enabled',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'twoFactorEnabled',
      '17': true
    },
    {
      '1': 'notifications',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserNotificationPreferences',
      '10': 'notifications'
    },
  ],
  '8': [
    {'1': '_two_factor_enabled'},
  ],
};

/// Descriptor for `UpdateUserPreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserPreferencesRequestDescriptor = $convert.base64Decode(
    'ChxVcGRhdGVVc2VyUHJlZmVyZW5jZXNSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEA'
    'EYQDISXnVzcl9bQS1aYS16MC05XSskUgZ1c2VySWQSMQoSdHdvX2ZhY3Rvcl9lbmFibGVkGAIg'
    'ASgISABSEHR3b0ZhY3RvckVuYWJsZWSIAQESUAoNbm90aWZpY2F0aW9ucxgEIAEoCzIqLnN5bm'
    'N0di5jbGllbnQuVXNlck5vdGlmaWNhdGlvblByZWZlcmVuY2VzUg1ub3RpZmljYXRpb25zQhUK'
    'E190d29fZmFjdG9yX2VuYWJsZWQ=');

@$core.Deprecated('Use updateUserPreferencesResponseDescriptor instead')
const UpdateUserPreferencesResponse$json = {
  '1': 'UpdateUserPreferencesResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
    {
      '1': 'preferences',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPreferences',
      '10': 'preferences'
    },
    {
      '1': 'auth_factors',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAuthFactors',
      '10': 'authFactors'
    },
  ],
};

/// Descriptor for `UpdateUserPreferencesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserPreferencesResponseDescriptor = $convert.base64Decode(
    'Ch1VcGRhdGVVc2VyUHJlZmVyZW5jZXNSZXNwb25zZRIrCgR1c2VyGAEgASgLMhcuc3luY3R2Lm'
    'FkbWluLkFkbWluVXNlclIEdXNlchJACgtwcmVmZXJlbmNlcxgCIAEoCzIeLnN5bmN0di5jbGll'
    'bnQuVXNlclByZWZlcmVuY2VzUgtwcmVmZXJlbmNlcxJBCgxhdXRoX2ZhY3RvcnMYAyABKAsyHi'
    '5zeW5jdHYuY2xpZW50LlVzZXJBdXRoRmFjdG9yc1ILYXV0aEZhY3RvcnM=');

@$core.Deprecated('Use setUserPasswordRequestDescriptor instead')
const SetUserPasswordRequest$json = {
  '1': 'SetUserPasswordRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `SetUserPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setUserPasswordRequestDescriptor = $convert.base64Decode(
    'ChZTZXRVc2VyUGFzc3dvcmRSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQDISXn'
    'Vzcl9bQS1aYS16MC05XSskUgZ1c2VySWQSJgoIcGFzc3dvcmQYAiABKAlCCrpIB3IFEAgYgAhS'
    'CHBhc3N3b3JkEiAKBnJlYXNvbhgDIAEoCUIIukgFcgMY9ANSBnJlYXNvbg==');

@$core.Deprecated('Use setUserPasswordResponseDescriptor instead')
const SetUserPasswordResponse$json = {
  '1': 'SetUserPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `SetUserPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setUserPasswordResponseDescriptor =
    $convert.base64Decode(
        'ChdTZXRVc2VyUGFzc3dvcmRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEisKBH'
        'VzZXIYAiABKAsyFy5zeW5jdHYuYWRtaW4uQWRtaW5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use updateUserUsernameRequestDescriptor instead')
const UpdateUserUsernameRequest$json = {
  '1': 'UpdateUserUsernameRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'new_username', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'newUsername'},
  ],
};

/// Descriptor for `UpdateUserUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserUsernameRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVVc2VyVXNlcm5hbWVSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQD'
    'ISXnVzcl9bQS1aYS16MC05XSskUgZ1c2VySWQSPwoMbmV3X3VzZXJuYW1lGAIgASgJQhy6SBly'
    'FxADGDIyEV5bXHB7TH1ccHtOfV8tXSskUgtuZXdVc2VybmFtZQ==');

@$core.Deprecated('Use updateUserRoleRequestDescriptor instead')
const UpdateUserRoleRequest$json = {
  '1': 'UpdateUserRoleRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'role',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '8': {},
      '10': 'role'
    },
  ],
};

/// Descriptor for `UpdateUserRoleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRoleRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVVc2VyUm9sZVJlcXVlc3QSNgoHdXNlcl9pZBgBIAEoCUIdukgachgQARhAMhJedX'
    'NyX1tBLVphLXowLTldKyRSBnVzZXJJZBI1CgRyb2xlGAIgASgOMhcuc3luY3R2LmNvbW1vbi5V'
    'c2VyUm9sZUIIukgFggECEAFSBHJvbGU=');

@$core.Deprecated('Use banUserRequestDescriptor instead')
const BanUserRequest$json = {
  '1': 'BanUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BanUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banUserRequestDescriptor = $convert.base64Decode(
    'Cg5CYW5Vc2VyUmVxdWVzdBI2Cgd1c2VyX2lkGAEgASgJQh26SBpyGBABGEAyEl51c3JfW0EtWm'
    'EtejAtOV0rJFIGdXNlcklkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use unbanUserRequestDescriptor instead')
const UnbanUserRequest$json = {
  '1': 'UnbanUserRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `UnbanUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbanUserRequestDescriptor = $convert.base64Decode(
    'ChBVbmJhblVzZXJSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQDISXnVzcl9bQS'
    '1aYS16MC05XSskUgZ1c2VySWQ=');

@$core.Deprecated('Use getUserRoomsRequestDescriptor instead')
const GetUserRoomsRequest$json = {
  '1': 'GetUserRoomsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomStatus',
      '8': {},
      '10': 'status'
    },
    {'1': 'search', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'is_banned',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isBanned',
      '17': true
    },
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.RoomListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
  '8': [
    {'1': '_is_banned'},
  ],
};

/// Descriptor for `GetUserRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRoomsRequestDescriptor = $convert.base64Decode(
    'ChNHZXRVc2VyUm9vbXNSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQDISXnVzcl'
    '9bQS1aYS16MC05XSskUgZ1c2VySWQSEgoEcGFnZRgCIAEoBVIEcGFnZRIbCglwYWdlX3NpemUY'
    'AyABKAVSCHBhZ2VTaXplEjsKBnN0YXR1cxgEIAEoDjIZLnN5bmN0di5jb21tb24uUm9vbVN0YX'
    'R1c0IIukgFggECEAFSBnN0YXR1cxIfCgZzZWFyY2gYBSABKAlCB7pIBHICGGRSBnNlYXJjaBIg'
    'Cglpc19iYW5uZWQYBiABKAhIAFIIaXNCYW5uZWSIAQESPwoHc29ydF9ieRgHIAEoDjIcLnN5bm'
    'N0di5hZG1pbi5Sb29tTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRCeRJMCg5zb3J0X2RpcmVj'
    'dGlvbhgIIAEoDjIbLnN5bmN0di5hZG1pbi5Tb3J0RGlyZWN0aW9uQgi6SAWCAQIQAVINc29ydE'
    'RpcmVjdGlvbjqRArpIjQIaaQoZYWRtaW4uZ2V0X3VzZXJfcm9vbXMucGFnZRIqcGFnZSBtdXN0'
    'IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdCAxGiB0aGlzLnBhZ2UgPT0gMCB8fCB0aG'
    'lzLnBhZ2UgPj0gMRqfAQoeYWRtaW4uZ2V0X3VzZXJfcm9vbXMucGFnZV9zaXplEjZwYWdlX3Np'
    'emUgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucG'
    'FnZV9zaXplID09IDAgfHwgKHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUg'
    'PD0gMTAwKUIMCgpfaXNfYmFubmVk');

@$core.Deprecated('Use getUserRoomsResponseDescriptor instead')
const GetUserRoomsResponse$json = {
  '1': 'GetUserRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.Room',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `GetUserRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRoomsResponseDescriptor = $convert.base64Decode(
    'ChRHZXRVc2VyUm9vbXNSZXNwb25zZRIoCgVyb29tcxgBIAMoCzISLnN5bmN0di5hZG1pbi5Sb2'
    '9tUgVyb29tcxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use listUserRegistrationReviewsRequestDescriptor instead')
const ListUserRegistrationReviewsRequest$json = {
  '1': 'ListUserRegistrationReviewsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.ReviewStatus',
      '8': {},
      '10': 'status'
    },
    {'1': 'search', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'search'},
  ],
  '7': {},
};

/// Descriptor for `ListUserRegistrationReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserRegistrationReviewsRequestDescriptor = $convert.base64Decode(
    'CiJMaXN0VXNlclJlZ2lzdHJhdGlvblJldmlld3NSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2'
    'USGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZRI9CgZzdGF0dXMYAyABKA4yGy5zeW5jdHYu'
    'Y29tbW9uLlJldmlld1N0YXR1c0IIukgFggECEAFSBnN0YXR1cxIfCgZzZWFyY2gYBCABKAlCB7'
    'pIBHICGGRSBnNlYXJjaDqxArpIrQIaeQopYWRtaW4ubGlzdF91c2VyX3JlZ2lzdHJhdGlvbl9y'
    'ZXZpZXdzLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYXQgbGVhc3QgMR'
    'ogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEarwEKLmFkbWluLmxpc3RfdXNlcl9y'
    'ZWdpc3RyYXRpb25fcmV2aWV3cy5wYWdlX3NpemUSNnBhZ2Vfc2l6ZSBtdXN0IGJlIDAgKHVzZS'
    'BkZWZhdWx0KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBpFdGhpcy5wYWdlX3NpemUgPT0gMCB8fCAo'
    'dGhpcy5wYWdlX3NpemUgPj0gMSAmJiB0aGlzLnBhZ2Vfc2l6ZSA8PSAxMDAp');

@$core.Deprecated('Use listUserRegistrationReviewsResponseDescriptor instead')
const ListUserRegistrationReviewsResponse$json = {
  '1': 'ListUserRegistrationReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.UserRegistrationReview',
      '10': 'reviews'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListUserRegistrationReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUserRegistrationReviewsResponseDescriptor =
    $convert.base64Decode(
        'CiNMaXN0VXNlclJlZ2lzdHJhdGlvblJldmlld3NSZXNwb25zZRI+CgdyZXZpZXdzGAEgAygLMi'
        'Quc3luY3R2LmFkbWluLlVzZXJSZWdpc3RyYXRpb25SZXZpZXdSB3Jldmlld3MSFAoFdG90YWwY'
        'AiABKAVSBXRvdGFs');

@$core.Deprecated('Use approveUserRegistrationReviewRequestDescriptor instead')
const ApproveUserRegistrationReviewRequest$json = {
  '1': 'ApproveUserRegistrationReviewRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
  ],
};

/// Descriptor for `ApproveUserRegistrationReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveUserRegistrationReviewRequestDescriptor =
    $convert.base64Decode(
        'CiRBcHByb3ZlVXNlclJlZ2lzdHJhdGlvblJldmlld1JlcXVlc3QSPAoKcmVxdWVzdF9pZBgBIA'
        'EoCUIdukgachgQARhAMhJedXNyX1tBLVphLXowLTldKyRSCXJlcXVlc3RJZA==');

@$core.Deprecated('Use approveUserRegistrationReviewResponseDescriptor instead')
const ApproveUserRegistrationReviewResponse$json = {
  '1': 'ApproveUserRegistrationReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.UserRegistrationReview',
      '10': 'review'
    },
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `ApproveUserRegistrationReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveUserRegistrationReviewResponseDescriptor =
    $convert.base64Decode(
        'CiVBcHByb3ZlVXNlclJlZ2lzdHJhdGlvblJldmlld1Jlc3BvbnNlEjwKBnJldmlldxgBIAEoCz'
        'IkLnN5bmN0di5hZG1pbi5Vc2VyUmVnaXN0cmF0aW9uUmV2aWV3UgZyZXZpZXcSKwoEdXNlchgC'
        'IAEoCzIXLnN5bmN0di5hZG1pbi5BZG1pblVzZXJSBHVzZXI=');

@$core.Deprecated('Use rejectUserRegistrationReviewRequestDescriptor instead')
const RejectUserRegistrationReviewRequest$json = {
  '1': 'RejectUserRegistrationReviewRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `RejectUserRegistrationReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectUserRegistrationReviewRequestDescriptor =
    $convert.base64Decode(
        'CiNSZWplY3RVc2VyUmVnaXN0cmF0aW9uUmV2aWV3UmVxdWVzdBI8CgpyZXF1ZXN0X2lkGAEgAS'
        'gJQh26SBpyGBABGEAyEl51c3JfW0EtWmEtejAtOV0rJFIJcmVxdWVzdElkEiAKBnJlYXNvbhgC'
        'IAEoCUIIukgFcgMY9ANSBnJlYXNvbg==');

@$core.Deprecated('Use listRoomCreationReviewsRequestDescriptor instead')
const ListRoomCreationReviewsRequest$json = {
  '1': 'ListRoomCreationReviewsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.ReviewStatus',
      '8': {},
      '10': 'status'
    },
    {'1': 'requested_by', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'requestedBy'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'search'},
  ],
  '7': {},
};

/// Descriptor for `ListRoomCreationReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomCreationReviewsRequestDescriptor = $convert.base64Decode(
    'Ch5MaXN0Um9vbUNyZWF0aW9uUmV2aWV3c1JlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIbCg'
    'lwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXplEj0KBnN0YXR1cxgDIAEoDjIbLnN5bmN0di5jb21t'
    'b24uUmV2aWV3U3RhdHVzQgi6SAWCAQIQAVIGc3RhdHVzEkEKDHJlcXVlc3RlZF9ieRgEIAEoCU'
    'IeukgbchkYQDIVXiR8XnVzcl9bQS1aYS16MC05XSskUgtyZXF1ZXN0ZWRCeRIfCgZzZWFyY2gY'
    'BSABKAlCB7pIBHICGGRSBnNlYXJjaDqpArpIpQIadQolYWRtaW4ubGlzdF9yb29tX2NyZWF0aW'
    '9uX3Jldmlld3MucGFnZRIqcGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFz'
    'dCAxGiB0aGlzLnBhZ2UgPT0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqrAQoqYWRtaW4ubGlzdF9yb2'
    '9tX2NyZWF0aW9uX3Jldmlld3MucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2Ug'
    'ZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwgKH'
    'RoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKQ==');

@$core.Deprecated('Use listRoomCreationReviewsResponseDescriptor instead')
const ListRoomCreationReviewsResponse$json = {
  '1': 'ListRoomCreationReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.RoomCreationReview',
      '10': 'reviews'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomCreationReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomCreationReviewsResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0Um9vbUNyZWF0aW9uUmV2aWV3c1Jlc3BvbnNlEjoKB3Jldmlld3MYASADKAsyIC5zeW'
        '5jdHYuYWRtaW4uUm9vbUNyZWF0aW9uUmV2aWV3UgdyZXZpZXdzEhQKBXRvdGFsGAIgASgFUgV0'
        'b3RhbA==');

@$core.Deprecated('Use approveRoomCreationReviewRequestDescriptor instead')
const ApproveRoomCreationReviewRequest$json = {
  '1': 'ApproveRoomCreationReviewRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
  ],
};

/// Descriptor for `ApproveRoomCreationReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRoomCreationReviewRequestDescriptor =
    $convert.base64Decode(
        'CiBBcHByb3ZlUm9vbUNyZWF0aW9uUmV2aWV3UmVxdWVzdBI9CgpyZXF1ZXN0X2lkGAEgASgJQh'
        '66SBtyGRABGEAyE15yb29tX1tBLVphLXowLTldKyRSCXJlcXVlc3RJZA==');

@$core.Deprecated('Use approveRoomCreationReviewResponseDescriptor instead')
const ApproveRoomCreationReviewResponse$json = {
  '1': 'ApproveRoomCreationReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomCreationReview',
      '10': 'review'
    },
    {
      '1': 'room',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.Room',
      '10': 'room'
    },
  ],
};

/// Descriptor for `ApproveRoomCreationReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRoomCreationReviewResponseDescriptor =
    $convert.base64Decode(
        'CiFBcHByb3ZlUm9vbUNyZWF0aW9uUmV2aWV3UmVzcG9uc2USOAoGcmV2aWV3GAEgASgLMiAuc3'
        'luY3R2LmFkbWluLlJvb21DcmVhdGlvblJldmlld1IGcmV2aWV3EiYKBHJvb20YAiABKAsyEi5z'
        'eW5jdHYuYWRtaW4uUm9vbVIEcm9vbQ==');

@$core.Deprecated('Use rejectRoomCreationReviewRequestDescriptor instead')
const RejectRoomCreationReviewRequest$json = {
  '1': 'RejectRoomCreationReviewRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `RejectRoomCreationReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectRoomCreationReviewRequestDescriptor =
    $convert.base64Decode(
        'Ch9SZWplY3RSb29tQ3JlYXRpb25SZXZpZXdSZXF1ZXN0Ej0KCnJlcXVlc3RfaWQYASABKAlCHr'
        'pIG3IZEAEYQDITXnJvb21fW0EtWmEtejAtOV0rJFIJcmVxdWVzdElkEiAKBnJlYXNvbhgCIAEo'
        'CUIIukgFcgMY9ANSBnJlYXNvbg==');

@$core.Deprecated('Use listRoomJoinReviewsRequestDescriptor instead')
const ListRoomJoinReviewsRequest$json = {
  '1': 'ListRoomJoinReviewsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.ReviewStatus',
      '8': {},
      '10': 'status'
    },
    {'1': 'room_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
  '7': {},
};

/// Descriptor for `ListRoomJoinReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomJoinReviewsRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0Um9vbUpvaW5SZXZpZXdzUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhsKCXBhZ2'
    'Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSPQoGc3RhdHVzGAMgASgOMhsuc3luY3R2LmNvbW1vbi5S'
    'ZXZpZXdTdGF0dXNCCLpIBYIBAhABUgZzdGF0dXMSOAoHcm9vbV9pZBgEIAEoCUIfukgcchoYQD'
    'IWXiR8XnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlkEjcKB3VzZXJfaWQYBSABKAlCHrpIG3IZ'
    'GEAyFV4kfF51c3JfW0EtWmEtejAtOV0rJFIGdXNlcklkOqECukidAhpxCiFhZG1pbi5saXN0X3'
    'Jvb21fam9pbl9yZXZpZXdzLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3Ig'
    'YXQgbGVhc3QgMRogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEapwEKJmFkbWluLm'
    'xpc3Rfcm9vbV9qb2luX3Jldmlld3MucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1'
    'c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfH'
    'wgKHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKQ==');

@$core.Deprecated('Use listRoomJoinReviewsResponseDescriptor instead')
const ListRoomJoinReviewsResponse$json = {
  '1': 'ListRoomJoinReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.RoomJoinReview',
      '10': 'reviews'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomJoinReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomJoinReviewsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Um9vbUpvaW5SZXZpZXdzUmVzcG9uc2USNgoHcmV2aWV3cxgBIAMoCzIcLnN5bmN0di'
        '5hZG1pbi5Sb29tSm9pblJldmlld1IHcmV2aWV3cxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use approveRoomJoinReviewRequestDescriptor instead')
const ApproveRoomJoinReviewRequest$json = {
  '1': 'ApproveRoomJoinReviewRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
  ],
};

/// Descriptor for `ApproveRoomJoinReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRoomJoinReviewRequestDescriptor =
    $convert.base64Decode(
        'ChxBcHByb3ZlUm9vbUpvaW5SZXZpZXdSZXF1ZXN0EjwKCnJlcXVlc3RfaWQYASABKAlCHbpIGn'
        'IYEAEYQDISXnJldl9bQS1aYS16MC05XSskUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use approveRoomJoinReviewResponseDescriptor instead')
const ApproveRoomJoinReviewResponse$json = {
  '1': 'ApproveRoomJoinReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomJoinReview',
      '10': 'review'
    },
    {
      '1': 'member',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '10': 'member'
    },
  ],
};

/// Descriptor for `ApproveRoomJoinReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRoomJoinReviewResponseDescriptor =
    $convert.base64Decode(
        'Ch1BcHByb3ZlUm9vbUpvaW5SZXZpZXdSZXNwb25zZRI0CgZyZXZpZXcYASABKAsyHC5zeW5jdH'
        'YuYWRtaW4uUm9vbUpvaW5SZXZpZXdSBnJldmlldxIxCgZtZW1iZXIYAiABKAsyGS5zeW5jdHYu'
        'Y29tbW9uLlJvb21NZW1iZXJSBm1lbWJlcg==');

@$core.Deprecated('Use rejectRoomJoinReviewRequestDescriptor instead')
const RejectRoomJoinReviewRequest$json = {
  '1': 'RejectRoomJoinReviewRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `RejectRoomJoinReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectRoomJoinReviewRequestDescriptor =
    $convert.base64Decode(
        'ChtSZWplY3RSb29tSm9pblJldmlld1JlcXVlc3QSPAoKcmVxdWVzdF9pZBgBIAEoCUIdukgach'
        'gQARhAMhJecmV2X1tBLVphLXowLTldKyRSCXJlcXVlc3RJZBIgCgZyZWFzb24YAiABKAlCCLpI'
        'BXIDGPQDUgZyZWFzb24=');

@$core.Deprecated('Use listRoomsRequestDescriptor instead')
const ListRoomsRequest$json = {
  '1': 'ListRoomsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomStatus',
      '8': {},
      '10': 'status'
    },
    {'1': 'search', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {'1': 'creator_id', '3': 5, '4': 1, '5': 9, '10': 'creatorId'},
    {
      '1': 'is_banned',
      '3': 6,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isBanned',
      '17': true
    },
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.RoomListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
    {'1': 'category_id', '3': 9, '4': 1, '5': 9, '8': {}, '10': 'categoryId'},
    {'1': 'label_ids', '3': 10, '4': 3, '5': 9, '8': {}, '10': 'labelIds'},
  ],
  '7': {},
  '8': [
    {'1': '_is_banned'},
  ],
};

/// Descriptor for `ListRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Um9vbXNSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAIgAS'
    'gFUghwYWdlU2l6ZRI7CgZzdGF0dXMYAyABKA4yGS5zeW5jdHYuY29tbW9uLlJvb21TdGF0dXNC'
    'CLpIBYIBAhABUgZzdGF0dXMSHwoGc2VhcmNoGAQgASgJQge6SARyAhhkUgZzZWFyY2gSHQoKY3'
    'JlYXRvcl9pZBgFIAEoCVIJY3JlYXRvcklkEiAKCWlzX2Jhbm5lZBgGIAEoCEgAUghpc0Jhbm5l'
    'ZIgBARI/Cgdzb3J0X2J5GAcgASgOMhwuc3luY3R2LmFkbWluLlJvb21MaXN0U29ydEJ5Qgi6SA'
    'WCAQIQAVIGc29ydEJ5EkwKDnNvcnRfZGlyZWN0aW9uGAggASgOMhsuc3luY3R2LmFkbWluLlNv'
    'cnREaXJlY3Rpb25CCLpIBYIBAhABUg1zb3J0RGlyZWN0aW9uEkMKC2NhdGVnb3J5X2lkGAkgAS'
    'gJQiK6SB9yHRhAMhleJHxecm9vbWNhdF9bQS1aYS16MC05XSskUgpjYXRlZ29yeUlkEkUKCWxh'
    'YmVsX2lkcxgKIAMoCUIoukglkgEiEAoiHnIcEAEYQDIWXnJvb21sYmxfW0EtWmEtejAtOV0rJF'
    'IIbGFiZWxJZHM6wwO6SL8DGrcBChthZG1pbi5saXN0X3Jvb21zLmNyZWF0b3JfaWQSL2NyZWF0'
    'b3JfaWQgbXVzdCBiZSBlbXB0eSBvciBhIHB1YmxpYyBpZGVudGlmaWVyGmd0aGlzLmNyZWF0b3'
    'JfaWQgPT0gJycgfHwgKHNpemUodGhpcy5jcmVhdG9yX2lkKSA8PSA2NCAmJiB0aGlzLmNyZWF0'
    'b3JfaWQubWF0Y2hlcygnXnVzcl9bQS1aYS16MC05XSskJykpGmUKFWFkbWluLmxpc3Rfcm9vbX'
    'MucGFnZRIqcGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdCAxGiB0aGlz'
    'LnBhZ2UgPT0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqbAQoaYWRtaW4ubGlzdF9yb29tcy5wYWdlX3'
    'NpemUSNnBhZ2Vfc2l6ZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBiZXR3ZWVuIDEgYW5k'
    'IDEwMBpFdGhpcy5wYWdlX3NpemUgPT0gMCB8fCAodGhpcy5wYWdlX3NpemUgPj0gMSAmJiB0aG'
    'lzLnBhZ2Vfc2l6ZSA8PSAxMDApQgwKCl9pc19iYW5uZWQ=');

@$core.Deprecated('Use listRoomsResponseDescriptor instead')
const ListRoomsResponse$json = {
  '1': 'ListRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.Room',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Um9vbXNSZXNwb25zZRIoCgVyb29tcxgBIAMoCzISLnN5bmN0di5hZG1pbi5Sb29tUg'
    'Vyb29tcxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use listRoomCategoriesRequestDescriptor instead')
const ListRoomCategoriesRequest$json = {
  '1': 'ListRoomCategoriesRequest',
  '2': [
    {'1': 'include_disabled', '3': 1, '4': 1, '5': 8, '10': 'includeDisabled'},
  ],
};

/// Descriptor for `ListRoomCategoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomCategoriesRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0Um9vbUNhdGVnb3JpZXNSZXF1ZXN0EikKEGluY2x1ZGVfZGlzYWJsZWQYASABKAhSD2'
        'luY2x1ZGVEaXNhYmxlZA==');

@$core.Deprecated('Use listRoomCategoriesResponseDescriptor instead')
const ListRoomCategoriesResponse$json = {
  '1': 'ListRoomCategoriesResponse',
  '2': [
    {
      '1': 'categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomCategory',
      '10': 'categories'
    },
  ],
};

/// Descriptor for `ListRoomCategoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomCategoriesResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Um9vbUNhdGVnb3JpZXNSZXNwb25zZRI7CgpjYXRlZ29yaWVzGAEgAygLMhsuc3luY3'
        'R2LmNsaWVudC5Sb29tQ2F0ZWdvcnlSCmNhdGVnb3JpZXM=');

@$core.Deprecated('Use upsertRoomCategoryRequestDescriptor instead')
const UpsertRoomCategoryRequest$json = {
  '1': 'UpsertRoomCategoryRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'key'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'description'},
    {'1': 'sort_order', '3': 4, '4': 1, '5': 5, '10': 'sortOrder'},
    {
      '1': 'is_enabled',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isEnabled',
      '17': true
    },
  ],
  '8': [
    {'1': '_is_enabled'},
  ],
};

/// Descriptor for `UpsertRoomCategoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertRoomCategoryRequestDescriptor = $convert.base64Decode(
    'ChlVcHNlcnRSb29tQ2F0ZWdvcnlSZXF1ZXN0EhsKA2tleRgBIAEoCUIJukgGcgQQARhAUgNrZX'
    'kSHQoEbmFtZRgCIAEoCUIJukgGcgQQARhQUgRuYW1lEioKC2Rlc2NyaXB0aW9uGAMgASgJQgi6'
    'SAVyAxisAlILZGVzY3JpcHRpb24SHQoKc29ydF9vcmRlchgEIAEoBVIJc29ydE9yZGVyEiIKCm'
    'lzX2VuYWJsZWQYBSABKAhIAFIJaXNFbmFibGVkiAEBQg0KC19pc19lbmFibGVk');

@$core.Deprecated('Use deleteRoomCategoryRequestDescriptor instead')
const DeleteRoomCategoryRequest$json = {
  '1': 'DeleteRoomCategoryRequest',
  '2': [
    {'1': 'category_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'categoryId'},
  ],
};

/// Descriptor for `DeleteRoomCategoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomCategoryRequestDescriptor =
    $convert.base64Decode(
        'ChlEZWxldGVSb29tQ2F0ZWdvcnlSZXF1ZXN0EkIKC2NhdGVnb3J5X2lkGAEgASgJQiG6SB5yHB'
        'ABGEAyFl5yb29tY2F0X1tBLVphLXowLTldKyRSCmNhdGVnb3J5SWQ=');

@$core.Deprecated('Use deleteRoomCategoryResponseDescriptor instead')
const DeleteRoomCategoryResponse$json = {
  '1': 'DeleteRoomCategoryResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteRoomCategoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomCategoryResponseDescriptor =
    $convert.base64Decode(
        'ChpEZWxldGVSb29tQ2F0ZWdvcnlSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use listRoomLabelsRequestDescriptor instead')
const ListRoomLabelsRequest$json = {
  '1': 'ListRoomLabelsRequest',
  '2': [
    {'1': 'include_disabled', '3': 1, '4': 1, '5': 8, '10': 'includeDisabled'},
    {'1': 'category_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'categoryId'},
  ],
};

/// Descriptor for `ListRoomLabelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomLabelsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Um9vbUxhYmVsc1JlcXVlc3QSKQoQaW5jbHVkZV9kaXNhYmxlZBgBIAEoCFIPaW5jbH'
    'VkZURpc2FibGVkEkMKC2NhdGVnb3J5X2lkGAIgASgJQiK6SB9yHRhAMhleJHxecm9vbWNhdF9b'
    'QS1aYS16MC05XSskUgpjYXRlZ29yeUlk');

@$core.Deprecated('Use listRoomLabelsResponseDescriptor instead')
const ListRoomLabelsResponse$json = {
  '1': 'ListRoomLabelsResponse',
  '2': [
    {
      '1': 'labels',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomLabel',
      '10': 'labels'
    },
  ],
};

/// Descriptor for `ListRoomLabelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomLabelsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Um9vbUxhYmVsc1Jlc3BvbnNlEjAKBmxhYmVscxgBIAMoCzIYLnN5bmN0di5jbGllbn'
        'QuUm9vbUxhYmVsUgZsYWJlbHM=');

@$core.Deprecated('Use upsertRoomLabelRequestDescriptor instead')
const UpsertRoomLabelRequest$json = {
  '1': 'UpsertRoomLabelRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'key'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'description'},
    {'1': 'color', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'color'},
    {'1': 'category_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'categoryId'},
    {'1': 'sort_order', '3': 6, '4': 1, '5': 5, '10': 'sortOrder'},
    {
      '1': 'is_enabled',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isEnabled',
      '17': true
    },
  ],
  '8': [
    {'1': '_is_enabled'},
  ],
};

/// Descriptor for `UpsertRoomLabelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upsertRoomLabelRequestDescriptor = $convert.base64Decode(
    'ChZVcHNlcnRSb29tTGFiZWxSZXF1ZXN0EhsKA2tleRgBIAEoCUIJukgGcgQQARhAUgNrZXkSHQ'
    'oEbmFtZRgCIAEoCUIJukgGcgQQARhQUgRuYW1lEioKC2Rlc2NyaXB0aW9uGAMgASgJQgi6SAVy'
    'AxisAlILZGVzY3JpcHRpb24SHQoFY29sb3IYBCABKAlCB7pIBHICGAdSBWNvbG9yEkMKC2NhdG'
    'Vnb3J5X2lkGAUgASgJQiK6SB9yHRhAMhleJHxecm9vbWNhdF9bQS1aYS16MC05XSskUgpjYXRl'
    'Z29yeUlkEh0KCnNvcnRfb3JkZXIYBiABKAVSCXNvcnRPcmRlchIiCgppc19lbmFibGVkGAcgAS'
    'gISABSCWlzRW5hYmxlZIgBAUINCgtfaXNfZW5hYmxlZA==');

@$core.Deprecated('Use deleteRoomLabelRequestDescriptor instead')
const DeleteRoomLabelRequest$json = {
  '1': 'DeleteRoomLabelRequest',
  '2': [
    {'1': 'label_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'labelId'},
  ],
};

/// Descriptor for `DeleteRoomLabelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomLabelRequestDescriptor =
    $convert.base64Decode(
        'ChZEZWxldGVSb29tTGFiZWxSZXF1ZXN0EjwKCGxhYmVsX2lkGAEgASgJQiG6SB5yHBABGEAyFl'
        '5yb29tbGJsX1tBLVphLXowLTldKyRSB2xhYmVsSWQ=');

@$core.Deprecated('Use deleteRoomLabelResponseDescriptor instead')
const DeleteRoomLabelResponse$json = {
  '1': 'DeleteRoomLabelResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteRoomLabelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomLabelResponseDescriptor =
    $convert.base64Decode(
        'ChdEZWxldGVSb29tTGFiZWxSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use updateRoomTaxonomyRequestDescriptor instead')
const UpdateRoomTaxonomyRequest$json = {
  '1': 'UpdateRoomTaxonomyRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {
      '1': 'category_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'categoryId',
      '17': true
    },
    {'1': 'label_ids', '3': 3, '4': 3, '5': 9, '8': {}, '10': 'labelIds'},
    {'1': 'clear_category', '3': 4, '4': 1, '5': 8, '10': 'clearCategory'},
  ],
  '8': [
    {'1': '_category_id'},
  ],
};

/// Descriptor for `UpdateRoomTaxonomyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomTaxonomyRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVSb29tVGF4b25vbXlSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQD'
    'ITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlkEkUKC2NhdGVnb3J5X2lkGAIgASgJQh+6SBxy'
    'GhhAMhZecm9vbWNhdF9bQS1aYS16MC05XSskSABSCmNhdGVnb3J5SWSIAQESRQoJbGFiZWxfaW'
    'RzGAMgAygJQii6SCWSASIQCiIechwQARhAMhZecm9vbWxibF9bQS1aYS16MC05XSskUghsYWJl'
    'bElkcxIlCg5jbGVhcl9jYXRlZ29yeRgEIAEoCFINY2xlYXJDYXRlZ29yeUIOCgxfY2F0ZWdvcn'
    'lfaWQ=');

@$core.Deprecated('Use getRoomRequestDescriptor instead')
const GetRoomRequest$json = {
  '1': 'GetRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `GetRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRSb29tUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE15yb29tX1tBLV'
    'phLXowLTldKyRSBnJvb21JZA==');

@$core.Deprecated('Use roomPathRequestDescriptor instead')
const RoomPathRequest$json = {
  '1': 'RoomPathRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `RoomPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomPathRequestDescriptor = $convert.base64Decode(
    'Cg9Sb29tUGF0aFJlcXVlc3QSNwoHcm9vbV9pZBgBIAEoCUIeukgbchkQARhAMhNecm9vbV9bQS'
    '1aYS16MC05XSskUgZyb29tSWQ=');

@$core.Deprecated('Use getRoomSettingsRequestDescriptor instead')
const GetRoomSettingsRequest$json = {
  '1': 'GetRoomSettingsRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `GetRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomSettingsRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRSb29tU2V0dGluZ3NSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQDITXn'
        'Jvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlk');

@$core.Deprecated('Use getRoomSettingsResponseDescriptor instead')
const GetRoomSettingsResponse$json = {
  '1': 'GetRoomSettingsResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomSettings',
      '10': 'settings'
    },
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `GetRoomSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomSettingsResponseDescriptor = $convert.base64Decode(
    'ChdHZXRSb29tU2V0dGluZ3NSZXNwb25zZRI3CghzZXR0aW5ncxgBIAEoCzIbLnN5bmN0di5jbG'
    'llbnQuUm9vbVNldHRpbmdzUghzZXR0aW5ncxIYCgd2ZXJzaW9uGAIgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use updateRoomSettingsRequestDescriptor instead')
const UpdateRoomSettingsRequest$json = {
  '1': 'UpdateRoomSettingsRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {
      '1': 'settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomSettingsPatch',
      '8': {},
      '10': 'settings'
    },
    {
      '1': 'update_mask',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.FieldMask',
      '8': {},
      '10': 'updateMask'
    },
  ],
};

/// Descriptor for `UpdateRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomSettingsRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVSb29tU2V0dGluZ3NSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQD'
    'ITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlkEkQKCHNldHRpbmdzGAIgASgLMiAuc3luY3R2'
    'LmNsaWVudC5Sb29tU2V0dGluZ3NQYXRjaEIGukgDyAEBUghzZXR0aW5ncxJDCgt1cGRhdGVfbW'
    'FzaxgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5GaWVsZE1hc2tCBrpIA8gBAVIKdXBkYXRlTWFz'
    'aw==');

@$core.Deprecated('Use resetRoomSettingsRequestDescriptor instead')
const ResetRoomSettingsRequest$json = {
  '1': 'ResetRoomSettingsRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `ResetRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetRoomSettingsRequestDescriptor =
    $convert.base64Decode(
        'ChhSZXNldFJvb21TZXR0aW5nc1JlcXVlc3QSNwoHcm9vbV9pZBgBIAEoCUIeukgbchkQARhAMh'
        'Necm9vbV9bQS1aYS16MC05XSskUgZyb29tSWQ=');

@$core.Deprecated('Use updateRoomPasswordRequestDescriptor instead')
const UpdateRoomPasswordRequest$json = {
  '1': 'UpdateRoomPasswordRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'new_password', '3': 2, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `UpdateRoomPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomPasswordRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVSb29tUGFzc3dvcmRSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQD'
    'ITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlkEiEKDG5ld19wYXNzd29yZBgCIAEoCVILbmV3'
    'UGFzc3dvcmQ=');

@$core.Deprecated('Use updateRoomPasswordResponseDescriptor instead')
const UpdateRoomPasswordResponse$json = {
  '1': 'UpdateRoomPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UpdateRoomPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomPasswordResponseDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVSb29tUGFzc3dvcmRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use deleteRoomRequestDescriptor instead')
const DeleteRoomRequest$json = {
  '1': 'DeleteRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `DeleteRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVSb29tUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE15yb29tX1'
    'tBLVphLXowLTldKyRSBnJvb21JZA==');

@$core.Deprecated('Use deleteRoomResponseDescriptor instead')
const DeleteRoomResponse$json = {
  '1': 'DeleteRoomResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomResponseDescriptor =
    $convert.base64Decode(
        'ChJEZWxldGVSb29tUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use banRoomRequestDescriptor instead')
const BanRoomRequest$json = {
  '1': 'BanRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BanRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banRoomRequestDescriptor = $convert.base64Decode(
    'Cg5CYW5Sb29tUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE15yb29tX1tBLV'
    'phLXowLTldKyRSBnJvb21JZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use unbanRoomRequestDescriptor instead')
const UnbanRoomRequest$json = {
  '1': 'UnbanRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `UnbanRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbanRoomRequestDescriptor = $convert.base64Decode(
    'ChBVbmJhblJvb21SZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQDITXnJvb21fW0'
    'EtWmEtejAtOV0rJFIGcm9vbUlk');

@$core.Deprecated('Use getRoomMembersRequestDescriptor instead')
const GetRoomMembersRequest$json = {
  '1': 'GetRoomMembersRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'role',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '8': {},
      '10': 'role'
    },
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.RoomMemberListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
};

/// Descriptor for `GetRoomMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersRequestDescriptor = $convert.base64Decode(
    'ChVHZXRSb29tTWVtYmVyc1JlcXVlc3QSNwoHcm9vbV9pZBgBIAEoCUIeukgbchkQARhAMhNecm'
    '9vbV9bQS1aYS16MC05XSskUgZyb29tSWQSEgoEcGFnZRgCIAEoBVIEcGFnZRIbCglwYWdlX3Np'
    'emUYAyABKAVSCHBhZ2VTaXplEh8KBnNlYXJjaBgEIAEoCUIHukgEcgIYZFIGc2VhcmNoEjsKBH'
    'JvbGUYBSABKA4yHS5zeW5jdHYuY29tbW9uLlJvb21NZW1iZXJSb2xlQgi6SAWCAQIQAVIEcm9s'
    'ZRJFCgdzb3J0X2J5GAcgASgOMiIuc3luY3R2LmFkbWluLlJvb21NZW1iZXJMaXN0U29ydEJ5Qg'
    'i6SAWCAQIQAVIGc29ydEJ5EkwKDnNvcnRfZGlyZWN0aW9uGAggASgOMhsuc3luY3R2LmFkbWlu'
    'LlNvcnREaXJlY3Rpb25CCLpIBYIBAhABUg1zb3J0RGlyZWN0aW9uOpUCukiRAhprChthZG1pbi'
    '5nZXRfcm9vbV9tZW1iZXJzLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3Ig'
    'YXQgbGVhc3QgMRogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEaoQEKIGFkbWluLm'
    'dldF9yb29tX21lbWJlcnMucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZGVm'
    'YXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwgKHRoaX'
    'MucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKQ==');

@$core.Deprecated('Use getRoomMembersResponseDescriptor instead')
const GetRoomMembersResponse$json = {
  '1': 'GetRoomMembersResponse',
  '2': [
    {
      '1': 'members',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '10': 'members'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
    {
      '1': 'presence',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomPresenceStats',
      '10': 'presence'
    },
  ],
};

/// Descriptor for `GetRoomMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersResponseDescriptor = $convert.base64Decode(
    'ChZHZXRSb29tTWVtYmVyc1Jlc3BvbnNlEjMKB21lbWJlcnMYASADKAsyGS5zeW5jdHYuY29tbW'
    '9uLlJvb21NZW1iZXJSB21lbWJlcnMSFAoFdG90YWwYAiABKAVSBXRvdGFsEjwKCHByZXNlbmNl'
    'GAMgASgLMiAuc3luY3R2LmNvbW1vbi5Sb29tUHJlc2VuY2VTdGF0c1IIcHJlc2VuY2U=');

@$core.Deprecated('Use addMemberRequestDescriptor instead')
const AddMemberRequest$json = {
  '1': 'AddMemberRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {'1': 'notify', '3': 4, '4': 1, '5': 8, '10': 'notify'},
    {'1': 'remark_name', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'remarkName'},
    {'1': 'display_tag', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'displayTag'},
  ],
};

/// Descriptor for `AddMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMemberRequestDescriptor = $convert.base64Decode(
    'ChBBZGRNZW1iZXJSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQDITXnJvb21fW0'
    'EtWmEtejAtOV0rJFIGcm9vbUlkEjYKB3VzZXJfaWQYAiABKAlCHbpIGnIYEAEYQDISXnVzcl9b'
    'QS1aYS16MC05XSskUgZ1c2VySWQSMQoEcm9sZRgDIAEoDjIdLnN5bmN0di5jb21tb24uUm9vbU'
    '1lbWJlclJvbGVSBHJvbGUSFgoGbm90aWZ5GAQgASgIUgZub3RpZnkSKAoLcmVtYXJrX25hbWUY'
    'BSABKAlCB7pIBHICGEBSCnJlbWFya05hbWUSKAoLZGlzcGxheV90YWcYBiABKAlCB7pIBHICGB'
    'BSCmRpc3BsYXlUYWc=');

@$core.Deprecated('Use updateMemberRemarkNameRequestDescriptor instead')
const UpdateMemberRemarkNameRequest$json = {
  '1': 'UpdateMemberRemarkNameRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'remark_name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'remarkName'},
  ],
};

/// Descriptor for `UpdateMemberRemarkNameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberRemarkNameRequestDescriptor = $convert.base64Decode(
    'Ch1VcGRhdGVNZW1iZXJSZW1hcmtOYW1lUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGR'
    'ABGEAyE15yb29tX1tBLVphLXowLTldKyRSBnJvb21JZBI2Cgd1c2VyX2lkGAIgASgJQh26SBpy'
    'GBABGEAyEl51c3JfW0EtWmEtejAtOV0rJFIGdXNlcklkEigKC3JlbWFya19uYW1lGAMgASgJQg'
    'e6SARyAhhAUgpyZW1hcmtOYW1l');

@$core.Deprecated('Use updateMemberDisplayTagRequestDescriptor instead')
const UpdateMemberDisplayTagRequest$json = {
  '1': 'UpdateMemberDisplayTagRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'display_tag', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'displayTag'},
  ],
};

/// Descriptor for `UpdateMemberDisplayTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberDisplayTagRequestDescriptor = $convert.base64Decode(
    'Ch1VcGRhdGVNZW1iZXJEaXNwbGF5VGFnUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGR'
    'ABGEAyE15yb29tX1tBLVphLXowLTldKyRSBnJvb21JZBI2Cgd1c2VyX2lkGAIgASgJQh26SBpy'
    'GBABGEAyEl51c3JfW0EtWmEtejAtOV0rJFIGdXNlcklkEigKC2Rpc3BsYXlfdGFnGAMgASgJQg'
    'e6SARyAhgQUgpkaXNwbGF5VGFn');

@$core.Deprecated('Use updateMemberPermissionsRequestDescriptor instead')
const UpdateMemberPermissionsRequest$json = {
  '1': 'UpdateMemberPermissionsRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {
      '1': 'added_permissions',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'addedPermissions'
    },
    {
      '1': 'removed_permissions',
      '3': 5,
      '4': 1,
      '5': 4,
      '10': 'removedPermissions'
    },
    {
      '1': 'admin_added_permissions',
      '3': 6,
      '4': 1,
      '5': 4,
      '10': 'adminAddedPermissions'
    },
    {
      '1': 'admin_removed_permissions',
      '3': 7,
      '4': 1,
      '5': 4,
      '10': 'adminRemovedPermissions'
    },
  ],
};

/// Descriptor for `UpdateMemberPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberPermissionsRequestDescriptor = $convert.base64Decode(
    'Ch5VcGRhdGVNZW1iZXJQZXJtaXNzaW9uc1JlcXVlc3QSNwoHcm9vbV9pZBgBIAEoCUIeukgbch'
    'kQARhAMhNecm9vbV9bQS1aYS16MC05XSskUgZyb29tSWQSNgoHdXNlcl9pZBgCIAEoCUIdukga'
    'chgQARhAMhJedXNyX1tBLVphLXowLTldKyRSBnVzZXJJZBIxCgRyb2xlGAMgASgOMh0uc3luY3'
    'R2LmNvbW1vbi5Sb29tTWVtYmVyUm9sZVIEcm9sZRIrChFhZGRlZF9wZXJtaXNzaW9ucxgEIAEo'
    'BFIQYWRkZWRQZXJtaXNzaW9ucxIvChNyZW1vdmVkX3Blcm1pc3Npb25zGAUgASgEUhJyZW1vdm'
    'VkUGVybWlzc2lvbnMSNgoXYWRtaW5fYWRkZWRfcGVybWlzc2lvbnMYBiABKARSFWFkbWluQWRk'
    'ZWRQZXJtaXNzaW9ucxI6ChlhZG1pbl9yZW1vdmVkX3Blcm1pc3Npb25zGAcgASgEUhdhZG1pbl'
    'JlbW92ZWRQZXJtaXNzaW9ucw==');

@$core.Deprecated('Use kickMemberRequestDescriptor instead')
const KickMemberRequest$json = {
  '1': 'KickMemberRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'kick_cooldown_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'kickCooldownSeconds'
    },
  ],
};

/// Descriptor for `KickMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickMemberRequestDescriptor = $convert.base64Decode(
    'ChFLaWNrTWVtYmVyUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE15yb29tX1'
    'tBLVphLXowLTldKyRSBnJvb21JZBI2Cgd1c2VyX2lkGAIgASgJQh26SBpyGBABGEAyEl51c3Jf'
    'W0EtWmEtejAtOV0rJFIGdXNlcklkEkAKFWtpY2tfY29vbGRvd25fc2Vjb25kcxgDIAEoA0IMuk'
    'gJIgcYgJqeASgBUhNraWNrQ29vbGRvd25TZWNvbmRz');

@$core.Deprecated('Use kickMemberResponseDescriptor instead')
const KickMemberResponse$json = {
  '1': 'KickMemberResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `KickMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickMemberResponseDescriptor =
    $convert.base64Decode(
        'ChJLaWNrTWVtYmVyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use addAdminRequestDescriptor instead')
const AddAdminRequest$json = {
  '1': 'AddAdminRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `AddAdminRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAdminRequestDescriptor = $convert.base64Decode(
    'Cg9BZGRBZG1pblJlcXVlc3QSNgoHdXNlcl9pZBgBIAEoCUIdukgachgQARhAMhJedXNyX1tBLV'
    'phLXowLTldKyRSBnVzZXJJZA==');

@$core.Deprecated('Use removeAdminRequestDescriptor instead')
const RemoveAdminRequest$json = {
  '1': 'RemoveAdminRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `RemoveAdminRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeAdminRequestDescriptor = $convert.base64Decode(
    'ChJSZW1vdmVBZG1pblJlcXVlc3QSNgoHdXNlcl9pZBgBIAEoCUIdukgachgQARhAMhJedXNyX1'
    'tBLVphLXowLTldKyRSBnVzZXJJZA==');

@$core.Deprecated('Use removeAdminResponseDescriptor instead')
const RemoveAdminResponse$json = {
  '1': 'RemoveAdminResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RemoveAdminResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeAdminResponseDescriptor =
    $convert.base64Decode(
        'ChNSZW1vdmVBZG1pblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use listAdminsRequestDescriptor instead')
const ListAdminsRequest$json = {
  '1': 'ListAdminsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'sort_by',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.UserListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
};

/// Descriptor for `ListAdminsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAdminsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QWRtaW5zUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhsKCXBhZ2Vfc2l6ZRgCIA'
    'EoBVIIcGFnZVNpemUSHwoGc2VhcmNoGAMgASgJQge6SARyAhhkUgZzZWFyY2gSPwoHc29ydF9i'
    'eRgEIAEoDjIcLnN5bmN0di5hZG1pbi5Vc2VyTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRCeR'
    'JMCg5zb3J0X2RpcmVjdGlvbhgFIAEoDjIbLnN5bmN0di5hZG1pbi5Tb3J0RGlyZWN0aW9uQgi6'
    'SAWCAQIQAVINc29ydERpcmVjdGlvbjqLArpIhwIaZgoWYWRtaW4ubGlzdF9hZG1pbnMucGFnZR'
    'IqcGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdCAxGiB0aGlzLnBhZ2Ug'
    'PT0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqcAQobYWRtaW4ubGlzdF9hZG1pbnMucGFnZV9zaXplEj'
    'ZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAa'
    'RXRoaXMucGFnZV9zaXplID09IDAgfHwgKHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYW'
    'dlX3NpemUgPD0gMTAwKQ==');

@$core.Deprecated('Use listAdminsResponseDescriptor instead')
const ListAdminsResponse$json = {
  '1': 'ListAdminsResponse',
  '2': [
    {
      '1': 'admins',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'admins'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListAdminsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAdminsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWRtaW5zUmVzcG9uc2USLwoGYWRtaW5zGAEgAygLMhcuc3luY3R2LmFkbWluLkFkbW'
    'luVXNlclIGYWRtaW5zEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

@$core.Deprecated('Use getServiceStateRequestDescriptor instead')
const GetServiceStateRequest$json = {
  '1': 'GetServiceStateRequest',
};

/// Descriptor for `GetServiceStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServiceStateRequestDescriptor =
    $convert.base64Decode('ChZHZXRTZXJ2aWNlU3RhdGVSZXF1ZXN0');

@$core.Deprecated('Use getServiceStateResponseDescriptor instead')
const GetServiceStateResponse$json = {
  '1': 'GetServiceStateResponse',
  '2': [
    {'1': 'total_users', '3': 1, '4': 1, '5': 3, '10': 'totalUsers'},
    {'1': 'active_users', '3': 2, '4': 1, '5': 3, '10': 'activeUsers'},
    {'1': 'banned_users', '3': 3, '4': 1, '5': 3, '10': 'bannedUsers'},
    {'1': 'total_rooms', '3': 4, '4': 1, '5': 3, '10': 'totalRooms'},
    {'1': 'active_rooms', '3': 5, '4': 1, '5': 3, '10': 'activeRooms'},
    {'1': 'banned_rooms', '3': 6, '4': 1, '5': 3, '10': 'bannedRooms'},
    {'1': 'total_media', '3': 7, '4': 1, '5': 3, '10': 'totalMedia'},
    {
      '1': 'provider_instances',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'providerInstances'
    },
    {
      '1': 'additional_state',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.ServiceAdditionalState',
      '10': 'additionalState'
    },
    {
      '1': 'presence',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.PresenceOverview',
      '10': 'presence'
    },
  ],
};

/// Descriptor for `GetServiceStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServiceStateResponseDescriptor = $convert.base64Decode(
    'ChdHZXRTZXJ2aWNlU3RhdGVSZXNwb25zZRIfCgt0b3RhbF91c2VycxgBIAEoA1IKdG90YWxVc2'
    'VycxIhCgxhY3RpdmVfdXNlcnMYAiABKANSC2FjdGl2ZVVzZXJzEiEKDGJhbm5lZF91c2VycxgD'
    'IAEoA1ILYmFubmVkVXNlcnMSHwoLdG90YWxfcm9vbXMYBCABKANSCnRvdGFsUm9vbXMSIQoMYW'
    'N0aXZlX3Jvb21zGAUgASgDUgthY3RpdmVSb29tcxIhCgxiYW5uZWRfcm9vbXMYBiABKANSC2Jh'
    'bm5lZFJvb21zEh8KC3RvdGFsX21lZGlhGAcgASgDUgp0b3RhbE1lZGlhEi0KEnByb3ZpZGVyX2'
    'luc3RhbmNlcxgIIAEoA1IRcHJvdmlkZXJJbnN0YW5jZXMSTwoQYWRkaXRpb25hbF9zdGF0ZRgJ'
    'IAEoCzIkLnN5bmN0di5hZG1pbi5TZXJ2aWNlQWRkaXRpb25hbFN0YXRlUg9hZGRpdGlvbmFsU3'
    'RhdGUSOwoIcHJlc2VuY2UYCiABKAsyHy5zeW5jdHYuY29tbW9uLlByZXNlbmNlT3ZlcnZpZXdS'
    'CHByZXNlbmNl');

@$core.Deprecated('Use serviceAdditionalStateDescriptor instead')
const ServiceAdditionalState$json = {
  '1': 'ServiceAdditionalState',
  '2': [
    {'1': 'active_streams', '3': 1, '4': 1, '5': 3, '10': 'activeStreams'},
    {'1': 'open_reports', '3': 2, '4': 1, '5': 3, '10': 'openReports'},
  ],
};

/// Descriptor for `ServiceAdditionalState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceAdditionalStateDescriptor =
    $convert.base64Decode(
        'ChZTZXJ2aWNlQWRkaXRpb25hbFN0YXRlEiUKDmFjdGl2ZV9zdHJlYW1zGAEgASgDUg1hY3Rpdm'
        'VTdHJlYW1zEiEKDG9wZW5fcmVwb3J0cxgCIAEoA1ILb3BlblJlcG9ydHM=');

@$core.Deprecated('Use listActiveStreamsRequestDescriptor instead')
const ListActiveStreamsRequest$json = {
  '1': 'ListActiveStreamsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'room_id', '3': 3, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'node_id', '3': 5, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'search', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ActiveStreamListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
};

/// Descriptor for `ListActiveStreamsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listActiveStreamsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0QWN0aXZlU3RyZWFtc1JlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIbCglwYWdlX3'
    'NpemUYAiABKAVSCHBhZ2VTaXplEhcKB3Jvb21faWQYAyABKAlSBnJvb21JZBIXCgd1c2VyX2lk'
    'GAQgASgJUgZ1c2VySWQSFwoHbm9kZV9pZBgFIAEoCVIGbm9kZUlkEh8KBnNlYXJjaBgGIAEoCU'
    'IHukgEcgIYZFIGc2VhcmNoEkcKB3NvcnRfYnkYByABKA4yJC5zeW5jdHYuYWRtaW4uQWN0aXZl'
    'U3RyZWFtTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRCeRJMCg5zb3J0X2RpcmVjdGlvbhgIIA'
    'EoDjIbLnN5bmN0di5hZG1pbi5Tb3J0RGlyZWN0aW9uQgi6SAWCAQIQAVINc29ydERpcmVjdGlv'
    'bjqEBbpIgAUasgEKIWFkbWluLmxpc3RfYWN0aXZlX3N0cmVhbXMucm9vbV9pZBIscm9vbV9pZC'
    'BtdXN0IGJlIGVtcHR5IG9yIGEgcHVibGljIGlkZW50aWZpZXIaX3RoaXMucm9vbV9pZCA9PSAn'
    'JyB8fCAoc2l6ZSh0aGlzLnJvb21faWQpIDw9IDY0ICYmIHRoaXMucm9vbV9pZC5tYXRjaGVzKC'
    'decm9vbV9bQS1aYS16MC05XSskJykpGrEBCiFhZG1pbi5saXN0X2FjdGl2ZV9zdHJlYW1zLnVz'
    'ZXJfaWQSLHVzZXJfaWQgbXVzdCBiZSBlbXB0eSBvciBhIHB1YmxpYyBpZGVudGlmaWVyGl50aG'
    'lzLnVzZXJfaWQgPT0gJycgfHwgKHNpemUodGhpcy51c2VyX2lkKSA8PSA2NCAmJiB0aGlzLnVz'
    'ZXJfaWQubWF0Y2hlcygnXnVzcl9bQS1aYS16MC05XSskJykpGm4KHmFkbWluLmxpc3RfYWN0aX'
    'ZlX3N0cmVhbXMucGFnZRIqcGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFz'
    'dCAxGiB0aGlzLnBhZ2UgPT0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqkAQojYWRtaW4ubGlzdF9hY3'
    'RpdmVfc3RyZWFtcy5wYWdlX3NpemUSNnBhZ2Vfc2l6ZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0'
    'KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBpFdGhpcy5wYWdlX3NpemUgPT0gMCB8fCAodGhpcy5wYW'
    'dlX3NpemUgPj0gMSAmJiB0aGlzLnBhZ2Vfc2l6ZSA8PSAxMDAp');

@$core.Deprecated('Use activeStreamInfoDescriptor instead')
const ActiveStreamInfo$json = {
  '1': 'ActiveStreamInfo',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'node_id', '3': 4, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'started_at', '3': 5, '4': 1, '5': 3, '10': 'startedAt'},
  ],
};

/// Descriptor for `ActiveStreamInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activeStreamInfoDescriptor = $convert.base64Decode(
    'ChBBY3RpdmVTdHJlYW1JbmZvEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIZCghtZWRpYV9pZB'
    'gCIAEoCVIHbWVkaWFJZBIXCgd1c2VyX2lkGAMgASgJUgZ1c2VySWQSFwoHbm9kZV9pZBgEIAEo'
    'CVIGbm9kZUlkEh0KCnN0YXJ0ZWRfYXQYBSABKANSCXN0YXJ0ZWRBdA==');

@$core.Deprecated('Use listActiveStreamsResponseDescriptor instead')
const ListActiveStreamsResponse$json = {
  '1': 'ListActiveStreamsResponse',
  '2': [
    {
      '1': 'streams',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.ActiveStreamInfo',
      '10': 'streams'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListActiveStreamsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listActiveStreamsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0QWN0aXZlU3RyZWFtc1Jlc3BvbnNlEjgKB3N0cmVhbXMYASADKAsyHi5zeW5jdHYuYW'
        'RtaW4uQWN0aXZlU3RyZWFtSW5mb1IHc3RyZWFtcxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use kickStreamRequestDescriptor instead')
const KickStreamRequest$json = {
  '1': 'KickStreamRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `KickStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickStreamRequestDescriptor = $convert.base64Decode(
    'ChFLaWNrU3RyZWFtUmVxdWVzdBIzCgdyb29tX2lkGAEgASgJQhq6SBdyFTITXnJvb21fW0EtWm'
    'EtejAtOV0rJFIGcm9vbUlkEjQKCG1lZGlhX2lkGAIgASgJQhm6SBZyFDISXm1lZF9bQS1aYS16'
    'MC05XSskUgdtZWRpYUlkEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use kickStreamResponseDescriptor instead')
const KickStreamResponse$json = {
  '1': 'KickStreamResponse',
};

/// Descriptor for `KickStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickStreamResponseDescriptor =
    $convert.base64Decode('ChJLaWNrU3RyZWFtUmVzcG9uc2U=');

@$core.Deprecated('Use getSliceCacheStatsRequestDescriptor instead')
const GetSliceCacheStatsRequest$json = {
  '1': 'GetSliceCacheStatsRequest',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'nodeId'},
    {'1': 'all_nodes', '3': 2, '4': 1, '5': 8, '10': 'allNodes'},
  ],
  '7': {},
};

/// Descriptor for `GetSliceCacheStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSliceCacheStatsRequestDescriptor = $convert.base64Decode(
    'ChlHZXRTbGljZUNhY2hlU3RhdHNSZXF1ZXN0EiEKB25vZGVfaWQYASABKAlCCLpIBXIDGIABUg'
    'Zub2RlSWQSGwoJYWxsX25vZGVzGAIgASgIUghhbGxOb2RlczqAAbpIfRp7CiJhZG1pbi5nZXRf'
    'c2xpY2VfY2FjaGVfc3RhdHMudGFyZ2V0Eixub2RlX2lkIGFuZCBhbGxfbm9kZXMgYXJlIG11dH'
    'VhbGx5IGV4Y2x1c2l2ZRonISh0aGlzLmFsbF9ub2RlcyAmJiB0aGlzLm5vZGVfaWQgIT0gJycp');

@$core.Deprecated('Use purgeSliceCacheRequestDescriptor instead')
const PurgeSliceCacheRequest$json = {
  '1': 'PurgeSliceCacheRequest',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'nodeId'},
    {'1': 'all_nodes', '3': 2, '4': 1, '5': 8, '10': 'allNodes'},
  ],
  '7': {},
};

/// Descriptor for `PurgeSliceCacheRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purgeSliceCacheRequestDescriptor = $convert.base64Decode(
    'ChZQdXJnZVNsaWNlQ2FjaGVSZXF1ZXN0EiEKB25vZGVfaWQYASABKAlCCLpIBXIDGIABUgZub2'
    'RlSWQSGwoJYWxsX25vZGVzGAIgASgIUghhbGxOb2Rlczp8ukh5GncKHmFkbWluLnB1cmdlX3Ns'
    'aWNlX2NhY2hlLnRhcmdldBIsbm9kZV9pZCBhbmQgYWxsX25vZGVzIGFyZSBtdXR1YWxseSBleG'
    'NsdXNpdmUaJyEodGhpcy5hbGxfbm9kZXMgJiYgdGhpcy5ub2RlX2lkICE9ICcnKQ==');

@$core.Deprecated('Use evictExpiredSliceCacheRequestDescriptor instead')
const EvictExpiredSliceCacheRequest$json = {
  '1': 'EvictExpiredSliceCacheRequest',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'nodeId'},
    {'1': 'all_nodes', '3': 2, '4': 1, '5': 8, '10': 'allNodes'},
  ],
  '7': {},
};

/// Descriptor for `EvictExpiredSliceCacheRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evictExpiredSliceCacheRequestDescriptor = $convert.base64Decode(
    'Ch1FdmljdEV4cGlyZWRTbGljZUNhY2hlUmVxdWVzdBIhCgdub2RlX2lkGAEgASgJQgi6SAVyAx'
    'iAAVIGbm9kZUlkEhsKCWFsbF9ub2RlcxgCIAEoCFIIYWxsTm9kZXM6hQG6SIEBGn8KJmFkbWlu'
    'LmV2aWN0X2V4cGlyZWRfc2xpY2VfY2FjaGUudGFyZ2V0Eixub2RlX2lkIGFuZCBhbGxfbm9kZX'
    'MgYXJlIG11dHVhbGx5IGV4Y2x1c2l2ZRonISh0aGlzLmFsbF9ub2RlcyAmJiB0aGlzLm5vZGVf'
    'aWQgIT0gJycp');

@$core.Deprecated('Use sliceCacheConfigInfoDescriptor instead')
const SliceCacheConfigInfo$json = {
  '1': 'SliceCacheConfigInfo',
  '2': [
    {'1': 'engine_enabled', '3': 1, '4': 1, '5': 8, '10': 'engineEnabled'},
    {'1': 'backend', '3': 2, '4': 1, '5': 9, '10': 'backend'},
    {'1': 'file_cache_dir', '3': 3, '4': 1, '5': 9, '10': 'fileCacheDir'},
    {'1': 'slice_size', '3': 4, '4': 1, '5': 4, '10': 'sliceSize'},
    {'1': 'max_cache_size', '3': 5, '4': 1, '5': 4, '10': 'maxCacheSize'},
    {'1': 'segment_ttl_secs', '3': 6, '4': 1, '5': 4, '10': 'segmentTtlSecs'},
    {
      '1': 'stale_max_age_secs',
      '3': 7,
      '4': 1,
      '5': 4,
      '10': 'staleMaxAgeSecs'
    },
    {
      '1': 'stale_while_revalidate',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'staleWhileRevalidate'
    },
    {
      '1': 'eviction_interval_secs',
      '3': 9,
      '4': 1,
      '5': 4,
      '10': 'evictionIntervalSecs'
    },
    {'1': 'watermark_ratio', '3': 10, '4': 1, '5': 1, '10': 'watermarkRatio'},
  ],
};

/// Descriptor for `SliceCacheConfigInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sliceCacheConfigInfoDescriptor = $convert.base64Decode(
    'ChRTbGljZUNhY2hlQ29uZmlnSW5mbxIlCg5lbmdpbmVfZW5hYmxlZBgBIAEoCFINZW5naW5lRW'
    '5hYmxlZBIYCgdiYWNrZW5kGAIgASgJUgdiYWNrZW5kEiQKDmZpbGVfY2FjaGVfZGlyGAMgASgJ'
    'UgxmaWxlQ2FjaGVEaXISHQoKc2xpY2Vfc2l6ZRgEIAEoBFIJc2xpY2VTaXplEiQKDm1heF9jYW'
    'NoZV9zaXplGAUgASgEUgxtYXhDYWNoZVNpemUSKAoQc2VnbWVudF90dGxfc2VjcxgGIAEoBFIO'
    'c2VnbWVudFR0bFNlY3MSKwoSc3RhbGVfbWF4X2FnZV9zZWNzGAcgASgEUg9zdGFsZU1heEFnZV'
    'NlY3MSNAoWc3RhbGVfd2hpbGVfcmV2YWxpZGF0ZRgIIAEoCFIUc3RhbGVXaGlsZVJldmFsaWRh'
    'dGUSNAoWZXZpY3Rpb25faW50ZXJ2YWxfc2VjcxgJIAEoBFIUZXZpY3Rpb25JbnRlcnZhbFNlY3'
    'MSJwoPd2F0ZXJtYXJrX3JhdGlvGAogASgBUg53YXRlcm1hcmtSYXRpbw==');

@$core.Deprecated('Use sliceCacheStatsNodeDescriptor instead')
const SliceCacheStatsNode$json = {
  '1': 'SliceCacheStatsNode',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {
      '1': 'config',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SliceCacheConfigInfo',
      '10': 'config'
    },
    {
      '1': 'current_size_bytes',
      '3': 3,
      '4': 1,
      '5': 4,
      '10': 'currentSizeBytes'
    },
    {'1': 'entry_count', '3': 4, '4': 1, '5': 4, '10': 'entryCount'},
    {'1': 'metadata_entries', '3': 5, '4': 1, '5': 4, '10': 'metadataEntries'},
    {'1': 'updating_entries', '3': 6, '4': 1, '5': 4, '10': 'updatingEntries'},
    {'1': 'lock_count', '3': 7, '4': 1, '5': 4, '10': 'lockCount'},
    {'1': 'usage_ratio', '3': 8, '4': 1, '5': 1, '10': 'usageRatio'},
  ],
};

/// Descriptor for `SliceCacheStatsNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sliceCacheStatsNodeDescriptor = $convert.base64Decode(
    'ChNTbGljZUNhY2hlU3RhdHNOb2RlEhcKB25vZGVfaWQYASABKAlSBm5vZGVJZBI6CgZjb25maW'
    'cYAiABKAsyIi5zeW5jdHYuYWRtaW4uU2xpY2VDYWNoZUNvbmZpZ0luZm9SBmNvbmZpZxIsChJj'
    'dXJyZW50X3NpemVfYnl0ZXMYAyABKARSEGN1cnJlbnRTaXplQnl0ZXMSHwoLZW50cnlfY291bn'
    'QYBCABKARSCmVudHJ5Q291bnQSKQoQbWV0YWRhdGFfZW50cmllcxgFIAEoBFIPbWV0YWRhdGFF'
    'bnRyaWVzEikKEHVwZGF0aW5nX2VudHJpZXMYBiABKARSD3VwZGF0aW5nRW50cmllcxIdCgpsb2'
    'NrX2NvdW50GAcgASgEUglsb2NrQ291bnQSHwoLdXNhZ2VfcmF0aW8YCCABKAFSCnVzYWdlUmF0'
    'aW8=');

@$core.Deprecated('Use sliceCacheNodeFailureDescriptor instead')
const SliceCacheNodeFailure$json = {
  '1': 'SliceCacheNodeFailure',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `SliceCacheNodeFailure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sliceCacheNodeFailureDescriptor = $convert.base64Decode(
    'ChVTbGljZUNhY2hlTm9kZUZhaWx1cmUSFwoHbm9kZV9pZBgBIAEoCVIGbm9kZUlkEhQKBWVycm'
    '9yGAIgASgJUgVlcnJvcg==');

@$core.Deprecated('Use getSliceCacheStatsResponseDescriptor instead')
const GetSliceCacheStatsResponse$json = {
  '1': 'GetSliceCacheStatsResponse',
  '2': [
    {
      '1': 'nodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.SliceCacheStatsNode',
      '10': 'nodes'
    },
    {
      '1': 'failures',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.SliceCacheNodeFailure',
      '10': 'failures'
    },
  ],
};

/// Descriptor for `GetSliceCacheStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSliceCacheStatsResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRTbGljZUNhY2hlU3RhdHNSZXNwb25zZRI3CgVub2RlcxgBIAMoCzIhLnN5bmN0di5hZG'
        '1pbi5TbGljZUNhY2hlU3RhdHNOb2RlUgVub2RlcxI/CghmYWlsdXJlcxgCIAMoCzIjLnN5bmN0'
        'di5hZG1pbi5TbGljZUNhY2hlTm9kZUZhaWx1cmVSCGZhaWx1cmVz');

@$core.Deprecated('Use purgeSliceCacheNodeResultDescriptor instead')
const PurgeSliceCacheNodeResult$json = {
  '1': 'PurgeSliceCacheNodeResult',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    {'1': 'removed_entries', '3': 3, '4': 1, '5': 4, '10': 'removedEntries'},
    {'1': 'freed_bytes', '3': 4, '4': 1, '5': 4, '10': 'freedBytes'},
    {
      '1': 'stats',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SliceCacheStatsNode',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `PurgeSliceCacheNodeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purgeSliceCacheNodeResultDescriptor = $convert.base64Decode(
    'ChlQdXJnZVNsaWNlQ2FjaGVOb2RlUmVzdWx0EhcKB25vZGVfaWQYASABKAlSBm5vZGVJZBIYCg'
    'dzdWNjZXNzGAIgASgIUgdzdWNjZXNzEicKD3JlbW92ZWRfZW50cmllcxgDIAEoBFIOcmVtb3Zl'
    'ZEVudHJpZXMSHwoLZnJlZWRfYnl0ZXMYBCABKARSCmZyZWVkQnl0ZXMSNwoFc3RhdHMYBSABKA'
    'syIS5zeW5jdHYuYWRtaW4uU2xpY2VDYWNoZVN0YXRzTm9kZVIFc3RhdHM=');

@$core.Deprecated('Use purgeSliceCacheResponseDescriptor instead')
const PurgeSliceCacheResponse$json = {
  '1': 'PurgeSliceCacheResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'removed_entries', '3': 2, '4': 1, '5': 4, '10': 'removedEntries'},
    {'1': 'freed_bytes', '3': 3, '4': 1, '5': 4, '10': 'freedBytes'},
    {
      '1': 'stats',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SliceCacheStatsNode',
      '10': 'stats'
    },
    {
      '1': 'nodes',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.PurgeSliceCacheNodeResult',
      '10': 'nodes'
    },
    {
      '1': 'failures',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.SliceCacheNodeFailure',
      '10': 'failures'
    },
  ],
};

/// Descriptor for `PurgeSliceCacheResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purgeSliceCacheResponseDescriptor = $convert.base64Decode(
    'ChdQdXJnZVNsaWNlQ2FjaGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEicKD3'
    'JlbW92ZWRfZW50cmllcxgCIAEoBFIOcmVtb3ZlZEVudHJpZXMSHwoLZnJlZWRfYnl0ZXMYAyAB'
    'KARSCmZyZWVkQnl0ZXMSNwoFc3RhdHMYBCABKAsyIS5zeW5jdHYuYWRtaW4uU2xpY2VDYWNoZV'
    'N0YXRzTm9kZVIFc3RhdHMSPQoFbm9kZXMYBSADKAsyJy5zeW5jdHYuYWRtaW4uUHVyZ2VTbGlj'
    'ZUNhY2hlTm9kZVJlc3VsdFIFbm9kZXMSPwoIZmFpbHVyZXMYBiADKAsyIy5zeW5jdHYuYWRtaW'
    '4uU2xpY2VDYWNoZU5vZGVGYWlsdXJlUghmYWlsdXJlcw==');

@$core.Deprecated('Use evictExpiredSliceCacheNodeResultDescriptor instead')
const EvictExpiredSliceCacheNodeResult$json = {
  '1': 'EvictExpiredSliceCacheNodeResult',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'removed_expired_entries',
      '3': 3,
      '4': 1,
      '5': 4,
      '10': 'removedExpiredEntries'
    },
    {
      '1': 'stats',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SliceCacheStatsNode',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `EvictExpiredSliceCacheNodeResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evictExpiredSliceCacheNodeResultDescriptor =
    $convert.base64Decode(
        'CiBFdmljdEV4cGlyZWRTbGljZUNhY2hlTm9kZVJlc3VsdBIXCgdub2RlX2lkGAEgASgJUgZub2'
        'RlSWQSGAoHc3VjY2VzcxgCIAEoCFIHc3VjY2VzcxI2ChdyZW1vdmVkX2V4cGlyZWRfZW50cmll'
        'cxgDIAEoBFIVcmVtb3ZlZEV4cGlyZWRFbnRyaWVzEjcKBXN0YXRzGAQgASgLMiEuc3luY3R2Lm'
        'FkbWluLlNsaWNlQ2FjaGVTdGF0c05vZGVSBXN0YXRz');

@$core.Deprecated('Use evictExpiredSliceCacheResponseDescriptor instead')
const EvictExpiredSliceCacheResponse$json = {
  '1': 'EvictExpiredSliceCacheResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'removed_expired_entries',
      '3': 2,
      '4': 1,
      '5': 4,
      '10': 'removedExpiredEntries'
    },
    {
      '1': 'stats',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SliceCacheStatsNode',
      '10': 'stats'
    },
    {
      '1': 'nodes',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.EvictExpiredSliceCacheNodeResult',
      '10': 'nodes'
    },
    {
      '1': 'failures',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.SliceCacheNodeFailure',
      '10': 'failures'
    },
  ],
};

/// Descriptor for `EvictExpiredSliceCacheResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evictExpiredSliceCacheResponseDescriptor = $convert.base64Decode(
    'Ch5FdmljdEV4cGlyZWRTbGljZUNhY2hlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
    'VzcxI2ChdyZW1vdmVkX2V4cGlyZWRfZW50cmllcxgCIAEoBFIVcmVtb3ZlZEV4cGlyZWRFbnRy'
    'aWVzEjcKBXN0YXRzGAMgASgLMiEuc3luY3R2LmFkbWluLlNsaWNlQ2FjaGVTdGF0c05vZGVSBX'
    'N0YXRzEkQKBW5vZGVzGAQgAygLMi4uc3luY3R2LmFkbWluLkV2aWN0RXhwaXJlZFNsaWNlQ2Fj'
    'aGVOb2RlUmVzdWx0UgVub2RlcxI/CghmYWlsdXJlcxgFIAMoCzIjLnN5bmN0di5hZG1pbi5TbG'
    'ljZUNhY2hlTm9kZUZhaWx1cmVSCGZhaWx1cmVz');

@$core.Deprecated('Use batchResultItemDescriptor instead')
const BatchResultItem$json = {
  '1': 'BatchResultItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

/// Descriptor for `BatchResultItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchResultItemDescriptor = $convert.base64Decode(
    'Cg9CYXRjaFJlc3VsdEl0ZW0SDgoCaWQYASABKAlSAmlkEhgKB3N1Y2Nlc3MYAiABKAhSB3N1Y2'
    'Nlc3MSFAoFZXJyb3IYAyABKAlSBWVycm9y');

@$core.Deprecated('Use batchBanUsersRequestDescriptor instead')
const BatchBanUsersRequest$json = {
  '1': 'BatchBanUsersRequest',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'userIds'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `BatchBanUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchBanUsersRequestDescriptor = $convert.base64Decode(
    'ChRCYXRjaEJhblVzZXJzUmVxdWVzdBJBCgh1c2VyX2lkcxgBIAMoCUImukgjkgEgCAEQZCIach'
    'gQARhAMhJedXNyX1tBLVphLXowLTldKyRSB3VzZXJJZHMSIAoGcmVhc29uGAIgASgJQgi6SAVy'
    'Axj0A1IGcmVhc29u');

@$core.Deprecated('Use batchBanUsersResponseDescriptor instead')
const BatchBanUsersResponse$json = {
  '1': 'BatchBanUsersResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.BatchResultItem',
      '10': 'results'
    },
    {'1': 'succeeded', '3': 2, '4': 1, '5': 5, '10': 'succeeded'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
  ],
};

/// Descriptor for `BatchBanUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchBanUsersResponseDescriptor = $convert.base64Decode(
    'ChVCYXRjaEJhblVzZXJzUmVzcG9uc2USNwoHcmVzdWx0cxgBIAMoCzIdLnN5bmN0di5hZG1pbi'
    '5CYXRjaFJlc3VsdEl0ZW1SB3Jlc3VsdHMSHAoJc3VjY2VlZGVkGAIgASgFUglzdWNjZWVkZWQS'
    'FgoGZmFpbGVkGAMgASgFUgZmYWlsZWQ=');

@$core.Deprecated('Use batchDeleteUsersRequestDescriptor instead')
const BatchDeleteUsersRequest$json = {
  '1': 'BatchDeleteUsersRequest',
  '2': [
    {'1': 'user_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'userIds'},
  ],
};

/// Descriptor for `BatchDeleteUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchDeleteUsersRequestDescriptor =
    $convert.base64Decode(
        'ChdCYXRjaERlbGV0ZVVzZXJzUmVxdWVzdBJBCgh1c2VyX2lkcxgBIAMoCUImukgjkgEgCAEQZC'
        'IachgQARhAMhJedXNyX1tBLVphLXowLTldKyRSB3VzZXJJZHM=');

@$core.Deprecated('Use batchDeleteUsersResponseDescriptor instead')
const BatchDeleteUsersResponse$json = {
  '1': 'BatchDeleteUsersResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.BatchResultItem',
      '10': 'results'
    },
    {'1': 'succeeded', '3': 2, '4': 1, '5': 5, '10': 'succeeded'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
  ],
};

/// Descriptor for `BatchDeleteUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchDeleteUsersResponseDescriptor = $convert.base64Decode(
    'ChhCYXRjaERlbGV0ZVVzZXJzUmVzcG9uc2USNwoHcmVzdWx0cxgBIAMoCzIdLnN5bmN0di5hZG'
    '1pbi5CYXRjaFJlc3VsdEl0ZW1SB3Jlc3VsdHMSHAoJc3VjY2VlZGVkGAIgASgFUglzdWNjZWVk'
    'ZWQSFgoGZmFpbGVkGAMgASgFUgZmYWlsZWQ=');

@$core.Deprecated('Use batchBanRoomsRequestDescriptor instead')
const BatchBanRoomsRequest$json = {
  '1': 'BatchBanRoomsRequest',
  '2': [
    {'1': 'room_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'roomIds'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `BatchBanRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchBanRoomsRequestDescriptor = $convert.base64Decode(
    'ChRCYXRjaEJhblJvb21zUmVxdWVzdBJCCghyb29tX2lkcxgBIAMoCUInukgkkgEhCAEQZCIbch'
    'kQARhAMhNecm9vbV9bQS1aYS16MC05XSskUgdyb29tSWRzEiAKBnJlYXNvbhgCIAEoCUIIukgF'
    'cgMY9ANSBnJlYXNvbg==');

@$core.Deprecated('Use batchBanRoomsResponseDescriptor instead')
const BatchBanRoomsResponse$json = {
  '1': 'BatchBanRoomsResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.BatchResultItem',
      '10': 'results'
    },
    {'1': 'succeeded', '3': 2, '4': 1, '5': 5, '10': 'succeeded'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
  ],
};

/// Descriptor for `BatchBanRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchBanRoomsResponseDescriptor = $convert.base64Decode(
    'ChVCYXRjaEJhblJvb21zUmVzcG9uc2USNwoHcmVzdWx0cxgBIAMoCzIdLnN5bmN0di5hZG1pbi'
    '5CYXRjaFJlc3VsdEl0ZW1SB3Jlc3VsdHMSHAoJc3VjY2VlZGVkGAIgASgFUglzdWNjZWVkZWQS'
    'FgoGZmFpbGVkGAMgASgFUgZmYWlsZWQ=');

@$core.Deprecated('Use listBanRecordsRequestDescriptor instead')
const ListBanRecordsRequest$json = {
  '1': 'ListBanRecordsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'target_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.BanTargetType',
      '8': {},
      '10': 'targetType'
    },
    {'1': 'active', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'active', '17': true},
    {'1': 'user_id', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'room_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
  '7': {},
  '8': [
    {'1': '_active'},
  ],
};

/// Descriptor for `ListBanRecordsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBanRecordsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0QmFuUmVjb3Jkc1JlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIbCglwYWdlX3Npem'
    'UYAiABKAVSCHBhZ2VTaXplEkYKC3RhcmdldF90eXBlGAMgASgOMhsuc3luY3R2LmFkbWluLkJh'
    'blRhcmdldFR5cGVCCLpIBYIBAhABUgp0YXJnZXRUeXBlEhsKBmFjdGl2ZRgEIAEoCEgAUgZhY3'
    'RpdmWIAQESNwoHdXNlcl9pZBgFIAEoCUIeukgbchkYQDIVXiR8XnVzcl9bQS1aYS16MC05XSsk'
    'UgZ1c2VySWQSOAoHcm9vbV9pZBgGIAEoCUIfukgcchoYQDIWXiR8XnJvb21fW0EtWmEtejAtOV'
    '0rJFIGcm9vbUlkOpUCukiRAhprChthZG1pbi5saXN0X2Jhbl9yZWNvcmRzLnBhZ2USKnBhZ2Ug'
    'bXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYXQgbGVhc3QgMRogdGhpcy5wYWdlID09IDAgfH'
    'wgdGhpcy5wYWdlID49IDEaoQEKIGFkbWluLmxpc3RfYmFuX3JlY29yZHMucGFnZV9zaXplEjZw'
    'YWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRX'
    'RoaXMucGFnZV9zaXplID09IDAgfHwgKHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdl'
    'X3NpemUgPD0gMTAwKUIJCgdfYWN0aXZl');

@$core.Deprecated('Use listBanRecordsResponseDescriptor instead')
const ListBanRecordsResponse$json = {
  '1': 'ListBanRecordsResponse',
  '2': [
    {
      '1': 'bans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.BanRecord',
      '10': 'bans'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListBanRecordsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBanRecordsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QmFuUmVjb3Jkc1Jlc3BvbnNlEisKBGJhbnMYASADKAsyFy5zeW5jdHYuYWRtaW4uQm'
        'FuUmVjb3JkUgRiYW5zEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

@$core.Deprecated('Use listContentReportsRequestDescriptor instead')
const ListContentReportsRequest$json = {
  '1': 'ListContentReportsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ContentReportStatus',
      '8': {},
      '10': 'status'
    },
    {
      '1': 'target_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ContentReportTargetType',
      '8': {},
      '10': 'targetType'
    },
    {
      '1': 'reporter_user_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'reporterUserId'
    },
    {'1': 'room_id', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'search', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'target_user_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'targetUserId'
    },
    {
      '1': 'target_member_user_id',
      '3': 9,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'targetMemberUserId'
    },
    {
      '1': 'target_chat_message_id',
      '3': 10,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'targetChatMessageId'
    },
    {
      '1': 'target_room_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'targetRoomId'
    },
    {
      '1': 'target_member_room_id',
      '3': 12,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'targetMemberRoomId'
    },
    {
      '1': 'scope',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ContentReportScope',
      '8': {},
      '10': 'scope'
    },
  ],
  '7': {},
};

/// Descriptor for `ListContentReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContentReportsRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0Q29udGVudFJlcG9ydHNSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USGwoJcGFnZV'
    '9zaXplGAIgASgFUghwYWdlU2l6ZRJDCgZzdGF0dXMYAyABKA4yIS5zeW5jdHYuYWRtaW4uQ29u'
    'dGVudFJlcG9ydFN0YXR1c0IIukgFggECEAFSBnN0YXR1cxJQCgt0YXJnZXRfdHlwZRgEIAEoDj'
    'IlLnN5bmN0di5hZG1pbi5Db250ZW50UmVwb3J0VGFyZ2V0VHlwZUIIukgFggECEAFSCnRhcmdl'
    'dFR5cGUSSAoQcmVwb3J0ZXJfdXNlcl9pZBgFIAEoCUIeukgbchkYQDIVXiR8XnVzcl9bQS1aYS'
    '16MC05XSskUg5yZXBvcnRlclVzZXJJZBI4Cgdyb29tX2lkGAYgASgJQh+6SBxyGhhAMhZeJHxe'
    'cm9vbV9bQS1aYS16MC05XSskUgZyb29tSWQSHwoGc2VhcmNoGAcgASgJQge6SARyAhh4UgZzZW'
    'FyY2gSRAoOdGFyZ2V0X3VzZXJfaWQYCCABKAlCHrpIG3IZGEAyFV4kfF51c3JfW0EtWmEtejAt'
    'OV0rJFIMdGFyZ2V0VXNlcklkElEKFXRhcmdldF9tZW1iZXJfdXNlcl9pZBgJIAEoCUIeukgbch'
    'kYQDIVXiR8XnVzcl9bQS1aYS16MC05XSskUhJ0YXJnZXRNZW1iZXJVc2VySWQSPAoWdGFyZ2V0'
    'X2NoYXRfbWVzc2FnZV9pZBgKIAEoA0IHukgEIgIoAFITdGFyZ2V0Q2hhdE1lc3NhZ2VJZBJFCg'
    '50YXJnZXRfcm9vbV9pZBgLIAEoCUIfukgcchoYQDIWXiR8XnJvb21fW0EtWmEtejAtOV0rJFIM'
    'dGFyZ2V0Um9vbUlkElIKFXRhcmdldF9tZW1iZXJfcm9vbV9pZBgMIAEoCUIfukgcchoYQDIWXi'
    'R8XnJvb21fW0EtWmEtejAtOV0rJFISdGFyZ2V0TWVtYmVyUm9vbUlkEkAKBXNjb3BlGA0gASgO'
    'MiAuc3luY3R2LmFkbWluLkNvbnRlbnRSZXBvcnRTY29wZUIIukgFggECEAFSBXNjb3BlOp0Cuk'
    'iZAhpvCh9hZG1pbi5saXN0X2NvbnRlbnRfcmVwb3J0cy5wYWdlEipwYWdlIG11c3QgYmUgMCAo'
    'dXNlIGRlZmF1bHQpIG9yIGF0IGxlYXN0IDEaIHRoaXMucGFnZSA9PSAwIHx8IHRoaXMucGFnZS'
    'A+PSAxGqUBCiRhZG1pbi5saXN0X2NvbnRlbnRfcmVwb3J0cy5wYWdlX3NpemUSNnBhZ2Vfc2l6'
    'ZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBpFdGhpcy5wYW'
    'dlX3NpemUgPT0gMCB8fCAodGhpcy5wYWdlX3NpemUgPj0gMSAmJiB0aGlzLnBhZ2Vfc2l6ZSA8'
    'PSAxMDAp');

@$core.Deprecated('Use listContentReportsResponseDescriptor instead')
const ListContentReportsResponse$json = {
  '1': 'ListContentReportsResponse',
  '2': [
    {
      '1': 'reports',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.ContentReport',
      '10': 'reports'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListContentReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContentReportsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Q29udGVudFJlcG9ydHNSZXNwb25zZRI1CgdyZXBvcnRzGAEgAygLMhsuc3luY3R2Lm'
        'FkbWluLkNvbnRlbnRSZXBvcnRSB3JlcG9ydHMSFAoFdG90YWwYAiABKAVSBXRvdGFs');

@$core.Deprecated('Use getContentReportRequestDescriptor instead')
const GetContentReportRequest$json = {
  '1': 'GetContentReportRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'reportId'},
  ],
};

/// Descriptor for `GetContentReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getContentReportRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDb250ZW50UmVwb3J0UmVxdWVzdBI9CglyZXBvcnRfaWQYASABKAlCILpIHXIbEAEYQD'
        'IVXnJlcG9ydF9bQS1aYS16MC05XSskUghyZXBvcnRJZA==');

@$core.Deprecated('Use updateContentReportStatusRequestDescriptor instead')
const UpdateContentReportStatusRequest$json = {
  '1': 'UpdateContentReportStatusRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'reportId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.admin.ContentReportStatus',
      '8': {},
      '10': 'status'
    },
    {
      '1': 'resolution_note',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'resolutionNote'
    },
  ],
};

/// Descriptor for `UpdateContentReportStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateContentReportStatusRequestDescriptor =
    $convert.base64Decode(
        'CiBVcGRhdGVDb250ZW50UmVwb3J0U3RhdHVzUmVxdWVzdBI9CglyZXBvcnRfaWQYASABKAlCIL'
        'pIHXIbEAEYQDIVXnJlcG9ydF9bQS1aYS16MC05XSskUghyZXBvcnRJZBJFCgZzdGF0dXMYAiAB'
        'KA4yIS5zeW5jdHYuYWRtaW4uQ29udGVudFJlcG9ydFN0YXR1c0IKukgHggEEEAEgAFIGc3RhdH'
        'VzEjEKD3Jlc29sdXRpb25fbm90ZRgDIAEoCUIIukgFcgMY0A9SDnJlc29sdXRpb25Ob3Rl');

@$core.Deprecated('Use updateContentReportStatusResponseDescriptor instead')
const UpdateContentReportStatusResponse$json = {
  '1': 'UpdateContentReportStatusResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.ContentReport',
      '10': 'report'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UpdateContentReportStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateContentReportStatusResponseDescriptor =
    $convert.base64Decode(
        'CiFVcGRhdGVDb250ZW50UmVwb3J0U3RhdHVzUmVzcG9uc2USMwoGcmVwb3J0GAEgASgLMhsuc3'
        'luY3R2LmFkbWluLkNvbnRlbnRSZXBvcnRSBnJlcG9ydBIYCgdzdWNjZXNzGAIgASgIUgdzdWNj'
        'ZXNz');

@$core.Deprecated('Use batchDeleteRoomsRequestDescriptor instead')
const BatchDeleteRoomsRequest$json = {
  '1': 'BatchDeleteRoomsRequest',
  '2': [
    {'1': 'room_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'roomIds'},
  ],
};

/// Descriptor for `BatchDeleteRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchDeleteRoomsRequestDescriptor =
    $convert.base64Decode(
        'ChdCYXRjaERlbGV0ZVJvb21zUmVxdWVzdBJCCghyb29tX2lkcxgBIAMoCUInukgkkgEhCAEQZC'
        'IbchkQARhAMhNecm9vbV9bQS1aYS16MC05XSskUgdyb29tSWRz');

@$core.Deprecated('Use batchDeleteRoomsResponseDescriptor instead')
const BatchDeleteRoomsResponse$json = {
  '1': 'BatchDeleteRoomsResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.BatchResultItem',
      '10': 'results'
    },
    {'1': 'succeeded', '3': 2, '4': 1, '5': 5, '10': 'succeeded'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
  ],
};

/// Descriptor for `BatchDeleteRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchDeleteRoomsResponseDescriptor = $convert.base64Decode(
    'ChhCYXRjaERlbGV0ZVJvb21zUmVzcG9uc2USNwoHcmVzdWx0cxgBIAMoCzIdLnN5bmN0di5hZG'
    '1pbi5CYXRjaFJlc3VsdEl0ZW1SB3Jlc3VsdHMSHAoJc3VjY2VlZGVkGAIgASgFUglzdWNjZWVk'
    'ZWQSFgoGZmFpbGVkGAMgASgFUgZmYWlsZWQ=');

const $core.Map<$core.String, $core.dynamic> AdminServiceBase$json = {
  '1': 'AdminService',
  '2': [
    {
      '1': 'GetSettings',
      '2': '.synctv.admin.GetSettingsRequest',
      '3': '.synctv.admin.RuntimeSettings'
    },
    {
      '1': 'UpdateSettings',
      '2': '.synctv.admin.UpdateSettingsRequest',
      '3': '.synctv.admin.RuntimeSettings'
    },
    {
      '1': 'ExportSettings',
      '2': '.synctv.admin.ExportSettingsRequest',
      '3': '.synctv.admin.RuntimeSettingsSnapshot'
    },
    {
      '1': 'ImportSettings',
      '2': '.synctv.admin.ImportSettingsRequest',
      '3': '.synctv.admin.ImportSettingsResponse'
    },
    {
      '1': 'SendTestEmail',
      '2': '.synctv.admin.SendTestEmailRequest',
      '3': '.synctv.admin.SendTestEmailResponse'
    },
    {
      '1': 'CreateUser',
      '2': '.synctv.admin.CreateUserRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'DeleteUser',
      '2': '.synctv.admin.DeleteUserRequest',
      '3': '.synctv.admin.DeleteUserResponse'
    },
    {
      '1': 'ListUsers',
      '2': '.synctv.admin.ListUsersRequest',
      '3': '.synctv.admin.ListUsersResponse'
    },
    {
      '1': 'GetUser',
      '2': '.synctv.admin.GetUserRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'GetUserPreferences',
      '2': '.synctv.admin.GetUserPreferencesRequest',
      '3': '.synctv.admin.GetUserPreferencesResponse'
    },
    {
      '1': 'UpdateUserPreferences',
      '2': '.synctv.admin.UpdateUserPreferencesRequest',
      '3': '.synctv.admin.UpdateUserPreferencesResponse'
    },
    {
      '1': 'SetUserPassword',
      '2': '.synctv.admin.SetUserPasswordRequest',
      '3': '.synctv.admin.SetUserPasswordResponse'
    },
    {
      '1': 'UpdateUserUsername',
      '2': '.synctv.admin.UpdateUserUsernameRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'UpdateUserRole',
      '2': '.synctv.admin.UpdateUserRoleRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'BanUser',
      '2': '.synctv.admin.BanUserRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'UnbanUser',
      '2': '.synctv.admin.UnbanUserRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'GetUserRooms',
      '2': '.synctv.admin.GetUserRoomsRequest',
      '3': '.synctv.admin.GetUserRoomsResponse'
    },
    {
      '1': 'BatchBanUsers',
      '2': '.synctv.admin.BatchBanUsersRequest',
      '3': '.synctv.admin.BatchBanUsersResponse'
    },
    {
      '1': 'BatchDeleteUsers',
      '2': '.synctv.admin.BatchDeleteUsersRequest',
      '3': '.synctv.admin.BatchDeleteUsersResponse'
    },
    {
      '1': 'BatchBanRooms',
      '2': '.synctv.admin.BatchBanRoomsRequest',
      '3': '.synctv.admin.BatchBanRoomsResponse'
    },
    {
      '1': 'BatchDeleteRooms',
      '2': '.synctv.admin.BatchDeleteRoomsRequest',
      '3': '.synctv.admin.BatchDeleteRoomsResponse'
    },
    {
      '1': 'ListRooms',
      '2': '.synctv.admin.ListRoomsRequest',
      '3': '.synctv.admin.ListRoomsResponse'
    },
    {
      '1': 'GetRoom',
      '2': '.synctv.admin.GetRoomRequest',
      '3': '.synctv.admin.Room'
    },
    {
      '1': 'GetRoomSettings',
      '2': '.synctv.admin.GetRoomSettingsRequest',
      '3': '.synctv.admin.GetRoomSettingsResponse'
    },
    {
      '1': 'UpdateRoomSettings',
      '2': '.synctv.admin.UpdateRoomSettingsRequest',
      '3': '.synctv.admin.Room'
    },
    {
      '1': 'ResetRoomSettings',
      '2': '.synctv.admin.ResetRoomSettingsRequest',
      '3': '.synctv.admin.Room'
    },
    {
      '1': 'UpdateRoomPassword',
      '2': '.synctv.admin.UpdateRoomPasswordRequest',
      '3': '.synctv.admin.UpdateRoomPasswordResponse'
    },
    {
      '1': 'DeleteRoom',
      '2': '.synctv.admin.DeleteRoomRequest',
      '3': '.synctv.admin.DeleteRoomResponse'
    },
    {
      '1': 'BanRoom',
      '2': '.synctv.admin.BanRoomRequest',
      '3': '.synctv.admin.Room'
    },
    {
      '1': 'UnbanRoom',
      '2': '.synctv.admin.UnbanRoomRequest',
      '3': '.synctv.admin.Room'
    },
    {
      '1': 'GetRoomMembers',
      '2': '.synctv.admin.GetRoomMembersRequest',
      '3': '.synctv.admin.GetRoomMembersResponse'
    },
    {
      '1': 'AddMember',
      '2': '.synctv.admin.AddMemberRequest',
      '3': '.synctv.common.RoomMember'
    },
    {
      '1': 'UpdateMemberRemarkName',
      '2': '.synctv.admin.UpdateMemberRemarkNameRequest',
      '3': '.synctv.common.RoomMember'
    },
    {
      '1': 'UpdateMemberDisplayTag',
      '2': '.synctv.admin.UpdateMemberDisplayTagRequest',
      '3': '.synctv.common.RoomMember'
    },
    {
      '1': 'UpdateMemberPermissions',
      '2': '.synctv.admin.UpdateMemberPermissionsRequest',
      '3': '.synctv.common.RoomMember'
    },
    {
      '1': 'KickMember',
      '2': '.synctv.admin.KickMemberRequest',
      '3': '.synctv.admin.KickMemberResponse'
    },
    {
      '1': 'ListRoomCategories',
      '2': '.synctv.admin.ListRoomCategoriesRequest',
      '3': '.synctv.admin.ListRoomCategoriesResponse'
    },
    {
      '1': 'UpsertRoomCategory',
      '2': '.synctv.admin.UpsertRoomCategoryRequest',
      '3': '.synctv.client.RoomCategory'
    },
    {
      '1': 'DeleteRoomCategory',
      '2': '.synctv.admin.DeleteRoomCategoryRequest',
      '3': '.synctv.admin.DeleteRoomCategoryResponse'
    },
    {
      '1': 'ListRoomLabels',
      '2': '.synctv.admin.ListRoomLabelsRequest',
      '3': '.synctv.admin.ListRoomLabelsResponse'
    },
    {
      '1': 'UpsertRoomLabel',
      '2': '.synctv.admin.UpsertRoomLabelRequest',
      '3': '.synctv.client.RoomLabel'
    },
    {
      '1': 'DeleteRoomLabel',
      '2': '.synctv.admin.DeleteRoomLabelRequest',
      '3': '.synctv.admin.DeleteRoomLabelResponse'
    },
    {
      '1': 'UpdateRoomTaxonomy',
      '2': '.synctv.admin.UpdateRoomTaxonomyRequest',
      '3': '.synctv.admin.Room'
    },
    {
      '1': 'AddAdmin',
      '2': '.synctv.admin.AddAdminRequest',
      '3': '.synctv.admin.AdminUser'
    },
    {
      '1': 'RemoveAdmin',
      '2': '.synctv.admin.RemoveAdminRequest',
      '3': '.synctv.admin.RemoveAdminResponse'
    },
    {
      '1': 'ListAdmins',
      '2': '.synctv.admin.ListAdminsRequest',
      '3': '.synctv.admin.ListAdminsResponse'
    },
    {
      '1': 'GetServiceState',
      '2': '.synctv.admin.GetServiceStateRequest',
      '3': '.synctv.admin.GetServiceStateResponse'
    },
    {
      '1': 'GetSliceCacheStats',
      '2': '.synctv.admin.GetSliceCacheStatsRequest',
      '3': '.synctv.admin.GetSliceCacheStatsResponse'
    },
    {
      '1': 'PurgeSliceCache',
      '2': '.synctv.admin.PurgeSliceCacheRequest',
      '3': '.synctv.admin.PurgeSliceCacheResponse'
    },
    {
      '1': 'EvictExpiredSliceCache',
      '2': '.synctv.admin.EvictExpiredSliceCacheRequest',
      '3': '.synctv.admin.EvictExpiredSliceCacheResponse'
    },
    {
      '1': 'ListActiveStreams',
      '2': '.synctv.admin.ListActiveStreamsRequest',
      '3': '.synctv.admin.ListActiveStreamsResponse'
    },
    {
      '1': 'KickStream',
      '2': '.synctv.admin.KickStreamRequest',
      '3': '.synctv.admin.KickStreamResponse'
    },
    {
      '1': 'ListUserRegistrationReviews',
      '2': '.synctv.admin.ListUserRegistrationReviewsRequest',
      '3': '.synctv.admin.ListUserRegistrationReviewsResponse'
    },
    {
      '1': 'ApproveUserRegistrationReview',
      '2': '.synctv.admin.ApproveUserRegistrationReviewRequest',
      '3': '.synctv.admin.ApproveUserRegistrationReviewResponse'
    },
    {
      '1': 'RejectUserRegistrationReview',
      '2': '.synctv.admin.RejectUserRegistrationReviewRequest',
      '3': '.synctv.admin.UserRegistrationReview'
    },
    {
      '1': 'ListRoomCreationReviews',
      '2': '.synctv.admin.ListRoomCreationReviewsRequest',
      '3': '.synctv.admin.ListRoomCreationReviewsResponse'
    },
    {
      '1': 'ApproveRoomCreationReview',
      '2': '.synctv.admin.ApproveRoomCreationReviewRequest',
      '3': '.synctv.admin.ApproveRoomCreationReviewResponse'
    },
    {
      '1': 'RejectRoomCreationReview',
      '2': '.synctv.admin.RejectRoomCreationReviewRequest',
      '3': '.synctv.admin.RoomCreationReview'
    },
    {
      '1': 'ListRoomJoinReviews',
      '2': '.synctv.admin.ListRoomJoinReviewsRequest',
      '3': '.synctv.admin.ListRoomJoinReviewsResponse'
    },
    {
      '1': 'ApproveRoomJoinReview',
      '2': '.synctv.admin.ApproveRoomJoinReviewRequest',
      '3': '.synctv.admin.ApproveRoomJoinReviewResponse'
    },
    {
      '1': 'RejectRoomJoinReview',
      '2': '.synctv.admin.RejectRoomJoinReviewRequest',
      '3': '.synctv.admin.RoomJoinReview'
    },
    {
      '1': 'ListBanRecords',
      '2': '.synctv.admin.ListBanRecordsRequest',
      '3': '.synctv.admin.ListBanRecordsResponse'
    },
    {
      '1': 'ListContentReports',
      '2': '.synctv.admin.ListContentReportsRequest',
      '3': '.synctv.admin.ListContentReportsResponse'
    },
    {
      '1': 'GetContentReport',
      '2': '.synctv.admin.GetContentReportRequest',
      '3': '.synctv.admin.ContentReport'
    },
    {
      '1': 'UpdateContentReportStatus',
      '2': '.synctv.admin.UpdateContentReportStatusRequest',
      '3': '.synctv.admin.UpdateContentReportStatusResponse'
    },
  ],
};

@$core.Deprecated('Use adminServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AdminServiceBase$messageJson = {
  '.synctv.admin.GetSettingsRequest': GetSettingsRequest$json,
  '.synctv.admin.RuntimeSettings': RuntimeSettings$json,
  '.synctv.admin.RoomDefaultsSettings': RoomDefaultsSettings$json,
  '.synctv.admin.PermissionSettings': PermissionSettings$json,
  '.synctv.admin.RoomCreationSettings': RoomCreationSettings$json,
  '.synctv.admin.UserSettings': UserSettings$json,
  '.synctv.admin.OAuth2Settings': OAuth2Settings$json,
  '.synctv.admin.OAuth2ProviderSettings': OAuth2ProviderSettings$json,
  '.synctv.admin.OAuth2QqProviderConfig': OAuth2QqProviderConfig$json,
  '.synctv.admin.OAuth2GithubProviderConfig': OAuth2GithubProviderConfig$json,
  '.synctv.admin.OAuth2GoogleProviderConfig': OAuth2GoogleProviderConfig$json,
  '.synctv.admin.OAuth2MicrosoftProviderConfig':
      OAuth2MicrosoftProviderConfig$json,
  '.synctv.admin.OAuth2DiscordProviderConfig': OAuth2DiscordProviderConfig$json,
  '.synctv.admin.OAuth2CasdoorProviderConfig': OAuth2CasdoorProviderConfig$json,
  '.synctv.admin.OAuth2LogtoProviderConfig': OAuth2LogtoProviderConfig$json,
  '.synctv.admin.OAuth2OidcProviderConfig': OAuth2OidcProviderConfig$json,
  '.synctv.admin.OAuth2FeishuProviderConfig': OAuth2FeishuProviderConfig$json,
  '.synctv.admin.OAuth2GiteeProviderConfig': OAuth2GiteeProviderConfig$json,
  '.synctv.admin.OAuth2AppleProviderConfig': OAuth2AppleProviderConfig$json,
  '.synctv.admin.RtmpSettings': RtmpSettings$json,
  '.synctv.admin.EmailSettings': EmailSettings$json,
  '.synctv.admin.SmtpCredentials': SmtpCredentials$json,
  '.synctv.admin.SmtpProxy': SmtpProxy$json,
  '.synctv.admin.WebRTCSettings': WebRTCSettings$json,
  '.synctv.client.IceServer': $1.IceServer$json,
  '.synctv.admin.ChatSettings': ChatSettings$json,
  '.synctv.admin.CorsSettings': CorsSettings$json,
  '.synctv.admin.ServerSettings': ServerSettings$json,
  '.synctv.admin.PlaybackHistorySettings': PlaybackHistorySettings$json,
  '.synctv.admin.UpdateSettingsRequest': UpdateSettingsRequest$json,
  '.synctv.admin.RuntimeSettingsPatch': RuntimeSettingsPatch$json,
  '.synctv.admin.RoomDefaultsSettingsPatch': RoomDefaultsSettingsPatch$json,
  '.synctv.admin.PermissionSettingsPatch': PermissionSettingsPatch$json,
  '.synctv.admin.RoomCreationSettingsPatch': RoomCreationSettingsPatch$json,
  '.synctv.admin.UserSettingsPatch': UserSettingsPatch$json,
  '.synctv.admin.OAuth2SettingsPatch': OAuth2SettingsPatch$json,
  '.synctv.admin.RtmpSettingsPatch': RtmpSettingsPatch$json,
  '.synctv.admin.EmailSettingsPatch': EmailSettingsPatch$json,
  '.synctv.admin.WebRTCSettingsPatch': WebRTCSettingsPatch$json,
  '.synctv.admin.ChatSettingsPatch': ChatSettingsPatch$json,
  '.synctv.admin.CorsSettingsPatch': CorsSettingsPatch$json,
  '.synctv.admin.ServerSettingsPatch': ServerSettingsPatch$json,
  '.synctv.admin.PlaybackHistorySettingsPatch':
      PlaybackHistorySettingsPatch$json,
  '.google.protobuf.FieldMask': $2.FieldMask$json,
  '.synctv.admin.ExportSettingsRequest': ExportSettingsRequest$json,
  '.synctv.admin.RuntimeSettingsSnapshot': RuntimeSettingsSnapshot$json,
  '.synctv.admin.ImportSettingsRequest': ImportSettingsRequest$json,
  '.synctv.admin.ImportSettingsResponse': ImportSettingsResponse$json,
  '.synctv.admin.SendTestEmailRequest': SendTestEmailRequest$json,
  '.synctv.admin.SendTestEmailResponse': SendTestEmailResponse$json,
  '.synctv.admin.CreateUserRequest': CreateUserRequest$json,
  '.synctv.admin.AdminUser': AdminUser$json,
  '.synctv.common.UserPresenceStats': $0.UserPresenceStats$json,
  '.synctv.common.NodeConnectionCount': $0.NodeConnectionCount$json,
  '.synctv.admin.DeleteUserRequest': DeleteUserRequest$json,
  '.synctv.admin.DeleteUserResponse': DeleteUserResponse$json,
  '.synctv.admin.ListUsersRequest': ListUsersRequest$json,
  '.synctv.admin.ListUsersResponse': ListUsersResponse$json,
  '.synctv.admin.GetUserRequest': GetUserRequest$json,
  '.synctv.admin.GetUserPreferencesRequest': GetUserPreferencesRequest$json,
  '.synctv.admin.GetUserPreferencesResponse': GetUserPreferencesResponse$json,
  '.synctv.client.UserPreferences': $1.UserPreferences$json,
  '.synctv.client.UserNotificationPreferences':
      $1.UserNotificationPreferences$json,
  '.synctv.client.RoomSettings': $1.RoomSettings$json,
  '.synctv.client.AutoPlaySettings': $1.AutoPlaySettings$json,
  '.synctv.client.UserAuthFactors': $1.UserAuthFactors$json,
  '.synctv.admin.UpdateUserPreferencesRequest':
      UpdateUserPreferencesRequest$json,
  '.synctv.admin.UpdateUserPreferencesResponse':
      UpdateUserPreferencesResponse$json,
  '.synctv.admin.SetUserPasswordRequest': SetUserPasswordRequest$json,
  '.synctv.admin.SetUserPasswordResponse': SetUserPasswordResponse$json,
  '.synctv.admin.UpdateUserUsernameRequest': UpdateUserUsernameRequest$json,
  '.synctv.admin.UpdateUserRoleRequest': UpdateUserRoleRequest$json,
  '.synctv.admin.BanUserRequest': BanUserRequest$json,
  '.synctv.admin.UnbanUserRequest': UnbanUserRequest$json,
  '.synctv.admin.GetUserRoomsRequest': GetUserRoomsRequest$json,
  '.synctv.admin.GetUserRoomsResponse': GetUserRoomsResponse$json,
  '.synctv.admin.Room': Room$json,
  '.synctv.common.RoomPresenceStats': $0.RoomPresenceStats$json,
  '.synctv.client.ResourceCover': $1.ResourceCover$json,
  '.synctv.client.FileMetadata': $1.FileMetadata$json,
  '.synctv.client.FileObjectVariant': $1.FileObjectVariant$json,
  '.synctv.client.FileObjectAccess': $1.FileObjectAccess$json,
  '.synctv.client.RoomCategory': $1.RoomCategory$json,
  '.synctv.client.RoomLabel': $1.RoomLabel$json,
  '.synctv.admin.BatchBanUsersRequest': BatchBanUsersRequest$json,
  '.synctv.admin.BatchBanUsersResponse': BatchBanUsersResponse$json,
  '.synctv.admin.BatchResultItem': BatchResultItem$json,
  '.synctv.admin.BatchDeleteUsersRequest': BatchDeleteUsersRequest$json,
  '.synctv.admin.BatchDeleteUsersResponse': BatchDeleteUsersResponse$json,
  '.synctv.admin.BatchBanRoomsRequest': BatchBanRoomsRequest$json,
  '.synctv.admin.BatchBanRoomsResponse': BatchBanRoomsResponse$json,
  '.synctv.admin.BatchDeleteRoomsRequest': BatchDeleteRoomsRequest$json,
  '.synctv.admin.BatchDeleteRoomsResponse': BatchDeleteRoomsResponse$json,
  '.synctv.admin.ListRoomsRequest': ListRoomsRequest$json,
  '.synctv.admin.ListRoomsResponse': ListRoomsResponse$json,
  '.synctv.admin.GetRoomRequest': GetRoomRequest$json,
  '.synctv.admin.GetRoomSettingsRequest': GetRoomSettingsRequest$json,
  '.synctv.admin.GetRoomSettingsResponse': GetRoomSettingsResponse$json,
  '.synctv.admin.UpdateRoomSettingsRequest': UpdateRoomSettingsRequest$json,
  '.synctv.client.RoomSettingsPatch': $1.RoomSettingsPatch$json,
  '.synctv.client.AutoPlaySettingsPatch': $1.AutoPlaySettingsPatch$json,
  '.synctv.admin.ResetRoomSettingsRequest': ResetRoomSettingsRequest$json,
  '.synctv.admin.UpdateRoomPasswordRequest': UpdateRoomPasswordRequest$json,
  '.synctv.admin.UpdateRoomPasswordResponse': UpdateRoomPasswordResponse$json,
  '.synctv.admin.DeleteRoomRequest': DeleteRoomRequest$json,
  '.synctv.admin.DeleteRoomResponse': DeleteRoomResponse$json,
  '.synctv.admin.BanRoomRequest': BanRoomRequest$json,
  '.synctv.admin.UnbanRoomRequest': UnbanRoomRequest$json,
  '.synctv.admin.GetRoomMembersRequest': GetRoomMembersRequest$json,
  '.synctv.admin.GetRoomMembersResponse': GetRoomMembersResponse$json,
  '.synctv.common.RoomMember': $0.RoomMember$json,
  '.synctv.admin.AddMemberRequest': AddMemberRequest$json,
  '.synctv.admin.UpdateMemberRemarkNameRequest':
      UpdateMemberRemarkNameRequest$json,
  '.synctv.admin.UpdateMemberDisplayTagRequest':
      UpdateMemberDisplayTagRequest$json,
  '.synctv.admin.UpdateMemberPermissionsRequest':
      UpdateMemberPermissionsRequest$json,
  '.synctv.admin.KickMemberRequest': KickMemberRequest$json,
  '.synctv.admin.KickMemberResponse': KickMemberResponse$json,
  '.synctv.admin.ListRoomCategoriesRequest': ListRoomCategoriesRequest$json,
  '.synctv.admin.ListRoomCategoriesResponse': ListRoomCategoriesResponse$json,
  '.synctv.admin.UpsertRoomCategoryRequest': UpsertRoomCategoryRequest$json,
  '.synctv.admin.DeleteRoomCategoryRequest': DeleteRoomCategoryRequest$json,
  '.synctv.admin.DeleteRoomCategoryResponse': DeleteRoomCategoryResponse$json,
  '.synctv.admin.ListRoomLabelsRequest': ListRoomLabelsRequest$json,
  '.synctv.admin.ListRoomLabelsResponse': ListRoomLabelsResponse$json,
  '.synctv.admin.UpsertRoomLabelRequest': UpsertRoomLabelRequest$json,
  '.synctv.admin.DeleteRoomLabelRequest': DeleteRoomLabelRequest$json,
  '.synctv.admin.DeleteRoomLabelResponse': DeleteRoomLabelResponse$json,
  '.synctv.admin.UpdateRoomTaxonomyRequest': UpdateRoomTaxonomyRequest$json,
  '.synctv.admin.AddAdminRequest': AddAdminRequest$json,
  '.synctv.admin.RemoveAdminRequest': RemoveAdminRequest$json,
  '.synctv.admin.RemoveAdminResponse': RemoveAdminResponse$json,
  '.synctv.admin.ListAdminsRequest': ListAdminsRequest$json,
  '.synctv.admin.ListAdminsResponse': ListAdminsResponse$json,
  '.synctv.admin.GetServiceStateRequest': GetServiceStateRequest$json,
  '.synctv.admin.GetServiceStateResponse': GetServiceStateResponse$json,
  '.synctv.admin.ServiceAdditionalState': ServiceAdditionalState$json,
  '.synctv.common.PresenceOverview': $0.PresenceOverview$json,
  '.synctv.common.NodePresenceStats': $0.NodePresenceStats$json,
  '.synctv.admin.GetSliceCacheStatsRequest': GetSliceCacheStatsRequest$json,
  '.synctv.admin.GetSliceCacheStatsResponse': GetSliceCacheStatsResponse$json,
  '.synctv.admin.SliceCacheStatsNode': SliceCacheStatsNode$json,
  '.synctv.admin.SliceCacheConfigInfo': SliceCacheConfigInfo$json,
  '.synctv.admin.SliceCacheNodeFailure': SliceCacheNodeFailure$json,
  '.synctv.admin.PurgeSliceCacheRequest': PurgeSliceCacheRequest$json,
  '.synctv.admin.PurgeSliceCacheResponse': PurgeSliceCacheResponse$json,
  '.synctv.admin.PurgeSliceCacheNodeResult': PurgeSliceCacheNodeResult$json,
  '.synctv.admin.EvictExpiredSliceCacheRequest':
      EvictExpiredSliceCacheRequest$json,
  '.synctv.admin.EvictExpiredSliceCacheResponse':
      EvictExpiredSliceCacheResponse$json,
  '.synctv.admin.EvictExpiredSliceCacheNodeResult':
      EvictExpiredSliceCacheNodeResult$json,
  '.synctv.admin.ListActiveStreamsRequest': ListActiveStreamsRequest$json,
  '.synctv.admin.ListActiveStreamsResponse': ListActiveStreamsResponse$json,
  '.synctv.admin.ActiveStreamInfo': ActiveStreamInfo$json,
  '.synctv.admin.KickStreamRequest': KickStreamRequest$json,
  '.synctv.admin.KickStreamResponse': KickStreamResponse$json,
  '.synctv.admin.ListUserRegistrationReviewsRequest':
      ListUserRegistrationReviewsRequest$json,
  '.synctv.admin.ListUserRegistrationReviewsResponse':
      ListUserRegistrationReviewsResponse$json,
  '.synctv.admin.UserRegistrationReview': UserRegistrationReview$json,
  '.synctv.admin.ApproveUserRegistrationReviewRequest':
      ApproveUserRegistrationReviewRequest$json,
  '.synctv.admin.ApproveUserRegistrationReviewResponse':
      ApproveUserRegistrationReviewResponse$json,
  '.synctv.admin.RejectUserRegistrationReviewRequest':
      RejectUserRegistrationReviewRequest$json,
  '.synctv.admin.ListRoomCreationReviewsRequest':
      ListRoomCreationReviewsRequest$json,
  '.synctv.admin.ListRoomCreationReviewsResponse':
      ListRoomCreationReviewsResponse$json,
  '.synctv.admin.RoomCreationReview': RoomCreationReview$json,
  '.synctv.admin.ApproveRoomCreationReviewRequest':
      ApproveRoomCreationReviewRequest$json,
  '.synctv.admin.ApproveRoomCreationReviewResponse':
      ApproveRoomCreationReviewResponse$json,
  '.synctv.admin.RejectRoomCreationReviewRequest':
      RejectRoomCreationReviewRequest$json,
  '.synctv.admin.ListRoomJoinReviewsRequest': ListRoomJoinReviewsRequest$json,
  '.synctv.admin.ListRoomJoinReviewsResponse': ListRoomJoinReviewsResponse$json,
  '.synctv.admin.RoomJoinReview': RoomJoinReview$json,
  '.synctv.admin.ApproveRoomJoinReviewRequest':
      ApproveRoomJoinReviewRequest$json,
  '.synctv.admin.ApproveRoomJoinReviewResponse':
      ApproveRoomJoinReviewResponse$json,
  '.synctv.admin.RejectRoomJoinReviewRequest': RejectRoomJoinReviewRequest$json,
  '.synctv.admin.ListBanRecordsRequest': ListBanRecordsRequest$json,
  '.synctv.admin.ListBanRecordsResponse': ListBanRecordsResponse$json,
  '.synctv.admin.BanRecord': BanRecord$json,
  '.synctv.admin.ListContentReportsRequest': ListContentReportsRequest$json,
  '.synctv.admin.ListContentReportsResponse': ListContentReportsResponse$json,
  '.synctv.admin.ContentReport': ContentReport$json,
  '.synctv.client.ContentReportMetadata': $1.ContentReportMetadata$json,
  '.synctv.admin.GetContentReportRequest': GetContentReportRequest$json,
  '.synctv.admin.UpdateContentReportStatusRequest':
      UpdateContentReportStatusRequest$json,
  '.synctv.admin.UpdateContentReportStatusResponse':
      UpdateContentReportStatusResponse$json,
};

/// Descriptor for `AdminService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List adminServiceDescriptor = $convert.base64Decode(
    'CgxBZG1pblNlcnZpY2USTgoLR2V0U2V0dGluZ3MSIC5zeW5jdHYuYWRtaW4uR2V0U2V0dGluZ3'
    'NSZXF1ZXN0Gh0uc3luY3R2LmFkbWluLlJ1bnRpbWVTZXR0aW5ncxJUCg5VcGRhdGVTZXR0aW5n'
    'cxIjLnN5bmN0di5hZG1pbi5VcGRhdGVTZXR0aW5nc1JlcXVlc3QaHS5zeW5jdHYuYWRtaW4uUn'
    'VudGltZVNldHRpbmdzElwKDkV4cG9ydFNldHRpbmdzEiMuc3luY3R2LmFkbWluLkV4cG9ydFNl'
    'dHRpbmdzUmVxdWVzdBolLnN5bmN0di5hZG1pbi5SdW50aW1lU2V0dGluZ3NTbmFwc2hvdBJbCg'
    '5JbXBvcnRTZXR0aW5ncxIjLnN5bmN0di5hZG1pbi5JbXBvcnRTZXR0aW5nc1JlcXVlc3QaJC5z'
    'eW5jdHYuYWRtaW4uSW1wb3J0U2V0dGluZ3NSZXNwb25zZRJYCg1TZW5kVGVzdEVtYWlsEiIuc3'
    'luY3R2LmFkbWluLlNlbmRUZXN0RW1haWxSZXF1ZXN0GiMuc3luY3R2LmFkbWluLlNlbmRUZXN0'
    'RW1haWxSZXNwb25zZRJGCgpDcmVhdGVVc2VyEh8uc3luY3R2LmFkbWluLkNyZWF0ZVVzZXJSZX'
    'F1ZXN0Ghcuc3luY3R2LmFkbWluLkFkbWluVXNlchJPCgpEZWxldGVVc2VyEh8uc3luY3R2LmFk'
    'bWluLkRlbGV0ZVVzZXJSZXF1ZXN0GiAuc3luY3R2LmFkbWluLkRlbGV0ZVVzZXJSZXNwb25zZR'
    'JMCglMaXN0VXNlcnMSHi5zeW5jdHYuYWRtaW4uTGlzdFVzZXJzUmVxdWVzdBofLnN5bmN0di5h'
    'ZG1pbi5MaXN0VXNlcnNSZXNwb25zZRJACgdHZXRVc2VyEhwuc3luY3R2LmFkbWluLkdldFVzZX'
    'JSZXF1ZXN0Ghcuc3luY3R2LmFkbWluLkFkbWluVXNlchJnChJHZXRVc2VyUHJlZmVyZW5jZXMS'
    'Jy5zeW5jdHYuYWRtaW4uR2V0VXNlclByZWZlcmVuY2VzUmVxdWVzdBooLnN5bmN0di5hZG1pbi'
    '5HZXRVc2VyUHJlZmVyZW5jZXNSZXNwb25zZRJwChVVcGRhdGVVc2VyUHJlZmVyZW5jZXMSKi5z'
    'eW5jdHYuYWRtaW4uVXBkYXRlVXNlclByZWZlcmVuY2VzUmVxdWVzdBorLnN5bmN0di5hZG1pbi'
    '5VcGRhdGVVc2VyUHJlZmVyZW5jZXNSZXNwb25zZRJeCg9TZXRVc2VyUGFzc3dvcmQSJC5zeW5j'
    'dHYuYWRtaW4uU2V0VXNlclBhc3N3b3JkUmVxdWVzdBolLnN5bmN0di5hZG1pbi5TZXRVc2VyUG'
    'Fzc3dvcmRSZXNwb25zZRJWChJVcGRhdGVVc2VyVXNlcm5hbWUSJy5zeW5jdHYuYWRtaW4uVXBk'
    'YXRlVXNlclVzZXJuYW1lUmVxdWVzdBoXLnN5bmN0di5hZG1pbi5BZG1pblVzZXISTgoOVXBkYX'
    'RlVXNlclJvbGUSIy5zeW5jdHYuYWRtaW4uVXBkYXRlVXNlclJvbGVSZXF1ZXN0Ghcuc3luY3R2'
    'LmFkbWluLkFkbWluVXNlchJACgdCYW5Vc2VyEhwuc3luY3R2LmFkbWluLkJhblVzZXJSZXF1ZX'
    'N0Ghcuc3luY3R2LmFkbWluLkFkbWluVXNlchJECglVbmJhblVzZXISHi5zeW5jdHYuYWRtaW4u'
    'VW5iYW5Vc2VyUmVxdWVzdBoXLnN5bmN0di5hZG1pbi5BZG1pblVzZXISVQoMR2V0VXNlclJvb2'
    '1zEiEuc3luY3R2LmFkbWluLkdldFVzZXJSb29tc1JlcXVlc3QaIi5zeW5jdHYuYWRtaW4uR2V0'
    'VXNlclJvb21zUmVzcG9uc2USWAoNQmF0Y2hCYW5Vc2VycxIiLnN5bmN0di5hZG1pbi5CYXRjaE'
    'JhblVzZXJzUmVxdWVzdBojLnN5bmN0di5hZG1pbi5CYXRjaEJhblVzZXJzUmVzcG9uc2USYQoQ'
    'QmF0Y2hEZWxldGVVc2VycxIlLnN5bmN0di5hZG1pbi5CYXRjaERlbGV0ZVVzZXJzUmVxdWVzdB'
    'omLnN5bmN0di5hZG1pbi5CYXRjaERlbGV0ZVVzZXJzUmVzcG9uc2USWAoNQmF0Y2hCYW5Sb29t'
    'cxIiLnN5bmN0di5hZG1pbi5CYXRjaEJhblJvb21zUmVxdWVzdBojLnN5bmN0di5hZG1pbi5CYX'
    'RjaEJhblJvb21zUmVzcG9uc2USYQoQQmF0Y2hEZWxldGVSb29tcxIlLnN5bmN0di5hZG1pbi5C'
    'YXRjaERlbGV0ZVJvb21zUmVxdWVzdBomLnN5bmN0di5hZG1pbi5CYXRjaERlbGV0ZVJvb21zUm'
    'VzcG9uc2USTAoJTGlzdFJvb21zEh4uc3luY3R2LmFkbWluLkxpc3RSb29tc1JlcXVlc3QaHy5z'
    'eW5jdHYuYWRtaW4uTGlzdFJvb21zUmVzcG9uc2USOwoHR2V0Um9vbRIcLnN5bmN0di5hZG1pbi'
    '5HZXRSb29tUmVxdWVzdBoSLnN5bmN0di5hZG1pbi5Sb29tEl4KD0dldFJvb21TZXR0aW5ncxIk'
    'LnN5bmN0di5hZG1pbi5HZXRSb29tU2V0dGluZ3NSZXF1ZXN0GiUuc3luY3R2LmFkbWluLkdldF'
    'Jvb21TZXR0aW5nc1Jlc3BvbnNlElEKElVwZGF0ZVJvb21TZXR0aW5ncxInLnN5bmN0di5hZG1p'
    'bi5VcGRhdGVSb29tU2V0dGluZ3NSZXF1ZXN0GhIuc3luY3R2LmFkbWluLlJvb20STwoRUmVzZX'
    'RSb29tU2V0dGluZ3MSJi5zeW5jdHYuYWRtaW4uUmVzZXRSb29tU2V0dGluZ3NSZXF1ZXN0GhIu'
    'c3luY3R2LmFkbWluLlJvb20SZwoSVXBkYXRlUm9vbVBhc3N3b3JkEicuc3luY3R2LmFkbWluLl'
    'VwZGF0ZVJvb21QYXNzd29yZFJlcXVlc3QaKC5zeW5jdHYuYWRtaW4uVXBkYXRlUm9vbVBhc3N3'
    'b3JkUmVzcG9uc2USTwoKRGVsZXRlUm9vbRIfLnN5bmN0di5hZG1pbi5EZWxldGVSb29tUmVxdW'
    'VzdBogLnN5bmN0di5hZG1pbi5EZWxldGVSb29tUmVzcG9uc2USOwoHQmFuUm9vbRIcLnN5bmN0'
    'di5hZG1pbi5CYW5Sb29tUmVxdWVzdBoSLnN5bmN0di5hZG1pbi5Sb29tEj8KCVVuYmFuUm9vbR'
    'IeLnN5bmN0di5hZG1pbi5VbmJhblJvb21SZXF1ZXN0GhIuc3luY3R2LmFkbWluLlJvb20SWwoO'
    'R2V0Um9vbU1lbWJlcnMSIy5zeW5jdHYuYWRtaW4uR2V0Um9vbU1lbWJlcnNSZXF1ZXN0GiQuc3'
    'luY3R2LmFkbWluLkdldFJvb21NZW1iZXJzUmVzcG9uc2USRgoJQWRkTWVtYmVyEh4uc3luY3R2'
    'LmFkbWluLkFkZE1lbWJlclJlcXVlc3QaGS5zeW5jdHYuY29tbW9uLlJvb21NZW1iZXISYAoWVX'
    'BkYXRlTWVtYmVyUmVtYXJrTmFtZRIrLnN5bmN0di5hZG1pbi5VcGRhdGVNZW1iZXJSZW1hcmtO'
    'YW1lUmVxdWVzdBoZLnN5bmN0di5jb21tb24uUm9vbU1lbWJlchJgChZVcGRhdGVNZW1iZXJEaX'
    'NwbGF5VGFnEisuc3luY3R2LmFkbWluLlVwZGF0ZU1lbWJlckRpc3BsYXlUYWdSZXF1ZXN0Ghku'
    'c3luY3R2LmNvbW1vbi5Sb29tTWVtYmVyEmIKF1VwZGF0ZU1lbWJlclBlcm1pc3Npb25zEiwuc3'
    'luY3R2LmFkbWluLlVwZGF0ZU1lbWJlclBlcm1pc3Npb25zUmVxdWVzdBoZLnN5bmN0di5jb21t'
    'b24uUm9vbU1lbWJlchJPCgpLaWNrTWVtYmVyEh8uc3luY3R2LmFkbWluLktpY2tNZW1iZXJSZX'
    'F1ZXN0GiAuc3luY3R2LmFkbWluLktpY2tNZW1iZXJSZXNwb25zZRJnChJMaXN0Um9vbUNhdGVn'
    'b3JpZXMSJy5zeW5jdHYuYWRtaW4uTGlzdFJvb21DYXRlZ29yaWVzUmVxdWVzdBooLnN5bmN0di'
    '5hZG1pbi5MaXN0Um9vbUNhdGVnb3JpZXNSZXNwb25zZRJaChJVcHNlcnRSb29tQ2F0ZWdvcnkS'
    'Jy5zeW5jdHYuYWRtaW4uVXBzZXJ0Um9vbUNhdGVnb3J5UmVxdWVzdBobLnN5bmN0di5jbGllbn'
    'QuUm9vbUNhdGVnb3J5EmcKEkRlbGV0ZVJvb21DYXRlZ29yeRInLnN5bmN0di5hZG1pbi5EZWxl'
    'dGVSb29tQ2F0ZWdvcnlSZXF1ZXN0Giguc3luY3R2LmFkbWluLkRlbGV0ZVJvb21DYXRlZ29yeV'
    'Jlc3BvbnNlElsKDkxpc3RSb29tTGFiZWxzEiMuc3luY3R2LmFkbWluLkxpc3RSb29tTGFiZWxz'
    'UmVxdWVzdBokLnN5bmN0di5hZG1pbi5MaXN0Um9vbUxhYmVsc1Jlc3BvbnNlElEKD1Vwc2VydF'
    'Jvb21MYWJlbBIkLnN5bmN0di5hZG1pbi5VcHNlcnRSb29tTGFiZWxSZXF1ZXN0Ghguc3luY3R2'
    'LmNsaWVudC5Sb29tTGFiZWwSXgoPRGVsZXRlUm9vbUxhYmVsEiQuc3luY3R2LmFkbWluLkRlbG'
    'V0ZVJvb21MYWJlbFJlcXVlc3QaJS5zeW5jdHYuYWRtaW4uRGVsZXRlUm9vbUxhYmVsUmVzcG9u'
    'c2USUQoSVXBkYXRlUm9vbVRheG9ub215Eicuc3luY3R2LmFkbWluLlVwZGF0ZVJvb21UYXhvbm'
    '9teVJlcXVlc3QaEi5zeW5jdHYuYWRtaW4uUm9vbRJCCghBZGRBZG1pbhIdLnN5bmN0di5hZG1p'
    'bi5BZGRBZG1pblJlcXVlc3QaFy5zeW5jdHYuYWRtaW4uQWRtaW5Vc2VyElIKC1JlbW92ZUFkbW'
    'luEiAuc3luY3R2LmFkbWluLlJlbW92ZUFkbWluUmVxdWVzdBohLnN5bmN0di5hZG1pbi5SZW1v'
    'dmVBZG1pblJlc3BvbnNlEk8KCkxpc3RBZG1pbnMSHy5zeW5jdHYuYWRtaW4uTGlzdEFkbWluc1'
    'JlcXVlc3QaIC5zeW5jdHYuYWRtaW4uTGlzdEFkbWluc1Jlc3BvbnNlEl4KD0dldFNlcnZpY2VT'
    'dGF0ZRIkLnN5bmN0di5hZG1pbi5HZXRTZXJ2aWNlU3RhdGVSZXF1ZXN0GiUuc3luY3R2LmFkbW'
    'luLkdldFNlcnZpY2VTdGF0ZVJlc3BvbnNlEmcKEkdldFNsaWNlQ2FjaGVTdGF0cxInLnN5bmN0'
    'di5hZG1pbi5HZXRTbGljZUNhY2hlU3RhdHNSZXF1ZXN0Giguc3luY3R2LmFkbWluLkdldFNsaW'
    'NlQ2FjaGVTdGF0c1Jlc3BvbnNlEl4KD1B1cmdlU2xpY2VDYWNoZRIkLnN5bmN0di5hZG1pbi5Q'
    'dXJnZVNsaWNlQ2FjaGVSZXF1ZXN0GiUuc3luY3R2LmFkbWluLlB1cmdlU2xpY2VDYWNoZVJlc3'
    'BvbnNlEnMKFkV2aWN0RXhwaXJlZFNsaWNlQ2FjaGUSKy5zeW5jdHYuYWRtaW4uRXZpY3RFeHBp'
    'cmVkU2xpY2VDYWNoZVJlcXVlc3QaLC5zeW5jdHYuYWRtaW4uRXZpY3RFeHBpcmVkU2xpY2VDYW'
    'NoZVJlc3BvbnNlEmQKEUxpc3RBY3RpdmVTdHJlYW1zEiYuc3luY3R2LmFkbWluLkxpc3RBY3Rp'
    'dmVTdHJlYW1zUmVxdWVzdBonLnN5bmN0di5hZG1pbi5MaXN0QWN0aXZlU3RyZWFtc1Jlc3Bvbn'
    'NlEk8KCktpY2tTdHJlYW0SHy5zeW5jdHYuYWRtaW4uS2lja1N0cmVhbVJlcXVlc3QaIC5zeW5j'
    'dHYuYWRtaW4uS2lja1N0cmVhbVJlc3BvbnNlEoIBChtMaXN0VXNlclJlZ2lzdHJhdGlvblJldm'
    'lld3MSMC5zeW5jdHYuYWRtaW4uTGlzdFVzZXJSZWdpc3RyYXRpb25SZXZpZXdzUmVxdWVzdBox'
    'LnN5bmN0di5hZG1pbi5MaXN0VXNlclJlZ2lzdHJhdGlvblJldmlld3NSZXNwb25zZRKIAQodQX'
    'Bwcm92ZVVzZXJSZWdpc3RyYXRpb25SZXZpZXcSMi5zeW5jdHYuYWRtaW4uQXBwcm92ZVVzZXJS'
    'ZWdpc3RyYXRpb25SZXZpZXdSZXF1ZXN0GjMuc3luY3R2LmFkbWluLkFwcHJvdmVVc2VyUmVnaX'
    'N0cmF0aW9uUmV2aWV3UmVzcG9uc2USdwocUmVqZWN0VXNlclJlZ2lzdHJhdGlvblJldmlldxIx'
    'LnN5bmN0di5hZG1pbi5SZWplY3RVc2VyUmVnaXN0cmF0aW9uUmV2aWV3UmVxdWVzdBokLnN5bm'
    'N0di5hZG1pbi5Vc2VyUmVnaXN0cmF0aW9uUmV2aWV3EnYKF0xpc3RSb29tQ3JlYXRpb25SZXZp'
    'ZXdzEiwuc3luY3R2LmFkbWluLkxpc3RSb29tQ3JlYXRpb25SZXZpZXdzUmVxdWVzdBotLnN5bm'
    'N0di5hZG1pbi5MaXN0Um9vbUNyZWF0aW9uUmV2aWV3c1Jlc3BvbnNlEnwKGUFwcHJvdmVSb29t'
    'Q3JlYXRpb25SZXZpZXcSLi5zeW5jdHYuYWRtaW4uQXBwcm92ZVJvb21DcmVhdGlvblJldmlld1'
    'JlcXVlc3QaLy5zeW5jdHYuYWRtaW4uQXBwcm92ZVJvb21DcmVhdGlvblJldmlld1Jlc3BvbnNl'
    'EmsKGFJlamVjdFJvb21DcmVhdGlvblJldmlldxItLnN5bmN0di5hZG1pbi5SZWplY3RSb29tQ3'
    'JlYXRpb25SZXZpZXdSZXF1ZXN0GiAuc3luY3R2LmFkbWluLlJvb21DcmVhdGlvblJldmlldxJq'
    'ChNMaXN0Um9vbUpvaW5SZXZpZXdzEiguc3luY3R2LmFkbWluLkxpc3RSb29tSm9pblJldmlld3'
    'NSZXF1ZXN0Gikuc3luY3R2LmFkbWluLkxpc3RSb29tSm9pblJldmlld3NSZXNwb25zZRJwChVB'
    'cHByb3ZlUm9vbUpvaW5SZXZpZXcSKi5zeW5jdHYuYWRtaW4uQXBwcm92ZVJvb21Kb2luUmV2aW'
    'V3UmVxdWVzdBorLnN5bmN0di5hZG1pbi5BcHByb3ZlUm9vbUpvaW5SZXZpZXdSZXNwb25zZRJf'
    'ChRSZWplY3RSb29tSm9pblJldmlldxIpLnN5bmN0di5hZG1pbi5SZWplY3RSb29tSm9pblJldm'
    'lld1JlcXVlc3QaHC5zeW5jdHYuYWRtaW4uUm9vbUpvaW5SZXZpZXcSWwoOTGlzdEJhblJlY29y'
    'ZHMSIy5zeW5jdHYuYWRtaW4uTGlzdEJhblJlY29yZHNSZXF1ZXN0GiQuc3luY3R2LmFkbWluLk'
    'xpc3RCYW5SZWNvcmRzUmVzcG9uc2USZwoSTGlzdENvbnRlbnRSZXBvcnRzEicuc3luY3R2LmFk'
    'bWluLkxpc3RDb250ZW50UmVwb3J0c1JlcXVlc3QaKC5zeW5jdHYuYWRtaW4uTGlzdENvbnRlbn'
    'RSZXBvcnRzUmVzcG9uc2USVgoQR2V0Q29udGVudFJlcG9ydBIlLnN5bmN0di5hZG1pbi5HZXRD'
    'b250ZW50UmVwb3J0UmVxdWVzdBobLnN5bmN0di5hZG1pbi5Db250ZW50UmVwb3J0EnwKGVVwZG'
    'F0ZUNvbnRlbnRSZXBvcnRTdGF0dXMSLi5zeW5jdHYuYWRtaW4uVXBkYXRlQ29udGVudFJlcG9y'
    'dFN0YXR1c1JlcXVlc3QaLy5zeW5jdHYuYWRtaW4uVXBkYXRlQ29udGVudFJlcG9ydFN0YXR1c1'
    'Jlc3BvbnNl');
