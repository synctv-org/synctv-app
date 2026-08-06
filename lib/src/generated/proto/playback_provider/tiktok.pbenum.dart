// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/tiktok.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TikTokHlsResourceKind extends $pb.ProtobufEnum {
  static const TikTokHlsResourceKind TIK_TOK_HLS_RESOURCE_KIND_UNSPECIFIED =
      TikTokHlsResourceKind._(
          0, _omitEnumNames ? '' : 'TIK_TOK_HLS_RESOURCE_KIND_UNSPECIFIED');
  static const TikTokHlsResourceKind TIK_TOK_HLS_RESOURCE_KIND_MEDIA =
      TikTokHlsResourceKind._(
          1, _omitEnumNames ? '' : 'TIK_TOK_HLS_RESOURCE_KIND_MEDIA');
  static const TikTokHlsResourceKind TIK_TOK_HLS_RESOURCE_KIND_MANIFEST =
      TikTokHlsResourceKind._(
          2, _omitEnumNames ? '' : 'TIK_TOK_HLS_RESOURCE_KIND_MANIFEST');

  static const $core.List<TikTokHlsResourceKind> values =
      <TikTokHlsResourceKind>[
    TIK_TOK_HLS_RESOURCE_KIND_UNSPECIFIED,
    TIK_TOK_HLS_RESOURCE_KIND_MEDIA,
    TIK_TOK_HLS_RESOURCE_KIND_MANIFEST,
  ];

  static final $core.List<TikTokHlsResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TikTokHlsResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TikTokHlsResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
