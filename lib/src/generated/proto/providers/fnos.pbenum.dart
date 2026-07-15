// This is a generated file - do not edit.
//
// Generated from proto/providers/fnos.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MediaCollection extends $pb.ProtobufEnum {
  static const MediaCollection MEDIA_COLLECTION_UNSPECIFIED = MediaCollection._(
      0, _omitEnumNames ? '' : 'MEDIA_COLLECTION_UNSPECIFIED');
  static const MediaCollection MEDIA_COLLECTION_LIBRARY =
      MediaCollection._(1, _omitEnumNames ? '' : 'MEDIA_COLLECTION_LIBRARY');
  static const MediaCollection MEDIA_COLLECTION_FAVORITES =
      MediaCollection._(2, _omitEnumNames ? '' : 'MEDIA_COLLECTION_FAVORITES');
  static const MediaCollection MEDIA_COLLECTION_HISTORY =
      MediaCollection._(3, _omitEnumNames ? '' : 'MEDIA_COLLECTION_HISTORY');

  static const $core.List<MediaCollection> values = <MediaCollection>[
    MEDIA_COLLECTION_UNSPECIFIED,
    MEDIA_COLLECTION_LIBRARY,
    MEDIA_COLLECTION_FAVORITES,
    MEDIA_COLLECTION_HISTORY,
  ];

  static final $core.List<MediaCollection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MediaCollection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MediaCollection._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
