// This is a generated file - do not edit.
//
// Generated from proto/providers/douyin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MediaKind extends $pb.ProtobufEnum {
  static const MediaKind MEDIA_KIND_UNSPECIFIED =
      MediaKind._(0, _omitEnumNames ? '' : 'MEDIA_KIND_UNSPECIFIED');
  static const MediaKind MEDIA_KIND_VIDEO =
      MediaKind._(1, _omitEnumNames ? '' : 'MEDIA_KIND_VIDEO');
  static const MediaKind MEDIA_KIND_LIVE =
      MediaKind._(2, _omitEnumNames ? '' : 'MEDIA_KIND_LIVE');

  static const $core.List<MediaKind> values = <MediaKind>[
    MEDIA_KIND_UNSPECIFIED,
    MEDIA_KIND_VIDEO,
    MEDIA_KIND_LIVE,
  ];

  static final $core.List<MediaKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static MediaKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MediaKind._(super.value, super.name);
}

class StreamFormat extends $pb.ProtobufEnum {
  static const StreamFormat STREAM_FORMAT_UNSPECIFIED =
      StreamFormat._(0, _omitEnumNames ? '' : 'STREAM_FORMAT_UNSPECIFIED');
  static const StreamFormat STREAM_FORMAT_MP4 =
      StreamFormat._(1, _omitEnumNames ? '' : 'STREAM_FORMAT_MP4');
  static const StreamFormat STREAM_FORMAT_FLV =
      StreamFormat._(2, _omitEnumNames ? '' : 'STREAM_FORMAT_FLV');
  static const StreamFormat STREAM_FORMAT_HLS =
      StreamFormat._(3, _omitEnumNames ? '' : 'STREAM_FORMAT_HLS');
  static const StreamFormat STREAM_FORMAT_DASH =
      StreamFormat._(4, _omitEnumNames ? '' : 'STREAM_FORMAT_DASH');
  static const StreamFormat STREAM_FORMAT_CMAF =
      StreamFormat._(5, _omitEnumNames ? '' : 'STREAM_FORMAT_CMAF');
  static const StreamFormat STREAM_FORMAT_LL_HLS =
      StreamFormat._(6, _omitEnumNames ? '' : 'STREAM_FORMAT_LL_HLS');
  static const StreamFormat STREAM_FORMAT_HTTP_TS =
      StreamFormat._(7, _omitEnumNames ? '' : 'STREAM_FORMAT_HTTP_TS');

  static const $core.List<StreamFormat> values = <StreamFormat>[
    STREAM_FORMAT_UNSPECIFIED,
    STREAM_FORMAT_MP4,
    STREAM_FORMAT_FLV,
    STREAM_FORMAT_HLS,
    STREAM_FORMAT_DASH,
    STREAM_FORMAT_CMAF,
    STREAM_FORMAT_LL_HLS,
    STREAM_FORMAT_HTTP_TS,
  ];

  static final $core.List<StreamFormat?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static StreamFormat? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StreamFormat._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
