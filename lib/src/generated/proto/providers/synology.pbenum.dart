// This is a generated file - do not edit.
//
// Generated from proto/providers/synology.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SynologyVideoEntryKind extends $pb.ProtobufEnum {
  static const SynologyVideoEntryKind SYNOLOGY_VIDEO_ENTRY_KIND_UNSPECIFIED =
      SynologyVideoEntryKind._(
          0, _omitEnumNames ? '' : 'SYNOLOGY_VIDEO_ENTRY_KIND_UNSPECIFIED');
  static const SynologyVideoEntryKind SYNOLOGY_VIDEO_ENTRY_KIND_MOVIE =
      SynologyVideoEntryKind._(
          1, _omitEnumNames ? '' : 'SYNOLOGY_VIDEO_ENTRY_KIND_MOVIE');
  static const SynologyVideoEntryKind SYNOLOGY_VIDEO_ENTRY_KIND_TV_SHOW =
      SynologyVideoEntryKind._(
          2, _omitEnumNames ? '' : 'SYNOLOGY_VIDEO_ENTRY_KIND_TV_SHOW');
  static const SynologyVideoEntryKind SYNOLOGY_VIDEO_ENTRY_KIND_EPISODE =
      SynologyVideoEntryKind._(
          3, _omitEnumNames ? '' : 'SYNOLOGY_VIDEO_ENTRY_KIND_EPISODE');
  static const SynologyVideoEntryKind SYNOLOGY_VIDEO_ENTRY_KIND_HOME_VIDEO =
      SynologyVideoEntryKind._(
          4, _omitEnumNames ? '' : 'SYNOLOGY_VIDEO_ENTRY_KIND_HOME_VIDEO');
  static const SynologyVideoEntryKind SYNOLOGY_VIDEO_ENTRY_KIND_TV_RECORDING =
      SynologyVideoEntryKind._(
          5, _omitEnumNames ? '' : 'SYNOLOGY_VIDEO_ENTRY_KIND_TV_RECORDING');

  static const $core.List<SynologyVideoEntryKind> values =
      <SynologyVideoEntryKind>[
    SYNOLOGY_VIDEO_ENTRY_KIND_UNSPECIFIED,
    SYNOLOGY_VIDEO_ENTRY_KIND_MOVIE,
    SYNOLOGY_VIDEO_ENTRY_KIND_TV_SHOW,
    SYNOLOGY_VIDEO_ENTRY_KIND_EPISODE,
    SYNOLOGY_VIDEO_ENTRY_KIND_HOME_VIDEO,
    SYNOLOGY_VIDEO_ENTRY_KIND_TV_RECORDING,
  ];

  static final $core.List<SynologyVideoEntryKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SynologyVideoEntryKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SynologyVideoEntryKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
