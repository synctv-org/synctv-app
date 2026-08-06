// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/truenas.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TrueNasHlsResourceKind extends $pb.ProtobufEnum {
  static const TrueNasHlsResourceKind TRUE_NAS_HLS_RESOURCE_KIND_UNSPECIFIED =
      TrueNasHlsResourceKind._(
          0, _omitEnumNames ? '' : 'TRUE_NAS_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const TrueNasHlsResourceKind TRUE_NAS_HLS_RESOURCE_KIND_MEDIA =
      TrueNasHlsResourceKind._(
          1, _omitEnumNames ? '' : 'TRUE_NAS_HLS_RESOURCE_KIND_MEDIA');
  static const TrueNasHlsResourceKind TRUE_NAS_HLS_RESOURCE_KIND_MANIFEST =
      TrueNasHlsResourceKind._(
          2, _omitEnumNames ? '' : 'TRUE_NAS_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<TrueNasHlsResourceKind> values =
      <TrueNasHlsResourceKind>[
    TRUE_NAS_HLS_RESOURCE_KIND_UNSPECIFIED,
    TRUE_NAS_HLS_RESOURCE_KIND_MEDIA,
    TRUE_NAS_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<TrueNasHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TrueNasHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TrueNasHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
