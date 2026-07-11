// This is a generated file - do not edit.
//
// Generated from proto/source_config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SourceProvider extends $pb.ProtobufEnum {
  static const SourceProvider SOURCE_PROVIDER_UNSPECIFIED =
      SourceProvider._(0, _omitEnumNames ? '' : 'SOURCE_PROVIDER_UNSPECIFIED');
  static const SourceProvider SOURCE_PROVIDER_DIRECT_URL =
      SourceProvider._(1, _omitEnumNames ? '' : 'SOURCE_PROVIDER_DIRECT_URL');
  static const SourceProvider SOURCE_PROVIDER_BILIBILI =
      SourceProvider._(2, _omitEnumNames ? '' : 'SOURCE_PROVIDER_BILIBILI');
  static const SourceProvider SOURCE_PROVIDER_ALIST =
      SourceProvider._(3, _omitEnumNames ? '' : 'SOURCE_PROVIDER_ALIST');
  static const SourceProvider SOURCE_PROVIDER_EMBY =
      SourceProvider._(4, _omitEnumNames ? '' : 'SOURCE_PROVIDER_EMBY');
  static const SourceProvider SOURCE_PROVIDER_RTMP =
      SourceProvider._(5, _omitEnumNames ? '' : 'SOURCE_PROVIDER_RTMP');
  static const SourceProvider SOURCE_PROVIDER_LIVE_PROXY =
      SourceProvider._(6, _omitEnumNames ? '' : 'SOURCE_PROVIDER_LIVE_PROXY');
  static const SourceProvider SOURCE_PROVIDER_CLOUDREVE =
      SourceProvider._(7, _omitEnumNames ? '' : 'SOURCE_PROVIDER_CLOUDREVE');

  static const $core.List<SourceProvider> values = <SourceProvider>[
    SOURCE_PROVIDER_UNSPECIFIED,
    SOURCE_PROVIDER_DIRECT_URL,
    SOURCE_PROVIDER_BILIBILI,
    SOURCE_PROVIDER_ALIST,
    SOURCE_PROVIDER_EMBY,
    SOURCE_PROVIDER_RTMP,
    SOURCE_PROVIDER_LIVE_PROXY,
    SOURCE_PROVIDER_CLOUDREVE,
  ];

  static final $core.List<SourceProvider?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static SourceProvider? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SourceProvider._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
