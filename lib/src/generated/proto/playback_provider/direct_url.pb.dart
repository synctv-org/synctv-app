// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/direct_url.proto.

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
import 'direct_url.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'direct_url.pbenum.dart';

class GetDirectUrlStreamRequest extends $pb.GeneratedMessage {
  factory GetDirectUrlStreamRequest({
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

  GetDirectUrlStreamRequest._();

  factory GetDirectUrlStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDirectUrlStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDirectUrlStreamRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
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
  GetDirectUrlStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlStreamRequest copyWith(
          void Function(GetDirectUrlStreamRequest) updates) =>
      super.copyWith((message) => updates(message as GetDirectUrlStreamRequest))
          as GetDirectUrlStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDirectUrlStreamRequest create() => GetDirectUrlStreamRequest._();
  @$core.override
  GetDirectUrlStreamRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDirectUrlStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDirectUrlStreamRequest>(create);
  static GetDirectUrlStreamRequest? _defaultInstance;

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

class DirectUrlStreamResponse extends $pb.GeneratedMessage {
  factory DirectUrlStreamResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DirectUrlStreamResponse._();

  factory DirectUrlStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlStreamResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlStreamResponse copyWith(
          void Function(DirectUrlStreamResponse) updates) =>
      super.copyWith((message) => updates(message as DirectUrlStreamResponse))
          as DirectUrlStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlStreamResponse create() => DirectUrlStreamResponse._();
  @$core.override
  DirectUrlStreamResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlStreamResponse>(create);
  static DirectUrlStreamResponse? _defaultInstance;

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

class GetDirectUrlHlsManifestRequest extends $pb.GeneratedMessage {
  factory GetDirectUrlHlsManifestRequest({
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

  GetDirectUrlHlsManifestRequest._();

  factory GetDirectUrlHlsManifestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDirectUrlHlsManifestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDirectUrlHlsManifestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
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
  GetDirectUrlHlsManifestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlHlsManifestRequest copyWith(
          void Function(GetDirectUrlHlsManifestRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDirectUrlHlsManifestRequest))
          as GetDirectUrlHlsManifestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDirectUrlHlsManifestRequest create() =>
      GetDirectUrlHlsManifestRequest._();
  @$core.override
  GetDirectUrlHlsManifestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDirectUrlHlsManifestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDirectUrlHlsManifestRequest>(create);
  static GetDirectUrlHlsManifestRequest? _defaultInstance;

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

class DirectUrlHlsManifestResponse extends $pb.GeneratedMessage {
  factory DirectUrlHlsManifestResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DirectUrlHlsManifestResponse._();

  factory DirectUrlHlsManifestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlHlsManifestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlHlsManifestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlHlsManifestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlHlsManifestResponse copyWith(
          void Function(DirectUrlHlsManifestResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlHlsManifestResponse))
          as DirectUrlHlsManifestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlHlsManifestResponse create() =>
      DirectUrlHlsManifestResponse._();
  @$core.override
  DirectUrlHlsManifestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlHlsManifestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlHlsManifestResponse>(create);
  static DirectUrlHlsManifestResponse? _defaultInstance;

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

class GetDirectUrlHlsResourceRequest extends $pb.GeneratedMessage {
  factory GetDirectUrlHlsResourceRequest({
    $core.String? version,
    $core.String? targetUrl,
    $core.String? sig,
    $core.String? uid,
    $core.String? rid,
    $fixnum.Int64? exp,
    $core.String? range,
    $core.bool? head,
    $core.String? modeName,
    $core.int? urlIndex,
    DirectUrlManifestResourceKind? resourceKind,
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
    if (urlIndex != null) result.urlIndex = urlIndex;
    if (resourceKind != null) result.resourceKind = resourceKind;
    return result;
  }

  GetDirectUrlHlsResourceRequest._();

  factory GetDirectUrlHlsResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDirectUrlHlsResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDirectUrlHlsResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
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
    ..aI(10, _omitFieldNames ? '' : 'urlIndex', fieldType: $pb.PbFieldType.OU3)
    ..aE<DirectUrlManifestResourceKind>(
        11, _omitFieldNames ? '' : 'resourceKind',
        enumValues: DirectUrlManifestResourceKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlHlsResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlHlsResourceRequest copyWith(
          void Function(GetDirectUrlHlsResourceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDirectUrlHlsResourceRequest))
          as GetDirectUrlHlsResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDirectUrlHlsResourceRequest create() =>
      GetDirectUrlHlsResourceRequest._();
  @$core.override
  GetDirectUrlHlsResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDirectUrlHlsResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDirectUrlHlsResourceRequest>(create);
  static GetDirectUrlHlsResourceRequest? _defaultInstance;

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
  $core.int get urlIndex => $_getIZ(9);
  @$pb.TagNumber(10)
  set urlIndex($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUrlIndex() => $_has(9);
  @$pb.TagNumber(10)
  void clearUrlIndex() => $_clearField(10);

  @$pb.TagNumber(11)
  DirectUrlManifestResourceKind get resourceKind => $_getN(10);
  @$pb.TagNumber(11)
  set resourceKind(DirectUrlManifestResourceKind value) =>
      $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasResourceKind() => $_has(10);
  @$pb.TagNumber(11)
  void clearResourceKind() => $_clearField(11);
}

class DirectUrlHlsResourceResponse extends $pb.GeneratedMessage {
  factory DirectUrlHlsResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DirectUrlHlsResourceResponse._();

  factory DirectUrlHlsResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlHlsResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlHlsResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlHlsResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlHlsResourceResponse copyWith(
          void Function(DirectUrlHlsResourceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlHlsResourceResponse))
          as DirectUrlHlsResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlHlsResourceResponse create() =>
      DirectUrlHlsResourceResponse._();
  @$core.override
  DirectUrlHlsResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlHlsResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlHlsResourceResponse>(create);
  static DirectUrlHlsResourceResponse? _defaultInstance;

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

class GetDirectUrlDashManifestRequest extends $pb.GeneratedMessage {
  factory GetDirectUrlDashManifestRequest({
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

  GetDirectUrlDashManifestRequest._();

  factory GetDirectUrlDashManifestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDirectUrlDashManifestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDirectUrlDashManifestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
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
  GetDirectUrlDashManifestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlDashManifestRequest copyWith(
          void Function(GetDirectUrlDashManifestRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDirectUrlDashManifestRequest))
          as GetDirectUrlDashManifestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDirectUrlDashManifestRequest create() =>
      GetDirectUrlDashManifestRequest._();
  @$core.override
  GetDirectUrlDashManifestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDirectUrlDashManifestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDirectUrlDashManifestRequest>(
          create);
  static GetDirectUrlDashManifestRequest? _defaultInstance;

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

class DirectUrlDashManifestResponse extends $pb.GeneratedMessage {
  factory DirectUrlDashManifestResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DirectUrlDashManifestResponse._();

  factory DirectUrlDashManifestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlDashManifestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlDashManifestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlDashManifestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlDashManifestResponse copyWith(
          void Function(DirectUrlDashManifestResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlDashManifestResponse))
          as DirectUrlDashManifestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlDashManifestResponse create() =>
      DirectUrlDashManifestResponse._();
  @$core.override
  DirectUrlDashManifestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlDashManifestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlDashManifestResponse>(create);
  static DirectUrlDashManifestResponse? _defaultInstance;

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

class GetDirectUrlDashResourceRequest extends $pb.GeneratedMessage {
  factory GetDirectUrlDashResourceRequest({
    $core.String? version,
    $core.String? modeName,
    $core.int? urlIndex,
    $core.String? scopeUrl,
    $core.String? resourcePath,
    $core.String? resourceQuery,
    DirectUrlManifestResourceKind? resourceKind,
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

  GetDirectUrlDashResourceRequest._();

  factory GetDirectUrlDashResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDirectUrlDashResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDirectUrlDashResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'modeName')
    ..aI(3, _omitFieldNames ? '' : 'urlIndex', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'scopeUrl')
    ..aOS(5, _omitFieldNames ? '' : 'resourcePath')
    ..aOS(6, _omitFieldNames ? '' : 'resourceQuery')
    ..aE<DirectUrlManifestResourceKind>(
        7, _omitFieldNames ? '' : 'resourceKind',
        enumValues: DirectUrlManifestResourceKind.values)
    ..aOS(8, _omitFieldNames ? '' : 'sig')
    ..aOS(9, _omitFieldNames ? '' : 'uid')
    ..aOS(10, _omitFieldNames ? '' : 'rid')
    ..aInt64(11, _omitFieldNames ? '' : 'exp')
    ..aOS(12, _omitFieldNames ? '' : 'range')
    ..aOB(13, _omitFieldNames ? '' : 'head')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlDashResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlDashResourceRequest copyWith(
          void Function(GetDirectUrlDashResourceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDirectUrlDashResourceRequest))
          as GetDirectUrlDashResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDirectUrlDashResourceRequest create() =>
      GetDirectUrlDashResourceRequest._();
  @$core.override
  GetDirectUrlDashResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDirectUrlDashResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDirectUrlDashResourceRequest>(
          create);
  static GetDirectUrlDashResourceRequest? _defaultInstance;

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
  $core.String get scopeUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get resourcePath => $_getSZ(4);
  @$pb.TagNumber(5)
  set resourcePath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResourcePath() => $_has(4);
  @$pb.TagNumber(5)
  void clearResourcePath() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get resourceQuery => $_getSZ(5);
  @$pb.TagNumber(6)
  set resourceQuery($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResourceQuery() => $_has(5);
  @$pb.TagNumber(6)
  void clearResourceQuery() => $_clearField(6);

  @$pb.TagNumber(7)
  DirectUrlManifestResourceKind get resourceKind => $_getN(6);
  @$pb.TagNumber(7)
  set resourceKind(DirectUrlManifestResourceKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasResourceKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearResourceKind() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sig => $_getSZ(7);
  @$pb.TagNumber(8)
  set sig($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSig() => $_has(7);
  @$pb.TagNumber(8)
  void clearSig() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get uid => $_getSZ(8);
  @$pb.TagNumber(9)
  set uid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUid() => $_has(8);
  @$pb.TagNumber(9)
  void clearUid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get rid => $_getSZ(9);
  @$pb.TagNumber(10)
  set rid($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRid() => $_has(9);
  @$pb.TagNumber(10)
  void clearRid() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get exp => $_getI64(10);
  @$pb.TagNumber(11)
  set exp($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExp() => $_has(10);
  @$pb.TagNumber(11)
  void clearExp() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get range => $_getSZ(11);
  @$pb.TagNumber(12)
  set range($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRange() => $_has(11);
  @$pb.TagNumber(12)
  void clearRange() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get head => $_getBF(12);
  @$pb.TagNumber(13)
  set head($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasHead() => $_has(12);
  @$pb.TagNumber(13)
  void clearHead() => $_clearField(13);
}

class DirectUrlDashResourceResponse extends $pb.GeneratedMessage {
  factory DirectUrlDashResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DirectUrlDashResourceResponse._();

  factory DirectUrlDashResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlDashResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlDashResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlDashResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlDashResourceResponse copyWith(
          void Function(DirectUrlDashResourceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlDashResourceResponse))
          as DirectUrlDashResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlDashResourceResponse create() =>
      DirectUrlDashResourceResponse._();
  @$core.override
  DirectUrlDashResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlDashResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlDashResourceResponse>(create);
  static DirectUrlDashResourceResponse? _defaultInstance;

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

class GetDirectUrlSubtitleRequest extends $pb.GeneratedMessage {
  factory GetDirectUrlSubtitleRequest({
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

  GetDirectUrlSubtitleRequest._();

  factory GetDirectUrlSubtitleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDirectUrlSubtitleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDirectUrlSubtitleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
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
  GetDirectUrlSubtitleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDirectUrlSubtitleRequest copyWith(
          void Function(GetDirectUrlSubtitleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDirectUrlSubtitleRequest))
          as GetDirectUrlSubtitleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDirectUrlSubtitleRequest create() =>
      GetDirectUrlSubtitleRequest._();
  @$core.override
  GetDirectUrlSubtitleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDirectUrlSubtitleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDirectUrlSubtitleRequest>(create);
  static GetDirectUrlSubtitleRequest? _defaultInstance;

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

class DirectUrlSubtitleResponse extends $pb.GeneratedMessage {
  factory DirectUrlSubtitleResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  DirectUrlSubtitleResponse._();

  factory DirectUrlSubtitleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlSubtitleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlSubtitleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.direct_url'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlSubtitleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlSubtitleResponse copyWith(
          void Function(DirectUrlSubtitleResponse) updates) =>
      super.copyWith((message) => updates(message as DirectUrlSubtitleResponse))
          as DirectUrlSubtitleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlSubtitleResponse create() => DirectUrlSubtitleResponse._();
  @$core.override
  DirectUrlSubtitleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlSubtitleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlSubtitleResponse>(create);
  static DirectUrlSubtitleResponse? _defaultInstance;

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

class DirectUrlPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  DirectUrlPlaybackProviderServiceApi(this._client);

  $async.Future<DirectUrlStreamResponse> getStream(
          $pb.ClientContext? ctx, GetDirectUrlStreamRequest request) =>
      _client.invoke<DirectUrlStreamResponse>(
          ctx,
          'DirectUrlPlaybackProviderService',
          'GetStream',
          request,
          DirectUrlStreamResponse());
  $async.Future<DirectUrlHlsManifestResponse> getHlsManifest(
          $pb.ClientContext? ctx, GetDirectUrlHlsManifestRequest request) =>
      _client.invoke<DirectUrlHlsManifestResponse>(
          ctx,
          'DirectUrlPlaybackProviderService',
          'GetHlsManifest',
          request,
          DirectUrlHlsManifestResponse());
  $async.Future<DirectUrlHlsResourceResponse> getHlsResource(
          $pb.ClientContext? ctx, GetDirectUrlHlsResourceRequest request) =>
      _client.invoke<DirectUrlHlsResourceResponse>(
          ctx,
          'DirectUrlPlaybackProviderService',
          'GetHlsResource',
          request,
          DirectUrlHlsResourceResponse());
  $async.Future<DirectUrlDashManifestResponse> getDashManifest(
          $pb.ClientContext? ctx, GetDirectUrlDashManifestRequest request) =>
      _client.invoke<DirectUrlDashManifestResponse>(
          ctx,
          'DirectUrlPlaybackProviderService',
          'GetDashManifest',
          request,
          DirectUrlDashManifestResponse());
  $async.Future<DirectUrlDashResourceResponse> getDashResource(
          $pb.ClientContext? ctx, GetDirectUrlDashResourceRequest request) =>
      _client.invoke<DirectUrlDashResourceResponse>(
          ctx,
          'DirectUrlPlaybackProviderService',
          'GetDashResource',
          request,
          DirectUrlDashResourceResponse());
  $async.Future<DirectUrlSubtitleResponse> getSubtitle(
          $pb.ClientContext? ctx, GetDirectUrlSubtitleRequest request) =>
      _client.invoke<DirectUrlSubtitleResponse>(
          ctx,
          'DirectUrlPlaybackProviderService',
          'GetSubtitle',
          request,
          DirectUrlSubtitleResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
