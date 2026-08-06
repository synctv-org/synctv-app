// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/douyin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DouyinHlsResourceKind extends $pb.ProtobufEnum {
  static const DouyinHlsResourceKind DOUYIN_HLS_RESOURCE_KIND_UNSPECIFIED =
      DouyinHlsResourceKind._(
          0, _omitEnumNames ? '' : 'DOUYIN_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const DouyinHlsResourceKind DOUYIN_HLS_RESOURCE_KIND_MEDIA =
      DouyinHlsResourceKind._(
          1, _omitEnumNames ? '' : 'DOUYIN_HLS_RESOURCE_KIND_MEDIA');
  static const DouyinHlsResourceKind DOUYIN_HLS_RESOURCE_KIND_MANIFEST =
      DouyinHlsResourceKind._(
          2, _omitEnumNames ? '' : 'DOUYIN_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<DouyinHlsResourceKind> values =
      <DouyinHlsResourceKind>[
    DOUYIN_HLS_RESOURCE_KIND_UNSPECIFIED,
    DOUYIN_HLS_RESOURCE_KIND_MEDIA,
    DOUYIN_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<DouyinHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static DouyinHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DouyinHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
