// This is a generated file - do not edit.
//
// Generated from proto/providers/common.proto.

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
import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

enum DiscoveredSource_SourceConfig { media, playlist, notSet }

/// A source prepared by the server during provider discovery. Clients submit
/// this value unchanged to AddMedia or CreatePlaylist.
class DiscoveredSource extends $pb.GeneratedMessage {
  factory DiscoveredSource({
    $0.MediaSourceConfig? media,
    $0.PlaylistSourceConfig? playlist,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (media != null) result.media = media;
    if (playlist != null) result.playlist = playlist;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    return result;
  }

  DiscoveredSource._();

  factory DiscoveredSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoveredSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DiscoveredSource_SourceConfig>
      _DiscoveredSource_SourceConfigByTag = {
    1: DiscoveredSource_SourceConfig.media,
    2: DiscoveredSource_SourceConfig.playlist,
    0: DiscoveredSource_SourceConfig.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoveredSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<$0.MediaSourceConfig>(1, _omitFieldNames ? '' : 'media',
        subBuilder: $0.MediaSourceConfig.create)
    ..aOM<$0.PlaylistSourceConfig>(2, _omitFieldNames ? '' : 'playlist',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..aOS(3, _omitFieldNames ? '' : 'providerInstanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoveredSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoveredSource copyWith(void Function(DiscoveredSource) updates) =>
      super.copyWith((message) => updates(message as DiscoveredSource))
          as DiscoveredSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoveredSource create() => DiscoveredSource._();
  @$core.override
  DiscoveredSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoveredSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoveredSource>(create);
  static DiscoveredSource? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  DiscoveredSource_SourceConfig whichSourceConfig() =>
      _DiscoveredSource_SourceConfigByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearSourceConfig() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.MediaSourceConfig get media => $_getN(0);
  @$pb.TagNumber(1)
  set media($0.MediaSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMedia() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedia() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.MediaSourceConfig ensureMedia() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.PlaylistSourceConfig get playlist => $_getN(1);
  @$pb.TagNumber(2)
  set playlist($0.PlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylist() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylist() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.PlaylistSourceConfig ensurePlaylist() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get providerInstanceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set providerInstanceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProviderInstanceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearProviderInstanceName() => $_clearField(3);
}

class PreparedMediaSource extends $pb.GeneratedMessage {
  factory PreparedMediaSource({
    DiscoveredSource? source,
    $core.String? suggestedName,
    $0.PlaybackKind? playbackKind,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (suggestedName != null) result.suggestedName = suggestedName;
    if (playbackKind != null) result.playbackKind = playbackKind;
    return result;
  }

  PreparedMediaSource._();

  factory PreparedMediaSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreparedMediaSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreparedMediaSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<DiscoveredSource>(1, _omitFieldNames ? '' : 'source',
        subBuilder: DiscoveredSource.create)
    ..aOS(2, _omitFieldNames ? '' : 'suggestedName')
    ..aE<$0.PlaybackKind>(3, _omitFieldNames ? '' : 'playbackKind',
        enumValues: $0.PlaybackKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreparedMediaSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreparedMediaSource copyWith(void Function(PreparedMediaSource) updates) =>
      super.copyWith((message) => updates(message as PreparedMediaSource))
          as PreparedMediaSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreparedMediaSource create() => PreparedMediaSource._();
  @$core.override
  PreparedMediaSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreparedMediaSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreparedMediaSource>(create);
  static PreparedMediaSource? _defaultInstance;

  @$pb.TagNumber(1)
  DiscoveredSource get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(DiscoveredSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  DiscoveredSource ensureSource() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get suggestedName => $_getSZ(1);
  @$pb.TagNumber(2)
  set suggestedName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuggestedName() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuggestedName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.PlaybackKind get playbackKind => $_getN(2);
  @$pb.TagNumber(3)
  set playbackKind($0.PlaybackKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlaybackKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlaybackKind() => $_clearField(3);
}

/// Transport-neutral chunks for non-room provider resources such as images
/// shown while browsing before media is added to a room.
class ResourceChunk extends $pb.GeneratedMessage {
  factory ResourceChunk({
    $core.List<$core.int>? data,
    $core.int? status,
    $core.String? contentType,
    $fixnum.Int64? contentLength,
    $core.String? contentRange,
    $core.String? acceptRanges,
    $core.String? cacheControl,
    $core.String? etag,
    $core.String? lastModified,
    $core.String? expires,
    $core.String? contentDisposition,
    $core.String? location,
    $core.String? contentEncoding,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (status != null) result.status = status;
    if (contentType != null) result.contentType = contentType;
    if (contentLength != null) result.contentLength = contentLength;
    if (contentRange != null) result.contentRange = contentRange;
    if (acceptRanges != null) result.acceptRanges = acceptRanges;
    if (cacheControl != null) result.cacheControl = cacheControl;
    if (etag != null) result.etag = etag;
    if (lastModified != null) result.lastModified = lastModified;
    if (expires != null) result.expires = expires;
    if (contentDisposition != null)
      result.contentDisposition = contentDisposition;
    if (location != null) result.location = location;
    if (contentEncoding != null) result.contentEncoding = contentEncoding;
    return result;
  }

  ResourceChunk._();

  factory ResourceChunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceChunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceChunk',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'contentType')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'contentLength', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, _omitFieldNames ? '' : 'contentRange')
    ..aOS(6, _omitFieldNames ? '' : 'acceptRanges')
    ..aOS(7, _omitFieldNames ? '' : 'cacheControl')
    ..aOS(8, _omitFieldNames ? '' : 'etag')
    ..aOS(9, _omitFieldNames ? '' : 'lastModified')
    ..aOS(10, _omitFieldNames ? '' : 'expires')
    ..aOS(11, _omitFieldNames ? '' : 'contentDisposition')
    ..aOS(12, _omitFieldNames ? '' : 'location')
    ..aOS(13, _omitFieldNames ? '' : 'contentEncoding')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceChunk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceChunk copyWith(void Function(ResourceChunk) updates) =>
      super.copyWith((message) => updates(message as ResourceChunk))
          as ResourceChunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceChunk create() => ResourceChunk._();
  @$core.override
  ResourceChunk createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResourceChunk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceChunk>(create);
  static ResourceChunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contentType => $_getSZ(2);
  @$pb.TagNumber(3)
  set contentType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get contentLength => $_getI64(3);
  @$pb.TagNumber(4)
  set contentLength($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentLength() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentLength() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentRange => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentRange($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentRange() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentRange() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get acceptRanges => $_getSZ(5);
  @$pb.TagNumber(6)
  set acceptRanges($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAcceptRanges() => $_has(5);
  @$pb.TagNumber(6)
  void clearAcceptRanges() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get cacheControl => $_getSZ(6);
  @$pb.TagNumber(7)
  set cacheControl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCacheControl() => $_has(6);
  @$pb.TagNumber(7)
  void clearCacheControl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get etag => $_getSZ(7);
  @$pb.TagNumber(8)
  set etag($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEtag() => $_has(7);
  @$pb.TagNumber(8)
  void clearEtag() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get lastModified => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastModified($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLastModified() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastModified() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get expires => $_getSZ(9);
  @$pb.TagNumber(10)
  set expires($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExpires() => $_has(9);
  @$pb.TagNumber(10)
  void clearExpires() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get contentDisposition => $_getSZ(10);
  @$pb.TagNumber(11)
  set contentDisposition($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasContentDisposition() => $_has(10);
  @$pb.TagNumber(11)
  void clearContentDisposition() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get location => $_getSZ(11);
  @$pb.TagNumber(12)
  set location($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLocation() => $_has(11);
  @$pb.TagNumber(12)
  void clearLocation() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get contentEncoding => $_getSZ(12);
  @$pb.TagNumber(13)
  set contentEncoding($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasContentEncoding() => $_has(12);
  @$pb.TagNumber(13)
  void clearContentEncoding() => $_clearField(13);
}

class ResourceResponse extends $pb.GeneratedMessage {
  factory ResourceResponse({
    ResourceChunk? chunk,
  }) {
    final result = create();
    if (chunk != null) result.chunk = chunk;
    return result;
  }

  ResourceResponse._();

  factory ResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<ResourceChunk>(1, _omitFieldNames ? '' : 'chunk',
        subBuilder: ResourceChunk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceResponse copyWith(void Function(ResourceResponse) updates) =>
      super.copyWith((message) => updates(message as ResourceResponse))
          as ResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResourceResponse create() => ResourceResponse._();
  @$core.override
  ResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResourceResponse>(create);
  static ResourceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ResourceChunk get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk(ResourceChunk value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => $_clearField(1);
  @$pb.TagNumber(1)
  ResourceChunk ensureChunk() => $_ensure(0);
}

class PlaybackProxyAutoPolicy extends $pb.GeneratedMessage {
  factory PlaybackProxyAutoPolicy({
    $core.String? variant,
    $0.PlaybackProxyMode? mode,
    PlaybackProxyAutoReason? reason,
  }) {
    final result = create();
    if (variant != null) result.variant = variant;
    if (mode != null) result.mode = mode;
    if (reason != null) result.reason = reason;
    return result;
  }

  PlaybackProxyAutoPolicy._();

  factory PlaybackProxyAutoPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackProxyAutoPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackProxyAutoPolicy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'variant')
    ..aE<$0.PlaybackProxyMode>(2, _omitFieldNames ? '' : 'mode',
        enumValues: $0.PlaybackProxyMode.values)
    ..aE<PlaybackProxyAutoReason>(3, _omitFieldNames ? '' : 'reason',
        enumValues: PlaybackProxyAutoReason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackProxyAutoPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackProxyAutoPolicy copyWith(
          void Function(PlaybackProxyAutoPolicy) updates) =>
      super.copyWith((message) => updates(message as PlaybackProxyAutoPolicy))
          as PlaybackProxyAutoPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackProxyAutoPolicy create() => PlaybackProxyAutoPolicy._();
  @$core.override
  PlaybackProxyAutoPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackProxyAutoPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackProxyAutoPolicy>(create);
  static PlaybackProxyAutoPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get variant => $_getSZ(0);
  @$pb.TagNumber(1)
  set variant($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVariant() => $_has(0);
  @$pb.TagNumber(1)
  void clearVariant() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.PlaybackProxyMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode($0.PlaybackProxyMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyAutoReason get reason => $_getN(2);
  @$pb.TagNumber(3)
  set reason(PlaybackProxyAutoReason value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class PlaybackProxyPolicy extends $pb.GeneratedMessage {
  factory PlaybackProxyPolicy({
    $core.Iterable<$0.PlaybackProxyMode>? supportedModes,
    $0.PlaybackProxyMode? currentMode,
    $core.Iterable<PlaybackProxyAutoPolicy>? autoPolicies,
  }) {
    final result = create();
    if (supportedModes != null) result.supportedModes.addAll(supportedModes);
    if (currentMode != null) result.currentMode = currentMode;
    if (autoPolicies != null) result.autoPolicies.addAll(autoPolicies);
    return result;
  }

  PlaybackProxyPolicy._();

  factory PlaybackProxyPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaybackProxyPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaybackProxyPolicy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..pc<$0.PlaybackProxyMode>(
        1, _omitFieldNames ? '' : 'supportedModes', $pb.PbFieldType.KE,
        valueOf: $0.PlaybackProxyMode.valueOf,
        enumValues: $0.PlaybackProxyMode.values,
        defaultEnumValue: $0.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO)
    ..aE<$0.PlaybackProxyMode>(2, _omitFieldNames ? '' : 'currentMode',
        enumValues: $0.PlaybackProxyMode.values)
    ..pPM<PlaybackProxyAutoPolicy>(3, _omitFieldNames ? '' : 'autoPolicies',
        subBuilder: PlaybackProxyAutoPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackProxyPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaybackProxyPolicy copyWith(void Function(PlaybackProxyPolicy) updates) =>
      super.copyWith((message) => updates(message as PlaybackProxyPolicy))
          as PlaybackProxyPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaybackProxyPolicy create() => PlaybackProxyPolicy._();
  @$core.override
  PlaybackProxyPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaybackProxyPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaybackProxyPolicy>(create);
  static PlaybackProxyPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.PlaybackProxyMode> get supportedModes => $_getList(0);

  @$pb.TagNumber(2)
  $0.PlaybackProxyMode get currentMode => $_getN(1);
  @$pb.TagNumber(2)
  set currentMode($0.PlaybackProxyMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<PlaybackProxyAutoPolicy> get autoPolicies => $_getList(2);
}

class ResolvePlaybackProxyPolicyRequest extends $pb.GeneratedMessage {
  factory ResolvePlaybackProxyPolicyRequest({
    DiscoveredSource? source,
  }) {
    final result = create();
    if (source != null) result.source = source;
    return result;
  }

  ResolvePlaybackProxyPolicyRequest._();

  factory ResolvePlaybackProxyPolicyRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolvePlaybackProxyPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolvePlaybackProxyPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<DiscoveredSource>(1, _omitFieldNames ? '' : 'source',
        subBuilder: DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvePlaybackProxyPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolvePlaybackProxyPolicyRequest copyWith(
          void Function(ResolvePlaybackProxyPolicyRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ResolvePlaybackProxyPolicyRequest))
          as ResolvePlaybackProxyPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolvePlaybackProxyPolicyRequest create() =>
      ResolvePlaybackProxyPolicyRequest._();
  @$core.override
  ResolvePlaybackProxyPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolvePlaybackProxyPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolvePlaybackProxyPolicyRequest>(
          create);
  static ResolvePlaybackProxyPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DiscoveredSource get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(DiscoveredSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  DiscoveredSource ensureSource() => $_ensure(0);
}

class PrepareDirectUrlRequest extends $pb.GeneratedMessage {
  factory PrepareDirectUrlRequest({
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $0.PlaybackKind? playbackKind,
    $0.PlaybackProxyMode? proxyMode,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (playbackKind != null) result.playbackKind = playbackKind;
    if (proxyMode != null) result.proxyMode = proxyMode;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  PrepareDirectUrlRequest._();

  factory PrepareDirectUrlRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareDirectUrlRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareDirectUrlRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'headers',
        entryClassName: 'PrepareDirectUrlRequest.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.provider.common'))
    ..aE<$0.PlaybackKind>(3, _omitFieldNames ? '' : 'playbackKind',
        enumValues: $0.PlaybackKind.values)
    ..aE<$0.PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: $0.PlaybackProxyMode.values)
    ..aInt64(6, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareDirectUrlRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareDirectUrlRequest copyWith(
          void Function(PrepareDirectUrlRequest) updates) =>
      super.copyWith((message) => updates(message as PrepareDirectUrlRequest))
          as PrepareDirectUrlRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareDirectUrlRequest create() => PrepareDirectUrlRequest._();
  @$core.override
  PrepareDirectUrlRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareDirectUrlRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareDirectUrlRequest>(create);
  static PrepareDirectUrlRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(1);

  @$pb.TagNumber(3)
  $0.PlaybackKind get playbackKind => $_getN(2);
  @$pb.TagNumber(3)
  set playbackKind($0.PlaybackKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlaybackKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlaybackKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode($0.PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiresAt => $_getI64(4);
  @$pb.TagNumber(6)
  set expiresAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(6)
  void clearExpiresAt() => $_clearField(6);
}

class PrepareRtmpPullIntent extends $pb.GeneratedMessage {
  factory PrepareRtmpPullIntent({
    $core.String? url,
    $0.RtmpStreamMode? mode,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (mode != null) result.mode = mode;
    return result;
  }

  PrepareRtmpPullIntent._();

  factory PrepareRtmpPullIntent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareRtmpPullIntent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareRtmpPullIntent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<$0.RtmpStreamMode>(2, _omitFieldNames ? '' : 'mode',
        enumValues: $0.RtmpStreamMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtmpPullIntent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtmpPullIntent copyWith(
          void Function(PrepareRtmpPullIntent) updates) =>
      super.copyWith((message) => updates(message as PrepareRtmpPullIntent))
          as PrepareRtmpPullIntent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareRtmpPullIntent create() => PrepareRtmpPullIntent._();
  @$core.override
  PrepareRtmpPullIntent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareRtmpPullIntent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareRtmpPullIntent>(create);
  static PrepareRtmpPullIntent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.RtmpStreamMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode($0.RtmpStreamMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);
}

enum PrepareRtspTrackIntent_Mode { firstCompatible, index_, disabled, notSet }

class PrepareRtspTrackIntent extends $pb.GeneratedMessage {
  factory PrepareRtspTrackIntent({
    $core.bool? firstCompatible,
    $core.int? index,
    $core.bool? disabled,
  }) {
    final result = create();
    if (firstCompatible != null) result.firstCompatible = firstCompatible;
    if (index != null) result.index = index;
    if (disabled != null) result.disabled = disabled;
    return result;
  }

  PrepareRtspTrackIntent._();

  factory PrepareRtspTrackIntent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareRtspTrackIntent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PrepareRtspTrackIntent_Mode>
      _PrepareRtspTrackIntent_ModeByTag = {
    1: PrepareRtspTrackIntent_Mode.firstCompatible,
    2: PrepareRtspTrackIntent_Mode.index_,
    3: PrepareRtspTrackIntent_Mode.disabled,
    0: PrepareRtspTrackIntent_Mode.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareRtspTrackIntent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOB(1, _omitFieldNames ? '' : 'firstCompatible')
    ..aI(2, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'disabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtspTrackIntent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtspTrackIntent copyWith(
          void Function(PrepareRtspTrackIntent) updates) =>
      super.copyWith((message) => updates(message as PrepareRtspTrackIntent))
          as PrepareRtspTrackIntent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareRtspTrackIntent create() => PrepareRtspTrackIntent._();
  @$core.override
  PrepareRtspTrackIntent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareRtspTrackIntent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareRtspTrackIntent>(create);
  static PrepareRtspTrackIntent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  PrepareRtspTrackIntent_Mode whichMode() =>
      _PrepareRtspTrackIntent_ModeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearMode() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get firstCompatible => $_getBF(0);
  @$pb.TagNumber(1)
  set firstCompatible($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFirstCompatible() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstCompatible() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get disabled => $_getBF(2);
  @$pb.TagNumber(3)
  set disabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisabled() => $_clearField(3);
}

class PrepareRtspPullIntent extends $pb.GeneratedMessage {
  factory PrepareRtspPullIntent({
    $core.String? url,
    $0.RtspTransport? transport,
    PrepareRtspTrackIntent? videoTrack,
    PrepareRtspTrackIntent? audioTrack,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (transport != null) result.transport = transport;
    if (videoTrack != null) result.videoTrack = videoTrack;
    if (audioTrack != null) result.audioTrack = audioTrack;
    return result;
  }

  PrepareRtspPullIntent._();

  factory PrepareRtspPullIntent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareRtspPullIntent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareRtspPullIntent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<$0.RtspTransport>(2, _omitFieldNames ? '' : 'transport',
        enumValues: $0.RtspTransport.values)
    ..aOM<PrepareRtspTrackIntent>(3, _omitFieldNames ? '' : 'videoTrack',
        subBuilder: PrepareRtspTrackIntent.create)
    ..aOM<PrepareRtspTrackIntent>(4, _omitFieldNames ? '' : 'audioTrack',
        subBuilder: PrepareRtspTrackIntent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtspPullIntent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtspPullIntent copyWith(
          void Function(PrepareRtspPullIntent) updates) =>
      super.copyWith((message) => updates(message as PrepareRtspPullIntent))
          as PrepareRtspPullIntent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareRtspPullIntent create() => PrepareRtspPullIntent._();
  @$core.override
  PrepareRtspPullIntent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareRtspPullIntent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareRtspPullIntent>(create);
  static PrepareRtspPullIntent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.RtspTransport get transport => $_getN(1);
  @$pb.TagNumber(2)
  set transport($0.RtspTransport value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTransport() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransport() => $_clearField(2);

  @$pb.TagNumber(3)
  PrepareRtspTrackIntent get videoTrack => $_getN(2);
  @$pb.TagNumber(3)
  set videoTrack(PrepareRtspTrackIntent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVideoTrack() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoTrack() => $_clearField(3);
  @$pb.TagNumber(3)
  PrepareRtspTrackIntent ensureVideoTrack() => $_ensure(2);

  @$pb.TagNumber(4)
  PrepareRtspTrackIntent get audioTrack => $_getN(3);
  @$pb.TagNumber(4)
  set audioTrack(PrepareRtspTrackIntent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAudioTrack() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioTrack() => $_clearField(4);
  @$pb.TagNumber(4)
  PrepareRtspTrackIntent ensureAudioTrack() => $_ensure(3);
}

class PrepareHttpFlvPullIntent extends $pb.GeneratedMessage {
  factory PrepareHttpFlvPullIntent({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  PrepareHttpFlvPullIntent._();

  factory PrepareHttpFlvPullIntent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareHttpFlvPullIntent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareHttpFlvPullIntent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareHttpFlvPullIntent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareHttpFlvPullIntent copyWith(
          void Function(PrepareHttpFlvPullIntent) updates) =>
      super.copyWith((message) => updates(message as PrepareHttpFlvPullIntent))
          as PrepareHttpFlvPullIntent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareHttpFlvPullIntent create() => PrepareHttpFlvPullIntent._();
  @$core.override
  PrepareHttpFlvPullIntent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareHttpFlvPullIntent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareHttpFlvPullIntent>(create);
  static PrepareHttpFlvPullIntent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class PrepareWhepPullIntent extends $pb.GeneratedMessage {
  factory PrepareWhepPullIntent({
    $core.String? url,
    $core.String? authorization,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (authorization != null) result.authorization = authorization;
    return result;
  }

  PrepareWhepPullIntent._();

  factory PrepareWhepPullIntent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareWhepPullIntent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareWhepPullIntent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'authorization')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareWhepPullIntent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareWhepPullIntent copyWith(
          void Function(PrepareWhepPullIntent) updates) =>
      super.copyWith((message) => updates(message as PrepareWhepPullIntent))
          as PrepareWhepPullIntent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareWhepPullIntent create() => PrepareWhepPullIntent._();
  @$core.override
  PrepareWhepPullIntent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareWhepPullIntent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareWhepPullIntent>(create);
  static PrepareWhepPullIntent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get authorization => $_getSZ(1);
  @$pb.TagNumber(2)
  set authorization($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthorization() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorization() => $_clearField(2);
}

enum PrepareLiveProxyRequest_Source { rtmp, rtsp, httpFlv, whep, notSet }

class PrepareLiveProxyRequest extends $pb.GeneratedMessage {
  factory PrepareLiveProxyRequest({
    PrepareRtmpPullIntent? rtmp,
    PrepareRtspPullIntent? rtsp,
    PrepareHttpFlvPullIntent? httpFlv,
    PrepareWhepPullIntent? whep,
  }) {
    final result = create();
    if (rtmp != null) result.rtmp = rtmp;
    if (rtsp != null) result.rtsp = rtsp;
    if (httpFlv != null) result.httpFlv = httpFlv;
    if (whep != null) result.whep = whep;
    return result;
  }

  PrepareLiveProxyRequest._();

  factory PrepareLiveProxyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareLiveProxyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PrepareLiveProxyRequest_Source>
      _PrepareLiveProxyRequest_SourceByTag = {
    1: PrepareLiveProxyRequest_Source.rtmp,
    2: PrepareLiveProxyRequest_Source.rtsp,
    3: PrepareLiveProxyRequest_Source.httpFlv,
    4: PrepareLiveProxyRequest_Source.whep,
    0: PrepareLiveProxyRequest_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareLiveProxyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<PrepareRtmpPullIntent>(1, _omitFieldNames ? '' : 'rtmp',
        subBuilder: PrepareRtmpPullIntent.create)
    ..aOM<PrepareRtspPullIntent>(2, _omitFieldNames ? '' : 'rtsp',
        subBuilder: PrepareRtspPullIntent.create)
    ..aOM<PrepareHttpFlvPullIntent>(3, _omitFieldNames ? '' : 'httpFlv',
        subBuilder: PrepareHttpFlvPullIntent.create)
    ..aOM<PrepareWhepPullIntent>(4, _omitFieldNames ? '' : 'whep',
        subBuilder: PrepareWhepPullIntent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareLiveProxyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareLiveProxyRequest copyWith(
          void Function(PrepareLiveProxyRequest) updates) =>
      super.copyWith((message) => updates(message as PrepareLiveProxyRequest))
          as PrepareLiveProxyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareLiveProxyRequest create() => PrepareLiveProxyRequest._();
  @$core.override
  PrepareLiveProxyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareLiveProxyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareLiveProxyRequest>(create);
  static PrepareLiveProxyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  PrepareLiveProxyRequest_Source whichSource() =>
      _PrepareLiveProxyRequest_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PrepareRtmpPullIntent get rtmp => $_getN(0);
  @$pb.TagNumber(1)
  set rtmp(PrepareRtmpPullIntent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRtmp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRtmp() => $_clearField(1);
  @$pb.TagNumber(1)
  PrepareRtmpPullIntent ensureRtmp() => $_ensure(0);

  @$pb.TagNumber(2)
  PrepareRtspPullIntent get rtsp => $_getN(1);
  @$pb.TagNumber(2)
  set rtsp(PrepareRtspPullIntent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRtsp() => $_has(1);
  @$pb.TagNumber(2)
  void clearRtsp() => $_clearField(2);
  @$pb.TagNumber(2)
  PrepareRtspPullIntent ensureRtsp() => $_ensure(1);

  @$pb.TagNumber(3)
  PrepareHttpFlvPullIntent get httpFlv => $_getN(2);
  @$pb.TagNumber(3)
  set httpFlv(PrepareHttpFlvPullIntent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasHttpFlv() => $_has(2);
  @$pb.TagNumber(3)
  void clearHttpFlv() => $_clearField(3);
  @$pb.TagNumber(3)
  PrepareHttpFlvPullIntent ensureHttpFlv() => $_ensure(2);

  @$pb.TagNumber(4)
  PrepareWhepPullIntent get whep => $_getN(3);
  @$pb.TagNumber(4)
  set whep(PrepareWhepPullIntent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWhep() => $_has(3);
  @$pb.TagNumber(4)
  void clearWhep() => $_clearField(4);
  @$pb.TagNumber(4)
  PrepareWhepPullIntent ensureWhep() => $_ensure(3);
}

class PrepareRtmpRequest extends $pb.GeneratedMessage {
  factory PrepareRtmpRequest({
    $0.RtmpStreamMode? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  PrepareRtmpRequest._();

  factory PrepareRtmpRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrepareRtmpRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrepareRtmpRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aE<$0.RtmpStreamMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: $0.RtmpStreamMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtmpRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrepareRtmpRequest copyWith(void Function(PrepareRtmpRequest) updates) =>
      super.copyWith((message) => updates(message as PrepareRtmpRequest))
          as PrepareRtmpRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrepareRtmpRequest create() => PrepareRtmpRequest._();
  @$core.override
  PrepareRtmpRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrepareRtmpRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrepareRtmpRequest>(create);
  static PrepareRtmpRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.RtmpStreamMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode($0.RtmpStreamMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

class ProviderInstanceQuery extends $pb.GeneratedMessage {
  factory ProviderInstanceQuery({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ProviderInstanceQuery._();

  factory ProviderInstanceQuery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderInstanceQuery.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderInstanceQuery',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderInstanceQuery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderInstanceQuery copyWith(
          void Function(ProviderInstanceQuery) updates) =>
      super.copyWith((message) => updates(message as ProviderInstanceQuery))
          as ProviderInstanceQuery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderInstanceQuery create() => ProviderInstanceQuery._();
  @$core.override
  ProviderInstanceQuery createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderInstanceQuery getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderInstanceQuery>(create);
  static ProviderInstanceQuery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

class ProviderInstance extends $pb.GeneratedMessage {
  factory ProviderInstance({
    $core.String? name,
    $core.String? endpoint,
    $core.String? comment,
    $core.int? timeoutSeconds,
    $core.bool? tls,
    $core.bool? insecureTls,
    $core.Iterable<$0.SourceProvider>? providers,
    $core.bool? enabled,
    ProviderInstanceStatus? status,
    $fixnum.Int64? createdAt,
    $fixnum.Int64? updatedAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (endpoint != null) result.endpoint = endpoint;
    if (comment != null) result.comment = comment;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    if (tls != null) result.tls = tls;
    if (insecureTls != null) result.insecureTls = insecureTls;
    if (providers != null) result.providers.addAll(providers);
    if (enabled != null) result.enabled = enabled;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ProviderInstance._();

  factory ProviderInstance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderInstance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderInstance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'endpoint')
    ..aOS(3, _omitFieldNames ? '' : 'comment')
    ..aI(4, _omitFieldNames ? '' : 'timeoutSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(5, _omitFieldNames ? '' : 'tls')
    ..aOB(6, _omitFieldNames ? '' : 'insecureTls')
    ..pc<$0.SourceProvider>(
        7, _omitFieldNames ? '' : 'providers', $pb.PbFieldType.KE,
        valueOf: $0.SourceProvider.valueOf,
        enumValues: $0.SourceProvider.values,
        defaultEnumValue: $0.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED)
    ..aOB(8, _omitFieldNames ? '' : 'enabled')
    ..aE<ProviderInstanceStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: ProviderInstanceStatus.values)
    ..aInt64(10, _omitFieldNames ? '' : 'createdAt')
    ..aInt64(11, _omitFieldNames ? '' : 'updatedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderInstance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderInstance copyWith(void Function(ProviderInstance) updates) =>
      super.copyWith((message) => updates(message as ProviderInstance))
          as ProviderInstance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderInstance create() => ProviderInstance._();
  @$core.override
  ProviderInstance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderInstance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderInstance>(create);
  static ProviderInstance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get endpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set endpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get comment => $_getSZ(2);
  @$pb.TagNumber(3)
  set comment($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComment() => $_has(2);
  @$pb.TagNumber(3)
  void clearComment() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get timeoutSeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set timeoutSeconds($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimeoutSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeoutSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get tls => $_getBF(4);
  @$pb.TagNumber(5)
  set tls($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTls() => $_has(4);
  @$pb.TagNumber(5)
  void clearTls() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get insecureTls => $_getBF(5);
  @$pb.TagNumber(6)
  set insecureTls($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInsecureTls() => $_has(5);
  @$pb.TagNumber(6)
  void clearInsecureTls() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$0.SourceProvider> get providers => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get enabled => $_getBF(7);
  @$pb.TagNumber(8)
  set enabled($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEnabled() => $_has(7);
  @$pb.TagNumber(8)
  void clearEnabled() => $_clearField(8);

  @$pb.TagNumber(9)
  ProviderInstanceStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(ProviderInstanceStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAt => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAt($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get updatedAt => $_getI64(10);
  @$pb.TagNumber(11)
  set updatedAt($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
}

class ListAvailableProviderInstancesRequest extends $pb.GeneratedMessage {
  factory ListAvailableProviderInstancesRequest({
    $0.SourceProvider? providerType,
  }) {
    final result = create();
    if (providerType != null) result.providerType = providerType;
    return result;
  }

  ListAvailableProviderInstancesRequest._();

  factory ListAvailableProviderInstancesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAvailableProviderInstancesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAvailableProviderInstancesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aE<$0.SourceProvider>(1, _omitFieldNames ? '' : 'providerType',
        enumValues: $0.SourceProvider.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAvailableProviderInstancesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAvailableProviderInstancesRequest copyWith(
          void Function(ListAvailableProviderInstancesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ListAvailableProviderInstancesRequest))
          as ListAvailableProviderInstancesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAvailableProviderInstancesRequest create() =>
      ListAvailableProviderInstancesRequest._();
  @$core.override
  ListAvailableProviderInstancesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAvailableProviderInstancesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ListAvailableProviderInstancesRequest>(create);
  static ListAvailableProviderInstancesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SourceProvider get providerType => $_getN(0);
  @$pb.TagNumber(1)
  set providerType($0.SourceProvider value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProviderType() => $_has(0);
  @$pb.TagNumber(1)
  void clearProviderType() => $_clearField(1);
}

class ListProviderInstancesRequest extends $pb.GeneratedMessage {
  factory ListProviderInstancesRequest({
    $core.int? page,
    $core.int? pageSize,
    $0.SourceProvider? providerType,
    $core.String? search,
    $core.bool? enabled,
    $core.bool? tls,
    ProviderInstanceListSortBy? sortBy,
    SortDirection? sortDirection,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (providerType != null) result.providerType = providerType;
    if (search != null) result.search = search;
    if (enabled != null) result.enabled = enabled;
    if (tls != null) result.tls = tls;
    if (sortBy != null) result.sortBy = sortBy;
    if (sortDirection != null) result.sortDirection = sortDirection;
    return result;
  }

  ListProviderInstancesRequest._();

  factory ListProviderInstancesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProviderInstancesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProviderInstancesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'page')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aE<$0.SourceProvider>(3, _omitFieldNames ? '' : 'providerType',
        enumValues: $0.SourceProvider.values)
    ..aOS(4, _omitFieldNames ? '' : 'search')
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..aOB(6, _omitFieldNames ? '' : 'tls')
    ..aE<ProviderInstanceListSortBy>(7, _omitFieldNames ? '' : 'sortBy',
        enumValues: ProviderInstanceListSortBy.values)
    ..aE<SortDirection>(8, _omitFieldNames ? '' : 'sortDirection',
        enumValues: SortDirection.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProviderInstancesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProviderInstancesRequest copyWith(
          void Function(ListProviderInstancesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListProviderInstancesRequest))
          as ListProviderInstancesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProviderInstancesRequest create() =>
      ListProviderInstancesRequest._();
  @$core.override
  ListProviderInstancesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProviderInstancesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProviderInstancesRequest>(create);
  static ListProviderInstancesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get page => $_getIZ(0);
  @$pb.TagNumber(1)
  set page($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.SourceProvider get providerType => $_getN(2);
  @$pb.TagNumber(3)
  set providerType($0.SourceProvider value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProviderType() => $_has(2);
  @$pb.TagNumber(3)
  void clearProviderType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get search => $_getSZ(3);
  @$pb.TagNumber(4)
  set search($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(4);
  @$pb.TagNumber(5)
  set enabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnabled() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get tls => $_getBF(5);
  @$pb.TagNumber(6)
  set tls($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTls() => $_has(5);
  @$pb.TagNumber(6)
  void clearTls() => $_clearField(6);

  @$pb.TagNumber(7)
  ProviderInstanceListSortBy get sortBy => $_getN(6);
  @$pb.TagNumber(7)
  set sortBy(ProviderInstanceListSortBy value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortBy() => $_clearField(7);

  @$pb.TagNumber(8)
  SortDirection get sortDirection => $_getN(7);
  @$pb.TagNumber(8)
  set sortDirection(SortDirection value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSortDirection() => $_has(7);
  @$pb.TagNumber(8)
  void clearSortDirection() => $_clearField(8);
}

class ListProviderInstancesResponse extends $pb.GeneratedMessage {
  factory ListProviderInstancesResponse({
    $core.Iterable<ProviderInstance>? instances,
    $core.int? total,
  }) {
    final result = create();
    if (instances != null) result.instances.addAll(instances);
    if (total != null) result.total = total;
    return result;
  }

  ListProviderInstancesResponse._();

  factory ListProviderInstancesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProviderInstancesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProviderInstancesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..pPM<ProviderInstance>(1, _omitFieldNames ? '' : 'instances',
        subBuilder: ProviderInstance.create)
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProviderInstancesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProviderInstancesResponse copyWith(
          void Function(ListProviderInstancesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListProviderInstancesResponse))
          as ListProviderInstancesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProviderInstancesResponse create() =>
      ListProviderInstancesResponse._();
  @$core.override
  ListProviderInstancesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProviderInstancesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProviderInstancesResponse>(create);
  static ListProviderInstancesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProviderInstance> get instances => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class AddProviderInstanceRequest extends $pb.GeneratedMessage {
  factory AddProviderInstanceRequest({
    $core.String? name,
    $core.String? endpoint,
    $core.String? comment,
    $core.int? timeoutSeconds,
    $core.bool? tls,
    $core.bool? insecureTls,
    $core.Iterable<$0.SourceProvider>? providers,
    $core.String? jwtSecret,
    $core.String? customCa,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (endpoint != null) result.endpoint = endpoint;
    if (comment != null) result.comment = comment;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    if (tls != null) result.tls = tls;
    if (insecureTls != null) result.insecureTls = insecureTls;
    if (providers != null) result.providers.addAll(providers);
    if (jwtSecret != null) result.jwtSecret = jwtSecret;
    if (customCa != null) result.customCa = customCa;
    return result;
  }

  AddProviderInstanceRequest._();

  factory AddProviderInstanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddProviderInstanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddProviderInstanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'endpoint')
    ..aOS(3, _omitFieldNames ? '' : 'comment')
    ..aI(4, _omitFieldNames ? '' : 'timeoutSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(5, _omitFieldNames ? '' : 'tls')
    ..aOB(6, _omitFieldNames ? '' : 'insecureTls')
    ..pc<$0.SourceProvider>(
        7, _omitFieldNames ? '' : 'providers', $pb.PbFieldType.KE,
        valueOf: $0.SourceProvider.valueOf,
        enumValues: $0.SourceProvider.values,
        defaultEnumValue: $0.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED)
    ..aOS(8, _omitFieldNames ? '' : 'jwtSecret')
    ..aOS(9, _omitFieldNames ? '' : 'customCa')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddProviderInstanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddProviderInstanceRequest copyWith(
          void Function(AddProviderInstanceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AddProviderInstanceRequest))
          as AddProviderInstanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddProviderInstanceRequest create() => AddProviderInstanceRequest._();
  @$core.override
  AddProviderInstanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddProviderInstanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddProviderInstanceRequest>(create);
  static AddProviderInstanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get endpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set endpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get comment => $_getSZ(2);
  @$pb.TagNumber(3)
  set comment($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComment() => $_has(2);
  @$pb.TagNumber(3)
  void clearComment() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get timeoutSeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set timeoutSeconds($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimeoutSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeoutSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get tls => $_getBF(4);
  @$pb.TagNumber(5)
  set tls($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTls() => $_has(4);
  @$pb.TagNumber(5)
  void clearTls() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get insecureTls => $_getBF(5);
  @$pb.TagNumber(6)
  set insecureTls($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInsecureTls() => $_has(5);
  @$pb.TagNumber(6)
  void clearInsecureTls() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$0.SourceProvider> get providers => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get jwtSecret => $_getSZ(7);
  @$pb.TagNumber(8)
  set jwtSecret($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasJwtSecret() => $_has(7);
  @$pb.TagNumber(8)
  void clearJwtSecret() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get customCa => $_getSZ(8);
  @$pb.TagNumber(9)
  set customCa($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCustomCa() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustomCa() => $_clearField(9);
}

class AddProviderInstanceResponse extends $pb.GeneratedMessage {
  factory AddProviderInstanceResponse({
    ProviderInstance? instance,
  }) {
    final result = create();
    if (instance != null) result.instance = instance;
    return result;
  }

  AddProviderInstanceResponse._();

  factory AddProviderInstanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddProviderInstanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddProviderInstanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<ProviderInstance>(1, _omitFieldNames ? '' : 'instance',
        subBuilder: ProviderInstance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddProviderInstanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddProviderInstanceResponse copyWith(
          void Function(AddProviderInstanceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AddProviderInstanceResponse))
          as AddProviderInstanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddProviderInstanceResponse create() =>
      AddProviderInstanceResponse._();
  @$core.override
  AddProviderInstanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddProviderInstanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddProviderInstanceResponse>(create);
  static AddProviderInstanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProviderInstance get instance => $_getN(0);
  @$pb.TagNumber(1)
  set instance(ProviderInstance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);
  @$pb.TagNumber(1)
  ProviderInstance ensureInstance() => $_ensure(0);
}

class UpdateProviderInstanceRequest extends $pb.GeneratedMessage {
  factory UpdateProviderInstanceRequest({
    $core.String? name,
    $core.String? endpoint,
    $core.String? comment,
    $core.int? timeoutSeconds,
    $core.bool? tls,
    $core.bool? insecureTls,
    $core.Iterable<$0.SourceProvider>? providers,
    $core.String? jwtSecret,
    $core.String? customCa,
    $core.bool? clearComment_10,
    $core.bool? clearJwtSecret_11,
    $core.bool? clearCustomCa_12,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (endpoint != null) result.endpoint = endpoint;
    if (comment != null) result.comment = comment;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    if (tls != null) result.tls = tls;
    if (insecureTls != null) result.insecureTls = insecureTls;
    if (providers != null) result.providers.addAll(providers);
    if (jwtSecret != null) result.jwtSecret = jwtSecret;
    if (customCa != null) result.customCa = customCa;
    if (clearComment_10 != null) result.clearComment_10 = clearComment_10;
    if (clearJwtSecret_11 != null) result.clearJwtSecret_11 = clearJwtSecret_11;
    if (clearCustomCa_12 != null) result.clearCustomCa_12 = clearCustomCa_12;
    return result;
  }

  UpdateProviderInstanceRequest._();

  factory UpdateProviderInstanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProviderInstanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProviderInstanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'endpoint')
    ..aOS(3, _omitFieldNames ? '' : 'comment')
    ..aI(4, _omitFieldNames ? '' : 'timeoutSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..aOB(5, _omitFieldNames ? '' : 'tls')
    ..aOB(6, _omitFieldNames ? '' : 'insecureTls')
    ..pc<$0.SourceProvider>(
        7, _omitFieldNames ? '' : 'providers', $pb.PbFieldType.KE,
        valueOf: $0.SourceProvider.valueOf,
        enumValues: $0.SourceProvider.values,
        defaultEnumValue: $0.SourceProvider.SOURCE_PROVIDER_UNSPECIFIED)
    ..aOS(8, _omitFieldNames ? '' : 'jwtSecret')
    ..aOS(9, _omitFieldNames ? '' : 'customCa')
    ..aOB(10, _omitFieldNames ? '' : 'clearComment')
    ..aOB(11, _omitFieldNames ? '' : 'clearJwtSecret')
    ..aOB(12, _omitFieldNames ? '' : 'clearCustomCa')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderInstanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderInstanceRequest copyWith(
          void Function(UpdateProviderInstanceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateProviderInstanceRequest))
          as UpdateProviderInstanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProviderInstanceRequest create() =>
      UpdateProviderInstanceRequest._();
  @$core.override
  UpdateProviderInstanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProviderInstanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProviderInstanceRequest>(create);
  static UpdateProviderInstanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get endpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set endpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get comment => $_getSZ(2);
  @$pb.TagNumber(3)
  set comment($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasComment() => $_has(2);
  @$pb.TagNumber(3)
  void clearComment() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get timeoutSeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set timeoutSeconds($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimeoutSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeoutSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get tls => $_getBF(4);
  @$pb.TagNumber(5)
  set tls($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTls() => $_has(4);
  @$pb.TagNumber(5)
  void clearTls() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get insecureTls => $_getBF(5);
  @$pb.TagNumber(6)
  set insecureTls($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInsecureTls() => $_has(5);
  @$pb.TagNumber(6)
  void clearInsecureTls() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$0.SourceProvider> get providers => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get jwtSecret => $_getSZ(7);
  @$pb.TagNumber(8)
  set jwtSecret($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasJwtSecret() => $_has(7);
  @$pb.TagNumber(8)
  void clearJwtSecret() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get customCa => $_getSZ(8);
  @$pb.TagNumber(9)
  set customCa($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCustomCa() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustomCa() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get clearComment_10 => $_getBF(9);
  @$pb.TagNumber(10)
  set clearComment_10($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClearComment_10() => $_has(9);
  @$pb.TagNumber(10)
  void clearClearComment_10() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get clearJwtSecret_11 => $_getBF(10);
  @$pb.TagNumber(11)
  set clearJwtSecret_11($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClearJwtSecret_11() => $_has(10);
  @$pb.TagNumber(11)
  void clearClearJwtSecret_11() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get clearCustomCa_12 => $_getBF(11);
  @$pb.TagNumber(12)
  set clearCustomCa_12($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasClearCustomCa_12() => $_has(11);
  @$pb.TagNumber(12)
  void clearClearCustomCa_12() => $_clearField(12);
}

class UpdateProviderInstanceResponse extends $pb.GeneratedMessage {
  factory UpdateProviderInstanceResponse({
    ProviderInstance? instance,
  }) {
    final result = create();
    if (instance != null) result.instance = instance;
    return result;
  }

  UpdateProviderInstanceResponse._();

  factory UpdateProviderInstanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateProviderInstanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProviderInstanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<ProviderInstance>(1, _omitFieldNames ? '' : 'instance',
        subBuilder: ProviderInstance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderInstanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProviderInstanceResponse copyWith(
          void Function(UpdateProviderInstanceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateProviderInstanceResponse))
          as UpdateProviderInstanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateProviderInstanceResponse create() =>
      UpdateProviderInstanceResponse._();
  @$core.override
  UpdateProviderInstanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateProviderInstanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateProviderInstanceResponse>(create);
  static UpdateProviderInstanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProviderInstance get instance => $_getN(0);
  @$pb.TagNumber(1)
  set instance(ProviderInstance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);
  @$pb.TagNumber(1)
  ProviderInstance ensureInstance() => $_ensure(0);
}

class DeleteProviderInstanceRequest extends $pb.GeneratedMessage {
  factory DeleteProviderInstanceRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  DeleteProviderInstanceRequest._();

  factory DeleteProviderInstanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteProviderInstanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProviderInstanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProviderInstanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProviderInstanceRequest copyWith(
          void Function(DeleteProviderInstanceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteProviderInstanceRequest))
          as DeleteProviderInstanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProviderInstanceRequest create() =>
      DeleteProviderInstanceRequest._();
  @$core.override
  DeleteProviderInstanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteProviderInstanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProviderInstanceRequest>(create);
  static DeleteProviderInstanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class DeleteProviderInstanceResponse extends $pb.GeneratedMessage {
  factory DeleteProviderInstanceResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  DeleteProviderInstanceResponse._();

  factory DeleteProviderInstanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteProviderInstanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteProviderInstanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProviderInstanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteProviderInstanceResponse copyWith(
          void Function(DeleteProviderInstanceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteProviderInstanceResponse))
          as DeleteProviderInstanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteProviderInstanceResponse create() =>
      DeleteProviderInstanceResponse._();
  @$core.override
  DeleteProviderInstanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteProviderInstanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteProviderInstanceResponse>(create);
  static DeleteProviderInstanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ReconnectProviderInstanceRequest extends $pb.GeneratedMessage {
  factory ReconnectProviderInstanceRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  ReconnectProviderInstanceRequest._();

  factory ReconnectProviderInstanceRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconnectProviderInstanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconnectProviderInstanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconnectProviderInstanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconnectProviderInstanceRequest copyWith(
          void Function(ReconnectProviderInstanceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReconnectProviderInstanceRequest))
          as ReconnectProviderInstanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconnectProviderInstanceRequest create() =>
      ReconnectProviderInstanceRequest._();
  @$core.override
  ReconnectProviderInstanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconnectProviderInstanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconnectProviderInstanceRequest>(
          create);
  static ReconnectProviderInstanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class ReconnectProviderInstanceResponse extends $pb.GeneratedMessage {
  factory ReconnectProviderInstanceResponse({
    ProviderInstance? instance,
  }) {
    final result = create();
    if (instance != null) result.instance = instance;
    return result;
  }

  ReconnectProviderInstanceResponse._();

  factory ReconnectProviderInstanceResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconnectProviderInstanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconnectProviderInstanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<ProviderInstance>(1, _omitFieldNames ? '' : 'instance',
        subBuilder: ProviderInstance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconnectProviderInstanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconnectProviderInstanceResponse copyWith(
          void Function(ReconnectProviderInstanceResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconnectProviderInstanceResponse))
          as ReconnectProviderInstanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconnectProviderInstanceResponse create() =>
      ReconnectProviderInstanceResponse._();
  @$core.override
  ReconnectProviderInstanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconnectProviderInstanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconnectProviderInstanceResponse>(
          create);
  static ReconnectProviderInstanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProviderInstance get instance => $_getN(0);
  @$pb.TagNumber(1)
  set instance(ProviderInstance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);
  @$pb.TagNumber(1)
  ProviderInstance ensureInstance() => $_ensure(0);
}

class EnableProviderInstanceRequest extends $pb.GeneratedMessage {
  factory EnableProviderInstanceRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  EnableProviderInstanceRequest._();

  factory EnableProviderInstanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnableProviderInstanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnableProviderInstanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableProviderInstanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableProviderInstanceRequest copyWith(
          void Function(EnableProviderInstanceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EnableProviderInstanceRequest))
          as EnableProviderInstanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableProviderInstanceRequest create() =>
      EnableProviderInstanceRequest._();
  @$core.override
  EnableProviderInstanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnableProviderInstanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnableProviderInstanceRequest>(create);
  static EnableProviderInstanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class EnableProviderInstanceResponse extends $pb.GeneratedMessage {
  factory EnableProviderInstanceResponse({
    ProviderInstance? instance,
  }) {
    final result = create();
    if (instance != null) result.instance = instance;
    return result;
  }

  EnableProviderInstanceResponse._();

  factory EnableProviderInstanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnableProviderInstanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnableProviderInstanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<ProviderInstance>(1, _omitFieldNames ? '' : 'instance',
        subBuilder: ProviderInstance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableProviderInstanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnableProviderInstanceResponse copyWith(
          void Function(EnableProviderInstanceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EnableProviderInstanceResponse))
          as EnableProviderInstanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnableProviderInstanceResponse create() =>
      EnableProviderInstanceResponse._();
  @$core.override
  EnableProviderInstanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnableProviderInstanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EnableProviderInstanceResponse>(create);
  static EnableProviderInstanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProviderInstance get instance => $_getN(0);
  @$pb.TagNumber(1)
  set instance(ProviderInstance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);
  @$pb.TagNumber(1)
  ProviderInstance ensureInstance() => $_ensure(0);
}

class DisableProviderInstanceRequest extends $pb.GeneratedMessage {
  factory DisableProviderInstanceRequest({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  DisableProviderInstanceRequest._();

  factory DisableProviderInstanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisableProviderInstanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisableProviderInstanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableProviderInstanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableProviderInstanceRequest copyWith(
          void Function(DisableProviderInstanceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DisableProviderInstanceRequest))
          as DisableProviderInstanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableProviderInstanceRequest create() =>
      DisableProviderInstanceRequest._();
  @$core.override
  DisableProviderInstanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisableProviderInstanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisableProviderInstanceRequest>(create);
  static DisableProviderInstanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class DisableProviderInstanceResponse extends $pb.GeneratedMessage {
  factory DisableProviderInstanceResponse({
    ProviderInstance? instance,
  }) {
    final result = create();
    if (instance != null) result.instance = instance;
    return result;
  }

  DisableProviderInstanceResponse._();

  factory DisableProviderInstanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisableProviderInstanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisableProviderInstanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aOM<ProviderInstance>(1, _omitFieldNames ? '' : 'instance',
        subBuilder: ProviderInstance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableProviderInstanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisableProviderInstanceResponse copyWith(
          void Function(DisableProviderInstanceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DisableProviderInstanceResponse))
          as DisableProviderInstanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisableProviderInstanceResponse create() =>
      DisableProviderInstanceResponse._();
  @$core.override
  DisableProviderInstanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisableProviderInstanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisableProviderInstanceResponse>(
          create);
  static DisableProviderInstanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProviderInstance get instance => $_getN(0);
  @$pb.TagNumber(1)
  set instance(ProviderInstance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);
  @$pb.TagNumber(1)
  ProviderInstance ensureInstance() => $_ensure(0);
}

class ListProviderBackendsRequest extends $pb.GeneratedMessage {
  factory ListProviderBackendsRequest({
    $0.SourceProvider? providerType,
  }) {
    final result = create();
    if (providerType != null) result.providerType = providerType;
    return result;
  }

  ListProviderBackendsRequest._();

  factory ListProviderBackendsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListProviderBackendsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListProviderBackendsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..aE<$0.SourceProvider>(1, _omitFieldNames ? '' : 'providerType',
        enumValues: $0.SourceProvider.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProviderBackendsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListProviderBackendsRequest copyWith(
          void Function(ListProviderBackendsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListProviderBackendsRequest))
          as ListProviderBackendsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListProviderBackendsRequest create() =>
      ListProviderBackendsRequest._();
  @$core.override
  ListProviderBackendsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListProviderBackendsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListProviderBackendsRequest>(create);
  static ListProviderBackendsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SourceProvider get providerType => $_getN(0);
  @$pb.TagNumber(1)
  set providerType($0.SourceProvider value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProviderType() => $_has(0);
  @$pb.TagNumber(1)
  void clearProviderType() => $_clearField(1);
}

class ProviderInstancesResponse extends $pb.GeneratedMessage {
  factory ProviderInstancesResponse({
    $core.Iterable<$core.String>? instances,
  }) {
    final result = create();
    if (instances != null) result.instances.addAll(instances);
    return result;
  }

  ProviderInstancesResponse._();

  factory ProviderInstancesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderInstancesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderInstancesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'instances')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderInstancesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderInstancesResponse copyWith(
          void Function(ProviderInstancesResponse) updates) =>
      super.copyWith((message) => updates(message as ProviderInstancesResponse))
          as ProviderInstancesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderInstancesResponse create() => ProviderInstancesResponse._();
  @$core.override
  ProviderInstancesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderInstancesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderInstancesResponse>(create);
  static ProviderInstancesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get instances => $_getList(0);
}

class ProviderBackendsResponse extends $pb.GeneratedMessage {
  factory ProviderBackendsResponse({
    $core.Iterable<$core.String>? backends,
  }) {
    final result = create();
    if (backends != null) result.backends.addAll(backends);
    return result;
  }

  ProviderBackendsResponse._();

  factory ProviderBackendsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProviderBackendsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProviderBackendsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.common'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'backends')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderBackendsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProviderBackendsResponse copyWith(
          void Function(ProviderBackendsResponse) updates) =>
      super.copyWith((message) => updates(message as ProviderBackendsResponse))
          as ProviderBackendsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProviderBackendsResponse create() => ProviderBackendsResponse._();
  @$core.override
  ProviderBackendsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProviderBackendsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProviderBackendsResponse>(create);
  static ProviderBackendsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get backends => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
