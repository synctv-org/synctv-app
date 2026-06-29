// This is a generated file - do not edit.
//
// Generated from proto/passkey.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use passkeyUserVerificationRequirementDescriptor instead')
const PasskeyUserVerificationRequirement$json = {
  '1': 'PasskeyUserVerificationRequirement',
  '2': [
    {'1': 'PASSKEY_USER_VERIFICATION_REQUIREMENT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_USER_VERIFICATION_REQUIREMENT_REQUIRED', '2': 1},
    {'1': 'PASSKEY_USER_VERIFICATION_REQUIREMENT_PREFERRED', '2': 2},
    {'1': 'PASSKEY_USER_VERIFICATION_REQUIREMENT_DISCOURAGED', '2': 3},
  ],
};

/// Descriptor for `PasskeyUserVerificationRequirement`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyUserVerificationRequirementDescriptor =
    $convert.base64Decode(
        'CiJQYXNza2V5VXNlclZlcmlmaWNhdGlvblJlcXVpcmVtZW50EjUKMVBBU1NLRVlfVVNFUl9WRV'
        'JJRklDQVRJT05fUkVRVUlSRU1FTlRfVU5TUEVDSUZJRUQQABIyCi5QQVNTS0VZX1VTRVJfVkVS'
        'SUZJQ0FUSU9OX1JFUVVJUkVNRU5UX1JFUVVJUkVEEAESMwovUEFTU0tFWV9VU0VSX1ZFUklGSU'
        'NBVElPTl9SRVFVSVJFTUVOVF9QUkVGRVJSRUQQAhI1CjFQQVNTS0VZX1VTRVJfVkVSSUZJQ0FU'
        'SU9OX1JFUVVJUkVNRU5UX0RJU0NPVVJBR0VEEAM=');

@$core
    .Deprecated('Use passkeyAttestationConveyancePreferenceDescriptor instead')
const PasskeyAttestationConveyancePreference$json = {
  '1': 'PasskeyAttestationConveyancePreference',
  '2': [
    {'1': 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_NONE', '2': 1},
    {'1': 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_INDIRECT', '2': 2},
    {'1': 'PASSKEY_ATTESTATION_CONVEYANCE_PREFERENCE_DIRECT', '2': 3},
  ],
};

/// Descriptor for `PasskeyAttestationConveyancePreference`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyAttestationConveyancePreferenceDescriptor =
    $convert.base64Decode(
        'CiZQYXNza2V5QXR0ZXN0YXRpb25Db252ZXlhbmNlUHJlZmVyZW5jZRI5CjVQQVNTS0VZX0FUVE'
        'VTVEFUSU9OX0NPTlZFWUFOQ0VfUFJFRkVSRU5DRV9VTlNQRUNJRklFRBAAEjIKLlBBU1NLRVlf'
        'QVRURVNUQVRJT05fQ09OVkVZQU5DRV9QUkVGRVJFTkNFX05PTkUQARI2CjJQQVNTS0VZX0FUVE'
        'VTVEFUSU9OX0NPTlZFWUFOQ0VfUFJFRkVSRU5DRV9JTkRJUkVDVBACEjQKMFBBU1NLRVlfQVRU'
        'RVNUQVRJT05fQ09OVkVZQU5DRV9QUkVGRVJFTkNFX0RJUkVDVBAD');

@$core.Deprecated('Use passkeyAuthenticatorTransportDescriptor instead')
const PasskeyAuthenticatorTransport$json = {
  '1': 'PasskeyAuthenticatorTransport',
  '2': [
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_USB', '2': 1},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_NFC', '2': 2},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_BLE', '2': 3},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_INTERNAL', '2': 4},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_HYBRID', '2': 5},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_TEST', '2': 6},
    {'1': 'PASSKEY_AUTHENTICATOR_TRANSPORT_UNKNOWN', '2': 7},
  ],
};

/// Descriptor for `PasskeyAuthenticatorTransport`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticatorTransportDescriptor = $convert.base64Decode(
    'Ch1QYXNza2V5QXV0aGVudGljYXRvclRyYW5zcG9ydBIvCitQQVNTS0VZX0FVVEhFTlRJQ0FUT1'
    'JfVFJBTlNQT1JUX1VOU1BFQ0lGSUVEEAASJwojUEFTU0tFWV9BVVRIRU5USUNBVE9SX1RSQU5T'
    'UE9SVF9VU0IQARInCiNQQVNTS0VZX0FVVEhFTlRJQ0FUT1JfVFJBTlNQT1JUX05GQxACEicKI1'
    'BBU1NLRVlfQVVUSEVOVElDQVRPUl9UUkFOU1BPUlRfQkxFEAMSLAooUEFTU0tFWV9BVVRIRU5U'
    'SUNBVE9SX1RSQU5TUE9SVF9JTlRFUk5BTBAEEioKJlBBU1NLRVlfQVVUSEVOVElDQVRPUl9UUk'
    'FOU1BPUlRfSFlCUklEEAUSKAokUEFTU0tFWV9BVVRIRU5USUNBVE9SX1RSQU5TUE9SVF9URVNU'
    'EAYSKwonUEFTU0tFWV9BVVRIRU5USUNBVE9SX1RSQU5TUE9SVF9VTktOT1dOEAc=');

@$core.Deprecated('Use passkeyAuthenticatorAttachmentDescriptor instead')
const PasskeyAuthenticatorAttachment$json = {
  '1': 'PasskeyAuthenticatorAttachment',
  '2': [
    {'1': 'PASSKEY_AUTHENTICATOR_ATTACHMENT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_AUTHENTICATOR_ATTACHMENT_PLATFORM', '2': 1},
    {'1': 'PASSKEY_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM', '2': 2},
  ],
};

/// Descriptor for `PasskeyAuthenticatorAttachment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticatorAttachmentDescriptor =
    $convert.base64Decode(
        'Ch5QYXNza2V5QXV0aGVudGljYXRvckF0dGFjaG1lbnQSMAosUEFTU0tFWV9BVVRIRU5USUNBVE'
        '9SX0FUVEFDSE1FTlRfVU5TUEVDSUZJRUQQABItCilQQVNTS0VZX0FVVEhFTlRJQ0FUT1JfQVRU'
        'QUNITUVOVF9QTEFURk9STRABEjMKL1BBU1NLRVlfQVVUSEVOVElDQVRPUl9BVFRBQ0hNRU5UX0'
        'NST1NTX1BMQVRGT1JNEAI=');

@$core.Deprecated('Use passkeyResidentKeyRequirementDescriptor instead')
const PasskeyResidentKeyRequirement$json = {
  '1': 'PasskeyResidentKeyRequirement',
  '2': [
    {'1': 'PASSKEY_RESIDENT_KEY_REQUIREMENT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_RESIDENT_KEY_REQUIREMENT_DISCOURAGED', '2': 1},
    {'1': 'PASSKEY_RESIDENT_KEY_REQUIREMENT_PREFERRED', '2': 2},
    {'1': 'PASSKEY_RESIDENT_KEY_REQUIREMENT_REQUIRED', '2': 3},
  ],
};

/// Descriptor for `PasskeyResidentKeyRequirement`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyResidentKeyRequirementDescriptor = $convert.base64Decode(
    'Ch1QYXNza2V5UmVzaWRlbnRLZXlSZXF1aXJlbWVudBIwCixQQVNTS0VZX1JFU0lERU5UX0tFWV'
    '9SRVFVSVJFTUVOVF9VTlNQRUNJRklFRBAAEjAKLFBBU1NLRVlfUkVTSURFTlRfS0VZX1JFUVVJ'
    'UkVNRU5UX0RJU0NPVVJBR0VEEAESLgoqUEFTU0tFWV9SRVNJREVOVF9LRVlfUkVRVUlSRU1FTl'
    'RfUFJFRkVSUkVEEAISLQopUEFTU0tFWV9SRVNJREVOVF9LRVlfUkVRVUlSRU1FTlRfUkVRVUlS'
    'RUQQAw==');

@$core.Deprecated('Use passkeyPublicKeyCredentialHintDescriptor instead')
const PasskeyPublicKeyCredentialHint$json = {
  '1': 'PasskeyPublicKeyCredentialHint',
  '2': [
    {'1': 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_SECURITY_KEY', '2': 1},
    {'1': 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_CLIENT_DEVICE', '2': 2},
    {'1': 'PASSKEY_PUBLIC_KEY_CREDENTIAL_HINT_HYBRID', '2': 3},
  ],
};

/// Descriptor for `PasskeyPublicKeyCredentialHint`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyPublicKeyCredentialHintDescriptor = $convert.base64Decode(
    'Ch5QYXNza2V5UHVibGljS2V5Q3JlZGVudGlhbEhpbnQSMgouUEFTU0tFWV9QVUJMSUNfS0VZX0'
    'NSRURFTlRJQUxfSElOVF9VTlNQRUNJRklFRBAAEjMKL1BBU1NLRVlfUFVCTElDX0tFWV9DUkVE'
    'RU5USUFMX0hJTlRfU0VDVVJJVFlfS0VZEAESNAowUEFTU0tFWV9QVUJMSUNfS0VZX0NSRURFTl'
    'RJQUxfSElOVF9DTElFTlRfREVWSUNFEAISLQopUEFTU0tFWV9QVUJMSUNfS0VZX0NSRURFTlRJ'
    'QUxfSElOVF9IWUJSSUQQAw==');

@$core.Deprecated('Use passkeyAttestationFormatDescriptor instead')
const PasskeyAttestationFormat$json = {
  '1': 'PasskeyAttestationFormat',
  '2': [
    {'1': 'PASSKEY_ATTESTATION_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_PACKED', '2': 1},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_TPM', '2': 2},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_ANDROID_KEY', '2': 3},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_ANDROID_SAFETYNET', '2': 4},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_FIDO_U2F', '2': 5},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_APPLE', '2': 6},
    {'1': 'PASSKEY_ATTESTATION_FORMAT_NONE', '2': 7},
  ],
};

/// Descriptor for `PasskeyAttestationFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyAttestationFormatDescriptor = $convert.base64Decode(
    'ChhQYXNza2V5QXR0ZXN0YXRpb25Gb3JtYXQSKgomUEFTU0tFWV9BVFRFU1RBVElPTl9GT1JNQV'
    'RfVU5TUEVDSUZJRUQQABIlCiFQQVNTS0VZX0FUVEVTVEFUSU9OX0ZPUk1BVF9QQUNLRUQQARIi'
    'Ch5QQVNTS0VZX0FUVEVTVEFUSU9OX0ZPUk1BVF9UUE0QAhIqCiZQQVNTS0VZX0FUVEVTVEFUSU'
    '9OX0ZPUk1BVF9BTkRST0lEX0tFWRADEjAKLFBBU1NLRVlfQVRURVNUQVRJT05fRk9STUFUX0FO'
    'RFJPSURfU0FGRVRZTkVUEAQSJwojUEFTU0tFWV9BVFRFU1RBVElPTl9GT1JNQVRfRklET19VMk'
    'YQBRIkCiBQQVNTS0VZX0FUVEVTVEFUSU9OX0ZPUk1BVF9BUFBMRRAGEiMKH1BBU1NLRVlfQVRU'
    'RVNUQVRJT05fRk9STUFUX05PTkUQBw==');

@$core.Deprecated('Use passkeyCredentialProtectionPolicyDescriptor instead')
const PasskeyCredentialProtectionPolicy$json = {
  '1': 'PasskeyCredentialProtectionPolicy',
  '2': [
    {'1': 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_UNSPECIFIED', '2': 0},
    {
      '1': 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL',
      '2': 1
    },
    {
      '1':
          'PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_OPTIONAL_WITH_CREDENTIAL_ID_LIST',
      '2': 2
    },
    {
      '1': 'PASSKEY_CREDENTIAL_PROTECTION_POLICY_USER_VERIFICATION_REQUIRED',
      '2': 3
    },
  ],
};

/// Descriptor for `PasskeyCredentialProtectionPolicy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyCredentialProtectionPolicyDescriptor = $convert.base64Decode(
    'CiFQYXNza2V5Q3JlZGVudGlhbFByb3RlY3Rpb25Qb2xpY3kSNAowUEFTU0tFWV9DUkVERU5USU'
    'FMX1BST1RFQ1RJT05fUE9MSUNZX1VOU1BFQ0lGSUVEEAASQwo/UEFTU0tFWV9DUkVERU5USUFM'
    'X1BST1RFQ1RJT05fUE9MSUNZX1VTRVJfVkVSSUZJQ0FUSU9OX09QVElPTkFMEAESWwpXUEFTU0'
    'tFWV9DUkVERU5USUFMX1BST1RFQ1RJT05fUE9MSUNZX1VTRVJfVkVSSUZJQ0FUSU9OX09QVElP'
    'TkFMX1dJVEhfQ1JFREVOVElBTF9JRF9MSVNUEAISQwo/UEFTU0tFWV9DUkVERU5USUFMX1BST1'
    'RFQ1RJT05fUE9MSUNZX1VTRVJfVkVSSUZJQ0FUSU9OX1JFUVVJUkVEEAM=');

@$core.Deprecated('Use passkeyMediationRequirementDescriptor instead')
const PasskeyMediationRequirement$json = {
  '1': 'PasskeyMediationRequirement',
  '2': [
    {'1': 'PASSKEY_MEDIATION_REQUIREMENT_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_MEDIATION_REQUIREMENT_CONDITIONAL', '2': 1},
  ],
};

/// Descriptor for `PasskeyMediationRequirement`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyMediationRequirementDescriptor =
    $convert.base64Decode(
        'ChtQYXNza2V5TWVkaWF0aW9uUmVxdWlyZW1lbnQSLQopUEFTU0tFWV9NRURJQVRJT05fUkVRVU'
        'lSRU1FTlRfVU5TUEVDSUZJRUQQABItCilQQVNTS0VZX01FRElBVElPTl9SRVFVSVJFTUVOVF9D'
        'T05ESVRJT05BTBAB');

@$core.Deprecated('Use passkeyPublicKeyCredentialTypeDescriptor instead')
const PasskeyPublicKeyCredentialType$json = {
  '1': 'PasskeyPublicKeyCredentialType',
  '2': [
    {'1': 'PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PASSKEY_PUBLIC_KEY_CREDENTIAL_TYPE_PUBLIC_KEY', '2': 1},
  ],
};

/// Descriptor for `PasskeyPublicKeyCredentialType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List passkeyPublicKeyCredentialTypeDescriptor =
    $convert.base64Decode(
        'Ch5QYXNza2V5UHVibGljS2V5Q3JlZGVudGlhbFR5cGUSMgouUEFTU0tFWV9QVUJMSUNfS0VZX0'
        'NSRURFTlRJQUxfVFlQRV9VTlNQRUNJRklFRBAAEjEKLVBBU1NLRVlfUFVCTElDX0tFWV9DUkVE'
        'RU5USUFMX1RZUEVfUFVCTElDX0tFWRAB');

@$core.Deprecated('Use passkeyRelyingPartyDescriptor instead')
const PasskeyRelyingParty$json = {
  '1': 'PasskeyRelyingParty',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'id'},
  ],
};

/// Descriptor for `PasskeyRelyingParty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRelyingPartyDescriptor = $convert.base64Decode(
    'ChNQYXNza2V5UmVseWluZ1BhcnR5Eh4KBG5hbWUYASABKAlCCrpIB3IFEAEY/wFSBG5hbWUSGg'
    'oCaWQYAiABKAlCCrpIB3IFEAEY/wFSAmlk');

@$core.Deprecated('Use passkeyUserEntityDescriptor instead')
const PasskeyUserEntity$json = {
  '1': 'PasskeyUserEntity',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 12, '8': {}, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'name'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'displayName'},
  ],
};

/// Descriptor for `PasskeyUserEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyUserEntityDescriptor = $convert.base64Decode(
    'ChFQYXNza2V5VXNlckVudGl0eRIaCgJpZBgBIAEoDEIKukgHegUQARiACFICaWQSHgoEbmFtZR'
    'gCIAEoCUIKukgHcgUQARjAAlIEbmFtZRItCgxkaXNwbGF5X25hbWUYAyABKAlCCrpIB3IFEAEY'
    'wAJSC2Rpc3BsYXlOYW1l');

@$core.Deprecated('Use passkeyPubKeyCredentialParamDescriptor instead')
const PasskeyPubKeyCredentialParam$json = {
  '1': 'PasskeyPubKeyCredentialParam',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyPublicKeyCredentialType',
      '8': {},
      '10': 'type'
    },
    {'1': 'alg', '3': 2, '4': 1, '5': 3, '10': 'alg'},
  ],
};

/// Descriptor for `PasskeyPubKeyCredentialParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyPubKeyCredentialParamDescriptor =
    $convert.base64Decode(
        'ChxQYXNza2V5UHViS2V5Q3JlZGVudGlhbFBhcmFtEksKBHR5cGUYASABKA4yLS5zeW5jdHYuY2'
        'xpZW50LlBhc3NrZXlQdWJsaWNLZXlDcmVkZW50aWFsVHlwZUIIukgFggECEAFSBHR5cGUSEAoD'
        'YWxnGAIgASgDUgNhbGc=');

@$core.Deprecated('Use passkeyCredentialDescriptorDescriptor instead')
const PasskeyCredentialDescriptor$json = {
  '1': 'PasskeyCredentialDescriptor',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyPublicKeyCredentialType',
      '8': {},
      '10': 'type'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'id'},
    {
      '1': 'transports',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PasskeyAuthenticatorTransport',
      '10': 'transports'
    },
  ],
};

/// Descriptor for `PasskeyCredentialDescriptor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyCredentialDescriptorDescriptor = $convert.base64Decode(
    'ChtQYXNza2V5Q3JlZGVudGlhbERlc2NyaXB0b3ISSwoEdHlwZRgBIAEoDjItLnN5bmN0di5jbG'
    'llbnQuUGFzc2tleVB1YmxpY0tleUNyZWRlbnRpYWxUeXBlQgi6SAWCAQIQAVIEdHlwZRIaCgJp'
    'ZBgCIAEoDEIKukgHegUQARiAIFICaWQSTAoKdHJhbnNwb3J0cxgDIAMoDjIsLnN5bmN0di5jbG'
    'llbnQuUGFzc2tleUF1dGhlbnRpY2F0b3JUcmFuc3BvcnRSCnRyYW5zcG9ydHM=');

@$core.Deprecated('Use passkeyAuthenticatorSelectionCriteriaDescriptor instead')
const PasskeyAuthenticatorSelectionCriteria$json = {
  '1': 'PasskeyAuthenticatorSelectionCriteria',
  '2': [
    {
      '1': 'authenticator_attachment',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyAuthenticatorAttachment',
      '10': 'authenticatorAttachment'
    },
    {
      '1': 'resident_key',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyResidentKeyRequirement',
      '10': 'residentKey'
    },
    {
      '1': 'require_resident_key',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'requireResidentKey'
    },
    {
      '1': 'user_verification',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyUserVerificationRequirement',
      '10': 'userVerification'
    },
  ],
};

/// Descriptor for `PasskeyAuthenticatorSelectionCriteria`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticatorSelectionCriteriaDescriptor = $convert.base64Decode(
    'CiVQYXNza2V5QXV0aGVudGljYXRvclNlbGVjdGlvbkNyaXRlcmlhEmgKGGF1dGhlbnRpY2F0b3'
    'JfYXR0YWNobWVudBgBIAEoDjItLnN5bmN0di5jbGllbnQuUGFzc2tleUF1dGhlbnRpY2F0b3JB'
    'dHRhY2htZW50UhdhdXRoZW50aWNhdG9yQXR0YWNobWVudBJPCgxyZXNpZGVudF9rZXkYAiABKA'
    '4yLC5zeW5jdHYuY2xpZW50LlBhc3NrZXlSZXNpZGVudEtleVJlcXVpcmVtZW50UgtyZXNpZGVu'
    'dEtleRIwChRyZXF1aXJlX3Jlc2lkZW50X2tleRgDIAEoCFIScmVxdWlyZVJlc2lkZW50S2V5El'
    '4KEXVzZXJfdmVyaWZpY2F0aW9uGAQgASgOMjEuc3luY3R2LmNsaWVudC5QYXNza2V5VXNlclZl'
    'cmlmaWNhdGlvblJlcXVpcmVtZW50UhB1c2VyVmVyaWZpY2F0aW9u');

@$core.Deprecated('Use passkeyCredProtectInputDescriptor instead')
const PasskeyCredProtectInput$json = {
  '1': 'PasskeyCredProtectInput',
  '2': [
    {
      '1': 'credential_protection_policy',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyCredentialProtectionPolicy',
      '8': {},
      '10': 'credentialProtectionPolicy'
    },
    {
      '1': 'enforce_credential_protection_policy',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'enforceCredentialProtectionPolicy',
      '17': true
    },
  ],
  '8': [
    {'1': '_enforce_credential_protection_policy'},
  ],
};

/// Descriptor for `PasskeyCredProtectInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyCredProtectInputDescriptor = $convert.base64Decode(
    'ChdQYXNza2V5Q3JlZFByb3RlY3RJbnB1dBJ8ChxjcmVkZW50aWFsX3Byb3RlY3Rpb25fcG9saW'
    'N5GAEgASgOMjAuc3luY3R2LmNsaWVudC5QYXNza2V5Q3JlZGVudGlhbFByb3RlY3Rpb25Qb2xp'
    'Y3lCCLpIBYIBAhABUhpjcmVkZW50aWFsUHJvdGVjdGlvblBvbGljeRJUCiRlbmZvcmNlX2NyZW'
    'RlbnRpYWxfcHJvdGVjdGlvbl9wb2xpY3kYAiABKAhIAFIhZW5mb3JjZUNyZWRlbnRpYWxQcm90'
    'ZWN0aW9uUG9saWN5iAEBQicKJV9lbmZvcmNlX2NyZWRlbnRpYWxfcHJvdGVjdGlvbl9wb2xpY3'
    'k=');

@$core.Deprecated('Use passkeyRegistrationExtensionsInputDescriptor instead')
const PasskeyRegistrationExtensionsInput$json = {
  '1': 'PasskeyRegistrationExtensionsInput',
  '2': [
    {
      '1': 'cred_protect',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyCredProtectInput',
      '10': 'credProtect'
    },
    {'1': 'uvm', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'uvm', '17': true},
    {
      '1': 'cred_props',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'credProps',
      '17': true
    },
    {
      '1': 'min_pin_length',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'minPinLength',
      '17': true
    },
    {
      '1': 'hmac_create_secret',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'hmacCreateSecret',
      '17': true
    },
  ],
  '8': [
    {'1': '_uvm'},
    {'1': '_cred_props'},
    {'1': '_min_pin_length'},
    {'1': '_hmac_create_secret'},
  ],
};

/// Descriptor for `PasskeyRegistrationExtensionsInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRegistrationExtensionsInputDescriptor = $convert.base64Decode(
    'CiJQYXNza2V5UmVnaXN0cmF0aW9uRXh0ZW5zaW9uc0lucHV0EkkKDGNyZWRfcHJvdGVjdBgBIA'
    'EoCzImLnN5bmN0di5jbGllbnQuUGFzc2tleUNyZWRQcm90ZWN0SW5wdXRSC2NyZWRQcm90ZWN0'
    'EhUKA3V2bRgCIAEoCEgAUgN1dm2IAQESIgoKY3JlZF9wcm9wcxgDIAEoCEgBUgljcmVkUHJvcH'
    'OIAQESKQoObWluX3Bpbl9sZW5ndGgYBCABKAhIAlIMbWluUGluTGVuZ3RoiAEBEjEKEmhtYWNf'
    'Y3JlYXRlX3NlY3JldBgFIAEoCEgDUhBobWFjQ3JlYXRlU2VjcmV0iAEBQgYKBF91dm1CDQoLX2'
    'NyZWRfcHJvcHNCEQoPX21pbl9waW5fbGVuZ3RoQhUKE19obWFjX2NyZWF0ZV9zZWNyZXQ=');

@$core.Deprecated('Use passkeyHmacGetSecretInputDescriptor instead')
const PasskeyHmacGetSecretInput$json = {
  '1': 'PasskeyHmacGetSecretInput',
  '2': [
    {'1': 'output1', '3': 1, '4': 1, '5': 12, '8': {}, '10': 'output1'},
    {'1': 'output2', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'output2'},
  ],
};

/// Descriptor for `PasskeyHmacGetSecretInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyHmacGetSecretInputDescriptor =
    $convert.base64Decode(
        'ChlQYXNza2V5SG1hY0dldFNlY3JldElucHV0EiQKB291dHB1dDEYASABKAxCCrpIB3oFEAEYgC'
        'BSB291dHB1dDESIgoHb3V0cHV0MhgCIAEoDEIIukgFegMYgCBSB291dHB1dDI=');

@$core.Deprecated('Use passkeyAuthenticationExtensionsInputDescriptor instead')
const PasskeyAuthenticationExtensionsInput$json = {
  '1': 'PasskeyAuthenticationExtensionsInput',
  '2': [
    {'1': 'appid', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'appid'},
    {'1': 'uvm', '3': 2, '4': 1, '5': 8, '9': 0, '10': 'uvm', '17': true},
    {
      '1': 'hmac_get_secret',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyHmacGetSecretInput',
      '10': 'hmacGetSecret'
    },
  ],
  '8': [
    {'1': '_uvm'},
  ],
};

/// Descriptor for `PasskeyAuthenticationExtensionsInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticationExtensionsInputDescriptor =
    $convert.base64Decode(
        'CiRQYXNza2V5QXV0aGVudGljYXRpb25FeHRlbnNpb25zSW5wdXQSHgoFYXBwaWQYASABKAlCCL'
        'pIBXIDGIAQUgVhcHBpZBIVCgN1dm0YAiABKAhIAFIDdXZtiAEBElAKD2htYWNfZ2V0X3NlY3Jl'
        'dBgDIAEoCzIoLnN5bmN0di5jbGllbnQuUGFzc2tleUhtYWNHZXRTZWNyZXRJbnB1dFINaG1hY0'
        'dldFNlY3JldEIGCgRfdXZt');

@$core.Deprecated(
    'Use passkeyPublicKeyCredentialCreationOptionsDescriptor instead')
const PasskeyPublicKeyCredentialCreationOptions$json = {
  '1': 'PasskeyPublicKeyCredentialCreationOptions',
  '2': [
    {
      '1': 'rp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyRelyingParty',
      '8': {},
      '10': 'rp'
    },
    {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyUserEntity',
      '8': {},
      '10': 'user'
    },
    {'1': 'challenge', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'challenge'},
    {
      '1': 'pub_key_cred_params',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PasskeyPubKeyCredentialParam',
      '8': {},
      '10': 'pubKeyCredParams'
    },
    {
      '1': 'timeout',
      '3': 5,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'timeout',
      '17': true
    },
    {
      '1': 'exclude_credentials',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PasskeyCredentialDescriptor',
      '10': 'excludeCredentials'
    },
    {
      '1': 'authenticator_selection',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyAuthenticatorSelectionCriteria',
      '10': 'authenticatorSelection'
    },
    {
      '1': 'hints',
      '3': 8,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PasskeyPublicKeyCredentialHint',
      '10': 'hints'
    },
    {
      '1': 'attestation',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyAttestationConveyancePreference',
      '10': 'attestation'
    },
    {
      '1': 'attestation_formats',
      '3': 10,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PasskeyAttestationFormat',
      '10': 'attestationFormats'
    },
    {
      '1': 'extensions',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyRegistrationExtensionsInput',
      '10': 'extensions'
    },
  ],
  '8': [
    {'1': '_timeout'},
  ],
};

/// Descriptor for `PasskeyPublicKeyCredentialCreationOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyPublicKeyCredentialCreationOptionsDescriptor = $convert.base64Decode(
    'CilQYXNza2V5UHVibGljS2V5Q3JlZGVudGlhbENyZWF0aW9uT3B0aW9ucxI6CgJycBgBIAEoCz'
    'IiLnN5bmN0di5jbGllbnQuUGFzc2tleVJlbHlpbmdQYXJ0eUIGukgDyAEBUgJycBI8CgR1c2Vy'
    'GAIgASgLMiAuc3luY3R2LmNsaWVudC5QYXNza2V5VXNlckVudGl0eUIGukgDyAEBUgR1c2VyEi'
    'gKCWNoYWxsZW5nZRgDIAEoDEIKukgHegUQARiAIFIJY2hhbGxlbmdlEmQKE3B1Yl9rZXlfY3Jl'
    'ZF9wYXJhbXMYBCADKAsyKy5zeW5jdHYuY2xpZW50LlBhc3NrZXlQdWJLZXlDcmVkZW50aWFsUG'
    'FyYW1CCLpIBZIBAggBUhBwdWJLZXlDcmVkUGFyYW1zEh0KB3RpbWVvdXQYBSABKA1IAFIHdGlt'
    'ZW91dIgBARJbChNleGNsdWRlX2NyZWRlbnRpYWxzGAYgAygLMiouc3luY3R2LmNsaWVudC5QYX'
    'Nza2V5Q3JlZGVudGlhbERlc2NyaXB0b3JSEmV4Y2x1ZGVDcmVkZW50aWFscxJtChdhdXRoZW50'
    'aWNhdG9yX3NlbGVjdGlvbhgHIAEoCzI0LnN5bmN0di5jbGllbnQuUGFzc2tleUF1dGhlbnRpY2'
    'F0b3JTZWxlY3Rpb25Dcml0ZXJpYVIWYXV0aGVudGljYXRvclNlbGVjdGlvbhJDCgVoaW50cxgI'
    'IAMoDjItLnN5bmN0di5jbGllbnQuUGFzc2tleVB1YmxpY0tleUNyZWRlbnRpYWxIaW50UgVoaW'
    '50cxJXCgthdHRlc3RhdGlvbhgJIAEoDjI1LnN5bmN0di5jbGllbnQuUGFzc2tleUF0dGVzdGF0'
    'aW9uQ29udmV5YW5jZVByZWZlcmVuY2VSC2F0dGVzdGF0aW9uElgKE2F0dGVzdGF0aW9uX2Zvcm'
    '1hdHMYCiADKA4yJy5zeW5jdHYuY2xpZW50LlBhc3NrZXlBdHRlc3RhdGlvbkZvcm1hdFISYXR0'
    'ZXN0YXRpb25Gb3JtYXRzElEKCmV4dGVuc2lvbnMYCyABKAsyMS5zeW5jdHYuY2xpZW50LlBhc3'
    'NrZXlSZWdpc3RyYXRpb25FeHRlbnNpb25zSW5wdXRSCmV4dGVuc2lvbnNCCgoIX3RpbWVvdXQ=');

@$core.Deprecated('Use passkeyCreationChallengeDescriptor instead')
const PasskeyCreationChallenge$json = {
  '1': 'PasskeyCreationChallenge',
  '2': [
    {
      '1': 'public_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyPublicKeyCredentialCreationOptions',
      '8': {},
      '10': 'publicKey'
    },
  ],
};

/// Descriptor for `PasskeyCreationChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyCreationChallengeDescriptor = $convert.base64Decode(
    'ChhQYXNza2V5Q3JlYXRpb25DaGFsbGVuZ2USXwoKcHVibGljX2tleRgBIAEoCzI4LnN5bmN0di'
    '5jbGllbnQuUGFzc2tleVB1YmxpY0tleUNyZWRlbnRpYWxDcmVhdGlvbk9wdGlvbnNCBrpIA8gB'
    'AVIJcHVibGljS2V5');

@$core.Deprecated(
    'Use passkeyPublicKeyCredentialRequestOptionsDescriptor instead')
const PasskeyPublicKeyCredentialRequestOptions$json = {
  '1': 'PasskeyPublicKeyCredentialRequestOptions',
  '2': [
    {'1': 'challenge', '3': 1, '4': 1, '5': 12, '8': {}, '10': 'challenge'},
    {
      '1': 'timeout',
      '3': 2,
      '4': 1,
      '5': 13,
      '9': 0,
      '10': 'timeout',
      '17': true
    },
    {'1': 'rp_id', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'rpId'},
    {
      '1': 'allow_credentials',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.PasskeyCredentialDescriptor',
      '10': 'allowCredentials'
    },
    {
      '1': 'user_verification',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyUserVerificationRequirement',
      '8': {},
      '10': 'userVerification'
    },
    {
      '1': 'hints',
      '3': 6,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PasskeyPublicKeyCredentialHint',
      '10': 'hints'
    },
    {
      '1': 'extensions',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyAuthenticationExtensionsInput',
      '10': 'extensions'
    },
  ],
  '8': [
    {'1': '_timeout'},
  ],
};

/// Descriptor for `PasskeyPublicKeyCredentialRequestOptions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyPublicKeyCredentialRequestOptionsDescriptor = $convert.base64Decode(
    'CihQYXNza2V5UHVibGljS2V5Q3JlZGVudGlhbFJlcXVlc3RPcHRpb25zEigKCWNoYWxsZW5nZR'
    'gBIAEoDEIKukgHegUQARiAIFIJY2hhbGxlbmdlEh0KB3RpbWVvdXQYAiABKA1IAFIHdGltZW91'
    'dIgBARIfCgVycF9pZBgDIAEoCUIKukgHcgUQARj/AVIEcnBJZBJXChFhbGxvd19jcmVkZW50aW'
    'FscxgEIAMoCzIqLnN5bmN0di5jbGllbnQuUGFzc2tleUNyZWRlbnRpYWxEZXNjcmlwdG9yUhBh'
    'bGxvd0NyZWRlbnRpYWxzEmgKEXVzZXJfdmVyaWZpY2F0aW9uGAUgASgOMjEuc3luY3R2LmNsaW'
    'VudC5QYXNza2V5VXNlclZlcmlmaWNhdGlvblJlcXVpcmVtZW50Qgi6SAWCAQIQAVIQdXNlclZl'
    'cmlmaWNhdGlvbhJDCgVoaW50cxgGIAMoDjItLnN5bmN0di5jbGllbnQuUGFzc2tleVB1YmxpY0'
    'tleUNyZWRlbnRpYWxIaW50UgVoaW50cxJTCgpleHRlbnNpb25zGAcgASgLMjMuc3luY3R2LmNs'
    'aWVudC5QYXNza2V5QXV0aGVudGljYXRpb25FeHRlbnNpb25zSW5wdXRSCmV4dGVuc2lvbnNCCg'
    'oIX3RpbWVvdXQ=');

@$core.Deprecated('Use passkeyRequestChallengeDescriptor instead')
const PasskeyRequestChallenge$json = {
  '1': 'PasskeyRequestChallenge',
  '2': [
    {
      '1': 'public_key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyPublicKeyCredentialRequestOptions',
      '8': {},
      '10': 'publicKey'
    },
    {
      '1': 'mediation',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyMediationRequirement',
      '10': 'mediation'
    },
  ],
};

/// Descriptor for `PasskeyRequestChallenge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRequestChallengeDescriptor = $convert.base64Decode(
    'ChdQYXNza2V5UmVxdWVzdENoYWxsZW5nZRJeCgpwdWJsaWNfa2V5GAEgASgLMjcuc3luY3R2Lm'
    'NsaWVudC5QYXNza2V5UHVibGljS2V5Q3JlZGVudGlhbFJlcXVlc3RPcHRpb25zQga6SAPIAQFS'
    'CXB1YmxpY0tleRJICgltZWRpYXRpb24YAiABKA4yKi5zeW5jdHYuY2xpZW50LlBhc3NrZXlNZW'
    'RpYXRpb25SZXF1aXJlbWVudFIJbWVkaWF0aW9u');

@$core.Deprecated(
    'Use passkeyAuthenticationExtensionsClientOutputsDescriptor instead')
const PasskeyAuthenticationExtensionsClientOutputs$json = {
  '1': 'PasskeyAuthenticationExtensionsClientOutputs',
  '2': [
    {'1': 'appid', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'appid', '17': true},
    {
      '1': 'hmac_get_secret',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyHmacGetSecretInput',
      '10': 'hmacGetSecret'
    },
  ],
  '8': [
    {'1': '_appid'},
  ],
};

/// Descriptor for `PasskeyAuthenticationExtensionsClientOutputs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    passkeyAuthenticationExtensionsClientOutputsDescriptor =
    $convert.base64Decode(
        'CixQYXNza2V5QXV0aGVudGljYXRpb25FeHRlbnNpb25zQ2xpZW50T3V0cHV0cxIZCgVhcHBpZB'
        'gBIAEoCEgAUgVhcHBpZIgBARJQCg9obWFjX2dldF9zZWNyZXQYAiABKAsyKC5zeW5jdHYuY2xp'
        'ZW50LlBhc3NrZXlIbWFjR2V0U2VjcmV0SW5wdXRSDWhtYWNHZXRTZWNyZXRCCAoGX2FwcGlk');

@$core.Deprecated('Use passkeyRegistrationCredPropsDescriptor instead')
const PasskeyRegistrationCredProps$json = {
  '1': 'PasskeyRegistrationCredProps',
  '2': [
    {'1': 'rk', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'rk', '17': true},
  ],
  '8': [
    {'1': '_rk'},
  ],
};

/// Descriptor for `PasskeyRegistrationCredProps`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRegistrationCredPropsDescriptor =
    $convert.base64Decode(
        'ChxQYXNza2V5UmVnaXN0cmF0aW9uQ3JlZFByb3BzEhMKAnJrGAEgASgISABSAnJriAEBQgUKA1'
        '9yaw==');

@$core.Deprecated(
    'Use passkeyRegistrationExtensionsClientOutputsDescriptor instead')
const PasskeyRegistrationExtensionsClientOutputs$json = {
  '1': 'PasskeyRegistrationExtensionsClientOutputs',
  '2': [
    {'1': 'appid', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'appid', '17': true},
    {
      '1': 'cred_props',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyRegistrationCredProps',
      '10': 'credProps'
    },
    {
      '1': 'hmac_secret',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'hmacSecret',
      '17': true
    },
    {
      '1': 'cred_protect',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyCredentialProtectionPolicy',
      '10': 'credProtect'
    },
    {
      '1': 'min_pin_length',
      '3': 5,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'minPinLength',
      '17': true
    },
  ],
  '8': [
    {'1': '_appid'},
    {'1': '_hmac_secret'},
    {'1': '_min_pin_length'},
  ],
};

/// Descriptor for `PasskeyRegistrationExtensionsClientOutputs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    passkeyRegistrationExtensionsClientOutputsDescriptor =
    $convert.base64Decode(
        'CipQYXNza2V5UmVnaXN0cmF0aW9uRXh0ZW5zaW9uc0NsaWVudE91dHB1dHMSGQoFYXBwaWQYAS'
        'ABKAhIAFIFYXBwaWSIAQESSgoKY3JlZF9wcm9wcxgCIAEoCzIrLnN5bmN0di5jbGllbnQuUGFz'
        'c2tleVJlZ2lzdHJhdGlvbkNyZWRQcm9wc1IJY3JlZFByb3BzEiQKC2htYWNfc2VjcmV0GAMgAS'
        'gISAFSCmhtYWNTZWNyZXSIAQESUwoMY3JlZF9wcm90ZWN0GAQgASgOMjAuc3luY3R2LmNsaWVu'
        'dC5QYXNza2V5Q3JlZGVudGlhbFByb3RlY3Rpb25Qb2xpY3lSC2NyZWRQcm90ZWN0EikKDm1pbl'
        '9waW5fbGVuZ3RoGAUgASgNSAJSDG1pblBpbkxlbmd0aIgBAUIICgZfYXBwaWRCDgoMX2htYWNf'
        'c2VjcmV0QhEKD19taW5fcGluX2xlbmd0aA==');

@$core.Deprecated('Use passkeyAuthenticatorAssertionResponseDescriptor instead')
const PasskeyAuthenticatorAssertionResponse$json = {
  '1': 'PasskeyAuthenticatorAssertionResponse',
  '2': [
    {
      '1': 'authenticator_data',
      '3': 1,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'authenticatorData'
    },
    {
      '1': 'client_data_json',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'clientDataJSON'
    },
    {'1': 'signature', '3': 3, '4': 1, '5': 12, '8': {}, '10': 'signature'},
    {'1': 'user_handle', '3': 4, '4': 1, '5': 12, '8': {}, '10': 'userHandle'},
  ],
};

/// Descriptor for `PasskeyAuthenticatorAssertionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticatorAssertionResponseDescriptor =
    $convert.base64Decode(
        'CiVQYXNza2V5QXV0aGVudGljYXRvckFzc2VydGlvblJlc3BvbnNlEjoKEmF1dGhlbnRpY2F0b3'
        'JfZGF0YRgBIAEoDEILukgIegYQARiAgARSEWF1dGhlbnRpY2F0b3JEYXRhEjUKEGNsaWVudF9k'
        'YXRhX2pzb24YAiABKAxCC7pICHoGEAEYgIAEUg5jbGllbnREYXRhSlNPThIpCglzaWduYXR1cm'
        'UYAyABKAxCC7pICHoGEAEYgIAEUglzaWduYXR1cmUSKQoLdXNlcl9oYW5kbGUYBCABKAxCCLpI'
        'BXoDGIAgUgp1c2VySGFuZGxl');

@$core
    .Deprecated('Use passkeyAuthenticatorAttestationResponseDescriptor instead')
const PasskeyAuthenticatorAttestationResponse$json = {
  '1': 'PasskeyAuthenticatorAttestationResponse',
  '2': [
    {
      '1': 'attestation_object',
      '3': 1,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'attestationObject'
    },
    {
      '1': 'client_data_json',
      '3': 2,
      '4': 1,
      '5': 12,
      '8': {},
      '10': 'clientDataJSON'
    },
    {
      '1': 'transports',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.synctv.client.PasskeyAuthenticatorTransport',
      '10': 'transports'
    },
  ],
};

/// Descriptor for `PasskeyAuthenticatorAttestationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticatorAttestationResponseDescriptor =
    $convert.base64Decode(
        'CidQYXNza2V5QXV0aGVudGljYXRvckF0dGVzdGF0aW9uUmVzcG9uc2USOgoSYXR0ZXN0YXRpb2'
        '5fb2JqZWN0GAEgASgMQgu6SAh6BhABGICABFIRYXR0ZXN0YXRpb25PYmplY3QSNQoQY2xpZW50'
        'X2RhdGFfanNvbhgCIAEoDEILukgIegYQARiAgARSDmNsaWVudERhdGFKU09OEkwKCnRyYW5zcG'
        '9ydHMYAyADKA4yLC5zeW5jdHYuY2xpZW50LlBhc3NrZXlBdXRoZW50aWNhdG9yVHJhbnNwb3J0'
        'Ugp0cmFuc3BvcnRz');

@$core.Deprecated('Use passkeyAuthenticationCredentialDescriptor instead')
const PasskeyAuthenticationCredential$json = {
  '1': 'PasskeyAuthenticationCredential',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'raw_id', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'rawId'},
    {
      '1': 'response',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyAuthenticatorAssertionResponse',
      '8': {},
      '10': 'response'
    },
    {
      '1': 'extensions',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyAuthenticationExtensionsClientOutputs',
      '10': 'extensions'
    },
    {
      '1': 'type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyPublicKeyCredentialType',
      '8': {},
      '10': 'type'
    },
  ],
};

/// Descriptor for `PasskeyAuthenticationCredential`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyAuthenticationCredentialDescriptor = $convert.base64Decode(
    'Ch9QYXNza2V5QXV0aGVudGljYXRpb25DcmVkZW50aWFsEhoKAmlkGAEgASgJQgq6SAdyBRABGI'
    'AgUgJpZBIhCgZyYXdfaWQYAiABKAxCCrpIB3oFEAEYgCBSBXJhd0lkElgKCHJlc3BvbnNlGAMg'
    'ASgLMjQuc3luY3R2LmNsaWVudC5QYXNza2V5QXV0aGVudGljYXRvckFzc2VydGlvblJlc3Bvbn'
    'NlQga6SAPIAQFSCHJlc3BvbnNlElsKCmV4dGVuc2lvbnMYBCABKAsyOy5zeW5jdHYuY2xpZW50'
    'LlBhc3NrZXlBdXRoZW50aWNhdGlvbkV4dGVuc2lvbnNDbGllbnRPdXRwdXRzUgpleHRlbnNpb2'
    '5zEksKBHR5cGUYBSABKA4yLS5zeW5jdHYuY2xpZW50LlBhc3NrZXlQdWJsaWNLZXlDcmVkZW50'
    'aWFsVHlwZUIIukgFggECEAFSBHR5cGU=');

@$core.Deprecated('Use passkeyRegistrationCredentialDescriptor instead')
const PasskeyRegistrationCredential$json = {
  '1': 'PasskeyRegistrationCredential',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'id'},
    {'1': 'raw_id', '3': 2, '4': 1, '5': 12, '8': {}, '10': 'rawId'},
    {
      '1': 'response',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyAuthenticatorAttestationResponse',
      '8': {},
      '10': 'response'
    },
    {
      '1': 'type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.PasskeyPublicKeyCredentialType',
      '8': {},
      '10': 'type'
    },
    {
      '1': 'extensions',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.PasskeyRegistrationExtensionsClientOutputs',
      '10': 'extensions'
    },
  ],
};

/// Descriptor for `PasskeyRegistrationCredential`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passkeyRegistrationCredentialDescriptor = $convert.base64Decode(
    'Ch1QYXNza2V5UmVnaXN0cmF0aW9uQ3JlZGVudGlhbBIaCgJpZBgBIAEoCUIKukgHcgUQARiAIF'
    'ICaWQSIQoGcmF3X2lkGAIgASgMQgq6SAd6BRABGIAgUgVyYXdJZBJaCghyZXNwb25zZRgDIAEo'
    'CzI2LnN5bmN0di5jbGllbnQuUGFzc2tleUF1dGhlbnRpY2F0b3JBdHRlc3RhdGlvblJlc3Bvbn'
    'NlQga6SAPIAQFSCHJlc3BvbnNlEksKBHR5cGUYBCABKA4yLS5zeW5jdHYuY2xpZW50LlBhc3Nr'
    'ZXlQdWJsaWNLZXlDcmVkZW50aWFsVHlwZUIIukgFggECEAFSBHR5cGUSWQoKZXh0ZW5zaW9ucx'
    'gFIAEoCzI5LnN5bmN0di5jbGllbnQuUGFzc2tleVJlZ2lzdHJhdGlvbkV4dGVuc2lvbnNDbGll'
    'bnRPdXRwdXRzUgpleHRlbnNpb25z');
