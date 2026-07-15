// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/fnos.proto.

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

class GetFnosResourceRequest extends $pb.GeneratedMessage {
  factory GetFnosResourceRequest({
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

  GetFnosResourceRequest._();

  factory GetFnosResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFnosResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFnosResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
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
  GetFnosResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFnosResourceRequest copyWith(
          void Function(GetFnosResourceRequest) updates) =>
      super.copyWith((message) => updates(message as GetFnosResourceRequest))
          as GetFnosResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFnosResourceRequest create() => GetFnosResourceRequest._();
  @$core.override
  GetFnosResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFnosResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFnosResourceRequest>(create);
  static GetFnosResourceRequest? _defaultInstance;

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

class FnosResourceResponse extends $pb.GeneratedMessage {
  factory FnosResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  FnosResourceResponse._();

  factory FnosResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosResourceResponse copyWith(void Function(FnosResourceResponse) updates) =>
      super.copyWith((message) => updates(message as FnosResourceResponse))
          as FnosResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosResourceResponse create() => FnosResourceResponse._();
  @$core.override
  FnosResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosResourceResponse>(create);
  static FnosResourceResponse? _defaultInstance;

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

class GetFnosSegmentRequest extends $pb.GeneratedMessage {
  factory GetFnosSegmentRequest({
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

  GetFnosSegmentRequest._();

  factory GetFnosSegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFnosSegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFnosSegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
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
  GetFnosSegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFnosSegmentRequest copyWith(
          void Function(GetFnosSegmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetFnosSegmentRequest))
          as GetFnosSegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFnosSegmentRequest create() => GetFnosSegmentRequest._();
  @$core.override
  GetFnosSegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFnosSegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFnosSegmentRequest>(create);
  static GetFnosSegmentRequest? _defaultInstance;

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

class FnosSegmentResponse extends $pb.GeneratedMessage {
  factory FnosSegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  FnosSegmentResponse._();

  factory FnosSegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosSegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosSegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosSegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosSegmentResponse copyWith(void Function(FnosSegmentResponse) updates) =>
      super.copyWith((message) => updates(message as FnosSegmentResponse))
          as FnosSegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosSegmentResponse create() => FnosSegmentResponse._();
  @$core.override
  FnosSegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosSegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosSegmentResponse>(create);
  static FnosSegmentResponse? _defaultInstance;

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

class GetFnosSubtitleRequest extends $pb.GeneratedMessage {
  factory GetFnosSubtitleRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? subtitleIndex,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (modeName != null) result.modeName = modeName;
    if (subtitleIndex != null) result.subtitleIndex = subtitleIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  GetFnosSubtitleRequest._();

  factory GetFnosSubtitleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFnosSubtitleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFnosSubtitleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'subtitleIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFnosSubtitleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFnosSubtitleRequest copyWith(
          void Function(GetFnosSubtitleRequest) updates) =>
      super.copyWith((message) => updates(message as GetFnosSubtitleRequest))
          as GetFnosSubtitleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFnosSubtitleRequest create() => GetFnosSubtitleRequest._();
  @$core.override
  GetFnosSubtitleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFnosSubtitleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFnosSubtitleRequest>(create);
  static GetFnosSubtitleRequest? _defaultInstance;

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
  $core.int get subtitleIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set subtitleIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitleIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitleIndex() => $_clearField(3);

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

class FnosSubtitleResponse extends $pb.GeneratedMessage {
  factory FnosSubtitleResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  FnosSubtitleResponse._();

  factory FnosSubtitleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosSubtitleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosSubtitleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosSubtitleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosSubtitleResponse copyWith(void Function(FnosSubtitleResponse) updates) =>
      super.copyWith((message) => updates(message as FnosSubtitleResponse))
          as FnosSubtitleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosSubtitleResponse create() => FnosSubtitleResponse._();
  @$core.override
  FnosSubtitleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosSubtitleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosSubtitleResponse>(create);
  static FnosSubtitleResponse? _defaultInstance;

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

class GetFnosThumbnailRequest extends $pb.GeneratedMessage {
  factory GetFnosThumbnailRequest({
    $core.String? version,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  GetFnosThumbnailRequest._();

  factory GetFnosThumbnailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFnosThumbnailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFnosThumbnailRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'sig')
    ..aOS(3, _omitFieldNames ? '' : 'uid')
    ..aOS(4, _omitFieldNames ? '' : 'rid')
    ..aInt64(5, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFnosThumbnailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFnosThumbnailRequest copyWith(
          void Function(GetFnosThumbnailRequest) updates) =>
      super.copyWith((message) => updates(message as GetFnosThumbnailRequest))
          as GetFnosThumbnailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFnosThumbnailRequest create() => GetFnosThumbnailRequest._();
  @$core.override
  GetFnosThumbnailRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFnosThumbnailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFnosThumbnailRequest>(create);
  static GetFnosThumbnailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sig => $_getSZ(1);
  @$pb.TagNumber(2)
  set sig($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSig() => $_has(1);
  @$pb.TagNumber(2)
  void clearSig() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uid => $_getSZ(2);
  @$pb.TagNumber(3)
  set uid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get rid => $_getSZ(3);
  @$pb.TagNumber(4)
  set rid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRid() => $_has(3);
  @$pb.TagNumber(4)
  void clearRid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get exp => $_getI64(4);
  @$pb.TagNumber(5)
  set exp($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExp() => $_has(4);
  @$pb.TagNumber(5)
  void clearExp() => $_clearField(5);
}

class FnosThumbnailResponse extends $pb.GeneratedMessage {
  factory FnosThumbnailResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  FnosThumbnailResponse._();

  factory FnosThumbnailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosThumbnailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosThumbnailResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.fnos'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosThumbnailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosThumbnailResponse copyWith(
          void Function(FnosThumbnailResponse) updates) =>
      super.copyWith((message) => updates(message as FnosThumbnailResponse))
          as FnosThumbnailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosThumbnailResponse create() => FnosThumbnailResponse._();
  @$core.override
  FnosThumbnailResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosThumbnailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosThumbnailResponse>(create);
  static FnosThumbnailResponse? _defaultInstance;

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

class FnosPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  FnosPlaybackProviderServiceApi(this._client);

  $async.Future<FnosResourceResponse> getResource(
          $pb.ClientContext? ctx, GetFnosResourceRequest request) =>
      _client.invoke<FnosResourceResponse>(ctx, 'FnosPlaybackProviderService',
          'GetResource', request, FnosResourceResponse());
  $async.Future<FnosSegmentResponse> getSegment(
          $pb.ClientContext? ctx, GetFnosSegmentRequest request) =>
      _client.invoke<FnosSegmentResponse>(ctx, 'FnosPlaybackProviderService',
          'GetSegment', request, FnosSegmentResponse());
  $async.Future<FnosSubtitleResponse> getSubtitle(
          $pb.ClientContext? ctx, GetFnosSubtitleRequest request) =>
      _client.invoke<FnosSubtitleResponse>(ctx, 'FnosPlaybackProviderService',
          'GetSubtitle', request, FnosSubtitleResponse());
  $async.Future<FnosThumbnailResponse> getThumbnail(
          $pb.ClientContext? ctx, GetFnosThumbnailRequest request) =>
      _client.invoke<FnosThumbnailResponse>(ctx, 'FnosPlaybackProviderService',
          'GetThumbnail', request, FnosThumbnailResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
