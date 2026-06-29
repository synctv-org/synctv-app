// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili.proto.

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

@$core.Deprecated('Use qRLoginStatusDescriptor instead')
const QRLoginStatus$json = {
  '1': 'QRLoginStatus',
  '2': [
    {'1': 'QR_LOGIN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'QR_LOGIN_STATUS_EXPIRED', '2': 1},
    {'1': 'QR_LOGIN_STATUS_NOT_SCANNED', '2': 2},
    {'1': 'QR_LOGIN_STATUS_SCANNED', '2': 3},
    {'1': 'QR_LOGIN_STATUS_SUCCESS', '2': 4},
  ],
};

/// Descriptor for `QRLoginStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List qRLoginStatusDescriptor = $convert.base64Decode(
    'Cg1RUkxvZ2luU3RhdHVzEh8KG1FSX0xPR0lOX1NUQVRVU19VTlNQRUNJRklFRBAAEhsKF1FSX0'
    'xPR0lOX1NUQVRVU19FWFBJUkVEEAESHwobUVJfTE9HSU5fU1RBVFVTX05PVF9TQ0FOTkVEEAIS'
    'GwoXUVJfTE9HSU5fU1RBVFVTX1NDQU5ORUQQAxIbChdRUl9MT0dJTl9TVEFUVVNfU1VDQ0VTUx'
    'AE');

@$core.Deprecated('Use parseRequestDescriptor instead')
const ParseRequest$json = {
  '1': 'ParseRequest',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'url'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ParseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseRequestDescriptor = $convert.base64Decode(
    'CgxQYXJzZVJlcXVlc3QSGQoDdXJsGAEgASgJQge6SARyAhABUgN1cmwSIwoNaW5zdGFuY2Vfbm'
    'FtZRgCIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use parseResponseDescriptor instead')
const ParseResponse$json = {
  '1': 'ParseResponse',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'actors', '3': 2, '4': 3, '5': 9, '10': 'actors'},
    {
      '1': 'videos',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.VideoInfo',
      '10': 'videos'
    },
  ],
};

/// Descriptor for `ParseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseResponseDescriptor = $convert.base64Decode(
    'Cg1QYXJzZVJlc3BvbnNlEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIWCgZhY3RvcnMYAiADKAlSBm'
    'FjdG9ycxI7CgZ2aWRlb3MYAyADKAsyIy5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuVmlkZW9J'
    'bmZvUgZ2aWRlb3M=');

@$core.Deprecated('Use videoInfoDescriptor instead')
const VideoInfo$json = {
  '1': 'VideoInfo',
  '2': [
    {'1': 'bvid', '3': 1, '4': 1, '5': 9, '10': 'bvid'},
    {'1': 'cid', '3': 2, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'epid', '3': 3, '4': 1, '5': 3, '10': 'epid'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'cover', '3': 5, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'is_live', '3': 6, '4': 1, '5': 8, '10': 'isLive'},
  ],
};

/// Descriptor for `VideoInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoInfoDescriptor = $convert.base64Decode(
    'CglWaWRlb0luZm8SEgoEYnZpZBgBIAEoCVIEYnZpZBIQCgNjaWQYAiABKANSA2NpZBISCgRlcG'
    'lkGAMgASgDUgRlcGlkEhIKBG5hbWUYBCABKAlSBG5hbWUSFAoFY292ZXIYBSABKAlSBWNvdmVy'
    'EhcKB2lzX2xpdmUYBiABKAhSBmlzTGl2ZQ==');

@$core.Deprecated('Use loginQRRequestDescriptor instead')
const LoginQRRequest$json = {
  '1': 'LoginQRRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LoginQRRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginQRRequestDescriptor = $convert.base64Decode(
    'Cg5Mb2dpblFSUmVxdWVzdBIjCg1pbnN0YW5jZV9uYW1lGAEgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use qRCodeResponseDescriptor instead')
const QRCodeResponse$json = {
  '1': 'QRCodeResponse',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `QRCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qRCodeResponseDescriptor = $convert.base64Decode(
    'Cg5RUkNvZGVSZXNwb25zZRIQCgN1cmwYASABKAlSA3VybBIQCgNrZXkYAiABKAlSA2tleQ==');

@$core.Deprecated('Use checkQRRequestDescriptor instead')
const CheckQRRequest$json = {
  '1': 'CheckQRRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'key'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `CheckQRRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkQRRequestDescriptor = $convert.base64Decode(
    'Cg5DaGVja1FSUmVxdWVzdBIZCgNrZXkYASABKAlCB7pIBHICEAFSA2tleRIjCg1pbnN0YW5jZV'
    '9uYW1lGAIgASgJUgxpbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use qRStatusResponseDescriptor instead')
const QRStatusResponse$json = {
  '1': 'QRStatusResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.bilibili.QRLoginStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `QRStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qRStatusResponseDescriptor = $convert.base64Decode(
    'ChBRUlN0YXR1c1Jlc3BvbnNlEj8KBnN0YXR1cxgBIAEoDjInLnN5bmN0di5wcm92aWRlci5iaW'
    'xpYmlsaS5RUkxvZ2luU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use startSMSLoginRequestDescriptor instead')
const StartSMSLoginRequest$json = {
  '1': 'StartSMSLoginRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `StartSMSLoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSMSLoginRequestDescriptor = $convert.base64Decode(
    'ChRTdGFydFNNU0xvZ2luUmVxdWVzdBIjCg1pbnN0YW5jZV9uYW1lGAEgASgJUgxpbnN0YW5jZU'
    '5hbWU=');

@$core.Deprecated('Use startSMSLoginResponseDescriptor instead')
const StartSMSLoginResponse$json = {
  '1': 'StartSMSLoginResponse',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'gt', '3': 2, '4': 1, '5': 9, '10': 'gt'},
    {'1': 'challenge', '3': 3, '4': 1, '5': 9, '10': 'challenge'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `StartSMSLoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSMSLoginResponseDescriptor = $convert.base64Decode(
    'ChVTdGFydFNNU0xvZ2luUmVzcG9uc2USIwoNc2Vzc2lvbl90b2tlbhgBIAEoCVIMc2Vzc2lvbl'
    'Rva2VuEg4KAmd0GAIgASgJUgJndBIcCgljaGFsbGVuZ2UYAyABKAlSCWNoYWxsZW5nZRIdCgpl'
    'eHBpcmVzX2F0GAQgASgDUglleHBpcmVzQXQ=');

@$core.Deprecated('Use sendSMSRequestDescriptor instead')
const SendSMSRequest$json = {
  '1': 'SendSMSRequest',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'validate', '3': 3, '4': 1, '5': 9, '10': 'validate'},
  ],
};

/// Descriptor for `SendSMSRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendSMSRequestDescriptor = $convert.base64Decode(
    'Cg5TZW5kU01TUmVxdWVzdBIjCg1zZXNzaW9uX3Rva2VuGAEgASgJUgxzZXNzaW9uVG9rZW4SFA'
    'oFcGhvbmUYAiABKAlSBXBob25lEhoKCHZhbGlkYXRlGAMgASgJUgh2YWxpZGF0ZQ==');

@$core.Deprecated('Use sendSMSResponseDescriptor instead')
const SendSMSResponse$json = {
  '1': 'SendSMSResponse',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'expires_at', '3': 2, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `SendSMSResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendSMSResponseDescriptor = $convert.base64Decode(
    'Cg9TZW5kU01TUmVzcG9uc2USIwoNc2Vzc2lvbl90b2tlbhgBIAEoCVIMc2Vzc2lvblRva2VuEh'
    '0KCmV4cGlyZXNfYXQYAiABKANSCWV4cGlyZXNBdA==');

@$core.Deprecated('Use loginSMSRequestDescriptor instead')
const LoginSMSRequest$json = {
  '1': 'LoginSMSRequest',
  '2': [
    {'1': 'session_token', '3': 1, '4': 1, '5': 9, '10': 'sessionToken'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `LoginSMSRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginSMSRequestDescriptor = $convert.base64Decode(
    'Cg9Mb2dpblNNU1JlcXVlc3QSIwoNc2Vzc2lvbl90b2tlbhgBIAEoCVIMc2Vzc2lvblRva2VuEh'
    'IKBGNvZGUYAiABKAlSBGNvZGU=');

@$core.Deprecated('Use loginSMSResponseDescriptor instead')
const LoginSMSResponse$json = {
  '1': 'LoginSMSResponse',
};

/// Descriptor for `LoginSMSResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginSMSResponseDescriptor =
    $convert.base64Decode('ChBMb2dpblNNU1Jlc3BvbnNl');

@$core.Deprecated('Use userInfoRequestDescriptor instead')
const UserInfoRequest$json = {
  '1': 'UserInfoRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `UserInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoRequestDescriptor = $convert.base64Decode(
    'Cg9Vc2VySW5mb1JlcXVlc3QSIwoNaW5zdGFuY2VfbmFtZRgBIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use userInfoResponseDescriptor instead')
const UserInfoResponse$json = {
  '1': 'UserInfoResponse',
  '2': [
    {'1': 'is_login', '3': 1, '4': 1, '5': 8, '10': 'isLogin'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'face', '3': 3, '4': 1, '5': 9, '10': 'face'},
    {'1': 'is_vip', '3': 4, '4': 1, '5': 8, '10': 'isVip'},
  ],
};

/// Descriptor for `UserInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoResponseDescriptor = $convert.base64Decode(
    'ChBVc2VySW5mb1Jlc3BvbnNlEhkKCGlzX2xvZ2luGAEgASgIUgdpc0xvZ2luEhoKCHVzZXJuYW'
    '1lGAIgASgJUgh1c2VybmFtZRISCgRmYWNlGAMgASgJUgRmYWNlEhUKBmlzX3ZpcBgEIAEoCFIF'
    'aXNWaXA=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EiMKDWluc3RhbmNlX25hbWUYASABKAlSDGluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use getBindsRequestDescriptor instead')
const GetBindsRequest$json = {
  '1': 'GetBindsRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `GetBindsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCaW5kc1JlcXVlc3QSIwoNaW5zdGFuY2VfbmFtZRgBIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.bilibili.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjgKBWJpbmRzGAEgAygLMiIuc3luY3R2LnByb3ZpZGVyLmJpbG'
    'liaWxpLkJpbmRJbmZvUgViaW5kcw==');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IdCgpjcmVhdGVkX2F0GAMgASgDUgljcmVhdGVkQXQSNAoWcHJvdmlkZXJfaW5zdGFuY2VfbmFt'
    'ZRgEIAEoCVIUcHJvdmlkZXJJbnN0YW5jZU5hbWU=');
