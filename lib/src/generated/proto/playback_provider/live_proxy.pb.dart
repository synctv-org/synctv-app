// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/live_proxy.proto.

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

class GetLiveProxyFlvStreamRequest extends $pb.GeneratedMessage {
  factory GetLiveProxyFlvStreamRequest({
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

  GetLiveProxyFlvStreamRequest._();

  factory GetLiveProxyFlvStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLiveProxyFlvStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLiveProxyFlvStreamRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'sig')
    ..aOS(3, _omitFieldNames ? '' : 'uid')
    ..aOS(4, _omitFieldNames ? '' : 'rid')
    ..aInt64(5, _omitFieldNames ? '' : 'exp')
    ..aOB(6, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyFlvStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyFlvStreamRequest copyWith(
          void Function(GetLiveProxyFlvStreamRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLiveProxyFlvStreamRequest))
          as GetLiveProxyFlvStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLiveProxyFlvStreamRequest create() =>
      GetLiveProxyFlvStreamRequest._();
  @$core.override
  GetLiveProxyFlvStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLiveProxyFlvStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLiveProxyFlvStreamRequest>(create);
  static GetLiveProxyFlvStreamRequest? _defaultInstance;

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

class LiveProxyFlvStreamResponse extends $pb.GeneratedMessage {
  factory LiveProxyFlvStreamResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  LiveProxyFlvStreamResponse._();

  factory LiveProxyFlvStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveProxyFlvStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveProxyFlvStreamResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyFlvStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyFlvStreamResponse copyWith(
          void Function(LiveProxyFlvStreamResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LiveProxyFlvStreamResponse))
          as LiveProxyFlvStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiveProxyFlvStreamResponse create() => LiveProxyFlvStreamResponse._();
  @$core.override
  LiveProxyFlvStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiveProxyFlvStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveProxyFlvStreamResponse>(create);
  static LiveProxyFlvStreamResponse? _defaultInstance;

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

class GetLiveProxyHlsMasterRequest extends $pb.GeneratedMessage {
  factory GetLiveProxyHlsMasterRequest({
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

  GetLiveProxyHlsMasterRequest._();

  factory GetLiveProxyHlsMasterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLiveProxyHlsMasterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLiveProxyHlsMasterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'sig')
    ..aOS(3, _omitFieldNames ? '' : 'uid')
    ..aOS(4, _omitFieldNames ? '' : 'rid')
    ..aInt64(5, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyHlsMasterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyHlsMasterRequest copyWith(
          void Function(GetLiveProxyHlsMasterRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLiveProxyHlsMasterRequest))
          as GetLiveProxyHlsMasterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLiveProxyHlsMasterRequest create() =>
      GetLiveProxyHlsMasterRequest._();
  @$core.override
  GetLiveProxyHlsMasterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLiveProxyHlsMasterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLiveProxyHlsMasterRequest>(create);
  static GetLiveProxyHlsMasterRequest? _defaultInstance;

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

class LiveProxyHlsMasterResponse extends $pb.GeneratedMessage {
  factory LiveProxyHlsMasterResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  LiveProxyHlsMasterResponse._();

  factory LiveProxyHlsMasterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveProxyHlsMasterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveProxyHlsMasterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyHlsMasterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyHlsMasterResponse copyWith(
          void Function(LiveProxyHlsMasterResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LiveProxyHlsMasterResponse))
          as LiveProxyHlsMasterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiveProxyHlsMasterResponse create() => LiveProxyHlsMasterResponse._();
  @$core.override
  LiveProxyHlsMasterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiveProxyHlsMasterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveProxyHlsMasterResponse>(create);
  static LiveProxyHlsMasterResponse? _defaultInstance;

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

class GetLiveProxyHlsPlaylistRequest extends $pb.GeneratedMessage {
  factory GetLiveProxyHlsPlaylistRequest({
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

  GetLiveProxyHlsPlaylistRequest._();

  factory GetLiveProxyHlsPlaylistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLiveProxyHlsPlaylistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLiveProxyHlsPlaylistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'generationId')
    ..aOS(3, _omitFieldNames ? '' : 'sig')
    ..aOS(4, _omitFieldNames ? '' : 'uid')
    ..aOS(5, _omitFieldNames ? '' : 'rid')
    ..aInt64(6, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyHlsPlaylistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyHlsPlaylistRequest copyWith(
          void Function(GetLiveProxyHlsPlaylistRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLiveProxyHlsPlaylistRequest))
          as GetLiveProxyHlsPlaylistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLiveProxyHlsPlaylistRequest create() =>
      GetLiveProxyHlsPlaylistRequest._();
  @$core.override
  GetLiveProxyHlsPlaylistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLiveProxyHlsPlaylistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLiveProxyHlsPlaylistRequest>(create);
  static GetLiveProxyHlsPlaylistRequest? _defaultInstance;

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

class LiveProxyHlsPlaylistResponse extends $pb.GeneratedMessage {
  factory LiveProxyHlsPlaylistResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  LiveProxyHlsPlaylistResponse._();

  factory LiveProxyHlsPlaylistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveProxyHlsPlaylistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveProxyHlsPlaylistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyHlsPlaylistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyHlsPlaylistResponse copyWith(
          void Function(LiveProxyHlsPlaylistResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LiveProxyHlsPlaylistResponse))
          as LiveProxyHlsPlaylistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiveProxyHlsPlaylistResponse create() =>
      LiveProxyHlsPlaylistResponse._();
  @$core.override
  LiveProxyHlsPlaylistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiveProxyHlsPlaylistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveProxyHlsPlaylistResponse>(create);
  static LiveProxyHlsPlaylistResponse? _defaultInstance;

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

class GetLiveProxyHlsSegmentRequest extends $pb.GeneratedMessage {
  factory GetLiveProxyHlsSegmentRequest({
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

  GetLiveProxyHlsSegmentRequest._();

  factory GetLiveProxyHlsSegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLiveProxyHlsSegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLiveProxyHlsSegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
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
  GetLiveProxyHlsSegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLiveProxyHlsSegmentRequest copyWith(
          void Function(GetLiveProxyHlsSegmentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLiveProxyHlsSegmentRequest))
          as GetLiveProxyHlsSegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLiveProxyHlsSegmentRequest create() =>
      GetLiveProxyHlsSegmentRequest._();
  @$core.override
  GetLiveProxyHlsSegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLiveProxyHlsSegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLiveProxyHlsSegmentRequest>(create);
  static GetLiveProxyHlsSegmentRequest? _defaultInstance;

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

class LiveProxyHlsSegmentResponse extends $pb.GeneratedMessage {
  factory LiveProxyHlsSegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  LiveProxyHlsSegmentResponse._();

  factory LiveProxyHlsSegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveProxyHlsSegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveProxyHlsSegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.live_proxy'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyHlsSegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyHlsSegmentResponse copyWith(
          void Function(LiveProxyHlsSegmentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LiveProxyHlsSegmentResponse))
          as LiveProxyHlsSegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiveProxyHlsSegmentResponse create() =>
      LiveProxyHlsSegmentResponse._();
  @$core.override
  LiveProxyHlsSegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiveProxyHlsSegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveProxyHlsSegmentResponse>(create);
  static LiveProxyHlsSegmentResponse? _defaultInstance;

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

class LiveProxyPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  LiveProxyPlaybackProviderServiceApi(this._client);

  $async.Future<LiveProxyFlvStreamResponse> getFlvStream(
          $pb.ClientContext? ctx, GetLiveProxyFlvStreamRequest request) =>
      _client.invoke<LiveProxyFlvStreamResponse>(
          ctx,
          'LiveProxyPlaybackProviderService',
          'GetFlvStream',
          request,
          LiveProxyFlvStreamResponse());
  $async.Future<LiveProxyHlsMasterResponse> getHlsMaster(
          $pb.ClientContext? ctx, GetLiveProxyHlsMasterRequest request) =>
      _client.invoke<LiveProxyHlsMasterResponse>(
          ctx,
          'LiveProxyPlaybackProviderService',
          'GetHlsMaster',
          request,
          LiveProxyHlsMasterResponse());
  $async.Future<LiveProxyHlsPlaylistResponse> getHlsPlaylist(
          $pb.ClientContext? ctx, GetLiveProxyHlsPlaylistRequest request) =>
      _client.invoke<LiveProxyHlsPlaylistResponse>(
          ctx,
          'LiveProxyPlaybackProviderService',
          'GetHlsPlaylist',
          request,
          LiveProxyHlsPlaylistResponse());
  $async.Future<LiveProxyHlsSegmentResponse> getHlsSegment(
          $pb.ClientContext? ctx, GetLiveProxyHlsSegmentRequest request) =>
      _client.invoke<LiveProxyHlsSegmentResponse>(
          ctx,
          'LiveProxyPlaybackProviderService',
          'GetHlsSegment',
          request,
          LiveProxyHlsSegmentResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
