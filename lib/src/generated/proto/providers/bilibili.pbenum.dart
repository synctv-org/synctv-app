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

class PgcFollowType extends $pb.ProtobufEnum {
  static const PgcFollowType PGC_FOLLOW_TYPE_UNSPECIFIED =
      PgcFollowType._(0, _omitEnumNames ? '' : 'PGC_FOLLOW_TYPE_UNSPECIFIED');
  static const PgcFollowType PGC_FOLLOW_TYPE_ANIME =
      PgcFollowType._(1, _omitEnumNames ? '' : 'PGC_FOLLOW_TYPE_ANIME');
  static const PgcFollowType PGC_FOLLOW_TYPE_CINEMA =
      PgcFollowType._(2, _omitEnumNames ? '' : 'PGC_FOLLOW_TYPE_CINEMA');

  static const $core.List<PgcFollowType> values = <PgcFollowType>[
    PGC_FOLLOW_TYPE_UNSPECIFIED,
    PGC_FOLLOW_TYPE_ANIME,
    PGC_FOLLOW_TYPE_CINEMA,
  ];

  static final $core.List<PgcFollowType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PgcFollowType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PgcFollowType._(super.value, super.name);
}

class PgcSeasonType extends $pb.ProtobufEnum {
  static const PgcSeasonType PGC_SEASON_TYPE_UNSPECIFIED =
      PgcSeasonType._(0, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_UNSPECIFIED');
  static const PgcSeasonType PGC_SEASON_TYPE_ANIME =
      PgcSeasonType._(1, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_ANIME');
  static const PgcSeasonType PGC_SEASON_TYPE_MOVIE =
      PgcSeasonType._(2, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_MOVIE');
  static const PgcSeasonType PGC_SEASON_TYPE_DOCUMENTARY =
      PgcSeasonType._(3, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_DOCUMENTARY');
  static const PgcSeasonType PGC_SEASON_TYPE_GUOCHUANG =
      PgcSeasonType._(4, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_GUOCHUANG');
  static const PgcSeasonType PGC_SEASON_TYPE_TV =
      PgcSeasonType._(5, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_TV');
  static const PgcSeasonType PGC_SEASON_TYPE_VARIETY =
      PgcSeasonType._(7, _omitEnumNames ? '' : 'PGC_SEASON_TYPE_VARIETY');

  static const $core.List<PgcSeasonType> values = <PgcSeasonType>[
    PGC_SEASON_TYPE_UNSPECIFIED,
    PGC_SEASON_TYPE_ANIME,
    PGC_SEASON_TYPE_MOVIE,
    PGC_SEASON_TYPE_DOCUMENTARY,
    PGC_SEASON_TYPE_GUOCHUANG,
    PGC_SEASON_TYPE_TV,
    PGC_SEASON_TYPE_VARIETY,
  ];

  static final $core.List<PgcSeasonType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static PgcSeasonType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PgcSeasonType._(super.value, super.name);
}

class PgcSeasonOrder extends $pb.ProtobufEnum {
  static const PgcSeasonOrder PGC_SEASON_ORDER_UPDATED =
      PgcSeasonOrder._(0, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_UPDATED');
  static const PgcSeasonOrder PGC_SEASON_ORDER_DANMAKU =
      PgcSeasonOrder._(1, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_DANMAKU');
  static const PgcSeasonOrder PGC_SEASON_ORDER_PLAY =
      PgcSeasonOrder._(2, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_PLAY');
  static const PgcSeasonOrder PGC_SEASON_ORDER_FOLLOW =
      PgcSeasonOrder._(3, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_FOLLOW');
  static const PgcSeasonOrder PGC_SEASON_ORDER_SCORE =
      PgcSeasonOrder._(4, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_SCORE');
  static const PgcSeasonOrder PGC_SEASON_ORDER_STARTED =
      PgcSeasonOrder._(5, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_STARTED');
  static const PgcSeasonOrder PGC_SEASON_ORDER_RELEASED =
      PgcSeasonOrder._(6, _omitEnumNames ? '' : 'PGC_SEASON_ORDER_RELEASED');

  static const $core.List<PgcSeasonOrder> values = <PgcSeasonOrder>[
    PGC_SEASON_ORDER_UPDATED,
    PGC_SEASON_ORDER_DANMAKU,
    PGC_SEASON_ORDER_PLAY,
    PGC_SEASON_ORDER_FOLLOW,
    PGC_SEASON_ORDER_SCORE,
    PGC_SEASON_ORDER_STARTED,
    PGC_SEASON_ORDER_RELEASED,
  ];

  static final $core.List<PgcSeasonOrder?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PgcSeasonOrder? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PgcSeasonOrder._(super.value, super.name);
}

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
