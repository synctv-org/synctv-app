// This is a generated file - do not edit.
//
// Generated from proto/providers/youtube.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../source_config.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BindRequest extends $pb.GeneratedMessage {
  factory BindRequest({
    $core.String? label,
    $core.String? visitorData,
    $core.String? poToken,
    $core.String? cookie,
    $core.String? instanceName,
  }) {
    final result = create();
    if (label != null) result.label = label;
    if (visitorData != null) result.visitorData = visitorData;
    if (poToken != null) result.poToken = poToken;
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'label')
    ..aOS(2, _omitFieldNames ? '' : 'visitorData')
    ..aOS(3, _omitFieldNames ? '' : 'poToken')
    ..aOS(4, _omitFieldNames ? '' : 'cookie')
    ..aOS(5, _omitFieldNames ? '' : 'instanceName')
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
  $core.String get visitorData => $_getSZ(1);
  @$pb.TagNumber(2)
  set visitorData($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVisitorData() => $_has(1);
  @$pb.TagNumber(2)
  void clearVisitorData() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get poToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set poToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPoToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cookie => $_getSZ(3);
  @$pb.TagNumber(4)
  set cookie($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCookie() => $_has(3);
  @$pb.TagNumber(4)
  void clearCookie() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get instanceName => $_getSZ(4);
  @$pb.TagNumber(5)
  set instanceName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstanceName() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstanceName() => $_clearField(5);
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
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
    $core.bool? hasVisitorData,
    $core.bool? hasPoToken,
    $core.bool? hasCookie,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (label != null) result.label = label;
    if (hasVisitorData != null) result.hasVisitorData = hasVisitorData;
    if (hasPoToken != null) result.hasPoToken = hasPoToken;
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOB(4, _omitFieldNames ? '' : 'hasVisitorData')
    ..aOB(5, _omitFieldNames ? '' : 'hasPoToken')
    ..aOB(6, _omitFieldNames ? '' : 'hasCookie')
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
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasVisitorData => $_getBF(3);
  @$pb.TagNumber(4)
  set hasVisitorData($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasVisitorData() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasVisitorData() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasPoToken => $_getBF(4);
  @$pb.TagNumber(5)
  set hasPoToken($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasPoToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasPoToken() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hasCookie => $_getBF(5);
  @$pb.TagNumber(6)
  set hasCookie($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasCookie() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasCookie() => $_clearField(6);

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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
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
  }) {
    final result = create();
    if (resource != null) result.resource = resource;
    if (instanceName != null) result.instanceName = instanceName;
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resource')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
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
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? videoId,
    $core.String? title,
    $core.String? channelId,
    $core.String? channelName,
    $core.String? description,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? viewCount,
    $core.String? thumbnailUrl,
    $core.Iterable<$core.String>? keywords,
    $core.bool? isLive,
    $core.bool? isPrivate,
    $core.String? publishDate,
    $core.String? uploadDate,
    $core.String? category,
    $core.String? liveStart,
    $core.String? liveEnd,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    if (title != null) result.title = title;
    if (channelId != null) result.channelId = channelId;
    if (channelName != null) result.channelName = channelName;
    if (description != null) result.description = description;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (viewCount != null) result.viewCount = viewCount;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (keywords != null) result.keywords.addAll(keywords);
    if (isLive != null) result.isLive = isLive;
    if (isPrivate != null) result.isPrivate = isPrivate;
    if (publishDate != null) result.publishDate = publishDate;
    if (uploadDate != null) result.uploadDate = uploadDate;
    if (category != null) result.category = category;
    if (liveStart != null) result.liveStart = liveStart;
    if (liveEnd != null) result.liveEnd = liveEnd;
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'channelId')
    ..aOS(4, _omitFieldNames ? '' : 'channelName')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(8, _omitFieldNames ? '' : 'thumbnailUrl')
    ..pPS(9, _omitFieldNames ? '' : 'keywords')
    ..aOB(10, _omitFieldNames ? '' : 'isLive')
    ..aOB(11, _omitFieldNames ? '' : 'isPrivate')
    ..aOS(12, _omitFieldNames ? '' : 'publishDate')
    ..aOS(13, _omitFieldNames ? '' : 'uploadDate')
    ..aOS(14, _omitFieldNames ? '' : 'category')
    ..aOS(15, _omitFieldNames ? '' : 'liveStart')
    ..aOS(16, _omitFieldNames ? '' : 'liveEnd')
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
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get channelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set channelId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChannelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get channelName => $_getSZ(3);
  @$pb.TagNumber(4)
  set channelName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChannelName() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannelName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get durationSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDurationSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearDurationSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get viewCount => $_getI64(6);
  @$pb.TagNumber(7)
  set viewCount($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasViewCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearViewCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get thumbnailUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set thumbnailUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasThumbnailUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearThumbnailUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get keywords => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get isLive => $_getBF(9);
  @$pb.TagNumber(10)
  set isLive($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsLive() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsLive() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isPrivate => $_getBF(10);
  @$pb.TagNumber(11)
  set isPrivate($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsPrivate() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsPrivate() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get publishDate => $_getSZ(11);
  @$pb.TagNumber(12)
  set publishDate($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPublishDate() => $_has(11);
  @$pb.TagNumber(12)
  void clearPublishDate() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get uploadDate => $_getSZ(12);
  @$pb.TagNumber(13)
  set uploadDate($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUploadDate() => $_has(12);
  @$pb.TagNumber(13)
  void clearUploadDate() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get category => $_getSZ(13);
  @$pb.TagNumber(14)
  set category($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCategory() => $_has(13);
  @$pb.TagNumber(14)
  void clearCategory() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get liveStart => $_getSZ(14);
  @$pb.TagNumber(15)
  set liveStart($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasLiveStart() => $_has(14);
  @$pb.TagNumber(15)
  void clearLiveStart() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get liveEnd => $_getSZ(15);
  @$pb.TagNumber(16)
  set liveEnd($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasLiveEnd() => $_has(15);
  @$pb.TagNumber(16)
  void clearLiveEnd() => $_clearField(16);
}

class Format extends $pb.GeneratedMessage {
  factory Format({
    $core.int? itag,
    $core.String? name,
    $core.String? container,
    $fixnum.Int64? bitrate,
    $core.int? width,
    $core.int? height,
    $core.int? fps,
    $core.Iterable<$core.String>? codecs,
    $core.bool? adaptive,
    $core.bool? audioOnly,
  }) {
    final result = create();
    if (itag != null) result.itag = itag;
    if (name != null) result.name = name;
    if (container != null) result.container = container;
    if (bitrate != null) result.bitrate = bitrate;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (fps != null) result.fps = fps;
    if (codecs != null) result.codecs.addAll(codecs);
    if (adaptive != null) result.adaptive = adaptive;
    if (audioOnly != null) result.audioOnly = audioOnly;
    return result;
  }

  Format._();

  factory Format.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Format.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Format',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'itag', fieldType: $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'container')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'bitrate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(5, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..aI(7, _omitFieldNames ? '' : 'fps', fieldType: $pb.PbFieldType.OU3)
    ..pPS(8, _omitFieldNames ? '' : 'codecs')
    ..aOB(9, _omitFieldNames ? '' : 'adaptive')
    ..aOB(10, _omitFieldNames ? '' : 'audioOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Format clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Format copyWith(void Function(Format) updates) =>
      super.copyWith((message) => updates(message as Format)) as Format;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Format create() => Format._();
  @$core.override
  Format createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Format getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Format>(create);
  static Format? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get itag => $_getIZ(0);
  @$pb.TagNumber(1)
  set itag($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItag() => $_has(0);
  @$pb.TagNumber(1)
  void clearItag() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get container => $_getSZ(2);
  @$pb.TagNumber(3)
  set container($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContainer() => $_has(2);
  @$pb.TagNumber(3)
  void clearContainer() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get bitrate => $_getI64(3);
  @$pb.TagNumber(4)
  set bitrate($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBitrate() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitrate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get width => $_getIZ(4);
  @$pb.TagNumber(5)
  set width($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWidth() => $_has(4);
  @$pb.TagNumber(5)
  void clearWidth() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get height => $_getIZ(5);
  @$pb.TagNumber(6)
  set height($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeight() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get fps => $_getIZ(6);
  @$pb.TagNumber(7)
  set fps($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFps() => $_has(6);
  @$pb.TagNumber(7)
  void clearFps() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get codecs => $_getList(7);

  @$pb.TagNumber(9)
  $core.bool get adaptive => $_getBF(8);
  @$pb.TagNumber(9)
  set adaptive($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAdaptive() => $_has(8);
  @$pb.TagNumber(9)
  void clearAdaptive() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get audioOnly => $_getBF(9);
  @$pb.TagNumber(10)
  set audioOnly($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAudioOnly() => $_has(9);
  @$pb.TagNumber(10)
  void clearAudioOnly() => $_clearField(10);
}

class Subtitle extends $pb.GeneratedMessage {
  factory Subtitle({
    $core.String? name,
    $core.String? language,
    $core.bool? automatic,
    $core.bool? translatable,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (language != null) result.language = language;
    if (automatic != null) result.automatic = automatic;
    if (translatable != null) result.translatable = translatable;
    return result;
  }

  Subtitle._();

  factory Subtitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Subtitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Subtitle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'language')
    ..aOB(3, _omitFieldNames ? '' : 'automatic')
    ..aOB(4, _omitFieldNames ? '' : 'translatable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subtitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Subtitle copyWith(void Function(Subtitle) updates) =>
      super.copyWith((message) => updates(message as Subtitle)) as Subtitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Subtitle create() => Subtitle._();
  @$core.override
  Subtitle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Subtitle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Subtitle>(create);
  static Subtitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get automatic => $_getBF(2);
  @$pb.TagNumber(3)
  set automatic($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAutomatic() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutomatic() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get translatable => $_getBF(3);
  @$pb.TagNumber(4)
  set translatable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTranslatable() => $_has(3);
  @$pb.TagNumber(4)
  void clearTranslatable() => $_clearField(4);
}

class ResolveResponse extends $pb.GeneratedMessage {
  factory ResolveResponse({
    Metadata? metadata,
    $core.Iterable<Format>? formats,
    $core.Iterable<Subtitle>? subtitles,
    $core.String? storyboardSpec,
    $0.YoutubeMediaSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (metadata != null) result.metadata = metadata;
    if (formats != null) result.formats.addAll(formats);
    if (subtitles != null) result.subtitles.addAll(subtitles);
    if (storyboardSpec != null) result.storyboardSpec = storyboardSpec;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
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
          _omitMessageNames ? '' : 'synctv.provider.youtube'),
      createEmptyInstance: create)
    ..aOM<Metadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: Metadata.create)
    ..pPM<Format>(2, _omitFieldNames ? '' : 'formats',
        subBuilder: Format.create)
    ..pPM<Subtitle>(3, _omitFieldNames ? '' : 'subtitles',
        subBuilder: Subtitle.create)
    ..aOS(4, _omitFieldNames ? '' : 'storyboardSpec')
    ..aOM<$0.YoutubeMediaSourceConfig>(5, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.YoutubeMediaSourceConfig.create)
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
  $pb.PbList<Format> get formats => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Subtitle> get subtitles => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get storyboardSpec => $_getSZ(3);
  @$pb.TagNumber(4)
  set storyboardSpec($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStoryboardSpec() => $_has(3);
  @$pb.TagNumber(4)
  void clearStoryboardSpec() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.YoutubeMediaSourceConfig get sourceConfig => $_getN(4);
  @$pb.TagNumber(5)
  set sourceConfig($0.YoutubeMediaSourceConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.YoutubeMediaSourceConfig ensureSourceConfig() => $_ensure(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
