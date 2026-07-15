// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/twitch.proto.

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

class GetTwitchResourceRequest extends $pb.GeneratedMessage {
  factory GetTwitchResourceRequest({
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

  GetTwitchResourceRequest._();

  factory GetTwitchResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTwitchResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTwitchResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.twitch'),
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
  GetTwitchResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTwitchResourceRequest copyWith(
          void Function(GetTwitchResourceRequest) updates) =>
      super.copyWith((message) => updates(message as GetTwitchResourceRequest))
          as GetTwitchResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTwitchResourceRequest create() => GetTwitchResourceRequest._();
  @$core.override
  GetTwitchResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTwitchResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTwitchResourceRequest>(create);
  static GetTwitchResourceRequest? _defaultInstance;

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

class TwitchResourceResponse extends $pb.GeneratedMessage {
  factory TwitchResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  TwitchResourceResponse._();

  factory TwitchResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.twitch'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchResourceResponse copyWith(
          void Function(TwitchResourceResponse) updates) =>
      super.copyWith((message) => updates(message as TwitchResourceResponse))
          as TwitchResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchResourceResponse create() => TwitchResourceResponse._();
  @$core.override
  TwitchResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchResourceResponse>(create);
  static TwitchResourceResponse? _defaultInstance;

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

class GetTwitchSegmentRequest extends $pb.GeneratedMessage {
  factory GetTwitchSegmentRequest({
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

  GetTwitchSegmentRequest._();

  factory GetTwitchSegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTwitchSegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTwitchSegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.twitch'),
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
  GetTwitchSegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTwitchSegmentRequest copyWith(
          void Function(GetTwitchSegmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetTwitchSegmentRequest))
          as GetTwitchSegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTwitchSegmentRequest create() => GetTwitchSegmentRequest._();
  @$core.override
  GetTwitchSegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTwitchSegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTwitchSegmentRequest>(create);
  static GetTwitchSegmentRequest? _defaultInstance;

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

class TwitchSegmentResponse extends $pb.GeneratedMessage {
  factory TwitchSegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  TwitchSegmentResponse._();

  factory TwitchSegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchSegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchSegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.twitch'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchSegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchSegmentResponse copyWith(
          void Function(TwitchSegmentResponse) updates) =>
      super.copyWith((message) => updates(message as TwitchSegmentResponse))
          as TwitchSegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchSegmentResponse create() => TwitchSegmentResponse._();
  @$core.override
  TwitchSegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchSegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchSegmentResponse>(create);
  static TwitchSegmentResponse? _defaultInstance;

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

class WatchTwitchChatRequest extends $pb.GeneratedMessage {
  factory WatchTwitchChatRequest({
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

  WatchTwitchChatRequest._();

  factory WatchTwitchChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchTwitchChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchTwitchChatRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.twitch'),
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
  WatchTwitchChatRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchTwitchChatRequest copyWith(
          void Function(WatchTwitchChatRequest) updates) =>
      super.copyWith((message) => updates(message as WatchTwitchChatRequest))
          as WatchTwitchChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchTwitchChatRequest create() => WatchTwitchChatRequest._();
  @$core.override
  WatchTwitchChatRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchTwitchChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchTwitchChatRequest>(create);
  static WatchTwitchChatRequest? _defaultInstance;

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

class TwitchChatEvent extends $pb.GeneratedMessage {
  factory TwitchChatEvent({
    $core.String? id,
    $core.String? userName,
    $core.String? text,
    $core.String? color,
    $core.Iterable<$core.String>? badges,
    $fixnum.Int64? sentAtMs,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (userName != null) result.userName = userName;
    if (text != null) result.text = text;
    if (color != null) result.color = color;
    if (badges != null) result.badges.addAll(badges);
    if (sentAtMs != null) result.sentAtMs = sentAtMs;
    return result;
  }

  TwitchChatEvent._();

  factory TwitchChatEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchChatEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchChatEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.twitch'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'userName')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'color')
    ..pPS(5, _omitFieldNames ? '' : 'badges')
    ..a<$fixnum.Int64>(
        6, _omitFieldNames ? '' : 'sentAtMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchChatEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchChatEvent copyWith(void Function(TwitchChatEvent) updates) =>
      super.copyWith((message) => updates(message as TwitchChatEvent))
          as TwitchChatEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchChatEvent create() => TwitchChatEvent._();
  @$core.override
  TwitchChatEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchChatEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchChatEvent>(create);
  static TwitchChatEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userName => $_getSZ(1);
  @$pb.TagNumber(2)
  set userName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get badges => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sentAtMs => $_getI64(5);
  @$pb.TagNumber(6)
  set sentAtMs($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSentAtMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearSentAtMs() => $_clearField(6);
}

class TwitchPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  TwitchPlaybackProviderServiceApi(this._client);

  $async.Future<TwitchResourceResponse> getResource(
          $pb.ClientContext? ctx, GetTwitchResourceRequest request) =>
      _client.invoke<TwitchResourceResponse>(
          ctx,
          'TwitchPlaybackProviderService',
          'GetResource',
          request,
          TwitchResourceResponse());
  $async.Future<TwitchSegmentResponse> getSegment(
          $pb.ClientContext? ctx, GetTwitchSegmentRequest request) =>
      _client.invoke<TwitchSegmentResponse>(
          ctx,
          'TwitchPlaybackProviderService',
          'GetSegment',
          request,
          TwitchSegmentResponse());
  $async.Future<TwitchChatEvent> watchChat(
          $pb.ClientContext? ctx, WatchTwitchChatRequest request) =>
      _client.invoke<TwitchChatEvent>(ctx, 'TwitchPlaybackProviderService',
          'WatchChat', request, TwitchChatEvent());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
