// This is a generated file - do not edit.
//
// Generated from proto/providers/twitch.proto.

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
  static const ResourceKind RESOURCE_KIND_CHANNEL =
      ResourceKind._(1, _omitEnumNames ? '' : 'RESOURCE_KIND_CHANNEL');
  static const ResourceKind RESOURCE_KIND_VIDEO =
      ResourceKind._(2, _omitEnumNames ? '' : 'RESOURCE_KIND_VIDEO');
  static const ResourceKind RESOURCE_KIND_CLIP =
      ResourceKind._(3, _omitEnumNames ? '' : 'RESOURCE_KIND_CLIP');

  static const $core.List<ResourceKind> values = <ResourceKind>[
    RESOURCE_KIND_UNSPECIFIED,
    RESOURCE_KIND_CHANNEL,
    RESOURCE_KIND_VIDEO,
    RESOURCE_KIND_CLIP,
  ];

  static final $core.List<ResourceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ResourceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ResourceKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
