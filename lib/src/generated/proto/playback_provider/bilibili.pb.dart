// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/bilibili.proto.

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

import 'bilibili.pbenum.dart';
import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'bilibili.pbenum.dart';

class GetBilibiliMediaStreamRequest extends $pb.GeneratedMessage {
  factory GetBilibiliMediaStreamRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? urlIndex,
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
    if (urlIndex != null) result.urlIndex = urlIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (range != null) result.range = range;
    if (head != null) result.head = head;
    return result;
  }

  GetBilibiliMediaStreamRequest._();

  factory GetBilibiliMediaStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliMediaStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliMediaStreamRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'urlIndex', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..aOS(8, _omitFieldNames ? '' : 'range')
    ..aOB(9, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliMediaStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliMediaStreamRequest copyWith(
          void Function(GetBilibiliMediaStreamRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliMediaStreamRequest))
          as GetBilibiliMediaStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliMediaStreamRequest create() =>
      GetBilibiliMediaStreamRequest._();
  @$core.override
  GetBilibiliMediaStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliMediaStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliMediaStreamRequest>(create);
  static GetBilibiliMediaStreamRequest? _defaultInstance;

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
  $core.int get urlIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set urlIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrlIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrlIndex() => $_clearField(3);

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

class BilibiliMediaStreamResponse extends $pb.GeneratedMessage {
  factory BilibiliMediaStreamResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliMediaStreamResponse._();

  factory BilibiliMediaStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliMediaStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliMediaStreamResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliMediaStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliMediaStreamResponse copyWith(
          void Function(BilibiliMediaStreamResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliMediaStreamResponse))
          as BilibiliMediaStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliMediaStreamResponse create() =>
      BilibiliMediaStreamResponse._();
  @$core.override
  BilibiliMediaStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliMediaStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliMediaStreamResponse>(create);
  static BilibiliMediaStreamResponse? _defaultInstance;

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

class GetBilibiliHlsManifestRequest extends $pb.GeneratedMessage {
  factory GetBilibiliHlsManifestRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? urlIndex,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (modeName != null) result.modeName = modeName;
    if (urlIndex != null) result.urlIndex = urlIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  GetBilibiliHlsManifestRequest._();

  factory GetBilibiliHlsManifestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliHlsManifestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliHlsManifestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'urlIndex', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliHlsManifestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliHlsManifestRequest copyWith(
          void Function(GetBilibiliHlsManifestRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliHlsManifestRequest))
          as GetBilibiliHlsManifestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliHlsManifestRequest create() =>
      GetBilibiliHlsManifestRequest._();
  @$core.override
  GetBilibiliHlsManifestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliHlsManifestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliHlsManifestRequest>(create);
  static GetBilibiliHlsManifestRequest? _defaultInstance;

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
  $core.int get urlIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set urlIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrlIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrlIndex() => $_clearField(3);

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

class BilibiliHlsManifestResponse extends $pb.GeneratedMessage {
  factory BilibiliHlsManifestResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliHlsManifestResponse._();

  factory BilibiliHlsManifestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliHlsManifestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliHlsManifestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliHlsManifestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliHlsManifestResponse copyWith(
          void Function(BilibiliHlsManifestResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliHlsManifestResponse))
          as BilibiliHlsManifestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliHlsManifestResponse create() =>
      BilibiliHlsManifestResponse._();
  @$core.override
  BilibiliHlsManifestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliHlsManifestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliHlsManifestResponse>(create);
  static BilibiliHlsManifestResponse? _defaultInstance;

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

class GetBilibiliHlsResourceRequest extends $pb.GeneratedMessage {
  factory GetBilibiliHlsResourceRequest({
    $core.String? version,
    $core.String? targetUrl,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
    $core.String? range,
    $core.bool? head,
    $core.String? modeName,
    $core.int? mediaIndex,
    BilibiliHlsResourceKind? resourceKind,
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
    if (modeName != null) result.modeName = modeName;
    if (mediaIndex != null) result.mediaIndex = mediaIndex;
    if (resourceKind != null) result.resourceKind = resourceKind;
    return result;
  }

  GetBilibiliHlsResourceRequest._();

  factory GetBilibiliHlsResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliHlsResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliHlsResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'targetUrl')
    ..aOS(3, _omitFieldNames ? '' : 'sig')
    ..aOS(4, _omitFieldNames ? '' : 'uid')
    ..aOS(5, _omitFieldNames ? '' : 'rid')
    ..aInt64(6, _omitFieldNames ? '' : 'exp')
    ..aOS(7, _omitFieldNames ? '' : 'range')
    ..aOB(8, _omitFieldNames ? '' : 'head')
    ..aOS(9, _omitFieldNames ? '' : 'modeName')
    ..aI(10, _omitFieldNames ? '' : 'mediaIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<BilibiliHlsResourceKind>(11, _omitFieldNames ? '' : 'resourceKind',
        enumValues: BilibiliHlsResourceKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliHlsResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliHlsResourceRequest copyWith(
          void Function(GetBilibiliHlsResourceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliHlsResourceRequest))
          as GetBilibiliHlsResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliHlsResourceRequest create() =>
      GetBilibiliHlsResourceRequest._();
  @$core.override
  GetBilibiliHlsResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliHlsResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliHlsResourceRequest>(create);
  static GetBilibiliHlsResourceRequest? _defaultInstance;

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

  @$pb.TagNumber(9)
  $core.String get modeName => $_getSZ(8);
  @$pb.TagNumber(9)
  set modeName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasModeName() => $_has(8);
  @$pb.TagNumber(9)
  void clearModeName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get mediaIndex => $_getIZ(9);
  @$pb.TagNumber(10)
  set mediaIndex($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMediaIndex() => $_has(9);
  @$pb.TagNumber(10)
  void clearMediaIndex() => $_clearField(10);

  @$pb.TagNumber(11)
  BilibiliHlsResourceKind get resourceKind => $_getN(10);
  @$pb.TagNumber(11)
  set resourceKind(BilibiliHlsResourceKind value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasResourceKind() => $_has(10);
  @$pb.TagNumber(11)
  void clearResourceKind() => $_clearField(11);
}

class BilibiliHlsResourceResponse extends $pb.GeneratedMessage {
  factory BilibiliHlsResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliHlsResourceResponse._();

  factory BilibiliHlsResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliHlsResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliHlsResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliHlsResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliHlsResourceResponse copyWith(
          void Function(BilibiliHlsResourceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliHlsResourceResponse))
          as BilibiliHlsResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliHlsResourceResponse create() =>
      BilibiliHlsResourceResponse._();
  @$core.override
  BilibiliHlsResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliHlsResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliHlsResourceResponse>(create);
  static BilibiliHlsResourceResponse? _defaultInstance;

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

class GetBilibiliDashManifestRequest extends $pb.GeneratedMessage {
  factory GetBilibiliDashManifestRequest({
    $core.String? version,
    $core.String? modeName,
    BilibiliDashManifestMode? mode,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (modeName != null) result.modeName = modeName;
    if (mode != null) result.mode = mode;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  GetBilibiliDashManifestRequest._();

  factory GetBilibiliDashManifestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliDashManifestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliDashManifestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aE<BilibiliDashManifestMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: BilibiliDashManifestMode.values)
    ..aOS(4, _omitFieldNames ? '' : 'sig')
    ..aOS(5, _omitFieldNames ? '' : 'uid')
    ..aOS(6, _omitFieldNames ? '' : 'rid')
    ..aInt64(7, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliDashManifestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliDashManifestRequest copyWith(
          void Function(GetBilibiliDashManifestRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliDashManifestRequest))
          as GetBilibiliDashManifestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliDashManifestRequest create() =>
      GetBilibiliDashManifestRequest._();
  @$core.override
  GetBilibiliDashManifestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliDashManifestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliDashManifestRequest>(create);
  static GetBilibiliDashManifestRequest? _defaultInstance;

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
  BilibiliDashManifestMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(BilibiliDashManifestMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

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

class BilibiliDashManifestResponse extends $pb.GeneratedMessage {
  factory BilibiliDashManifestResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliDashManifestResponse._();

  factory BilibiliDashManifestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliDashManifestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliDashManifestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliDashManifestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliDashManifestResponse copyWith(
          void Function(BilibiliDashManifestResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliDashManifestResponse))
          as BilibiliDashManifestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliDashManifestResponse create() =>
      BilibiliDashManifestResponse._();
  @$core.override
  BilibiliDashManifestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliDashManifestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliDashManifestResponse>(create);
  static BilibiliDashManifestResponse? _defaultInstance;

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

class GetBilibiliDashResourceRequest extends $pb.GeneratedMessage {
  factory GetBilibiliDashResourceRequest({
    $core.String? version,
    $core.String? modeName,
    $core.String? scopeUrl,
    $core.String? resourcePath,
    $core.String? resourceQuery,
    BilibiliDashResourceKind? resourceKind,
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
    if (scopeUrl != null) result.scopeUrl = scopeUrl;
    if (resourcePath != null) result.resourcePath = resourcePath;
    if (resourceQuery != null) result.resourceQuery = resourceQuery;
    if (resourceKind != null) result.resourceKind = resourceKind;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    if (range != null) result.range = range;
    if (head != null) result.head = head;
    return result;
  }

  GetBilibiliDashResourceRequest._();

  factory GetBilibiliDashResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliDashResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliDashResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aOS(3, _omitFieldNames ? '' : 'scopeUrl')
    ..aOS(4, _omitFieldNames ? '' : 'resourcePath')
    ..aOS(5, _omitFieldNames ? '' : 'resourceQuery')
    ..aE<BilibiliDashResourceKind>(6, _omitFieldNames ? '' : 'resourceKind',
        enumValues: BilibiliDashResourceKind.values)
    ..aOS(7, _omitFieldNames ? '' : 'sig')
    ..aOS(8, _omitFieldNames ? '' : 'uid')
    ..aOS(9, _omitFieldNames ? '' : 'rid')
    ..aInt64(10, _omitFieldNames ? '' : 'exp')
    ..aOS(11, _omitFieldNames ? '' : 'range')
    ..aOB(12, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliDashResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliDashResourceRequest copyWith(
          void Function(GetBilibiliDashResourceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliDashResourceRequest))
          as GetBilibiliDashResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliDashResourceRequest create() =>
      GetBilibiliDashResourceRequest._();
  @$core.override
  GetBilibiliDashResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliDashResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliDashResourceRequest>(create);
  static GetBilibiliDashResourceRequest? _defaultInstance;

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
  $core.String get scopeUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get resourcePath => $_getSZ(3);
  @$pb.TagNumber(4)
  set resourcePath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResourcePath() => $_has(3);
  @$pb.TagNumber(4)
  void clearResourcePath() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get resourceQuery => $_getSZ(4);
  @$pb.TagNumber(5)
  set resourceQuery($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResourceQuery() => $_has(4);
  @$pb.TagNumber(5)
  void clearResourceQuery() => $_clearField(5);

  @$pb.TagNumber(6)
  BilibiliDashResourceKind get resourceKind => $_getN(5);
  @$pb.TagNumber(6)
  set resourceKind(BilibiliDashResourceKind value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasResourceKind() => $_has(5);
  @$pb.TagNumber(6)
  void clearResourceKind() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sig => $_getSZ(6);
  @$pb.TagNumber(7)
  set sig($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSig() => $_has(6);
  @$pb.TagNumber(7)
  void clearSig() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get uid => $_getSZ(7);
  @$pb.TagNumber(8)
  set uid($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUid() => $_has(7);
  @$pb.TagNumber(8)
  void clearUid() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get rid => $_getSZ(8);
  @$pb.TagNumber(9)
  set rid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRid() => $_has(8);
  @$pb.TagNumber(9)
  void clearRid() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get exp => $_getI64(9);
  @$pb.TagNumber(10)
  set exp($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExp() => $_has(9);
  @$pb.TagNumber(10)
  void clearExp() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get range => $_getSZ(10);
  @$pb.TagNumber(11)
  set range($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRange() => $_has(10);
  @$pb.TagNumber(11)
  void clearRange() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get head => $_getBF(11);
  @$pb.TagNumber(12)
  set head($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasHead() => $_has(11);
  @$pb.TagNumber(12)
  void clearHead() => $_clearField(12);
}

class BilibiliDashResourceResponse extends $pb.GeneratedMessage {
  factory BilibiliDashResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliDashResourceResponse._();

  factory BilibiliDashResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliDashResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliDashResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliDashResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliDashResourceResponse copyWith(
          void Function(BilibiliDashResourceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliDashResourceResponse))
          as BilibiliDashResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliDashResourceResponse create() =>
      BilibiliDashResourceResponse._();
  @$core.override
  BilibiliDashResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliDashResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliDashResourceResponse>(create);
  static BilibiliDashResourceResponse? _defaultInstance;

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

class GetBilibiliSubtitleRequest extends $pb.GeneratedMessage {
  factory GetBilibiliSubtitleRequest({
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

  GetBilibiliSubtitleRequest._();

  factory GetBilibiliSubtitleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliSubtitleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliSubtitleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
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
  GetBilibiliSubtitleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliSubtitleRequest copyWith(
          void Function(GetBilibiliSubtitleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliSubtitleRequest))
          as GetBilibiliSubtitleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliSubtitleRequest create() => GetBilibiliSubtitleRequest._();
  @$core.override
  GetBilibiliSubtitleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliSubtitleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliSubtitleRequest>(create);
  static GetBilibiliSubtitleRequest? _defaultInstance;

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

class BilibiliSubtitleResponse extends $pb.GeneratedMessage {
  factory BilibiliSubtitleResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliSubtitleResponse._();

  factory BilibiliSubtitleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliSubtitleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliSubtitleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliSubtitleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliSubtitleResponse copyWith(
          void Function(BilibiliSubtitleResponse) updates) =>
      super.copyWith((message) => updates(message as BilibiliSubtitleResponse))
          as BilibiliSubtitleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliSubtitleResponse create() => BilibiliSubtitleResponse._();
  @$core.override
  BilibiliSubtitleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliSubtitleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliSubtitleResponse>(create);
  static BilibiliSubtitleResponse? _defaultInstance;

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

class GetBilibiliDanmakuFileRequest extends $pb.GeneratedMessage {
  factory GetBilibiliDanmakuFileRequest({
    $core.String? version,
    $core.int? danmakuIndex,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (danmakuIndex != null) result.danmakuIndex = danmakuIndex;
    if (sig != null) result.sig = sig;
    if (uid != null) result.uid = uid;
    if (rid != null) result.rid = rid;
    if (exp != null) result.exp = exp;
    return result;
  }

  GetBilibiliDanmakuFileRequest._();

  factory GetBilibiliDanmakuFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBilibiliDanmakuFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBilibiliDanmakuFileRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aI(2, _omitFieldNames ? '' : 'danmakuIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'sig')
    ..aOS(4, _omitFieldNames ? '' : 'uid')
    ..aOS(5, _omitFieldNames ? '' : 'rid')
    ..aInt64(6, _omitFieldNames ? '' : 'exp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliDanmakuFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBilibiliDanmakuFileRequest copyWith(
          void Function(GetBilibiliDanmakuFileRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetBilibiliDanmakuFileRequest))
          as GetBilibiliDanmakuFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBilibiliDanmakuFileRequest create() =>
      GetBilibiliDanmakuFileRequest._();
  @$core.override
  GetBilibiliDanmakuFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBilibiliDanmakuFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBilibiliDanmakuFileRequest>(create);
  static GetBilibiliDanmakuFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get danmakuIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set danmakuIndex($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDanmakuIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearDanmakuIndex() => $_clearField(2);

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

class BilibiliDanmakuFileResponse extends $pb.GeneratedMessage {
  factory BilibiliDanmakuFileResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  BilibiliDanmakuFileResponse._();

  factory BilibiliDanmakuFileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliDanmakuFileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliDanmakuFileResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliDanmakuFileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliDanmakuFileResponse copyWith(
          void Function(BilibiliDanmakuFileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliDanmakuFileResponse))
          as BilibiliDanmakuFileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliDanmakuFileResponse create() =>
      BilibiliDanmakuFileResponse._();
  @$core.override
  BilibiliDanmakuFileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliDanmakuFileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliDanmakuFileResponse>(create);
  static BilibiliDanmakuFileResponse? _defaultInstance;

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

class WatchBilibiliLiveDanmakuRequest extends $pb.GeneratedMessage {
  factory WatchBilibiliLiveDanmakuRequest({
    $core.String? mediaId,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  WatchBilibiliLiveDanmakuRequest._();

  factory WatchBilibiliLiveDanmakuRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchBilibiliLiveDanmakuRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchBilibiliLiveDanmakuRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchBilibiliLiveDanmakuRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchBilibiliLiveDanmakuRequest copyWith(
          void Function(WatchBilibiliLiveDanmakuRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WatchBilibiliLiveDanmakuRequest))
          as WatchBilibiliLiveDanmakuRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchBilibiliLiveDanmakuRequest create() =>
      WatchBilibiliLiveDanmakuRequest._();
  @$core.override
  WatchBilibiliLiveDanmakuRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchBilibiliLiveDanmakuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchBilibiliLiveDanmakuRequest>(
          create);
  static WatchBilibiliLiveDanmakuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);
}

class BilibiliLiveDanmakuEvent extends $pb.GeneratedMessage {
  factory BilibiliLiveDanmakuEvent({
    $core.String? format,
    $core.String? eventType,
    $core.String? user,
    $core.String? message,
    $fixnum.Int64? timestamp,
    $core.String? giftName,
    $core.int? giftCount,
    $core.int? onlineCount,
    BilibiliLiveDanmakuEventType? type,
  }) {
    final result = create();
    if (format != null) result.format = format;
    if (eventType != null) result.eventType = eventType;
    if (user != null) result.user = user;
    if (message != null) result.message = message;
    if (timestamp != null) result.timestamp = timestamp;
    if (giftName != null) result.giftName = giftName;
    if (giftCount != null) result.giftCount = giftCount;
    if (onlineCount != null) result.onlineCount = onlineCount;
    if (type != null) result.type = type;
    return result;
  }

  BilibiliLiveDanmakuEvent._();

  factory BilibiliLiveDanmakuEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliLiveDanmakuEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliLiveDanmakuEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'format')
    ..aOS(2, _omitFieldNames ? '' : 'eventType')
    ..aOS(3, _omitFieldNames ? '' : 'user')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(6, _omitFieldNames ? '' : 'giftName')
    ..aI(7, _omitFieldNames ? '' : 'giftCount', fieldType: $pb.PbFieldType.OU3)
    ..aI(8, _omitFieldNames ? '' : 'onlineCount',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<BilibiliLiveDanmakuEventType>(9, _omitFieldNames ? '' : 'type',
        enumValues: BilibiliLiveDanmakuEventType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveDanmakuEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveDanmakuEvent copyWith(
          void Function(BilibiliLiveDanmakuEvent) updates) =>
      super.copyWith((message) => updates(message as BilibiliLiveDanmakuEvent))
          as BilibiliLiveDanmakuEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliLiveDanmakuEvent create() => BilibiliLiveDanmakuEvent._();
  @$core.override
  BilibiliLiveDanmakuEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliLiveDanmakuEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliLiveDanmakuEvent>(create);
  static BilibiliLiveDanmakuEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get format => $_getSZ(0);
  @$pb.TagNumber(1)
  set format($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFormat() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormat() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get eventType => $_getSZ(1);
  @$pb.TagNumber(2)
  set eventType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEventType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get giftName => $_getSZ(5);
  @$pb.TagNumber(6)
  set giftName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGiftName() => $_has(5);
  @$pb.TagNumber(6)
  void clearGiftName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get giftCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set giftCount($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGiftCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearGiftCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get onlineCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set onlineCount($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOnlineCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearOnlineCount() => $_clearField(8);

  @$pb.TagNumber(9)
  BilibiliLiveDanmakuEventType get type => $_getN(8);
  @$pb.TagNumber(9)
  set type(BilibiliLiveDanmakuEventType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasType() => $_has(8);
  @$pb.TagNumber(9)
  void clearType() => $_clearField(9);
}

class BilibiliPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  BilibiliPlaybackProviderServiceApi(this._client);

  $async.Future<BilibiliMediaStreamResponse> getMediaStream(
          $pb.ClientContext? ctx, GetBilibiliMediaStreamRequest request) =>
      _client.invoke<BilibiliMediaStreamResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetMediaStream',
          request,
          BilibiliMediaStreamResponse());
  $async.Future<BilibiliHlsManifestResponse> getHlsManifest(
          $pb.ClientContext? ctx, GetBilibiliHlsManifestRequest request) =>
      _client.invoke<BilibiliHlsManifestResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetHlsManifest',
          request,
          BilibiliHlsManifestResponse());
  $async.Future<BilibiliHlsResourceResponse> getHlsResource(
          $pb.ClientContext? ctx, GetBilibiliHlsResourceRequest request) =>
      _client.invoke<BilibiliHlsResourceResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetHlsResource',
          request,
          BilibiliHlsResourceResponse());
  $async.Future<BilibiliDashManifestResponse> getDashManifest(
          $pb.ClientContext? ctx, GetBilibiliDashManifestRequest request) =>
      _client.invoke<BilibiliDashManifestResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetDashManifest',
          request,
          BilibiliDashManifestResponse());
  $async.Future<BilibiliDashResourceResponse> getDashResource(
          $pb.ClientContext? ctx, GetBilibiliDashResourceRequest request) =>
      _client.invoke<BilibiliDashResourceResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetDashResource',
          request,
          BilibiliDashResourceResponse());
  $async.Future<BilibiliSubtitleResponse> getSubtitle(
          $pb.ClientContext? ctx, GetBilibiliSubtitleRequest request) =>
      _client.invoke<BilibiliSubtitleResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetSubtitle',
          request,
          BilibiliSubtitleResponse());
  $async.Future<BilibiliDanmakuFileResponse> getDanmakuFile(
          $pb.ClientContext? ctx, GetBilibiliDanmakuFileRequest request) =>
      _client.invoke<BilibiliDanmakuFileResponse>(
          ctx,
          'BilibiliPlaybackProviderService',
          'GetDanmakuFile',
          request,
          BilibiliDanmakuFileResponse());
  $async.Future<BilibiliLiveDanmakuEvent> watchLiveDanmaku(
          $pb.ClientContext? ctx, WatchBilibiliLiveDanmakuRequest request) =>
      _client.invoke<BilibiliLiveDanmakuEvent>(
          ctx,
          'BilibiliPlaybackProviderService',
          'WatchLiveDanmaku',
          request,
          BilibiliLiveDanmakuEvent());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
