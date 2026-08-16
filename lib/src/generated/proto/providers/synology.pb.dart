// This is a generated file - do not edit.
//
// Generated from proto/providers/synology.proto.

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
import 'synology.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'synology.pbenum.dart';

class LoginRequest extends $pb.GeneratedMessage {
  factory LoginRequest({
    $core.String? endpoint,
    $core.String? username,
    $core.String? password,
    $core.String? otpCode,
    $core.String? deviceName,
    $core.String? instanceName,
  }) {
    final result = create();
    if (endpoint != null) result.endpoint = endpoint;
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (otpCode != null) result.otpCode = otpCode;
    if (deviceName != null) result.deviceName = deviceName;
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'endpoint')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aOS(4, _omitFieldNames ? '' : 'otpCode')
    ..aOS(5, _omitFieldNames ? '' : 'deviceName')
    ..aOS(6, _omitFieldNames ? '' : 'instanceName')
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
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get otpCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set otpCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOtpCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearOtpCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get deviceName => $_getSZ(4);
  @$pb.TagNumber(5)
  set deviceName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeviceName() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeviceName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get instanceName => $_getSZ(5);
  @$pb.TagNumber(6)
  set instanceName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInstanceName() => $_has(5);
  @$pb.TagNumber(6)
  void clearInstanceName() => $_clearField(6);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $core.String? serverId,
    $core.bool? videoStationAvailable,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (videoStationAvailable != null)
      result.videoStationAvailable = videoStationAvailable;
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOB(2, _omitFieldNames ? '' : 'videoStationAvailable')
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
  $core.bool get videoStationAvailable => $_getBF(1);
  @$pb.TagNumber(2)
  set videoStationAvailable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVideoStationAvailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideoStationAvailable() => $_clearField(2);
}

class ListFilesRequest extends $pb.GeneratedMessage {
  factory ListFilesRequest({
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

  ListFilesRequest._();

  factory ListFilesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFilesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFilesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
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
  ListFilesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFilesRequest copyWith(void Function(ListFilesRequest) updates) =>
      super.copyWith((message) => updates(message as ListFilesRequest))
          as ListFilesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFilesRequest create() => ListFilesRequest._();
  @$core.override
  ListFilesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFilesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFilesRequest>(create);
  static ListFilesRequest? _defaultInstance;

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

class FileItem extends $pb.GeneratedMessage {
  factory FileItem({
    $core.String? name,
    $core.String? path,
    $core.bool? isDir,
    $fixnum.Int64? size,
    $fixnum.Int64? modifiedAt,
    $fixnum.Int64? createdAt,
    $core.String? fileType,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (path != null) result.path = path;
    if (isDir != null) result.isDir = isDir;
    if (size != null) result.size = size;
    if (modifiedAt != null) result.modifiedAt = modifiedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (fileType != null) result.fileType = fileType;
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOB(3, _omitFieldNames ? '' : 'isDir')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'modifiedAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'createdAt', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(7, _omitFieldNames ? '' : 'fileType')
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
  $core.bool get isDir => $_getBF(2);
  @$pb.TagNumber(3)
  set isDir($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsDir() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get size => $_getI64(3);
  @$pb.TagNumber(4)
  set size($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get modifiedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set modifiedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModifiedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearModifiedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get fileType => $_getSZ(6);
  @$pb.TagNumber(7)
  set fileType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFileType() => $_has(6);
  @$pb.TagNumber(7)
  void clearFileType() => $_clearField(7);

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

class ListFilesResponse extends $pb.GeneratedMessage {
  factory ListFilesResponse({
    $core.Iterable<FileItem>? items,
    $fixnum.Int64? total,
    $fixnum.Int64? page,
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

  ListFilesResponse._();

  factory ListFilesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFilesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFilesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..pPM<FileItem>(1, _omitFieldNames ? '' : 'items',
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
  ListFilesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFilesResponse copyWith(void Function(ListFilesResponse) updates) =>
      super.copyWith((message) => updates(message as ListFilesResponse))
          as ListFilesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFilesResponse create() => ListFilesResponse._();
  @$core.override
  ListFilesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFilesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFilesResponse>(create);
  static ListFilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FileItem> get items => $_getList(0);

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

class ListLibrariesRequest extends $pb.GeneratedMessage {
  factory ListLibrariesRequest({
    $core.String? serverId,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListLibrariesRequest._();

  factory ListLibrariesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLibrariesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLibrariesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLibrariesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLibrariesRequest copyWith(void Function(ListLibrariesRequest) updates) =>
      super.copyWith((message) => updates(message as ListLibrariesRequest))
          as ListLibrariesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLibrariesRequest create() => ListLibrariesRequest._();
  @$core.override
  ListLibrariesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLibrariesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLibrariesRequest>(create);
  static ListLibrariesRequest? _defaultInstance;

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

class VideoLibrary extends $pb.GeneratedMessage {
  factory VideoLibrary({
    $fixnum.Int64? id,
    $core.String? title,
    $core.String? libraryType,
    $core.bool? isPublic,
    $core.bool? visible,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (libraryType != null) result.libraryType = libraryType;
    if (isPublic != null) result.isPublic = isPublic;
    if (visible != null) result.visible = visible;
    return result;
  }

  VideoLibrary._();

  factory VideoLibrary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoLibrary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoLibrary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'libraryType')
    ..aOB(4, _omitFieldNames ? '' : 'isPublic')
    ..aOB(5, _omitFieldNames ? '' : 'visible')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoLibrary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoLibrary copyWith(void Function(VideoLibrary) updates) =>
      super.copyWith((message) => updates(message as VideoLibrary))
          as VideoLibrary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoLibrary create() => VideoLibrary._();
  @$core.override
  VideoLibrary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VideoLibrary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoLibrary>(create);
  static VideoLibrary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
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
  $core.String get libraryType => $_getSZ(2);
  @$pb.TagNumber(3)
  set libraryType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLibraryType() => $_has(2);
  @$pb.TagNumber(3)
  void clearLibraryType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isPublic => $_getBF(3);
  @$pb.TagNumber(4)
  set isPublic($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsPublic() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsPublic() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get visible => $_getBF(4);
  @$pb.TagNumber(5)
  set visible($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVisible() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisible() => $_clearField(5);
}

class ListLibrariesResponse extends $pb.GeneratedMessage {
  factory ListLibrariesResponse({
    $core.Iterable<VideoLibrary>? libraries,
  }) {
    final result = create();
    if (libraries != null) result.libraries.addAll(libraries);
    return result;
  }

  ListLibrariesResponse._();

  factory ListLibrariesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLibrariesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLibrariesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..pPM<VideoLibrary>(1, _omitFieldNames ? '' : 'libraries',
        subBuilder: VideoLibrary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLibrariesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLibrariesResponse copyWith(
          void Function(ListLibrariesResponse) updates) =>
      super.copyWith((message) => updates(message as ListLibrariesResponse))
          as ListLibrariesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLibrariesResponse create() => ListLibrariesResponse._();
  @$core.override
  ListLibrariesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLibrariesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLibrariesResponse>(create);
  static ListLibrariesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VideoLibrary> get libraries => $_getList(0);
}

class ListMoviesRequest extends $pb.GeneratedMessage {
  factory ListMoviesRequest({
    $core.String? serverId,
    $fixnum.Int64? libraryId,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (libraryId != null) result.libraryId = libraryId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListMoviesRequest._();

  factory ListMoviesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMoviesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMoviesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aInt64(2, _omitFieldNames ? '' : 'libraryId')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOS(6, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMoviesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMoviesRequest copyWith(void Function(ListMoviesRequest) updates) =>
      super.copyWith((message) => updates(message as ListMoviesRequest))
          as ListMoviesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMoviesRequest create() => ListMoviesRequest._();
  @$core.override
  ListMoviesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMoviesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMoviesRequest>(create);
  static ListMoviesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

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

class ListTvShowsRequest extends $pb.GeneratedMessage {
  factory ListTvShowsRequest({
    $core.String? serverId,
    $fixnum.Int64? libraryId,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (libraryId != null) result.libraryId = libraryId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListTvShowsRequest._();

  factory ListTvShowsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTvShowsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTvShowsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aInt64(2, _omitFieldNames ? '' : 'libraryId')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOS(6, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTvShowsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTvShowsRequest copyWith(void Function(ListTvShowsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTvShowsRequest))
          as ListTvShowsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTvShowsRequest create() => ListTvShowsRequest._();
  @$core.override
  ListTvShowsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTvShowsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTvShowsRequest>(create);
  static ListTvShowsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

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

class ListEpisodesRequest extends $pb.GeneratedMessage {
  factory ListEpisodesRequest({
    $core.String? serverId,
    $fixnum.Int64? libraryId,
    $fixnum.Int64? tvShowId,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (libraryId != null) result.libraryId = libraryId;
    if (tvShowId != null) result.tvShowId = tvShowId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListEpisodesRequest._();

  factory ListEpisodesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEpisodesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEpisodesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aInt64(2, _omitFieldNames ? '' : 'libraryId')
    ..aInt64(3, _omitFieldNames ? '' : 'tvShowId')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(5, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'search')
    ..aOS(7, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEpisodesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEpisodesRequest copyWith(void Function(ListEpisodesRequest) updates) =>
      super.copyWith((message) => updates(message as ListEpisodesRequest))
          as ListEpisodesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEpisodesRequest create() => ListEpisodesRequest._();
  @$core.override
  ListEpisodesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEpisodesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEpisodesRequest>(create);
  static ListEpisodesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get tvShowId => $_getI64(2);
  @$pb.TagNumber(3)
  set tvShowId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTvShowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTvShowId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get page => $_getI64(3);
  @$pb.TagNumber(4)
  set page($fixnum.Int64 value) => $_setInt64(3, value);
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
  $core.String get search => $_getSZ(5);
  @$pb.TagNumber(6)
  set search($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSearch() => $_has(5);
  @$pb.TagNumber(6)
  void clearSearch() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get instanceName => $_getSZ(6);
  @$pb.TagNumber(7)
  set instanceName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInstanceName() => $_has(6);
  @$pb.TagNumber(7)
  void clearInstanceName() => $_clearField(7);
}

class ListHomeVideosRequest extends $pb.GeneratedMessage {
  factory ListHomeVideosRequest({
    $core.String? serverId,
    $fixnum.Int64? libraryId,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (libraryId != null) result.libraryId = libraryId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListHomeVideosRequest._();

  factory ListHomeVideosRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHomeVideosRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHomeVideosRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aInt64(2, _omitFieldNames ? '' : 'libraryId')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOS(6, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHomeVideosRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHomeVideosRequest copyWith(
          void Function(ListHomeVideosRequest) updates) =>
      super.copyWith((message) => updates(message as ListHomeVideosRequest))
          as ListHomeVideosRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHomeVideosRequest create() => ListHomeVideosRequest._();
  @$core.override
  ListHomeVideosRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHomeVideosRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHomeVideosRequest>(create);
  static ListHomeVideosRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

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

class ListTvRecordingsRequest extends $pb.GeneratedMessage {
  factory ListTvRecordingsRequest({
    $core.String? serverId,
    $fixnum.Int64? libraryId,
    $fixnum.Int64? page,
    $core.int? pageSize,
    $core.String? search,
    $core.String? instanceName,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (libraryId != null) result.libraryId = libraryId;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (search != null) result.search = search;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListTvRecordingsRequest._();

  factory ListTvRecordingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTvRecordingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTvRecordingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aInt64(2, _omitFieldNames ? '' : 'libraryId')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'search')
    ..aOS(6, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTvRecordingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTvRecordingsRequest copyWith(
          void Function(ListTvRecordingsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTvRecordingsRequest))
          as ListTvRecordingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTvRecordingsRequest create() => ListTvRecordingsRequest._();
  @$core.override
  ListTvRecordingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTvRecordingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTvRecordingsRequest>(create);
  static ListTvRecordingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

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

class VideoFile extends $pb.GeneratedMessage {
  factory VideoFile({
    $fixnum.Int64? id,
    $core.String? path,
    $fixnum.Int64? size,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? progressSeconds,
    $core.int? width,
    $core.int? height,
    $core.String? videoCodec,
    $core.String? audioCodec,
    $core.String? container,
    $fixnum.Int64? videoBitrate,
    $fixnum.Int64? audioBitrate,
    $fixnum.Int64? frameRateNumerator,
    $fixnum.Int64? frameRateDenominator,
    $core.int? audioChannels,
    $core.int? audioFrequencyHz,
    $core.bool? conversionProduced,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (path != null) result.path = path;
    if (size != null) result.size = size;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (progressSeconds != null) result.progressSeconds = progressSeconds;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (videoCodec != null) result.videoCodec = videoCodec;
    if (audioCodec != null) result.audioCodec = audioCodec;
    if (container != null) result.container = container;
    if (videoBitrate != null) result.videoBitrate = videoBitrate;
    if (audioBitrate != null) result.audioBitrate = audioBitrate;
    if (frameRateNumerator != null)
      result.frameRateNumerator = frameRateNumerator;
    if (frameRateDenominator != null)
      result.frameRateDenominator = frameRateDenominator;
    if (audioChannels != null) result.audioChannels = audioChannels;
    if (audioFrequencyHz != null) result.audioFrequencyHz = audioFrequencyHz;
    if (conversionProduced != null)
      result.conversionProduced = conversionProduced;
    return result;
  }

  VideoFile._();

  factory VideoFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoFile',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'progressSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(6, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aOS(8, _omitFieldNames ? '' : 'videoCodec')
    ..aOS(9, _omitFieldNames ? '' : 'audioCodec')
    ..aOS(10, _omitFieldNames ? '' : 'container')
    ..a<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'videoBitrate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        12, _omitFieldNames ? '' : 'audioBitrate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        13, _omitFieldNames ? '' : 'frameRateNumerator', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        14, _omitFieldNames ? '' : 'frameRateDenominator', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(15, _omitFieldNames ? '' : 'audioChannels',
        fieldType: $pb.PbFieldType.OU3)
    ..aI(16, _omitFieldNames ? '' : 'audioFrequencyHz',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(17, _omitFieldNames ? '' : 'conversionProduced')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoFile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoFile copyWith(void Function(VideoFile) updates) =>
      super.copyWith((message) => updates(message as VideoFile)) as VideoFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoFile create() => VideoFile._();
  @$core.override
  VideoFile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VideoFile getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoFile>(create);
  static VideoFile? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

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
  $fixnum.Int64 get durationSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDurationSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearDurationSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get progressSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set progressSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProgressSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearProgressSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get width => $_getIZ(5);
  @$pb.TagNumber(6)
  set width($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWidth() => $_has(5);
  @$pb.TagNumber(6)
  void clearWidth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get height => $_getIZ(6);
  @$pb.TagNumber(7)
  set height($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearHeight() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get videoCodec => $_getSZ(7);
  @$pb.TagNumber(8)
  set videoCodec($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVideoCodec() => $_has(7);
  @$pb.TagNumber(8)
  void clearVideoCodec() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get audioCodec => $_getSZ(8);
  @$pb.TagNumber(9)
  set audioCodec($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAudioCodec() => $_has(8);
  @$pb.TagNumber(9)
  void clearAudioCodec() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get container => $_getSZ(9);
  @$pb.TagNumber(10)
  set container($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasContainer() => $_has(9);
  @$pb.TagNumber(10)
  void clearContainer() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get videoBitrate => $_getI64(10);
  @$pb.TagNumber(11)
  set videoBitrate($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVideoBitrate() => $_has(10);
  @$pb.TagNumber(11)
  void clearVideoBitrate() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get audioBitrate => $_getI64(11);
  @$pb.TagNumber(12)
  set audioBitrate($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAudioBitrate() => $_has(11);
  @$pb.TagNumber(12)
  void clearAudioBitrate() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get frameRateNumerator => $_getI64(12);
  @$pb.TagNumber(13)
  set frameRateNumerator($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasFrameRateNumerator() => $_has(12);
  @$pb.TagNumber(13)
  void clearFrameRateNumerator() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get frameRateDenominator => $_getI64(13);
  @$pb.TagNumber(14)
  set frameRateDenominator($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFrameRateDenominator() => $_has(13);
  @$pb.TagNumber(14)
  void clearFrameRateDenominator() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get audioChannels => $_getIZ(14);
  @$pb.TagNumber(15)
  set audioChannels($core.int value) => $_setUnsignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAudioChannels() => $_has(14);
  @$pb.TagNumber(15)
  void clearAudioChannels() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get audioFrequencyHz => $_getIZ(15);
  @$pb.TagNumber(16)
  set audioFrequencyHz($core.int value) => $_setUnsignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasAudioFrequencyHz() => $_has(15);
  @$pb.TagNumber(16)
  void clearAudioFrequencyHz() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get conversionProduced => $_getBF(16);
  @$pb.TagNumber(17)
  set conversionProduced($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasConversionProduced() => $_has(16);
  @$pb.TagNumber(17)
  void clearConversionProduced() => $_clearField(17);
}

class VideoItem extends $pb.GeneratedMessage {
  factory VideoItem({
    $fixnum.Int64? id,
    $fixnum.Int64? libraryId,
    SynologyVideoEntryKind? kind,
    $core.String? title,
    $core.String? sortTitle,
    $core.String? tagline,
    $core.String? summary,
    $core.String? certificate,
    $core.int? rating,
    $core.Iterable<$core.String>? actors,
    $core.Iterable<$core.String>? directors,
    $core.Iterable<$core.String>? writers,
    $core.Iterable<$core.String>? genres,
    $core.String? originalAvailable,
    $fixnum.Int64? createTime,
    $fixnum.Int64? lastWatched,
    $core.double? watchedRatio,
    $core.bool? parentalControlled,
    $core.int? season,
    $core.int? episode,
    $fixnum.Int64? tvShowId,
    $core.String? posterMtime,
    $core.String? backdropMtime,
    $core.Iterable<VideoFile>? files,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (libraryId != null) result.libraryId = libraryId;
    if (kind != null) result.kind = kind;
    if (title != null) result.title = title;
    if (sortTitle != null) result.sortTitle = sortTitle;
    if (tagline != null) result.tagline = tagline;
    if (summary != null) result.summary = summary;
    if (certificate != null) result.certificate = certificate;
    if (rating != null) result.rating = rating;
    if (actors != null) result.actors.addAll(actors);
    if (directors != null) result.directors.addAll(directors);
    if (writers != null) result.writers.addAll(writers);
    if (genres != null) result.genres.addAll(genres);
    if (originalAvailable != null) result.originalAvailable = originalAvailable;
    if (createTime != null) result.createTime = createTime;
    if (lastWatched != null) result.lastWatched = lastWatched;
    if (watchedRatio != null) result.watchedRatio = watchedRatio;
    if (parentalControlled != null)
      result.parentalControlled = parentalControlled;
    if (season != null) result.season = season;
    if (episode != null) result.episode = episode;
    if (tvShowId != null) result.tvShowId = tvShowId;
    if (posterMtime != null) result.posterMtime = posterMtime;
    if (backdropMtime != null) result.backdropMtime = backdropMtime;
    if (files != null) result.files.addAll(files);
    if (source != null) result.source = source;
    return result;
  }

  VideoItem._();

  factory VideoItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'libraryId')
    ..aE<SynologyVideoEntryKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: SynologyVideoEntryKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'sortTitle')
    ..aOS(6, _omitFieldNames ? '' : 'tagline')
    ..aOS(7, _omitFieldNames ? '' : 'summary')
    ..aOS(8, _omitFieldNames ? '' : 'certificate')
    ..aI(9, _omitFieldNames ? '' : 'rating')
    ..pPS(10, _omitFieldNames ? '' : 'actors')
    ..pPS(11, _omitFieldNames ? '' : 'directors')
    ..pPS(12, _omitFieldNames ? '' : 'writers')
    ..pPS(13, _omitFieldNames ? '' : 'genres')
    ..aOS(14, _omitFieldNames ? '' : 'originalAvailable')
    ..aInt64(15, _omitFieldNames ? '' : 'createTime')
    ..aInt64(16, _omitFieldNames ? '' : 'lastWatched')
    ..aD(17, _omitFieldNames ? '' : 'watchedRatio')
    ..aOB(18, _omitFieldNames ? '' : 'parentalControlled')
    ..aI(19, _omitFieldNames ? '' : 'season', fieldType: $pb.PbFieldType.OU3)
    ..aI(20, _omitFieldNames ? '' : 'episode', fieldType: $pb.PbFieldType.OU3)
    ..aInt64(21, _omitFieldNames ? '' : 'tvShowId')
    ..aOS(22, _omitFieldNames ? '' : 'posterMtime')
    ..aOS(23, _omitFieldNames ? '' : 'backdropMtime')
    ..pPM<VideoFile>(24, _omitFieldNames ? '' : 'files',
        subBuilder: VideoFile.create)
    ..aOM<$0.DiscoveredSource>(25, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoItem copyWith(void Function(VideoItem) updates) =>
      super.copyWith((message) => updates(message as VideoItem)) as VideoItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoItem create() => VideoItem._();
  @$core.override
  VideoItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VideoItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoItem>(create);
  static VideoItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get libraryId => $_getI64(1);
  @$pb.TagNumber(2)
  set libraryId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLibraryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLibraryId() => $_clearField(2);

  @$pb.TagNumber(3)
  SynologyVideoEntryKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(SynologyVideoEntryKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sortTitle => $_getSZ(4);
  @$pb.TagNumber(5)
  set sortTitle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSortTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearSortTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get tagline => $_getSZ(5);
  @$pb.TagNumber(6)
  set tagline($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTagline() => $_has(5);
  @$pb.TagNumber(6)
  void clearTagline() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get summary => $_getSZ(6);
  @$pb.TagNumber(7)
  set summary($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSummary() => $_has(6);
  @$pb.TagNumber(7)
  void clearSummary() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get certificate => $_getSZ(7);
  @$pb.TagNumber(8)
  set certificate($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCertificate() => $_has(7);
  @$pb.TagNumber(8)
  void clearCertificate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get rating => $_getIZ(8);
  @$pb.TagNumber(9)
  set rating($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRating() => $_has(8);
  @$pb.TagNumber(9)
  void clearRating() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get actors => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get directors => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get writers => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get genres => $_getList(12);

  @$pb.TagNumber(14)
  $core.String get originalAvailable => $_getSZ(13);
  @$pb.TagNumber(14)
  set originalAvailable($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOriginalAvailable() => $_has(13);
  @$pb.TagNumber(14)
  void clearOriginalAvailable() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get createTime => $_getI64(14);
  @$pb.TagNumber(15)
  set createTime($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCreateTime() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreateTime() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get lastWatched => $_getI64(15);
  @$pb.TagNumber(16)
  set lastWatched($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasLastWatched() => $_has(15);
  @$pb.TagNumber(16)
  void clearLastWatched() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get watchedRatio => $_getN(16);
  @$pb.TagNumber(17)
  set watchedRatio($core.double value) => $_setDouble(16, value);
  @$pb.TagNumber(17)
  $core.bool hasWatchedRatio() => $_has(16);
  @$pb.TagNumber(17)
  void clearWatchedRatio() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get parentalControlled => $_getBF(17);
  @$pb.TagNumber(18)
  set parentalControlled($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasParentalControlled() => $_has(17);
  @$pb.TagNumber(18)
  void clearParentalControlled() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get season => $_getIZ(18);
  @$pb.TagNumber(19)
  set season($core.int value) => $_setUnsignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasSeason() => $_has(18);
  @$pb.TagNumber(19)
  void clearSeason() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.int get episode => $_getIZ(19);
  @$pb.TagNumber(20)
  set episode($core.int value) => $_setUnsignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasEpisode() => $_has(19);
  @$pb.TagNumber(20)
  void clearEpisode() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get tvShowId => $_getI64(20);
  @$pb.TagNumber(21)
  set tvShowId($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasTvShowId() => $_has(20);
  @$pb.TagNumber(21)
  void clearTvShowId() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get posterMtime => $_getSZ(21);
  @$pb.TagNumber(22)
  set posterMtime($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasPosterMtime() => $_has(21);
  @$pb.TagNumber(22)
  void clearPosterMtime() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get backdropMtime => $_getSZ(22);
  @$pb.TagNumber(23)
  set backdropMtime($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasBackdropMtime() => $_has(22);
  @$pb.TagNumber(23)
  void clearBackdropMtime() => $_clearField(23);

  @$pb.TagNumber(24)
  $pb.PbList<VideoFile> get files => $_getList(23);

  @$pb.TagNumber(25)
  $0.DiscoveredSource get source => $_getN(24);
  @$pb.TagNumber(25)
  set source($0.DiscoveredSource value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasSource() => $_has(24);
  @$pb.TagNumber(25)
  void clearSource() => $_clearField(25);
  @$pb.TagNumber(25)
  $0.DiscoveredSource ensureSource() => $_ensure(24);
}

class ListVideoItemsResponse extends $pb.GeneratedMessage {
  factory ListVideoItemsResponse({
    $core.Iterable<VideoItem>? items,
    $fixnum.Int64? total,
    $fixnum.Int64? page,
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

  ListVideoItemsResponse._();

  factory ListVideoItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVideoItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVideoItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..pPM<VideoItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: VideoItem.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(4, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(5, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVideoItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVideoItemsResponse copyWith(
          void Function(ListVideoItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListVideoItemsResponse))
          as ListVideoItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVideoItemsResponse create() => ListVideoItemsResponse._();
  @$core.override
  ListVideoItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVideoItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVideoItemsResponse>(create);
  static ListVideoItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VideoItem> get items => $_getList(0);

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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
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
    $core.bool? videoStationAvailable,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (endpoint != null) result.endpoint = endpoint;
    if (username != null) result.username = username;
    if (videoStationAvailable != null)
      result.videoStationAvailable = videoStationAvailable;
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'endpoint')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOB(5, _omitFieldNames ? '' : 'videoStationAvailable')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..aOS(7, _omitFieldNames ? '' : 'providerInstanceName')
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
  $core.bool get videoStationAvailable => $_getBF(4);
  @$pb.TagNumber(5)
  set videoStationAvailable($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVideoStationAvailable() => $_has(4);
  @$pb.TagNumber(5)
  void clearVideoStationAvailable() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get providerInstanceName => $_getSZ(6);
  @$pb.TagNumber(7)
  set providerInstanceName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProviderInstanceName() => $_has(6);
  @$pb.TagNumber(7)
  void clearProviderInstanceName() => $_clearField(7);
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
          _omitMessageNames ? '' : 'synctv.provider.synology'),
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

class FileImageRequest extends $pb.GeneratedMessage {
  factory FileImageRequest({
    $core.String? path,
    $core.String? size,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (size != null) result.size = size;
    return result;
  }

  FileImageRequest._();

  factory FileImageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileImageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileImageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'size')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileImageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileImageRequest copyWith(void Function(FileImageRequest) updates) =>
      super.copyWith((message) => updates(message as FileImageRequest))
          as FileImageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileImageRequest create() => FileImageRequest._();
  @$core.override
  FileImageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileImageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileImageRequest>(create);
  static FileImageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get size => $_getSZ(1);
  @$pb.TagNumber(2)
  set size($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);
}

class PosterImageRequest extends $pb.GeneratedMessage {
  factory PosterImageRequest({
    $fixnum.Int64? itemId,
    $core.String? mediaType,
    $core.String? posterMtime,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (mediaType != null) result.mediaType = mediaType;
    if (posterMtime != null) result.posterMtime = posterMtime;
    return result;
  }

  PosterImageRequest._();

  factory PosterImageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PosterImageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PosterImageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaType')
    ..aOS(3, _omitFieldNames ? '' : 'posterMtime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PosterImageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PosterImageRequest copyWith(void Function(PosterImageRequest) updates) =>
      super.copyWith((message) => updates(message as PosterImageRequest))
          as PosterImageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PosterImageRequest create() => PosterImageRequest._();
  @$core.override
  PosterImageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PosterImageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PosterImageRequest>(create);
  static PosterImageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get itemId => $_getI64(0);
  @$pb.TagNumber(1)
  set itemId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get posterMtime => $_getSZ(2);
  @$pb.TagNumber(3)
  set posterMtime($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosterMtime() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosterMtime() => $_clearField(3);
}

enum GetImageRequest_Image { file, poster, notSet }

class GetImageRequest extends $pb.GeneratedMessage {
  factory GetImageRequest({
    $core.String? serverId,
    FileImageRequest? file,
    PosterImageRequest? poster,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (file != null) result.file = file;
    if (poster != null) result.poster = poster;
    return result;
  }

  GetImageRequest._();

  factory GetImageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetImageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, GetImageRequest_Image>
      _GetImageRequest_ImageByTag = {
    2: GetImageRequest_Image.file,
    3: GetImageRequest_Image.poster,
    0: GetImageRequest_Image.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetImageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.synology'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<FileImageRequest>(2, _omitFieldNames ? '' : 'file',
        subBuilder: FileImageRequest.create)
    ..aOM<PosterImageRequest>(3, _omitFieldNames ? '' : 'poster',
        subBuilder: PosterImageRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImageRequest copyWith(void Function(GetImageRequest) updates) =>
      super.copyWith((message) => updates(message as GetImageRequest))
          as GetImageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetImageRequest create() => GetImageRequest._();
  @$core.override
  GetImageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetImageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetImageRequest>(create);
  static GetImageRequest? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  GetImageRequest_Image whichImage() =>
      _GetImageRequest_ImageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearImage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  FileImageRequest get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(FileImageRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);
  @$pb.TagNumber(2)
  FileImageRequest ensureFile() => $_ensure(1);

  @$pb.TagNumber(3)
  PosterImageRequest get poster => $_getN(2);
  @$pb.TagNumber(3)
  set poster(PosterImageRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPoster() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoster() => $_clearField(3);
  @$pb.TagNumber(3)
  PosterImageRequest ensurePoster() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
