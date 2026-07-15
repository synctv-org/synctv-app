// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/douyu.proto.

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

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetDouyuResourceRequest extends $pb.GeneratedMessage {
  factory GetDouyuResourceRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? mediaIndex,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
    $core.String? range,
    $core.bool? head,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (modeName != null) result.modeName = modeName;
    if (mediaIndex != null) result.mediaIndex = mediaIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (range != null) result.range = range;
    if (head != null) result.head = head;
    return result;
  }

  GetDouyuResourceRequest._();

  factory GetDouyuResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDouyuResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDouyuResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.douyu'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'mediaIndex', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..aOS(8, _omitFieldNames ? '' : 'range')
    ..aOB(9, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDouyuResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDouyuResourceRequest copyWith(
          void Function(GetDouyuResourceRequest) updates) =>
      super.copyWith((message) => updates(message as GetDouyuResourceRequest))
          as GetDouyuResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDouyuResourceRequest create() => GetDouyuResourceRequest._();
  @$core.override
  GetDouyuResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDouyuResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDouyuResourceRequest>(create);
  static GetDouyuResourceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get modeName => $_getSZ(1);
  @$pb.TagNumber(2)
  set modeName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModeName() => $_has(1);
  @$pb.TagNumber(2)
  void clearModeName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mediaIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set mediaIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sig => $_getSZ(3);
  @$pb.TagNumber(4)
  set sig($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSig() => $_has(3);
  @$pb.TagNumber(4)
  void clearSig() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get uid => $_getSZ(4);
  @$pb.TagNumber(5)
  set uid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUid() => $_has(4);
  @$pb.TagNumber(5)
  void clearUid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get rid => $_getSZ(5);
  @$pb.TagNumber(6)
  set rid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRid() => $_has(5);
  @$pb.TagNumber(6)
  void clearRid() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get exp => $_getI64(6);
  @$pb.TagNumber(7)
  set exp($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExp() => $_has(6);
  @$pb.TagNumber(7)
  void clearExp() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get range => $_getSZ(7);
  @$pb.TagNumber(8)
  set range($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRange() => $_has(7);
  @$pb.TagNumber(8)
  void clearRange() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get head => $_getBF(8);
  @$pb.TagNumber(9)
  set head($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHead() => $_has(8);
  @$pb.TagNumber(9)
  void clearHead() => $_clearField(9);
}

class DouyuResourceResponse extends $pb.GeneratedMessage {
  factory DouyuResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DouyuResourceResponse._();

  factory DouyuResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyuResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyuResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.douyu'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuResourceResponse copyWith(
          void Function(DouyuResourceResponse) updates) =>
      super.copyWith((message) => updates(message as DouyuResourceResponse))
          as DouyuResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyuResourceResponse create() => DouyuResourceResponse._();
  @$core.override
  DouyuResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyuResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyuResourceResponse>(create);
  static DouyuResourceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.StreamChunk get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($0.StreamChunk value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.StreamChunk ensureChunk() => $_ensure(0);
}

class GetDouyuSegmentRequest extends $pb.GeneratedMessage {
  factory GetDouyuSegmentRequest({
    $core.String? version,
    $core.String? targetUrl,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
    $core.String? range,
    $core.bool? head,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (targetUrl != null) result.targetUrl = targetUrl;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (range != null) result.range = range;
    if (head != null) result.head = head;
    return result;
  }

  GetDouyuSegmentRequest._();

  factory GetDouyuSegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDouyuSegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDouyuSegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.douyu'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'targetUrl')
    ..aOS(3, _omitFieldNames ? '' : 'sig')
    ..aOS(4, _omitFieldNames ? '' : 'uid')
    ..aOS(5, _omitFieldNames ? '' : 'rid')
    ..aInt64(6, _omitFieldNames ? '' : 'exp')
    ..aOS(7, _omitFieldNames ? '' : 'range')
    ..aOB(8, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDouyuSegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDouyuSegmentRequest copyWith(
          void Function(GetDouyuSegmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetDouyuSegmentRequest))
          as GetDouyuSegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDouyuSegmentRequest create() => GetDouyuSegmentRequest._();
  @$core.override
  GetDouyuSegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDouyuSegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDouyuSegmentRequest>(create);
  static GetDouyuSegmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sig => $_getSZ(2);
  @$pb.TagNumber(3)
  set sig($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSig() => $_has(2);
  @$pb.TagNumber(3)
  void clearSig() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uid => $_getSZ(3);
  @$pb.TagNumber(4)
  set uid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rid => $_getSZ(4);
  @$pb.TagNumber(5)
  set rid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRid() => $_has(4);
  @$pb.TagNumber(5)
  void clearRid() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get exp => $_getI64(5);
  @$pb.TagNumber(6)
  set exp($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExp() => $_has(5);
  @$pb.TagNumber(6)
  void clearExp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get range => $_getSZ(6);
  @$pb.TagNumber(7)
  set range($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRange() => $_has(6);
  @$pb.TagNumber(7)
  void clearRange() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get head => $_getBF(7);
  @$pb.TagNumber(8)
  set head($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHead() => $_has(7);
  @$pb.TagNumber(8)
  void clearHead() => $_clearField(8);
}

class DouyuSegmentResponse extends $pb.GeneratedMessage {
  factory DouyuSegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DouyuSegmentResponse._();

  factory DouyuSegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyuSegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyuSegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.douyu'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuSegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuSegmentResponse copyWith(void Function(DouyuSegmentResponse) updates) =>
      super.copyWith((message) => updates(message as DouyuSegmentResponse))
          as DouyuSegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyuSegmentResponse create() => DouyuSegmentResponse._();
  @$core.override
  DouyuSegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyuSegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyuSegmentResponse>(create);
  static DouyuSegmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.StreamChunk get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($0.StreamChunk value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.StreamChunk ensureChunk() => $_ensure(0);
}

class WatchDouyuDanmakuRequest extends $pb.GeneratedMessage {
  factory WatchDouyuDanmakuRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? mediaIndex,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (modeName != null) result.modeName = modeName;
    if (mediaIndex != null) result.mediaIndex = mediaIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  WatchDouyuDanmakuRequest._();

  factory WatchDouyuDanmakuRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchDouyuDanmakuRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchDouyuDanmakuRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.douyu'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'mediaIndex', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchDouyuDanmakuRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchDouyuDanmakuRequest copyWith(
          void Function(WatchDouyuDanmakuRequest) updates) =>
      super.copyWith((message) => updates(message as WatchDouyuDanmakuRequest))
          as WatchDouyuDanmakuRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchDouyuDanmakuRequest create() => WatchDouyuDanmakuRequest._();
  @$core.override
  WatchDouyuDanmakuRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchDouyuDanmakuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchDouyuDanmakuRequest>(create);
  static WatchDouyuDanmakuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get modeName => $_getSZ(1);
  @$pb.TagNumber(2)
  set modeName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModeName() => $_has(1);
  @$pb.TagNumber(2)
  void clearModeName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mediaIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set mediaIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sig => $_getSZ(3);
  @$pb.TagNumber(4)
  set sig($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSig() => $_has(3);
  @$pb.TagNumber(4)
  void clearSig() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get uid => $_getSZ(4);
  @$pb.TagNumber(5)
  set uid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUid() => $_has(4);
  @$pb.TagNumber(5)
  void clearUid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get rid => $_getSZ(5);
  @$pb.TagNumber(6)
  set rid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRid() => $_has(5);
  @$pb.TagNumber(6)
  void clearRid() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get exp => $_getI64(6);
  @$pb.TagNumber(7)
  set exp($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExp() => $_has(6);
  @$pb.TagNumber(7)
  void clearExp() => $_clearField(7);
}

class DouyuDanmakuEvent extends $pb.GeneratedMessage {
  factory DouyuDanmakuEvent({
    $core.String? id,
    $core.String? userId,
    $core.String? userName,
    $core.String? text,
    $core.String? color,
    $core.int? level,
    $core.String? badgeName,
    $core.int? badgeLevel,
    $fixnum.Int64? sentAtMs,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (userId != null) result.userId = userId;
    if (userName != null) result.userName = userName;
    if (text != null) result.text = text;
    if (color != null) result.color = color;
    if (level != null) result.level = level;
    if (badgeName != null) result.badgeName = badgeName;
    if (badgeLevel != null) result.badgeLevel = badgeLevel;
    if (sentAtMs != null) result.sentAtMs = sentAtMs;
    return result;
  }

  DouyuDanmakuEvent._();

  factory DouyuDanmakuEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyuDanmakuEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyuDanmakuEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.douyu'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'userName')
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..aOS(5, _omitFieldNames ? '' : 'color')
    ..aI(6, _omitFieldNames ? '' : 'level', fieldType: $pb.PbFieldType.OU3)
    ..aOS(7, _omitFieldNames ? '' : 'badgeName')
    ..aI(8, _omitFieldNames ? '' : 'badgeLevel', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'sentAtMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuDanmakuEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuDanmakuEvent copyWith(void Function(DouyuDanmakuEvent) updates) =>
      super.copyWith((message) => updates(message as DouyuDanmakuEvent))
          as DouyuDanmakuEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyuDanmakuEvent create() => DouyuDanmakuEvent._();
  @$core.override
  DouyuDanmakuEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyuDanmakuEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyuDanmakuEvent>(create);
  static DouyuDanmakuEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userName => $_getSZ(2);
  @$pb.TagNumber(3)
  set userName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get color => $_getSZ(4);
  @$pb.TagNumber(5)
  set color($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get level => $_getIZ(5);
  @$pb.TagNumber(6)
  set level($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearLevel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get badgeName => $_getSZ(6);
  @$pb.TagNumber(7)
  set badgeName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBadgeName() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadgeName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get badgeLevel => $_getIZ(7);
  @$pb.TagNumber(8)
  set badgeLevel($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBadgeLevel() => $_has(7);
  @$pb.TagNumber(8)
  void clearBadgeLevel() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get sentAtMs => $_getI64(8);
  @$pb.TagNumber(9)
  set sentAtMs($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSentAtMs() => $_has(8);
  @$pb.TagNumber(9)
  void clearSentAtMs() => $_clearField(9);
}

class DouyuPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  DouyuPlaybackProviderServiceApi(this._client);

  $async.Future<DouyuResourceResponse> getResource(
          $pb.ClientContext? ctx, GetDouyuResourceRequest request) =>
      _client.invoke<DouyuResourceResponse>(ctx, 'DouyuPlaybackProviderService',
          'GetResource', request, DouyuResourceResponse());
  $async.Future<DouyuSegmentResponse> getSegment(
          $pb.ClientContext? ctx, GetDouyuSegmentRequest request) =>
      _client.invoke<DouyuSegmentResponse>(ctx, 'DouyuPlaybackProviderService',
          'GetSegment', request, DouyuSegmentResponse());
  $async.Future<DouyuDanmakuEvent> watchDanmaku(
          $pb.ClientContext? ctx, WatchDouyuDanmakuRequest request) =>
      _client.invoke<DouyuDanmakuEvent>(ctx, 'DouyuPlaybackProviderService',
          'WatchDanmaku', request, DouyuDanmakuEvent());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
