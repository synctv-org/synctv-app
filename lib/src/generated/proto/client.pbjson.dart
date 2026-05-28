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

@$core.Deprecated('Use notificationTypeDescriptor instead')
const NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'NOTIFICATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_TYPE_ROOM_INVITATION', '2': 1},
    {'1': 'NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT', '2': 2},
    {'1': 'NOTIFICATION_TYPE_ROOM_EVENT', '2': 3},
    {'1': 'NOTIFICATION_TYPE_PASSWORD_RESET', '2': 4},
    {'1': 'NOTIFICATION_TYPE_EMAIL_VERIFICATION', '2': 5},
  ],
};

/// Descriptor for `NotificationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationTypeDescriptor = $convert.base64Decode(
    'ChBOb3RpZmljYXRpb25UeXBlEiEKHU5PVElGSUNBVElPTl9UWVBFX1VOU1BFQ0lGSUVEEAASJQ'
    'ohTk9USUZJQ0FUSU9OX1RZUEVfUk9PTV9JTlZJVEFUSU9OEAESKQolTk9USUZJQ0FUSU9OX1RZ'
    'UEVfU1lTVEVNX0FOTk9VTkNFTUVOVBACEiAKHE5PVElGSUNBVElPTl9UWVBFX1JPT01fRVZFTl'
    'QQAxIkCiBOT1RJRklDQVRJT05fVFlQRV9QQVNTV09SRF9SRVNFVBAEEigKJE5PVElGSUNBVElP'
    'Tl9UWVBFX0VNQUlMX1ZFUklGSUNBVElPThAF');

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
    {'1': 'email_verified', '3': 7, '4': 1, '5': 8, '10': 'emailVerified'},
    {'1': 'is_banned', '3': 8, '4': 1, '5': 8, '10': 'isBanned'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbWUSFAoFZW'
    '1haWwYAyABKAlSBWVtYWlsEisKBHJvbGUYBCABKA4yFy5zeW5jdHYuY29tbW9uLlVzZXJSb2xl'
    'UgRyb2xlEjEKBnN0YXR1cxgFIAEoDjIZLnN5bmN0di5jb21tb24uVXNlclN0YXR1c1IGc3RhdH'
    'VzEh0KCmNyZWF0ZWRfYXQYBiABKANSCWNyZWF0ZWRBdBIlCg5lbWFpbF92ZXJpZmllZBgHIAEo'
    'CFINZW1haWxWZXJpZmllZBIbCglpc19iYW5uZWQYCCABKAhSCGlzQmFubmVk');

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
  ],
};

/// Descriptor for `UserPublicView`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPublicViewDescriptor = $convert.base64Decode(
    'Cg5Vc2VyUHVibGljVmlldxIOCgJpZBgBIAEoCVICaWQSGgoIdXNlcm5hbWUYAiABKAlSCHVzZX'
    'JuYW1lEisKBHJvbGUYAyABKA4yFy5zeW5jdHYuY29tbW9uLlVzZXJSb2xlUgRyb2xlEh0KCmNy'
    'ZWF0ZWRfYXQYBCABKANSCWNyZWF0ZWRBdA==');

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
    'd2ZXJzaW9uGAwgASgDUgd2ZXJzaW9u');

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
    'gKB3ZlcnNpb24YDSABKANSB3ZlcnNpb24=');

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
    'c3RhbmNlX25hbWUYDiABKAlSFHByb3ZpZGVySW5zdGFuY2VOYW1l');

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
  ],
};

/// Descriptor for `PlaybackState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackStateDescriptor = $convert.base64Decode(
    'Cg1QbGF5YmFja1N0YXRlEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIoChBwbGF5aW5nX21lZG'
    'lhX2lkGAIgASgJUg5wbGF5aW5nTWVkaWFJZBIaCghwb3NpdGlvbhgDIAEoAVIIcG9zaXRpb24S'
    'FAoFc3BlZWQYBCABKAFSBXNwZWVkEh0KCmlzX3BsYXlpbmcYBSABKAhSCWlzUGxheWluZxIdCg'
    'p1cGRhdGVkX2F0GAYgASgDUgl1cGRhdGVkQXQSGAoHdmVyc2lvbhgHIAEoA1IHdmVyc2lvbhIu'
    'ChNwbGF5aW5nX3BsYXlsaXN0X2lkGAggASgJUhFwbGF5aW5nUGxheWxpc3RJZBIWCgZ0YXJnZX'
    'QYCSABKAxSBnRhcmdldA==');

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
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEicKBHVzZXIYASABKAsyEy5zeW5jdHYuY2xpZW50LlVzZXJSBH'
    'VzZXISIQoMYWNjZXNzX3Rva2VuGAIgASgJUgthY2Nlc3NUb2tlbhIjCg1yZWZyZXNoX3Rva2Vu'
    'GAMgASgJUgxyZWZyZXNoVG9rZW4=');

@$core.Deprecated('Use startOpaqueRegistrationRequestDescriptor instead')
const StartOpaqueRegistrationRequest$json = {
  '1': 'StartOpaqueRegistrationRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
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

/// Descriptor for `StartOpaqueRegistrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaqueRegistrationRequestDescriptor =
    $convert.base64Decode(
        'Ch5TdGFydE9wYXF1ZVJlZ2lzdHJhdGlvblJlcXVlc3QSOAoIdXNlcm5hbWUYASABKAlCHLpIGX'
        'IXEAMYMjIRXltccHtMfVxwe059Xy1dKyRSCHVzZXJuYW1lEiAKBWVtYWlsGAIgASgJQgq6SAdy'
        'BRj+AWABUgVlbWFpbBI9ChRyZWdpc3RyYXRpb25fcmVxdWVzdBgDIAEoDEIKukgHegUQARiAIF'
        'ITcmVnaXN0cmF0aW9uUmVxdWVzdA==');

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

@$core.Deprecated('Use startOpaqueLoginRequestDescriptor instead')
const StartOpaqueLoginRequest$json = {
  '1': 'StartOpaqueLoginRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
    {
      '1': 'credential_request',
      '3': 3,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'credentialRequest'
    },
  ],
};

/// Descriptor for `StartOpaqueLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOpaqueLoginRequestDescriptor = $convert.base64Decode(
    'ChdTdGFydE9wYXF1ZUxvZ2luUmVxdWVzdBIjCgh1c2VybmFtZRgBIAEoCUIHukgEcgIYMlIIdX'
    'Nlcm5hbWUSHgoFZW1haWwYAiABKAlCCLpIBXIDGP4BUgVlbWFpbBI5ChJjcmVkZW50aWFsX3Jl'
    'cXVlc3QYAyABKAxCCrpIB3oFEAEYgCBSEWNyZWRlbnRpYWxSZXF1ZXN0');

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
    {'1': 'username', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'email'},
  ],
};

/// Descriptor for `StartPasskeyLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startPasskeyLoginRequestDescriptor =
    $convert.base64Decode(
        'ChhTdGFydFBhc3NrZXlMb2dpblJlcXVlc3QSIwoIdXNlcm5hbWUYASABKAlCB7pIBHICGDJSCH'
        'VzZXJuYW1lEh4KBWVtYWlsGAIgASgJQgi6SAVyAxj+AVIFZW1haWw=');

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
  ],
};

/// Descriptor for `FinishPasskeyBindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishPasskeyBindRequestDescriptor = $convert.base64Decode(
    'ChhGaW5pc2hQYXNza2V5QmluZFJlcXVlc3QSKQoKc2Vzc2lvbl9pZBgBIAEoCUIKukgHcgUQAR'
    'iAAVIJc2Vzc2lvbklkEisKCmNyZWRlbnRpYWwYAiABKAxCC7pICHoGEAEYgIAEUgpjcmVkZW50'
    'aWFs');

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
  ],
};

/// Descriptor for `DeletePasskeyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePasskeyRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVQYXNza2V5UmVxdWVzdBIvCg1jcmVkZW50aWFsX2lkGAEgASgJQgq6SAdyBRABGI'
    'AQUgxjcmVkZW50aWFsSWQ=');

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
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'settings', '3': 3, '4': 1, '5': 12, '10': 'settings'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'description'},
  ],
};

/// Descriptor for `CreateRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoomRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSb29tUmVxdWVzdBKXAQoEbmFtZRgBIAEoCUKCAbpIf3IEEAEYZLoBdgoiY3JlYX'
    'RlX3Jvb20ubmFtZS5ub19hbmdsZV9icmFja2V0cxIkbmFtZSBtdXN0IG5vdCBjb250YWluIEhU'
    'TUwtbGlrZSB0YWdzGiohdGhpcy5jb250YWlucygnPCcpICYmICF0aGlzLmNvbnRhaW5zKCc+Jy'
    'lSBG5hbWUSGgoIcGFzc3dvcmQYAiABKAlSCHBhc3N3b3JkEhoKCHNldHRpbmdzGAMgASgMUghz'
    'ZXR0aW5ncxK0AQoLZGVzY3JpcHRpb24YBCABKAlCkQG6SI0BcgMY9AO6AYQBCiljcmVhdGVfcm'
    '9vbS5kZXNjcmlwdGlvbi5ub19hbmdsZV9icmFja2V0cxIrZGVzY3JpcHRpb24gbXVzdCBub3Qg'
    'Y29udGFpbiBIVE1MLWxpa2UgdGFncxoqIXRoaXMuY29udGFpbnMoJzwnKSAmJiAhdGhpcy5jb2'
    '50YWlucygnPicpUgtkZXNjcmlwdGlvbg==');

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
    {'1': 'password', '3': 1, '4': 1, '5': 9, '10': 'password'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'roomId'},
  ],
};

/// Descriptor for `JoinRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinRoomRequestDescriptor = $convert.base64Decode(
    'Cg9Kb2luUm9vbVJlcXVlc3QSGgoIcGFzc3dvcmQYASABKAlSCHBhc3N3b3JkEjcKB3Jvb21faW'
    'QYAiABKAlCHrpIG3IZEAEYQDITXnJvb21fW0EtWmEtejAtOV0rJFIGcm9vbUlk');

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

@$core.Deprecated('Use setRoomPasswordRequestDescriptor instead')
const SetRoomPasswordRequest$json = {
  '1': 'SetRoomPasswordRequest',
  '2': [
    {'1': 'password', '3': 1, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `SetRoomPasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setRoomPasswordRequestDescriptor =
    $convert.base64Decode(
        'ChZTZXRSb29tUGFzc3dvcmRSZXF1ZXN0EhoKCHBhc3N3b3JkGAEgASgJUghwYXNzd29yZA==');

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
  ],
};

/// Descriptor for `GetRoomMembersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRoomMembersResponseDescriptor = $convert.base64Decode(
    'ChZHZXRSb29tTWVtYmVyc1Jlc3BvbnNlEjMKB21lbWJlcnMYASADKAsyGS5zeW5jdHYuY29tbW'
    '9uLlJvb21NZW1iZXJSB21lbWJlcnMSFAoFdG90YWwYAiABKAVSBXRvdGFsEhgKB3ZlcnNpb24Y'
    'AyABKAlSB3ZlcnNpb24=');

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
    {'1': 'reviewed_by', '3': 9, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'rejection_reason', '3': 10, '4': 1, '5': 9, '10': 'rejectionReason'},
  ],
};

/// Descriptor for `RoomJoinReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomJoinReviewDescriptor = $convert.base64Decode(
    'Cg5Sb29tSm9pblJldmlldxIOCgJpZBgBIAEoCVICaWQSFwoHcm9vbV9pZBgCIAEoCVIGcm9vbU'
    'lkEhcKB3VzZXJfaWQYAyABKAlSBnVzZXJJZBIaCgh1c2VybmFtZRgEIAEoCVIIdXNlcm5hbWUS'
    'RAoOcmVxdWVzdGVkX3JvbGUYBSABKA4yHS5zeW5jdHYuY29tbW9uLlJvb21NZW1iZXJSb2xlUg'
    '1yZXF1ZXN0ZWRSb2xlEjMKBnN0YXR1cxgGIAEoDjIbLnN5bmN0di5jb21tb24uUmV2aWV3U3Rh'
    'dHVzUgZzdGF0dXMSIQoMcmVxdWVzdGVkX2F0GAcgASgDUgtyZXF1ZXN0ZWRBdBIfCgtyZXZpZX'
    'dlZF9hdBgIIAEoA1IKcmV2aWV3ZWRBdBIfCgtyZXZpZXdlZF9ieRgJIAEoCVIKcmV2aWV3ZWRC'
    'eRIpChByZWplY3Rpb25fcmVhc29uGAogASgJUg9yZWplY3Rpb25SZWFzb24=');

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
  ],
  '7': {},
};

/// Descriptor for `CreatePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPlaylistRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQbGF5bGlzdFJlcXVlc3QSHAoEbmFtZRgBIAEoCUIIukgFcgMY/wFSBG5hbWUSGw'
    'oJcGFyZW50X2lkGAIgASgJUghwYXJlbnRJZBJGCg9zb3VyY2VfcHJvdmlkZXIYAyABKAlCHbpI'
    'GnIVGEAyEV5bYS16XVthLXowLTlfXSok2AEBUg5zb3VyY2VQcm92aWRlchIjCg1zb3VyY2VfY2'
    '9uZmlnGAQgASgMUgxzb3VyY2VDb25maWcSUgoWcHJvdmlkZXJfaW5zdGFuY2VfbmFtZRgFIAEo'
    'CUIcukgZchQYQDIQXltBLVphLXowLTlfLV0rJNgBAVIUcHJvdmlkZXJJbnN0YW5jZU5hbWU6sA'
    'S6SKwEGpEBCiBwbGF5bGlzdC5keW5hbWljLnJlcXVpcmVzX2ZpZWxkcxIxZHluYW1pYyBwbGF5'
    'bGlzdHMgcmVxdWlyZSBub24tZW1wdHkgc291cmNlX2NvbmZpZxo6dGhpcy5zb3VyY2VfcHJvdm'
    'lkZXIgPT0gJycgfHwgc2l6ZSh0aGlzLnNvdXJjZV9jb25maWcpID4gMBrdAQomcGxheWxpc3Qu'
    'c3RhdGljLnJlamVjdHNfZHluYW1pY19maWVsZHMST3NvdXJjZV9wcm92aWRlciBpcyByZXF1aX'
    'JlZCB3aGVuIHNvdXJjZV9jb25maWcgb3IgcHJvdmlkZXJfaW5zdGFuY2VfbmFtZSBpcyBzZXQa'
    'YnRoaXMuc291cmNlX3Byb3ZpZGVyICE9ICcnIHx8IChzaXplKHRoaXMuc291cmNlX2NvbmZpZy'
    'kgPT0gMCAmJiB0aGlzLnByb3ZpZGVyX2luc3RhbmNlX25hbWUgPT0gJycpGrUBChlwbGF5bGlz'
    'dC5wYXJlbnRfaWQuZm9ybWF0EjNwYXJlbnRfaWQgbXVzdCBiZSBhIHB1YmxpYyBpZGVudGlmaW'
    'VyIHdoZW4gcHJvdmlkZWQaY3RoaXMucGFyZW50X2lkID09ICcnIHx8IChzaXplKHRoaXMucGFy'
    'ZW50X2lkKSA8PSA2NCAmJiB0aGlzLnBhcmVudF9pZC5tYXRjaGVzKCdecGxfW0EtWmEtejAtOV'
    '0rJCcpKQ==');

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
  ],
};

/// Descriptor for `UpdatePlaylistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaylistRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQbGF5bGlzdFJlcXVlc3QSPQoLcGxheWxpc3RfaWQYASABKAlCHLpIGXIXEAEYQD'
    'IRXnBsX1tBLVphLXowLTldKyRSCnBsYXlsaXN0SWQSHwoEbmFtZRgCIAEoCUILukgIcgMY/wHY'
    'AQFSBG5hbWU=');

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
    'cSHAoEbmFtZRgFIAEoCUIIukgFcgMY9ANSBG5hbWU6WbpIVhpUChlhZGRfbWVkaWEuc291cmNl'
    'X3Byb3ZpZGVyEhtzb3VyY2VfcHJvdmlkZXIgaXMgcmVxdWlyZWQaGnRoaXMuc291cmNlX3Byb3'
    'ZpZGVyICE9ICcnQg4KDF9wbGF5bGlzdF9pZA==');

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
    'FpbIgBARIkCgttb2RpZmllZF9hdBgGIAEoA0gCUgptb2RpZmllZEF0iAEBQgcKBV9zaXplQgwK'
    'Cl90aHVtYm5haWxCDgoMX21vZGlmaWVkX2F0');

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
  ],
};

/// Descriptor for `EditMediaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List editMediaRequestDescriptor = $convert.base64Decode(
    'ChBFZGl0TWVkaWFSZXF1ZXN0EjgKCG1lZGlhX2lkGAEgASgJQh26SBpyGBABGEAyEl5tZWRfW0'
    'EtWmEtejAtOV0rJFIHbWVkaWFJZBIcCgRuYW1lGAIgASgJQgi6SAVyAxj0A1IEbmFtZQ==');

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

@$core.Deprecated('Use updatePlaybackRequestDescriptor instead')
const UpdatePlaybackRequest$json = {
  '1': 'UpdatePlaybackRequest',
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
  ],
  '7': {},
  '8': [
    {'1': '_playing'},
    {'1': '_position'},
    {'1': '_speed'},
    {'1': '_version'},
  ],
};

/// Descriptor for `UpdatePlaybackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePlaybackRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQbGF5YmFja1JlcXVlc3QSPwoEdHlwZRgBIAEoDjIhLnN5bmN0di5jbGllbnQuUG'
    'xheWJhY2tVcGRhdGVUeXBlQgi6SAWCAQIQAVIEdHlwZRIdCgdwbGF5aW5nGAIgASgISABSB3Bs'
    'YXlpbmeIAQESHwoIcG9zaXRpb24YAyABKAFIAVIIcG9zaXRpb26IAQESGQoFc3BlZWQYBCABKA'
    'FIAlIFc3BlZWSIAQESHQoHdmVyc2lvbhgFIAEoA0gDUgd2ZXJzaW9uiAEBOla6SFMaUQoddXBk'
    'YXRlX3BsYXliYWNrLnR5cGVfcmVxdWlyZWQSIHBsYXliYWNrIHVwZGF0ZSB0eXBlIGlzIHJlcX'
    'VpcmVkGg50aGlzLnR5cGUgIT0gMEIKCghfcGxheWluZ0ILCglfcG9zaXRpb25CCAoGX3NwZWVk'
    'QgoKCF92ZXJzaW9u');

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
      '1': 'playback_snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackSnapshot',
      '10': 'playbackSnapshot'
    },
  ],
};

/// Descriptor for `GetPlaybackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlaybackResponseDescriptor = $convert.base64Decode(
    'ChNHZXRQbGF5YmFja1Jlc3BvbnNlEkMKDnBsYXliYWNrX3N0YXRlGAEgASgLMhwuc3luY3R2Lm'
    'NsaWVudC5QbGF5YmFja1N0YXRlUg1wbGF5YmFja1N0YXRlEkwKEXBsYXliYWNrX3NuYXBzaG90'
    'GAIgASgLMh8uc3luY3R2LmNsaWVudC5QbGF5YmFja1NuYXBzaG90UhBwbGF5YmFja1NuYXBzaG'
    '90');

@$core.Deprecated('Use playbackSnapshotDescriptor instead')
const PlaybackSnapshot$json = {
  '1': 'PlaybackSnapshot',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'room_id', '3': 3, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'position', '3': 5, '4': 1, '5': 1, '10': 'position'},
    {
      '1': 'playback_infos',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaybackSnapshot.PlaybackInfosEntry',
      '10': 'playbackInfos'
    },
    {'1': 'default_mode', '3': 7, '4': 1, '5': 9, '10': 'defaultMode'},
    {
      '1': 'metadata',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PlaybackSnapshot.MetadataEntry',
      '10': 'metadata'
    },
    {'1': 'version', '3': 9, '4': 1, '5': 9, '10': 'version'},
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
  '3': [
    PlaybackSnapshot_PlaybackInfosEntry$json,
    PlaybackSnapshot_MetadataEntry$json
  ],
  '8': [
    {'1': '_expires_at'},
  ],
};

@$core.Deprecated('Use playbackSnapshotDescriptor instead')
const PlaybackSnapshot_PlaybackInfosEntry$json = {
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

@$core.Deprecated('Use playbackSnapshotDescriptor instead')
const PlaybackSnapshot_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `PlaybackSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackSnapshotDescriptor = $convert.base64Decode(
    'ChBQbGF5YmFja1NuYXBzaG90EhkKCG1lZGlhX2lkGAEgASgJUgdtZWRpYUlkEh8KC3BsYXlsaX'
    'N0X2lkGAIgASgJUgpwbGF5bGlzdElkEhcKB3Jvb21faWQYAyABKAlSBnJvb21JZBISCgRuYW1l'
    'GAQgASgJUgRuYW1lEhoKCHBvc2l0aW9uGAUgASgBUghwb3NpdGlvbhJZCg5wbGF5YmFja19pbm'
    'ZvcxgGIAMoCzIyLnN5bmN0di5jbGllbnQuUGxheWJhY2tTbmFwc2hvdC5QbGF5YmFja0luZm9z'
    'RW50cnlSDXBsYXliYWNrSW5mb3MSIQoMZGVmYXVsdF9tb2RlGAcgASgJUgtkZWZhdWx0TW9kZR'
    'JJCghtZXRhZGF0YRgIIAMoCzItLnN5bmN0di5jbGllbnQuUGxheWJhY2tTbmFwc2hvdC5NZXRh'
    'ZGF0YUVudHJ5UghtZXRhZGF0YRIYCgd2ZXJzaW9uGAkgASgJUgd2ZXJzaW9uEiIKCmV4cGlyZX'
    'NfYXQYCiABKANIAFIJZXhwaXJlc0F0iAEBGl0KElBsYXliYWNrSW5mb3NFbnRyeRIQCgNrZXkY'
    'ASABKAlSA2tleRIxCgV2YWx1ZRgCIAEoCzIbLnN5bmN0di5jbGllbnQuUGxheWJhY2tJbmZvUg'
    'V2YWx1ZToCOAEaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgC'
    'IAEoCVIFdmFsdWU6AjgBQg0KC19leHBpcmVzX2F0');

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
      '1': 'playback_progress',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackProgressReport',
      '9': 0,
      '10': 'playbackProgress'
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
      '1': 'webrtc_offer',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCOffer',
      '9': 0,
      '10': 'webrtcOffer'
    },
    {
      '1': 'webrtc_answer',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCAnswer',
      '9': 0,
      '10': 'webrtcAnswer'
    },
    {
      '1': 'webrtc_ice_candidate',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCIceCandidate',
      '9': 0,
      '10': 'webrtcIceCandidate'
    },
    {
      '1': 'webrtc_join',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCJoin',
      '9': 0,
      '10': 'webrtcJoin'
    },
    {
      '1': 'webrtc_leave',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCLeave',
      '9': 0,
      '10': 'webrtcLeave'
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
    'ZWF0TWVzc2FnZUgAUgloZWFydGJlYXQSVAoRcGxheWJhY2tfcHJvZ3Jlc3MYAyABKAsyJS5zeW'
    '5jdHYuY2xpZW50LlBsYXliYWNrUHJvZ3Jlc3NSZXBvcnRIAFIQcGxheWJhY2tQcm9ncmVzcxJP'
    'Cg9wbGF5YmFja191cGRhdGUYBCABKAsyJC5zeW5jdHYuY2xpZW50LlVwZGF0ZVBsYXliYWNrUm'
    'VxdWVzdEgAUg5wbGF5YmFja1VwZGF0ZRJLChBvYnNlcnZlX3Jlc291cmNlGAUgASgLMh4uc3lu'
    'Y3R2LmNsaWVudC5PYnNlcnZlUmVzb3VyY2VIAFIPb2JzZXJ2ZVJlc291cmNlElEKEnVub2JzZX'
    'J2ZV9yZXNvdXJjZRgGIAEoCzIgLnN5bmN0di5jbGllbnQuVW5vYnNlcnZlUmVzb3VyY2VIAFIR'
    'dW5vYnNlcnZlUmVzb3VyY2USPwoMd2VicnRjX29mZmVyGAcgASgLMhouc3luY3R2LmNsaWVudC'
    '5XZWJSVENPZmZlckgAUgt3ZWJydGNPZmZlchJCCg13ZWJydGNfYW5zd2VyGAggASgLMhsuc3lu'
    'Y3R2LmNsaWVudC5XZWJSVENBbnN3ZXJIAFIMd2VicnRjQW5zd2VyElUKFHdlYnJ0Y19pY2VfY2'
    'FuZGlkYXRlGAkgASgLMiEuc3luY3R2LmNsaWVudC5XZWJSVENJY2VDYW5kaWRhdGVIAFISd2Vi'
    'cnRjSWNlQ2FuZGlkYXRlEjwKC3dlYnJ0Y19qb2luGAogASgLMhkuc3luY3R2LmNsaWVudC5XZW'
    'JSVENKb2luSABSCndlYnJ0Y0pvaW4SPwoMd2VicnRjX2xlYXZlGAsgASgLMhouc3luY3R2LmNs'
    'aWVudC5XZWJSVENMZWF2ZUgAUgt3ZWJydGNMZWF2ZUIJCgdtZXNzYWdl');

@$core.Deprecated('Use observeResourceDescriptor instead')
const ObserveResource$json = {
  '1': 'ObserveResource',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'observeId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
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
      '1': 'playback_snapshot',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlaybackSnapshot',
      '9': 0,
      '10': 'playbackSnapshot'
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
      '1': 'room_members',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObserveRoomMembers',
      '9': 0,
      '10': 'roomMembers'
    },
  ],
  '8': [
    {'1': 'resource'},
  ],
};

/// Descriptor for `ObserveResource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeResourceDescriptor = $convert.base64Decode(
    'Cg9PYnNlcnZlUmVzb3VyY2USKQoKb2JzZXJ2ZV9pZBgBIAEoCUIKukgHcgUQARiAAVIJb2JzZX'
    'J2ZUlkEhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SUgoNZGVsaXZlcnlfbW9kZRgDIAEoDjIj'
    'LnN5bmN0di5jbGllbnQuUmVzb3VyY2VEZWxpdmVyeU1vZGVCCLpIBYIBAhABUgxkZWxpdmVyeU'
    '1vZGUSTAoOcGxheWJhY2tfc3RhdGUYBCABKAsyIy5zeW5jdHYuY2xpZW50Lk9ic2VydmVQbGF5'
    'YmFja1N0YXRlSABSDXBsYXliYWNrU3RhdGUSVQoRcGxheWJhY2tfc25hcHNob3QYBSABKAsyJi'
    '5zeW5jdHYuY2xpZW50Lk9ic2VydmVQbGF5YmFja1NuYXBzaG90SABSEHBsYXliYWNrU25hcHNo'
    'b3QSSQoNcm9vbV9zZXR0aW5ncxgGIAEoCzIiLnN5bmN0di5jbGllbnQuT2JzZXJ2ZVJvb21TZX'
    'R0aW5nc0gAUgxyb29tU2V0dGluZ3MSTAoOcGxheWxpc3RfaXRlbXMYByABKAsyIy5zeW5jdHYu'
    'Y2xpZW50Lk9ic2VydmVQbGF5bGlzdEl0ZW1zSABSDXBsYXlsaXN0SXRlbXMSRgoMcm9vbV9tZW'
    '1iZXJzGAggASgLMiEuc3luY3R2LmNsaWVudC5PYnNlcnZlUm9vbU1lbWJlcnNIAFILcm9vbU1l'
    'bWJlcnNCCgoIcmVzb3VyY2U=');

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
};

/// Descriptor for `ObservePlaybackState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observePlaybackStateDescriptor =
    $convert.base64Decode('ChRPYnNlcnZlUGxheWJhY2tTdGF0ZQ==');

@$core.Deprecated('Use observePlaybackSnapshotDescriptor instead')
const ObservePlaybackSnapshot$json = {
  '1': 'ObservePlaybackSnapshot',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '10': 'playlistId'},
    {'1': 'target', '3': 3, '4': 1, '5': 12, '10': 'target'},
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

/// Descriptor for `ObservePlaybackSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observePlaybackSnapshotDescriptor = $convert.base64Decode(
    'ChdPYnNlcnZlUGxheWJhY2tTbmFwc2hvdBIZCghtZWRpYV9pZBgBIAEoCVIHbWVkaWFJZBIfCg'
    'twbGF5bGlzdF9pZBgCIAEoCVIKcGxheWxpc3RJZBIWCgZ0YXJnZXQYAyABKAxSBnRhcmdldBJc'
    'ChdwbGF5YmFja19jbGllbnRfcHJvZmlsZRgEIAEoCzIkLnN5bmN0di5jbGllbnQuUGxheWJhY2'
    'tDbGllbnRQcm9maWxlUhVwbGF5YmFja0NsaWVudFByb2ZpbGU=');

@$core.Deprecated('Use observeRoomSettingsDescriptor instead')
const ObserveRoomSettings$json = {
  '1': 'ObserveRoomSettings',
};

/// Descriptor for `ObserveRoomSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeRoomSettingsDescriptor =
    $convert.base64Decode('ChNPYnNlcnZlUm9vbVNldHRpbmdz');

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
  ],
};

/// Descriptor for `ObservePlaylistItems`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observePlaylistItemsDescriptor = $convert.base64Decode(
    'ChRPYnNlcnZlUGxheWxpc3RJdGVtcxJBCgdyZXF1ZXN0GAEgASgLMicuc3luY3R2LmNsaWVudC'
    '5MaXN0UGxheWxpc3RJdGVtc1JlcXVlc3RSB3JlcXVlc3Q=');

@$core.Deprecated('Use observeRoomMembersDescriptor instead')
const ObserveRoomMembers$json = {
  '1': 'ObserveRoomMembers',
  '2': [
    {
      '1': 'request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.GetRoomMembersRequest',
      '10': 'request'
    },
  ],
};

/// Descriptor for `ObserveRoomMembers`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeRoomMembersDescriptor = $convert.base64Decode(
    'ChJPYnNlcnZlUm9vbU1lbWJlcnMSPgoHcmVxdWVzdBgBIAEoCzIkLnN5bmN0di5jbGllbnQuR2'
    'V0Um9vbU1lbWJlcnNSZXF1ZXN0UgdyZXF1ZXN0');

@$core.Deprecated('Use watchOptionsDescriptor instead')
const WatchOptions$json = {
  '1': 'WatchOptions',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'delivery_mode',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.ResourceDeliveryMode',
      '10': 'deliveryMode'
    },
  ],
};

/// Descriptor for `WatchOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchOptionsDescriptor = $convert.base64Decode(
    'CgxXYXRjaE9wdGlvbnMSGAoHdmVyc2lvbhgBIAEoCVIHdmVyc2lvbhJICg1kZWxpdmVyeV9tb2'
    'RlGAIgASgOMiMuc3luY3R2LmNsaWVudC5SZXNvdXJjZURlbGl2ZXJ5TW9kZVIMZGVsaXZlcnlN'
    'b2Rl');

@$core.Deprecated('Use watchPlaybackStateRequestDescriptor instead')
const WatchPlaybackStateRequest$json = {
  '1': 'WatchPlaybackStateRequest',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WatchOptions',
      '10': 'options'
    },
  ],
};

/// Descriptor for `WatchPlaybackStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackStateRequestDescriptor =
    $convert.base64Decode(
        'ChlXYXRjaFBsYXliYWNrU3RhdGVSZXF1ZXN0EjUKB29wdGlvbnMYASABKAsyGy5zeW5jdHYuY2'
        'xpZW50LldhdGNoT3B0aW9uc1IHb3B0aW9ucw==');

@$core.Deprecated('Use watchPlaybackSnapshotRequestDescriptor instead')
const WatchPlaybackSnapshotRequest$json = {
  '1': 'WatchPlaybackSnapshotRequest',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WatchOptions',
      '10': 'options'
    },
    {
      '1': 'playback_snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ObservePlaybackSnapshot',
      '10': 'playbackSnapshot'
    },
  ],
};

/// Descriptor for `WatchPlaybackSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackSnapshotRequestDescriptor = $convert.base64Decode(
    'ChxXYXRjaFBsYXliYWNrU25hcHNob3RSZXF1ZXN0EjUKB29wdGlvbnMYASABKAsyGy5zeW5jdH'
    'YuY2xpZW50LldhdGNoT3B0aW9uc1IHb3B0aW9ucxJTChFwbGF5YmFja19zbmFwc2hvdBgCIAEo'
    'CzImLnN5bmN0di5jbGllbnQuT2JzZXJ2ZVBsYXliYWNrU25hcHNob3RSEHBsYXliYWNrU25hcH'
    'Nob3Q=');

@$core.Deprecated('Use watchRoomSettingsRequestDescriptor instead')
const WatchRoomSettingsRequest$json = {
  '1': 'WatchRoomSettingsRequest',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WatchOptions',
      '10': 'options'
    },
  ],
};

/// Descriptor for `WatchRoomSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomSettingsRequestDescriptor =
    $convert.base64Decode(
        'ChhXYXRjaFJvb21TZXR0aW5nc1JlcXVlc3QSNQoHb3B0aW9ucxgBIAEoCzIbLnN5bmN0di5jbG'
        'llbnQuV2F0Y2hPcHRpb25zUgdvcHRpb25z');

@$core.Deprecated('Use watchPlaylistItemsRequestDescriptor instead')
const WatchPlaylistItemsRequest$json = {
  '1': 'WatchPlaylistItemsRequest',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WatchOptions',
      '10': 'options'
    },
    {
      '1': 'request',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ListPlaylistItemsRequest',
      '10': 'request'
    },
  ],
};

/// Descriptor for `WatchPlaylistItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaylistItemsRequestDescriptor = $convert.base64Decode(
    'ChlXYXRjaFBsYXlsaXN0SXRlbXNSZXF1ZXN0EjUKB29wdGlvbnMYASABKAsyGy5zeW5jdHYuY2'
    'xpZW50LldhdGNoT3B0aW9uc1IHb3B0aW9ucxJBCgdyZXF1ZXN0GAIgASgLMicuc3luY3R2LmNs'
    'aWVudC5MaXN0UGxheWxpc3RJdGVtc1JlcXVlc3RSB3JlcXVlc3Q=');

@$core.Deprecated('Use watchRoomMembersRequestDescriptor instead')
const WatchRoomMembersRequest$json = {
  '1': 'WatchRoomMembersRequest',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WatchOptions',
      '10': 'options'
    },
    {
      '1': 'request',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.GetRoomMembersRequest',
      '10': 'request'
    },
  ],
};

/// Descriptor for `WatchRoomMembersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomMembersRequestDescriptor = $convert.base64Decode(
    'ChdXYXRjaFJvb21NZW1iZXJzUmVxdWVzdBI1CgdvcHRpb25zGAEgASgLMhsuc3luY3R2LmNsaW'
    'VudC5XYXRjaE9wdGlvbnNSB29wdGlvbnMSPgoHcmVxdWVzdBgCIAEoCzIkLnN5bmN0di5jbGll'
    'bnQuR2V0Um9vbU1lbWJlcnNSZXF1ZXN0UgdyZXF1ZXN0');

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
      '1': 'changed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChanged',
      '9': 0,
      '10': 'changed'
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
    'llbnQuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBI6CgdjaGFuZ2VkGAIgASgLMh4uc3lu'
    'Y3R2LmNsaWVudC5SZXNvdXJjZUNoYW5nZWRIAFIHY2hhbmdlZBI7CgVlcnJvchgDIAEoCzIjLn'
    'N5bmN0di5jbGllbnQuUmVzb3VyY2VPYnNlcnZlRXJyb3JIAFIFZXJyb3JCBwoFZXZlbnQ=');

@$core.Deprecated('Use watchPlaybackSnapshotEventDescriptor instead')
const WatchPlaybackSnapshotEvent$json = {
  '1': 'WatchPlaybackSnapshotEvent',
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
      '1': 'changed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChanged',
      '9': 0,
      '10': 'changed'
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

/// Descriptor for `WatchPlaybackSnapshotEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchPlaybackSnapshotEventDescriptor = $convert.base64Decode(
    'ChpXYXRjaFBsYXliYWNrU25hcHNob3RFdmVudBI9CghvYnNlcnZlZBgBIAEoCzIfLnN5bmN0di'
    '5jbGllbnQuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBI6CgdjaGFuZ2VkGAIgASgLMh4u'
    'c3luY3R2LmNsaWVudC5SZXNvdXJjZUNoYW5nZWRIAFIHY2hhbmdlZBI7CgVlcnJvchgDIAEoCz'
    'IjLnN5bmN0di5jbGllbnQuUmVzb3VyY2VPYnNlcnZlRXJyb3JIAFIFZXJyb3JCBwoFZXZlbnQ=');

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
      '1': 'changed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChanged',
      '9': 0,
      '10': 'changed'
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
    'VudC5SZXNvdXJjZU9ic2VydmVkSABSCG9ic2VydmVkEjoKB2NoYW5nZWQYAiABKAsyHi5zeW5j'
    'dHYuY2xpZW50LlJlc291cmNlQ2hhbmdlZEgAUgdjaGFuZ2VkEjsKBWVycm9yGAMgASgLMiMuc3'
    'luY3R2LmNsaWVudC5SZXNvdXJjZU9ic2VydmVFcnJvckgAUgVlcnJvckIHCgVldmVudA==');

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
      '1': 'changed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChanged',
      '9': 0,
      '10': 'changed'
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
    'llbnQuUmVzb3VyY2VPYnNlcnZlZEgAUghvYnNlcnZlZBI6CgdjaGFuZ2VkGAIgASgLMh4uc3lu'
    'Y3R2LmNsaWVudC5SZXNvdXJjZUNoYW5nZWRIAFIHY2hhbmdlZBI7CgVlcnJvchgDIAEoCzIjLn'
    'N5bmN0di5jbGllbnQuUmVzb3VyY2VPYnNlcnZlRXJyb3JIAFIFZXJyb3JCBwoFZXZlbnQ=');

@$core.Deprecated('Use watchRoomMembersEventDescriptor instead')
const WatchRoomMembersEvent$json = {
  '1': 'WatchRoomMembersEvent',
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
      '1': 'changed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChanged',
      '9': 0,
      '10': 'changed'
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

/// Descriptor for `WatchRoomMembersEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRoomMembersEventDescriptor = $convert.base64Decode(
    'ChVXYXRjaFJvb21NZW1iZXJzRXZlbnQSPQoIb2JzZXJ2ZWQYASABKAsyHy5zeW5jdHYuY2xpZW'
    '50LlJlc291cmNlT2JzZXJ2ZWRIAFIIb2JzZXJ2ZWQSOgoHY2hhbmdlZBgCIAEoCzIeLnN5bmN0'
    'di5jbGllbnQuUmVzb3VyY2VDaGFuZ2VkSABSB2NoYW5nZWQSOwoFZXJyb3IYAyABKAsyIy5zeW'
    '5jdHYuY2xpZW50LlJlc291cmNlT2JzZXJ2ZUVycm9ySABSBWVycm9yQgcKBWV2ZW50');

@$core.Deprecated('Use playbackProgressReportDescriptor instead')
const PlaybackProgressReport$json = {
  '1': 'PlaybackProgressReport',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 1, '10': 'position'},
    {'1': 'is_playing', '3': 2, '4': 1, '5': 8, '10': 'isPlaying'},
  ],
};

/// Descriptor for `PlaybackProgressReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackProgressReportDescriptor =
    $convert.base64Decode(
        'ChZQbGF5YmFja1Byb2dyZXNzUmVwb3J0EhoKCHBvc2l0aW9uGAEgASgBUghwb3NpdGlvbhIdCg'
        'ppc19wbGF5aW5nGAIgASgIUglpc1BsYXlpbmc=');

@$core.Deprecated('Use serverMessageDescriptor instead')
const ServerMessage$json = {
  '1': 'ServerMessage',
  '2': [
    {
      '1': 'chat',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ChatMessageReceive',
      '9': 0,
      '10': 'chat'
    },
    {
      '1': 'playback_state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackStateChanged',
      '9': 0,
      '10': 'playbackState'
    },
    {
      '1': 'user_joined',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserJoinedRoom',
      '9': 0,
      '10': 'userJoined'
    },
    {
      '1': 'user_left',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.UserLeftRoom',
      '9': 0,
      '10': 'userLeft'
    },
    {
      '1': 'room_settings',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomSettingsChanged',
      '9': 0,
      '10': 'roomSettings'
    },
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
      '1': 'media_added',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.MediaAdded',
      '9': 0,
      '10': 'mediaAdded'
    },
    {
      '1': 'media_removed',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.MediaRemoved',
      '9': 0,
      '10': 'mediaRemoved'
    },
    {
      '1': 'media_removed_batch',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.MediaRemovedBatch',
      '9': 0,
      '10': 'mediaRemovedBatch'
    },
    {
      '1': 'permission_changed',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PermissionChanged',
      '9': 0,
      '10': 'permissionChanged'
    },
    {
      '1': 'playlist_created',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistCreated',
      '9': 0,
      '10': 'playlistCreated'
    },
    {
      '1': 'playlist_updated',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistUpdated',
      '9': 0,
      '10': 'playlistUpdated'
    },
    {
      '1': 'playlist_deleted',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistDeleted',
      '9': 0,
      '10': 'playlistDeleted'
    },
    {
      '1': 'playlist_reordered',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistReordered',
      '9': 0,
      '10': 'playlistReordered'
    },
    {
      '1': 'playing_changed',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlayingChanged',
      '9': 0,
      '10': 'playingChanged'
    },
    {
      '1': 'webrtc_offer',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCOffer',
      '9': 0,
      '10': 'webrtcOffer'
    },
    {
      '1': 'webrtc_answer',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCAnswer',
      '9': 0,
      '10': 'webrtcAnswer'
    },
    {
      '1': 'webrtc_ice_candidate',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCIceCandidate',
      '9': 0,
      '10': 'webrtcIceCandidate'
    },
    {
      '1': 'webrtc_join',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCJoin',
      '9': 0,
      '10': 'webrtcJoin'
    },
    {
      '1': 'webrtc_leave',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.WebRTCLeave',
      '9': 0,
      '10': 'webrtcLeave'
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
      '1': 'media_updated',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.MediaUpdated',
      '9': 0,
      '10': 'mediaUpdated'
    },
    {
      '1': 'playback_snapshot',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackSnapshotChanged',
      '9': 0,
      '10': 'playbackSnapshot'
    },
    {
      '1': 'playlist_items',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaylistItemsChanged',
      '9': 0,
      '10': 'playlistItems'
    },
    {
      '1': 'room_members',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomMembersChanged',
      '9': 0,
      '10': 'roomMembers'
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
      '1': 'resource_changed',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChanged',
      '9': 0,
      '10': 'resourceChanged'
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
    'Cg1TZXJ2ZXJNZXNzYWdlEjcKBGNoYXQYASABKAsyIS5zeW5jdHYuY2xpZW50LkNoYXRNZXNzYW'
    'dlUmVjZWl2ZUgAUgRjaGF0EkwKDnBsYXliYWNrX3N0YXRlGAIgASgLMiMuc3luY3R2LmNsaWVu'
    'dC5QbGF5YmFja1N0YXRlQ2hhbmdlZEgAUg1wbGF5YmFja1N0YXRlEkAKC3VzZXJfam9pbmVkGA'
    'MgASgLMh0uc3luY3R2LmNsaWVudC5Vc2VySm9pbmVkUm9vbUgAUgp1c2VySm9pbmVkEjoKCXVz'
    'ZXJfbGVmdBgEIAEoCzIbLnN5bmN0di5jbGllbnQuVXNlckxlZnRSb29tSABSCHVzZXJMZWZ0Ek'
    'kKDXJvb21fc2V0dGluZ3MYBSABKAsyIi5zeW5jdHYuY2xpZW50LlJvb21TZXR0aW5nc0NoYW5n'
    'ZWRIAFIMcm9vbVNldHRpbmdzEkIKDWhlYXJ0YmVhdF9hY2sYBiABKAsyGy5zeW5jdHYuY2xpZW'
    '50LkhlYXJ0YmVhdEFja0gAUgxoZWFydGJlYXRBY2sSMwoFZXJyb3IYByABKAsyGy5zeW5jdHYu'
    'Y2xpZW50LkVycm9yTWVzc2FnZUgAUgVlcnJvchI8CgttZWRpYV9hZGRlZBgIIAEoCzIZLnN5bm'
    'N0di5jbGllbnQuTWVkaWFBZGRlZEgAUgptZWRpYUFkZGVkEkIKDW1lZGlhX3JlbW92ZWQYCSAB'
    'KAsyGy5zeW5jdHYuY2xpZW50Lk1lZGlhUmVtb3ZlZEgAUgxtZWRpYVJlbW92ZWQSUgoTbWVkaW'
    'FfcmVtb3ZlZF9iYXRjaBgKIAEoCzIgLnN5bmN0di5jbGllbnQuTWVkaWFSZW1vdmVkQmF0Y2hI'
    'AFIRbWVkaWFSZW1vdmVkQmF0Y2gSUQoScGVybWlzc2lvbl9jaGFuZ2VkGAsgASgLMiAuc3luY3'
    'R2LmNsaWVudC5QZXJtaXNzaW9uQ2hhbmdlZEgAUhFwZXJtaXNzaW9uQ2hhbmdlZBJLChBwbGF5'
    'bGlzdF9jcmVhdGVkGAwgASgLMh4uc3luY3R2LmNsaWVudC5QbGF5bGlzdENyZWF0ZWRIAFIPcG'
    'xheWxpc3RDcmVhdGVkEksKEHBsYXlsaXN0X3VwZGF0ZWQYDSABKAsyHi5zeW5jdHYuY2xpZW50'
    'LlBsYXlsaXN0VXBkYXRlZEgAUg9wbGF5bGlzdFVwZGF0ZWQSSwoQcGxheWxpc3RfZGVsZXRlZB'
    'gOIAEoCzIeLnN5bmN0di5jbGllbnQuUGxheWxpc3REZWxldGVkSABSD3BsYXlsaXN0RGVsZXRl'
    'ZBJRChJwbGF5bGlzdF9yZW9yZGVyZWQYDyABKAsyIC5zeW5jdHYuY2xpZW50LlBsYXlsaXN0Um'
    'VvcmRlcmVkSABSEXBsYXlsaXN0UmVvcmRlcmVkEkgKD3BsYXlpbmdfY2hhbmdlZBgQIAEoCzId'
    'LnN5bmN0di5jbGllbnQuUGxheWluZ0NoYW5nZWRIAFIOcGxheWluZ0NoYW5nZWQSPwoMd2Vicn'
    'RjX29mZmVyGBEgASgLMhouc3luY3R2LmNsaWVudC5XZWJSVENPZmZlckgAUgt3ZWJydGNPZmZl'
    'chJCCg13ZWJydGNfYW5zd2VyGBIgASgLMhsuc3luY3R2LmNsaWVudC5XZWJSVENBbnN3ZXJIAF'
    'IMd2VicnRjQW5zd2VyElUKFHdlYnJ0Y19pY2VfY2FuZGlkYXRlGBMgASgLMiEuc3luY3R2LmNs'
    'aWVudC5XZWJSVENJY2VDYW5kaWRhdGVIAFISd2VicnRjSWNlQ2FuZGlkYXRlEjwKC3dlYnJ0Y1'
    '9qb2luGBQgASgLMhkuc3luY3R2LmNsaWVudC5XZWJSVENKb2luSABSCndlYnJ0Y0pvaW4SPwoM'
    'd2VicnRjX2xlYXZlGBUgASgLMhouc3luY3R2LmNsaWVudC5XZWJSVENMZWF2ZUgAUgt3ZWJydG'
    'NMZWF2ZRJFCgxub3RpZmljYXRpb24YGCABKAsyHy5zeW5jdHYuY2xpZW50LlVzZXJOb3RpZmlj'
    'YXRpb25IAFIMbm90aWZpY2F0aW9uEkIKDW1lZGlhX3VwZGF0ZWQYGSABKAsyGy5zeW5jdHYuY2'
    'xpZW50Lk1lZGlhVXBkYXRlZEgAUgxtZWRpYVVwZGF0ZWQSVQoRcGxheWJhY2tfc25hcHNob3QY'
    'GiABKAsyJi5zeW5jdHYuY2xpZW50LlBsYXliYWNrU25hcHNob3RDaGFuZ2VkSABSEHBsYXliYW'
    'NrU25hcHNob3QSTAoOcGxheWxpc3RfaXRlbXMYGyABKAsyIy5zeW5jdHYuY2xpZW50LlBsYXls'
    'aXN0SXRlbXNDaGFuZ2VkSABSDXBsYXlsaXN0SXRlbXMSRgoMcm9vbV9tZW1iZXJzGBwgASgLMi'
    'Euc3luY3R2LmNsaWVudC5Sb29tTWVtYmVyc0NoYW5nZWRIAFILcm9vbU1lbWJlcnMSTgoRcmVz'
    'b3VyY2Vfb2JzZXJ2ZWQYHSABKAsyHy5zeW5jdHYuY2xpZW50LlJlc291cmNlT2JzZXJ2ZWRIAF'
    'IQcmVzb3VyY2VPYnNlcnZlZBJLChByZXNvdXJjZV9jaGFuZ2VkGB4gASgLMh4uc3luY3R2LmNs'
    'aWVudC5SZXNvdXJjZUNoYW5nZWRIAFIPcmVzb3VyY2VDaGFuZ2VkElsKFnJlc291cmNlX29ic2'
    'VydmVfZXJyb3IYHyABKAsyIy5zeW5jdHYuY2xpZW50LlJlc291cmNlT2JzZXJ2ZUVycm9ySABS'
    'FHJlc291cmNlT2JzZXJ2ZUVycm9yQgkKB21lc3NhZ2U=');

@$core.Deprecated('Use resourceObservedDescriptor instead')
const ResourceObserved$json = {
  '1': 'ResourceObserved',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '10': 'observeId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'changed', '3': 3, '4': 1, '5': 8, '10': 'changed'},
  ],
};

/// Descriptor for `ResourceObserved`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceObservedDescriptor = $convert.base64Decode(
    'ChBSZXNvdXJjZU9ic2VydmVkEh0KCm9ic2VydmVfaWQYASABKAlSCW9ic2VydmVJZBIYCgd2ZX'
    'JzaW9uGAIgASgJUgd2ZXJzaW9uEhgKB2NoYW5nZWQYAyABKAhSB2NoYW5nZWQ=');

@$core.Deprecated('Use resourceChangedOnlyDescriptor instead')
const ResourceChangedOnly$json = {
  '1': 'ResourceChangedOnly',
};

/// Descriptor for `ResourceChangedOnly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceChangedOnlyDescriptor =
    $convert.base64Decode('ChNSZXNvdXJjZUNoYW5nZWRPbmx5');

@$core.Deprecated('Use resourceChangedDescriptor instead')
const ResourceChanged$json = {
  '1': 'ResourceChanged',
  '2': [
    {'1': 'observe_id', '3': 1, '4': 1, '5': 9, '10': 'observeId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'changed_only',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ResourceChangedOnly',
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
      '1': 'playback_snapshot',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackSnapshot',
      '9': 0,
      '10': 'playbackSnapshot'
    },
    {
      '1': 'room_settings',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.RoomSettingsChanged',
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
      '1': 'room_members',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.GetRoomMembersResponse',
      '9': 0,
      '10': 'roomMembers'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `ResourceChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceChangedDescriptor = $convert.base64Decode(
    'Cg9SZXNvdXJjZUNoYW5nZWQSHQoKb2JzZXJ2ZV9pZBgBIAEoCVIJb2JzZXJ2ZUlkEhgKB3Zlcn'
    'Npb24YAiABKAlSB3ZlcnNpb24SRwoMY2hhbmdlZF9vbmx5GAMgASgLMiIuc3luY3R2LmNsaWVu'
    'dC5SZXNvdXJjZUNoYW5nZWRPbmx5SABSC2NoYW5nZWRPbmx5EkUKDnBsYXliYWNrX3N0YXRlGA'
    'QgASgLMhwuc3luY3R2LmNsaWVudC5QbGF5YmFja1N0YXRlSABSDXBsYXliYWNrU3RhdGUSTgoR'
    'cGxheWJhY2tfc25hcHNob3QYBSABKAsyHy5zeW5jdHYuY2xpZW50LlBsYXliYWNrU25hcHNob3'
    'RIAFIQcGxheWJhY2tTbmFwc2hvdBJJCg1yb29tX3NldHRpbmdzGAYgASgLMiIuc3luY3R2LmNs'
    'aWVudC5Sb29tU2V0dGluZ3NDaGFuZ2VkSABSDHJvb21TZXR0aW5ncxJRCg5wbGF5bGlzdF9pdG'
    'VtcxgHIAEoCzIoLnN5bmN0di5jbGllbnQuTGlzdFBsYXlsaXN0SXRlbXNSZXNwb25zZUgAUg1w'
    'bGF5bGlzdEl0ZW1zEkoKDHJvb21fbWVtYmVycxgIIAEoCzIlLnN5bmN0di5jbGllbnQuR2V0Um'
    '9vbU1lbWJlcnNSZXNwb25zZUgAUgtyb29tTWVtYmVyc0IJCgdwYXlsb2Fk');

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

@$core.Deprecated('Use playlistItemsChangedDescriptor instead')
const PlaylistItemsChanged$json = {
  '1': 'PlaylistItemsChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.ListPlaylistItemsResponse',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `PlaylistItemsChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistItemsChangedDescriptor = $convert.base64Decode(
    'ChRQbGF5bGlzdEl0ZW1zQ2hhbmdlZBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSRAoIc25hcH'
    'Nob3QYAiABKAsyKC5zeW5jdHYuY2xpZW50Lkxpc3RQbGF5bGlzdEl0ZW1zUmVzcG9uc2VSCHNu'
    'YXBzaG90');

@$core.Deprecated('Use roomMembersChangedDescriptor instead')
const RoomMembersChanged$json = {
  '1': 'RoomMembersChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.GetRoomMembersResponse',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `RoomMembersChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomMembersChangedDescriptor = $convert.base64Decode(
    'ChJSb29tTWVtYmVyc0NoYW5nZWQSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEkEKCHNuYXBzaG'
    '90GAIgASgLMiUuc3luY3R2LmNsaWVudC5HZXRSb29tTWVtYmVyc1Jlc3BvbnNlUghzbmFwc2hv'
    'dA==');

@$core.Deprecated('Use chatMessageSendDescriptor instead')
const ChatMessageSend$json = {
  '1': 'ChatMessageSend',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
    {
      '1': 'position',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'position',
      '17': true
    },
    {'1': 'color', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'color', '17': true},
  ],
  '8': [
    {'1': '_position'},
    {'1': '_color'},
  ],
};

/// Descriptor for `ChatMessageSend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageSendDescriptor = $convert.base64Decode(
    'Cg9DaGF0TWVzc2FnZVNlbmQSGAoHY29udGVudBgBIAEoCVIHY29udGVudBIfCghwb3NpdGlvbh'
    'gCIAEoAUgAUghwb3NpdGlvbogBARIZCgVjb2xvchgDIAEoCUgBUgVjb2xvcogBAUILCglfcG9z'
    'aXRpb25CCAoGX2NvbG9y');

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
    {
      '1': 'position',
      '3': 7,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'position',
      '17': true
    },
    {'1': 'color', '3': 8, '4': 1, '5': 9, '9': 1, '10': 'color', '17': true},
  ],
  '8': [
    {'1': '_position'},
    {'1': '_color'},
  ],
};

/// Descriptor for `ChatMessageReceive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chatMessageReceiveDescriptor = $convert.base64Decode(
    'ChJDaGF0TWVzc2FnZVJlY2VpdmUSDgoCaWQYASABKAlSAmlkEhcKB3Jvb21faWQYAiABKAlSBn'
    'Jvb21JZBIXCgd1c2VyX2lkGAMgASgJUgZ1c2VySWQSGgoIdXNlcm5hbWUYBCABKAlSCHVzZXJu'
    'YW1lEhgKB2NvbnRlbnQYBSABKAlSB2NvbnRlbnQSHAoJdGltZXN0YW1wGAYgASgDUgl0aW1lc3'
    'RhbXASHwoIcG9zaXRpb24YByABKAFIAFIIcG9zaXRpb26IAQESGQoFY29sb3IYCCABKAlIAVIF'
    'Y29sb3KIAQFCCwoJX3Bvc2l0aW9uQggKBl9jb2xvcg==');

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

@$core.Deprecated('Use playbackStateChangedDescriptor instead')
const PlaybackStateChanged$json = {
  '1': 'PlaybackStateChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackState',
      '10': 'state'
    },
  ],
};

/// Descriptor for `PlaybackStateChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackStateChangedDescriptor = $convert.base64Decode(
    'ChRQbGF5YmFja1N0YXRlQ2hhbmdlZBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSMgoFc3RhdG'
    'UYAiABKAsyHC5zeW5jdHYuY2xpZW50LlBsYXliYWNrU3RhdGVSBXN0YXRl');

@$core.Deprecated('Use playbackSnapshotChangedDescriptor instead')
const PlaybackSnapshotChanged$json = {
  '1': 'PlaybackSnapshotChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'snapshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PlaybackSnapshot',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `PlaybackSnapshotChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playbackSnapshotChangedDescriptor = $convert.base64Decode(
    'ChdQbGF5YmFja1NuYXBzaG90Q2hhbmdlZBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSOwoIc2'
    '5hcHNob3QYAiABKAsyHy5zeW5jdHYuY2xpZW50LlBsYXliYWNrU25hcHNob3RSCHNuYXBzaG90');

@$core.Deprecated('Use userJoinedRoomDescriptor instead')
const UserJoinedRoom$json = {
  '1': 'UserJoinedRoom',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
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

/// Descriptor for `UserJoinedRoom`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userJoinedRoomDescriptor = $convert.base64Decode(
    'Cg5Vc2VySm9pbmVkUm9vbRIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSMQoGbWVtYmVyGAIgAS'
    'gLMhkuc3luY3R2LmNvbW1vbi5Sb29tTWVtYmVyUgZtZW1iZXI=');

@$core.Deprecated('Use userLeftRoomDescriptor instead')
const UserLeftRoom$json = {
  '1': 'UserLeftRoom',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `UserLeftRoom`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userLeftRoomDescriptor = $convert.base64Decode(
    'CgxVc2VyTGVmdFJvb20SFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEhcKB3VzZXJfaWQYAiABKA'
    'lSBnVzZXJJZA==');

@$core.Deprecated('Use roomSettingsChangedDescriptor instead')
const RoomSettingsChanged$json = {
  '1': 'RoomSettingsChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'settings', '3': 2, '4': 1, '5': 12, '10': 'settings'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `RoomSettingsChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomSettingsChangedDescriptor = $convert.base64Decode(
    'ChNSb29tU2V0dGluZ3NDaGFuZ2VkEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIaCghzZXR0aW'
    '5ncxgCIAEoDFIIc2V0dGluZ3MSGAoHdmVyc2lvbhgDIAEoA1IHdmVyc2lvbg==');

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
  ],
};

/// Descriptor for `GetChatHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChatHistoryResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDaGF0SGlzdG9yeVJlc3BvbnNlEj0KCG1lc3NhZ2VzGAEgAygLMiEuc3luY3R2LmNsaW'
    'VudC5DaGF0TWVzc2FnZVJlY2VpdmVSCG1lc3NhZ2VzEh8KC25leHRfY3Vyc29yGAIgASgJUgpu'
    'ZXh0Q3Vyc29y');

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
    'CFIVZW1haWxTaWdudXBOZWVkUmV2aWV3EjQKFmVuYWJsZV93ZWJhdXRobl9zaWdudXAYFiABKA'
    'hSFGVuYWJsZVdlYmF1dGhuU2lnbnVwEj0KG3dlYmF1dGhuX3NpZ251cF9uZWVkX3JldmlldxgX'
    'IAEoCFIYd2ViYXV0aG5TaWdudXBOZWVkUmV2aWV3Eh8KC21vdmllX3Byb3h5GAsgASgIUgptb3'
    'ZpZVByb3h5Eh0KCmxpdmVfcHJveHkYDCABKAhSCWxpdmVQcm94eRItChN0c19kaXNndWlzZWRf'
    'YXNfcG5nGA0gASgIUhB0c0Rpc2d1aXNlZEFzUG5nEi4KE2N1c3RvbV9wdWJsaXNoX2hvc3QYDi'
    'ABKAlSEWN1c3RvbVB1Ymxpc2hIb3N0EjYKF2VtYWlsX3doaXRlbGlzdF9lbmFibGVkGA8gASgI'
    'UhVlbWFpbFdoaXRlbGlzdEVuYWJsZWQ=');

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

@$core.Deprecated('Use sendVerificationEmailRequestDescriptor instead')
const SendVerificationEmailRequest$json = {
  '1': 'SendVerificationEmailRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `SendVerificationEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationEmailRequestDescriptor =
    $convert.base64Decode(
        'ChxTZW5kVmVyaWZpY2F0aW9uRW1haWxSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbA==');

@$core.Deprecated('Use sendVerificationEmailResponseDescriptor instead')
const SendVerificationEmailResponse$json = {
  '1': 'SendVerificationEmailResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SendVerificationEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationEmailResponseDescriptor =
    $convert.base64Decode(
        'Ch1TZW5kVmVyaWZpY2F0aW9uRW1haWxSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYW'
        'dl');

@$core.Deprecated('Use confirmEmailRequestDescriptor instead')
const ConfirmEmailRequest$json = {
  '1': 'ConfirmEmailRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `ConfirmEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmEmailRequestDescriptor = $convert.base64Decode(
    'ChNDb25maXJtRW1haWxSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbBIUCgV0b2tlbhgCIA'
    'EoCVIFdG9rZW4=');

@$core.Deprecated('Use confirmEmailResponseDescriptor instead')
const ConfirmEmailResponse$json = {
  '1': 'ConfirmEmailResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `ConfirmEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmEmailResponseDescriptor = $convert.base64Decode(
    'ChRDb25maXJtRW1haWxSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdlEhcKB3VzZX'
    'JfaWQYAiABKAlSBnVzZXJJZA==');

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

@$core.Deprecated('Use mediaAddedDescriptor instead')
const MediaAdded$json = {
  '1': 'MediaAdded',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'creator_username', '3': 4, '4': 1, '5': 9, '10': 'creatorUsername'},
    {'1': 'creator_id', '3': 5, '4': 1, '5': 9, '10': 'creatorId'},
  ],
};

/// Descriptor for `MediaAdded`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaAddedDescriptor = $convert.base64Decode(
    'CgpNZWRpYUFkZGVkEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIZCghtZWRpYV9pZBgCIAEoCV'
    'IHbWVkaWFJZBISCgRuYW1lGAMgASgJUgRuYW1lEikKEGNyZWF0b3JfdXNlcm5hbWUYBCABKAlS'
    'D2NyZWF0b3JVc2VybmFtZRIdCgpjcmVhdG9yX2lkGAUgASgJUgljcmVhdG9ySWQ=');

@$core.Deprecated('Use mediaRemovedDescriptor instead')
const MediaRemoved$json = {
  '1': 'MediaRemoved',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'removed_by', '3': 4, '4': 1, '5': 9, '10': 'removedBy'},
    {
      '1': 'removed_by_user_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'removedByUserId'
    },
  ],
};

/// Descriptor for `MediaRemoved`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaRemovedDescriptor = $convert.base64Decode(
    'CgxNZWRpYVJlbW92ZWQSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEhkKCG1lZGlhX2lkGAIgAS'
    'gJUgdtZWRpYUlkEh0KCnJlbW92ZWRfYnkYBCABKAlSCXJlbW92ZWRCeRIrChJyZW1vdmVkX2J5'
    'X3VzZXJfaWQYBSABKAlSD3JlbW92ZWRCeVVzZXJJZA==');

@$core.Deprecated('Use mediaRemovedBatchDescriptor instead')
const MediaRemovedBatch$json = {
  '1': 'MediaRemovedBatch',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_ids', '3': 2, '4': 3, '5': 9, '10': 'mediaIds'},
    {'1': 'removed_by', '3': 4, '4': 1, '5': 9, '10': 'removedBy'},
    {
      '1': 'removed_by_user_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'removedByUserId'
    },
  ],
};

/// Descriptor for `MediaRemovedBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaRemovedBatchDescriptor = $convert.base64Decode(
    'ChFNZWRpYVJlbW92ZWRCYXRjaBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSGwoJbWVkaWFfaW'
    'RzGAIgAygJUghtZWRpYUlkcxIdCgpyZW1vdmVkX2J5GAQgASgJUglyZW1vdmVkQnkSKwoScmVt'
    'b3ZlZF9ieV91c2VyX2lkGAUgASgJUg9yZW1vdmVkQnlVc2VySWQ=');

@$core.Deprecated('Use mediaUpdatedDescriptor instead')
const MediaUpdated$json = {
  '1': 'MediaUpdated',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_id', '3': 2, '4': 1, '5': 9, '10': 'mediaId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'updated_by', '3': 4, '4': 1, '5': 9, '10': 'updatedBy'},
    {
      '1': 'updated_by_user_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'updatedByUserId'
    },
  ],
};

/// Descriptor for `MediaUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaUpdatedDescriptor = $convert.base64Decode(
    'CgxNZWRpYVVwZGF0ZWQSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEhkKCG1lZGlhX2lkGAIgAS'
    'gJUgdtZWRpYUlkEhIKBG5hbWUYAyABKAlSBG5hbWUSHQoKdXBkYXRlZF9ieRgEIAEoCVIJdXBk'
    'YXRlZEJ5EisKEnVwZGF0ZWRfYnlfdXNlcl9pZBgFIAEoCVIPdXBkYXRlZEJ5VXNlcklk');

@$core.Deprecated('Use permissionChangedDescriptor instead')
const PermissionChanged$json = {
  '1': 'PermissionChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.RoomMemberRole',
      '10': 'role'
    },
    {
      '1': 'effective_permissions',
      '3': 4,
      '4': 1,
      '5': 4,
      '10': 'effectivePermissions'
    },
    {
      '1': 'added_permissions',
      '3': 5,
      '4': 1,
      '5': 4,
      '10': 'addedPermissions'
    },
    {
      '1': 'removed_permissions',
      '3': 6,
      '4': 1,
      '5': 4,
      '10': 'removedPermissions'
    },
    {
      '1': 'admin_added_permissions',
      '3': 7,
      '4': 1,
      '5': 4,
      '10': 'adminAddedPermissions'
    },
    {
      '1': 'admin_removed_permissions',
      '3': 8,
      '4': 1,
      '5': 4,
      '10': 'adminRemovedPermissions'
    },
    {'1': 'updated_by', '3': 9, '4': 1, '5': 9, '10': 'updatedBy'},
  ],
};

/// Descriptor for `PermissionChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List permissionChangedDescriptor = $convert.base64Decode(
    'ChFQZXJtaXNzaW9uQ2hhbmdlZBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSFwoHdXNlcl9pZB'
    'gCIAEoCVIGdXNlcklkEjEKBHJvbGUYAyABKA4yHS5zeW5jdHYuY29tbW9uLlJvb21NZW1iZXJS'
    'b2xlUgRyb2xlEjMKFWVmZmVjdGl2ZV9wZXJtaXNzaW9ucxgEIAEoBFIUZWZmZWN0aXZlUGVybW'
    'lzc2lvbnMSKwoRYWRkZWRfcGVybWlzc2lvbnMYBSABKARSEGFkZGVkUGVybWlzc2lvbnMSLwoT'
    'cmVtb3ZlZF9wZXJtaXNzaW9ucxgGIAEoBFIScmVtb3ZlZFBlcm1pc3Npb25zEjYKF2FkbWluX2'
    'FkZGVkX3Blcm1pc3Npb25zGAcgASgEUhVhZG1pbkFkZGVkUGVybWlzc2lvbnMSOgoZYWRtaW5f'
    'cmVtb3ZlZF9wZXJtaXNzaW9ucxgIIAEoBFIXYWRtaW5SZW1vdmVkUGVybWlzc2lvbnMSHQoKdX'
    'BkYXRlZF9ieRgJIAEoCVIJdXBkYXRlZEJ5');

@$core.Deprecated('Use playlistCreatedDescriptor instead')
const PlaylistCreated$json = {
  '1': 'PlaylistCreated',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'playlist',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
  ],
};

/// Descriptor for `PlaylistCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistCreatedDescriptor = $convert.base64Decode(
    'Cg9QbGF5bGlzdENyZWF0ZWQSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEjMKCHBsYXlsaXN0GA'
    'IgASgLMhcuc3luY3R2LmNsaWVudC5QbGF5bGlzdFIIcGxheWxpc3Q=');

@$core.Deprecated('Use playlistUpdatedDescriptor instead')
const PlaylistUpdated$json = {
  '1': 'PlaylistUpdated',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'playlist',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
  ],
};

/// Descriptor for `PlaylistUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistUpdatedDescriptor = $convert.base64Decode(
    'Cg9QbGF5bGlzdFVwZGF0ZWQSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEjMKCHBsYXlsaXN0GA'
    'IgASgLMhcuc3luY3R2LmNsaWVudC5QbGF5bGlzdFIIcGxheWxpc3Q=');

@$core.Deprecated('Use playlistDeletedDescriptor instead')
const PlaylistDeleted$json = {
  '1': 'PlaylistDeleted',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'playlist_id', '3': 2, '4': 1, '5': 9, '10': 'playlistId'},
  ],
};

/// Descriptor for `PlaylistDeleted`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistDeletedDescriptor = $convert.base64Decode(
    'Cg9QbGF5bGlzdERlbGV0ZWQSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEh8KC3BsYXlsaXN0X2'
    'lkGAIgASgJUgpwbGF5bGlzdElk');

@$core.Deprecated('Use playlistReorderedDescriptor instead')
const PlaylistReordered$json = {
  '1': 'PlaylistReordered',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'media_ids', '3': 2, '4': 3, '5': 9, '10': 'mediaIds'},
    {'1': 'reordered_by', '3': 3, '4': 1, '5': 9, '10': 'reorderedBy'},
    {
      '1': 'reordered_by_user_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'reorderedByUserId'
    },
  ],
};

/// Descriptor for `PlaylistReordered`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistReorderedDescriptor = $convert.base64Decode(
    'ChFQbGF5bGlzdFJlb3JkZXJlZBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSGwoJbWVkaWFfaW'
    'RzGAIgAygJUghtZWRpYUlkcxIhCgxyZW9yZGVyZWRfYnkYAyABKAlSC3Jlb3JkZXJlZEJ5Ei8K'
    'FHJlb3JkZXJlZF9ieV91c2VyX2lkGAQgASgJUhFyZW9yZGVyZWRCeVVzZXJJZA==');

@$core.Deprecated('Use playingChangedDescriptor instead')
const PlayingChanged$json = {
  '1': 'PlayingChanged',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'playlist',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Playlist',
      '10': 'playlist'
    },
    {
      '1': 'playing_media',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.Media',
      '10': 'playingMedia'
    },
  ],
};

/// Descriptor for `PlayingChanged`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playingChangedDescriptor = $convert.base64Decode(
    'Cg5QbGF5aW5nQ2hhbmdlZBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSMwoIcGxheWxpc3QYAi'
    'ABKAsyFy5zeW5jdHYuY2xpZW50LlBsYXlsaXN0UghwbGF5bGlzdBI5Cg1wbGF5aW5nX21lZGlh'
    'GAMgASgLMhQuc3luY3R2LmNsaWVudC5NZWRpYVIMcGxheWluZ01lZGlh');

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
