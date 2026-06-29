// This is a generated file - do not edit.
//
// Generated from proto/oauth2.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class OAuth2ProviderType extends $pb.ProtobufEnum {
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_UNSPECIFIED =
      OAuth2ProviderType._(
          0, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_UNSPECIFIED');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_QQ =
      OAuth2ProviderType._(1, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_QQ');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_GITHUB =
      OAuth2ProviderType._(
          2, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_GITHUB');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_GOOGLE =
      OAuth2ProviderType._(
          3, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_GOOGLE');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_MICROSOFT =
      OAuth2ProviderType._(
          4, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_MICROSOFT');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_DISCORD =
      OAuth2ProviderType._(
          5, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_DISCORD');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_CASDOOR =
      OAuth2ProviderType._(
          6, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_CASDOOR');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_LOGTO =
      OAuth2ProviderType._(
          7, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_LOGTO');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_OIDC =
      OAuth2ProviderType._(
          8, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_OIDC');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_FEISHU =
      OAuth2ProviderType._(
          9, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_FEISHU');
  static const OAuth2ProviderType OAUTH2_PROVIDER_TYPE_GITEE =
      OAuth2ProviderType._(
          10, _omitEnumNames ? '' : 'OAUTH2_PROVIDER_TYPE_GITEE');

  static const $core.List<OAuth2ProviderType> values = <OAuth2ProviderType>[
    OAUTH2_PROVIDER_TYPE_UNSPECIFIED,
    OAUTH2_PROVIDER_TYPE_QQ,
    OAUTH2_PROVIDER_TYPE_GITHUB,
    OAUTH2_PROVIDER_TYPE_GOOGLE,
    OAUTH2_PROVIDER_TYPE_MICROSOFT,
    OAUTH2_PROVIDER_TYPE_DISCORD,
    OAUTH2_PROVIDER_TYPE_CASDOOR,
    OAUTH2_PROVIDER_TYPE_LOGTO,
    OAUTH2_PROVIDER_TYPE_OIDC,
    OAUTH2_PROVIDER_TYPE_FEISHU,
    OAUTH2_PROVIDER_TYPE_GITEE,
  ];

  static final $core.List<OAuth2ProviderType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static OAuth2ProviderType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OAuth2ProviderType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
