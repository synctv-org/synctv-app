// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/synology.proto.

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

class GetSynologyResourceRequest extends $pb.GeneratedMessage {
  factory GetSynologyResourceRequest({
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

  GetSynologyResourceRequest._();

  factory GetSynologyResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSynologyResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSynologyResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.synology'),
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
  GetSynologyResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSynologyResourceRequest copyWith(
          void Function(GetSynologyResourceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetSynologyResourceRequest))
          as GetSynologyResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSynologyResourceRequest create() => GetSynologyResourceRequest._();
  @$core.override
  GetSynologyResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSynologyResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSynologyResourceRequest>(create);
  static GetSynologyResourceRequest? _defaultInstance;

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

class SynologyResourceResponse extends $pb.GeneratedMessage {
  factory SynologyResourceResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  SynologyResourceResponse._();

  factory SynologyResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.synology'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyResourceResponse copyWith(
          void Function(SynologyResourceResponse) updates) =>
      super.copyWith((message) => updates(message as SynologyResourceResponse))
          as SynologyResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyResourceResponse create() => SynologyResourceResponse._();
  @$core.override
  SynologyResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyResourceResponse>(create);
  static SynologyResourceResponse? _defaultInstance;

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

class GetSynologySegmentRequest extends $pb.GeneratedMessage {
  factory GetSynologySegmentRequest({
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

  GetSynologySegmentRequest._();

  factory GetSynologySegmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSynologySegmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSynologySegmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.synology'),
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
  GetSynologySegmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSynologySegmentRequest copyWith(
          void Function(GetSynologySegmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetSynologySegmentRequest))
          as GetSynologySegmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSynologySegmentRequest create() => GetSynologySegmentRequest._();
  @$core.override
  GetSynologySegmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSynologySegmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSynologySegmentRequest>(create);
  static GetSynologySegmentRequest? _defaultInstance;

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

class SynologySegmentResponse extends $pb.GeneratedMessage {
  factory SynologySegmentResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  SynologySegmentResponse._();

  factory SynologySegmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologySegmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologySegmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.synology'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologySegmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologySegmentResponse copyWith(
          void Function(SynologySegmentResponse) updates) =>
      super.copyWith((message) => updates(message as SynologySegmentResponse))
          as SynologySegmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologySegmentResponse create() => SynologySegmentResponse._();
  @$core.override
  SynologySegmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologySegmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologySegmentResponse>(create);
  static SynologySegmentResponse? _defaultInstance;

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

class GetSynologySubtitleRequest extends $pb.GeneratedMessage {
  factory GetSynologySubtitleRequest({
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

  GetSynologySubtitleRequest._();

  factory GetSynologySubtitleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSynologySubtitleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSynologySubtitleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.synology'),
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
  GetSynologySubtitleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSynologySubtitleRequest copyWith(
          void Function(GetSynologySubtitleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetSynologySubtitleRequest))
          as GetSynologySubtitleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSynologySubtitleRequest create() => GetSynologySubtitleRequest._();
  @$core.override
  GetSynologySubtitleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSynologySubtitleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSynologySubtitleRequest>(create);
  static GetSynologySubtitleRequest? _defaultInstance;

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

class SynologySubtitleResponse extends $pb.GeneratedMessage {
  factory SynologySubtitleResponse({
    $0.StreamChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  SynologySubtitleResponse._();

  factory SynologySubtitleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologySubtitleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologySubtitleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.synology'),
      createEmptyInstance: create)
    ..aOM<$0.StreamChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: $0.StreamChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologySubtitleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologySubtitleResponse copyWith(
          void Function(SynologySubtitleResponse) updates) =>
      super.copyWith((message) => updates(message as SynologySubtitleResponse))
          as SynologySubtitleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologySubtitleResponse create() => SynologySubtitleResponse._();
  @$core.override
  SynologySubtitleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologySubtitleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologySubtitleResponse>(create);
  static SynologySubtitleResponse? _defaultInstance;

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

class SynologyPlaybackProviderServiceApi {
  final $pb.RpcClient _client;

  SynologyPlaybackProviderServiceApi(this._client);

  $async.Future<SynologyResourceResponse> getResource(
          $pb.ClientContext? ctx, GetSynologyResourceRequest request) =>
      _client.invoke<SynologyResourceResponse>(
          ctx,
          'SynologyPlaybackProviderService',
          'GetResource',
          request,
          SynologyResourceResponse());
  $async.Future<SynologySegmentResponse> getSegment(
          $pb.ClientContext? ctx, GetSynologySegmentRequest request) =>
      _client.invoke<SynologySegmentResponse>(
          ctx,
          'SynologyPlaybackProviderService',
          'GetSegment',
          request,
          SynologySegmentResponse());
  $async.Future<SynologySubtitleResponse> getSubtitle(
          $pb.ClientContext? ctx, GetSynologySubtitleRequest request) =>
      _client.invoke<SynologySubtitleResponse>(
          ctx,
          'SynologyPlaybackProviderService',
          'GetSubtitle',
          request,
          SynologySubtitleResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
