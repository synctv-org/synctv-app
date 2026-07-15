// This is a generated file - do not edit.
//
// Generated from proto/providers/cctv.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class StreamKind extends $pb.ProtobufEnum {
  static const StreamKind STREAM_KIND_UNSPECIFIED =
      StreamKind._(0, _omitEnumNames ? '' : 'STREAM_KIND_UNSPECIFIED');
  static const StreamKind STREAM_KIND_VIDEO_HLS =
      StreamKind._(1, _omitEnumNames ? '' : 'STREAM_KIND_VIDEO_HLS');
  static const StreamKind STREAM_KIND_AUDIO_HLS =
      StreamKind._(2, _omitEnumNames ? '' : 'STREAM_KIND_AUDIO_HLS');
  static const StreamKind STREAM_KIND_HTTP =
      StreamKind._(3, _omitEnumNames ? '' : 'STREAM_KIND_HTTP');

  static const $core.List<StreamKind> values = <StreamKind>[
    STREAM_KIND_UNSPECIFIED,
    STREAM_KIND_VIDEO_HLS,
    STREAM_KIND_AUDIO_HLS,
    STREAM_KIND_HTTP,
  ];

  static final $core.List<StreamKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static StreamKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StreamKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
