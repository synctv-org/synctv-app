// This is a generated file - do not edit.
//
// Generated from proto/providers/fnos.proto.

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
import 'fnos.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'fnos.pbenum.dart';

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? endpoint,
    $core.String? webdavEndpoint,
    $core.String? mediaEndpoint,
    $core.String? username,
    $core.String? password,
    $core.String? twofaCode,
    $core.bool? trustDevice,
    $core.String? instanceName,
  }) {
    final result = create();
    if (endpoint != null) result.endpoint = endpoint;
    if (webdavEndpoint != null) result.webdavEndpoint = webdavEndpoint;
    if (mediaEndpoint != null) result.mediaEndpoint = mediaEndpoint;
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (twofaCode != null) result.twofaCode = twofaCode;
    if (trustDevice != null) result.trustDevice = trustDevice;
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'endpoint')
    ..aOS(2, _omitFieldNames ? '' : 'webdavEndpoint')
    ..aOS(3, _omitFieldNames ? '' : 'mediaEndpoint')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'password')
    ..aOS(6, _omitFieldNames ? '' : 'twofaCode')
    ..aOB(7, _omitFieldNames ? '' : 'trustDevice')
    ..aOS(8, _omitFieldNames ? '' : 'instanceName')
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
  $core.String get webdavEndpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set webdavEndpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWebdavEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearWebdavEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get mediaEndpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set mediaEndpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaEndpoint() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get password => $_getSZ(4);
  @$pb.TagNumber(5)
  set password($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassword() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassword() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get twofaCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set twofaCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTwofaCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearTwofaCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get trustDevice => $_getBF(6);
  @$pb.TagNumber(7)
  set trustDevice($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTrustDevice() => $_has(6);
  @$pb.TagNumber(7)
  void clearTrustDevice() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get instanceName => $_getSZ(7);
  @$pb.TagNumber(8)
  set instanceName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInstanceName() => $_has(7);
  @$pb.TagNumber(8)
  void clearInstanceName() => $_clearField(8);
}

enum LoginResponse_Result { authenticated, twoFactorRequired, notSet }

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    Authenticated? authenticated,
    TwoFactorRequired? twoFactorRequired,
  }) {
    final result = create();
    if (authenticated != null) result.authenticated = authenticated;
    if (twoFactorRequired != null) result.twoFactorRequired = twoFactorRequired;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, LoginResponse_Result>
      _LoginResponse_ResultByTag = {
    1: LoginResponse_Result.authenticated,
    2: LoginResponse_Result.twoFactorRequired,
    0: LoginResponse_Result.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Authenticated>(1, _omitFieldNames ? '' : 'authenticated',
        subBuilder: Authenticated.create)
    ..aOM<TwoFactorRequired>(2, _omitFieldNames ? '' : 'twoFactorRequired',
        subBuilder: TwoFactorRequired.create)
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
  @$pb.TagNumber(2)
  LoginResponse_Result whichResult() =>
      _LoginResponse_ResultByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearResult() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Authenticated get authenticated => $_getN(0);
  @$pb.TagNumber(1)
  set authenticated(Authenticated value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthenticated() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthenticated() => $_clearField(1);
  @$pb.TagNumber(1)
  Authenticated ensureAuthenticated() => $_ensure(0);

  @$pb.TagNumber(2)
  TwoFactorRequired get twoFactorRequired => $_getN(1);
  @$pb.TagNumber(2)
  set twoFactorRequired(TwoFactorRequired value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTwoFactorRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearTwoFactorRequired() => $_clearField(2);
  @$pb.TagNumber(2)
  TwoFactorRequired ensureTwoFactorRequired() => $_ensure(1);
}

class Authenticated extends $pb.GeneratedMessage {
  factory Authenticated({
    $core.String? serverId,
    $core.String? hostName,
    $core.String? version,
    $core.bool? mediaAvailable,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (hostName != null) result.hostName = hostName;
    if (version != null) result.version = version;
    if (mediaAvailable != null) result.mediaAvailable = mediaAvailable;
    return result;
  }

  Authenticated._();

  factory Authenticated.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Authenticated.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Authenticated',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'hostName')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..aOB(4, _omitFieldNames ? '' : 'mediaAvailable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Authenticated clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Authenticated copyWith(void Function(Authenticated) updates) =>
      super.copyWith((message) => updates(message as Authenticated))
          as Authenticated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Authenticated create() => Authenticated._();
  @$core.override
  Authenticated createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Authenticated getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Authenticated>(create);
  static Authenticated? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hostName => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostName() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get mediaAvailable => $_getBF(3);
  @$pb.TagNumber(4)
  set mediaAvailable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMediaAvailable() => $_has(3);
  @$pb.TagNumber(4)
  void clearMediaAvailable() => $_clearField(4);
}

class TwoFactorRequired extends $pb.GeneratedMessage {
  factory TwoFactorRequired({
    $core.bool? setupRequired,
  }) {
    final result = create();
    if (setupRequired != null) result.setupRequired = setupRequired;
    return result;
  }

  TwoFactorRequired._();

  factory TwoFactorRequired.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwoFactorRequired.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwoFactorRequired',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'setupRequired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoFactorRequired clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoFactorRequired copyWith(void Function(TwoFactorRequired) updates) =>
      super.copyWith((message) => updates(message as TwoFactorRequired))
          as TwoFactorRequired;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwoFactorRequired create() => TwoFactorRequired._();
  @$core.override
  TwoFactorRequired createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwoFactorRequired getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwoFactorRequired>(create);
  static TwoFactorRequired? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get setupRequired => $_getBF(0);
  @$pb.TagNumber(1)
  set setupRequired($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetupRequired() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetupRequired() => $_clearField(1);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $core.String? serverId,
    $core.String? path,
    $core.int? page,
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aI(3, _omitFieldNames ? '' : 'page', fieldType: $pb.PbFieldType.OU3)
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
  $core.int get page => $_getIZ(2);
  @$pb.TagNumber(3)
  set page($core.int value) => $_setUnsignedInt32(2, value);
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

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<FileItem>? content,
    $fixnum.Int64? total,
    $core.int? page,
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..pPM<FileItem>(1, _omitFieldNames ? '' : 'content',
        subBuilder: FileItem.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'page', fieldType: $pb.PbFieldType.OU3)
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
  $core.int get page => $_getIZ(2);
  @$pb.TagNumber(3)
  set page($core.int value) => $_setUnsignedInt32(2, value);
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

class ListMediaLibrariesRequest extends $pb.GeneratedMessage {
  factory ListMediaLibrariesRequest({
    $core.String? serverId,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListMediaLibrariesRequest._();

  factory ListMediaLibrariesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMediaLibrariesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMediaLibrariesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaLibrariesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaLibrariesRequest copyWith(
          void Function(ListMediaLibrariesRequest) updates) =>
      super.copyWith((message) => updates(message as ListMediaLibrariesRequest))
          as ListMediaLibrariesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMediaLibrariesRequest create() => ListMediaLibrariesRequest._();
  @$core.override
  ListMediaLibrariesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMediaLibrariesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMediaLibrariesRequest>(create);
  static ListMediaLibrariesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instanceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceName() => $_clearField(2);
}

class ListMediaLibrariesResponse extends $pb.GeneratedMessage {
  factory ListMediaLibrariesResponse({
    $core.Iterable<MediaLibrary>? libraries,
  }) {
    final result = create();
    if (libraries != null) result.libraries.addAll(libraries);
    return result;
  }

  ListMediaLibrariesResponse._();

  factory ListMediaLibrariesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMediaLibrariesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMediaLibrariesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..pPM<MediaLibrary>(1, _omitFieldNames ? '' : 'libraries',
        subBuilder: MediaLibrary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaLibrariesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaLibrariesResponse copyWith(
          void Function(ListMediaLibrariesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListMediaLibrariesResponse))
          as ListMediaLibrariesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMediaLibrariesResponse create() => ListMediaLibrariesResponse._();
  @$core.override
  ListMediaLibrariesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMediaLibrariesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMediaLibrariesResponse>(create);
  static ListMediaLibrariesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MediaLibrary> get libraries => $_getList(0);
}

class MediaLibrary extends $pb.GeneratedMessage {
  factory MediaLibrary({
    $core.String? guid,
    $core.String? title,
    $core.String? poster,
    $core.Iterable<$core.String>? posters,
    $core.String? category,
    $core.int? viewType,
    $core.int? posterType,
  }) {
    final result = create();
    if (guid != null) result.guid = guid;
    if (title != null) result.title = title;
    if (poster != null) result.poster = poster;
    if (posters != null) result.posters.addAll(posters);
    if (category != null) result.category = category;
    if (viewType != null) result.viewType = viewType;
    if (posterType != null) result.posterType = posterType;
    return result;
  }

  MediaLibrary._();

  factory MediaLibrary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaLibrary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaLibrary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'guid')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'poster')
    ..pPS(4, _omitFieldNames ? '' : 'posters')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aI(6, _omitFieldNames ? '' : 'viewType')
    ..aI(7, _omitFieldNames ? '' : 'posterType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaLibrary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaLibrary copyWith(void Function(MediaLibrary) updates) =>
      super.copyWith((message) => updates(message as MediaLibrary))
          as MediaLibrary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaLibrary create() => MediaLibrary._();
  @$core.override
  MediaLibrary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaLibrary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaLibrary>(create);
  static MediaLibrary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(1)
  set guid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get poster => $_getSZ(2);
  @$pb.TagNumber(3)
  set poster($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPoster() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoster() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get posters => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get viewType => $_getIZ(5);
  @$pb.TagNumber(6)
  set viewType($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasViewType() => $_has(5);
  @$pb.TagNumber(6)
  void clearViewType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get posterType => $_getIZ(6);
  @$pb.TagNumber(7)
  set posterType($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPosterType() => $_has(6);
  @$pb.TagNumber(7)
  void clearPosterType() => $_clearField(7);
}

class ListMediaItemsRequest extends $pb.GeneratedMessage {
  factory ListMediaItemsRequest({
    $core.String? serverId,
    MediaCollection? collection,
    $core.String? libraryGuid,
    $core.int? page,
    $core.int? pageSize,
    $core.Iterable<$core.String>? mediaTypes,
    $core.String? search,
    $core.String? instanceName,
    $core.String? parentGuid,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (collection != null) result.collection = collection;
    if (libraryGuid != null) result.libraryGuid = libraryGuid;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (mediaTypes != null) result.mediaTypes.addAll(mediaTypes);
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    if (parentGuid != null) result.parentGuid = parentGuid;
    return result;
  }

  ListMediaItemsRequest._();

  factory ListMediaItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMediaItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMediaItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aE<MediaCollection>(2, _omitFieldNames ? '' : 'collection',
        enumValues: MediaCollection.values)
    ..aOS(3, _omitFieldNames ? '' : 'libraryGuid')
    ..aI(4, _omitFieldNames ? '' : 'page', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..pPS(6, _omitFieldNames ? '' : 'mediaTypes')
    ..aOS(7, _omitFieldNames ? '' : 'search')
    ..aOS(8, _omitFieldNames ? '' : 'instanceName')
    ..aOS(9, _omitFieldNames ? '' : 'parentGuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaItemsRequest copyWith(
          void Function(ListMediaItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListMediaItemsRequest))
          as ListMediaItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMediaItemsRequest create() => ListMediaItemsRequest._();
  @$core.override
  ListMediaItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMediaItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMediaItemsRequest>(create);
  static ListMediaItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  MediaCollection get collection => $_getN(1);
  @$pb.TagNumber(2)
  set collection(MediaCollection value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCollection() => $_has(1);
  @$pb.TagNumber(2)
  void clearCollection() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get libraryGuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set libraryGuid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLibraryGuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearLibraryGuid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get page => $_getIZ(3);
  @$pb.TagNumber(4)
  set page($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get mediaTypes => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get search => $_getSZ(6);
  @$pb.TagNumber(7)
  set search($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSearch() => $_has(6);
  @$pb.TagNumber(7)
  void clearSearch() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get instanceName => $_getSZ(7);
  @$pb.TagNumber(8)
  set instanceName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInstanceName() => $_has(7);
  @$pb.TagNumber(8)
  void clearInstanceName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get parentGuid => $_getSZ(8);
  @$pb.TagNumber(9)
  set parentGuid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasParentGuid() => $_has(8);
  @$pb.TagNumber(9)
  void clearParentGuid() => $_clearField(9);
}

class ListMediaItemsResponse extends $pb.GeneratedMessage {
  factory ListMediaItemsResponse({
    $core.Iterable<MediaItem>? items,
    $fixnum.Int64? total,
    $core.int? page,
    $core.bool? hasMore,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (total != null) result.total = total;
    if (page != null) result.page = page;
    if (hasMore != null) result.hasMore = hasMore;
    if (source != null) result.source = source;
    return result;
  }

  ListMediaItemsResponse._();

  factory ListMediaItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMediaItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMediaItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..pPM<MediaItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: MediaItem.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'page', fieldType: $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(5, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMediaItemsResponse copyWith(
          void Function(ListMediaItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListMediaItemsResponse))
          as ListMediaItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMediaItemsResponse create() => ListMediaItemsResponse._();
  @$core.override
  ListMediaItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMediaItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMediaItemsResponse>(create);
  static ListMediaItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MediaItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get page => $_getIZ(2);
  @$pb.TagNumber(3)
  set page($core.int value) => $_setUnsignedInt32(2, value);
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

class MediaItem extends $pb.GeneratedMessage {
  factory MediaItem({
    $core.String? guid,
    $core.String? title,
    $core.String? itemType,
    $core.String? poster,
    $core.String? mediaGuid,
    $core.String? parentGuid,
    $core.String? overview,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? progressSeconds,
    $core.bool? watched,
    $core.int? seasonNumber,
    $core.int? episodeNumber,
    $core.bool? isFolder,
    $core.bool? isPlayable,
    $core.bool? favorite,
    $0.DiscoveredSource? source,
    $core.String? libraryGuid,
  }) {
    final result = create();
    if (guid != null) result.guid = guid;
    if (title != null) result.title = title;
    if (itemType != null) result.itemType = itemType;
    if (poster != null) result.poster = poster;
    if (mediaGuid != null) result.mediaGuid = mediaGuid;
    if (parentGuid != null) result.parentGuid = parentGuid;
    if (overview != null) result.overview = overview;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (progressSeconds != null) result.progressSeconds = progressSeconds;
    if (watched != null) result.watched = watched;
    if (seasonNumber != null) result.seasonNumber = seasonNumber;
    if (episodeNumber != null) result.episodeNumber = episodeNumber;
    if (isFolder != null) result.isFolder = isFolder;
    if (isPlayable != null) result.isPlayable = isPlayable;
    if (favorite != null) result.favorite = favorite;
    if (source != null) result.source = source;
    if (libraryGuid != null) result.libraryGuid = libraryGuid;
    return result;
  }

  MediaItem._();

  factory MediaItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'guid')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'itemType')
    ..aOS(4, _omitFieldNames ? '' : 'poster')
    ..aOS(5, _omitFieldNames ? '' : 'mediaGuid')
    ..aOS(6, _omitFieldNames ? '' : 'parentGuid')
    ..aOS(7, _omitFieldNames ? '' : 'overview')
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'progressSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(10, _omitFieldNames ? '' : 'watched')
    ..aI(11, _omitFieldNames ? '' : 'seasonNumber',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(12, _omitFieldNames ? '' : 'episodeNumber',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(13, _omitFieldNames ? '' : 'isFolder')
    ..aOB(14, _omitFieldNames ? '' : 'isPlayable')
    ..aOB(15, _omitFieldNames ? '' : 'favorite')
    ..aOM<$0.DiscoveredSource>(16, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..aOS(17, _omitFieldNames ? '' : 'libraryGuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaItem copyWith(void Function(MediaItem) updates) =>
      super.copyWith((message) => updates(message as MediaItem)) as MediaItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaItem create() => MediaItem._();
  @$core.override
  MediaItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MediaItem>(create);
  static MediaItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get guid => $_getSZ(0);
  @$pb.TagNumber(1)
  set guid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemType => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemType() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get poster => $_getSZ(3);
  @$pb.TagNumber(4)
  set poster($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPoster() => $_has(3);
  @$pb.TagNumber(4)
  void clearPoster() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get mediaGuid => $_getSZ(4);
  @$pb.TagNumber(5)
  set mediaGuid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMediaGuid() => $_has(4);
  @$pb.TagNumber(5)
  void clearMediaGuid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get parentGuid => $_getSZ(5);
  @$pb.TagNumber(6)
  set parentGuid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentGuid() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentGuid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get overview => $_getSZ(6);
  @$pb.TagNumber(7)
  set overview($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOverview() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverview() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get durationSeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get progressSeconds => $_getI64(8);
  @$pb.TagNumber(9)
  set progressSeconds($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProgressSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearProgressSeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get watched => $_getBF(9);
  @$pb.TagNumber(10)
  set watched($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWatched() => $_has(9);
  @$pb.TagNumber(10)
  void clearWatched() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get seasonNumber => $_getIZ(10);
  @$pb.TagNumber(11)
  set seasonNumber($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSeasonNumber() => $_has(10);
  @$pb.TagNumber(11)
  void clearSeasonNumber() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get episodeNumber => $_getIZ(11);
  @$pb.TagNumber(12)
  set episodeNumber($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEpisodeNumber() => $_has(11);
  @$pb.TagNumber(12)
  void clearEpisodeNumber() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get isFolder => $_getBF(12);
  @$pb.TagNumber(13)
  set isFolder($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsFolder() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsFolder() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isPlayable => $_getBF(13);
  @$pb.TagNumber(14)
  set isPlayable($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsPlayable() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsPlayable() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get favorite => $_getBF(14);
  @$pb.TagNumber(15)
  set favorite($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFavorite() => $_has(14);
  @$pb.TagNumber(15)
  void clearFavorite() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.DiscoveredSource get source => $_getN(15);
  @$pb.TagNumber(16)
  set source($0.DiscoveredSource value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSource() => $_has(15);
  @$pb.TagNumber(16)
  void clearSource() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.DiscoveredSource ensureSource() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get libraryGuid => $_getSZ(16);
  @$pb.TagNumber(17)
  set libraryGuid($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasLibraryGuid() => $_has(16);
  @$pb.TagNumber(17)
  void clearLibraryGuid() => $_clearField(17);
}

class SetFavoriteRequest extends $pb.GeneratedMessage {
  factory SetFavoriteRequest({
    $core.String? serverId,
    $core.String? itemGuid,
    $core.bool? favorite,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (itemGuid != null) result.itemGuid = itemGuid;
    if (favorite != null) result.favorite = favorite;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  SetFavoriteRequest._();

  factory SetFavoriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetFavoriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetFavoriteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'itemGuid')
    ..aOB(3, _omitFieldNames ? '' : 'favorite')
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFavoriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFavoriteRequest copyWith(void Function(SetFavoriteRequest) updates) =>
      super.copyWith((message) => updates(message as SetFavoriteRequest))
          as SetFavoriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetFavoriteRequest create() => SetFavoriteRequest._();
  @$core.override
  SetFavoriteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetFavoriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetFavoriteRequest>(create);
  static SetFavoriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemGuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemGuid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemGuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemGuid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get favorite => $_getBF(2);
  @$pb.TagNumber(3)
  set favorite($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFavorite() => $_has(2);
  @$pb.TagNumber(3)
  void clearFavorite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class SetFavoriteResponse extends $pb.GeneratedMessage {
  factory SetFavoriteResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SetFavoriteResponse._();

  factory SetFavoriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetFavoriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetFavoriteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFavoriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFavoriteResponse copyWith(void Function(SetFavoriteResponse) updates) =>
      super.copyWith((message) => updates(message as SetFavoriteResponse))
          as SetFavoriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetFavoriteResponse create() => SetFavoriteResponse._();
  @$core.override
  SetFavoriteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetFavoriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetFavoriteResponse>(create);
  static SetFavoriteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class SetWatchedRequest extends $pb.GeneratedMessage {
  factory SetWatchedRequest({
    $core.String? serverId,
    $core.String? itemGuid,
    $core.bool? watched,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (itemGuid != null) result.itemGuid = itemGuid;
    if (watched != null) result.watched = watched;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  SetWatchedRequest._();

  factory SetWatchedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetWatchedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetWatchedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'itemGuid')
    ..aOB(3, _omitFieldNames ? '' : 'watched')
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWatchedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWatchedRequest copyWith(void Function(SetWatchedRequest) updates) =>
      super.copyWith((message) => updates(message as SetWatchedRequest))
          as SetWatchedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetWatchedRequest create() => SetWatchedRequest._();
  @$core.override
  SetWatchedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetWatchedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetWatchedRequest>(create);
  static SetWatchedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemGuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemGuid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemGuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemGuid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get watched => $_getBF(2);
  @$pb.TagNumber(3)
  set watched($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatched() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatched() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class SetWatchedResponse extends $pb.GeneratedMessage {
  factory SetWatchedResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SetWatchedResponse._();

  factory SetWatchedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetWatchedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetWatchedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWatchedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWatchedResponse copyWith(void Function(SetWatchedResponse) updates) =>
      super.copyWith((message) => updates(message as SetWatchedResponse))
          as SetWatchedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetWatchedResponse create() => SetWatchedResponse._();
  @$core.override
  SetWatchedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetWatchedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetWatchedResponse>(create);
  static SetWatchedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class FileItem extends $pb.GeneratedMessage {
  factory FileItem({
    $core.String? name,
    $core.String? path,
    $fixnum.Int64? size,
    $fixnum.Int64? modifiedAt,
    $fixnum.Int64? createdAt,
    $core.bool? isDir,
    $fixnum.Int64? storageId,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (path != null) result.path = path;
    if (size != null) result.size = size;
    if (modifiedAt != null) result.modifiedAt = modifiedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (isDir != null) result.isDir = isDir;
    if (storageId != null) result.storageId = storageId;
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(4, _omitFieldNames ? '' : 'modifiedAt')
    ..aInt64(5, _omitFieldNames ? '' : 'createdAt')
    ..aOB(6, _omitFieldNames ? '' : 'isDir')
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'storageId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.DiscoveredSource>(8, _omitFieldNames ? '' : 'source',
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
  $fixnum.Int64 get size => $_getI64(2);
  @$pb.TagNumber(3)
  set size($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get modifiedAt => $_getI64(3);
  @$pb.TagNumber(4)
  set modifiedAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModifiedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearModifiedAt() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get createdAt => $_getI64(4);
  @$pb.TagNumber(5)
  set createdAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isDir => $_getBF(5);
  @$pb.TagNumber(6)
  set isDir($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsDir() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsDir() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get storageId => $_getI64(6);
  @$pb.TagNumber(7)
  set storageId($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStorageId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStorageId() => $_clearField(7);

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

class GetServerInfoRequest extends $pb.GeneratedMessage {
  factory GetServerInfoRequest({
    $core.String? serverId,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  GetServerInfoRequest._();

  factory GetServerInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerInfoRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoRequest copyWith(void Function(GetServerInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetServerInfoRequest))
          as GetServerInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerInfoRequest create() => GetServerInfoRequest._();
  @$core.override
  GetServerInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServerInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerInfoRequest>(create);
  static GetServerInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instanceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceName() => $_clearField(2);
}

class GetServerInfoResponse extends $pb.GeneratedMessage {
  factory GetServerInfoResponse({
    $core.String? hostName,
    $core.String? version,
  }) {
    final result = create();
    if (hostName != null) result.hostName = hostName;
    if (version != null) result.version = version;
    return result;
  }

  GetServerInfoResponse._();

  factory GetServerInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServerInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServerInfoResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hostName')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServerInfoResponse copyWith(
          void Function(GetServerInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetServerInfoResponse))
          as GetServerInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServerInfoResponse create() => GetServerInfoResponse._();
  @$core.override
  GetServerInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServerInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServerInfoResponse>(create);
  static GetServerInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hostName => $_getSZ(0);
  @$pb.TagNumber(1)
  set hostName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHostName() => $_has(0);
  @$pb.TagNumber(1)
  void clearHostName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
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

class GetThumbnailRequest extends $pb.GeneratedMessage {
  factory GetThumbnailRequest({
    $core.String? serverId,
    $core.String? imagePath,
    $core.int? width,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (imagePath != null) result.imagePath = imagePath;
    if (width != null) result.width = width;
    return result;
  }

  GetThumbnailRequest._();

  factory GetThumbnailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetThumbnailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetThumbnailRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'imagePath')
    ..aI(3, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetThumbnailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetThumbnailRequest copyWith(void Function(GetThumbnailRequest) updates) =>
      super.copyWith((message) => updates(message as GetThumbnailRequest))
          as GetThumbnailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetThumbnailRequest create() => GetThumbnailRequest._();
  @$core.override
  GetThumbnailRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetThumbnailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetThumbnailRequest>(create);
  static GetThumbnailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get imagePath => $_getSZ(1);
  @$pb.TagNumber(2)
  set imagePath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImagePath() => $_has(1);
  @$pb.TagNumber(2)
  void clearImagePath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => $_clearField(3);
}

class BindInfo extends $pb.GeneratedMessage {
  factory BindInfo({
    $core.String? id,
    $core.String? serverId,
    $core.String? endpoint,
    $core.String? webdavEndpoint,
    $core.String? mediaEndpoint,
    $core.String? username,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
    $core.bool? mediaAvailable,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (endpoint != null) result.endpoint = endpoint;
    if (webdavEndpoint != null) result.webdavEndpoint = webdavEndpoint;
    if (mediaEndpoint != null) result.mediaEndpoint = mediaEndpoint;
    if (username != null) result.username = username;
    if (createdAt != null) result.createdAt = createdAt;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    if (mediaAvailable != null) result.mediaAvailable = mediaAvailable;
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
          _omitMessageNames ? '' : 'synctv.provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..aOS(4, _omitFieldNames ? '' : 'webdavEndpoint')
    ..aOS(5, _omitFieldNames ? '' : 'mediaEndpoint')
    ..aOS(6, _omitFieldNames ? '' : 'username')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAt')
    ..aOS(8, _omitFieldNames ? '' : 'providerInstanceName')
    ..aOB(9, _omitFieldNames ? '' : 'mediaAvailable')
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
  $core.String get webdavEndpoint => $_getSZ(3);
  @$pb.TagNumber(4)
  set webdavEndpoint($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWebdavEndpoint() => $_has(3);
  @$pb.TagNumber(4)
  void clearWebdavEndpoint() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get mediaEndpoint => $_getSZ(4);
  @$pb.TagNumber(5)
  set mediaEndpoint($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMediaEndpoint() => $_has(4);
  @$pb.TagNumber(5)
  void clearMediaEndpoint() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get username => $_getSZ(5);
  @$pb.TagNumber(6)
  set username($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsername() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsername() => $_clearField(6);

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

  @$pb.TagNumber(9)
  $core.bool get mediaAvailable => $_getBF(8);
  @$pb.TagNumber(9)
  set mediaAvailable($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMediaAvailable() => $_has(8);
  @$pb.TagNumber(9)
  void clearMediaAvailable() => $_clearField(9);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
