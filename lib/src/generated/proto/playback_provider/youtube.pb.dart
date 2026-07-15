// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/youtube.proto.

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

class GetYoutubeResourceRequest extends $pb.GeneratedMessage {
  factory GetYoutubeResourceRequest({
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

  GetYoutubeResourceRequest._();

  factory GetYoutubeResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetYoutubeResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetYoutubeResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.youtube'),
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
  GetYoutubeResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetYoutubeResourceRequest copyWith(
          void Function(GetYoutubeResourceRequest) updates) =>
      super.copyWith((message) => updates(message as GetYoutubeResourceRequest))
          as GetYoutubeResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetYoutubeResourceRequest create() => GetYoutubeResourceRequest._();
  @$core.override
  GetYoutubeResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetYoutubeResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetYoutubeResourceRequest>(create);
  static GetYoutubeResourceRequest? _defaultInstance;

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

class YoutubeResourceResponse extends $pb.GeneratedMessage {
  factory YoutubeResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  YoutubeResourceResponse._();

  factory YoutubeResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubeResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubeResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.youtube'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeResourceResponse copyWith(
          void Function(YoutubeResourceResponse) updates) =>
      super.copyWith((message) => updates(message as YoutubeResourceResponse))
          as YoutubeResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubeResourceResponse create() => YoutubeResourceResponse._();
  @$core.override
  YoutubeResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubeResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<YoutubeResourceResponse>(create);
  static YoutubeResourceResponse? _defaultInstance;

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

class GetYoutubeSegmentRequest extends $pb.GeneratedMessage {
  factory GetYoutubeSegmentRequest({
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

  GetYoutubeSegmentRequest._();

  factory GetYoutubeSegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetYoutubeSegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetYoutubeSegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.youtube'),
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
  GetYoutubeSegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetYoutubeSegmentRequest copyWith(
          void Function(GetYoutubeSegmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetYoutubeSegmentRequest))
          as GetYoutubeSegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetYoutubeSegmentRequest create() => GetYoutubeSegmentRequest._();
  @$core.override
  GetYoutubeSegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetYoutubeSegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetYoutubeSegmentRequest>(create);
  static GetYoutubeSegmentRequest? _defaultInstance;

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

class YoutubeSegmentResponse extends $pb.GeneratedMessage {
  factory YoutubeSegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  YoutubeSegmentResponse._();

  factory YoutubeSegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubeSegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubeSegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.youtube'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeSegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeSegmentResponse copyWith(
          void Function(YoutubeSegmentResponse) updates) =>
      super.copyWith((message) => updates(message as YoutubeSegmentResponse))
          as YoutubeSegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubeSegmentResponse create() => YoutubeSegmentResponse._();
  @$core.override
  YoutubeSegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubeSegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<YoutubeSegmentResponse>(create);
  static YoutubeSegmentResponse? _defaultInstance;

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

class GetYoutubeSubtitleRequest extends $pb.GeneratedMessage {
  factory GetYoutubeSubtitleRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? subtitleIndex,
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
    if (subtitleIndex != null) result.subtitleIndex = subtitleIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (range != null) result.range = range;
    if (head != null) result.head = head;
    return result;
  }

  GetYoutubeSubtitleRequest._();

  factory GetYoutubeSubtitleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetYoutubeSubtitleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetYoutubeSubtitleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.youtube'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'subtitleIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..aOS(8, _omitFieldNames ? '' : 'range')
    ..aOB(9, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetYoutubeSubtitleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetYoutubeSubtitleRequest copyWith(
          void Function(GetYoutubeSubtitleRequest) updates) =>
      super.copyWith((message) => updates(message as GetYoutubeSubtitleRequest))
          as GetYoutubeSubtitleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetYoutubeSubtitleRequest create() => GetYoutubeSubtitleRequest._();
  @$core.override
  GetYoutubeSubtitleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetYoutubeSubtitleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetYoutubeSubtitleRequest>(create);
  static GetYoutubeSubtitleRequest? _defaultInstance;

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

class YoutubeSubtitleResponse extends $pb.GeneratedMessage {
  factory YoutubeSubtitleResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  YoutubeSubtitleResponse._();

  factory YoutubeSubtitleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubeSubtitleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubeSubtitleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.youtube'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeSubtitleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeSubtitleResponse copyWith(
          void Function(YoutubeSubtitleResponse) updates) =>
      super.copyWith((message) => updates(message as YoutubeSubtitleResponse))
          as YoutubeSubtitleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubeSubtitleResponse create() => YoutubeSubtitleResponse._();
  @$core.override
  YoutubeSubtitleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubeSubtitleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<YoutubeSubtitleResponse>(create);
  static YoutubeSubtitleResponse? _defaultInstance;

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

class YoutubePlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  YoutubePlaybackProviderServiceApi(this._client);

  $async.Future<YoutubeResourceResponse> getResource(
          $pb.ClientContext? ctx, GetYoutubeResourceRequest request) =>
      _client.invoke<YoutubeResourceResponse>(
          ctx,
          'YoutubePlaybackProviderService',
          'GetResource',
          request,
          YoutubeResourceResponse());
  $async.Future<YoutubeSegmentResponse> getSegment(
          $pb.ClientContext? ctx, GetYoutubeSegmentRequest request) =>
      _client.invoke<YoutubeSegmentResponse>(
          ctx,
          'YoutubePlaybackProviderService',
          'GetSegment',
          request,
          YoutubeSegmentResponse());
  $async.Future<YoutubeSubtitleResponse> getSubtitle(
          $pb.ClientContext? ctx, GetYoutubeSubtitleRequest request) =>
      _client.invoke<YoutubeSubtitleResponse>(
          ctx,
          'YoutubePlaybackProviderService',
          'GetSubtitle',
          request,
          YoutubeSubtitleResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
