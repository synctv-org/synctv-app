// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/alist.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AlistHlsResourceKind extends $pb.ProtobufEnum {
  static const AlistHlsResourceKind ALIST_HLS_RESOURCE_KIND_UNSPECIFIED =
      AlistHlsResourceKind._(
          0, _omitEnumNames ? '' : 'ALIST_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const AlistHlsResourceKind ALIST_HLS_RESOURCE_KIND_MEDIA =
      AlistHlsResourceKind._(
          1, _omitEnumNames ? '' : 'ALIST_HLS_RESOURCE_KIND_MEDIA');
  static const AlistHlsResourceKind ALIST_HLS_RESOURCE_KIND_MANIFEST =
      AlistHlsResourceKind._(
          2, _omitEnumNames ? '' : 'ALIST_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<AlistHlsResourceKind> values = <AlistHlsResourceKind>[
    ALIST_HLS_RESOURCE_KIND_UNSPECIFIED,
    ALIST_HLS_RESOURCE_KIND_MEDIA,
    ALIST_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<AlistHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AlistHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlistHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
