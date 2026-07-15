// This is a generated file - do not edit.
//
// Generated from proto/providers/douyu.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class StreamFormat extends $pb.ProtobufEnum {
  static const StreamFormat STREAM_FORMAT_UNSPECIFIED =
      StreamFormat._(0, _omitEnumNames ? '' : 'STREAM_FORMAT_UNSPECIFIED');
  static const StreamFormat STREAM_FORMAT_FLV =
      StreamFormat._(1, _omitEnumNames ? '' : 'STREAM_FORMAT_FLV');
  static const StreamFormat STREAM_FORMAT_HLS =
      StreamFormat._(2, _omitEnumNames ? '' : 'STREAM_FORMAT_HLS');

  static const $core.List<StreamFormat> values = <StreamFormat>[
    STREAM_FORMAT_UNSPECIFIED,
    STREAM_FORMAT_FLV,
    STREAM_FORMAT_HLS,
  ];

  static final $core.List<StreamFormat?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static StreamFormat? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StreamFormat._(super.value, super.name);
}

class Codec extends $pb.ProtobufEnum {
  static const Codec CODEC_UNSPECIFIED =
      Codec._(0, _omitEnumNames ? '' : 'CODEC_UNSPECIFIED');
  static const Codec CODEC_AVC = Codec._(1, _omitEnumNames ? '' : 'CODEC_AVC');
  static const Codec CODEC_HEVC =
      Codec._(2, _omitEnumNames ? '' : 'CODEC_HEVC');
  static const Codec CODEC_AAC = Codec._(3, _omitEnumNames ? '' : 'CODEC_AAC');

  static const $core.List<Codec> values = <Codec>[
    CODEC_UNSPECIFIED,
    CODEC_AVC,
    CODEC_HEVC,
    CODEC_AAC,
  ];

  static final $core.List<Codec?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Codec? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Codec._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
