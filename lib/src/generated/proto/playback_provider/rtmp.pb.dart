// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/rtmp.proto.

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

class GetRtmpFlvStreamRequest extends $pb.GeneratedMessage {
  factory GetRtmpFlvStreamRequest({
    $core.String? version,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
    $core.bool? head,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (head != null) result.head = head;
    return result;
  }

  GetRtmpFlvStreamRequest._();

  factory GetRtmpFlvStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRtmpFlvStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRtmpFlvStreamRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'sig')
    ..aOS(3, _omitFieldNames ? '' : 'uid')
    ..aOS(4, _omitFieldNames ? '' : 'rid')
    ..aInt64(5, _omitFieldNames ? '' : 'exp')
    ..aOB(6, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpFlvStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpFlvStreamRequest copyWith(
          void Function(GetRtmpFlvStreamRequest) updates) =>
      super.copyWith((message) => updates(message as GetRtmpFlvStreamRequest))
          as GetRtmpFlvStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRtmpFlvStreamRequest create() => GetRtmpFlvStreamRequest._();
  @$core.override
  GetRtmpFlvStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRtmpFlvStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRtmpFlvStreamRequest>(create);
  static GetRtmpFlvStreamRequest? _defaultInstance;

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

  @$pb.TagNumber(6)
  $core.bool get head => $_getBF(5);
  @$pb.TagNumber(6)
  set head($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHead() => $_has(5);
  @$pb.TagNumber(6)
  void clearHead() => $_clearField(6);
}

class RtmpFlvStreamResponse extends $pb.GeneratedMessage {
  factory RtmpFlvStreamResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  RtmpFlvStreamResponse._();

  factory RtmpFlvStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpFlvStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpFlvStreamResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpFlvStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpFlvStreamResponse copyWith(
          void Function(RtmpFlvStreamResponse) updates) =>
      super.copyWith((message) => updates(message as RtmpFlvStreamResponse))
          as RtmpFlvStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpFlvStreamResponse create() => RtmpFlvStreamResponse._();
  @$core.override
  RtmpFlvStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpFlvStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpFlvStreamResponse>(create);
  static RtmpFlvStreamResponse? _defaultInstance;

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

class GetRtmpHlsMasterRequest extends $pb.GeneratedMessage {
  factory GetRtmpHlsMasterRequest({
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

  GetRtmpHlsMasterRequest._();

  factory GetRtmpHlsMasterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRtmpHlsMasterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRtmpHlsMasterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'sig')
    ..aOS(3, _omitFieldNames ? '' : 'uid')
    ..aOS(4, _omitFieldNames ? '' : 'rid')
    ..aInt64(5, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpHlsMasterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpHlsMasterRequest copyWith(
          void Function(GetRtmpHlsMasterRequest) updates) =>
      super.copyWith((message) => updates(message as GetRtmpHlsMasterRequest))
          as GetRtmpHlsMasterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRtmpHlsMasterRequest create() => GetRtmpHlsMasterRequest._();
  @$core.override
  GetRtmpHlsMasterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRtmpHlsMasterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRtmpHlsMasterRequest>(create);
  static GetRtmpHlsMasterRequest? _defaultInstance;

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

class RtmpHlsMasterResponse extends $pb.GeneratedMessage {
  factory RtmpHlsMasterResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  RtmpHlsMasterResponse._();

  factory RtmpHlsMasterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpHlsMasterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpHlsMasterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpHlsMasterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpHlsMasterResponse copyWith(
          void Function(RtmpHlsMasterResponse) updates) =>
      super.copyWith((message) => updates(message as RtmpHlsMasterResponse))
          as RtmpHlsMasterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpHlsMasterResponse create() => RtmpHlsMasterResponse._();
  @$core.override
  RtmpHlsMasterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpHlsMasterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpHlsMasterResponse>(create);
  static RtmpHlsMasterResponse? _defaultInstance;

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

class GetRtmpHlsPlaylistRequest extends $pb.GeneratedMessage {
  factory GetRtmpHlsPlaylistRequest({
    $core.String? version,
    $core.String? generationId,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (generationId != null) result.generationId = generationId;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  GetRtmpHlsPlaylistRequest._();

  factory GetRtmpHlsPlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRtmpHlsPlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRtmpHlsPlaylistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'generationId')
    ..aOS(3, _omitFieldNames ? '' : 'sig')
    ..aOS(4, _omitFieldNames ? '' : 'uid')
    ..aOS(5, _omitFieldNames ? '' : 'rid')
    ..aInt64(6, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpHlsPlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpHlsPlaylistRequest copyWith(
          void Function(GetRtmpHlsPlaylistRequest) updates) =>
      super.copyWith((message) => updates(message as GetRtmpHlsPlaylistRequest))
          as GetRtmpHlsPlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRtmpHlsPlaylistRequest create() => GetRtmpHlsPlaylistRequest._();
  @$core.override
  GetRtmpHlsPlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRtmpHlsPlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRtmpHlsPlaylistRequest>(create);
  static GetRtmpHlsPlaylistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get generationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set generationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGenerationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGenerationId() => $_clearField(2);

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
}

class RtmpHlsPlaylistResponse extends $pb.GeneratedMessage {
  factory RtmpHlsPlaylistResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  RtmpHlsPlaylistResponse._();

  factory RtmpHlsPlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpHlsPlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpHlsPlaylistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpHlsPlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpHlsPlaylistResponse copyWith(
          void Function(RtmpHlsPlaylistResponse) updates) =>
      super.copyWith((message) => updates(message as RtmpHlsPlaylistResponse))
          as RtmpHlsPlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpHlsPlaylistResponse create() => RtmpHlsPlaylistResponse._();
  @$core.override
  RtmpHlsPlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpHlsPlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpHlsPlaylistResponse>(create);
  static RtmpHlsPlaylistResponse? _defaultInstance;

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

class GetRtmpHlsSegmentRequest extends $pb.GeneratedMessage {
  factory GetRtmpHlsSegmentRequest({
    $core.String? version,
    $core.String? generationId,
    $core.String? segmentName,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
    $core.String? range,
    $core.bool? head,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (generationId != null) result.generationId = generationId;
    if (segmentName != null) result.segmentName = segmentName;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (range != null) result.range = range;
    if (head != null) result.head = head;
    return result;
  }

  GetRtmpHlsSegmentRequest._();

  factory GetRtmpHlsSegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRtmpHlsSegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRtmpHlsSegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'generationId')
    ..aOS(3, _omitFieldNames ? '' : 'segmentName')
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..aOS(8, _omitFieldNames ? '' : 'range')
    ..aOB(9, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpHlsSegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRtmpHlsSegmentRequest copyWith(
          void Function(GetRtmpHlsSegmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetRtmpHlsSegmentRequest))
          as GetRtmpHlsSegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRtmpHlsSegmentRequest create() => GetRtmpHlsSegmentRequest._();
  @$core.override
  GetRtmpHlsSegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRtmpHlsSegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRtmpHlsSegmentRequest>(create);
  static GetRtmpHlsSegmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get generationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set generationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGenerationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGenerationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get segmentName => $_getSZ(2);
  @$pb.TagNumber(3)
  set segmentName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSegmentName() => $_has(2);
  @$pb.TagNumber(3)
  void clearSegmentName() => $_clearField(3);

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

class RtmpHlsSegmentResponse extends $pb.GeneratedMessage {
  factory RtmpHlsSegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  RtmpHlsSegmentResponse._();

  factory RtmpHlsSegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpHlsSegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpHlsSegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.rtmp'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpHlsSegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpHlsSegmentResponse copyWith(
          void Function(RtmpHlsSegmentResponse) updates) =>
      super.copyWith((message) => updates(message as RtmpHlsSegmentResponse))
          as RtmpHlsSegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpHlsSegmentResponse create() => RtmpHlsSegmentResponse._();
  @$core.override
  RtmpHlsSegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpHlsSegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpHlsSegmentResponse>(create);
  static RtmpHlsSegmentResponse? _defaultInstance;

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

class RtmpPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  RtmpPlaybackProviderServiceApi(this._client);

  $async.Future<RtmpFlvStreamResponse> getFlvStream(
          $pb.ClientContext? ctx, GetRtmpFlvStreamRequest request) =>
      _client.invoke<RtmpFlvStreamResponse>(ctx, 'RtmpPlaybackProviderService',
          'GetFlvStream', request, RtmpFlvStreamResponse());
  $async.Future<RtmpHlsMasterResponse> getHlsMaster(
          $pb.ClientContext? ctx, GetRtmpHlsMasterRequest request) =>
      _client.invoke<RtmpHlsMasterResponse>(ctx, 'RtmpPlaybackProviderService',
          'GetHlsMaster', request, RtmpHlsMasterResponse());
  $async.Future<RtmpHlsPlaylistResponse> getHlsPlaylist(
          $pb.ClientContext? ctx, GetRtmpHlsPlaylistRequest request) =>
      _client.invoke<RtmpHlsPlaylistResponse>(
          ctx,
          'RtmpPlaybackProviderService',
          'GetHlsPlaylist',
          request,
          RtmpHlsPlaylistResponse());
  $async.Future<RtmpHlsSegmentResponse> getHlsSegment(
          $pb.ClientContext? ctx, GetRtmpHlsSegmentRequest request) =>
      _client.invoke<RtmpHlsSegmentResponse>(ctx, 'RtmpPlaybackProviderService',
          'GetHlsSegment', request, RtmpHlsSegmentResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
