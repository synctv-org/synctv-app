// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/acfun.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AcFunHlsResourceKind extends $pb.ProtobufEnum {
  static const AcFunHlsResourceKind AC_FUN_HLS_RESOURCE_KIND_UNSPECIFIED =
      AcFunHlsResourceKind._(
          0, _omitEnumNames ? '' : 'AC_FUN_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const AcFunHlsResourceKind AC_FUN_HLS_RESOURCE_KIND_MEDIA =
      AcFunHlsResourceKind._(
          1, _omitEnumNames ? '' : 'AC_FUN_HLS_RESOURCE_KIND_MEDIA');
  static const AcFunHlsResourceKind AC_FUN_HLS_RESOURCE_KIND_MANIFEST =
      AcFunHlsResourceKind._(
          2, _omitEnumNames ? '' : 'AC_FUN_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<AcFunHlsResourceKind> values = <AcFunHlsResourceKind>[
    AC_FUN_HLS_RESOURCE_KIND_UNSPECIFIED,
    AC_FUN_HLS_RESOURCE_KIND_MEDIA,
    AC_FUN_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<AcFunHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AcFunHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AcFunHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
