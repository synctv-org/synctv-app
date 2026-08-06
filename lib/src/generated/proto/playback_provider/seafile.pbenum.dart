// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/seafile.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SeafileHlsResourceKind extends $pb.ProtobufEnum {
  static const SeafileHlsResourceKind SEAFILE_HLS_RESOURCE_KIND_UNSPECIFIED =
      SeafileHlsResourceKind._(
          0, _omitEnumNames ? '' : 'SEAFILE_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const SeafileHlsResourceKind SEAFILE_HLS_RESOURCE_KIND_MEDIA =
      SeafileHlsResourceKind._(
          1, _omitEnumNames ? '' : 'SEAFILE_HLS_RESOURCE_KIND_MEDIA');
  static const SeafileHlsResourceKind SEAFILE_HLS_RESOURCE_KIND_MANIFEST =
      SeafileHlsResourceKind._(
          2, _omitEnumNames ? '' : 'SEAFILE_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<SeafileHlsResourceKind> values =
      <SeafileHlsResourceKind>[
    SEAFILE_HLS_RESOURCE_KIND_UNSPECIFIED,
    SEAFILE_HLS_RESOURCE_KIND_MEDIA,
    SEAFILE_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<SeafileHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SeafileHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SeafileHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
