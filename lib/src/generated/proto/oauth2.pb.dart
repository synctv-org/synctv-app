// This is a generated file - do not edit.
//
// Generated from proto/oauth2.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart' as $0;
import 'oauth2.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'oauth2.pbenum.dart';

class OAuth2ProviderInstancePathRequest extends $pb.GeneratedMessage {
  factory OAuth2ProviderInstancePathRequest({
    $core.String? provider,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    return result;
  }

  OAuth2ProviderInstancePathRequest._();

  factory OAuth2ProviderInstancePathRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2ProviderInstancePathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2ProviderInstancePathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderInstancePathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderInstancePathRequest copyWith(
          void Function(OAuth2ProviderInstancePathRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OAuth2ProviderInstancePathRequest))
          as OAuth2ProviderInstancePathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderInstancePathRequest create() =>
      OAuth2ProviderInstancePathRequest._();
  @$core.override
  OAuth2ProviderInstancePathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderInstancePathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2ProviderInstancePathRequest>(
          create);
  static OAuth2ProviderInstancePathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);
}

class OAuth2ProviderTypePathRequest extends $pb.GeneratedMessage {
  factory OAuth2ProviderTypePathRequest({
    $core.String? provider,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    return result;
  }

  OAuth2ProviderTypePathRequest._();

  factory OAuth2ProviderTypePathRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2ProviderTypePathRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2ProviderTypePathRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderTypePathRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderTypePathRequest copyWith(
          void Function(OAuth2ProviderTypePathRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OAuth2ProviderTypePathRequest))
          as OAuth2ProviderTypePathRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderTypePathRequest create() =>
      OAuth2ProviderTypePathRequest._();
  @$core.override
  OAuth2ProviderTypePathRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderTypePathRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2ProviderTypePathRequest>(create);
  static OAuth2ProviderTypePathRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);
}

class GetAuthorizationUrlRequest extends $pb.GeneratedMessage {
  factory GetAuthorizationUrlRequest({
    $core.String? provider,
    $core.String? redirectUrl,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    return result;
  }

  GetAuthorizationUrlRequest._();

  factory GetAuthorizationUrlRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAuthorizationUrlRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAuthorizationUrlRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..aOS(2, _omitFieldNames ? '' : 'redirectUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlRequest copyWith(
          void Function(GetAuthorizationUrlRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetAuthorizationUrlRequest))
          as GetAuthorizationUrlRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlRequest create() => GetAuthorizationUrlRequest._();
  @$core.override
  GetAuthorizationUrlRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAuthorizationUrlRequest>(create);
  static GetAuthorizationUrlRequest? _defaultInstance;

  /// OAuth2 provider instance name (e.g., "github", "google", "logto1")
  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  /// Optional OAuth2 callback URL for this authorization flow.
  /// Clients use HTTPS App Links/Universal Links on mobile and loopback HTTP
  /// URLs on desktop. Custom URL schemes are not supported.
  @$pb.TagNumber(2)
  $core.String get redirectUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set redirectUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRedirectUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedirectUrl() => $_clearField(2);
}

class GetAuthorizationUrlResponse extends $pb.GeneratedMessage {
  factory GetAuthorizationUrlResponse({
    $core.String? authorizationUrl,
    $core.String? state,
    OAuth2Operation? operation,
  }) {
    final result = create();
    if (authorizationUrl != null) result.authorizationUrl = authorizationUrl;
    if (state != null) result.state = state;
    if (operation != null) result.operation = operation;
    return result;
  }

  GetAuthorizationUrlResponse._();

  factory GetAuthorizationUrlResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAuthorizationUrlResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAuthorizationUrlResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authorizationUrl')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..aE<OAuth2Operation>(3, _omitFieldNames ? '' : 'operation',
        enumValues: OAuth2Operation.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlResponse copyWith(
          void Function(GetAuthorizationUrlResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetAuthorizationUrlResponse))
          as GetAuthorizationUrlResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlResponse create() =>
      GetAuthorizationUrlResponse._();
  @$core.override
  GetAuthorizationUrlResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAuthorizationUrlResponse>(create);
  static GetAuthorizationUrlResponse? _defaultInstance;

  /// Authorization URL to redirect user to
  /// Frontend should redirect the browser to this URL
  @$pb.TagNumber(1)
  $core.String get authorizationUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorizationUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorizationUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorizationUrl() => $_clearField(1);

  /// State token for CSRF protection
  /// Frontend should store this temporarily and validate it matches the state
  /// received in the callback URL parameters
  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  OAuth2Operation get operation => $_getN(2);
  @$pb.TagNumber(3)
  set operation(OAuth2Operation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOperation() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperation() => $_clearField(3);
}

class GetAuthorizationUrlForBindRequest extends $pb.GeneratedMessage {
  factory GetAuthorizationUrlForBindRequest({
    $core.String? provider,
    $core.String? redirectUrl,
    $core.String? verificationId,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    if (verificationId != null) result.verificationId = verificationId;
    return result;
  }

  GetAuthorizationUrlForBindRequest._();

  factory GetAuthorizationUrlForBindRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAuthorizationUrlForBindRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAuthorizationUrlForBindRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'provider')
    ..aOS(2, _omitFieldNames ? '' : 'redirectUrl')
    ..aOS(3, _omitFieldNames ? '' : 'verificationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlForBindRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlForBindRequest copyWith(
          void Function(GetAuthorizationUrlForBindRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetAuthorizationUrlForBindRequest))
          as GetAuthorizationUrlForBindRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlForBindRequest create() =>
      GetAuthorizationUrlForBindRequest._();
  @$core.override
  GetAuthorizationUrlForBindRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlForBindRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAuthorizationUrlForBindRequest>(
          create);
  static GetAuthorizationUrlForBindRequest? _defaultInstance;

  /// OAuth2 provider instance name (e.g., "github", "google", "logto1")
  @$pb.TagNumber(1)
  $core.String get provider => $_getSZ(0);
  @$pb.TagNumber(1)
  set provider($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  /// Optional OAuth2 callback URL for this bind flow.
  /// Clients use HTTPS App Links/Universal Links on mobile and loopback HTTP
  /// URLs on desktop. Custom URL schemes are not supported.
  @$pb.TagNumber(2)
  $core.String get redirectUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set redirectUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRedirectUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearRedirectUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get verificationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set verificationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerificationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerificationId() => $_clearField(3);
}

class GetAuthorizationUrlForBindResponse extends $pb.GeneratedMessage {
  factory GetAuthorizationUrlForBindResponse({
    $core.String? authorizationUrl,
    $core.String? state,
    OAuth2Operation? operation,
  }) {
    final result = create();
    if (authorizationUrl != null) result.authorizationUrl = authorizationUrl;
    if (state != null) result.state = state;
    if (operation != null) result.operation = operation;
    return result;
  }

  GetAuthorizationUrlForBindResponse._();

  factory GetAuthorizationUrlForBindResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAuthorizationUrlForBindResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAuthorizationUrlForBindResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authorizationUrl')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..aE<OAuth2Operation>(3, _omitFieldNames ? '' : 'operation',
        enumValues: OAuth2Operation.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlForBindResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAuthorizationUrlForBindResponse copyWith(
          void Function(GetAuthorizationUrlForBindResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetAuthorizationUrlForBindResponse))
          as GetAuthorizationUrlForBindResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlForBindResponse create() =>
      GetAuthorizationUrlForBindResponse._();
  @$core.override
  GetAuthorizationUrlForBindResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAuthorizationUrlForBindResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAuthorizationUrlForBindResponse>(
          create);
  static GetAuthorizationUrlForBindResponse? _defaultInstance;

  /// Authorization URL to redirect user to
  @$pb.TagNumber(1)
  $core.String get authorizationUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorizationUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorizationUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorizationUrl() => $_clearField(1);

  /// State token for CSRF protection
  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  OAuth2Operation get operation => $_getN(2);
  @$pb.TagNumber(3)
  set operation(OAuth2Operation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOperation() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperation() => $_clearField(3);
}

class ExchangeAuthorizationCodeRequest extends $pb.GeneratedMessage {
  factory ExchangeAuthorizationCodeRequest({
    $core.String? code,
    $core.String? state,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (state != null) result.state = state;
    return result;
  }

  ExchangeAuthorizationCodeRequest._();

  factory ExchangeAuthorizationCodeRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExchangeAuthorizationCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExchangeAuthorizationCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeAuthorizationCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeAuthorizationCodeRequest copyWith(
          void Function(ExchangeAuthorizationCodeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExchangeAuthorizationCodeRequest))
          as ExchangeAuthorizationCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExchangeAuthorizationCodeRequest create() =>
      ExchangeAuthorizationCodeRequest._();
  @$core.override
  ExchangeAuthorizationCodeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExchangeAuthorizationCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExchangeAuthorizationCodeRequest>(
          create);
  static ExchangeAuthorizationCodeRequest? _defaultInstance;

  /// Authorization code received from OAuth2 provider redirect
  /// Frontend extracts this from the callback URL query parameter
  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  /// State token received from OAuth2 provider redirect
  /// The server uses this opaque token to recover the provider instance,
  /// redirect URL, PKCE verifier, OIDC nonce, and bind/login context.
  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
}

class ExchangeAuthorizationCodeResponse extends $pb.GeneratedMessage {
  factory ExchangeAuthorizationCodeResponse({
    $core.String? accessToken,
    $core.String? refreshToken,
    $fixnum.Int64? expiresIn,
    OAuth2UserInfo? userInfo,
    $core.String? redirectUrl,
    OAuth2Operation? operation,
    $core.bool? registrationReviewRequired,
    $core.String? registrationReviewId,
  }) {
    final result = create();
    if (accessToken != null) result.accessToken = accessToken;
    if (refreshToken != null) result.refreshToken = refreshToken;
    if (expiresIn != null) result.expiresIn = expiresIn;
    if (userInfo != null) result.userInfo = userInfo;
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    if (operation != null) result.operation = operation;
    if (registrationReviewRequired != null)
      result.registrationReviewRequired = registrationReviewRequired;
    if (registrationReviewId != null)
      result.registrationReviewId = registrationReviewId;
    return result;
  }

  ExchangeAuthorizationCodeResponse._();

  factory ExchangeAuthorizationCodeResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExchangeAuthorizationCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExchangeAuthorizationCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accessToken')
    ..aOS(2, _omitFieldNames ? '' : 'refreshToken')
    ..aInt64(3, _omitFieldNames ? '' : 'expiresIn')
    ..aOM<OAuth2UserInfo>(4, _omitFieldNames ? '' : 'userInfo',
        subBuilder: OAuth2UserInfo.create)
    ..aOS(5, _omitFieldNames ? '' : 'redirectUrl')
    ..aE<OAuth2Operation>(6, _omitFieldNames ? '' : 'operation',
        enumValues: OAuth2Operation.values)
    ..aOB(7, _omitFieldNames ? '' : 'registrationReviewRequired')
    ..aOS(8, _omitFieldNames ? '' : 'registrationReviewId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeAuthorizationCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeAuthorizationCodeResponse copyWith(
          void Function(ExchangeAuthorizationCodeResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ExchangeAuthorizationCodeResponse))
          as ExchangeAuthorizationCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExchangeAuthorizationCodeResponse create() =>
      ExchangeAuthorizationCodeResponse._();
  @$core.override
  ExchangeAuthorizationCodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExchangeAuthorizationCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExchangeAuthorizationCodeResponse>(
          create);
  static ExchangeAuthorizationCodeResponse? _defaultInstance;

  /// JWT access token (if login flow)
  /// Empty if this is a bind flow
  @$pb.TagNumber(1)
  $core.String get accessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set accessToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccessToken() => $_clearField(1);

  /// JWT refresh token (if login flow and refresh tokens are enabled)
  @$pb.TagNumber(2)
  $core.String get refreshToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set refreshToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefreshToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefreshToken() => $_clearField(2);

  /// Token expiration time in seconds
  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresIn => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresIn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresIn() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresIn() => $_clearField(3);

  /// User information (login flow only)
  @$pb.TagNumber(4)
  OAuth2UserInfo get userInfo => $_getN(3);
  @$pb.TagNumber(4)
  set userInfo(OAuth2UserInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUserInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  OAuth2UserInfo ensureUserInfo() => $_ensure(3);

  /// Redirect URL from the original request (if provided)
  /// Frontend can use this to redirect user after successful authentication
  @$pb.TagNumber(5)
  $core.String get redirectUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set redirectUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRedirectUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearRedirectUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  OAuth2Operation get operation => $_getN(5);
  @$pb.TagNumber(6)
  set operation(OAuth2Operation value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOperation() => $_has(5);
  @$pb.TagNumber(6)
  void clearOperation() => $_clearField(6);

  /// True when a first-time OAuth2 signup was accepted but requires admin review.
  @$pb.TagNumber(7)
  $core.bool get registrationReviewRequired => $_getBF(6);
  @$pb.TagNumber(7)
  set registrationReviewRequired($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRegistrationReviewRequired() => $_has(6);
  @$pb.TagNumber(7)
  void clearRegistrationReviewRequired() => $_clearField(7);

  /// Public review request ID when registration_review_required is true.
  @$pb.TagNumber(8)
  $core.String get registrationReviewId => $_getSZ(7);
  @$pb.TagNumber(8)
  set registrationReviewId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRegistrationReviewId() => $_has(7);
  @$pb.TagNumber(8)
  void clearRegistrationReviewId() => $_clearField(8);
}

class ListAvailableProvidersRequest extends $pb.GeneratedMessage {
  factory ListAvailableProvidersRequest() => create();

  ListAvailableProvidersRequest._();

  factory ListAvailableProvidersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAvailableProvidersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAvailableProvidersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAvailableProvidersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAvailableProvidersRequest copyWith(
          void Function(ListAvailableProvidersRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListAvailableProvidersRequest))
          as ListAvailableProvidersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAvailableProvidersRequest create() =>
      ListAvailableProvidersRequest._();
  @$core.override
  ListAvailableProvidersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAvailableProvidersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAvailableProvidersRequest>(create);
  static ListAvailableProvidersRequest? _defaultInstance;
}

class ListAvailableProvidersResponse extends $pb.GeneratedMessage {
  factory ListAvailableProvidersResponse({
    $core.Iterable<OAuth2ProviderInstance>? providers,
  }) {
    final result = create();
    if (providers != null) result.providers.addAll(providers);
    return result;
  }

  ListAvailableProvidersResponse._();

  factory ListAvailableProvidersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAvailableProvidersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAvailableProvidersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<OAuth2ProviderInstance>(1, _omitFieldNames ? '' : 'providers',
        subBuilder: OAuth2ProviderInstance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAvailableProvidersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAvailableProvidersResponse copyWith(
          void Function(ListAvailableProvidersResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListAvailableProvidersResponse))
          as ListAvailableProvidersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAvailableProvidersResponse create() =>
      ListAvailableProvidersResponse._();
  @$core.override
  ListAvailableProvidersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAvailableProvidersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAvailableProvidersResponse>(create);
  static ListAvailableProvidersResponse? _defaultInstance;

  /// List of available OAuth2 provider instances
  @$pb.TagNumber(1)
  $pb.PbList<OAuth2ProviderInstance> get providers => $_getList(0);
}

class OAuth2ProviderInstance extends $pb.GeneratedMessage {
  factory OAuth2ProviderInstance({
    $core.String? name,
    OAuth2ProviderType? type,
    $core.bool? signupEnabled,
    $core.bool? signupNeedReview,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (signupEnabled != null) result.signupEnabled = signupEnabled;
    if (signupNeedReview != null) result.signupNeedReview = signupNeedReview;
    return result;
  }

  OAuth2ProviderInstance._();

  factory OAuth2ProviderInstance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2ProviderInstance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2ProviderInstance',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<OAuth2ProviderType>(2, _omitFieldNames ? '' : 'type',
        enumValues: OAuth2ProviderType.values)
    ..aOB(3, _omitFieldNames ? '' : 'signupEnabled')
    ..aOB(4, _omitFieldNames ? '' : 'signupNeedReview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderInstance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2ProviderInstance copyWith(
          void Function(OAuth2ProviderInstance) updates) =>
      super.copyWith((message) => updates(message as OAuth2ProviderInstance))
          as OAuth2ProviderInstance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderInstance create() => OAuth2ProviderInstance._();
  @$core.override
  OAuth2ProviderInstance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2ProviderInstance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2ProviderInstance>(create);
  static OAuth2ProviderInstance? _defaultInstance;

  /// Instance name (e.g., "github", "google", "logto1")
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  OAuth2ProviderType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(OAuth2ProviderType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// Whether this provider instance allows new local account creation.
  @$pb.TagNumber(3)
  $core.bool get signupEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set signupEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignupEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignupEnabled() => $_clearField(3);

  /// Whether new account creation through this provider instance requires review.
  @$pb.TagNumber(4)
  $core.bool get signupNeedReview => $_getBF(3);
  @$pb.TagNumber(4)
  set signupNeedReview($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSignupNeedReview() => $_has(3);
  @$pb.TagNumber(4)
  void clearSignupNeedReview() => $_clearField(4);
}

class UnlinkProviderRequest extends $pb.GeneratedMessage {
  factory UnlinkProviderRequest({
    OAuth2ProviderType? provider,
    $core.String? providerUserId,
    $core.String? providerInstanceName,
    $core.String? verificationId,
  }) {
    final result = create();
    if (provider != null) result.provider = provider;
    if (providerUserId != null) result.providerUserId = providerUserId;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (verificationId != null) result.verificationId = verificationId;
    return result;
  }

  UnlinkProviderRequest._();

  factory UnlinkProviderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnlinkProviderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlinkProviderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<OAuth2ProviderType>(1, _omitFieldNames ? '' : 'provider',
        enumValues: OAuth2ProviderType.values)
    ..aOS(2, _omitFieldNames ? '' : 'providerUserId')
    ..aOS(3, _omitFieldNames ? '' : 'providerInstanceName')
    ..aOS(4, _omitFieldNames ? '' : 'verificationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkProviderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkProviderRequest copyWith(
          void Function(UnlinkProviderRequest) updates) =>
      super.copyWith((message) => updates(message as UnlinkProviderRequest))
          as UnlinkProviderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkProviderRequest create() => UnlinkProviderRequest._();
  @$core.override
  UnlinkProviderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnlinkProviderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnlinkProviderRequest>(create);
  static UnlinkProviderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OAuth2ProviderType get provider => $_getN(0);
  @$pb.TagNumber(1)
  set provider(OAuth2ProviderType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProvider() => $_has(0);
  @$pb.TagNumber(1)
  void clearProvider() => $_clearField(1);

  /// Optional: specific provider user ID to unlink
  /// If not provided, unlinks all bindings for this provider type
  @$pb.TagNumber(2)
  $core.String get providerUserId => $_getSZ(1);
  @$pb.TagNumber(2)
  set providerUserId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProviderUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProviderUserId() => $_clearField(2);

  /// Required when provider_user_id is set: the configured provider instance namespace.
  /// Empty with empty provider_user_id unlinks every binding for provider type.
  @$pb.TagNumber(3)
  $core.String get providerInstanceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set providerInstanceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProviderInstanceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearProviderInstanceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get verificationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set verificationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVerificationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerificationId() => $_clearField(4);
}

class UnlinkProviderResponse extends $pb.GeneratedMessage {
  factory UnlinkProviderResponse({
    $core.bool? success,
    $core.int? removedCount,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (removedCount != null) result.removedCount = removedCount;
    return result;
  }

  UnlinkProviderResponse._();

  factory UnlinkProviderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnlinkProviderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlinkProviderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'removedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkProviderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkProviderResponse copyWith(
          void Function(UnlinkProviderResponse) updates) =>
      super.copyWith((message) => updates(message as UnlinkProviderResponse))
          as UnlinkProviderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkProviderResponse create() => UnlinkProviderResponse._();
  @$core.override
  UnlinkProviderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnlinkProviderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnlinkProviderResponse>(create);
  static UnlinkProviderResponse? _defaultInstance;

  /// Whether any provider was unlinked
  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  /// Number of provider bindings removed
  @$pb.TagNumber(2)
  $core.int get removedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set removedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemovedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemovedCount() => $_clearField(2);
}

class GetLinkedProvidersRequest extends $pb.GeneratedMessage {
  factory GetLinkedProvidersRequest() => create();

  GetLinkedProvidersRequest._();

  factory GetLinkedProvidersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLinkedProvidersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLinkedProvidersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedProvidersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedProvidersRequest copyWith(
          void Function(GetLinkedProvidersRequest) updates) =>
      super.copyWith((message) => updates(message as GetLinkedProvidersRequest))
          as GetLinkedProvidersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLinkedProvidersRequest create() => GetLinkedProvidersRequest._();
  @$core.override
  GetLinkedProvidersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLinkedProvidersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLinkedProvidersRequest>(create);
  static GetLinkedProvidersRequest? _defaultInstance;
}

class GetLinkedProvidersResponse extends $pb.GeneratedMessage {
  factory GetLinkedProvidersResponse({
    $core.Iterable<LinkedProvider>? providers,
  }) {
    final result = create();
    if (providers != null) result.providers.addAll(providers);
    return result;
  }

  GetLinkedProvidersResponse._();

  factory GetLinkedProvidersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLinkedProvidersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLinkedProvidersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..pPM<LinkedProvider>(1, _omitFieldNames ? '' : 'providers',
        subBuilder: LinkedProvider.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedProvidersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinkedProvidersResponse copyWith(
          void Function(GetLinkedProvidersResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetLinkedProvidersResponse))
          as GetLinkedProvidersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLinkedProvidersResponse create() => GetLinkedProvidersResponse._();
  @$core.override
  GetLinkedProvidersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLinkedProvidersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLinkedProvidersResponse>(create);
  static GetLinkedProvidersResponse? _defaultInstance;

  /// List of linked OAuth2 providers
  @$pb.TagNumber(1)
  $pb.PbList<LinkedProvider> get providers => $_getList(0);
}

class LinkedProvider extends $pb.GeneratedMessage {
  factory LinkedProvider({
    OAuth2ProviderType? providerType,
    $core.String? providerUsername,
    $fixnum.Int64? linkedAt,
    $core.String? providerInstanceName,
    $core.String? providerIssuer,
    $core.String? providerUserId,
  }) {
    final result = create();
    if (providerType != null) result.providerType = providerType;
    if (providerUsername != null) result.providerUsername = providerUsername;
    if (linkedAt != null) result.linkedAt = linkedAt;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (providerIssuer != null) result.providerIssuer = providerIssuer;
    if (providerUserId != null) result.providerUserId = providerUserId;
    return result;
  }

  LinkedProvider._();

  factory LinkedProvider.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkedProvider.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkedProvider',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aE<OAuth2ProviderType>(1, _omitFieldNames ? '' : 'providerType',
        enumValues: OAuth2ProviderType.values)
    ..aOS(2, _omitFieldNames ? '' : 'providerUsername')
    ..aInt64(3, _omitFieldNames ? '' : 'linkedAt')
    ..aOS(4, _omitFieldNames ? '' : 'providerInstanceName')
    ..aOS(5, _omitFieldNames ? '' : 'providerIssuer')
    ..aOS(6, _omitFieldNames ? '' : 'providerUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkedProvider clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkedProvider copyWith(void Function(LinkedProvider) updates) =>
      super.copyWith((message) => updates(message as LinkedProvider))
          as LinkedProvider;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkedProvider create() => LinkedProvider._();
  @$core.override
  LinkedProvider createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkedProvider getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkedProvider>(create);
  static LinkedProvider? _defaultInstance;

  @$pb.TagNumber(1)
  OAuth2ProviderType get providerType => $_getN(0);
  @$pb.TagNumber(1)
  set providerType(OAuth2ProviderType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProviderType() => $_has(0);
  @$pb.TagNumber(1)
  void clearProviderType() => $_clearField(1);

  /// Username from the OAuth2 provider
  @$pb.TagNumber(2)
  $core.String get providerUsername => $_getSZ(1);
  @$pb.TagNumber(2)
  set providerUsername($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProviderUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearProviderUsername() => $_clearField(2);

  /// When the provider was linked (Unix timestamp, seconds)
  /// NOTE: Changed from string to int64 for consistency with all other timestamp fields.
  @$pb.TagNumber(3)
  $fixnum.Int64 get linkedAt => $_getI64(2);
  @$pb.TagNumber(3)
  set linkedAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLinkedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearLinkedAt() => $_clearField(3);

  /// Provider instance name that owns this external identity namespace.
  @$pb.TagNumber(4)
  $core.String get providerInstanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set providerInstanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProviderInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearProviderInstanceName() => $_clearField(4);

  /// Issuer metadata when known for OIDC-like providers.
  @$pb.TagNumber(5)
  $core.String get providerIssuer => $_getSZ(4);
  @$pb.TagNumber(5)
  set providerIssuer($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProviderIssuer() => $_has(4);
  @$pb.TagNumber(5)
  void clearProviderIssuer() => $_clearField(5);

  /// External user ID in the provider instance namespace. Clients must pass
  /// this with provider_instance_name to unlink one specific OAuth2 identity.
  @$pb.TagNumber(6)
  $core.String get providerUserId => $_getSZ(5);
  @$pb.TagNumber(6)
  set providerUserId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProviderUserId() => $_has(5);
  @$pb.TagNumber(6)
  void clearProviderUserId() => $_clearField(6);
}

class OAuth2UserInfo extends $pb.GeneratedMessage {
  factory OAuth2UserInfo({
    $core.String? userId,
    $core.String? username,
    $core.String? avatar,
    $0.UserRole? role,
    $0.UserStatus? status,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (avatar != null) result.avatar = avatar;
    if (role != null) result.role = role;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  OAuth2UserInfo._();

  factory OAuth2UserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OAuth2UserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OAuth2UserInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'synctv.client'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'avatar')
    ..aE<$0.UserRole>(4, _omitFieldNames ? '' : 'role',
        enumValues: $0.UserRole.values)
    ..aE<$0.UserStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: $0.UserStatus.values)
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2UserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OAuth2UserInfo copyWith(void Function(OAuth2UserInfo) updates) =>
      super.copyWith((message) => updates(message as OAuth2UserInfo))
          as OAuth2UserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OAuth2UserInfo create() => OAuth2UserInfo._();
  @$core.override
  OAuth2UserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OAuth2UserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OAuth2UserInfo>(create);
  static OAuth2UserInfo? _defaultInstance;

  /// User ID
  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  /// Username
  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  /// Avatar URL, when available.
  @$pb.TagNumber(3)
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);

  /// User role
  @$pb.TagNumber(4)
  $0.UserRole get role => $_getN(3);
  @$pb.TagNumber(4)
  set role($0.UserRole value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => $_clearField(4);

  /// Account status
  @$pb.TagNumber(5)
  $0.UserStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status($0.UserStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  /// When the account was created (Unix timestamp, seconds)
  /// NOTE: Changed from string to int64 for consistency with all other timestamp fields.
  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
}

/// ==================== OAuth2 Service ====================
/// OAuth2/OIDC authentication service
///
/// Frontend-driven flow:
/// 1. Frontend calls GetAuthorizationUrl to get the OAuth2 provider's auth URL
/// 2. Frontend redirects user to the auth URL
/// 3. User authorizes on the OAuth2 provider (e.g., GitHub)
/// 4. Provider redirects to frontend URL with code and state parameters
/// 5. Frontend extracts code and state from URL
/// 6. Frontend calls ExchangeAuthorizationCode with code and state
/// 7. Backend validates state, exchanges code for user info, creates/logs in user
/// 8. Backend returns JWT token to frontend
///
/// Authentication:
/// - GetAuthorizationUrl: None (public)
/// - ExchangeAuthorizationCode: None for login flow; bind flow requires JWT matching OAuth2 state user
/// - GetAuthorizationUrlForBind: JWT Authorization header (user_id)
/// - ListAvailableProviders: None (public)
/// - UnlinkProvider, GetLinkedProviders: JWT Authorization header (user_id)
///
/// Routes: /api/oauth2/*
class OAuth2ServiceApi {
  final $pb.RpcClient _client;

  OAuth2ServiceApi(this._client);

  /// Get authorization URL for OAuth2 login flow
  /// Returns the URL to redirect the user to for authorization
  $async.Future<GetAuthorizationUrlResponse> getAuthorizationUrl(
          $pb.ClientContext? ctx, GetAuthorizationUrlRequest request) =>
      _client.invoke<GetAuthorizationUrlResponse>(ctx, 'OAuth2Service',
          'GetAuthorizationUrl', request, GetAuthorizationUrlResponse());

  /// Get authorization URL for binding OAuth2 provider to existing user account
  /// Requires authentication
  $async.Future<GetAuthorizationUrlForBindResponse> getAuthorizationUrlForBind(
          $pb.ClientContext? ctx, GetAuthorizationUrlForBindRequest request) =>
      _client.invoke<GetAuthorizationUrlForBindResponse>(
          ctx,
          'OAuth2Service',
          'GetAuthorizationUrlForBind',
          request,
          GetAuthorizationUrlForBindResponse());

  /// Exchange authorization code for JWT token or complete a bind flow.
  /// Public for login flow. Bind flow requires authentication and the token's
  /// user ID must match the user stored in the OAuth2 state.
  $async.Future<ExchangeAuthorizationCodeResponse> exchangeAuthorizationCode(
          $pb.ClientContext? ctx, ExchangeAuthorizationCodeRequest request) =>
      _client.invoke<ExchangeAuthorizationCodeResponse>(
          ctx,
          'OAuth2Service',
          'ExchangeAuthorizationCode',
          request,
          ExchangeAuthorizationCodeResponse());

  /// List all available OAuth2 provider instances
  $async.Future<ListAvailableProvidersResponse> listAvailableProviders(
          $pb.ClientContext? ctx, ListAvailableProvidersRequest request) =>
      _client.invoke<ListAvailableProvidersResponse>(ctx, 'OAuth2Service',
          'ListAvailableProviders', request, ListAvailableProvidersResponse());

  /// Unlink OAuth2 provider from user account (requires authentication)
  $async.Future<UnlinkProviderResponse> unlinkProvider(
          $pb.ClientContext? ctx, UnlinkProviderRequest request) =>
      _client.invoke<UnlinkProviderResponse>(ctx, 'OAuth2Service',
          'UnlinkProvider', request, UnlinkProviderResponse());

  /// Get linked OAuth2 providers for authenticated user
  $async.Future<GetLinkedProvidersResponse> getLinkedProviders(
          $pb.ClientContext? ctx, GetLinkedProvidersRequest request) =>
      _client.invoke<GetLinkedProvidersResponse>(ctx, 'OAuth2Service',
          'GetLinkedProviders', request, GetLinkedProvidersResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
