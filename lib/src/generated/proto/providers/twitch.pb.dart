// This is a generated file - do not edit.
//
// Generated from proto/providers/twitch.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../source_config.pbenum.dart' as $1;
import 'common.pb.dart' as $0;
import 'twitch.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'twitch.pbenum.dart';

class BindRequest extends $pb.GeneratedMessage {
  factory BindRequest({
    $core.String? authToken,
    $core.String? deviceId,
    $core.String? clientIntegrity,
    $core.String? instanceName,
  }) {
    final result = create();
    if (authToken != null) result.authToken = authToken;
    if (deviceId != null) result.deviceId = deviceId;
    if (clientIntegrity != null) result.clientIntegrity = clientIntegrity;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  BindRequest._();

  factory BindRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BindRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BindRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authToken')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..aOS(3, _omitFieldNames ? '' : 'clientIntegrity')
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindRequest copyWith(void Function(BindRequest) updates) =>
      super.copyWith((message) => updates(message as BindRequest))
          as BindRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindRequest create() => BindRequest._();
  @$core.override
  BindRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BindRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BindRequest>(create);
  static BindRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get authToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set authToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get clientIntegrity => $_getSZ(2);
  @$pb.TagNumber(3)
  set clientIntegrity($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClientIntegrity() => $_has(2);
  @$pb.TagNumber(3)
  void clearClientIntegrity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class BindResponse extends $pb.GeneratedMessage {
  factory BindResponse({
    $core.String? serverId,
    $core.String? login,
    $core.String? twitchUserId,
    $core.String? clientId,
    $core.Iterable<$core.String>? scopes,
    $fixnum.Int64? expiresIn,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (login != null) result.login = login;
    if (twitchUserId != null) result.twitchUserId = twitchUserId;
    if (clientId != null) result.clientId = clientId;
    if (scopes != null) result.scopes.addAll(scopes);
    if (expiresIn != null) result.expiresIn = expiresIn;
    return result;
  }

  BindResponse._();

  factory BindResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BindResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BindResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'login')
    ..aOS(3, _omitFieldNames ? '' : 'twitchUserId')
    ..aOS(4, _omitFieldNames ? '' : 'clientId')
    ..pPS(5, _omitFieldNames ? '' : 'scopes')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'expiresIn', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindResponse copyWith(void Function(BindResponse) updates) =>
      super.copyWith((message) => updates(message as BindResponse))
          as BindResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindResponse create() => BindResponse._();
  @$core.override
  BindResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BindResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BindResponse>(create);
  static BindResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get login => $_getSZ(1);
  @$pb.TagNumber(2)
  set login($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLogin() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get twitchUserId => $_getSZ(2);
  @$pb.TagNumber(3)
  set twitchUserId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTwitchUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTwitchUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get clientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set clientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get scopes => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiresIn => $_getI64(5);
  @$pb.TagNumber(6)
  set expiresIn($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresIn() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresIn() => $_clearField(6);
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
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
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
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
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

class BindInfo extends $pb.GeneratedMessage {
  factory BindInfo({
    $core.String? id,
    $core.String? serverId,
    $core.String? login,
    $core.String? twitchUserId,
    $core.String? clientId,
    $core.Iterable<$core.String>? scopes,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (login != null) result.login = login;
    if (twitchUserId != null) result.twitchUserId = twitchUserId;
    if (clientId != null) result.clientId = clientId;
    if (scopes != null) result.scopes.addAll(scopes);
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
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'login')
    ..aOS(4, _omitFieldNames ? '' : 'twitchUserId')
    ..aOS(5, _omitFieldNames ? '' : 'clientId')
    ..pPS(6, _omitFieldNames ? '' : 'scopes')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAt')
    ..aOS(8, _omitFieldNames ? '' : 'providerInstanceName')
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
  $core.String get login => $_getSZ(2);
  @$pb.TagNumber(3)
  set login($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLogin() => $_has(2);
  @$pb.TagNumber(3)
  void clearLogin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get twitchUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set twitchUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTwitchUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTwitchUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get clientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set clientId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearClientId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get scopes => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAt => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get providerInstanceName => $_getSZ(7);
  @$pb.TagNumber(8)
  set providerInstanceName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasProviderInstanceName() => $_has(7);
  @$pb.TagNumber(8)
  void clearProviderInstanceName() => $_clearField(8);
}

class UnbindRequest extends $pb.GeneratedMessage {
  factory UnbindRequest({
    $core.String? serverId,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    return result;
  }

  UnbindRequest._();

  factory UnbindRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnbindRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnbindRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbindRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbindRequest copyWith(void Function(UnbindRequest) updates) =>
      super.copyWith((message) => updates(message as UnbindRequest))
          as UnbindRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnbindRequest create() => UnbindRequest._();
  @$core.override
  UnbindRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnbindRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnbindRequest>(create);
  static UnbindRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);
}

class UnbindResponse extends $pb.GeneratedMessage {
  factory UnbindResponse({
    $core.bool? removed,
  }) {
    final result = create();
    if (removed != null) result.removed = removed;
    return result;
  }

  UnbindResponse._();

  factory UnbindResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnbindResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnbindResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'removed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbindResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnbindResponse copyWith(void Function(UnbindResponse) updates) =>
      super.copyWith((message) => updates(message as UnbindResponse))
          as UnbindResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnbindResponse create() => UnbindResponse._();
  @$core.override
  UnbindResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnbindResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnbindResponse>(create);
  static UnbindResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get removed => $_getBF(0);
  @$pb.TagNumber(1)
  set removed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoved() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoved() => $_clearField(1);
}

class ResolveRequest extends $pb.GeneratedMessage {
  factory ResolveRequest({
    $core.String? resource,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (resource != null) result.resource = resource;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ResolveRequest._();

  factory ResolveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resource')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..aOB(3, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveRequest copyWith(void Function(ResolveRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveRequest))
          as ResolveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveRequest create() => ResolveRequest._();
  @$core.override
  ResolveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveRequest>(create);
  static ResolveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resource => $_getSZ(0);
  @$pb.TagNumber(1)
  set resource($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResource() => $_has(0);
  @$pb.TagNumber(1)
  void clearResource() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instanceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get shared => $_getBF(2);
  @$pb.TagNumber(3)
  set shared($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShared() => $_has(2);
  @$pb.TagNumber(3)
  void clearShared() => $_clearField(3);
}

class Chapter extends $pb.GeneratedMessage {
  factory Chapter({
    $core.String? title,
    $fixnum.Int64? startSeconds,
    $fixnum.Int64? endSeconds,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (startSeconds != null) result.startSeconds = startSeconds;
    if (endSeconds != null) result.endSeconds = endSeconds;
    return result;
  }

  Chapter._();

  factory Chapter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chapter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chapter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'startSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'endSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chapter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chapter copyWith(void Function(Chapter) updates) =>
      super.copyWith((message) => updates(message as Chapter)) as Chapter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chapter create() => Chapter._();
  @$core.override
  Chapter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chapter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chapter>(create);
  static Chapter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get startSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set startSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set endSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndSeconds() => $_clearField(3);
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? id,
    $core.String? title,
    $core.String? author,
    $core.String? category,
    $core.String? thumbnailUrl,
    $core.bool? isLive,
    $core.String? description,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? viewCount,
    $core.String? publishedAt,
    $core.Iterable<Chapter>? chapters,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (author != null) result.author = author;
    if (category != null) result.category = category;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (isLive != null) result.isLive = isLive;
    if (description != null) result.description = description;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (viewCount != null) result.viewCount = viewCount;
    if (publishedAt != null) result.publishedAt = publishedAt;
    if (chapters != null) result.chapters.addAll(chapters);
    return result;
  }

  Metadata._();

  factory Metadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Metadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Metadata',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aOS(5, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOB(6, _omitFieldNames ? '' : 'isLive')
    ..aOS(7, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(10, _omitFieldNames ? '' : 'publishedAt')
    ..pPM<Chapter>(11, _omitFieldNames ? '' : 'chapters',
        subBuilder: Chapter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata copyWith(void Function(Metadata) updates) =>
      super.copyWith((message) => updates(message as Metadata)) as Metadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Metadata create() => Metadata._();
  @$core.override
  Metadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Metadata getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Metadata>(create);
  static Metadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get thumbnailUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set thumbnailUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasThumbnailUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearThumbnailUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isLive => $_getBF(5);
  @$pb.TagNumber(6)
  set isLive($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsLive() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsLive() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get description => $_getSZ(6);
  @$pb.TagNumber(7)
  set description($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDescription() => $_has(6);
  @$pb.TagNumber(7)
  void clearDescription() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get durationSeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get viewCount => $_getI64(8);
  @$pb.TagNumber(9)
  set viewCount($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasViewCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearViewCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get publishedAt => $_getSZ(9);
  @$pb.TagNumber(10)
  set publishedAt($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPublishedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearPublishedAt() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<Chapter> get chapters => $_getList(10);
}

class Quality extends $pb.GeneratedMessage {
  factory Quality({
    $core.String? name,
    $fixnum.Int64? bandwidth,
    $core.int? width,
    $core.int? height,
    $core.String? frameRate,
    $core.String? codecs,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (bandwidth != null) result.bandwidth = bandwidth;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (frameRate != null) result.frameRate = frameRate;
    if (codecs != null) result.codecs = codecs;
    return result;
  }

  Quality._();

  factory Quality.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Quality.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Quality',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'bandwidth', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'frameRate')
    ..aOS(6, _omitFieldNames ? '' : 'codecs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quality clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quality copyWith(void Function(Quality) updates) =>
      super.copyWith((message) => updates(message as Quality)) as Quality;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Quality create() => Quality._();
  @$core.override
  Quality createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Quality getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quality>(create);
  static Quality? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bandwidth => $_getI64(1);
  @$pb.TagNumber(2)
  set bandwidth($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBandwidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearBandwidth() => $_clearField(2);

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
  $core.String get frameRate => $_getSZ(4);
  @$pb.TagNumber(5)
  set frameRate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFrameRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearFrameRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get codecs => $_getSZ(5);
  @$pb.TagNumber(6)
  set codecs($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCodecs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCodecs() => $_clearField(6);
}

class ResolveResponse extends $pb.GeneratedMessage {
  factory ResolveResponse({
    ResourceKind? kind,
    Metadata? metadata,
    $core.Iterable<Quality>? qualities,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (metadata != null) result.metadata = metadata;
    if (qualities != null) result.qualities.addAll(qualities);
    if (source != null) result.source = source;
    return result;
  }

  ResolveResponse._();

  factory ResolveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aE<ResourceKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: ResourceKind.values)
    ..aOM<Metadata>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: Metadata.create)
    ..pPM<Quality>(3, _omitFieldNames ? '' : 'qualities',
        subBuilder: Quality.create)
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveResponse copyWith(void Function(ResolveResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveResponse))
          as ResolveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveResponse create() => ResolveResponse._();
  @$core.override
  ResolveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveResponse>(create);
  static ResolveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ResourceKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(ResourceKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  Metadata get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata(Metadata value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  Metadata ensureMetadata() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<Quality> get qualities => $_getList(2);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

class ListChannelItemsRequest extends $pb.GeneratedMessage {
  factory ListChannelItemsRequest({
    $core.String? resource,
    $1.TwitchPlaylistContent? content,
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (resource != null) result.resource = resource;
    if (content != null) result.content = content;
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ListChannelItemsRequest._();

  factory ListChannelItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChannelItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChannelItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resource')
    ..aE<$1.TwitchPlaylistContent>(2, _omitFieldNames ? '' : 'content',
        enumValues: $1.TwitchPlaylistContent.values)
    ..aOS(3, _omitFieldNames ? '' : 'cursor')
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'instanceName')
    ..aOB(6, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelItemsRequest copyWith(
          void Function(ListChannelItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListChannelItemsRequest))
          as ListChannelItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChannelItemsRequest create() => ListChannelItemsRequest._();
  @$core.override
  ListChannelItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChannelItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChannelItemsRequest>(create);
  static ListChannelItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resource => $_getSZ(0);
  @$pb.TagNumber(1)
  set resource($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResource() => $_has(0);
  @$pb.TagNumber(1)
  void clearResource() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.TwitchPlaylistContent get content => $_getN(1);
  @$pb.TagNumber(2)
  set content($1.TwitchPlaylistContent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cursor => $_getSZ(2);
  @$pb.TagNumber(3)
  set cursor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get instanceName => $_getSZ(4);
  @$pb.TagNumber(5)
  set instanceName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstanceName() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstanceName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get shared => $_getBF(5);
  @$pb.TagNumber(6)
  set shared($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShared() => $_has(5);
  @$pb.TagNumber(6)
  void clearShared() => $_clearField(6);
}

class ListItem extends $pb.GeneratedMessage {
  factory ListItem({
    ResourceKind? kind,
    $core.String? id,
    $core.String? title,
    $core.String? thumbnailUrl,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? viewCount,
    $core.String? publishedAt,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (viewCount != null) result.viewCount = viewCount;
    if (publishedAt != null) result.publishedAt = publishedAt;
    if (source != null) result.source = source;
    return result;
  }

  ListItem._();

  factory ListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aE<ResourceKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: ResourceKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'thumbnailUrl')
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, _omitFieldNames ? '' : 'publishedAt')
    ..aOM<$0.DiscoveredSource>(8, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItem copyWith(void Function(ListItem) updates) =>
      super.copyWith((message) => updates(message as ListItem)) as ListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItem create() => ListItem._();
  @$core.override
  ListItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListItem>(create);
  static ListItem? _defaultInstance;

  @$pb.TagNumber(1)
  ResourceKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(ResourceKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get thumbnailUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set thumbnailUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasThumbnailUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearThumbnailUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get durationSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDurationSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearDurationSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get viewCount => $_getI64(5);
  @$pb.TagNumber(6)
  set viewCount($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasViewCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearViewCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get publishedAt => $_getSZ(6);
  @$pb.TagNumber(7)
  set publishedAt($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPublishedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPublishedAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.DiscoveredSource get source => $_getN(7);
  @$pb.TagNumber(8)
  set source($0.DiscoveredSource value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearSource() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.DiscoveredSource ensureSource() => $_ensure(7);
}

class ListChannelItemsResponse extends $pb.GeneratedMessage {
  factory ListChannelItemsResponse({
    $core.Iterable<ListItem>? items,
    $core.String? cursor,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  ListChannelItemsResponse._();

  factory ListChannelItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChannelItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChannelItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..pPM<ListItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: ListItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChannelItemsResponse copyWith(
          void Function(ListChannelItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListChannelItemsResponse))
          as ListChannelItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChannelItemsResponse create() => ListChannelItemsResponse._();
  @$core.override
  ListChannelItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChannelItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChannelItemsResponse>(create);
  static ListChannelItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ListItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

class StreamItem extends $pb.GeneratedMessage {
  factory StreamItem({
    $core.String? streamId,
    $core.String? userId,
    $core.String? channel,
    $core.String? displayName,
    $core.String? title,
    $core.String? categoryId,
    $core.String? categoryName,
    $core.String? thumbnailUrl,
    $fixnum.Int64? viewerCount,
    $core.String? startedAt,
    $core.String? language,
    $core.Iterable<$core.String>? tags,
    $core.bool? isMature,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (streamId != null) result.streamId = streamId;
    if (userId != null) result.userId = userId;
    if (channel != null) result.channel = channel;
    if (displayName != null) result.displayName = displayName;
    if (title != null) result.title = title;
    if (categoryId != null) result.categoryId = categoryId;
    if (categoryName != null) result.categoryName = categoryName;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (viewerCount != null) result.viewerCount = viewerCount;
    if (startedAt != null) result.startedAt = startedAt;
    if (language != null) result.language = language;
    if (tags != null) result.tags.addAll(tags);
    if (isMature != null) result.isMature = isMature;
    if (source != null) result.source = source;
    return result;
  }

  StreamItem._();

  factory StreamItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'streamId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'channel')
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'categoryId')
    ..aOS(7, _omitFieldNames ? '' : 'categoryName')
    ..aOS(8, _omitFieldNames ? '' : 'thumbnailUrl')
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'viewerCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(10, _omitFieldNames ? '' : 'startedAt')
    ..aOS(11, _omitFieldNames ? '' : 'language')
    ..pPS(12, _omitFieldNames ? '' : 'tags')
    ..aOB(13, _omitFieldNames ? '' : 'isMature')
    ..aOM<$0.DiscoveredSource>(14, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamItem copyWith(void Function(StreamItem) updates) =>
      super.copyWith((message) => updates(message as StreamItem)) as StreamItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamItem create() => StreamItem._();
  @$core.override
  StreamItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamItem>(create);
  static StreamItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get streamId => $_getSZ(0);
  @$pb.TagNumber(1)
  set streamId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStreamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get channel => $_getSZ(2);
  @$pb.TagNumber(3)
  set channel($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannel() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get categoryId => $_getSZ(5);
  @$pb.TagNumber(6)
  set categoryId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategoryId() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategoryId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get categoryName => $_getSZ(6);
  @$pb.TagNumber(7)
  set categoryName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCategoryName() => $_has(6);
  @$pb.TagNumber(7)
  void clearCategoryName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get thumbnailUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set thumbnailUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasThumbnailUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearThumbnailUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get viewerCount => $_getI64(8);
  @$pb.TagNumber(9)
  set viewerCount($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasViewerCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearViewerCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get startedAt => $_getSZ(9);
  @$pb.TagNumber(10)
  set startedAt($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStartedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartedAt() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get language => $_getSZ(10);
  @$pb.TagNumber(11)
  set language($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLanguage() => $_has(10);
  @$pb.TagNumber(11)
  void clearLanguage() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get tags => $_getList(11);

  @$pb.TagNumber(13)
  $core.bool get isMature => $_getBF(12);
  @$pb.TagNumber(13)
  set isMature($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsMature() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsMature() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.DiscoveredSource get source => $_getN(13);
  @$pb.TagNumber(14)
  set source($0.DiscoveredSource value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSource() => $_has(13);
  @$pb.TagNumber(14)
  void clearSource() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.DiscoveredSource ensureSource() => $_ensure(13);
}

class ListFollowedLiveRequest extends $pb.GeneratedMessage {
  factory ListFollowedLiveRequest({
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ListFollowedLiveRequest._();

  factory ListFollowedLiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFollowedLiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFollowedLiveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cursor')
    ..aI(2, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'instanceName')
    ..aOB(4, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedLiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedLiveRequest copyWith(
          void Function(ListFollowedLiveRequest) updates) =>
      super.copyWith((message) => updates(message as ListFollowedLiveRequest))
          as ListFollowedLiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFollowedLiveRequest create() => ListFollowedLiveRequest._();
  @$core.override
  ListFollowedLiveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFollowedLiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFollowedLiveRequest>(create);
  static ListFollowedLiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cursor => $_getSZ(0);
  @$pb.TagNumber(1)
  set cursor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get instanceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set instanceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInstanceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstanceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get shared => $_getBF(3);
  @$pb.TagNumber(4)
  set shared($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShared() => $_has(3);
  @$pb.TagNumber(4)
  void clearShared() => $_clearField(4);
}

class ListFollowedLiveResponse extends $pb.GeneratedMessage {
  factory ListFollowedLiveResponse({
    $core.Iterable<StreamItem>? items,
    $core.String? cursor,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  ListFollowedLiveResponse._();

  factory ListFollowedLiveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFollowedLiveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFollowedLiveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..pPM<StreamItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: StreamItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedLiveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedLiveResponse copyWith(
          void Function(ListFollowedLiveResponse) updates) =>
      super.copyWith((message) => updates(message as ListFollowedLiveResponse))
          as ListFollowedLiveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFollowedLiveResponse create() => ListFollowedLiveResponse._();
  @$core.override
  ListFollowedLiveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFollowedLiveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFollowedLiveResponse>(create);
  static ListFollowedLiveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StreamItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

class ListCategoryStreamsRequest extends $pb.GeneratedMessage {
  factory ListCategoryStreamsRequest({
    $core.String? categoryId,
    $core.String? categoryName,
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (categoryId != null) result.categoryId = categoryId;
    if (categoryName != null) result.categoryName = categoryName;
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ListCategoryStreamsRequest._();

  factory ListCategoryStreamsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCategoryStreamsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCategoryStreamsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'categoryId')
    ..aOS(2, _omitFieldNames ? '' : 'categoryName')
    ..aOS(3, _omitFieldNames ? '' : 'cursor')
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'instanceName')
    ..aOB(6, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCategoryStreamsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCategoryStreamsRequest copyWith(
          void Function(ListCategoryStreamsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCategoryStreamsRequest))
          as ListCategoryStreamsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCategoryStreamsRequest create() => ListCategoryStreamsRequest._();
  @$core.override
  ListCategoryStreamsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCategoryStreamsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCategoryStreamsRequest>(create);
  static ListCategoryStreamsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get categoryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set categoryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get categoryName => $_getSZ(1);
  @$pb.TagNumber(2)
  set categoryName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cursor => $_getSZ(2);
  @$pb.TagNumber(3)
  set cursor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get instanceName => $_getSZ(4);
  @$pb.TagNumber(5)
  set instanceName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstanceName() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstanceName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get shared => $_getBF(5);
  @$pb.TagNumber(6)
  set shared($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShared() => $_has(5);
  @$pb.TagNumber(6)
  void clearShared() => $_clearField(6);
}

class ListCategoryStreamsResponse extends $pb.GeneratedMessage {
  factory ListCategoryStreamsResponse({
    $core.Iterable<StreamItem>? items,
    $core.String? cursor,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  ListCategoryStreamsResponse._();

  factory ListCategoryStreamsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCategoryStreamsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCategoryStreamsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..pPM<StreamItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: StreamItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCategoryStreamsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCategoryStreamsResponse copyWith(
          void Function(ListCategoryStreamsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCategoryStreamsResponse))
          as ListCategoryStreamsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCategoryStreamsResponse create() =>
      ListCategoryStreamsResponse._();
  @$core.override
  ListCategoryStreamsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCategoryStreamsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCategoryStreamsResponse>(create);
  static ListCategoryStreamsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StreamItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

class CategoryItem extends $pb.GeneratedMessage {
  factory CategoryItem({
    $core.String? id,
    $core.String? name,
    $core.String? boxArtUrl,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (boxArtUrl != null) result.boxArtUrl = boxArtUrl;
    if (source != null) result.source = source;
    return result;
  }

  CategoryItem._();

  factory CategoryItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CategoryItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'boxArtUrl')
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryItem copyWith(void Function(CategoryItem) updates) =>
      super.copyWith((message) => updates(message as CategoryItem))
          as CategoryItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CategoryItem create() => CategoryItem._();
  @$core.override
  CategoryItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CategoryItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryItem>(create);
  static CategoryItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
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
  $core.String get boxArtUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set boxArtUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBoxArtUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearBoxArtUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

class ListTopCategoriesRequest extends $pb.GeneratedMessage {
  factory ListTopCategoriesRequest({
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ListTopCategoriesRequest._();

  factory ListTopCategoriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTopCategoriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTopCategoriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cursor')
    ..aI(2, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'instanceName')
    ..aOB(4, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTopCategoriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTopCategoriesRequest copyWith(
          void Function(ListTopCategoriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListTopCategoriesRequest))
          as ListTopCategoriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTopCategoriesRequest create() => ListTopCategoriesRequest._();
  @$core.override
  ListTopCategoriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTopCategoriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTopCategoriesRequest>(create);
  static ListTopCategoriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cursor => $_getSZ(0);
  @$pb.TagNumber(1)
  set cursor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get instanceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set instanceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInstanceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstanceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get shared => $_getBF(3);
  @$pb.TagNumber(4)
  set shared($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShared() => $_has(3);
  @$pb.TagNumber(4)
  void clearShared() => $_clearField(4);
}

class ListTopCategoriesResponse extends $pb.GeneratedMessage {
  factory ListTopCategoriesResponse({
    $core.Iterable<CategoryItem>? items,
    $core.String? cursor,
    $core.bool? hasMore,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  ListTopCategoriesResponse._();

  factory ListTopCategoriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTopCategoriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTopCategoriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..pPM<CategoryItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: CategoryItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTopCategoriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTopCategoriesResponse copyWith(
          void Function(ListTopCategoriesResponse) updates) =>
      super.copyWith((message) => updates(message as ListTopCategoriesResponse))
          as ListTopCategoriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTopCategoriesResponse create() => ListTopCategoriesResponse._();
  @$core.override
  ListTopCategoriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTopCategoriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTopCategoriesResponse>(create);
  static ListTopCategoriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CategoryItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);
}

class SearchLiveChannelsRequest extends $pb.GeneratedMessage {
  factory SearchLiveChannelsRequest({
    $core.String? query,
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (query != null) result.query = query;
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  SearchLiveChannelsRequest._();

  factory SearchLiveChannelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchLiveChannelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchLiveChannelsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aI(3, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..aOB(5, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchLiveChannelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchLiveChannelsRequest copyWith(
          void Function(SearchLiveChannelsRequest) updates) =>
      super.copyWith((message) => updates(message as SearchLiveChannelsRequest))
          as SearchLiveChannelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchLiveChannelsRequest create() => SearchLiveChannelsRequest._();
  @$core.override
  SearchLiveChannelsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchLiveChannelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchLiveChannelsRequest>(create);
  static SearchLiveChannelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

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

  @$pb.TagNumber(5)
  $core.bool get shared => $_getBF(4);
  @$pb.TagNumber(5)
  set shared($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShared() => $_has(4);
  @$pb.TagNumber(5)
  void clearShared() => $_clearField(5);
}

class SearchChannelItem extends $pb.GeneratedMessage {
  factory SearchChannelItem({
    $core.String? userId,
    $core.String? channel,
    $core.String? displayName,
    $core.String? title,
    $core.String? categoryId,
    $core.String? categoryName,
    $core.String? thumbnailUrl,
    $core.bool? isLive,
    $core.String? startedAt,
    $core.String? language,
    $core.Iterable<$core.String>? tags,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (channel != null) result.channel = channel;
    if (displayName != null) result.displayName = displayName;
    if (title != null) result.title = title;
    if (categoryId != null) result.categoryId = categoryId;
    if (categoryName != null) result.categoryName = categoryName;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (isLive != null) result.isLive = isLive;
    if (startedAt != null) result.startedAt = startedAt;
    if (language != null) result.language = language;
    if (tags != null) result.tags.addAll(tags);
    if (source != null) result.source = source;
    return result;
  }

  SearchChannelItem._();

  factory SearchChannelItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchChannelItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchChannelItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aOS(2, _omitFieldNames ? '' : 'channel')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'categoryId')
    ..aOS(6, _omitFieldNames ? '' : 'categoryName')
    ..aOS(7, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOB(8, _omitFieldNames ? '' : 'isLive')
    ..aOS(9, _omitFieldNames ? '' : 'startedAt')
    ..aOS(10, _omitFieldNames ? '' : 'language')
    ..pPS(11, _omitFieldNames ? '' : 'tags')
    ..aOM<$0.DiscoveredSource>(12, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchChannelItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchChannelItem copyWith(void Function(SearchChannelItem) updates) =>
      super.copyWith((message) => updates(message as SearchChannelItem))
          as SearchChannelItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchChannelItem create() => SearchChannelItem._();
  @$core.override
  SearchChannelItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchChannelItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchChannelItem>(create);
  static SearchChannelItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get channel => $_getSZ(1);
  @$pb.TagNumber(2)
  set channel($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get categoryId => $_getSZ(4);
  @$pb.TagNumber(5)
  set categoryId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategoryId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategoryId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get categoryName => $_getSZ(5);
  @$pb.TagNumber(6)
  set categoryName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategoryName() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategoryName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get thumbnailUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set thumbnailUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasThumbnailUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearThumbnailUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isLive => $_getBF(7);
  @$pb.TagNumber(8)
  set isLive($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsLive() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsLive() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get startedAt => $_getSZ(8);
  @$pb.TagNumber(9)
  set startedAt($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStartedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearStartedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get language => $_getSZ(9);
  @$pb.TagNumber(10)
  set language($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLanguage() => $_has(9);
  @$pb.TagNumber(10)
  void clearLanguage() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get tags => $_getList(10);

  @$pb.TagNumber(12)
  $0.DiscoveredSource get source => $_getN(11);
  @$pb.TagNumber(12)
  set source($0.DiscoveredSource value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearSource() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.DiscoveredSource ensureSource() => $_ensure(11);
}

class SearchLiveChannelsResponse extends $pb.GeneratedMessage {
  factory SearchLiveChannelsResponse({
    $core.Iterable<SearchChannelItem>? items,
    $core.String? cursor,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  SearchLiveChannelsResponse._();

  factory SearchLiveChannelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchLiveChannelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchLiveChannelsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..pPM<SearchChannelItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: SearchChannelItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchLiveChannelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchLiveChannelsResponse copyWith(
          void Function(SearchLiveChannelsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SearchLiveChannelsResponse))
          as SearchLiveChannelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchLiveChannelsResponse create() => SearchLiveChannelsResponse._();
  @$core.override
  SearchLiveChannelsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchLiveChannelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchLiveChannelsResponse>(create);
  static SearchLiveChannelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SearchChannelItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

class ListScheduleRequest extends $pb.GeneratedMessage {
  factory ListScheduleRequest({
    $core.String? broadcasterId,
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (broadcasterId != null) result.broadcasterId = broadcasterId;
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ListScheduleRequest._();

  factory ListScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListScheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'broadcasterId')
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aI(3, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..aOB(5, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScheduleRequest copyWith(void Function(ListScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as ListScheduleRequest))
          as ListScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListScheduleRequest create() => ListScheduleRequest._();
  @$core.override
  ListScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListScheduleRequest>(create);
  static ListScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get broadcasterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set broadcasterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBroadcasterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcasterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

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

  @$pb.TagNumber(5)
  $core.bool get shared => $_getBF(4);
  @$pb.TagNumber(5)
  set shared($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShared() => $_has(4);
  @$pb.TagNumber(5)
  void clearShared() => $_clearField(5);
}

class ScheduleSegment extends $pb.GeneratedMessage {
  factory ScheduleSegment({
    $core.String? id,
    $core.String? startTime,
    $core.String? endTime,
    $core.String? title,
    $core.String? categoryId,
    $core.String? categoryName,
    $core.String? canceledUntil,
    $core.bool? isRecurring,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (title != null) result.title = title;
    if (categoryId != null) result.categoryId = categoryId;
    if (categoryName != null) result.categoryName = categoryName;
    if (canceledUntil != null) result.canceledUntil = canceledUntil;
    if (isRecurring != null) result.isRecurring = isRecurring;
    return result;
  }

  ScheduleSegment._();

  factory ScheduleSegment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleSegment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleSegment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'startTime')
    ..aOS(3, _omitFieldNames ? '' : 'endTime')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'categoryId')
    ..aOS(6, _omitFieldNames ? '' : 'categoryName')
    ..aOS(7, _omitFieldNames ? '' : 'canceledUntil')
    ..aOB(8, _omitFieldNames ? '' : 'isRecurring')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleSegment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleSegment copyWith(void Function(ScheduleSegment) updates) =>
      super.copyWith((message) => updates(message as ScheduleSegment))
          as ScheduleSegment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleSegment create() => ScheduleSegment._();
  @$core.override
  ScheduleSegment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleSegment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleSegment>(create);
  static ScheduleSegment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get startTime => $_getSZ(1);
  @$pb.TagNumber(2)
  set startTime($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get endTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set endTime($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get categoryId => $_getSZ(4);
  @$pb.TagNumber(5)
  set categoryId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategoryId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategoryId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get categoryName => $_getSZ(5);
  @$pb.TagNumber(6)
  set categoryName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategoryName() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategoryName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get canceledUntil => $_getSZ(6);
  @$pb.TagNumber(7)
  set canceledUntil($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCanceledUntil() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanceledUntil() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isRecurring => $_getBF(7);
  @$pb.TagNumber(8)
  set isRecurring($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsRecurring() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsRecurring() => $_clearField(8);
}

class ListScheduleResponse extends $pb.GeneratedMessage {
  factory ListScheduleResponse({
    $core.String? broadcasterId,
    $core.String? broadcasterLogin,
    $core.String? broadcasterName,
    $core.Iterable<ScheduleSegment>? segments,
    $core.String? cursor,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (broadcasterId != null) result.broadcasterId = broadcasterId;
    if (broadcasterLogin != null) result.broadcasterLogin = broadcasterLogin;
    if (broadcasterName != null) result.broadcasterName = broadcasterName;
    if (segments != null) result.segments.addAll(segments);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  ListScheduleResponse._();

  factory ListScheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListScheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListScheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'broadcasterId')
    ..aOS(2, _omitFieldNames ? '' : 'broadcasterLogin')
    ..aOS(3, _omitFieldNames ? '' : 'broadcasterName')
    ..pPM<ScheduleSegment>(4, _omitFieldNames ? '' : 'segments',
        subBuilder: ScheduleSegment.create)
    ..aOS(5, _omitFieldNames ? '' : 'cursor')
    ..aOB(6, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(7, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListScheduleResponse copyWith(void Function(ListScheduleResponse) updates) =>
      super.copyWith((message) => updates(message as ListScheduleResponse))
          as ListScheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListScheduleResponse create() => ListScheduleResponse._();
  @$core.override
  ListScheduleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListScheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListScheduleResponse>(create);
  static ListScheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get broadcasterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set broadcasterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBroadcasterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBroadcasterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get broadcasterLogin => $_getSZ(1);
  @$pb.TagNumber(2)
  set broadcasterLogin($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBroadcasterLogin() => $_has(1);
  @$pb.TagNumber(2)
  void clearBroadcasterLogin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get broadcasterName => $_getSZ(2);
  @$pb.TagNumber(3)
  set broadcasterName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBroadcasterName() => $_has(2);
  @$pb.TagNumber(3)
  void clearBroadcasterName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ScheduleSegment> get segments => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get cursor => $_getSZ(4);
  @$pb.TagNumber(5)
  set cursor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCursor() => $_has(4);
  @$pb.TagNumber(5)
  void clearCursor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hasMore => $_getBF(5);
  @$pb.TagNumber(6)
  set hasMore($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasMore() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasMore() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.DiscoveredSource get source => $_getN(6);
  @$pb.TagNumber(7)
  set source($0.DiscoveredSource value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.DiscoveredSource ensureSource() => $_ensure(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
