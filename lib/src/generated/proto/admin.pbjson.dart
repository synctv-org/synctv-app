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
    'cmVhc29uGAsgASgJUgxiYW5uZWRSZWFzb24=');

@$core.Deprecated('Use adminRoomDescriptor instead')
const AdminRoom$json = {
  '1': 'AdminRoom',
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
    {'1': 'settings', '3': 6, '4': 1, '5': 12, '10': 'settings'},
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
  ],
};

/// Descriptor for `AdminRoom`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminRoomDescriptor = $convert.base64Decode(
    'CglBZG1pblJvb20SDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSHQoKY3JlYX'
    'Rvcl9pZBgDIAEoCVIJY3JlYXRvcklkEikKEGNyZWF0b3JfdXNlcm5hbWUYBCABKAlSD2NyZWF0'
    'b3JVc2VybmFtZRIxCgZzdGF0dXMYBSABKA4yGS5zeW5jdHYuY29tbW9uLlJvb21TdGF0dXNSBn'
    'N0YXR1cxIaCghzZXR0aW5ncxgGIAEoDFIIc2V0dGluZ3MSIQoMbWVtYmVyX2NvdW50GAcgASgF'
    'UgttZW1iZXJDb3VudBIdCgpjcmVhdGVkX2F0GAggASgDUgljcmVhdGVkQXQSHQoKdXBkYXRlZF'
    '9hdBgJIAEoA1IJdXBkYXRlZEF0EiAKC2Rlc2NyaXB0aW9uGAogASgJUgtkZXNjcmlwdGlvbhIb'
    'Cglpc19iYW5uZWQYCyABKAhSCGlzQmFubmVkEkAKDmNyZWF0b3Jfc3RhdHVzGAwgASgOMhkuc3'
    'luY3R2LmNvbW1vbi5Vc2VyU3RhdHVzUg1jcmVhdG9yU3RhdHVzEhgKB3ZlcnNpb24YDSABKANS'
    'B3ZlcnNpb24=');

@$core.Deprecated('Use settingsGroupDescriptor instead')
const SettingsGroup$json = {
  '1': 'SettingsGroup',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'settings', '3': 2, '4': 1, '5': 12, '10': 'settings'},
  ],
};

/// Descriptor for `SettingsGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsGroupDescriptor = $convert.base64Decode(
    'Cg1TZXR0aW5nc0dyb3VwEhIKBG5hbWUYASABKAlSBG5hbWUSGgoIc2V0dGluZ3MYAiABKAxSCH'
    'NldHRpbmdz');

@$core.Deprecated('Use userRegistrationReviewDescriptor instead')
const UserRegistrationReview$json = {
  '1': 'UserRegistrationReview',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'signup_method', '3': 4, '4': 1, '5': 5, '10': 'signupMethod'},
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
    {'1': 'reviewed_by', '3': 8, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'rejection_reason', '3': 9, '4': 1, '5': 9, '10': 'rejectionReason'},
    {'1': 'oauth2_provider', '3': 10, '4': 1, '5': 9, '10': 'oauth2Provider'},
    {
      '1': 'oauth2_provider_user_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'oauth2ProviderUserId'
    },
    {
      '1': 'oauth2_provider_username',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'oauth2ProviderUsername'
    },
    {
      '1': 'oauth2_avatar_url',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'oauth2AvatarUrl'
    },
    {
      '1': 'oauth2_email_verified',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'oauth2EmailVerified'
    },
    {
      '1': 'oauth2_provider_instance_name',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'oauth2ProviderInstanceName'
    },
    {
      '1': 'oauth2_provider_issuer',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'oauth2ProviderIssuer'
    },
    {
      '1': 'webauthn_credential_id',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'webauthnCredentialId'
    },
    {
      '1': 'webauthn_credential_name',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'webauthnCredentialName'
    },
  ],
};

/// Descriptor for `UserRegistrationReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userRegistrationReviewDescriptor = $convert.base64Decode(
    'ChZVc2VyUmVnaXN0cmF0aW9uUmV2aWV3Eg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIA'
    'EoCVIIdXNlcm5hbWUSFAoFZW1haWwYAyABKAlSBWVtYWlsEiMKDXNpZ251cF9tZXRob2QYBCAB'
    'KAVSDHNpZ251cE1ldGhvZBIzCgZzdGF0dXMYBSABKA4yGy5zeW5jdHYuY29tbW9uLlJldmlld1'
    'N0YXR1c1IGc3RhdHVzEiEKDHJlcXVlc3RlZF9hdBgGIAEoA1ILcmVxdWVzdGVkQXQSHwoLcmV2'
    'aWV3ZWRfYXQYByABKANSCnJldmlld2VkQXQSHwoLcmV2aWV3ZWRfYnkYCCABKAlSCnJldmlld2'
    'VkQnkSKQoQcmVqZWN0aW9uX3JlYXNvbhgJIAEoCVIPcmVqZWN0aW9uUmVhc29uEicKD29hdXRo'
    'Ml9wcm92aWRlchgKIAEoCVIOb2F1dGgyUHJvdmlkZXISNQoXb2F1dGgyX3Byb3ZpZGVyX3VzZX'
    'JfaWQYCyABKAlSFG9hdXRoMlByb3ZpZGVyVXNlcklkEjgKGG9hdXRoMl9wcm92aWRlcl91c2Vy'
    'bmFtZRgMIAEoCVIWb2F1dGgyUHJvdmlkZXJVc2VybmFtZRIqChFvYXV0aDJfYXZhdGFyX3VybB'
    'gNIAEoCVIPb2F1dGgyQXZhdGFyVXJsEjIKFW9hdXRoMl9lbWFpbF92ZXJpZmllZBgOIAEoCFIT'
    'b2F1dGgyRW1haWxWZXJpZmllZBJBCh1vYXV0aDJfcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgPIA'
    'EoCVIab2F1dGgyUHJvdmlkZXJJbnN0YW5jZU5hbWUSNAoWb2F1dGgyX3Byb3ZpZGVyX2lzc3Vl'
    'chgQIAEoCVIUb2F1dGgyUHJvdmlkZXJJc3N1ZXISNAoWd2ViYXV0aG5fY3JlZGVudGlhbF9pZB'
    'gRIAEoCVIUd2ViYXV0aG5DcmVkZW50aWFsSWQSOAoYd2ViYXV0aG5fY3JlZGVudGlhbF9uYW1l'
    'GBIgASgJUhZ3ZWJhdXRobkNyZWRlbnRpYWxOYW1l');

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
    {'1': 'reviewed_by', '3': 9, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'rejection_reason', '3': 10, '4': 1, '5': 9, '10': 'rejectionReason'},
  ],
};

/// Descriptor for `RoomCreationReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomCreationReviewDescriptor = $convert.base64Decode(
    'ChJSb29tQ3JlYXRpb25SZXZpZXcSDgoCaWQYASABKAlSAmlkEiEKDHJlcXVlc3RlZF9ieRgCIA'
    'EoCVILcmVxdWVzdGVkQnkSMgoVcmVxdWVzdGVkX2J5X3VzZXJuYW1lGAMgASgJUhNyZXF1ZXN0'
    'ZWRCeVVzZXJuYW1lEhIKBG5hbWUYBCABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2'
    'Rlc2NyaXB0aW9uEjMKBnN0YXR1cxgGIAEoDjIbLnN5bmN0di5jb21tb24uUmV2aWV3U3RhdHVz'
    'UgZzdGF0dXMSIQoMcmVxdWVzdGVkX2F0GAcgASgDUgtyZXF1ZXN0ZWRBdBIfCgtyZXZpZXdlZF'
    '9hdBgIIAEoA1IKcmV2aWV3ZWRBdBIfCgtyZXZpZXdlZF9ieRgJIAEoCVIKcmV2aWV3ZWRCeRIp'
    'ChByZWplY3Rpb25fcmVhc29uGAogASgJUg9yZWplY3Rpb25SZWFzb24=');

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
    {'1': 'reviewed_by', '3': 10, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'rejection_reason', '3': 11, '4': 1, '5': 9, '10': 'rejectionReason'},
  ],
};

/// Descriptor for `RoomJoinReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomJoinReviewDescriptor = $convert.base64Decode(
    'Cg5Sb29tSm9pblJldmlldxIOCgJpZBgBIAEoCVICaWQSFwoHcm9vbV9pZBgCIAEoCVIGcm9vbU'
    'lkEhsKCXJvb21fbmFtZRgDIAEoCVIIcm9vbU5hbWUSFwoHdXNlcl9pZBgEIAEoCVIGdXNlcklk'
    'EhoKCHVzZXJuYW1lGAUgASgJUgh1c2VybmFtZRJECg5yZXF1ZXN0ZWRfcm9sZRgGIAEoDjIdLn'
    'N5bmN0di5jb21tb24uUm9vbU1lbWJlclJvbGVSDXJlcXVlc3RlZFJvbGUSMwoGc3RhdHVzGAcg'
    'ASgOMhsuc3luY3R2LmNvbW1vbi5SZXZpZXdTdGF0dXNSBnN0YXR1cxIhCgxyZXF1ZXN0ZWRfYX'
    'QYCCABKANSC3JlcXVlc3RlZEF0Eh8KC3Jldmlld2VkX2F0GAkgASgDUgpyZXZpZXdlZEF0Eh8K'
    'C3Jldmlld2VkX2J5GAogASgJUgpyZXZpZXdlZEJ5EikKEHJlamVjdGlvbl9yZWFzb24YCyABKA'
    'lSD3JlamVjdGlvblJlYXNvbg==');

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

@$core.Deprecated('Use getSettingsRequestDescriptor instead')
const GetSettingsRequest$json = {
  '1': 'GetSettingsRequest',
};

/// Descriptor for `GetSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsRequestDescriptor =
    $convert.base64Decode('ChJHZXRTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use getSettingsResponseDescriptor instead')
const GetSettingsResponse$json = {
  '1': 'GetSettingsResponse',
  '2': [
    {
      '1': 'groups',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.SettingsGroup',
      '10': 'groups'
    },
  ],
};

/// Descriptor for `GetSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRTZXR0aW5nc1Jlc3BvbnNlEjMKBmdyb3VwcxgBIAMoCzIbLnN5bmN0di5hZG1pbi5TZX'
    'R0aW5nc0dyb3VwUgZncm91cHM=');

@$core.Deprecated('Use getSettingsGroupRequestDescriptor instead')
const GetSettingsGroupRequest$json = {
  '1': 'GetSettingsGroupRequest',
  '2': [
    {'1': 'group', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'group'},
  ],
};

/// Descriptor for `GetSettingsGroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsGroupRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRTZXR0aW5nc0dyb3VwUmVxdWVzdBIxCgVncm91cBgBIAEoCUIbukgYchYQARhAMhBeW0'
        'EtWmEtejAtOV8tXSskUgVncm91cA==');

@$core.Deprecated('Use getSettingsGroupResponseDescriptor instead')
const GetSettingsGroupResponse$json = {
  '1': 'GetSettingsGroupResponse',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SettingsGroup',
      '10': 'group'
    },
  ],
};

/// Descriptor for `GetSettingsGroupResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingsGroupResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRTZXR0aW5nc0dyb3VwUmVzcG9uc2USMQoFZ3JvdXAYASABKAsyGy5zeW5jdHYuYWRtaW'
        '4uU2V0dGluZ3NHcm91cFIFZ3JvdXA=');

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest$json = {
  '1': 'UpdateSettingsRequest',
  '2': [
    {'1': 'group', '3': 1, '4': 1, '5': 9, '10': 'group'},
    {
      '1': 'settings',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.UpdateSettingsRequest.SettingsEntry',
      '10': 'settings'
    },
  ],
  '3': [UpdateSettingsRequest_SettingsEntry$json],
};

@$core.Deprecated('Use updateSettingsRequestDescriptor instead')
const UpdateSettingsRequest_SettingsEntry$json = {
  '1': 'SettingsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UpdateSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nc1JlcXVlc3QSFAoFZ3JvdXAYASABKAlSBWdyb3VwEk0KCHNldHRpbm'
    'dzGAIgAygLMjEuc3luY3R2LmFkbWluLlVwZGF0ZVNldHRpbmdzUmVxdWVzdC5TZXR0aW5nc0Vu'
    'dHJ5UghzZXR0aW5ncxo7Cg1TZXR0aW5nc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbH'
    'VlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use updateSettingsResponseDescriptor instead')
const UpdateSettingsResponse$json = {
  '1': 'UpdateSettingsResponse',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.SettingsGroup',
      '10': 'group'
    },
  ],
};

/// Descriptor for `UpdateSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVTZXR0aW5nc1Jlc3BvbnNlEjEKBWdyb3VwGAEgASgLMhsuc3luY3R2LmFkbWluLl'
        'NldHRpbmdzR3JvdXBSBWdyb3Vw');

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
    {'1': 'password', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '8': {},
      '10': 'role'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '8': {},
      '10': 'status'
    },
  ],
};

/// Descriptor for `CreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVVc2VyUmVxdWVzdBI4Cgh1c2VybmFtZRgBIAEoCUIcukgZchcQAxgyMhFeW1xwe0'
    'x9XHB7Tn1fLV0rJFIIdXNlcm5hbWUSJgoIcGFzc3dvcmQYAiABKAlCCrpIB3IFEAgYgAFSCHBh'
    'c3N3b3JkEiMKBWVtYWlsGAMgASgJQg26SApyBRj+AWAB2AEBUgVlbWFpbBI1CgRyb2xlGAQgAS'
    'gOMhcuc3luY3R2LmNvbW1vbi5Vc2VyUm9sZUIIukgFggECEAFSBHJvbGUSOwoGc3RhdHVzGAUg'
    'ASgOMhkuc3luY3R2LmNvbW1vbi5Vc2VyU3RhdHVzQgi6SAWCAQIQAVIGc3RhdHVz');

@$core.Deprecated('Use createUserResponseDescriptor instead')
const CreateUserResponse$json = {
  '1': 'CreateUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `CreateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVVc2VyUmVzcG9uc2USKwoEdXNlchgBIAEoCzIXLnN5bmN0di5hZG1pbi5BZG1pbl'
    'VzZXJSBHVzZXI=');

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

@$core.Deprecated('Use getUserResponseDescriptor instead')
const GetUserResponse$json = {
  '1': 'GetUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `GetUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRVc2VyUmVzcG9uc2USKwoEdXNlchgBIAEoCzIXLnN5bmN0di5hZG1pbi5BZG1pblVzZX'
    'JSBHVzZXI=');

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

@$core.Deprecated('Use updateUserPasswordRequestDescriptor instead')
const UpdateUserPasswordRequest$json = {
  '1': 'UpdateUserPasswordRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'new_password', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'newPassword'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'reason'},
  ],
};

/// Descriptor for `UpdateUserPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserPasswordRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVVc2VyUGFzc3dvcmRSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQD'
    'ISXnVzcl9bQS1aYS16MC05XSskUgZ1c2VySWQSLQoMbmV3X3Bhc3N3b3JkGAIgASgJQgq6SAdy'
    'BRAIGIABUgtuZXdQYXNzd29yZBIgCgZyZWFzb24YAyABKAlCCLpIBXIDGPQDUgZyZWFzb24=');

@$core.Deprecated('Use updateUserPasswordResponseDescriptor instead')
const UpdateUserPasswordResponse$json = {
  '1': 'UpdateUserPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UpdateUserPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserPasswordResponseDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVVc2VyUGFzc3dvcmRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

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

@$core.Deprecated('Use updateUserUsernameResponseDescriptor instead')
const UpdateUserUsernameResponse$json = {
  '1': 'UpdateUserUsernameResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `UpdateUserUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserUsernameResponseDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVVc2VyVXNlcm5hbWVSZXNwb25zZRIrCgR1c2VyGAEgASgLMhcuc3luY3R2LmFkbW'
        'luLkFkbWluVXNlclIEdXNlcg==');

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

@$core.Deprecated('Use updateUserRoleResponseDescriptor instead')
const UpdateUserRoleResponse$json = {
  '1': 'UpdateUserRoleResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `UpdateUserRoleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserRoleResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVVc2VyUm9sZVJlc3BvbnNlEisKBHVzZXIYASABKAsyFy5zeW5jdHYuYWRtaW4uQW'
        'RtaW5Vc2VyUgR1c2Vy');

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

@$core.Deprecated('Use banUserResponseDescriptor instead')
const BanUserResponse$json = {
  '1': 'BanUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `BanUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banUserResponseDescriptor = $convert.base64Decode(
    'Cg9CYW5Vc2VyUmVzcG9uc2USKwoEdXNlchgBIAEoCzIXLnN5bmN0di5hZG1pbi5BZG1pblVzZX'
    'JSBHVzZXI=');

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

@$core.Deprecated('Use unbanUserResponseDescriptor instead')
const UnbanUserResponse$json = {
  '1': 'UnbanUserResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `UnbanUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbanUserResponseDescriptor = $convert.base64Decode(
    'ChFVbmJhblVzZXJSZXNwb25zZRIrCgR1c2VyGAEgASgLMhcuc3luY3R2LmFkbWluLkFkbWluVX'
    'NlclIEdXNlcg==');

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
      '6': '.synctv.admin.AdminRoom',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `GetUserRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserRoomsResponseDescriptor = $convert.base64Decode(
    'ChRHZXRVc2VyUm9vbXNSZXNwb25zZRItCgVyb29tcxgBIAMoCzIXLnN5bmN0di5hZG1pbi5BZG'
    '1pblJvb21SBXJvb21zEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

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

@$core.Deprecated('Use rejectUserRegistrationReviewResponseDescriptor instead')
const RejectUserRegistrationReviewResponse$json = {
  '1': 'RejectUserRegistrationReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.UserRegistrationReview',
      '10': 'review'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RejectUserRegistrationReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectUserRegistrationReviewResponseDescriptor =
    $convert.base64Decode(
        'CiRSZWplY3RVc2VyUmVnaXN0cmF0aW9uUmV2aWV3UmVzcG9uc2USPAoGcmV2aWV3GAEgASgLMi'
        'Quc3luY3R2LmFkbWluLlVzZXJSZWdpc3RyYXRpb25SZXZpZXdSBnJldmlldxIYCgdzdWNjZXNz'
        'GAIgASgIUgdzdWNjZXNz');

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
      '6': '.synctv.admin.AdminRoom',
      '10': 'room'
    },
  ],
};

/// Descriptor for `ApproveRoomCreationReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRoomCreationReviewResponseDescriptor =
    $convert.base64Decode(
        'CiFBcHByb3ZlUm9vbUNyZWF0aW9uUmV2aWV3UmVzcG9uc2USOAoGcmV2aWV3GAEgASgLMiAuc3'
        'luY3R2LmFkbWluLlJvb21DcmVhdGlvblJldmlld1IGcmV2aWV3EisKBHJvb20YAiABKAsyFy5z'
        'eW5jdHYuYWRtaW4uQWRtaW5Sb29tUgRyb29t');

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

@$core.Deprecated('Use rejectRoomCreationReviewResponseDescriptor instead')
const RejectRoomCreationReviewResponse$json = {
  '1': 'RejectRoomCreationReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomCreationReview',
      '10': 'review'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RejectRoomCreationReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectRoomCreationReviewResponseDescriptor =
    $convert.base64Decode(
        'CiBSZWplY3RSb29tQ3JlYXRpb25SZXZpZXdSZXNwb25zZRI4CgZyZXZpZXcYASABKAsyIC5zeW'
        '5jdHYuYWRtaW4uUm9vbUNyZWF0aW9uUmV2aWV3UgZyZXZpZXcSGAoHc3VjY2VzcxgCIAEoCFIH'
        'c3VjY2Vzcw==');

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

@$core.Deprecated('Use rejectRoomJoinReviewResponseDescriptor instead')
const RejectRoomJoinReviewResponse$json = {
  '1': 'RejectRoomJoinReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.RoomJoinReview',
      '10': 'review'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RejectRoomJoinReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectRoomJoinReviewResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWplY3RSb29tSm9pblJldmlld1Jlc3BvbnNlEjQKBnJldmlldxgBIAEoCzIcLnN5bmN0di'
        '5hZG1pbi5Sb29tSm9pblJldmlld1IGcmV2aWV3EhgKB3N1Y2Nlc3MYAiABKAhSB3N1Y2Nlc3M=');

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
    'cnREaXJlY3Rpb25CCLpIBYIBAhABUg1zb3J0RGlyZWN0aW9uOsMDuki/Axq3AQobYWRtaW4ubG'
    'lzdF9yb29tcy5jcmVhdG9yX2lkEi9jcmVhdG9yX2lkIG11c3QgYmUgZW1wdHkgb3IgYSBwdWJs'
    'aWMgaWRlbnRpZmllchpndGhpcy5jcmVhdG9yX2lkID09ICcnIHx8IChzaXplKHRoaXMuY3JlYX'
    'Rvcl9pZCkgPD0gNjQgJiYgdGhpcy5jcmVhdG9yX2lkLm1hdGNoZXMoJ151c3JfW0EtWmEtejAt'
    'OV0rJCcpKRplChVhZG1pbi5saXN0X3Jvb21zLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZG'
    'VmYXVsdCkgb3IgYXQgbGVhc3QgMRogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEa'
    'mwEKGmFkbWluLmxpc3Rfcm9vbXMucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2'
    'UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwg'
    'KHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKUIMCgpfaXNfYm'
    'FubmVk');

@$core.Deprecated('Use listRoomsResponseDescriptor instead')
const ListRoomsResponse$json = {
  '1': 'ListRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.admin.AdminRoom',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Um9vbXNSZXNwb25zZRItCgVyb29tcxgBIAMoCzIXLnN5bmN0di5hZG1pbi5BZG1pbl'
    'Jvb21SBXJvb21zEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

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

@$core.Deprecated('Use getRoomResponseDescriptor instead')
const GetRoomResponse$json = {
  '1': 'GetRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminRoom',
      '10': 'room'
    },
  ],
};

/// Descriptor for `GetRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRSb29tUmVzcG9uc2USKwoEcm9vbRgBIAEoCzIXLnN5bmN0di5hZG1pbi5BZG1pblJvb2'
    '1SBHJvb20=');

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
    {'1': 'settings', '3': 1, '4': 1, '5': 12, '10': 'settings'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `GetRoomSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRSb29tU2V0dGluZ3NSZXNwb25zZRIaCghzZXR0aW5ncxgBIAEoDFIIc2V0dGluZ3MSGA'
        'oHdmVyc2lvbhgCIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use updateRoomSettingsRequestDescriptor instead')
const UpdateRoomSettingsRequest$json = {
  '1': 'UpdateRoomSettingsRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'settings', '3': 2, '4': 1, '5': 12, '10': 'settings'},
  ],
};

/// Descriptor for `UpdateRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomSettingsRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVSb29tU2V0dGluZ3NSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQD'
    'ITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlkEhoKCHNldHRpbmdzGAIgASgMUghzZXR0aW5n'
    'cw==');

@$core.Deprecated('Use updateRoomSettingsResponseDescriptor instead')
const UpdateRoomSettingsResponse$json = {
  '1': 'UpdateRoomSettingsResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminRoom',
      '10': 'room'
    },
  ],
};

/// Descriptor for `UpdateRoomSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVSb29tU2V0dGluZ3NSZXNwb25zZRIrCgRyb29tGAEgASgLMhcuc3luY3R2LmFkbW'
        'luLkFkbWluUm9vbVIEcm9vbQ==');

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

@$core.Deprecated('Use resetRoomSettingsResponseDescriptor instead')
const ResetRoomSettingsResponse$json = {
  '1': 'ResetRoomSettingsResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminRoom',
      '10': 'room'
    },
  ],
};

/// Descriptor for `ResetRoomSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetRoomSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXNldFJvb21TZXR0aW5nc1Jlc3BvbnNlEisKBHJvb20YASABKAsyFy5zeW5jdHYuYWRtaW'
        '4uQWRtaW5Sb29tUgRyb29t');

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

@$core.Deprecated('Use banRoomResponseDescriptor instead')
const BanRoomResponse$json = {
  '1': 'BanRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminRoom',
      '10': 'room'
    },
  ],
};

/// Descriptor for `BanRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List banRoomResponseDescriptor = $convert.base64Decode(
    'Cg9CYW5Sb29tUmVzcG9uc2USKwoEcm9vbRgBIAEoCzIXLnN5bmN0di5hZG1pbi5BZG1pblJvb2'
    '1SBHJvb20=');

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

@$core.Deprecated('Use unbanRoomResponseDescriptor instead')
const UnbanRoomResponse$json = {
  '1': 'UnbanRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminRoom',
      '10': 'room'
    },
  ],
};

/// Descriptor for `UnbanRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbanRoomResponseDescriptor = $convert.base64Decode(
    'ChFVbmJhblJvb21SZXNwb25zZRIrCgRyb29tGAEgASgLMhcuc3luY3R2LmFkbWluLkFkbWluUm'
    '9vbVIEcm9vbQ==');

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
  ],
};

/// Descriptor for `GetRoomMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRSb29tTWVtYmVyc1Jlc3BvbnNlEjMKB21lbWJlcnMYASADKAsyGS5zeW5jdHYuY29tbW'
        '9uLlJvb21NZW1iZXJSB21lbWJlcnMSFAoFdG90YWwYAiABKAVSBXRvdGFs');

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
  ],
};

/// Descriptor for `AddMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMemberRequestDescriptor = $convert.base64Decode(
    'ChBBZGRNZW1iZXJSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQDITXnJvb21fW0'
    'EtWmEtejAtOV0rJFIGcm9vbUlkEjYKB3VzZXJfaWQYAiABKAlCHbpIGnIYEAEYQDISXnVzcl9b'
    'QS1aYS16MC05XSskUgZ1c2VySWQSMQoEcm9sZRgDIAEoDjIdLnN5bmN0di5jb21tb24uUm9vbU'
    '1lbWJlclJvbGVSBHJvbGUSFgoGbm90aWZ5GAQgASgIUgZub3RpZnk=');

@$core.Deprecated('Use addMemberResponseDescriptor instead')
const AddMemberResponse$json = {
  '1': 'AddMemberResponse',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '10': 'member'
    },
  ],
};

/// Descriptor for `AddMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMemberResponseDescriptor = $convert.base64Decode(
    'ChFBZGRNZW1iZXJSZXNwb25zZRIxCgZtZW1iZXIYASABKAsyGS5zeW5jdHYuY29tbW9uLlJvb2'
    '1NZW1iZXJSBm1lbWJlcg==');

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

@$core.Deprecated('Use updateMemberPermissionsResponseDescriptor instead')
const UpdateMemberPermissionsResponse$json = {
  '1': 'UpdateMemberPermissionsResponse',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '10': 'member'
    },
  ],
};

/// Descriptor for `UpdateMemberPermissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberPermissionsResponseDescriptor =
    $convert.base64Decode(
        'Ch9VcGRhdGVNZW1iZXJQZXJtaXNzaW9uc1Jlc3BvbnNlEjEKBm1lbWJlchgBIAEoCzIZLnN5bm'
        'N0di5jb21tb24uUm9vbU1lbWJlclIGbWVtYmVy');

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

@$core.Deprecated('Use addAdminResponseDescriptor instead')
const AddAdminResponse$json = {
  '1': 'AddAdminResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.admin.AdminUser',
      '10': 'user'
    },
  ],
};

/// Descriptor for `AddAdminResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAdminResponseDescriptor = $convert.base64Decode(
    'ChBBZGRBZG1pblJlc3BvbnNlEisKBHVzZXIYASABKAsyFy5zeW5jdHYuYWRtaW4uQWRtaW5Vc2'
    'VyUgR1c2Vy');

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

@$core.Deprecated('Use getSystemStatsRequestDescriptor instead')
const GetSystemStatsRequest$json = {
  '1': 'GetSystemStatsRequest',
};

/// Descriptor for `GetSystemStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSystemStatsRequestDescriptor =
    $convert.base64Decode('ChVHZXRTeXN0ZW1TdGF0c1JlcXVlc3Q=');

@$core.Deprecated('Use getSystemStatsResponseDescriptor instead')
const GetSystemStatsResponse$json = {
  '1': 'GetSystemStatsResponse',
  '2': [
    {'1': 'total_users', '3': 1, '4': 1, '5': 5, '10': 'totalUsers'},
    {'1': 'active_users', '3': 2, '4': 1, '5': 5, '10': 'activeUsers'},
    {'1': 'banned_users', '3': 3, '4': 1, '5': 5, '10': 'bannedUsers'},
    {'1': 'total_rooms', '3': 4, '4': 1, '5': 5, '10': 'totalRooms'},
    {'1': 'active_rooms', '3': 5, '4': 1, '5': 5, '10': 'activeRooms'},
    {'1': 'banned_rooms', '3': 6, '4': 1, '5': 5, '10': 'bannedRooms'},
    {'1': 'total_media', '3': 7, '4': 1, '5': 5, '10': 'totalMedia'},
    {
      '1': 'provider_instances',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'providerInstances'
    },
    {'1': 'additional_stats', '3': 9, '4': 1, '5': 12, '10': 'additionalStats'},
  ],
};

/// Descriptor for `GetSystemStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSystemStatsResponseDescriptor = $convert.base64Decode(
    'ChZHZXRTeXN0ZW1TdGF0c1Jlc3BvbnNlEh8KC3RvdGFsX3VzZXJzGAEgASgFUgp0b3RhbFVzZX'
    'JzEiEKDGFjdGl2ZV91c2VycxgCIAEoBVILYWN0aXZlVXNlcnMSIQoMYmFubmVkX3VzZXJzGAMg'
    'ASgFUgtiYW5uZWRVc2VycxIfCgt0b3RhbF9yb29tcxgEIAEoBVIKdG90YWxSb29tcxIhCgxhY3'
    'RpdmVfcm9vbXMYBSABKAVSC2FjdGl2ZVJvb21zEiEKDGJhbm5lZF9yb29tcxgGIAEoBVILYmFu'
    'bmVkUm9vbXMSHwoLdG90YWxfbWVkaWEYByABKAVSCnRvdGFsTWVkaWESLQoScHJvdmlkZXJfaW'
    '5zdGFuY2VzGAggASgFUhFwcm92aWRlckluc3RhbmNlcxIpChBhZGRpdGlvbmFsX3N0YXRzGAkg'
    'ASgMUg9hZGRpdGlvbmFsU3RhdHM=');

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
