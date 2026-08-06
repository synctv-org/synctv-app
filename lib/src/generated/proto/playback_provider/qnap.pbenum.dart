// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/qnap.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class QnapHlsResourceKind extends $pb.ProtobufEnum {
  static const QnapHlsResourceKind QNAP_HLS_RESOURCE_KIND_UNSPECIFIED =
      QnapHlsResourceKind._(
          0, _omitEnumNames ? '' : 'QNAP_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const QnapHlsResourceKind QNAP_HLS_RESOURCE_KIND_MEDIA =
      QnapHlsResourceKind._(
          1, _omitEnumNames ? '' : 'QNAP_HLS_RESOURCE_KIND_MEDIA');
  static const QnapHlsResourceKind QNAP_HLS_RESOURCE_KIND_MANIFEST =
      QnapHlsResourceKind._(
          2, _omitEnumNames ? '' : 'QNAP_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<QnapHlsResourceKind> values = <QnapHlsResourceKind>[
    QNAP_HLS_RESOURCE_KIND_UNSPECIFIED,
    QNAP_HLS_RESOURCE_KIND_MEDIA,
    QNAP_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<QnapHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static QnapHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const QnapHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
