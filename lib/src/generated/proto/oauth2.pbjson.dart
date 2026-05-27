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
  ],
};

/// Descriptor for `GetAuthorizationUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuthorizationUrlResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRBdXRob3JpemF0aW9uVXJsUmVzcG9uc2USKwoRYXV0aG9yaXphdGlvbl91cmwYASABKA'
        'lSEGF1dGhvcml6YXRpb25VcmwSFAoFc3RhdGUYAiABKAlSBXN0YXRl');

@$core.Deprecated('Use getAuthorizationUrlForBindRequestDescriptor instead')
const GetAuthorizationUrlForBindRequest$json = {
  '1': 'GetAuthorizationUrlForBindRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
    {'1': 'redirect_url', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'redirectUrl'},
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
    'spPy9bXlxcc10qJCcpKSlSC3JlZGlyZWN0VXJs');

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
  ],
};

/// Descriptor for `GetAuthorizationUrlForBindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuthorizationUrlForBindResponseDescriptor =
    $convert.base64Decode(
        'CiJHZXRBdXRob3JpemF0aW9uVXJsRm9yQmluZFJlc3BvbnNlEisKEWF1dGhvcml6YXRpb25fdX'
        'JsGAEgASgJUhBhdXRob3JpemF0aW9uVXJsEhQKBXN0YXRlGAIgASgJUgVzdGF0ZQ==');

@$core.Deprecated('Use exchangeAuthorizationCodeRequestDescriptor instead')
const ExchangeAuthorizationCodeRequest$json = {
  '1': 'ExchangeAuthorizationCodeRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'code'},
    {'1': 'state', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'state'},
  ],
};

/// Descriptor for `ExchangeAuthorizationCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeAuthorizationCodeRequestDescriptor =
    $convert.base64Decode(
        'CiBFeGNoYW5nZUF1dGhvcml6YXRpb25Db2RlUmVxdWVzdBI3Cghwcm92aWRlchgBIAEoCUIbuk'
        'gYchYQARhAMhBeW0EtWmEtejAtOV8tXSskUghwcm92aWRlchIyCgRjb2RlGAIgASgJQh66SBty'
        'GRABGIACMhJeW0EtWmEtejAtOS5fKy1dKyRSBGNvZGUSLgoFc3RhdGUYAyABKAlCGLpIFXITMg'
        '5eW0EtWmEtejAtOV0rJJgBIFIFc3RhdGU=');

@$core.Deprecated('Use exchangeAuthorizationCodeResponseDescriptor instead')
const ExchangeAuthorizationCodeResponse$json = {
  '1': 'ExchangeAuthorizationCodeResponse',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
    {'1': 'expires_in', '3': 3, '4': 1, '5': 3, '10': 'expiresIn'},
    {
      '1': 'user_info',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.synctv.client.OAuth2UserInfo',
      '10': 'userInfo'
    },
    {'1': 'redirect_url', '3': 5, '4': 1, '5': 9, '10': 'redirectUrl'},
    {'1': 'is_bind', '3': 6, '4': 1, '5': 8, '10': 'isBind'},
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
      '10': 'registrationReviewId'
    },
  ],
};

/// Descriptor for `ExchangeAuthorizationCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeAuthorizationCodeResponseDescriptor = $convert.base64Decode(
    'CiFFeGNoYW5nZUF1dGhvcml6YXRpb25Db2RlUmVzcG9uc2USIQoMYWNjZXNzX3Rva2VuGAEgAS'
    'gJUgthY2Nlc3NUb2tlbhIjCg1yZWZyZXNoX3Rva2VuGAIgASgJUgxyZWZyZXNoVG9rZW4SHQoK'
    'ZXhwaXJlc19pbhgDIAEoA1IJZXhwaXJlc0luEjoKCXVzZXJfaW5mbxgEIAEoCzIdLnN5bmN0di'
    '5jbGllbnQuT0F1dGgyVXNlckluZm9SCHVzZXJJbmZvEiEKDHJlZGlyZWN0X3VybBgFIAEoCVIL'
    'cmVkaXJlY3RVcmwSFwoHaXNfYmluZBgGIAEoCFIGaXNCaW5kEkAKHHJlZ2lzdHJhdGlvbl9yZX'
    'ZpZXdfcmVxdWlyZWQYByABKAhSGnJlZ2lzdHJhdGlvblJldmlld1JlcXVpcmVkEjQKFnJlZ2lz'
    'dHJhdGlvbl9yZXZpZXdfaWQYCCABKAlSFHJlZ2lzdHJhdGlvblJldmlld0lk');

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
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
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
    'ChZPQXV0aDJQcm92aWRlckluc3RhbmNlEhIKBG5hbWUYASABKAlSBG5hbWUSEgoEdHlwZRgCIA'
    'EoCVIEdHlwZRIlCg5zaWdudXBfZW5hYmxlZBgDIAEoCFINc2lnbnVwRW5hYmxlZBIsChJzaWdu'
    'dXBfbmVlZF9yZXZpZXcYBCABKAhSEHNpZ251cE5lZWRSZXZpZXc=');

@$core.Deprecated('Use unlinkProviderRequestDescriptor instead')
const UnlinkProviderRequest$json = {
  '1': 'UnlinkProviderRequest',
  '2': [
    {'1': 'provider', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'provider'},
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
  ],
  '7': {},
};

/// Descriptor for `UnlinkProviderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkProviderRequestDescriptor = $convert.base64Decode(
    'ChVVbmxpbmtQcm92aWRlclJlcXVlc3QSbQoIcHJvdmlkZXIYASABKAlCUbpITnJMEAEYIDJGXi'
    'hxcXxnaXRodWJ8Z29vZ2xlfG1pY3Jvc29mdHxkaXNjb3JkfGNhc2Rvb3J8bG9ndG98b2lkY3xm'
    'ZWlzaHV8Z2l0ZWUpJFIIcHJvdmlkZXIS7AEKEHByb3ZpZGVyX3VzZXJfaWQYAiABKAlCwQG6SL'
    '0BugG5AQonb2F1dGgyLnVubGlua19wcm92aWRlci5wcm92aWRlcl91c2VyX2lkEkBwcm92aWRl'
    'cl91c2VyX2lkIG11c3QgYmUgZW1wdHkgb3IgYXQgbW9zdCAyNTYgdmlzaWJsZSBjaGFyYWN0ZX'
    'JzGkx0aGlzID09ICcnIHx8IChzaXplKHRoaXMpIDw9IDI1NiAmJiAhdGhpcy5tYXRjaGVzKCcu'
    'KltcXHgwMC1cXHgxRlxceDdGXS4qJykpUg5wcm92aWRlclVzZXJJZBJSChZwcm92aWRlcl9pbn'
    'N0YW5jZV9uYW1lGAMgASgJQhy6SBlyFBhAMhBeW0EtWmEtejAtOV8tXSsk2AEBUhRwcm92aWRl'
    'ckluc3RhbmNlTmFtZTrBAbpIvQEaugEKNW9hdXRoMi51bmxpbmtfcHJvdmlkZXIuaW5zdGFuY2'
    'VfZm9yX3NwZWNpZmljX2lkZW50aXR5Ej9wcm92aWRlcl9pbnN0YW5jZV9uYW1lIGlzIHJlcXVp'
    'cmVkIHdoZW4gcHJvdmlkZXJfdXNlcl9pZCBpcyBzZXQaQHRoaXMucHJvdmlkZXJfdXNlcl9pZC'
    'A9PSAnJyB8fCB0aGlzLnByb3ZpZGVyX2luc3RhbmNlX25hbWUgIT0gJyc=');

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
    {'1': 'provider_type', '3': 1, '4': 1, '5': 9, '10': 'providerType'},
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
    {'1': 'provider_issuer', '3': 5, '4': 1, '5': 9, '10': 'providerIssuer'},
    {'1': 'provider_user_id', '3': 6, '4': 1, '5': 9, '10': 'providerUserId'},
  ],
};

/// Descriptor for `LinkedProvider`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkedProviderDescriptor = $convert.base64Decode(
    'Cg5MaW5rZWRQcm92aWRlchIjCg1wcm92aWRlcl90eXBlGAEgASgJUgxwcm92aWRlclR5cGUSKw'
    'oRcHJvdmlkZXJfdXNlcm5hbWUYAiABKAlSEHByb3ZpZGVyVXNlcm5hbWUSGwoJbGlua2VkX2F0'
    'GAMgASgDUghsaW5rZWRBdBI0ChZwcm92aWRlcl9pbnN0YW5jZV9uYW1lGAQgASgJUhRwcm92aW'
    'Rlckluc3RhbmNlTmFtZRInCg9wcm92aWRlcl9pc3N1ZXIYBSABKAlSDnByb3ZpZGVySXNzdWVy'
    'EigKEHByb3ZpZGVyX3VzZXJfaWQYBiABKAlSDnByb3ZpZGVyVXNlcklk');

@$core.Deprecated('Use oAuth2UserInfoDescriptor instead')
const OAuth2UserInfo$json = {
  '1': 'OAuth2UserInfo',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'avatar', '3': 4, '4': 1, '5': 9, '10': 'avatar'},
    {
      '1': 'role',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserRole',
      '10': 'role'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.synctv.common.UserStatus',
      '10': 'status'
    },
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
  ],
};

/// Descriptor for `OAuth2UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oAuth2UserInfoDescriptor = $convert.base64Decode(
    'Cg5PQXV0aDJVc2VySW5mbxIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGgoIdXNlcm5hbWUYAi'
    'ABKAlSCHVzZXJuYW1lEhQKBWVtYWlsGAMgASgJUgVlbWFpbBIWCgZhdmF0YXIYBCABKAlSBmF2'
    'YXRhchIrCgRyb2xlGAUgASgOMhcuc3luY3R2LmNvbW1vbi5Vc2VyUm9sZVIEcm9sZRIxCgZzdG'
    'F0dXMYBiABKA4yGS5zeW5jdHYuY29tbW9uLlVzZXJTdGF0dXNSBnN0YXR1cxIdCgpjcmVhdGVk'
    'X2F0GAcgASgDUgljcmVhdGVkQXQ=');
