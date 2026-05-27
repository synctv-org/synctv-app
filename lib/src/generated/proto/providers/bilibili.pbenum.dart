// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// QR login status enum
/// Wire values mirror synctv-media-providers QRCodeStatus.
class QRLoginStatus extends $pb.ProtobufEnum {
  static const QRLoginStatus QR_LOGIN_STATUS_UNSPECIFIED =
      QRLoginStatus._(0, _omitEnumNames ? '' : 'QR_LOGIN_STATUS_UNSPECIFIED');
  static const QRLoginStatus QR_LOGIN_STATUS_EXPIRED =
      QRLoginStatus._(1, _omitEnumNames ? '' : 'QR_LOGIN_STATUS_EXPIRED');
  static const QRLoginStatus QR_LOGIN_STATUS_NOT_SCANNED =
      QRLoginStatus._(2, _omitEnumNames ? '' : 'QR_LOGIN_STATUS_NOT_SCANNED');
  static const QRLoginStatus QR_LOGIN_STATUS_SCANNED =
      QRLoginStatus._(3, _omitEnumNames ? '' : 'QR_LOGIN_STATUS_SCANNED');
  static const QRLoginStatus QR_LOGIN_STATUS_SUCCESS =
      QRLoginStatus._(4, _omitEnumNames ? '' : 'QR_LOGIN_STATUS_SUCCESS');

  static const $core.List<QRLoginStatus> values = <QRLoginStatus>[
    QR_LOGIN_STATUS_UNSPECIFIED,
    QR_LOGIN_STATUS_EXPIRED,
    QR_LOGIN_STATUS_NOT_SCANNED,
    QR_LOGIN_STATUS_SCANNED,
    QR_LOGIN_STATUS_SUCCESS,
  ];

  static final $core.List<QRLoginStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static QRLoginStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const QRLoginStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
