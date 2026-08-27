// This is a generated file - do not edit.
//
// Generated from proto/client.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PlayMode extends $pb.ProtobufEnum {
  static const PlayMode PLAY_MODE_UNSPECIFIED =
      PlayMode._(0, _omitEnumNames ? '' : 'PLAY_MODE_UNSPECIFIED');
  static const PlayMode PLAY_MODE_SEQUENTIAL =
      PlayMode._(1, _omitEnumNames ? '' : 'PLAY_MODE_SEQUENTIAL');
  static const PlayMode PLAY_MODE_REPEAT_ONE =
      PlayMode._(2, _omitEnumNames ? '' : 'PLAY_MODE_REPEAT_ONE');
  static const PlayMode PLAY_MODE_REPEAT_ALL =
      PlayMode._(3, _omitEnumNames ? '' : 'PLAY_MODE_REPEAT_ALL');
  static const PlayMode PLAY_MODE_SHUFFLE =
      PlayMode._(4, _omitEnumNames ? '' : 'PLAY_MODE_SHUFFLE');

  static const $core.List<PlayMode> values = <PlayMode>[
    PLAY_MODE_UNSPECIFIED,
    PLAY_MODE_SEQUENTIAL,
    PLAY_MODE_REPEAT_ONE,
    PLAY_MODE_REPEAT_ALL,
    PLAY_MODE_SHUFFLE,
  ];

  static final $core.List<PlayMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PlayMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlayMode._(super.value, super.name);
}

class TwitchTargetKind extends $pb.ProtobufEnum {
  static const TwitchTargetKind TWITCH_TARGET_KIND_UNSPECIFIED =
      TwitchTargetKind._(
          0, _omitEnumNames ? '' : 'TWITCH_TARGET_KIND_UNSPECIFIED');
  static const TwitchTargetKind TWITCH_TARGET_KIND_VIDEO =
      TwitchTargetKind._(1, _omitEnumNames ? '' : 'TWITCH_TARGET_KIND_VIDEO');
  static const TwitchTargetKind TWITCH_TARGET_KIND_CLIP =
      TwitchTargetKind._(2, _omitEnumNames ? '' : 'TWITCH_TARGET_KIND_CLIP');
  static const TwitchTargetKind TWITCH_TARGET_KIND_LIVE =
      TwitchTargetKind._(3, _omitEnumNames ? '' : 'TWITCH_TARGET_KIND_LIVE');

  static const $core.List<TwitchTargetKind> values = <TwitchTargetKind>[
    TWITCH_TARGET_KIND_UNSPECIFIED,
    TWITCH_TARGET_KIND_VIDEO,
    TWITCH_TARGET_KIND_CLIP,
    TWITCH_TARGET_KIND_LIVE,
  ];

  static final $core.List<TwitchTargetKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TwitchTargetKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TwitchTargetKind._(super.value, super.name);
}

class PlaybackChangeReason extends $pb.ProtobufEnum {
  static const PlaybackChangeReason PLAYBACK_CHANGE_REASON_UNSPECIFIED =
      PlaybackChangeReason._(
          0, _omitEnumNames ? '' : 'PLAYBACK_CHANGE_REASON_UNSPECIFIED');
  static const PlaybackChangeReason PLAYBACK_CHANGE_REASON_SELECTED =
      PlaybackChangeReason._(
          1, _omitEnumNames ? '' : 'PLAYBACK_CHANGE_REASON_SELECTED');
  static const PlaybackChangeReason PLAYBACK_CHANGE_REASON_NEXT =
      PlaybackChangeReason._(
          2, _omitEnumNames ? '' : 'PLAYBACK_CHANGE_REASON_NEXT');
  static const PlaybackChangeReason PLAYBACK_CHANGE_REASON_PREVIOUS =
      PlaybackChangeReason._(
          3, _omitEnumNames ? '' : 'PLAYBACK_CHANGE_REASON_PREVIOUS');
  static const PlaybackChangeReason PLAYBACK_CHANGE_REASON_HISTORY_ENTRY =
      PlaybackChangeReason._(
          4, _omitEnumNames ? '' : 'PLAYBACK_CHANGE_REASON_HISTORY_ENTRY');
  static const PlaybackChangeReason PLAYBACK_CHANGE_REASON_AUTO_ADVANCE =
      PlaybackChangeReason._(
          5, _omitEnumNames ? '' : 'PLAYBACK_CHANGE_REASON_AUTO_ADVANCE');

  static const $core.List<PlaybackChangeReason> values = <PlaybackChangeReason>[
    PLAYBACK_CHANGE_REASON_UNSPECIFIED,
    PLAYBACK_CHANGE_REASON_SELECTED,
    PLAYBACK_CHANGE_REASON_NEXT,
    PLAYBACK_CHANGE_REASON_PREVIOUS,
    PLAYBACK_CHANGE_REASON_HISTORY_ENTRY,
    PLAYBACK_CHANGE_REASON_AUTO_ADVANCE,
  ];

  static final $core.List<PlaybackChangeReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PlaybackChangeReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackChangeReason._(super.value, super.name);
}

class PlaylistBrowseAccessMode extends $pb.ProtobufEnum {
  static const PlaylistBrowseAccessMode PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT =
      PlaylistBrowseAccessMode._(
          0, _omitEnumNames ? '' : 'PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT');
  static const PlaylistBrowseAccessMode
      PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS = PlaylistBrowseAccessMode._(
          1, _omitEnumNames ? '' : 'PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS');
  static const PlaylistBrowseAccessMode
      PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY = PlaylistBrowseAccessMode._(
          2, _omitEnumNames ? '' : 'PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY');

  static const $core.List<PlaylistBrowseAccessMode> values =
      <PlaylistBrowseAccessMode>[
    PLAYLIST_BROWSE_ACCESS_MODE_DEFAULT,
    PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS,
    PLAYLIST_BROWSE_ACCESS_MODE_CREATOR_ONLY,
  ];

  static final $core.List<PlaylistBrowseAccessMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PlaylistBrowseAccessMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaylistBrowseAccessMode._(super.value, super.name);
}

class ResourceAvailability extends $pb.ProtobufEnum {
  static const ResourceAvailability RESOURCE_AVAILABILITY_UNSPECIFIED =
      ResourceAvailability._(
          0, _omitEnumNames ? '' : 'RESOURCE_AVAILABILITY_UNSPECIFIED');
  static const ResourceAvailability RESOURCE_AVAILABILITY_AVAILABLE =
      ResourceAvailability._(
          1, _omitEnumNames ? '' : 'RESOURCE_AVAILABILITY_AVAILABLE');
  static const ResourceAvailability RESOURCE_AVAILABILITY_CREATOR_INACTIVE =
      ResourceAvailability._(
          2, _omitEnumNames ? '' : 'RESOURCE_AVAILABILITY_CREATOR_INACTIVE');

  static const $core.List<ResourceAvailability> values = <ResourceAvailability>[
    RESOURCE_AVAILABILITY_UNSPECIFIED,
    RESOURCE_AVAILABILITY_AVAILABLE,
    RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
  ];

  static final $core.List<ResourceAvailability?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ResourceAvailability? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceAvailability._(super.value, super.name);
}

class ResourceAvailabilityFilter extends $pb.ProtobufEnum {
  static const ResourceAvailabilityFilter RESOURCE_AVAILABILITY_FILTER_ALL =
      ResourceAvailabilityFilter._(
          0, _omitEnumNames ? '' : 'RESOURCE_AVAILABILITY_FILTER_ALL');
  static const ResourceAvailabilityFilter
      RESOURCE_AVAILABILITY_FILTER_AVAILABLE = ResourceAvailabilityFilter._(
          1, _omitEnumNames ? '' : 'RESOURCE_AVAILABILITY_FILTER_AVAILABLE');
  static const ResourceAvailabilityFilter
      RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE = ResourceAvailabilityFilter._(
          2, _omitEnumNames ? '' : 'RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE');

  static const $core.List<ResourceAvailabilityFilter> values =
      <ResourceAvailabilityFilter>[
    RESOURCE_AVAILABILITY_FILTER_ALL,
    RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
    RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE,
  ];

  static final $core.List<ResourceAvailabilityFilter?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ResourceAvailabilityFilter? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceAvailabilityFilter._(super.value, super.name);
}

class RegistrationStatus extends $pb.ProtobufEnum {
  static const RegistrationStatus REGISTRATION_STATUS_UNSPECIFIED =
      RegistrationStatus._(
          0, _omitEnumNames ? '' : 'REGISTRATION_STATUS_UNSPECIFIED');
  static const RegistrationStatus REGISTRATION_STATUS_REGISTERED =
      RegistrationStatus._(
          1, _omitEnumNames ? '' : 'REGISTRATION_STATUS_REGISTERED');
  static const RegistrationStatus REGISTRATION_STATUS_PENDING_REVIEW =
      RegistrationStatus._(
          2, _omitEnumNames ? '' : 'REGISTRATION_STATUS_PENDING_REVIEW');

  static const $core.List<RegistrationStatus> values = <RegistrationStatus>[
    REGISTRATION_STATUS_UNSPECIFIED,
    REGISTRATION_STATUS_REGISTERED,
    REGISTRATION_STATUS_PENDING_REVIEW,
  ];

  static final $core.List<RegistrationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RegistrationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RegistrationStatus._(super.value, super.name);
}

class LoginMethod extends $pb.ProtobufEnum {
  static const LoginMethod LOGIN_METHOD_UNSPECIFIED =
      LoginMethod._(0, _omitEnumNames ? '' : 'LOGIN_METHOD_UNSPECIFIED');
  static const LoginMethod LOGIN_METHOD_PASSWORD =
      LoginMethod._(1, _omitEnumNames ? '' : 'LOGIN_METHOD_PASSWORD');
  static const LoginMethod LOGIN_METHOD_PASSKEY =
      LoginMethod._(2, _omitEnumNames ? '' : 'LOGIN_METHOD_PASSKEY');
  static const LoginMethod LOGIN_METHOD_EMAIL_CODE =
      LoginMethod._(3, _omitEnumNames ? '' : 'LOGIN_METHOD_EMAIL_CODE');

  static const $core.List<LoginMethod> values = <LoginMethod>[
    LOGIN_METHOD_UNSPECIFIED,
    LOGIN_METHOD_PASSWORD,
    LOGIN_METHOD_PASSKEY,
    LOGIN_METHOD_EMAIL_CODE,
  ];

  static final $core.List<LoginMethod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static LoginMethod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LoginMethod._(super.value, super.name);
}

class MfaMethod extends $pb.ProtobufEnum {
  static const MfaMethod MFA_METHOD_UNSPECIFIED =
      MfaMethod._(0, _omitEnumNames ? '' : 'MFA_METHOD_UNSPECIFIED');
  static const MfaMethod MFA_METHOD_PASSWORD =
      MfaMethod._(1, _omitEnumNames ? '' : 'MFA_METHOD_PASSWORD');
  static const MfaMethod MFA_METHOD_WEBAUTHN =
      MfaMethod._(2, _omitEnumNames ? '' : 'MFA_METHOD_WEBAUTHN');
  static const MfaMethod MFA_METHOD_EMAIL =
      MfaMethod._(3, _omitEnumNames ? '' : 'MFA_METHOD_EMAIL');
  static const MfaMethod MFA_METHOD_TOTP =
      MfaMethod._(4, _omitEnumNames ? '' : 'MFA_METHOD_TOTP');
  static const MfaMethod MFA_METHOD_RECOVERY_CODE =
      MfaMethod._(5, _omitEnumNames ? '' : 'MFA_METHOD_RECOVERY_CODE');

  static const $core.List<MfaMethod> values = <MfaMethod>[
    MFA_METHOD_UNSPECIFIED,
    MFA_METHOD_PASSWORD,
    MFA_METHOD_WEBAUTHN,
    MFA_METHOD_EMAIL,
    MFA_METHOD_TOTP,
    MFA_METHOD_RECOVERY_CODE,
  ];

  static final $core.List<MfaMethod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static MfaMethod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MfaMethod._(super.value, super.name);
}

class SensitiveOperationVerificationMethod extends $pb.ProtobufEnum {
  static const SensitiveOperationVerificationMethod
      SENSITIVE_OPERATION_VERIFICATION_METHOD_UNSPECIFIED =
      SensitiveOperationVerificationMethod._(
          0,
          _omitEnumNames
              ? ''
              : 'SENSITIVE_OPERATION_VERIFICATION_METHOD_UNSPECIFIED');
  static const SensitiveOperationVerificationMethod
      SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD =
      SensitiveOperationVerificationMethod._(
          1,
          _omitEnumNames
              ? ''
              : 'SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD');
  static const SensitiveOperationVerificationMethod
      SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN =
      SensitiveOperationVerificationMethod._(
          2,
          _omitEnumNames
              ? ''
              : 'SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN');
  static const SensitiveOperationVerificationMethod
      SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL =
      SensitiveOperationVerificationMethod._(
          3,
          _omitEnumNames
              ? ''
              : 'SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL');
  static const SensitiveOperationVerificationMethod
      SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP =
      SensitiveOperationVerificationMethod._(4,
          _omitEnumNames ? '' : 'SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP');
  static const SensitiveOperationVerificationMethod
      SENSITIVE_OPERATION_VERIFICATION_METHOD_RECOVERY_CODE =
      SensitiveOperationVerificationMethod._(
          5,
          _omitEnumNames
              ? ''
              : 'SENSITIVE_OPERATION_VERIFICATION_METHOD_RECOVERY_CODE');

  static const $core.List<SensitiveOperationVerificationMethod> values =
      <SensitiveOperationVerificationMethod>[
    SENSITIVE_OPERATION_VERIFICATION_METHOD_UNSPECIFIED,
    SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD,
    SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
    SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL,
    SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP,
    SENSITIVE_OPERATION_VERIFICATION_METHOD_RECOVERY_CODE,
  ];

  static final $core.List<SensitiveOperationVerificationMethod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SensitiveOperationVerificationMethod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SensitiveOperationVerificationMethod._(super.value, super.name);
}

/// Start changing the current user's password credential via OPAQUE. This is an
/// authenticated endpoint; successful finish stores the updated account
/// credential as OPAQUE material.
class OpaquePasswordUpdateVerificationMethod extends $pb.ProtobufEnum {
  static const OpaquePasswordUpdateVerificationMethod
      OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_UNSPECIFIED =
      OpaquePasswordUpdateVerificationMethod._(
          0,
          _omitEnumNames
              ? ''
              : 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_UNSPECIFIED');
  static const OpaquePasswordUpdateVerificationMethod
      OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD =
      OpaquePasswordUpdateVerificationMethod._(
          1,
          _omitEnumNames
              ? ''
              : 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD');
  static const OpaquePasswordUpdateVerificationMethod
      OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_EMAIL_TOKEN =
      OpaquePasswordUpdateVerificationMethod._(
          2,
          _omitEnumNames
              ? ''
              : 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_EMAIL_TOKEN');
  static const OpaquePasswordUpdateVerificationMethod
      OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_PASSKEY =
      OpaquePasswordUpdateVerificationMethod._(
          3,
          _omitEnumNames
              ? ''
              : 'OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_PASSKEY');

  static const $core.List<OpaquePasswordUpdateVerificationMethod> values =
      <OpaquePasswordUpdateVerificationMethod>[
    OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_UNSPECIFIED,
    OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_CURRENT_OPAQUE_PASSWORD,
    OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_EMAIL_TOKEN,
    OPAQUE_PASSWORD_UPDATE_VERIFICATION_METHOD_PASSKEY,
  ];

  static final $core.List<OpaquePasswordUpdateVerificationMethod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static OpaquePasswordUpdateVerificationMethod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OpaquePasswordUpdateVerificationMethod._(super.value, super.name);
}

class RoomDiscoveryAccess extends $pb.ProtobufEnum {
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_UNSPECIFIED =
      RoomDiscoveryAccess._(
          0, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_UNSPECIFIED');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_ENTER =
      RoomDiscoveryAccess._(
          1, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_ENTER');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_JOIN =
      RoomDiscoveryAccess._(
          2, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_JOIN');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_PASSWORD =
      RoomDiscoveryAccess._(
          3, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_PASSWORD');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_REQUEST_APPROVAL =
      RoomDiscoveryAccess._(
          4, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_REQUEST_APPROVAL');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_PENDING_APPROVAL =
      RoomDiscoveryAccess._(
          5, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_PENDING_APPROVAL');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_SIGN_IN =
      RoomDiscoveryAccess._(
          6, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_SIGN_IN');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_INVITATION =
      RoomDiscoveryAccess._(
          7, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_INVITATION');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_FULL =
      RoomDiscoveryAccess._(
          8, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_FULL');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_UNAVAILABLE =
      RoomDiscoveryAccess._(
          9, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_UNAVAILABLE');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_COOLDOWN =
      RoomDiscoveryAccess._(
          10, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_COOLDOWN');
  static const RoomDiscoveryAccess ROOM_DISCOVERY_ACCESS_GUEST =
      RoomDiscoveryAccess._(
          11, _omitEnumNames ? '' : 'ROOM_DISCOVERY_ACCESS_GUEST');

  static const $core.List<RoomDiscoveryAccess> values = <RoomDiscoveryAccess>[
    ROOM_DISCOVERY_ACCESS_UNSPECIFIED,
    ROOM_DISCOVERY_ACCESS_ENTER,
    ROOM_DISCOVERY_ACCESS_JOIN,
    ROOM_DISCOVERY_ACCESS_PASSWORD,
    ROOM_DISCOVERY_ACCESS_REQUEST_APPROVAL,
    ROOM_DISCOVERY_ACCESS_PENDING_APPROVAL,
    ROOM_DISCOVERY_ACCESS_SIGN_IN,
    ROOM_DISCOVERY_ACCESS_INVITATION,
    ROOM_DISCOVERY_ACCESS_FULL,
    ROOM_DISCOVERY_ACCESS_UNAVAILABLE,
    ROOM_DISCOVERY_ACCESS_COOLDOWN,
    ROOM_DISCOVERY_ACCESS_GUEST,
  ];

  static final $core.List<RoomDiscoveryAccess?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 11);
  static RoomDiscoveryAccess? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomDiscoveryAccess._(super.value, super.name);
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

class RoomStreamListSortBy extends $pb.ProtobufEnum {
  static const RoomStreamListSortBy ROOM_STREAM_LIST_SORT_BY_UNSPECIFIED =
      RoomStreamListSortBy._(
          0, _omitEnumNames ? '' : 'ROOM_STREAM_LIST_SORT_BY_UNSPECIFIED');
  static const RoomStreamListSortBy ROOM_STREAM_LIST_SORT_BY_MEDIA_ID =
      RoomStreamListSortBy._(
          1, _omitEnumNames ? '' : 'ROOM_STREAM_LIST_SORT_BY_MEDIA_ID');

  static const $core.List<RoomStreamListSortBy> values = <RoomStreamListSortBy>[
    ROOM_STREAM_LIST_SORT_BY_UNSPECIFIED,
    ROOM_STREAM_LIST_SORT_BY_MEDIA_ID,
  ];

  static final $core.List<RoomStreamListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static RoomStreamListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomStreamListSortBy._(super.value, super.name);
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

class PlaylistListSortBy extends $pb.ProtobufEnum {
  static const PlaylistListSortBy PLAYLIST_LIST_SORT_BY_UNSPECIFIED =
      PlaylistListSortBy._(
          0, _omitEnumNames ? '' : 'PLAYLIST_LIST_SORT_BY_UNSPECIFIED');
  static const PlaylistListSortBy PLAYLIST_LIST_SORT_BY_POSITION =
      PlaylistListSortBy._(
          1, _omitEnumNames ? '' : 'PLAYLIST_LIST_SORT_BY_POSITION');
  static const PlaylistListSortBy PLAYLIST_LIST_SORT_BY_NAME =
      PlaylistListSortBy._(
          2, _omitEnumNames ? '' : 'PLAYLIST_LIST_SORT_BY_NAME');
  static const PlaylistListSortBy PLAYLIST_LIST_SORT_BY_CREATED_AT =
      PlaylistListSortBy._(
          3, _omitEnumNames ? '' : 'PLAYLIST_LIST_SORT_BY_CREATED_AT');
  static const PlaylistListSortBy PLAYLIST_LIST_SORT_BY_UPDATED_AT =
      PlaylistListSortBy._(
          4, _omitEnumNames ? '' : 'PLAYLIST_LIST_SORT_BY_UPDATED_AT');

  static const $core.List<PlaylistListSortBy> values = <PlaylistListSortBy>[
    PLAYLIST_LIST_SORT_BY_UNSPECIFIED,
    PLAYLIST_LIST_SORT_BY_POSITION,
    PLAYLIST_LIST_SORT_BY_NAME,
    PLAYLIST_LIST_SORT_BY_CREATED_AT,
    PLAYLIST_LIST_SORT_BY_UPDATED_AT,
  ];

  static final $core.List<PlaylistListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PlaylistListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaylistListSortBy._(super.value, super.name);
}

class MediaListSortBy extends $pb.ProtobufEnum {
  static const MediaListSortBy MEDIA_LIST_SORT_BY_UNSPECIFIED =
      MediaListSortBy._(
          0, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_UNSPECIFIED');
  static const MediaListSortBy MEDIA_LIST_SORT_BY_POSITION =
      MediaListSortBy._(1, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_POSITION');
  static const MediaListSortBy MEDIA_LIST_SORT_BY_NAME =
      MediaListSortBy._(2, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_NAME');
  static const MediaListSortBy MEDIA_LIST_SORT_BY_ADDED_AT =
      MediaListSortBy._(3, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_ADDED_AT');
  static const MediaListSortBy MEDIA_LIST_SORT_BY_UPDATED_AT =
      MediaListSortBy._(
          4, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_UPDATED_AT');
  static const MediaListSortBy MEDIA_LIST_SORT_BY_SOURCE_PROVIDER =
      MediaListSortBy._(
          5, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_SOURCE_PROVIDER');
  static const MediaListSortBy MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME =
      MediaListSortBy._(
          6, _omitEnumNames ? '' : 'MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME');

  static const $core.List<MediaListSortBy> values = <MediaListSortBy>[
    MEDIA_LIST_SORT_BY_UNSPECIFIED,
    MEDIA_LIST_SORT_BY_POSITION,
    MEDIA_LIST_SORT_BY_NAME,
    MEDIA_LIST_SORT_BY_ADDED_AT,
    MEDIA_LIST_SORT_BY_UPDATED_AT,
    MEDIA_LIST_SORT_BY_SOURCE_PROVIDER,
    MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME,
  ];

  static final $core.List<MediaListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static MediaListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MediaListSortBy._(super.value, super.name);
}

class MyRoomListSortBy extends $pb.ProtobufEnum {
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_UNSPECIFIED =
      MyRoomListSortBy._(
          0, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_UNSPECIFIED');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_FREQUENT =
      MyRoomListSortBy._(
          1, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_FREQUENT');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_LAST_VISITED_AT =
      MyRoomListSortBy._(
          2, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_LAST_VISITED_AT');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_JOINED_AT =
      MyRoomListSortBy._(
          3, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_JOINED_AT');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_CREATED_AT =
      MyRoomListSortBy._(
          4, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_CREATED_AT');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_UPDATED_AT =
      MyRoomListSortBy._(
          5, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_UPDATED_AT');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT =
      MyRoomListSortBy._(
          6, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT');
  static const MyRoomListSortBy MY_ROOM_LIST_SORT_BY_NAME =
      MyRoomListSortBy._(7, _omitEnumNames ? '' : 'MY_ROOM_LIST_SORT_BY_NAME');

  static const $core.List<MyRoomListSortBy> values = <MyRoomListSortBy>[
    MY_ROOM_LIST_SORT_BY_UNSPECIFIED,
    MY_ROOM_LIST_SORT_BY_FREQUENT,
    MY_ROOM_LIST_SORT_BY_LAST_VISITED_AT,
    MY_ROOM_LIST_SORT_BY_JOINED_AT,
    MY_ROOM_LIST_SORT_BY_CREATED_AT,
    MY_ROOM_LIST_SORT_BY_UPDATED_AT,
    MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
    MY_ROOM_LIST_SORT_BY_NAME,
  ];

  static final $core.List<MyRoomListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static MyRoomListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MyRoomListSortBy._(super.value, super.name);
}

class MyRoomRelation extends $pb.ProtobufEnum {
  static const MyRoomRelation MY_ROOM_RELATION_UNSPECIFIED =
      MyRoomRelation._(0, _omitEnumNames ? '' : 'MY_ROOM_RELATION_UNSPECIFIED');
  static const MyRoomRelation MY_ROOM_RELATION_ALL =
      MyRoomRelation._(1, _omitEnumNames ? '' : 'MY_ROOM_RELATION_ALL');
  static const MyRoomRelation MY_ROOM_RELATION_CREATED =
      MyRoomRelation._(2, _omitEnumNames ? '' : 'MY_ROOM_RELATION_CREATED');
  static const MyRoomRelation MY_ROOM_RELATION_PARTICIPATING = MyRoomRelation._(
      3, _omitEnumNames ? '' : 'MY_ROOM_RELATION_PARTICIPATING');

  static const $core.List<MyRoomRelation> values = <MyRoomRelation>[
    MY_ROOM_RELATION_UNSPECIFIED,
    MY_ROOM_RELATION_ALL,
    MY_ROOM_RELATION_CREATED,
    MY_ROOM_RELATION_PARTICIPATING,
  ];

  static final $core.List<MyRoomRelation?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MyRoomRelation? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MyRoomRelation._(super.value, super.name);
}

class NotificationListSortBy extends $pb.ProtobufEnum {
  static const NotificationListSortBy NOTIFICATION_LIST_SORT_BY_UNSPECIFIED =
      NotificationListSortBy._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_LIST_SORT_BY_UNSPECIFIED');
  static const NotificationListSortBy NOTIFICATION_LIST_SORT_BY_CREATED_AT =
      NotificationListSortBy._(
          1, _omitEnumNames ? '' : 'NOTIFICATION_LIST_SORT_BY_CREATED_AT');
  static const NotificationListSortBy NOTIFICATION_LIST_SORT_BY_UPDATED_AT =
      NotificationListSortBy._(
          2, _omitEnumNames ? '' : 'NOTIFICATION_LIST_SORT_BY_UPDATED_AT');
  static const NotificationListSortBy NOTIFICATION_LIST_SORT_BY_TITLE =
      NotificationListSortBy._(
          3, _omitEnumNames ? '' : 'NOTIFICATION_LIST_SORT_BY_TITLE');

  static const $core.List<NotificationListSortBy> values =
      <NotificationListSortBy>[
    NOTIFICATION_LIST_SORT_BY_UNSPECIFIED,
    NOTIFICATION_LIST_SORT_BY_CREATED_AT,
    NOTIFICATION_LIST_SORT_BY_UPDATED_AT,
    NOTIFICATION_LIST_SORT_BY_TITLE,
  ];

  static final $core.List<NotificationListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static NotificationListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotificationListSortBy._(super.value, super.name);
}

class PublishKeyType extends $pb.ProtobufEnum {
  static const PublishKeyType PUBLISH_KEY_TYPE_UNSPECIFIED =
      PublishKeyType._(0, _omitEnumNames ? '' : 'PUBLISH_KEY_TYPE_UNSPECIFIED');
  static const PublishKeyType PUBLISH_KEY_TYPE_SINGLE_USE =
      PublishKeyType._(1, _omitEnumNames ? '' : 'PUBLISH_KEY_TYPE_SINGLE_USE');
  static const PublishKeyType PUBLISH_KEY_TYPE_EXPIRING =
      PublishKeyType._(2, _omitEnumNames ? '' : 'PUBLISH_KEY_TYPE_EXPIRING');
  static const PublishKeyType PUBLISH_KEY_TYPE_PERMANENT =
      PublishKeyType._(3, _omitEnumNames ? '' : 'PUBLISH_KEY_TYPE_PERMANENT');

  static const $core.List<PublishKeyType> values = <PublishKeyType>[
    PUBLISH_KEY_TYPE_UNSPECIFIED,
    PUBLISH_KEY_TYPE_SINGLE_USE,
    PUBLISH_KEY_TYPE_EXPIRING,
    PUBLISH_KEY_TYPE_PERMANENT,
  ];

  static final $core.List<PublishKeyType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PublishKeyType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PublishKeyType._(super.value, super.name);
}

class ItemType extends $pb.ProtobufEnum {
  static const ItemType ITEM_TYPE_UNSPECIFIED =
      ItemType._(0, _omitEnumNames ? '' : 'ITEM_TYPE_UNSPECIFIED');
  static const ItemType ITEM_TYPE_PLAYLIST =
      ItemType._(1, _omitEnumNames ? '' : 'ITEM_TYPE_PLAYLIST');
  static const ItemType ITEM_TYPE_MEDIA =
      ItemType._(2, _omitEnumNames ? '' : 'ITEM_TYPE_MEDIA');

  static const $core.List<ItemType> values = <ItemType>[
    ITEM_TYPE_UNSPECIFIED,
    ITEM_TYPE_PLAYLIST,
    ITEM_TYPE_MEDIA,
  ];

  static final $core.List<ItemType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ItemType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ItemType._(super.value, super.name);
}

class PlaybackUpdateType extends $pb.ProtobufEnum {
  static const PlaybackUpdateType PLAYBACK_UPDATE_TYPE_UNSPECIFIED =
      PlaybackUpdateType._(
          0, _omitEnumNames ? '' : 'PLAYBACK_UPDATE_TYPE_UNSPECIFIED');
  static const PlaybackUpdateType PLAYBACK_UPDATE_TYPE_PLAY =
      PlaybackUpdateType._(
          1, _omitEnumNames ? '' : 'PLAYBACK_UPDATE_TYPE_PLAY');
  static const PlaybackUpdateType PLAYBACK_UPDATE_TYPE_PAUSE =
      PlaybackUpdateType._(
          2, _omitEnumNames ? '' : 'PLAYBACK_UPDATE_TYPE_PAUSE');
  static const PlaybackUpdateType PLAYBACK_UPDATE_TYPE_SEEK =
      PlaybackUpdateType._(
          3, _omitEnumNames ? '' : 'PLAYBACK_UPDATE_TYPE_SEEK');
  static const PlaybackUpdateType PLAYBACK_UPDATE_TYPE_SPEED =
      PlaybackUpdateType._(
          4, _omitEnumNames ? '' : 'PLAYBACK_UPDATE_TYPE_SPEED');

  static const $core.List<PlaybackUpdateType> values = <PlaybackUpdateType>[
    PLAYBACK_UPDATE_TYPE_UNSPECIFIED,
    PLAYBACK_UPDATE_TYPE_PLAY,
    PLAYBACK_UPDATE_TYPE_PAUSE,
    PLAYBACK_UPDATE_TYPE_SEEK,
    PLAYBACK_UPDATE_TYPE_SPEED,
  ];

  static final $core.List<PlaybackUpdateType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PlaybackUpdateType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackUpdateType._(super.value, super.name);
}

class PlaybackStreamPreference extends $pb.ProtobufEnum {
  static const PlaybackStreamPreference PLAYBACK_STREAM_PREFERENCE_UNSPECIFIED =
      PlaybackStreamPreference._(
          0, _omitEnumNames ? '' : 'PLAYBACK_STREAM_PREFERENCE_UNSPECIFIED');
  static const PlaybackStreamPreference PLAYBACK_STREAM_PREFERENCE_AUTO =
      PlaybackStreamPreference._(
          1, _omitEnumNames ? '' : 'PLAYBACK_STREAM_PREFERENCE_AUTO');
  static const PlaybackStreamPreference PLAYBACK_STREAM_PREFERENCE_DIRECT_PLAY =
      PlaybackStreamPreference._(
          2, _omitEnumNames ? '' : 'PLAYBACK_STREAM_PREFERENCE_DIRECT_PLAY');
  static const PlaybackStreamPreference PLAYBACK_STREAM_PREFERENCE_TRANSCODE =
      PlaybackStreamPreference._(
          3, _omitEnumNames ? '' : 'PLAYBACK_STREAM_PREFERENCE_TRANSCODE');

  static const $core.List<PlaybackStreamPreference> values =
      <PlaybackStreamPreference>[
    PLAYBACK_STREAM_PREFERENCE_UNSPECIFIED,
    PLAYBACK_STREAM_PREFERENCE_AUTO,
    PLAYBACK_STREAM_PREFERENCE_DIRECT_PLAY,
    PLAYBACK_STREAM_PREFERENCE_TRANSCODE,
  ];

  static final $core.List<PlaybackStreamPreference?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlaybackStreamPreference? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackStreamPreference._(super.value, super.name);
}

class PlaybackSubtitlePreference extends $pb.ProtobufEnum {
  static const PlaybackSubtitlePreference
      PLAYBACK_SUBTITLE_PREFERENCE_UNSPECIFIED = PlaybackSubtitlePreference._(
          0, _omitEnumNames ? '' : 'PLAYBACK_SUBTITLE_PREFERENCE_UNSPECIFIED');
  static const PlaybackSubtitlePreference
      PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL = PlaybackSubtitlePreference._(
          1, _omitEnumNames ? '' : 'PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL');
  static const PlaybackSubtitlePreference
      PLAYBACK_SUBTITLE_PREFERENCE_EMBEDDED_OR_EXTERNAL =
      PlaybackSubtitlePreference._(
          2,
          _omitEnumNames
              ? ''
              : 'PLAYBACK_SUBTITLE_PREFERENCE_EMBEDDED_OR_EXTERNAL');
  static const PlaybackSubtitlePreference PLAYBACK_SUBTITLE_PREFERENCE_NONE =
      PlaybackSubtitlePreference._(
          3, _omitEnumNames ? '' : 'PLAYBACK_SUBTITLE_PREFERENCE_NONE');

  static const $core.List<PlaybackSubtitlePreference> values =
      <PlaybackSubtitlePreference>[
    PLAYBACK_SUBTITLE_PREFERENCE_UNSPECIFIED,
    PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
    PLAYBACK_SUBTITLE_PREFERENCE_EMBEDDED_OR_EXTERNAL,
    PLAYBACK_SUBTITLE_PREFERENCE_NONE,
  ];

  static final $core.List<PlaybackSubtitlePreference?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlaybackSubtitlePreference? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackSubtitlePreference._(super.value, super.name);
}

class PlaybackVideoCodec extends $pb.ProtobufEnum {
  static const PlaybackVideoCodec PLAYBACK_VIDEO_CODEC_UNSPECIFIED =
      PlaybackVideoCodec._(
          0, _omitEnumNames ? '' : 'PLAYBACK_VIDEO_CODEC_UNSPECIFIED');
  static const PlaybackVideoCodec PLAYBACK_VIDEO_CODEC_H264 =
      PlaybackVideoCodec._(
          1, _omitEnumNames ? '' : 'PLAYBACK_VIDEO_CODEC_H264');
  static const PlaybackVideoCodec PLAYBACK_VIDEO_CODEC_HEVC =
      PlaybackVideoCodec._(
          2, _omitEnumNames ? '' : 'PLAYBACK_VIDEO_CODEC_HEVC');
  static const PlaybackVideoCodec PLAYBACK_VIDEO_CODEC_VP9 =
      PlaybackVideoCodec._(3, _omitEnumNames ? '' : 'PLAYBACK_VIDEO_CODEC_VP9');
  static const PlaybackVideoCodec PLAYBACK_VIDEO_CODEC_AV1 =
      PlaybackVideoCodec._(4, _omitEnumNames ? '' : 'PLAYBACK_VIDEO_CODEC_AV1');

  static const $core.List<PlaybackVideoCodec> values = <PlaybackVideoCodec>[
    PLAYBACK_VIDEO_CODEC_UNSPECIFIED,
    PLAYBACK_VIDEO_CODEC_H264,
    PLAYBACK_VIDEO_CODEC_HEVC,
    PLAYBACK_VIDEO_CODEC_VP9,
    PLAYBACK_VIDEO_CODEC_AV1,
  ];

  static final $core.List<PlaybackVideoCodec?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PlaybackVideoCodec? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackVideoCodec._(super.value, super.name);
}

class PlaybackContainer extends $pb.ProtobufEnum {
  static const PlaybackContainer PLAYBACK_CONTAINER_UNSPECIFIED =
      PlaybackContainer._(
          0, _omitEnumNames ? '' : 'PLAYBACK_CONTAINER_UNSPECIFIED');
  static const PlaybackContainer PLAYBACK_CONTAINER_MP4 =
      PlaybackContainer._(1, _omitEnumNames ? '' : 'PLAYBACK_CONTAINER_MP4');
  static const PlaybackContainer PLAYBACK_CONTAINER_MKV =
      PlaybackContainer._(2, _omitEnumNames ? '' : 'PLAYBACK_CONTAINER_MKV');
  static const PlaybackContainer PLAYBACK_CONTAINER_WEBM =
      PlaybackContainer._(3, _omitEnumNames ? '' : 'PLAYBACK_CONTAINER_WEBM');

  static const $core.List<PlaybackContainer> values = <PlaybackContainer>[
    PLAYBACK_CONTAINER_UNSPECIFIED,
    PLAYBACK_CONTAINER_MP4,
    PLAYBACK_CONTAINER_MKV,
    PLAYBACK_CONTAINER_WEBM,
  ];

  static final $core.List<PlaybackContainer?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlaybackContainer? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackContainer._(super.value, super.name);
}

class PlaybackLiveTransport extends $pb.ProtobufEnum {
  static const PlaybackLiveTransport PLAYBACK_LIVE_TRANSPORT_UNSPECIFIED =
      PlaybackLiveTransport._(
          0, _omitEnumNames ? '' : 'PLAYBACK_LIVE_TRANSPORT_UNSPECIFIED');
  static const PlaybackLiveTransport PLAYBACK_LIVE_TRANSPORT_HLS =
      PlaybackLiveTransport._(
          1, _omitEnumNames ? '' : 'PLAYBACK_LIVE_TRANSPORT_HLS');
  static const PlaybackLiveTransport PLAYBACK_LIVE_TRANSPORT_FLV =
      PlaybackLiveTransport._(
          2, _omitEnumNames ? '' : 'PLAYBACK_LIVE_TRANSPORT_FLV');
  static const PlaybackLiveTransport PLAYBACK_LIVE_TRANSPORT_WHEP =
      PlaybackLiveTransport._(
          3, _omitEnumNames ? '' : 'PLAYBACK_LIVE_TRANSPORT_WHEP');

  static const $core.List<PlaybackLiveTransport> values =
      <PlaybackLiveTransport>[
    PLAYBACK_LIVE_TRANSPORT_UNSPECIFIED,
    PLAYBACK_LIVE_TRANSPORT_HLS,
    PLAYBACK_LIVE_TRANSPORT_FLV,
    PLAYBACK_LIVE_TRANSPORT_WHEP,
  ];

  static final $core.List<PlaybackLiveTransport?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlaybackLiveTransport? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackLiveTransport._(super.value, super.name);
}

class PlaybackAudioCapability extends $pb.ProtobufEnum {
  static const PlaybackAudioCapability PLAYBACK_AUDIO_CAPABILITY_UNSPECIFIED =
      PlaybackAudioCapability._(
          0, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CAPABILITY_UNSPECIFIED');
  static const PlaybackAudioCapability PLAYBACK_AUDIO_CAPABILITY_STEREO =
      PlaybackAudioCapability._(
          1, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CAPABILITY_STEREO');
  static const PlaybackAudioCapability PLAYBACK_AUDIO_CAPABILITY_SURROUND =
      PlaybackAudioCapability._(
          2, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CAPABILITY_SURROUND');
  static const PlaybackAudioCapability
      PLAYBACK_AUDIO_CAPABILITY_LOSSLESS_SURROUND = PlaybackAudioCapability._(3,
          _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CAPABILITY_LOSSLESS_SURROUND');

  static const $core.List<PlaybackAudioCapability> values =
      <PlaybackAudioCapability>[
    PLAYBACK_AUDIO_CAPABILITY_UNSPECIFIED,
    PLAYBACK_AUDIO_CAPABILITY_STEREO,
    PLAYBACK_AUDIO_CAPABILITY_SURROUND,
    PLAYBACK_AUDIO_CAPABILITY_LOSSLESS_SURROUND,
  ];

  static final $core.List<PlaybackAudioCapability?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlaybackAudioCapability? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackAudioCapability._(super.value, super.name);
}

/// Runtime environment is declared by the client. Servers must not infer it
/// from User-Agent because embedded browsers and privacy modes make that signal
/// unreliable.
class PlaybackClientEnvironment extends $pb.ProtobufEnum {
  static const PlaybackClientEnvironment
      PLAYBACK_CLIENT_ENVIRONMENT_UNSPECIFIED = PlaybackClientEnvironment._(
          0, _omitEnumNames ? '' : 'PLAYBACK_CLIENT_ENVIRONMENT_UNSPECIFIED');
  static const PlaybackClientEnvironment PLAYBACK_CLIENT_ENVIRONMENT_NATIVE =
      PlaybackClientEnvironment._(
          1, _omitEnumNames ? '' : 'PLAYBACK_CLIENT_ENVIRONMENT_NATIVE');
  static const PlaybackClientEnvironment PLAYBACK_CLIENT_ENVIRONMENT_WEB =
      PlaybackClientEnvironment._(
          2, _omitEnumNames ? '' : 'PLAYBACK_CLIENT_ENVIRONMENT_WEB');

  static const $core.List<PlaybackClientEnvironment> values =
      <PlaybackClientEnvironment>[
    PLAYBACK_CLIENT_ENVIRONMENT_UNSPECIFIED,
    PLAYBACK_CLIENT_ENVIRONMENT_NATIVE,
    PLAYBACK_CLIENT_ENVIRONMENT_WEB,
  ];

  static final $core.List<PlaybackClientEnvironment?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PlaybackClientEnvironment? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackClientEnvironment._(super.value, super.name);
}

/// Delivery protocol consumed by a player pipeline. This is independent from
/// the byte container because HLS and DASH can carry several container types.
class PlaybackMediaTransport extends $pb.ProtobufEnum {
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_UNSPECIFIED =
      PlaybackMediaTransport._(
          0, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_UNSPECIFIED');
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE =
      PlaybackMediaTransport._(
          1, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE');
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_HLS =
      PlaybackMediaTransport._(
          2, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_HLS');
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_DASH =
      PlaybackMediaTransport._(
          3, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_DASH');
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_FLV =
      PlaybackMediaTransport._(
          4, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_FLV');
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_MPEG_TS =
      PlaybackMediaTransport._(
          5, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_MPEG_TS');
  static const PlaybackMediaTransport PLAYBACK_MEDIA_TRANSPORT_WEB_RTC =
      PlaybackMediaTransport._(
          6, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_TRANSPORT_WEB_RTC');

  static const $core.List<PlaybackMediaTransport> values =
      <PlaybackMediaTransport>[
    PLAYBACK_MEDIA_TRANSPORT_UNSPECIFIED,
    PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE,
    PLAYBACK_MEDIA_TRANSPORT_HLS,
    PLAYBACK_MEDIA_TRANSPORT_DASH,
    PLAYBACK_MEDIA_TRANSPORT_FLV,
    PLAYBACK_MEDIA_TRANSPORT_MPEG_TS,
    PLAYBACK_MEDIA_TRANSPORT_WEB_RTC,
  ];

  static final $core.List<PlaybackMediaTransport?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PlaybackMediaTransport? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackMediaTransport._(super.value, super.name);
}

class PlaybackMediaPipeline extends $pb.ProtobufEnum {
  static const PlaybackMediaPipeline PLAYBACK_MEDIA_PIPELINE_UNSPECIFIED =
      PlaybackMediaPipeline._(
          0, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_PIPELINE_UNSPECIFIED');
  static const PlaybackMediaPipeline PLAYBACK_MEDIA_PIPELINE_NATIVE =
      PlaybackMediaPipeline._(
          1, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_PIPELINE_NATIVE');
  static const PlaybackMediaPipeline PLAYBACK_MEDIA_PIPELINE_MEDIA_SOURCE =
      PlaybackMediaPipeline._(
          2, _omitEnumNames ? '' : 'PLAYBACK_MEDIA_PIPELINE_MEDIA_SOURCE');
  static const PlaybackMediaPipeline
      PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE = PlaybackMediaPipeline._(3,
          _omitEnumNames ? '' : 'PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE');

  static const $core.List<PlaybackMediaPipeline> values =
      <PlaybackMediaPipeline>[
    PLAYBACK_MEDIA_PIPELINE_UNSPECIFIED,
    PLAYBACK_MEDIA_PIPELINE_NATIVE,
    PLAYBACK_MEDIA_PIPELINE_MEDIA_SOURCE,
    PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE,
  ];

  static final $core.List<PlaybackMediaPipeline?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlaybackMediaPipeline? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackMediaPipeline._(super.value, super.name);
}

class PlaybackAudioCodec extends $pb.ProtobufEnum {
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_UNSPECIFIED =
      PlaybackAudioCodec._(
          0, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_UNSPECIFIED');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_AAC =
      PlaybackAudioCodec._(1, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_AAC');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_MP3 =
      PlaybackAudioCodec._(2, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_MP3');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_OPUS =
      PlaybackAudioCodec._(
          3, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_OPUS');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_VORBIS =
      PlaybackAudioCodec._(
          4, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_VORBIS');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_AC3 =
      PlaybackAudioCodec._(5, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_AC3');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_EAC3 =
      PlaybackAudioCodec._(
          6, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_EAC3');
  static const PlaybackAudioCodec PLAYBACK_AUDIO_CODEC_FLAC =
      PlaybackAudioCodec._(
          7, _omitEnumNames ? '' : 'PLAYBACK_AUDIO_CODEC_FLAC');

  static const $core.List<PlaybackAudioCodec> values = <PlaybackAudioCodec>[
    PLAYBACK_AUDIO_CODEC_UNSPECIFIED,
    PLAYBACK_AUDIO_CODEC_AAC,
    PLAYBACK_AUDIO_CODEC_MP3,
    PLAYBACK_AUDIO_CODEC_OPUS,
    PLAYBACK_AUDIO_CODEC_VORBIS,
    PLAYBACK_AUDIO_CODEC_AC3,
    PLAYBACK_AUDIO_CODEC_EAC3,
    PLAYBACK_AUDIO_CODEC_FLAC,
  ];

  static final $core.List<PlaybackAudioCodec?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static PlaybackAudioCodec? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackAudioCodec._(super.value, super.name);
}

class BilibiliPlaybackKind extends $pb.ProtobufEnum {
  static const BilibiliPlaybackKind BILIBILI_PLAYBACK_KIND_UNSPECIFIED =
      BilibiliPlaybackKind._(
          0, _omitEnumNames ? '' : 'BILIBILI_PLAYBACK_KIND_UNSPECIFIED');
  static const BilibiliPlaybackKind BILIBILI_PLAYBACK_KIND_VIDEO =
      BilibiliPlaybackKind._(
          1, _omitEnumNames ? '' : 'BILIBILI_PLAYBACK_KIND_VIDEO');
  static const BilibiliPlaybackKind BILIBILI_PLAYBACK_KIND_PGC =
      BilibiliPlaybackKind._(
          2, _omitEnumNames ? '' : 'BILIBILI_PLAYBACK_KIND_PGC');
  static const BilibiliPlaybackKind BILIBILI_PLAYBACK_KIND_LIVE =
      BilibiliPlaybackKind._(
          3, _omitEnumNames ? '' : 'BILIBILI_PLAYBACK_KIND_LIVE');

  static const $core.List<BilibiliPlaybackKind> values = <BilibiliPlaybackKind>[
    BILIBILI_PLAYBACK_KIND_UNSPECIFIED,
    BILIBILI_PLAYBACK_KIND_VIDEO,
    BILIBILI_PLAYBACK_KIND_PGC,
    BILIBILI_PLAYBACK_KIND_LIVE,
  ];

  static final $core.List<BilibiliPlaybackKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static BilibiliPlaybackKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliPlaybackKind._(super.value, super.name);
}

class EmbyPlaybackKind extends $pb.ProtobufEnum {
  static const EmbyPlaybackKind EMBY_PLAYBACK_KIND_UNSPECIFIED =
      EmbyPlaybackKind._(
          0, _omitEnumNames ? '' : 'EMBY_PLAYBACK_KIND_UNSPECIFIED');
  static const EmbyPlaybackKind EMBY_PLAYBACK_KIND_MOVIE =
      EmbyPlaybackKind._(1, _omitEnumNames ? '' : 'EMBY_PLAYBACK_KIND_MOVIE');
  static const EmbyPlaybackKind EMBY_PLAYBACK_KIND_EPISODE =
      EmbyPlaybackKind._(2, _omitEnumNames ? '' : 'EMBY_PLAYBACK_KIND_EPISODE');
  static const EmbyPlaybackKind EMBY_PLAYBACK_KIND_VIDEO =
      EmbyPlaybackKind._(3, _omitEnumNames ? '' : 'EMBY_PLAYBACK_KIND_VIDEO');
  static const EmbyPlaybackKind EMBY_PLAYBACK_KIND_AUDIO =
      EmbyPlaybackKind._(4, _omitEnumNames ? '' : 'EMBY_PLAYBACK_KIND_AUDIO');
  static const EmbyPlaybackKind EMBY_PLAYBACK_KIND_MUSIC_ALBUM =
      EmbyPlaybackKind._(
          5, _omitEnumNames ? '' : 'EMBY_PLAYBACK_KIND_MUSIC_ALBUM');

  static const $core.List<EmbyPlaybackKind> values = <EmbyPlaybackKind>[
    EMBY_PLAYBACK_KIND_UNSPECIFIED,
    EMBY_PLAYBACK_KIND_MOVIE,
    EMBY_PLAYBACK_KIND_EPISODE,
    EMBY_PLAYBACK_KIND_VIDEO,
    EMBY_PLAYBACK_KIND_AUDIO,
    EMBY_PLAYBACK_KIND_MUSIC_ALBUM,
  ];

  static final $core.List<EmbyPlaybackKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static EmbyPlaybackKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EmbyPlaybackKind._(super.value, super.name);
}

class LiveStreamAvailability extends $pb.ProtobufEnum {
  static const LiveStreamAvailability LIVE_STREAM_AVAILABILITY_UNSPECIFIED =
      LiveStreamAvailability._(
          0, _omitEnumNames ? '' : 'LIVE_STREAM_AVAILABILITY_UNSPECIFIED');
  static const LiveStreamAvailability LIVE_STREAM_AVAILABILITY_OFFLINE =
      LiveStreamAvailability._(
          1, _omitEnumNames ? '' : 'LIVE_STREAM_AVAILABILITY_OFFLINE');
  static const LiveStreamAvailability LIVE_STREAM_AVAILABILITY_LIVE =
      LiveStreamAvailability._(
          2, _omitEnumNames ? '' : 'LIVE_STREAM_AVAILABILITY_LIVE');

  static const $core.List<LiveStreamAvailability> values =
      <LiveStreamAvailability>[
    LIVE_STREAM_AVAILABILITY_UNSPECIFIED,
    LIVE_STREAM_AVAILABILITY_OFFLINE,
    LIVE_STREAM_AVAILABILITY_LIVE,
  ];

  static final $core.List<LiveStreamAvailability?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static LiveStreamAvailability? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LiveStreamAvailability._(super.value, super.name);
}

class DouyinPlaybackKind extends $pb.ProtobufEnum {
  static const DouyinPlaybackKind DOUYIN_PLAYBACK_KIND_UNSPECIFIED =
      DouyinPlaybackKind._(
          0, _omitEnumNames ? '' : 'DOUYIN_PLAYBACK_KIND_UNSPECIFIED');
  static const DouyinPlaybackKind DOUYIN_PLAYBACK_KIND_VIDEO =
      DouyinPlaybackKind._(
          1, _omitEnumNames ? '' : 'DOUYIN_PLAYBACK_KIND_VIDEO');
  static const DouyinPlaybackKind DOUYIN_PLAYBACK_KIND_LIVE =
      DouyinPlaybackKind._(
          2, _omitEnumNames ? '' : 'DOUYIN_PLAYBACK_KIND_LIVE');

  static const $core.List<DouyinPlaybackKind> values = <DouyinPlaybackKind>[
    DOUYIN_PLAYBACK_KIND_UNSPECIFIED,
    DOUYIN_PLAYBACK_KIND_VIDEO,
    DOUYIN_PLAYBACK_KIND_LIVE,
  ];

  static final $core.List<DouyinPlaybackKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static DouyinPlaybackKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DouyinPlaybackKind._(super.value, super.name);
}

class TikTokPlaybackKind extends $pb.ProtobufEnum {
  static const TikTokPlaybackKind TIK_TOK_PLAYBACK_KIND_UNSPECIFIED =
      TikTokPlaybackKind._(
          0, _omitEnumNames ? '' : 'TIK_TOK_PLAYBACK_KIND_UNSPECIFIED');
  static const TikTokPlaybackKind TIK_TOK_PLAYBACK_KIND_VIDEO =
      TikTokPlaybackKind._(
          1, _omitEnumNames ? '' : 'TIK_TOK_PLAYBACK_KIND_VIDEO');
  static const TikTokPlaybackKind TIK_TOK_PLAYBACK_KIND_LIVE =
      TikTokPlaybackKind._(
          2, _omitEnumNames ? '' : 'TIK_TOK_PLAYBACK_KIND_LIVE');

  static const $core.List<TikTokPlaybackKind> values = <TikTokPlaybackKind>[
    TIK_TOK_PLAYBACK_KIND_UNSPECIFIED,
    TIK_TOK_PLAYBACK_KIND_VIDEO,
    TIK_TOK_PLAYBACK_KIND_LIVE,
  ];

  static final $core.List<TikTokPlaybackKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TikTokPlaybackKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TikTokPlaybackKind._(super.value, super.name);
}

class PlaybackDanmakuDelivery extends $pb.ProtobufEnum {
  static const PlaybackDanmakuDelivery PLAYBACK_DANMAKU_DELIVERY_UNSPECIFIED =
      PlaybackDanmakuDelivery._(
          0, _omitEnumNames ? '' : 'PLAYBACK_DANMAKU_DELIVERY_UNSPECIFIED');
  static const PlaybackDanmakuDelivery PLAYBACK_DANMAKU_DELIVERY_DOCUMENT =
      PlaybackDanmakuDelivery._(
          1, _omitEnumNames ? '' : 'PLAYBACK_DANMAKU_DELIVERY_DOCUMENT');
  static const PlaybackDanmakuDelivery PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM =
      PlaybackDanmakuDelivery._(
          2, _omitEnumNames ? '' : 'PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM');

  static const $core.List<PlaybackDanmakuDelivery> values =
      <PlaybackDanmakuDelivery>[
    PLAYBACK_DANMAKU_DELIVERY_UNSPECIFIED,
    PLAYBACK_DANMAKU_DELIVERY_DOCUMENT,
    PLAYBACK_DANMAKU_DELIVERY_EVENT_STREAM,
  ];

  static final $core.List<PlaybackDanmakuDelivery?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PlaybackDanmakuDelivery? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackDanmakuDelivery._(super.value, super.name);
}

class ResourceDeliveryMode extends $pb.ProtobufEnum {
  static const ResourceDeliveryMode RESOURCE_DELIVERY_MODE_UNSPECIFIED =
      ResourceDeliveryMode._(
          0, _omitEnumNames ? '' : 'RESOURCE_DELIVERY_MODE_UNSPECIFIED');
  static const ResourceDeliveryMode RESOURCE_DELIVERY_MODE_NOTIFY_ONLY =
      ResourceDeliveryMode._(
          1, _omitEnumNames ? '' : 'RESOURCE_DELIVERY_MODE_NOTIFY_ONLY');
  static const ResourceDeliveryMode RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT =
      ResourceDeliveryMode._(
          2, _omitEnumNames ? '' : 'RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT');

  static const $core.List<ResourceDeliveryMode> values = <ResourceDeliveryMode>[
    RESOURCE_DELIVERY_MODE_UNSPECIFIED,
    RESOURCE_DELIVERY_MODE_NOTIFY_ONLY,
    RESOURCE_DELIVERY_MODE_PUSH_SNAPSHOT,
  ];

  static final $core.List<ResourceDeliveryMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ResourceDeliveryMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceDeliveryMode._(super.value, super.name);
}

class RealtimeTerminationCode extends $pb.ProtobufEnum {
  static const RealtimeTerminationCode REALTIME_TERMINATION_CODE_UNSPECIFIED =
      RealtimeTerminationCode._(
          0, _omitEnumNames ? '' : 'REALTIME_TERMINATION_CODE_UNSPECIFIED');
  static const RealtimeTerminationCode
      REALTIME_TERMINATION_CODE_CONNECTION_REVOKED = RealtimeTerminationCode._(
          1,
          _omitEnumNames ? '' : 'REALTIME_TERMINATION_CODE_CONNECTION_REVOKED');
  static const RealtimeTerminationCode
      REALTIME_TERMINATION_CODE_USER_ACCESS_REVOKED = RealtimeTerminationCode._(
          2,
          _omitEnumNames
              ? ''
              : 'REALTIME_TERMINATION_CODE_USER_ACCESS_REVOKED');
  static const RealtimeTerminationCode
      REALTIME_TERMINATION_CODE_ROOM_ACCESS_REVOKED = RealtimeTerminationCode._(
          3,
          _omitEnumNames
              ? ''
              : 'REALTIME_TERMINATION_CODE_ROOM_ACCESS_REVOKED');
  static const RealtimeTerminationCode
      REALTIME_TERMINATION_CODE_ROOM_MEMBERSHIP_REVOKED =
      RealtimeTerminationCode._(
          4,
          _omitEnumNames
              ? ''
              : 'REALTIME_TERMINATION_CODE_ROOM_MEMBERSHIP_REVOKED');
  static const RealtimeTerminationCode
      REALTIME_TERMINATION_CODE_GUEST_ACCESS_REVOKED =
      RealtimeTerminationCode._(
          5,
          _omitEnumNames
              ? ''
              : 'REALTIME_TERMINATION_CODE_GUEST_ACCESS_REVOKED');
  static const RealtimeTerminationCode REALTIME_TERMINATION_CODE_ROOM_DELETED =
      RealtimeTerminationCode._(
          6, _omitEnumNames ? '' : 'REALTIME_TERMINATION_CODE_ROOM_DELETED');
  static const RealtimeTerminationCode REALTIME_TERMINATION_CODE_ROOM_BANNED =
      RealtimeTerminationCode._(
          7, _omitEnumNames ? '' : 'REALTIME_TERMINATION_CODE_ROOM_BANNED');
  static const RealtimeTerminationCode
      REALTIME_TERMINATION_CODE_ROOM_OWNER_INACTIVE = RealtimeTerminationCode._(
          8,
          _omitEnumNames
              ? ''
              : 'REALTIME_TERMINATION_CODE_ROOM_OWNER_INACTIVE');

  static const $core.List<RealtimeTerminationCode> values =
      <RealtimeTerminationCode>[
    REALTIME_TERMINATION_CODE_UNSPECIFIED,
    REALTIME_TERMINATION_CODE_CONNECTION_REVOKED,
    REALTIME_TERMINATION_CODE_USER_ACCESS_REVOKED,
    REALTIME_TERMINATION_CODE_ROOM_ACCESS_REVOKED,
    REALTIME_TERMINATION_CODE_ROOM_MEMBERSHIP_REVOKED,
    REALTIME_TERMINATION_CODE_GUEST_ACCESS_REVOKED,
    REALTIME_TERMINATION_CODE_ROOM_DELETED,
    REALTIME_TERMINATION_CODE_ROOM_BANNED,
    REALTIME_TERMINATION_CODE_ROOM_OWNER_INACTIVE,
  ];

  static final $core.List<RealtimeTerminationCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static RealtimeTerminationCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RealtimeTerminationCode._(super.value, super.name);
}

class ChatMessageStatus extends $pb.ProtobufEnum {
  static const ChatMessageStatus CHAT_MESSAGE_STATUS_UNSPECIFIED =
      ChatMessageStatus._(
          0, _omitEnumNames ? '' : 'CHAT_MESSAGE_STATUS_UNSPECIFIED');
  static const ChatMessageStatus CHAT_MESSAGE_STATUS_ACTIVE =
      ChatMessageStatus._(
          1, _omitEnumNames ? '' : 'CHAT_MESSAGE_STATUS_ACTIVE');
  static const ChatMessageStatus CHAT_MESSAGE_STATUS_EDITED =
      ChatMessageStatus._(
          2, _omitEnumNames ? '' : 'CHAT_MESSAGE_STATUS_EDITED');
  static const ChatMessageStatus CHAT_MESSAGE_STATUS_DELETED =
      ChatMessageStatus._(
          3, _omitEnumNames ? '' : 'CHAT_MESSAGE_STATUS_DELETED');

  static const $core.List<ChatMessageStatus> values = <ChatMessageStatus>[
    CHAT_MESSAGE_STATUS_UNSPECIFIED,
    CHAT_MESSAGE_STATUS_ACTIVE,
    CHAT_MESSAGE_STATUS_EDITED,
    CHAT_MESSAGE_STATUS_DELETED,
  ];

  static final $core.List<ChatMessageStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ChatMessageStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatMessageStatus._(super.value, super.name);
}

class ChatMessageType extends $pb.ProtobufEnum {
  static const ChatMessageType CHAT_MESSAGE_TYPE_UNSPECIFIED =
      ChatMessageType._(
          0, _omitEnumNames ? '' : 'CHAT_MESSAGE_TYPE_UNSPECIFIED');
  static const ChatMessageType CHAT_MESSAGE_TYPE_USER =
      ChatMessageType._(1, _omitEnumNames ? '' : 'CHAT_MESSAGE_TYPE_USER');
  static const ChatMessageType CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED =
      ChatMessageType._(
          1001, _omitEnumNames ? '' : 'CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED');
  static const ChatMessageType CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED =
      ChatMessageType._(1002,
          _omitEnumNames ? '' : 'CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED');

  static const $core.List<ChatMessageType> values = <ChatMessageType>[
    CHAT_MESSAGE_TYPE_UNSPECIFIED,
    CHAT_MESSAGE_TYPE_USER,
    CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED,
    CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED,
  ];

  static final $core.Map<$core.int, ChatMessageType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ChatMessageType? valueOf($core.int value) => _byValue[value];

  const ChatMessageType._(super.value, super.name);
}

class ChatMessageEventKind extends $pb.ProtobufEnum {
  static const ChatMessageEventKind CHAT_MESSAGE_EVENT_KIND_UNSPECIFIED =
      ChatMessageEventKind._(
          0, _omitEnumNames ? '' : 'CHAT_MESSAGE_EVENT_KIND_UNSPECIFIED');
  static const ChatMessageEventKind CHAT_MESSAGE_EVENT_KIND_CREATED =
      ChatMessageEventKind._(
          1, _omitEnumNames ? '' : 'CHAT_MESSAGE_EVENT_KIND_CREATED');
  static const ChatMessageEventKind CHAT_MESSAGE_EVENT_KIND_EDITED =
      ChatMessageEventKind._(
          2, _omitEnumNames ? '' : 'CHAT_MESSAGE_EVENT_KIND_EDITED');
  static const ChatMessageEventKind CHAT_MESSAGE_EVENT_KIND_DELETED =
      ChatMessageEventKind._(
          3, _omitEnumNames ? '' : 'CHAT_MESSAGE_EVENT_KIND_DELETED');
  static const ChatMessageEventKind CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED =
      ChatMessageEventKind._(
          4, _omitEnumNames ? '' : 'CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED');

  static const $core.List<ChatMessageEventKind> values = <ChatMessageEventKind>[
    CHAT_MESSAGE_EVENT_KIND_UNSPECIFIED,
    CHAT_MESSAGE_EVENT_KIND_CREATED,
    CHAT_MESSAGE_EVENT_KIND_EDITED,
    CHAT_MESSAGE_EVENT_KIND_DELETED,
    CHAT_MESSAGE_EVENT_KIND_REACTIONS_CHANGED,
  ];

  static final $core.List<ChatMessageEventKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ChatMessageEventKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatMessageEventKind._(super.value, super.name);
}

class ChatPinEventKind extends $pb.ProtobufEnum {
  static const ChatPinEventKind CHAT_PIN_EVENT_KIND_UNSPECIFIED =
      ChatPinEventKind._(
          0, _omitEnumNames ? '' : 'CHAT_PIN_EVENT_KIND_UNSPECIFIED');
  static const ChatPinEventKind CHAT_PIN_EVENT_KIND_PINNED =
      ChatPinEventKind._(1, _omitEnumNames ? '' : 'CHAT_PIN_EVENT_KIND_PINNED');
  static const ChatPinEventKind CHAT_PIN_EVENT_KIND_UNPINNED =
      ChatPinEventKind._(
          2, _omitEnumNames ? '' : 'CHAT_PIN_EVENT_KIND_UNPINNED');
  static const ChatPinEventKind CHAT_PIN_EVENT_KIND_MESSAGE_UPDATED =
      ChatPinEventKind._(
          3, _omitEnumNames ? '' : 'CHAT_PIN_EVENT_KIND_MESSAGE_UPDATED');
  static const ChatPinEventKind CHAT_PIN_EVENT_KIND_MESSAGE_DELETED =
      ChatPinEventKind._(
          4, _omitEnumNames ? '' : 'CHAT_PIN_EVENT_KIND_MESSAGE_DELETED');

  static const $core.List<ChatPinEventKind> values = <ChatPinEventKind>[
    CHAT_PIN_EVENT_KIND_UNSPECIFIED,
    CHAT_PIN_EVENT_KIND_PINNED,
    CHAT_PIN_EVENT_KIND_UNPINNED,
    CHAT_PIN_EVENT_KIND_MESSAGE_UPDATED,
    CHAT_PIN_EVENT_KIND_MESSAGE_DELETED,
  ];

  static final $core.List<ChatPinEventKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ChatPinEventKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatPinEventKind._(super.value, super.name);
}

class RoomMemberEventKind extends $pb.ProtobufEnum {
  static const RoomMemberEventKind ROOM_MEMBER_EVENT_KIND_UNSPECIFIED =
      RoomMemberEventKind._(
          0, _omitEnumNames ? '' : 'ROOM_MEMBER_EVENT_KIND_UNSPECIFIED');
  static const RoomMemberEventKind ROOM_MEMBER_EVENT_KIND_JOINED =
      RoomMemberEventKind._(
          1, _omitEnumNames ? '' : 'ROOM_MEMBER_EVENT_KIND_JOINED');
  static const RoomMemberEventKind ROOM_MEMBER_EVENT_KIND_LEFT =
      RoomMemberEventKind._(
          2, _omitEnumNames ? '' : 'ROOM_MEMBER_EVENT_KIND_LEFT');
  static const RoomMemberEventKind ROOM_MEMBER_EVENT_KIND_PERMISSION_CHANGED =
      RoomMemberEventKind._(
          3, _omitEnumNames ? '' : 'ROOM_MEMBER_EVENT_KIND_PERMISSION_CHANGED');
  static const RoomMemberEventKind ROOM_MEMBER_EVENT_KIND_KICKED =
      RoomMemberEventKind._(
          4, _omitEnumNames ? '' : 'ROOM_MEMBER_EVENT_KIND_KICKED');

  static const $core.List<RoomMemberEventKind> values = <RoomMemberEventKind>[
    ROOM_MEMBER_EVENT_KIND_UNSPECIFIED,
    ROOM_MEMBER_EVENT_KIND_JOINED,
    ROOM_MEMBER_EVENT_KIND_LEFT,
    ROOM_MEMBER_EVENT_KIND_PERMISSION_CHANGED,
    ROOM_MEMBER_EVENT_KIND_KICKED,
  ];

  static final $core.List<RoomMemberEventKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RoomMemberEventKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomMemberEventKind._(super.value, super.name);
}

class ChatAttachmentKind extends $pb.ProtobufEnum {
  static const ChatAttachmentKind CHAT_ATTACHMENT_KIND_UNSPECIFIED =
      ChatAttachmentKind._(
          0, _omitEnumNames ? '' : 'CHAT_ATTACHMENT_KIND_UNSPECIFIED');
  static const ChatAttachmentKind CHAT_ATTACHMENT_KIND_FILE =
      ChatAttachmentKind._(
          1, _omitEnumNames ? '' : 'CHAT_ATTACHMENT_KIND_FILE');
  static const ChatAttachmentKind CHAT_ATTACHMENT_KIND_IMAGE =
      ChatAttachmentKind._(
          2, _omitEnumNames ? '' : 'CHAT_ATTACHMENT_KIND_IMAGE');
  static const ChatAttachmentKind CHAT_ATTACHMENT_KIND_AUDIO =
      ChatAttachmentKind._(
          3, _omitEnumNames ? '' : 'CHAT_ATTACHMENT_KIND_AUDIO');

  static const $core.List<ChatAttachmentKind> values = <ChatAttachmentKind>[
    CHAT_ATTACHMENT_KIND_UNSPECIFIED,
    CHAT_ATTACHMENT_KIND_FILE,
    CHAT_ATTACHMENT_KIND_IMAGE,
    CHAT_ATTACHMENT_KIND_AUDIO,
  ];

  static final $core.List<ChatAttachmentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ChatAttachmentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatAttachmentKind._(super.value, super.name);
}

class ChatAttachmentReferenceKind extends $pb.ProtobufEnum {
  static const ChatAttachmentReferenceKind
      CHAT_ATTACHMENT_REFERENCE_KIND_UNSPECIFIED =
      ChatAttachmentReferenceKind._(0,
          _omitEnumNames ? '' : 'CHAT_ATTACHMENT_REFERENCE_KIND_UNSPECIFIED');
  static const ChatAttachmentReferenceKind
      CHAT_ATTACHMENT_REFERENCE_KIND_UPLOAD = ChatAttachmentReferenceKind._(
          1, _omitEnumNames ? '' : 'CHAT_ATTACHMENT_REFERENCE_KIND_UPLOAD');
  static const ChatAttachmentReferenceKind
      CHAT_ATTACHMENT_REFERENCE_KIND_REUSE = ChatAttachmentReferenceKind._(
          2, _omitEnumNames ? '' : 'CHAT_ATTACHMENT_REFERENCE_KIND_REUSE');

  static const $core.List<ChatAttachmentReferenceKind> values =
      <ChatAttachmentReferenceKind>[
    CHAT_ATTACHMENT_REFERENCE_KIND_UNSPECIFIED,
    CHAT_ATTACHMENT_REFERENCE_KIND_UPLOAD,
    CHAT_ATTACHMENT_REFERENCE_KIND_REUSE,
  ];

  static final $core.List<ChatAttachmentReferenceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ChatAttachmentReferenceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatAttachmentReferenceKind._(super.value, super.name);
}

class FileObjectAccessKind extends $pb.ProtobufEnum {
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_UNSPECIFIED =
      FileObjectAccessKind._(
          0, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_UNSPECIFIED');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_CHAT_ATTACHMENT =
      FileObjectAccessKind._(
          1, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_CHAT_ATTACHMENT');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_USER_AVATAR =
      FileObjectAccessKind._(
          2, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_USER_AVATAR');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_MEDIA_COVER =
      FileObjectAccessKind._(
          3, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_MEDIA_COVER');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_ROOM_COVER =
      FileObjectAccessKind._(
          4, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_ROOM_COVER');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_PLAYLIST_COVER =
      FileObjectAccessKind._(
          5, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_PLAYLIST_COVER');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_GENERIC =
      FileObjectAccessKind._(
          6, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_GENERIC');
  static const FileObjectAccessKind FILE_OBJECT_ACCESS_KIND_MEDIA_THUMBNAIL =
      FileObjectAccessKind._(
          7, _omitEnumNames ? '' : 'FILE_OBJECT_ACCESS_KIND_MEDIA_THUMBNAIL');

  static const $core.List<FileObjectAccessKind> values = <FileObjectAccessKind>[
    FILE_OBJECT_ACCESS_KIND_UNSPECIFIED,
    FILE_OBJECT_ACCESS_KIND_CHAT_ATTACHMENT,
    FILE_OBJECT_ACCESS_KIND_USER_AVATAR,
    FILE_OBJECT_ACCESS_KIND_MEDIA_COVER,
    FILE_OBJECT_ACCESS_KIND_ROOM_COVER,
    FILE_OBJECT_ACCESS_KIND_PLAYLIST_COVER,
    FILE_OBJECT_ACCESS_KIND_GENERIC,
    FILE_OBJECT_ACCESS_KIND_MEDIA_THUMBNAIL,
  ];

  static final $core.List<FileObjectAccessKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static FileObjectAccessKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FileObjectAccessKind._(super.value, super.name);
}

class OnlineEventKind extends $pb.ProtobufEnum {
  static const OnlineEventKind ONLINE_EVENT_KIND_UNSPECIFIED =
      OnlineEventKind._(
          0, _omitEnumNames ? '' : 'ONLINE_EVENT_KIND_UNSPECIFIED');
  static const OnlineEventKind ONLINE_EVENT_KIND_JOINED =
      OnlineEventKind._(1, _omitEnumNames ? '' : 'ONLINE_EVENT_KIND_JOINED');
  static const OnlineEventKind ONLINE_EVENT_KIND_LEFT =
      OnlineEventKind._(2, _omitEnumNames ? '' : 'ONLINE_EVENT_KIND_LEFT');

  static const $core.List<OnlineEventKind> values = <OnlineEventKind>[
    ONLINE_EVENT_KIND_UNSPECIFIED,
    ONLINE_EVENT_KIND_JOINED,
    ONLINE_EVENT_KIND_LEFT,
  ];

  static final $core.List<OnlineEventKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static OnlineEventKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OnlineEventKind._(super.value, super.name);
}

class ContentReportTargetType extends $pb.ProtobufEnum {
  static const ContentReportTargetType CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED =
      ContentReportTargetType._(
          0, _omitEnumNames ? '' : 'CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED');
  static const ContentReportTargetType CONTENT_REPORT_TARGET_TYPE_ROOM =
      ContentReportTargetType._(
          1, _omitEnumNames ? '' : 'CONTENT_REPORT_TARGET_TYPE_ROOM');
  static const ContentReportTargetType CONTENT_REPORT_TARGET_TYPE_USER =
      ContentReportTargetType._(
          2, _omitEnumNames ? '' : 'CONTENT_REPORT_TARGET_TYPE_USER');
  static const ContentReportTargetType CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER =
      ContentReportTargetType._(
          3, _omitEnumNames ? '' : 'CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER');
  static const ContentReportTargetType CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE =
      ContentReportTargetType._(
          4, _omitEnumNames ? '' : 'CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE');

  static const $core.List<ContentReportTargetType> values =
      <ContentReportTargetType>[
    CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
    CONTENT_REPORT_TARGET_TYPE_ROOM,
    CONTENT_REPORT_TARGET_TYPE_USER,
    CONTENT_REPORT_TARGET_TYPE_ROOM_MEMBER,
    CONTENT_REPORT_TARGET_TYPE_CHAT_MESSAGE,
  ];

  static final $core.List<ContentReportTargetType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ContentReportTargetType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContentReportTargetType._(super.value, super.name);
}

class ContentReportStatus extends $pb.ProtobufEnum {
  static const ContentReportStatus CONTENT_REPORT_STATUS_UNSPECIFIED =
      ContentReportStatus._(
          0, _omitEnumNames ? '' : 'CONTENT_REPORT_STATUS_UNSPECIFIED');
  static const ContentReportStatus CONTENT_REPORT_STATUS_OPEN =
      ContentReportStatus._(
          1, _omitEnumNames ? '' : 'CONTENT_REPORT_STATUS_OPEN');
  static const ContentReportStatus CONTENT_REPORT_STATUS_REVIEWING =
      ContentReportStatus._(
          2, _omitEnumNames ? '' : 'CONTENT_REPORT_STATUS_REVIEWING');
  static const ContentReportStatus CONTENT_REPORT_STATUS_RESOLVED =
      ContentReportStatus._(
          3, _omitEnumNames ? '' : 'CONTENT_REPORT_STATUS_RESOLVED');
  static const ContentReportStatus CONTENT_REPORT_STATUS_DISMISSED =
      ContentReportStatus._(
          4, _omitEnumNames ? '' : 'CONTENT_REPORT_STATUS_DISMISSED');

  static const $core.List<ContentReportStatus> values = <ContentReportStatus>[
    CONTENT_REPORT_STATUS_UNSPECIFIED,
    CONTENT_REPORT_STATUS_OPEN,
    CONTENT_REPORT_STATUS_REVIEWING,
    CONTENT_REPORT_STATUS_RESOLVED,
    CONTENT_REPORT_STATUS_DISMISSED,
  ];

  static final $core.List<ContentReportStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ContentReportStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContentReportStatus._(super.value, super.name);
}

class NotificationType extends $pb.ProtobufEnum {
  static const NotificationType NOTIFICATION_TYPE_UNSPECIFIED =
      NotificationType._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_UNSPECIFIED');
  static const NotificationType NOTIFICATION_TYPE_ROOM_INVITATION =
      NotificationType._(
          1, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_ROOM_INVITATION');
  static const NotificationType NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT =
      NotificationType._(
          2, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT');
  static const NotificationType NOTIFICATION_TYPE_ROOM_EVENT =
      NotificationType._(
          3, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_ROOM_EVENT');
  static const NotificationType NOTIFICATION_TYPE_PASSWORD_RESET =
      NotificationType._(
          4, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_PASSWORD_RESET');
  static const NotificationType NOTIFICATION_TYPE_EMAIL_BIND =
      NotificationType._(
          5, _omitEnumNames ? '' : 'NOTIFICATION_TYPE_EMAIL_BIND');

  static const $core.List<NotificationType> values = <NotificationType>[
    NOTIFICATION_TYPE_UNSPECIFIED,
    NOTIFICATION_TYPE_ROOM_INVITATION,
    NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT,
    NOTIFICATION_TYPE_ROOM_EVENT,
    NOTIFICATION_TYPE_PASSWORD_RESET,
    NOTIFICATION_TYPE_EMAIL_BIND,
  ];

  static final $core.List<NotificationType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static NotificationType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotificationType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
