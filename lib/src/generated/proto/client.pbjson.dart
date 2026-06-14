// This is a generated file - do not edit.
//
// Generated from proto/client.proto.

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

import 'common.pbjson.dart' as $0;

@$core.Deprecated('Use resourceAvailabilityDescriptor instead')
const ResourceAvailability$json = {
  '1': 'ResourceAvailability',
  '2': [
    {'1': 'RESOURCE_AVAILABILITY_UNSPECIFIED', '2': 0},
    {'1': 'RESOURCE_AVAILABILITY_AVAILABLE', '2': 1},
    {'1': 'RESOURCE_AVAILABILITY_CREATOR_INACTIVE', '2': 2},
  ],
};

/// Descriptor for `ResourceAvailability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceAvailabilityDescriptor = $convert.base64Decode(
    'ChRSZXNvdXJjZUF2YWlsYWJpbGl0eRIlCiFSRVNPVVJDRV9BVkFJTEFCSUxJVFlfVU5TUEVDSU'
    'ZJRUQQABIjCh9SRVNPVVJDRV9BVkFJTEFCSUxJVFlfQVZBSUxBQkxFEAESKgomUkVTT1VSQ0Vf'
    'QVZBSUxBQklMSVRZX0NSRUFUT1JfSU5BQ1RJVkUQAg==');

@$core.Deprecated('Use resourceAvailabilityFilterDescriptor instead')
const ResourceAvailabilityFilter$json = {
  '1': 'ResourceAvailabilityFilter',
  '2': [
    {'1': 'RESOURCE_AVAILABILITY_FILTER_ALL', '2': 0},
    {'1': 'RESOURCE_AVAILABILITY_FILTER_AVAILABLE', '2': 1},
    {'1': 'RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE', '2': 2},
  ],
};

/// Descriptor for `ResourceAvailabilityFilter`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceAvailabilityFilterDescriptor =
    $convert.base64Decode(
        'ChpSZXNvdXJjZUF2YWlsYWJpbGl0eUZpbHRlchIkCiBSRVNPVVJDRV9BVkFJTEFCSUxJVFlfRk'
        'lMVEVSX0FMTBAAEioKJlJFU09VUkNFX0FWQUlMQUJJTElUWV9GSUxURVJfQVZBSUxBQkxFEAES'
        'LAooUkVTT1VSQ0VfQVZBSUxBQklMSVRZX0ZJTFRFUl9VTkFWQUlMQUJMRRAC');

@$core.Deprecated('Use registrationStatusDescriptor instead')
const RegistrationStatus$json = {
  '1': 'RegistrationStatus',
  '2': [
    {'1': 'REGISTRATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REGISTRATION_STATUS_REGISTERED', '2': 1},
    {'1': 'REGISTRATION_STATUS_PENDING_REVIEW', '2': 2},
  ],
};

/// Descriptor for `RegistrationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List registrationStatusDescriptor = $convert.base64Decode(
    'ChJSZWdpc3RyYXRpb25TdGF0dXMSIwofUkVHSVNUUkFUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEiIKHlJFR0lTVFJBVElPTl9TVEFUVVNfUkVHSVNURVJFRBABEiYKIlJFR0lTVFJBVElPTl9T'
    'VEFUVVNfUEVORElOR19SRVZJRVcQAg==');

@$core.Deprecated('Use mfaMethodDescriptor instead')
const MfaMethod$json = {
  '1': 'MfaMethod',
  '2': [
    {'1': 'MFA_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'MFA_METHOD_PASSWORD', '2': 1},
    {'1': 'MFA_METHOD_WEBAUTHN', '2': 2},
    {'1': 'MFA_METHOD_EMAIL', '2': 3},
  ],
};

/// Descriptor for `MfaMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mfaMethodDescriptor = $convert.base64Decode(
    'CglNZmFNZXRob2QSGgoWTUZBX01FVEhPRF9VTlNQRUNJRklFRBAAEhcKE01GQV9NRVRIT0RfUE'
    'FTU1dPUkQQARIXChNNRkFfTUVUSE9EX1dFQkFVVEhOEAISFAoQTUZBX01FVEhPRF9FTUFJTBAD');

@$core.Deprecated('Use sensitiveOperationVerificationMethodDescriptor instead')
const SensitiveOperationVerificationMethod$json = {
  '1': 'SensitiveOperationVerificationMethod',
  '2': [
    {'1': 'SENSITIVE_OPERATION_VERIFICATION_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD', '2': 1},
    {'1': 'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN', '2': 2},
    {'1': 'SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL', '2': 3},
  ],
};

/// Descriptor for `SensitiveOperationVerificationMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sensitiveOperationVerificationMethodDescriptor =
    $convert.base64Decode(
        'CiRTZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25NZXRob2QSNwozU0VOU0lUSVZFX09QRV'
        'JBVElPTl9WRVJJRklDQVRJT05fTUVUSE9EX1VOU1BFQ0lGSUVEEAASNAowU0VOU0lUSVZFX09Q'
        'RVJBVElPTl9WRVJJRklDQVRJT05fTUVUSE9EX1BBU1NXT1JEEAESNAowU0VOU0lUSVZFX09QRV'
        'JBVElPTl9WRVJJRklDQVRJT05fTUVUSE9EX1dFQkFVVEhOEAISMQotU0VOU0lUSVZFX09QRVJB'
        'VElPTl9WRVJJRklDQVRJT05fTUVUSE9EX0VNQUlMEAM=');

@$core
    .Deprecated('Use opaquePasswordUpdateVerificationMethodDescriptor instead')
const OpaquePasswordUpdateVerificationMethod$json = {
  '1': 'OpaquePasswordUpdateVerificationMethod',
  '2': [
    {'1': 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_UNSPECIFIED', '2': 0},
    {
      '1': 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD',
      '2': 1
    },
    {'1': 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_EMAIL_TOKEN', '2': 2},
    {'1': 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_PASSKEY', '2': 3},
  ],
};

/// Descriptor for `OpaquePasswordUpdateVerificationMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List opaquePasswordUpdateVerificationMethodDescriptor =
    $convert.base64Decode(
        'CiZPcGFxdWVQYXNzd29yZFVwZGF0ZVZlcmlmaWNhdGlvbk1ldGhvZBI6CjZPUEFRVUVfUEFTU1'
        'dPUkRfVVBEQVRFX1ZFUklGSUNBVElPTl9NRVRIT0RfVU5TUEVDSUZJRUQQABJGCkJPUEFRVUVf'
        'UEFTU1dPUkRfVVBEQVRFX1ZFUklGSUNBVElPTl9NRVRIT0RfQ1VSUkVOVF9PUEFRVUVfUEFTU1'
        'dPUkQQARI6CjZPUEFRVUVfUEFTU1dPUkRfVVBEQVRFX1ZFUklGSUNBVElPTl9NRVRIT0RfRU1B'
        'SUxfVE9LRU4QAhI2CjJPUEFRVUVfUEFTU1dPUkRfVVBEQVRFX1ZFUklGSUNBVElPTl9NRVRIT0'
        'RfUEFTU0tFWRAD');

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

@$core.Deprecated('Use roomStreamListSortByDescriptor instead')
const RoomStreamListSortBy$json = {
  '1': 'RoomStreamListSortBy',
  '2': [
    {'1': 'ROOM_STREAM_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_STREAM_LIST_SORT_BY_MEDIA_ID', '2': 1},
  ],
};

/// Descriptor for `RoomStreamListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomStreamListSortByDescriptor = $convert.base64Decode(
    'ChRSb29tU3RyZWFtTGlzdFNvcnRCeRIoCiRST09NX1NUUkVBTV9MSVNUX1NPUlRfQllfVU5TUE'
    'VDSUZJRUQQABIlCiFST09NX1NUUkVBTV9MSVNUX1NPUlRfQllfTUVESUFfSUQQAQ==');

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

@$core.Deprecated('Use playlistListSortByDescriptor instead')
const PlaylistListSortBy$json = {
  '1': 'PlaylistListSortBy',
  '2': [
    {'1': 'PLAYLIST_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'PLAYLIST_LIST_SORT_BY_POSITION', '2': 1},
    {'1': 'PLAYLIST_LIST_SORT_BY_NAME', '2': 2},
    {'1': 'PLAYLIST_LIST_SORT_BY_CREATED_AT', '2': 3},
    {'1': 'PLAYLIST_LIST_SORT_BY_UPDATED_AT', '2': 4},
  ],
};

/// Descriptor for `PlaylistListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playlistListSortByDescriptor = $convert.base64Decode(
    'ChJQbGF5bGlzdExpc3RTb3J0QnkSJQohUExBWUxJU1RfTElTVF9TT1JUX0JZX1VOU1BFQ0lGSU'
    'VEEAASIgoeUExBWUxJU1RfTElTVF9TT1JUX0JZX1BPU0lUSU9OEAESHgoaUExBWUxJU1RfTElT'
    'VF9TT1JUX0JZX05BTUUQAhIkCiBQTEFZTElTVF9MSVNUX1NPUlRfQllfQ1JFQVRFRF9BVBADEi'
    'QKIFBMQVlMSVNUX0xJU1RfU09SVF9CWV9VUERBVEVEX0FUEAQ=');

@$core.Deprecated('Use mediaListSortByDescriptor instead')
const MediaListSortBy$json = {
  '1': 'MediaListSortBy',
  '2': [
    {'1': 'MEDIA_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'MEDIA_LIST_SORT_BY_POSITION', '2': 1},
    {'1': 'MEDIA_LIST_SORT_BY_NAME', '2': 2},
    {'1': 'MEDIA_LIST_SORT_BY_ADDED_AT', '2': 3},
    {'1': 'MEDIA_LIST_SORT_BY_UPDATED_AT', '2': 4},
    {'1': 'MEDIA_LIST_SORT_BY_SOURCE_PROVIDER', '2': 5},
    {'1': 'MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME', '2': 6},
  ],
};

/// Descriptor for `MediaListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaListSortByDescriptor = $convert.base64Decode(
    'Cg9NZWRpYUxpc3RTb3J0QnkSIgoeTUVESUFfTElTVF9TT1JUX0JZX1VOU1BFQ0lGSUVEEAASHw'
    'obTUVESUFfTElTVF9TT1JUX0JZX1BPU0lUSU9OEAESGwoXTUVESUFfTElTVF9TT1JUX0JZX05B'
    'TUUQAhIfChtNRURJQV9MSVNUX1NPUlRfQllfQURERURfQVQQAxIhCh1NRURJQV9MSVNUX1NPUl'
    'RfQllfVVBEQVRFRF9BVBAEEiYKIk1FRElBX0xJU1RfU09SVF9CWV9TT1VSQ0VfUFJPVklERVIQ'
    'BRItCilNRURJQV9MSVNUX1NPUlRfQllfUFJPVklERVJfSU5TVEFOQ0VfTkFNRRAG');

@$core.Deprecated('Use myRoomListSortByDescriptor instead')
const MyRoomListSortBy$json = {
  '1': 'MyRoomListSortBy',
  '2': [
    {'1': 'MY_ROOM_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'MY_ROOM_LIST_SORT_BY_JOINED_AT', '2': 1},
    {'1': 'MY_ROOM_LIST_SORT_BY_CREATED_AT', '2': 2},
    {'1': 'MY_ROOM_LIST_SORT_BY_UPDATED_AT', '2': 3},
    {'1': 'MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT', '2': 4},
    {'1': 'MY_ROOM_LIST_SORT_BY_NAME', '2': 5},
  ],
};

/// Descriptor for `MyRoomListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List myRoomListSortByDescriptor = $convert.base64Decode(
    'ChBNeVJvb21MaXN0U29ydEJ5EiQKIE1ZX1JPT01fTElTVF9TT1JUX0JZX1VOU1BFQ0lGSUVEEA'
    'ASIgoeTVlfUk9PTV9MSVNUX1NPUlRfQllfSk9JTkVEX0FUEAESIwofTVlfUk9PTV9MSVNUX1NP'
    'UlRfQllfQ1JFQVRFRF9BVBACEiMKH01ZX1JPT01fTElTVF9TT1JUX0JZX1VQREFURURfQVQQAx'
    'IpCiVNWV9ST09NX0xJU1RfU09SVF9CWV9MQVNUX0FDVElWSVRZX0FUEAQSHQoZTVlfUk9PTV9M'
    'SVNUX1NPUlRfQllfTkFNRRAF');

@$core.Deprecated('Use myRoomRelationDescriptor instead')
const MyRoomRelation$json = {
  '1': 'MyRoomRelation',
  '2': [
    {'1': 'MY_ROOM_RELATION_UNSPECIFIED', '2': 0},
    {'1': 'MY_ROOM_RELATION_ALL', '2': 1},
    {'1': 'MY_ROOM_RELATION_CREATED', '2': 2},
    {'1': 'MY_ROOM_RELATION_PARTICIPATING', '2': 3},
  ],
};

/// Descriptor for `MyRoomRelation`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List myRoomRelationDescriptor = $convert.base64Decode(
    'Cg5NeVJvb21SZWxhdGlvbhIgChxNWV9ST09NX1JFTEFUSU9OX1VOU1BFQ0lGSUVEEAASGAoUTV'
    'lfUk9PTV9SRUxBVElPTl9BTEwQARIcChhNWV9ST09NX1JFTEFUSU9OX0NSRUFURUQQAhIiCh5N'
    'WV9ST09NX1JFTEFUSU9OX1BBUlRJQ0lQQVRJTkcQAw==');

@$core.Deprecated('Use notificationListSortByDescriptor instead')
const NotificationListSortBy$json = {
  '1': 'NotificationListSortBy',
  '2': [
    {'1': 'NOTIFICATION_LIST_SORT_BY_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_LIST_SORT_BY_CREATED_AT', '2': 1},
    {'1': 'NOTIFICATION_LIST_SORT_BY_UPDATED_AT', '2': 2},
    {'1': 'NOTIFICATION_LIST_SORT_BY_TITLE', '2': 3},
  ],
};

/// Descriptor for `NotificationListSortBy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationListSortByDescriptor = $convert.base64Decode(
    'ChZOb3RpZmljYXRpb25MaXN0U29ydEJ5EikKJU5PVElGSUNBVElPTl9MSVNUX1NPUlRfQllfVU'
    '5TUEVDSUZJRUQQABIoCiROT1RJRklDQVRJT05fTElTVF9TT1JUX0JZX0NSRUFURURfQVQQARIo'
    'CiROT1RJRklDQVRJT05fTElTVF9TT1JUX0JZX1VQREFURURfQVQQAhIjCh9OT1RJRklDQVRJT0'
    '5fTElTVF9TT1JUX0JZX1RJVExFEAM=');

@$core.Deprecated('Use itemTypeDescriptor instead')
const ItemType$json = {
  '1': 'ItemType',
  '2': [
    {'1': 'ITEM_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ITEM_TYPE_PLAYLIST', '2': 1},
    {'1': 'ITEM_TYPE_MEDIA', '2': 2},
  ],
};

/// Descriptor for `ItemType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List itemTypeDescriptor = $convert.base64Decode(
    'CghJdGVtVHlwZRIZChVJVEVNX1RZUEVfVU5TUEVDSUZJRUQQABIWChJJVEVNX1RZUEVfUExBWU'
    'xJU1QQARITCg9JVEVNX1RZUEVfTUVESUEQAg==');

@$core.Deprecated('Use playbackUpdateTypeDescriptor instead')
const PlaybackUpdateType$json = {
  '1': 'PlaybackUpdateType',
  '2': [
    {'1': 'PLAYBACK_UPDATE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_UPDATE_TYPE_PLAY', '2': 1},
    {'1': 'PLAYBACK_UPDATE_TYPE_PAUSE', '2': 2},
    {'1': 'PLAYBACK_UPDATE_TYPE_SEEK', '2': 3},
    {'1': 'PLAYBACK_UPDATE_TYPE_SPEED', '2': 4},
  ],
};

/// Descriptor for `PlaybackUpdateType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackUpdateTypeDescriptor = $convert.base64Decode(
    'ChJQbGF5YmFja1VwZGF0ZVR5cGUSJAogUExBWUJBQ0tfVVBEQVRFX1RZUEVfVU5TUEVDSUZJRU'
    'QQABIdChlQTEFZQkFDS19VUERBVEVfVFlQRV9QTEFZEAESHgoaUExBWUJBQ0tfVVBEQVRFX1RZ'
    'UEVfUEFVU0UQAhIdChlQTEFZQkFDS19VUERBVEVfVFlQRV9TRUVLEAMSHgoaUExBWUJBQ0tfVV'
    'BEQVRFX1RZUEVfU1BFRUQQBA==');

@$core.Deprecated('Use playbackDeliveryPreferenceDescriptor instead')
const PlaybackDeliveryPreference$json = {
  '1': 'PlaybackDeliveryPreference',
  '2': [
    {'1': 'PLAYBACK_DELIVERY_PREFERENCE_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_DELIVERY_PREFERENCE_AUTO', '2': 1},
    {'1': 'PLAYBACK_DELIVERY_PREFERENCE_DIRECT_PLAY', '2': 2},
    {'1': 'PLAYBACK_DELIVERY_PREFERENCE_TRANSCODE', '2': 3},
  ],
};

/// Descriptor for `PlaybackDeliveryPreference`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackDeliveryPreferenceDescriptor = $convert.base64Decode(
    'ChpQbGF5YmFja0RlbGl2ZXJ5UHJlZmVyZW5jZRIsCihQTEFZQkFDS19ERUxJVkVSWV9QUkVGRV'
    'JFTkNFX1VOU1BFQ0lGSUVEEAASJQohUExBWUJBQ0tfREVMSVZFUllfUFJFRkVSRU5DRV9BVVRP'
    'EAESLAooUExBWUJBQ0tfREVMSVZFUllfUFJFRkVSRU5DRV9ESVJFQ1RfUExBWRACEioKJlBMQV'
    'lCQUNLX0RFTElWRVJZX1BSRUZFUkVOQ0VfVFJBTlNDT0RFEAM=');

@$core.Deprecated('Use playbackSubtitlePreferenceDescriptor instead')
const PlaybackSubtitlePreference$json = {
  '1': 'PlaybackSubtitlePreference',
  '2': [
    {'1': 'PLAYBACK_SUBTITLE_PREFERENCE_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL', '2': 1},
    {'1': 'PLAYBACK_SUBTITLE_PREFERENCE_EMBEDDED_OR_EXTERNAL', '2': 2},
    {'1': 'PLAYBACK_SUBTITLE_PREFERENCE_NONE', '2': 3},
  ],
};

/// Descriptor for `PlaybackSubtitlePreference`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackSubtitlePreferenceDescriptor = $convert.base64Decode(
    'ChpQbGF5YmFja1N1YnRpdGxlUHJlZmVyZW5jZRIsCihQTEFZQkFDS19TVUJUSVRMRV9QUkVGRV'
    'JFTkNFX1VOU1BFQ0lGSUVEEAASKQolUExBWUJBQ0tfU1VCVElUTEVfUFJFRkVSRU5DRV9FWFRF'
    'Uk5BTBABEjUKMVBMQVlCQUNLX1NVQlRJVExFX1BSRUZFUkVOQ0VfRU1CRURERURfT1JfRVhURV'
    'JOQUwQAhIlCiFQTEFZQkFDS19TVUJUSVRMRV9QUkVGRVJFTkNFX05PTkUQAw==');

@$core.Deprecated('Use playbackVideoCodecDescriptor instead')
const PlaybackVideoCodec$json = {
  '1': 'PlaybackVideoCodec',
  '2': [
    {'1': 'PLAYBACK_VIDEO_CODEC_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_VIDEO_CODEC_H264', '2': 1},
    {'1': 'PLAYBACK_VIDEO_CODEC_HEVC', '2': 2},
    {'1': 'PLAYBACK_VIDEO_CODEC_VP9', '2': 3},
    {'1': 'PLAYBACK_VIDEO_CODEC_AV1', '2': 4},
  ],
};

/// Descriptor for `PlaybackVideoCodec`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackVideoCodecDescriptor = $convert.base64Decode(
    'ChJQbGF5YmFja1ZpZGVvQ29kZWMSJAogUExBWUJBQ0tfVklERU9fQ09ERUNfVU5TUEVDSUZJRU'
    'QQABIdChlQTEFZQkFDS19WSURFT19DT0RFQ19IMjY0EAESHQoZUExBWUJBQ0tfVklERU9fQ09E'
    'RUNfSEVWQxACEhwKGFBMQVlCQUNLX1ZJREVPX0NPREVDX1ZQORADEhwKGFBMQVlCQUNLX1ZJRE'
    'VPX0NPREVDX0FWMRAE');

@$core.Deprecated('Use playbackContainerDescriptor instead')
const PlaybackContainer$json = {
  '1': 'PlaybackContainer',
  '2': [
    {'1': 'PLAYBACK_CONTAINER_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_CONTAINER_MP4', '2': 1},
    {'1': 'PLAYBACK_CONTAINER_MKV', '2': 2},
    {'1': 'PLAYBACK_CONTAINER_WEBM', '2': 3},
  ],
};

/// Descriptor for `PlaybackContainer`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackContainerDescriptor = $convert.base64Decode(
    'ChFQbGF5YmFja0NvbnRhaW5lchIiCh5QTEFZQkFDS19DT05UQUlORVJfVU5TUEVDSUZJRUQQAB'
    'IaChZQTEFZQkFDS19DT05UQUlORVJfTVA0EAESGgoWUExBWUJBQ0tfQ09OVEFJTkVSX01LVhAC'
    'EhsKF1BMQVlCQUNLX0NPTlRBSU5FUl9XRUJNEAM=');

@$core.Deprecated('Use playbackAudioCapabilityDescriptor instead')
const PlaybackAudioCapability$json = {
  '1': 'PlaybackAudioCapability',
  '2': [
    {'1': 'PLAYBACK_AUDIO_CAPABILITY_UNSPECIFIED', '2': 0},
    {'1': 'PLAYBACK_AUDIO_CAPABILITY_STEREO', '2': 1},
    {'1': 'PLAYBACK_AUDIO_CAPABILITY_SURROUND', '2': 2},
    {'1': 'PLAYBACK_AUDIO_CAPABILITY_LOSSLESS_SURROUND', '2': 3},
  ],
};

/// Descriptor for `PlaybackAudioCapability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackAudioCapabilityDescriptor = $convert.base64Decode(
    'ChdQbGF5YmFja0F1ZGlvQ2FwYWJpbGl0eRIpCiVQTEFZQkFDS19BVURJT19DQVBBQklMSVRZX1'
    'VOU1BFQ0lGSUVEEAASJAogUExBWUJBQ0tfQVVESU9fQ0FQQUJJTElUWV9TVEVSRU8QARImCiJQ'
    'TEFZQkFDS19BVURJT19DQVBBQklMSVRZX1NVUlJPVU5EEAISLworUExBWUJBQ0tfQVVESU9fQ0'
    'FQQUJJTElUWV9MT1NTTEVTU19TVVJST1VORBAD');

@$core.Deprecated('Use resourceDeliveryModeDescriptor instead')
const ResourceDeliveryMode$json = {
  '1': 'ResourceDeliveryMode',
  '2': [
    {'1': 'RESOURCE_DELIVERY_MODE_UNSPECIFIED', '2': 0},
    {'1': 'RESOURCE_DELIVERY_MODE_NOTIFY_ONLY', '2': 1},
    {'1': 'RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT', '2': 2},
  ],
};

/// Descriptor for `ResourceDeliveryMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceDeliveryModeDescriptor = $convert.base64Decode(
    'ChRSZXNvdXJjZURlbGl2ZXJ5TW9kZRImCiJSRVNPVVJDRV9ERUxJVkVSWV9NT0RFX1VOU1BFQ0'
    'lGSUVEEAASJgoiUkVTT1VSQ0VfREVMSVZFUllfTU9ERV9OT1RJRllfT05MWRABEigKJFJFU09V'
    'UkNFX0RFTElWRVJZX01PREVfUFVTSF9TTkFQU0hPVBAC');

@$core.Deprecated('Use chatMessageStatusDescriptor instead')
const ChatMessageStatus$json = {
  '1': 'ChatMessageStatus',
  '2': [
    {'1': 'CHAT_MESSAGE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CHAT_MESSAGE_STATUS_ACTIVE', '2': 1},
    {'1': 'CHAT_MESSAGE_STATUS_EDITED', '2': 2},
    {'1': 'CHAT_MESSAGE_STATUS_DELETED', '2': 3},
  ],
};

/// Descriptor for `ChatMessageStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatMessageStatusDescriptor = $convert.base64Decode(
    'ChFDaGF0TWVzc2FnZVN0YXR1cxIjCh9DSEFUX01FU1NBR0VfU1RBVFVTX1VOU1BFQ0lGSUVEEA'
    'ASHgoaQ0hBVF9NRVNTQUdFX1NUQVRVU19BQ1RJVkUQARIeChpDSEFUX01FU1NBR0VfU1RBVFVT'
    'X0VESVRFRBACEh8KG0NIQVRfTUVTU0FHRV9TVEFUVVNfREVMRVRFRBAD');

@$core.Deprecated('Use chatMessageEventKindDescriptor instead')
const ChatMessageEventKind$json = {
  '1': 'ChatMessageEventKind',
  '2': [
    {'1': 'CHAT_MESSAGE_EVENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'CHAT_MESSAGE_EVENT_KIND_CREATED', '2': 1},
    {'1': 'CHAT_MESSAGE_EVENT_KIND_EDITED', '2': 2},
    {'1': 'CHAT_MESSAGE_EVENT_KIND_DELETED', '2': 3},
    {'1': 'CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED', '2': 4},
  ],
};

/// Descriptor for `ChatMessageEventKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chatMessageEventKindDescriptor = $convert.base64Decode(
    'ChRDaGF0TWVzc2FnZUV2ZW50S2luZBInCiNDSEFUX01FU1NBR0VfRVZFTlRfS0lORF9VTlNQRU'
    'NJRklFRBAAEiMKH0NIQVRfTUVTU0FHRV9FVkVOVF9LSU5EX0NSRUFURUQQARIiCh5DSEFUX01F'
    'U1NBR0VfRVZFTlRfS0lORF9FRElURUQQAhIjCh9DSEFUX01FU1NBR0VfRVZFTlRfS0lORF9ERU'
    'xFVEVEEAMSLQopQ0hBVF9NRVNTQUdFX0VWRU5UX0tJTkRfUkVBQ1RJT05TX0NIQU5HRUQQBA==');

@$core.Deprecated('Use roomMemberEventKindDescriptor instead')
const RoomMemberEventKind$json = {
  '1': 'RoomMemberEventKind',
  '2': [
    {'1': 'ROOM_MEMBER_EVENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_MEMBER_EVENT_KIND_JOINED', '2': 1},
    {'1': 'ROOM_MEMBER_EVENT_KIND_LEFT', '2': 2},
    {'1': 'ROOM_MEMBER_EVENT_KIND_PERMISSION_CHANGED', '2': 3},
    {'1': 'ROOM_MEMBER_EVENT_KIND_KICKED', '2': 4},
  ],
};

/// Descriptor for `RoomMemberEventKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomMemberEventKindDescriptor = $convert.base64Decode(
    'ChNSb29tTWVtYmVyRXZlbnRLaW5kEiYKIlJPT01fTUVNQkVSX0VWRU5UX0tJTkRfVU5TUEVDSU'
    'ZJRUQQABIhCh1ST09NX01FTUJFUl9FVkVOVF9LSU5EX0pPSU5FRBABEh8KG1JPT01fTUVNQkVS'
    'X0VWRU5UX0tJTkRfTEVGVBACEi0KKVJPT01fTUVNQkVSX0VWRU5UX0tJTkRfUEVSTUlTU0lPTl'
    '9DSEFOR0VEEAMSIQodUk9PTV9NRU1CRVJfRVZFTlRfS0lORF9LSUNLRUQQBA==');

@$core.Deprecated('Use onlineEventKindDescriptor instead')
const OnlineEventKind$json = {
  '1': 'OnlineEventKind',
  '2': [
    {'1': 'ONLINE_EVENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ONLINE_EVENT_KIND_JOINED', '2': 1},
    {'1': 'ONLINE_EVENT_KIND_LEFT', '2': 2},
  ],
};

/// Descriptor for `OnlineEventKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List onlineEventKindDescriptor = $convert.base64Decode(
    'Cg9PbmxpbmVFdmVudEtpbmQSIQodT05MSU5FX0VWRU5UX0tJTkRfVU5TUEVDSUZJRUQQABIcCh'
    'hPTkxJTkVfRVZFTlRfS0lORF9KT0lORUQQARIaChZPTkxJTkVfRVZFTlRfS0lORF9MRUZUEAI=');

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

@$core.Deprecated('Use notificationTypeDescriptor instead')
const NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'NOTIFICATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_TYPE_ROOM_INVITATION', '2': 1},
    {'1': 'NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT', '2': 2},
    {'1': 'NOTIFICATION_TYPE_ROOM_EVENT', '2': 3},
    {'1': 'NOTIFICATION_TYPE_PASSWORD_RESET', '2': 4},
    {'1': 'NOTIFICATION_TYPE_EMAIL_BIND', '2': 5},
  ],
};

/// Descriptor for `NotificationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationTypeDescriptor = $convert.base64Decode(
    'ChBOb3RpZmljYXRpb25UeXBlEiEKHU5PVElGSUNBVElPTl9UWVBFX1VOU1BFQ0lGSUVEEAASJQ'
    'ohTk9USUZJQ0FUSU9OX1RZUEVfUk9PTV9JTlZJVEFUSU9OEAESKQolTk9USUZJQ0FUSU9OX1RZ'
    'UEVfU1lTVEVNX0FOTk9VTkNFTUVOVBACEiAKHE5PVElGSUNBVElPTl9UWVBFX1JPT01fRVZFTl'
    'QQAxIkCiBOT1RJRklDQVRJT05fVFlQRV9QQVNTV09SRF9SRVNFVBAEEiAKHE5PVElGSUNBVElP'
    'Tl9UWVBFX0VNQUlMX0JJTkQQBQ==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
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
    {'1': 'is_banned', '3': 7, '4': 1, '5': 8, '10': 'isBanned'},
    {'1': 'avatar_url', '3': 8, '4': 1, '5': 9, '10': 'avatarUrl'},
    {
      '1': 'avatar',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAvatar',
      '10': 'avatar'
    },
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWUSFAoFZW'
    '1haWwYAyABKAlSBWVtYWlsEisKBHJvbGUYBCABKA4yFy5zeW5jdHYuY29tbW9uLlVzZXJSb2xl'
    'UgRyb2xlEjEKBnN0YXR1cxgFIAEoDjIZLnN5bmN0di5jb21tb24uVXNlclN0YXR1c1IGc3RhdH'
    'VzEh0KCmNyZWF0ZWRfYXQYBiABKANSCWNyZWF0ZWRBdBIbCglpc19iYW5uZWQYByABKAhSCGlz'
    'QmFubmVkEh0KCmF2YXRhcl91cmwYCCABKAlSCWF2YXRhclVybBIxCgZhdmF0YXIYCSABKAsyGS'
    '5zeW5jdHYuY2xpZW50LlVzZXJBdmF0YXJSBmF2YXRhcg==');

@$core.Deprecated('Use userPublicViewDescriptor instead')
const UserPublicView$json = {
  '1': 'UserPublicView',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '10': 'role'
    },
    {'1': 'created_at', '3': 4, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'avatar_url', '3': 5, '4': 1, '5': 9, '10': 'avatarUrl'},
    {
      '1': 'avatar',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAvatar',
      '10': 'avatar'
    },
  ],
};

/// Descriptor for `UserPublicView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPublicViewDescriptor = $convert.base64Decode(
    'Cg5Vc2VyUHVibGljVmlldxIOCgJpZBgBIAEoCVICaWQSGgoIdXNlcm5hbWUYAiABKAlSCHVzZX'
    'JuYW1lEisKBHJvbGUYAyABKA4yFy5zeW5jdHYuY29tbW9uLlVzZXJSb2xlUgRyb2xlEh0KCmNy'
    'ZWF0ZWRfYXQYBCABKANSCWNyZWF0ZWRBdBIdCgphdmF0YXJfdXJsGAUgASgJUglhdmF0YXJVcm'
    'wSMQoGYXZhdGFyGAYgASgLMhkuc3luY3R2LmNsaWVudC5Vc2VyQXZhdGFyUgZhdmF0YXI=');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'created_by', '3': 3, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomStatus',
      '10': 'status'
    },
    {'1': 'settings', '3': 5, '4': 1, '5': 12, '10': 'settings'},
    {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'member_count', '3': 7, '4': 1, '5': 5, '10': 'memberCount'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'is_banned', '3': 10, '4': 1, '5': 8, '10': 'isBanned'},
    {
      '1': 'availability',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceAvailability',
      '10': 'availability'
    },
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'cover',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceCover',
      '10': 'cover'
    },
    {
      '1': 'presence',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomPresenceStats',
      '10': 'presence'
    },
    {
      '1': 'creator',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPublicView',
      '10': 'creator'
    },
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEh0KCmNyZWF0ZWRfYn'
    'kYAyABKAlSCWNyZWF0ZWRCeRIxCgZzdGF0dXMYBCABKA4yGS5zeW5jdHYuY29tbW9uLlJvb21T'
    'dGF0dXNSBnN0YXR1cxIaCghzZXR0aW5ncxgFIAEoDFIIc2V0dGluZ3MSHQoKY3JlYXRlZF9hdB'
    'gGIAEoA1IJY3JlYXRlZEF0EiEKDG1lbWJlcl9jb3VudBgHIAEoBVILbWVtYmVyQ291bnQSIAoL'
    'ZGVzY3JpcHRpb24YCCABKAlSC2Rlc2NyaXB0aW9uEh0KCnVwZGF0ZWRfYXQYCSABKANSCXVwZG'
    'F0ZWRBdBIbCglpc19iYW5uZWQYCiABKAhSCGlzQmFubmVkEkcKDGF2YWlsYWJpbGl0eRgLIAEo'
    'DjIjLnN5bmN0di5jbGllbnQuUmVzb3VyY2VBdmFpbGFiaWxpdHlSDGF2YWlsYWJpbGl0eRIYCg'
    'd2ZXJzaW9uGAwgASgDUgd2ZXJzaW9uEjIKBWNvdmVyGA0gASgLMhwuc3luY3R2LmNsaWVudC5S'
    'ZXNvdXJjZUNvdmVyUgVjb3ZlchI8CghwcmVzZW5jZRgOIAEoCzIgLnN5bmN0di5jb21tb24uUm'
    '9vbVByZXNlbmNlU3RhdHNSCHByZXNlbmNlEjcKB2NyZWF0b3IYDyABKAsyHS5zeW5jdHYuY2xp'
    'ZW50LlVzZXJQdWJsaWNWaWV3UgdjcmVhdG9y');

@$core.Deprecated('Use mediaDescriptor instead')
const Media$json = {
  '1': 'Media',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'source_provider', '3': 4, '4': 1, '5': 9, '10': 'sourceProvider'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {'1': 'metadata', '3': 6, '4': 1, '5': 12, '10': 'metadata'},
    {'1': 'position', '3': 7, '4': 1, '5': 1, '10': 'position'},
    {'1': 'added_at', '3': 8, '4': 1, '5': 3, '10': 'addedAt'},
    {'1': 'creator_id', '3': 9, '4': 1, '5': 9, '10': 'creatorId'},
    {
      '1': 'provider_instance_name',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
    {'1': 'source_config', '3': 11, '4': 1, '5': 12, '10': 'sourceConfig'},
    {
      '1': 'availability',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceAvailability',
      '10': 'availability'
    },
    {'1': 'version', '3': 13, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'cover',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.VideoCover',
      '10': 'cover'
    },
    {'1': 'description', '3': 15, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `Media`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaDescriptor = $convert.base64Decode(
    'CgVNZWRpYRIOCgJpZBgBIAEoCVICaWQSFwoHcm9vbV9pZBgCIAEoCVIGcm9vbUlkEicKD3NvdX'
    'JjZV9wcm92aWRlchgEIAEoCVIOc291cmNlUHJvdmlkZXISEgoEbmFtZRgFIAEoCVIEbmFtZRIa'
    'CghtZXRhZGF0YRgGIAEoDFIIbWV0YWRhdGESGgoIcG9zaXRpb24YByABKAFSCHBvc2l0aW9uEh'
    'kKCGFkZGVkX2F0GAggASgDUgdhZGRlZEF0Eh0KCmNyZWF0b3JfaWQYCSABKAlSCWNyZWF0b3JJ'
    'ZBI0ChZwcm92aWRlcl9pbnN0YW5jZV9uYW1lGAogASgJUhRwcm92aWRlckluc3RhbmNlTmFtZR'
    'IjCg1zb3VyY2VfY29uZmlnGAsgASgMUgxzb3VyY2VDb25maWcSRwoMYXZhaWxhYmlsaXR5GAwg'
    'ASgOMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZUF2YWlsYWJpbGl0eVIMYXZhaWxhYmlsaXR5Eh'
    'gKB3ZlcnNpb24YDSABKANSB3ZlcnNpb24SLwoFY292ZXIYDiABKAsyGS5zeW5jdHYuY2xpZW50'
    'LlZpZGVvQ292ZXJSBWNvdmVyEiAKC2Rlc2NyaXB0aW9uGA8gASgJUgtkZXNjcmlwdGlvbg==');

@$core.Deprecated('Use playlistDescriptor instead')
const Playlist$json = {
  '1': 'Playlist',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'parent_id', '3': 4, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'position', '3': 5, '4': 1, '5': 1, '10': 'position'},
    {'1': 'is_dynamic', '3': 6, '4': 1, '5': 8, '10': 'isDynamic'},
    {'1': 'item_count', '3': 7, '4': 1, '5': 5, '10': 'itemCount'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
    {
      '1': 'availability',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceAvailability',
      '10': 'availability'
    },
    {'1': 'version', '3': 11, '4': 1, '5': 3, '10': 'version'},
    {'1': 'source_config', '3': 12, '4': 1, '5': 12, '10': 'sourceConfig'},
    {'1': 'source_provider', '3': 13, '4': 1, '5': 9, '10': 'sourceProvider'},
    {
      '1': 'provider_instance_name',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
    {'1': 'description', '3': 15, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'cover',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceCover',
      '10': 'cover'
    },
  ],
};

/// Descriptor for `Playlist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistDescriptor = $convert.base64Decode(
    'CghQbGF5bGlzdBIOCgJpZBgBIAEoCVICaWQSFwoHcm9vbV9pZBgCIAEoCVIGcm9vbUlkEhIKBG'
    '5hbWUYAyABKAlSBG5hbWUSGwoJcGFyZW50X2lkGAQgASgJUghwYXJlbnRJZBIaCghwb3NpdGlv'
    'bhgFIAEoAVIIcG9zaXRpb24SHQoKaXNfZHluYW1pYxgGIAEoCFIJaXNEeW5hbWljEh0KCml0ZW'
    '1fY291bnQYByABKAVSCWl0ZW1Db3VudBIdCgpjcmVhdGVkX2F0GAggASgDUgljcmVhdGVkQXQS'
    'HQoKdXBkYXRlZF9hdBgJIAEoA1IJdXBkYXRlZEF0EkcKDGF2YWlsYWJpbGl0eRgKIAEoDjIjLn'
    'N5bmN0di5jbGllbnQuUmVzb3VyY2VBdmFpbGFiaWxpdHlSDGF2YWlsYWJpbGl0eRIYCgd2ZXJz'
    'aW9uGAsgASgDUgd2ZXJzaW9uEiMKDXNvdXJjZV9jb25maWcYDCABKAxSDHNvdXJjZUNvbmZpZx'
    'InCg9zb3VyY2VfcHJvdmlkZXIYDSABKAlSDnNvdXJjZVByb3ZpZGVyEjQKFnByb3ZpZGVyX2lu'
    'c3RhbmNlX25hbWUYDiABKAlSFHByb3ZpZGVySW5zdGFuY2VOYW1lEiAKC2Rlc2NyaXB0aW9uGA'
    '8gASgJUgtkZXNjcmlwdGlvbhIyCgVjb3ZlchgQIAEoCzIcLnN5bmN0di5jbGllbnQuUmVzb3Vy'
    'Y2VDb3ZlclIFY292ZXI=');

@$core.Deprecated('Use resourceCoverDescriptor instead')
const ResourceCover$json = {
  '1': 'ResourceCover',
  '2': [
    {'1': 'storage_backend', '3': 1, '4': 1, '5': 9, '10': 'storageBackend'},
    {'1': 'object_key', '3': 2, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {'1': 'metadata', '3': 4, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `ResourceCover`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceCoverDescriptor = $convert.base64Decode(
    'Cg1SZXNvdXJjZUNvdmVyEicKD3N0b3JhZ2VfYmFja2VuZBgBIAEoCVIOc3RvcmFnZUJhY2tlbm'
    'QSHQoKb2JqZWN0X2tleRgCIAEoCVIJb2JqZWN0S2V5EhAKA3VybBgDIAEoCVIDdXJsEhoKCG1l'
    'dGFkYXRhGAQgASgMUghtZXRhZGF0YQ==');

@$core.Deprecated('Use playbackStateDescriptor instead')
const PlaybackState$json = {
  '1': 'PlaybackState',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'playing_media_id', '3': 2, '4': 1, '5': 9, '10': 'playingMediaId'},
    {'1': 'position', '3': 3, '4': 1, '5': 1, '10': 'position'},
    {'1': 'speed', '3': 4, '4': 1, '5': 1, '10': 'speed'},
    {'1': 'is_playing', '3': 5, '4': 1, '5': 8, '10': 'isPlaying'},
    {'1': 'updated_at', '3': 6, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'version', '3': 7, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'playing_playlist_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'playingPlaylistId'
    },
    {'1': 'target', '3': 9, '4': 1, '5': 12, '10': 'target'},
    {'1': 'target_hash', '3': 10, '4': 1, '5': 9, '10': 'targetHash'},
  ],
};

/// Descriptor for `PlaybackState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackStateDescriptor = $convert.base64Decode(
    'Cg1QbGF5YmFja1N0YXRlEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIoChBwbGF5aW5nX21lZG'
    'lhX2lkGAIgASgJUg5wbGF5aW5nTWVkaWFJZBIaCghwb3NpdGlvbhgDIAEoAVIIcG9zaXRpb24S'
    'FAoFc3BlZWQYBCABKAFSBXNwZWVkEh0KCmlzX3BsYXlpbmcYBSABKAhSCWlzUGxheWluZxIdCg'
    'p1cGRhdGVkX2F0GAYgASgDUgl1cGRhdGVkQXQSGAoHdmVyc2lvbhgHIAEoA1IHdmVyc2lvbhIu'
    'ChNwbGF5aW5nX3BsYXlsaXN0X2lkGAggASgJUhFwbGF5aW5nUGxheWxpc3RJZBIWCgZ0YXJnZX'
    'QYCSABKAxSBnRhcmdldBIfCgt0YXJnZXRfaGFzaBgKIAEoCVIKdGFyZ2V0SGFzaA==');

@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = {
  '1': 'RegisterResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 3, '4': 1, '5': 9, '10': 'refreshToken'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.RegistrationStatus',
      '10': 'status'
    },
    {
      '1': 'pending_review',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PendingRegistrationReview',
      '10': 'pendingReview'
    },
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5zeW5jdHYuY2xpZW50LlVzZXJSBH'
    'VzZXISIQoMYWNjZXNzX3Rva2VuGAIgASgJUgthY2Nlc3NUb2tlbhIjCg1yZWZyZXNoX3Rva2Vu'
    'GAMgASgJUgxyZWZyZXNoVG9rZW4SOQoGc3RhdHVzGAQgASgOMiEuc3luY3R2LmNsaWVudC5SZW'
    'dpc3RyYXRpb25TdGF0dXNSBnN0YXR1cxJPCg5wZW5kaW5nX3JldmlldxgFIAEoCzIoLnN5bmN0'
    'di5jbGllbnQuUGVuZGluZ1JlZ2lzdHJhdGlvblJldmlld1INcGVuZGluZ1Jldmlldw==');

@$core.Deprecated('Use pendingRegistrationReviewDescriptor instead')
const PendingRegistrationReview$json = {
  '1': 'PendingRegistrationReview',
  '2': [
    {
      '1': 'review_request_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'reviewRequestId'
    },
    {'1': 'username', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {
      '1': 'email',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'email',
      '17': true
    },
  ],
  '8': [
    {'1': '_email'},
  ],
};

/// Descriptor for `PendingRegistrationReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pendingRegistrationReviewDescriptor = $convert.base64Decode(
    'ChlQZW5kaW5nUmVnaXN0cmF0aW9uUmV2aWV3EkkKEXJldmlld19yZXF1ZXN0X2lkGAEgASgJQh'
    '26SBpyGBABGEAyEl51c3JfW0EtWmEtejAtOV0rJFIPcmV2aWV3UmVxdWVzdElkEiUKCHVzZXJu'
    'YW1lGAIgASgJQgm6SAZyBBADGDJSCHVzZXJuYW1lEiUKBWVtYWlsGAMgASgJQgq6SAdyBRj+AW'
    'ABSABSBWVtYWlsiAEBQggKBl9lbWFpbA==');

@$core.Deprecated('Use startOpaqueRegistrationRequestDescriptor instead')
const StartOpaqueRegistrationRequest$json = {
  '1': 'StartOpaqueRegistrationRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {
      '1': 'email',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'email',
      '17': true
    },
    {
      '1': 'registration_request',
      '3': 3,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationRequest'
    },
  ],
  '8': [
    {'1': '_email'},
  ],
};

/// Descriptor for `StartOpaqueRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaqueRegistrationRequestDescriptor =
    $convert.base64Decode(
        'Ch5TdGFydE9wYXF1ZVJlZ2lzdHJhdGlvblJlcXVlc3QSOAoIdXNlcm5hbWUYASABKAlCHLpIGX'
        'IXEAMYMjIRXltccHtMfVxwe059Xy1dKyRSCHVzZXJuYW1lEiUKBWVtYWlsGAIgASgJQgq6SAdy'
        'BRj+AWABSABSBWVtYWlsiAEBEj0KFHJlZ2lzdHJhdGlvbl9yZXF1ZXN0GAMgASgMQgq6SAd6BR'
        'ABGIAgUhNyZWdpc3RyYXRpb25SZXF1ZXN0QggKBl9lbWFpbA==');

@$core.Deprecated('Use startOpaqueRegistrationResponseDescriptor instead')
const StartOpaqueRegistrationResponse$json = {
  '1': 'StartOpaqueRegistrationResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'registration_response',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'registrationResponse'
    },
  ],
};

/// Descriptor for `StartOpaqueRegistrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaqueRegistrationResponseDescriptor =
    $convert.base64Decode(
        'Ch9TdGFydE9wYXF1ZVJlZ2lzdHJhdGlvblJlc3BvbnNlEikKCnNlc3Npb25faWQYASABKAlCCr'
        'pIB3IFEAEYgAFSCXNlc3Npb25JZBIzChVyZWdpc3RyYXRpb25fcmVzcG9uc2UYAiABKAxSFHJl'
        'Z2lzdHJhdGlvblJlc3BvbnNl');

@$core.Deprecated('Use finishOpaqueRegistrationRequestDescriptor instead')
const FinishOpaqueRegistrationRequest$json = {
  '1': 'FinishOpaqueRegistrationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'registration_upload',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationUpload'
    },
  ],
};

/// Descriptor for `FinishOpaqueRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishOpaqueRegistrationRequestDescriptor =
    $convert.base64Decode(
        'Ch9GaW5pc2hPcGFxdWVSZWdpc3RyYXRpb25SZXF1ZXN0EikKCnNlc3Npb25faWQYASABKAlCCr'
        'pIB3IFEAEYgAFSCXNlc3Npb25JZBI7ChNyZWdpc3RyYXRpb25fdXBsb2FkGAIgASgMQgq6SAd6'
        'BRABGIAgUhJyZWdpc3RyYXRpb25VcGxvYWQ=');

@$core.Deprecated('Use registerWithDirectPasswordRequestDescriptor instead')
const RegisterWithDirectPasswordRequest$json = {
  '1': 'RegisterWithDirectPasswordRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {
      '1': 'email',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'email',
      '17': true
    },
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
  ],
  '8': [
    {'1': '_email'},
  ],
};

/// Descriptor for `RegisterWithDirectPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerWithDirectPasswordRequestDescriptor =
    $convert.base64Decode(
        'CiFSZWdpc3RlcldpdGhEaXJlY3RQYXNzd29yZFJlcXVlc3QSOAoIdXNlcm5hbWUYASABKAlCHL'
        'pIGXIXEAMYMjIRXltccHtMfVxwe059Xy1dKyRSCHVzZXJuYW1lEiUKBWVtYWlsGAIgASgJQgq6'
        'SAdyBRj+AWABSABSBWVtYWlsiAEBEiYKCHBhc3N3b3JkGAMgASgJQgq6SAdyBRABGIAIUghwYX'
        'Nzd29yZEIICgZfZW1haWw=');

@$core.Deprecated('Use loginWithDirectPasswordRequestDescriptor instead')
const LoginWithDirectPasswordRequest$json = {
  '1': 'LoginWithDirectPasswordRequest',
  '2': [
    {
      '1': 'username',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'username'
    },
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '9': 0, '10': 'email'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
  ],
  '8': [
    {'1': 'identifier', '2': {}},
  ],
};

/// Descriptor for `LoginWithDirectPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginWithDirectPasswordRequestDescriptor =
    $convert.base64Decode(
        'Ch5Mb2dpbldpdGhEaXJlY3RQYXNzd29yZFJlcXVlc3QSJQoIdXNlcm5hbWUYASABKAlCB7pIBH'
        'ICGDJIAFIIdXNlcm5hbWUSIAoFZW1haWwYAiABKAlCCLpIBXIDGP4BSABSBWVtYWlsEiYKCHBh'
        'c3N3b3JkGAMgASgJQgq6SAdyBRABGIAIUghwYXNzd29yZEITCgppZGVudGlmaWVyEgW6SAIIAQ'
        '==');

@$core.Deprecated('Use requestEmailRegistrationRequestDescriptor instead')
const RequestEmailRegistrationRequest$json = {
  '1': 'RequestEmailRegistrationRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
  ],
};

/// Descriptor for `RequestEmailRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEmailRegistrationRequestDescriptor =
    $convert.base64Decode(
        'Ch9SZXF1ZXN0RW1haWxSZWdpc3RyYXRpb25SZXF1ZXN0EjgKCHVzZXJuYW1lGAEgASgJQhy6SB'
        'lyFxADGDIyEV5bXHB7TH1ccHtOfV8tXSskUgh1c2VybmFtZRIiCgVlbWFpbBgCIAEoCUIMukgJ'
        'cgcQARj+AWABUgVlbWFpbA==');

@$core.Deprecated('Use requestEmailRegistrationResponseDescriptor instead')
const RequestEmailRegistrationResponse$json = {
  '1': 'RequestEmailRegistrationResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RequestEmailRegistrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEmailRegistrationResponseDescriptor =
    $convert.base64Decode(
        'CiBSZXF1ZXN0RW1haWxSZWdpc3RyYXRpb25SZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZX'
        'NzYWdl');

@$core.Deprecated('Use confirmEmailRegistrationRequestDescriptor instead')
const ConfirmEmailRegistrationRequest$json = {
  '1': 'ConfirmEmailRegistrationRequest',
  '2': [
    {'1': 'email_token', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'emailToken'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'password'},
  ],
};

/// Descriptor for `ConfirmEmailRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmEmailRegistrationRequestDescriptor =
    $convert.base64Decode(
        'Ch9Db25maXJtRW1haWxSZWdpc3RyYXRpb25SZXF1ZXN0EisKC2VtYWlsX3Rva2VuGAEgASgJQg'
        'q6SAdyBRABGP8BUgplbWFpbFRva2VuEiYKCHBhc3N3b3JkGAIgASgJQgq6SAdyBRABGIAIUghw'
        'YXNzd29yZA==');

@$core.Deprecated('Use confirmEmailLoginRequestDescriptor instead')
const ConfirmEmailLoginRequest$json = {
  '1': 'ConfirmEmailLoginRequest',
  '2': [
    {'1': 'email', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {'1': 'email_token', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'emailToken'},
  ],
};

/// Descriptor for `ConfirmEmailLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmEmailLoginRequestDescriptor =
    $convert.base64Decode(
        'ChhDb25maXJtRW1haWxMb2dpblJlcXVlc3QSIAoFZW1haWwYAyABKAlCCrpIB3IFEAEY/gFSBW'
        'VtYWlsEisKC2VtYWlsX3Rva2VuGAQgASgJQgq6SAdyBRABGP8BUgplbWFpbFRva2Vu');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
    {'1': 'access_token', '3': 2, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 3, '4': 1, '5': 9, '10': 'refreshToken'},
    {
      '1': 'mfa',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.MfaChallenge',
      '10': 'mfa'
    },
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5zeW5jdHYuY2xpZW50LlVzZXJSBHVzZX'
    'ISIQoMYWNjZXNzX3Rva2VuGAIgASgJUgthY2Nlc3NUb2tlbhIjCg1yZWZyZXNoX3Rva2VuGAMg'
    'ASgJUgxyZWZyZXNoVG9rZW4SLQoDbWZhGAQgASgLMhsuc3luY3R2LmNsaWVudC5NZmFDaGFsbG'
    'VuZ2VSA21mYQ==');

@$core.Deprecated('Use mfaChallengeDescriptor instead')
const MfaChallenge$json = {
  '1': 'MfaChallenge',
  '2': [
    {'1': 'required', '3': 1, '4': 1, '5': 8, '10': 'required'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'available_methods',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.MfaMethod',
      '10': 'availableMethods'
    },
    {'1': 'masked_email', '3': 4, '4': 1, '5': 9, '10': 'maskedEmail'},
    {'1': 'expires_at', '3': 5, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `MfaChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mfaChallengeDescriptor = $convert.base64Decode(
    'CgxNZmFDaGFsbGVuZ2USGgoIcmVxdWlyZWQYASABKAhSCHJlcXVpcmVkEikKCnNlc3Npb25faW'
    'QYAiABKAlCCrpIB3IFEAEYgAFSCXNlc3Npb25JZBJFChFhdmFpbGFibGVfbWV0aG9kcxgDIAMo'
    'DjIYLnN5bmN0di5jbGllbnQuTWZhTWV0aG9kUhBhdmFpbGFibGVNZXRob2RzEiEKDG1hc2tlZF'
    '9lbWFpbBgEIAEoCVILbWFza2VkRW1haWwSHQoKZXhwaXJlc19hdBgFIAEoA1IJZXhwaXJlc0F0');

@$core
    .Deprecated('Use sensitiveOperationVerificationChallengeDescriptor instead')
const SensitiveOperationVerificationChallenge$json = {
  '1': 'SensitiveOperationVerificationChallenge',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'required_methods',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.SensitiveOperationVerificationMethod',
      '10': 'requiredMethods'
    },
    {
      '1': 'completed_methods',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.SensitiveOperationVerificationMethod',
      '10': 'completedMethods'
    },
    {
      '1': 'available_methods',
      '3': 4,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.SensitiveOperationVerificationMethod',
      '10': 'availableMethods'
    },
    {'1': 'masked_email', '3': 5, '4': 1, '5': 9, '10': 'maskedEmail'},
    {'1': 'expires_at', '3': 6, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'required_count', '3': 7, '4': 1, '5': 5, '10': 'requiredCount'},
  ],
};

/// Descriptor for `SensitiveOperationVerificationChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensitiveOperationVerificationChallengeDescriptor = $convert.base64Decode(
    'CidTZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25DaGFsbGVuZ2USKQoKc2Vzc2lvbl9pZB'
    'gBIAEoCUIKukgHcgUQARiAAVIJc2Vzc2lvbklkEl4KEHJlcXVpcmVkX21ldGhvZHMYAiADKA4y'
    'My5zeW5jdHYuY2xpZW50LlNlbnNpdGl2ZU9wZXJhdGlvblZlcmlmaWNhdGlvbk1ldGhvZFIPcm'
    'VxdWlyZWRNZXRob2RzEmAKEWNvbXBsZXRlZF9tZXRob2RzGAMgAygOMjMuc3luY3R2LmNsaWVu'
    'dC5TZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25NZXRob2RSEGNvbXBsZXRlZE1ldGhvZH'
    'MSYAoRYXZhaWxhYmxlX21ldGhvZHMYBCADKA4yMy5zeW5jdHYuY2xpZW50LlNlbnNpdGl2ZU9w'
    'ZXJhdGlvblZlcmlmaWNhdGlvbk1ldGhvZFIQYXZhaWxhYmxlTWV0aG9kcxIhCgxtYXNrZWRfZW'
    '1haWwYBSABKAlSC21hc2tlZEVtYWlsEh0KCmV4cGlyZXNfYXQYBiABKANSCWV4cGlyZXNBdBIl'
    'Cg5yZXF1aXJlZF9jb3VudBgHIAEoBVINcmVxdWlyZWRDb3VudA==');

@$core.Deprecated(
    'Use startSensitiveOperationVerificationRequestDescriptor instead')
const StartSensitiveOperationVerificationRequest$json = {
  '1': 'StartSensitiveOperationVerificationRequest',
};

/// Descriptor for `StartSensitiveOperationVerificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    startSensitiveOperationVerificationRequestDescriptor =
    $convert.base64Decode(
        'CipTdGFydFNlbnNpdGl2ZU9wZXJhdGlvblZlcmlmaWNhdGlvblJlcXVlc3Q=');

@$core.Deprecated(
    'Use startSensitiveOperationVerificationResponseDescriptor instead')
const StartSensitiveOperationVerificationResponse$json = {
  '1': 'StartSensitiveOperationVerificationResponse',
  '2': [
    {
      '1': 'challenge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.SensitiveOperationVerificationChallenge',
      '10': 'challenge'
    },
    {'1': 'verification_id', '3': 2, '4': 1, '5': 9, '10': 'verificationId'},
  ],
};

/// Descriptor for `StartSensitiveOperationVerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    startSensitiveOperationVerificationResponseDescriptor =
    $convert.base64Decode(
        'CitTdGFydFNlbnNpdGl2ZU9wZXJhdGlvblZlcmlmaWNhdGlvblJlc3BvbnNlElQKCWNoYWxsZW'
        '5nZRgBIAEoCzI2LnN5bmN0di5jbGllbnQuU2Vuc2l0aXZlT3BlcmF0aW9uVmVyaWZpY2F0aW9u'
        'Q2hhbGxlbmdlUgljaGFsbGVuZ2USJwoPdmVyaWZpY2F0aW9uX2lkGAIgASgJUg52ZXJpZmljYX'
        'Rpb25JZA==');

@$core.Deprecated('Use startSensitiveOperationPasskeyRequestDescriptor instead')
const StartSensitiveOperationPasskeyRequest$json = {
  '1': 'StartSensitiveOperationPasskeyRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
  ],
};

/// Descriptor for `StartSensitiveOperationPasskeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSensitiveOperationPasskeyRequestDescriptor =
    $convert.base64Decode(
        'CiVTdGFydFNlbnNpdGl2ZU9wZXJhdGlvblBhc3NrZXlSZXF1ZXN0EikKCnNlc3Npb25faWQYAS'
        'ABKAlCCrpIB3IFEAEYgAFSCXNlc3Npb25JZA==');

@$core
    .Deprecated('Use startSensitiveOperationPasskeyResponseDescriptor instead')
const StartSensitiveOperationPasskeyResponse$json = {
  '1': 'StartSensitiveOperationPasskeyResponse',
  '2': [
    {
      '1': 'passkey_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'passkeySessionId'
    },
    {'1': 'options', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'options'},
  ],
};

/// Descriptor for `StartSensitiveOperationPasskeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSensitiveOperationPasskeyResponseDescriptor =
    $convert.base64Decode(
        'CiZTdGFydFNlbnNpdGl2ZU9wZXJhdGlvblBhc3NrZXlSZXNwb25zZRI4ChJwYXNza2V5X3Nlc3'
        'Npb25faWQYASABKAlCCrpIB3IFEAEYgAFSEHBhc3NrZXlTZXNzaW9uSWQSJQoHb3B0aW9ucxgC'
        'IAEoDEILukgIegYQARiAgARSB29wdGlvbnM=');

@$core.Deprecated(
    'Use requestSensitiveOperationEmailCodeRequestDescriptor instead')
const RequestSensitiveOperationEmailCodeRequest$json = {
  '1': 'RequestSensitiveOperationEmailCodeRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
  ],
};

/// Descriptor for `RequestSensitiveOperationEmailCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    requestSensitiveOperationEmailCodeRequestDescriptor = $convert.base64Decode(
        'CilSZXF1ZXN0U2Vuc2l0aXZlT3BlcmF0aW9uRW1haWxDb2RlUmVxdWVzdBIpCgpzZXNzaW9uX2'
        'lkGAEgASgJQgq6SAdyBRABGIABUglzZXNzaW9uSWQ=');

@$core.Deprecated(
    'Use requestSensitiveOperationEmailCodeResponseDescriptor instead')
const RequestSensitiveOperationEmailCodeResponse$json = {
  '1': 'RequestSensitiveOperationEmailCodeResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'masked_email', '3': 2, '4': 1, '5': 9, '10': 'maskedEmail'},
  ],
};

/// Descriptor for `RequestSensitiveOperationEmailCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    requestSensitiveOperationEmailCodeResponseDescriptor =
    $convert.base64Decode(
        'CipSZXF1ZXN0U2Vuc2l0aXZlT3BlcmF0aW9uRW1haWxDb2RlUmVzcG9uc2USGAoHbWVzc2FnZR'
        'gBIAEoCVIHbWVzc2FnZRIhCgxtYXNrZWRfZW1haWwYAiABKAlSC21hc2tlZEVtYWls');

@$core.Deprecated(
    'Use finishSensitiveOperationVerificationRequestDescriptor instead')
const FinishSensitiveOperationVerificationRequest$json = {
  '1': 'FinishSensitiveOperationVerificationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'method',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SensitiveOperationVerificationMethod',
      '8': {},
      '10': 'method'
    },
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {'1': 'email_token', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'emailToken'},
    {
      '1': 'passkey_session_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'passkeySessionId'
    },
    {
      '1': 'passkey_credential',
      '3': 6,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'passkeyCredential'
    },
  ],
};

/// Descriptor for `FinishSensitiveOperationVerificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    finishSensitiveOperationVerificationRequestDescriptor =
    $convert.base64Decode(
        'CitGaW5pc2hTZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25SZXF1ZXN0EikKCnNlc3Npb2'
        '5faWQYASABKAlCCrpIB3IFEAEYgAFSCXNlc3Npb25JZBJVCgZtZXRob2QYAiABKA4yMy5zeW5j'
        'dHYuY2xpZW50LlNlbnNpdGl2ZU9wZXJhdGlvblZlcmlmaWNhdGlvbk1ldGhvZEIIukgFggECEA'
        'FSBm1ldGhvZBIkCghwYXNzd29yZBgDIAEoCUIIukgFcgMYgAhSCHBhc3N3b3JkEikKC2VtYWls'
        'X3Rva2VuGAQgASgJQgi6SAVyAxj/AVIKZW1haWxUb2tlbhI2ChJwYXNza2V5X3Nlc3Npb25faW'
        'QYBSABKAlCCLpIBXIDGIABUhBwYXNza2V5U2Vzc2lvbklkEjgKEnBhc3NrZXlfY3JlZGVudGlh'
        'bBgGIAEoDEIJukgGegQYgIABUhFwYXNza2V5Q3JlZGVudGlhbA==');

@$core.Deprecated(
    'Use finishSensitiveOperationVerificationResponseDescriptor instead')
const FinishSensitiveOperationVerificationResponse$json = {
  '1': 'FinishSensitiveOperationVerificationResponse',
  '2': [
    {'1': 'verification_id', '3': 1, '4': 1, '5': 9, '10': 'verificationId'},
    {
      '1': 'challenge',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.SensitiveOperationVerificationChallenge',
      '10': 'challenge'
    },
  ],
};

/// Descriptor for `FinishSensitiveOperationVerificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    finishSensitiveOperationVerificationResponseDescriptor =
    $convert.base64Decode(
        'CixGaW5pc2hTZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25SZXNwb25zZRInCg92ZXJpZm'
        'ljYXRpb25faWQYASABKAlSDnZlcmlmaWNhdGlvbklkElQKCWNoYWxsZW5nZRgCIAEoCzI2LnN5'
        'bmN0di5jbGllbnQuU2Vuc2l0aXZlT3BlcmF0aW9uVmVyaWZpY2F0aW9uQ2hhbGxlbmdlUgljaG'
        'FsbGVuZ2U=');

@$core.Deprecated('Use startOpaqueLoginRequestDescriptor instead')
const StartOpaqueLoginRequest$json = {
  '1': 'StartOpaqueLoginRequest',
  '2': [
    {
      '1': 'username',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'username'
    },
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '9': 0, '10': 'email'},
    {
      '1': 'credential_request',
      '3': 3,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialRequest'
    },
  ],
  '8': [
    {'1': 'identifier', '2': {}},
  ],
};

/// Descriptor for `StartOpaqueLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaqueLoginRequestDescriptor = $convert.base64Decode(
    'ChdTdGFydE9wYXF1ZUxvZ2luUmVxdWVzdBIlCgh1c2VybmFtZRgBIAEoCUIHukgEcgIYMkgAUg'
    'h1c2VybmFtZRIgCgVlbWFpbBgCIAEoCUIIukgFcgMY/gFIAFIFZW1haWwSOQoSY3JlZGVudGlh'
    'bF9yZXF1ZXN0GAMgASgMQgq6SAd6BRABGIAgUhFjcmVkZW50aWFsUmVxdWVzdEITCgppZGVudG'
    'lmaWVyEgW6SAIIAQ==');

@$core.Deprecated('Use startOpaqueLoginResponseDescriptor instead')
const StartOpaqueLoginResponse$json = {
  '1': 'StartOpaqueLoginResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'credential_response',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'credentialResponse'
    },
  ],
};

/// Descriptor for `StartOpaqueLoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaqueLoginResponseDescriptor = $convert.base64Decode(
    'ChhTdGFydE9wYXF1ZUxvZ2luUmVzcG9uc2USKQoKc2Vzc2lvbl9pZBgBIAEoCUIKukgHcgUQAR'
    'iAAVIJc2Vzc2lvbklkEi8KE2NyZWRlbnRpYWxfcmVzcG9uc2UYAiABKAxSEmNyZWRlbnRpYWxS'
    'ZXNwb25zZQ==');

@$core.Deprecated('Use finishOpaqueLoginRequestDescriptor instead')
const FinishOpaqueLoginRequest$json = {
  '1': 'FinishOpaqueLoginRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'credential_finalization',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialFinalization'
    },
  ],
};

/// Descriptor for `FinishOpaqueLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishOpaqueLoginRequestDescriptor = $convert.base64Decode(
    'ChhGaW5pc2hPcGFxdWVMb2dpblJlcXVlc3QSKQoKc2Vzc2lvbl9pZBgBIAEoCUIKukgHcgUQAR'
    'iAAVIJc2Vzc2lvbklkEkMKF2NyZWRlbnRpYWxfZmluYWxpemF0aW9uGAIgASgMQgq6SAd6BRAB'
    'GIAgUhZjcmVkZW50aWFsRmluYWxpemF0aW9u');

@$core.Deprecated('Use startPasskeyLoginRequestDescriptor instead')
const StartPasskeyLoginRequest$json = {
  '1': 'StartPasskeyLoginRequest',
  '2': [
    {
      '1': 'username',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'username'
    },
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '9': 0, '10': 'email'},
  ],
  '8': [
    {'1': 'identifier'},
  ],
};

/// Descriptor for `StartPasskeyLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyLoginRequestDescriptor = $convert.base64Decode(
    'ChhTdGFydFBhc3NrZXlMb2dpblJlcXVlc3QSJQoIdXNlcm5hbWUYASABKAlCB7pIBHICGDJIAF'
    'IIdXNlcm5hbWUSIAoFZW1haWwYAiABKAlCCLpIBXIDGP4BSABSBWVtYWlsQgwKCmlkZW50aWZp'
    'ZXI=');

@$core.Deprecated('Use startPasskeyLoginResponseDescriptor instead')
const StartPasskeyLoginResponse$json = {
  '1': 'StartPasskeyLoginResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {'1': 'options', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'options'},
  ],
};

/// Descriptor for `StartPasskeyLoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyLoginResponseDescriptor = $convert.base64Decode(
    'ChlTdGFydFBhc3NrZXlMb2dpblJlc3BvbnNlEikKCnNlc3Npb25faWQYASABKAlCCrpIB3IFEA'
    'EYgAFSCXNlc3Npb25JZBIlCgdvcHRpb25zGAIgASgMQgu6SAh6BhABGICABFIHb3B0aW9ucw==');

@$core.Deprecated('Use finishPasskeyLoginRequestDescriptor instead')
const FinishPasskeyLoginRequest$json = {
  '1': 'FinishPasskeyLoginRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {'1': 'credential', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'credential'},
  ],
};

/// Descriptor for `FinishPasskeyLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishPasskeyLoginRequestDescriptor = $convert.base64Decode(
    'ChlGaW5pc2hQYXNza2V5TG9naW5SZXF1ZXN0EikKCnNlc3Npb25faWQYASABKAlCCrpIB3IFEA'
    'EYgAFSCXNlc3Npb25JZBIrCgpjcmVkZW50aWFsGAIgASgMQgu6SAh6BhABGICABFIKY3JlZGVu'
    'dGlhbA==');

@$core.Deprecated('Use startPasskeyRegistrationRequestDescriptor instead')
const StartPasskeyRegistrationRequest$json = {
  '1': 'StartPasskeyRegistrationRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `StartPasskeyRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyRegistrationRequestDescriptor =
    $convert.base64Decode(
        'Ch9TdGFydFBhc3NrZXlSZWdpc3RyYXRpb25SZXF1ZXN0EjgKCHVzZXJuYW1lGAEgASgJQhy6SB'
        'lyFxADGDIyEV5bXHB7TH1ccHtOfV8tXSskUgh1c2VybmFtZRIjCgVlbWFpbBgCIAEoCUINukgK'
        'cgUY/gFgAdgBAVIFZW1haWwSGwoEbmFtZRgDIAEoCUIHukgEcgIYZFIEbmFtZQ==');

@$core.Deprecated('Use finishPasskeyRegistrationRequestDescriptor instead')
const FinishPasskeyRegistrationRequest$json = {
  '1': 'FinishPasskeyRegistrationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {'1': 'credential', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'credential'},
  ],
};

/// Descriptor for `FinishPasskeyRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishPasskeyRegistrationRequestDescriptor =
    $convert.base64Decode(
        'CiBGaW5pc2hQYXNza2V5UmVnaXN0cmF0aW9uUmVxdWVzdBIpCgpzZXNzaW9uX2lkGAEgASgJQg'
        'q6SAdyBRABGIABUglzZXNzaW9uSWQSKwoKY3JlZGVudGlhbBgCIAEoDEILukgIegYQARiAgARS'
        'CmNyZWRlbnRpYWw=');

@$core.Deprecated('Use startPasskeyBindRequestDescriptor instead')
const StartPasskeyBindRequest$json = {
  '1': 'StartPasskeyBindRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
  ],
};

/// Descriptor for `StartPasskeyBindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyBindRequestDescriptor =
    $convert.base64Decode(
        'ChdTdGFydFBhc3NrZXlCaW5kUmVxdWVzdBIbCgRuYW1lGAEgASgJQge6SARyAhhkUgRuYW1l');

@$core.Deprecated('Use startPasskeyRegistrationResponseDescriptor instead')
const StartPasskeyRegistrationResponse$json = {
  '1': 'StartPasskeyRegistrationResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {'1': 'options', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'options'},
  ],
};

/// Descriptor for `StartPasskeyRegistrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyRegistrationResponseDescriptor =
    $convert.base64Decode(
        'CiBTdGFydFBhc3NrZXlSZWdpc3RyYXRpb25SZXNwb25zZRIpCgpzZXNzaW9uX2lkGAEgASgJQg'
        'q6SAdyBRABGIABUglzZXNzaW9uSWQSJQoHb3B0aW9ucxgCIAEoDEILukgIegYQARiAgARSB29w'
        'dGlvbnM=');

@$core.Deprecated('Use startPasskeyBindResponseDescriptor instead')
const StartPasskeyBindResponse$json = {
  '1': 'StartPasskeyBindResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {'1': 'options', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'options'},
  ],
};

/// Descriptor for `StartPasskeyBindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyBindResponseDescriptor =
    $convert.base64Decode(
        'ChhTdGFydFBhc3NrZXlCaW5kUmVzcG9uc2USKQoKc2Vzc2lvbl9pZBgBIAEoCUIKukgHcgUQAR'
        'iAAVIJc2Vzc2lvbklkEiUKB29wdGlvbnMYAiABKAxCC7pICHoGEAEYgIAEUgdvcHRpb25z');

@$core.Deprecated('Use finishPasskeyBindRequestDescriptor instead')
const FinishPasskeyBindRequest$json = {
  '1': 'FinishPasskeyBindRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {'1': 'credential', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'credential'},
    {
      '1': 'verification_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'verificationId'
    },
  ],
};

/// Descriptor for `FinishPasskeyBindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishPasskeyBindRequestDescriptor = $convert.base64Decode(
    'ChhGaW5pc2hQYXNza2V5QmluZFJlcXVlc3QSKQoKc2Vzc2lvbl9pZBgBIAEoCUIKukgHcgUQAR'
    'iAAVIJc2Vzc2lvbklkEisKCmNyZWRlbnRpYWwYAiABKAxCC7pICHoGEAEYgIAEUgpjcmVkZW50'
    'aWFsEjMKD3ZlcmlmaWNhdGlvbl9pZBgDIAEoCUIKukgHcgUQARiAAVIOdmVyaWZpY2F0aW9uSW'
    'Q=');

@$core.Deprecated('Use passkeyCredentialDescriptor instead')
const PasskeyCredential$json = {
  '1': 'PasskeyCredential',
  '2': [
    {'1': 'credential_id', '3': 1, '4': 1, '5': 9, '10': 'credentialId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'sign_count', '3': 3, '4': 1, '5': 3, '10': 'signCount'},
    {'1': 'created_at', '3': 4, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 5, '4': 1, '5': 3, '10': 'updatedAt'},
    {'1': 'last_used_at', '3': 6, '4': 1, '5': 3, '10': 'lastUsedAt'},
  ],
};

/// Descriptor for `PasskeyCredential`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyCredentialDescriptor = $convert.base64Decode(
    'ChFQYXNza2V5Q3JlZGVudGlhbBIjCg1jcmVkZW50aWFsX2lkGAEgASgJUgxjcmVkZW50aWFsSW'
    'QSEgoEbmFtZRgCIAEoCVIEbmFtZRIdCgpzaWduX2NvdW50GAMgASgDUglzaWduQ291bnQSHQoK'
    'Y3JlYXRlZF9hdBgEIAEoA1IJY3JlYXRlZEF0Eh0KCnVwZGF0ZWRfYXQYBSABKANSCXVwZGF0ZW'
    'RBdBIgCgxsYXN0X3VzZWRfYXQYBiABKANSCmxhc3RVc2VkQXQ=');

@$core.Deprecated('Use passkeyCredentialResponseDescriptor instead')
const PasskeyCredentialResponse$json = {
  '1': 'PasskeyCredentialResponse',
  '2': [
    {
      '1': 'credential',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyCredential',
      '10': 'credential'
    },
  ],
};

/// Descriptor for `PasskeyCredentialResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyCredentialResponseDescriptor =
    $convert.base64Decode(
        'ChlQYXNza2V5Q3JlZGVudGlhbFJlc3BvbnNlEkAKCmNyZWRlbnRpYWwYASABKAsyIC5zeW5jdH'
        'YuY2xpZW50LlBhc3NrZXlDcmVkZW50aWFsUgpjcmVkZW50aWFs');

@$core.Deprecated('Use listPasskeysRequestDescriptor instead')
const ListPasskeysRequest$json = {
  '1': 'ListPasskeysRequest',
};

/// Descriptor for `ListPasskeysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPasskeysRequestDescriptor =
    $convert.base64Decode('ChNMaXN0UGFzc2tleXNSZXF1ZXN0');

@$core.Deprecated('Use listPasskeysResponseDescriptor instead')
const ListPasskeysResponse$json = {
  '1': 'ListPasskeysResponse',
  '2': [
    {
      '1': 'credentials',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PasskeyCredential',
      '10': 'credentials'
    },
  ],
};

/// Descriptor for `ListPasskeysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPasskeysResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UGFzc2tleXNSZXNwb25zZRJCCgtjcmVkZW50aWFscxgBIAMoCzIgLnN5bmN0di5jbG'
    'llbnQuUGFzc2tleUNyZWRlbnRpYWxSC2NyZWRlbnRpYWxz');

@$core.Deprecated('Use deletePasskeyRequestDescriptor instead')
const DeletePasskeyRequest$json = {
  '1': 'DeletePasskeyRequest',
  '2': [
    {
      '1': 'credential_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'credentialId'
    },
    {
      '1': 'verification_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'verificationId'
    },
  ],
};

/// Descriptor for `DeletePasskeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePasskeyRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVQYXNza2V5UmVxdWVzdBIvCg1jcmVkZW50aWFsX2lkGAEgASgJQgq6SAdyBRABGI'
    'AQUgxjcmVkZW50aWFsSWQSMwoPdmVyaWZpY2F0aW9uX2lkGAIgASgJQgq6SAdyBRABGIABUg52'
    'ZXJpZmljYXRpb25JZA==');

@$core.Deprecated('Use deletePasskeyResponseDescriptor instead')
const DeletePasskeyResponse$json = {
  '1': 'DeletePasskeyResponse',
  '2': [
    {'1': 'deleted', '3': 1, '4': 1, '5': 8, '10': 'deleted'},
  ],
};

/// Descriptor for `DeletePasskeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePasskeyResponseDescriptor =
    $convert.base64Decode(
        'ChVEZWxldGVQYXNza2V5UmVzcG9uc2USGAoHZGVsZXRlZBgBIAEoCFIHZGVsZXRlZA==');

@$core.Deprecated('Use userAuthFactorsDescriptor instead')
const UserAuthFactors$json = {
  '1': 'UserAuthFactors',
  '2': [
    {'1': 'password', '3': 1, '4': 1, '5': 8, '10': 'password'},
    {'1': 'webauthn', '3': 2, '4': 1, '5': 8, '10': 'webauthn'},
    {'1': 'email', '3': 3, '4': 1, '5': 8, '10': 'email'},
    {'1': 'eligible_count', '3': 4, '4': 1, '5': 5, '10': 'eligibleCount'},
  ],
};

/// Descriptor for `UserAuthFactors`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAuthFactorsDescriptor = $convert.base64Decode(
    'Cg9Vc2VyQXV0aEZhY3RvcnMSGgoIcGFzc3dvcmQYASABKAhSCHBhc3N3b3JkEhoKCHdlYmF1dG'
    'huGAIgASgIUgh3ZWJhdXRobhIUCgVlbWFpbBgDIAEoCFIFZW1haWwSJQoOZWxpZ2libGVfY291'
    'bnQYBCABKAVSDWVsaWdpYmxlQ291bnQ=');

@$core.Deprecated('Use userPreferencesDescriptor instead')
const UserPreferences$json = {
  '1': 'UserPreferences',
  '2': [
    {
      '1': 'two_factor_enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'twoFactorEnabled'
    },
    {
      '1': 'notifications',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserNotificationPreferences',
      '10': 'notifications'
    },
    {'1': 'settings', '3': 15, '4': 1, '5': 12, '10': 'settings'},
  ],
};

/// Descriptor for `UserPreferences`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPreferencesDescriptor = $convert.base64Decode(
    'Cg9Vc2VyUHJlZmVyZW5jZXMSLAoSdHdvX2ZhY3Rvcl9lbmFibGVkGAEgASgIUhB0d29GYWN0b3'
    'JFbmFibGVkElAKDW5vdGlmaWNhdGlvbnMYAyABKAsyKi5zeW5jdHYuY2xpZW50LlVzZXJOb3Rp'
    'ZmljYXRpb25QcmVmZXJlbmNlc1INbm90aWZpY2F0aW9ucxIaCghzZXR0aW5ncxgPIAEoDFIIc2'
    'V0dGluZ3M=');

@$core.Deprecated('Use userNotificationPreferencesDescriptor instead')
const UserNotificationPreferences$json = {
  '1': 'UserNotificationPreferences',
  '2': [
    {
      '1': 'room_invitation_in_app',
      '3': 1,
      '4': 1,
      '5': 8,
      '10': 'roomInvitationInApp'
    },
    {'1': 'room_event_in_app', '3': 2, '4': 1, '5': 8, '10': 'roomEventInApp'},
    {
      '1': 'system_announcement_in_app',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'systemAnnouncementInApp'
    },
    {
      '1': 'room_invitation_email',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'roomInvitationEmail'
    },
    {'1': 'room_event_email', '3': 5, '4': 1, '5': 8, '10': 'roomEventEmail'},
    {
      '1': 'system_announcement_email',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'systemAnnouncementEmail'
    },
  ],
};

/// Descriptor for `UserNotificationPreferences`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userNotificationPreferencesDescriptor = $convert.base64Decode(
    'ChtVc2VyTm90aWZpY2F0aW9uUHJlZmVyZW5jZXMSMwoWcm9vbV9pbnZpdGF0aW9uX2luX2FwcB'
    'gBIAEoCFITcm9vbUludml0YXRpb25JbkFwcBIpChFyb29tX2V2ZW50X2luX2FwcBgCIAEoCFIO'
    'cm9vbUV2ZW50SW5BcHASOwoac3lzdGVtX2Fubm91bmNlbWVudF9pbl9hcHAYAyABKAhSF3N5c3'
    'RlbUFubm91bmNlbWVudEluQXBwEjIKFXJvb21faW52aXRhdGlvbl9lbWFpbBgEIAEoCFITcm9v'
    'bUludml0YXRpb25FbWFpbBIoChByb29tX2V2ZW50X2VtYWlsGAUgASgIUg5yb29tRXZlbnRFbW'
    'FpbBI6ChlzeXN0ZW1fYW5ub3VuY2VtZW50X2VtYWlsGAYgASgIUhdzeXN0ZW1Bbm5vdW5jZW1l'
    'bnRFbWFpbA==');

@$core.Deprecated('Use getUserPreferencesRequestDescriptor instead')
const GetUserPreferencesRequest$json = {
  '1': 'GetUserPreferencesRequest',
};

/// Descriptor for `GetUserPreferencesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserPreferencesRequestDescriptor =
    $convert.base64Decode('ChlHZXRVc2VyUHJlZmVyZW5jZXNSZXF1ZXN0');

@$core.Deprecated('Use getUserPreferencesResponseDescriptor instead')
const GetUserPreferencesResponse$json = {
  '1': 'GetUserPreferencesResponse',
  '2': [
    {
      '1': 'preferences',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPreferences',
      '10': 'preferences'
    },
    {
      '1': 'auth_factors',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAuthFactors',
      '10': 'authFactors'
    },
  ],
};

/// Descriptor for `GetUserPreferencesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserPreferencesResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRVc2VyUHJlZmVyZW5jZXNSZXNwb25zZRJACgtwcmVmZXJlbmNlcxgBIAEoCzIeLnN5bm'
        'N0di5jbGllbnQuVXNlclByZWZlcmVuY2VzUgtwcmVmZXJlbmNlcxJBCgxhdXRoX2ZhY3RvcnMY'
        'AiABKAsyHi5zeW5jdHYuY2xpZW50LlVzZXJBdXRoRmFjdG9yc1ILYXV0aEZhY3RvcnM=');

@$core.Deprecated('Use updateUserPreferencesRequestDescriptor instead')
const UpdateUserPreferencesRequest$json = {
  '1': 'UpdateUserPreferencesRequest',
  '2': [
    {
      '1': 'two_factor_enabled',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'twoFactorEnabled',
      '17': true
    },
    {
      '1': 'notifications',
      '3': 3,
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
    'ChxVcGRhdGVVc2VyUHJlZmVyZW5jZXNSZXF1ZXN0EjEKEnR3b19mYWN0b3JfZW5hYmxlZBgBIA'
    'EoCEgAUhB0d29GYWN0b3JFbmFibGVkiAEBElAKDW5vdGlmaWNhdGlvbnMYAyABKAsyKi5zeW5j'
    'dHYuY2xpZW50LlVzZXJOb3RpZmljYXRpb25QcmVmZXJlbmNlc1INbm90aWZpY2F0aW9uc0IVCh'
    'NfdHdvX2ZhY3Rvcl9lbmFibGVk');

@$core.Deprecated('Use updateUserPreferencesResponseDescriptor instead')
const UpdateUserPreferencesResponse$json = {
  '1': 'UpdateUserPreferencesResponse',
  '2': [
    {
      '1': 'preferences',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPreferences',
      '10': 'preferences'
    },
    {
      '1': 'auth_factors',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAuthFactors',
      '10': 'authFactors'
    },
  ],
};

/// Descriptor for `UpdateUserPreferencesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserPreferencesResponseDescriptor = $convert.base64Decode(
    'Ch1VcGRhdGVVc2VyUHJlZmVyZW5jZXNSZXNwb25zZRJACgtwcmVmZXJlbmNlcxgBIAEoCzIeLn'
    'N5bmN0di5jbGllbnQuVXNlclByZWZlcmVuY2VzUgtwcmVmZXJlbmNlcxJBCgxhdXRoX2ZhY3Rv'
    'cnMYAiABKAsyHi5zeW5jdHYuY2xpZW50LlVzZXJBdXRoRmFjdG9yc1ILYXV0aEZhY3RvcnM=');

@$core.Deprecated('Use requestEmailLoginRequestDescriptor instead')
const RequestEmailLoginRequest$json = {
  '1': 'RequestEmailLoginRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `RequestEmailLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEmailLoginRequestDescriptor =
    $convert.base64Decode(
        'ChhSZXF1ZXN0RW1haWxMb2dpblJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWls');

@$core.Deprecated('Use requestEmailLoginResponseDescriptor instead')
const RequestEmailLoginResponse$json = {
  '1': 'RequestEmailLoginResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RequestEmailLoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEmailLoginResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0RW1haWxMb2dpblJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use requestMfaEmailCodeRequestDescriptor instead')
const RequestMfaEmailCodeRequest$json = {
  '1': 'RequestMfaEmailCodeRequest',
  '2': [
    {
      '1': 'mfa_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'mfaSessionId'
    },
  ],
};

/// Descriptor for `RequestMfaEmailCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestMfaEmailCodeRequestDescriptor =
    $convert.base64Decode(
        'ChpSZXF1ZXN0TWZhRW1haWxDb2RlUmVxdWVzdBIwCg5tZmFfc2Vzc2lvbl9pZBgBIAEoCUIKuk'
        'gHcgUQARiAAVIMbWZhU2Vzc2lvbklk');

@$core.Deprecated('Use requestMfaEmailCodeResponseDescriptor instead')
const RequestMfaEmailCodeResponse$json = {
  '1': 'RequestMfaEmailCodeResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'masked_email', '3': 2, '4': 1, '5': 9, '10': 'maskedEmail'},
  ],
};

/// Descriptor for `RequestMfaEmailCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestMfaEmailCodeResponseDescriptor =
    $convert.base64Decode(
        'ChtSZXF1ZXN0TWZhRW1haWxDb2RlUmVzcG9uc2USGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZR'
        'IhCgxtYXNrZWRfZW1haWwYAiABKAlSC21hc2tlZEVtYWls');

@$core.Deprecated('Use verifyMfaEmailCodeRequestDescriptor instead')
const VerifyMfaEmailCodeRequest$json = {
  '1': 'VerifyMfaEmailCodeRequest',
  '2': [
    {
      '1': 'mfa_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'mfaSessionId'
    },
    {'1': 'email_token', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'emailToken'},
  ],
};

/// Descriptor for `VerifyMfaEmailCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyMfaEmailCodeRequestDescriptor = $convert.base64Decode(
    'ChlWZXJpZnlNZmFFbWFpbENvZGVSZXF1ZXN0EjAKDm1mYV9zZXNzaW9uX2lkGAEgASgJQgq6SA'
    'dyBRABGIABUgxtZmFTZXNzaW9uSWQSKwoLZW1haWxfdG9rZW4YAiABKAlCCrpIB3IFEAEY/wFS'
    'CmVtYWlsVG9rZW4=');

@$core.Deprecated('Use startMfaPasskeyRequestDescriptor instead')
const StartMfaPasskeyRequest$json = {
  '1': 'StartMfaPasskeyRequest',
  '2': [
    {
      '1': 'mfa_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'mfaSessionId'
    },
  ],
};

/// Descriptor for `StartMfaPasskeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startMfaPasskeyRequestDescriptor =
    $convert.base64Decode(
        'ChZTdGFydE1mYVBhc3NrZXlSZXF1ZXN0EjAKDm1mYV9zZXNzaW9uX2lkGAEgASgJQgq6SAdyBR'
        'ABGIABUgxtZmFTZXNzaW9uSWQ=');

@$core.Deprecated('Use startMfaPasskeyResponseDescriptor instead')
const StartMfaPasskeyResponse$json = {
  '1': 'StartMfaPasskeyResponse',
  '2': [
    {
      '1': 'passkey_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'passkeySessionId'
    },
    {'1': 'options', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'options'},
  ],
};

/// Descriptor for `StartMfaPasskeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startMfaPasskeyResponseDescriptor = $convert.base64Decode(
    'ChdTdGFydE1mYVBhc3NrZXlSZXNwb25zZRI4ChJwYXNza2V5X3Nlc3Npb25faWQYASABKAlCCr'
    'pIB3IFEAEYgAFSEHBhc3NrZXlTZXNzaW9uSWQSJQoHb3B0aW9ucxgCIAEoDEILukgIegYQARiA'
    'gARSB29wdGlvbnM=');

@$core.Deprecated('Use finishMfaPasskeyRequestDescriptor instead')
const FinishMfaPasskeyRequest$json = {
  '1': 'FinishMfaPasskeyRequest',
  '2': [
    {
      '1': 'mfa_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'mfaSessionId'
    },
    {
      '1': 'passkey_session_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'passkeySessionId'
    },
    {'1': 'credential', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'credential'},
  ],
};

/// Descriptor for `FinishMfaPasskeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishMfaPasskeyRequestDescriptor = $convert.base64Decode(
    'ChdGaW5pc2hNZmFQYXNza2V5UmVxdWVzdBIwCg5tZmFfc2Vzc2lvbl9pZBgBIAEoCUIKukgHcg'
    'UQARiAAVIMbWZhU2Vzc2lvbklkEjgKEnBhc3NrZXlfc2Vzc2lvbl9pZBgCIAEoCUIKukgHcgUQ'
    'ARiAAVIQcGFzc2tleVNlc3Npb25JZBIrCgpjcmVkZW50aWFsGAMgASgMQgu6SAh6BhABGICABF'
    'IKY3JlZGVudGlhbA==');

@$core.Deprecated('Use refreshTokenRequestDescriptor instead')
const RefreshTokenRequest$json = {
  '1': 'RefreshTokenRequest',
  '2': [
    {
      '1': 'refresh_token',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'refreshToken'
    },
  ],
};

/// Descriptor for `RefreshTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokenRequestDescriptor = $convert.base64Decode(
    'ChNSZWZyZXNoVG9rZW5SZXF1ZXN0Ei8KDXJlZnJlc2hfdG9rZW4YASABKAlCCrpIB3IFEAEYgC'
    'BSDHJlZnJlc2hUb2tlbg==');

@$core.Deprecated('Use refreshTokenResponseDescriptor instead')
const RefreshTokenResponse$json = {
  '1': 'RefreshTokenResponse',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `RefreshTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refreshTokenResponseDescriptor = $convert.base64Decode(
    'ChRSZWZyZXNoVG9rZW5SZXNwb25zZRIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2'
    'VuEiMKDXJlZnJlc2hfdG9rZW4YAiABKAlSDHJlZnJlc2hUb2tlbg==');

@$core.Deprecated('Use getProfileRequestDescriptor instead')
const GetProfileRequest$json = {
  '1': 'GetProfileRequest',
};

/// Descriptor for `GetProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProfileRequestDescriptor =
    $convert.base64Decode('ChFHZXRQcm9maWxlUmVxdWVzdA==');

@$core.Deprecated('Use getProfileResponseDescriptor instead')
const GetProfileResponse$json = {
  '1': 'GetProfileResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `GetProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProfileResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9maWxlUmVzcG9uc2USJwoEdXNlchgBIAEoCzITLnN5bmN0di5jbGllbnQuVXNlcl'
    'IEdXNlcg==');

@$core.Deprecated('Use closeAccountRequestDescriptor instead')
const CloseAccountRequest$json = {
  '1': 'CloseAccountRequest',
};

/// Descriptor for `CloseAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeAccountRequestDescriptor =
    $convert.base64Decode('ChNDbG9zZUFjY291bnRSZXF1ZXN0');

@$core.Deprecated('Use closeAccountResponseDescriptor instead')
const CloseAccountResponse$json = {
  '1': 'CloseAccountResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CloseAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeAccountResponseDescriptor =
    $convert.base64Decode(
        'ChRDbG9zZUFjY291bnRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use startOpaquePasswordUpdateRequestDescriptor instead')
const StartOpaquePasswordUpdateRequest$json = {
  '1': 'StartOpaquePasswordUpdateRequest',
  '2': [
    {
      '1': 'credential_request',
      '3': 1,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialRequest'
    },
    {
      '1': 'registration_request',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationRequest'
    },
    {
      '1': 'verification_method',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OpaquePasswordUpdateVerificationMethod',
      '10': 'verificationMethod'
    },
    {'1': 'email_token', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'emailToken'},
  ],
};

/// Descriptor for `StartOpaquePasswordUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaquePasswordUpdateRequestDescriptor = $convert.base64Decode(
    'CiBTdGFydE9wYXF1ZVBhc3N3b3JkVXBkYXRlUmVxdWVzdBI3ChJjcmVkZW50aWFsX3JlcXVlc3'
    'QYASABKAxCCLpIBXoDGIAgUhFjcmVkZW50aWFsUmVxdWVzdBI9ChRyZWdpc3RyYXRpb25fcmVx'
    'dWVzdBgCIAEoDEIKukgHegUQARiAIFITcmVnaXN0cmF0aW9uUmVxdWVzdBJmChN2ZXJpZmljYX'
    'Rpb25fbWV0aG9kGAQgASgOMjUuc3luY3R2LmNsaWVudC5PcGFxdWVQYXNzd29yZFVwZGF0ZVZl'
    'cmlmaWNhdGlvbk1ldGhvZFISdmVyaWZpY2F0aW9uTWV0aG9kEikKC2VtYWlsX3Rva2VuGAYgAS'
    'gJQgi6SAVyAxiAAVIKZW1haWxUb2tlbg==');

@$core.Deprecated('Use startOpaquePasswordUpdateResponseDescriptor instead')
const StartOpaquePasswordUpdateResponse$json = {
  '1': 'StartOpaquePasswordUpdateResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'credential_response',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'credentialResponse'
    },
    {
      '1': 'registration_response',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'registrationResponse'
    },
    {
      '1': 'passkey_session_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'passkeySessionId'
    },
    {'1': 'passkey_options', '3': 5, '4': 1, '5': 12, '10': 'passkeyOptions'},
  ],
};

/// Descriptor for `StartOpaquePasswordUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaquePasswordUpdateResponseDescriptor = $convert.base64Decode(
    'CiFTdGFydE9wYXF1ZVBhc3N3b3JkVXBkYXRlUmVzcG9uc2USKQoKc2Vzc2lvbl9pZBgBIAEoCU'
    'IKukgHcgUQARiAAVIJc2Vzc2lvbklkEi8KE2NyZWRlbnRpYWxfcmVzcG9uc2UYAiABKAxSEmNy'
    'ZWRlbnRpYWxSZXNwb25zZRIzChVyZWdpc3RyYXRpb25fcmVzcG9uc2UYAyABKAxSFHJlZ2lzdH'
    'JhdGlvblJlc3BvbnNlEiwKEnBhc3NrZXlfc2Vzc2lvbl9pZBgEIAEoCVIQcGFzc2tleVNlc3Np'
    'b25JZBInCg9wYXNza2V5X29wdGlvbnMYBSABKAxSDnBhc3NrZXlPcHRpb25z');

@$core.Deprecated('Use finishOpaquePasswordUpdateRequestDescriptor instead')
const FinishOpaquePasswordUpdateRequest$json = {
  '1': 'FinishOpaquePasswordUpdateRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'credential_finalization',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialFinalization'
    },
    {
      '1': 'registration_upload',
      '3': 3,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationUpload'
    },
    {
      '1': 'passkey_session_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'passkeySessionId'
    },
    {
      '1': 'passkey_credential',
      '3': 6,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'passkeyCredential'
    },
  ],
};

/// Descriptor for `FinishOpaquePasswordUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishOpaquePasswordUpdateRequestDescriptor = $convert.base64Decode(
    'CiFGaW5pc2hPcGFxdWVQYXNzd29yZFVwZGF0ZVJlcXVlc3QSKQoKc2Vzc2lvbl9pZBgBIAEoCU'
    'IKukgHcgUQARiAAVIJc2Vzc2lvbklkEkEKF2NyZWRlbnRpYWxfZmluYWxpemF0aW9uGAIgASgM'
    'Qgi6SAV6AxiAIFIWY3JlZGVudGlhbEZpbmFsaXphdGlvbhI7ChNyZWdpc3RyYXRpb25fdXBsb2'
    'FkGAMgASgMQgq6SAd6BRABGIAgUhJyZWdpc3RyYXRpb25VcGxvYWQSNgoScGFzc2tleV9zZXNz'
    'aW9uX2lkGAUgASgJQgi6SAVyAxiAAVIQcGFzc2tleVNlc3Npb25JZBI4ChJwYXNza2V5X2NyZW'
    'RlbnRpYWwYBiABKAxCCbpIBnoEGICAAVIRcGFzc2tleUNyZWRlbnRpYWw=');

@$core.Deprecated('Use finishOpaquePasswordUpdateResponseDescriptor instead')
const FinishOpaquePasswordUpdateResponse$json = {
  '1': 'FinishOpaquePasswordUpdateResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `FinishOpaquePasswordUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishOpaquePasswordUpdateResponseDescriptor =
    $convert.base64Decode(
        'CiJGaW5pc2hPcGFxdWVQYXNzd29yZFVwZGF0ZVJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5zeW'
        '5jdHYuY2xpZW50LlVzZXJSBHVzZXI=');

@$core.Deprecated('Use createWebSocketTicketRequestDescriptor instead')
const CreateWebSocketTicketRequest$json = {
  '1': 'CreateWebSocketTicketRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `CreateWebSocketTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWebSocketTicketRequestDescriptor =
    $convert.base64Decode(
        'ChxDcmVhdGVXZWJTb2NrZXRUaWNrZXRSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEA'
        'EYQDITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlk');

@$core.Deprecated('Use createWebSocketTicketResponseDescriptor instead')
const CreateWebSocketTicketResponse$json = {
  '1': 'CreateWebSocketTicketResponse',
  '2': [
    {'1': 'ticket', '3': 1, '4': 1, '5': 9, '10': 'ticket'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'expires_in_secs', '3': 3, '4': 1, '5': 4, '10': 'expiresInSecs'},
    {'1': 'usage', '3': 4, '4': 1, '5': 9, '10': 'usage'},
  ],
};

/// Descriptor for `CreateWebSocketTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createWebSocketTicketResponseDescriptor =
    $convert.base64Decode(
        'Ch1DcmVhdGVXZWJTb2NrZXRUaWNrZXRSZXNwb25zZRIWCgZ0aWNrZXQYASABKAlSBnRpY2tldB'
        'IXCgdyb29tX2lkGAIgASgJUgZyb29tSWQSJgoPZXhwaXJlc19pbl9zZWNzGAMgASgEUg1leHBp'
        'cmVzSW5TZWNzEhQKBXVzYWdlGAQgASgJUgV1c2FnZQ==');

@$core.Deprecated('Use createGuestTokenRequestDescriptor instead')
const CreateGuestTokenRequest$json = {
  '1': 'CreateGuestTokenRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `CreateGuestTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGuestTokenRequestDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVHdWVzdFRva2VuUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGEAyE1'
        '5yb29tX1tBLVphLXowLTldKyRSBnJvb21JZA==');

@$core.Deprecated('Use createGuestTokenResponseDescriptor instead')
const CreateGuestTokenResponse$json = {
  '1': 'CreateGuestTokenResponse',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'guest_id', '3': 3, '4': 1, '5': 9, '10': 'guestId'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'expires_at', '3': 5, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'expires_in_secs', '3': 6, '4': 1, '5': 4, '10': 'expiresInSecs'},
    {'1': 'usage', '3': 7, '4': 1, '5': 9, '10': 'usage'},
  ],
};

/// Descriptor for `CreateGuestTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createGuestTokenResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVHdWVzdFRva2VuUmVzcG9uc2USFAoFdG9rZW4YASABKAlSBXRva2VuEhcKB3Jvb2'
    '1faWQYAiABKAlSBnJvb21JZBIZCghndWVzdF9pZBgDIAEoCVIHZ3Vlc3RJZBIhCgxkaXNwbGF5'
    'X25hbWUYBCABKAlSC2Rpc3BsYXlOYW1lEh0KCmV4cGlyZXNfYXQYBSABKANSCWV4cGlyZXNBdB'
    'ImCg9leHBpcmVzX2luX3NlY3MYBiABKARSDWV4cGlyZXNJblNlY3MSFAoFdXNhZ2UYByABKAlS'
    'BXVzYWdl');

@$core.Deprecated('Use webSocketConnectRequestDescriptor instead')
const WebSocketConnectRequest$json = {
  '1': 'WebSocketConnectRequest',
  '2': [
    {'1': 'ticket', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'ticket'},
  ],
};

/// Descriptor for `WebSocketConnectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webSocketConnectRequestDescriptor = $convert.base64Decode(
    'ChdXZWJTb2NrZXRDb25uZWN0UmVxdWVzdBLXAQoGdGlja2V0GAEgASgJQr4Buki6AboBtgEKMH'
    'dlYnNvY2tldF9jb25uZWN0X3JlcXVlc3QudGlja2V0Lm9wdGlvbmFsX2Zvcm1hdBI8dGlja2V0'
    'IG11c3QgYmUgZW1wdHkgb3IgYSBVUkwtc2FmZSB0b2tlbiB1cCB0byA0MyBjaGFyYWN0ZXJzGk'
    'R0aGlzID09ICcnIHx8IChzaXplKHRoaXMpIDw9IDQzICYmIHRoaXMubWF0Y2hlcygnXltBLVph'
    'LXowLTlfLV0rJCcpKVIGdGlja2V0');

@$core.Deprecated('Use createRoomRequestDescriptor instead')
const CreateRoomRequest$json = {
  '1': 'CreateRoomRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'settings', '3': 2, '4': 1, '5': 12, '10': 'settings'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'description'},
    {'1': 'password', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'password'},
  ],
};

/// Descriptor for `CreateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSb29tUmVxdWVzdBKXAQoEbmFtZRgBIAEoCUKCAbpIf3IEEAEYZLoBdgoiY3JlYX'
    'RlX3Jvb20ubmFtZS5ub19hbmdsZV9icmFja2V0cxIkbmFtZSBtdXN0IG5vdCBjb250YWluIEhU'
    'TUwtbGlrZSB0YWdzGiohdGhpcy5jb250YWlucygnPCcpICYmICF0aGlzLmNvbnRhaW5zKCc+Jy'
    'lSBG5hbWUSGgoIc2V0dGluZ3MYAiABKAxSCHNldHRpbmdzErQBCgtkZXNjcmlwdGlvbhgDIAEo'
    'CUKRAbpIjQFyAxj0A7oBhAEKKWNyZWF0ZV9yb29tLmRlc2NyaXB0aW9uLm5vX2FuZ2xlX2JyYW'
    'NrZXRzEitkZXNjcmlwdGlvbiBtdXN0IG5vdCBjb250YWluIEhUTUwtbGlrZSB0YWdzGiohdGhp'
    'cy5jb250YWlucygnPCcpICYmICF0aGlzLmNvbnRhaW5zKCc+JylSC2Rlc2NyaXB0aW9uEiQKCH'
    'Bhc3N3b3JkGAQgASgJQgi6SAVyAxiAAVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use createRoomResponseDescriptor instead')
const CreateRoomResponse$json = {
  '1': 'CreateRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
  ],
};

/// Descriptor for `CreateRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVSb29tUmVzcG9uc2USJwoEcm9vbRgBIAEoCzITLnN5bmN0di5jbGllbnQuUm9vbV'
    'IEcm9vbQ==');

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

@$core.Deprecated('Use getRoomResponseDescriptor instead')
const GetRoomResponse$json = {
  '1': 'GetRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
    {
      '1': 'playback_state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackState',
      '10': 'playbackState'
    },
  ],
};

/// Descriptor for `GetRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRSb29tUmVzcG9uc2USJwoEcm9vbRgBIAEoCzITLnN5bmN0di5jbGllbnQuUm9vbVIEcm'
    '9vbRJDCg5wbGF5YmFja19zdGF0ZRgCIAEoCzIcLnN5bmN0di5jbGllbnQuUGxheWJhY2tTdGF0'
    'ZVINcGxheWJhY2tTdGF0ZQ==');

@$core.Deprecated('Use joinRoomRequestDescriptor instead')
const JoinRoomRequest$json = {
  '1': 'JoinRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'password'},
  ],
};

/// Descriptor for `JoinRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomRequestDescriptor = $convert.base64Decode(
    'Cg9Kb2luUm9vbVJlcXVlc3QSNwoHcm9vbV9pZBgBIAEoCUIeukgbchkQARhAMhNecm9vbV9bQS'
    '1aYS16MC05XSskUgZyb29tSWQSJAoIcGFzc3dvcmQYAiABKAlCCLpIBXIDGIABUghwYXNzd29y'
    'ZA==');

@$core.Deprecated('Use joinRoomResponseDescriptor instead')
const JoinRoomResponse$json = {
  '1': 'JoinRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
    {
      '1': 'playback_state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackState',
      '10': 'playbackState'
    },
    {
      '1': 'members',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '10': 'members'
    },
    {
      '1': 'membership_status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.MemberStatus',
      '10': 'membershipStatus'
    },
    {
      '1': 'requires_approval',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'requiresApproval'
    },
  ],
};

/// Descriptor for `JoinRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomResponseDescriptor = $convert.base64Decode(
    'ChBKb2luUm9vbVJlc3BvbnNlEicKBHJvb20YASABKAsyEy5zeW5jdHYuY2xpZW50LlJvb21SBH'
    'Jvb20SQwoOcGxheWJhY2tfc3RhdGUYAiABKAsyHC5zeW5jdHYuY2xpZW50LlBsYXliYWNrU3Rh'
    'dGVSDXBsYXliYWNrU3RhdGUSMwoHbWVtYmVycxgDIAMoCzIZLnN5bmN0di5jb21tb24uUm9vbU'
    '1lbWJlclIHbWVtYmVycxJIChFtZW1iZXJzaGlwX3N0YXR1cxgEIAEoDjIbLnN5bmN0di5jb21t'
    'b24uTWVtYmVyU3RhdHVzUhBtZW1iZXJzaGlwU3RhdHVzEisKEXJlcXVpcmVzX2FwcHJvdmFsGA'
    'UgASgIUhByZXF1aXJlc0FwcHJvdmFs');

@$core.Deprecated('Use leaveRoomRequestDescriptor instead')
const LeaveRoomRequest$json = {
  '1': 'LeaveRoomRequest',
};

/// Descriptor for `LeaveRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveRoomRequestDescriptor =
    $convert.base64Decode('ChBMZWF2ZVJvb21SZXF1ZXN0');

@$core.Deprecated('Use leaveRoomResponseDescriptor instead')
const LeaveRoomResponse$json = {
  '1': 'LeaveRoomResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LeaveRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaveRoomResponseDescriptor = $convert.base64Decode(
    'ChFMZWF2ZVJvb21SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use listRoomsRequestDescriptor instead')
const ListRoomsRequest$json = {
  '1': 'ListRoomsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'sort_by',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.RoomListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
};

/// Descriptor for `ListRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Um9vbXNSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAIgAS'
    'gFUghwYWdlU2l6ZRIfCgZzZWFyY2gYAyABKAlCB7pIBHICGGRSBnNlYXJjaBJACgdzb3J0X2J5'
    'GAQgASgOMh0uc3luY3R2LmNsaWVudC5Sb29tTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRCeR'
    'JNCg5zb3J0X2RpcmVjdGlvbhgFIAEoDjIcLnN5bmN0di5jbGllbnQuU29ydERpcmVjdGlvbkII'
    'ukgFggECEAFSDXNvcnREaXJlY3Rpb246/QG6SPkBGl8KD2xpc3Rfcm9vbXMucGFnZRIqcGFnZS'
    'BtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdCAxGiB0aGlzLnBhZ2UgPT0gMCB8'
    'fCB0aGlzLnBhZ2UgPj0gMRqVAQoUbGlzdF9yb29tcy5wYWdlX3NpemUSNnBhZ2Vfc2l6ZSBtdX'
    'N0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBpFdGhpcy5wYWdlX3Np'
    'emUgPT0gMCB8fCAodGhpcy5wYWdlX3NpemUgPj0gMSAmJiB0aGlzLnBhZ2Vfc2l6ZSA8PSAxMD'
    'Ap');

@$core.Deprecated('Use listRoomsResponseDescriptor instead')
const ListRoomsResponse$json = {
  '1': 'ListRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Um9vbXNSZXNwb25zZRIpCgVyb29tcxgBIAMoCzITLnN5bmN0di5jbGllbnQuUm9vbV'
    'IFcm9vbXMSFAoFdG90YWwYAiABKAVSBXRvdGFs');

@$core.Deprecated('Use deleteRoomRequestDescriptor instead')
const DeleteRoomRequest$json = {
  '1': 'DeleteRoomRequest',
};

/// Descriptor for `DeleteRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRoomRequestDescriptor =
    $convert.base64Decode('ChFEZWxldGVSb29tUmVxdWVzdA==');

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

@$core.Deprecated('Use updateRoomSettingsRequestDescriptor instead')
const UpdateRoomSettingsRequest$json = {
  '1': 'UpdateRoomSettingsRequest',
  '2': [
    {'1': 'settings', '3': 1, '4': 1, '5': 12, '10': 'settings'},
  ],
};

/// Descriptor for `UpdateRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomSettingsRequestDescriptor =
    $convert.base64Decode(
        'ChlVcGRhdGVSb29tU2V0dGluZ3NSZXF1ZXN0EhoKCHNldHRpbmdzGAEgASgMUghzZXR0aW5ncw'
        '==');

@$core.Deprecated('Use updateRoomSettingsResponseDescriptor instead')
const UpdateRoomSettingsResponse$json = {
  '1': 'UpdateRoomSettingsResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
  ],
};

/// Descriptor for `UpdateRoomSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVSb29tU2V0dGluZ3NSZXNwb25zZRInCgRyb29tGAEgASgLMhMuc3luY3R2LmNsaW'
        'VudC5Sb29tUgRyb29t');

@$core.Deprecated('Use getRoomSettingsRequestDescriptor instead')
const GetRoomSettingsRequest$json = {
  '1': 'GetRoomSettingsRequest',
};

/// Descriptor for `GetRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomSettingsRequestDescriptor =
    $convert.base64Decode('ChZHZXRSb29tU2V0dGluZ3NSZXF1ZXN0');

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

@$core.Deprecated('Use resetRoomSettingsRequestDescriptor instead')
const ResetRoomSettingsRequest$json = {
  '1': 'ResetRoomSettingsRequest',
};

/// Descriptor for `ResetRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetRoomSettingsRequestDescriptor =
    $convert.base64Decode('ChhSZXNldFJvb21TZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use resetRoomSettingsResponseDescriptor instead')
const ResetRoomSettingsResponse$json = {
  '1': 'ResetRoomSettingsResponse',
  '2': [
    {'1': 'settings', '3': 1, '4': 1, '5': 12, '10': 'settings'},
  ],
};

/// Descriptor for `ResetRoomSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetRoomSettingsResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXNldFJvb21TZXR0aW5nc1Jlc3BvbnNlEhoKCHNldHRpbmdzGAEgASgMUghzZXR0aW5ncw'
        '==');

@$core.Deprecated('Use transferRoomOwnershipRequestDescriptor instead')
const TransferRoomOwnershipRequest$json = {
  '1': 'TransferRoomOwnershipRequest',
  '2': [
    {
      '1': 'new_owner_user_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'newOwnerUserId'
    },
  ],
};

/// Descriptor for `TransferRoomOwnershipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferRoomOwnershipRequestDescriptor =
    $convert.base64Decode(
        'ChxUcmFuc2ZlclJvb21Pd25lcnNoaXBSZXF1ZXN0EkgKEW5ld19vd25lcl91c2VyX2lkGAEgAS'
        'gJQh26SBpyGBABGEAyEl51c3JfW0EtWmEtejAtOV0rJFIObmV3T3duZXJVc2VySWQ=');

@$core.Deprecated('Use transferRoomOwnershipResponseDescriptor instead')
const TransferRoomOwnershipResponse$json = {
  '1': 'TransferRoomOwnershipResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
  ],
};

/// Descriptor for `TransferRoomOwnershipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferRoomOwnershipResponseDescriptor =
    $convert.base64Decode(
        'Ch1UcmFuc2ZlclJvb21Pd25lcnNoaXBSZXNwb25zZRInCgRyb29tGAEgASgLMhMuc3luY3R2Lm'
        'NsaWVudC5Sb29tUgRyb29t');

@$core.Deprecated('Use startRoomPasswordRegistrationRequestDescriptor instead')
const StartRoomPasswordRegistrationRequest$json = {
  '1': 'StartRoomPasswordRegistrationRequest',
  '2': [
    {
      '1': 'registration_request',
      '3': 1,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationRequest'
    },
  ],
};

/// Descriptor for `StartRoomPasswordRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRoomPasswordRegistrationRequestDescriptor =
    $convert.base64Decode(
        'CiRTdGFydFJvb21QYXNzd29yZFJlZ2lzdHJhdGlvblJlcXVlc3QSPQoUcmVnaXN0cmF0aW9uX3'
        'JlcXVlc3QYASABKAxCCrpIB3oFEAEYgCBSE3JlZ2lzdHJhdGlvblJlcXVlc3Q=');

@$core.Deprecated('Use startRoomPasswordRegistrationResponseDescriptor instead')
const StartRoomPasswordRegistrationResponse$json = {
  '1': 'StartRoomPasswordRegistrationResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'registration_response',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'registrationResponse'
    },
  ],
};

/// Descriptor for `StartRoomPasswordRegistrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRoomPasswordRegistrationResponseDescriptor =
    $convert.base64Decode(
        'CiVTdGFydFJvb21QYXNzd29yZFJlZ2lzdHJhdGlvblJlc3BvbnNlEikKCnNlc3Npb25faWQYAS'
        'ABKAlCCrpIB3IFEAEYgAFSCXNlc3Npb25JZBIzChVyZWdpc3RyYXRpb25fcmVzcG9uc2UYAiAB'
        'KAxSFHJlZ2lzdHJhdGlvblJlc3BvbnNl');

@$core.Deprecated('Use finishRoomPasswordRegistrationRequestDescriptor instead')
const FinishRoomPasswordRegistrationRequest$json = {
  '1': 'FinishRoomPasswordRegistrationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'registration_upload',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationUpload'
    },
  ],
};

/// Descriptor for `FinishRoomPasswordRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishRoomPasswordRegistrationRequestDescriptor =
    $convert.base64Decode(
        'CiVGaW5pc2hSb29tUGFzc3dvcmRSZWdpc3RyYXRpb25SZXF1ZXN0EikKCnNlc3Npb25faWQYAS'
        'ABKAlCCrpIB3IFEAEYgAFSCXNlc3Npb25JZBI7ChNyZWdpc3RyYXRpb25fdXBsb2FkGAIgASgM'
        'Qgq6SAd6BRABGIAgUhJyZWdpc3RyYXRpb25VcGxvYWQ=');

@$core.Deprecated('Use clearRoomPasswordRequestDescriptor instead')
const ClearRoomPasswordRequest$json = {
  '1': 'ClearRoomPasswordRequest',
};

/// Descriptor for `ClearRoomPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearRoomPasswordRequestDescriptor =
    $convert.base64Decode('ChhDbGVhclJvb21QYXNzd29yZFJlcXVlc3Q=');

@$core.Deprecated('Use setRoomPasswordResponseDescriptor instead')
const SetRoomPasswordResponse$json = {
  '1': 'SetRoomPasswordResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SetRoomPasswordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setRoomPasswordResponseDescriptor =
    $convert.base64Decode(
        'ChdTZXRSb29tUGFzc3dvcmRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use startRoomPasswordLoginRequestDescriptor instead')
const StartRoomPasswordLoginRequest$json = {
  '1': 'StartRoomPasswordLoginRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {
      '1': 'credential_request',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialRequest'
    },
  ],
};

/// Descriptor for `StartRoomPasswordLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRoomPasswordLoginRequestDescriptor =
    $convert.base64Decode(
        'Ch1TdGFydFJvb21QYXNzd29yZExvZ2luUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGR'
        'ABGEAyE15yb29tX1tBLVphLXowLTldKyRSBnJvb21JZBI5ChJjcmVkZW50aWFsX3JlcXVlc3QY'
        'AiABKAxCCrpIB3oFEAEYgCBSEWNyZWRlbnRpYWxSZXF1ZXN0');

@$core.Deprecated('Use startRoomPasswordLoginResponseDescriptor instead')
const StartRoomPasswordLoginResponse$json = {
  '1': 'StartRoomPasswordLoginResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'credential_response',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'credentialResponse'
    },
  ],
};

/// Descriptor for `StartRoomPasswordLoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRoomPasswordLoginResponseDescriptor =
    $convert.base64Decode(
        'Ch5TdGFydFJvb21QYXNzd29yZExvZ2luUmVzcG9uc2USKQoKc2Vzc2lvbl9pZBgBIAEoCUIKuk'
        'gHcgUQARiAAVIJc2Vzc2lvbklkEi8KE2NyZWRlbnRpYWxfcmVzcG9uc2UYAiABKAxSEmNyZWRl'
        'bnRpYWxSZXNwb25zZQ==');

@$core.Deprecated('Use finishRoomPasswordLoginRequestDescriptor instead')
const FinishRoomPasswordLoginRequest$json = {
  '1': 'FinishRoomPasswordLoginRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'credential_finalization',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialFinalization'
    },
  ],
};

/// Descriptor for `FinishRoomPasswordLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishRoomPasswordLoginRequestDescriptor =
    $convert.base64Decode(
        'Ch5GaW5pc2hSb29tUGFzc3dvcmRMb2dpblJlcXVlc3QSKQoKc2Vzc2lvbl9pZBgBIAEoCUIKuk'
        'gHcgUQARiAAVIJc2Vzc2lvbklkEkMKF2NyZWRlbnRpYWxfZmluYWxpemF0aW9uGAIgASgMQgq6'
        'SAd6BRABGIAgUhZjcmVkZW50aWFsRmluYWxpemF0aW9u');

@$core.Deprecated('Use getRoomMembersRequestDescriptor instead')
const GetRoomMembersRequest$json = {
  '1': 'GetRoomMembersRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '8': {},
      '9': 0,
      '10': 'role',
      '17': true
    },
    {
      '1': 'sort_by',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.RoomMemberListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
  '8': [
    {'1': '_role'},
  ],
};

/// Descriptor for `GetRoomMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersRequestDescriptor = $convert.base64Decode(
    'ChVHZXRSb29tTWVtYmVyc1JlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIbCglwYWdlX3Npem'
    'UYAiABKAVSCHBhZ2VTaXplEh8KBnNlYXJjaBgDIAEoCUIHukgEcgIYZFIGc2VhcmNoEkAKBHJv'
    'bGUYBCABKA4yHS5zeW5jdHYuY29tbW9uLlJvb21NZW1iZXJSb2xlQgi6SAWCAQIQAUgAUgRyb2'
    'xliAEBEkYKB3NvcnRfYnkYBiABKA4yIy5zeW5jdHYuY2xpZW50LlJvb21NZW1iZXJMaXN0U29y'
    'dEJ5Qgi6SAWCAQIQAVIGc29ydEJ5Ek0KDnNvcnRfZGlyZWN0aW9uGAcgASgOMhwuc3luY3R2Lm'
    'NsaWVudC5Tb3J0RGlyZWN0aW9uQgi6SAWCAQIQAVINc29ydERpcmVjdGlvbjqJArpIhQIaZQoV'
    'Z2V0X3Jvb21fbWVtYmVycy5wYWdlEipwYWdlIG11c3QgYmUgMCAodXNlIGRlZmF1bHQpIG9yIG'
    'F0IGxlYXN0IDEaIHRoaXMucGFnZSA9PSAwIHx8IHRoaXMucGFnZSA+PSAxGpsBChpnZXRfcm9v'
    'bV9tZW1iZXJzLnBhZ2Vfc2l6ZRI2cGFnZV9zaXplIG11c3QgYmUgMCAodXNlIGRlZmF1bHQpIG'
    '9yIGJldHdlZW4gMSBhbmQgMTAwGkV0aGlzLnBhZ2Vfc2l6ZSA9PSAwIHx8ICh0aGlzLnBhZ2Vf'
    'c2l6ZSA+PSAxICYmIHRoaXMucGFnZV9zaXplIDw9IDEwMClCBwoFX3JvbGU=');

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
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'presence',
      '3': 4,
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
    '9uLlJvb21NZW1iZXJSB21lbWJlcnMSFAoFdG90YWwYAiABKAVSBXRvdGFsEhgKB3ZlcnNpb24Y'
    'AyABKAlSB3ZlcnNpb24SPAoIcHJlc2VuY2UYBCABKAsyIC5zeW5jdHYuY29tbW9uLlJvb21Qcm'
    'VzZW5jZVN0YXRzUghwcmVzZW5jZQ==');

@$core.Deprecated('Use listRoomStreamsRequestDescriptor instead')
const ListRoomStreamsRequest$json = {
  '1': 'ListRoomStreamsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'sort_by',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.RoomStreamListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
};

/// Descriptor for `ListRoomStreamsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomStreamsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0Um9vbVN0cmVhbXNSZXF1ZXN0EhIKBHBhZ2UYASABKAVSBHBhZ2USGwoJcGFnZV9zaX'
    'plGAIgASgFUghwYWdlU2l6ZRIfCgZzZWFyY2gYAyABKAlCB7pIBHICGGRSBnNlYXJjaBJGCgdz'
    'b3J0X2J5GAQgASgOMiMuc3luY3R2LmNsaWVudC5Sb29tU3RyZWFtTGlzdFNvcnRCeUIIukgFgg'
    'ECEAFSBnNvcnRCeRJNCg5zb3J0X2RpcmVjdGlvbhgFIAEoDjIcLnN5bmN0di5jbGllbnQuU29y'
    'dERpcmVjdGlvbkIIukgFggECEAFSDXNvcnREaXJlY3Rpb246iwK6SIcCGmYKFmxpc3Rfcm9vbV'
    '9zdHJlYW1zLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYXQgbGVhc3Qg'
    'MRogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEanAEKG2xpc3Rfcm9vbV9zdHJlYW'
    '1zLnBhZ2Vfc2l6ZRI2cGFnZV9zaXplIG11c3QgYmUgMCAodXNlIGRlZmF1bHQpIG9yIGJldHdl'
    'ZW4gMSBhbmQgMTAwGkV0aGlzLnBhZ2Vfc2l6ZSA9PSAwIHx8ICh0aGlzLnBhZ2Vfc2l6ZSA+PS'
    'AxICYmIHRoaXMucGFnZV9zaXplIDw9IDEwMCk=');

@$core.Deprecated('Use streamEntryDescriptor instead')
const StreamEntry$json = {
  '1': 'StreamEntry',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'active', '3': 2, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `StreamEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntryDescriptor = $convert.base64Decode(
    'CgtTdHJlYW1FbnRyeRIZCghtZWRpYV9pZBgBIAEoCVIHbWVkaWFJZBIWCgZhY3RpdmUYAiABKA'
    'hSBmFjdGl2ZQ==');

@$core.Deprecated('Use listRoomStreamsResponseDescriptor instead')
const ListRoomStreamsResponse$json = {
  '1': 'ListRoomStreamsResponse',
  '2': [
    {
      '1': 'streams',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.StreamEntry',
      '10': 'streams'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomStreamsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomStreamsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0Um9vbVN0cmVhbXNSZXNwb25zZRI0CgdzdHJlYW1zGAEgAygLMhouc3luY3R2LmNsaW'
        'VudC5TdHJlYW1FbnRyeVIHc3RyZWFtcxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use getRoomStreamInfoRequestDescriptor instead')
const GetRoomStreamInfoRequest$json = {
  '1': 'GetRoomStreamInfoRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `GetRoomStreamInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomStreamInfoRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRSb29tU3RyZWFtSW5mb1JlcXVlc3QSOAoIbWVkaWFfaWQYASABKAlCHbpIGnIYEAEYQD'
        'ISXm1lZF9bQS1aYS16MC05XSskUgdtZWRpYUlk');

@$core.Deprecated('Use roomStreamPublisherInfoDescriptor instead')
const RoomStreamPublisherInfo$json = {
  '1': 'RoomStreamPublisherInfo',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'started_at', '3': 2, '4': 1, '5': 3, '10': 'startedAt'},
  ],
};

/// Descriptor for `RoomStreamPublisherInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomStreamPublisherInfoDescriptor =
    $convert.base64Decode(
        'ChdSb29tU3RyZWFtUHVibGlzaGVySW5mbxIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSHQoKc3'
        'RhcnRlZF9hdBgCIAEoA1IJc3RhcnRlZEF0');

@$core.Deprecated('Use getRoomStreamInfoResponseDescriptor instead')
const GetRoomStreamInfoResponse$json = {
  '1': 'GetRoomStreamInfoResponse',
  '2': [
    {'1': 'active', '3': 1, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'publisher',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomStreamPublisherInfo',
      '10': 'publisher'
    },
  ],
};

/// Descriptor for `GetRoomStreamInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomStreamInfoResponseDescriptor = $convert.base64Decode(
    'ChlHZXRSb29tU3RyZWFtSW5mb1Jlc3BvbnNlEhYKBmFjdGl2ZRgBIAEoCFIGYWN0aXZlEkQKCX'
    'B1Ymxpc2hlchgCIAEoCzImLnN5bmN0di5jbGllbnQuUm9vbVN0cmVhbVB1Ymxpc2hlckluZm9S'
    'CXB1Ymxpc2hlcg==');

@$core.Deprecated('Use kickRoomStreamRequestDescriptor instead')
const KickRoomStreamRequest$json = {
  '1': 'KickRoomStreamRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `KickRoomStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickRoomStreamRequestDescriptor = $convert.base64Decode(
    'ChVLaWNrUm9vbVN0cmVhbVJlcXVlc3QSOAoIbWVkaWFfaWQYASABKAlCHbpIGnIYEAEYQDISXm'
    '1lZF9bQS1aYS16MC05XSskUgdtZWRpYUlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use kickRoomStreamResponseDescriptor instead')
const KickRoomStreamResponse$json = {
  '1': 'KickRoomStreamResponse',
};

/// Descriptor for `KickRoomStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickRoomStreamResponseDescriptor =
    $convert.base64Decode('ChZLaWNrUm9vbVN0cmVhbVJlc3BvbnNl');

@$core.Deprecated('Use addMemberRequestDescriptor instead')
const AddMemberRequest$json = {
  '1': 'AddMemberRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'role',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {'1': 'notify', '3': 3, '4': 1, '5': 8, '10': 'notify'},
  ],
};

/// Descriptor for `AddMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMemberRequestDescriptor = $convert.base64Decode(
    'ChBBZGRNZW1iZXJSZXF1ZXN0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQDISXnVzcl9bQS'
    '1aYS16MC05XSskUgZ1c2VySWQSMQoEcm9sZRgCIAEoDjIdLnN5bmN0di5jb21tb24uUm9vbU1l'
    'bWJlclJvbGVSBHJvbGUSFgoGbm90aWZ5GAMgASgIUgZub3RpZnk=');

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

@$core.Deprecated('Use roomJoinReviewDescriptor instead')
const RoomJoinReview$json = {
  '1': 'RoomJoinReview',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'requested_role',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'requestedRole'
    },
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
  ],
  '8': [
    {'1': '_reviewed_by'},
    {'1': '_rejection_reason'},
  ],
};

/// Descriptor for `RoomJoinReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomJoinReviewDescriptor = $convert.base64Decode(
    'Cg5Sb29tSm9pblJldmlldxIOCgJpZBgBIAEoCVICaWQSFwoHcm9vbV9pZBgCIAEoCVIGcm9vbU'
    'lkEhcKB3VzZXJfaWQYAyABKAlSBnVzZXJJZBIaCgh1c2VybmFtZRgEIAEoCVIIdXNlcm5hbWUS'
    'RAoOcmVxdWVzdGVkX3JvbGUYBSABKA4yHS5zeW5jdHYuY29tbW9uLlJvb21NZW1iZXJSb2xlUg'
    '1yZXF1ZXN0ZWRSb2xlEjMKBnN0YXR1cxgGIAEoDjIbLnN5bmN0di5jb21tb24uUmV2aWV3U3Rh'
    'dHVzUgZzdGF0dXMSIQoMcmVxdWVzdGVkX2F0GAcgASgDUgtyZXF1ZXN0ZWRBdBIfCgtyZXZpZX'
    'dlZF9hdBgIIAEoA1IKcmV2aWV3ZWRBdBIkCgtyZXZpZXdlZF9ieRgJIAEoCUgAUgpyZXZpZXdl'
    'ZEJ5iAEBEi4KEHJlamVjdGlvbl9yZWFzb24YCiABKAlIAVIPcmVqZWN0aW9uUmVhc29uiAEBQg'
    '4KDF9yZXZpZXdlZF9ieUITChFfcmVqZWN0aW9uX3JlYXNvbg==');

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
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
  '7': {},
};

/// Descriptor for `ListRoomJoinReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomJoinReviewsRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0Um9vbUpvaW5SZXZpZXdzUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhsKCXBhZ2'
    'Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSPQoGc3RhdHVzGAMgASgOMhsuc3luY3R2LmNvbW1vbi5S'
    'ZXZpZXdTdGF0dXNCCLpIBYIBAhABUgZzdGF0dXMSNwoHdXNlcl9pZBgEIAEoCUIeukgbchkYQD'
    'IVXiR8XnVzcl9bQS1aYS16MC05XSskUgZ1c2VySWQ6owK6SJ8CGnIKImNsaWVudC5saXN0X3Jv'
    'b21fam9pbl9yZXZpZXdzLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYX'
    'QgbGVhc3QgMRogdGhpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEaqAEKJ2NsaWVudC5s'
    'aXN0X3Jvb21fam9pbl9yZXZpZXdzLnBhZ2Vfc2l6ZRI2cGFnZV9zaXplIG11c3QgYmUgMCAodX'
    'NlIGRlZmF1bHQpIG9yIGJldHdlZW4gMSBhbmQgMTAwGkV0aGlzLnBhZ2Vfc2l6ZSA9PSAwIHx8'
    'ICh0aGlzLnBhZ2Vfc2l6ZSA+PSAxICYmIHRoaXMucGFnZV9zaXplIDw9IDEwMCk=');

@$core.Deprecated('Use listRoomJoinReviewsResponseDescriptor instead')
const ListRoomJoinReviewsResponse$json = {
  '1': 'ListRoomJoinReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomJoinReview',
      '10': 'reviews'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomJoinReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomJoinReviewsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Um9vbUpvaW5SZXZpZXdzUmVzcG9uc2USNwoHcmV2aWV3cxgBIAMoCzIdLnN5bmN0di'
        '5jbGllbnQuUm9vbUpvaW5SZXZpZXdSB3Jldmlld3MSFAoFdG90YWwYAiABKAVSBXRvdGFs');

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
      '6': '.synctv.client.RoomJoinReview',
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
        'Ch1BcHByb3ZlUm9vbUpvaW5SZXZpZXdSZXNwb25zZRI1CgZyZXZpZXcYASABKAsyHS5zeW5jdH'
        'YuY2xpZW50LlJvb21Kb2luUmV2aWV3UgZyZXZpZXcSMQoGbWVtYmVyGAIgASgLMhkuc3luY3R2'
        'LmNvbW1vbi5Sb29tTWVtYmVyUgZtZW1iZXI=');

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
      '6': '.synctv.client.RoomJoinReview',
      '10': 'review'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RejectRoomJoinReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectRoomJoinReviewResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWplY3RSb29tSm9pblJldmlld1Jlc3BvbnNlEjUKBnJldmlldxgBIAEoCzIdLnN5bmN0di'
        '5jbGllbnQuUm9vbUpvaW5SZXZpZXdSBnJldmlldxIYCgdzdWNjZXNzGAIgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use updateMemberPermissionsRequestDescriptor instead')
const UpdateMemberPermissionsRequest$json = {
  '1': 'UpdateMemberPermissionsRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'role',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {
      '1': 'added_permissions',
      '3': 3,
      '4': 1,
      '5': 4,
      '10': 'addedPermissions'
    },
    {
      '1': 'removed_permissions',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'removedPermissions'
    },
    {
      '1': 'admin_added_permissions',
      '3': 5,
      '4': 1,
      '5': 4,
      '10': 'adminAddedPermissions'
    },
    {
      '1': 'admin_removed_permissions',
      '3': 6,
      '4': 1,
      '5': 4,
      '10': 'adminRemovedPermissions'
    },
  ],
};

/// Descriptor for `UpdateMemberPermissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateMemberPermissionsRequestDescriptor = $convert.base64Decode(
    'Ch5VcGRhdGVNZW1iZXJQZXJtaXNzaW9uc1JlcXVlc3QSNgoHdXNlcl9pZBgBIAEoCUIdukgach'
    'gQARhAMhJedXNyX1tBLVphLXowLTldKyRSBnVzZXJJZBIxCgRyb2xlGAIgASgOMh0uc3luY3R2'
    'LmNvbW1vbi5Sb29tTWVtYmVyUm9sZVIEcm9sZRIrChFhZGRlZF9wZXJtaXNzaW9ucxgDIAEoBF'
    'IQYWRkZWRQZXJtaXNzaW9ucxIvChNyZW1vdmVkX3Blcm1pc3Npb25zGAQgASgEUhJyZW1vdmVk'
    'UGVybWlzc2lvbnMSNgoXYWRtaW5fYWRkZWRfcGVybWlzc2lvbnMYBSABKARSFWFkbWluQWRkZW'
    'RQZXJtaXNzaW9ucxI6ChlhZG1pbl9yZW1vdmVkX3Blcm1pc3Npb25zGAYgASgEUhdhZG1pblJl'
    'bW92ZWRQZXJtaXNzaW9ucw==');

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
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {
      '1': 'kick_cooldown_seconds',
      '3': 2,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'kickCooldownSeconds'
    },
  ],
};

/// Descriptor for `KickMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kickMemberRequestDescriptor = $convert.base64Decode(
    'ChFLaWNrTWVtYmVyUmVxdWVzdBI2Cgd1c2VyX2lkGAEgASgJQh26SBpyGBABGEAyEl51c3JfW0'
    'EtWmEtejAtOV0rJFIGdXNlcklkEkAKFWtpY2tfY29vbGRvd25fc2Vjb25kcxgCIAEoA0IMukgJ'
    'IgcYgJqeASgBUhNraWNrQ29vbGRvd25TZWNvbmRz');

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

@$core.Deprecated('Use createPlaylistRequestDescriptor instead')
const CreatePlaylistRequest$json = {
  '1': 'CreatePlaylistRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 9, '10': 'parentId'},
    {
      '1': 'source_provider',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'sourceProvider'
    },
    {'1': 'source_config', '3': 4, '4': 1, '5': 12, '10': 'sourceConfig'},
    {
      '1': 'provider_instance_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerInstanceName'
    },
    {'1': 'description', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'description'},
  ],
  '7': {},
};

/// Descriptor for `CreatePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPlaylistRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQbGF5bGlzdFJlcXVlc3QSHAoEbmFtZRgBIAEoCUIIukgFcgMY/wFSBG5hbWUSGw'
    'oJcGFyZW50X2lkGAIgASgJUghwYXJlbnRJZBJGCg9zb3VyY2VfcHJvdmlkZXIYAyABKAlCHbpI'
    'GnIVGEAyEV5bYS16XVthLXowLTlfXSok2AEBUg5zb3VyY2VQcm92aWRlchIjCg1zb3VyY2VfY2'
    '9uZmlnGAQgASgMUgxzb3VyY2VDb25maWcSUgoWcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgFIAEo'
    'CUIcukgZchQYQDIQXltBLVphLXowLTlfLV0rJNgBAVIUcHJvdmlkZXJJbnN0YW5jZU5hbWUSKg'
    'oLZGVzY3JpcHRpb24YBiABKAlCCLpIBXIDGIgnUgtkZXNjcmlwdGlvbjqwBLpIrAQakQEKIHBs'
    'YXlsaXN0LmR5bmFtaWMucmVxdWlyZXNfZmllbGRzEjFkeW5hbWljIHBsYXlsaXN0cyByZXF1aX'
    'JlIG5vbi1lbXB0eSBzb3VyY2VfY29uZmlnGjp0aGlzLnNvdXJjZV9wcm92aWRlciA9PSAnJyB8'
    'fCBzaXplKHRoaXMuc291cmNlX2NvbmZpZykgPiAwGt0BCiZwbGF5bGlzdC5zdGF0aWMucmVqZW'
    'N0c19keW5hbWljX2ZpZWxkcxJPc291cmNlX3Byb3ZpZGVyIGlzIHJlcXVpcmVkIHdoZW4gc291'
    'cmNlX2NvbmZpZyBvciBwcm92aWRlcl9pbnN0YW5jZV9uYW1lIGlzIHNldBpidGhpcy5zb3VyY2'
    'VfcHJvdmlkZXIgIT0gJycgfHwgKHNpemUodGhpcy5zb3VyY2VfY29uZmlnKSA9PSAwICYmIHRo'
    'aXMucHJvdmlkZXJfaW5zdGFuY2VfbmFtZSA9PSAnJykatQEKGXBsYXlsaXN0LnBhcmVudF9pZC'
    '5mb3JtYXQSM3BhcmVudF9pZCBtdXN0IGJlIGEgcHVibGljIGlkZW50aWZpZXIgd2hlbiBwcm92'
    'aWRlZBpjdGhpcy5wYXJlbnRfaWQgPT0gJycgfHwgKHNpemUodGhpcy5wYXJlbnRfaWQpIDw9ID'
    'Y0ICYmIHRoaXMucGFyZW50X2lkLm1hdGNoZXMoJ15wbF9bQS1aYS16MC05XSskJykp');

@$core.Deprecated('Use createPlaylistResponseDescriptor instead')
const CreatePlaylistResponse$json = {
  '1': 'CreatePlaylistResponse',
  '2': [
    {
      '1': 'playlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
  ],
};

/// Descriptor for `CreatePlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPlaylistResponseDescriptor =
    $convert.base64Decode(
        'ChZDcmVhdGVQbGF5bGlzdFJlc3BvbnNlEjMKCHBsYXlsaXN0GAEgASgLMhcuc3luY3R2LmNsaW'
        'VudC5QbGF5bGlzdFIIcGxheWxpc3Q=');

@$core.Deprecated('Use updatePlaylistRequestDescriptor instead')
const UpdatePlaylistRequest$json = {
  '1': 'UpdatePlaylistRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'description'},
  ],
};

/// Descriptor for `UpdatePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaylistRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQbGF5bGlzdFJlcXVlc3QSPQoLcGxheWxpc3RfaWQYASABKAlCHLpIGXIXEAEYQD'
    'IRXnBsX1tBLVphLXowLTldKyRSCnBsYXlsaXN0SWQSHwoEbmFtZRgCIAEoCUILukgIcgMY/wHY'
    'AQFSBG5hbWUSKgoLZGVzY3JpcHRpb24YAyABKAlCCLpIBXIDGIgnUgtkZXNjcmlwdGlvbg==');

@$core.Deprecated('Use updatePlaylistResponseDescriptor instead')
const UpdatePlaylistResponse$json = {
  '1': 'UpdatePlaylistResponse',
  '2': [
    {
      '1': 'playlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
  ],
};

/// Descriptor for `UpdatePlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaylistResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVQbGF5bGlzdFJlc3BvbnNlEjMKCHBsYXlsaXN0GAEgASgLMhcuc3luY3R2LmNsaW'
        'VudC5QbGF5bGlzdFIIcGxheWxpc3Q=');

@$core.Deprecated('Use movePlaylistRequestDescriptor instead')
const MovePlaylistRequest$json = {
  '1': 'MovePlaylistRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
    {
      '1': 'before_playlist_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'beforePlaylistId'
    },
    {
      '1': 'after_playlist_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'afterPlaylistId'
    },
  ],
  '8': [
    {'1': 'anchor', '2': {}},
  ],
};

/// Descriptor for `MovePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List movePlaylistRequestDescriptor = $convert.base64Decode(
    'ChNNb3ZlUGxheWxpc3RSZXF1ZXN0Ej0KC3BsYXlsaXN0X2lkGAEgASgJQhy6SBlyFxABGEAyEV'
    '5wbF9bQS1aYS16MC05XSskUgpwbGF5bGlzdElkEkwKEmJlZm9yZV9wbGF5bGlzdF9pZBgCIAEo'
    'CUIcukgZchcQARhAMhFecGxfW0EtWmEtejAtOV0rJEgAUhBiZWZvcmVQbGF5bGlzdElkEkoKEW'
    'FmdGVyX3BsYXlsaXN0X2lkGAMgASgJQhy6SBlyFxABGEAyEV5wbF9bQS1aYS16MC05XSskSABS'
    'D2FmdGVyUGxheWxpc3RJZEIPCgZhbmNob3ISBbpIAggB');

@$core.Deprecated('Use movePlaylistResponseDescriptor instead')
const MovePlaylistResponse$json = {
  '1': 'MovePlaylistResponse',
  '2': [
    {
      '1': 'playlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
  ],
};

/// Descriptor for `MovePlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List movePlaylistResponseDescriptor = $convert.base64Decode(
    'ChRNb3ZlUGxheWxpc3RSZXNwb25zZRIzCghwbGF5bGlzdBgBIAEoCzIXLnN5bmN0di5jbGllbn'
    'QuUGxheWxpc3RSCHBsYXlsaXN0');

@$core.Deprecated('Use deletePlaylistRequestDescriptor instead')
const DeletePlaylistRequest$json = {
  '1': 'DeletePlaylistRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
    {'1': 'force', '3': 2, '4': 1, '5': 8, '10': 'force'},
  ],
};

/// Descriptor for `DeletePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePlaylistRequestDescriptor = $convert.base64Decode(
    'ChVEZWxldGVQbGF5bGlzdFJlcXVlc3QSPQoLcGxheWxpc3RfaWQYASABKAlCHLpIGXIXEAEYQD'
    'IRXnBsX1tBLVphLXowLTldKyRSCnBsYXlsaXN0SWQSFAoFZm9yY2UYAiABKAhSBWZvcmNl');

@$core.Deprecated('Use deletePlaylistQueryDescriptor instead')
const DeletePlaylistQuery$json = {
  '1': 'DeletePlaylistQuery',
  '2': [
    {'1': 'force', '3': 1, '4': 1, '5': 8, '10': 'force'},
  ],
};

/// Descriptor for `DeletePlaylistQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePlaylistQueryDescriptor =
    $convert.base64Decode(
        'ChNEZWxldGVQbGF5bGlzdFF1ZXJ5EhQKBWZvcmNlGAEgASgIUgVmb3JjZQ==');

@$core.Deprecated('Use deletePlaylistResponseDescriptor instead')
const DeletePlaylistResponse$json = {
  '1': 'DeletePlaylistResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeletePlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePlaylistResponseDescriptor =
    $convert.base64Decode(
        'ChZEZWxldGVQbGF5bGlzdFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use getPlaylistRequestDescriptor instead')
const GetPlaylistRequest$json = {
  '1': 'GetPlaylistRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
  ],
};

/// Descriptor for `GetPlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlaylistRequestDescriptor = $convert.base64Decode(
    'ChJHZXRQbGF5bGlzdFJlcXVlc3QSPQoLcGxheWxpc3RfaWQYASABKAlCHLpIGXIXEAEYQDIRXn'
    'BsX1tBLVphLXowLTldKyRSCnBsYXlsaXN0SWQ=');

@$core.Deprecated('Use getPlaylistResponseDescriptor instead')
const GetPlaylistResponse$json = {
  '1': 'GetPlaylistResponse',
  '2': [
    {
      '1': 'playlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
    {
      '1': 'child_folder_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'childFolderCount'
    },
    {'1': 'media_count', '3': 3, '4': 1, '5': 5, '10': 'mediaCount'},
  ],
};

/// Descriptor for `GetPlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlaylistResponseDescriptor = $convert.base64Decode(
    'ChNHZXRQbGF5bGlzdFJlc3BvbnNlEjMKCHBsYXlsaXN0GAEgASgLMhcuc3luY3R2LmNsaWVudC'
    '5QbGF5bGlzdFIIcGxheWxpc3QSLAoSY2hpbGRfZm9sZGVyX2NvdW50GAIgASgFUhBjaGlsZEZv'
    'bGRlckNvdW50Eh8KC21lZGlhX2NvdW50GAMgASgFUgptZWRpYUNvdW50');

@$core.Deprecated('Use listPlaylistsRequestDescriptor instead')
const ListPlaylistsRequest$json = {
  '1': 'ListPlaylistsRequest',
  '2': [
    {'1': 'parent_id', '3': 1, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'source_provider',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'sourceProvider'
    },
    {
      '1': 'provider_instance_name',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerInstanceName'
    },
    {
      '1': 'dynamic_only',
      '3': 7,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'dynamicOnly',
      '17': true
    },
    {
      '1': 'sort_by',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PlaylistListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
    {
      '1': 'availability',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceAvailabilityFilter',
      '8': {},
      '10': 'availability'
    },
  ],
  '7': {},
  '8': [
    {'1': '_dynamic_only'},
  ],
};

/// Descriptor for `ListPlaylistsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlaylistsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0UGxheWxpc3RzUmVxdWVzdBIbCglwYXJlbnRfaWQYASABKAlSCHBhcmVudElkEhIKBH'
    'BhZ2UYAiABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZRIfCgZzZWFyY2gY'
    'BCABKAlCB7pIBHICGGRSBnNlYXJjaBJGCg9zb3VyY2VfcHJvdmlkZXIYBSABKAlCHbpIGnIVGE'
    'AyEV5bYS16XVthLXowLTlfXSok2AEBUg5zb3VyY2VQcm92aWRlchJSChZwcm92aWRlcl9pbnN0'
    'YW5jZV9uYW1lGAYgASgJQhy6SBlyFBhAMhBeW0EtWmEtejAtOV8tXSsk2AEBUhRwcm92aWRlck'
    'luc3RhbmNlTmFtZRImCgxkeW5hbWljX29ubHkYByABKAhIAFILZHluYW1pY09ubHmIAQESRAoH'
    'c29ydF9ieRgIIAEoDjIhLnN5bmN0di5jbGllbnQuUGxheWxpc3RMaXN0U29ydEJ5Qgi6SAWCAQ'
    'IQAVIGc29ydEJ5Ek0KDnNvcnRfZGlyZWN0aW9uGAkgASgOMhwuc3luY3R2LmNsaWVudC5Tb3J0'
    'RGlyZWN0aW9uQgi6SAWCAQIQAVINc29ydERpcmVjdGlvbhJXCgxhdmFpbGFiaWxpdHkYCiABKA'
    '4yKS5zeW5jdHYuY2xpZW50LlJlc291cmNlQXZhaWxhYmlsaXR5RmlsdGVyQgi6SAWCAQIQAVIM'
    'YXZhaWxhYmlsaXR5OsMDuki/Axq7AQofbGlzdF9wbGF5bGlzdHMucGFyZW50X2lkLmZvcm1hdB'
    'IzcGFyZW50X2lkIG11c3QgYmUgYSBwdWJsaWMgaWRlbnRpZmllciB3aGVuIHByb3ZpZGVkGmN0'
    'aGlzLnBhcmVudF9pZCA9PSAnJyB8fCAoc2l6ZSh0aGlzLnBhcmVudF9pZCkgPD0gNjQgJiYgdG'
    'hpcy5wYXJlbnRfaWQubWF0Y2hlcygnXnBsX1tBLVphLXowLTldKyQnKSkaYwoTbGlzdF9wbGF5'
    'bGlzdHMucGFnZRIqcGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdCAxGi'
    'B0aGlzLnBhZ2UgPT0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqZAQoYbGlzdF9wbGF5bGlzdHMucGFn'
    'ZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIG'
    'FuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwgKHRoaXMucGFnZV9zaXplID49IDEgJiYg'
    'dGhpcy5wYWdlX3NpemUgPD0gMTAwKUIPCg1fZHluYW1pY19vbmx5');

@$core.Deprecated('Use listPlaylistsResponseDescriptor instead')
const ListPlaylistsResponse$json = {
  '1': 'ListPlaylistsResponse',
  '2': [
    {
      '1': 'playlists',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlists'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListPlaylistsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlaylistsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UGxheWxpc3RzUmVzcG9uc2USNQoJcGxheWxpc3RzGAEgAygLMhcuc3luY3R2LmNsaW'
    'VudC5QbGF5bGlzdFIJcGxheWxpc3RzEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

@$core.Deprecated('Use startPlaybackRequestDescriptor instead')
const StartPlaybackRequest$json = {
  '1': 'StartPlaybackRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'target', '3': 3, '4': 1, '5': 12, '10': 'target'},
  ],
  '7': {},
};

/// Descriptor for `StartPlaybackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPlaybackRequestDescriptor = $convert.base64Decode(
    'ChRTdGFydFBsYXliYWNrUmVxdWVzdBIZCghtZWRpYV9pZBgBIAEoCVIHbWVkaWFJZBIfCgtwbG'
    'F5bGlzdF9pZBgCIAEoCVIKcGxheWxpc3RJZBIWCgZ0YXJnZXQYAyABKAxSBnRhcmdldDq4BLpI'
    'tAQafQocc3RhcnRfcGxheWJhY2suc2luZ2xlX3RhcmdldBIrbWVkaWFfaWQgYW5kIHBsYXlsaX'
    'N0X2lkIGNhbm5vdCBib3RoIGJlIHNldBowISh0aGlzLm1lZGlhX2lkICE9ICcnICYmIHRoaXMu'
    'cGxheWxpc3RfaWQgIT0gJycpGpUBChtzdGFydF9wbGF5YmFjay5jbGVhcl90YXJnZXQSK3Rhcm'
    'dldCBtdXN0IGJlIGVtcHR5IHdoZW4gY2xlYXJpbmcgcGxheWJhY2saSSh0aGlzLm1lZGlhX2lk'
    'ICE9ICcnIHx8IHRoaXMucGxheWxpc3RfaWQgIT0gJycpIHx8IHNpemUodGhpcy50YXJnZXQpID'
    '09IDAaiQEKHHN0YXJ0X3BsYXliYWNrLnN0YXRpY190YXJnZXQSOnRhcmdldCBtdXN0IGJlIGVt'
    'cHR5IHdoZW4gc3dpdGNoaW5nIHRvIGEgc3RhdGljIG1lZGlhIGl0ZW0aLXRoaXMubWVkaWFfaW'
    'QgPT0gJycgfHwgc2l6ZSh0aGlzLnRhcmdldCkgPT0gMBqOAQodc3RhcnRfcGxheWJhY2suZHlu'
    'YW1pY190YXJnZXQSPHRhcmdldCBpcyByZXF1aXJlZCB3aGVuIHN3aXRjaGluZyB0byBhIGR5bm'
    'FtaWMgcGxheWxpc3QgaXRlbRovdGhpcy5wbGF5bGlzdF9pZCA9PSAnJyB8fCBzaXplKHRoaXMu'
    'dGFyZ2V0KSA+IDA=');

@$core.Deprecated('Use startPlaybackResponseDescriptor instead')
const StartPlaybackResponse$json = {
  '1': 'StartPlaybackResponse',
};

/// Descriptor for `StartPlaybackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPlaybackResponseDescriptor =
    $convert.base64Decode('ChVTdGFydFBsYXliYWNrUmVzcG9uc2U=');

@$core.Deprecated('Use stopPlaybackRequestDescriptor instead')
const StopPlaybackRequest$json = {
  '1': 'StopPlaybackRequest',
};

/// Descriptor for `StopPlaybackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopPlaybackRequestDescriptor =
    $convert.base64Decode('ChNTdG9wUGxheWJhY2tSZXF1ZXN0');

@$core.Deprecated('Use stopPlaybackResponseDescriptor instead')
const StopPlaybackResponse$json = {
  '1': 'StopPlaybackResponse',
};

/// Descriptor for `StopPlaybackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopPlaybackResponseDescriptor =
    $convert.base64Decode('ChRTdG9wUGxheWJhY2tSZXNwb25zZQ==');

@$core.Deprecated('Use updatePlaybackRequestDescriptor instead')
const UpdatePlaybackRequest$json = {
  '1': 'UpdatePlaybackRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'target', '3': 3, '4': 1, '5': 12, '10': 'target'},
  ],
  '7': {},
};

/// Descriptor for `UpdatePlaybackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaybackRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQbGF5YmFja1JlcXVlc3QSGQoIbWVkaWFfaWQYASABKAlSB21lZGlhSWQSHwoLcG'
    'xheWxpc3RfaWQYAiABKAlSCnBsYXlsaXN0SWQSFgoGdGFyZ2V0GAMgASgMUgZ0YXJnZXQ6vAS6'
    'SLgEGn4KHXVwZGF0ZV9wbGF5YmFjay5zaW5nbGVfdGFyZ2V0EittZWRpYV9pZCBhbmQgcGxheW'
    'xpc3RfaWQgY2Fubm90IGJvdGggYmUgc2V0GjAhKHRoaXMubWVkaWFfaWQgIT0gJycgJiYgdGhp'
    'cy5wbGF5bGlzdF9pZCAhPSAnJykalgEKHHVwZGF0ZV9wbGF5YmFjay5jbGVhcl90YXJnZXQSK3'
    'RhcmdldCBtdXN0IGJlIGVtcHR5IHdoZW4gY2xlYXJpbmcgcGxheWJhY2saSSh0aGlzLm1lZGlh'
    'X2lkICE9ICcnIHx8IHRoaXMucGxheWxpc3RfaWQgIT0gJycpIHx8IHNpemUodGhpcy50YXJnZX'
    'QpID09IDAaigEKHXVwZGF0ZV9wbGF5YmFjay5zdGF0aWNfdGFyZ2V0Ejp0YXJnZXQgbXVzdCBi'
    'ZSBlbXB0eSB3aGVuIHN3aXRjaGluZyB0byBhIHN0YXRpYyBtZWRpYSBpdGVtGi10aGlzLm1lZG'
    'lhX2lkID09ICcnIHx8IHNpemUodGhpcy50YXJnZXQpID09IDAajwEKHnVwZGF0ZV9wbGF5YmFj'
    'ay5keW5hbWljX3RhcmdldBI8dGFyZ2V0IGlzIHJlcXVpcmVkIHdoZW4gc3dpdGNoaW5nIHRvIG'
    'EgZHluYW1pYyBwbGF5bGlzdCBpdGVtGi90aGlzLnBsYXlsaXN0X2lkID09ICcnIHx8IHNpemUo'
    'dGhpcy50YXJnZXQpID4gMA==');

@$core.Deprecated('Use addMediaRequestDescriptor instead')
const AddMediaRequest$json = {
  '1': 'AddMediaRequest',
  '2': [
    {
      '1': 'playlist_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'playlistId',
      '17': true
    },
    {
      '1': 'source_provider',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'sourceProvider'
    },
    {
      '1': 'provider_instance_name',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerInstanceName'
    },
    {'1': 'source_config', '3': 4, '4': 1, '5': 12, '10': 'sourceConfig'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'description'},
  ],
  '7': {},
  '8': [
    {'1': '_playlist_id'},
  ],
};

/// Descriptor for `AddMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMediaRequestDescriptor = $convert.base64Decode(
    'Cg9BZGRNZWRpYVJlcXVlc3QSQgoLcGxheWxpc3RfaWQYASABKAlCHLpIGXIXEAEYQDIRXnBsX1'
    'tBLVphLXowLTldKyRIAFIKcGxheWxpc3RJZIgBARJGCg9zb3VyY2VfcHJvdmlkZXIYAiABKAlC'
    'HbpIGnIVGEAyEV5bYS16XVthLXowLTlfXSok2AEBUg5zb3VyY2VQcm92aWRlchJSChZwcm92aW'
    'Rlcl9pbnN0YW5jZV9uYW1lGAMgASgJQhy6SBlyFBhAMhBeW0EtWmEtejAtOV8tXSsk2AEBUhRw'
    'cm92aWRlckluc3RhbmNlTmFtZRIjCg1zb3VyY2VfY29uZmlnGAQgASgMUgxzb3VyY2VDb25maW'
    'cSHAoEbmFtZRgFIAEoCUIIukgFcgMY9ANSBG5hbWUSKgoLZGVzY3JpcHRpb24YBiABKAlCCLpI'
    'BXIDGIgnUgtkZXNjcmlwdGlvbjpZukhWGlQKGWFkZF9tZWRpYS5zb3VyY2VfcHJvdmlkZXISG3'
    'NvdXJjZV9wcm92aWRlciBpcyByZXF1aXJlZBoadGhpcy5zb3VyY2VfcHJvdmlkZXIgIT0gJydC'
    'DgoMX3BsYXlsaXN0X2lk');

@$core.Deprecated('Use addMediaResponseDescriptor instead')
const AddMediaResponse$json = {
  '1': 'AddMediaResponse',
  '2': [
    {
      '1': 'media',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Media',
      '10': 'media'
    },
  ],
};

/// Descriptor for `AddMediaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMediaResponseDescriptor = $convert.base64Decode(
    'ChBBZGRNZWRpYVJlc3BvbnNlEioKBW1lZGlhGAEgASgLMhQuc3luY3R2LmNsaWVudC5NZWRpYV'
    'IFbWVkaWE=');

@$core.Deprecated('Use getMediaRequestDescriptor instead')
const GetMediaRequest$json = {
  '1': 'GetMediaRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `GetMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMediaRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRNZWRpYVJlcXVlc3QSOAoIbWVkaWFfaWQYASABKAlCHbpIGnIYEAEYQDISXm1lZF9bQS'
    '1aYS16MC05XSskUgdtZWRpYUlk');

@$core.Deprecated('Use deleteMediaRequestDescriptor instead')
const DeleteMediaRequest$json = {
  '1': 'DeleteMediaRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
    {'1': 'force', '3': 2, '4': 1, '5': 8, '10': 'force'},
  ],
};

/// Descriptor for `DeleteMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMediaRequestDescriptor = $convert.base64Decode(
    'ChJEZWxldGVNZWRpYVJlcXVlc3QSOAoIbWVkaWFfaWQYASABKAlCHbpIGnIYEAEYQDISXm1lZF'
    '9bQS1aYS16MC05XSskUgdtZWRpYUlkEhQKBWZvcmNlGAIgASgIUgVmb3JjZQ==');

@$core.Deprecated('Use deleteMediaQueryDescriptor instead')
const DeleteMediaQuery$json = {
  '1': 'DeleteMediaQuery',
  '2': [
    {'1': 'force', '3': 1, '4': 1, '5': 8, '10': 'force'},
  ],
};

/// Descriptor for `DeleteMediaQuery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMediaQueryDescriptor = $convert
    .base64Decode('ChBEZWxldGVNZWRpYVF1ZXJ5EhQKBWZvcmNlGAEgASgIUgVmb3JjZQ==');

@$core.Deprecated('Use deleteMediaResponseDescriptor instead')
const DeleteMediaResponse$json = {
  '1': 'DeleteMediaResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteMediaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMediaResponseDescriptor =
    $convert.base64Decode(
        'ChNEZWxldGVNZWRpYVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use deleteEntriesRequestDescriptor instead')
const DeleteEntriesRequest$json = {
  '1': 'DeleteEntriesRequest',
  '2': [
    {'1': 'playlist_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'playlistIds'},
    {'1': 'media_ids', '3': 2, '4': 3, '5': 9, '8': {}, '10': 'mediaIds'},
    {'1': 'force', '3': 3, '4': 1, '5': 8, '10': 'force'},
  ],
  '7': {},
};

/// Descriptor for `DeleteEntriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteEntriesRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVFbnRyaWVzUmVxdWVzdBJECgxwbGF5bGlzdF9pZHMYASADKAlCIbpIHpIBGyIZch'
    'cQARhAMhFecGxfW0EtWmEtejAtOV0rJFILcGxheWxpc3RJZHMSPwoJbWVkaWFfaWRzGAIgAygJ'
    'QiK6SB+SARwiGnIYEAEYQDISXm1lZF9bQS1aYS16MC05XSskUghtZWRpYUlkcxIUCgVmb3JjZR'
    'gDIAEoCFIFZm9yY2U68wG6SO8BGm4KGGRlbGV0ZV9lbnRyaWVzLm5vbl9lbXB0eRIeZGVsZXRl'
    'IHJlcXVlc3QgY2Fubm90IGJlIGVtcHR5GjJzaXplKHRoaXMucGxheWxpc3RfaWRzKSArIHNpem'
    'UodGhpcy5tZWRpYV9pZHMpID4gMBp9ChpkZWxldGVfZW50cmllcy5tYXhfdGFyZ2V0cxIoZGVs'
    'ZXRlIGJhdGNoIHNpemUgZXhjZWVkcyBtYXhpbXVtIG9mIDEwMBo1c2l6ZSh0aGlzLnBsYXlsaX'
    'N0X2lkcykgKyBzaXplKHRoaXMubWVkaWFfaWRzKSA8PSAxMDA=');

@$core.Deprecated('Use deleteEntriesResponseDescriptor instead')
const DeleteEntriesResponse$json = {
  '1': 'DeleteEntriesResponse',
  '2': [
    {
      '1': 'deleted_playlists',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'deletedPlaylists'
    },
    {'1': 'deleted_media', '3': 2, '4': 1, '5': 5, '10': 'deletedMedia'},
  ],
};

/// Descriptor for `DeleteEntriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteEntriesResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVFbnRyaWVzUmVzcG9uc2USKwoRZGVsZXRlZF9wbGF5bGlzdHMYASABKAVSEGRlbG'
    'V0ZWRQbGF5bGlzdHMSIwoNZGVsZXRlZF9tZWRpYRgCIAEoBVIMZGVsZXRlZE1lZGlh');

@$core.Deprecated('Use listPlaylistItemsRequestDescriptor instead')
const ListPlaylistItemsRequest$json = {
  '1': 'ListPlaylistItemsRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'target', '3': 2, '4': 1, '5': 12, '10': 'target'},
    {'1': 'page', '3': 3, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'source_provider',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'sourceProvider'
    },
    {
      '1': 'provider_instance_name',
      '3': 7,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerInstanceName'
    },
    {
      '1': 'sort_by',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.MediaListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
    {
      '1': 'availability',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceAvailabilityFilter',
      '8': {},
      '10': 'availability'
    },
    {'1': 'refresh', '3': 11, '4': 1, '5': 8, '10': 'refresh'},
  ],
  '7': {},
};

/// Descriptor for `ListPlaylistItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlaylistItemsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0UGxheWxpc3RJdGVtc1JlcXVlc3QSHwoLcGxheWxpc3RfaWQYASABKAlSCnBsYXlsaX'
    'N0SWQSFgoGdGFyZ2V0GAIgASgMUgZ0YXJnZXQSEgoEcGFnZRgDIAEoBVIEcGFnZRIbCglwYWdl'
    'X3NpemUYBCABKAVSCHBhZ2VTaXplEh8KBnNlYXJjaBgFIAEoCUIHukgEcgIYZFIGc2VhcmNoEk'
    'YKD3NvdXJjZV9wcm92aWRlchgGIAEoCUIdukgachUYQDIRXlthLXpdW2EtejAtOV9dKiTYAQFS'
    'DnNvdXJjZVByb3ZpZGVyElIKFnByb3ZpZGVyX2luc3RhbmNlX25hbWUYByABKAlCHLpIGXIUGE'
    'AyEF5bQS1aYS16MC05Xy1dKyTYAQFSFHByb3ZpZGVySW5zdGFuY2VOYW1lEkEKB3NvcnRfYnkY'
    'CCABKA4yHi5zeW5jdHYuY2xpZW50Lk1lZGlhTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRCeR'
    'JNCg5zb3J0X2RpcmVjdGlvbhgJIAEoDjIcLnN5bmN0di5jbGllbnQuU29ydERpcmVjdGlvbkII'
    'ukgFggECEAFSDXNvcnREaXJlY3Rpb24SVwoMYXZhaWxhYmlsaXR5GAogASgOMikuc3luY3R2Lm'
    'NsaWVudC5SZXNvdXJjZUF2YWlsYWJpbGl0eUZpbHRlckIIukgFggECEAFSDGF2YWlsYWJpbGl0'
    'eRIYCgdyZWZyZXNoGAsgASgIUgdyZWZyZXNoOo8CukiLAhpoChhsaXN0X3BsYXlsaXN0X2l0ZW'
    '1zLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYXQgbGVhc3QgMRogdGhp'
    'cy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEangEKHWxpc3RfcGxheWxpc3RfaXRlbXMucG'
    'FnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAx'
    'IGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwgKHRoaXMucGFnZV9zaXplID49IDEgJi'
    'YgdGhpcy5wYWdlX3NpemUgPD0gMTAwKQ==');

@$core.Deprecated('Use listPlaylistItemsResponseDescriptor instead')
const ListPlaylistItemsResponse$json = {
  '1': 'ListPlaylistItemsResponse',
  '2': [
    {
      '1': 'playlists',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlists'
    },
    {
      '1': 'media',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Media',
      '10': 'media'
    },
    {'1': 'total', '3': 3, '4': 1, '5': 5, '10': 'total'},
    {'1': 'folder_count', '3': 4, '4': 1, '5': 5, '10': 'folderCount'},
    {'1': 'file_count', '3': 5, '4': 1, '5': 5, '10': 'fileCount'},
    {
      '1': 'dynamic_items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaylistItem',
      '10': 'dynamicItems'
    },
    {
      '1': 'current_path',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaylistBrowsePathNode',
      '10': 'currentPath'
    },
    {'1': 'version', '3': 8, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `ListPlaylistItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlaylistItemsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0UGxheWxpc3RJdGVtc1Jlc3BvbnNlEjUKCXBsYXlsaXN0cxgBIAMoCzIXLnN5bmN0di'
    '5jbGllbnQuUGxheWxpc3RSCXBsYXlsaXN0cxIqCgVtZWRpYRgCIAMoCzIULnN5bmN0di5jbGll'
    'bnQuTWVkaWFSBW1lZGlhEhQKBXRvdGFsGAMgASgFUgV0b3RhbBIhCgxmb2xkZXJfY291bnQYBC'
    'ABKAVSC2ZvbGRlckNvdW50Eh0KCmZpbGVfY291bnQYBSABKAVSCWZpbGVDb3VudBJACg1keW5h'
    'bWljX2l0ZW1zGAYgAygLMhsuc3luY3R2LmNsaWVudC5QbGF5bGlzdEl0ZW1SDGR5bmFtaWNJdG'
    'VtcxJICgxjdXJyZW50X3BhdGgYByADKAsyJS5zeW5jdHYuY2xpZW50LlBsYXlsaXN0QnJvd3Nl'
    'UGF0aE5vZGVSC2N1cnJlbnRQYXRoEhgKB3ZlcnNpb24YCCABKAlSB3ZlcnNpb24=');

@$core.Deprecated('Use playlistItemDescriptor instead')
const PlaylistItem$json = {
  '1': 'PlaylistItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'item_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ItemType',
      '10': 'itemType'
    },
    {'1': 'target', '3': 3, '4': 1, '5': 12, '10': 'target'},
    {'1': 'size', '3': 4, '4': 1, '5': 3, '9': 0, '10': 'size', '17': true},
    {
      '1': 'thumbnail',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'thumbnail',
      '17': true
    },
    {
      '1': 'modified_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'modifiedAt',
      '17': true
    },
    {'1': 'description', '3': 7, '4': 1, '5': 9, '10': 'description'},
  ],
  '8': [
    {'1': '_size'},
    {'1': '_thumbnail'},
    {'1': '_modified_at'},
  ],
};

/// Descriptor for `PlaylistItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistItemDescriptor = $convert.base64Decode(
    'CgxQbGF5bGlzdEl0ZW0SEgoEbmFtZRgBIAEoCVIEbmFtZRI0CglpdGVtX3R5cGUYAiABKA4yFy'
    '5zeW5jdHYuY2xpZW50Lkl0ZW1UeXBlUghpdGVtVHlwZRIWCgZ0YXJnZXQYAyABKAxSBnRhcmdl'
    'dBIXCgRzaXplGAQgASgDSABSBHNpemWIAQESIQoJdGh1bWJuYWlsGAUgASgJSAFSCXRodW1ibm'
    'FpbIgBARIkCgttb2RpZmllZF9hdBgGIAEoA0gCUgptb2RpZmllZEF0iAEBEiAKC2Rlc2NyaXB0'
    'aW9uGAcgASgJUgtkZXNjcmlwdGlvbkIHCgVfc2l6ZUIMCgpfdGh1bWJuYWlsQg4KDF9tb2RpZm'
    'llZF9hdA==');

@$core.Deprecated('Use playlistBrowsePathNodeDescriptor instead')
const PlaylistBrowsePathNode$json = {
  '1': 'PlaylistBrowsePathNode',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'target', '3': 3, '4': 1, '5': 12, '10': 'target'},
  ],
};

/// Descriptor for `PlaylistBrowsePathNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistBrowsePathNodeDescriptor =
    $convert.base64Decode(
        'ChZQbGF5bGlzdEJyb3dzZVBhdGhOb2RlEh8KC3BsYXlsaXN0X2lkGAEgASgJUgpwbGF5bGlzdE'
        'lkEhIKBG5hbWUYAiABKAlSBG5hbWUSFgoGdGFyZ2V0GAMgASgMUgZ0YXJnZXQ=');

@$core.Deprecated('Use moveMediaRequestDescriptor instead')
const MoveMediaRequest$json = {
  '1': 'MoveMediaRequest',
  '2': [
    {'1': 'media_ids', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'mediaIds'},
    {
      '1': 'source_playlist_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 0,
      '10': 'sourcePlaylistId',
      '17': true
    },
    {
      '1': 'target_playlist_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 1,
      '10': 'targetPlaylistId',
      '17': true
    },
    {'1': 'all_from_scope', '3': 4, '4': 1, '5': 8, '10': 'allFromScope'},
    {
      '1': 'before_media_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 2,
      '10': 'beforeMediaId',
      '17': true
    },
    {
      '1': 'after_media_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': {},
      '9': 3,
      '10': 'afterMediaId',
      '17': true
    },
  ],
  '7': {},
  '8': [
    {'1': '_source_playlist_id'},
    {'1': '_target_playlist_id'},
    {'1': '_before_media_id'},
    {'1': '_after_media_id'},
  ],
};

/// Descriptor for `MoveMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveMediaRequestDescriptor = $convert.base64Decode(
    'ChBNb3ZlTWVkaWFSZXF1ZXN0EkEKCW1lZGlhX2lkcxgBIAMoCUIkukghkgEeEGQiGnIYEAEYQD'
    'ISXm1lZF9bQS1aYS16MC05XSskUghtZWRpYUlkcxJPChJzb3VyY2VfcGxheWxpc3RfaWQYAiAB'
    'KAlCHLpIGXIXEAEYQDIRXnBsX1tBLVphLXowLTldKyRIAFIQc291cmNlUGxheWxpc3RJZIgBAR'
    'JPChJ0YXJnZXRfcGxheWxpc3RfaWQYAyABKAlCHLpIGXIXEAEYQDIRXnBsX1tBLVphLXowLTld'
    'KyRIAVIQdGFyZ2V0UGxheWxpc3RJZIgBARIkCg5hbGxfZnJvbV9zY29wZRgEIAEoCFIMYWxsRn'
    'JvbVNjb3BlEkoKD2JlZm9yZV9tZWRpYV9pZBgFIAEoCUIdukgachgQARhAMhJebWVkX1tBLVph'
    'LXowLTldKyRIAlINYmVmb3JlTWVkaWFJZIgBARJICg5hZnRlcl9tZWRpYV9pZBgGIAEoCUIduk'
    'gachgQARhAMhJebWVkX1tBLVphLXowLTldKyRIA1IMYWZ0ZXJNZWRpYUlkiAEBOtgEukjUBBqh'
    'AQoRbW92ZV9tZWRpYS5hbmNob3ISO0F0IG1vc3Qgb25lIG9mIGJlZm9yZV9tZWRpYV9pZCBvci'
    'BhZnRlcl9tZWRpYV9pZCBtYXkgYmUgc2V0Gk8odGhpcy5iZWZvcmVfbWVkaWFfaWQgPT0gJycg'
    'PyAwIDogMSkgKyAodGhpcy5hZnRlcl9tZWRpYV9pZCA9PSAnJyA/IDAgOiAxKSA8PSAxGokBCh'
    'ptb3ZlX21lZGlhLnNjb3BlX3NlbGVjdGlvbhI4bWVkaWFfaWRzIGNhbm5vdCBiZSBwcm92aWRl'
    'ZCB3aGVuIGFsbF9mcm9tX3Njb3BlIGlzIHRydWUaMSF0aGlzLmFsbF9mcm9tX3Njb3BlIHx8IH'
    'NpemUodGhpcy5tZWRpYV9pZHMpID09IDAajQEKF21vdmVfbWVkaWEuc291cmNlX3Njb3BlEjxz'
    'b3VyY2VfcGxheWxpc3RfaWQgaXMgb25seSB2YWxpZCB3aGVuIGFsbF9mcm9tX3Njb3BlIGlzIH'
    'RydWUaNHRoaXMuYWxsX2Zyb21fc2NvcGUgfHwgdGhpcy5zb3VyY2VfcGxheWxpc3RfaWQgPT0g'
    'JycakQEKHW1vdmVfbWVkaWEuZXhwbGljaXRfc2VsZWN0aW9uEj5BdCBsZWFzdCBvbmUgbWVkaW'
    'FfaWQgaXMgcmVxdWlyZWQgd2hlbiBhbGxfZnJvbV9zY29wZSBpcyBmYWxzZRowdGhpcy5hbGxf'
    'ZnJvbV9zY29wZSB8fCBzaXplKHRoaXMubWVkaWFfaWRzKSA+PSAxQhUKE19zb3VyY2VfcGxheW'
    'xpc3RfaWRCFQoTX3RhcmdldF9wbGF5bGlzdF9pZEISChBfYmVmb3JlX21lZGlhX2lkQhEKD19h'
    'ZnRlcl9tZWRpYV9pZA==');

@$core.Deprecated('Use moveMediaResponseDescriptor instead')
const MoveMediaResponse$json = {
  '1': 'MoveMediaResponse',
  '2': [
    {'1': 'moved_count', '3': 1, '4': 1, '5': 5, '10': 'movedCount'},
    {
      '1': 'media',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Media',
      '10': 'media'
    },
  ],
};

/// Descriptor for `MoveMediaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveMediaResponseDescriptor = $convert.base64Decode(
    'ChFNb3ZlTWVkaWFSZXNwb25zZRIfCgttb3ZlZF9jb3VudBgBIAEoBVIKbW92ZWRDb3VudBIqCg'
    'VtZWRpYRgCIAMoCzIULnN5bmN0di5jbGllbnQuTWVkaWFSBW1lZGlh');

@$core.Deprecated('Use editMediaRequestDescriptor instead')
const EditMediaRequest$json = {
  '1': 'EditMediaRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'description'},
  ],
};

/// Descriptor for `EditMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List editMediaRequestDescriptor = $convert.base64Decode(
    'ChBFZGl0TWVkaWFSZXF1ZXN0EjgKCG1lZGlhX2lkGAEgASgJQh26SBpyGBABGEAyEl5tZWRfW0'
    'EtWmEtejAtOV0rJFIHbWVkaWFJZBIcCgRuYW1lGAIgASgJQgi6SAVyAxj0A1IEbmFtZRIqCgtk'
    'ZXNjcmlwdGlvbhgDIAEoCUIIukgFcgMYiCdSC2Rlc2NyaXB0aW9u');

@$core.Deprecated('Use editMediaResponseDescriptor instead')
const EditMediaResponse$json = {
  '1': 'EditMediaResponse',
  '2': [
    {
      '1': 'media',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Media',
      '10': 'media'
    },
  ],
};

/// Descriptor for `EditMediaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List editMediaResponseDescriptor = $convert.base64Decode(
    'ChFFZGl0TWVkaWFSZXNwb25zZRIqCgVtZWRpYRgBIAEoCzIULnN5bmN0di5jbGllbnQuTWVkaW'
    'FSBW1lZGlh');

@$core.Deprecated('Use clearPlaylistRequestDescriptor instead')
const ClearPlaylistRequest$json = {
  '1': 'ClearPlaylistRequest',
  '2': [
    {'1': 'playlist_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
  ],
};

/// Descriptor for `ClearPlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearPlaylistRequestDescriptor = $convert.base64Decode(
    'ChRDbGVhclBsYXlsaXN0UmVxdWVzdBJACgtwbGF5bGlzdF9pZBgBIAEoCUIfukgcchcQARhAMh'
    'FecGxfW0EtWmEtejAtOV0rJNgBAVIKcGxheWxpc3RJZA==');

@$core.Deprecated('Use clearPlaylistResponseDescriptor instead')
const ClearPlaylistResponse$json = {
  '1': 'ClearPlaylistResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'deleted_count', '3': 2, '4': 1, '5': 5, '10': 'deletedCount'},
    {
      '1': 'deleted_playlists',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'deletedPlaylists'
    },
  ],
};

/// Descriptor for `ClearPlaylistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearPlaylistResponseDescriptor = $convert.base64Decode(
    'ChVDbGVhclBsYXlsaXN0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIjCg1kZW'
    'xldGVkX2NvdW50GAIgASgFUgxkZWxldGVkQ291bnQSKwoRZGVsZXRlZF9wbGF5bGlzdHMYAyAB'
    'KAVSEGRlbGV0ZWRQbGF5bGlzdHM=');

@$core.Deprecated('Use addMediaBatchRequestDescriptor instead')
const AddMediaBatchRequest$json = {
  '1': 'AddMediaBatchRequest',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.AddMediaRequest',
      '8': {},
      '10': 'items'
    },
  ],
};

/// Descriptor for `AddMediaBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMediaBatchRequestDescriptor = $convert.base64Decode(
    'ChRBZGRNZWRpYUJhdGNoUmVxdWVzdBI+CgVpdGVtcxgBIAMoCzIeLnN5bmN0di5jbGllbnQuQW'
    'RkTWVkaWFSZXF1ZXN0Qgi6SAWSAQIQZFIFaXRlbXM=');

@$core.Deprecated('Use addMediaBatchResponseDescriptor instead')
const AddMediaBatchResponse$json = {
  '1': 'AddMediaBatchResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.AddMediaResponse',
      '10': 'results'
    },
  ],
};

/// Descriptor for `AddMediaBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMediaBatchResponseDescriptor = $convert.base64Decode(
    'ChVBZGRNZWRpYUJhdGNoUmVzcG9uc2USOQoHcmVzdWx0cxgBIAMoCzIfLnN5bmN0di5jbGllbn'
    'QuQWRkTWVkaWFSZXNwb25zZVIHcmVzdWx0cw==');

@$core.Deprecated('Use updatePlaybackStateRequestDescriptor instead')
const UpdatePlaybackStateRequest$json = {
  '1': 'UpdatePlaybackStateRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PlaybackUpdateType',
      '8': {},
      '10': 'type'
    },
    {
      '1': 'playing',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'playing',
      '17': true
    },
    {
      '1': 'position',
      '3': 3,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'position',
      '17': true
    },
    {'1': 'speed', '3': 4, '4': 1, '5': 1, '9': 2, '10': 'speed', '17': true},
    {
      '1': 'version',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'version',
      '17': true
    },
    {
      '1': 'expected_media_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'expectedMediaId',
      '17': true
    },
    {
      '1': 'expected_playlist_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'expectedPlaylistId',
      '17': true
    },
    {
      '1': 'expected_target_hash',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'expectedTargetHash',
      '17': true
    },
  ],
  '7': {},
  '8': [
    {'1': '_playing'},
    {'1': '_position'},
    {'1': '_speed'},
    {'1': '_version'},
    {'1': '_expected_media_id'},
    {'1': '_expected_playlist_id'},
    {'1': '_expected_target_hash'},
  ],
};

/// Descriptor for `UpdatePlaybackStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaybackStateRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVQbGF5YmFja1N0YXRlUmVxdWVzdBI/CgR0eXBlGAEgASgOMiEuc3luY3R2LmNsaW'
    'VudC5QbGF5YmFja1VwZGF0ZVR5cGVCCLpIBYIBAhABUgR0eXBlEh0KB3BsYXlpbmcYAiABKAhI'
    'AFIHcGxheWluZ4gBARIfCghwb3NpdGlvbhgDIAEoAUgBUghwb3NpdGlvbogBARIZCgVzcGVlZB'
    'gEIAEoAUgCUgVzcGVlZIgBARIdCgd2ZXJzaW9uGAUgASgDSANSB3ZlcnNpb26IAQESLwoRZXhw'
    'ZWN0ZWRfbWVkaWFfaWQYBiABKAlIBFIPZXhwZWN0ZWRNZWRpYUlkiAEBEjUKFGV4cGVjdGVkX3'
    'BsYXlsaXN0X2lkGAcgASgJSAVSEmV4cGVjdGVkUGxheWxpc3RJZIgBARI1ChRleHBlY3RlZF90'
    'YXJnZXRfaGFzaBgIIAEoCUgGUhJleHBlY3RlZFRhcmdldEhhc2iIAQE6YrpIXxpdCiN1cGRhdG'
    'VfcGxheWJhY2tfc3RhdGUudHlwZV9yZXF1aXJlZBImcGxheWJhY2sgc3RhdGUgdXBkYXRlIHR5'
    'cGUgaXMgcmVxdWlyZWQaDnRoaXMudHlwZSAhPSAwQgoKCF9wbGF5aW5nQgsKCV9wb3NpdGlvbk'
    'IICgZfc3BlZWRCCgoIX3ZlcnNpb25CFAoSX2V4cGVjdGVkX21lZGlhX2lkQhcKFV9leHBlY3Rl'
    'ZF9wbGF5bGlzdF9pZEIXChVfZXhwZWN0ZWRfdGFyZ2V0X2hhc2g=');

@$core.Deprecated('Use updatePlaybackStateResponseDescriptor instead')
const UpdatePlaybackStateResponse$json = {
  '1': 'UpdatePlaybackStateResponse',
  '2': [
    {
      '1': 'playback_state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackState',
      '10': 'playbackState'
    },
  ],
};

/// Descriptor for `UpdatePlaybackStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaybackStateResponseDescriptor =
    $convert.base64Decode(
        'ChtVcGRhdGVQbGF5YmFja1N0YXRlUmVzcG9uc2USQwoOcGxheWJhY2tfc3RhdGUYASABKAsyHC'
        '5zeW5jdHYuY2xpZW50LlBsYXliYWNrU3RhdGVSDXBsYXliYWNrU3RhdGU=');

@$core.Deprecated('Use playbackClientProfileDescriptor instead')
const PlaybackClientProfile$json = {
  '1': 'PlaybackClientProfile',
  '2': [
    {
      '1': 'delivery_preference',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PlaybackDeliveryPreference',
      '8': {},
      '10': 'deliveryPreference'
    },
    {
      '1': 'max_streaming_bitrate',
      '3': 2,
      '4': 1,
      '5': 3,
      '8': {},
      '9': 0,
      '10': 'maxStreamingBitrate',
      '17': true
    },
    {
      '1': 'max_audio_channels',
      '3': 3,
      '4': 1,
      '5': 5,
      '8': {},
      '9': 1,
      '10': 'maxAudioChannels',
      '17': true
    },
    {
      '1': 'supported_video_codecs',
      '3': 4,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PlaybackVideoCodec',
      '8': {},
      '10': 'supportedVideoCodecs'
    },
    {
      '1': 'supported_containers',
      '3': 5,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PlaybackContainer',
      '8': {},
      '10': 'supportedContainers'
    },
    {
      '1': 'audio_capability',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PlaybackAudioCapability',
      '8': {},
      '10': 'audioCapability'
    },
    {
      '1': 'subtitle_preference',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PlaybackSubtitlePreference',
      '8': {},
      '10': 'subtitlePreference'
    },
  ],
  '8': [
    {'1': '_max_streaming_bitrate'},
    {'1': '_max_audio_channels'},
  ],
};

/// Descriptor for `PlaybackClientProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackClientProfileDescriptor = $convert.base64Decode(
    'ChVQbGF5YmFja0NsaWVudFByb2ZpbGUSZAoTZGVsaXZlcnlfcHJlZmVyZW5jZRgBIAEoDjIpLn'
    'N5bmN0di5jbGllbnQuUGxheWJhY2tEZWxpdmVyeVByZWZlcmVuY2VCCLpIBYIBAhABUhJkZWxp'
    'dmVyeVByZWZlcmVuY2USQAoVbWF4X3N0cmVhbWluZ19iaXRyYXRlGAIgASgDQge6SAQiAiAASA'
    'BSE21heFN0cmVhbWluZ0JpdHJhdGWIAQESOgoSbWF4X2F1ZGlvX2NoYW5uZWxzGAMgASgFQge6'
    'SAQaAiAASAFSEG1heEF1ZGlvQ2hhbm5lbHOIAQESZgoWc3VwcG9ydGVkX3ZpZGVvX2NvZGVjcx'
    'gEIAMoDjIhLnN5bmN0di5jbGllbnQuUGxheWJhY2tWaWRlb0NvZGVjQg26SAqSAQciBYIBAhAB'
    'UhRzdXBwb3J0ZWRWaWRlb0NvZGVjcxJiChRzdXBwb3J0ZWRfY29udGFpbmVycxgFIAMoDjIgLn'
    'N5bmN0di5jbGllbnQuUGxheWJhY2tDb250YWluZXJCDbpICpIBByIFggECEAFSE3N1cHBvcnRl'
    'ZENvbnRhaW5lcnMSWwoQYXVkaW9fY2FwYWJpbGl0eRgGIAEoDjImLnN5bmN0di5jbGllbnQuUG'
    'xheWJhY2tBdWRpb0NhcGFiaWxpdHlCCLpIBYIBAhABUg9hdWRpb0NhcGFiaWxpdHkSZAoTc3Vi'
    'dGl0bGVfcHJlZmVyZW5jZRgHIAEoDjIpLnN5bmN0di5jbGllbnQuUGxheWJhY2tTdWJ0aXRsZV'
    'ByZWZlcmVuY2VCCLpIBYIBAhABUhJzdWJ0aXRsZVByZWZlcmVuY2VCGAoWX21heF9zdHJlYW1p'
    'bmdfYml0cmF0ZUIVChNfbWF4X2F1ZGlvX2NoYW5uZWxz');

@$core.Deprecated('Use getPlaybackRequestDescriptor instead')
const GetPlaybackRequest$json = {
  '1': 'GetPlaybackRequest',
  '2': [
    {
      '1': 'playback_client_profile',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackClientProfile',
      '10': 'playbackClientProfile'
    },
  ],
};

/// Descriptor for `GetPlaybackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlaybackRequestDescriptor = $convert.base64Decode(
    'ChJHZXRQbGF5YmFja1JlcXVlc3QSXAoXcGxheWJhY2tfY2xpZW50X3Byb2ZpbGUYASABKAsyJC'
    '5zeW5jdHYuY2xpZW50LlBsYXliYWNrQ2xpZW50UHJvZmlsZVIVcGxheWJhY2tDbGllbnRQcm9m'
    'aWxl');

@$core.Deprecated('Use getPlaybackResponseDescriptor instead')
const GetPlaybackResponse$json = {
  '1': 'GetPlaybackResponse',
  '2': [
    {
      '1': 'playback_state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackState',
      '10': 'playbackState'
    },
    {
      '1': 'playback',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playback',
      '10': 'playback'
    },
  ],
};

/// Descriptor for `GetPlaybackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlaybackResponseDescriptor = $convert.base64Decode(
    'ChNHZXRQbGF5YmFja1Jlc3BvbnNlEkMKDnBsYXliYWNrX3N0YXRlGAEgASgLMhwuc3luY3R2Lm'
    'NsaWVudC5QbGF5YmFja1N0YXRlUg1wbGF5YmFja1N0YXRlEjMKCHBsYXliYWNrGAIgASgLMhcu'
    'c3luY3R2LmNsaWVudC5QbGF5YmFja1IIcGxheWJhY2s=');

@$core.Deprecated('Use playbackDescriptor instead')
const Playback$json = {
  '1': 'Playback',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'room_id', '3': 3, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'playlist_position',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'playlistPosition'
    },
    {
      '1': 'playback_infos',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Playback.PlaybackInfosEntry',
      '10': 'playbackInfos'
    },
    {'1': 'default_mode', '3': 7, '4': 1, '5': 9, '10': 'defaultMode'},
    {
      '1': 'metadata',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Playback.MetadataEntry',
      '10': 'metadata'
    },
    {
      '1': 'expires_at',
      '3': 10,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'expiresAt',
      '17': true
    },
  ],
  '3': [Playback_PlaybackInfosEntry$json, Playback_MetadataEntry$json],
  '8': [
    {'1': '_expires_at'},
  ],
};

@$core.Deprecated('Use playbackDescriptor instead')
const Playback_PlaybackInfosEntry$json = {
  '1': 'PlaybackInfosEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackInfo',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use playbackDescriptor instead')
const Playback_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Playback`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackDescriptor = $convert.base64Decode(
    'CghQbGF5YmFjaxIZCghtZWRpYV9pZBgBIAEoCVIHbWVkaWFJZBIfCgtwbGF5bGlzdF9pZBgCIA'
    'EoCVIKcGxheWxpc3RJZBIXCgdyb29tX2lkGAMgASgJUgZyb29tSWQSEgoEbmFtZRgEIAEoCVIE'
    'bmFtZRIrChFwbGF5bGlzdF9wb3NpdGlvbhgFIAEoAVIQcGxheWxpc3RQb3NpdGlvbhJRCg5wbG'
    'F5YmFja19pbmZvcxgGIAMoCzIqLnN5bmN0di5jbGllbnQuUGxheWJhY2suUGxheWJhY2tJbmZv'
    'c0VudHJ5Ug1wbGF5YmFja0luZm9zEiEKDGRlZmF1bHRfbW9kZRgHIAEoCVILZGVmYXVsdE1vZG'
    'USQQoIbWV0YWRhdGEYCCADKAsyJS5zeW5jdHYuY2xpZW50LlBsYXliYWNrLk1ldGFkYXRhRW50'
    'cnlSCG1ldGFkYXRhEiIKCmV4cGlyZXNfYXQYCiABKANIAFIJZXhwaXJlc0F0iAEBGl0KElBsYX'
    'liYWNrSW5mb3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIxCgV2YWx1ZRgCIAEoCzIbLnN5bmN0'
    'di5jbGllbnQuUGxheWJhY2tJbmZvUgV2YWx1ZToCOAEaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZX'
    'kYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBQg0KC19leHBpcmVzX2F0');

@$core.Deprecated('Use playbackInfoDescriptor instead')
const PlaybackInfo$json = {
  '1': 'PlaybackInfo',
  '2': [
    {
      '1': 'urls',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaybackUrl',
      '10': 'urls'
    },
    {'1': 'default_url_index', '3': 2, '4': 1, '5': 5, '10': 'defaultUrlIndex'},
    {
      '1': 'subtitles',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Subtitle',
      '10': 'subtitles'
    },
    {
      '1': 'default_subtitle_index',
      '3': 4,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'defaultSubtitleIndex',
      '17': true
    },
    {
      '1': 'danmakus',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Danmaku',
      '10': 'danmakus'
    },
    {'1': 'format', '3': 6, '4': 1, '5': 9, '10': 'format'},
  ],
  '8': [
    {'1': '_default_subtitle_index'},
  ],
};

/// Descriptor for `PlaybackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackInfoDescriptor = $convert.base64Decode(
    'CgxQbGF5YmFja0luZm8SLgoEdXJscxgBIAMoCzIaLnN5bmN0di5jbGllbnQuUGxheWJhY2tVcm'
    'xSBHVybHMSKgoRZGVmYXVsdF91cmxfaW5kZXgYAiABKAVSD2RlZmF1bHRVcmxJbmRleBI1Cglz'
    'dWJ0aXRsZXMYAyADKAsyFy5zeW5jdHYuY2xpZW50LlN1YnRpdGxlUglzdWJ0aXRsZXMSOQoWZG'
    'VmYXVsdF9zdWJ0aXRsZV9pbmRleBgEIAEoBUgAUhRkZWZhdWx0U3VidGl0bGVJbmRleIgBARIy'
    'CghkYW5tYWt1cxgFIAMoCzIWLnN5bmN0di5jbGllbnQuRGFubWFrdVIIZGFubWFrdXMSFgoGZm'
    '9ybWF0GAYgASgJUgZmb3JtYXRCGQoXX2RlZmF1bHRfc3VidGl0bGVfaW5kZXg=');

@$core.Deprecated('Use playbackUrlDescriptor instead')
const PlaybackUrl$json = {
  '1': 'PlaybackUrl',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'headers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaybackUrl.HeadersEntry',
      '10': 'headers'
    },
    {
      '1': 'expire_at',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'expireAt',
      '17': true
    },
    {
      '1': 'metadata',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackUrlMetadata',
      '9': 1,
      '10': 'metadata',
      '17': true
    },
  ],
  '3': [PlaybackUrl_HeadersEntry$json],
  '8': [
    {'1': '_expire_at'},
    {'1': '_metadata'},
  ],
};

@$core.Deprecated('Use playbackUrlDescriptor instead')
const PlaybackUrl_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PlaybackUrl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackUrlDescriptor = $convert.base64Decode(
    'CgtQbGF5YmFja1VybBISCgRuYW1lGAEgASgJUgRuYW1lEhAKA3VybBgCIAEoCVIDdXJsEkEKB2'
    'hlYWRlcnMYAyADKAsyJy5zeW5jdHYuY2xpZW50LlBsYXliYWNrVXJsLkhlYWRlcnNFbnRyeVIH'
    'aGVhZGVycxIgCglleHBpcmVfYXQYBCABKANIAFIIZXhwaXJlQXSIAQESQwoIbWV0YWRhdGEYBS'
    'ABKAsyIi5zeW5jdHYuY2xpZW50LlBsYXliYWNrVXJsTWV0YWRhdGFIAVIIbWV0YWRhdGGIAQEa'
    'OgoMSGVhZGVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZT'
    'oCOAFCDAoKX2V4cGlyZV9hdEILCglfbWV0YWRhdGE=');

@$core.Deprecated('Use playbackUrlMetadataDescriptor instead')
const PlaybackUrlMetadata$json = {
  '1': 'PlaybackUrlMetadata',
  '2': [
    {
      '1': 'resolution',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'resolution',
      '17': true
    },
    {
      '1': 'bitrate',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'bitrate',
      '17': true
    },
    {'1': 'codec', '3': 3, '4': 1, '5': 9, '9': 2, '10': 'codec', '17': true},
    {'1': 'fps', '3': 4, '4': 1, '5': 5, '9': 3, '10': 'fps', '17': true},
    {
      '1': 'extra',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaybackUrlMetadata.ExtraEntry',
      '10': 'extra'
    },
  ],
  '3': [PlaybackUrlMetadata_ExtraEntry$json],
  '8': [
    {'1': '_resolution'},
    {'1': '_bitrate'},
    {'1': '_codec'},
    {'1': '_fps'},
  ],
};

@$core.Deprecated('Use playbackUrlMetadataDescriptor instead')
const PlaybackUrlMetadata_ExtraEntry$json = {
  '1': 'ExtraEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PlaybackUrlMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackUrlMetadataDescriptor = $convert.base64Decode(
    'ChNQbGF5YmFja1VybE1ldGFkYXRhEiMKCnJlc29sdXRpb24YASABKAlIAFIKcmVzb2x1dGlvbo'
    'gBARIdCgdiaXRyYXRlGAIgASgDSAFSB2JpdHJhdGWIAQESGQoFY29kZWMYAyABKAlIAlIFY29k'
    'ZWOIAQESFQoDZnBzGAQgASgFSANSA2Zwc4gBARJDCgVleHRyYRgFIAMoCzItLnN5bmN0di5jbG'
    'llbnQuUGxheWJhY2tVcmxNZXRhZGF0YS5FeHRyYUVudHJ5UgVleHRyYRo4CgpFeHRyYUVudHJ5'
    'EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFCDQoLX3Jlc29sdX'
    'Rpb25CCgoIX2JpdHJhdGVCCAoGX2NvZGVjQgYKBF9mcHM=');

@$core.Deprecated('Use subtitleDescriptor instead')
const Subtitle$json = {
  '1': 'Subtitle',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
    {
      '1': 'urls',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.SubtitleUrl',
      '10': 'urls'
    },
    {'1': 'default_url_index', '3': 4, '4': 1, '5': 5, '10': 'defaultUrlIndex'},
  ],
};

/// Descriptor for `Subtitle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subtitleDescriptor = $convert.base64Decode(
    'CghTdWJ0aXRsZRISCgRuYW1lGAEgASgJUgRuYW1lEhoKCGxhbmd1YWdlGAIgASgJUghsYW5ndW'
    'FnZRIuCgR1cmxzGAMgAygLMhouc3luY3R2LmNsaWVudC5TdWJ0aXRsZVVybFIEdXJscxIqChFk'
    'ZWZhdWx0X3VybF9pbmRleBgEIAEoBVIPZGVmYXVsdFVybEluZGV4');

@$core.Deprecated('Use subtitleUrlDescriptor instead')
const SubtitleUrl$json = {
  '1': 'SubtitleUrl',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'headers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.SubtitleUrl.HeadersEntry',
      '10': 'headers'
    },
    {'1': 'format', '3': 4, '4': 1, '5': 9, '10': 'format'},
  ],
  '3': [SubtitleUrl_HeadersEntry$json],
};

@$core.Deprecated('Use subtitleUrlDescriptor instead')
const SubtitleUrl_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SubtitleUrl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subtitleUrlDescriptor = $convert.base64Decode(
    'CgtTdWJ0aXRsZVVybBISCgRuYW1lGAEgASgJUgRuYW1lEhAKA3VybBgCIAEoCVIDdXJsEkEKB2'
    'hlYWRlcnMYAyADKAsyJy5zeW5jdHYuY2xpZW50LlN1YnRpdGxlVXJsLkhlYWRlcnNFbnRyeVIH'
    'aGVhZGVycxIWCgZmb3JtYXQYBCABKAlSBmZvcm1hdBo6CgxIZWFkZXJzRW50cnkSEAoDa2V5GA'
    'EgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use danmakuDescriptor instead')
const Danmaku$json = {
  '1': 'Danmaku',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'format', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'format', '17': true},
    {
      '1': 'headers',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.Danmaku.HeadersEntry',
      '10': 'headers'
    },
  ],
  '3': [Danmaku_HeadersEntry$json],
  '8': [
    {'1': '_format'},
  ],
};

@$core.Deprecated('Use danmakuDescriptor instead')
const Danmaku_HeadersEntry$json = {
  '1': 'HeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Danmaku`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List danmakuDescriptor = $convert.base64Decode(
    'CgdEYW5tYWt1EhIKBG5hbWUYASABKAlSBG5hbWUSEAoDdXJsGAIgASgJUgN1cmwSGwoGZm9ybW'
    'F0GAMgASgJSABSBmZvcm1hdIgBARI9CgdoZWFkZXJzGAQgAygLMiMuc3luY3R2LmNsaWVudC5E'
    'YW5tYWt1LkhlYWRlcnNFbnRyeVIHaGVhZGVycxo6CgxIZWFkZXJzRW50cnkSEAoDa2V5GAEgAS'
    'gJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AUIJCgdfZm9ybWF0');

@$core.Deprecated('Use clientMessageDescriptor instead')
const ClientMessage$json = {
  '1': 'ClientMessage',
  '2': [
    {
      '1': 'chat',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageSend',
      '9': 0,
      '10': 'chat'
    },
    {
      '1': 'heartbeat',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.HeartbeatMessage',
      '9': 0,
      '10': 'heartbeat'
    },
    {
      '1': 'playback_state_update',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UpdatePlaybackStateRequest',
      '9': 0,
      '10': 'playbackStateUpdate'
    },
    {
      '1': 'playback_update',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UpdatePlaybackRequest',
      '9': 0,
      '10': 'playbackUpdate'
    },
    {
      '1': 'observe_resource',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveResource',
      '9': 0,
      '10': 'observeResource'
    },
    {
      '1': 'unobserve_resource',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UnobserveResource',
      '9': 0,
      '10': 'unobserveResource'
    },
    {
      '1': 'webrtc',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRtcCommand',
      '9': 0,
      '10': 'webrtc'
    },
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `ClientMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientMessageDescriptor = $convert.base64Decode(
    'Cg1DbGllbnRNZXNzYWdlEjQKBGNoYXQYASABKAsyHi5zeW5jdHYuY2xpZW50LkNoYXRNZXNzYW'
    'dlU2VuZEgAUgRjaGF0Ej8KCWhlYXJ0YmVhdBgCIAEoCzIfLnN5bmN0di5jbGllbnQuSGVhcnRi'
    'ZWF0TWVzc2FnZUgAUgloZWFydGJlYXQSXwoVcGxheWJhY2tfc3RhdGVfdXBkYXRlGAMgASgLMi'
    'kuc3luY3R2LmNsaWVudC5VcGRhdGVQbGF5YmFja1N0YXRlUmVxdWVzdEgAUhNwbGF5YmFja1N0'
    'YXRlVXBkYXRlEk8KD3BsYXliYWNrX3VwZGF0ZRgEIAEoCzIkLnN5bmN0di5jbGllbnQuVXBkYX'
    'RlUGxheWJhY2tSZXF1ZXN0SABSDnBsYXliYWNrVXBkYXRlEksKEG9ic2VydmVfcmVzb3VyY2UY'
    'BSABKAsyHi5zeW5jdHYuY2xpZW50Lk9ic2VydmVSZXNvdXJjZUgAUg9vYnNlcnZlUmVzb3VyY2'
    'USUQoSdW5vYnNlcnZlX3Jlc291cmNlGAYgASgLMiAuc3luY3R2LmNsaWVudC5Vbm9ic2VydmVS'
    'ZXNvdXJjZUgAUhF1bm9ic2VydmVSZXNvdXJjZRI2CgZ3ZWJydGMYByABKAsyHC5zeW5jdHYuY2'
    'xpZW50LldlYlJ0Y0NvbW1hbmRIAFIGd2VicnRjQgkKB21lc3NhZ2U=');

@$core.Deprecated('Use observeResourceDescriptor instead')
const ObserveResource$json = {
  '1': 'ObserveResource',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'observeId'},
    {
      '1': 'delivery_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'playback_state',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlaybackState',
      '9': 0,
      '10': 'playbackState'
    },
    {
      '1': 'playback',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlayback',
      '9': 0,
      '10': 'playback'
    },
    {
      '1': 'room_settings',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveRoomSettings',
      '9': 0,
      '10': 'roomSettings'
    },
    {
      '1': 'playlist_items',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlaylistItems',
      '9': 0,
      '10': 'playlistItems'
    },
    {
      '1': 'room_member_events',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveRoomMemberEvents',
      '9': 0,
      '10': 'roomMemberEvents'
    },
    {
      '1': 'chat_events',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveChatEvents',
      '9': 0,
      '10': 'chatEvents'
    },
    {
      '1': 'online_count',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveOnlineCount',
      '9': 0,
      '10': 'onlineCount'
    },
    {
      '1': 'online_event',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveOnlineEvent',
      '9': 0,
      '10': 'onlineEvent'
    },
    {
      '1': 'self_room_member',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveSelfRoomMember',
      '9': 0,
      '10': 'selfRoomMember'
    },
  ],
  '8': [
    {'1': 'resource'},
  ],
};

/// Descriptor for `ObserveResource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeResourceDescriptor = $convert.base64Decode(
    'Cg9PYnNlcnZlUmVzb3VyY2USKQoKb2JzZXJ2ZV9pZBgBIAEoCUIKukgHcgUQARiAAVIJb2JzZX'
    'J2ZUlkElIKDWRlbGl2ZXJ5X21vZGUYAyABKA4yIy5zeW5jdHYuY2xpZW50LlJlc291cmNlRGVs'
    'aXZlcnlNb2RlQgi6SAWCAQIQAVIMZGVsaXZlcnlNb2RlEkwKDnBsYXliYWNrX3N0YXRlGAQgAS'
    'gLMiMuc3luY3R2LmNsaWVudC5PYnNlcnZlUGxheWJhY2tTdGF0ZUgAUg1wbGF5YmFja1N0YXRl'
    'EjwKCHBsYXliYWNrGAUgASgLMh4uc3luY3R2LmNsaWVudC5PYnNlcnZlUGxheWJhY2tIAFIIcG'
    'xheWJhY2sSSQoNcm9vbV9zZXR0aW5ncxgGIAEoCzIiLnN5bmN0di5jbGllbnQuT2JzZXJ2ZVJv'
    'b21TZXR0aW5nc0gAUgxyb29tU2V0dGluZ3MSTAoOcGxheWxpc3RfaXRlbXMYByABKAsyIy5zeW'
    '5jdHYuY2xpZW50Lk9ic2VydmVQbGF5bGlzdEl0ZW1zSABSDXBsYXlsaXN0SXRlbXMSVgoScm9v'
    'bV9tZW1iZXJfZXZlbnRzGAggASgLMiYuc3luY3R2LmNsaWVudC5PYnNlcnZlUm9vbU1lbWJlck'
    'V2ZW50c0gAUhByb29tTWVtYmVyRXZlbnRzEkMKC2NoYXRfZXZlbnRzGAkgASgLMiAuc3luY3R2'
    'LmNsaWVudC5PYnNlcnZlQ2hhdEV2ZW50c0gAUgpjaGF0RXZlbnRzEkYKDG9ubGluZV9jb3VudB'
    'gKIAEoCzIhLnN5bmN0di5jbGllbnQuT2JzZXJ2ZU9ubGluZUNvdW50SABSC29ubGluZUNvdW50'
    'EkYKDG9ubGluZV9ldmVudBgLIAEoCzIhLnN5bmN0di5jbGllbnQuT2JzZXJ2ZU9ubGluZUV2ZW'
    '50SABSC29ubGluZUV2ZW50ElAKEHNlbGZfcm9vbV9tZW1iZXIYDCABKAsyJC5zeW5jdHYuY2xp'
    'ZW50Lk9ic2VydmVTZWxmUm9vbU1lbWJlckgAUg5zZWxmUm9vbU1lbWJlckIKCghyZXNvdXJjZQ'
    '==');

@$core.Deprecated('Use unobserveResourceDescriptor instead')
const UnobserveResource$json = {
  '1': 'UnobserveResource',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'observeId'},
  ],
};

/// Descriptor for `UnobserveResource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unobserveResourceDescriptor = $convert.base64Decode(
    'ChFVbm9ic2VydmVSZXNvdXJjZRIpCgpvYnNlcnZlX2lkGAEgASgJQgq6SAdyBRABGIABUglvYn'
    'NlcnZlSWQ=');

@$core.Deprecated('Use observePlaybackStateDescriptor instead')
const ObservePlaybackState$json = {
  '1': 'ObservePlaybackState',
  '2': [
    {
      '1': 'after_event_sequence',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'afterEventSequence',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_event_sequence'},
  ],
};

/// Descriptor for `ObservePlaybackState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observePlaybackStateDescriptor = $convert.base64Decode(
    'ChRPYnNlcnZlUGxheWJhY2tTdGF0ZRI1ChRhZnRlcl9ldmVudF9zZXF1ZW5jZRgBIAEoA0gAUh'
    'JhZnRlckV2ZW50U2VxdWVuY2WIAQFCFwoVX2FmdGVyX2V2ZW50X3NlcXVlbmNl');

@$core.Deprecated('Use observePlaybackDescriptor instead')
const ObservePlayback$json = {
  '1': 'ObservePlayback',
  '2': [
    {
      '1': 'playback_client_profile',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackClientProfile',
      '10': 'playbackClientProfile'
    },
  ],
};

/// Descriptor for `ObservePlayback`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observePlaybackDescriptor = $convert.base64Decode(
    'Cg9PYnNlcnZlUGxheWJhY2sSXAoXcGxheWJhY2tfY2xpZW50X3Byb2ZpbGUYBCABKAsyJC5zeW'
    '5jdHYuY2xpZW50LlBsYXliYWNrQ2xpZW50UHJvZmlsZVIVcGxheWJhY2tDbGllbnRQcm9maWxl');

@$core.Deprecated('Use observeRoomSettingsDescriptor instead')
const ObserveRoomSettings$json = {
  '1': 'ObserveRoomSettings',
  '2': [
    {
      '1': 'after_event_sequence',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'afterEventSequence',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_event_sequence'},
  ],
};

/// Descriptor for `ObserveRoomSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeRoomSettingsDescriptor = $convert.base64Decode(
    'ChNPYnNlcnZlUm9vbVNldHRpbmdzEjUKFGFmdGVyX2V2ZW50X3NlcXVlbmNlGAEgASgDSABSEm'
    'FmdGVyRXZlbnRTZXF1ZW5jZYgBAUIXChVfYWZ0ZXJfZXZlbnRfc2VxdWVuY2U=');

@$core.Deprecated('Use observePlaylistItemsDescriptor instead')
const ObservePlaylistItems$json = {
  '1': 'ObservePlaylistItems',
  '2': [
    {
      '1': 'request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ListPlaylistItemsRequest',
      '10': 'request'
    },
    {
      '1': 'after_event_sequence',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'afterEventSequence',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_event_sequence'},
  ],
};

/// Descriptor for `ObservePlaylistItems`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observePlaylistItemsDescriptor = $convert.base64Decode(
    'ChRPYnNlcnZlUGxheWxpc3RJdGVtcxJBCgdyZXF1ZXN0GAEgASgLMicuc3luY3R2LmNsaWVudC'
    '5MaXN0UGxheWxpc3RJdGVtc1JlcXVlc3RSB3JlcXVlc3QSNQoUYWZ0ZXJfZXZlbnRfc2VxdWVu'
    'Y2UYAiABKANIAFISYWZ0ZXJFdmVudFNlcXVlbmNliAEBQhcKFV9hZnRlcl9ldmVudF9zZXF1ZW'
    '5jZQ==');

@$core.Deprecated('Use observeRoomMemberEventsDescriptor instead')
const ObserveRoomMemberEvents$json = {
  '1': 'ObserveRoomMemberEvents',
  '2': [
    {
      '1': 'after_event_sequence',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'afterEventSequence',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_event_sequence'},
  ],
};

/// Descriptor for `ObserveRoomMemberEvents`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeRoomMemberEventsDescriptor =
    $convert.base64Decode(
        'ChdPYnNlcnZlUm9vbU1lbWJlckV2ZW50cxI1ChRhZnRlcl9ldmVudF9zZXF1ZW5jZRgBIAEoA0'
        'gAUhJhZnRlckV2ZW50U2VxdWVuY2WIAQFCFwoVX2FmdGVyX2V2ZW50X3NlcXVlbmNl');

@$core.Deprecated('Use observeSelfRoomMemberDescriptor instead')
const ObserveSelfRoomMember$json = {
  '1': 'ObserveSelfRoomMember',
  '2': [
    {
      '1': 'after_event_sequence',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'afterEventSequence',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_event_sequence'},
  ],
};

/// Descriptor for `ObserveSelfRoomMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeSelfRoomMemberDescriptor = $convert.base64Decode(
    'ChVPYnNlcnZlU2VsZlJvb21NZW1iZXISNQoUYWZ0ZXJfZXZlbnRfc2VxdWVuY2UYASABKANIAF'
    'ISYWZ0ZXJFdmVudFNlcXVlbmNliAEBQhcKFV9hZnRlcl9ldmVudF9zZXF1ZW5jZQ==');

@$core.Deprecated('Use observeOnlineCountDescriptor instead')
const ObserveOnlineCount$json = {
  '1': 'ObserveOnlineCount',
  '2': [
    {
      '1': 'roles',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '8': {},
      '10': 'roles'
    },
    {'1': 'user_ids', '3': 2, '4': 3, '5': 9, '8': {}, '10': 'userIds'},
  ],
};

/// Descriptor for `ObserveOnlineCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeOnlineCountDescriptor = $convert.base64Decode(
    'ChJPYnNlcnZlT25saW5lQ291bnQSRAoFcm9sZXMYASADKA4yHS5zeW5jdHYuY29tbW9uLlJvb2'
    '1NZW1iZXJSb2xlQg+6SAySAQkQBCIFggECEAFSBXJvbGVzEiwKCHVzZXJfaWRzGAIgAygJQhG6'
    'SA6SAQsQ9AMiBnIEEAEYQFIHdXNlcklkcw==');

@$core.Deprecated('Use observeOnlineEventDescriptor instead')
const ObserveOnlineEvent$json = {
  '1': 'ObserveOnlineEvent',
  '2': [
    {
      '1': 'roles',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '8': {},
      '10': 'roles'
    },
    {
      '1': 'kinds',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.OnlineEventKind',
      '8': {},
      '10': 'kinds'
    },
    {'1': 'user_ids', '3': 3, '4': 3, '5': 9, '8': {}, '10': 'userIds'},
  ],
};

/// Descriptor for `ObserveOnlineEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeOnlineEventDescriptor = $convert.base64Decode(
    'ChJPYnNlcnZlT25saW5lRXZlbnQSRAoFcm9sZXMYASADKA4yHS5zeW5jdHYuY29tbW9uLlJvb2'
    '1NZW1iZXJSb2xlQg+6SAySAQkQBCIFggECEAFSBXJvbGVzEkUKBWtpbmRzGAIgAygOMh4uc3lu'
    'Y3R2LmNsaWVudC5PbmxpbmVFdmVudEtpbmRCD7pIDJIBCRACIgWCAQIQAVIFa2luZHMSLAoIdX'
    'Nlcl9pZHMYAyADKAlCEbpIDpIBCxD0AyIGcgQQARhAUgd1c2VySWRz');

@$core.Deprecated('Use observeChatEventsDescriptor instead')
const ObserveChatEvents$json = {
  '1': 'ObserveChatEvents',
  '2': [
    {
      '1': 'after_event_sequence',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'afterEventSequence',
      '17': true
    },
  ],
  '8': [
    {'1': '_after_event_sequence'},
  ],
};

/// Descriptor for `ObserveChatEvents`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeChatEventsDescriptor = $convert.base64Decode(
    'ChFPYnNlcnZlQ2hhdEV2ZW50cxI1ChRhZnRlcl9ldmVudF9zZXF1ZW5jZRgBIAEoA0gAUhJhZn'
    'RlckV2ZW50U2VxdWVuY2WIAQFCFwoVX2FmdGVyX2V2ZW50X3NlcXVlbmNl');

@$core.Deprecated('Use watchPlaybackStateRequestDescriptor instead')
const WatchPlaybackStateRequest$json = {
  '1': 'WatchPlaybackStateRequest',
  '2': [
    {
      '1': 'delivery_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'playback_state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlaybackState',
      '10': 'playbackState'
    },
  ],
};

/// Descriptor for `WatchPlaybackStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackStateRequestDescriptor = $convert.base64Decode(
    'ChlXYXRjaFBsYXliYWNrU3RhdGVSZXF1ZXN0ElIKDWRlbGl2ZXJ5X21vZGUYASABKA4yIy5zeW'
    '5jdHYuY2xpZW50LlJlc291cmNlRGVsaXZlcnlNb2RlQgi6SAWCAQIQAVIMZGVsaXZlcnlNb2Rl'
    'EkoKDnBsYXliYWNrX3N0YXRlGAIgASgLMiMuc3luY3R2LmNsaWVudC5PYnNlcnZlUGxheWJhY2'
    'tTdGF0ZVINcGxheWJhY2tTdGF0ZQ==');

@$core.Deprecated('Use watchPlaybackRequestDescriptor instead')
const WatchPlaybackRequest$json = {
  '1': 'WatchPlaybackRequest',
  '2': [
    {
      '1': 'delivery_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'playback',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlayback',
      '10': 'playback'
    },
  ],
};

/// Descriptor for `WatchPlaybackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackRequestDescriptor = $convert.base64Decode(
    'ChRXYXRjaFBsYXliYWNrUmVxdWVzdBJSCg1kZWxpdmVyeV9tb2RlGAEgASgOMiMuc3luY3R2Lm'
    'NsaWVudC5SZXNvdXJjZURlbGl2ZXJ5TW9kZUIIukgFggECEAFSDGRlbGl2ZXJ5TW9kZRI6Cghw'
    'bGF5YmFjaxgCIAEoCzIeLnN5bmN0di5jbGllbnQuT2JzZXJ2ZVBsYXliYWNrUghwbGF5YmFjaw'
    '==');

@$core.Deprecated('Use watchRoomSettingsRequestDescriptor instead')
const WatchRoomSettingsRequest$json = {
  '1': 'WatchRoomSettingsRequest',
  '2': [
    {
      '1': 'delivery_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'room_settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveRoomSettings',
      '10': 'roomSettings'
    },
  ],
};

/// Descriptor for `WatchRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomSettingsRequestDescriptor = $convert.base64Decode(
    'ChhXYXRjaFJvb21TZXR0aW5nc1JlcXVlc3QSUgoNZGVsaXZlcnlfbW9kZRgBIAEoDjIjLnN5bm'
    'N0di5jbGllbnQuUmVzb3VyY2VEZWxpdmVyeU1vZGVCCLpIBYIBAhABUgxkZWxpdmVyeU1vZGUS'
    'RwoNcm9vbV9zZXR0aW5ncxgCIAEoCzIiLnN5bmN0di5jbGllbnQuT2JzZXJ2ZVJvb21TZXR0aW'
    '5nc1IMcm9vbVNldHRpbmdz');

@$core.Deprecated('Use watchPlaylistItemsRequestDescriptor instead')
const WatchPlaylistItemsRequest$json = {
  '1': 'WatchPlaylistItemsRequest',
  '2': [
    {
      '1': 'delivery_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'playlist_items',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlaylistItems',
      '10': 'playlistItems'
    },
  ],
};

/// Descriptor for `WatchPlaylistItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaylistItemsRequestDescriptor = $convert.base64Decode(
    'ChlXYXRjaFBsYXlsaXN0SXRlbXNSZXF1ZXN0ElIKDWRlbGl2ZXJ5X21vZGUYASABKA4yIy5zeW'
    '5jdHYuY2xpZW50LlJlc291cmNlRGVsaXZlcnlNb2RlQgi6SAWCAQIQAVIMZGVsaXZlcnlNb2Rl'
    'EkoKDnBsYXlsaXN0X2l0ZW1zGAIgASgLMiMuc3luY3R2LmNsaWVudC5PYnNlcnZlUGxheWxpc3'
    'RJdGVtc1INcGxheWxpc3RJdGVtcw==');

@$core.Deprecated('Use watchRoomMemberEventsRequestDescriptor instead')
const WatchRoomMemberEventsRequest$json = {
  '1': 'WatchRoomMemberEventsRequest',
  '2': [
    {
      '1': 'delivery_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'room_member_events',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveRoomMemberEvents',
      '10': 'roomMemberEvents'
    },
  ],
};

/// Descriptor for `WatchRoomMemberEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomMemberEventsRequestDescriptor = $convert.base64Decode(
    'ChxXYXRjaFJvb21NZW1iZXJFdmVudHNSZXF1ZXN0ElIKDWRlbGl2ZXJ5X21vZGUYASABKA4yIy'
    '5zeW5jdHYuY2xpZW50LlJlc291cmNlRGVsaXZlcnlNb2RlQgi6SAWCAQIQAVIMZGVsaXZlcnlN'
    'b2RlElQKEnJvb21fbWVtYmVyX2V2ZW50cxgCIAEoCzImLnN5bmN0di5jbGllbnQuT2JzZXJ2ZV'
    'Jvb21NZW1iZXJFdmVudHNSEHJvb21NZW1iZXJFdmVudHM=');

@$core.Deprecated('Use watchChatEventsRequestDescriptor instead')
const WatchChatEventsRequest$json = {
  '1': 'WatchChatEventsRequest',
  '2': [
    {
      '1': 'delivery_mode',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '8': {},
      '10': 'deliveryMode'
    },
    {
      '1': 'chat_events',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveChatEvents',
      '10': 'chatEvents'
    },
  ],
};

/// Descriptor for `WatchChatEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchChatEventsRequestDescriptor = $convert.base64Decode(
    'ChZXYXRjaENoYXRFdmVudHNSZXF1ZXN0ElIKDWRlbGl2ZXJ5X21vZGUYASABKA4yIy5zeW5jdH'
    'YuY2xpZW50LlJlc291cmNlRGVsaXZlcnlNb2RlQgi6SAWCAQIQAVIMZGVsaXZlcnlNb2RlEkEK'
    'C2NoYXRfZXZlbnRzGAIgASgLMiAuc3luY3R2LmNsaWVudC5PYnNlcnZlQ2hhdEV2ZW50c1IKY2'
    'hhdEV2ZW50cw==');

@$core.Deprecated('Use watchPlaybackStateEventDescriptor instead')
const WatchPlaybackStateEvent$json = {
  '1': 'WatchPlaybackStateEvent',
  '2': [
    {
      '1': 'observed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'observed'
    },
    {
      '1': 'resource_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WatchPlaybackStateEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackStateEventDescriptor = $convert.base64Decode(
    'ChdXYXRjaFBsYXliYWNrU3RhdGVFdmVudBI9CghvYnNlcnZlZBgBIAEoCzIfLnN5bmN0di5jbG'
    'llbnQuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBJFCg5yZXNvdXJjZV9ldmVudBgCIAEo'
    'CzIcLnN5bmN0di5jbGllbnQuUmVzb3VyY2VFdmVudEgAUg1yZXNvdXJjZUV2ZW50EjsKBWVycm'
    '9yGAMgASgLMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVFcnJvckgAUgVlcnJvckIH'
    'CgVldmVudA==');

@$core.Deprecated('Use watchPlaybackEventDescriptor instead')
const WatchPlaybackEvent$json = {
  '1': 'WatchPlaybackEvent',
  '2': [
    {
      '1': 'observed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'observed'
    },
    {
      '1': 'resource_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WatchPlaybackEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackEventDescriptor = $convert.base64Decode(
    'ChJXYXRjaFBsYXliYWNrRXZlbnQSPQoIb2JzZXJ2ZWQYASABKAsyHy5zeW5jdHYuY2xpZW50Ll'
    'Jlc291cmNlT2JzZXJ2ZWRIAFIIb2JzZXJ2ZWQSRQoOcmVzb3VyY2VfZXZlbnQYAiABKAsyHC5z'
    'eW5jdHYuY2xpZW50LlJlc291cmNlRXZlbnRIAFINcmVzb3VyY2VFdmVudBI7CgVlcnJvchgDIA'
    'EoCzIjLnN5bmN0di5jbGllbnQuUmVzb3VyY2VPYnNlcnZlRXJyb3JIAFIFZXJyb3JCBwoFZXZl'
    'bnQ=');

@$core.Deprecated('Use watchRoomSettingsEventDescriptor instead')
const WatchRoomSettingsEvent$json = {
  '1': 'WatchRoomSettingsEvent',
  '2': [
    {
      '1': 'observed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'observed'
    },
    {
      '1': 'resource_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WatchRoomSettingsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomSettingsEventDescriptor = $convert.base64Decode(
    'ChZXYXRjaFJvb21TZXR0aW5nc0V2ZW50Ej0KCG9ic2VydmVkGAEgASgLMh8uc3luY3R2LmNsaW'
    'VudC5SZXNvdXJjZU9ic2VydmVkSABSCG9ic2VydmVkEkUKDnJlc291cmNlX2V2ZW50GAIgASgL'
    'Mhwuc3luY3R2LmNsaWVudC5SZXNvdXJjZUV2ZW50SABSDXJlc291cmNlRXZlbnQSOwoFZXJyb3'
    'IYAyABKAsyIy5zeW5jdHYuY2xpZW50LlJlc291cmNlT2JzZXJ2ZUVycm9ySABSBWVycm9yQgcK'
    'BWV2ZW50');

@$core.Deprecated('Use watchPlaylistItemsEventDescriptor instead')
const WatchPlaylistItemsEvent$json = {
  '1': 'WatchPlaylistItemsEvent',
  '2': [
    {
      '1': 'observed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'observed'
    },
    {
      '1': 'resource_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WatchPlaylistItemsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaylistItemsEventDescriptor = $convert.base64Decode(
    'ChdXYXRjaFBsYXlsaXN0SXRlbXNFdmVudBI9CghvYnNlcnZlZBgBIAEoCzIfLnN5bmN0di5jbG'
    'llbnQuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBJFCg5yZXNvdXJjZV9ldmVudBgCIAEo'
    'CzIcLnN5bmN0di5jbGllbnQuUmVzb3VyY2VFdmVudEgAUg1yZXNvdXJjZUV2ZW50EjsKBWVycm'
    '9yGAMgASgLMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVFcnJvckgAUgVlcnJvckIH'
    'CgVldmVudA==');

@$core.Deprecated('Use watchRoomMemberEventsEventDescriptor instead')
const WatchRoomMemberEventsEvent$json = {
  '1': 'WatchRoomMemberEventsEvent',
  '2': [
    {
      '1': 'observed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'observed'
    },
    {
      '1': 'resource_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WatchRoomMemberEventsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomMemberEventsEventDescriptor = $convert.base64Decode(
    'ChpXYXRjaFJvb21NZW1iZXJFdmVudHNFdmVudBI9CghvYnNlcnZlZBgBIAEoCzIfLnN5bmN0di'
    '5jbGllbnQuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBJFCg5yZXNvdXJjZV9ldmVudBgC'
    'IAEoCzIcLnN5bmN0di5jbGllbnQuUmVzb3VyY2VFdmVudEgAUg1yZXNvdXJjZUV2ZW50EjsKBW'
    'Vycm9yGAMgASgLMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVFcnJvckgAUgVlcnJv'
    'ckIHCgVldmVudA==');

@$core.Deprecated('Use watchChatEventsEventDescriptor instead')
const WatchChatEventsEvent$json = {
  '1': 'WatchChatEventsEvent',
  '2': [
    {
      '1': 'observed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'observed'
    },
    {
      '1': 'resource_event',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WatchChatEventsEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchChatEventsEventDescriptor = $convert.base64Decode(
    'ChRXYXRjaENoYXRFdmVudHNFdmVudBI9CghvYnNlcnZlZBgBIAEoCzIfLnN5bmN0di5jbGllbn'
    'QuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBJFCg5yZXNvdXJjZV9ldmVudBgCIAEoCzIc'
    'LnN5bmN0di5jbGllbnQuUmVzb3VyY2VFdmVudEgAUg1yZXNvdXJjZUV2ZW50EjsKBWVycm9yGA'
    'MgASgLMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVFcnJvckgAUgVlcnJvckIHCgVl'
    'dmVudA==');

@$core.Deprecated('Use serverMessageDescriptor instead')
const ServerMessage$json = {
  '1': 'ServerMessage',
  '2': [
    {
      '1': 'heartbeat_ack',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.HeartbeatAck',
      '9': 0,
      '10': 'heartbeatAck'
    },
    {
      '1': 'error',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ErrorMessage',
      '9': 0,
      '10': 'error'
    },
    {
      '1': 'notification',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserNotification',
      '9': 0,
      '10': 'notification'
    },
    {
      '1': 'resource_observed',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserved',
      '9': 0,
      '10': 'resourceObserved'
    },
    {
      '1': 'resource_event',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEvent',
      '9': 0,
      '10': 'resourceEvent'
    },
    {
      '1': 'resource_observe_error',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceObserveError',
      '9': 0,
      '10': 'resourceObserveError'
    },
  ],
  '8': [
    {'1': 'message'},
  ],
};

/// Descriptor for `ServerMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverMessageDescriptor = $convert.base64Decode(
    'Cg1TZXJ2ZXJNZXNzYWdlEkIKDWhlYXJ0YmVhdF9hY2sYBiABKAsyGy5zeW5jdHYuY2xpZW50Lk'
    'hlYXJ0YmVhdEFja0gAUgxoZWFydGJlYXRBY2sSMwoFZXJyb3IYByABKAsyGy5zeW5jdHYuY2xp'
    'ZW50LkVycm9yTWVzc2FnZUgAUgVlcnJvchJFCgxub3RpZmljYXRpb24YGCABKAsyHy5zeW5jdH'
    'YuY2xpZW50LlVzZXJOb3RpZmljYXRpb25IAFIMbm90aWZpY2F0aW9uEk4KEXJlc291cmNlX29i'
    'c2VydmVkGB0gASgLMh8uc3luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVkSABSEHJlc291cm'
    'NlT2JzZXJ2ZWQSRQoOcmVzb3VyY2VfZXZlbnQYHiABKAsyHC5zeW5jdHYuY2xpZW50LlJlc291'
    'cmNlRXZlbnRIAFINcmVzb3VyY2VFdmVudBJbChZyZXNvdXJjZV9vYnNlcnZlX2Vycm9yGB8gAS'
    'gLMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVFcnJvckgAUhRyZXNvdXJjZU9ic2Vy'
    'dmVFcnJvckIJCgdtZXNzYWdl');

@$core.Deprecated('Use resourceObservedDescriptor instead')
const ResourceObserved$json = {
  '1': 'ResourceObserved',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '10': 'observeId'},
    {'1': 'changed', '3': 3, '4': 1, '5': 8, '10': 'changed'},
    {
      '1': 'event_cursor',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.EventCursor',
      '10': 'eventCursor'
    },
  ],
};

/// Descriptor for `ResourceObserved`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceObservedDescriptor = $convert.base64Decode(
    'ChBSZXNvdXJjZU9ic2VydmVkEh0KCm9ic2VydmVfaWQYASABKAlSCW9ic2VydmVJZBIYCgdjaG'
    'FuZ2VkGAMgASgIUgdjaGFuZ2VkEj0KDGV2ZW50X2N1cnNvchgEIAEoCzIaLnN5bmN0di5jbGll'
    'bnQuRXZlbnRDdXJzb3JSC2V2ZW50Q3Vyc29y');

@$core.Deprecated('Use resourceEventOnlyDescriptor instead')
const ResourceEventOnly$json = {
  '1': 'ResourceEventOnly',
};

/// Descriptor for `ResourceEventOnly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceEventOnlyDescriptor =
    $convert.base64Decode('ChFSZXNvdXJjZUV2ZW50T25seQ==');

@$core.Deprecated('Use resourceEventDescriptor instead')
const ResourceEvent$json = {
  '1': 'ResourceEvent',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '10': 'observeId'},
    {
      '1': 'changed_only',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceEventOnly',
      '9': 0,
      '10': 'changedOnly'
    },
    {
      '1': 'playback_state',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackState',
      '9': 0,
      '10': 'playbackState'
    },
    {
      '1': 'playback',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playback',
      '9': 0,
      '10': 'playback'
    },
    {
      '1': 'room_settings',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.GetRoomSettingsResponse',
      '9': 0,
      '10': 'roomSettings'
    },
    {
      '1': 'playlist_items',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ListPlaylistItemsResponse',
      '9': 0,
      '10': 'playlistItems'
    },
    {
      '1': 'room_member_event',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomMemberEvent',
      '9': 0,
      '10': 'roomMemberEvent'
    },
    {
      '1': 'chat_event',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageEvent',
      '9': 0,
      '10': 'chatEvent'
    },
    {
      '1': 'online_count',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.OnlineCount',
      '9': 0,
      '10': 'onlineCount'
    },
    {
      '1': 'online_event',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.OnlineEvent',
      '9': 0,
      '10': 'onlineEvent'
    },
    {
      '1': 'webrtc_event',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRtcEvent',
      '9': 0,
      '10': 'webrtcEvent'
    },
    {
      '1': 'self_room_member',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '9': 0,
      '10': 'selfRoomMember'
    },
    {
      '1': 'event_cursor',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.EventCursor',
      '10': 'eventCursor'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ResourceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceEventDescriptor = $convert.base64Decode(
    'Cg1SZXNvdXJjZUV2ZW50Eh0KCm9ic2VydmVfaWQYASABKAlSCW9ic2VydmVJZBJFCgxjaGFuZ2'
    'VkX29ubHkYAyABKAsyIC5zeW5jdHYuY2xpZW50LlJlc291cmNlRXZlbnRPbmx5SABSC2NoYW5n'
    'ZWRPbmx5EkUKDnBsYXliYWNrX3N0YXRlGAQgASgLMhwuc3luY3R2LmNsaWVudC5QbGF5YmFja1'
    'N0YXRlSABSDXBsYXliYWNrU3RhdGUSNQoIcGxheWJhY2sYBSABKAsyFy5zeW5jdHYuY2xpZW50'
    'LlBsYXliYWNrSABSCHBsYXliYWNrEk0KDXJvb21fc2V0dGluZ3MYBiABKAsyJi5zeW5jdHYuY2'
    'xpZW50LkdldFJvb21TZXR0aW5nc1Jlc3BvbnNlSABSDHJvb21TZXR0aW5ncxJRCg5wbGF5bGlz'
    'dF9pdGVtcxgHIAEoCzIoLnN5bmN0di5jbGllbnQuTGlzdFBsYXlsaXN0SXRlbXNSZXNwb25zZU'
    'gAUg1wbGF5bGlzdEl0ZW1zEkwKEXJvb21fbWVtYmVyX2V2ZW50GAggASgLMh4uc3luY3R2LmNs'
    'aWVudC5Sb29tTWVtYmVyRXZlbnRIAFIPcm9vbU1lbWJlckV2ZW50EkAKCmNoYXRfZXZlbnQYCS'
    'ABKAsyHy5zeW5jdHYuY2xpZW50LkNoYXRNZXNzYWdlRXZlbnRIAFIJY2hhdEV2ZW50Ej8KDG9u'
    'bGluZV9jb3VudBgKIAEoCzIaLnN5bmN0di5jbGllbnQuT25saW5lQ291bnRIAFILb25saW5lQ2'
    '91bnQSPwoMb25saW5lX2V2ZW50GAwgASgLMhouc3luY3R2LmNsaWVudC5PbmxpbmVFdmVudEgA'
    'UgtvbmxpbmVFdmVudBI/Cgx3ZWJydGNfZXZlbnQYDSABKAsyGi5zeW5jdHYuY2xpZW50LldlYl'
    'J0Y0V2ZW50SABSC3dlYnJ0Y0V2ZW50EkUKEHNlbGZfcm9vbV9tZW1iZXIYDiABKAsyGS5zeW5j'
    'dHYuY29tbW9uLlJvb21NZW1iZXJIAFIOc2VsZlJvb21NZW1iZXISPQoMZXZlbnRfY3Vyc29yGA'
    'sgASgLMhouc3luY3R2LmNsaWVudC5FdmVudEN1cnNvclILZXZlbnRDdXJzb3JCCQoHcGF5bG9h'
    'ZA==');

@$core.Deprecated('Use resourceObserveErrorDescriptor instead')
const ResourceObserveError$json = {
  '1': 'ResourceObserveError',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '10': 'observeId'},
    {
      '1': 'error',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ErrorMessage',
      '10': 'error'
    },
  ],
};

/// Descriptor for `ResourceObserveError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceObserveErrorDescriptor = $convert.base64Decode(
    'ChRSZXNvdXJjZU9ic2VydmVFcnJvchIdCgpvYnNlcnZlX2lkGAEgASgJUglvYnNlcnZlSWQSMQ'
    'oFZXJyb3IYAiABKAsyGy5zeW5jdHYuY2xpZW50LkVycm9yTWVzc2FnZVIFZXJyb3I=');

@$core.Deprecated('Use chatMessageSendDescriptor instead')
const ChatMessageSend$json = {
  '1': 'ChatMessageSend',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
    {'1': 'display_position', '3': 2, '4': 1, '5': 9, '10': 'displayPosition'},
    {'1': 'display_color', '3': 3, '4': 1, '5': 9, '10': 'displayColor'},
    {'1': 'client_message_id', '3': 4, '4': 1, '5': 9, '10': 'clientMessageId'},
    {
      '1': 'images',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatImage',
      '10': 'images'
    },
    {
      '1': 'reply_to_message_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'replyToMessageId'
    },
    {'1': 'metadata', '3': 7, '4': 1, '5': 12, '10': 'metadata'},
    {
      '1': 'mentions',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMentionInput',
      '10': 'mentions'
    },
  ],
};

/// Descriptor for `ChatMessageSend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageSendDescriptor = $convert.base64Decode(
    'Cg9DaGF0TWVzc2FnZVNlbmQSGAoHY29udGVudBgBIAEoCVIHY29udGVudBIpChBkaXNwbGF5X3'
    'Bvc2l0aW9uGAIgASgJUg9kaXNwbGF5UG9zaXRpb24SIwoNZGlzcGxheV9jb2xvchgDIAEoCVIM'
    'ZGlzcGxheUNvbG9yEioKEWNsaWVudF9tZXNzYWdlX2lkGAQgASgJUg9jbGllbnRNZXNzYWdlSW'
    'QSMAoGaW1hZ2VzGAUgAygLMhguc3luY3R2LmNsaWVudC5DaGF0SW1hZ2VSBmltYWdlcxItChNy'
    'ZXBseV90b19tZXNzYWdlX2lkGAYgASgJUhByZXBseVRvTWVzc2FnZUlkEhoKCG1ldGFkYXRhGA'
    'cgASgMUghtZXRhZGF0YRI7CghtZW50aW9ucxgIIAMoCzIfLnN5bmN0di5jbGllbnQuQ2hhdE1l'
    'bnRpb25JbnB1dFIIbWVudGlvbnM=');

@$core.Deprecated('Use chatMentionInputDescriptor instead')
const ChatMentionInput$json = {
  '1': 'ChatMentionInput',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'userId'},
    {'1': 'start', '3': 2, '4': 1, '5': 5, '8': {}, '10': 'start'},
    {'1': 'length', '3': 3, '4': 1, '5': 5, '8': {}, '10': 'length'},
  ],
};

/// Descriptor for `ChatMentionInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMentionInputDescriptor = $convert.base64Decode(
    'ChBDaGF0TWVudGlvbklucHV0EjYKB3VzZXJfaWQYASABKAlCHbpIGnIYEAEYQDISXnVzcl9bQS'
    '1aYS16MC05XSskUgZ1c2VySWQSHQoFc3RhcnQYAiABKAVCB7pIBBoCKABSBXN0YXJ0Eh8KBmxl'
    'bmd0aBgDIAEoBUIHukgEGgIgAFIGbGVuZ3Ro');

@$core.Deprecated('Use chatMentionDescriptor instead')
const ChatMention$json = {
  '1': 'ChatMention',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'start', '3': 3, '4': 1, '5': 5, '10': 'start'},
    {'1': 'length', '3': 4, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `ChatMention`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMentionDescriptor = $convert.base64Decode(
    'CgtDaGF0TWVudGlvbhIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGgoIdXNlcm5hbWUYAiABKA'
    'lSCHVzZXJuYW1lEhQKBXN0YXJ0GAMgASgFUgVzdGFydBIWCgZsZW5ndGgYBCABKAVSBmxlbmd0'
    'aA==');

@$core.Deprecated('Use chatMessageReceiveDescriptor instead')
const ChatMessageReceive$json = {
  '1': 'ChatMessageReceive',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'display_position', '3': 7, '4': 1, '5': 9, '10': 'displayPosition'},
    {'1': 'display_color', '3': 8, '4': 1, '5': 9, '10': 'displayColor'},
    {'1': 'client_message_id', '3': 9, '4': 1, '5': 9, '10': 'clientMessageId'},
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ChatMessageStatus',
      '10': 'status'
    },
    {'1': 'version', '3': 11, '4': 1, '5': 3, '10': 'version'},
    {'1': 'edited_at', '3': 12, '4': 1, '5': 3, '10': 'editedAt'},
    {'1': 'deleted_at', '3': 13, '4': 1, '5': 3, '10': 'deletedAt'},
    {
      '1': 'reply_to_message_id',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'replyToMessageId'
    },
    {
      '1': 'images',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatImage',
      '10': 'images'
    },
    {
      '1': 'deleted_by_user_id',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'deletedByUserId'
    },
    {'1': 'delete_reason', '3': 17, '4': 1, '5': 9, '10': 'deleteReason'},
    {
      '1': 'playback_media_id',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'playbackMediaId'
    },
    {
      '1': 'playback_playlist_id',
      '3': 19,
      '4': 1,
      '5': 9,
      '10': 'playbackPlaylistId'
    },
    {'1': 'playback_target', '3': 20, '4': 1, '5': 12, '10': 'playbackTarget'},
    {
      '1': 'playback_target_hash',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'playbackTargetHash'
    },
    {
      '1': 'playback_position_seconds',
      '3': 22,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'playbackPositionSeconds',
      '17': true
    },
    {
      '1': 'reactions',
      '3': 23,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatReactionSummary',
      '10': 'reactions'
    },
    {'1': 'reaction_count', '3': 24, '4': 1, '5': 5, '10': 'reactionCount'},
    {'1': 'metadata', '3': 25, '4': 1, '5': 12, '10': 'metadata'},
    {
      '1': 'mentions',
      '3': 26,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMention',
      '10': 'mentions'
    },
  ],
  '8': [
    {'1': '_playback_position_seconds'},
  ],
};

/// Descriptor for `ChatMessageReceive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageReceiveDescriptor = $convert.base64Decode(
    'ChJDaGF0TWVzc2FnZVJlY2VpdmUSDgoCaWQYASABKAlSAmlkEhcKB3Jvb21faWQYAiABKAlSBn'
    'Jvb21JZBIXCgd1c2VyX2lkGAMgASgJUgZ1c2VySWQSGgoIdXNlcm5hbWUYBCABKAlSCHVzZXJu'
    'YW1lEhgKB2NvbnRlbnQYBSABKAlSB2NvbnRlbnQSHAoJdGltZXN0YW1wGAYgASgDUgl0aW1lc3'
    'RhbXASKQoQZGlzcGxheV9wb3NpdGlvbhgHIAEoCVIPZGlzcGxheVBvc2l0aW9uEiMKDWRpc3Bs'
    'YXlfY29sb3IYCCABKAlSDGRpc3BsYXlDb2xvchIqChFjbGllbnRfbWVzc2FnZV9pZBgJIAEoCV'
    'IPY2xpZW50TWVzc2FnZUlkEjgKBnN0YXR1cxgKIAEoDjIgLnN5bmN0di5jbGllbnQuQ2hhdE1l'
    'c3NhZ2VTdGF0dXNSBnN0YXR1cxIYCgd2ZXJzaW9uGAsgASgDUgd2ZXJzaW9uEhsKCWVkaXRlZF'
    '9hdBgMIAEoA1IIZWRpdGVkQXQSHQoKZGVsZXRlZF9hdBgNIAEoA1IJZGVsZXRlZEF0Ei0KE3Jl'
    'cGx5X3RvX21lc3NhZ2VfaWQYDiABKAlSEHJlcGx5VG9NZXNzYWdlSWQSMAoGaW1hZ2VzGA8gAy'
    'gLMhguc3luY3R2LmNsaWVudC5DaGF0SW1hZ2VSBmltYWdlcxIrChJkZWxldGVkX2J5X3VzZXJf'
    'aWQYECABKAlSD2RlbGV0ZWRCeVVzZXJJZBIjCg1kZWxldGVfcmVhc29uGBEgASgJUgxkZWxldG'
    'VSZWFzb24SKgoRcGxheWJhY2tfbWVkaWFfaWQYEiABKAlSD3BsYXliYWNrTWVkaWFJZBIwChRw'
    'bGF5YmFja19wbGF5bGlzdF9pZBgTIAEoCVIScGxheWJhY2tQbGF5bGlzdElkEicKD3BsYXliYW'
    'NrX3RhcmdldBgUIAEoDFIOcGxheWJhY2tUYXJnZXQSMAoUcGxheWJhY2tfdGFyZ2V0X2hhc2gY'
    'FSABKAlSEnBsYXliYWNrVGFyZ2V0SGFzaBI/ChlwbGF5YmFja19wb3NpdGlvbl9zZWNvbmRzGB'
    'YgASgBSABSF3BsYXliYWNrUG9zaXRpb25TZWNvbmRziAEBEkAKCXJlYWN0aW9ucxgXIAMoCzIi'
    'LnN5bmN0di5jbGllbnQuQ2hhdFJlYWN0aW9uU3VtbWFyeVIJcmVhY3Rpb25zEiUKDnJlYWN0aW'
    '9uX2NvdW50GBggASgFUg1yZWFjdGlvbkNvdW50EhoKCG1ldGFkYXRhGBkgASgMUghtZXRhZGF0'
    'YRI2CghtZW50aW9ucxgaIAMoCzIaLnN5bmN0di5jbGllbnQuQ2hhdE1lbnRpb25SCG1lbnRpb2'
    '5zQhwKGl9wbGF5YmFja19wb3NpdGlvbl9zZWNvbmRz');

@$core.Deprecated('Use chatReactionSummaryDescriptor instead')
const ChatReactionSummary$json = {
  '1': 'ChatReactionSummary',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'count', '3': 2, '4': 1, '5': 3, '10': 'count'},
    {'1': 'reacted_by_me', '3': 3, '4': 1, '5': 8, '10': 'reactedByMe'},
  ],
};

/// Descriptor for `ChatReactionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatReactionSummaryDescriptor = $convert.base64Decode(
    'ChNDaGF0UmVhY3Rpb25TdW1tYXJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBWNvdW50GAIgASgDUg'
    'Vjb3VudBIiCg1yZWFjdGVkX2J5X21lGAMgASgIUgtyZWFjdGVkQnlNZQ==');

@$core.Deprecated('Use chatReactionUserDescriptor instead')
const ChatReactionUser$json = {
  '1': 'ChatReactionUser',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'reacted_at', '3': 3, '4': 1, '5': 3, '10': 'reactedAt'},
  ],
};

/// Descriptor for `ChatReactionUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatReactionUserDescriptor = $convert.base64Decode(
    'ChBDaGF0UmVhY3Rpb25Vc2VyEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIaCgh1c2VybmFtZR'
    'gCIAEoCVIIdXNlcm5hbWUSHQoKcmVhY3RlZF9hdBgDIAEoA1IJcmVhY3RlZEF0');

@$core.Deprecated('Use chatImageDescriptor instead')
const ChatImage$json = {
  '1': 'ChatImage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'storage_backend', '3': 2, '4': 1, '5': 9, '10': 'storageBackend'},
    {'1': 'object_key', '3': 3, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'mime_type', '3': 5, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 6, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 7, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 8, '4': 1, '5': 5, '10': 'height'},
    {'1': 'metadata', '3': 9, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `ChatImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatImageDescriptor = $convert.base64Decode(
    'CglDaGF0SW1hZ2USDgoCaWQYASABKAlSAmlkEicKD3N0b3JhZ2VfYmFja2VuZBgCIAEoCVIOc3'
    'RvcmFnZUJhY2tlbmQSHQoKb2JqZWN0X2tleRgDIAEoCVIJb2JqZWN0S2V5EhAKA3VybBgEIAEo'
    'CVIDdXJsEhsKCW1pbWVfdHlwZRgFIAEoCVIIbWltZVR5cGUSHQoKc2l6ZV9ieXRlcxgGIAEoA1'
    'IJc2l6ZUJ5dGVzEhQKBXdpZHRoGAcgASgFUgV3aWR0aBIWCgZoZWlnaHQYCCABKAVSBmhlaWdo'
    'dBIaCghtZXRhZGF0YRgJIAEoDFIIbWV0YWRhdGE=');

@$core.Deprecated('Use createChatImageUploadSessionRequestDescriptor instead')
const CreateChatImageUploadSessionRequest$json = {
  '1': 'CreateChatImageUploadSessionRequest',
  '2': [
    {'1': 'client_image_id', '3': 1, '4': 1, '5': 9, '10': 'clientImageId'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 3, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 4, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 5, '4': 1, '5': 5, '10': 'height'},
    {'1': 'checksum_sha256', '3': 6, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'metadata', '3': 7, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `CreateChatImageUploadSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChatImageUploadSessionRequestDescriptor =
    $convert.base64Decode(
        'CiNDcmVhdGVDaGF0SW1hZ2VVcGxvYWRTZXNzaW9uUmVxdWVzdBImCg9jbGllbnRfaW1hZ2VfaW'
        'QYASABKAlSDWNsaWVudEltYWdlSWQSGwoJbWltZV90eXBlGAIgASgJUghtaW1lVHlwZRIdCgpz'
        'aXplX2J5dGVzGAMgASgDUglzaXplQnl0ZXMSFAoFd2lkdGgYBCABKAVSBXdpZHRoEhYKBmhlaW'
        'dodBgFIAEoBVIGaGVpZ2h0EicKD2NoZWNrc3VtX3NoYTI1NhgGIAEoCVIOY2hlY2tzdW1TaGEy'
        'NTYSGgoIbWV0YWRhdGEYByABKAxSCG1ldGFkYXRh');

@$core.Deprecated('Use chatImageUploadSessionDescriptor instead')
const ChatImageUploadSession$json = {
  '1': 'ChatImageUploadSession',
  '2': [
    {
      '1': 'image',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatImage',
      '10': 'image'
    },
    {'1': 'upload_required', '3': 2, '4': 1, '5': 8, '10': 'uploadRequired'},
    {
      '1': 'upload_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'uploadUrl',
      '17': true
    },
    {
      '1': 'upload_method',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'uploadMethod',
      '17': true
    },
    {
      '1': 'upload_headers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatImageUploadSession.UploadHeadersEntry',
      '10': 'uploadHeaders'
    },
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'expiresAt',
      '17': true
    },
    {'1': 'max_size_bytes', '3': 7, '4': 1, '5': 3, '10': 'maxSizeBytes'},
    {
      '1': 'ownership_proof_required',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'ownershipProofRequired'
    },
    {
      '1': 'ownership_proof_nonce',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'ownershipProofNonce',
      '17': true
    },
    {
      '1': 'ownership_proof_ranges',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatImageOwnershipProofRange',
      '10': 'ownershipProofRanges'
    },
    {
      '1': 'ownership_proof_metadata_key',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'ownershipProofMetadataKey',
      '17': true
    },
  ],
  '3': [ChatImageUploadSession_UploadHeadersEntry$json],
  '8': [
    {'1': '_upload_url'},
    {'1': '_upload_method'},
    {'1': '_expires_at'},
    {'1': '_ownership_proof_nonce'},
    {'1': '_ownership_proof_metadata_key'},
  ],
};

@$core.Deprecated('Use chatImageUploadSessionDescriptor instead')
const ChatImageUploadSession_UploadHeadersEntry$json = {
  '1': 'UploadHeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ChatImageUploadSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatImageUploadSessionDescriptor = $convert.base64Decode(
    'ChZDaGF0SW1hZ2VVcGxvYWRTZXNzaW9uEi4KBWltYWdlGAEgASgLMhguc3luY3R2LmNsaWVudC'
    '5DaGF0SW1hZ2VSBWltYWdlEicKD3VwbG9hZF9yZXF1aXJlZBgCIAEoCFIOdXBsb2FkUmVxdWly'
    'ZWQSIgoKdXBsb2FkX3VybBgDIAEoCUgAUgl1cGxvYWRVcmyIAQESKAoNdXBsb2FkX21ldGhvZB'
    'gEIAEoCUgBUgx1cGxvYWRNZXRob2SIAQESXwoOdXBsb2FkX2hlYWRlcnMYBSADKAsyOC5zeW5j'
    'dHYuY2xpZW50LkNoYXRJbWFnZVVwbG9hZFNlc3Npb24uVXBsb2FkSGVhZGVyc0VudHJ5Ug11cG'
    'xvYWRIZWFkZXJzEiIKCmV4cGlyZXNfYXQYBiABKANIAlIJZXhwaXJlc0F0iAEBEiQKDm1heF9z'
    'aXplX2J5dGVzGAcgASgDUgxtYXhTaXplQnl0ZXMSOAoYb3duZXJzaGlwX3Byb29mX3JlcXVpcm'
    'VkGAggASgIUhZvd25lcnNoaXBQcm9vZlJlcXVpcmVkEjcKFW93bmVyc2hpcF9wcm9vZl9ub25j'
    'ZRgJIAEoCUgDUhNvd25lcnNoaXBQcm9vZk5vbmNliAEBEmEKFm93bmVyc2hpcF9wcm9vZl9yYW'
    '5nZXMYCiADKAsyKy5zeW5jdHYuY2xpZW50LkNoYXRJbWFnZU93bmVyc2hpcFByb29mUmFuZ2VS'
    'FG93bmVyc2hpcFByb29mUmFuZ2VzEkQKHG93bmVyc2hpcF9wcm9vZl9tZXRhZGF0YV9rZXkYCy'
    'ABKAlIBFIZb3duZXJzaGlwUHJvb2ZNZXRhZGF0YUtleYgBARpAChJVcGxvYWRIZWFkZXJzRW50'
    'cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AUINCgtfdXBsb2'
    'FkX3VybEIQCg5fdXBsb2FkX21ldGhvZEINCgtfZXhwaXJlc19hdEIYChZfb3duZXJzaGlwX3By'
    'b29mX25vbmNlQh8KHV9vd25lcnNoaXBfcHJvb2ZfbWV0YWRhdGFfa2V5');

@$core.Deprecated('Use chatImageOwnershipProofRangeDescriptor instead')
const ChatImageOwnershipProofRange$json = {
  '1': 'ChatImageOwnershipProofRange',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `ChatImageOwnershipProofRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatImageOwnershipProofRangeDescriptor =
    $convert.base64Decode(
        'ChxDaGF0SW1hZ2VPd25lcnNoaXBQcm9vZlJhbmdlEhYKBm9mZnNldBgBIAEoA1IGb2Zmc2V0Eh'
        'YKBmxlbmd0aBgCIAEoBVIGbGVuZ3Ro');

@$core.Deprecated('Use createChatImageUploadSessionResponseDescriptor instead')
const CreateChatImageUploadSessionResponse$json = {
  '1': 'CreateChatImageUploadSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatImageUploadSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CreateChatImageUploadSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createChatImageUploadSessionResponseDescriptor =
    $convert.base64Decode(
        'CiRDcmVhdGVDaGF0SW1hZ2VVcGxvYWRTZXNzaW9uUmVzcG9uc2USPwoHc2Vzc2lvbhgBIAEoCz'
        'IlLnN5bmN0di5jbGllbnQuQ2hhdEltYWdlVXBsb2FkU2Vzc2lvblIHc2Vzc2lvbg==');

@$core.Deprecated('Use uploadChatImageObjectRequestDescriptor instead')
const UploadChatImageObjectRequest$json = {
  '1': 'UploadChatImageObjectRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'encoded_object_key',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'content_type',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'contentType',
      '17': true
    },
    {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
  ],
  '8': [
    {'1': '_content_type'},
  ],
};

/// Descriptor for `UploadChatImageObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChatImageObjectRequestDescriptor = $convert.base64Decode(
    'ChxVcGxvYWRDaGF0SW1hZ2VPYmplY3RSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZB'
    'IsChJlbmNvZGVkX29iamVjdF9rZXkYAiABKAlSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4Y'
    'AyABKAlSBXRva2VuEiYKDGNvbnRlbnRfdHlwZRgEIAEoCUgAUgtjb250ZW50VHlwZYgBARISCg'
    'RkYXRhGAUgASgMUgRkYXRhQg8KDV9jb250ZW50X3R5cGU=');

@$core.Deprecated('Use getChatImageObjectRequestDescriptor instead')
const GetChatImageObjectRequest$json = {
  '1': 'GetChatImageObjectRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'encoded_object_key',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 3, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `GetChatImageObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatImageObjectRequestDescriptor = $convert.base64Decode(
    'ChlHZXRDaGF0SW1hZ2VPYmplY3RSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIsCh'
    'JlbmNvZGVkX29iamVjdF9rZXkYAiABKAlSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAyAB'
    'KAlSBXRva2Vu');

@$core.Deprecated('Use chatImageObjectResponseDescriptor instead')
const ChatImageObjectResponse$json = {
  '1': 'ChatImageObjectResponse',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'object_key', '3': 2, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'mime_type', '3': 3, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'checksum_sha256', '3': 4, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'data', '3': 5, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `ChatImageObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatImageObjectResponseDescriptor = $convert.base64Decode(
    'ChdDaGF0SW1hZ2VPYmplY3RSZXNwb25zZRIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSHQoKb2'
    'JqZWN0X2tleRgCIAEoCVIJb2JqZWN0S2V5EhsKCW1pbWVfdHlwZRgDIAEoCVIIbWltZVR5cGUS'
    'JwoPY2hlY2tzdW1fc2hhMjU2GAQgASgJUg5jaGVja3N1bVNoYTI1NhISCgRkYXRhGAUgASgMUg'
    'RkYXRh');

@$core.Deprecated('Use uploadChatImageObjectResponseDescriptor instead')
const UploadChatImageObjectResponse$json = {
  '1': 'UploadChatImageObjectResponse',
  '2': [
    {
      '1': 'object',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatImageObjectResponse',
      '10': 'object'
    },
  ],
};

/// Descriptor for `UploadChatImageObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChatImageObjectResponseDescriptor =
    $convert.base64Decode(
        'Ch1VcGxvYWRDaGF0SW1hZ2VPYmplY3RSZXNwb25zZRI+CgZvYmplY3QYASABKAsyJi5zeW5jdH'
        'YuY2xpZW50LkNoYXRJbWFnZU9iamVjdFJlc3BvbnNlUgZvYmplY3Q=');

@$core.Deprecated('Use userAvatarDescriptor instead')
const UserAvatar$json = {
  '1': 'UserAvatar',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'storage_backend', '3': 2, '4': 1, '5': 9, '10': 'storageBackend'},
    {'1': 'object_key', '3': 3, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'mime_type', '3': 5, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 6, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 7, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 8, '4': 1, '5': 5, '10': 'height'},
    {'1': 'metadata', '3': 9, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `UserAvatar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAvatarDescriptor = $convert.base64Decode(
    'CgpVc2VyQXZhdGFyEg4KAmlkGAEgASgJUgJpZBInCg9zdG9yYWdlX2JhY2tlbmQYAiABKAlSDn'
    'N0b3JhZ2VCYWNrZW5kEh0KCm9iamVjdF9rZXkYAyABKAlSCW9iamVjdEtleRIQCgN1cmwYBCAB'
    'KAlSA3VybBIbCgltaW1lX3R5cGUYBSABKAlSCG1pbWVUeXBlEh0KCnNpemVfYnl0ZXMYBiABKA'
    'NSCXNpemVCeXRlcxIUCgV3aWR0aBgHIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAggASgFUgZoZWln'
    'aHQSGgoIbWV0YWRhdGEYCSABKAxSCG1ldGFkYXRh');

@$core.Deprecated('Use createUserAvatarUploadSessionRequestDescriptor instead')
const CreateUserAvatarUploadSessionRequest$json = {
  '1': 'CreateUserAvatarUploadSessionRequest',
  '2': [
    {'1': 'client_avatar_id', '3': 1, '4': 1, '5': 9, '10': 'clientAvatarId'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 3, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 4, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 5, '4': 1, '5': 5, '10': 'height'},
    {'1': 'checksum_sha256', '3': 6, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'metadata', '3': 7, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `CreateUserAvatarUploadSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserAvatarUploadSessionRequestDescriptor =
    $convert.base64Decode(
        'CiRDcmVhdGVVc2VyQXZhdGFyVXBsb2FkU2Vzc2lvblJlcXVlc3QSKAoQY2xpZW50X2F2YXRhcl'
        '9pZBgBIAEoCVIOY2xpZW50QXZhdGFySWQSGwoJbWltZV90eXBlGAIgASgJUghtaW1lVHlwZRId'
        'CgpzaXplX2J5dGVzGAMgASgDUglzaXplQnl0ZXMSFAoFd2lkdGgYBCABKAVSBXdpZHRoEhYKBm'
        'hlaWdodBgFIAEoBVIGaGVpZ2h0EicKD2NoZWNrc3VtX3NoYTI1NhgGIAEoCVIOY2hlY2tzdW1T'
        'aGEyNTYSGgoIbWV0YWRhdGEYByABKAxSCG1ldGFkYXRh');

@$core.Deprecated('Use userAvatarUploadSessionDescriptor instead')
const UserAvatarUploadSession$json = {
  '1': 'UserAvatarUploadSession',
  '2': [
    {
      '1': 'avatar',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAvatar',
      '10': 'avatar'
    },
    {'1': 'upload_required', '3': 2, '4': 1, '5': 8, '10': 'uploadRequired'},
    {
      '1': 'upload_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'uploadUrl',
      '17': true
    },
    {
      '1': 'upload_method',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'uploadMethod',
      '17': true
    },
    {
      '1': 'upload_headers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.UserAvatarUploadSession.UploadHeadersEntry',
      '10': 'uploadHeaders'
    },
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'expiresAt',
      '17': true
    },
    {'1': 'max_size_bytes', '3': 7, '4': 1, '5': 3, '10': 'maxSizeBytes'},
    {
      '1': 'ownership_proof_required',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'ownershipProofRequired'
    },
    {
      '1': 'ownership_proof_nonce',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'ownershipProofNonce',
      '17': true
    },
    {
      '1': 'ownership_proof_ranges',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.UserAvatarOwnershipProofRange',
      '10': 'ownershipProofRanges'
    },
    {
      '1': 'ownership_proof_metadata_key',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'ownershipProofMetadataKey',
      '17': true
    },
  ],
  '3': [UserAvatarUploadSession_UploadHeadersEntry$json],
  '8': [
    {'1': '_upload_url'},
    {'1': '_upload_method'},
    {'1': '_expires_at'},
    {'1': '_ownership_proof_nonce'},
    {'1': '_ownership_proof_metadata_key'},
  ],
};

@$core.Deprecated('Use userAvatarUploadSessionDescriptor instead')
const UserAvatarUploadSession_UploadHeadersEntry$json = {
  '1': 'UploadHeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UserAvatarUploadSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAvatarUploadSessionDescriptor = $convert.base64Decode(
    'ChdVc2VyQXZhdGFyVXBsb2FkU2Vzc2lvbhIxCgZhdmF0YXIYASABKAsyGS5zeW5jdHYuY2xpZW'
    '50LlVzZXJBdmF0YXJSBmF2YXRhchInCg91cGxvYWRfcmVxdWlyZWQYAiABKAhSDnVwbG9hZFJl'
    'cXVpcmVkEiIKCnVwbG9hZF91cmwYAyABKAlIAFIJdXBsb2FkVXJsiAEBEigKDXVwbG9hZF9tZX'
    'Rob2QYBCABKAlIAVIMdXBsb2FkTWV0aG9kiAEBEmAKDnVwbG9hZF9oZWFkZXJzGAUgAygLMjku'
    'c3luY3R2LmNsaWVudC5Vc2VyQXZhdGFyVXBsb2FkU2Vzc2lvbi5VcGxvYWRIZWFkZXJzRW50cn'
    'lSDXVwbG9hZEhlYWRlcnMSIgoKZXhwaXJlc19hdBgGIAEoA0gCUglleHBpcmVzQXSIAQESJAoO'
    'bWF4X3NpemVfYnl0ZXMYByABKANSDG1heFNpemVCeXRlcxI4Chhvd25lcnNoaXBfcHJvb2Zfcm'
    'VxdWlyZWQYCCABKAhSFm93bmVyc2hpcFByb29mUmVxdWlyZWQSNwoVb3duZXJzaGlwX3Byb29m'
    'X25vbmNlGAkgASgJSANSE293bmVyc2hpcFByb29mTm9uY2WIAQESYgoWb3duZXJzaGlwX3Byb2'
    '9mX3JhbmdlcxgKIAMoCzIsLnN5bmN0di5jbGllbnQuVXNlckF2YXRhck93bmVyc2hpcFByb29m'
    'UmFuZ2VSFG93bmVyc2hpcFByb29mUmFuZ2VzEkQKHG93bmVyc2hpcF9wcm9vZl9tZXRhZGF0YV'
    '9rZXkYCyABKAlIBFIZb3duZXJzaGlwUHJvb2ZNZXRhZGF0YUtleYgBARpAChJVcGxvYWRIZWFk'
    'ZXJzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AUINCg'
    'tfdXBsb2FkX3VybEIQCg5fdXBsb2FkX21ldGhvZEINCgtfZXhwaXJlc19hdEIYChZfb3duZXJz'
    'aGlwX3Byb29mX25vbmNlQh8KHV9vd25lcnNoaXBfcHJvb2ZfbWV0YWRhdGFfa2V5');

@$core.Deprecated('Use userAvatarOwnershipProofRangeDescriptor instead')
const UserAvatarOwnershipProofRange$json = {
  '1': 'UserAvatarOwnershipProofRange',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `UserAvatarOwnershipProofRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAvatarOwnershipProofRangeDescriptor =
    $convert.base64Decode(
        'Ch1Vc2VyQXZhdGFyT3duZXJzaGlwUHJvb2ZSYW5nZRIWCgZvZmZzZXQYASABKANSBm9mZnNldB'
        'IWCgZsZW5ndGgYAiABKAVSBmxlbmd0aA==');

@$core.Deprecated('Use createUserAvatarUploadSessionResponseDescriptor instead')
const CreateUserAvatarUploadSessionResponse$json = {
  '1': 'CreateUserAvatarUploadSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAvatarUploadSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CreateUserAvatarUploadSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserAvatarUploadSessionResponseDescriptor =
    $convert.base64Decode(
        'CiVDcmVhdGVVc2VyQXZhdGFyVXBsb2FkU2Vzc2lvblJlc3BvbnNlEkAKB3Nlc3Npb24YASABKA'
        'syJi5zeW5jdHYuY2xpZW50LlVzZXJBdmF0YXJVcGxvYWRTZXNzaW9uUgdzZXNzaW9u');

@$core.Deprecated('Use uploadUserAvatarObjectRequestDescriptor instead')
const UploadUserAvatarObjectRequest$json = {
  '1': 'UploadUserAvatarObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'content_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'contentType',
      '17': true
    },
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
  '8': [
    {'1': '_content_type'},
  ],
};

/// Descriptor for `UploadUserAvatarObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadUserAvatarObjectRequestDescriptor = $convert.base64Decode(
    'Ch1VcGxvYWRVc2VyQXZhdGFyT2JqZWN0UmVxdWVzdBIsChJlbmNvZGVkX29iamVjdF9rZXkYAS'
    'ABKAlSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAiABKAlSBXRva2VuEiYKDGNvbnRlbnRf'
    'dHlwZRgDIAEoCUgAUgtjb250ZW50VHlwZYgBARISCgRkYXRhGAQgASgMUgRkYXRhQg8KDV9jb2'
    '50ZW50X3R5cGU=');

@$core.Deprecated('Use getUserAvatarObjectRequestDescriptor instead')
const GetUserAvatarObjectRequest$json = {
  '1': 'GetUserAvatarObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `GetUserAvatarObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserAvatarObjectRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRVc2VyQXZhdGFyT2JqZWN0UmVxdWVzdBIsChJlbmNvZGVkX29iamVjdF9rZXkYASABKA'
        'lSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use userAvatarObjectResponseDescriptor instead')
const UserAvatarObjectResponse$json = {
  '1': 'UserAvatarObjectResponse',
  '2': [
    {'1': 'object_key', '3': 1, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'checksum_sha256', '3': 3, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `UserAvatarObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userAvatarObjectResponseDescriptor = $convert.base64Decode(
    'ChhVc2VyQXZhdGFyT2JqZWN0UmVzcG9uc2USHQoKb2JqZWN0X2tleRgBIAEoCVIJb2JqZWN0S2'
    'V5EhsKCW1pbWVfdHlwZRgCIAEoCVIIbWltZVR5cGUSJwoPY2hlY2tzdW1fc2hhMjU2GAMgASgJ'
    'Ug5jaGVja3N1bVNoYTI1NhISCgRkYXRhGAQgASgMUgRkYXRh');

@$core.Deprecated('Use uploadUserAvatarObjectResponseDescriptor instead')
const UploadUserAvatarObjectResponse$json = {
  '1': 'UploadUserAvatarObjectResponse',
  '2': [
    {
      '1': 'object',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAvatarObjectResponse',
      '10': 'object'
    },
  ],
};

/// Descriptor for `UploadUserAvatarObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadUserAvatarObjectResponseDescriptor =
    $convert.base64Decode(
        'Ch5VcGxvYWRVc2VyQXZhdGFyT2JqZWN0UmVzcG9uc2USPwoGb2JqZWN0GAEgASgLMicuc3luY3'
        'R2LmNsaWVudC5Vc2VyQXZhdGFyT2JqZWN0UmVzcG9uc2VSBm9iamVjdA==');

@$core.Deprecated('Use updateUserAvatarRequestDescriptor instead')
const UpdateUserAvatarRequest$json = {
  '1': 'UpdateUserAvatarRequest',
  '2': [
    {
      '1': 'avatar',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserAvatar',
      '10': 'avatar'
    },
  ],
};

/// Descriptor for `UpdateUserAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserAvatarRequestDescriptor =
    $convert.base64Decode(
        'ChdVcGRhdGVVc2VyQXZhdGFyUmVxdWVzdBIxCgZhdmF0YXIYASABKAsyGS5zeW5jdHYuY2xpZW'
        '50LlVzZXJBdmF0YXJSBmF2YXRhcg==');

@$core.Deprecated('Use clearUserAvatarRequestDescriptor instead')
const ClearUserAvatarRequest$json = {
  '1': 'ClearUserAvatarRequest',
};

/// Descriptor for `ClearUserAvatarRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearUserAvatarRequestDescriptor =
    $convert.base64Decode('ChZDbGVhclVzZXJBdmF0YXJSZXF1ZXN0');

@$core.Deprecated('Use fileCoverDescriptor instead')
const FileCover$json = {
  '1': 'FileCover',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'storage_backend', '3': 2, '4': 1, '5': 9, '10': 'storageBackend'},
    {'1': 'object_key', '3': 3, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'mime_type', '3': 5, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 6, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 7, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 8, '4': 1, '5': 5, '10': 'height'},
    {'1': 'metadata', '3': 9, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `FileCover`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileCoverDescriptor = $convert.base64Decode(
    'CglGaWxlQ292ZXISDgoCaWQYASABKAlSAmlkEicKD3N0b3JhZ2VfYmFja2VuZBgCIAEoCVIOc3'
    'RvcmFnZUJhY2tlbmQSHQoKb2JqZWN0X2tleRgDIAEoCVIJb2JqZWN0S2V5EhAKA3VybBgEIAEo'
    'CVIDdXJsEhsKCW1pbWVfdHlwZRgFIAEoCVIIbWltZVR5cGUSHQoKc2l6ZV9ieXRlcxgGIAEoA1'
    'IJc2l6ZUJ5dGVzEhQKBXdpZHRoGAcgASgFUgV3aWR0aBIWCgZoZWlnaHQYCCABKAVSBmhlaWdo'
    'dBIaCghtZXRhZGF0YRgJIAEoDFIIbWV0YWRhdGE=');

@$core.Deprecated('Use videoCoverDescriptor instead')
const VideoCover$json = {
  '1': 'VideoCover',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'storage_backend', '3': 2, '4': 1, '5': 9, '10': 'storageBackend'},
    {'1': 'object_key', '3': 3, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'mime_type', '3': 5, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 6, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 7, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 8, '4': 1, '5': 5, '10': 'height'},
    {'1': 'metadata', '3': 9, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `VideoCover`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCoverDescriptor = $convert.base64Decode(
    'CgpWaWRlb0NvdmVyEg4KAmlkGAEgASgJUgJpZBInCg9zdG9yYWdlX2JhY2tlbmQYAiABKAlSDn'
    'N0b3JhZ2VCYWNrZW5kEh0KCm9iamVjdF9rZXkYAyABKAlSCW9iamVjdEtleRIQCgN1cmwYBCAB'
    'KAlSA3VybBIbCgltaW1lX3R5cGUYBSABKAlSCG1pbWVUeXBlEh0KCnNpemVfYnl0ZXMYBiABKA'
    'NSCXNpemVCeXRlcxIUCgV3aWR0aBgHIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GAggASgFUgZoZWln'
    'aHQSGgoIbWV0YWRhdGEYCSABKAxSCG1ldGFkYXRh');

@$core.Deprecated('Use createVideoCoverUploadSessionRequestDescriptor instead')
const CreateVideoCoverUploadSessionRequest$json = {
  '1': 'CreateVideoCoverUploadSessionRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
    {'1': 'client_cover_id', '3': 3, '4': 1, '5': 9, '10': 'clientCoverId'},
    {'1': 'mime_type', '3': 4, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 5, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 6, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 7, '4': 1, '5': 5, '10': 'height'},
    {'1': 'checksum_sha256', '3': 8, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'metadata', '3': 9, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `CreateVideoCoverUploadSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createVideoCoverUploadSessionRequestDescriptor = $convert.base64Decode(
    'CiRDcmVhdGVWaWRlb0NvdmVyVXBsb2FkU2Vzc2lvblJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCV'
    'IGcm9vbUlkEiIKCG1lZGlhX2lkGAIgASgJQge6SARyAhABUgdtZWRpYUlkEiYKD2NsaWVudF9j'
    'b3Zlcl9pZBgDIAEoCVINY2xpZW50Q292ZXJJZBIbCgltaW1lX3R5cGUYBCABKAlSCG1pbWVUeX'
    'BlEh0KCnNpemVfYnl0ZXMYBSABKANSCXNpemVCeXRlcxIUCgV3aWR0aBgGIAEoBVIFd2lkdGgS'
    'FgoGaGVpZ2h0GAcgASgFUgZoZWlnaHQSJwoPY2hlY2tzdW1fc2hhMjU2GAggASgJUg5jaGVja3'
    'N1bVNoYTI1NhIaCghtZXRhZGF0YRgJIAEoDFIIbWV0YWRhdGE=');

@$core.Deprecated('Use videoCoverUploadSessionDescriptor instead')
const VideoCoverUploadSession$json = {
  '1': 'VideoCoverUploadSession',
  '2': [
    {
      '1': 'cover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.VideoCover',
      '10': 'cover'
    },
    {'1': 'upload_required', '3': 2, '4': 1, '5': 8, '10': 'uploadRequired'},
    {
      '1': 'upload_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'uploadUrl',
      '17': true
    },
    {
      '1': 'upload_method',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'uploadMethod',
      '17': true
    },
    {
      '1': 'upload_headers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.VideoCoverUploadSession.UploadHeadersEntry',
      '10': 'uploadHeaders'
    },
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'expiresAt',
      '17': true
    },
    {'1': 'max_size_bytes', '3': 7, '4': 1, '5': 3, '10': 'maxSizeBytes'},
    {
      '1': 'ownership_proof_required',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'ownershipProofRequired'
    },
    {
      '1': 'ownership_proof_nonce',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'ownershipProofNonce',
      '17': true
    },
    {
      '1': 'ownership_proof_ranges',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.VideoCoverOwnershipProofRange',
      '10': 'ownershipProofRanges'
    },
    {
      '1': 'ownership_proof_metadata_key',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'ownershipProofMetadataKey',
      '17': true
    },
  ],
  '3': [VideoCoverUploadSession_UploadHeadersEntry$json],
  '8': [
    {'1': '_upload_url'},
    {'1': '_upload_method'},
    {'1': '_expires_at'},
    {'1': '_ownership_proof_nonce'},
    {'1': '_ownership_proof_metadata_key'},
  ],
};

@$core.Deprecated('Use videoCoverUploadSessionDescriptor instead')
const VideoCoverUploadSession_UploadHeadersEntry$json = {
  '1': 'UploadHeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `VideoCoverUploadSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCoverUploadSessionDescriptor = $convert.base64Decode(
    'ChdWaWRlb0NvdmVyVXBsb2FkU2Vzc2lvbhIvCgVjb3ZlchgBIAEoCzIZLnN5bmN0di5jbGllbn'
    'QuVmlkZW9Db3ZlclIFY292ZXISJwoPdXBsb2FkX3JlcXVpcmVkGAIgASgIUg51cGxvYWRSZXF1'
    'aXJlZBIiCgp1cGxvYWRfdXJsGAMgASgJSABSCXVwbG9hZFVybIgBARIoCg11cGxvYWRfbWV0aG'
    '9kGAQgASgJSAFSDHVwbG9hZE1ldGhvZIgBARJgCg51cGxvYWRfaGVhZGVycxgFIAMoCzI5LnN5'
    'bmN0di5jbGllbnQuVmlkZW9Db3ZlclVwbG9hZFNlc3Npb24uVXBsb2FkSGVhZGVyc0VudHJ5Ug'
    '11cGxvYWRIZWFkZXJzEiIKCmV4cGlyZXNfYXQYBiABKANIAlIJZXhwaXJlc0F0iAEBEiQKDm1h'
    'eF9zaXplX2J5dGVzGAcgASgDUgxtYXhTaXplQnl0ZXMSOAoYb3duZXJzaGlwX3Byb29mX3JlcX'
    'VpcmVkGAggASgIUhZvd25lcnNoaXBQcm9vZlJlcXVpcmVkEjcKFW93bmVyc2hpcF9wcm9vZl9u'
    'b25jZRgJIAEoCUgDUhNvd25lcnNoaXBQcm9vZk5vbmNliAEBEmIKFm93bmVyc2hpcF9wcm9vZl'
    '9yYW5nZXMYCiADKAsyLC5zeW5jdHYuY2xpZW50LlZpZGVvQ292ZXJPd25lcnNoaXBQcm9vZlJh'
    'bmdlUhRvd25lcnNoaXBQcm9vZlJhbmdlcxJEChxvd25lcnNoaXBfcHJvb2ZfbWV0YWRhdGFfa2'
    'V5GAsgASgJSARSGW93bmVyc2hpcFByb29mTWV0YWRhdGFLZXmIAQEaQAoSVXBsb2FkSGVhZGVy'
    'c0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFCDQoLX3'
    'VwbG9hZF91cmxCEAoOX3VwbG9hZF9tZXRob2RCDQoLX2V4cGlyZXNfYXRCGAoWX293bmVyc2hp'
    'cF9wcm9vZl9ub25jZUIfCh1fb3duZXJzaGlwX3Byb29mX21ldGFkYXRhX2tleQ==');

@$core.Deprecated('Use videoCoverOwnershipProofRangeDescriptor instead')
const VideoCoverOwnershipProofRange$json = {
  '1': 'VideoCoverOwnershipProofRange',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `VideoCoverOwnershipProofRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCoverOwnershipProofRangeDescriptor =
    $convert.base64Decode(
        'Ch1WaWRlb0NvdmVyT3duZXJzaGlwUHJvb2ZSYW5nZRIWCgZvZmZzZXQYASABKANSBm9mZnNldB'
        'IWCgZsZW5ndGgYAiABKAVSBmxlbmd0aA==');

@$core.Deprecated('Use createVideoCoverUploadSessionResponseDescriptor instead')
const CreateVideoCoverUploadSessionResponse$json = {
  '1': 'CreateVideoCoverUploadSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.VideoCoverUploadSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CreateVideoCoverUploadSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createVideoCoverUploadSessionResponseDescriptor =
    $convert.base64Decode(
        'CiVDcmVhdGVWaWRlb0NvdmVyVXBsb2FkU2Vzc2lvblJlc3BvbnNlEkAKB3Nlc3Npb24YASABKA'
        'syJi5zeW5jdHYuY2xpZW50LlZpZGVvQ292ZXJVcGxvYWRTZXNzaW9uUgdzZXNzaW9u');

@$core.Deprecated('Use uploadVideoCoverObjectRequestDescriptor instead')
const UploadVideoCoverObjectRequest$json = {
  '1': 'UploadVideoCoverObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'content_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'contentType',
      '17': true
    },
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
  '8': [
    {'1': '_content_type'},
  ],
};

/// Descriptor for `UploadVideoCoverObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadVideoCoverObjectRequestDescriptor = $convert.base64Decode(
    'Ch1VcGxvYWRWaWRlb0NvdmVyT2JqZWN0UmVxdWVzdBIsChJlbmNvZGVkX29iamVjdF9rZXkYAS'
    'ABKAlSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAiABKAlSBXRva2VuEiYKDGNvbnRlbnRf'
    'dHlwZRgDIAEoCUgAUgtjb250ZW50VHlwZYgBARISCgRkYXRhGAQgASgMUgRkYXRhQg8KDV9jb2'
    '50ZW50X3R5cGU=');

@$core.Deprecated('Use getVideoCoverObjectRequestDescriptor instead')
const GetVideoCoverObjectRequest$json = {
  '1': 'GetVideoCoverObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `GetVideoCoverObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVideoCoverObjectRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRWaWRlb0NvdmVyT2JqZWN0UmVxdWVzdBIsChJlbmNvZGVkX29iamVjdF9rZXkYASABKA'
        'lSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use videoCoverObjectResponseDescriptor instead')
const VideoCoverObjectResponse$json = {
  '1': 'VideoCoverObjectResponse',
  '2': [
    {'1': 'object_key', '3': 1, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'checksum_sha256', '3': 3, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `VideoCoverObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoCoverObjectResponseDescriptor = $convert.base64Decode(
    'ChhWaWRlb0NvdmVyT2JqZWN0UmVzcG9uc2USHQoKb2JqZWN0X2tleRgBIAEoCVIJb2JqZWN0S2'
    'V5EhsKCW1pbWVfdHlwZRgCIAEoCVIIbWltZVR5cGUSJwoPY2hlY2tzdW1fc2hhMjU2GAMgASgJ'
    'Ug5jaGVja3N1bVNoYTI1NhISCgRkYXRhGAQgASgMUgRkYXRh');

@$core.Deprecated('Use uploadVideoCoverObjectResponseDescriptor instead')
const UploadVideoCoverObjectResponse$json = {
  '1': 'UploadVideoCoverObjectResponse',
  '2': [
    {
      '1': 'object',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.VideoCoverObjectResponse',
      '10': 'object'
    },
  ],
};

/// Descriptor for `UploadVideoCoverObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadVideoCoverObjectResponseDescriptor =
    $convert.base64Decode(
        'Ch5VcGxvYWRWaWRlb0NvdmVyT2JqZWN0UmVzcG9uc2USPwoGb2JqZWN0GAEgASgLMicuc3luY3'
        'R2LmNsaWVudC5WaWRlb0NvdmVyT2JqZWN0UmVzcG9uc2VSBm9iamVjdA==');

@$core.Deprecated('Use updateVideoCoverRequestDescriptor instead')
const UpdateVideoCoverRequest$json = {
  '1': 'UpdateVideoCoverRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
    {
      '1': 'cover',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.VideoCover',
      '10': 'cover'
    },
  ],
};

/// Descriptor for `UpdateVideoCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateVideoCoverRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVWaWRlb0NvdmVyUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSIgoIbW'
    'VkaWFfaWQYAiABKAlCB7pIBHICEAFSB21lZGlhSWQSLwoFY292ZXIYAyABKAsyGS5zeW5jdHYu'
    'Y2xpZW50LlZpZGVvQ292ZXJSBWNvdmVy');

@$core.Deprecated('Use clearVideoCoverRequestDescriptor instead')
const ClearVideoCoverRequest$json = {
  '1': 'ClearVideoCoverRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `ClearVideoCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearVideoCoverRequestDescriptor =
    $convert.base64Decode(
        'ChZDbGVhclZpZGVvQ292ZXJSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIiCghtZW'
        'RpYV9pZBgCIAEoCUIHukgEcgIQAVIHbWVkaWFJZA==');

@$core.Deprecated('Use createRoomCoverUploadSessionRequestDescriptor instead')
const CreateRoomCoverUploadSessionRequest$json = {
  '1': 'CreateRoomCoverUploadSessionRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'client_cover_id', '3': 2, '4': 1, '5': 9, '10': 'clientCoverId'},
    {'1': 'mime_type', '3': 3, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 4, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 5, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 6, '4': 1, '5': 5, '10': 'height'},
    {'1': 'checksum_sha256', '3': 7, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'metadata', '3': 8, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `CreateRoomCoverUploadSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomCoverUploadSessionRequestDescriptor = $convert.base64Decode(
    'CiNDcmVhdGVSb29tQ292ZXJVcGxvYWRTZXNzaW9uUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUg'
    'Zyb29tSWQSJgoPY2xpZW50X2NvdmVyX2lkGAIgASgJUg1jbGllbnRDb3ZlcklkEhsKCW1pbWVf'
    'dHlwZRgDIAEoCVIIbWltZVR5cGUSHQoKc2l6ZV9ieXRlcxgEIAEoA1IJc2l6ZUJ5dGVzEhQKBX'
    'dpZHRoGAUgASgFUgV3aWR0aBIWCgZoZWlnaHQYBiABKAVSBmhlaWdodBInCg9jaGVja3N1bV9z'
    'aGEyNTYYByABKAlSDmNoZWNrc3VtU2hhMjU2EhoKCG1ldGFkYXRhGAggASgMUghtZXRhZGF0YQ'
    '==');

@$core.Deprecated('Use roomCoverUploadSessionDescriptor instead')
const RoomCoverUploadSession$json = {
  '1': 'RoomCoverUploadSession',
  '2': [
    {
      '1': 'cover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.FileCover',
      '10': 'cover'
    },
    {'1': 'upload_required', '3': 2, '4': 1, '5': 8, '10': 'uploadRequired'},
    {
      '1': 'upload_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'uploadUrl',
      '17': true
    },
    {
      '1': 'upload_method',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'uploadMethod',
      '17': true
    },
    {
      '1': 'upload_headers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomCoverUploadSession.UploadHeadersEntry',
      '10': 'uploadHeaders'
    },
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'expiresAt',
      '17': true
    },
    {'1': 'max_size_bytes', '3': 7, '4': 1, '5': 3, '10': 'maxSizeBytes'},
    {
      '1': 'ownership_proof_required',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'ownershipProofRequired'
    },
    {
      '1': 'ownership_proof_nonce',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'ownershipProofNonce',
      '17': true
    },
    {
      '1': 'ownership_proof_ranges',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.FileOwnershipProofRange',
      '10': 'ownershipProofRanges'
    },
    {
      '1': 'ownership_proof_metadata_key',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'ownershipProofMetadataKey',
      '17': true
    },
  ],
  '3': [RoomCoverUploadSession_UploadHeadersEntry$json],
  '8': [
    {'1': '_upload_url'},
    {'1': '_upload_method'},
    {'1': '_expires_at'},
    {'1': '_ownership_proof_nonce'},
    {'1': '_ownership_proof_metadata_key'},
  ],
};

@$core.Deprecated('Use roomCoverUploadSessionDescriptor instead')
const RoomCoverUploadSession_UploadHeadersEntry$json = {
  '1': 'UploadHeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RoomCoverUploadSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomCoverUploadSessionDescriptor = $convert.base64Decode(
    'ChZSb29tQ292ZXJVcGxvYWRTZXNzaW9uEi4KBWNvdmVyGAEgASgLMhguc3luY3R2LmNsaWVudC'
    '5GaWxlQ292ZXJSBWNvdmVyEicKD3VwbG9hZF9yZXF1aXJlZBgCIAEoCFIOdXBsb2FkUmVxdWly'
    'ZWQSIgoKdXBsb2FkX3VybBgDIAEoCUgAUgl1cGxvYWRVcmyIAQESKAoNdXBsb2FkX21ldGhvZB'
    'gEIAEoCUgBUgx1cGxvYWRNZXRob2SIAQESXwoOdXBsb2FkX2hlYWRlcnMYBSADKAsyOC5zeW5j'
    'dHYuY2xpZW50LlJvb21Db3ZlclVwbG9hZFNlc3Npb24uVXBsb2FkSGVhZGVyc0VudHJ5Ug11cG'
    'xvYWRIZWFkZXJzEiIKCmV4cGlyZXNfYXQYBiABKANIAlIJZXhwaXJlc0F0iAEBEiQKDm1heF9z'
    'aXplX2J5dGVzGAcgASgDUgxtYXhTaXplQnl0ZXMSOAoYb3duZXJzaGlwX3Byb29mX3JlcXVpcm'
    'VkGAggASgIUhZvd25lcnNoaXBQcm9vZlJlcXVpcmVkEjcKFW93bmVyc2hpcF9wcm9vZl9ub25j'
    'ZRgJIAEoCUgDUhNvd25lcnNoaXBQcm9vZk5vbmNliAEBElwKFm93bmVyc2hpcF9wcm9vZl9yYW'
    '5nZXMYCiADKAsyJi5zeW5jdHYuY2xpZW50LkZpbGVPd25lcnNoaXBQcm9vZlJhbmdlUhRvd25l'
    'cnNoaXBQcm9vZlJhbmdlcxJEChxvd25lcnNoaXBfcHJvb2ZfbWV0YWRhdGFfa2V5GAsgASgJSA'
    'RSGW93bmVyc2hpcFByb29mTWV0YWRhdGFLZXmIAQEaQAoSVXBsb2FkSGVhZGVyc0VudHJ5EhAK'
    'A2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFCDQoLX3VwbG9hZF91cm'
    'xCEAoOX3VwbG9hZF9tZXRob2RCDQoLX2V4cGlyZXNfYXRCGAoWX293bmVyc2hpcF9wcm9vZl9u'
    'b25jZUIfCh1fb3duZXJzaGlwX3Byb29mX21ldGFkYXRhX2tleQ==');

@$core.Deprecated('Use createRoomCoverUploadSessionResponseDescriptor instead')
const CreateRoomCoverUploadSessionResponse$json = {
  '1': 'CreateRoomCoverUploadSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomCoverUploadSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CreateRoomCoverUploadSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomCoverUploadSessionResponseDescriptor =
    $convert.base64Decode(
        'CiRDcmVhdGVSb29tQ292ZXJVcGxvYWRTZXNzaW9uUmVzcG9uc2USPwoHc2Vzc2lvbhgBIAEoCz'
        'IlLnN5bmN0di5jbGllbnQuUm9vbUNvdmVyVXBsb2FkU2Vzc2lvblIHc2Vzc2lvbg==');

@$core.Deprecated('Use uploadRoomCoverObjectRequestDescriptor instead')
const UploadRoomCoverObjectRequest$json = {
  '1': 'UploadRoomCoverObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'content_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'contentType',
      '17': true
    },
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
  '8': [
    {'1': '_content_type'},
  ],
};

/// Descriptor for `UploadRoomCoverObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadRoomCoverObjectRequestDescriptor = $convert.base64Decode(
    'ChxVcGxvYWRSb29tQ292ZXJPYmplY3RSZXF1ZXN0EiwKEmVuY29kZWRfb2JqZWN0X2tleRgBIA'
    'EoCVIQZW5jb2RlZE9iamVjdEtleRIUCgV0b2tlbhgCIAEoCVIFdG9rZW4SJgoMY29udGVudF90'
    'eXBlGAMgASgJSABSC2NvbnRlbnRUeXBliAEBEhIKBGRhdGEYBCABKAxSBGRhdGFCDwoNX2Nvbn'
    'RlbnRfdHlwZQ==');

@$core.Deprecated('Use getRoomCoverObjectRequestDescriptor instead')
const GetRoomCoverObjectRequest$json = {
  '1': 'GetRoomCoverObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `GetRoomCoverObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomCoverObjectRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRSb29tQ292ZXJPYmplY3RSZXF1ZXN0EiwKEmVuY29kZWRfb2JqZWN0X2tleRgBIAEoCV'
        'IQZW5jb2RlZE9iamVjdEtleRIUCgV0b2tlbhgCIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use roomCoverObjectResponseDescriptor instead')
const RoomCoverObjectResponse$json = {
  '1': 'RoomCoverObjectResponse',
  '2': [
    {'1': 'object_key', '3': 1, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'checksum_sha256', '3': 3, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `RoomCoverObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomCoverObjectResponseDescriptor = $convert.base64Decode(
    'ChdSb29tQ292ZXJPYmplY3RSZXNwb25zZRIdCgpvYmplY3Rfa2V5GAEgASgJUglvYmplY3RLZX'
    'kSGwoJbWltZV90eXBlGAIgASgJUghtaW1lVHlwZRInCg9jaGVja3N1bV9zaGEyNTYYAyABKAlS'
    'DmNoZWNrc3VtU2hhMjU2EhIKBGRhdGEYBCABKAxSBGRhdGE=');

@$core.Deprecated('Use uploadRoomCoverObjectResponseDescriptor instead')
const UploadRoomCoverObjectResponse$json = {
  '1': 'UploadRoomCoverObjectResponse',
  '2': [
    {
      '1': 'object',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomCoverObjectResponse',
      '10': 'object'
    },
  ],
};

/// Descriptor for `UploadRoomCoverObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadRoomCoverObjectResponseDescriptor =
    $convert.base64Decode(
        'Ch1VcGxvYWRSb29tQ292ZXJPYmplY3RSZXNwb25zZRI+CgZvYmplY3QYASABKAsyJi5zeW5jdH'
        'YuY2xpZW50LlJvb21Db3Zlck9iamVjdFJlc3BvbnNlUgZvYmplY3Q=');

@$core.Deprecated('Use updateRoomCoverRequestDescriptor instead')
const UpdateRoomCoverRequest$json = {
  '1': 'UpdateRoomCoverRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'cover',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.FileCover',
      '10': 'cover'
    },
  ],
};

/// Descriptor for `UpdateRoomCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomCoverRequestDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVSb29tQ292ZXJSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIuCgVjb3'
        'ZlchgCIAEoCzIYLnN5bmN0di5jbGllbnQuRmlsZUNvdmVyUgVjb3Zlcg==');

@$core.Deprecated('Use clearRoomCoverRequestDescriptor instead')
const ClearRoomCoverRequest$json = {
  '1': 'ClearRoomCoverRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `ClearRoomCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearRoomCoverRequestDescriptor =
    $convert.base64Decode(
        'ChVDbGVhclJvb21Db3ZlclJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlk');

@$core
    .Deprecated('Use createPlaylistCoverUploadSessionRequestDescriptor instead')
const CreatePlaylistCoverUploadSessionRequest$json = {
  '1': 'CreatePlaylistCoverUploadSessionRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
    {'1': 'client_cover_id', '3': 3, '4': 1, '5': 9, '10': 'clientCoverId'},
    {'1': 'mime_type', '3': 4, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'size_bytes', '3': 5, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'width', '3': 6, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 7, '4': 1, '5': 5, '10': 'height'},
    {'1': 'checksum_sha256', '3': 8, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'metadata', '3': 9, '4': 1, '5': 12, '10': 'metadata'},
  ],
};

/// Descriptor for `CreatePlaylistCoverUploadSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPlaylistCoverUploadSessionRequestDescriptor =
    $convert.base64Decode(
        'CidDcmVhdGVQbGF5bGlzdENvdmVyVXBsb2FkU2Vzc2lvblJlcXVlc3QSFwoHcm9vbV9pZBgBIA'
        'EoCVIGcm9vbUlkEigKC3BsYXlsaXN0X2lkGAIgASgJQge6SARyAhABUgpwbGF5bGlzdElkEiYK'
        'D2NsaWVudF9jb3Zlcl9pZBgDIAEoCVINY2xpZW50Q292ZXJJZBIbCgltaW1lX3R5cGUYBCABKA'
        'lSCG1pbWVUeXBlEh0KCnNpemVfYnl0ZXMYBSABKANSCXNpemVCeXRlcxIUCgV3aWR0aBgGIAEo'
        'BVIFd2lkdGgSFgoGaGVpZ2h0GAcgASgFUgZoZWlnaHQSJwoPY2hlY2tzdW1fc2hhMjU2GAggAS'
        'gJUg5jaGVja3N1bVNoYTI1NhIaCghtZXRhZGF0YRgJIAEoDFIIbWV0YWRhdGE=');

@$core.Deprecated('Use playlistCoverUploadSessionDescriptor instead')
const PlaylistCoverUploadSession$json = {
  '1': 'PlaylistCoverUploadSession',
  '2': [
    {
      '1': 'cover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.FileCover',
      '10': 'cover'
    },
    {'1': 'upload_required', '3': 2, '4': 1, '5': 8, '10': 'uploadRequired'},
    {
      '1': 'upload_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'uploadUrl',
      '17': true
    },
    {
      '1': 'upload_method',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'uploadMethod',
      '17': true
    },
    {
      '1': 'upload_headers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaylistCoverUploadSession.UploadHeadersEntry',
      '10': 'uploadHeaders'
    },
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'expiresAt',
      '17': true
    },
    {'1': 'max_size_bytes', '3': 7, '4': 1, '5': 3, '10': 'maxSizeBytes'},
    {
      '1': 'ownership_proof_required',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'ownershipProofRequired'
    },
    {
      '1': 'ownership_proof_nonce',
      '3': 9,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'ownershipProofNonce',
      '17': true
    },
    {
      '1': 'ownership_proof_ranges',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.FileOwnershipProofRange',
      '10': 'ownershipProofRanges'
    },
    {
      '1': 'ownership_proof_metadata_key',
      '3': 11,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'ownershipProofMetadataKey',
      '17': true
    },
  ],
  '3': [PlaylistCoverUploadSession_UploadHeadersEntry$json],
  '8': [
    {'1': '_upload_url'},
    {'1': '_upload_method'},
    {'1': '_expires_at'},
    {'1': '_ownership_proof_nonce'},
    {'1': '_ownership_proof_metadata_key'},
  ],
};

@$core.Deprecated('Use playlistCoverUploadSessionDescriptor instead')
const PlaylistCoverUploadSession_UploadHeadersEntry$json = {
  '1': 'UploadHeadersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PlaylistCoverUploadSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistCoverUploadSessionDescriptor = $convert.base64Decode(
    'ChpQbGF5bGlzdENvdmVyVXBsb2FkU2Vzc2lvbhIuCgVjb3ZlchgBIAEoCzIYLnN5bmN0di5jbG'
    'llbnQuRmlsZUNvdmVyUgVjb3ZlchInCg91cGxvYWRfcmVxdWlyZWQYAiABKAhSDnVwbG9hZFJl'
    'cXVpcmVkEiIKCnVwbG9hZF91cmwYAyABKAlIAFIJdXBsb2FkVXJsiAEBEigKDXVwbG9hZF9tZX'
    'Rob2QYBCABKAlIAVIMdXBsb2FkTWV0aG9kiAEBEmMKDnVwbG9hZF9oZWFkZXJzGAUgAygLMjwu'
    'c3luY3R2LmNsaWVudC5QbGF5bGlzdENvdmVyVXBsb2FkU2Vzc2lvbi5VcGxvYWRIZWFkZXJzRW'
    '50cnlSDXVwbG9hZEhlYWRlcnMSIgoKZXhwaXJlc19hdBgGIAEoA0gCUglleHBpcmVzQXSIAQES'
    'JAoObWF4X3NpemVfYnl0ZXMYByABKANSDG1heFNpemVCeXRlcxI4Chhvd25lcnNoaXBfcHJvb2'
    'ZfcmVxdWlyZWQYCCABKAhSFm93bmVyc2hpcFByb29mUmVxdWlyZWQSNwoVb3duZXJzaGlwX3By'
    'b29mX25vbmNlGAkgASgJSANSE293bmVyc2hpcFByb29mTm9uY2WIAQESXAoWb3duZXJzaGlwX3'
    'Byb29mX3JhbmdlcxgKIAMoCzImLnN5bmN0di5jbGllbnQuRmlsZU93bmVyc2hpcFByb29mUmFu'
    'Z2VSFG93bmVyc2hpcFByb29mUmFuZ2VzEkQKHG93bmVyc2hpcF9wcm9vZl9tZXRhZGF0YV9rZX'
    'kYCyABKAlIBFIZb3duZXJzaGlwUHJvb2ZNZXRhZGF0YUtleYgBARpAChJVcGxvYWRIZWFkZXJz'
    'RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AUINCgtfdX'
    'Bsb2FkX3VybEIQCg5fdXBsb2FkX21ldGhvZEINCgtfZXhwaXJlc19hdEIYChZfb3duZXJzaGlw'
    'X3Byb29mX25vbmNlQh8KHV9vd25lcnNoaXBfcHJvb2ZfbWV0YWRhdGFfa2V5');

@$core.Deprecated(
    'Use createPlaylistCoverUploadSessionResponseDescriptor instead')
const CreatePlaylistCoverUploadSessionResponse$json = {
  '1': 'CreatePlaylistCoverUploadSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistCoverUploadSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `CreatePlaylistCoverUploadSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPlaylistCoverUploadSessionResponseDescriptor =
    $convert.base64Decode(
        'CihDcmVhdGVQbGF5bGlzdENvdmVyVXBsb2FkU2Vzc2lvblJlc3BvbnNlEkMKB3Nlc3Npb24YAS'
        'ABKAsyKS5zeW5jdHYuY2xpZW50LlBsYXlsaXN0Q292ZXJVcGxvYWRTZXNzaW9uUgdzZXNzaW9u');

@$core.Deprecated('Use uploadPlaylistCoverObjectRequestDescriptor instead')
const UploadPlaylistCoverObjectRequest$json = {
  '1': 'UploadPlaylistCoverObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'content_type',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'contentType',
      '17': true
    },
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
  '8': [
    {'1': '_content_type'},
  ],
};

/// Descriptor for `UploadPlaylistCoverObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadPlaylistCoverObjectRequestDescriptor =
    $convert.base64Decode(
        'CiBVcGxvYWRQbGF5bGlzdENvdmVyT2JqZWN0UmVxdWVzdBIsChJlbmNvZGVkX29iamVjdF9rZX'
        'kYASABKAlSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAiABKAlSBXRva2VuEiYKDGNvbnRl'
        'bnRfdHlwZRgDIAEoCUgAUgtjb250ZW50VHlwZYgBARISCgRkYXRhGAQgASgMUgRkYXRhQg8KDV'
        '9jb250ZW50X3R5cGU=');

@$core.Deprecated('Use getPlaylistCoverObjectRequestDescriptor instead')
const GetPlaylistCoverObjectRequest$json = {
  '1': 'GetPlaylistCoverObjectRequest',
  '2': [
    {
      '1': 'encoded_object_key',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'encodedObjectKey'
    },
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `GetPlaylistCoverObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlaylistCoverObjectRequestDescriptor =
    $convert.base64Decode(
        'Ch1HZXRQbGF5bGlzdENvdmVyT2JqZWN0UmVxdWVzdBIsChJlbmNvZGVkX29iamVjdF9rZXkYAS'
        'ABKAlSEGVuY29kZWRPYmplY3RLZXkSFAoFdG9rZW4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use playlistCoverObjectResponseDescriptor instead')
const PlaylistCoverObjectResponse$json = {
  '1': 'PlaylistCoverObjectResponse',
  '2': [
    {'1': 'object_key', '3': 1, '4': 1, '5': 9, '10': 'objectKey'},
    {'1': 'mime_type', '3': 2, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'checksum_sha256', '3': 3, '4': 1, '5': 9, '10': 'checksumSha256'},
    {'1': 'data', '3': 4, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `PlaylistCoverObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistCoverObjectResponseDescriptor =
    $convert.base64Decode(
        'ChtQbGF5bGlzdENvdmVyT2JqZWN0UmVzcG9uc2USHQoKb2JqZWN0X2tleRgBIAEoCVIJb2JqZW'
        'N0S2V5EhsKCW1pbWVfdHlwZRgCIAEoCVIIbWltZVR5cGUSJwoPY2hlY2tzdW1fc2hhMjU2GAMg'
        'ASgJUg5jaGVja3N1bVNoYTI1NhISCgRkYXRhGAQgASgMUgRkYXRh');

@$core.Deprecated('Use uploadPlaylistCoverObjectResponseDescriptor instead')
const UploadPlaylistCoverObjectResponse$json = {
  '1': 'UploadPlaylistCoverObjectResponse',
  '2': [
    {
      '1': 'object',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistCoverObjectResponse',
      '10': 'object'
    },
  ],
};

/// Descriptor for `UploadPlaylistCoverObjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadPlaylistCoverObjectResponseDescriptor =
    $convert.base64Decode(
        'CiFVcGxvYWRQbGF5bGlzdENvdmVyT2JqZWN0UmVzcG9uc2USQgoGb2JqZWN0GAEgASgLMiouc3'
        'luY3R2LmNsaWVudC5QbGF5bGlzdENvdmVyT2JqZWN0UmVzcG9uc2VSBm9iamVjdA==');

@$core.Deprecated('Use updatePlaylistCoverRequestDescriptor instead')
const UpdatePlaylistCoverRequest$json = {
  '1': 'UpdatePlaylistCoverRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
    {
      '1': 'cover',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.FileCover',
      '10': 'cover'
    },
  ],
};

/// Descriptor for `UpdatePlaylistCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaylistCoverRequestDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVQbGF5bGlzdENvdmVyUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSKA'
        'oLcGxheWxpc3RfaWQYAiABKAlCB7pIBHICEAFSCnBsYXlsaXN0SWQSLgoFY292ZXIYAyABKAsy'
        'GC5zeW5jdHYuY2xpZW50LkZpbGVDb3ZlclIFY292ZXI=');

@$core.Deprecated('Use clearPlaylistCoverRequestDescriptor instead')
const ClearPlaylistCoverRequest$json = {
  '1': 'ClearPlaylistCoverRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
  ],
};

/// Descriptor for `ClearPlaylistCoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearPlaylistCoverRequestDescriptor =
    $convert.base64Decode(
        'ChlDbGVhclBsYXlsaXN0Q292ZXJSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIoCg'
        'twbGF5bGlzdF9pZBgCIAEoCUIHukgEcgIQAVIKcGxheWxpc3RJZA==');

@$core.Deprecated('Use fileOwnershipProofRangeDescriptor instead')
const FileOwnershipProofRange$json = {
  '1': 'FileOwnershipProofRange',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 2, '4': 1, '5': 5, '10': 'length'},
  ],
};

/// Descriptor for `FileOwnershipProofRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileOwnershipProofRangeDescriptor =
    $convert.base64Decode(
        'ChdGaWxlT3duZXJzaGlwUHJvb2ZSYW5nZRIWCgZvZmZzZXQYASABKANSBm9mZnNldBIWCgZsZW'
        '5ndGgYAiABKAVSBmxlbmd0aA==');

@$core.Deprecated('Use chatMessageEventDescriptor instead')
const ChatMessageEvent$json = {
  '1': 'ChatMessageEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ChatMessageEventKind',
      '10': 'kind'
    },
    {
      '1': 'message',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'message'
    },
    {'1': 'occurred_at', '3': 5, '4': 1, '5': 3, '10': 'occurredAt'},
    {'1': 'sequence', '3': 6, '4': 1, '5': 3, '10': 'sequence'},
  ],
};

/// Descriptor for `ChatMessageEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageEventDescriptor = $convert.base64Decode(
    'ChBDaGF0TWVzc2FnZUV2ZW50EhkKCGV2ZW50X2lkGAEgASgJUgdldmVudElkEhcKB3Jvb21faW'
    'QYAiABKAlSBnJvb21JZBI3CgRraW5kGAMgASgOMiMuc3luY3R2LmNsaWVudC5DaGF0TWVzc2Fn'
    'ZUV2ZW50S2luZFIEa2luZBI7CgdtZXNzYWdlGAQgASgLMiEuc3luY3R2LmNsaWVudC5DaGF0TW'
    'Vzc2FnZVJlY2VpdmVSB21lc3NhZ2USHwoLb2NjdXJyZWRfYXQYBSABKANSCm9jY3VycmVkQXQS'
    'GgoIc2VxdWVuY2UYBiABKANSCHNlcXVlbmNl');

@$core.Deprecated('Use roomMemberEventDescriptor instead')
const RoomMemberEvent$json = {
  '1': 'RoomMemberEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.RoomMemberEventKind',
      '10': 'kind'
    },
    {
      '1': 'member',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.common.RoomMember',
      '10': 'member'
    },
    {'1': 'user_id', '3': 5, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'guest_id', '3': 6, '4': 1, '5': 9, '10': 'guestId'},
    {'1': 'username', '3': 7, '4': 1, '5': 9, '10': 'username'},
    {'1': 'actor_user_id', '3': 8, '4': 1, '5': 9, '10': 'actorUserId'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'occurred_at', '3': 10, '4': 1, '5': 3, '10': 'occurredAt'},
    {'1': 'sequence', '3': 11, '4': 1, '5': 3, '10': 'sequence'},
  ],
};

/// Descriptor for `RoomMemberEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMemberEventDescriptor = $convert.base64Decode(
    'Cg9Sb29tTWVtYmVyRXZlbnQSGQoIZXZlbnRfaWQYASABKAlSB2V2ZW50SWQSFwoHcm9vbV9pZB'
    'gCIAEoCVIGcm9vbUlkEjYKBGtpbmQYAyABKA4yIi5zeW5jdHYuY2xpZW50LlJvb21NZW1iZXJF'
    'dmVudEtpbmRSBGtpbmQSMQoGbWVtYmVyGAQgASgLMhkuc3luY3R2LmNvbW1vbi5Sb29tTWVtYm'
    'VyUgZtZW1iZXISFwoHdXNlcl9pZBgFIAEoCVIGdXNlcklkEhkKCGd1ZXN0X2lkGAYgASgJUgdn'
    'dWVzdElkEhoKCHVzZXJuYW1lGAcgASgJUgh1c2VybmFtZRIiCg1hY3Rvcl91c2VyX2lkGAggAS'
    'gJUgthY3RvclVzZXJJZBIWCgZyZWFzb24YCSABKAlSBnJlYXNvbhIfCgtvY2N1cnJlZF9hdBgK'
    'IAEoA1IKb2NjdXJyZWRBdBIaCghzZXF1ZW5jZRgLIAEoA1IIc2VxdWVuY2U=');

@$core.Deprecated('Use heartbeatMessageDescriptor instead')
const HeartbeatMessage$json = {
  '1': 'HeartbeatMessage',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `HeartbeatMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatMessageDescriptor = $convert.base64Decode(
    'ChBIZWFydGJlYXRNZXNzYWdlEhwKCXRpbWVzdGFtcBgBIAEoA1IJdGltZXN0YW1w');

@$core.Deprecated('Use heartbeatAckDescriptor instead')
const HeartbeatAck$json = {
  '1': 'HeartbeatAck',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `HeartbeatAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartbeatAckDescriptor = $convert.base64Decode(
    'CgxIZWFydGJlYXRBY2sSHAoJdGltZXN0YW1wGAEgASgDUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use onlineCountDescriptor instead')
const OnlineCount$json = {
  '1': 'OnlineCount',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `OnlineCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onlineCountDescriptor =
    $convert.base64Decode('CgtPbmxpbmVDb3VudBIUCgVjb3VudBgBIAEoBVIFY291bnQ=');

@$core.Deprecated('Use onlineEventDescriptor instead')
const OnlineEvent$json = {
  '1': 'OnlineEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
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
      '1': 'kind',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OnlineEventKind',
      '8': {},
      '10': 'kind'
    },
    {'1': 'occurred_at', '3': 7, '4': 1, '5': 3, '10': 'occurredAt'},
  ],
};

/// Descriptor for `OnlineEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onlineEventDescriptor = $convert.base64Decode(
    'CgtPbmxpbmVFdmVudBIZCghldmVudF9pZBgBIAEoCVIHZXZlbnRJZBIXCgdyb29tX2lkGAIgAS'
    'gJUgZyb29tSWQSFwoHdXNlcl9pZBgDIAEoCVIGdXNlcklkEhoKCHVzZXJuYW1lGAQgASgJUgh1'
    'c2VybmFtZRI7CgRyb2xlGAUgASgOMh0uc3luY3R2LmNvbW1vbi5Sb29tTWVtYmVyUm9sZUIIuk'
    'gFggECEAFSBHJvbGUSPAoEa2luZBgGIAEoDjIeLnN5bmN0di5jbGllbnQuT25saW5lRXZlbnRL'
    'aW5kQgi6SAWCAQIQAVIEa2luZBIfCgtvY2N1cnJlZF9hdBgHIAEoA1IKb2NjdXJyZWRBdA==');

@$core.Deprecated('Use errorMessageDescriptor instead')
const ErrorMessage$json = {
  '1': 'ErrorMessage',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'code', '3': 2, '4': 1, '5': 5, '10': 'code'},
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `ErrorMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorMessageDescriptor = $convert.base64Decode(
    'CgxFcnJvck1lc3NhZ2USGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZRISCgRjb2RlGAIgASgFUg'
    'Rjb2RlEhYKBmRldGFpbBgDIAEoCVIGZGV0YWls');

@$core.Deprecated('Use userNotificationDescriptor instead')
const UserNotification$json = {
  '1': 'UserNotification',
  '2': [
    {'1': 'notification_id', '3': 1, '4': 1, '5': 9, '10': 'notificationId'},
    {
      '1': 'notification_type',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'notificationType'
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    {'1': 'data', '3': 5, '4': 1, '5': 9, '10': 'data'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `UserNotification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userNotificationDescriptor = $convert.base64Decode(
    'ChBVc2VyTm90aWZpY2F0aW9uEicKD25vdGlmaWNhdGlvbl9pZBgBIAEoCVIObm90aWZpY2F0aW'
    '9uSWQSKwoRbm90aWZpY2F0aW9uX3R5cGUYAiABKAlSEG5vdGlmaWNhdGlvblR5cGUSFAoFdGl0'
    'bGUYAyABKAlSBXRpdGxlEhgKB2NvbnRlbnQYBCABKAlSB2NvbnRlbnQSEgoEZGF0YRgFIAEoCV'
    'IEZGF0YRIcCgl0aW1lc3RhbXAYBiABKANSCXRpbWVzdGFtcA==');

@$core.Deprecated('Use sendChatMessageRequestDescriptor instead')
const SendChatMessageRequest$json = {
  '1': 'SendChatMessageRequest',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
    {'1': 'client_message_id', '3': 2, '4': 1, '5': 9, '10': 'clientMessageId'},
    {
      '1': 'images',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatImage',
      '10': 'images'
    },
    {
      '1': 'reply_to_message_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'replyToMessageId'
    },
    {'1': 'metadata', '3': 5, '4': 1, '5': 12, '10': 'metadata'},
    {'1': 'display_position', '3': 6, '4': 1, '5': 9, '10': 'displayPosition'},
    {'1': 'display_color', '3': 7, '4': 1, '5': 9, '10': 'displayColor'},
    {
      '1': 'mentions',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMentionInput',
      '10': 'mentions'
    },
  ],
};

/// Descriptor for `SendChatMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendChatMessageRequestDescriptor = $convert.base64Decode(
    'ChZTZW5kQ2hhdE1lc3NhZ2VSZXF1ZXN0EhgKB2NvbnRlbnQYASABKAlSB2NvbnRlbnQSKgoRY2'
    'xpZW50X21lc3NhZ2VfaWQYAiABKAlSD2NsaWVudE1lc3NhZ2VJZBIwCgZpbWFnZXMYAyADKAsy'
    'GC5zeW5jdHYuY2xpZW50LkNoYXRJbWFnZVIGaW1hZ2VzEi0KE3JlcGx5X3RvX21lc3NhZ2VfaW'
    'QYBCABKAlSEHJlcGx5VG9NZXNzYWdlSWQSGgoIbWV0YWRhdGEYBSABKAxSCG1ldGFkYXRhEikK'
    'EGRpc3BsYXlfcG9zaXRpb24YBiABKAlSD2Rpc3BsYXlQb3NpdGlvbhIjCg1kaXNwbGF5X2NvbG'
    '9yGAcgASgJUgxkaXNwbGF5Q29sb3ISOwoIbWVudGlvbnMYCCADKAsyHy5zeW5jdHYuY2xpZW50'
    'LkNoYXRNZW50aW9uSW5wdXRSCG1lbnRpb25z');

@$core.Deprecated('Use editChatMessageRequestDescriptor instead')
const EditChatMessageRequest$json = {
  '1': 'EditChatMessageRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
    {'1': 'metadata', '3': 4, '4': 1, '5': 12, '10': 'metadata'},
    {
      '1': 'client_operation_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'clientOperationId'
    },
  ],
};

/// Descriptor for `EditChatMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List editChatMessageRequestDescriptor = $convert.base64Decode(
    'ChZFZGl0Q2hhdE1lc3NhZ2VSZXF1ZXN0Eh0KCm1lc3NhZ2VfaWQYASABKAlSCW1lc3NhZ2VJZB'
    'IYCgdjb250ZW50GAIgASgJUgdjb250ZW50EikKEGV4cGVjdGVkX3ZlcnNpb24YAyABKANSD2V4'
    'cGVjdGVkVmVyc2lvbhIaCghtZXRhZGF0YRgEIAEoDFIIbWV0YWRhdGESLgoTY2xpZW50X29wZX'
    'JhdGlvbl9pZBgFIAEoCVIRY2xpZW50T3BlcmF0aW9uSWQ=');

@$core.Deprecated('Use deleteChatMessageRequestDescriptor instead')
const DeleteChatMessageRequest$json = {
  '1': 'DeleteChatMessageRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'client_operation_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'clientOperationId'
    },
  ],
};

/// Descriptor for `DeleteChatMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteChatMessageRequestDescriptor = $convert.base64Decode(
    'ChhEZWxldGVDaGF0TWVzc2FnZVJlcXVlc3QSHQoKbWVzc2FnZV9pZBgBIAEoCVIJbWVzc2FnZU'
    'lkEikKEGV4cGVjdGVkX3ZlcnNpb24YAiABKANSD2V4cGVjdGVkVmVyc2lvbhIWCgZyZWFzb24Y'
    'AyABKAlSBnJlYXNvbhIuChNjbGllbnRfb3BlcmF0aW9uX2lkGAQgASgJUhFjbGllbnRPcGVyYX'
    'Rpb25JZA==');

@$core.Deprecated('Use setChatReactionRequestDescriptor instead')
const SetChatReactionRequest$json = {
  '1': 'SetChatReactionRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'reaction_key', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reactionKey'},
    {'1': 'enabled', '3': 3, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `SetChatReactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setChatReactionRequestDescriptor = $convert.base64Decode(
    'ChZTZXRDaGF0UmVhY3Rpb25SZXF1ZXN0Eh0KCm1lc3NhZ2VfaWQYASABKAlSCW1lc3NhZ2VJZB'
    'IsCgxyZWFjdGlvbl9rZXkYAiABKAlCCbpIBnIEEAEYQFILcmVhY3Rpb25LZXkSGAoHZW5hYmxl'
    'ZBgDIAEoCFIHZW5hYmxlZA==');

@$core.Deprecated('Use setChatReactionResponseDescriptor instead')
const SetChatReactionResponse$json = {
  '1': 'SetChatReactionResponse',
  '2': [
    {
      '1': 'event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageEvent',
      '10': 'event'
    },
  ],
};

/// Descriptor for `SetChatReactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setChatReactionResponseDescriptor =
    $convert.base64Decode(
        'ChdTZXRDaGF0UmVhY3Rpb25SZXNwb25zZRI1CgVldmVudBgBIAEoCzIfLnN5bmN0di5jbGllbn'
        'QuQ2hhdE1lc3NhZ2VFdmVudFIFZXZlbnQ=');

@$core.Deprecated('Use reportRoomTargetDescriptor instead')
const ReportRoomTarget$json = {
  '1': 'ReportRoomTarget',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
  ],
};

/// Descriptor for `ReportRoomTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportRoomTargetDescriptor = $convert.base64Decode(
    'ChBSZXBvcnRSb29tVGFyZ2V0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZA==');

@$core.Deprecated('Use reportUserTargetDescriptor instead')
const ReportUserTarget$json = {
  '1': 'ReportUserTarget',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ReportUserTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportUserTargetDescriptor = $convert.base64Decode(
    'ChBSZXBvcnRVc2VyVGFyZ2V0EhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use reportRoomMemberTargetDescriptor instead')
const ReportRoomMemberTarget$json = {
  '1': 'ReportRoomMemberTarget',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ReportRoomMemberTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportRoomMemberTargetDescriptor =
    $convert.base64Decode(
        'ChZSZXBvcnRSb29tTWVtYmVyVGFyZ2V0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIXCgd1c2'
        'VyX2lkGAIgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use reportChatMessageTargetDescriptor instead')
const ReportChatMessageTarget$json = {
  '1': 'ReportChatMessageTarget',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'message_id', '3': 2, '4': 1, '5': 9, '10': 'messageId'},
  ],
};

/// Descriptor for `ReportChatMessageTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportChatMessageTargetDescriptor =
    $convert.base64Decode(
        'ChdSZXBvcnRDaGF0TWVzc2FnZVRhcmdldBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSHQoKbW'
        'Vzc2FnZV9pZBgCIAEoCVIJbWVzc2FnZUlk');

@$core.Deprecated('Use reportContentRequestDescriptor instead')
const ReportContentRequest$json = {
  '1': 'ReportContentRequest',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ReportRoomTarget',
      '9': 0,
      '10': 'room'
    },
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ReportUserTarget',
      '9': 0,
      '10': 'user'
    },
    {
      '1': 'room_member',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ReportRoomMemberTarget',
      '9': 0,
      '10': 'roomMember'
    },
    {
      '1': 'chat_message',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ReportChatMessageTarget',
      '9': 0,
      '10': 'chatMessage'
    },
    {'1': 'reason_code', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'reasonCode'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'reason'},
    {'1': 'metadata', '3': 7, '4': 1, '5': 12, '10': 'metadata'},
  ],
  '8': [
    {'1': 'target'},
  ],
};

/// Descriptor for `ReportContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportContentRequestDescriptor = $convert.base64Decode(
    'ChRSZXBvcnRDb250ZW50UmVxdWVzdBI1CgRyb29tGAEgASgLMh8uc3luY3R2LmNsaWVudC5SZX'
    'BvcnRSb29tVGFyZ2V0SABSBHJvb20SNQoEdXNlchgCIAEoCzIfLnN5bmN0di5jbGllbnQuUmVw'
    'b3J0VXNlclRhcmdldEgAUgR1c2VyEkgKC3Jvb21fbWVtYmVyGAMgASgLMiUuc3luY3R2LmNsaW'
    'VudC5SZXBvcnRSb29tTWVtYmVyVGFyZ2V0SABSCnJvb21NZW1iZXISSwoMY2hhdF9tZXNzYWdl'
    'GAQgASgLMiYuc3luY3R2LmNsaWVudC5SZXBvcnRDaGF0TWVzc2FnZVRhcmdldEgAUgtjaGF0TW'
    'Vzc2FnZRIqCgtyZWFzb25fY29kZRgFIAEoCUIJukgGcgQQARhAUgpyZWFzb25Db2RlEiAKBnJl'
    'YXNvbhgGIAEoCUIIukgFcgMY0A9SBnJlYXNvbhIaCghtZXRhZGF0YRgHIAEoDFIIbWV0YWRhdG'
    'FCCAoGdGFyZ2V0');

@$core.Deprecated('Use reportContentResponseDescriptor instead')
const ReportContentResponse$json = {
  '1': 'ReportContentResponse',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `ReportContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportContentResponseDescriptor = $convert.base64Decode(
    'ChVSZXBvcnRDb250ZW50UmVzcG9uc2USGwoJcmVwb3J0X2lkGAEgASgJUghyZXBvcnRJZBIdCg'
    'pjcmVhdGVkX2F0GAIgASgDUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use listRoomContentReportsRequestDescriptor instead')
const ListRoomContentReportsRequest$json = {
  '1': 'ListRoomContentReportsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ContentReportStatus',
      '8': {},
      '10': 'status'
    },
    {
      '1': 'target_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ContentReportTargetType',
      '8': {},
      '10': 'targetType'
    },
    {
      '1': 'target_member_user_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'targetMemberUserId'
    },
    {
      '1': 'target_chat_message_id',
      '3': 6,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'targetChatMessageId'
    },
    {'1': 'search', '3': 7, '4': 1, '5': 9, '8': {}, '10': 'search'},
  ],
  '7': {},
};

/// Descriptor for `ListRoomContentReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomContentReportsRequestDescriptor = $convert.base64Decode(
    'Ch1MaXN0Um9vbUNvbnRlbnRSZXBvcnRzUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhsKCX'
    'BhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSRAoGc3RhdHVzGAMgASgOMiIuc3luY3R2LmNsaWVu'
    'dC5Db250ZW50UmVwb3J0U3RhdHVzQgi6SAWCAQIQAVIGc3RhdHVzElEKC3RhcmdldF90eXBlGA'
    'QgASgOMiYuc3luY3R2LmNsaWVudC5Db250ZW50UmVwb3J0VGFyZ2V0VHlwZUIIukgFggECEAFS'
    'CnRhcmdldFR5cGUSUQoVdGFyZ2V0X21lbWJlcl91c2VyX2lkGAUgASgJQh66SBtyGRhAMhVeJH'
    'xedXNyX1tBLVphLXowLTldKyRSEnRhcmdldE1lbWJlclVzZXJJZBI8ChZ0YXJnZXRfY2hhdF9t'
    'ZXNzYWdlX2lkGAYgASgDQge6SAQiAigAUhN0YXJnZXRDaGF0TWVzc2FnZUlkEh8KBnNlYXJjaB'
    'gHIAEoCUIHukgEcgIYeFIGc2VhcmNoOpsCukiXAhpuCh5yb29tLmxpc3RfY29udGVudF9yZXBv'
    'cnRzLnBhZ2USKnBhZ2UgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYXQgbGVhc3QgMRogdG'
    'hpcy5wYWdlID09IDAgfHwgdGhpcy5wYWdlID49IDEapAEKI3Jvb20ubGlzdF9jb250ZW50X3Jl'
    'cG9ydHMucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYm'
    'V0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfHwgKHRoaXMucGFnZV9zaXpl'
    'ID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKQ==');

@$core.Deprecated('Use listRoomContentReportsResponseDescriptor instead')
const ListRoomContentReportsResponse$json = {
  '1': 'ListRoomContentReportsResponse',
  '2': [
    {
      '1': 'reports',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ContentReport',
      '10': 'reports'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListRoomContentReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomContentReportsResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0Um9vbUNvbnRlbnRSZXBvcnRzUmVzcG9uc2USNgoHcmVwb3J0cxgBIAMoCzIcLnN5bm'
        'N0di5jbGllbnQuQ29udGVudFJlcG9ydFIHcmVwb3J0cxIUCgV0b3RhbBgCIAEoBVIFdG90YWw=');

@$core.Deprecated('Use getRoomContentReportRequestDescriptor instead')
const GetRoomContentReportRequest$json = {
  '1': 'GetRoomContentReportRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'reportId'},
  ],
};

/// Descriptor for `GetRoomContentReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomContentReportRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRSb29tQ29udGVudFJlcG9ydFJlcXVlc3QSPQoJcmVwb3J0X2lkGAEgASgJQiC6SB1yGx'
        'ABGEAyFV5yZXBvcnRfW0EtWmEtejAtOV0rJFIIcmVwb3J0SWQ=');

@$core.Deprecated('Use getRoomContentReportResponseDescriptor instead')
const GetRoomContentReportResponse$json = {
  '1': 'GetRoomContentReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ContentReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetRoomContentReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomContentReportResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXRSb29tQ29udGVudFJlcG9ydFJlc3BvbnNlEjQKBnJlcG9ydBgBIAEoCzIcLnN5bmN0di'
        '5jbGllbnQuQ29udGVudFJlcG9ydFIGcmVwb3J0');

@$core.Deprecated('Use updateRoomContentReportStatusRequestDescriptor instead')
const UpdateRoomContentReportStatusRequest$json = {
  '1': 'UpdateRoomContentReportStatusRequest',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'reportId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ContentReportStatus',
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

/// Descriptor for `UpdateRoomContentReportStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomContentReportStatusRequestDescriptor =
    $convert.base64Decode(
        'CiRVcGRhdGVSb29tQ29udGVudFJlcG9ydFN0YXR1c1JlcXVlc3QSPQoJcmVwb3J0X2lkGAEgAS'
        'gJQiC6SB1yGxABGEAyFV5yZXBvcnRfW0EtWmEtejAtOV0rJFIIcmVwb3J0SWQSRgoGc3RhdHVz'
        'GAIgASgOMiIuc3luY3R2LmNsaWVudC5Db250ZW50UmVwb3J0U3RhdHVzQgq6SAeCAQQQASAAUg'
        'ZzdGF0dXMSMQoPcmVzb2x1dGlvbl9ub3RlGAMgASgJQgi6SAVyAxjQD1IOcmVzb2x1dGlvbk5v'
        'dGU=');

@$core.Deprecated('Use updateRoomContentReportStatusResponseDescriptor instead')
const UpdateRoomContentReportStatusResponse$json = {
  '1': 'UpdateRoomContentReportStatusResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ContentReport',
      '10': 'report'
    },
    {'1': 'success', '3': 2, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `UpdateRoomContentReportStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoomContentReportStatusResponseDescriptor =
    $convert.base64Decode(
        'CiVVcGRhdGVSb29tQ29udGVudFJlcG9ydFN0YXR1c1Jlc3BvbnNlEjQKBnJlcG9ydBgBIAEoCz'
        'IcLnN5bmN0di5jbGllbnQuQ29udGVudFJlcG9ydFIGcmVwb3J0EhgKB3N1Y2Nlc3MYAiABKAhS'
        'B3N1Y2Nlc3M=');

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
      '6': '.synctv.client.ContentReportTargetType',
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
    {'1': 'metadata', '3': 20, '4': 1, '5': 12, '10': 'metadata'},
    {
      '1': 'status',
      '3': 21,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ContentReportStatus',
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
    '9tTmFtZRJHCgt0YXJnZXRfdHlwZRgGIAEoDjImLnN5bmN0di5jbGllbnQuQ29udGVudFJlcG9y'
    'dFRhcmdldFR5cGVSCnRhcmdldFR5cGUSJAoOdGFyZ2V0X3Jvb21faWQYByABKAlSDHRhcmdldF'
    'Jvb21JZBIoChB0YXJnZXRfcm9vbV9uYW1lGAggASgJUg50YXJnZXRSb29tTmFtZRIkCg50YXJn'
    'ZXRfdXNlcl9pZBgJIAEoCVIMdGFyZ2V0VXNlcklkEicKD3RhcmdldF91c2VybmFtZRgKIAEoCV'
    'IOdGFyZ2V0VXNlcm5hbWUSMQoVdGFyZ2V0X21lbWJlcl9yb29tX2lkGAsgASgJUhJ0YXJnZXRN'
    'ZW1iZXJSb29tSWQSNQoXdGFyZ2V0X21lbWJlcl9yb29tX25hbWUYDCABKAlSFHRhcmdldE1lbW'
    'JlclJvb21OYW1lEjEKFXRhcmdldF9tZW1iZXJfdXNlcl9pZBgNIAEoCVISdGFyZ2V0TWVtYmVy'
    'VXNlcklkEjQKFnRhcmdldF9tZW1iZXJfdXNlcm5hbWUYDiABKAlSFHRhcmdldE1lbWJlclVzZX'
    'JuYW1lEjMKFnRhcmdldF9jaGF0X21lc3NhZ2VfaWQYDyABKANSE3RhcmdldENoYXRNZXNzYWdl'
    'SWQSQgoedGFyZ2V0X2NoYXRfbWVzc2FnZV9jcmVhdGVkX2F0GBAgASgDUhp0YXJnZXRDaGF0TW'
    'Vzc2FnZUNyZWF0ZWRBdBI9Cht0YXJnZXRfY2hhdF9tZXNzYWdlX3ByZXZpZXcYESABKAlSGHRh'
    'cmdldENoYXRNZXNzYWdlUHJldmlldxIfCgtyZWFzb25fY29kZRgSIAEoCVIKcmVhc29uQ29kZR'
    'IWCgZyZWFzb24YEyABKAlSBnJlYXNvbhIaCghtZXRhZGF0YRgUIAEoDFIIbWV0YWRhdGESOgoG'
    'c3RhdHVzGBUgASgOMiIuc3luY3R2LmNsaWVudC5Db250ZW50UmVwb3J0U3RhdHVzUgZzdGF0dX'
    'MSHwoLcmV2aWV3ZWRfYnkYFiABKAlSCnJldmlld2VkQnkSMAoUcmV2aWV3ZWRfYnlfdXNlcm5h'
    'bWUYFyABKAlSEnJldmlld2VkQnlVc2VybmFtZRIfCgtyZXZpZXdlZF9hdBgYIAEoA1IKcmV2aW'
    'V3ZWRBdBInCg9yZXNvbHV0aW9uX25vdGUYGSABKAlSDnJlc29sdXRpb25Ob3RlEh0KCmNyZWF0'
    'ZWRfYXQYGiABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GBsgASgDUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use listChatReactionUsersRequestDescriptor instead')
const ListChatReactionUsersRequest$json = {
  '1': 'ListChatReactionUsersRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'reaction_key', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'reactionKey'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'cursor', '3': 4, '4': 1, '5': 9, '10': 'cursor'},
  ],
  '7': {},
};

/// Descriptor for `ListChatReactionUsersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChatReactionUsersRequestDescriptor = $convert.base64Decode(
    'ChxMaXN0Q2hhdFJlYWN0aW9uVXNlcnNSZXF1ZXN0Eh0KCm1lc3NhZ2VfaWQYASABKAlSCW1lc3'
    'NhZ2VJZBIsCgxyZWFjdGlvbl9rZXkYAiABKAlCCbpIBnIEEAEYQFILcmVhY3Rpb25LZXkSFAoF'
    'bGltaXQYAyABKAVSBWxpbWl0EhYKBmN1cnNvchgEIAEoCVIGY3Vyc29yOpYBukiSARqPAQoebG'
    'lzdF9jaGF0X3JlYWN0aW9uX3VzZXJzLmxpbWl0EjJsaW1pdCBtdXN0IGJlIDAgKHVzZSBkZWZh'
    'dWx0KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBo5dGhpcy5saW1pdCA9PSAwIHx8ICh0aGlzLmxpbW'
    'l0ID49IDEgJiYgdGhpcy5saW1pdCA8PSAxMDAp');

@$core.Deprecated('Use listChatReactionUsersResponseDescriptor instead')
const ListChatReactionUsersResponse$json = {
  '1': 'ListChatReactionUsersResponse',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatReactionUser',
      '10': 'users'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
    {'1': 'total', '3': 3, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `ListChatReactionUsersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChatReactionUsersResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q2hhdFJlYWN0aW9uVXNlcnNSZXNwb25zZRI1CgV1c2VycxgBIAMoCzIfLnN5bmN0di'
        '5jbGllbnQuQ2hhdFJlYWN0aW9uVXNlclIFdXNlcnMSHwoLbmV4dF9jdXJzb3IYAiABKAlSCm5l'
        'eHRDdXJzb3ISFAoFdG90YWwYAyABKANSBXRvdGFs');

@$core.Deprecated('Use chatMessageEventResponseDescriptor instead')
const ChatMessageEventResponse$json = {
  '1': 'ChatMessageEventResponse',
  '2': [
    {
      '1': 'event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageEvent',
      '10': 'event'
    },
  ],
};

/// Descriptor for `ChatMessageEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageEventResponseDescriptor =
    $convert.base64Decode(
        'ChhDaGF0TWVzc2FnZUV2ZW50UmVzcG9uc2USNQoFZXZlbnQYASABKAsyHy5zeW5jdHYuY2xpZW'
        '50LkNoYXRNZXNzYWdlRXZlbnRSBWV2ZW50');

@$core.Deprecated('Use getChatHistoryRequestDescriptor instead')
const GetChatHistoryRequest$json = {
  '1': 'GetChatHistoryRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'cursor', '3': 2, '4': 1, '5': 9, '10': 'cursor'},
  ],
  '7': {},
};

/// Descriptor for `GetChatHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatHistoryRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDaGF0SGlzdG9yeVJlcXVlc3QSFAoFbGltaXQYASABKAVSBWxpbWl0EhYKBmN1cnNvch'
    'gCIAEoCVIGY3Vyc29yOo4BukiKARqHAQoWZ2V0X2NoYXRfaGlzdG9yeS5saW1pdBIybGltaXQg'
    'bXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaOXRoaXMubGltaX'
    'QgPT0gMCB8fCAodGhpcy5saW1pdCA+PSAxICYmIHRoaXMubGltaXQgPD0gMTAwKQ==');

@$core.Deprecated('Use getChatHistoryResponseDescriptor instead')
const GetChatHistoryResponse$json = {
  '1': 'GetChatHistoryResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'messages'
    },
    {'1': 'next_cursor', '3': 2, '4': 1, '5': 9, '10': 'nextCursor'},
    {
      '1': 'event_cursor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.EventCursor',
      '10': 'eventCursor'
    },
  ],
};

/// Descriptor for `GetChatHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatHistoryResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDaGF0SGlzdG9yeVJlc3BvbnNlEj0KCG1lc3NhZ2VzGAEgAygLMiEuc3luY3R2LmNsaW'
    'VudC5DaGF0TWVzc2FnZVJlY2VpdmVSCG1lc3NhZ2VzEh8KC25leHRfY3Vyc29yGAIgASgJUgpu'
    'ZXh0Q3Vyc29yEj0KDGV2ZW50X2N1cnNvchgDIAEoCzIaLnN5bmN0di5jbGllbnQuRXZlbnRDdX'
    'Jzb3JSC2V2ZW50Q3Vyc29y');

@$core.Deprecated('Use eventCursorDescriptor instead')
const EventCursor$json = {
  '1': 'EventCursor',
  '2': [
    {
      '1': 'event_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'eventId',
      '17': true
    },
    {'1': 'sequence', '3': 2, '4': 1, '5': 3, '10': 'sequence'},
  ],
  '8': [
    {'1': '_event_id'},
  ],
};

/// Descriptor for `EventCursor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventCursorDescriptor = $convert.base64Decode(
    'CgtFdmVudEN1cnNvchIeCghldmVudF9pZBgBIAEoCUgAUgdldmVudElkiAEBEhoKCHNlcXVlbm'
    'NlGAIgASgDUghzZXF1ZW5jZUILCglfZXZlbnRfaWQ=');

@$core.Deprecated('Use getChatMessageRequestDescriptor instead')
const GetChatMessageRequest$json = {
  '1': 'GetChatMessageRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'include_deleted', '3': 2, '4': 1, '5': 8, '10': 'includeDeleted'},
  ],
};

/// Descriptor for `GetChatMessageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatMessageRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDaGF0TWVzc2FnZVJlcXVlc3QSHQoKbWVzc2FnZV9pZBgBIAEoCVIJbWVzc2FnZUlkEi'
    'cKD2luY2x1ZGVfZGVsZXRlZBgCIAEoCFIOaW5jbHVkZURlbGV0ZWQ=');

@$core.Deprecated('Use getChatMessageResponseDescriptor instead')
const GetChatMessageResponse$json = {
  '1': 'GetChatMessageResponse',
  '2': [
    {
      '1': 'message',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'message'
    },
  ],
};

/// Descriptor for `GetChatMessageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatMessageResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRDaGF0TWVzc2FnZVJlc3BvbnNlEjsKB21lc3NhZ2UYASABKAsyIS5zeW5jdHYuY2xpZW'
        '50LkNoYXRNZXNzYWdlUmVjZWl2ZVIHbWVzc2FnZQ==');

@$core.Deprecated('Use getChatMessageContextRequestDescriptor instead')
const GetChatMessageContextRequest$json = {
  '1': 'GetChatMessageContextRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'before_limit', '3': 2, '4': 1, '5': 5, '10': 'beforeLimit'},
    {'1': 'after_limit', '3': 3, '4': 1, '5': 5, '10': 'afterLimit'},
    {'1': 'include_deleted', '3': 4, '4': 1, '5': 8, '10': 'includeDeleted'},
  ],
};

/// Descriptor for `GetChatMessageContextRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatMessageContextRequestDescriptor = $convert.base64Decode(
    'ChxHZXRDaGF0TWVzc2FnZUNvbnRleHRSZXF1ZXN0Eh0KCm1lc3NhZ2VfaWQYASABKAlSCW1lc3'
    'NhZ2VJZBIhCgxiZWZvcmVfbGltaXQYAiABKAVSC2JlZm9yZUxpbWl0Eh8KC2FmdGVyX2xpbWl0'
    'GAMgASgFUgphZnRlckxpbWl0EicKD2luY2x1ZGVfZGVsZXRlZBgEIAEoCFIOaW5jbHVkZURlbG'
    'V0ZWQ=');

@$core.Deprecated('Use getChatMessageContextResponseDescriptor instead')
const GetChatMessageContextResponse$json = {
  '1': 'GetChatMessageContextResponse',
  '2': [
    {
      '1': 'before',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'before'
    },
    {
      '1': 'message',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'message'
    },
    {
      '1': 'after',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'after'
    },
  ],
};

/// Descriptor for `GetChatMessageContextResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatMessageContextResponseDescriptor = $convert.base64Decode(
    'Ch1HZXRDaGF0TWVzc2FnZUNvbnRleHRSZXNwb25zZRI5CgZiZWZvcmUYASADKAsyIS5zeW5jdH'
    'YuY2xpZW50LkNoYXRNZXNzYWdlUmVjZWl2ZVIGYmVmb3JlEjsKB21lc3NhZ2UYAiABKAsyIS5z'
    'eW5jdHYuY2xpZW50LkNoYXRNZXNzYWdlUmVjZWl2ZVIHbWVzc2FnZRI3CgVhZnRlchgDIAMoCz'
    'IhLnN5bmN0di5jbGllbnQuQ2hhdE1lc3NhZ2VSZWNlaXZlUgVhZnRlcg==');

@$core.Deprecated('Use getChatPlaybackMessagesRequestDescriptor instead')
const GetChatPlaybackMessagesRequest$json = {
  '1': 'GetChatPlaybackMessagesRequest',
  '2': [
    {'1': 'playback_media_id', '3': 1, '4': 1, '5': 9, '10': 'playbackMediaId'},
    {
      '1': 'playback_playlist_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'playbackPlaylistId'
    },
    {'1': 'playback_target', '3': 3, '4': 1, '5': 12, '10': 'playbackTarget'},
    {'1': 'position_seconds', '3': 4, '4': 1, '5': 1, '10': 'positionSeconds'},
    {'1': 'before_seconds', '3': 5, '4': 1, '5': 1, '10': 'beforeSeconds'},
    {'1': 'after_seconds', '3': 6, '4': 1, '5': 1, '10': 'afterSeconds'},
    {'1': 'limit', '3': 7, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'include_deleted', '3': 8, '4': 1, '5': 8, '10': 'includeDeleted'},
  ],
};

/// Descriptor for `GetChatPlaybackMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatPlaybackMessagesRequestDescriptor = $convert.base64Decode(
    'Ch5HZXRDaGF0UGxheWJhY2tNZXNzYWdlc1JlcXVlc3QSKgoRcGxheWJhY2tfbWVkaWFfaWQYAS'
    'ABKAlSD3BsYXliYWNrTWVkaWFJZBIwChRwbGF5YmFja19wbGF5bGlzdF9pZBgCIAEoCVIScGxh'
    'eWJhY2tQbGF5bGlzdElkEicKD3BsYXliYWNrX3RhcmdldBgDIAEoDFIOcGxheWJhY2tUYXJnZX'
    'QSKQoQcG9zaXRpb25fc2Vjb25kcxgEIAEoAVIPcG9zaXRpb25TZWNvbmRzEiUKDmJlZm9yZV9z'
    'ZWNvbmRzGAUgASgBUg1iZWZvcmVTZWNvbmRzEiMKDWFmdGVyX3NlY29uZHMYBiABKAFSDGFmdG'
    'VyU2Vjb25kcxIUCgVsaW1pdBgHIAEoBVIFbGltaXQSJwoPaW5jbHVkZV9kZWxldGVkGAggASgI'
    'Ug5pbmNsdWRlRGVsZXRlZA==');

@$core.Deprecated('Use getChatPlaybackMessagesResponseDescriptor instead')
const GetChatPlaybackMessagesResponse$json = {
  '1': 'GetChatPlaybackMessagesResponse',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '10': 'messages'
    },
  ],
};

/// Descriptor for `GetChatPlaybackMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatPlaybackMessagesResponseDescriptor =
    $convert.base64Decode(
        'Ch9HZXRDaGF0UGxheWJhY2tNZXNzYWdlc1Jlc3BvbnNlEj0KCG1lc3NhZ2VzGAEgAygLMiEuc3'
        'luY3R2LmNsaWVudC5DaGF0TWVzc2FnZVJlY2VpdmVSCG1lc3NhZ2Vz');

@$core.Deprecated('Use chatReadStateDescriptor instead')
const ChatReadState$json = {
  '1': 'ChatReadState',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'last_read_message_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'lastReadMessageId'
    },
    {
      '1': 'last_read_event_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'lastReadEventId'
    },
    {
      '1': 'last_read_event_sequence',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'lastReadEventSequence'
    },
    {'1': 'updated_at', '3': 6, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `ChatReadState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatReadStateDescriptor = $convert.base64Decode(
    'Cg1DaGF0UmVhZFN0YXRlEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIXCgd1c2VyX2lkGAIgAS'
    'gJUgZ1c2VySWQSLwoUbGFzdF9yZWFkX21lc3NhZ2VfaWQYAyABKAlSEWxhc3RSZWFkTWVzc2Fn'
    'ZUlkEisKEmxhc3RfcmVhZF9ldmVudF9pZBgEIAEoCVIPbGFzdFJlYWRFdmVudElkEjcKGGxhc3'
    'RfcmVhZF9ldmVudF9zZXF1ZW5jZRgFIAEoA1IVbGFzdFJlYWRFdmVudFNlcXVlbmNlEh0KCnVw'
    'ZGF0ZWRfYXQYBiABKANSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use markChatReadRequestDescriptor instead')
const MarkChatReadRequest$json = {
  '1': 'MarkChatReadRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
  ],
};

/// Descriptor for `MarkChatReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markChatReadRequestDescriptor = $convert.base64Decode(
    'ChNNYXJrQ2hhdFJlYWRSZXF1ZXN0Eh0KCm1lc3NhZ2VfaWQYASABKAlSCW1lc3NhZ2VJZA==');

@$core.Deprecated('Use getChatReadStateRequestDescriptor instead')
const GetChatReadStateRequest$json = {
  '1': 'GetChatReadStateRequest',
};

/// Descriptor for `GetChatReadStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatReadStateRequestDescriptor =
    $convert.base64Decode('ChdHZXRDaGF0UmVhZFN0YXRlUmVxdWVzdA==');

@$core.Deprecated('Use chatReadStateResponseDescriptor instead')
const ChatReadStateResponse$json = {
  '1': 'ChatReadStateResponse',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatReadState',
      '10': 'state'
    },
    {'1': 'unread_count', '3': 2, '4': 1, '5': 3, '10': 'unreadCount'},
  ],
};

/// Descriptor for `ChatReadStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatReadStateResponseDescriptor = $convert.base64Decode(
    'ChVDaGF0UmVhZFN0YXRlUmVzcG9uc2USMgoFc3RhdGUYASABKAsyHC5zeW5jdHYuY2xpZW50Lk'
    'NoYXRSZWFkU3RhdGVSBXN0YXRlEiEKDHVucmVhZF9jb3VudBgCIAEoA1ILdW5yZWFkQ291bnQ=');

@$core.Deprecated('Use chatMessageReadReceiptUserDescriptor instead')
const ChatMessageReadReceiptUser$json = {
  '1': 'ChatMessageReadReceiptUser',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPublicView',
      '10': 'user'
    },
    {'1': 'read_at', '3': 2, '4': 1, '5': 3, '10': 'readAt'},
  ],
};

/// Descriptor for `ChatMessageReadReceiptUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageReadReceiptUserDescriptor =
    $convert.base64Decode(
        'ChpDaGF0TWVzc2FnZVJlYWRSZWNlaXB0VXNlchIxCgR1c2VyGAEgASgLMh0uc3luY3R2LmNsaW'
        'VudC5Vc2VyUHVibGljVmlld1IEdXNlchIXCgdyZWFkX2F0GAIgASgDUgZyZWFkQXQ=');

@$core.Deprecated('Use chatMessageUnreadMemberDescriptor instead')
const ChatMessageUnreadMember$json = {
  '1': 'ChatMessageUnreadMember',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserPublicView',
      '10': 'user'
    },
  ],
};

/// Descriptor for `ChatMessageUnreadMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageUnreadMemberDescriptor =
    $convert.base64Decode(
        'ChdDaGF0TWVzc2FnZVVucmVhZE1lbWJlchIxCgR1c2VyGAEgASgLMh0uc3luY3R2LmNsaWVudC'
        '5Vc2VyUHVibGljVmlld1IEdXNlcg==');

@$core.Deprecated('Use getChatMessageReadReceiptsRequestDescriptor instead')
const GetChatMessageReadReceiptsRequest$json = {
  '1': 'GetChatMessageReadReceiptsRequest',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetChatMessageReadReceiptsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatMessageReadReceiptsRequestDescriptor =
    $convert.base64Decode(
        'CiFHZXRDaGF0TWVzc2FnZVJlYWRSZWNlaXB0c1JlcXVlc3QSHQoKbWVzc2FnZV9pZBgBIAEoCV'
        'IJbWVzc2FnZUlkEhIKBHBhZ2UYAiABKAVSBHBhZ2USGwoJcGFnZV9zaXplGAMgASgFUghwYWdl'
        'U2l6ZQ==');

@$core.Deprecated('Use getChatMessageReadReceiptsResponseDescriptor instead')
const GetChatMessageReadReceiptsResponse$json = {
  '1': 'GetChatMessageReadReceiptsResponse',
  '2': [
    {
      '1': 'readers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMessageReadReceiptUser',
      '10': 'readers'
    },
    {
      '1': 'unread_members',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.ChatMessageUnreadMember',
      '10': 'unreadMembers'
    },
    {'1': 'reader_total', '3': 3, '4': 1, '5': 3, '10': 'readerTotal'},
    {'1': 'unread_total', '3': 4, '4': 1, '5': 3, '10': 'unreadTotal'},
  ],
};

/// Descriptor for `GetChatMessageReadReceiptsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatMessageReadReceiptsResponseDescriptor =
    $convert.base64Decode(
        'CiJHZXRDaGF0TWVzc2FnZVJlYWRSZWNlaXB0c1Jlc3BvbnNlEkMKB3JlYWRlcnMYASADKAsyKS'
        '5zeW5jdHYuY2xpZW50LkNoYXRNZXNzYWdlUmVhZFJlY2VpcHRVc2VyUgdyZWFkZXJzEk0KDnVu'
        'cmVhZF9tZW1iZXJzGAIgAygLMiYuc3luY3R2LmNsaWVudC5DaGF0TWVzc2FnZVVucmVhZE1lbW'
        'JlclINdW5yZWFkTWVtYmVycxIhCgxyZWFkZXJfdG90YWwYAyABKANSC3JlYWRlclRvdGFsEiEK'
        'DHVucmVhZF90b3RhbBgEIAEoA1ILdW5yZWFkVG90YWw=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor =
    $convert.base64Decode('Cg1Mb2dvdXRSZXF1ZXN0');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert.base64Decode(
    'Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAi'
    'ABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use setUsernameRequestDescriptor instead')
const SetUsernameRequest$json = {
  '1': 'SetUsernameRequest',
  '2': [
    {'1': 'new_username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'newUsername'},
  ],
};

/// Descriptor for `SetUsernameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setUsernameRequestDescriptor = $convert.base64Decode(
    'ChJTZXRVc2VybmFtZVJlcXVlc3QSPwoMbmV3X3VzZXJuYW1lGAEgASgJQhy6SBlyFxADGCAyEV'
    '5bXHB7TH1ccHtOfV8tXSskUgtuZXdVc2VybmFtZQ==');

@$core.Deprecated('Use setUsernameResponseDescriptor instead')
const SetUsernameResponse$json = {
  '1': 'SetUsernameResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `SetUsernameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setUsernameResponseDescriptor = $convert.base64Decode(
    'ChNTZXRVc2VybmFtZVJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5zeW5jdHYuY2xpZW50LlVzZX'
    'JSBHVzZXI=');

@$core.Deprecated('Use startEmailBindRequestDescriptor instead')
const StartEmailBindRequest$json = {
  '1': 'StartEmailBindRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'email'},
  ],
};

/// Descriptor for `StartEmailBindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startEmailBindRequestDescriptor = $convert.base64Decode(
    'ChVTdGFydEVtYWlsQmluZFJlcXVlc3QSIgoFZW1haWwYASABKAlCDLpICXIHEAMY/gFgAVIFZW'
    '1haWw=');

@$core.Deprecated('Use startEmailBindResponseDescriptor instead')
const StartEmailBindResponse$json = {
  '1': 'StartEmailBindResponse',
  '2': [
    {'1': 'masked_email', '3': 1, '4': 1, '5': 9, '10': 'maskedEmail'},
  ],
};

/// Descriptor for `StartEmailBindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startEmailBindResponseDescriptor =
    $convert.base64Decode(
        'ChZTdGFydEVtYWlsQmluZFJlc3BvbnNlEiEKDG1hc2tlZF9lbWFpbBgBIAEoCVILbWFza2VkRW'
        '1haWw=');

@$core.Deprecated('Use confirmEmailBindRequestDescriptor instead')
const ConfirmEmailBindRequest$json = {
  '1': 'ConfirmEmailBindRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'token'},
    {
      '1': 'verification_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'verificationId'
    },
  ],
};

/// Descriptor for `ConfirmEmailBindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmEmailBindRequestDescriptor = $convert.base64Decode(
    'ChdDb25maXJtRW1haWxCaW5kUmVxdWVzdBIiCgVlbWFpbBgBIAEoCUIMukgJcgcQAxj+AWABUg'
    'VlbWFpbBIgCgV0b2tlbhgCIAEoCUIKukgHcgUQARj/AVIFdG9rZW4SMwoPdmVyaWZpY2F0aW9u'
    'X2lkGAMgASgJQgq6SAdyBRABGIABUg52ZXJpZmljYXRpb25JZA==');

@$core.Deprecated('Use confirmEmailBindResponseDescriptor instead')
const ConfirmEmailBindResponse$json = {
  '1': 'ConfirmEmailBindResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `ConfirmEmailBindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmEmailBindResponseDescriptor =
    $convert.base64Decode(
        'ChhDb25maXJtRW1haWxCaW5kUmVzcG9uc2USJwoEdXNlchgBIAEoCzITLnN5bmN0di5jbGllbn'
        'QuVXNlclIEdXNlcg==');

@$core.Deprecated('Use unbindEmailRequestDescriptor instead')
const UnbindEmailRequest$json = {
  '1': 'UnbindEmailRequest',
  '2': [
    {
      '1': 'verification_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'verificationId'
    },
  ],
};

/// Descriptor for `UnbindEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbindEmailRequestDescriptor = $convert.base64Decode(
    'ChJVbmJpbmRFbWFpbFJlcXVlc3QSMwoPdmVyaWZpY2F0aW9uX2lkGAEgASgJQgq6SAdyBRABGI'
    'ABUg52ZXJpZmljYXRpb25JZA==');

@$core.Deprecated('Use unbindEmailResponseDescriptor instead')
const UnbindEmailResponse$json = {
  '1': 'UnbindEmailResponse',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.User',
      '10': 'user'
    },
  ],
};

/// Descriptor for `UnbindEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbindEmailResponseDescriptor = $convert.base64Decode(
    'ChNVbmJpbmRFbWFpbFJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5zeW5jdHYuY2xpZW50LlVzZX'
    'JSBHVzZXI=');

@$core.Deprecated('Use listMyRoomsRequestDescriptor instead')
const ListMyRoomsRequest$json = {
  '1': 'ListMyRoomsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'search', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomStatus',
      '8': {},
      '10': 'status'
    },
    {
      '1': 'is_banned',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isBanned',
      '17': true
    },
    {
      '1': 'relation',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.MyRoomRelation',
      '8': {},
      '10': 'relation'
    },
    {
      '1': 'sort_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.MyRoomListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
  '8': [
    {'1': '_is_banned'},
  ],
};

/// Descriptor for `ListMyRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyRoomsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0TXlSb29tc1JlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIbCglwYWdlX3NpemUYAi'
    'ABKAVSCHBhZ2VTaXplEh8KBnNlYXJjaBgDIAEoCUIHukgEcgIYZFIGc2VhcmNoEjsKBnN0YXR1'
    'cxgEIAEoDjIZLnN5bmN0di5jb21tb24uUm9vbVN0YXR1c0IIukgFggECEAFSBnN0YXR1cxIgCg'
    'lpc19iYW5uZWQYBSABKAhIAFIIaXNCYW5uZWSIAQESQwoIcmVsYXRpb24YBiABKA4yHS5zeW5j'
    'dHYuY2xpZW50Lk15Um9vbVJlbGF0aW9uQgi6SAWCAQIQAVIIcmVsYXRpb24SQgoHc29ydF9ieR'
    'gHIAEoDjIfLnN5bmN0di5jbGllbnQuTXlSb29tTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRC'
    'eRJNCg5zb3J0X2RpcmVjdGlvbhgIIAEoDjIcLnN5bmN0di5jbGllbnQuU29ydERpcmVjdGlvbk'
    'IIukgFggECEAFSDXNvcnREaXJlY3Rpb246gwK6SP8BGmIKEmxpc3RfbXlfcm9vbXMucGFnZRIq'
    'cGFnZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBhdCBsZWFzdCAxGiB0aGlzLnBhZ2UgPT'
    '0gMCB8fCB0aGlzLnBhZ2UgPj0gMRqYAQoXbGlzdF9teV9yb29tcy5wYWdlX3NpemUSNnBhZ2Vf'
    'c2l6ZSBtdXN0IGJlIDAgKHVzZSBkZWZhdWx0KSBvciBiZXR3ZWVuIDEgYW5kIDEwMBpFdGhpcy'
    '5wYWdlX3NpemUgPT0gMCB8fCAodGhpcy5wYWdlX3NpemUgPj0gMSAmJiB0aGlzLnBhZ2Vfc2l6'
    'ZSA8PSAxMDApQgwKCl9pc19iYW5uZWQ=');

@$core.Deprecated('Use listMyRoomsResponseDescriptor instead')
const ListMyRoomsResponse$json = {
  '1': 'ListMyRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.MyRoom',
      '10': 'rooms'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
  ],
};

/// Descriptor for `ListMyRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMyRoomsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0TXlSb29tc1Jlc3BvbnNlEisKBXJvb21zGAEgAygLMhUuc3luY3R2LmNsaWVudC5NeV'
    'Jvb21SBXJvb21zEhQKBXRvdGFsGAIgASgFUgV0b3RhbA==');

@$core.Deprecated('Use myRoomDescriptor instead')
const MyRoom$json = {
  '1': 'MyRoom',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
    {'1': 'permissions', '3': 2, '4': 1, '5': 4, '10': 'permissions'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {
      '1': 'relation',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.MyRoomRelation',
      '10': 'relation'
    },
  ],
};

/// Descriptor for `MyRoom`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List myRoomDescriptor = $convert.base64Decode(
    'CgZNeVJvb20SJwoEcm9vbRgBIAEoCzITLnN5bmN0di5jbGllbnQuUm9vbVIEcm9vbRIgCgtwZX'
    'JtaXNzaW9ucxgCIAEoBFILcGVybWlzc2lvbnMSMQoEcm9sZRgDIAEoDjIdLnN5bmN0di5jb21t'
    'b24uUm9vbU1lbWJlclJvbGVSBHJvbGUSOQoIcmVsYXRpb24YBCABKA4yHS5zeW5jdHYuY2xpZW'
    '50Lk15Um9vbVJlbGF0aW9uUghyZWxhdGlvbg==');

@$core.Deprecated('Use checkRoomRequestDescriptor instead')
const CheckRoomRequest$json = {
  '1': 'CheckRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `CheckRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRoomRequestDescriptor = $convert.base64Decode(
    'ChBDaGVja1Jvb21SZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQDITXnJvb21fW0'
    'EtWmEtejAtOV0rJFIGcm9vbUlk');

@$core.Deprecated('Use roomMemberTargetPathRequestDescriptor instead')
const RoomMemberTargetPathRequest$json = {
  '1': 'RoomMemberTargetPathRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'userId'},
  ],
};

/// Descriptor for `RoomMemberTargetPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMemberTargetPathRequestDescriptor =
    $convert.base64Decode(
        'ChtSb29tTWVtYmVyVGFyZ2V0UGF0aFJlcXVlc3QSNwoHcm9vbV9pZBgBIAEoCUIeukgbchkQAR'
        'hAMhNecm9vbV9bQS1aYS16MC05XSskUgZyb29tSWQSNgoHdXNlcl9pZBgCIAEoCUIdukgachgQ'
        'ARhAMhJedXNyX1tBLVphLXowLTldKyRSBnVzZXJJZA==');

@$core.Deprecated('Use roomJoinReviewPathRequestDescriptor instead')
const RoomJoinReviewPathRequest$json = {
  '1': 'RoomJoinReviewPathRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'requestId'},
  ],
};

/// Descriptor for `RoomJoinReviewPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomJoinReviewPathRequestDescriptor = $convert.base64Decode(
    'ChlSb29tSm9pblJldmlld1BhdGhSZXF1ZXN0EjcKB3Jvb21faWQYASABKAlCHrpIG3IZEAEYQD'
    'ITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlkEjwKCnJlcXVlc3RfaWQYAiABKAlCHbpIGnIY'
    'EAEYQDISXnJldl9bQS1aYS16MC05XSskUglyZXF1ZXN0SWQ=');

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

@$core.Deprecated('Use roomMediaTargetPathRequestDescriptor instead')
const RoomMediaTargetPathRequest$json = {
  '1': 'RoomMediaTargetPathRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `RoomMediaTargetPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMediaTargetPathRequestDescriptor =
    $convert.base64Decode(
        'ChpSb29tTWVkaWFUYXJnZXRQYXRoUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGRABGE'
        'AyE15yb29tX1tBLVphLXowLTldKyRSBnJvb21JZBI4CghtZWRpYV9pZBgCIAEoCUIdukgachgQ'
        'ARhAMhJebWVkX1tBLVphLXowLTldKyRSB21lZGlhSWQ=');

@$core.Deprecated('Use roomPlaylistTargetPathRequestDescriptor instead')
const RoomPlaylistTargetPathRequest$json = {
  '1': 'RoomPlaylistTargetPathRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'playlistId'},
  ],
};

/// Descriptor for `RoomPlaylistTargetPathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomPlaylistTargetPathRequestDescriptor =
    $convert.base64Decode(
        'Ch1Sb29tUGxheWxpc3RUYXJnZXRQYXRoUmVxdWVzdBI3Cgdyb29tX2lkGAEgASgJQh66SBtyGR'
        'ABGEAyE15yb29tX1tBLVphLXowLTldKyRSBnJvb21JZBI9CgtwbGF5bGlzdF9pZBgCIAEoCUIc'
        'ukgZchcQARhAMhFecGxfW0EtWmEtejAtOV0rJFIKcGxheWxpc3RJZA==');

@$core.Deprecated('Use checkRoomResponseDescriptor instead')
const CheckRoomResponse$json = {
  '1': 'CheckRoomResponse',
  '2': [
    {'1': 'exists', '3': 1, '4': 1, '5': 8, '10': 'exists'},
    {
      '1': 'requires_password',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'requiresPassword'
    },
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'availability',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceAvailability',
      '10': 'availability'
    },
  ],
};

/// Descriptor for `CheckRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRoomResponseDescriptor = $convert.base64Decode(
    'ChFDaGVja1Jvb21SZXNwb25zZRIWCgZleGlzdHMYASABKAhSBmV4aXN0cxIrChFyZXF1aXJlc1'
    '9wYXNzd29yZBgCIAEoCFIQcmVxdWlyZXNQYXNzd29yZBISCgRuYW1lGAMgASgJUgRuYW1lEkcK'
    'DGF2YWlsYWJpbGl0eRgEIAEoDjIjLnN5bmN0di5jbGllbnQuUmVzb3VyY2VBdmFpbGFiaWxpdH'
    'lSDGF2YWlsYWJpbGl0eQ==');

@$core.Deprecated('Use getHotRoomsRequestDescriptor instead')
const GetHotRoomsRequest$json = {
  '1': 'GetHotRoomsRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
  '7': {},
};

/// Descriptor for `GetHotRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHotRoomsRequestDescriptor = $convert.base64Decode(
    'ChJHZXRIb3RSb29tc1JlcXVlc3QSFAoFbGltaXQYASABKAVSBWxpbWl0OokBukiFARqCAQoTZ2'
    'V0X2hvdF9yb29tcy5saW1pdBIxbGltaXQgbXVzdCBiZSAwICh1c2UgZGVmYXVsdCkgb3IgYmV0'
    'd2VlbiAxIGFuZCA1MBo4dGhpcy5saW1pdCA9PSAwIHx8ICh0aGlzLmxpbWl0ID49IDEgJiYgdG'
    'hpcy5saW1pdCA8PSA1MCk=');

@$core.Deprecated('Use getHotRoomsResponseDescriptor instead')
const GetHotRoomsResponse$json = {
  '1': 'GetHotRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.RoomWithStats',
      '10': 'rooms'
    },
  ],
};

/// Descriptor for `GetHotRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHotRoomsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRIb3RSb29tc1Jlc3BvbnNlEjIKBXJvb21zGAEgAygLMhwuc3luY3R2LmNsaWVudC5Sb2'
    '9tV2l0aFN0YXRzUgVyb29tcw==');

@$core.Deprecated('Use roomWithStatsDescriptor instead')
const RoomWithStats$json = {
  '1': 'RoomWithStats',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Room',
      '10': 'room'
    },
    {'1': 'online_count', '3': 2, '4': 1, '5': 5, '10': 'onlineCount'},
    {'1': 'total_members', '3': 3, '4': 1, '5': 5, '10': 'totalMembers'},
  ],
};

/// Descriptor for `RoomWithStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomWithStatsDescriptor = $convert.base64Decode(
    'Cg1Sb29tV2l0aFN0YXRzEicKBHJvb20YASABKAsyEy5zeW5jdHYuY2xpZW50LlJvb21SBHJvb2'
    '0SIQoMb25saW5lX2NvdW50GAIgASgFUgtvbmxpbmVDb3VudBIjCg10b3RhbF9tZW1iZXJzGAMg'
    'ASgFUgx0b3RhbE1lbWJlcnM=');

@$core.Deprecated('Use getPublicSettingsRequestDescriptor instead')
const GetPublicSettingsRequest$json = {
  '1': 'GetPublicSettingsRequest',
};

/// Descriptor for `GetPublicSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPublicSettingsRequestDescriptor =
    $convert.base64Decode('ChhHZXRQdWJsaWNTZXR0aW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use getPublicSettingsResponseDescriptor instead')
const GetPublicSettingsResponse$json = {
  '1': 'GetPublicSettingsResponse',
  '2': [
    {
      '1': 'allow_room_creation',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'allowRoomCreation'
    },
    {
      '1': 'max_rooms_per_user',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'maxRoomsPerUser'
    },
    {
      '1': 'max_members_per_room',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'maxMembersPerRoom'
    },
    {
      '1': 'disable_create_room',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'disableCreateRoom'
    },
    {
      '1': 'create_room_need_review',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'createRoomNeedReview'
    },
    {
      '1': 'room_password_policy',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'roomPasswordPolicy'
    },
    {
      '1': 'enable_password_signup',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'enablePasswordSignup'
    },
    {
      '1': 'password_signup_need_review',
      '3': 16,
      '4': 1,
      '5': 8,
      '10': 'passwordSignupNeedReview'
    },
    {
      '1': 'enable_email_signup',
      '3': 17,
      '4': 1,
      '5': 8,
      '10': 'enableEmailSignup'
    },
    {'1': 'enable_guest', '3': 18, '4': 1, '5': 8, '10': 'enableGuest'},
    {
      '1': 'email_signup_need_review',
      '3': 19,
      '4': 1,
      '5': 8,
      '10': 'emailSignupNeedReview'
    },
    {'1': 'enable_email', '3': 24, '4': 1, '5': 8, '10': 'enableEmail'},
    {'1': 'enable_webauthn', '3': 25, '4': 1, '5': 8, '10': 'enableWebauthn'},
    {
      '1': 'enable_webauthn_signup',
      '3': 22,
      '4': 1,
      '5': 8,
      '10': 'enableWebauthnSignup'
    },
    {
      '1': 'webauthn_signup_need_review',
      '3': 23,
      '4': 1,
      '5': 8,
      '10': 'webauthnSignupNeedReview'
    },
    {'1': 'movie_proxy', '3': 11, '4': 1, '5': 8, '10': 'movieProxy'},
    {'1': 'live_proxy', '3': 12, '4': 1, '5': 8, '10': 'liveProxy'},
    {
      '1': 'ts_disguised_as_png',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'tsDisguisedAsPng'
    },
    {
      '1': 'custom_publish_host',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'customPublishHost'
    },
    {
      '1': 'email_whitelist_enabled',
      '3': 15,
      '4': 1,
      '5': 8,
      '10': 'emailWhitelistEnabled'
    },
    {
      '1': 'email_whitelist_domains',
      '3': 26,
      '4': 3,
      '5': 9,
      '10': 'emailWhitelistDomains'
    },
  ],
};

/// Descriptor for `GetPublicSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPublicSettingsResponseDescriptor = $convert.base64Decode(
    'ChlHZXRQdWJsaWNTZXR0aW5nc1Jlc3BvbnNlEi4KE2FsbG93X3Jvb21fY3JlYXRpb24YAiABKA'
    'hSEWFsbG93Um9vbUNyZWF0aW9uEisKEm1heF9yb29tc19wZXJfdXNlchgDIAEoA1IPbWF4Um9v'
    'bXNQZXJVc2VyEi8KFG1heF9tZW1iZXJzX3Blcl9yb29tGAQgASgDUhFtYXhNZW1iZXJzUGVyUm'
    '9vbRIuChNkaXNhYmxlX2NyZWF0ZV9yb29tGAUgASgIUhFkaXNhYmxlQ3JlYXRlUm9vbRI1Chdj'
    'cmVhdGVfcm9vbV9uZWVkX3JldmlldxgGIAEoCFIUY3JlYXRlUm9vbU5lZWRSZXZpZXcSMAoUcm'
    '9vbV9wYXNzd29yZF9wb2xpY3kYCCABKAlSEnJvb21QYXNzd29yZFBvbGljeRI0ChZlbmFibGVf'
    'cGFzc3dvcmRfc2lnbnVwGAogASgIUhRlbmFibGVQYXNzd29yZFNpZ251cBI9ChtwYXNzd29yZF'
    '9zaWdudXBfbmVlZF9yZXZpZXcYECABKAhSGHBhc3N3b3JkU2lnbnVwTmVlZFJldmlldxIuChNl'
    'bmFibGVfZW1haWxfc2lnbnVwGBEgASgIUhFlbmFibGVFbWFpbFNpZ251cBIhCgxlbmFibGVfZ3'
    'Vlc3QYEiABKAhSC2VuYWJsZUd1ZXN0EjcKGGVtYWlsX3NpZ251cF9uZWVkX3JldmlldxgTIAEo'
    'CFIVZW1haWxTaWdudXBOZWVkUmV2aWV3EiEKDGVuYWJsZV9lbWFpbBgYIAEoCFILZW5hYmxlRW'
    '1haWwSJwoPZW5hYmxlX3dlYmF1dGhuGBkgASgIUg5lbmFibGVXZWJhdXRobhI0ChZlbmFibGVf'
    'd2ViYXV0aG5fc2lnbnVwGBYgASgIUhRlbmFibGVXZWJhdXRoblNpZ251cBI9Cht3ZWJhdXRobl'
    '9zaWdudXBfbmVlZF9yZXZpZXcYFyABKAhSGHdlYmF1dGhuU2lnbnVwTmVlZFJldmlldxIfCgtt'
    'b3ZpZV9wcm94eRgLIAEoCFIKbW92aWVQcm94eRIdCgpsaXZlX3Byb3h5GAwgASgIUglsaXZlUH'
    'JveHkSLQoTdHNfZGlzZ3Vpc2VkX2FzX3BuZxgNIAEoCFIQdHNEaXNndWlzZWRBc1BuZxIuChNj'
    'dXN0b21fcHVibGlzaF9ob3N0GA4gASgJUhFjdXN0b21QdWJsaXNoSG9zdBI2ChdlbWFpbF93aG'
    'l0ZWxpc3RfZW5hYmxlZBgPIAEoCFIVZW1haWxXaGl0ZWxpc3RFbmFibGVkEjYKF2VtYWlsX3do'
    'aXRlbGlzdF9kb21haW5zGBogAygJUhVlbWFpbFdoaXRlbGlzdERvbWFpbnM=');

@$core.Deprecated('Use getServerInfoRequestDescriptor instead')
const GetServerInfoRequest$json = {
  '1': 'GetServerInfoRequest',
};

/// Descriptor for `GetServerInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerInfoRequestDescriptor =
    $convert.base64Decode('ChRHZXRTZXJ2ZXJJbmZvUmVxdWVzdA==');

@$core.Deprecated('Use getServerInfoResponseDescriptor instead')
const GetServerInfoResponse$json = {
  '1': 'GetServerInfoResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'server_name', '3': 2, '4': 1, '5': 9, '10': 'serverName'},
  ],
};

/// Descriptor for `GetServerInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServerInfoResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTZXJ2ZXJJbmZvUmVzcG9uc2USGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZBIfCg'
    'tzZXJ2ZXJfbmFtZRgCIAEoCVIKc2VydmVyTmFtZQ==');

@$core.Deprecated('Use requestPasswordResetRequestDescriptor instead')
const RequestPasswordResetRequest$json = {
  '1': 'RequestPasswordResetRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `RequestPasswordResetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPasswordResetRequestDescriptor =
    $convert.base64Decode(
        'ChtSZXF1ZXN0UGFzc3dvcmRSZXNldFJlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWls');

@$core.Deprecated('Use requestPasswordResetResponseDescriptor instead')
const RequestPasswordResetResponse$json = {
  '1': 'RequestPasswordResetResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RequestPasswordResetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPasswordResetResponseDescriptor =
    $convert.base64Decode(
        'ChxSZXF1ZXN0UGFzc3dvcmRSZXNldFJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2'
        'U=');

@$core.Deprecated('Use startOpaquePasswordResetRequestDescriptor instead')
const StartOpaquePasswordResetRequest$json = {
  '1': 'StartOpaquePasswordResetRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'token'},
    {
      '1': 'registration_request',
      '3': 3,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationRequest'
    },
  ],
};

/// Descriptor for `StartOpaquePasswordResetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaquePasswordResetRequestDescriptor =
    $convert.base64Decode(
        'Ch9TdGFydE9wYXF1ZVBhc3N3b3JkUmVzZXRSZXF1ZXN0EiAKBWVtYWlsGAEgASgJQgq6SAdyBR'
        'ABGP4BUgVlbWFpbBIgCgV0b2tlbhgCIAEoCUIKukgHcgUQARj/AVIFdG9rZW4SPQoUcmVnaXN0'
        'cmF0aW9uX3JlcXVlc3QYAyABKAxCCrpIB3oFEAEYgCBSE3JlZ2lzdHJhdGlvblJlcXVlc3Q=');

@$core.Deprecated('Use startOpaquePasswordResetResponseDescriptor instead')
const StartOpaquePasswordResetResponse$json = {
  '1': 'StartOpaquePasswordResetResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'registration_response',
      '3': 2,
      '4': 1,
      '5': 12,
      '10': 'registrationResponse'
    },
  ],
};

/// Descriptor for `StartOpaquePasswordResetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaquePasswordResetResponseDescriptor =
    $convert.base64Decode(
        'CiBTdGFydE9wYXF1ZVBhc3N3b3JkUmVzZXRSZXNwb25zZRIpCgpzZXNzaW9uX2lkGAEgASgJQg'
        'q6SAdyBRABGIABUglzZXNzaW9uSWQSMwoVcmVnaXN0cmF0aW9uX3Jlc3BvbnNlGAIgASgMUhRy'
        'ZWdpc3RyYXRpb25SZXNwb25zZQ==');

@$core.Deprecated('Use finishOpaquePasswordResetRequestDescriptor instead')
const FinishOpaquePasswordResetRequest$json = {
  '1': 'FinishOpaquePasswordResetRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'sessionId'},
    {
      '1': 'registration_upload',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'registrationUpload'
    },
  ],
};

/// Descriptor for `FinishOpaquePasswordResetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishOpaquePasswordResetRequestDescriptor =
    $convert.base64Decode(
        'CiBGaW5pc2hPcGFxdWVQYXNzd29yZFJlc2V0UmVxdWVzdBIpCgpzZXNzaW9uX2lkGAEgASgJQg'
        'q6SAdyBRABGIABUglzZXNzaW9uSWQSOwoTcmVnaXN0cmF0aW9uX3VwbG9hZBgCIAEoDEIKukgH'
        'egUQARiAIFIScmVnaXN0cmF0aW9uVXBsb2Fk');

@$core.Deprecated('Use confirmPasswordResetResponseDescriptor instead')
const ConfirmPasswordResetResponse$json = {
  '1': 'ConfirmPasswordResetResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ConfirmPasswordResetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmPasswordResetResponseDescriptor =
    $convert.base64Decode(
        'ChxDb25maXJtUGFzc3dvcmRSZXNldFJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2'
        'USFwoHdXNlcl9pZBgCIAEoCVIGdXNlcklk');

@$core.Deprecated('Use webRTCOfferDescriptor instead')
const WebRTCOffer$json = {
  '1': 'WebRTCOffer',
  '2': [
    {'1': 'to', '3': 1, '4': 1, '5': 9, '10': 'to'},
    {'1': 'from', '3': 2, '4': 1, '5': 9, '10': 'from'},
    {'1': 'data', '3': 3, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `WebRTCOffer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCOfferDescriptor = $convert.base64Decode(
    'CgtXZWJSVENPZmZlchIOCgJ0bxgBIAEoCVICdG8SEgoEZnJvbRgCIAEoCVIEZnJvbRISCgRkYX'
    'RhGAMgASgJUgRkYXRh');

@$core.Deprecated('Use webRTCAnswerDescriptor instead')
const WebRTCAnswer$json = {
  '1': 'WebRTCAnswer',
  '2': [
    {'1': 'to', '3': 1, '4': 1, '5': 9, '10': 'to'},
    {'1': 'from', '3': 2, '4': 1, '5': 9, '10': 'from'},
    {'1': 'data', '3': 3, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `WebRTCAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCAnswerDescriptor = $convert.base64Decode(
    'CgxXZWJSVENBbnN3ZXISDgoCdG8YASABKAlSAnRvEhIKBGZyb20YAiABKAlSBGZyb20SEgoEZG'
    'F0YRgDIAEoCVIEZGF0YQ==');

@$core.Deprecated('Use webRTCIceCandidateDescriptor instead')
const WebRTCIceCandidate$json = {
  '1': 'WebRTCIceCandidate',
  '2': [
    {'1': 'to', '3': 1, '4': 1, '5': 9, '10': 'to'},
    {'1': 'from', '3': 2, '4': 1, '5': 9, '10': 'from'},
    {'1': 'data', '3': 3, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `WebRTCIceCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCIceCandidateDescriptor = $convert.base64Decode(
    'ChJXZWJSVENJY2VDYW5kaWRhdGUSDgoCdG8YASABKAlSAnRvEhIKBGZyb20YAiABKAlSBGZyb2'
    '0SEgoEZGF0YRgDIAEoCVIEZGF0YQ==');

@$core.Deprecated('Use webRTCJoinDescriptor instead')
const WebRTCJoin$json = {
  '1': 'WebRTCJoin',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'conn_id', '3': 2, '4': 1, '5': 9, '10': 'connId'},
    {'1': 'username', '3': 3, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `WebRTCJoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCJoinDescriptor = $convert.base64Decode(
    'CgpXZWJSVENKb2luEhcKB3VzZXJfaWQYASABKAlSBnVzZXJJZBIXCgdjb25uX2lkGAIgASgJUg'
    'Zjb25uSWQSGgoIdXNlcm5hbWUYAyABKAlSCHVzZXJuYW1l');

@$core.Deprecated('Use webRTCLeaveDescriptor instead')
const WebRTCLeave$json = {
  '1': 'WebRTCLeave',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'conn_id', '3': 2, '4': 1, '5': 9, '10': 'connId'},
  ],
};

/// Descriptor for `WebRTCLeave`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRTCLeaveDescriptor = $convert.base64Decode(
    'CgtXZWJSVENMZWF2ZRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSFwoHY29ubl9pZBgCIAEoCV'
    'IGY29ubklk');

@$core.Deprecated('Use webRtcCommandDescriptor instead')
const WebRtcCommand$json = {
  '1': 'WebRtcCommand',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCOffer',
      '9': 0,
      '10': 'offer'
    },
    {
      '1': 'answer',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCAnswer',
      '9': 0,
      '10': 'answer'
    },
    {
      '1': 'ice_candidate',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCIceCandidate',
      '9': 0,
      '10': 'iceCandidate'
    },
    {
      '1': 'join',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCJoin',
      '9': 0,
      '10': 'join'
    },
    {
      '1': 'leave',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCLeave',
      '9': 0,
      '10': 'leave'
    },
  ],
  '8': [
    {'1': 'command'},
  ],
};

/// Descriptor for `WebRtcCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRtcCommandDescriptor = $convert.base64Decode(
    'Cg1XZWJSdGNDb21tYW5kEjIKBW9mZmVyGAEgASgLMhouc3luY3R2LmNsaWVudC5XZWJSVENPZm'
    'ZlckgAUgVvZmZlchI1CgZhbnN3ZXIYAiABKAsyGy5zeW5jdHYuY2xpZW50LldlYlJUQ0Fuc3dl'
    'ckgAUgZhbnN3ZXISSAoNaWNlX2NhbmRpZGF0ZRgDIAEoCzIhLnN5bmN0di5jbGllbnQuV2ViUl'
    'RDSWNlQ2FuZGlkYXRlSABSDGljZUNhbmRpZGF0ZRIvCgRqb2luGAQgASgLMhkuc3luY3R2LmNs'
    'aWVudC5XZWJSVENKb2luSABSBGpvaW4SMgoFbGVhdmUYBSABKAsyGi5zeW5jdHYuY2xpZW50Ll'
    'dlYlJUQ0xlYXZlSABSBWxlYXZlQgkKB2NvbW1hbmQ=');

@$core.Deprecated('Use webRtcEventDescriptor instead')
const WebRtcEvent$json = {
  '1': 'WebRtcEvent',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCOffer',
      '9': 0,
      '10': 'offer'
    },
    {
      '1': 'answer',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCAnswer',
      '9': 0,
      '10': 'answer'
    },
    {
      '1': 'ice_candidate',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCIceCandidate',
      '9': 0,
      '10': 'iceCandidate'
    },
    {
      '1': 'join',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCJoin',
      '9': 0,
      '10': 'join'
    },
    {
      '1': 'leave',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCLeave',
      '9': 0,
      '10': 'leave'
    },
  ],
  '8': [
    {'1': 'event'},
  ],
};

/// Descriptor for `WebRtcEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRtcEventDescriptor = $convert.base64Decode(
    'CgtXZWJSdGNFdmVudBIyCgVvZmZlchgBIAEoCzIaLnN5bmN0di5jbGllbnQuV2ViUlRDT2ZmZX'
    'JIAFIFb2ZmZXISNQoGYW5zd2VyGAIgASgLMhsuc3luY3R2LmNsaWVudC5XZWJSVENBbnN3ZXJI'
    'AFIGYW5zd2VyEkgKDWljZV9jYW5kaWRhdGUYAyABKAsyIS5zeW5jdHYuY2xpZW50LldlYlJUQ0'
    'ljZUNhbmRpZGF0ZUgAUgxpY2VDYW5kaWRhdGUSLwoEam9pbhgEIAEoCzIZLnN5bmN0di5jbGll'
    'bnQuV2ViUlRDSm9pbkgAUgRqb2luEjIKBWxlYXZlGAUgASgLMhouc3luY3R2LmNsaWVudC5XZW'
    'JSVENMZWF2ZUgAUgVsZWF2ZUIHCgVldmVudA==');

@$core.Deprecated('Use iceServersConfigDescriptor instead')
const IceServersConfig$json = {
  '1': 'IceServersConfig',
  '2': [
    {
      '1': 'servers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.IceServer',
      '10': 'servers'
    },
  ],
};

/// Descriptor for `IceServersConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iceServersConfigDescriptor = $convert.base64Decode(
    'ChBJY2VTZXJ2ZXJzQ29uZmlnEjIKB3NlcnZlcnMYASADKAsyGC5zeW5jdHYuY2xpZW50LkljZV'
    'NlcnZlclIHc2VydmVycw==');

@$core.Deprecated('Use iceServerDescriptor instead')
const IceServer$json = {
  '1': 'IceServer',
  '2': [
    {'1': 'urls', '3': 1, '4': 3, '5': 9, '10': 'urls'},
    {
      '1': 'username',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'username',
      '17': true
    },
    {
      '1': 'credential',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'credential',
      '17': true
    },
  ],
  '8': [
    {'1': '_username'},
    {'1': '_credential'},
  ],
};

/// Descriptor for `IceServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iceServerDescriptor = $convert.base64Decode(
    'CglJY2VTZXJ2ZXISEgoEdXJscxgBIAMoCVIEdXJscxIfCgh1c2VybmFtZRgCIAEoCUgAUgh1c2'
    'VybmFtZYgBARIjCgpjcmVkZW50aWFsGAMgASgJSAFSCmNyZWRlbnRpYWyIAQFCCwoJX3VzZXJu'
    'YW1lQg0KC19jcmVkZW50aWFs');

@$core.Deprecated('Use getIceServersRequestDescriptor instead')
const GetIceServersRequest$json = {
  '1': 'GetIceServersRequest',
};

/// Descriptor for `GetIceServersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIceServersRequestDescriptor =
    $convert.base64Decode('ChRHZXRJY2VTZXJ2ZXJzUmVxdWVzdA==');

@$core.Deprecated('Use getIceServersResponseDescriptor instead')
const GetIceServersResponse$json = {
  '1': 'GetIceServersResponse',
  '2': [
    {
      '1': 'servers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.IceServer',
      '10': 'servers'
    },
    {
      '1': 'webrtc',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRtcStatus',
      '9': 0,
      '10': 'webrtc',
      '17': true
    },
  ],
  '8': [
    {'1': '_webrtc'},
  ],
};

/// Descriptor for `GetIceServersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIceServersResponseDescriptor = $convert.base64Decode(
    'ChVHZXRJY2VTZXJ2ZXJzUmVzcG9uc2USMgoHc2VydmVycxgBIAMoCzIYLnN5bmN0di5jbGllbn'
    'QuSWNlU2VydmVyUgdzZXJ2ZXJzEjgKBndlYnJ0YxgCIAEoCzIbLnN5bmN0di5jbGllbnQuV2Vi'
    'UnRjU3RhdHVzSABSBndlYnJ0Y4gBAUIJCgdfd2VicnRj');

@$core.Deprecated('Use memoryHealthDescriptor instead')
const MemoryHealth$json = {
  '1': 'MemoryHealth',
  '2': [
    {'1': 'usage_percent', '3': 1, '4': 1, '5': 1, '10': 'usagePercent'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `MemoryHealth`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memoryHealthDescriptor = $convert.base64Decode(
    'CgxNZW1vcnlIZWFsdGgSIwoNdXNhZ2VfcGVyY2VudBgBIAEoAVIMdXNhZ2VQZXJjZW50EhYKBn'
    'N0YXR1cxgCIAEoCVIGc3RhdHVz');

@$core.Deprecated('Use webRtcStatusDescriptor instead')
const WebRtcStatus$json = {
  '1': 'WebRtcStatus',
  '2': [
    {'1': 'mode', '3': 1, '4': 1, '5': 9, '10': 'mode'},
    {
      '1': 'builtin_stun_state',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'builtinStunState'
    },
    {
      '1': 'builtin_stun_configured',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'builtinStunConfigured'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'local_addr',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'localAddr',
      '17': true
    },
    {
      '1': 'external_addr',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'externalAddr',
      '17': true
    },
    {
      '1': 'message',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'message',
      '17': true
    },
  ],
  '8': [
    {'1': '_local_addr'},
    {'1': '_external_addr'},
    {'1': '_message'},
  ],
};

/// Descriptor for `WebRtcStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List webRtcStatusDescriptor = $convert.base64Decode(
    'CgxXZWJSdGNTdGF0dXMSEgoEbW9kZRgBIAEoCVIEbW9kZRIsChJidWlsdGluX3N0dW5fc3RhdG'
    'UYAiABKAlSEGJ1aWx0aW5TdHVuU3RhdGUSNgoXYnVpbHRpbl9zdHVuX2NvbmZpZ3VyZWQYAyAB'
    'KAhSFWJ1aWx0aW5TdHVuQ29uZmlndXJlZBIWCgZyZWFzb24YBCABKAlSBnJlYXNvbhIiCgpsb2'
    'NhbF9hZGRyGAUgASgJSABSCWxvY2FsQWRkcogBARIoCg1leHRlcm5hbF9hZGRyGAYgASgJSAFS'
    'DGV4dGVybmFsQWRkcogBARIdCgdtZXNzYWdlGAcgASgJSAJSB21lc3NhZ2WIAQFCDQoLX2xvY2'
    'FsX2FkZHJCEAoOX2V4dGVybmFsX2FkZHJCCgoIX21lc3NhZ2U=');

@$core.Deprecated('Use healthDetailsDescriptor instead')
const HealthDetails$json = {
  '1': 'HealthDetails',
  '2': [
    {'1': 'database', '3': 1, '4': 1, '5': 9, '10': 'database'},
    {'1': 'redis', '3': 2, '4': 1, '5': 9, '10': 'redis'},
    {
      '1': 'cluster',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'cluster',
      '17': true
    },
    {
      '1': 'ws_ticket',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'wsTicket',
      '17': true
    },
    {'1': 'email', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'email', '17': true},
    {
      '1': 'livestream',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'livestream',
      '17': true
    },
    {
      '1': 'memory',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.MemoryHealth',
      '9': 4,
      '10': 'memory',
      '17': true
    },
    {
      '1': 'message',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'message',
      '17': true
    },
    {
      '1': 'webrtc',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRtcStatus',
      '9': 6,
      '10': 'webrtc',
      '17': true
    },
  ],
  '8': [
    {'1': '_cluster'},
    {'1': '_ws_ticket'},
    {'1': '_email'},
    {'1': '_livestream'},
    {'1': '_memory'},
    {'1': '_message'},
    {'1': '_webrtc'},
  ],
};

/// Descriptor for `HealthDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthDetailsDescriptor = $convert.base64Decode(
    'Cg1IZWFsdGhEZXRhaWxzEhoKCGRhdGFiYXNlGAEgASgJUghkYXRhYmFzZRIUCgVyZWRpcxgCIA'
    'EoCVIFcmVkaXMSHQoHY2x1c3RlchgDIAEoCUgAUgdjbHVzdGVyiAEBEiAKCXdzX3RpY2tldBgE'
    'IAEoCUgBUgh3c1RpY2tldIgBARIZCgVlbWFpbBgFIAEoCUgCUgVlbWFpbIgBARIjCgpsaXZlc3'
    'RyZWFtGAYgASgJSANSCmxpdmVzdHJlYW2IAQESOAoGbWVtb3J5GAcgASgLMhsuc3luY3R2LmNs'
    'aWVudC5NZW1vcnlIZWFsdGhIBFIGbWVtb3J5iAEBEh0KB21lc3NhZ2UYCCABKAlIBVIHbWVzc2'
    'FnZYgBARI4CgZ3ZWJydGMYCSABKAsyGy5zeW5jdHYuY2xpZW50LldlYlJ0Y1N0YXR1c0gGUgZ3'
    'ZWJydGOIAQFCCgoIX2NsdXN0ZXJCDAoKX3dzX3RpY2tldEIICgZfZW1haWxCDQoLX2xpdmVzdH'
    'JlYW1CCQoHX21lbW9yeUIKCghfbWVzc2FnZUIJCgdfd2VicnRj');

@$core.Deprecated('Use healthResponseDescriptor instead')
const HealthResponse$json = {
  '1': 'HealthResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'details',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.HealthDetails',
      '9': 0,
      '10': 'details',
      '17': true
    },
  ],
  '8': [
    {'1': '_details'},
  ],
};

/// Descriptor for `HealthResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List healthResponseDescriptor = $convert.base64Decode(
    'Cg5IZWFsdGhSZXNwb25zZRIWCgZzdGF0dXMYASABKAlSBnN0YXR1cxI7CgdkZXRhaWxzGAIgAS'
    'gLMhwuc3luY3R2LmNsaWVudC5IZWFsdGhEZXRhaWxzSABSB2RldGFpbHOIAQFCCgoIX2RldGFp'
    'bHM=');

@$core.Deprecated('Use notificationProtoDescriptor instead')
const NotificationProto$json = {
  '1': 'NotificationProto',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'notification_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.NotificationType',
      '10': 'notificationType'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'content', '3': 5, '4': 1, '5': 9, '10': 'content'},
    {'1': 'data', '3': 6, '4': 1, '5': 12, '10': 'data'},
    {'1': 'is_read', '3': 7, '4': 1, '5': 8, '10': 'isRead'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 3, '10': 'createdAt'},
    {'1': 'updated_at', '3': 9, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
};

/// Descriptor for `NotificationProto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationProtoDescriptor = $convert.base64Decode(
    'ChFOb3RpZmljYXRpb25Qcm90bxIOCgJpZBgBIAEoCVICaWQSFwoHdXNlcl9pZBgCIAEoCVIGdX'
    'NlcklkEkwKEW5vdGlmaWNhdGlvbl90eXBlGAMgASgOMh8uc3luY3R2LmNsaWVudC5Ob3RpZmlj'
    'YXRpb25UeXBlUhBub3RpZmljYXRpb25UeXBlEhQKBXRpdGxlGAQgASgJUgV0aXRsZRIYCgdjb2'
    '50ZW50GAUgASgJUgdjb250ZW50EhIKBGRhdGEYBiABKAxSBGRhdGESFwoHaXNfcmVhZBgHIAEo'
    'CFIGaXNSZWFkEh0KCmNyZWF0ZWRfYXQYCCABKANSCWNyZWF0ZWRBdBIdCgp1cGRhdGVkX2F0GA'
    'kgASgDUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use listNotificationsRequestDescriptor instead')
const ListNotificationsRequest$json = {
  '1': 'ListNotificationsRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'is_read',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'isRead',
      '17': true
    },
    {
      '1': 'notification_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.NotificationType',
      '8': {},
      '9': 1,
      '10': 'notificationType',
      '17': true
    },
    {'1': 'search', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'search'},
    {
      '1': 'sort_by',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.NotificationListSortBy',
      '8': {},
      '10': 'sortBy'
    },
    {
      '1': 'sort_direction',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.SortDirection',
      '8': {},
      '10': 'sortDirection'
    },
  ],
  '7': {},
  '8': [
    {'1': '_is_read'},
    {'1': '_notification_type'},
  ],
};

/// Descriptor for `ListNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotificationsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0Tm90aWZpY2F0aW9uc1JlcXVlc3QSEgoEcGFnZRgBIAEoBVIEcGFnZRIbCglwYWdlX3'
    'NpemUYAiABKAVSCHBhZ2VTaXplEhwKB2lzX3JlYWQYAyABKAhIAFIGaXNSZWFkiAEBEl0KEW5v'
    'dGlmaWNhdGlvbl90eXBlGAQgASgOMh8uc3luY3R2LmNsaWVudC5Ob3RpZmljYXRpb25UeXBlQg'
    'q6SAeCAQQQASAASAFSEG5vdGlmaWNhdGlvblR5cGWIAQESHwoGc2VhcmNoGAUgASgJQge6SARy'
    'AhhkUgZzZWFyY2gSSAoHc29ydF9ieRgGIAEoDjIlLnN5bmN0di5jbGllbnQuTm90aWZpY2F0aW'
    '9uTGlzdFNvcnRCeUIIukgFggECEAFSBnNvcnRCeRJNCg5zb3J0X2RpcmVjdGlvbhgHIAEoDjIc'
    'LnN5bmN0di5jbGllbnQuU29ydERpcmVjdGlvbkIIukgFggECEAFSDXNvcnREaXJlY3Rpb246jQ'
    'K6SIkCGmcKF2xpc3Rfbm90aWZpY2F0aW9ucy5wYWdlEipwYWdlIG11c3QgYmUgMCAodXNlIGRl'
    'ZmF1bHQpIG9yIGF0IGxlYXN0IDEaIHRoaXMucGFnZSA9PSAwIHx8IHRoaXMucGFnZSA+PSAxGp'
    '0BChxsaXN0X25vdGlmaWNhdGlvbnMucGFnZV9zaXplEjZwYWdlX3NpemUgbXVzdCBiZSAwICh1'
    'c2UgZGVmYXVsdCkgb3IgYmV0d2VlbiAxIGFuZCAxMDAaRXRoaXMucGFnZV9zaXplID09IDAgfH'
    'wgKHRoaXMucGFnZV9zaXplID49IDEgJiYgdGhpcy5wYWdlX3NpemUgPD0gMTAwKUIKCghfaXNf'
    'cmVhZEIUChJfbm90aWZpY2F0aW9uX3R5cGU=');

@$core.Deprecated('Use listNotificationsResponseDescriptor instead')
const ListNotificationsResponse$json = {
  '1': 'ListNotificationsResponse',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.NotificationProto',
      '10': 'notifications'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
    {'1': 'unread_count', '3': 3, '4': 1, '5': 5, '10': 'unreadCount'},
  ],
};

/// Descriptor for `ListNotificationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotificationsResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0Tm90aWZpY2F0aW9uc1Jlc3BvbnNlEkYKDW5vdGlmaWNhdGlvbnMYASADKAsyIC5zeW'
    '5jdHYuY2xpZW50Lk5vdGlmaWNhdGlvblByb3RvUg1ub3RpZmljYXRpb25zEhQKBXRvdGFsGAIg'
    'ASgFUgV0b3RhbBIhCgx1bnJlYWRfY291bnQYAyABKAVSC3VucmVhZENvdW50');

@$core.Deprecated('Use getNotificationRequestDescriptor instead')
const GetNotificationRequest$json = {
  '1': 'GetNotificationRequest',
  '2': [
    {
      '1': 'notification_id',
      '3': 1,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'notificationId'
    },
  ],
};

/// Descriptor for `GetNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNotificationRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXROb3RpZmljYXRpb25SZXF1ZXN0EjAKD25vdGlmaWNhdGlvbl9pZBgBIAEoA0IHukgEIg'
        'IoAVIObm90aWZpY2F0aW9uSWQ=');

@$core.Deprecated('Use getNotificationResponseDescriptor instead')
const GetNotificationResponse$json = {
  '1': 'GetNotificationResponse',
  '2': [
    {
      '1': 'notification',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.NotificationProto',
      '10': 'notification'
    },
  ],
};

/// Descriptor for `GetNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNotificationResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXROb3RpZmljYXRpb25SZXNwb25zZRJECgxub3RpZmljYXRpb24YASABKAsyIC5zeW5jdH'
        'YuY2xpZW50Lk5vdGlmaWNhdGlvblByb3RvUgxub3RpZmljYXRpb24=');

@$core.Deprecated('Use markAsReadRequestDescriptor instead')
const MarkAsReadRequest$json = {
  '1': 'MarkAsReadRequest',
  '2': [
    {
      '1': 'notification_ids',
      '3': 1,
      '4': 3,
      '5': 3,
      '8': {},
      '10': 'notificationIds'
    },
  ],
};

/// Descriptor for `MarkAsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAsReadRequestDescriptor = $convert.base64Decode(
    'ChFNYXJrQXNSZWFkUmVxdWVzdBI3ChBub3RpZmljYXRpb25faWRzGAEgAygDQgy6SAmSAQYiBC'
    'ICKAFSD25vdGlmaWNhdGlvbklkcw==');

@$core.Deprecated('Use markAsReadResponseDescriptor instead')
const MarkAsReadResponse$json = {
  '1': 'MarkAsReadResponse',
};

/// Descriptor for `MarkAsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAsReadResponseDescriptor =
    $convert.base64Decode('ChJNYXJrQXNSZWFkUmVzcG9uc2U=');

@$core.Deprecated('Use markAllAsReadRequestDescriptor instead')
const MarkAllAsReadRequest$json = {
  '1': 'MarkAllAsReadRequest',
  '2': [
    {'1': 'before', '3': 1, '4': 1, '5': 3, '9': 0, '10': 'before', '17': true},
  ],
  '8': [
    {'1': '_before'},
  ],
};

/// Descriptor for `MarkAllAsReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAllAsReadRequestDescriptor = $convert.base64Decode(
    'ChRNYXJrQWxsQXNSZWFkUmVxdWVzdBIbCgZiZWZvcmUYASABKANIAFIGYmVmb3JliAEBQgkKB1'
    '9iZWZvcmU=');

@$core.Deprecated('Use markAllAsReadResponseDescriptor instead')
const MarkAllAsReadResponse$json = {
  '1': 'MarkAllAsReadResponse',
};

/// Descriptor for `MarkAllAsReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAllAsReadResponseDescriptor =
    $convert.base64Decode('ChVNYXJrQWxsQXNSZWFkUmVzcG9uc2U=');

@$core.Deprecated('Use apiErrorResponseDescriptor instead')
const ApiErrorResponse$json = {
  '1': 'ApiErrorResponse',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '10': 'error'},
    {'1': 'status', '3': 2, '4': 1, '5': 13, '10': 'status'},
    {'1': 'code', '3': 3, '4': 1, '5': 5, '9': 0, '10': 'code', '17': true},
    {
      '1': 'request_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'requestId',
      '17': true
    },
  ],
  '8': [
    {'1': '_code'},
    {'1': '_request_id'},
  ],
};

/// Descriptor for `ApiErrorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List apiErrorResponseDescriptor = $convert.base64Decode(
    'ChBBcGlFcnJvclJlc3BvbnNlEhQKBWVycm9yGAEgASgJUgVlcnJvchIWCgZzdGF0dXMYAiABKA'
    '1SBnN0YXR1cxIXCgRjb2RlGAMgASgFSABSBGNvZGWIAQESIgoKcmVxdWVzdF9pZBgEIAEoCUgB'
    'UglyZXF1ZXN0SWSIAQFCBwoFX2NvZGVCDQoLX3JlcXVlc3RfaWQ=');

@$core.Deprecated('Use deleteNotificationRequestDescriptor instead')
const DeleteNotificationRequest$json = {
  '1': 'DeleteNotificationRequest',
  '2': [
    {
      '1': 'notification_id',
      '3': 1,
      '4': 1,
      '5': 3,
      '8': {},
      '10': 'notificationId'
    },
  ],
};

/// Descriptor for `DeleteNotificationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotificationRequestDescriptor =
    $convert.base64Decode(
        'ChlEZWxldGVOb3RpZmljYXRpb25SZXF1ZXN0EjAKD25vdGlmaWNhdGlvbl9pZBgBIAEoA0IHuk'
        'gEIgIoAVIObm90aWZpY2F0aW9uSWQ=');

@$core.Deprecated('Use deleteNotificationResponseDescriptor instead')
const DeleteNotificationResponse$json = {
  '1': 'DeleteNotificationResponse',
};

/// Descriptor for `DeleteNotificationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNotificationResponseDescriptor =
    $convert.base64Decode('ChpEZWxldGVOb3RpZmljYXRpb25SZXNwb25zZQ==');

@$core.Deprecated('Use deleteAllReadRequestDescriptor instead')
const DeleteAllReadRequest$json = {
  '1': 'DeleteAllReadRequest',
};

/// Descriptor for `DeleteAllReadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAllReadRequestDescriptor =
    $convert.base64Decode('ChREZWxldGVBbGxSZWFkUmVxdWVzdA==');

@$core.Deprecated('Use deleteAllReadResponseDescriptor instead')
const DeleteAllReadResponse$json = {
  '1': 'DeleteAllReadResponse',
};

/// Descriptor for `DeleteAllReadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAllReadResponseDescriptor =
    $convert.base64Decode('ChVEZWxldGVBbGxSZWFkUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> AuthServiceBase$json = {
  '1': 'AuthService',
  '2': [
    {
      '1': 'RequestEmailLogin',
      '2': '.synctv.client.RequestEmailLoginRequest',
      '3': '.synctv.client.RequestEmailLoginResponse'
    },
    {
      '1': 'ConfirmEmailLogin',
      '2': '.synctv.client.ConfirmEmailLoginRequest',
      '3': '.synctv.client.LoginResponse'
    },
    {
      '1': 'CreateGuestToken',
      '2': '.synctv.client.CreateGuestTokenRequest',
      '3': '.synctv.client.CreateGuestTokenResponse'
    },
    {
      '1': 'RegisterWithDirectPassword',
      '2': '.synctv.client.RegisterWithDirectPasswordRequest',
      '3': '.synctv.client.RegisterResponse'
    },
    {
      '1': 'LoginWithDirectPassword',
      '2': '.synctv.client.LoginWithDirectPasswordRequest',
      '3': '.synctv.client.LoginResponse'
    },
    {
      '1': 'RequestEmailRegistration',
      '2': '.synctv.client.RequestEmailRegistrationRequest',
      '3': '.synctv.client.RequestEmailRegistrationResponse'
    },
    {
      '1': 'ConfirmEmailRegistration',
      '2': '.synctv.client.ConfirmEmailRegistrationRequest',
      '3': '.synctv.client.RegisterResponse'
    },
    {
      '1': 'StartOpaqueRegistration',
      '2': '.synctv.client.StartOpaqueRegistrationRequest',
      '3': '.synctv.client.StartOpaqueRegistrationResponse'
    },
    {
      '1': 'FinishOpaqueRegistration',
      '2': '.synctv.client.FinishOpaqueRegistrationRequest',
      '3': '.synctv.client.RegisterResponse'
    },
    {
      '1': 'StartOpaqueLogin',
      '2': '.synctv.client.StartOpaqueLoginRequest',
      '3': '.synctv.client.StartOpaqueLoginResponse'
    },
    {
      '1': 'FinishOpaqueLogin',
      '2': '.synctv.client.FinishOpaqueLoginRequest',
      '3': '.synctv.client.LoginResponse'
    },
    {
      '1': 'StartPasskeyRegistration',
      '2': '.synctv.client.StartPasskeyRegistrationRequest',
      '3': '.synctv.client.StartPasskeyRegistrationResponse'
    },
    {
      '1': 'FinishPasskeyRegistration',
      '2': '.synctv.client.FinishPasskeyRegistrationRequest',
      '3': '.synctv.client.RegisterResponse'
    },
    {
      '1': 'StartPasskeyLogin',
      '2': '.synctv.client.StartPasskeyLoginRequest',
      '3': '.synctv.client.StartPasskeyLoginResponse'
    },
    {
      '1': 'FinishPasskeyLogin',
      '2': '.synctv.client.FinishPasskeyLoginRequest',
      '3': '.synctv.client.LoginResponse'
    },
    {
      '1': 'RequestMfaEmailCode',
      '2': '.synctv.client.RequestMfaEmailCodeRequest',
      '3': '.synctv.client.RequestMfaEmailCodeResponse'
    },
    {
      '1': 'VerifyMfaEmailCode',
      '2': '.synctv.client.VerifyMfaEmailCodeRequest',
      '3': '.synctv.client.LoginResponse'
    },
    {
      '1': 'StartMfaPasskey',
      '2': '.synctv.client.StartMfaPasskeyRequest',
      '3': '.synctv.client.StartMfaPasskeyResponse'
    },
    {
      '1': 'FinishMfaPasskey',
      '2': '.synctv.client.FinishMfaPasskeyRequest',
      '3': '.synctv.client.LoginResponse'
    },
    {
      '1': 'RefreshToken',
      '2': '.synctv.client.RefreshTokenRequest',
      '3': '.synctv.client.RefreshTokenResponse'
    },
  ],
};

@$core.Deprecated('Use authServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AuthServiceBase$messageJson = {
  '.synctv.client.RequestEmailLoginRequest': RequestEmailLoginRequest$json,
  '.synctv.client.RequestEmailLoginResponse': RequestEmailLoginResponse$json,
  '.synctv.client.ConfirmEmailLoginRequest': ConfirmEmailLoginRequest$json,
  '.synctv.client.LoginResponse': LoginResponse$json,
  '.synctv.client.User': User$json,
  '.synctv.client.UserAvatar': UserAvatar$json,
  '.synctv.client.MfaChallenge': MfaChallenge$json,
  '.synctv.client.CreateGuestTokenRequest': CreateGuestTokenRequest$json,
  '.synctv.client.CreateGuestTokenResponse': CreateGuestTokenResponse$json,
  '.synctv.client.RegisterWithDirectPasswordRequest':
      RegisterWithDirectPasswordRequest$json,
  '.synctv.client.RegisterResponse': RegisterResponse$json,
  '.synctv.client.PendingRegistrationReview': PendingRegistrationReview$json,
  '.synctv.client.LoginWithDirectPasswordRequest':
      LoginWithDirectPasswordRequest$json,
  '.synctv.client.RequestEmailRegistrationRequest':
      RequestEmailRegistrationRequest$json,
  '.synctv.client.RequestEmailRegistrationResponse':
      RequestEmailRegistrationResponse$json,
  '.synctv.client.ConfirmEmailRegistrationRequest':
      ConfirmEmailRegistrationRequest$json,
  '.synctv.client.StartOpaqueRegistrationRequest':
      StartOpaqueRegistrationRequest$json,
  '.synctv.client.StartOpaqueRegistrationResponse':
      StartOpaqueRegistrationResponse$json,
  '.synctv.client.FinishOpaqueRegistrationRequest':
      FinishOpaqueRegistrationRequest$json,
  '.synctv.client.StartOpaqueLoginRequest': StartOpaqueLoginRequest$json,
  '.synctv.client.StartOpaqueLoginResponse': StartOpaqueLoginResponse$json,
  '.synctv.client.FinishOpaqueLoginRequest': FinishOpaqueLoginRequest$json,
  '.synctv.client.StartPasskeyRegistrationRequest':
      StartPasskeyRegistrationRequest$json,
  '.synctv.client.StartPasskeyRegistrationResponse':
      StartPasskeyRegistrationResponse$json,
  '.synctv.client.FinishPasskeyRegistrationRequest':
      FinishPasskeyRegistrationRequest$json,
  '.synctv.client.StartPasskeyLoginRequest': StartPasskeyLoginRequest$json,
  '.synctv.client.StartPasskeyLoginResponse': StartPasskeyLoginResponse$json,
  '.synctv.client.FinishPasskeyLoginRequest': FinishPasskeyLoginRequest$json,
  '.synctv.client.RequestMfaEmailCodeRequest': RequestMfaEmailCodeRequest$json,
  '.synctv.client.RequestMfaEmailCodeResponse':
      RequestMfaEmailCodeResponse$json,
  '.synctv.client.VerifyMfaEmailCodeRequest': VerifyMfaEmailCodeRequest$json,
  '.synctv.client.StartMfaPasskeyRequest': StartMfaPasskeyRequest$json,
  '.synctv.client.StartMfaPasskeyResponse': StartMfaPasskeyResponse$json,
  '.synctv.client.FinishMfaPasskeyRequest': FinishMfaPasskeyRequest$json,
  '.synctv.client.RefreshTokenRequest': RefreshTokenRequest$json,
  '.synctv.client.RefreshTokenResponse': RefreshTokenResponse$json,
};

/// Descriptor for `AuthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List authServiceDescriptor = $convert.base64Decode(
    'CgtBdXRoU2VydmljZRJmChFSZXF1ZXN0RW1haWxMb2dpbhInLnN5bmN0di5jbGllbnQuUmVxdW'
    'VzdEVtYWlsTG9naW5SZXF1ZXN0Giguc3luY3R2LmNsaWVudC5SZXF1ZXN0RW1haWxMb2dpblJl'
    'c3BvbnNlEloKEUNvbmZpcm1FbWFpbExvZ2luEicuc3luY3R2LmNsaWVudC5Db25maXJtRW1haW'
    'xMb2dpblJlcXVlc3QaHC5zeW5jdHYuY2xpZW50LkxvZ2luUmVzcG9uc2USYwoQQ3JlYXRlR3Vl'
    'c3RUb2tlbhImLnN5bmN0di5jbGllbnQuQ3JlYXRlR3Vlc3RUb2tlblJlcXVlc3QaJy5zeW5jdH'
    'YuY2xpZW50LkNyZWF0ZUd1ZXN0VG9rZW5SZXNwb25zZRJvChpSZWdpc3RlcldpdGhEaXJlY3RQ'
    'YXNzd29yZBIwLnN5bmN0di5jbGllbnQuUmVnaXN0ZXJXaXRoRGlyZWN0UGFzc3dvcmRSZXF1ZX'
    'N0Gh8uc3luY3R2LmNsaWVudC5SZWdpc3RlclJlc3BvbnNlEmYKF0xvZ2luV2l0aERpcmVjdFBh'
    'c3N3b3JkEi0uc3luY3R2LmNsaWVudC5Mb2dpbldpdGhEaXJlY3RQYXNzd29yZFJlcXVlc3QaHC'
    '5zeW5jdHYuY2xpZW50LkxvZ2luUmVzcG9uc2USewoYUmVxdWVzdEVtYWlsUmVnaXN0cmF0aW9u'
    'Ei4uc3luY3R2LmNsaWVudC5SZXF1ZXN0RW1haWxSZWdpc3RyYXRpb25SZXF1ZXN0Gi8uc3luY3'
    'R2LmNsaWVudC5SZXF1ZXN0RW1haWxSZWdpc3RyYXRpb25SZXNwb25zZRJrChhDb25maXJtRW1h'
    'aWxSZWdpc3RyYXRpb24SLi5zeW5jdHYuY2xpZW50LkNvbmZpcm1FbWFpbFJlZ2lzdHJhdGlvbl'
    'JlcXVlc3QaHy5zeW5jdHYuY2xpZW50LlJlZ2lzdGVyUmVzcG9uc2USeAoXU3RhcnRPcGFxdWVS'
    'ZWdpc3RyYXRpb24SLS5zeW5jdHYuY2xpZW50LlN0YXJ0T3BhcXVlUmVnaXN0cmF0aW9uUmVxdW'
    'VzdBouLnN5bmN0di5jbGllbnQuU3RhcnRPcGFxdWVSZWdpc3RyYXRpb25SZXNwb25zZRJrChhG'
    'aW5pc2hPcGFxdWVSZWdpc3RyYXRpb24SLi5zeW5jdHYuY2xpZW50LkZpbmlzaE9wYXF1ZVJlZ2'
    'lzdHJhdGlvblJlcXVlc3QaHy5zeW5jdHYuY2xpZW50LlJlZ2lzdGVyUmVzcG9uc2USYwoQU3Rh'
    'cnRPcGFxdWVMb2dpbhImLnN5bmN0di5jbGllbnQuU3RhcnRPcGFxdWVMb2dpblJlcXVlc3QaJy'
    '5zeW5jdHYuY2xpZW50LlN0YXJ0T3BhcXVlTG9naW5SZXNwb25zZRJaChFGaW5pc2hPcGFxdWVM'
    'b2dpbhInLnN5bmN0di5jbGllbnQuRmluaXNoT3BhcXVlTG9naW5SZXF1ZXN0Ghwuc3luY3R2Lm'
    'NsaWVudC5Mb2dpblJlc3BvbnNlEnsKGFN0YXJ0UGFzc2tleVJlZ2lzdHJhdGlvbhIuLnN5bmN0'
    'di5jbGllbnQuU3RhcnRQYXNza2V5UmVnaXN0cmF0aW9uUmVxdWVzdBovLnN5bmN0di5jbGllbn'
    'QuU3RhcnRQYXNza2V5UmVnaXN0cmF0aW9uUmVzcG9uc2USbQoZRmluaXNoUGFzc2tleVJlZ2lz'
    'dHJhdGlvbhIvLnN5bmN0di5jbGllbnQuRmluaXNoUGFzc2tleVJlZ2lzdHJhdGlvblJlcXVlc3'
    'QaHy5zeW5jdHYuY2xpZW50LlJlZ2lzdGVyUmVzcG9uc2USZgoRU3RhcnRQYXNza2V5TG9naW4S'
    'Jy5zeW5jdHYuY2xpZW50LlN0YXJ0UGFzc2tleUxvZ2luUmVxdWVzdBooLnN5bmN0di5jbGllbn'
    'QuU3RhcnRQYXNza2V5TG9naW5SZXNwb25zZRJcChJGaW5pc2hQYXNza2V5TG9naW4SKC5zeW5j'
    'dHYuY2xpZW50LkZpbmlzaFBhc3NrZXlMb2dpblJlcXVlc3QaHC5zeW5jdHYuY2xpZW50LkxvZ2'
    'luUmVzcG9uc2USbAoTUmVxdWVzdE1mYUVtYWlsQ29kZRIpLnN5bmN0di5jbGllbnQuUmVxdWVz'
    'dE1mYUVtYWlsQ29kZVJlcXVlc3QaKi5zeW5jdHYuY2xpZW50LlJlcXVlc3RNZmFFbWFpbENvZG'
    'VSZXNwb25zZRJcChJWZXJpZnlNZmFFbWFpbENvZGUSKC5zeW5jdHYuY2xpZW50LlZlcmlmeU1m'
    'YUVtYWlsQ29kZVJlcXVlc3QaHC5zeW5jdHYuY2xpZW50LkxvZ2luUmVzcG9uc2USYAoPU3Rhcn'
    'RNZmFQYXNza2V5EiUuc3luY3R2LmNsaWVudC5TdGFydE1mYVBhc3NrZXlSZXF1ZXN0GiYuc3lu'
    'Y3R2LmNsaWVudC5TdGFydE1mYVBhc3NrZXlSZXNwb25zZRJYChBGaW5pc2hNZmFQYXNza2V5Ei'
    'Yuc3luY3R2LmNsaWVudC5GaW5pc2hNZmFQYXNza2V5UmVxdWVzdBocLnN5bmN0di5jbGllbnQu'
    'TG9naW5SZXNwb25zZRJXCgxSZWZyZXNoVG9rZW4SIi5zeW5jdHYuY2xpZW50LlJlZnJlc2hUb2'
    'tlblJlcXVlc3QaIy5zeW5jdHYuY2xpZW50LlJlZnJlc2hUb2tlblJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> UserServiceBase$json = {
  '1': 'UserService',
  '2': [
    {
      '1': 'Logout',
      '2': '.synctv.client.LogoutRequest',
      '3': '.synctv.client.LogoutResponse'
    },
    {
      '1': 'GetProfile',
      '2': '.synctv.client.GetProfileRequest',
      '3': '.synctv.client.GetProfileResponse'
    },
    {
      '1': 'SetUsername',
      '2': '.synctv.client.SetUsernameRequest',
      '3': '.synctv.client.SetUsernameResponse'
    },
    {
      '1': 'CreateUserAvatarUploadSession',
      '2': '.synctv.client.CreateUserAvatarUploadSessionRequest',
      '3': '.synctv.client.CreateUserAvatarUploadSessionResponse'
    },
    {
      '1': 'UploadUserAvatarObject',
      '2': '.synctv.client.UploadUserAvatarObjectRequest',
      '3': '.synctv.client.UploadUserAvatarObjectResponse'
    },
    {
      '1': 'GetUserAvatarObject',
      '2': '.synctv.client.GetUserAvatarObjectRequest',
      '3': '.synctv.client.UserAvatarObjectResponse'
    },
    {
      '1': 'UpdateUserAvatar',
      '2': '.synctv.client.UpdateUserAvatarRequest',
      '3': '.synctv.client.GetProfileResponse'
    },
    {
      '1': 'ClearUserAvatar',
      '2': '.synctv.client.ClearUserAvatarRequest',
      '3': '.synctv.client.GetProfileResponse'
    },
    {
      '1': 'StartSensitiveOperationVerification',
      '2': '.synctv.client.StartSensitiveOperationVerificationRequest',
      '3': '.synctv.client.StartSensitiveOperationVerificationResponse'
    },
    {
      '1': 'StartSensitiveOperationPasskey',
      '2': '.synctv.client.StartSensitiveOperationPasskeyRequest',
      '3': '.synctv.client.StartSensitiveOperationPasskeyResponse'
    },
    {
      '1': 'RequestSensitiveOperationEmailCode',
      '2': '.synctv.client.RequestSensitiveOperationEmailCodeRequest',
      '3': '.synctv.client.RequestSensitiveOperationEmailCodeResponse'
    },
    {
      '1': 'FinishSensitiveOperationVerification',
      '2': '.synctv.client.FinishSensitiveOperationVerificationRequest',
      '3': '.synctv.client.FinishSensitiveOperationVerificationResponse'
    },
    {
      '1': 'StartEmailBind',
      '2': '.synctv.client.StartEmailBindRequest',
      '3': '.synctv.client.StartEmailBindResponse'
    },
    {
      '1': 'ConfirmEmailBind',
      '2': '.synctv.client.ConfirmEmailBindRequest',
      '3': '.synctv.client.ConfirmEmailBindResponse'
    },
    {
      '1': 'UnbindEmail',
      '2': '.synctv.client.UnbindEmailRequest',
      '3': '.synctv.client.UnbindEmailResponse'
    },
    {
      '1': 'StartOpaquePasswordUpdate',
      '2': '.synctv.client.StartOpaquePasswordUpdateRequest',
      '3': '.synctv.client.StartOpaquePasswordUpdateResponse'
    },
    {
      '1': 'FinishOpaquePasswordUpdate',
      '2': '.synctv.client.FinishOpaquePasswordUpdateRequest',
      '3': '.synctv.client.FinishOpaquePasswordUpdateResponse'
    },
    {
      '1': 'StartPasskeyBind',
      '2': '.synctv.client.StartPasskeyBindRequest',
      '3': '.synctv.client.StartPasskeyBindResponse'
    },
    {
      '1': 'FinishPasskeyBind',
      '2': '.synctv.client.FinishPasskeyBindRequest',
      '3': '.synctv.client.PasskeyCredentialResponse'
    },
    {
      '1': 'ListPasskeys',
      '2': '.synctv.client.ListPasskeysRequest',
      '3': '.synctv.client.ListPasskeysResponse'
    },
    {
      '1': 'DeletePasskey',
      '2': '.synctv.client.DeletePasskeyRequest',
      '3': '.synctv.client.DeletePasskeyResponse'
    },
    {
      '1': 'GetUserPreferences',
      '2': '.synctv.client.GetUserPreferencesRequest',
      '3': '.synctv.client.GetUserPreferencesResponse'
    },
    {
      '1': 'UpdateUserPreferences',
      '2': '.synctv.client.UpdateUserPreferencesRequest',
      '3': '.synctv.client.UpdateUserPreferencesResponse'
    },
    {
      '1': 'CloseAccount',
      '2': '.synctv.client.CloseAccountRequest',
      '3': '.synctv.client.CloseAccountResponse'
    },
    {
      '1': 'CreateRoom',
      '2': '.synctv.client.CreateRoomRequest',
      '3': '.synctv.client.CreateRoomResponse'
    },
    {
      '1': 'GetRoom',
      '2': '.synctv.client.GetRoomRequest',
      '3': '.synctv.client.GetRoomResponse'
    },
    {
      '1': 'JoinRoom',
      '2': '.synctv.client.JoinRoomRequest',
      '3': '.synctv.client.JoinRoomResponse'
    },
    {
      '1': 'StartRoomPasswordLogin',
      '2': '.synctv.client.StartRoomPasswordLoginRequest',
      '3': '.synctv.client.StartRoomPasswordLoginResponse'
    },
    {
      '1': 'FinishRoomPasswordLogin',
      '2': '.synctv.client.FinishRoomPasswordLoginRequest',
      '3': '.synctv.client.JoinRoomResponse'
    },
    {
      '1': 'ListMyRooms',
      '2': '.synctv.client.ListMyRoomsRequest',
      '3': '.synctv.client.ListMyRoomsResponse'
    },
  ],
};

@$core.Deprecated('Use userServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    UserServiceBase$messageJson = {
  '.synctv.client.LogoutRequest': LogoutRequest$json,
  '.synctv.client.LogoutResponse': LogoutResponse$json,
  '.synctv.client.GetProfileRequest': GetProfileRequest$json,
  '.synctv.client.GetProfileResponse': GetProfileResponse$json,
  '.synctv.client.User': User$json,
  '.synctv.client.UserAvatar': UserAvatar$json,
  '.synctv.client.SetUsernameRequest': SetUsernameRequest$json,
  '.synctv.client.SetUsernameResponse': SetUsernameResponse$json,
  '.synctv.client.CreateUserAvatarUploadSessionRequest':
      CreateUserAvatarUploadSessionRequest$json,
  '.synctv.client.CreateUserAvatarUploadSessionResponse':
      CreateUserAvatarUploadSessionResponse$json,
  '.synctv.client.UserAvatarUploadSession': UserAvatarUploadSession$json,
  '.synctv.client.UserAvatarUploadSession.UploadHeadersEntry':
      UserAvatarUploadSession_UploadHeadersEntry$json,
  '.synctv.client.UserAvatarOwnershipProofRange':
      UserAvatarOwnershipProofRange$json,
  '.synctv.client.UploadUserAvatarObjectRequest':
      UploadUserAvatarObjectRequest$json,
  '.synctv.client.UploadUserAvatarObjectResponse':
      UploadUserAvatarObjectResponse$json,
  '.synctv.client.UserAvatarObjectResponse': UserAvatarObjectResponse$json,
  '.synctv.client.GetUserAvatarObjectRequest': GetUserAvatarObjectRequest$json,
  '.synctv.client.UpdateUserAvatarRequest': UpdateUserAvatarRequest$json,
  '.synctv.client.ClearUserAvatarRequest': ClearUserAvatarRequest$json,
  '.synctv.client.StartSensitiveOperationVerificationRequest':
      StartSensitiveOperationVerificationRequest$json,
  '.synctv.client.StartSensitiveOperationVerificationResponse':
      StartSensitiveOperationVerificationResponse$json,
  '.synctv.client.SensitiveOperationVerificationChallenge':
      SensitiveOperationVerificationChallenge$json,
  '.synctv.client.StartSensitiveOperationPasskeyRequest':
      StartSensitiveOperationPasskeyRequest$json,
  '.synctv.client.StartSensitiveOperationPasskeyResponse':
      StartSensitiveOperationPasskeyResponse$json,
  '.synctv.client.RequestSensitiveOperationEmailCodeRequest':
      RequestSensitiveOperationEmailCodeRequest$json,
  '.synctv.client.RequestSensitiveOperationEmailCodeResponse':
      RequestSensitiveOperationEmailCodeResponse$json,
  '.synctv.client.FinishSensitiveOperationVerificationRequest':
      FinishSensitiveOperationVerificationRequest$json,
  '.synctv.client.FinishSensitiveOperationVerificationResponse':
      FinishSensitiveOperationVerificationResponse$json,
  '.synctv.client.StartEmailBindRequest': StartEmailBindRequest$json,
  '.synctv.client.StartEmailBindResponse': StartEmailBindResponse$json,
  '.synctv.client.ConfirmEmailBindRequest': ConfirmEmailBindRequest$json,
  '.synctv.client.ConfirmEmailBindResponse': ConfirmEmailBindResponse$json,
  '.synctv.client.UnbindEmailRequest': UnbindEmailRequest$json,
  '.synctv.client.UnbindEmailResponse': UnbindEmailResponse$json,
  '.synctv.client.StartOpaquePasswordUpdateRequest':
      StartOpaquePasswordUpdateRequest$json,
  '.synctv.client.StartOpaquePasswordUpdateResponse':
      StartOpaquePasswordUpdateResponse$json,
  '.synctv.client.FinishOpaquePasswordUpdateRequest':
      FinishOpaquePasswordUpdateRequest$json,
  '.synctv.client.FinishOpaquePasswordUpdateResponse':
      FinishOpaquePasswordUpdateResponse$json,
  '.synctv.client.StartPasskeyBindRequest': StartPasskeyBindRequest$json,
  '.synctv.client.StartPasskeyBindResponse': StartPasskeyBindResponse$json,
  '.synctv.client.FinishPasskeyBindRequest': FinishPasskeyBindRequest$json,
  '.synctv.client.PasskeyCredentialResponse': PasskeyCredentialResponse$json,
  '.synctv.client.PasskeyCredential': PasskeyCredential$json,
  '.synctv.client.ListPasskeysRequest': ListPasskeysRequest$json,
  '.synctv.client.ListPasskeysResponse': ListPasskeysResponse$json,
  '.synctv.client.DeletePasskeyRequest': DeletePasskeyRequest$json,
  '.synctv.client.DeletePasskeyResponse': DeletePasskeyResponse$json,
  '.synctv.client.GetUserPreferencesRequest': GetUserPreferencesRequest$json,
  '.synctv.client.GetUserPreferencesResponse': GetUserPreferencesResponse$json,
  '.synctv.client.UserPreferences': UserPreferences$json,
  '.synctv.client.UserNotificationPreferences':
      UserNotificationPreferences$json,
  '.synctv.client.UserAuthFactors': UserAuthFactors$json,
  '.synctv.client.UpdateUserPreferencesRequest':
      UpdateUserPreferencesRequest$json,
  '.synctv.client.UpdateUserPreferencesResponse':
      UpdateUserPreferencesResponse$json,
  '.synctv.client.CloseAccountRequest': CloseAccountRequest$json,
  '.synctv.client.CloseAccountResponse': CloseAccountResponse$json,
  '.synctv.client.CreateRoomRequest': CreateRoomRequest$json,
  '.synctv.client.CreateRoomResponse': CreateRoomResponse$json,
  '.synctv.client.Room': Room$json,
  '.synctv.client.ResourceCover': ResourceCover$json,
  '.synctv.common.RoomPresenceStats': $0.RoomPresenceStats$json,
  '.synctv.common.NodeConnectionCount': $0.NodeConnectionCount$json,
  '.synctv.client.UserPublicView': UserPublicView$json,
  '.synctv.client.GetRoomRequest': GetRoomRequest$json,
  '.synctv.client.GetRoomResponse': GetRoomResponse$json,
  '.synctv.client.PlaybackState': PlaybackState$json,
  '.synctv.client.JoinRoomRequest': JoinRoomRequest$json,
  '.synctv.client.JoinRoomResponse': JoinRoomResponse$json,
  '.synctv.common.RoomMember': $0.RoomMember$json,
  '.synctv.client.StartRoomPasswordLoginRequest':
      StartRoomPasswordLoginRequest$json,
  '.synctv.client.StartRoomPasswordLoginResponse':
      StartRoomPasswordLoginResponse$json,
  '.synctv.client.FinishRoomPasswordLoginRequest':
      FinishRoomPasswordLoginRequest$json,
  '.synctv.client.ListMyRoomsRequest': ListMyRoomsRequest$json,
  '.synctv.client.ListMyRoomsResponse': ListMyRoomsResponse$json,
  '.synctv.client.MyRoom': MyRoom$json,
};

/// Descriptor for `UserService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List userServiceDescriptor = $convert.base64Decode(
    'CgtVc2VyU2VydmljZRJFCgZMb2dvdXQSHC5zeW5jdHYuY2xpZW50LkxvZ291dFJlcXVlc3QaHS'
    '5zeW5jdHYuY2xpZW50LkxvZ291dFJlc3BvbnNlElEKCkdldFByb2ZpbGUSIC5zeW5jdHYuY2xp'
    'ZW50LkdldFByb2ZpbGVSZXF1ZXN0GiEuc3luY3R2LmNsaWVudC5HZXRQcm9maWxlUmVzcG9uc2'
    'USVAoLU2V0VXNlcm5hbWUSIS5zeW5jdHYuY2xpZW50LlNldFVzZXJuYW1lUmVxdWVzdBoiLnN5'
    'bmN0di5jbGllbnQuU2V0VXNlcm5hbWVSZXNwb25zZRKKAQodQ3JlYXRlVXNlckF2YXRhclVwbG'
    '9hZFNlc3Npb24SMy5zeW5jdHYuY2xpZW50LkNyZWF0ZVVzZXJBdmF0YXJVcGxvYWRTZXNzaW9u'
    'UmVxdWVzdBo0LnN5bmN0di5jbGllbnQuQ3JlYXRlVXNlckF2YXRhclVwbG9hZFNlc3Npb25SZX'
    'Nwb25zZRJ1ChZVcGxvYWRVc2VyQXZhdGFyT2JqZWN0Eiwuc3luY3R2LmNsaWVudC5VcGxvYWRV'
    'c2VyQXZhdGFyT2JqZWN0UmVxdWVzdBotLnN5bmN0di5jbGllbnQuVXBsb2FkVXNlckF2YXRhck'
    '9iamVjdFJlc3BvbnNlEmkKE0dldFVzZXJBdmF0YXJPYmplY3QSKS5zeW5jdHYuY2xpZW50Lkdl'
    'dFVzZXJBdmF0YXJPYmplY3RSZXF1ZXN0Gicuc3luY3R2LmNsaWVudC5Vc2VyQXZhdGFyT2JqZW'
    'N0UmVzcG9uc2USXQoQVXBkYXRlVXNlckF2YXRhchImLnN5bmN0di5jbGllbnQuVXBkYXRlVXNl'
    'ckF2YXRhclJlcXVlc3QaIS5zeW5jdHYuY2xpZW50LkdldFByb2ZpbGVSZXNwb25zZRJbCg9DbG'
    'VhclVzZXJBdmF0YXISJS5zeW5jdHYuY2xpZW50LkNsZWFyVXNlckF2YXRhclJlcXVlc3QaIS5z'
    'eW5jdHYuY2xpZW50LkdldFByb2ZpbGVSZXNwb25zZRKcAQojU3RhcnRTZW5zaXRpdmVPcGVyYX'
    'Rpb25WZXJpZmljYXRpb24SOS5zeW5jdHYuY2xpZW50LlN0YXJ0U2Vuc2l0aXZlT3BlcmF0aW9u'
    'VmVyaWZpY2F0aW9uUmVxdWVzdBo6LnN5bmN0di5jbGllbnQuU3RhcnRTZW5zaXRpdmVPcGVyYX'
    'Rpb25WZXJpZmljYXRpb25SZXNwb25zZRKNAQoeU3RhcnRTZW5zaXRpdmVPcGVyYXRpb25QYXNz'
    'a2V5EjQuc3luY3R2LmNsaWVudC5TdGFydFNlbnNpdGl2ZU9wZXJhdGlvblBhc3NrZXlSZXF1ZX'
    'N0GjUuc3luY3R2LmNsaWVudC5TdGFydFNlbnNpdGl2ZU9wZXJhdGlvblBhc3NrZXlSZXNwb25z'
    'ZRKZAQoiUmVxdWVzdFNlbnNpdGl2ZU9wZXJhdGlvbkVtYWlsQ29kZRI4LnN5bmN0di5jbGllbn'
    'QuUmVxdWVzdFNlbnNpdGl2ZU9wZXJhdGlvbkVtYWlsQ29kZVJlcXVlc3QaOS5zeW5jdHYuY2xp'
    'ZW50LlJlcXVlc3RTZW5zaXRpdmVPcGVyYXRpb25FbWFpbENvZGVSZXNwb25zZRKfAQokRmluaX'
    'NoU2Vuc2l0aXZlT3BlcmF0aW9uVmVyaWZpY2F0aW9uEjouc3luY3R2LmNsaWVudC5GaW5pc2hT'
    'ZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25SZXF1ZXN0Gjsuc3luY3R2LmNsaWVudC5GaW'
    '5pc2hTZW5zaXRpdmVPcGVyYXRpb25WZXJpZmljYXRpb25SZXNwb25zZRJdCg5TdGFydEVtYWls'
    'QmluZBIkLnN5bmN0di5jbGllbnQuU3RhcnRFbWFpbEJpbmRSZXF1ZXN0GiUuc3luY3R2LmNsaW'
    'VudC5TdGFydEVtYWlsQmluZFJlc3BvbnNlEmMKEENvbmZpcm1FbWFpbEJpbmQSJi5zeW5jdHYu'
    'Y2xpZW50LkNvbmZpcm1FbWFpbEJpbmRSZXF1ZXN0Gicuc3luY3R2LmNsaWVudC5Db25maXJtRW'
    '1haWxCaW5kUmVzcG9uc2USVAoLVW5iaW5kRW1haWwSIS5zeW5jdHYuY2xpZW50LlVuYmluZEVt'
    'YWlsUmVxdWVzdBoiLnN5bmN0di5jbGllbnQuVW5iaW5kRW1haWxSZXNwb25zZRJ+ChlTdGFydE'
    '9wYXF1ZVBhc3N3b3JkVXBkYXRlEi8uc3luY3R2LmNsaWVudC5TdGFydE9wYXF1ZVBhc3N3b3Jk'
    'VXBkYXRlUmVxdWVzdBowLnN5bmN0di5jbGllbnQuU3RhcnRPcGFxdWVQYXNzd29yZFVwZGF0ZV'
    'Jlc3BvbnNlEoEBChpGaW5pc2hPcGFxdWVQYXNzd29yZFVwZGF0ZRIwLnN5bmN0di5jbGllbnQu'
    'RmluaXNoT3BhcXVlUGFzc3dvcmRVcGRhdGVSZXF1ZXN0GjEuc3luY3R2LmNsaWVudC5GaW5pc2'
    'hPcGFxdWVQYXNzd29yZFVwZGF0ZVJlc3BvbnNlEmMKEFN0YXJ0UGFzc2tleUJpbmQSJi5zeW5j'
    'dHYuY2xpZW50LlN0YXJ0UGFzc2tleUJpbmRSZXF1ZXN0Gicuc3luY3R2LmNsaWVudC5TdGFydF'
    'Bhc3NrZXlCaW5kUmVzcG9uc2USZgoRRmluaXNoUGFzc2tleUJpbmQSJy5zeW5jdHYuY2xpZW50'
    'LkZpbmlzaFBhc3NrZXlCaW5kUmVxdWVzdBooLnN5bmN0di5jbGllbnQuUGFzc2tleUNyZWRlbn'
    'RpYWxSZXNwb25zZRJXCgxMaXN0UGFzc2tleXMSIi5zeW5jdHYuY2xpZW50Lkxpc3RQYXNza2V5'
    'c1JlcXVlc3QaIy5zeW5jdHYuY2xpZW50Lkxpc3RQYXNza2V5c1Jlc3BvbnNlEloKDURlbGV0ZV'
    'Bhc3NrZXkSIy5zeW5jdHYuY2xpZW50LkRlbGV0ZVBhc3NrZXlSZXF1ZXN0GiQuc3luY3R2LmNs'
    'aWVudC5EZWxldGVQYXNza2V5UmVzcG9uc2USaQoSR2V0VXNlclByZWZlcmVuY2VzEiguc3luY3'
    'R2LmNsaWVudC5HZXRVc2VyUHJlZmVyZW5jZXNSZXF1ZXN0Gikuc3luY3R2LmNsaWVudC5HZXRV'
    'c2VyUHJlZmVyZW5jZXNSZXNwb25zZRJyChVVcGRhdGVVc2VyUHJlZmVyZW5jZXMSKy5zeW5jdH'
    'YuY2xpZW50LlVwZGF0ZVVzZXJQcmVmZXJlbmNlc1JlcXVlc3QaLC5zeW5jdHYuY2xpZW50LlVw'
    'ZGF0ZVVzZXJQcmVmZXJlbmNlc1Jlc3BvbnNlElcKDENsb3NlQWNjb3VudBIiLnN5bmN0di5jbG'
    'llbnQuQ2xvc2VBY2NvdW50UmVxdWVzdBojLnN5bmN0di5jbGllbnQuQ2xvc2VBY2NvdW50UmVz'
    'cG9uc2USUQoKQ3JlYXRlUm9vbRIgLnN5bmN0di5jbGllbnQuQ3JlYXRlUm9vbVJlcXVlc3QaIS'
    '5zeW5jdHYuY2xpZW50LkNyZWF0ZVJvb21SZXNwb25zZRJICgdHZXRSb29tEh0uc3luY3R2LmNs'
    'aWVudC5HZXRSb29tUmVxdWVzdBoeLnN5bmN0di5jbGllbnQuR2V0Um9vbVJlc3BvbnNlEksKCE'
    'pvaW5Sb29tEh4uc3luY3R2LmNsaWVudC5Kb2luUm9vbVJlcXVlc3QaHy5zeW5jdHYuY2xpZW50'
    'LkpvaW5Sb29tUmVzcG9uc2USdQoWU3RhcnRSb29tUGFzc3dvcmRMb2dpbhIsLnN5bmN0di5jbG'
    'llbnQuU3RhcnRSb29tUGFzc3dvcmRMb2dpblJlcXVlc3QaLS5zeW5jdHYuY2xpZW50LlN0YXJ0'
    'Um9vbVBhc3N3b3JkTG9naW5SZXNwb25zZRJpChdGaW5pc2hSb29tUGFzc3dvcmRMb2dpbhItLn'
    'N5bmN0di5jbGllbnQuRmluaXNoUm9vbVBhc3N3b3JkTG9naW5SZXF1ZXN0Gh8uc3luY3R2LmNs'
    'aWVudC5Kb2luUm9vbVJlc3BvbnNlElQKC0xpc3RNeVJvb21zEiEuc3luY3R2LmNsaWVudC5MaX'
    'N0TXlSb29tc1JlcXVlc3QaIi5zeW5jdHYuY2xpZW50Lkxpc3RNeVJvb21zUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> RoomServiceBase$json = {
  '1': 'RoomService',
  '2': [
    {
      '1': 'GetRoomSettings',
      '2': '.synctv.client.GetRoomSettingsRequest',
      '3': '.synctv.client.GetRoomSettingsResponse'
    },
    {
      '1': 'UpdateRoomSettings',
      '2': '.synctv.client.UpdateRoomSettingsRequest',
      '3': '.synctv.client.UpdateRoomSettingsResponse'
    },
    {
      '1': 'ResetRoomSettings',
      '2': '.synctv.client.ResetRoomSettingsRequest',
      '3': '.synctv.client.ResetRoomSettingsResponse'
    },
    {
      '1': 'TransferRoomOwnership',
      '2': '.synctv.client.TransferRoomOwnershipRequest',
      '3': '.synctv.client.TransferRoomOwnershipResponse'
    },
    {
      '1': 'LeaveRoom',
      '2': '.synctv.client.LeaveRoomRequest',
      '3': '.synctv.client.LeaveRoomResponse'
    },
    {
      '1': 'DeleteRoom',
      '2': '.synctv.client.DeleteRoomRequest',
      '3': '.synctv.client.DeleteRoomResponse'
    },
    {
      '1': 'StartRoomPasswordRegistration',
      '2': '.synctv.client.StartRoomPasswordRegistrationRequest',
      '3': '.synctv.client.StartRoomPasswordRegistrationResponse'
    },
    {
      '1': 'FinishRoomPasswordRegistration',
      '2': '.synctv.client.FinishRoomPasswordRegistrationRequest',
      '3': '.synctv.client.SetRoomPasswordResponse'
    },
    {
      '1': 'ClearRoomPassword',
      '2': '.synctv.client.ClearRoomPasswordRequest',
      '3': '.synctv.client.SetRoomPasswordResponse'
    },
    {
      '1': 'GetRoomMembers',
      '2': '.synctv.client.GetRoomMembersRequest',
      '3': '.synctv.client.GetRoomMembersResponse'
    },
    {
      '1': 'ListRoomStreams',
      '2': '.synctv.client.ListRoomStreamsRequest',
      '3': '.synctv.client.ListRoomStreamsResponse'
    },
    {
      '1': 'GetRoomStreamInfo',
      '2': '.synctv.client.GetRoomStreamInfoRequest',
      '3': '.synctv.client.GetRoomStreamInfoResponse'
    },
    {
      '1': 'KickRoomStream',
      '2': '.synctv.client.KickRoomStreamRequest',
      '3': '.synctv.client.KickRoomStreamResponse'
    },
    {
      '1': 'AddMember',
      '2': '.synctv.client.AddMemberRequest',
      '3': '.synctv.client.AddMemberResponse'
    },
    {
      '1': 'ListRoomJoinReviews',
      '2': '.synctv.client.ListRoomJoinReviewsRequest',
      '3': '.synctv.client.ListRoomJoinReviewsResponse'
    },
    {
      '1': 'ApproveRoomJoinReview',
      '2': '.synctv.client.ApproveRoomJoinReviewRequest',
      '3': '.synctv.client.ApproveRoomJoinReviewResponse'
    },
    {
      '1': 'RejectRoomJoinReview',
      '2': '.synctv.client.RejectRoomJoinReviewRequest',
      '3': '.synctv.client.RejectRoomJoinReviewResponse'
    },
    {
      '1': 'UpdateMemberPermissions',
      '2': '.synctv.client.UpdateMemberPermissionsRequest',
      '3': '.synctv.client.UpdateMemberPermissionsResponse'
    },
    {
      '1': 'KickMember',
      '2': '.synctv.client.KickMemberRequest',
      '3': '.synctv.client.KickMemberResponse'
    },
    {
      '1': 'CreateWebSocketTicket',
      '2': '.synctv.client.CreateWebSocketTicketRequest',
      '3': '.synctv.client.CreateWebSocketTicketResponse'
    },
    {
      '1': 'MessageStream',
      '2': '.synctv.client.ClientMessage',
      '3': '.synctv.client.ServerMessage',
      '5': true,
      '6': true
    },
    {
      '1': 'WatchPlaybackState',
      '2': '.synctv.client.WatchPlaybackStateRequest',
      '3': '.synctv.client.WatchPlaybackStateEvent',
      '6': true
    },
    {
      '1': 'WatchPlayback',
      '2': '.synctv.client.WatchPlaybackRequest',
      '3': '.synctv.client.WatchPlaybackEvent',
      '6': true
    },
    {
      '1': 'WatchRoomSettings',
      '2': '.synctv.client.WatchRoomSettingsRequest',
      '3': '.synctv.client.WatchRoomSettingsEvent',
      '6': true
    },
    {
      '1': 'WatchPlaylistItems',
      '2': '.synctv.client.WatchPlaylistItemsRequest',
      '3': '.synctv.client.WatchPlaylistItemsEvent',
      '6': true
    },
    {
      '1': 'WatchRoomMemberEvents',
      '2': '.synctv.client.WatchRoomMemberEventsRequest',
      '3': '.synctv.client.WatchRoomMemberEventsEvent',
      '6': true
    },
    {
      '1': 'WatchChatEvents',
      '2': '.synctv.client.WatchChatEventsRequest',
      '3': '.synctv.client.WatchChatEventsEvent',
      '6': true
    },
    {
      '1': 'CreateChatImageUploadSession',
      '2': '.synctv.client.CreateChatImageUploadSessionRequest',
      '3': '.synctv.client.CreateChatImageUploadSessionResponse'
    },
    {
      '1': 'UploadChatImageObject',
      '2': '.synctv.client.UploadChatImageObjectRequest',
      '3': '.synctv.client.UploadChatImageObjectResponse'
    },
    {
      '1': 'GetChatImageObject',
      '2': '.synctv.client.GetChatImageObjectRequest',
      '3': '.synctv.client.ChatImageObjectResponse'
    },
    {
      '1': 'CreateRoomCoverUploadSession',
      '2': '.synctv.client.CreateRoomCoverUploadSessionRequest',
      '3': '.synctv.client.CreateRoomCoverUploadSessionResponse'
    },
    {
      '1': 'UploadRoomCoverObject',
      '2': '.synctv.client.UploadRoomCoverObjectRequest',
      '3': '.synctv.client.UploadRoomCoverObjectResponse'
    },
    {
      '1': 'GetRoomCoverObject',
      '2': '.synctv.client.GetRoomCoverObjectRequest',
      '3': '.synctv.client.RoomCoverObjectResponse'
    },
    {
      '1': 'UpdateRoomCover',
      '2': '.synctv.client.UpdateRoomCoverRequest',
      '3': '.synctv.client.GetRoomResponse'
    },
    {
      '1': 'ClearRoomCover',
      '2': '.synctv.client.ClearRoomCoverRequest',
      '3': '.synctv.client.GetRoomResponse'
    },
    {
      '1': 'SendChatMessage',
      '2': '.synctv.client.SendChatMessageRequest',
      '3': '.synctv.client.ChatMessageEventResponse'
    },
    {
      '1': 'EditChatMessage',
      '2': '.synctv.client.EditChatMessageRequest',
      '3': '.synctv.client.ChatMessageEventResponse'
    },
    {
      '1': 'DeleteChatMessage',
      '2': '.synctv.client.DeleteChatMessageRequest',
      '3': '.synctv.client.ChatMessageEventResponse'
    },
    {
      '1': 'GetChatHistory',
      '2': '.synctv.client.GetChatHistoryRequest',
      '3': '.synctv.client.GetChatHistoryResponse'
    },
    {
      '1': 'GetChatMessage',
      '2': '.synctv.client.GetChatMessageRequest',
      '3': '.synctv.client.GetChatMessageResponse'
    },
    {
      '1': 'GetChatMessageContext',
      '2': '.synctv.client.GetChatMessageContextRequest',
      '3': '.synctv.client.GetChatMessageContextResponse'
    },
    {
      '1': 'GetChatPlaybackMessages',
      '2': '.synctv.client.GetChatPlaybackMessagesRequest',
      '3': '.synctv.client.GetChatPlaybackMessagesResponse'
    },
    {
      '1': 'SetChatReaction',
      '2': '.synctv.client.SetChatReactionRequest',
      '3': '.synctv.client.SetChatReactionResponse'
    },
    {
      '1': 'ListChatReactionUsers',
      '2': '.synctv.client.ListChatReactionUsersRequest',
      '3': '.synctv.client.ListChatReactionUsersResponse'
    },
    {
      '1': 'MarkChatRead',
      '2': '.synctv.client.MarkChatReadRequest',
      '3': '.synctv.client.ChatReadStateResponse'
    },
    {
      '1': 'GetChatReadState',
      '2': '.synctv.client.GetChatReadStateRequest',
      '3': '.synctv.client.ChatReadStateResponse'
    },
    {
      '1': 'GetChatMessageReadReceipts',
      '2': '.synctv.client.GetChatMessageReadReceiptsRequest',
      '3': '.synctv.client.GetChatMessageReadReceiptsResponse'
    },
    {
      '1': 'ReportContent',
      '2': '.synctv.client.ReportContentRequest',
      '3': '.synctv.client.ReportContentResponse'
    },
    {
      '1': 'ListRoomContentReports',
      '2': '.synctv.client.ListRoomContentReportsRequest',
      '3': '.synctv.client.ListRoomContentReportsResponse'
    },
    {
      '1': 'GetRoomContentReport',
      '2': '.synctv.client.GetRoomContentReportRequest',
      '3': '.synctv.client.GetRoomContentReportResponse'
    },
    {
      '1': 'UpdateRoomContentReportStatus',
      '2': '.synctv.client.UpdateRoomContentReportStatusRequest',
      '3': '.synctv.client.UpdateRoomContentReportStatusResponse'
    },
    {
      '1': 'GetIceServers',
      '2': '.synctv.client.GetIceServersRequest',
      '3': '.synctv.client.GetIceServersResponse'
    },
    {
      '1': 'CreatePlaylist',
      '2': '.synctv.client.CreatePlaylistRequest',
      '3': '.synctv.client.CreatePlaylistResponse'
    },
    {
      '1': 'GetPlaylist',
      '2': '.synctv.client.GetPlaylistRequest',
      '3': '.synctv.client.GetPlaylistResponse'
    },
    {
      '1': 'UpdatePlaylist',
      '2': '.synctv.client.UpdatePlaylistRequest',
      '3': '.synctv.client.UpdatePlaylistResponse'
    },
    {
      '1': 'CreatePlaylistCoverUploadSession',
      '2': '.synctv.client.CreatePlaylistCoverUploadSessionRequest',
      '3': '.synctv.client.CreatePlaylistCoverUploadSessionResponse'
    },
    {
      '1': 'UploadPlaylistCoverObject',
      '2': '.synctv.client.UploadPlaylistCoverObjectRequest',
      '3': '.synctv.client.UploadPlaylistCoverObjectResponse'
    },
    {
      '1': 'GetPlaylistCoverObject',
      '2': '.synctv.client.GetPlaylistCoverObjectRequest',
      '3': '.synctv.client.PlaylistCoverObjectResponse'
    },
    {
      '1': 'UpdatePlaylistCover',
      '2': '.synctv.client.UpdatePlaylistCoverRequest',
      '3': '.synctv.client.UpdatePlaylistResponse'
    },
    {
      '1': 'ClearPlaylistCover',
      '2': '.synctv.client.ClearPlaylistCoverRequest',
      '3': '.synctv.client.UpdatePlaylistResponse'
    },
    {
      '1': 'MovePlaylist',
      '2': '.synctv.client.MovePlaylistRequest',
      '3': '.synctv.client.MovePlaylistResponse'
    },
    {
      '1': 'DeletePlaylist',
      '2': '.synctv.client.DeletePlaylistRequest',
      '3': '.synctv.client.DeletePlaylistResponse'
    },
    {
      '1': 'ListPlaylists',
      '2': '.synctv.client.ListPlaylistsRequest',
      '3': '.synctv.client.ListPlaylistsResponse'
    },
    {
      '1': 'AddMedia',
      '2': '.synctv.client.AddMediaRequest',
      '3': '.synctv.client.AddMediaResponse'
    },
    {
      '1': 'GetMedia',
      '2': '.synctv.client.GetMediaRequest',
      '3': '.synctv.client.Media'
    },
    {
      '1': 'CreateVideoCoverUploadSession',
      '2': '.synctv.client.CreateVideoCoverUploadSessionRequest',
      '3': '.synctv.client.CreateVideoCoverUploadSessionResponse'
    },
    {
      '1': 'UploadVideoCoverObject',
      '2': '.synctv.client.UploadVideoCoverObjectRequest',
      '3': '.synctv.client.UploadVideoCoverObjectResponse'
    },
    {
      '1': 'GetVideoCoverObject',
      '2': '.synctv.client.GetVideoCoverObjectRequest',
      '3': '.synctv.client.VideoCoverObjectResponse'
    },
    {
      '1': 'UpdateVideoCover',
      '2': '.synctv.client.UpdateVideoCoverRequest',
      '3': '.synctv.client.EditMediaResponse'
    },
    {
      '1': 'ClearVideoCover',
      '2': '.synctv.client.ClearVideoCoverRequest',
      '3': '.synctv.client.EditMediaResponse'
    },
    {
      '1': 'DeleteMedia',
      '2': '.synctv.client.DeleteMediaRequest',
      '3': '.synctv.client.DeleteMediaResponse'
    },
    {
      '1': 'DeleteEntries',
      '2': '.synctv.client.DeleteEntriesRequest',
      '3': '.synctv.client.DeleteEntriesResponse'
    },
    {
      '1': 'EditMedia',
      '2': '.synctv.client.EditMediaRequest',
      '3': '.synctv.client.EditMediaResponse'
    },
    {
      '1': 'ListPlaylistItems',
      '2': '.synctv.client.ListPlaylistItemsRequest',
      '3': '.synctv.client.ListPlaylistItemsResponse'
    },
    {
      '1': 'MoveMedia',
      '2': '.synctv.client.MoveMediaRequest',
      '3': '.synctv.client.MoveMediaResponse'
    },
    {
      '1': 'ClearPlaylist',
      '2': '.synctv.client.ClearPlaylistRequest',
      '3': '.synctv.client.ClearPlaylistResponse'
    },
    {
      '1': 'AddMediaBatch',
      '2': '.synctv.client.AddMediaBatchRequest',
      '3': '.synctv.client.AddMediaBatchResponse'
    },
    {
      '1': 'StartPlayback',
      '2': '.synctv.client.StartPlaybackRequest',
      '3': '.synctv.client.StartPlaybackResponse'
    },
    {
      '1': 'StopPlayback',
      '2': '.synctv.client.StopPlaybackRequest',
      '3': '.synctv.client.StopPlaybackResponse'
    },
    {
      '1': 'GetPlayback',
      '2': '.synctv.client.GetPlaybackRequest',
      '3': '.synctv.client.GetPlaybackResponse'
    },
    {
      '1': 'UpdatePlaybackState',
      '2': '.synctv.client.UpdatePlaybackStateRequest',
      '3': '.synctv.client.UpdatePlaybackStateResponse'
    },
  ],
};

@$core.Deprecated('Use roomServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RoomServiceBase$messageJson = {
  '.synctv.client.GetRoomSettingsRequest': GetRoomSettingsRequest$json,
  '.synctv.client.GetRoomSettingsResponse': GetRoomSettingsResponse$json,
  '.synctv.client.UpdateRoomSettingsRequest': UpdateRoomSettingsRequest$json,
  '.synctv.client.UpdateRoomSettingsResponse': UpdateRoomSettingsResponse$json,
  '.synctv.client.Room': Room$json,
  '.synctv.client.ResourceCover': ResourceCover$json,
  '.synctv.common.RoomPresenceStats': $0.RoomPresenceStats$json,
  '.synctv.common.NodeConnectionCount': $0.NodeConnectionCount$json,
  '.synctv.client.UserPublicView': UserPublicView$json,
  '.synctv.client.UserAvatar': UserAvatar$json,
  '.synctv.client.ResetRoomSettingsRequest': ResetRoomSettingsRequest$json,
  '.synctv.client.ResetRoomSettingsResponse': ResetRoomSettingsResponse$json,
  '.synctv.client.TransferRoomOwnershipRequest':
      TransferRoomOwnershipRequest$json,
  '.synctv.client.TransferRoomOwnershipResponse':
      TransferRoomOwnershipResponse$json,
  '.synctv.client.LeaveRoomRequest': LeaveRoomRequest$json,
  '.synctv.client.LeaveRoomResponse': LeaveRoomResponse$json,
  '.synctv.client.DeleteRoomRequest': DeleteRoomRequest$json,
  '.synctv.client.DeleteRoomResponse': DeleteRoomResponse$json,
  '.synctv.client.StartRoomPasswordRegistrationRequest':
      StartRoomPasswordRegistrationRequest$json,
  '.synctv.client.StartRoomPasswordRegistrationResponse':
      StartRoomPasswordRegistrationResponse$json,
  '.synctv.client.FinishRoomPasswordRegistrationRequest':
      FinishRoomPasswordRegistrationRequest$json,
  '.synctv.client.SetRoomPasswordResponse': SetRoomPasswordResponse$json,
  '.synctv.client.ClearRoomPasswordRequest': ClearRoomPasswordRequest$json,
  '.synctv.client.GetRoomMembersRequest': GetRoomMembersRequest$json,
  '.synctv.client.GetRoomMembersResponse': GetRoomMembersResponse$json,
  '.synctv.common.RoomMember': $0.RoomMember$json,
  '.synctv.client.ListRoomStreamsRequest': ListRoomStreamsRequest$json,
  '.synctv.client.ListRoomStreamsResponse': ListRoomStreamsResponse$json,
  '.synctv.client.StreamEntry': StreamEntry$json,
  '.synctv.client.GetRoomStreamInfoRequest': GetRoomStreamInfoRequest$json,
  '.synctv.client.GetRoomStreamInfoResponse': GetRoomStreamInfoResponse$json,
  '.synctv.client.RoomStreamPublisherInfo': RoomStreamPublisherInfo$json,
  '.synctv.client.KickRoomStreamRequest': KickRoomStreamRequest$json,
  '.synctv.client.KickRoomStreamResponse': KickRoomStreamResponse$json,
  '.synctv.client.AddMemberRequest': AddMemberRequest$json,
  '.synctv.client.AddMemberResponse': AddMemberResponse$json,
  '.synctv.client.ListRoomJoinReviewsRequest': ListRoomJoinReviewsRequest$json,
  '.synctv.client.ListRoomJoinReviewsResponse':
      ListRoomJoinReviewsResponse$json,
  '.synctv.client.RoomJoinReview': RoomJoinReview$json,
  '.synctv.client.ApproveRoomJoinReviewRequest':
      ApproveRoomJoinReviewRequest$json,
  '.synctv.client.ApproveRoomJoinReviewResponse':
      ApproveRoomJoinReviewResponse$json,
  '.synctv.client.RejectRoomJoinReviewRequest':
      RejectRoomJoinReviewRequest$json,
  '.synctv.client.RejectRoomJoinReviewResponse':
      RejectRoomJoinReviewResponse$json,
  '.synctv.client.UpdateMemberPermissionsRequest':
      UpdateMemberPermissionsRequest$json,
  '.synctv.client.UpdateMemberPermissionsResponse':
      UpdateMemberPermissionsResponse$json,
  '.synctv.client.KickMemberRequest': KickMemberRequest$json,
  '.synctv.client.KickMemberResponse': KickMemberResponse$json,
  '.synctv.client.CreateWebSocketTicketRequest':
      CreateWebSocketTicketRequest$json,
  '.synctv.client.CreateWebSocketTicketResponse':
      CreateWebSocketTicketResponse$json,
  '.synctv.client.ClientMessage': ClientMessage$json,
  '.synctv.client.ChatMessageSend': ChatMessageSend$json,
  '.synctv.client.ChatImage': ChatImage$json,
  '.synctv.client.ChatMentionInput': ChatMentionInput$json,
  '.synctv.client.HeartbeatMessage': HeartbeatMessage$json,
  '.synctv.client.UpdatePlaybackStateRequest': UpdatePlaybackStateRequest$json,
  '.synctv.client.UpdatePlaybackRequest': UpdatePlaybackRequest$json,
  '.synctv.client.ObserveResource': ObserveResource$json,
  '.synctv.client.ObservePlaybackState': ObservePlaybackState$json,
  '.synctv.client.ObservePlayback': ObservePlayback$json,
  '.synctv.client.PlaybackClientProfile': PlaybackClientProfile$json,
  '.synctv.client.ObserveRoomSettings': ObserveRoomSettings$json,
  '.synctv.client.ObservePlaylistItems': ObservePlaylistItems$json,
  '.synctv.client.ListPlaylistItemsRequest': ListPlaylistItemsRequest$json,
  '.synctv.client.ObserveRoomMemberEvents': ObserveRoomMemberEvents$json,
  '.synctv.client.ObserveChatEvents': ObserveChatEvents$json,
  '.synctv.client.ObserveOnlineCount': ObserveOnlineCount$json,
  '.synctv.client.ObserveOnlineEvent': ObserveOnlineEvent$json,
  '.synctv.client.ObserveSelfRoomMember': ObserveSelfRoomMember$json,
  '.synctv.client.UnobserveResource': UnobserveResource$json,
  '.synctv.client.WebRtcCommand': WebRtcCommand$json,
  '.synctv.client.WebRTCOffer': WebRTCOffer$json,
  '.synctv.client.WebRTCAnswer': WebRTCAnswer$json,
  '.synctv.client.WebRTCIceCandidate': WebRTCIceCandidate$json,
  '.synctv.client.WebRTCJoin': WebRTCJoin$json,
  '.synctv.client.WebRTCLeave': WebRTCLeave$json,
  '.synctv.client.ServerMessage': ServerMessage$json,
  '.synctv.client.HeartbeatAck': HeartbeatAck$json,
  '.synctv.client.ErrorMessage': ErrorMessage$json,
  '.synctv.client.UserNotification': UserNotification$json,
  '.synctv.client.ResourceObserved': ResourceObserved$json,
  '.synctv.client.EventCursor': EventCursor$json,
  '.synctv.client.ResourceEvent': ResourceEvent$json,
  '.synctv.client.ResourceEventOnly': ResourceEventOnly$json,
  '.synctv.client.PlaybackState': PlaybackState$json,
  '.synctv.client.Playback': Playback$json,
  '.synctv.client.Playback.PlaybackInfosEntry':
      Playback_PlaybackInfosEntry$json,
  '.synctv.client.PlaybackInfo': PlaybackInfo$json,
  '.synctv.client.PlaybackUrl': PlaybackUrl$json,
  '.synctv.client.PlaybackUrl.HeadersEntry': PlaybackUrl_HeadersEntry$json,
  '.synctv.client.PlaybackUrlMetadata': PlaybackUrlMetadata$json,
  '.synctv.client.PlaybackUrlMetadata.ExtraEntry':
      PlaybackUrlMetadata_ExtraEntry$json,
  '.synctv.client.Subtitle': Subtitle$json,
  '.synctv.client.SubtitleUrl': SubtitleUrl$json,
  '.synctv.client.SubtitleUrl.HeadersEntry': SubtitleUrl_HeadersEntry$json,
  '.synctv.client.Danmaku': Danmaku$json,
  '.synctv.client.Danmaku.HeadersEntry': Danmaku_HeadersEntry$json,
  '.synctv.client.Playback.MetadataEntry': Playback_MetadataEntry$json,
  '.synctv.client.ListPlaylistItemsResponse': ListPlaylistItemsResponse$json,
  '.synctv.client.Playlist': Playlist$json,
  '.synctv.client.Media': Media$json,
  '.synctv.client.VideoCover': VideoCover$json,
  '.synctv.client.PlaylistItem': PlaylistItem$json,
  '.synctv.client.PlaylistBrowsePathNode': PlaylistBrowsePathNode$json,
  '.synctv.client.RoomMemberEvent': RoomMemberEvent$json,
  '.synctv.client.ChatMessageEvent': ChatMessageEvent$json,
  '.synctv.client.ChatMessageReceive': ChatMessageReceive$json,
  '.synctv.client.ChatReactionSummary': ChatReactionSummary$json,
  '.synctv.client.ChatMention': ChatMention$json,
  '.synctv.client.OnlineCount': OnlineCount$json,
  '.synctv.client.OnlineEvent': OnlineEvent$json,
  '.synctv.client.WebRtcEvent': WebRtcEvent$json,
  '.synctv.client.ResourceObserveError': ResourceObserveError$json,
  '.synctv.client.WatchPlaybackStateRequest': WatchPlaybackStateRequest$json,
  '.synctv.client.WatchPlaybackStateEvent': WatchPlaybackStateEvent$json,
  '.synctv.client.WatchPlaybackRequest': WatchPlaybackRequest$json,
  '.synctv.client.WatchPlaybackEvent': WatchPlaybackEvent$json,
  '.synctv.client.WatchRoomSettingsRequest': WatchRoomSettingsRequest$json,
  '.synctv.client.WatchRoomSettingsEvent': WatchRoomSettingsEvent$json,
  '.synctv.client.WatchPlaylistItemsRequest': WatchPlaylistItemsRequest$json,
  '.synctv.client.WatchPlaylistItemsEvent': WatchPlaylistItemsEvent$json,
  '.synctv.client.WatchRoomMemberEventsRequest':
      WatchRoomMemberEventsRequest$json,
  '.synctv.client.WatchRoomMemberEventsEvent': WatchRoomMemberEventsEvent$json,
  '.synctv.client.WatchChatEventsRequest': WatchChatEventsRequest$json,
  '.synctv.client.WatchChatEventsEvent': WatchChatEventsEvent$json,
  '.synctv.client.CreateChatImageUploadSessionRequest':
      CreateChatImageUploadSessionRequest$json,
  '.synctv.client.CreateChatImageUploadSessionResponse':
      CreateChatImageUploadSessionResponse$json,
  '.synctv.client.ChatImageUploadSession': ChatImageUploadSession$json,
  '.synctv.client.ChatImageUploadSession.UploadHeadersEntry':
      ChatImageUploadSession_UploadHeadersEntry$json,
  '.synctv.client.ChatImageOwnershipProofRange':
      ChatImageOwnershipProofRange$json,
  '.synctv.client.UploadChatImageObjectRequest':
      UploadChatImageObjectRequest$json,
  '.synctv.client.UploadChatImageObjectResponse':
      UploadChatImageObjectResponse$json,
  '.synctv.client.ChatImageObjectResponse': ChatImageObjectResponse$json,
  '.synctv.client.GetChatImageObjectRequest': GetChatImageObjectRequest$json,
  '.synctv.client.CreateRoomCoverUploadSessionRequest':
      CreateRoomCoverUploadSessionRequest$json,
  '.synctv.client.CreateRoomCoverUploadSessionResponse':
      CreateRoomCoverUploadSessionResponse$json,
  '.synctv.client.RoomCoverUploadSession': RoomCoverUploadSession$json,
  '.synctv.client.FileCover': FileCover$json,
  '.synctv.client.RoomCoverUploadSession.UploadHeadersEntry':
      RoomCoverUploadSession_UploadHeadersEntry$json,
  '.synctv.client.FileOwnershipProofRange': FileOwnershipProofRange$json,
  '.synctv.client.UploadRoomCoverObjectRequest':
      UploadRoomCoverObjectRequest$json,
  '.synctv.client.UploadRoomCoverObjectResponse':
      UploadRoomCoverObjectResponse$json,
  '.synctv.client.RoomCoverObjectResponse': RoomCoverObjectResponse$json,
  '.synctv.client.GetRoomCoverObjectRequest': GetRoomCoverObjectRequest$json,
  '.synctv.client.UpdateRoomCoverRequest': UpdateRoomCoverRequest$json,
  '.synctv.client.GetRoomResponse': GetRoomResponse$json,
  '.synctv.client.ClearRoomCoverRequest': ClearRoomCoverRequest$json,
  '.synctv.client.SendChatMessageRequest': SendChatMessageRequest$json,
  '.synctv.client.ChatMessageEventResponse': ChatMessageEventResponse$json,
  '.synctv.client.EditChatMessageRequest': EditChatMessageRequest$json,
  '.synctv.client.DeleteChatMessageRequest': DeleteChatMessageRequest$json,
  '.synctv.client.GetChatHistoryRequest': GetChatHistoryRequest$json,
  '.synctv.client.GetChatHistoryResponse': GetChatHistoryResponse$json,
  '.synctv.client.GetChatMessageRequest': GetChatMessageRequest$json,
  '.synctv.client.GetChatMessageResponse': GetChatMessageResponse$json,
  '.synctv.client.GetChatMessageContextRequest':
      GetChatMessageContextRequest$json,
  '.synctv.client.GetChatMessageContextResponse':
      GetChatMessageContextResponse$json,
  '.synctv.client.GetChatPlaybackMessagesRequest':
      GetChatPlaybackMessagesRequest$json,
  '.synctv.client.GetChatPlaybackMessagesResponse':
      GetChatPlaybackMessagesResponse$json,
  '.synctv.client.SetChatReactionRequest': SetChatReactionRequest$json,
  '.synctv.client.SetChatReactionResponse': SetChatReactionResponse$json,
  '.synctv.client.ListChatReactionUsersRequest':
      ListChatReactionUsersRequest$json,
  '.synctv.client.ListChatReactionUsersResponse':
      ListChatReactionUsersResponse$json,
  '.synctv.client.ChatReactionUser': ChatReactionUser$json,
  '.synctv.client.MarkChatReadRequest': MarkChatReadRequest$json,
  '.synctv.client.ChatReadStateResponse': ChatReadStateResponse$json,
  '.synctv.client.ChatReadState': ChatReadState$json,
  '.synctv.client.GetChatReadStateRequest': GetChatReadStateRequest$json,
  '.synctv.client.GetChatMessageReadReceiptsRequest':
      GetChatMessageReadReceiptsRequest$json,
  '.synctv.client.GetChatMessageReadReceiptsResponse':
      GetChatMessageReadReceiptsResponse$json,
  '.synctv.client.ChatMessageReadReceiptUser': ChatMessageReadReceiptUser$json,
  '.synctv.client.ChatMessageUnreadMember': ChatMessageUnreadMember$json,
  '.synctv.client.ReportContentRequest': ReportContentRequest$json,
  '.synctv.client.ReportRoomTarget': ReportRoomTarget$json,
  '.synctv.client.ReportUserTarget': ReportUserTarget$json,
  '.synctv.client.ReportRoomMemberTarget': ReportRoomMemberTarget$json,
  '.synctv.client.ReportChatMessageTarget': ReportChatMessageTarget$json,
  '.synctv.client.ReportContentResponse': ReportContentResponse$json,
  '.synctv.client.ListRoomContentReportsRequest':
      ListRoomContentReportsRequest$json,
  '.synctv.client.ListRoomContentReportsResponse':
      ListRoomContentReportsResponse$json,
  '.synctv.client.ContentReport': ContentReport$json,
  '.synctv.client.GetRoomContentReportRequest':
      GetRoomContentReportRequest$json,
  '.synctv.client.GetRoomContentReportResponse':
      GetRoomContentReportResponse$json,
  '.synctv.client.UpdateRoomContentReportStatusRequest':
      UpdateRoomContentReportStatusRequest$json,
  '.synctv.client.UpdateRoomContentReportStatusResponse':
      UpdateRoomContentReportStatusResponse$json,
  '.synctv.client.GetIceServersRequest': GetIceServersRequest$json,
  '.synctv.client.GetIceServersResponse': GetIceServersResponse$json,
  '.synctv.client.IceServer': IceServer$json,
  '.synctv.client.WebRtcStatus': WebRtcStatus$json,
  '.synctv.client.CreatePlaylistRequest': CreatePlaylistRequest$json,
  '.synctv.client.CreatePlaylistResponse': CreatePlaylistResponse$json,
  '.synctv.client.GetPlaylistRequest': GetPlaylistRequest$json,
  '.synctv.client.GetPlaylistResponse': GetPlaylistResponse$json,
  '.synctv.client.UpdatePlaylistRequest': UpdatePlaylistRequest$json,
  '.synctv.client.UpdatePlaylistResponse': UpdatePlaylistResponse$json,
  '.synctv.client.CreatePlaylistCoverUploadSessionRequest':
      CreatePlaylistCoverUploadSessionRequest$json,
  '.synctv.client.CreatePlaylistCoverUploadSessionResponse':
      CreatePlaylistCoverUploadSessionResponse$json,
  '.synctv.client.PlaylistCoverUploadSession': PlaylistCoverUploadSession$json,
  '.synctv.client.PlaylistCoverUploadSession.UploadHeadersEntry':
      PlaylistCoverUploadSession_UploadHeadersEntry$json,
  '.synctv.client.UploadPlaylistCoverObjectRequest':
      UploadPlaylistCoverObjectRequest$json,
  '.synctv.client.UploadPlaylistCoverObjectResponse':
      UploadPlaylistCoverObjectResponse$json,
  '.synctv.client.PlaylistCoverObjectResponse':
      PlaylistCoverObjectResponse$json,
  '.synctv.client.GetPlaylistCoverObjectRequest':
      GetPlaylistCoverObjectRequest$json,
  '.synctv.client.UpdatePlaylistCoverRequest': UpdatePlaylistCoverRequest$json,
  '.synctv.client.ClearPlaylistCoverRequest': ClearPlaylistCoverRequest$json,
  '.synctv.client.MovePlaylistRequest': MovePlaylistRequest$json,
  '.synctv.client.MovePlaylistResponse': MovePlaylistResponse$json,
  '.synctv.client.DeletePlaylistRequest': DeletePlaylistRequest$json,
  '.synctv.client.DeletePlaylistResponse': DeletePlaylistResponse$json,
  '.synctv.client.ListPlaylistsRequest': ListPlaylistsRequest$json,
  '.synctv.client.ListPlaylistsResponse': ListPlaylistsResponse$json,
  '.synctv.client.AddMediaRequest': AddMediaRequest$json,
  '.synctv.client.AddMediaResponse': AddMediaResponse$json,
  '.synctv.client.GetMediaRequest': GetMediaRequest$json,
  '.synctv.client.CreateVideoCoverUploadSessionRequest':
      CreateVideoCoverUploadSessionRequest$json,
  '.synctv.client.CreateVideoCoverUploadSessionResponse':
      CreateVideoCoverUploadSessionResponse$json,
  '.synctv.client.VideoCoverUploadSession': VideoCoverUploadSession$json,
  '.synctv.client.VideoCoverUploadSession.UploadHeadersEntry':
      VideoCoverUploadSession_UploadHeadersEntry$json,
  '.synctv.client.VideoCoverOwnershipProofRange':
      VideoCoverOwnershipProofRange$json,
  '.synctv.client.UploadVideoCoverObjectRequest':
      UploadVideoCoverObjectRequest$json,
  '.synctv.client.UploadVideoCoverObjectResponse':
      UploadVideoCoverObjectResponse$json,
  '.synctv.client.VideoCoverObjectResponse': VideoCoverObjectResponse$json,
  '.synctv.client.GetVideoCoverObjectRequest': GetVideoCoverObjectRequest$json,
  '.synctv.client.UpdateVideoCoverRequest': UpdateVideoCoverRequest$json,
  '.synctv.client.EditMediaResponse': EditMediaResponse$json,
  '.synctv.client.ClearVideoCoverRequest': ClearVideoCoverRequest$json,
  '.synctv.client.DeleteMediaRequest': DeleteMediaRequest$json,
  '.synctv.client.DeleteMediaResponse': DeleteMediaResponse$json,
  '.synctv.client.DeleteEntriesRequest': DeleteEntriesRequest$json,
  '.synctv.client.DeleteEntriesResponse': DeleteEntriesResponse$json,
  '.synctv.client.EditMediaRequest': EditMediaRequest$json,
  '.synctv.client.MoveMediaRequest': MoveMediaRequest$json,
  '.synctv.client.MoveMediaResponse': MoveMediaResponse$json,
  '.synctv.client.ClearPlaylistRequest': ClearPlaylistRequest$json,
  '.synctv.client.ClearPlaylistResponse': ClearPlaylistResponse$json,
  '.synctv.client.AddMediaBatchRequest': AddMediaBatchRequest$json,
  '.synctv.client.AddMediaBatchResponse': AddMediaBatchResponse$json,
  '.synctv.client.StartPlaybackRequest': StartPlaybackRequest$json,
  '.synctv.client.StartPlaybackResponse': StartPlaybackResponse$json,
  '.synctv.client.StopPlaybackRequest': StopPlaybackRequest$json,
  '.synctv.client.StopPlaybackResponse': StopPlaybackResponse$json,
  '.synctv.client.GetPlaybackRequest': GetPlaybackRequest$json,
  '.synctv.client.GetPlaybackResponse': GetPlaybackResponse$json,
  '.synctv.client.UpdatePlaybackStateResponse':
      UpdatePlaybackStateResponse$json,
};

/// Descriptor for `RoomService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List roomServiceDescriptor = $convert.base64Decode(
    'CgtSb29tU2VydmljZRJgCg9HZXRSb29tU2V0dGluZ3MSJS5zeW5jdHYuY2xpZW50LkdldFJvb2'
    '1TZXR0aW5nc1JlcXVlc3QaJi5zeW5jdHYuY2xpZW50LkdldFJvb21TZXR0aW5nc1Jlc3BvbnNl'
    'EmkKElVwZGF0ZVJvb21TZXR0aW5ncxIoLnN5bmN0di5jbGllbnQuVXBkYXRlUm9vbVNldHRpbm'
    'dzUmVxdWVzdBopLnN5bmN0di5jbGllbnQuVXBkYXRlUm9vbVNldHRpbmdzUmVzcG9uc2USZgoR'
    'UmVzZXRSb29tU2V0dGluZ3MSJy5zeW5jdHYuY2xpZW50LlJlc2V0Um9vbVNldHRpbmdzUmVxdW'
    'VzdBooLnN5bmN0di5jbGllbnQuUmVzZXRSb29tU2V0dGluZ3NSZXNwb25zZRJyChVUcmFuc2Zl'
    'clJvb21Pd25lcnNoaXASKy5zeW5jdHYuY2xpZW50LlRyYW5zZmVyUm9vbU93bmVyc2hpcFJlcX'
    'Vlc3QaLC5zeW5jdHYuY2xpZW50LlRyYW5zZmVyUm9vbU93bmVyc2hpcFJlc3BvbnNlEk4KCUxl'
    'YXZlUm9vbRIfLnN5bmN0di5jbGllbnQuTGVhdmVSb29tUmVxdWVzdBogLnN5bmN0di5jbGllbn'
    'QuTGVhdmVSb29tUmVzcG9uc2USUQoKRGVsZXRlUm9vbRIgLnN5bmN0di5jbGllbnQuRGVsZXRl'
    'Um9vbVJlcXVlc3QaIS5zeW5jdHYuY2xpZW50LkRlbGV0ZVJvb21SZXNwb25zZRKKAQodU3Rhcn'
    'RSb29tUGFzc3dvcmRSZWdpc3RyYXRpb24SMy5zeW5jdHYuY2xpZW50LlN0YXJ0Um9vbVBhc3N3'
    'b3JkUmVnaXN0cmF0aW9uUmVxdWVzdBo0LnN5bmN0di5jbGllbnQuU3RhcnRSb29tUGFzc3dvcm'
    'RSZWdpc3RyYXRpb25SZXNwb25zZRJ+Ch5GaW5pc2hSb29tUGFzc3dvcmRSZWdpc3RyYXRpb24S'
    'NC5zeW5jdHYuY2xpZW50LkZpbmlzaFJvb21QYXNzd29yZFJlZ2lzdHJhdGlvblJlcXVlc3QaJi'
    '5zeW5jdHYuY2xpZW50LlNldFJvb21QYXNzd29yZFJlc3BvbnNlEmQKEUNsZWFyUm9vbVBhc3N3'
    'b3JkEicuc3luY3R2LmNsaWVudC5DbGVhclJvb21QYXNzd29yZFJlcXVlc3QaJi5zeW5jdHYuY2'
    'xpZW50LlNldFJvb21QYXNzd29yZFJlc3BvbnNlEl0KDkdldFJvb21NZW1iZXJzEiQuc3luY3R2'
    'LmNsaWVudC5HZXRSb29tTWVtYmVyc1JlcXVlc3QaJS5zeW5jdHYuY2xpZW50LkdldFJvb21NZW'
    '1iZXJzUmVzcG9uc2USYAoPTGlzdFJvb21TdHJlYW1zEiUuc3luY3R2LmNsaWVudC5MaXN0Um9v'
    'bVN0cmVhbXNSZXF1ZXN0GiYuc3luY3R2LmNsaWVudC5MaXN0Um9vbVN0cmVhbXNSZXNwb25zZR'
    'JmChFHZXRSb29tU3RyZWFtSW5mbxInLnN5bmN0di5jbGllbnQuR2V0Um9vbVN0cmVhbUluZm9S'
    'ZXF1ZXN0Giguc3luY3R2LmNsaWVudC5HZXRSb29tU3RyZWFtSW5mb1Jlc3BvbnNlEl0KDktpY2'
    'tSb29tU3RyZWFtEiQuc3luY3R2LmNsaWVudC5LaWNrUm9vbVN0cmVhbVJlcXVlc3QaJS5zeW5j'
    'dHYuY2xpZW50LktpY2tSb29tU3RyZWFtUmVzcG9uc2USTgoJQWRkTWVtYmVyEh8uc3luY3R2Lm'
    'NsaWVudC5BZGRNZW1iZXJSZXF1ZXN0GiAuc3luY3R2LmNsaWVudC5BZGRNZW1iZXJSZXNwb25z'
    'ZRJsChNMaXN0Um9vbUpvaW5SZXZpZXdzEikuc3luY3R2LmNsaWVudC5MaXN0Um9vbUpvaW5SZX'
    'ZpZXdzUmVxdWVzdBoqLnN5bmN0di5jbGllbnQuTGlzdFJvb21Kb2luUmV2aWV3c1Jlc3BvbnNl'
    'EnIKFUFwcHJvdmVSb29tSm9pblJldmlldxIrLnN5bmN0di5jbGllbnQuQXBwcm92ZVJvb21Kb2'
    'luUmV2aWV3UmVxdWVzdBosLnN5bmN0di5jbGllbnQuQXBwcm92ZVJvb21Kb2luUmV2aWV3UmVz'
    'cG9uc2USbwoUUmVqZWN0Um9vbUpvaW5SZXZpZXcSKi5zeW5jdHYuY2xpZW50LlJlamVjdFJvb2'
    '1Kb2luUmV2aWV3UmVxdWVzdBorLnN5bmN0di5jbGllbnQuUmVqZWN0Um9vbUpvaW5SZXZpZXdS'
    'ZXNwb25zZRJ4ChdVcGRhdGVNZW1iZXJQZXJtaXNzaW9ucxItLnN5bmN0di5jbGllbnQuVXBkYX'
    'RlTWVtYmVyUGVybWlzc2lvbnNSZXF1ZXN0Gi4uc3luY3R2LmNsaWVudC5VcGRhdGVNZW1iZXJQ'
    'ZXJtaXNzaW9uc1Jlc3BvbnNlElEKCktpY2tNZW1iZXISIC5zeW5jdHYuY2xpZW50LktpY2tNZW'
    '1iZXJSZXF1ZXN0GiEuc3luY3R2LmNsaWVudC5LaWNrTWVtYmVyUmVzcG9uc2UScgoVQ3JlYXRl'
    'V2ViU29ja2V0VGlja2V0Eisuc3luY3R2LmNsaWVudC5DcmVhdGVXZWJTb2NrZXRUaWNrZXRSZX'
    'F1ZXN0Giwuc3luY3R2LmNsaWVudC5DcmVhdGVXZWJTb2NrZXRUaWNrZXRSZXNwb25zZRJPCg1N'
    'ZXNzYWdlU3RyZWFtEhwuc3luY3R2LmNsaWVudC5DbGllbnRNZXNzYWdlGhwuc3luY3R2LmNsaW'
    'VudC5TZXJ2ZXJNZXNzYWdlKAEwARJoChJXYXRjaFBsYXliYWNrU3RhdGUSKC5zeW5jdHYuY2xp'
    'ZW50LldhdGNoUGxheWJhY2tTdGF0ZVJlcXVlc3QaJi5zeW5jdHYuY2xpZW50LldhdGNoUGxheW'
    'JhY2tTdGF0ZUV2ZW50MAESWQoNV2F0Y2hQbGF5YmFjaxIjLnN5bmN0di5jbGllbnQuV2F0Y2hQ'
    'bGF5YmFja1JlcXVlc3QaIS5zeW5jdHYuY2xpZW50LldhdGNoUGxheWJhY2tFdmVudDABEmUKEV'
    'dhdGNoUm9vbVNldHRpbmdzEicuc3luY3R2LmNsaWVudC5XYXRjaFJvb21TZXR0aW5nc1JlcXVl'
    'c3QaJS5zeW5jdHYuY2xpZW50LldhdGNoUm9vbVNldHRpbmdzRXZlbnQwARJoChJXYXRjaFBsYX'
    'lsaXN0SXRlbXMSKC5zeW5jdHYuY2xpZW50LldhdGNoUGxheWxpc3RJdGVtc1JlcXVlc3QaJi5z'
    'eW5jdHYuY2xpZW50LldhdGNoUGxheWxpc3RJdGVtc0V2ZW50MAEScQoVV2F0Y2hSb29tTWVtYm'
    'VyRXZlbnRzEisuc3luY3R2LmNsaWVudC5XYXRjaFJvb21NZW1iZXJFdmVudHNSZXF1ZXN0Giku'
    'c3luY3R2LmNsaWVudC5XYXRjaFJvb21NZW1iZXJFdmVudHNFdmVudDABEl8KD1dhdGNoQ2hhdE'
    'V2ZW50cxIlLnN5bmN0di5jbGllbnQuV2F0Y2hDaGF0RXZlbnRzUmVxdWVzdBojLnN5bmN0di5j'
    'bGllbnQuV2F0Y2hDaGF0RXZlbnRzRXZlbnQwARKHAQocQ3JlYXRlQ2hhdEltYWdlVXBsb2FkU2'
    'Vzc2lvbhIyLnN5bmN0di5jbGllbnQuQ3JlYXRlQ2hhdEltYWdlVXBsb2FkU2Vzc2lvblJlcXVl'
    'c3QaMy5zeW5jdHYuY2xpZW50LkNyZWF0ZUNoYXRJbWFnZVVwbG9hZFNlc3Npb25SZXNwb25zZR'
    'JyChVVcGxvYWRDaGF0SW1hZ2VPYmplY3QSKy5zeW5jdHYuY2xpZW50LlVwbG9hZENoYXRJbWFn'
    'ZU9iamVjdFJlcXVlc3QaLC5zeW5jdHYuY2xpZW50LlVwbG9hZENoYXRJbWFnZU9iamVjdFJlc3'
    'BvbnNlEmYKEkdldENoYXRJbWFnZU9iamVjdBIoLnN5bmN0di5jbGllbnQuR2V0Q2hhdEltYWdl'
    'T2JqZWN0UmVxdWVzdBomLnN5bmN0di5jbGllbnQuQ2hhdEltYWdlT2JqZWN0UmVzcG9uc2UShw'
    'EKHENyZWF0ZVJvb21Db3ZlclVwbG9hZFNlc3Npb24SMi5zeW5jdHYuY2xpZW50LkNyZWF0ZVJv'
    'b21Db3ZlclVwbG9hZFNlc3Npb25SZXF1ZXN0GjMuc3luY3R2LmNsaWVudC5DcmVhdGVSb29tQ2'
    '92ZXJVcGxvYWRTZXNzaW9uUmVzcG9uc2UScgoVVXBsb2FkUm9vbUNvdmVyT2JqZWN0Eisuc3lu'
    'Y3R2LmNsaWVudC5VcGxvYWRSb29tQ292ZXJPYmplY3RSZXF1ZXN0Giwuc3luY3R2LmNsaWVudC'
    '5VcGxvYWRSb29tQ292ZXJPYmplY3RSZXNwb25zZRJmChJHZXRSb29tQ292ZXJPYmplY3QSKC5z'
    'eW5jdHYuY2xpZW50LkdldFJvb21Db3Zlck9iamVjdFJlcXVlc3QaJi5zeW5jdHYuY2xpZW50Ll'
    'Jvb21Db3Zlck9iamVjdFJlc3BvbnNlElgKD1VwZGF0ZVJvb21Db3ZlchIlLnN5bmN0di5jbGll'
    'bnQuVXBkYXRlUm9vbUNvdmVyUmVxdWVzdBoeLnN5bmN0di5jbGllbnQuR2V0Um9vbVJlc3Bvbn'
    'NlElYKDkNsZWFyUm9vbUNvdmVyEiQuc3luY3R2LmNsaWVudC5DbGVhclJvb21Db3ZlclJlcXVl'
    'c3QaHi5zeW5jdHYuY2xpZW50LkdldFJvb21SZXNwb25zZRJhCg9TZW5kQ2hhdE1lc3NhZ2USJS'
    '5zeW5jdHYuY2xpZW50LlNlbmRDaGF0TWVzc2FnZVJlcXVlc3QaJy5zeW5jdHYuY2xpZW50LkNo'
    'YXRNZXNzYWdlRXZlbnRSZXNwb25zZRJhCg9FZGl0Q2hhdE1lc3NhZ2USJS5zeW5jdHYuY2xpZW'
    '50LkVkaXRDaGF0TWVzc2FnZVJlcXVlc3QaJy5zeW5jdHYuY2xpZW50LkNoYXRNZXNzYWdlRXZl'
    'bnRSZXNwb25zZRJlChFEZWxldGVDaGF0TWVzc2FnZRInLnN5bmN0di5jbGllbnQuRGVsZXRlQ2'
    'hhdE1lc3NhZ2VSZXF1ZXN0Gicuc3luY3R2LmNsaWVudC5DaGF0TWVzc2FnZUV2ZW50UmVzcG9u'
    'c2USXQoOR2V0Q2hhdEhpc3RvcnkSJC5zeW5jdHYuY2xpZW50LkdldENoYXRIaXN0b3J5UmVxdW'
    'VzdBolLnN5bmN0di5jbGllbnQuR2V0Q2hhdEhpc3RvcnlSZXNwb25zZRJdCg5HZXRDaGF0TWVz'
    'c2FnZRIkLnN5bmN0di5jbGllbnQuR2V0Q2hhdE1lc3NhZ2VSZXF1ZXN0GiUuc3luY3R2LmNsaW'
    'VudC5HZXRDaGF0TWVzc2FnZVJlc3BvbnNlEnIKFUdldENoYXRNZXNzYWdlQ29udGV4dBIrLnN5'
    'bmN0di5jbGllbnQuR2V0Q2hhdE1lc3NhZ2VDb250ZXh0UmVxdWVzdBosLnN5bmN0di5jbGllbn'
    'QuR2V0Q2hhdE1lc3NhZ2VDb250ZXh0UmVzcG9uc2USeAoXR2V0Q2hhdFBsYXliYWNrTWVzc2Fn'
    'ZXMSLS5zeW5jdHYuY2xpZW50LkdldENoYXRQbGF5YmFja01lc3NhZ2VzUmVxdWVzdBouLnN5bm'
    'N0di5jbGllbnQuR2V0Q2hhdFBsYXliYWNrTWVzc2FnZXNSZXNwb25zZRJgCg9TZXRDaGF0UmVh'
    'Y3Rpb24SJS5zeW5jdHYuY2xpZW50LlNldENoYXRSZWFjdGlvblJlcXVlc3QaJi5zeW5jdHYuY2'
    'xpZW50LlNldENoYXRSZWFjdGlvblJlc3BvbnNlEnIKFUxpc3RDaGF0UmVhY3Rpb25Vc2VycxIr'
    'LnN5bmN0di5jbGllbnQuTGlzdENoYXRSZWFjdGlvblVzZXJzUmVxdWVzdBosLnN5bmN0di5jbG'
    'llbnQuTGlzdENoYXRSZWFjdGlvblVzZXJzUmVzcG9uc2USWAoMTWFya0NoYXRSZWFkEiIuc3lu'
    'Y3R2LmNsaWVudC5NYXJrQ2hhdFJlYWRSZXF1ZXN0GiQuc3luY3R2LmNsaWVudC5DaGF0UmVhZF'
    'N0YXRlUmVzcG9uc2USYAoQR2V0Q2hhdFJlYWRTdGF0ZRImLnN5bmN0di5jbGllbnQuR2V0Q2hh'
    'dFJlYWRTdGF0ZVJlcXVlc3QaJC5zeW5jdHYuY2xpZW50LkNoYXRSZWFkU3RhdGVSZXNwb25zZR'
    'KBAQoaR2V0Q2hhdE1lc3NhZ2VSZWFkUmVjZWlwdHMSMC5zeW5jdHYuY2xpZW50LkdldENoYXRN'
    'ZXNzYWdlUmVhZFJlY2VpcHRzUmVxdWVzdBoxLnN5bmN0di5jbGllbnQuR2V0Q2hhdE1lc3NhZ2'
    'VSZWFkUmVjZWlwdHNSZXNwb25zZRJaCg1SZXBvcnRDb250ZW50EiMuc3luY3R2LmNsaWVudC5S'
    'ZXBvcnRDb250ZW50UmVxdWVzdBokLnN5bmN0di5jbGllbnQuUmVwb3J0Q29udGVudFJlc3Bvbn'
    'NlEnUKFkxpc3RSb29tQ29udGVudFJlcG9ydHMSLC5zeW5jdHYuY2xpZW50Lkxpc3RSb29tQ29u'
    'dGVudFJlcG9ydHNSZXF1ZXN0Gi0uc3luY3R2LmNsaWVudC5MaXN0Um9vbUNvbnRlbnRSZXBvcn'
    'RzUmVzcG9uc2USbwoUR2V0Um9vbUNvbnRlbnRSZXBvcnQSKi5zeW5jdHYuY2xpZW50LkdldFJv'
    'b21Db250ZW50UmVwb3J0UmVxdWVzdBorLnN5bmN0di5jbGllbnQuR2V0Um9vbUNvbnRlbnRSZX'
    'BvcnRSZXNwb25zZRKKAQodVXBkYXRlUm9vbUNvbnRlbnRSZXBvcnRTdGF0dXMSMy5zeW5jdHYu'
    'Y2xpZW50LlVwZGF0ZVJvb21Db250ZW50UmVwb3J0U3RhdHVzUmVxdWVzdBo0LnN5bmN0di5jbG'
    'llbnQuVXBkYXRlUm9vbUNvbnRlbnRSZXBvcnRTdGF0dXNSZXNwb25zZRJaCg1HZXRJY2VTZXJ2'
    'ZXJzEiMuc3luY3R2LmNsaWVudC5HZXRJY2VTZXJ2ZXJzUmVxdWVzdBokLnN5bmN0di5jbGllbn'
    'QuR2V0SWNlU2VydmVyc1Jlc3BvbnNlEl0KDkNyZWF0ZVBsYXlsaXN0EiQuc3luY3R2LmNsaWVu'
    'dC5DcmVhdGVQbGF5bGlzdFJlcXVlc3QaJS5zeW5jdHYuY2xpZW50LkNyZWF0ZVBsYXlsaXN0Um'
    'VzcG9uc2USVAoLR2V0UGxheWxpc3QSIS5zeW5jdHYuY2xpZW50LkdldFBsYXlsaXN0UmVxdWVz'
    'dBoiLnN5bmN0di5jbGllbnQuR2V0UGxheWxpc3RSZXNwb25zZRJdCg5VcGRhdGVQbGF5bGlzdB'
    'IkLnN5bmN0di5jbGllbnQuVXBkYXRlUGxheWxpc3RSZXF1ZXN0GiUuc3luY3R2LmNsaWVudC5V'
    'cGRhdGVQbGF5bGlzdFJlc3BvbnNlEpMBCiBDcmVhdGVQbGF5bGlzdENvdmVyVXBsb2FkU2Vzc2'
    'lvbhI2LnN5bmN0di5jbGllbnQuQ3JlYXRlUGxheWxpc3RDb3ZlclVwbG9hZFNlc3Npb25SZXF1'
    'ZXN0Gjcuc3luY3R2LmNsaWVudC5DcmVhdGVQbGF5bGlzdENvdmVyVXBsb2FkU2Vzc2lvblJlc3'
    'BvbnNlEn4KGVVwbG9hZFBsYXlsaXN0Q292ZXJPYmplY3QSLy5zeW5jdHYuY2xpZW50LlVwbG9h'
    'ZFBsYXlsaXN0Q292ZXJPYmplY3RSZXF1ZXN0GjAuc3luY3R2LmNsaWVudC5VcGxvYWRQbGF5bG'
    'lzdENvdmVyT2JqZWN0UmVzcG9uc2UScgoWR2V0UGxheWxpc3RDb3Zlck9iamVjdBIsLnN5bmN0'
    'di5jbGllbnQuR2V0UGxheWxpc3RDb3Zlck9iamVjdFJlcXVlc3QaKi5zeW5jdHYuY2xpZW50Ll'
    'BsYXlsaXN0Q292ZXJPYmplY3RSZXNwb25zZRJnChNVcGRhdGVQbGF5bGlzdENvdmVyEikuc3lu'
    'Y3R2LmNsaWVudC5VcGRhdGVQbGF5bGlzdENvdmVyUmVxdWVzdBolLnN5bmN0di5jbGllbnQuVX'
    'BkYXRlUGxheWxpc3RSZXNwb25zZRJlChJDbGVhclBsYXlsaXN0Q292ZXISKC5zeW5jdHYuY2xp'
    'ZW50LkNsZWFyUGxheWxpc3RDb3ZlclJlcXVlc3QaJS5zeW5jdHYuY2xpZW50LlVwZGF0ZVBsYX'
    'lsaXN0UmVzcG9uc2USVwoMTW92ZVBsYXlsaXN0EiIuc3luY3R2LmNsaWVudC5Nb3ZlUGxheWxp'
    'c3RSZXF1ZXN0GiMuc3luY3R2LmNsaWVudC5Nb3ZlUGxheWxpc3RSZXNwb25zZRJdCg5EZWxldG'
    'VQbGF5bGlzdBIkLnN5bmN0di5jbGllbnQuRGVsZXRlUGxheWxpc3RSZXF1ZXN0GiUuc3luY3R2'
    'LmNsaWVudC5EZWxldGVQbGF5bGlzdFJlc3BvbnNlEloKDUxpc3RQbGF5bGlzdHMSIy5zeW5jdH'
    'YuY2xpZW50Lkxpc3RQbGF5bGlzdHNSZXF1ZXN0GiQuc3luY3R2LmNsaWVudC5MaXN0UGxheWxp'
    'c3RzUmVzcG9uc2USSwoIQWRkTWVkaWESHi5zeW5jdHYuY2xpZW50LkFkZE1lZGlhUmVxdWVzdB'
    'ofLnN5bmN0di5jbGllbnQuQWRkTWVkaWFSZXNwb25zZRJACghHZXRNZWRpYRIeLnN5bmN0di5j'
    'bGllbnQuR2V0TWVkaWFSZXF1ZXN0GhQuc3luY3R2LmNsaWVudC5NZWRpYRKKAQodQ3JlYXRlVm'
    'lkZW9Db3ZlclVwbG9hZFNlc3Npb24SMy5zeW5jdHYuY2xpZW50LkNyZWF0ZVZpZGVvQ292ZXJV'
    'cGxvYWRTZXNzaW9uUmVxdWVzdBo0LnN5bmN0di5jbGllbnQuQ3JlYXRlVmlkZW9Db3ZlclVwbG'
    '9hZFNlc3Npb25SZXNwb25zZRJ1ChZVcGxvYWRWaWRlb0NvdmVyT2JqZWN0Eiwuc3luY3R2LmNs'
    'aWVudC5VcGxvYWRWaWRlb0NvdmVyT2JqZWN0UmVxdWVzdBotLnN5bmN0di5jbGllbnQuVXBsb2'
    'FkVmlkZW9Db3Zlck9iamVjdFJlc3BvbnNlEmkKE0dldFZpZGVvQ292ZXJPYmplY3QSKS5zeW5j'
    'dHYuY2xpZW50LkdldFZpZGVvQ292ZXJPYmplY3RSZXF1ZXN0Gicuc3luY3R2LmNsaWVudC5WaW'
    'Rlb0NvdmVyT2JqZWN0UmVzcG9uc2USXAoQVXBkYXRlVmlkZW9Db3ZlchImLnN5bmN0di5jbGll'
    'bnQuVXBkYXRlVmlkZW9Db3ZlclJlcXVlc3QaIC5zeW5jdHYuY2xpZW50LkVkaXRNZWRpYVJlc3'
    'BvbnNlEloKD0NsZWFyVmlkZW9Db3ZlchIlLnN5bmN0di5jbGllbnQuQ2xlYXJWaWRlb0NvdmVy'
    'UmVxdWVzdBogLnN5bmN0di5jbGllbnQuRWRpdE1lZGlhUmVzcG9uc2USVAoLRGVsZXRlTWVkaW'
    'ESIS5zeW5jdHYuY2xpZW50LkRlbGV0ZU1lZGlhUmVxdWVzdBoiLnN5bmN0di5jbGllbnQuRGVs'
    'ZXRlTWVkaWFSZXNwb25zZRJaCg1EZWxldGVFbnRyaWVzEiMuc3luY3R2LmNsaWVudC5EZWxldG'
    'VFbnRyaWVzUmVxdWVzdBokLnN5bmN0di5jbGllbnQuRGVsZXRlRW50cmllc1Jlc3BvbnNlEk4K'
    'CUVkaXRNZWRpYRIfLnN5bmN0di5jbGllbnQuRWRpdE1lZGlhUmVxdWVzdBogLnN5bmN0di5jbG'
    'llbnQuRWRpdE1lZGlhUmVzcG9uc2USZgoRTGlzdFBsYXlsaXN0SXRlbXMSJy5zeW5jdHYuY2xp'
    'ZW50Lkxpc3RQbGF5bGlzdEl0ZW1zUmVxdWVzdBooLnN5bmN0di5jbGllbnQuTGlzdFBsYXlsaX'
    'N0SXRlbXNSZXNwb25zZRJOCglNb3ZlTWVkaWESHy5zeW5jdHYuY2xpZW50Lk1vdmVNZWRpYVJl'
    'cXVlc3QaIC5zeW5jdHYuY2xpZW50Lk1vdmVNZWRpYVJlc3BvbnNlEloKDUNsZWFyUGxheWxpc3'
    'QSIy5zeW5jdHYuY2xpZW50LkNsZWFyUGxheWxpc3RSZXF1ZXN0GiQuc3luY3R2LmNsaWVudC5D'
    'bGVhclBsYXlsaXN0UmVzcG9uc2USWgoNQWRkTWVkaWFCYXRjaBIjLnN5bmN0di5jbGllbnQuQW'
    'RkTWVkaWFCYXRjaFJlcXVlc3QaJC5zeW5jdHYuY2xpZW50LkFkZE1lZGlhQmF0Y2hSZXNwb25z'
    'ZRJaCg1TdGFydFBsYXliYWNrEiMuc3luY3R2LmNsaWVudC5TdGFydFBsYXliYWNrUmVxdWVzdB'
    'okLnN5bmN0di5jbGllbnQuU3RhcnRQbGF5YmFja1Jlc3BvbnNlElcKDFN0b3BQbGF5YmFjaxIi'
    'LnN5bmN0di5jbGllbnQuU3RvcFBsYXliYWNrUmVxdWVzdBojLnN5bmN0di5jbGllbnQuU3RvcF'
    'BsYXliYWNrUmVzcG9uc2USVAoLR2V0UGxheWJhY2sSIS5zeW5jdHYuY2xpZW50LkdldFBsYXli'
    'YWNrUmVxdWVzdBoiLnN5bmN0di5jbGllbnQuR2V0UGxheWJhY2tSZXNwb25zZRJsChNVcGRhdG'
    'VQbGF5YmFja1N0YXRlEikuc3luY3R2LmNsaWVudC5VcGRhdGVQbGF5YmFja1N0YXRlUmVxdWVz'
    'dBoqLnN5bmN0di5jbGllbnQuVXBkYXRlUGxheWJhY2tTdGF0ZVJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> PublicServiceBase$json = {
  '1': 'PublicService',
  '2': [
    {
      '1': 'CheckRoom',
      '2': '.synctv.client.CheckRoomRequest',
      '3': '.synctv.client.CheckRoomResponse'
    },
    {
      '1': 'ListRooms',
      '2': '.synctv.client.ListRoomsRequest',
      '3': '.synctv.client.ListRoomsResponse'
    },
    {
      '1': 'GetHotRooms',
      '2': '.synctv.client.GetHotRoomsRequest',
      '3': '.synctv.client.GetHotRoomsResponse'
    },
    {
      '1': 'GetPublicSettings',
      '2': '.synctv.client.GetPublicSettingsRequest',
      '3': '.synctv.client.GetPublicSettingsResponse'
    },
    {
      '1': 'GetServerInfo',
      '2': '.synctv.client.GetServerInfoRequest',
      '3': '.synctv.client.GetServerInfoResponse'
    },
  ],
};

@$core.Deprecated('Use publicServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PublicServiceBase$messageJson = {
  '.synctv.client.CheckRoomRequest': CheckRoomRequest$json,
  '.synctv.client.CheckRoomResponse': CheckRoomResponse$json,
  '.synctv.client.ListRoomsRequest': ListRoomsRequest$json,
  '.synctv.client.ListRoomsResponse': ListRoomsResponse$json,
  '.synctv.client.Room': Room$json,
  '.synctv.client.ResourceCover': ResourceCover$json,
  '.synctv.common.RoomPresenceStats': $0.RoomPresenceStats$json,
  '.synctv.common.NodeConnectionCount': $0.NodeConnectionCount$json,
  '.synctv.client.UserPublicView': UserPublicView$json,
  '.synctv.client.UserAvatar': UserAvatar$json,
  '.synctv.client.GetHotRoomsRequest': GetHotRoomsRequest$json,
  '.synctv.client.GetHotRoomsResponse': GetHotRoomsResponse$json,
  '.synctv.client.RoomWithStats': RoomWithStats$json,
  '.synctv.client.GetPublicSettingsRequest': GetPublicSettingsRequest$json,
  '.synctv.client.GetPublicSettingsResponse': GetPublicSettingsResponse$json,
  '.synctv.client.GetServerInfoRequest': GetServerInfoRequest$json,
  '.synctv.client.GetServerInfoResponse': GetServerInfoResponse$json,
};

/// Descriptor for `PublicService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List publicServiceDescriptor = $convert.base64Decode(
    'Cg1QdWJsaWNTZXJ2aWNlEk4KCUNoZWNrUm9vbRIfLnN5bmN0di5jbGllbnQuQ2hlY2tSb29tUm'
    'VxdWVzdBogLnN5bmN0di5jbGllbnQuQ2hlY2tSb29tUmVzcG9uc2USTgoJTGlzdFJvb21zEh8u'
    'c3luY3R2LmNsaWVudC5MaXN0Um9vbXNSZXF1ZXN0GiAuc3luY3R2LmNsaWVudC5MaXN0Um9vbX'
    'NSZXNwb25zZRJUCgtHZXRIb3RSb29tcxIhLnN5bmN0di5jbGllbnQuR2V0SG90Um9vbXNSZXF1'
    'ZXN0GiIuc3luY3R2LmNsaWVudC5HZXRIb3RSb29tc1Jlc3BvbnNlEmYKEUdldFB1YmxpY1NldH'
    'RpbmdzEicuc3luY3R2LmNsaWVudC5HZXRQdWJsaWNTZXR0aW5nc1JlcXVlc3QaKC5zeW5jdHYu'
    'Y2xpZW50LkdldFB1YmxpY1NldHRpbmdzUmVzcG9uc2USWgoNR2V0U2VydmVySW5mbxIjLnN5bm'
    'N0di5jbGllbnQuR2V0U2VydmVySW5mb1JlcXVlc3QaJC5zeW5jdHYuY2xpZW50LkdldFNlcnZl'
    'ckluZm9SZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> EmailServiceBase$json = {
  '1': 'EmailService',
  '2': [
    {
      '1': 'RequestPasswordReset',
      '2': '.synctv.client.RequestPasswordResetRequest',
      '3': '.synctv.client.RequestPasswordResetResponse'
    },
    {
      '1': 'StartOpaquePasswordReset',
      '2': '.synctv.client.StartOpaquePasswordResetRequest',
      '3': '.synctv.client.StartOpaquePasswordResetResponse'
    },
    {
      '1': 'FinishOpaquePasswordReset',
      '2': '.synctv.client.FinishOpaquePasswordResetRequest',
      '3': '.synctv.client.ConfirmPasswordResetResponse'
    },
  ],
};

@$core.Deprecated('Use emailServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    EmailServiceBase$messageJson = {
  '.synctv.client.RequestPasswordResetRequest':
      RequestPasswordResetRequest$json,
  '.synctv.client.RequestPasswordResetResponse':
      RequestPasswordResetResponse$json,
  '.synctv.client.StartOpaquePasswordResetRequest':
      StartOpaquePasswordResetRequest$json,
  '.synctv.client.StartOpaquePasswordResetResponse':
      StartOpaquePasswordResetResponse$json,
  '.synctv.client.FinishOpaquePasswordResetRequest':
      FinishOpaquePasswordResetRequest$json,
  '.synctv.client.ConfirmPasswordResetResponse':
      ConfirmPasswordResetResponse$json,
};

/// Descriptor for `EmailService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List emailServiceDescriptor = $convert.base64Decode(
    'CgxFbWFpbFNlcnZpY2USbwoUUmVxdWVzdFBhc3N3b3JkUmVzZXQSKi5zeW5jdHYuY2xpZW50Ll'
    'JlcXVlc3RQYXNzd29yZFJlc2V0UmVxdWVzdBorLnN5bmN0di5jbGllbnQuUmVxdWVzdFBhc3N3'
    'b3JkUmVzZXRSZXNwb25zZRJ7ChhTdGFydE9wYXF1ZVBhc3N3b3JkUmVzZXQSLi5zeW5jdHYuY2'
    'xpZW50LlN0YXJ0T3BhcXVlUGFzc3dvcmRSZXNldFJlcXVlc3QaLy5zeW5jdHYuY2xpZW50LlN0'
    'YXJ0T3BhcXVlUGFzc3dvcmRSZXNldFJlc3BvbnNlEnkKGUZpbmlzaE9wYXF1ZVBhc3N3b3JkUm'
    'VzZXQSLy5zeW5jdHYuY2xpZW50LkZpbmlzaE9wYXF1ZVBhc3N3b3JkUmVzZXRSZXF1ZXN0Gisu'
    'c3luY3R2LmNsaWVudC5Db25maXJtUGFzc3dvcmRSZXNldFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> NotificationServiceBase$json = {
  '1': 'NotificationService',
  '2': [
    {
      '1': 'ListNotifications',
      '2': '.synctv.client.ListNotificationsRequest',
      '3': '.synctv.client.ListNotificationsResponse'
    },
    {
      '1': 'GetNotification',
      '2': '.synctv.client.GetNotificationRequest',
      '3': '.synctv.client.GetNotificationResponse'
    },
    {
      '1': 'MarkAsRead',
      '2': '.synctv.client.MarkAsReadRequest',
      '3': '.synctv.client.MarkAsReadResponse'
    },
    {
      '1': 'MarkAllAsRead',
      '2': '.synctv.client.MarkAllAsReadRequest',
      '3': '.synctv.client.MarkAllAsReadResponse'
    },
    {
      '1': 'DeleteNotification',
      '2': '.synctv.client.DeleteNotificationRequest',
      '3': '.synctv.client.DeleteNotificationResponse'
    },
    {
      '1': 'DeleteAllRead',
      '2': '.synctv.client.DeleteAllReadRequest',
      '3': '.synctv.client.DeleteAllReadResponse'
    },
  ],
};

@$core.Deprecated('Use notificationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    NotificationServiceBase$messageJson = {
  '.synctv.client.ListNotificationsRequest': ListNotificationsRequest$json,
  '.synctv.client.ListNotificationsResponse': ListNotificationsResponse$json,
  '.synctv.client.NotificationProto': NotificationProto$json,
  '.synctv.client.GetNotificationRequest': GetNotificationRequest$json,
  '.synctv.client.GetNotificationResponse': GetNotificationResponse$json,
  '.synctv.client.MarkAsReadRequest': MarkAsReadRequest$json,
  '.synctv.client.MarkAsReadResponse': MarkAsReadResponse$json,
  '.synctv.client.MarkAllAsReadRequest': MarkAllAsReadRequest$json,
  '.synctv.client.MarkAllAsReadResponse': MarkAllAsReadResponse$json,
  '.synctv.client.DeleteNotificationRequest': DeleteNotificationRequest$json,
  '.synctv.client.DeleteNotificationResponse': DeleteNotificationResponse$json,
  '.synctv.client.DeleteAllReadRequest': DeleteAllReadRequest$json,
  '.synctv.client.DeleteAllReadResponse': DeleteAllReadResponse$json,
};

/// Descriptor for `NotificationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List notificationServiceDescriptor = $convert.base64Decode(
    'ChNOb3RpZmljYXRpb25TZXJ2aWNlEmYKEUxpc3ROb3RpZmljYXRpb25zEicuc3luY3R2LmNsaW'
    'VudC5MaXN0Tm90aWZpY2F0aW9uc1JlcXVlc3QaKC5zeW5jdHYuY2xpZW50Lkxpc3ROb3RpZmlj'
    'YXRpb25zUmVzcG9uc2USYAoPR2V0Tm90aWZpY2F0aW9uEiUuc3luY3R2LmNsaWVudC5HZXROb3'
    'RpZmljYXRpb25SZXF1ZXN0GiYuc3luY3R2LmNsaWVudC5HZXROb3RpZmljYXRpb25SZXNwb25z'
    'ZRJRCgpNYXJrQXNSZWFkEiAuc3luY3R2LmNsaWVudC5NYXJrQXNSZWFkUmVxdWVzdBohLnN5bm'
    'N0di5jbGllbnQuTWFya0FzUmVhZFJlc3BvbnNlEloKDU1hcmtBbGxBc1JlYWQSIy5zeW5jdHYu'
    'Y2xpZW50Lk1hcmtBbGxBc1JlYWRSZXF1ZXN0GiQuc3luY3R2LmNsaWVudC5NYXJrQWxsQXNSZW'
    'FkUmVzcG9uc2USaQoSRGVsZXRlTm90aWZpY2F0aW9uEiguc3luY3R2LmNsaWVudC5EZWxldGVO'
    'b3RpZmljYXRpb25SZXF1ZXN0Gikuc3luY3R2LmNsaWVudC5EZWxldGVOb3RpZmljYXRpb25SZX'
    'Nwb25zZRJaCg1EZWxldGVBbGxSZWFkEiMuc3luY3R2LmNsaWVudC5EZWxldGVBbGxSZWFkUmVx'
    'dWVzdBokLnN5bmN0di5jbGllbnQuRGVsZXRlQWxsUmVhZFJlc3BvbnNl');
