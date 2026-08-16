// This is a generated file - do not edit.
//
// Generated from proto/providers/douyin.proto.

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
import 'douyin.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'douyin.pbenum.dart';

class BindRequest extends $pb.GeneratedMessage {
  factory BindRequest({
    $core.String? label,
    $core.String? cookie,
    $core.String? instanceName,
  }) {
    final result = create();
    if (label != null) result.label = label;
    if (cookie != null) result.cookie = cookie;
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'label')
    ..aOS(2, _omitFieldNames ? '' : 'cookie')
    ..aOS(3, _omitFieldNames ? '' : 'instanceName')
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
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookie => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookie($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCookie() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookie() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get instanceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set instanceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInstanceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstanceName() => $_clearField(3);
}

class BindResponse extends $pb.GeneratedMessage {
  factory BindResponse({
    $core.String? serverId,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
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
    $core.String? label,
    $core.bool? hasCookie,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (label != null) result.label = label;
    if (hasCookie != null) result.hasCookie = hasCookie;
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOB(4, _omitFieldNames ? '' : 'hasCookie')
    ..aInt64(5, _omitFieldNames ? '' : 'createdAt')
    ..aOS(6, _omitFieldNames ? '' : 'providerInstanceName')
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
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasCookie => $_getBF(3);
  @$pb.TagNumber(4)
  set hasCookie($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasCookie() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasCookie() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get createdAt => $_getI64(4);
  @$pb.TagNumber(5)
  set createdAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get providerInstanceName => $_getSZ(5);
  @$pb.TagNumber(6)
  set providerInstanceName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProviderInstanceName() => $_has(5);
  @$pb.TagNumber(6)
  void clearProviderInstanceName() => $_clearField(6);
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
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

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.String? url,
    $core.int? width,
    $core.int? height,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  Image._();

  factory Image.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Image.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Image',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aI(2, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Image clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Image copyWith(void Function(Image) updates) =>
      super.copyWith((message) => updates(message as Image)) as Image;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  @$core.override
  Image createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(2)
  set width($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(3)
  set height($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => $_clearField(3);
}

class Author extends $pb.GeneratedMessage {
  factory Author({
    $core.String? id,
    $core.String? secUid,
    $core.String? uniqueId,
    $core.String? nickname,
    Image? avatar,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (secUid != null) result.secUid = secUid;
    if (uniqueId != null) result.uniqueId = uniqueId;
    if (nickname != null) result.nickname = nickname;
    if (avatar != null) result.avatar = avatar;
    return result;
  }

  Author._();

  factory Author.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Author.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Author',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'secUid')
    ..aOS(3, _omitFieldNames ? '' : 'uniqueId')
    ..aOS(4, _omitFieldNames ? '' : 'nickname')
    ..aOM<Image>(5, _omitFieldNames ? '' : 'avatar', subBuilder: Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author copyWith(void Function(Author) updates) =>
      super.copyWith((message) => updates(message as Author)) as Author;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Author create() => Author._();
  @$core.override
  Author createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Author getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Author>(create);
  static Author? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get secUid => $_getSZ(1);
  @$pb.TagNumber(2)
  set secUid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSecUid() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecUid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uniqueId => $_getSZ(2);
  @$pb.TagNumber(3)
  set uniqueId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUniqueId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUniqueId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nickname => $_getSZ(3);
  @$pb.TagNumber(4)
  set nickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearNickname() => $_clearField(4);

  @$pb.TagNumber(5)
  Image get avatar => $_getN(4);
  @$pb.TagNumber(5)
  set avatar(Image value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAvatar() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvatar() => $_clearField(5);
  @$pb.TagNumber(5)
  Image ensureAvatar() => $_ensure(4);
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? id,
    MediaKind? kind,
    $core.String? title,
    $core.String? description,
    Author? author,
    Image? cover,
    Image? dynamicCover,
    $fixnum.Int64? durationMs,
    $fixnum.Int64? createdAt,
    $core.bool? isLive,
    $fixnum.Int64? viewCount,
    $fixnum.Int64? likeCount,
    $fixnum.Int64? commentCount,
    $fixnum.Int64? shareCount,
    $fixnum.Int64? collectCount,
    $core.String? musicTitle,
    $core.String? musicAuthor,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (kind != null) result.kind = kind;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (author != null) result.author = author;
    if (cover != null) result.cover = cover;
    if (dynamicCover != null) result.dynamicCover = dynamicCover;
    if (durationMs != null) result.durationMs = durationMs;
    if (createdAt != null) result.createdAt = createdAt;
    if (isLive != null) result.isLive = isLive;
    if (viewCount != null) result.viewCount = viewCount;
    if (likeCount != null) result.likeCount = likeCount;
    if (commentCount != null) result.commentCount = commentCount;
    if (shareCount != null) result.shareCount = shareCount;
    if (collectCount != null) result.collectCount = collectCount;
    if (musicTitle != null) result.musicTitle = musicTitle;
    if (musicAuthor != null) result.musicAuthor = musicAuthor;
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<MediaKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: MediaKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOM<Author>(5, _omitFieldNames ? '' : 'author', subBuilder: Author.create)
    ..aOM<Image>(6, _omitFieldNames ? '' : 'cover', subBuilder: Image.create)
    ..aOM<Image>(7, _omitFieldNames ? '' : 'dynamicCover',
        subBuilder: Image.create)
    ..a<$fixnum.Int64>(
        8, _omitFieldNames ? '' : 'durationMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(9, _omitFieldNames ? '' : 'createdAt')
    ..aOB(10, _omitFieldNames ? '' : 'isLive')
    ..a<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        12, _omitFieldNames ? '' : 'likeCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        13, _omitFieldNames ? '' : 'commentCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        14, _omitFieldNames ? '' : 'shareCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        15, _omitFieldNames ? '' : 'collectCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(16, _omitFieldNames ? '' : 'musicTitle')
    ..aOS(17, _omitFieldNames ? '' : 'musicAuthor')
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
  MediaKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(MediaKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  Author get author => $_getN(4);
  @$pb.TagNumber(5)
  set author(Author value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => $_clearField(5);
  @$pb.TagNumber(5)
  Author ensureAuthor() => $_ensure(4);

  @$pb.TagNumber(6)
  Image get cover => $_getN(5);
  @$pb.TagNumber(6)
  set cover(Image value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCover() => $_has(5);
  @$pb.TagNumber(6)
  void clearCover() => $_clearField(6);
  @$pb.TagNumber(6)
  Image ensureCover() => $_ensure(5);

  @$pb.TagNumber(7)
  Image get dynamicCover => $_getN(6);
  @$pb.TagNumber(7)
  set dynamicCover(Image value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDynamicCover() => $_has(6);
  @$pb.TagNumber(7)
  void clearDynamicCover() => $_clearField(7);
  @$pb.TagNumber(7)
  Image ensureDynamicCover() => $_ensure(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get durationMs => $_getI64(7);
  @$pb.TagNumber(8)
  set durationMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createdAt => $_getI64(8);
  @$pb.TagNumber(9)
  set createdAt($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isLive => $_getBF(9);
  @$pb.TagNumber(10)
  set isLive($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsLive() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsLive() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get viewCount => $_getI64(10);
  @$pb.TagNumber(11)
  set viewCount($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasViewCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearViewCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get likeCount => $_getI64(11);
  @$pb.TagNumber(12)
  set likeCount($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLikeCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearLikeCount() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get commentCount => $_getI64(12);
  @$pb.TagNumber(13)
  set commentCount($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCommentCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearCommentCount() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get shareCount => $_getI64(13);
  @$pb.TagNumber(14)
  set shareCount($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasShareCount() => $_has(13);
  @$pb.TagNumber(14)
  void clearShareCount() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get collectCount => $_getI64(14);
  @$pb.TagNumber(15)
  set collectCount($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCollectCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearCollectCount() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get musicTitle => $_getSZ(15);
  @$pb.TagNumber(16)
  set musicTitle($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasMusicTitle() => $_has(15);
  @$pb.TagNumber(16)
  void clearMusicTitle() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get musicAuthor => $_getSZ(16);
  @$pb.TagNumber(17)
  set musicAuthor($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasMusicAuthor() => $_has(16);
  @$pb.TagNumber(17)
  void clearMusicAuthor() => $_clearField(17);
}

class Variant extends $pb.GeneratedMessage {
  factory Variant({
    StreamFormat? format,
    $core.String? quality,
    $core.String? codec,
    $core.int? width,
    $core.int? height,
    $core.int? fps,
    $fixnum.Int64? bitrate,
    $core.bool? audioOnly,
    $core.bool? headersRequired,
  }) {
    final result = create();
    if (format != null) result.format = format;
    if (quality != null) result.quality = quality;
    if (codec != null) result.codec = codec;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (fps != null) result.fps = fps;
    if (bitrate != null) result.bitrate = bitrate;
    if (audioOnly != null) result.audioOnly = audioOnly;
    if (headersRequired != null) result.headersRequired = headersRequired;
    return result;
  }

  Variant._();

  factory Variant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Variant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Variant',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aE<StreamFormat>(1, _omitFieldNames ? '' : 'format',
        enumValues: StreamFormat.values)
    ..aOS(2, _omitFieldNames ? '' : 'quality')
    ..aOS(3, _omitFieldNames ? '' : 'codec')
    ..aI(4, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(5, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'fps', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'bitrate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(8, _omitFieldNames ? '' : 'audioOnly')
    ..aOB(9, _omitFieldNames ? '' : 'headersRequired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Variant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Variant copyWith(void Function(Variant) updates) =>
      super.copyWith((message) => updates(message as Variant)) as Variant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Variant create() => Variant._();
  @$core.override
  Variant createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Variant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Variant>(create);
  static Variant? _defaultInstance;

  @$pb.TagNumber(1)
  StreamFormat get format => $_getN(0);
  @$pb.TagNumber(1)
  set format(StreamFormat value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFormat() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormat() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get quality => $_getSZ(1);
  @$pb.TagNumber(2)
  set quality($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuality() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuality() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get codec => $_getSZ(2);
  @$pb.TagNumber(3)
  set codec($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCodec() => $_has(2);
  @$pb.TagNumber(3)
  void clearCodec() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get width => $_getIZ(3);
  @$pb.TagNumber(4)
  set width($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearWidth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get height => $_getIZ(4);
  @$pb.TagNumber(5)
  set height($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHeight() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get fps => $_getIZ(5);
  @$pb.TagNumber(6)
  set fps($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFps() => $_has(5);
  @$pb.TagNumber(6)
  void clearFps() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get bitrate => $_getI64(6);
  @$pb.TagNumber(7)
  set bitrate($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBitrate() => $_has(6);
  @$pb.TagNumber(7)
  void clearBitrate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get audioOnly => $_getBF(7);
  @$pb.TagNumber(8)
  set audioOnly($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAudioOnly() => $_has(7);
  @$pb.TagNumber(8)
  void clearAudioOnly() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get headersRequired => $_getBF(8);
  @$pb.TagNumber(9)
  set headersRequired($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHeadersRequired() => $_has(8);
  @$pb.TagNumber(9)
  void clearHeadersRequired() => $_clearField(9);
}

class ResolveResponse extends $pb.GeneratedMessage {
  factory ResolveResponse({
    Metadata? metadata,
    $core.Iterable<Variant>? variants,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (metadata != null) result.metadata = metadata;
    if (variants != null) result.variants.addAll(variants);
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOM<Metadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: Metadata.create)
    ..pPM<Variant>(2, _omitFieldNames ? '' : 'variants',
        subBuilder: Variant.create)
    ..aOM<$0.DiscoveredSource>(3, _omitFieldNames ? '' : 'source',
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
  Metadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(Metadata value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => $_clearField(1);
  @$pb.TagNumber(1)
  Metadata ensureMetadata() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Variant> get variants => $_getList(1);

  @$pb.TagNumber(3)
  $0.DiscoveredSource get source => $_getN(2);
  @$pb.TagNumber(3)
  set source($0.DiscoveredSource value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.DiscoveredSource ensureSource() => $_ensure(2);
}

class ListUserPostsRequest extends $pb.GeneratedMessage {
  factory ListUserPostsRequest({
    $core.String? secUid,
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
    $core.bool? shared,
  }) {
    final result = create();
    if (secUid != null) result.secUid = secUid;
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    if (shared != null) result.shared = shared;
    return result;
  }

  ListUserPostsRequest._();

  factory ListUserPostsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserPostsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserPostsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'secUid')
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aI(3, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..aOB(5, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserPostsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserPostsRequest copyWith(void Function(ListUserPostsRequest) updates) =>
      super.copyWith((message) => updates(message as ListUserPostsRequest))
          as ListUserPostsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserPostsRequest create() => ListUserPostsRequest._();
  @$core.override
  ListUserPostsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUserPostsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserPostsRequest>(create);
  static ListUserPostsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get secUid => $_getSZ(0);
  @$pb.TagNumber(1)
  set secUid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecUid() => $_clearField(1);

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

class ListItem extends $pb.GeneratedMessage {
  factory ListItem({
    $core.String? awemeId,
    $core.String? title,
    Author? author,
    Image? cover,
    $fixnum.Int64? durationMs,
    $fixnum.Int64? createdAt,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (awemeId != null) result.awemeId = awemeId;
    if (title != null) result.title = title;
    if (author != null) result.author = author;
    if (cover != null) result.cover = cover;
    if (durationMs != null) result.durationMs = durationMs;
    if (createdAt != null) result.createdAt = createdAt;
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
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'awemeId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<Author>(3, _omitFieldNames ? '' : 'author', subBuilder: Author.create)
    ..aOM<Image>(4, _omitFieldNames ? '' : 'cover', subBuilder: Image.create)
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'durationMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(6, _omitFieldNames ? '' : 'createdAt')
    ..aOM<$0.DiscoveredSource>(7, _omitFieldNames ? '' : 'source',
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
  $core.String get awemeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set awemeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAwemeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAwemeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  Author get author => $_getN(2);
  @$pb.TagNumber(3)
  set author(Author value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);
  @$pb.TagNumber(3)
  Author ensureAuthor() => $_ensure(2);

  @$pb.TagNumber(4)
  Image get cover => $_getN(3);
  @$pb.TagNumber(4)
  set cover(Image value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);
  @$pb.TagNumber(4)
  Image ensureCover() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get durationMs => $_getI64(4);
  @$pb.TagNumber(5)
  set durationMs($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDurationMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearDurationMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAt => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);

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

class ListUserPostsResponse extends $pb.GeneratedMessage {
  factory ListUserPostsResponse({
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

  ListUserPostsResponse._();

  factory ListUserPostsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListUserPostsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUserPostsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.douyin'),
      createEmptyInstance: create)
    ..pPM<ListItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: ListItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserPostsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUserPostsResponse copyWith(
          void Function(ListUserPostsResponse) updates) =>
      super.copyWith((message) => updates(message as ListUserPostsResponse))
          as ListUserPostsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListUserPostsResponse create() => ListUserPostsResponse._();
  @$core.override
  ListUserPostsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListUserPostsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUserPostsResponse>(create);
  static ListUserPostsResponse? _defaultInstance;

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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
