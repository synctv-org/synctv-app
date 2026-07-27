// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/bilibili.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class BilibiliDashManifestMode extends $pb.ProtobufEnum {
  static const BilibiliDashManifestMode
      BILIBILI_DASH_MANIFEST_MODE_UNSPECIFIED = BilibiliDashManifestMode._(
          0, _omitEnumNames ? '' : 'BILIBILI_DASH_MANIFEST_MODE_UNSPECIFIED');
  static const BilibiliDashManifestMode BILIBILI_DASH_MANIFEST_MODE_DIRECT =
      BilibiliDashManifestMode._(
          1, _omitEnumNames ? '' : 'BILIBILI_DASH_MANIFEST_MODE_DIRECT');
  static const BilibiliDashManifestMode BILIBILI_DASH_MANIFEST_MODE_PROXY =
      BilibiliDashManifestMode._(
          2, _omitEnumNames ? '' : 'BILIBILI_DASH_MANIFEST_MODE_PROXY');

  static const $core.List<BilibiliDashManifestMode> values =
      <BilibiliDashManifestMode>[
    BILIBILI_DASH_MANIFEST_MODE_UNSPECIFIED,
    BILIBILI_DASH_MANIFEST_MODE_DIRECT,
    BILIBILI_DASH_MANIFEST_MODE_PROXY,
  ];

  static final $core.List<BilibiliDashManifestMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static BilibiliDashManifestMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliDashManifestMode._(super.value, super.name);
}

class BilibiliHlsResourceKind extends $pb.ProtobufEnum {
  static const BilibiliHlsResourceKind BILIBILI_HLS_RESOURCE_KIND_UNSPECIFIED =
      BilibiliHlsResourceKind._(
          0, _omitEnumNames ? '' : 'BILIBILI_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const BilibiliHlsResourceKind BILIBILI_HLS_RESOURCE_KIND_MEDIA =
      BilibiliHlsResourceKind._(
          1, _omitEnumNames ? '' : 'BILIBILI_HLS_RESOURCE_KIND_MEDIA');
  static const BilibiliHlsResourceKind BILIBILI_HLS_RESOURCE_KIND_MANIFEST =
      BilibiliHlsResourceKind._(
          2, _omitEnumNames ? '' : 'BILIBILI_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<BilibiliHlsResourceKind> values =
      <BilibiliHlsResourceKind>[
    BILIBILI_HLS_RESOURCE_KIND_UNSPECIFIED,
    BILIBILI_HLS_RESOURCE_KIND_MEDIA,
    BILIBILI_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<BilibiliHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static BilibiliHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliHlsResourceKind._(super.value, super.name);
}

class BilibiliDashResourceKind extends $pb.ProtobufEnum {
  static const BilibiliDashResourceKind
      BILIBILI_DASH_RESOURCE_KIND_UNSPECIFIED = BilibiliDashResourceKind._(
          0, _omitEnumNames ? '' : 'BILIBILI_DASH_RESOURCE_KIND_UNSPECIFIED');
  static const BilibiliDashResourceKind BILIBILI_DASH_RESOURCE_KIND_MEDIA =
      BilibiliDashResourceKind._(
          1, _omitEnumNames ? '' : 'BILIBILI_DASH_RESOURCE_KIND_MEDIA');
  static const BilibiliDashResourceKind BILIBILI_DASH_RESOURCE_KIND_MANIFEST =
      BilibiliDashResourceKind._(
          2, _omitEnumNames ? '' : 'BILIBILI_DASH_RESOURCE_KIND_MANIFEST');

  static const $core.List<BilibiliDashResourceKind> values =
      <BilibiliDashResourceKind>[
    BILIBILI_DASH_RESOURCE_KIND_UNSPECIFIED,
    BILIBILI_DASH_RESOURCE_KIND_MEDIA,
    BILIBILI_DASH_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<BilibiliDashResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static BilibiliDashResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliDashResourceKind._(super.value, super.name);
}

class BilibiliLiveDanmakuEventType extends $pb.ProtobufEnum {
  static const BilibiliLiveDanmakuEventType
      BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNSPECIFIED =
      BilibiliLiveDanmakuEventType._(0,
          _omitEnumNames ? '' : 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNSPECIFIED');
  static const BilibiliLiveDanmakuEventType
      BILIBILI_LIVE_DANMAKU_EVENT_TYPE_CHAT = BilibiliLiveDanmakuEventType._(
          1, _omitEnumNames ? '' : 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_CHAT');
  static const BilibiliLiveDanmakuEventType
      BILIBILI_LIVE_DANMAKU_EVENT_TYPE_USER_ENTER =
      BilibiliLiveDanmakuEventType._(2,
          _omitEnumNames ? '' : 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_USER_ENTER');
  static const BilibiliLiveDanmakuEventType
      BILIBILI_LIVE_DANMAKU_EVENT_TYPE_GIFT = BilibiliLiveDanmakuEventType._(
          3, _omitEnumNames ? '' : 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_GIFT');
  static const BilibiliLiveDanmakuEventType
      BILIBILI_LIVE_DANMAKU_EVENT_TYPE_HEARTBEAT =
      BilibiliLiveDanmakuEventType._(4,
          _omitEnumNames ? '' : 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_HEARTBEAT');
  static const BilibiliLiveDanmakuEventType
      BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNKNOWN = BilibiliLiveDanmakuEventType._(
          5, _omitEnumNames ? '' : 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNKNOWN');

  static const $core.List<BilibiliLiveDanmakuEventType> values =
      <BilibiliLiveDanmakuEventType>[
    BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNSPECIFIED,
    BILIBILI_LIVE_DANMAKU_EVENT_TYPE_CHAT,
    BILIBILI_LIVE_DANMAKU_EVENT_TYPE_USER_ENTER,
    BILIBILI_LIVE_DANMAKU_EVENT_TYPE_GIFT,
    BILIBILI_LIVE_DANMAKU_EVENT_TYPE_HEARTBEAT,
    BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNKNOWN,
  ];

  static final $core.List<BilibiliLiveDanmakuEventType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static BilibiliLiveDanmakuEventType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BilibiliLiveDanmakuEventType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
