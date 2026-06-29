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

import 'package:protobuf/protobuf.dart' as $pb;

class PasskeyUserVerificationRequirement extends $pb.ProtobufEnum {
  static const PasskeyUserVerificationRequirement
      PASSKEY_USER_VERIFICATION_REQUIREMENT_UNSPECIFIED =
      PasskeyUserVerificationRequirement._(
          0,
          _omitEnumNames
              ? ''
              : 'PASSKEY_USER_VERIFICATION_REQUIREMENT_UNSPECIFIED');
  static const PasskeyUserVerificationRequirement
      PASSKEY_USER_VERIFICATION_REQUIREMENT_REQUIRED =
      PasskeyUserVerificationRequirement._(
          1,
          _omitEnumNames
              ? ''
              : 'PASSKEY_USER_VERIFICATION_REQUIREMENT_REQUIRED');
  static const PasskeyUserVerificationRequirement
      PASSKEY_USER_VERIFICATION_REQUIREMENT_PREFERRED =
      PasskeyUserVerificationRequirement._(
          2,
          _omitEnumNames
              ? ''
              : 'PASSKEY_USER_VERIFICATION_REQUIREMENT_PREFERRED');
  static const PasskeyUserVerificationRequirement
      PASSKEY_USER_VERIFICATION_REQUIREMENT_DISCOURAGED =
      PasskeyUserVerificationRequirement._(
          3,
          _omitEnumNames
              ? ''
              : 'PASSKEY_USER_VERIFICATION_REQUIREMENT_DISCOURAGED');

  static const $core.List<PasskeyUserVerificationRequirement> values =
      <PasskeyUserVerificationRequirement>[
    PASSKEY_USER_VERIFICATION_REQUIREMENT_UNSPECIFIED,
    PASSKEY_USER_VERIFICATION_REQUIREMENT_REQUIRED,
    PASSKEY_USER_VERIFICATION_REQUIREMENT_PREFERRED,
    PASSKEY_USER_VERIFICATION_REQUIREMENT_DISCOURAGED,
  ];

  static final $core.List<PasskeyUserVerificationRequirement?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PasskeyUserVerificationRequirement? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyUserVerificationRequirement._(super.value, super.name);
}

class PasskeyAttestationConveyancePreference extends $pb.ProtobufEnum {
  static const PasskeyAttestationConveyancePreference
      PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_UNSPECIFIED =
      PasskeyAttestationConveyancePreference._(
          0,
          _omitEnumNames
              ? ''
              : 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_UNSPECIFIED');
  static const PasskeyAttestationConveyancePreference
      PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_NONE =
      PasskeyAttestationConveyancePreference._(
          1,
          _omitEnumNames
              ? ''
              : 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_NONE');
  static const PasskeyAttestationConveyancePreference
      PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_INDIRECT =
      PasskeyAttestationConveyancePreference._(
          2,
          _omitEnumNames
              ? ''
              : 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_INDIRECT');
  static const PasskeyAttestationConveyancePreference
      PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_DIRECT =
      PasskeyAttestationConveyancePreference._(
          3,
          _omitEnumNames
              ? ''
              : 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_DIRECT');

  static const $core.List<PasskeyAttestationConveyancePreference> values =
      <PasskeyAttestationConveyancePreference>[
    PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_UNSPECIFIED,
    PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_NONE,
    PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_INDIRECT,
    PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_DIRECT,
  ];

  static final $core.List<PasskeyAttestationConveyancePreference?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PasskeyAttestationConveyancePreference? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyAttestationConveyancePreference._(super.value, super.name);
}

class PasskeyAuthenticatorTransport extends $pb.ProtobufEnum {
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_UNSPECIFIED =
      PasskeyAuthenticatorTransport._(0,
          _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_UNSPECIFIED');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_USB = PasskeyAuthenticatorTransport._(
          1, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_USB');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_NFC = PasskeyAuthenticatorTransport._(
          2, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_NFC');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_BLE = PasskeyAuthenticatorTransport._(
          3, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_BLE');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_INTERNAL =
      PasskeyAuthenticatorTransport._(
          4, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_INTERNAL');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_HYBRID = PasskeyAuthenticatorTransport._(
          5, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_HYBRID');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_TEST = PasskeyAuthenticatorTransport._(
          6, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_TEST');
  static const PasskeyAuthenticatorTransport
      PASSKEY_AUTHENTICATOR_TRANSPORT_UNKNOWN = PasskeyAuthenticatorTransport._(
          7, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_TRANSPORT_UNKNOWN');

  static const $core.List<PasskeyAuthenticatorTransport> values =
      <PasskeyAuthenticatorTransport>[
    PASSKEY_AUTHENTICATOR_TRANSPORT_UNSPECIFIED,
    PASSKEY_AUTHENTICATOR_TRANSPORT_USB,
    PASSKEY_AUTHENTICATOR_TRANSPORT_NFC,
    PASSKEY_AUTHENTICATOR_TRANSPORT_BLE,
    PASSKEY_AUTHENTICATOR_TRANSPORT_INTERNAL,
    PASSKEY_AUTHENTICATOR_TRANSPORT_HYBRID,
    PASSKEY_AUTHENTICATOR_TRANSPORT_TEST,
    PASSKEY_AUTHENTICATOR_TRANSPORT_UNKNOWN,
  ];

  static final $core.List<PasskeyAuthenticatorTransport?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static PasskeyAuthenticatorTransport? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyAuthenticatorTransport._(super.value, super.name);
}

class PasskeyAuthenticatorAttachment extends $pb.ProtobufEnum {
  static const PasskeyAuthenticatorAttachment
      PASSKEY_AUTHENTICATOR_ATTACHMENT_UNSPECIFIED =
      PasskeyAuthenticatorAttachment._(0,
          _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_ATTACHMENT_UNSPECIFIED');
  static const PasskeyAuthenticatorAttachment
      PASSKEY_AUTHENTICATOR_ATTACHMENT_PLATFORM =
      PasskeyAuthenticatorAttachment._(
          1, _omitEnumNames ? '' : 'PASSKEY_AUTHENTICATOR_ATTACHMENT_PLATFORM');
  static const PasskeyAuthenticatorAttachment
      PASSKEY_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM =
      PasskeyAuthenticatorAttachment._(
          2,
          _omitEnumNames
              ? ''
              : 'PASSKEY_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM');

  static const $core.List<PasskeyAuthenticatorAttachment> values =
      <PasskeyAuthenticatorAttachment>[
    PASSKEY_AUTHENTICATOR_ATTACHMENT_UNSPECIFIED,
    PASSKEY_AUTHENTICATOR_ATTACHMENT_PLATFORM,
    PASSKEY_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM,
  ];

  static final $core.List<PasskeyAuthenticatorAttachment?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PasskeyAuthenticatorAttachment? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyAuthenticatorAttachment._(super.value, super.name);
}

class PasskeyResidentKeyRequirement extends $pb.ProtobufEnum {
  static const PasskeyResidentKeyRequirement
      PASSKEY_RESIDENT_KEY_REQUIREMENT_UNSPECIFIED =
      PasskeyResidentKeyRequirement._(0,
          _omitEnumNames ? '' : 'PASSKEY_RESIDENT_KEY_REQUIREMENT_UNSPECIFIED');
  static const PasskeyResidentKeyRequirement
      PASSKEY_RESIDENT_KEY_REQUIREMENT_DISCOURAGED =
      PasskeyResidentKeyRequirement._(1,
          _omitEnumNames ? '' : 'PASSKEY_RESIDENT_KEY_REQUIREMENT_DISCOURAGED');
  static const PasskeyResidentKeyRequirement
      PASSKEY_RESIDENT_KEY_REQUIREMENT_PREFERRED =
      PasskeyResidentKeyRequirement._(2,
          _omitEnumNames ? '' : 'PASSKEY_RESIDENT_KEY_REQUIREMENT_PREFERRED');
  static const PasskeyResidentKeyRequirement
      PASSKEY_RESIDENT_KEY_REQUIREMENT_REQUIRED =
      PasskeyResidentKeyRequirement._(
          3, _omitEnumNames ? '' : 'PASSKEY_RESIDENT_KEY_REQUIREMENT_REQUIRED');

  static const $core.List<PasskeyResidentKeyRequirement> values =
      <PasskeyResidentKeyRequirement>[
    PASSKEY_RESIDENT_KEY_REQUIREMENT_UNSPECIFIED,
    PASSKEY_RESIDENT_KEY_REQUIREMENT_DISCOURAGED,
    PASSKEY_RESIDENT_KEY_REQUIREMENT_PREFERRED,
    PASSKEY_RESIDENT_KEY_REQUIREMENT_REQUIRED,
  ];

  static final $core.List<PasskeyResidentKeyRequirement?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PasskeyResidentKeyRequirement? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyResidentKeyRequirement._(super.value, super.name);
}

class PasskeyPublicKeyCredentialHint extends $pb.ProtobufEnum {
  static const PasskeyPublicKeyCredentialHint
      PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_UNSPECIFIED =
      PasskeyPublicKeyCredentialHint._(
          0,
          _omitEnumNames
              ? ''
              : 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_UNSPECIFIED');
  static const PasskeyPublicKeyCredentialHint
      PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_SECURITY_KEY =
      PasskeyPublicKeyCredentialHint._(
          1,
          _omitEnumNames
              ? ''
              : 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_SECURITY_KEY');
  static const PasskeyPublicKeyCredentialHint
      PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_CLIENT_DEVICE =
      PasskeyPublicKeyCredentialHint._(
          2,
          _omitEnumNames
              ? ''
              : 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_CLIENT_DEVICE');
  static const PasskeyPublicKeyCredentialHint
      PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_HYBRID =
      PasskeyPublicKeyCredentialHint._(
          3, _omitEnumNames ? '' : 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_HYBRID');

  static const $core.List<PasskeyPublicKeyCredentialHint> values =
      <PasskeyPublicKeyCredentialHint>[
    PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_UNSPECIFIED,
    PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_SECURITY_KEY,
    PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_CLIENT_DEVICE,
    PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_HYBRID,
  ];

  static final $core.List<PasskeyPublicKeyCredentialHint?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PasskeyPublicKeyCredentialHint? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyPublicKeyCredentialHint._(super.value, super.name);
}

class PasskeyAttestationFormat extends $pb.ProtobufEnum {
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_UNSPECIFIED =
      PasskeyAttestationFormat._(
          0, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_UNSPECIFIED');
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_PACKED =
      PasskeyAttestationFormat._(
          1, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_PACKED');
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_TPM =
      PasskeyAttestationFormat._(
          2, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_TPM');
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_ANDROID_KEY =
      PasskeyAttestationFormat._(
          3, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_ANDROID_KEY');
  static const PasskeyAttestationFormat
      PASSKEY_ATTESTATION_FORMAT_ANDROID_SAFETYNET = PasskeyAttestationFormat._(
          4,
          _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_ANDROID_SAFETYNET');
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_FIDO_U2F =
      PasskeyAttestationFormat._(
          5, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_FIDO_U2F');
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_APPLE =
      PasskeyAttestationFormat._(
          6, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_APPLE');
  static const PasskeyAttestationFormat PASSKEY_ATTESTATION_FORMAT_NONE =
      PasskeyAttestationFormat._(
          7, _omitEnumNames ? '' : 'PASSKEY_ATTESTATION_FORMAT_NONE');

  static const $core.List<PasskeyAttestationFormat> values =
      <PasskeyAttestationFormat>[
    PASSKEY_ATTESTATION_FORMAT_UNSPECIFIED,
    PASSKEY_ATTESTATION_FORMAT_PACKED,
    PASSKEY_ATTESTATION_FORMAT_TPM,
    PASSKEY_ATTESTATION_FORMAT_ANDROID_KEY,
    PASSKEY_ATTESTATION_FORMAT_ANDROID_SAFETYNET,
    PASSKEY_ATTESTATION_FORMAT_FIDO_U2F,
    PASSKEY_ATTESTATION_FORMAT_APPLE,
    PASSKEY_ATTESTATION_FORMAT_NONE,
  ];

  static final $core.List<PasskeyAttestationFormat?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static PasskeyAttestationFormat? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyAttestationFormat._(super.value, super.name);
}

class PasskeyCredentialProtectionPolicy extends $pb.ProtobufEnum {
  static const PasskeyCredentialProtectionPolicy
      PASSKEY_CREDENTIAL_PROTECTION_POLICY_UNSPECIFIED =
      PasskeyCredentialProtectionPolicy._(
          0,
          _omitEnumNames
              ? ''
              : 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_UNSPECIFIED');
  static const PasskeyCredentialProtectionPolicy
      PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL =
      PasskeyCredentialProtectionPolicy._(
          1,
          _omitEnumNames
              ? ''
              : 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL');
  static const PasskeyCredentialProtectionPolicy
      PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL_WITH_CREDENTIAL_ID_LIST =
      PasskeyCredentialProtectionPolicy._(
          2,
          _omitEnumNames
              ? ''
              : 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL_WITH_CREDENTIAL_ID_LIST');
  static const PasskeyCredentialProtectionPolicy
      PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED =
      PasskeyCredentialProtectionPolicy._(
          3,
          _omitEnumNames
              ? ''
              : 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED');

  static const $core.List<PasskeyCredentialProtectionPolicy> values =
      <PasskeyCredentialProtectionPolicy>[
    PASSKEY_CREDENTIAL_PROTECTION_POLICY_UNSPECIFIED,
    PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL,
    PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL_WITH_CREDENTIAL_ID_LIST,
    PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED,
  ];

  static final $core.List<PasskeyCredentialProtectionPolicy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PasskeyCredentialProtectionPolicy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyCredentialProtectionPolicy._(super.value, super.name);
}

class PasskeyMediationRequirement extends $pb.ProtobufEnum {
  static const PasskeyMediationRequirement
      PASSKEY_MEDIATION_REQUIREMENT_UNSPECIFIED = PasskeyMediationRequirement._(
          0, _omitEnumNames ? '' : 'PASSKEY_MEDIATION_REQUIREMENT_UNSPECIFIED');
  static const PasskeyMediationRequirement
      PASSKEY_MEDIATION_REQUIREMENT_CONDITIONAL = PasskeyMediationRequirement._(
          1, _omitEnumNames ? '' : 'PASSKEY_MEDIATION_REQUIREMENT_CONDITIONAL');

  static const $core.List<PasskeyMediationRequirement> values =
      <PasskeyMediationRequirement>[
    PASSKEY_MEDIATION_REQUIREMENT_UNSPECIFIED,
    PASSKEY_MEDIATION_REQUIREMENT_CONDITIONAL,
  ];

  static final $core.List<PasskeyMediationRequirement?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PasskeyMediationRequirement? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyMediationRequirement._(super.value, super.name);
}

class PasskeyPublicKeyCredentialType extends $pb.ProtobufEnum {
  static const PasskeyPublicKeyCredentialType
      PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_UNSPECIFIED =
      PasskeyPublicKeyCredentialType._(
          0,
          _omitEnumNames
              ? ''
              : 'PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_UNSPECIFIED');
  static const PasskeyPublicKeyCredentialType
      PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY =
      PasskeyPublicKeyCredentialType._(
          1,
          _omitEnumNames
              ? ''
              : 'PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY');

  static const $core.List<PasskeyPublicKeyCredentialType> values =
      <PasskeyPublicKeyCredentialType>[
    PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_UNSPECIFIED,
    PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY,
  ];

  static final $core.List<PasskeyPublicKeyCredentialType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PasskeyPublicKeyCredentialType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PasskeyPublicKeyCredentialType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
