// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili_service.proto.

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

import 'bilibili.pbjson.dart' as $0;

const $core.Map<$core.String, $core.dynamic> BilibiliProviderServiceBase$json =
    {
  '1': 'BilibiliProviderService',
  '2': [
    {
      '1': 'Parse',
      '2': '.synctv.provider.bilibili.ParseRequest',
      '3': '.synctv.provider.bilibili.ParseResponse'
    },
    {
      '1': 'LoginQR',
      '2': '.synctv.provider.bilibili.LoginQRRequest',
      '3': '.synctv.provider.bilibili.QRCodeResponse'
    },
    {
      '1': 'CheckQR',
      '2': '.synctv.provider.bilibili.CheckQRRequest',
      '3': '.synctv.provider.bilibili.QRStatusResponse'
    },
    {
      '1': 'StartSMSLogin',
      '2': '.synctv.provider.bilibili.StartSMSLoginRequest',
      '3': '.synctv.provider.bilibili.StartSMSLoginResponse'
    },
    {
      '1': 'SendSMS',
      '2': '.synctv.provider.bilibili.SendSMSRequest',
      '3': '.synctv.provider.bilibili.SendSMSResponse'
    },
    {
      '1': 'LoginSMS',
      '2': '.synctv.provider.bilibili.LoginSMSRequest',
      '3': '.synctv.provider.bilibili.LoginSMSResponse'
    },
    {
      '1': 'GetUserInfo',
      '2': '.synctv.provider.bilibili.UserInfoRequest',
      '3': '.synctv.provider.bilibili.UserInfoResponse'
    },
    {
      '1': 'Logout',
      '2': '.synctv.provider.bilibili.LogoutRequest',
      '3': '.synctv.provider.bilibili.LogoutResponse'
    },
    {
      '1': 'GetBinds',
      '2': '.synctv.provider.bilibili.GetBindsRequest',
      '3': '.synctv.provider.bilibili.GetBindsResponse'
    },
  ],
};

@$core.Deprecated('Use bilibiliProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BilibiliProviderServiceBase$messageJson = {
  '.synctv.provider.bilibili.ParseRequest': $0.ParseRequest$json,
  '.synctv.provider.bilibili.ParseResponse': $0.ParseResponse$json,
  '.synctv.provider.bilibili.VideoInfo': $0.VideoInfo$json,
  '.synctv.provider.bilibili.LoginQRRequest': $0.LoginQRRequest$json,
  '.synctv.provider.bilibili.QRCodeResponse': $0.QRCodeResponse$json,
  '.synctv.provider.bilibili.CheckQRRequest': $0.CheckQRRequest$json,
  '.synctv.provider.bilibili.QRStatusResponse': $0.QRStatusResponse$json,
  '.synctv.provider.bilibili.StartSMSLoginRequest':
      $0.StartSMSLoginRequest$json,
  '.synctv.provider.bilibili.StartSMSLoginResponse':
      $0.StartSMSLoginResponse$json,
  '.synctv.provider.bilibili.SendSMSRequest': $0.SendSMSRequest$json,
  '.synctv.provider.bilibili.SendSMSResponse': $0.SendSMSResponse$json,
  '.synctv.provider.bilibili.LoginSMSRequest': $0.LoginSMSRequest$json,
  '.synctv.provider.bilibili.LoginSMSResponse': $0.LoginSMSResponse$json,
  '.synctv.provider.bilibili.UserInfoRequest': $0.UserInfoRequest$json,
  '.synctv.provider.bilibili.UserInfoResponse': $0.UserInfoResponse$json,
  '.synctv.provider.bilibili.LogoutRequest': $0.LogoutRequest$json,
  '.synctv.provider.bilibili.LogoutResponse': $0.LogoutResponse$json,
  '.synctv.provider.bilibili.GetBindsRequest': $0.GetBindsRequest$json,
  '.synctv.provider.bilibili.GetBindsResponse': $0.GetBindsResponse$json,
  '.synctv.provider.bilibili.BindInfo': $0.BindInfo$json,
};

/// Descriptor for `BilibiliProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List bilibiliProviderServiceDescriptor = $convert.base64Decode(
    'ChdCaWxpYmlsaVByb3ZpZGVyU2VydmljZRJYCgVQYXJzZRImLnN5bmN0di5wcm92aWRlci5iaW'
    'xpYmlsaS5QYXJzZVJlcXVlc3QaJy5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuUGFyc2VSZXNw'
    'b25zZRJdCgdMb2dpblFSEiguc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLkxvZ2luUVJSZXF1ZX'
    'N0Giguc3luY3R2LnByb3ZpZGVyLmJpbGliaWxpLlFSQ29kZVJlc3BvbnNlEl8KB0NoZWNrUVIS'
    'KC5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuQ2hlY2tRUlJlcXVlc3QaKi5zeW5jdHYucHJvdm'
    'lkZXIuYmlsaWJpbGkuUVJTdGF0dXNSZXNwb25zZRJwCg1TdGFydFNNU0xvZ2luEi4uc3luY3R2'
    'LnByb3ZpZGVyLmJpbGliaWxpLlN0YXJ0U01TTG9naW5SZXF1ZXN0Gi8uc3luY3R2LnByb3ZpZG'
    'VyLmJpbGliaWxpLlN0YXJ0U01TTG9naW5SZXNwb25zZRJeCgdTZW5kU01TEiguc3luY3R2LnBy'
    'b3ZpZGVyLmJpbGliaWxpLlNlbmRTTVNSZXF1ZXN0Gikuc3luY3R2LnByb3ZpZGVyLmJpbGliaW'
    'xpLlNlbmRTTVNSZXNwb25zZRJhCghMb2dpblNNUxIpLnN5bmN0di5wcm92aWRlci5iaWxpYmls'
    'aS5Mb2dpblNNU1JlcXVlc3QaKi5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuTG9naW5TTVNSZX'
    'Nwb25zZRJkCgtHZXRVc2VySW5mbxIpLnN5bmN0di5wcm92aWRlci5iaWxpYmlsaS5Vc2VySW5m'
    'b1JlcXVlc3QaKi5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuVXNlckluZm9SZXNwb25zZRJbCg'
    'ZMb2dvdXQSJy5zeW5jdHYucHJvdmlkZXIuYmlsaWJpbGkuTG9nb3V0UmVxdWVzdBooLnN5bmN0'
    'di5wcm92aWRlci5iaWxpYmlsaS5Mb2dvdXRSZXNwb25zZRJhCghHZXRCaW5kcxIpLnN5bmN0di'
    '5wcm92aWRlci5iaWxpYmlsaS5HZXRCaW5kc1JlcXVlc3QaKi5zeW5jdHYucHJvdmlkZXIuYmls'
    'aWJpbGkuR2V0QmluZHNSZXNwb25zZQ==');
