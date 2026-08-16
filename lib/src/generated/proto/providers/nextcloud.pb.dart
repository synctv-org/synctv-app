// This is a generated file - do not edit.
//
// Generated from proto/providers/nextcloud.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? endpoint,
    $core.String? username,
    $core.String? appPassword,
    $core.String? instanceName,
  }) {
    final result = create();
    if (endpoint != null) result.endpoint = endpoint;
    if (username != null) result.username = username;
    if (appPassword != null) result.appPassword = appPassword;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  LoginRequest._();

  factory LoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'endpoint')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'appPassword')
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginRequest copyWith(void Function(LoginRequest) updates) =>
      super.copyWith((message) => updates(message as LoginRequest))
          as LoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginRequest create() => LoginRequest._();
  @$core.override
  LoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginRequest>(create);
  static LoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get endpoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set endpoint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEndpoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearEndpoint() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get appPassword => $_getSZ(2);
  @$pb.TagNumber(3)
  set appPassword($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? serverId,
    $core.String? userId,
    $core.String? displayName,
    $core.String? version,
    $core.String? edition,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (userId != null) result.userId = userId;
    if (displayName != null) result.displayName = displayName;
    if (version != null) result.version = version;
    if (edition != null) result.edition = edition;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'version')
    ..aOS(5, _omitFieldNames ? '' : 'edition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get edition => $_getSZ(4);
  @$pb.TagNumber(5)
  set edition($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEdition() => $_has(4);
  @$pb.TagNumber(5)
  void clearEdition() => $_clearField(5);
}

class StartLoginFlowRequest extends $pb.GeneratedMessage {
  factory StartLoginFlowRequest({
    $core.String? endpoint,
  }) {
    final result = create();
    if (endpoint != null) result.endpoint = endpoint;
    return result;
  }

  StartLoginFlowRequest._();

  factory StartLoginFlowRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartLoginFlowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartLoginFlowRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'endpoint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartLoginFlowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartLoginFlowRequest copyWith(
          void Function(StartLoginFlowRequest) updates) =>
      super.copyWith((message) => updates(message as StartLoginFlowRequest))
          as StartLoginFlowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartLoginFlowRequest create() => StartLoginFlowRequest._();
  @$core.override
  StartLoginFlowRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartLoginFlowRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartLoginFlowRequest>(create);
  static StartLoginFlowRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get endpoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set endpoint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEndpoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearEndpoint() => $_clearField(1);
}

class StartLoginFlowResponse extends $pb.GeneratedMessage {
  factory StartLoginFlowResponse({
    $core.String? loginUrl,
    $core.String? pollEndpoint,
    $core.String? pollToken,
  }) {
    final result = create();
    if (loginUrl != null) result.loginUrl = loginUrl;
    if (pollEndpoint != null) result.pollEndpoint = pollEndpoint;
    if (pollToken != null) result.pollToken = pollToken;
    return result;
  }

  StartLoginFlowResponse._();

  factory StartLoginFlowResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartLoginFlowResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartLoginFlowResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loginUrl')
    ..aOS(2, _omitFieldNames ? '' : 'pollEndpoint')
    ..aOS(3, _omitFieldNames ? '' : 'pollToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartLoginFlowResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartLoginFlowResponse copyWith(
          void Function(StartLoginFlowResponse) updates) =>
      super.copyWith((message) => updates(message as StartLoginFlowResponse))
          as StartLoginFlowResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartLoginFlowResponse create() => StartLoginFlowResponse._();
  @$core.override
  StartLoginFlowResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartLoginFlowResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartLoginFlowResponse>(create);
  static StartLoginFlowResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loginUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set loginUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoginUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pollEndpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set pollEndpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPollEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPollEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pollToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pollToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPollToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPollToken() => $_clearField(3);
}

class PollLoginFlowRequest extends $pb.GeneratedMessage {
  factory PollLoginFlowRequest({
    $core.String? endpoint,
    $core.String? pollEndpoint,
    $core.String? pollToken,
    $core.String? instanceName,
  }) {
    final result = create();
    if (endpoint != null) result.endpoint = endpoint;
    if (pollEndpoint != null) result.pollEndpoint = pollEndpoint;
    if (pollToken != null) result.pollToken = pollToken;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  PollLoginFlowRequest._();

  factory PollLoginFlowRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PollLoginFlowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PollLoginFlowRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'endpoint')
    ..aOS(2, _omitFieldNames ? '' : 'pollEndpoint')
    ..aOS(3, _omitFieldNames ? '' : 'pollToken')
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollLoginFlowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollLoginFlowRequest copyWith(void Function(PollLoginFlowRequest) updates) =>
      super.copyWith((message) => updates(message as PollLoginFlowRequest))
          as PollLoginFlowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PollLoginFlowRequest create() => PollLoginFlowRequest._();
  @$core.override
  PollLoginFlowRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PollLoginFlowRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PollLoginFlowRequest>(create);
  static PollLoginFlowRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get endpoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set endpoint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEndpoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearEndpoint() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pollEndpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set pollEndpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPollEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPollEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pollToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pollToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPollToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPollToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $core.String? serverId,
    $core.String? path,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListRequest._();

  factory ListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOS(6, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequest copyWith(void Function(ListRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequest))
          as ListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRequest create() => ListRequest._();
  @$core.override
  ListRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRequest>(create);
  static ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get page => $_getI64(2);
  @$pb.TagNumber(3)
  set page($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get search => $_getSZ(4);
  @$pb.TagNumber(5)
  set search($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSearch() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get instanceName => $_getSZ(5);
  @$pb.TagNumber(6)
  set instanceName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInstanceName() => $_has(5);
  @$pb.TagNumber(6)
  void clearInstanceName() => $_clearField(6);
}

class ListFavoritesRequest extends $pb.GeneratedMessage {
  factory ListFavoritesRequest({
    $core.String? serverId,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListFavoritesRequest._();

  factory ListFavoritesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFavoritesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFavoritesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavoritesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavoritesRequest copyWith(void Function(ListFavoritesRequest) updates) =>
      super.copyWith((message) => updates(message as ListFavoritesRequest))
          as ListFavoritesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFavoritesRequest create() => ListFavoritesRequest._();
  @$core.override
  ListFavoritesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFavoritesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFavoritesRequest>(create);
  static ListFavoritesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get page => $_getI64(1);
  @$pb.TagNumber(2)
  set page($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class FileItem extends $pb.GeneratedMessage {
  factory FileItem({
    $core.String? name,
    $core.String? path,
    $fixnum.Int64? fileId,
    $core.bool? isDir,
    $fixnum.Int64? size,
    $core.String? modifiedAt,
    $core.String? contentType,
    $core.String? etag,
    $core.String? permissions,
    $core.String? ownerId,
    $core.String? ownerDisplayName,
    $core.bool? favorite,
    $core.bool? hasPreview,
    $core.String? blurhash,
    $core.int? width,
    $core.int? height,
    $fixnum.Int64? durationMillis,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (path != null) result.path = path;
    if (fileId != null) result.fileId = fileId;
    if (isDir != null) result.isDir = isDir;
    if (size != null) result.size = size;
    if (modifiedAt != null) result.modifiedAt = modifiedAt;
    if (contentType != null) result.contentType = contentType;
    if (etag != null) result.etag = etag;
    if (permissions != null) result.permissions = permissions;
    if (ownerId != null) result.ownerId = ownerId;
    if (ownerDisplayName != null) result.ownerDisplayName = ownerDisplayName;
    if (favorite != null) result.favorite = favorite;
    if (hasPreview != null) result.hasPreview = hasPreview;
    if (blurhash != null) result.blurhash = blurhash;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (durationMillis != null) result.durationMillis = durationMillis;
    if (source != null) result.source = source;
    return result;
  }

  FileItem._();

  factory FileItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'fileId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(4, _omitFieldNames ? '' : 'isDir')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(6, _omitFieldNames ? '' : 'modifiedAt')
    ..aOS(7, _omitFieldNames ? '' : 'contentType')
    ..aOS(8, _omitFieldNames ? '' : 'etag')
    ..aOS(9, _omitFieldNames ? '' : 'permissions')
    ..aOS(10, _omitFieldNames ? '' : 'ownerId')
    ..aOS(11, _omitFieldNames ? '' : 'ownerDisplayName')
    ..aOB(12, _omitFieldNames ? '' : 'favorite')
    ..aOB(13, _omitFieldNames ? '' : 'hasPreview')
    ..aOS(14, _omitFieldNames ? '' : 'blurhash')
    ..aI(15, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(16, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        17, _omitFieldNames ? '' : 'durationMillis', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.DiscoveredSource>(18, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileItem copyWith(void Function(FileItem) updates) =>
      super.copyWith((message) => updates(message as FileItem)) as FileItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileItem create() => FileItem._();
  @$core.override
  FileItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileItem>(create);
  static FileItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fileId => $_getI64(2);
  @$pb.TagNumber(3)
  set fileId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isDir => $_getBF(3);
  @$pb.TagNumber(4)
  set isDir($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsDir() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get size => $_getI64(4);
  @$pb.TagNumber(5)
  set size($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get modifiedAt => $_getSZ(5);
  @$pb.TagNumber(6)
  set modifiedAt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModifiedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearModifiedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get contentType => $_getSZ(6);
  @$pb.TagNumber(7)
  set contentType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContentType() => $_has(6);
  @$pb.TagNumber(7)
  void clearContentType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get etag => $_getSZ(7);
  @$pb.TagNumber(8)
  set etag($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEtag() => $_has(7);
  @$pb.TagNumber(8)
  void clearEtag() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get permissions => $_getSZ(8);
  @$pb.TagNumber(9)
  set permissions($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPermissions() => $_has(8);
  @$pb.TagNumber(9)
  void clearPermissions() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get ownerId => $_getSZ(9);
  @$pb.TagNumber(10)
  set ownerId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOwnerId() => $_has(9);
  @$pb.TagNumber(10)
  void clearOwnerId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get ownerDisplayName => $_getSZ(10);
  @$pb.TagNumber(11)
  set ownerDisplayName($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOwnerDisplayName() => $_has(10);
  @$pb.TagNumber(11)
  void clearOwnerDisplayName() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get favorite => $_getBF(11);
  @$pb.TagNumber(12)
  set favorite($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFavorite() => $_has(11);
  @$pb.TagNumber(12)
  void clearFavorite() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get hasPreview => $_getBF(12);
  @$pb.TagNumber(13)
  set hasPreview($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasHasPreview() => $_has(12);
  @$pb.TagNumber(13)
  void clearHasPreview() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get blurhash => $_getSZ(13);
  @$pb.TagNumber(14)
  set blurhash($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasBlurhash() => $_has(13);
  @$pb.TagNumber(14)
  void clearBlurhash() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get width => $_getIZ(14);
  @$pb.TagNumber(15)
  set width($core.int value) => $_setUnsignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasWidth() => $_has(14);
  @$pb.TagNumber(15)
  void clearWidth() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get height => $_getIZ(15);
  @$pb.TagNumber(16)
  set height($core.int value) => $_setUnsignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasHeight() => $_has(15);
  @$pb.TagNumber(16)
  void clearHeight() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get durationMillis => $_getI64(16);
  @$pb.TagNumber(17)
  set durationMillis($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDurationMillis() => $_has(16);
  @$pb.TagNumber(17)
  void clearDurationMillis() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.DiscoveredSource get source => $_getN(17);
  @$pb.TagNumber(18)
  set source($0.DiscoveredSource value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasSource() => $_has(17);
  @$pb.TagNumber(18)
  void clearSource() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.DiscoveredSource ensureSource() => $_ensure(17);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<FileItem>? content,
    $fixnum.Int64? total,
    $fixnum.Int64? page,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (content != null) result.content.addAll(content);
    if (total != null) result.total = total;
    if (page != null) result.page = page;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  ListResponse._();

  factory ListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..pPM<FileItem>(1, _omitFieldNames ? '' : 'content',
        subBuilder: FileItem.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(4, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(5, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse copyWith(void Function(ListResponse) updates) =>
      super.copyWith((message) => updates(message as ListResponse))
          as ListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListResponse create() => ListResponse._();
  @$core.override
  ListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListResponse>(create);
  static ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FileItem> get content => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get page => $_getI64(2);
  @$pb.TagNumber(3)
  set page($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasMore => $_getBF(3);
  @$pb.TagNumber(4)
  set hasMore($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasMore() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.DiscoveredSource get source => $_getN(4);
  @$pb.TagNumber(5)
  set source($0.DiscoveredSource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.DiscoveredSource ensureSource() => $_ensure(4);
}

class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest({
    $core.String? serverId,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    return result;
  }

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutRequest create() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(create);
  static LogoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);
}

class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class GetBindsRequest extends $pb.GeneratedMessage {
  factory GetBindsRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  GetBindsRequest._();

  factory GetBindsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBindsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBindsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsRequest copyWith(void Function(GetBindsRequest) updates) =>
      super.copyWith((message) => updates(message as GetBindsRequest))
          as GetBindsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBindsRequest create() => GetBindsRequest._();
  @$core.override
  GetBindsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBindsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBindsRequest>(create);
  static GetBindsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

class BindInfo extends $pb.GeneratedMessage {
  factory BindInfo({
    $core.String? id,
    $core.String? serverId,
    $core.String? endpoint,
    $core.String? username,
    $core.String? userId,
    $core.String? version,
    $core.String? edition,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (endpoint != null) result.endpoint = endpoint;
    if (username != null) result.username = username;
    if (userId != null) result.userId = userId;
    if (version != null) result.version = version;
    if (edition != null) result.edition = edition;
    if (createdAt != null) result.createdAt = createdAt;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    return result;
  }

  BindInfo._();

  factory BindInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BindInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BindInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'userId')
    ..aOS(6, _omitFieldNames ? '' : 'version')
    ..aOS(7, _omitFieldNames ? '' : 'edition')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAt')
    ..aOS(9, _omitFieldNames ? '' : 'providerInstanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindInfo copyWith(void Function(BindInfo) updates) =>
      super.copyWith((message) => updates(message as BindInfo)) as BindInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindInfo create() => BindInfo._();
  @$core.override
  BindInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BindInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindInfo>(create);
  static BindInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set endpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndpoint() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userId => $_getSZ(4);
  @$pb.TagNumber(5)
  set userId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(5);
  @$pb.TagNumber(6)
  set version($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get edition => $_getSZ(6);
  @$pb.TagNumber(7)
  set edition($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEdition() => $_has(6);
  @$pb.TagNumber(7)
  void clearEdition() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAt => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get providerInstanceName => $_getSZ(8);
  @$pb.TagNumber(9)
  set providerInstanceName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProviderInstanceName() => $_has(8);
  @$pb.TagNumber(9)
  void clearProviderInstanceName() => $_clearField(9);
}

class GetBindsResponse extends $pb.GeneratedMessage {
  factory GetBindsResponse({
    $core.Iterable<BindInfo>? binds,
  }) {
    final result = create();
    if (binds != null) result.binds.addAll(binds);
    return result;
  }

  GetBindsResponse._();

  factory GetBindsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBindsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBindsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..pPM<BindInfo>(1, _omitFieldNames ? '' : 'binds',
        subBuilder: BindInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsResponse copyWith(void Function(GetBindsResponse) updates) =>
      super.copyWith((message) => updates(message as GetBindsResponse))
          as GetBindsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBindsResponse create() => GetBindsResponse._();
  @$core.override
  GetBindsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBindsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBindsResponse>(create);
  static GetBindsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BindInfo> get binds => $_getList(0);
}

class GetPreviewRequest extends $pb.GeneratedMessage {
  factory GetPreviewRequest({
    $core.String? serverId,
    $fixnum.Int64? fileId,
    $core.int? width,
    $core.int? height,
    $core.bool? crop,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (fileId != null) result.fileId = fileId;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (crop != null) result.crop = crop;
    return result;
  }

  GetPreviewRequest._();

  factory GetPreviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPreviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPreviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.nextcloud'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'fileId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aOB(5, _omitFieldNames ? '' : 'crop')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPreviewRequest copyWith(void Function(GetPreviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetPreviewRequest))
          as GetPreviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPreviewRequest create() => GetPreviewRequest._();
  @$core.override
  GetPreviewRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPreviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPreviewRequest>(create);
  static GetPreviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fileId => $_getI64(1);
  @$pb.TagNumber(2)
  set fileId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get crop => $_getBF(4);
  @$pb.TagNumber(5)
  set crop($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCrop() => $_has(4);
  @$pb.TagNumber(5)
  void clearCrop() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
