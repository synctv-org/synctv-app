// This is a generated file - do not edit.
//
// Generated from proto/providers/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PlaybackProxyAutoReason extends $pb.ProtobufEnum {
  static const PlaybackProxyAutoReason PLAYBACK_PROXY_AUTO_REASON_UNSPECIFIED =
      PlaybackProxyAutoReason._(
          0, _omitEnumNames ? '' : 'PLAYBACK_PROXY_AUTO_REASON_UNSPECIFIED');
  static const PlaybackProxyAutoReason
      PLAYBACK_PROXY_AUTO_REASON_PUBLIC_RESOURCE = PlaybackProxyAutoReason._(1,
          _omitEnumNames ? '' : 'PLAYBACK_PROXY_AUTO_REASON_PUBLIC_RESOURCE');
  static const PlaybackProxyAutoReason
      PLAYBACK_PROXY_AUTO_REASON_REQUEST_CREDENTIALS =
      PlaybackProxyAutoReason._(
          2,
          _omitEnumNames
              ? ''
              : 'PLAYBACK_PROXY_AUTO_REASON_REQUEST_CREDENTIALS');
  static const PlaybackProxyAutoReason
      PLAYBACK_PROXY_AUTO_REASON_SIGNED_RESOURCE = PlaybackProxyAutoReason._(3,
          _omitEnumNames ? '' : 'PLAYBACK_PROXY_AUTO_REASON_SIGNED_RESOURCE');
  static const PlaybackProxyAutoReason
      PLAYBACK_PROXY_AUTO_REASON_PROVIDER_SESSION = PlaybackProxyAutoReason._(4,
          _omitEnumNames ? '' : 'PLAYBACK_PROXY_AUTO_REASON_PROVIDER_SESSION');
  static const PlaybackProxyAutoReason
      PLAYBACK_PROXY_AUTO_REASON_SERVER_TRANSPORT = PlaybackProxyAutoReason._(5,
          _omitEnumNames ? '' : 'PLAYBACK_PROXY_AUTO_REASON_SERVER_TRANSPORT');

  static const $core.List<PlaybackProxyAutoReason> values =
      <PlaybackProxyAutoReason>[
    PLAYBACK_PROXY_AUTO_REASON_UNSPECIFIED,
    PLAYBACK_PROXY_AUTO_REASON_PUBLIC_RESOURCE,
    PLAYBACK_PROXY_AUTO_REASON_REQUEST_CREDENTIALS,
    PLAYBACK_PROXY_AUTO_REASON_SIGNED_RESOURCE,
    PLAYBACK_PROXY_AUTO_REASON_PROVIDER_SESSION,
    PLAYBACK_PROXY_AUTO_REASON_SERVER_TRANSPORT,
  ];

  static final $core.List<PlaybackProxyAutoReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PlaybackProxyAutoReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaybackProxyAutoReason._(super.value, super.name);
}

class ProviderInstanceStatus extends $pb.ProtobufEnum {
  static const ProviderInstanceStatus PROVIDER_INSTANCE_STATUS_UNSPECIFIED =
      ProviderInstanceStatus._(
          0, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_STATUS_UNSPECIFIED');
  static const ProviderInstanceStatus PROVIDER_INSTANCE_STATUS_CONNECTED =
      ProviderInstanceStatus._(
          1, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_STATUS_CONNECTED');
  static const ProviderInstanceStatus PROVIDER_INSTANCE_STATUS_DISCONNECTED =
      ProviderInstanceStatus._(
          2, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_STATUS_DISCONNECTED');
  static const ProviderInstanceStatus PROVIDER_INSTANCE_STATUS_ERROR =
      ProviderInstanceStatus._(
          3, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_STATUS_ERROR');

  static const $core.List<ProviderInstanceStatus> values =
      <ProviderInstanceStatus>[
    PROVIDER_INSTANCE_STATUS_UNSPECIFIED,
    PROVIDER_INSTANCE_STATUS_CONNECTED,
    PROVIDER_INSTANCE_STATUS_DISCONNECTED,
    PROVIDER_INSTANCE_STATUS_ERROR,
  ];

  static final $core.List<ProviderInstanceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ProviderInstanceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProviderInstanceStatus._(super.value, super.name);
}

class ProviderInstanceListSortBy extends $pb.ProtobufEnum {
  static const ProviderInstanceListSortBy
      PROVIDER_INSTANCE_LIST_SORT_BY_UNSPECIFIED = ProviderInstanceListSortBy._(
          0,
          _omitEnumNames ? '' : 'PROVIDER_INSTANCE_LIST_SORT_BY_UNSPECIFIED');
  static const ProviderInstanceListSortBy PROVIDER_INSTANCE_LIST_SORT_BY_NAME =
      ProviderInstanceListSortBy._(
          1, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_LIST_SORT_BY_NAME');
  static const ProviderInstanceListSortBy
      PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT = ProviderInstanceListSortBy._(
          2, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT');
  static const ProviderInstanceListSortBy
      PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT = ProviderInstanceListSortBy._(
          3, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT');
  static const ProviderInstanceListSortBy
      PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT = ProviderInstanceListSortBy._(
          4, _omitEnumNames ? '' : 'PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT');

  static const $core.List<ProviderInstanceListSortBy> values =
      <ProviderInstanceListSortBy>[
    PROVIDER_INSTANCE_LIST_SORT_BY_UNSPECIFIED,
    PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
    PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT,
    PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
    PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT,
  ];

  static final $core.List<ProviderInstanceListSortBy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ProviderInstanceListSortBy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ProviderInstanceListSortBy._(super.value, super.name);
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

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
