// This is a generated file - do not edit.
//
// Generated from proto/providers/acfun.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ResourceKind extends $pb.ProtobufEnum {
  static const ResourceKind RESOURCE_KIND_UNSPECIFIED =
      ResourceKind._(0, _omitEnumNames ? '' : 'RESOURCE_KIND_UNSPECIFIED');
  static const ResourceKind RESOURCE_KIND_VIDEO =
      ResourceKind._(1, _omitEnumNames ? '' : 'RESOURCE_KIND_VIDEO');
  static const ResourceKind RESOURCE_KIND_BANGUMI =
      ResourceKind._(2, _omitEnumNames ? '' : 'RESOURCE_KIND_BANGUMI');
  static const ResourceKind RESOURCE_KIND_LIVE =
      ResourceKind._(3, _omitEnumNames ? '' : 'RESOURCE_KIND_LIVE');

  static const $core.List<ResourceKind> values = <ResourceKind>[
    RESOURCE_KIND_UNSPECIFIED,
    RESOURCE_KIND_VIDEO,
    RESOURCE_KIND_BANGUMI,
    RESOURCE_KIND_LIVE,
  ];

  static final $core.List<ResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceKind._(super.value, super.name);
}

class StreamFormat extends $pb.ProtobufEnum {
  static const StreamFormat STREAM_FORMAT_UNSPECIFIED =
      StreamFormat._(0, _omitEnumNames ? '' : 'STREAM_FORMAT_UNSPECIFIED');
  static const StreamFormat STREAM_FORMAT_HLS =
      StreamFormat._(1, _omitEnumNames ? '' : 'STREAM_FORMAT_HLS');
  static const StreamFormat STREAM_FORMAT_FLV =
      StreamFormat._(2, _omitEnumNames ? '' : 'STREAM_FORMAT_FLV');

  static const $core.List<StreamFormat> values = <StreamFormat>[
    STREAM_FORMAT_UNSPECIFIED,
    STREAM_FORMAT_HLS,
    STREAM_FORMAT_FLV,
  ];

  static final $core.List<StreamFormat?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static StreamFormat? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StreamFormat._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
