// This is a generated file - do not edit.
//
// Generated from proto/oauth2.proto.

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

@$core.Deprecated('Use oAuth2ProviderTypeDescriptor instead')
const OAuth2ProviderType$json = {
  '1': 'OAuth2ProviderType',
  '2': [
    {'1': 'OAUTH2_PROVIDER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'OAUTH2_PROVIDER_TYPE_QQ', '2': 1},
    {'1': 'OAUTH2_PROVIDER_TYPE_GITHUB', '2': 2},
    {'1': 'OAUTH2_PROVIDER_TYPE_GOOGLE', '2': 3},
    {'1': 'OAUTH2_PROVIDER_TYPE_MICROSOFT', '2': 4},
    {'1': 'OAUTH2_PROVIDER_TYPE_DISCORD', '2': 5},
    {'1': 'OAUTH2_PROVIDER_TYPE_CASDOOR', '2': 6},
    {'1': 'OAUTH2_PROVIDER_TYPE_LOGTO', '2': 7},
    {'1': 'OAUTH2_PROVIDER_TYPE_OIDC', '2': 8},
    {'1': 'OAUTH2_PROVIDER_TYPE_FEISHU', '2': 9},
    {'1': 'OAUTH2_PROVIDER_TYPE_GITEE', '2': 10},
    {'1': 'OAUTH2_PROVIDER_TYPE_APPLE', '2': 11},
  ],
};

/// Descriptor for `OAuth2ProviderType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List oAuth2ProviderTypeDescriptor = $convert.base64Decode(
    'ChJPQXV0aDJQcm92aWRlclR5cGUSJAogT0FVVEgyX1BST1ZJREVSX1RZUEVfVU5TUEVDSUZJRU'
    'QQABIbChdPQVVUSDJfUFJPVklERVJfVFlQRV9RURABEh8KG09BVVRIMl9QUk9WSURFUl9UWVBF'
    'X0dJVEhVQhACEh8KG09BVVRIMl9QUk9WSURFUl9UWVBFX0dPT0dMRRADEiIKHk9BVVRIMl9QUk'
    '9WSURFUl9UWVBFX01JQ1JPU09GVBAEEiAKHE9BVVRIMl9QUk9WSURFUl9UWVBFX0RJU0NPUkQQ'
    'BRIgChxPQVVUSDJfUFJPVklERVJfVFlQRV9DQVNET09SEAYSHgoaT0FVVEgyX1BST1ZJREVSX1'
    'RZUEVfTE9HVE8QBxIdChlPQVVUSDJfUFJPVklERVJfVFlQRV9PSURDEAgSHwobT0FVVEgyX1BS'
    'T1ZJREVSX1RZUEVfRkVJU0hVEAkSHgoaT0FVVEgyX1BST1ZJREVSX1RZUEVfR0lURUUQChIeCh'
    'pPQVVUSDJfUFJPVklERVJfVFlQRV9BUFBMRRAL');

@$core.Deprecated('Use oAuth2OperationDescriptor instead')
const OAuth2Operation$json = {
  '1': 'OAuth2Operation',
  '2': [
    {'1': 'OAUTH2_OPERATION_UNSPECIFIED', '2': 0},
    {'1': 'OAUTH2_OPERATION_LOGIN', '2': 1},
    {'1': 'OAUTH2_OPERATION_BIND', '2': 2},
  ],
};

/// Descriptor for `OAuth2Operation`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List oAuth2OperationDescriptor = $convert.base64Decode(
    'Cg9PQXV0aDJPcGVyYXRpb24SIAocT0FVVEgyX09QRVJBVElPTl9VTlNQRUNJRklFRBAAEhoKFk'
    '9BVVRIMl9PUEVSQVRJT05fTE9HSU4QARIZChVPQVVUSDJfT1BFUkFUSU9OX0JJTkQQAg==');

@$core.Deprecated('Use oAuth2ProviderInstancePathRequestDescriptor instead')
const OAuth2ProviderInstancePathRequest$json = {
  '1': 'OAuth2ProviderInstancePathRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
  ],
};

/// Descriptor for `OAuth2ProviderInstancePathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2ProviderInstancePathRequestDescriptor =
    $convert.base64Decode(
        'CiFPQXV0aDJQcm92aWRlckluc3RhbmNlUGF0aFJlcXVlc3QSNwoIcHJvdmlkZXIYASABKAlCG7'
        'pIGHIWEAEYQDIQXltBLVphLXowLTlfLV0rJFIIcHJvdmlkZXI=');

@$core.Deprecated('Use oAuth2ProviderTypePathRequestDescriptor instead')
const OAuth2ProviderTypePathRequest$json = {
  '1': 'OAuth2ProviderTypePathRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
  ],
};

/// Descriptor for `OAuth2ProviderTypePathRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2ProviderTypePathRequestDescriptor =
    $convert.base64Decode(
        'Ch1PQXV0aDJQcm92aWRlclR5cGVQYXRoUmVxdWVzdBJtCghwcm92aWRlchgBIAEoCUJRukhOck'
        'wQARggMkZeKHFxfGdpdGh1Ynxnb29nbGV8bWljcm9zb2Z0fGRpc2NvcmR8Y2FzZG9vcnxsb2d0'
        'b3xvaWRjfGZlaXNodXxnaXRlZSkkUghwcm92aWRlcg==');

@$core.Deprecated('Use getAuthorizationUrlRequestDescriptor instead')
const GetAuthorizationUrlRequest$json = {
  '1': 'GetAuthorizationUrlRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
    {'1': 'redirect_url', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'redirectUrl'},
  ],
};

/// Descriptor for `GetAuthorizationUrlRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuthorizationUrlRequestDescriptor = $convert.base64Decode(
    'ChpHZXRBdXRob3JpemF0aW9uVXJsUmVxdWVzdBI3Cghwcm92aWRlchgBIAEoCUIbukgYchYQAR'
    'hAMhBeW0EtWmEtejAtOV8tXSskUghwcm92aWRlchK5AgoMcmVkaXJlY3RfdXJsGAIgASgJQpUC'
    'ukiRAroBjQIKKW9hdXRoMi5nZXRfYXV0aG9yaXphdGlvbl91cmwucmVkaXJlY3RfdXJsEkByZW'
    'RpcmVjdF91cmwgbXVzdCBiZSBlbXB0eSwgYW4gaHR0cHMgVVJMLCBvciBhIGxvb3BiYWNrIGh0'
    'dHAgVVJMGp0BdGhpcyA9PSAnJyB8fCAoc2l6ZSh0aGlzKSA8PSAyMDQ4ICYmICh0aGlzLm1hdG'
    'NoZXMoJ15odHRwczovL1teXFxzXSskJykgfHwgdGhpcy5tYXRjaGVzKCdeaHR0cDovLygxMjdc'
    'XC4wXFwuMFxcLjF8bG9jYWxob3N0fFxcWzo6MVxcXSkoOlswLTldKyk/L1teXFxzXSokJykpKV'
    'ILcmVkaXJlY3RVcmw=');

@$core.Deprecated('Use getAuthorizationUrlResponseDescriptor instead')
const GetAuthorizationUrlResponse$json = {
  '1': 'GetAuthorizationUrlResponse',
  '2': [
    {
      '1': 'authorization_url',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'authorizationUrl'
    },
    {'1': 'state', '3': 2, '4': 1, '5': 9, '10': 'state'},
    {
      '1': 'operation',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2Operation',
      '8': {},
      '10': 'operation'
    },
  ],
};

/// Descriptor for `GetAuthorizationUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuthorizationUrlResponseDescriptor = $convert.base64Decode(
    'ChtHZXRBdXRob3JpemF0aW9uVXJsUmVzcG9uc2USKwoRYXV0aG9yaXphdGlvbl91cmwYASABKA'
    'lSEGF1dGhvcml6YXRpb25VcmwSFAoFc3RhdGUYAiABKAlSBXN0YXRlEkgKCW9wZXJhdGlvbhgD'
    'IAEoDjIeLnN5bmN0di5jbGllbnQuT0F1dGgyT3BlcmF0aW9uQgq6SAeCAQQQASAAUglvcGVyYX'
    'Rpb24=');

@$core.Deprecated('Use getAuthorizationUrlForBindRequestDescriptor instead')
const GetAuthorizationUrlForBindRequest$json = {
  '1': 'GetAuthorizationUrlForBindRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
    {'1': 'redirect_url', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'redirectUrl'},
    {
      '1': 'verification_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'verificationId'
    },
  ],
};

/// Descriptor for `GetAuthorizationUrlForBindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuthorizationUrlForBindRequestDescriptor = $convert.base64Decode(
    'CiFHZXRBdXRob3JpemF0aW9uVXJsRm9yQmluZFJlcXVlc3QSNwoIcHJvdmlkZXIYASABKAlCG7'
    'pIGHIWEAEYQDIQXltBLVphLXowLTlfLV0rJFIIcHJvdmlkZXISwgIKDHJlZGlyZWN0X3VybBgC'
    'IAEoCUKeArpImgK6AZYCCjJvYXV0aDIuZ2V0X2F1dGhvcml6YXRpb25fdXJsX2Zvcl9iaW5kLn'
    'JlZGlyZWN0X3VybBJAcmVkaXJlY3RfdXJsIG11c3QgYmUgZW1wdHksIGFuIGh0dHBzIFVSTCwg'
    'b3IgYSBsb29wYmFjayBodHRwIFVSTBqdAXRoaXMgPT0gJycgfHwgKHNpemUodGhpcykgPD0gMj'
    'A0OCAmJiAodGhpcy5tYXRjaGVzKCdeaHR0cHM6Ly9bXlxcc10rJCcpIHx8IHRoaXMubWF0Y2hl'
    'cygnXmh0dHA6Ly8oMTI3XFwuMFxcLjBcXC4xfGxvY2FsaG9zdHxcXFs6OjFcXF0pKDpbMC05XS'
    'spPy9bXlxcc10qJCcpKSlSC3JlZGlyZWN0VXJsEjMKD3ZlcmlmaWNhdGlvbl9pZBgDIAEoCUIK'
    'ukgHcgUQARiAAVIOdmVyaWZpY2F0aW9uSWQ=');

@$core.Deprecated('Use getAuthorizationUrlForBindResponseDescriptor instead')
const GetAuthorizationUrlForBindResponse$json = {
  '1': 'GetAuthorizationUrlForBindResponse',
  '2': [
    {
      '1': 'authorization_url',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'authorizationUrl'
    },
    {'1': 'state', '3': 2, '4': 1, '5': 9, '10': 'state'},
    {
      '1': 'operation',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2Operation',
      '8': {},
      '10': 'operation'
    },
  ],
};

/// Descriptor for `GetAuthorizationUrlForBindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuthorizationUrlForBindResponseDescriptor =
    $convert.base64Decode(
        'CiJHZXRBdXRob3JpemF0aW9uVXJsRm9yQmluZFJlc3BvbnNlEisKEWF1dGhvcml6YXRpb25fdX'
        'JsGAEgASgJUhBhdXRob3JpemF0aW9uVXJsEhQKBXN0YXRlGAIgASgJUgVzdGF0ZRJICglvcGVy'
        'YXRpb24YAyABKA4yHi5zeW5jdHYuY2xpZW50Lk9BdXRoMk9wZXJhdGlvbkIKukgHggEEEAEgAF'
        'IJb3BlcmF0aW9u');

@$core.Deprecated('Use exchangeAuthorizationCodeRequestDescriptor instead')
const ExchangeAuthorizationCodeRequest$json = {
  '1': 'ExchangeAuthorizationCodeRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'state', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'state'},
  ],
};

/// Descriptor for `ExchangeAuthorizationCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeAuthorizationCodeRequestDescriptor =
    $convert.base64Decode(
        'CiBFeGNoYW5nZUF1dGhvcml6YXRpb25Db2RlUmVxdWVzdBIyCgRjb2RlGAEgASgJQh66SBtyGR'
        'ABGIACMhJeW0EtWmEtejAtOS5fKy1dKyRSBGNvZGUSLgoFc3RhdGUYAiABKAlCGLpIFXITMg5e'
        'W0EtWmEtejAtOV0rJJgBIFIFc3RhdGU=');

@$core.Deprecated('Use exchangeAuthorizationCodeResponseDescriptor instead')
const ExchangeAuthorizationCodeResponse$json = {
  '1': 'ExchangeAuthorizationCodeResponse',
  '2': [
    {
      '1': 'access_token',
      '3': 1,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'accessToken',
      '17': true
    },
    {
      '1': 'refresh_token',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'refreshToken',
      '17': true
    },
    {'1': 'expires_in', '3': 3, '4': 1, '5': 3, '10': 'expiresIn'},
    {
      '1': 'user_info',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.OAuth2UserInfo',
      '10': 'userInfo'
    },
    {
      '1': 'redirect_url',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'redirectUrl',
      '17': true
    },
    {
      '1': 'operation',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2Operation',
      '8': {},
      '10': 'operation'
    },
    {
      '1': 'registration_review_required',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'registrationReviewRequired'
    },
    {
      '1': 'registration_review_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'registrationReviewId',
      '17': true
    },
  ],
  '8': [
    {'1': '_access_token'},
    {'1': '_refresh_token'},
    {'1': '_redirect_url'},
    {'1': '_registration_review_id'},
  ],
};

/// Descriptor for `ExchangeAuthorizationCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeAuthorizationCodeResponseDescriptor = $convert.base64Decode(
    'CiFFeGNoYW5nZUF1dGhvcml6YXRpb25Db2RlUmVzcG9uc2USJgoMYWNjZXNzX3Rva2VuGAEgAS'
    'gJSABSC2FjY2Vzc1Rva2VuiAEBEigKDXJlZnJlc2hfdG9rZW4YAiABKAlIAVIMcmVmcmVzaFRv'
    'a2VuiAEBEh0KCmV4cGlyZXNfaW4YAyABKANSCWV4cGlyZXNJbhI6Cgl1c2VyX2luZm8YBCABKA'
    'syHS5zeW5jdHYuY2xpZW50Lk9BdXRoMlVzZXJJbmZvUgh1c2VySW5mbxImCgxyZWRpcmVjdF91'
    'cmwYBSABKAlIAlILcmVkaXJlY3RVcmyIAQESSAoJb3BlcmF0aW9uGAYgASgOMh4uc3luY3R2Lm'
    'NsaWVudC5PQXV0aDJPcGVyYXRpb25CCrpIB4IBBBABIABSCW9wZXJhdGlvbhJAChxyZWdpc3Ry'
    'YXRpb25fcmV2aWV3X3JlcXVpcmVkGAcgASgIUhpyZWdpc3RyYXRpb25SZXZpZXdSZXF1aXJlZB'
    'I5ChZyZWdpc3RyYXRpb25fcmV2aWV3X2lkGAggASgJSANSFHJlZ2lzdHJhdGlvblJldmlld0lk'
    'iAEBQg8KDV9hY2Nlc3NfdG9rZW5CEAoOX3JlZnJlc2hfdG9rZW5CDwoNX3JlZGlyZWN0X3VybE'
    'IZChdfcmVnaXN0cmF0aW9uX3Jldmlld19pZA==');

@$core.Deprecated('Use listAvailableProvidersRequestDescriptor instead')
const ListAvailableProvidersRequest$json = {
  '1': 'ListAvailableProvidersRequest',
};

/// Descriptor for `ListAvailableProvidersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAvailableProvidersRequestDescriptor =
    $convert.base64Decode('Ch1MaXN0QXZhaWxhYmxlUHJvdmlkZXJzUmVxdWVzdA==');

@$core.Deprecated('Use listAvailableProvidersResponseDescriptor instead')
const ListAvailableProvidersResponse$json = {
  '1': 'ListAvailableProvidersResponse',
  '2': [
    {
      '1': 'providers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.OAuth2ProviderInstance',
      '10': 'providers'
    },
  ],
};

/// Descriptor for `ListAvailableProvidersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAvailableProvidersResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0QXZhaWxhYmxlUHJvdmlkZXJzUmVzcG9uc2USQwoJcHJvdmlkZXJzGAEgAygLMiUuc3'
        'luY3R2LmNsaWVudC5PQXV0aDJQcm92aWRlckluc3RhbmNlUglwcm92aWRlcnM=');

@$core.Deprecated('Use oAuth2ProviderInstanceDescriptor instead')
const OAuth2ProviderInstance$json = {
  '1': 'OAuth2ProviderInstance',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2ProviderType',
      '8': {},
      '10': 'type'
    },
    {'1': 'signup_enabled', '3': 3, '4': 1, '5': 8, '10': 'signupEnabled'},
    {
      '1': 'signup_need_review',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'signupNeedReview'
    },
  ],
};

/// Descriptor for `OAuth2ProviderInstance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2ProviderInstanceDescriptor = $convert.base64Decode(
    'ChZPQXV0aDJQcm92aWRlckluc3RhbmNlEhIKBG5hbWUYASABKAlSBG5hbWUSQQoEdHlwZRgCIA'
    'EoDjIhLnN5bmN0di5jbGllbnQuT0F1dGgyUHJvdmlkZXJUeXBlQgq6SAeCAQQQASAAUgR0eXBl'
    'EiUKDnNpZ251cF9lbmFibGVkGAMgASgIUg1zaWdudXBFbmFibGVkEiwKEnNpZ251cF9uZWVkX3'
    'JldmlldxgEIAEoCFIQc2lnbnVwTmVlZFJldmlldw==');

@$core.Deprecated('Use unlinkProviderRequestDescriptor instead')
const UnlinkProviderRequest$json = {
  '1': 'UnlinkProviderRequest',
  '2': [
    {
      '1': 'provider',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2ProviderType',
      '8': {},
      '10': 'provider'
    },
    {
      '1': 'provider_user_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerUserId'
    },
    {
      '1': 'provider_instance_name',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'providerInstanceName'
    },
    {
      '1': 'verification_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '8': {},
      '10': 'verificationId'
    },
  ],
  '7': {},
};

/// Descriptor for `UnlinkProviderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkProviderRequestDescriptor = $convert.base64Decode(
    'ChVVbmxpbmtQcm92aWRlclJlcXVlc3QSSQoIcHJvdmlkZXIYASABKA4yIS5zeW5jdHYuY2xpZW'
    '50Lk9BdXRoMlByb3ZpZGVyVHlwZUIKukgHggEEEAEgAFIIcHJvdmlkZXIS7AEKEHByb3ZpZGVy'
    'X3VzZXJfaWQYAiABKAlCwQG6SL0BugG5AQonb2F1dGgyLnVubGlua19wcm92aWRlci5wcm92aW'
    'Rlcl91c2VyX2lkEkBwcm92aWRlcl91c2VyX2lkIG11c3QgYmUgZW1wdHkgb3IgYXQgbW9zdCAy'
    'NTYgdmlzaWJsZSBjaGFyYWN0ZXJzGkx0aGlzID09ICcnIHx8IChzaXplKHRoaXMpIDw9IDI1Ni'
    'AmJiAhdGhpcy5tYXRjaGVzKCcuKltcXHgwMC1cXHgxRlxceDdGXS4qJykpUg5wcm92aWRlclVz'
    'ZXJJZBJSChZwcm92aWRlcl9pbnN0YW5jZV9uYW1lGAMgASgJQhy6SBlyFBhAMhBeW0EtWmEtej'
    'AtOV8tXSsk2AEBUhRwcm92aWRlckluc3RhbmNlTmFtZRIzCg92ZXJpZmljYXRpb25faWQYBCAB'
    'KAlCCrpIB3IFEAEYgAFSDnZlcmlmaWNhdGlvbklkOsEBuki9ARq6AQo1b2F1dGgyLnVubGlua1'
    '9wcm92aWRlci5pbnN0YW5jZV9mb3Jfc3BlY2lmaWNfaWRlbnRpdHkSP3Byb3ZpZGVyX2luc3Rh'
    'bmNlX25hbWUgaXMgcmVxdWlyZWQgd2hlbiBwcm92aWRlcl91c2VyX2lkIGlzIHNldBpAdGhpcy'
    '5wcm92aWRlcl91c2VyX2lkID09ICcnIHx8IHRoaXMucHJvdmlkZXJfaW5zdGFuY2VfbmFtZSAh'
    'PSAnJw==');

@$core.Deprecated('Use unlinkProviderResponseDescriptor instead')
const UnlinkProviderResponse$json = {
  '1': 'UnlinkProviderResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'removed_count', '3': 2, '4': 1, '5': 5, '10': 'removedCount'},
  ],
};

/// Descriptor for `UnlinkProviderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkProviderResponseDescriptor =
    $convert.base64Decode(
        'ChZVbmxpbmtQcm92aWRlclJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSIwoNcm'
        'Vtb3ZlZF9jb3VudBgCIAEoBVIMcmVtb3ZlZENvdW50');

@$core.Deprecated('Use getLinkedProvidersRequestDescriptor instead')
const GetLinkedProvidersRequest$json = {
  '1': 'GetLinkedProvidersRequest',
};

/// Descriptor for `GetLinkedProvidersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLinkedProvidersRequestDescriptor =
    $convert.base64Decode('ChlHZXRMaW5rZWRQcm92aWRlcnNSZXF1ZXN0');

@$core.Deprecated('Use getLinkedProvidersResponseDescriptor instead')
const GetLinkedProvidersResponse$json = {
  '1': 'GetLinkedProvidersResponse',
  '2': [
    {
      '1': 'providers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.client.LinkedProvider',
      '10': 'providers'
    },
  ],
};

/// Descriptor for `GetLinkedProvidersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLinkedProvidersResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRMaW5rZWRQcm92aWRlcnNSZXNwb25zZRI7Cglwcm92aWRlcnMYASADKAsyHS5zeW5jdH'
        'YuY2xpZW50LkxpbmtlZFByb3ZpZGVyUglwcm92aWRlcnM=');

@$core.Deprecated('Use linkedProviderDescriptor instead')
const LinkedProvider$json = {
  '1': 'LinkedProvider',
  '2': [
    {
      '1': 'provider_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.synctv.client.OAuth2ProviderType',
      '8': {},
      '10': 'providerType'
    },
    {
      '1': 'provider_username',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'providerUsername'
    },
    {'1': 'linked_at', '3': 3, '4': 1, '5': 3, '10': 'linkedAt'},
    {
      '1': 'provider_instance_name',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
    {
      '1': 'provider_issuer',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'providerIssuer',
      '17': true
    },
    {'1': 'provider_user_id', '3': 6, '4': 1, '5': 9, '10': 'providerUserId'},
  ],
  '8': [
    {'1': '_provider_issuer'},
  ],
};

/// Descriptor for `LinkedProvider`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkedProviderDescriptor = $convert.base64Decode(
    'Cg5MaW5rZWRQcm92aWRlchJSCg1wcm92aWRlcl90eXBlGAEgASgOMiEuc3luY3R2LmNsaWVudC'
    '5PQXV0aDJQcm92aWRlclR5cGVCCrpIB4IBBBABIABSDHByb3ZpZGVyVHlwZRIrChFwcm92aWRl'
    'cl91c2VybmFtZRgCIAEoCVIQcHJvdmlkZXJVc2VybmFtZRIbCglsaW5rZWRfYXQYAyABKANSCG'
    'xpbmtlZEF0EjQKFnByb3ZpZGVyX2luc3RhbmNlX25hbWUYBCABKAlSFHByb3ZpZGVySW5zdGFu'
    'Y2VOYW1lEiwKD3Byb3ZpZGVyX2lzc3VlchgFIAEoCUgAUg5wcm92aWRlcklzc3VlcogBARIoCh'
    'Bwcm92aWRlcl91c2VyX2lkGAYgASgJUg5wcm92aWRlclVzZXJJZEISChBfcHJvdmlkZXJfaXNz'
    'dWVy');

@$core.Deprecated('Use oAuth2UserInfoDescriptor instead')
const OAuth2UserInfo$json = {
  '1': 'OAuth2UserInfo',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'avatar', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'avatar', '17': true},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '10': 'role'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
  ],
  '8': [
    {'1': '_avatar'},
  ],
};

/// Descriptor for `OAuth2UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2UserInfoDescriptor = $convert.base64Decode(
    'Cg5PQXV0aDJVc2VySW5mbxIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGgoIdXNlcm5hbWUYAi'
    'ABKAlSCHVzZXJuYW1lEhsKBmF2YXRhchgDIAEoCUgAUgZhdmF0YXKIAQESKwoEcm9sZRgEIAEo'
    'DjIXLnN5bmN0di5jb21tb24uVXNlclJvbGVSBHJvbGUSMQoGc3RhdHVzGAUgASgOMhkuc3luY3'
    'R2LmNvbW1vbi5Vc2VyU3RhdHVzUgZzdGF0dXMSHQoKY3JlYXRlZF9hdBgGIAEoA1IJY3JlYXRl'
    'ZEF0QgkKB19hdmF0YXI=');

const $core.Map<$core.String, $core.dynamic> OAuth2ServiceBase$json = {
  '1': 'OAuth2Service',
  '2': [
    {
      '1': 'GetAuthorizationUrl',
      '2': '.synctv.client.GetAuthorizationUrlRequest',
      '3': '.synctv.client.GetAuthorizationUrlResponse'
    },
    {
      '1': 'GetAuthorizationUrlForBind',
      '2': '.synctv.client.GetAuthorizationUrlForBindRequest',
      '3': '.synctv.client.GetAuthorizationUrlForBindResponse'
    },
    {
      '1': 'ExchangeAuthorizationCode',
      '2': '.synctv.client.ExchangeAuthorizationCodeRequest',
      '3': '.synctv.client.ExchangeAuthorizationCodeResponse'
    },
    {
      '1': 'ListAvailableProviders',
      '2': '.synctv.client.ListAvailableProvidersRequest',
      '3': '.synctv.client.ListAvailableProvidersResponse'
    },
    {
      '1': 'UnlinkProvider',
      '2': '.synctv.client.UnlinkProviderRequest',
      '3': '.synctv.client.UnlinkProviderResponse'
    },
    {
      '1': 'GetLinkedProviders',
      '2': '.synctv.client.GetLinkedProvidersRequest',
      '3': '.synctv.client.GetLinkedProvidersResponse'
    },
  ],
};

@$core.Deprecated('Use oAuth2ServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    OAuth2ServiceBase$messageJson = {
  '.synctv.client.GetAuthorizationUrlRequest': GetAuthorizationUrlRequest$json,
  '.synctv.client.GetAuthorizationUrlResponse':
      GetAuthorizationUrlResponse$json,
  '.synctv.client.GetAuthorizationUrlForBindRequest':
      GetAuthorizationUrlForBindRequest$json,
  '.synctv.client.GetAuthorizationUrlForBindResponse':
      GetAuthorizationUrlForBindResponse$json,
  '.synctv.client.ExchangeAuthorizationCodeRequest':
      ExchangeAuthorizationCodeRequest$json,
  '.synctv.client.ExchangeAuthorizationCodeResponse':
      ExchangeAuthorizationCodeResponse$json,
  '.synctv.client.OAuth2UserInfo': OAuth2UserInfo$json,
  '.synctv.client.ListAvailableProvidersRequest':
      ListAvailableProvidersRequest$json,
  '.synctv.client.ListAvailableProvidersResponse':
      ListAvailableProvidersResponse$json,
  '.synctv.client.OAuth2ProviderInstance': OAuth2ProviderInstance$json,
  '.synctv.client.UnlinkProviderRequest': UnlinkProviderRequest$json,
  '.synctv.client.UnlinkProviderResponse': UnlinkProviderResponse$json,
  '.synctv.client.GetLinkedProvidersRequest': GetLinkedProvidersRequest$json,
  '.synctv.client.GetLinkedProvidersResponse': GetLinkedProvidersResponse$json,
  '.synctv.client.LinkedProvider': LinkedProvider$json,
};

/// Descriptor for `OAuth2Service`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List oAuth2ServiceDescriptor = $convert.base64Decode(
    'Cg1PQXV0aDJTZXJ2aWNlEmwKE0dldEF1dGhvcml6YXRpb25VcmwSKS5zeW5jdHYuY2xpZW50Lk'
    'dldEF1dGhvcml6YXRpb25VcmxSZXF1ZXN0Giouc3luY3R2LmNsaWVudC5HZXRBdXRob3JpemF0'
    'aW9uVXJsUmVzcG9uc2USgQEKGkdldEF1dGhvcml6YXRpb25VcmxGb3JCaW5kEjAuc3luY3R2Lm'
    'NsaWVudC5HZXRBdXRob3JpemF0aW9uVXJsRm9yQmluZFJlcXVlc3QaMS5zeW5jdHYuY2xpZW50'
    'LkdldEF1dGhvcml6YXRpb25VcmxGb3JCaW5kUmVzcG9uc2USfgoZRXhjaGFuZ2VBdXRob3Jpem'
    'F0aW9uQ29kZRIvLnN5bmN0di5jbGllbnQuRXhjaGFuZ2VBdXRob3JpemF0aW9uQ29kZVJlcXVl'
    'c3QaMC5zeW5jdHYuY2xpZW50LkV4Y2hhbmdlQXV0aG9yaXphdGlvbkNvZGVSZXNwb25zZRJ1Ch'
    'ZMaXN0QXZhaWxhYmxlUHJvdmlkZXJzEiwuc3luY3R2LmNsaWVudC5MaXN0QXZhaWxhYmxlUHJv'
    'dmlkZXJzUmVxdWVzdBotLnN5bmN0di5jbGllbnQuTGlzdEF2YWlsYWJsZVByb3ZpZGVyc1Jlc3'
    'BvbnNlEl0KDlVubGlua1Byb3ZpZGVyEiQuc3luY3R2LmNsaWVudC5VbmxpbmtQcm92aWRlclJl'
    'cXVlc3QaJS5zeW5jdHYuY2xpZW50LlVubGlua1Byb3ZpZGVyUmVzcG9uc2USaQoSR2V0TGlua2'
    'VkUHJvdmlkZXJzEiguc3luY3R2LmNsaWVudC5HZXRMaW5rZWRQcm92aWRlcnNSZXF1ZXN0Giku'
    'c3luY3R2LmNsaWVudC5HZXRMaW5rZWRQcm92aWRlcnNSZXNwb25zZQ==');
