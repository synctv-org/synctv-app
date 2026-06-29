// This is a generated file - do not edit.
//
// Generated from proto/passkey.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'passkey.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'passkey.pbenum.dart';

class PasskeyRelyingParty extends $pb.GeneratedMessage {
  factory PasskeyRelyingParty({
    $core.String? name,
    $core.String? id,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (id != null) result.id = id;
    return result;
  }

  PasskeyRelyingParty._();

  factory PasskeyRelyingParty.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRelyingParty.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyRelyingParty',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRelyingParty clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRelyingParty copyWith(void Function(PasskeyRelyingParty) updates) =>
      super.copyWith((message) => updates(message as PasskeyRelyingParty))
          as PasskeyRelyingParty;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRelyingParty create() => PasskeyRelyingParty._();
  @$core.override
  PasskeyRelyingParty createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRelyingParty getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyRelyingParty>(create);
  static PasskeyRelyingParty? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class PasskeyUserEntity extends $pb.GeneratedMessage {
  factory PasskeyUserEntity({
    $core.List<$core.int>? id,
    $core.String? name,
    $core.String? displayName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (displayName != null) result.displayName = displayName;
    return result;
  }

  PasskeyUserEntity._();

  factory PasskeyUserEntity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyUserEntity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyUserEntity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyUserEntity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyUserEntity copyWith(void Function(PasskeyUserEntity) updates) =>
      super.copyWith((message) => updates(message as PasskeyUserEntity))
          as PasskeyUserEntity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyUserEntity create() => PasskeyUserEntity._();
  @$core.override
  PasskeyUserEntity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyUserEntity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyUserEntity>(create);
  static PasskeyUserEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get id => $_getN(0);
  @$pb.TagNumber(1)
  set id($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);
}

class PasskeyPubKeyCredentialParam extends $pb.GeneratedMessage {
  factory PasskeyPubKeyCredentialParam({
    PasskeyPublicKeyCredentialType? type,
    $fixnum.Int64? alg,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (alg != null) result.alg = alg;
    return result;
  }

  PasskeyPubKeyCredentialParam._();

  factory PasskeyPubKeyCredentialParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyPubKeyCredentialParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyPubKeyCredentialParam',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<PasskeyPublicKeyCredentialType>(1, _omitFieldNames ? '' : 'type',
        enumValues: PasskeyPublicKeyCredentialType.values)
    ..aInt64(2, _omitFieldNames ? '' : 'alg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyPubKeyCredentialParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyPubKeyCredentialParam copyWith(
          void Function(PasskeyPubKeyCredentialParam) updates) =>
      super.copyWith(
              (message) => updates(message as PasskeyPubKeyCredentialParam))
          as PasskeyPubKeyCredentialParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyPubKeyCredentialParam create() =>
      PasskeyPubKeyCredentialParam._();
  @$core.override
  PasskeyPubKeyCredentialParam createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyPubKeyCredentialParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyPubKeyCredentialParam>(create);
  static PasskeyPubKeyCredentialParam? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyPublicKeyCredentialType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(PasskeyPublicKeyCredentialType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get alg => $_getI64(1);
  @$pb.TagNumber(2)
  set alg($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlg() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlg() => $_clearField(2);
}

class PasskeyCredentialDescriptor extends $pb.GeneratedMessage {
  factory PasskeyCredentialDescriptor({
    PasskeyPublicKeyCredentialType? type,
    $core.List<$core.int>? id,
    $core.Iterable<PasskeyAuthenticatorTransport>? transports,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    if (transports != null) result.transports.addAll(transports);
    return result;
  }

  PasskeyCredentialDescriptor._();

  factory PasskeyCredentialDescriptor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyCredentialDescriptor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyCredentialDescriptor',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<PasskeyPublicKeyCredentialType>(1, _omitFieldNames ? '' : 'type',
        enumValues: PasskeyPublicKeyCredentialType.values)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OY)
    ..pc<PasskeyAuthenticatorTransport>(
        3, _omitFieldNames ? '' : 'transports', $pb.PbFieldType.KE,
        valueOf: PasskeyAuthenticatorTransport.valueOf,
        enumValues: PasskeyAuthenticatorTransport.values,
        defaultEnumValue: PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredentialDescriptor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredentialDescriptor copyWith(
          void Function(PasskeyCredentialDescriptor) updates) =>
      super.copyWith(
              (message) => updates(message as PasskeyCredentialDescriptor))
          as PasskeyCredentialDescriptor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyCredentialDescriptor create() =>
      PasskeyCredentialDescriptor._();
  @$core.override
  PasskeyCredentialDescriptor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyCredentialDescriptor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyCredentialDescriptor>(create);
  static PasskeyCredentialDescriptor? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyPublicKeyCredentialType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(PasskeyPublicKeyCredentialType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get id => $_getN(1);
  @$pb.TagNumber(2)
  set id($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<PasskeyAuthenticatorTransport> get transports => $_getList(2);
}

class PasskeyAuthenticatorSelectionCriteria extends $pb.GeneratedMessage {
  factory PasskeyAuthenticatorSelectionCriteria({
    PasskeyAuthenticatorAttachment? authenticatorAttachment,
    PasskeyResidentKeyRequirement? residentKey,
    $core.bool? requireResidentKey,
    PasskeyUserVerificationRequirement? userVerification,
  }) {
    final result = create();
    if (authenticatorAttachment != null)
      result.authenticatorAttachment = authenticatorAttachment;
    if (residentKey != null) result.residentKey = residentKey;
    if (requireResidentKey != null)
      result.requireResidentKey = requireResidentKey;
    if (userVerification != null) result.userVerification = userVerification;
    return result;
  }

  PasskeyAuthenticatorSelectionCriteria._();

  factory PasskeyAuthenticatorSelectionCriteria.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyAuthenticatorSelectionCriteria.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyAuthenticatorSelectionCriteria',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<PasskeyAuthenticatorAttachment>(
        1, _omitFieldNames ? '' : 'authenticatorAttachment',
        enumValues: PasskeyAuthenticatorAttachment.values)
    ..aE<PasskeyResidentKeyRequirement>(2, _omitFieldNames ? '' : 'residentKey',
        enumValues: PasskeyResidentKeyRequirement.values)
    ..aOB(3, _omitFieldNames ? '' : 'requireResidentKey')
    ..aE<PasskeyUserVerificationRequirement>(
        4, _omitFieldNames ? '' : 'userVerification',
        enumValues: PasskeyUserVerificationRequirement.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticatorSelectionCriteria clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticatorSelectionCriteria copyWith(
          void Function(PasskeyAuthenticatorSelectionCriteria) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyAuthenticatorSelectionCriteria))
          as PasskeyAuthenticatorSelectionCriteria;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticatorSelectionCriteria create() =>
      PasskeyAuthenticatorSelectionCriteria._();
  @$core.override
  PasskeyAuthenticatorSelectionCriteria createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticatorSelectionCriteria getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyAuthenticatorSelectionCriteria>(create);
  static PasskeyAuthenticatorSelectionCriteria? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyAuthenticatorAttachment get authenticatorAttachment => $_getN(0);
  @$pb.TagNumber(1)
  set authenticatorAttachment(PasskeyAuthenticatorAttachment value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthenticatorAttachment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthenticatorAttachment() => $_clearField(1);

  @$pb.TagNumber(2)
  PasskeyResidentKeyRequirement get residentKey => $_getN(1);
  @$pb.TagNumber(2)
  set residentKey(PasskeyResidentKeyRequirement value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResidentKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearResidentKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get requireResidentKey => $_getBF(2);
  @$pb.TagNumber(3)
  set requireResidentKey($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequireResidentKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequireResidentKey() => $_clearField(3);

  @$pb.TagNumber(4)
  PasskeyUserVerificationRequirement get userVerification => $_getN(3);
  @$pb.TagNumber(4)
  set userVerification(PasskeyUserVerificationRequirement value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUserVerification() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserVerification() => $_clearField(4);
}

class PasskeyCredProtectInput extends $pb.GeneratedMessage {
  factory PasskeyCredProtectInput({
    PasskeyCredentialProtectionPolicy? credentialProtectionPolicy,
    $core.bool? enforceCredentialProtectionPolicy,
  }) {
    final result = create();
    if (credentialProtectionPolicy != null)
      result.credentialProtectionPolicy = credentialProtectionPolicy;
    if (enforceCredentialProtectionPolicy != null)
      result.enforceCredentialProtectionPolicy =
          enforceCredentialProtectionPolicy;
    return result;
  }

  PasskeyCredProtectInput._();

  factory PasskeyCredProtectInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyCredProtectInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyCredProtectInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<PasskeyCredentialProtectionPolicy>(
        1, _omitFieldNames ? '' : 'credentialProtectionPolicy',
        enumValues: PasskeyCredentialProtectionPolicy.values)
    ..aOB(2, _omitFieldNames ? '' : 'enforceCredentialProtectionPolicy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredProtectInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCredProtectInput copyWith(
          void Function(PasskeyCredProtectInput) updates) =>
      super.copyWith((message) => updates(message as PasskeyCredProtectInput))
          as PasskeyCredProtectInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyCredProtectInput create() => PasskeyCredProtectInput._();
  @$core.override
  PasskeyCredProtectInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyCredProtectInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyCredProtectInput>(create);
  static PasskeyCredProtectInput? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyCredentialProtectionPolicy get credentialProtectionPolicy => $_getN(0);
  @$pb.TagNumber(1)
  set credentialProtectionPolicy(PasskeyCredentialProtectionPolicy value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCredentialProtectionPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredentialProtectionPolicy() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enforceCredentialProtectionPolicy => $_getBF(1);
  @$pb.TagNumber(2)
  set enforceCredentialProtectionPolicy($core.bool value) =>
      $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnforceCredentialProtectionPolicy() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnforceCredentialProtectionPolicy() => $_clearField(2);
}

class PasskeyRegistrationExtensionsInput extends $pb.GeneratedMessage {
  factory PasskeyRegistrationExtensionsInput({
    PasskeyCredProtectInput? credProtect,
    $core.bool? uvm,
    $core.bool? credProps,
    $core.bool? minPinLength,
    $core.bool? hmacCreateSecret,
  }) {
    final result = create();
    if (credProtect != null) result.credProtect = credProtect;
    if (uvm != null) result.uvm = uvm;
    if (credProps != null) result.credProps = credProps;
    if (minPinLength != null) result.minPinLength = minPinLength;
    if (hmacCreateSecret != null) result.hmacCreateSecret = hmacCreateSecret;
    return result;
  }

  PasskeyRegistrationExtensionsInput._();

  factory PasskeyRegistrationExtensionsInput.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegistrationExtensionsInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyRegistrationExtensionsInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PasskeyCredProtectInput>(1, _omitFieldNames ? '' : 'credProtect',
        subBuilder: PasskeyCredProtectInput.create)
    ..aOB(2, _omitFieldNames ? '' : 'uvm')
    ..aOB(3, _omitFieldNames ? '' : 'credProps')
    ..aOB(4, _omitFieldNames ? '' : 'minPinLength')
    ..aOB(5, _omitFieldNames ? '' : 'hmacCreateSecret')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationExtensionsInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationExtensionsInput copyWith(
          void Function(PasskeyRegistrationExtensionsInput) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyRegistrationExtensionsInput))
          as PasskeyRegistrationExtensionsInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationExtensionsInput create() =>
      PasskeyRegistrationExtensionsInput._();
  @$core.override
  PasskeyRegistrationExtensionsInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationExtensionsInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyRegistrationExtensionsInput>(
          create);
  static PasskeyRegistrationExtensionsInput? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyCredProtectInput get credProtect => $_getN(0);
  @$pb.TagNumber(1)
  set credProtect(PasskeyCredProtectInput value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCredProtect() => $_has(0);
  @$pb.TagNumber(1)
  void clearCredProtect() => $_clearField(1);
  @$pb.TagNumber(1)
  PasskeyCredProtectInput ensureCredProtect() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get uvm => $_getBF(1);
  @$pb.TagNumber(2)
  set uvm($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUvm() => $_has(1);
  @$pb.TagNumber(2)
  void clearUvm() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get credProps => $_getBF(2);
  @$pb.TagNumber(3)
  set credProps($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredProps() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredProps() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get minPinLength => $_getBF(3);
  @$pb.TagNumber(4)
  set minPinLength($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinPinLength() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinPinLength() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hmacCreateSecret => $_getBF(4);
  @$pb.TagNumber(5)
  set hmacCreateSecret($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHmacCreateSecret() => $_has(4);
  @$pb.TagNumber(5)
  void clearHmacCreateSecret() => $_clearField(5);
}

class PasskeyHmacGetSecretInput extends $pb.GeneratedMessage {
  factory PasskeyHmacGetSecretInput({
    $core.List<$core.int>? output1,
    $core.List<$core.int>? output2,
  }) {
    final result = create();
    if (output1 != null) result.output1 = output1;
    if (output2 != null) result.output2 = output2;
    return result;
  }

  PasskeyHmacGetSecretInput._();

  factory PasskeyHmacGetSecretInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyHmacGetSecretInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyHmacGetSecretInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'output1', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'output2', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyHmacGetSecretInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyHmacGetSecretInput copyWith(
          void Function(PasskeyHmacGetSecretInput) updates) =>
      super.copyWith((message) => updates(message as PasskeyHmacGetSecretInput))
          as PasskeyHmacGetSecretInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyHmacGetSecretInput create() => PasskeyHmacGetSecretInput._();
  @$core.override
  PasskeyHmacGetSecretInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyHmacGetSecretInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyHmacGetSecretInput>(create);
  static PasskeyHmacGetSecretInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get output1 => $_getN(0);
  @$pb.TagNumber(1)
  set output1($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutput1() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get output2 => $_getN(1);
  @$pb.TagNumber(2)
  set output2($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutput2() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutput2() => $_clearField(2);
}

class PasskeyAuthenticationExtensionsInput extends $pb.GeneratedMessage {
  factory PasskeyAuthenticationExtensionsInput({
    $core.String? appid,
    $core.bool? uvm,
    PasskeyHmacGetSecretInput? hmacGetSecret,
  }) {
    final result = create();
    if (appid != null) result.appid = appid;
    if (uvm != null) result.uvm = uvm;
    if (hmacGetSecret != null) result.hmacGetSecret = hmacGetSecret;
    return result;
  }

  PasskeyAuthenticationExtensionsInput._();

  factory PasskeyAuthenticationExtensionsInput.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyAuthenticationExtensionsInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyAuthenticationExtensionsInput',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appid')
    ..aOB(2, _omitFieldNames ? '' : 'uvm')
    ..aOM<PasskeyHmacGetSecretInput>(3, _omitFieldNames ? '' : 'hmacGetSecret',
        subBuilder: PasskeyHmacGetSecretInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticationExtensionsInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticationExtensionsInput copyWith(
          void Function(PasskeyAuthenticationExtensionsInput) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyAuthenticationExtensionsInput))
          as PasskeyAuthenticationExtensionsInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticationExtensionsInput create() =>
      PasskeyAuthenticationExtensionsInput._();
  @$core.override
  PasskeyAuthenticationExtensionsInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticationExtensionsInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyAuthenticationExtensionsInput>(create);
  static PasskeyAuthenticationExtensionsInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appid => $_getSZ(0);
  @$pb.TagNumber(1)
  set appid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get uvm => $_getBF(1);
  @$pb.TagNumber(2)
  set uvm($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUvm() => $_has(1);
  @$pb.TagNumber(2)
  void clearUvm() => $_clearField(2);

  @$pb.TagNumber(3)
  PasskeyHmacGetSecretInput get hmacGetSecret => $_getN(2);
  @$pb.TagNumber(3)
  set hmacGetSecret(PasskeyHmacGetSecretInput value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasHmacGetSecret() => $_has(2);
  @$pb.TagNumber(3)
  void clearHmacGetSecret() => $_clearField(3);
  @$pb.TagNumber(3)
  PasskeyHmacGetSecretInput ensureHmacGetSecret() => $_ensure(2);
}

class PasskeyPublicKeyCredentialCreationOptions extends $pb.GeneratedMessage {
  factory PasskeyPublicKeyCredentialCreationOptions({
    PasskeyRelyingParty? rp,
    PasskeyUserEntity? user,
    $core.List<$core.int>? challenge,
    $core.Iterable<PasskeyPubKeyCredentialParam>? pubKeyCredParams,
    $core.int? timeout,
    $core.Iterable<PasskeyCredentialDescriptor>? excludeCredentials,
    PasskeyAuthenticatorSelectionCriteria? authenticatorSelection,
    $core.Iterable<PasskeyPublicKeyCredentialHint>? hints,
    PasskeyAttestationConveyancePreference? attestation,
    $core.Iterable<PasskeyAttestationFormat>? attestationFormats,
    PasskeyRegistrationExtensionsInput? extensions,
  }) {
    final result = create();
    if (rp != null) result.rp = rp;
    if (user != null) result.user = user;
    if (challenge != null) result.challenge = challenge;
    if (pubKeyCredParams != null)
      result.pubKeyCredParams.addAll(pubKeyCredParams);
    if (timeout != null) result.timeout = timeout;
    if (excludeCredentials != null)
      result.excludeCredentials.addAll(excludeCredentials);
    if (authenticatorSelection != null)
      result.authenticatorSelection = authenticatorSelection;
    if (hints != null) result.hints.addAll(hints);
    if (attestation != null) result.attestation = attestation;
    if (attestationFormats != null)
      result.attestationFormats.addAll(attestationFormats);
    if (extensions != null) result.extensions = extensions;
    return result;
  }

  PasskeyPublicKeyCredentialCreationOptions._();

  factory PasskeyPublicKeyCredentialCreationOptions.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyPublicKeyCredentialCreationOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyPublicKeyCredentialCreationOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PasskeyRelyingParty>(1, _omitFieldNames ? '' : 'rp',
        subBuilder: PasskeyRelyingParty.create)
    ..aOM<PasskeyUserEntity>(2, _omitFieldNames ? '' : 'user',
        subBuilder: PasskeyUserEntity.create)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'challenge', $pb.PbFieldType.OY)
    ..pPM<PasskeyPubKeyCredentialParam>(
        4, _omitFieldNames ? '' : 'pubKeyCredParams',
        subBuilder: PasskeyPubKeyCredentialParam.create)
    ..aI(5, _omitFieldNames ? '' : 'timeout', fieldType: $pb.PbFieldType.OU3)
    ..pPM<PasskeyCredentialDescriptor>(
        6, _omitFieldNames ? '' : 'excludeCredentials',
        subBuilder: PasskeyCredentialDescriptor.create)
    ..aOM<PasskeyAuthenticatorSelectionCriteria>(
        7, _omitFieldNames ? '' : 'authenticatorSelection',
        subBuilder: PasskeyAuthenticatorSelectionCriteria.create)
    ..pc<PasskeyPublicKeyCredentialHint>(
        8, _omitFieldNames ? '' : 'hints', $pb.PbFieldType.KE,
        valueOf: PasskeyPublicKeyCredentialHint.valueOf,
        enumValues: PasskeyPublicKeyCredentialHint.values,
        defaultEnumValue: PasskeyPublicKeyCredentialHint
            .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_UNSPECIFIED)
    ..aE<PasskeyAttestationConveyancePreference>(
        9, _omitFieldNames ? '' : 'attestation',
        enumValues: PasskeyAttestationConveyancePreference.values)
    ..pc<PasskeyAttestationFormat>(
        10, _omitFieldNames ? '' : 'attestationFormats', $pb.PbFieldType.KE,
        valueOf: PasskeyAttestationFormat.valueOf,
        enumValues: PasskeyAttestationFormat.values,
        defaultEnumValue:
            PasskeyAttestationFormat.PASSKEY_ATTESTATION_FORMAT_UNSPECIFIED)
    ..aOM<PasskeyRegistrationExtensionsInput>(
        11, _omitFieldNames ? '' : 'extensions',
        subBuilder: PasskeyRegistrationExtensionsInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyPublicKeyCredentialCreationOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyPublicKeyCredentialCreationOptions copyWith(
          void Function(PasskeyPublicKeyCredentialCreationOptions) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyPublicKeyCredentialCreationOptions))
          as PasskeyPublicKeyCredentialCreationOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyPublicKeyCredentialCreationOptions create() =>
      PasskeyPublicKeyCredentialCreationOptions._();
  @$core.override
  PasskeyPublicKeyCredentialCreationOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyPublicKeyCredentialCreationOptions getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyPublicKeyCredentialCreationOptions>(create);
  static PasskeyPublicKeyCredentialCreationOptions? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyRelyingParty get rp => $_getN(0);
  @$pb.TagNumber(1)
  set rp(PasskeyRelyingParty value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRp() => $_clearField(1);
  @$pb.TagNumber(1)
  PasskeyRelyingParty ensureRp() => $_ensure(0);

  @$pb.TagNumber(2)
  PasskeyUserEntity get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(PasskeyUserEntity value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  PasskeyUserEntity ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get challenge => $_getN(2);
  @$pb.TagNumber(3)
  set challenge($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChallenge() => $_has(2);
  @$pb.TagNumber(3)
  void clearChallenge() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PasskeyPubKeyCredentialParam> get pubKeyCredParams => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get timeout => $_getIZ(4);
  @$pb.TagNumber(5)
  set timeout($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimeout() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeout() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<PasskeyCredentialDescriptor> get excludeCredentials =>
      $_getList(5);

  @$pb.TagNumber(7)
  PasskeyAuthenticatorSelectionCriteria get authenticatorSelection => $_getN(6);
  @$pb.TagNumber(7)
  set authenticatorSelection(PasskeyAuthenticatorSelectionCriteria value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthenticatorSelection() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthenticatorSelection() => $_clearField(7);
  @$pb.TagNumber(7)
  PasskeyAuthenticatorSelectionCriteria ensureAuthenticatorSelection() =>
      $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<PasskeyPublicKeyCredentialHint> get hints => $_getList(7);

  @$pb.TagNumber(9)
  PasskeyAttestationConveyancePreference get attestation => $_getN(8);
  @$pb.TagNumber(9)
  set attestation(PasskeyAttestationConveyancePreference value) =>
      $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAttestation() => $_has(8);
  @$pb.TagNumber(9)
  void clearAttestation() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<PasskeyAttestationFormat> get attestationFormats => $_getList(9);

  @$pb.TagNumber(11)
  PasskeyRegistrationExtensionsInput get extensions => $_getN(10);
  @$pb.TagNumber(11)
  set extensions(PasskeyRegistrationExtensionsInput value) =>
      $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasExtensions() => $_has(10);
  @$pb.TagNumber(11)
  void clearExtensions() => $_clearField(11);
  @$pb.TagNumber(11)
  PasskeyRegistrationExtensionsInput ensureExtensions() => $_ensure(10);
}

class PasskeyCreationChallenge extends $pb.GeneratedMessage {
  factory PasskeyCreationChallenge({
    PasskeyPublicKeyCredentialCreationOptions? publicKey,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  PasskeyCreationChallenge._();

  factory PasskeyCreationChallenge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyCreationChallenge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyCreationChallenge',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PasskeyPublicKeyCredentialCreationOptions>(
        1, _omitFieldNames ? '' : 'publicKey',
        subBuilder: PasskeyPublicKeyCredentialCreationOptions.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCreationChallenge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyCreationChallenge copyWith(
          void Function(PasskeyCreationChallenge) updates) =>
      super.copyWith((message) => updates(message as PasskeyCreationChallenge))
          as PasskeyCreationChallenge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyCreationChallenge create() => PasskeyCreationChallenge._();
  @$core.override
  PasskeyCreationChallenge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyCreationChallenge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyCreationChallenge>(create);
  static PasskeyCreationChallenge? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyPublicKeyCredentialCreationOptions get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey(PasskeyPublicKeyCredentialCreationOptions value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);
  @$pb.TagNumber(1)
  PasskeyPublicKeyCredentialCreationOptions ensurePublicKey() => $_ensure(0);
}

class PasskeyPublicKeyCredentialRequestOptions extends $pb.GeneratedMessage {
  factory PasskeyPublicKeyCredentialRequestOptions({
    $core.List<$core.int>? challenge,
    $core.int? timeout,
    $core.String? rpId,
    $core.Iterable<PasskeyCredentialDescriptor>? allowCredentials,
    PasskeyUserVerificationRequirement? userVerification,
    $core.Iterable<PasskeyPublicKeyCredentialHint>? hints,
    PasskeyAuthenticationExtensionsInput? extensions,
  }) {
    final result = create();
    if (challenge != null) result.challenge = challenge;
    if (timeout != null) result.timeout = timeout;
    if (rpId != null) result.rpId = rpId;
    if (allowCredentials != null)
      result.allowCredentials.addAll(allowCredentials);
    if (userVerification != null) result.userVerification = userVerification;
    if (hints != null) result.hints.addAll(hints);
    if (extensions != null) result.extensions = extensions;
    return result;
  }

  PasskeyPublicKeyCredentialRequestOptions._();

  factory PasskeyPublicKeyCredentialRequestOptions.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyPublicKeyCredentialRequestOptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyPublicKeyCredentialRequestOptions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'challenge', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'timeout', fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'rpId')
    ..pPM<PasskeyCredentialDescriptor>(
        4, _omitFieldNames ? '' : 'allowCredentials',
        subBuilder: PasskeyCredentialDescriptor.create)
    ..aE<PasskeyUserVerificationRequirement>(
        5, _omitFieldNames ? '' : 'userVerification',
        enumValues: PasskeyUserVerificationRequirement.values)
    ..pc<PasskeyPublicKeyCredentialHint>(
        6, _omitFieldNames ? '' : 'hints', $pb.PbFieldType.KE,
        valueOf: PasskeyPublicKeyCredentialHint.valueOf,
        enumValues: PasskeyPublicKeyCredentialHint.values,
        defaultEnumValue: PasskeyPublicKeyCredentialHint
            .PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_UNSPECIFIED)
    ..aOM<PasskeyAuthenticationExtensionsInput>(
        7, _omitFieldNames ? '' : 'extensions',
        subBuilder: PasskeyAuthenticationExtensionsInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyPublicKeyCredentialRequestOptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyPublicKeyCredentialRequestOptions copyWith(
          void Function(PasskeyPublicKeyCredentialRequestOptions) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyPublicKeyCredentialRequestOptions))
          as PasskeyPublicKeyCredentialRequestOptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyPublicKeyCredentialRequestOptions create() =>
      PasskeyPublicKeyCredentialRequestOptions._();
  @$core.override
  PasskeyPublicKeyCredentialRequestOptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyPublicKeyCredentialRequestOptions getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyPublicKeyCredentialRequestOptions>(create);
  static PasskeyPublicKeyCredentialRequestOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get timeout => $_getIZ(1);
  @$pb.TagNumber(2)
  set timeout($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeout() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeout() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rpId => $_getSZ(2);
  @$pb.TagNumber(3)
  set rpId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRpId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRpId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PasskeyCredentialDescriptor> get allowCredentials => $_getList(3);

  @$pb.TagNumber(5)
  PasskeyUserVerificationRequirement get userVerification => $_getN(4);
  @$pb.TagNumber(5)
  set userVerification(PasskeyUserVerificationRequirement value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUserVerification() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserVerification() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<PasskeyPublicKeyCredentialHint> get hints => $_getList(5);

  @$pb.TagNumber(7)
  PasskeyAuthenticationExtensionsInput get extensions => $_getN(6);
  @$pb.TagNumber(7)
  set extensions(PasskeyAuthenticationExtensionsInput value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExtensions() => $_has(6);
  @$pb.TagNumber(7)
  void clearExtensions() => $_clearField(7);
  @$pb.TagNumber(7)
  PasskeyAuthenticationExtensionsInput ensureExtensions() => $_ensure(6);
}

class PasskeyRequestChallenge extends $pb.GeneratedMessage {
  factory PasskeyRequestChallenge({
    PasskeyPublicKeyCredentialRequestOptions? publicKey,
    PasskeyMediationRequirement? mediation,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    if (mediation != null) result.mediation = mediation;
    return result;
  }

  PasskeyRequestChallenge._();

  factory PasskeyRequestChallenge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRequestChallenge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyRequestChallenge',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOM<PasskeyPublicKeyCredentialRequestOptions>(
        1, _omitFieldNames ? '' : 'publicKey',
        subBuilder: PasskeyPublicKeyCredentialRequestOptions.create)
    ..aE<PasskeyMediationRequirement>(2, _omitFieldNames ? '' : 'mediation',
        enumValues: PasskeyMediationRequirement.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRequestChallenge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRequestChallenge copyWith(
          void Function(PasskeyRequestChallenge) updates) =>
      super.copyWith((message) => updates(message as PasskeyRequestChallenge))
          as PasskeyRequestChallenge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRequestChallenge create() => PasskeyRequestChallenge._();
  @$core.override
  PasskeyRequestChallenge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRequestChallenge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyRequestChallenge>(create);
  static PasskeyRequestChallenge? _defaultInstance;

  @$pb.TagNumber(1)
  PasskeyPublicKeyCredentialRequestOptions get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey(PasskeyPublicKeyCredentialRequestOptions value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);
  @$pb.TagNumber(1)
  PasskeyPublicKeyCredentialRequestOptions ensurePublicKey() => $_ensure(0);

  @$pb.TagNumber(2)
  PasskeyMediationRequirement get mediation => $_getN(1);
  @$pb.TagNumber(2)
  set mediation(PasskeyMediationRequirement value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMediation() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediation() => $_clearField(2);
}

class PasskeyAuthenticationExtensionsClientOutputs
    extends $pb.GeneratedMessage {
  factory PasskeyAuthenticationExtensionsClientOutputs({
    $core.bool? appid,
    PasskeyHmacGetSecretInput? hmacGetSecret,
  }) {
    final result = create();
    if (appid != null) result.appid = appid;
    if (hmacGetSecret != null) result.hmacGetSecret = hmacGetSecret;
    return result;
  }

  PasskeyAuthenticationExtensionsClientOutputs._();

  factory PasskeyAuthenticationExtensionsClientOutputs.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyAuthenticationExtensionsClientOutputs.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyAuthenticationExtensionsClientOutputs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'appid')
    ..aOM<PasskeyHmacGetSecretInput>(2, _omitFieldNames ? '' : 'hmacGetSecret',
        subBuilder: PasskeyHmacGetSecretInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticationExtensionsClientOutputs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticationExtensionsClientOutputs copyWith(
          void Function(PasskeyAuthenticationExtensionsClientOutputs)
              updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyAuthenticationExtensionsClientOutputs))
          as PasskeyAuthenticationExtensionsClientOutputs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticationExtensionsClientOutputs create() =>
      PasskeyAuthenticationExtensionsClientOutputs._();
  @$core.override
  PasskeyAuthenticationExtensionsClientOutputs createEmptyInstance() =>
      create();
  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticationExtensionsClientOutputs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyAuthenticationExtensionsClientOutputs>(create);
  static PasskeyAuthenticationExtensionsClientOutputs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get appid => $_getBF(0);
  @$pb.TagNumber(1)
  set appid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppid() => $_clearField(1);

  @$pb.TagNumber(2)
  PasskeyHmacGetSecretInput get hmacGetSecret => $_getN(1);
  @$pb.TagNumber(2)
  set hmacGetSecret(PasskeyHmacGetSecretInput value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHmacGetSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearHmacGetSecret() => $_clearField(2);
  @$pb.TagNumber(2)
  PasskeyHmacGetSecretInput ensureHmacGetSecret() => $_ensure(1);
}

class PasskeyRegistrationCredProps extends $pb.GeneratedMessage {
  factory PasskeyRegistrationCredProps({
    $core.bool? rk,
  }) {
    final result = create();
    if (rk != null) result.rk = rk;
    return result;
  }

  PasskeyRegistrationCredProps._();

  factory PasskeyRegistrationCredProps.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegistrationCredProps.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyRegistrationCredProps',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'rk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationCredProps clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationCredProps copyWith(
          void Function(PasskeyRegistrationCredProps) updates) =>
      super.copyWith(
              (message) => updates(message as PasskeyRegistrationCredProps))
          as PasskeyRegistrationCredProps;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationCredProps create() =>
      PasskeyRegistrationCredProps._();
  @$core.override
  PasskeyRegistrationCredProps createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationCredProps getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyRegistrationCredProps>(create);
  static PasskeyRegistrationCredProps? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get rk => $_getBF(0);
  @$pb.TagNumber(1)
  set rk($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRk() => $_has(0);
  @$pb.TagNumber(1)
  void clearRk() => $_clearField(1);
}

class PasskeyRegistrationExtensionsClientOutputs extends $pb.GeneratedMessage {
  factory PasskeyRegistrationExtensionsClientOutputs({
    $core.bool? appid,
    PasskeyRegistrationCredProps? credProps,
    $core.bool? hmacSecret,
    PasskeyCredentialProtectionPolicy? credProtect,
    $core.int? minPinLength,
  }) {
    final result = create();
    if (appid != null) result.appid = appid;
    if (credProps != null) result.credProps = credProps;
    if (hmacSecret != null) result.hmacSecret = hmacSecret;
    if (credProtect != null) result.credProtect = credProtect;
    if (minPinLength != null) result.minPinLength = minPinLength;
    return result;
  }

  PasskeyRegistrationExtensionsClientOutputs._();

  factory PasskeyRegistrationExtensionsClientOutputs.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegistrationExtensionsClientOutputs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyRegistrationExtensionsClientOutputs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'appid')
    ..aOM<PasskeyRegistrationCredProps>(2, _omitFieldNames ? '' : 'credProps',
        subBuilder: PasskeyRegistrationCredProps.create)
    ..aOB(3, _omitFieldNames ? '' : 'hmacSecret')
    ..aE<PasskeyCredentialProtectionPolicy>(
        4, _omitFieldNames ? '' : 'credProtect',
        enumValues: PasskeyCredentialProtectionPolicy.values)
    ..aI(5, _omitFieldNames ? '' : 'minPinLength',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationExtensionsClientOutputs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationExtensionsClientOutputs copyWith(
          void Function(PasskeyRegistrationExtensionsClientOutputs) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyRegistrationExtensionsClientOutputs))
          as PasskeyRegistrationExtensionsClientOutputs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationExtensionsClientOutputs create() =>
      PasskeyRegistrationExtensionsClientOutputs._();
  @$core.override
  PasskeyRegistrationExtensionsClientOutputs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationExtensionsClientOutputs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyRegistrationExtensionsClientOutputs>(create);
  static PasskeyRegistrationExtensionsClientOutputs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get appid => $_getBF(0);
  @$pb.TagNumber(1)
  set appid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppid() => $_clearField(1);

  @$pb.TagNumber(2)
  PasskeyRegistrationCredProps get credProps => $_getN(1);
  @$pb.TagNumber(2)
  set credProps(PasskeyRegistrationCredProps value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCredProps() => $_has(1);
  @$pb.TagNumber(2)
  void clearCredProps() => $_clearField(2);
  @$pb.TagNumber(2)
  PasskeyRegistrationCredProps ensureCredProps() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get hmacSecret => $_getBF(2);
  @$pb.TagNumber(3)
  set hmacSecret($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHmacSecret() => $_has(2);
  @$pb.TagNumber(3)
  void clearHmacSecret() => $_clearField(3);

  @$pb.TagNumber(4)
  PasskeyCredentialProtectionPolicy get credProtect => $_getN(3);
  @$pb.TagNumber(4)
  set credProtect(PasskeyCredentialProtectionPolicy value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCredProtect() => $_has(3);
  @$pb.TagNumber(4)
  void clearCredProtect() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get minPinLength => $_getIZ(4);
  @$pb.TagNumber(5)
  set minPinLength($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinPinLength() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinPinLength() => $_clearField(5);
}

class PasskeyAuthenticatorAssertionResponse extends $pb.GeneratedMessage {
  factory PasskeyAuthenticatorAssertionResponse({
    $core.List<$core.int>? authenticatorData,
    $core.List<$core.int>? clientDataJson,
    $core.List<$core.int>? signature,
    $core.List<$core.int>? userHandle,
  }) {
    final result = create();
    if (authenticatorData != null) result.authenticatorData = authenticatorData;
    if (clientDataJson != null) result.clientDataJson = clientDataJson;
    if (signature != null) result.signature = signature;
    if (userHandle != null) result.userHandle = userHandle;
    return result;
  }

  PasskeyAuthenticatorAssertionResponse._();

  factory PasskeyAuthenticatorAssertionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyAuthenticatorAssertionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyAuthenticatorAssertionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'authenticatorData', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'clientDataJSON', $pb.PbFieldType.OY,
        protoName: 'client_data_json')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'userHandle', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticatorAssertionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticatorAssertionResponse copyWith(
          void Function(PasskeyAuthenticatorAssertionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyAuthenticatorAssertionResponse))
          as PasskeyAuthenticatorAssertionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticatorAssertionResponse create() =>
      PasskeyAuthenticatorAssertionResponse._();
  @$core.override
  PasskeyAuthenticatorAssertionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticatorAssertionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyAuthenticatorAssertionResponse>(create);
  static PasskeyAuthenticatorAssertionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get authenticatorData => $_getN(0);
  @$pb.TagNumber(1)
  set authenticatorData($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthenticatorData() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthenticatorData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get clientDataJson => $_getN(1);
  @$pb.TagNumber(2)
  set clientDataJson($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientDataJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientDataJson() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get signature => $_getN(2);
  @$pb.TagNumber(3)
  set signature($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignature() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignature() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get userHandle => $_getN(3);
  @$pb.TagNumber(4)
  set userHandle($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserHandle() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserHandle() => $_clearField(4);
}

class PasskeyAuthenticatorAttestationResponse extends $pb.GeneratedMessage {
  factory PasskeyAuthenticatorAttestationResponse({
    $core.List<$core.int>? attestationObject,
    $core.List<$core.int>? clientDataJson,
    $core.Iterable<PasskeyAuthenticatorTransport>? transports,
  }) {
    final result = create();
    if (attestationObject != null) result.attestationObject = attestationObject;
    if (clientDataJson != null) result.clientDataJson = clientDataJson;
    if (transports != null) result.transports.addAll(transports);
    return result;
  }

  PasskeyAuthenticatorAttestationResponse._();

  factory PasskeyAuthenticatorAttestationResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyAuthenticatorAttestationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyAuthenticatorAttestationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'attestationObject', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'clientDataJSON', $pb.PbFieldType.OY,
        protoName: 'client_data_json')
    ..pc<PasskeyAuthenticatorTransport>(
        3, _omitFieldNames ? '' : 'transports', $pb.PbFieldType.KE,
        valueOf: PasskeyAuthenticatorTransport.valueOf,
        enumValues: PasskeyAuthenticatorTransport.values,
        defaultEnumValue: PasskeyAuthenticatorTransport
            .PASSKEY_AUTHENTICATOR_TRANSPORT_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticatorAttestationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticatorAttestationResponse copyWith(
          void Function(PasskeyAuthenticatorAttestationResponse) updates) =>
      super.copyWith((message) =>
              updates(message as PasskeyAuthenticatorAttestationResponse))
          as PasskeyAuthenticatorAttestationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticatorAttestationResponse create() =>
      PasskeyAuthenticatorAttestationResponse._();
  @$core.override
  PasskeyAuthenticatorAttestationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticatorAttestationResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PasskeyAuthenticatorAttestationResponse>(create);
  static PasskeyAuthenticatorAttestationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get attestationObject => $_getN(0);
  @$pb.TagNumber(1)
  set attestationObject($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAttestationObject() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttestationObject() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get clientDataJson => $_getN(1);
  @$pb.TagNumber(2)
  set clientDataJson($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientDataJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientDataJson() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<PasskeyAuthenticatorTransport> get transports => $_getList(2);
}

class PasskeyAuthenticationCredential extends $pb.GeneratedMessage {
  factory PasskeyAuthenticationCredential({
    $core.String? id,
    $core.List<$core.int>? rawId,
    PasskeyAuthenticatorAssertionResponse? response,
    PasskeyAuthenticationExtensionsClientOutputs? extensions,
    PasskeyPublicKeyCredentialType? type,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (rawId != null) result.rawId = rawId;
    if (response != null) result.response = response;
    if (extensions != null) result.extensions = extensions;
    if (type != null) result.type = type;
    return result;
  }

  PasskeyAuthenticationCredential._();

  factory PasskeyAuthenticationCredential.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyAuthenticationCredential.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyAuthenticationCredential',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'rawId', $pb.PbFieldType.OY)
    ..aOM<PasskeyAuthenticatorAssertionResponse>(
        3, _omitFieldNames ? '' : 'response',
        subBuilder: PasskeyAuthenticatorAssertionResponse.create)
    ..aOM<PasskeyAuthenticationExtensionsClientOutputs>(
        4, _omitFieldNames ? '' : 'extensions',
        subBuilder: PasskeyAuthenticationExtensionsClientOutputs.create)
    ..aE<PasskeyPublicKeyCredentialType>(5, _omitFieldNames ? '' : 'type',
        enumValues: PasskeyPublicKeyCredentialType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticationCredential clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyAuthenticationCredential copyWith(
          void Function(PasskeyAuthenticationCredential) updates) =>
      super.copyWith(
              (message) => updates(message as PasskeyAuthenticationCredential))
          as PasskeyAuthenticationCredential;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticationCredential create() =>
      PasskeyAuthenticationCredential._();
  @$core.override
  PasskeyAuthenticationCredential createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyAuthenticationCredential getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyAuthenticationCredential>(
          create);
  static PasskeyAuthenticationCredential? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get rawId => $_getN(1);
  @$pb.TagNumber(2)
  set rawId($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRawId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRawId() => $_clearField(2);

  @$pb.TagNumber(3)
  PasskeyAuthenticatorAssertionResponse get response => $_getN(2);
  @$pb.TagNumber(3)
  set response(PasskeyAuthenticatorAssertionResponse value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponse() => $_clearField(3);
  @$pb.TagNumber(3)
  PasskeyAuthenticatorAssertionResponse ensureResponse() => $_ensure(2);

  @$pb.TagNumber(4)
  PasskeyAuthenticationExtensionsClientOutputs get extensions => $_getN(3);
  @$pb.TagNumber(4)
  set extensions(PasskeyAuthenticationExtensionsClientOutputs value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasExtensions() => $_has(3);
  @$pb.TagNumber(4)
  void clearExtensions() => $_clearField(4);
  @$pb.TagNumber(4)
  PasskeyAuthenticationExtensionsClientOutputs ensureExtensions() =>
      $_ensure(3);

  @$pb.TagNumber(5)
  PasskeyPublicKeyCredentialType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(PasskeyPublicKeyCredentialType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);
}

class PasskeyRegistrationCredential extends $pb.GeneratedMessage {
  factory PasskeyRegistrationCredential({
    $core.String? id,
    $core.List<$core.int>? rawId,
    PasskeyAuthenticatorAttestationResponse? response,
    PasskeyPublicKeyCredentialType? type,
    PasskeyRegistrationExtensionsClientOutputs? extensions,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (rawId != null) result.rawId = rawId;
    if (response != null) result.response = response;
    if (type != null) result.type = type;
    if (extensions != null) result.extensions = extensions;
    return result;
  }

  PasskeyRegistrationCredential._();

  factory PasskeyRegistrationCredential.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PasskeyRegistrationCredential.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PasskeyRegistrationCredential',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'rawId', $pb.PbFieldType.OY)
    ..aOM<PasskeyAuthenticatorAttestationResponse>(
        3, _omitFieldNames ? '' : 'response',
        subBuilder: PasskeyAuthenticatorAttestationResponse.create)
    ..aE<PasskeyPublicKeyCredentialType>(4, _omitFieldNames ? '' : 'type',
        enumValues: PasskeyPublicKeyCredentialType.values)
    ..aOM<PasskeyRegistrationExtensionsClientOutputs>(
        5, _omitFieldNames ? '' : 'extensions',
        subBuilder: PasskeyRegistrationExtensionsClientOutputs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationCredential clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PasskeyRegistrationCredential copyWith(
          void Function(PasskeyRegistrationCredential) updates) =>
      super.copyWith(
              (message) => updates(message as PasskeyRegistrationCredential))
          as PasskeyRegistrationCredential;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationCredential create() =>
      PasskeyRegistrationCredential._();
  @$core.override
  PasskeyRegistrationCredential createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PasskeyRegistrationCredential getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PasskeyRegistrationCredential>(create);
  static PasskeyRegistrationCredential? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get rawId => $_getN(1);
  @$pb.TagNumber(2)
  set rawId($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRawId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRawId() => $_clearField(2);

  @$pb.TagNumber(3)
  PasskeyAuthenticatorAttestationResponse get response => $_getN(2);
  @$pb.TagNumber(3)
  set response(PasskeyAuthenticatorAttestationResponse value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponse() => $_clearField(3);
  @$pb.TagNumber(3)
  PasskeyAuthenticatorAttestationResponse ensureResponse() => $_ensure(2);

  @$pb.TagNumber(4)
  PasskeyPublicKeyCredentialType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(PasskeyPublicKeyCredentialType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  PasskeyRegistrationExtensionsClientOutputs get extensions => $_getN(4);
  @$pb.TagNumber(5)
  set extensions(PasskeyRegistrationExtensionsClientOutputs value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExtensions() => $_has(4);
  @$pb.TagNumber(5)
  void clearExtensions() => $_clearField(5);
  @$pb.TagNumber(5)
  PasskeyRegistrationExtensionsClientOutputs ensureExtensions() => $_ensure(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
