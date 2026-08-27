// This is a generated file - do not edit.
//
// Generated from proto/source_config.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'source_config.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'source_config.pbenum.dart';

class DirectUrlMediaResourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlMediaResourceConfig({
    $core.String? name,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  DirectUrlMediaResourceConfig._();

  factory DirectUrlMediaResourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlMediaResourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlMediaResourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'headers',
        entryClassName: 'DirectUrlMediaResourceConfig.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.source_config'))
    ..aOS(4, _omitFieldNames ? '' : 'format')
    ..aInt64(5, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlMediaResourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlMediaResourceConfig copyWith(
          void Function(DirectUrlMediaResourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlMediaResourceConfig))
          as DirectUrlMediaResourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlMediaResourceConfig create() =>
      DirectUrlMediaResourceConfig._();
  @$core.override
  DirectUrlMediaResourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlMediaResourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlMediaResourceConfig>(create);
  static DirectUrlMediaResourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get format => $_getSZ(3);
  @$pb.TagNumber(4)
  set format($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiresAt => $_getI64(4);
  @$pb.TagNumber(5)
  set expiresAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
}

class DirectUrlSubtitleSourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlSubtitleSourceConfig({
    $core.String? name,
    $core.String? language,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (language != null) result.language = language;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  DirectUrlSubtitleSourceConfig._();

  factory DirectUrlSubtitleSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlSubtitleSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlSubtitleSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'language')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'headers',
        entryClassName: 'DirectUrlSubtitleSourceConfig.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.source_config'))
    ..aOS(5, _omitFieldNames ? '' : 'format')
    ..aInt64(6, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlSubtitleSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlSubtitleSourceConfig copyWith(
          void Function(DirectUrlSubtitleSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlSubtitleSourceConfig))
          as DirectUrlSubtitleSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlSubtitleSourceConfig create() =>
      DirectUrlSubtitleSourceConfig._();
  @$core.override
  DirectUrlSubtitleSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlSubtitleSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlSubtitleSourceConfig>(create);
  static DirectUrlSubtitleSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(3);

  @$pb.TagNumber(5)
  $core.String get format => $_getSZ(4);
  @$pb.TagNumber(5)
  set format($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expiresAt => $_getI64(5);
  @$pb.TagNumber(6)
  set expiresAt($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAt() => $_clearField(6);
}

class DirectUrlDanmakuSourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlDanmakuSourceConfig({
    $core.String? name,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  DirectUrlDanmakuSourceConfig._();

  factory DirectUrlDanmakuSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlDanmakuSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlDanmakuSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'headers',
        entryClassName: 'DirectUrlDanmakuSourceConfig.HeadersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('synctv.source_config'))
    ..aOS(4, _omitFieldNames ? '' : 'format')
    ..aInt64(5, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlDanmakuSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlDanmakuSourceConfig copyWith(
          void Function(DirectUrlDanmakuSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlDanmakuSourceConfig))
          as DirectUrlDanmakuSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlDanmakuSourceConfig create() =>
      DirectUrlDanmakuSourceConfig._();
  @$core.override
  DirectUrlDanmakuSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlDanmakuSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlDanmakuSourceConfig>(create);
  static DirectUrlDanmakuSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get headers => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get format => $_getSZ(3);
  @$pb.TagNumber(4)
  set format($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiresAt => $_getI64(4);
  @$pb.TagNumber(5)
  set expiresAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
}

class DirectUrlMediaSourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlMediaSourceConfig({
    $core.Iterable<DirectUrlMediaResourceConfig>? medias,
    $core.int? defaultMediaIndex,
    $core.Iterable<DirectUrlSubtitleSourceConfig>? subtitles,
    $core.int? defaultSubtitleIndex,
    $core.Iterable<DirectUrlDanmakuSourceConfig>? danmakus,
    $core.int? defaultDanmakuIndex,
    PlaybackKind? playbackKind,
    $core.double? durationSeconds,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (medias != null) result.medias.addAll(medias);
    if (defaultMediaIndex != null) result.defaultMediaIndex = defaultMediaIndex;
    if (subtitles != null) result.subtitles.addAll(subtitles);
    if (defaultSubtitleIndex != null)
      result.defaultSubtitleIndex = defaultSubtitleIndex;
    if (danmakus != null) result.danmakus.addAll(danmakus);
    if (defaultDanmakuIndex != null)
      result.defaultDanmakuIndex = defaultDanmakuIndex;
    if (playbackKind != null) result.playbackKind = playbackKind;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  DirectUrlMediaSourceConfig._();

  factory DirectUrlMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DirectUrlMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DirectUrlMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..pPM<DirectUrlMediaResourceConfig>(1, _omitFieldNames ? '' : 'medias',
        subBuilder: DirectUrlMediaResourceConfig.create)
    ..aI(2, _omitFieldNames ? '' : 'defaultMediaIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<DirectUrlSubtitleSourceConfig>(3, _omitFieldNames ? '' : 'subtitles',
        subBuilder: DirectUrlSubtitleSourceConfig.create)
    ..aI(4, _omitFieldNames ? '' : 'defaultSubtitleIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..pPM<DirectUrlDanmakuSourceConfig>(5, _omitFieldNames ? '' : 'danmakus',
        subBuilder: DirectUrlDanmakuSourceConfig.create)
    ..aI(6, _omitFieldNames ? '' : 'defaultDanmakuIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..aE<PlaybackKind>(7, _omitFieldNames ? '' : 'playbackKind',
        enumValues: PlaybackKind.values)
    ..aD(8, _omitFieldNames ? '' : 'durationSeconds')
    ..aE<PlaybackProxyMode>(9, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DirectUrlMediaSourceConfig copyWith(
          void Function(DirectUrlMediaSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as DirectUrlMediaSourceConfig))
          as DirectUrlMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DirectUrlMediaSourceConfig create() => DirectUrlMediaSourceConfig._();
  @$core.override
  DirectUrlMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DirectUrlMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DirectUrlMediaSourceConfig>(create);
  static DirectUrlMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DirectUrlMediaResourceConfig> get medias => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get defaultMediaIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set defaultMediaIndex($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultMediaIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultMediaIndex() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<DirectUrlSubtitleSourceConfig> get subtitles => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get defaultSubtitleIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set defaultSubtitleIndex($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefaultSubtitleIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultSubtitleIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<DirectUrlDanmakuSourceConfig> get danmakus => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get defaultDanmakuIndex => $_getIZ(5);
  @$pb.TagNumber(6)
  set defaultDanmakuIndex($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDefaultDanmakuIndex() => $_has(5);
  @$pb.TagNumber(6)
  void clearDefaultDanmakuIndex() => $_clearField(6);

  @$pb.TagNumber(7)
  PlaybackKind get playbackKind => $_getN(6);
  @$pb.TagNumber(7)
  set playbackKind(PlaybackKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlaybackKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlaybackKind() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get durationSeconds => $_getN(7);
  @$pb.TagNumber(8)
  set durationSeconds($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  PlaybackProxyMode get proxyMode => $_getN(8);
  @$pb.TagNumber(9)
  set proxyMode(PlaybackProxyMode value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasProxyMode() => $_has(8);
  @$pb.TagNumber(9)
  void clearProxyMode() => $_clearField(9);
}

class AlistMediaSourceConfig extends $pb.GeneratedMessage {
  factory AlistMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
    $core.String? password,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (password != null) result.password = password;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  AlistMediaSourceConfig._();

  factory AlistMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AlistMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlistMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlistMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlistMediaSourceConfig copyWith(
          void Function(AlistMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as AlistMediaSourceConfig))
          as AlistMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AlistMediaSourceConfig create() => AlistMediaSourceConfig._();
  @$core.override
  AlistMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AlistMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AlistMediaSourceConfig>(create);
  static AlistMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class AlistPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory AlistPlaylistSourceConfig({
    $core.String? serverId,
    $core.String? path,
    $core.String? password,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (password != null) result.password = password;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  AlistPlaylistSourceConfig._();

  factory AlistPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AlistPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlistPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlistPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlistPlaylistSourceConfig copyWith(
          void Function(AlistPlaylistSourceConfig) updates) =>
      super.copyWith((message) => updates(message as AlistPlaylistSourceConfig))
          as AlistPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AlistPlaylistSourceConfig create() => AlistPlaylistSourceConfig._();
  @$core.override
  AlistPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AlistPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AlistPlaylistSourceConfig>(create);
  static AlistPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class CloudreveMediaSourceConfig extends $pb.GeneratedMessage {
  factory CloudreveMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  CloudreveMediaSourceConfig._();

  factory CloudreveMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudreveMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloudreveMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aE<PlaybackProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudreveMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudreveMediaSourceConfig copyWith(
          void Function(CloudreveMediaSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as CloudreveMediaSourceConfig))
          as CloudreveMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudreveMediaSourceConfig create() => CloudreveMediaSourceConfig._();
  @$core.override
  CloudreveMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudreveMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloudreveMediaSourceConfig>(create);
  static CloudreveMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(PlaybackProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);
}

class CloudrevePlaylistSourceConfig extends $pb.GeneratedMessage {
  factory CloudrevePlaylistSourceConfig({
    $core.String? serverId,
    $core.String? path,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  CloudrevePlaylistSourceConfig._();

  factory CloudrevePlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudrevePlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloudrevePlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aE<PlaybackProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudrevePlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudrevePlaylistSourceConfig copyWith(
          void Function(CloudrevePlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as CloudrevePlaylistSourceConfig))
          as CloudrevePlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudrevePlaylistSourceConfig create() =>
      CloudrevePlaylistSourceConfig._();
  @$core.override
  CloudrevePlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloudrevePlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloudrevePlaylistSourceConfig>(create);
  static CloudrevePlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(PlaybackProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);
}

class EmbyMediaSourceConfig extends $pb.GeneratedMessage {
  factory EmbyMediaSourceConfig({
    $core.String? serverId,
    $core.String? itemId,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (itemId != null) result.itemId = itemId;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  EmbyMediaSourceConfig._();

  factory EmbyMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aE<PlaybackProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyMediaSourceConfig copyWith(
          void Function(EmbyMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as EmbyMediaSourceConfig))
          as EmbyMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyMediaSourceConfig create() => EmbyMediaSourceConfig._();
  @$core.override
  EmbyMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyMediaSourceConfig>(create);
  static EmbyMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(PlaybackProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);
}

enum EmbyPlaylistSourceConfig_Source {
  folder,
  favoriteItems,
  favoritePeople,
  personItems,
  continueWatching,
  nextUp,
  recentlyAdded,
  playlists,
  collections,
  genres,
  genreItems,
  notSet
}

class EmbyPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory EmbyPlaylistSourceConfig({
    $core.String? serverId,
    EmbyFolderPlaylistSource? folder,
    EmbyFavoriteItemsPlaylistSource? favoriteItems,
    EmbyFavoritePeoplePlaylistSource? favoritePeople,
    EmbyPersonItemsPlaylistSource? personItems,
    EmbyContinueWatchingPlaylistSource? continueWatching,
    EmbyNextUpPlaylistSource? nextUp,
    EmbyRecentlyAddedPlaylistSource? recentlyAdded,
    EmbyPlaylistsPlaylistSource? playlists,
    EmbyCollectionsPlaylistSource? collections,
    EmbyGenresPlaylistSource? genres,
    EmbyGenreItemsPlaylistSource? genreItems,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (folder != null) result.folder = folder;
    if (favoriteItems != null) result.favoriteItems = favoriteItems;
    if (favoritePeople != null) result.favoritePeople = favoritePeople;
    if (personItems != null) result.personItems = personItems;
    if (continueWatching != null) result.continueWatching = continueWatching;
    if (nextUp != null) result.nextUp = nextUp;
    if (recentlyAdded != null) result.recentlyAdded = recentlyAdded;
    if (playlists != null) result.playlists = playlists;
    if (collections != null) result.collections = collections;
    if (genres != null) result.genres = genres;
    if (genreItems != null) result.genreItems = genreItems;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  EmbyPlaylistSourceConfig._();

  factory EmbyPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, EmbyPlaylistSourceConfig_Source>
      _EmbyPlaylistSourceConfig_SourceByTag = {
    2: EmbyPlaylistSourceConfig_Source.folder,
    3: EmbyPlaylistSourceConfig_Source.favoriteItems,
    4: EmbyPlaylistSourceConfig_Source.favoritePeople,
    5: EmbyPlaylistSourceConfig_Source.personItems,
    6: EmbyPlaylistSourceConfig_Source.continueWatching,
    7: EmbyPlaylistSourceConfig_Source.nextUp,
    8: EmbyPlaylistSourceConfig_Source.recentlyAdded,
    9: EmbyPlaylistSourceConfig_Source.playlists,
    10: EmbyPlaylistSourceConfig_Source.collections,
    11: EmbyPlaylistSourceConfig_Source.genres,
    12: EmbyPlaylistSourceConfig_Source.genreItems,
    0: EmbyPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<EmbyFolderPlaylistSource>(2, _omitFieldNames ? '' : 'folder',
        subBuilder: EmbyFolderPlaylistSource.create)
    ..aOM<EmbyFavoriteItemsPlaylistSource>(
        3, _omitFieldNames ? '' : 'favoriteItems',
        subBuilder: EmbyFavoriteItemsPlaylistSource.create)
    ..aOM<EmbyFavoritePeoplePlaylistSource>(
        4, _omitFieldNames ? '' : 'favoritePeople',
        subBuilder: EmbyFavoritePeoplePlaylistSource.create)
    ..aOM<EmbyPersonItemsPlaylistSource>(
        5, _omitFieldNames ? '' : 'personItems',
        subBuilder: EmbyPersonItemsPlaylistSource.create)
    ..aOM<EmbyContinueWatchingPlaylistSource>(
        6, _omitFieldNames ? '' : 'continueWatching',
        subBuilder: EmbyContinueWatchingPlaylistSource.create)
    ..aOM<EmbyNextUpPlaylistSource>(7, _omitFieldNames ? '' : 'nextUp',
        subBuilder: EmbyNextUpPlaylistSource.create)
    ..aOM<EmbyRecentlyAddedPlaylistSource>(
        8, _omitFieldNames ? '' : 'recentlyAdded',
        subBuilder: EmbyRecentlyAddedPlaylistSource.create)
    ..aOM<EmbyPlaylistsPlaylistSource>(9, _omitFieldNames ? '' : 'playlists',
        subBuilder: EmbyPlaylistsPlaylistSource.create)
    ..aOM<EmbyCollectionsPlaylistSource>(
        10, _omitFieldNames ? '' : 'collections',
        subBuilder: EmbyCollectionsPlaylistSource.create)
    ..aOM<EmbyGenresPlaylistSource>(11, _omitFieldNames ? '' : 'genres',
        subBuilder: EmbyGenresPlaylistSource.create)
    ..aOM<EmbyGenreItemsPlaylistSource>(12, _omitFieldNames ? '' : 'genreItems',
        subBuilder: EmbyGenreItemsPlaylistSource.create)
    ..aE<PlaybackProxyMode>(13, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyPlaylistSourceConfig copyWith(
          void Function(EmbyPlaylistSourceConfig) updates) =>
      super.copyWith((message) => updates(message as EmbyPlaylistSourceConfig))
          as EmbyPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyPlaylistSourceConfig create() => EmbyPlaylistSourceConfig._();
  @$core.override
  EmbyPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyPlaylistSourceConfig>(create);
  static EmbyPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  EmbyPlaylistSourceConfig_Source whichSource() =>
      _EmbyPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  EmbyFolderPlaylistSource get folder => $_getN(1);
  @$pb.TagNumber(2)
  set folder(EmbyFolderPlaylistSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => $_clearField(2);
  @$pb.TagNumber(2)
  EmbyFolderPlaylistSource ensureFolder() => $_ensure(1);

  @$pb.TagNumber(3)
  EmbyFavoriteItemsPlaylistSource get favoriteItems => $_getN(2);
  @$pb.TagNumber(3)
  set favoriteItems(EmbyFavoriteItemsPlaylistSource value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFavoriteItems() => $_has(2);
  @$pb.TagNumber(3)
  void clearFavoriteItems() => $_clearField(3);
  @$pb.TagNumber(3)
  EmbyFavoriteItemsPlaylistSource ensureFavoriteItems() => $_ensure(2);

  @$pb.TagNumber(4)
  EmbyFavoritePeoplePlaylistSource get favoritePeople => $_getN(3);
  @$pb.TagNumber(4)
  set favoritePeople(EmbyFavoritePeoplePlaylistSource value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFavoritePeople() => $_has(3);
  @$pb.TagNumber(4)
  void clearFavoritePeople() => $_clearField(4);
  @$pb.TagNumber(4)
  EmbyFavoritePeoplePlaylistSource ensureFavoritePeople() => $_ensure(3);

  @$pb.TagNumber(5)
  EmbyPersonItemsPlaylistSource get personItems => $_getN(4);
  @$pb.TagNumber(5)
  set personItems(EmbyPersonItemsPlaylistSource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPersonItems() => $_has(4);
  @$pb.TagNumber(5)
  void clearPersonItems() => $_clearField(5);
  @$pb.TagNumber(5)
  EmbyPersonItemsPlaylistSource ensurePersonItems() => $_ensure(4);

  @$pb.TagNumber(6)
  EmbyContinueWatchingPlaylistSource get continueWatching => $_getN(5);
  @$pb.TagNumber(6)
  set continueWatching(EmbyContinueWatchingPlaylistSource value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasContinueWatching() => $_has(5);
  @$pb.TagNumber(6)
  void clearContinueWatching() => $_clearField(6);
  @$pb.TagNumber(6)
  EmbyContinueWatchingPlaylistSource ensureContinueWatching() => $_ensure(5);

  @$pb.TagNumber(7)
  EmbyNextUpPlaylistSource get nextUp => $_getN(6);
  @$pb.TagNumber(7)
  set nextUp(EmbyNextUpPlaylistSource value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNextUp() => $_has(6);
  @$pb.TagNumber(7)
  void clearNextUp() => $_clearField(7);
  @$pb.TagNumber(7)
  EmbyNextUpPlaylistSource ensureNextUp() => $_ensure(6);

  @$pb.TagNumber(8)
  EmbyRecentlyAddedPlaylistSource get recentlyAdded => $_getN(7);
  @$pb.TagNumber(8)
  set recentlyAdded(EmbyRecentlyAddedPlaylistSource value) =>
      $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRecentlyAdded() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecentlyAdded() => $_clearField(8);
  @$pb.TagNumber(8)
  EmbyRecentlyAddedPlaylistSource ensureRecentlyAdded() => $_ensure(7);

  @$pb.TagNumber(9)
  EmbyPlaylistsPlaylistSource get playlists => $_getN(8);
  @$pb.TagNumber(9)
  set playlists(EmbyPlaylistsPlaylistSource value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPlaylists() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlaylists() => $_clearField(9);
  @$pb.TagNumber(9)
  EmbyPlaylistsPlaylistSource ensurePlaylists() => $_ensure(8);

  @$pb.TagNumber(10)
  EmbyCollectionsPlaylistSource get collections => $_getN(9);
  @$pb.TagNumber(10)
  set collections(EmbyCollectionsPlaylistSource value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCollections() => $_has(9);
  @$pb.TagNumber(10)
  void clearCollections() => $_clearField(10);
  @$pb.TagNumber(10)
  EmbyCollectionsPlaylistSource ensureCollections() => $_ensure(9);

  @$pb.TagNumber(11)
  EmbyGenresPlaylistSource get genres => $_getN(10);
  @$pb.TagNumber(11)
  set genres(EmbyGenresPlaylistSource value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasGenres() => $_has(10);
  @$pb.TagNumber(11)
  void clearGenres() => $_clearField(11);
  @$pb.TagNumber(11)
  EmbyGenresPlaylistSource ensureGenres() => $_ensure(10);

  @$pb.TagNumber(12)
  EmbyGenreItemsPlaylistSource get genreItems => $_getN(11);
  @$pb.TagNumber(12)
  set genreItems(EmbyGenreItemsPlaylistSource value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasGenreItems() => $_has(11);
  @$pb.TagNumber(12)
  void clearGenreItems() => $_clearField(12);
  @$pb.TagNumber(12)
  EmbyGenreItemsPlaylistSource ensureGenreItems() => $_ensure(11);

  @$pb.TagNumber(13)
  PlaybackProxyMode get proxyMode => $_getN(12);
  @$pb.TagNumber(13)
  set proxyMode(PlaybackProxyMode value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasProxyMode() => $_has(12);
  @$pb.TagNumber(13)
  void clearProxyMode() => $_clearField(13);
}

class EmbyFolderPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyFolderPlaylistSource({
    $core.String? itemId,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    return result;
  }

  EmbyFolderPlaylistSource._();

  factory EmbyFolderPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyFolderPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyFolderPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyFolderPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyFolderPlaylistSource copyWith(
          void Function(EmbyFolderPlaylistSource) updates) =>
      super.copyWith((message) => updates(message as EmbyFolderPlaylistSource))
          as EmbyFolderPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyFolderPlaylistSource create() => EmbyFolderPlaylistSource._();
  @$core.override
  EmbyFolderPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyFolderPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyFolderPlaylistSource>(create);
  static EmbyFolderPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);
}

class EmbyFavoriteItemsPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyFavoriteItemsPlaylistSource({
    $core.Iterable<$core.String>? itemTypes,
  }) {
    final result = create();
    if (itemTypes != null) result.itemTypes.addAll(itemTypes);
    return result;
  }

  EmbyFavoriteItemsPlaylistSource._();

  factory EmbyFavoriteItemsPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyFavoriteItemsPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyFavoriteItemsPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'itemTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyFavoriteItemsPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyFavoriteItemsPlaylistSource copyWith(
          void Function(EmbyFavoriteItemsPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyFavoriteItemsPlaylistSource))
          as EmbyFavoriteItemsPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyFavoriteItemsPlaylistSource create() =>
      EmbyFavoriteItemsPlaylistSource._();
  @$core.override
  EmbyFavoriteItemsPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyFavoriteItemsPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyFavoriteItemsPlaylistSource>(
          create);
  static EmbyFavoriteItemsPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get itemTypes => $_getList(0);
}

class EmbyFavoritePeoplePlaylistSource extends $pb.GeneratedMessage {
  factory EmbyFavoritePeoplePlaylistSource() => create();

  EmbyFavoritePeoplePlaylistSource._();

  factory EmbyFavoritePeoplePlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyFavoritePeoplePlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyFavoritePeoplePlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyFavoritePeoplePlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyFavoritePeoplePlaylistSource copyWith(
          void Function(EmbyFavoritePeoplePlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyFavoritePeoplePlaylistSource))
          as EmbyFavoritePeoplePlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyFavoritePeoplePlaylistSource create() =>
      EmbyFavoritePeoplePlaylistSource._();
  @$core.override
  EmbyFavoritePeoplePlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyFavoritePeoplePlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyFavoritePeoplePlaylistSource>(
          create);
  static EmbyFavoritePeoplePlaylistSource? _defaultInstance;
}

class EmbyPersonItemsPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyPersonItemsPlaylistSource({
    $core.String? personId,
    $core.Iterable<$core.String>? itemTypes,
  }) {
    final result = create();
    if (personId != null) result.personId = personId;
    if (itemTypes != null) result.itemTypes.addAll(itemTypes);
    return result;
  }

  EmbyPersonItemsPlaylistSource._();

  factory EmbyPersonItemsPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyPersonItemsPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyPersonItemsPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'personId')
    ..pPS(2, _omitFieldNames ? '' : 'itemTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyPersonItemsPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyPersonItemsPlaylistSource copyWith(
          void Function(EmbyPersonItemsPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyPersonItemsPlaylistSource))
          as EmbyPersonItemsPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyPersonItemsPlaylistSource create() =>
      EmbyPersonItemsPlaylistSource._();
  @$core.override
  EmbyPersonItemsPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyPersonItemsPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyPersonItemsPlaylistSource>(create);
  static EmbyPersonItemsPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get personId => $_getSZ(0);
  @$pb.TagNumber(1)
  set personId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPersonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPersonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get itemTypes => $_getList(1);
}

class EmbyContinueWatchingPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyContinueWatchingPlaylistSource() => create();

  EmbyContinueWatchingPlaylistSource._();

  factory EmbyContinueWatchingPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyContinueWatchingPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyContinueWatchingPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyContinueWatchingPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyContinueWatchingPlaylistSource copyWith(
          void Function(EmbyContinueWatchingPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as EmbyContinueWatchingPlaylistSource))
          as EmbyContinueWatchingPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyContinueWatchingPlaylistSource create() =>
      EmbyContinueWatchingPlaylistSource._();
  @$core.override
  EmbyContinueWatchingPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyContinueWatchingPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyContinueWatchingPlaylistSource>(
          create);
  static EmbyContinueWatchingPlaylistSource? _defaultInstance;
}

class EmbyNextUpPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyNextUpPlaylistSource() => create();

  EmbyNextUpPlaylistSource._();

  factory EmbyNextUpPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyNextUpPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyNextUpPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyNextUpPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyNextUpPlaylistSource copyWith(
          void Function(EmbyNextUpPlaylistSource) updates) =>
      super.copyWith((message) => updates(message as EmbyNextUpPlaylistSource))
          as EmbyNextUpPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyNextUpPlaylistSource create() => EmbyNextUpPlaylistSource._();
  @$core.override
  EmbyNextUpPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyNextUpPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyNextUpPlaylistSource>(create);
  static EmbyNextUpPlaylistSource? _defaultInstance;
}

class EmbyRecentlyAddedPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyRecentlyAddedPlaylistSource({
    $core.Iterable<$core.String>? itemTypes,
  }) {
    final result = create();
    if (itemTypes != null) result.itemTypes.addAll(itemTypes);
    return result;
  }

  EmbyRecentlyAddedPlaylistSource._();

  factory EmbyRecentlyAddedPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyRecentlyAddedPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyRecentlyAddedPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'itemTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyRecentlyAddedPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyRecentlyAddedPlaylistSource copyWith(
          void Function(EmbyRecentlyAddedPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyRecentlyAddedPlaylistSource))
          as EmbyRecentlyAddedPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyRecentlyAddedPlaylistSource create() =>
      EmbyRecentlyAddedPlaylistSource._();
  @$core.override
  EmbyRecentlyAddedPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyRecentlyAddedPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyRecentlyAddedPlaylistSource>(
          create);
  static EmbyRecentlyAddedPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get itemTypes => $_getList(0);
}

class EmbyPlaylistsPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyPlaylistsPlaylistSource() => create();

  EmbyPlaylistsPlaylistSource._();

  factory EmbyPlaylistsPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyPlaylistsPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyPlaylistsPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyPlaylistsPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyPlaylistsPlaylistSource copyWith(
          void Function(EmbyPlaylistsPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyPlaylistsPlaylistSource))
          as EmbyPlaylistsPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyPlaylistsPlaylistSource create() =>
      EmbyPlaylistsPlaylistSource._();
  @$core.override
  EmbyPlaylistsPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyPlaylistsPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyPlaylistsPlaylistSource>(create);
  static EmbyPlaylistsPlaylistSource? _defaultInstance;
}

class EmbyCollectionsPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyCollectionsPlaylistSource() => create();

  EmbyCollectionsPlaylistSource._();

  factory EmbyCollectionsPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyCollectionsPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyCollectionsPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyCollectionsPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyCollectionsPlaylistSource copyWith(
          void Function(EmbyCollectionsPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyCollectionsPlaylistSource))
          as EmbyCollectionsPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyCollectionsPlaylistSource create() =>
      EmbyCollectionsPlaylistSource._();
  @$core.override
  EmbyCollectionsPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyCollectionsPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyCollectionsPlaylistSource>(create);
  static EmbyCollectionsPlaylistSource? _defaultInstance;
}

class EmbyGenresPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyGenresPlaylistSource({
    $core.Iterable<$core.String>? itemTypes,
  }) {
    final result = create();
    if (itemTypes != null) result.itemTypes.addAll(itemTypes);
    return result;
  }

  EmbyGenresPlaylistSource._();

  factory EmbyGenresPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyGenresPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyGenresPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'itemTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyGenresPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyGenresPlaylistSource copyWith(
          void Function(EmbyGenresPlaylistSource) updates) =>
      super.copyWith((message) => updates(message as EmbyGenresPlaylistSource))
          as EmbyGenresPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyGenresPlaylistSource create() => EmbyGenresPlaylistSource._();
  @$core.override
  EmbyGenresPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyGenresPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyGenresPlaylistSource>(create);
  static EmbyGenresPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get itemTypes => $_getList(0);
}

class EmbyGenreItemsPlaylistSource extends $pb.GeneratedMessage {
  factory EmbyGenreItemsPlaylistSource({
    $core.String? genreId,
    $core.Iterable<$core.String>? itemTypes,
  }) {
    final result = create();
    if (genreId != null) result.genreId = genreId;
    if (itemTypes != null) result.itemTypes.addAll(itemTypes);
    return result;
  }

  EmbyGenreItemsPlaylistSource._();

  factory EmbyGenreItemsPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyGenreItemsPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyGenreItemsPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'genreId')
    ..pPS(2, _omitFieldNames ? '' : 'itemTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyGenreItemsPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmbyGenreItemsPlaylistSource copyWith(
          void Function(EmbyGenreItemsPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as EmbyGenreItemsPlaylistSource))
          as EmbyGenreItemsPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmbyGenreItemsPlaylistSource create() =>
      EmbyGenreItemsPlaylistSource._();
  @$core.override
  EmbyGenreItemsPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmbyGenreItemsPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmbyGenreItemsPlaylistSource>(create);
  static EmbyGenreItemsPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get genreId => $_getSZ(0);
  @$pb.TagNumber(1)
  set genreId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGenreId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGenreId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get itemTypes => $_getList(1);
}

class RtmpMediaSourceConfig extends $pb.GeneratedMessage {
  factory RtmpMediaSourceConfig({
    RtmpStreamMode? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  RtmpMediaSourceConfig._();

  factory RtmpMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aE<RtmpStreamMode>(1, _omitFieldNames ? '' : 'mode',
        enumValues: RtmpStreamMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpMediaSourceConfig copyWith(
          void Function(RtmpMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as RtmpMediaSourceConfig))
          as RtmpMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpMediaSourceConfig create() => RtmpMediaSourceConfig._();
  @$core.override
  RtmpMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpMediaSourceConfig>(create);
  static RtmpMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  RtmpStreamMode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode(RtmpStreamMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => $_clearField(1);
}

enum RtspTrackSelection_Mode { firstCompatible, index_, disabled, notSet }

class RtspTrackSelection extends $pb.GeneratedMessage {
  factory RtspTrackSelection({
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

  RtspTrackSelection._();

  factory RtspTrackSelection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtspTrackSelection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RtspTrackSelection_Mode>
      _RtspTrackSelection_ModeByTag = {
    1: RtspTrackSelection_Mode.firstCompatible,
    2: RtspTrackSelection_Mode.index_,
    3: RtspTrackSelection_Mode.disabled,
    0: RtspTrackSelection_Mode.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtspTrackSelection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOB(1, _omitFieldNames ? '' : 'firstCompatible')
    ..aI(2, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'disabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtspTrackSelection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtspTrackSelection copyWith(void Function(RtspTrackSelection) updates) =>
      super.copyWith((message) => updates(message as RtspTrackSelection))
          as RtspTrackSelection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtspTrackSelection create() => RtspTrackSelection._();
  @$core.override
  RtspTrackSelection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtspTrackSelection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtspTrackSelection>(create);
  static RtspTrackSelection? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  RtspTrackSelection_Mode whichMode() =>
      _RtspTrackSelection_ModeByTag[$_whichOneof(0)]!;
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

class RtmpPullSourceConfig extends $pb.GeneratedMessage {
  factory RtmpPullSourceConfig({
    $core.String? url,
    RtmpStreamMode? mode,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (mode != null) result.mode = mode;
    return result;
  }

  RtmpPullSourceConfig._();

  factory RtmpPullSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtmpPullSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtmpPullSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<RtmpStreamMode>(2, _omitFieldNames ? '' : 'mode',
        enumValues: RtmpStreamMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpPullSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtmpPullSourceConfig copyWith(void Function(RtmpPullSourceConfig) updates) =>
      super.copyWith((message) => updates(message as RtmpPullSourceConfig))
          as RtmpPullSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtmpPullSourceConfig create() => RtmpPullSourceConfig._();
  @$core.override
  RtmpPullSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtmpPullSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtmpPullSourceConfig>(create);
  static RtmpPullSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  RtmpStreamMode get mode => $_getN(1);
  @$pb.TagNumber(2)
  set mode(RtmpStreamMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);
}

class RtspPullSourceConfig extends $pb.GeneratedMessage {
  factory RtspPullSourceConfig({
    $core.String? url,
    RtspTransport? transport,
    RtspTrackSelection? videoTrack,
    RtspTrackSelection? audioTrack,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (transport != null) result.transport = transport;
    if (videoTrack != null) result.videoTrack = videoTrack;
    if (audioTrack != null) result.audioTrack = audioTrack;
    return result;
  }

  RtspPullSourceConfig._();

  factory RtspPullSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RtspPullSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RtspPullSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<RtspTransport>(2, _omitFieldNames ? '' : 'transport',
        enumValues: RtspTransport.values)
    ..aOM<RtspTrackSelection>(3, _omitFieldNames ? '' : 'videoTrack',
        subBuilder: RtspTrackSelection.create)
    ..aOM<RtspTrackSelection>(4, _omitFieldNames ? '' : 'audioTrack',
        subBuilder: RtspTrackSelection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtspPullSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RtspPullSourceConfig copyWith(void Function(RtspPullSourceConfig) updates) =>
      super.copyWith((message) => updates(message as RtspPullSourceConfig))
          as RtspPullSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RtspPullSourceConfig create() => RtspPullSourceConfig._();
  @$core.override
  RtspPullSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RtspPullSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RtspPullSourceConfig>(create);
  static RtspPullSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  RtspTransport get transport => $_getN(1);
  @$pb.TagNumber(2)
  set transport(RtspTransport value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTransport() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransport() => $_clearField(2);

  @$pb.TagNumber(3)
  RtspTrackSelection get videoTrack => $_getN(2);
  @$pb.TagNumber(3)
  set videoTrack(RtspTrackSelection value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVideoTrack() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoTrack() => $_clearField(3);
  @$pb.TagNumber(3)
  RtspTrackSelection ensureVideoTrack() => $_ensure(2);

  @$pb.TagNumber(4)
  RtspTrackSelection get audioTrack => $_getN(3);
  @$pb.TagNumber(4)
  set audioTrack(RtspTrackSelection value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAudioTrack() => $_has(3);
  @$pb.TagNumber(4)
  void clearAudioTrack() => $_clearField(4);
  @$pb.TagNumber(4)
  RtspTrackSelection ensureAudioTrack() => $_ensure(3);
}

class HttpFlvPullSourceConfig extends $pb.GeneratedMessage {
  factory HttpFlvPullSourceConfig({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  HttpFlvPullSourceConfig._();

  factory HttpFlvPullSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HttpFlvPullSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HttpFlvPullSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HttpFlvPullSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HttpFlvPullSourceConfig copyWith(
          void Function(HttpFlvPullSourceConfig) updates) =>
      super.copyWith((message) => updates(message as HttpFlvPullSourceConfig))
          as HttpFlvPullSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HttpFlvPullSourceConfig create() => HttpFlvPullSourceConfig._();
  @$core.override
  HttpFlvPullSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HttpFlvPullSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HttpFlvPullSourceConfig>(create);
  static HttpFlvPullSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class WhepPullSourceConfig extends $pb.GeneratedMessage {
  factory WhepPullSourceConfig({
    $core.String? url,
    $core.String? authorization,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (authorization != null) result.authorization = authorization;
    return result;
  }

  WhepPullSourceConfig._();

  factory WhepPullSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WhepPullSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WhepPullSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'authorization')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhepPullSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhepPullSourceConfig copyWith(void Function(WhepPullSourceConfig) updates) =>
      super.copyWith((message) => updates(message as WhepPullSourceConfig))
          as WhepPullSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WhepPullSourceConfig create() => WhepPullSourceConfig._();
  @$core.override
  WhepPullSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WhepPullSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WhepPullSourceConfig>(create);
  static WhepPullSourceConfig? _defaultInstance;

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

enum LiveProxyMediaSourceConfig_Source { rtmp, rtsp, httpFlv, whep, notSet }

class LiveProxyMediaSourceConfig extends $pb.GeneratedMessage {
  factory LiveProxyMediaSourceConfig({
    RtmpPullSourceConfig? rtmp,
    RtspPullSourceConfig? rtsp,
    HttpFlvPullSourceConfig? httpFlv,
    WhepPullSourceConfig? whep,
  }) {
    final result = create();
    if (rtmp != null) result.rtmp = rtmp;
    if (rtsp != null) result.rtsp = rtsp;
    if (httpFlv != null) result.httpFlv = httpFlv;
    if (whep != null) result.whep = whep;
    return result;
  }

  LiveProxyMediaSourceConfig._();

  factory LiveProxyMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveProxyMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, LiveProxyMediaSourceConfig_Source>
      _LiveProxyMediaSourceConfig_SourceByTag = {
    1: LiveProxyMediaSourceConfig_Source.rtmp,
    2: LiveProxyMediaSourceConfig_Source.rtsp,
    3: LiveProxyMediaSourceConfig_Source.httpFlv,
    4: LiveProxyMediaSourceConfig_Source.whep,
    0: LiveProxyMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveProxyMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<RtmpPullSourceConfig>(1, _omitFieldNames ? '' : 'rtmp',
        subBuilder: RtmpPullSourceConfig.create)
    ..aOM<RtspPullSourceConfig>(2, _omitFieldNames ? '' : 'rtsp',
        subBuilder: RtspPullSourceConfig.create)
    ..aOM<HttpFlvPullSourceConfig>(3, _omitFieldNames ? '' : 'httpFlv',
        subBuilder: HttpFlvPullSourceConfig.create)
    ..aOM<WhepPullSourceConfig>(4, _omitFieldNames ? '' : 'whep',
        subBuilder: WhepPullSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveProxyMediaSourceConfig copyWith(
          void Function(LiveProxyMediaSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as LiveProxyMediaSourceConfig))
          as LiveProxyMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiveProxyMediaSourceConfig create() => LiveProxyMediaSourceConfig._();
  @$core.override
  LiveProxyMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiveProxyMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveProxyMediaSourceConfig>(create);
  static LiveProxyMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  LiveProxyMediaSourceConfig_Source whichSource() =>
      _LiveProxyMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  RtmpPullSourceConfig get rtmp => $_getN(0);
  @$pb.TagNumber(1)
  set rtmp(RtmpPullSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRtmp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRtmp() => $_clearField(1);
  @$pb.TagNumber(1)
  RtmpPullSourceConfig ensureRtmp() => $_ensure(0);

  @$pb.TagNumber(2)
  RtspPullSourceConfig get rtsp => $_getN(1);
  @$pb.TagNumber(2)
  set rtsp(RtspPullSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRtsp() => $_has(1);
  @$pb.TagNumber(2)
  void clearRtsp() => $_clearField(2);
  @$pb.TagNumber(2)
  RtspPullSourceConfig ensureRtsp() => $_ensure(1);

  @$pb.TagNumber(3)
  HttpFlvPullSourceConfig get httpFlv => $_getN(2);
  @$pb.TagNumber(3)
  set httpFlv(HttpFlvPullSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasHttpFlv() => $_has(2);
  @$pb.TagNumber(3)
  void clearHttpFlv() => $_clearField(3);
  @$pb.TagNumber(3)
  HttpFlvPullSourceConfig ensureHttpFlv() => $_ensure(2);

  @$pb.TagNumber(4)
  WhepPullSourceConfig get whep => $_getN(3);
  @$pb.TagNumber(4)
  set whep(WhepPullSourceConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWhep() => $_has(3);
  @$pb.TagNumber(4)
  void clearWhep() => $_clearField(4);
  @$pb.TagNumber(4)
  WhepPullSourceConfig ensureWhep() => $_ensure(3);
}

class BilibiliVideoSourceConfig extends $pb.GeneratedMessage {
  factory BilibiliVideoSourceConfig({
    $core.String? bvid,
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $core.bool? shared,
  }) {
    final result = create();
    if (bvid != null) result.bvid = bvid;
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (shared != null) result.shared = shared;
    return result;
  }

  BilibiliVideoSourceConfig._();

  factory BilibiliVideoSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliVideoSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliVideoSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bvid')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'aid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'cid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(4, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliVideoSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliVideoSourceConfig copyWith(
          void Function(BilibiliVideoSourceConfig) updates) =>
      super.copyWith((message) => updates(message as BilibiliVideoSourceConfig))
          as BilibiliVideoSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliVideoSourceConfig create() => BilibiliVideoSourceConfig._();
  @$core.override
  BilibiliVideoSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliVideoSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliVideoSourceConfig>(create);
  static BilibiliVideoSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bvid => $_getSZ(0);
  @$pb.TagNumber(1)
  set bvid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBvid() => $_has(0);
  @$pb.TagNumber(1)
  void clearBvid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get aid => $_getI64(1);
  @$pb.TagNumber(2)
  set aid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAid() => $_has(1);
  @$pb.TagNumber(2)
  void clearAid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get cid => $_getI64(2);
  @$pb.TagNumber(3)
  set cid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get shared => $_getBF(3);
  @$pb.TagNumber(4)
  set shared($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShared() => $_has(3);
  @$pb.TagNumber(4)
  void clearShared() => $_clearField(4);
}

class BilibiliPgcSourceConfig extends $pb.GeneratedMessage {
  factory BilibiliPgcSourceConfig({
    $fixnum.Int64? epid,
    $fixnum.Int64? cid,
    $core.bool? shared,
  }) {
    final result = create();
    if (epid != null) result.epid = epid;
    if (cid != null) result.cid = cid;
    if (shared != null) result.shared = shared;
    return result;
  }

  BilibiliPgcSourceConfig._();

  factory BilibiliPgcSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliPgcSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliPgcSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'epid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'cid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(3, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPgcSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPgcSourceConfig copyWith(
          void Function(BilibiliPgcSourceConfig) updates) =>
      super.copyWith((message) => updates(message as BilibiliPgcSourceConfig))
          as BilibiliPgcSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliPgcSourceConfig create() => BilibiliPgcSourceConfig._();
  @$core.override
  BilibiliPgcSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliPgcSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliPgcSourceConfig>(create);
  static BilibiliPgcSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get epid => $_getI64(0);
  @$pb.TagNumber(1)
  set epid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpid() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cid => $_getI64(1);
  @$pb.TagNumber(2)
  set cid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCid() => $_has(1);
  @$pb.TagNumber(2)
  void clearCid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get shared => $_getBF(2);
  @$pb.TagNumber(3)
  set shared($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShared() => $_has(2);
  @$pb.TagNumber(3)
  void clearShared() => $_clearField(3);
}

class BilibiliLiveSourceConfig extends $pb.GeneratedMessage {
  factory BilibiliLiveSourceConfig({
    $fixnum.Int64? roomId,
    $core.bool? shared,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (shared != null) result.shared = shared;
    return result;
  }

  BilibiliLiveSourceConfig._();

  factory BilibiliLiveSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliLiveSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliLiveSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'roomId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveSourceConfig copyWith(
          void Function(BilibiliLiveSourceConfig) updates) =>
      super.copyWith((message) => updates(message as BilibiliLiveSourceConfig))
          as BilibiliLiveSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliLiveSourceConfig create() => BilibiliLiveSourceConfig._();
  @$core.override
  BilibiliLiveSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliLiveSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliLiveSourceConfig>(create);
  static BilibiliLiveSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get roomId => $_getI64(0);
  @$pb.TagNumber(1)
  set roomId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

enum BilibiliMediaSourceConfig_Source { video, pgc, live, notSet }

class BilibiliMediaSourceConfig extends $pb.GeneratedMessage {
  factory BilibiliMediaSourceConfig({
    BilibiliVideoSourceConfig? video,
    BilibiliPgcSourceConfig? pgc,
    BilibiliLiveSourceConfig? live,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (video != null) result.video = video;
    if (pgc != null) result.pgc = pgc;
    if (live != null) result.live = live;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  BilibiliMediaSourceConfig._();

  factory BilibiliMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, BilibiliMediaSourceConfig_Source>
      _BilibiliMediaSourceConfig_SourceByTag = {
    1: BilibiliMediaSourceConfig_Source.video,
    2: BilibiliMediaSourceConfig_Source.pgc,
    3: BilibiliMediaSourceConfig_Source.live,
    0: BilibiliMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<BilibiliVideoSourceConfig>(1, _omitFieldNames ? '' : 'video',
        subBuilder: BilibiliVideoSourceConfig.create)
    ..aOM<BilibiliPgcSourceConfig>(2, _omitFieldNames ? '' : 'pgc',
        subBuilder: BilibiliPgcSourceConfig.create)
    ..aOM<BilibiliLiveSourceConfig>(3, _omitFieldNames ? '' : 'live',
        subBuilder: BilibiliLiveSourceConfig.create)
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliMediaSourceConfig copyWith(
          void Function(BilibiliMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as BilibiliMediaSourceConfig))
          as BilibiliMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliMediaSourceConfig create() => BilibiliMediaSourceConfig._();
  @$core.override
  BilibiliMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliMediaSourceConfig>(create);
  static BilibiliMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  BilibiliMediaSourceConfig_Source whichSource() =>
      _BilibiliMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  BilibiliVideoSourceConfig get video => $_getN(0);
  @$pb.TagNumber(1)
  set video(BilibiliVideoSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideo() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideo() => $_clearField(1);
  @$pb.TagNumber(1)
  BilibiliVideoSourceConfig ensureVideo() => $_ensure(0);

  @$pb.TagNumber(2)
  BilibiliPgcSourceConfig get pgc => $_getN(1);
  @$pb.TagNumber(2)
  set pgc(BilibiliPgcSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPgc() => $_has(1);
  @$pb.TagNumber(2)
  void clearPgc() => $_clearField(2);
  @$pb.TagNumber(2)
  BilibiliPgcSourceConfig ensurePgc() => $_ensure(1);

  @$pb.TagNumber(3)
  BilibiliLiveSourceConfig get live => $_getN(2);
  @$pb.TagNumber(3)
  set live(BilibiliLiveSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLive() => $_has(2);
  @$pb.TagNumber(3)
  void clearLive() => $_clearField(3);
  @$pb.TagNumber(3)
  BilibiliLiveSourceConfig ensureLive() => $_ensure(2);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class BilibiliPopularPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliPopularPlaylistSource() => create();

  BilibiliPopularPlaylistSource._();

  factory BilibiliPopularPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliPopularPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliPopularPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPopularPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPopularPlaylistSource copyWith(
          void Function(BilibiliPopularPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliPopularPlaylistSource))
          as BilibiliPopularPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliPopularPlaylistSource create() =>
      BilibiliPopularPlaylistSource._();
  @$core.override
  BilibiliPopularPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliPopularPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliPopularPlaylistSource>(create);
  static BilibiliPopularPlaylistSource? _defaultInstance;
}

class BilibiliRecommendedPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliRecommendedPlaylistSource() => create();

  BilibiliRecommendedPlaylistSource._();

  factory BilibiliRecommendedPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliRecommendedPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliRecommendedPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliRecommendedPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliRecommendedPlaylistSource copyWith(
          void Function(BilibiliRecommendedPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliRecommendedPlaylistSource))
          as BilibiliRecommendedPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliRecommendedPlaylistSource create() =>
      BilibiliRecommendedPlaylistSource._();
  @$core.override
  BilibiliRecommendedPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliRecommendedPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliRecommendedPlaylistSource>(
          create);
  static BilibiliRecommendedPlaylistSource? _defaultInstance;
}

class BilibiliVideoPartsPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliVideoPartsPlaylistSource({
    $core.String? bvid,
    $fixnum.Int64? aid,
  }) {
    final result = create();
    if (bvid != null) result.bvid = bvid;
    if (aid != null) result.aid = aid;
    return result;
  }

  BilibiliVideoPartsPlaylistSource._();

  factory BilibiliVideoPartsPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliVideoPartsPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliVideoPartsPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bvid')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'aid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliVideoPartsPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliVideoPartsPlaylistSource copyWith(
          void Function(BilibiliVideoPartsPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliVideoPartsPlaylistSource))
          as BilibiliVideoPartsPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliVideoPartsPlaylistSource create() =>
      BilibiliVideoPartsPlaylistSource._();
  @$core.override
  BilibiliVideoPartsPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliVideoPartsPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliVideoPartsPlaylistSource>(
          create);
  static BilibiliVideoPartsPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bvid => $_getSZ(0);
  @$pb.TagNumber(1)
  set bvid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBvid() => $_has(0);
  @$pb.TagNumber(1)
  void clearBvid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get aid => $_getI64(1);
  @$pb.TagNumber(2)
  set aid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAid() => $_has(1);
  @$pb.TagNumber(2)
  void clearAid() => $_clearField(2);
}

class BilibiliUpVideosPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliUpVideosPlaylistSource({
    $fixnum.Int64? mid,
    $core.String? keyword,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  BilibiliUpVideosPlaylistSource._();

  factory BilibiliUpVideosPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliUpVideosPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliUpVideosPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliUpVideosPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliUpVideosPlaylistSource copyWith(
          void Function(BilibiliUpVideosPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliUpVideosPlaylistSource))
          as BilibiliUpVideosPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliUpVideosPlaylistSource create() =>
      BilibiliUpVideosPlaylistSource._();
  @$core.override
  BilibiliUpVideosPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliUpVideosPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliUpVideosPlaylistSource>(create);
  static BilibiliUpVideosPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get keyword => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyword() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyword() => $_clearField(2);
}

class BilibiliFavoriteVideosPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliFavoriteVideosPlaylistSource({
    $fixnum.Int64? mediaId,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  BilibiliFavoriteVideosPlaylistSource._();

  factory BilibiliFavoriteVideosPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliFavoriteVideosPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliFavoriteVideosPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mediaId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliFavoriteVideosPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliFavoriteVideosPlaylistSource copyWith(
          void Function(BilibiliFavoriteVideosPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliFavoriteVideosPlaylistSource))
          as BilibiliFavoriteVideosPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliFavoriteVideosPlaylistSource create() =>
      BilibiliFavoriteVideosPlaylistSource._();
  @$core.override
  BilibiliFavoriteVideosPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliFavoriteVideosPlaylistSource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          BilibiliFavoriteVideosPlaylistSource>(create);
  static BilibiliFavoriteVideosPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mediaId => $_getI64(0);
  @$pb.TagNumber(1)
  set mediaId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);
}

class BilibiliCollectionVideosPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliCollectionVideosPlaylistSource({
    $fixnum.Int64? mid,
    $fixnum.Int64? seasonId,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (seasonId != null) result.seasonId = seasonId;
    return result;
  }

  BilibiliCollectionVideosPlaylistSource._();

  factory BilibiliCollectionVideosPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliCollectionVideosPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliCollectionVideosPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'seasonId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliCollectionVideosPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliCollectionVideosPlaylistSource copyWith(
          void Function(BilibiliCollectionVideosPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliCollectionVideosPlaylistSource))
          as BilibiliCollectionVideosPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliCollectionVideosPlaylistSource create() =>
      BilibiliCollectionVideosPlaylistSource._();
  @$core.override
  BilibiliCollectionVideosPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliCollectionVideosPlaylistSource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          BilibiliCollectionVideosPlaylistSource>(create);
  static BilibiliCollectionVideosPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seasonId => $_getI64(1);
  @$pb.TagNumber(2)
  set seasonId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeasonId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeasonId() => $_clearField(2);
}

class BilibiliSeriesVideosPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliSeriesVideosPlaylistSource({
    $fixnum.Int64? mid,
    $fixnum.Int64? seriesId,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (seriesId != null) result.seriesId = seriesId;
    return result;
  }

  BilibiliSeriesVideosPlaylistSource._();

  factory BilibiliSeriesVideosPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliSeriesVideosPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliSeriesVideosPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'seriesId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliSeriesVideosPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliSeriesVideosPlaylistSource copyWith(
          void Function(BilibiliSeriesVideosPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliSeriesVideosPlaylistSource))
          as BilibiliSeriesVideosPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliSeriesVideosPlaylistSource create() =>
      BilibiliSeriesVideosPlaylistSource._();
  @$core.override
  BilibiliSeriesVideosPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliSeriesVideosPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliSeriesVideosPlaylistSource>(
          create);
  static BilibiliSeriesVideosPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seriesId => $_getI64(1);
  @$pb.TagNumber(2)
  set seriesId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeriesId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeriesId() => $_clearField(2);
}

class BilibiliWatchLaterPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliWatchLaterPlaylistSource() => create();

  BilibiliWatchLaterPlaylistSource._();

  factory BilibiliWatchLaterPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliWatchLaterPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliWatchLaterPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliWatchLaterPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliWatchLaterPlaylistSource copyWith(
          void Function(BilibiliWatchLaterPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliWatchLaterPlaylistSource))
          as BilibiliWatchLaterPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliWatchLaterPlaylistSource create() =>
      BilibiliWatchLaterPlaylistSource._();
  @$core.override
  BilibiliWatchLaterPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliWatchLaterPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliWatchLaterPlaylistSource>(
          create);
  static BilibiliWatchLaterPlaylistSource? _defaultInstance;
}

class BilibiliPgcSeasonPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliPgcSeasonPlaylistSource({
    $fixnum.Int64? seasonId,
  }) {
    final result = create();
    if (seasonId != null) result.seasonId = seasonId;
    return result;
  }

  BilibiliPgcSeasonPlaylistSource._();

  factory BilibiliPgcSeasonPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliPgcSeasonPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliPgcSeasonPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'seasonId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPgcSeasonPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPgcSeasonPlaylistSource copyWith(
          void Function(BilibiliPgcSeasonPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliPgcSeasonPlaylistSource))
          as BilibiliPgcSeasonPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliPgcSeasonPlaylistSource create() =>
      BilibiliPgcSeasonPlaylistSource._();
  @$core.override
  BilibiliPgcSeasonPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliPgcSeasonPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliPgcSeasonPlaylistSource>(
          create);
  static BilibiliPgcSeasonPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);
}

class BilibiliLiveRecommendedPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliLiveRecommendedPlaylistSource() => create();

  BilibiliLiveRecommendedPlaylistSource._();

  factory BilibiliLiveRecommendedPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliLiveRecommendedPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliLiveRecommendedPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveRecommendedPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveRecommendedPlaylistSource copyWith(
          void Function(BilibiliLiveRecommendedPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliLiveRecommendedPlaylistSource))
          as BilibiliLiveRecommendedPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliLiveRecommendedPlaylistSource create() =>
      BilibiliLiveRecommendedPlaylistSource._();
  @$core.override
  BilibiliLiveRecommendedPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliLiveRecommendedPlaylistSource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          BilibiliLiveRecommendedPlaylistSource>(create);
  static BilibiliLiveRecommendedPlaylistSource? _defaultInstance;
}

class BilibiliLiveFollowedPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliLiveFollowedPlaylistSource() => create();

  BilibiliLiveFollowedPlaylistSource._();

  factory BilibiliLiveFollowedPlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliLiveFollowedPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliLiveFollowedPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveFollowedPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveFollowedPlaylistSource copyWith(
          void Function(BilibiliLiveFollowedPlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliLiveFollowedPlaylistSource))
          as BilibiliLiveFollowedPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliLiveFollowedPlaylistSource create() =>
      BilibiliLiveFollowedPlaylistSource._();
  @$core.override
  BilibiliLiveFollowedPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliLiveFollowedPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliLiveFollowedPlaylistSource>(
          create);
  static BilibiliLiveFollowedPlaylistSource? _defaultInstance;
}

class BilibiliLiveAreaPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliLiveAreaPlaylistSource({
    $fixnum.Int64? parentAreaId,
    $fixnum.Int64? areaId,
  }) {
    final result = create();
    if (parentAreaId != null) result.parentAreaId = parentAreaId;
    if (areaId != null) result.areaId = areaId;
    return result;
  }

  BilibiliLiveAreaPlaylistSource._();

  factory BilibiliLiveAreaPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliLiveAreaPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliLiveAreaPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'parentAreaId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'areaId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveAreaPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliLiveAreaPlaylistSource copyWith(
          void Function(BilibiliLiveAreaPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliLiveAreaPlaylistSource))
          as BilibiliLiveAreaPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliLiveAreaPlaylistSource create() =>
      BilibiliLiveAreaPlaylistSource._();
  @$core.override
  BilibiliLiveAreaPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliLiveAreaPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliLiveAreaPlaylistSource>(create);
  static BilibiliLiveAreaPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parentAreaId => $_getI64(0);
  @$pb.TagNumber(1)
  set parentAreaId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParentAreaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParentAreaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get areaId => $_getI64(1);
  @$pb.TagNumber(2)
  set areaId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAreaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAreaId() => $_clearField(2);
}

class BilibiliHistoryPlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliHistoryPlaylistSource({
    BilibiliHistoryType? type,
  }) {
    final result = create();
    if (type != null) result.type = type;
    return result;
  }

  BilibiliHistoryPlaylistSource._();

  factory BilibiliHistoryPlaylistSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliHistoryPlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliHistoryPlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aE<BilibiliHistoryType>(1, _omitFieldNames ? '' : 'type',
        enumValues: BilibiliHistoryType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliHistoryPlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliHistoryPlaylistSource copyWith(
          void Function(BilibiliHistoryPlaylistSource) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliHistoryPlaylistSource))
          as BilibiliHistoryPlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliHistoryPlaylistSource create() =>
      BilibiliHistoryPlaylistSource._();
  @$core.override
  BilibiliHistoryPlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliHistoryPlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliHistoryPlaylistSource>(create);
  static BilibiliHistoryPlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  BilibiliHistoryType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(BilibiliHistoryType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

class BilibiliPgcTimelinePlaylistSource extends $pb.GeneratedMessage {
  factory BilibiliPgcTimelinePlaylistSource({
    BilibiliPgcTimelineType? type,
    $core.int? beforeDays,
    $core.int? afterDays,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (beforeDays != null) result.beforeDays = beforeDays;
    if (afterDays != null) result.afterDays = afterDays;
    return result;
  }

  BilibiliPgcTimelinePlaylistSource._();

  factory BilibiliPgcTimelinePlaylistSource.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliPgcTimelinePlaylistSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliPgcTimelinePlaylistSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aE<BilibiliPgcTimelineType>(1, _omitFieldNames ? '' : 'type',
        enumValues: BilibiliPgcTimelineType.values)
    ..aI(2, _omitFieldNames ? '' : 'beforeDays', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'afterDays', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPgcTimelinePlaylistSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPgcTimelinePlaylistSource copyWith(
          void Function(BilibiliPgcTimelinePlaylistSource) updates) =>
      super.copyWith((message) =>
              updates(message as BilibiliPgcTimelinePlaylistSource))
          as BilibiliPgcTimelinePlaylistSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliPgcTimelinePlaylistSource create() =>
      BilibiliPgcTimelinePlaylistSource._();
  @$core.override
  BilibiliPgcTimelinePlaylistSource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliPgcTimelinePlaylistSource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliPgcTimelinePlaylistSource>(
          create);
  static BilibiliPgcTimelinePlaylistSource? _defaultInstance;

  @$pb.TagNumber(1)
  BilibiliPgcTimelineType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(BilibiliPgcTimelineType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get beforeDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set beforeDays($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBeforeDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforeDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get afterDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set afterDays($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAfterDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfterDays() => $_clearField(3);
}

enum BilibiliPlaylistSourceConfig_Source {
  videoParts,
  popular,
  recommended,
  upVideos,
  favoriteVideos,
  collectionVideos,
  seriesVideos,
  watchLater,
  pgcSeason,
  liveRecommended,
  liveFollowed,
  liveArea,
  history,
  pgcTimeline,
  notSet
}

class BilibiliPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory BilibiliPlaylistSourceConfig({
    BilibiliVideoPartsPlaylistSource? videoParts,
    BilibiliPopularPlaylistSource? popular,
    BilibiliRecommendedPlaylistSource? recommended,
    BilibiliUpVideosPlaylistSource? upVideos,
    BilibiliFavoriteVideosPlaylistSource? favoriteVideos,
    BilibiliCollectionVideosPlaylistSource? collectionVideos,
    BilibiliSeriesVideosPlaylistSource? seriesVideos,
    BilibiliWatchLaterPlaylistSource? watchLater,
    BilibiliPgcSeasonPlaylistSource? pgcSeason,
    BilibiliLiveRecommendedPlaylistSource? liveRecommended,
    BilibiliLiveFollowedPlaylistSource? liveFollowed,
    BilibiliLiveAreaPlaylistSource? liveArea,
    BilibiliHistoryPlaylistSource? history,
    BilibiliPgcTimelinePlaylistSource? pgcTimeline,
    $core.bool? shared,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (videoParts != null) result.videoParts = videoParts;
    if (popular != null) result.popular = popular;
    if (recommended != null) result.recommended = recommended;
    if (upVideos != null) result.upVideos = upVideos;
    if (favoriteVideos != null) result.favoriteVideos = favoriteVideos;
    if (collectionVideos != null) result.collectionVideos = collectionVideos;
    if (seriesVideos != null) result.seriesVideos = seriesVideos;
    if (watchLater != null) result.watchLater = watchLater;
    if (pgcSeason != null) result.pgcSeason = pgcSeason;
    if (liveRecommended != null) result.liveRecommended = liveRecommended;
    if (liveFollowed != null) result.liveFollowed = liveFollowed;
    if (liveArea != null) result.liveArea = liveArea;
    if (history != null) result.history = history;
    if (pgcTimeline != null) result.pgcTimeline = pgcTimeline;
    if (shared != null) result.shared = shared;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  BilibiliPlaylistSourceConfig._();

  factory BilibiliPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BilibiliPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, BilibiliPlaylistSourceConfig_Source>
      _BilibiliPlaylistSourceConfig_SourceByTag = {
    1: BilibiliPlaylistSourceConfig_Source.videoParts,
    2: BilibiliPlaylistSourceConfig_Source.popular,
    3: BilibiliPlaylistSourceConfig_Source.recommended,
    4: BilibiliPlaylistSourceConfig_Source.upVideos,
    5: BilibiliPlaylistSourceConfig_Source.favoriteVideos,
    6: BilibiliPlaylistSourceConfig_Source.collectionVideos,
    7: BilibiliPlaylistSourceConfig_Source.seriesVideos,
    8: BilibiliPlaylistSourceConfig_Source.watchLater,
    9: BilibiliPlaylistSourceConfig_Source.pgcSeason,
    10: BilibiliPlaylistSourceConfig_Source.liveRecommended,
    11: BilibiliPlaylistSourceConfig_Source.liveFollowed,
    12: BilibiliPlaylistSourceConfig_Source.liveArea,
    13: BilibiliPlaylistSourceConfig_Source.history,
    14: BilibiliPlaylistSourceConfig_Source.pgcTimeline,
    0: BilibiliPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BilibiliPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    ..aOM<BilibiliVideoPartsPlaylistSource>(
        1, _omitFieldNames ? '' : 'videoParts',
        subBuilder: BilibiliVideoPartsPlaylistSource.create)
    ..aOM<BilibiliPopularPlaylistSource>(2, _omitFieldNames ? '' : 'popular',
        subBuilder: BilibiliPopularPlaylistSource.create)
    ..aOM<BilibiliRecommendedPlaylistSource>(
        3, _omitFieldNames ? '' : 'recommended',
        subBuilder: BilibiliRecommendedPlaylistSource.create)
    ..aOM<BilibiliUpVideosPlaylistSource>(4, _omitFieldNames ? '' : 'upVideos',
        subBuilder: BilibiliUpVideosPlaylistSource.create)
    ..aOM<BilibiliFavoriteVideosPlaylistSource>(
        5, _omitFieldNames ? '' : 'favoriteVideos',
        subBuilder: BilibiliFavoriteVideosPlaylistSource.create)
    ..aOM<BilibiliCollectionVideosPlaylistSource>(
        6, _omitFieldNames ? '' : 'collectionVideos',
        subBuilder: BilibiliCollectionVideosPlaylistSource.create)
    ..aOM<BilibiliSeriesVideosPlaylistSource>(
        7, _omitFieldNames ? '' : 'seriesVideos',
        subBuilder: BilibiliSeriesVideosPlaylistSource.create)
    ..aOM<BilibiliWatchLaterPlaylistSource>(
        8, _omitFieldNames ? '' : 'watchLater',
        subBuilder: BilibiliWatchLaterPlaylistSource.create)
    ..aOM<BilibiliPgcSeasonPlaylistSource>(
        9, _omitFieldNames ? '' : 'pgcSeason',
        subBuilder: BilibiliPgcSeasonPlaylistSource.create)
    ..aOM<BilibiliLiveRecommendedPlaylistSource>(
        10, _omitFieldNames ? '' : 'liveRecommended',
        subBuilder: BilibiliLiveRecommendedPlaylistSource.create)
    ..aOM<BilibiliLiveFollowedPlaylistSource>(
        11, _omitFieldNames ? '' : 'liveFollowed',
        subBuilder: BilibiliLiveFollowedPlaylistSource.create)
    ..aOM<BilibiliLiveAreaPlaylistSource>(12, _omitFieldNames ? '' : 'liveArea',
        subBuilder: BilibiliLiveAreaPlaylistSource.create)
    ..aOM<BilibiliHistoryPlaylistSource>(13, _omitFieldNames ? '' : 'history',
        subBuilder: BilibiliHistoryPlaylistSource.create)
    ..aOM<BilibiliPgcTimelinePlaylistSource>(
        14, _omitFieldNames ? '' : 'pgcTimeline',
        subBuilder: BilibiliPgcTimelinePlaylistSource.create)
    ..aOB(15, _omitFieldNames ? '' : 'shared')
    ..aE<PlaybackProxyMode>(16, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BilibiliPlaylistSourceConfig copyWith(
          void Function(BilibiliPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as BilibiliPlaylistSourceConfig))
          as BilibiliPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BilibiliPlaylistSourceConfig create() =>
      BilibiliPlaylistSourceConfig._();
  @$core.override
  BilibiliPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BilibiliPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BilibiliPlaylistSourceConfig>(create);
  static BilibiliPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  BilibiliPlaylistSourceConfig_Source whichSource() =>
      _BilibiliPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  BilibiliVideoPartsPlaylistSource get videoParts => $_getN(0);
  @$pb.TagNumber(1)
  set videoParts(BilibiliVideoPartsPlaylistSource value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoParts() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoParts() => $_clearField(1);
  @$pb.TagNumber(1)
  BilibiliVideoPartsPlaylistSource ensureVideoParts() => $_ensure(0);

  @$pb.TagNumber(2)
  BilibiliPopularPlaylistSource get popular => $_getN(1);
  @$pb.TagNumber(2)
  set popular(BilibiliPopularPlaylistSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPopular() => $_has(1);
  @$pb.TagNumber(2)
  void clearPopular() => $_clearField(2);
  @$pb.TagNumber(2)
  BilibiliPopularPlaylistSource ensurePopular() => $_ensure(1);

  @$pb.TagNumber(3)
  BilibiliRecommendedPlaylistSource get recommended => $_getN(2);
  @$pb.TagNumber(3)
  set recommended(BilibiliRecommendedPlaylistSource value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRecommended() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecommended() => $_clearField(3);
  @$pb.TagNumber(3)
  BilibiliRecommendedPlaylistSource ensureRecommended() => $_ensure(2);

  @$pb.TagNumber(4)
  BilibiliUpVideosPlaylistSource get upVideos => $_getN(3);
  @$pb.TagNumber(4)
  set upVideos(BilibiliUpVideosPlaylistSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpVideos() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpVideos() => $_clearField(4);
  @$pb.TagNumber(4)
  BilibiliUpVideosPlaylistSource ensureUpVideos() => $_ensure(3);

  @$pb.TagNumber(5)
  BilibiliFavoriteVideosPlaylistSource get favoriteVideos => $_getN(4);
  @$pb.TagNumber(5)
  set favoriteVideos(BilibiliFavoriteVideosPlaylistSource value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFavoriteVideos() => $_has(4);
  @$pb.TagNumber(5)
  void clearFavoriteVideos() => $_clearField(5);
  @$pb.TagNumber(5)
  BilibiliFavoriteVideosPlaylistSource ensureFavoriteVideos() => $_ensure(4);

  @$pb.TagNumber(6)
  BilibiliCollectionVideosPlaylistSource get collectionVideos => $_getN(5);
  @$pb.TagNumber(6)
  set collectionVideos(BilibiliCollectionVideosPlaylistSource value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCollectionVideos() => $_has(5);
  @$pb.TagNumber(6)
  void clearCollectionVideos() => $_clearField(6);
  @$pb.TagNumber(6)
  BilibiliCollectionVideosPlaylistSource ensureCollectionVideos() =>
      $_ensure(5);

  @$pb.TagNumber(7)
  BilibiliSeriesVideosPlaylistSource get seriesVideos => $_getN(6);
  @$pb.TagNumber(7)
  set seriesVideos(BilibiliSeriesVideosPlaylistSource value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSeriesVideos() => $_has(6);
  @$pb.TagNumber(7)
  void clearSeriesVideos() => $_clearField(7);
  @$pb.TagNumber(7)
  BilibiliSeriesVideosPlaylistSource ensureSeriesVideos() => $_ensure(6);

  @$pb.TagNumber(8)
  BilibiliWatchLaterPlaylistSource get watchLater => $_getN(7);
  @$pb.TagNumber(8)
  set watchLater(BilibiliWatchLaterPlaylistSource value) =>
      $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWatchLater() => $_has(7);
  @$pb.TagNumber(8)
  void clearWatchLater() => $_clearField(8);
  @$pb.TagNumber(8)
  BilibiliWatchLaterPlaylistSource ensureWatchLater() => $_ensure(7);

  @$pb.TagNumber(9)
  BilibiliPgcSeasonPlaylistSource get pgcSeason => $_getN(8);
  @$pb.TagNumber(9)
  set pgcSeason(BilibiliPgcSeasonPlaylistSource value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPgcSeason() => $_has(8);
  @$pb.TagNumber(9)
  void clearPgcSeason() => $_clearField(9);
  @$pb.TagNumber(9)
  BilibiliPgcSeasonPlaylistSource ensurePgcSeason() => $_ensure(8);

  @$pb.TagNumber(10)
  BilibiliLiveRecommendedPlaylistSource get liveRecommended => $_getN(9);
  @$pb.TagNumber(10)
  set liveRecommended(BilibiliLiveRecommendedPlaylistSource value) =>
      $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLiveRecommended() => $_has(9);
  @$pb.TagNumber(10)
  void clearLiveRecommended() => $_clearField(10);
  @$pb.TagNumber(10)
  BilibiliLiveRecommendedPlaylistSource ensureLiveRecommended() => $_ensure(9);

  @$pb.TagNumber(11)
  BilibiliLiveFollowedPlaylistSource get liveFollowed => $_getN(10);
  @$pb.TagNumber(11)
  set liveFollowed(BilibiliLiveFollowedPlaylistSource value) =>
      $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLiveFollowed() => $_has(10);
  @$pb.TagNumber(11)
  void clearLiveFollowed() => $_clearField(11);
  @$pb.TagNumber(11)
  BilibiliLiveFollowedPlaylistSource ensureLiveFollowed() => $_ensure(10);

  @$pb.TagNumber(12)
  BilibiliLiveAreaPlaylistSource get liveArea => $_getN(11);
  @$pb.TagNumber(12)
  set liveArea(BilibiliLiveAreaPlaylistSource value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLiveArea() => $_has(11);
  @$pb.TagNumber(12)
  void clearLiveArea() => $_clearField(12);
  @$pb.TagNumber(12)
  BilibiliLiveAreaPlaylistSource ensureLiveArea() => $_ensure(11);

  @$pb.TagNumber(13)
  BilibiliHistoryPlaylistSource get history => $_getN(12);
  @$pb.TagNumber(13)
  set history(BilibiliHistoryPlaylistSource value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasHistory() => $_has(12);
  @$pb.TagNumber(13)
  void clearHistory() => $_clearField(13);
  @$pb.TagNumber(13)
  BilibiliHistoryPlaylistSource ensureHistory() => $_ensure(12);

  @$pb.TagNumber(14)
  BilibiliPgcTimelinePlaylistSource get pgcTimeline => $_getN(13);
  @$pb.TagNumber(14)
  set pgcTimeline(BilibiliPgcTimelinePlaylistSource value) =>
      $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPgcTimeline() => $_has(13);
  @$pb.TagNumber(14)
  void clearPgcTimeline() => $_clearField(14);
  @$pb.TagNumber(14)
  BilibiliPgcTimelinePlaylistSource ensurePgcTimeline() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.bool get shared => $_getBF(14);
  @$pb.TagNumber(15)
  set shared($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasShared() => $_has(14);
  @$pb.TagNumber(15)
  void clearShared() => $_clearField(15);

  @$pb.TagNumber(16)
  PlaybackProxyMode get proxyMode => $_getN(15);
  @$pb.TagNumber(16)
  set proxyMode(PlaybackProxyMode value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasProxyMode() => $_has(15);
  @$pb.TagNumber(16)
  void clearProxyMode() => $_clearField(16);
}

class TwitchLiveSourceConfig extends $pb.GeneratedMessage {
  factory TwitchLiveSourceConfig({
    $core.String? channel,
    $core.bool? shared,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    if (shared != null) result.shared = shared;
    return result;
  }

  TwitchLiveSourceConfig._();

  factory TwitchLiveSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchLiveSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchLiveSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchLiveSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchLiveSourceConfig copyWith(
          void Function(TwitchLiveSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TwitchLiveSourceConfig))
          as TwitchLiveSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchLiveSourceConfig create() => TwitchLiveSourceConfig._();
  @$core.override
  TwitchLiveSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchLiveSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchLiveSourceConfig>(create);
  static TwitchLiveSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

class TwitchVideoSourceConfig extends $pb.GeneratedMessage {
  factory TwitchVideoSourceConfig({
    $core.String? videoId,
    $core.bool? shared,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    if (shared != null) result.shared = shared;
    return result;
  }

  TwitchVideoSourceConfig._();

  factory TwitchVideoSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchVideoSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchVideoSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchVideoSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchVideoSourceConfig copyWith(
          void Function(TwitchVideoSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TwitchVideoSourceConfig))
          as TwitchVideoSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchVideoSourceConfig create() => TwitchVideoSourceConfig._();
  @$core.override
  TwitchVideoSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchVideoSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchVideoSourceConfig>(create);
  static TwitchVideoSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

class TwitchClipSourceConfig extends $pb.GeneratedMessage {
  factory TwitchClipSourceConfig({
    $core.String? slug,
    $core.bool? shared,
  }) {
    final result = create();
    if (slug != null) result.slug = slug;
    if (shared != null) result.shared = shared;
    return result;
  }

  TwitchClipSourceConfig._();

  factory TwitchClipSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchClipSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchClipSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'slug')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchClipSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchClipSourceConfig copyWith(
          void Function(TwitchClipSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TwitchClipSourceConfig))
          as TwitchClipSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchClipSourceConfig create() => TwitchClipSourceConfig._();
  @$core.override
  TwitchClipSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchClipSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchClipSourceConfig>(create);
  static TwitchClipSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get slug => $_getSZ(0);
  @$pb.TagNumber(1)
  set slug($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSlug() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlug() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

enum TwitchMediaSourceConfig_Source { live, video, clip, notSet }

class TwitchMediaSourceConfig extends $pb.GeneratedMessage {
  factory TwitchMediaSourceConfig({
    TwitchLiveSourceConfig? live,
    TwitchVideoSourceConfig? video,
    TwitchClipSourceConfig? clip,
  }) {
    final result = create();
    if (live != null) result.live = live;
    if (video != null) result.video = video;
    if (clip != null) result.clip = clip;
    return result;
  }

  TwitchMediaSourceConfig._();

  factory TwitchMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TwitchMediaSourceConfig_Source>
      _TwitchMediaSourceConfig_SourceByTag = {
    1: TwitchMediaSourceConfig_Source.live,
    2: TwitchMediaSourceConfig_Source.video,
    3: TwitchMediaSourceConfig_Source.clip,
    0: TwitchMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<TwitchLiveSourceConfig>(1, _omitFieldNames ? '' : 'live',
        subBuilder: TwitchLiveSourceConfig.create)
    ..aOM<TwitchVideoSourceConfig>(2, _omitFieldNames ? '' : 'video',
        subBuilder: TwitchVideoSourceConfig.create)
    ..aOM<TwitchClipSourceConfig>(3, _omitFieldNames ? '' : 'clip',
        subBuilder: TwitchClipSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchMediaSourceConfig copyWith(
          void Function(TwitchMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TwitchMediaSourceConfig))
          as TwitchMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchMediaSourceConfig create() => TwitchMediaSourceConfig._();
  @$core.override
  TwitchMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchMediaSourceConfig>(create);
  static TwitchMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  TwitchMediaSourceConfig_Source whichSource() =>
      _TwitchMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  TwitchLiveSourceConfig get live => $_getN(0);
  @$pb.TagNumber(1)
  set live(TwitchLiveSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLive() => $_has(0);
  @$pb.TagNumber(1)
  void clearLive() => $_clearField(1);
  @$pb.TagNumber(1)
  TwitchLiveSourceConfig ensureLive() => $_ensure(0);

  @$pb.TagNumber(2)
  TwitchVideoSourceConfig get video => $_getN(1);
  @$pb.TagNumber(2)
  set video(TwitchVideoSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVideo() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideo() => $_clearField(2);
  @$pb.TagNumber(2)
  TwitchVideoSourceConfig ensureVideo() => $_ensure(1);

  @$pb.TagNumber(3)
  TwitchClipSourceConfig get clip => $_getN(2);
  @$pb.TagNumber(3)
  set clip(TwitchClipSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasClip() => $_has(2);
  @$pb.TagNumber(3)
  void clearClip() => $_clearField(3);
  @$pb.TagNumber(3)
  TwitchClipSourceConfig ensureClip() => $_ensure(2);
}

class TwitchPlaylistSourceConfig_Channel extends $pb.GeneratedMessage {
  factory TwitchPlaylistSourceConfig_Channel({
    $core.String? channel,
    TwitchPlaylistContent? content,
  }) {
    final result = create();
    if (channel != null) result.channel = channel;
    if (content != null) result.content = content;
    return result;
  }

  TwitchPlaylistSourceConfig_Channel._();

  factory TwitchPlaylistSourceConfig_Channel.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchPlaylistSourceConfig_Channel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchPlaylistSourceConfig.Channel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channel')
    ..aE<TwitchPlaylistContent>(2, _omitFieldNames ? '' : 'content',
        enumValues: TwitchPlaylistContent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_Channel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_Channel copyWith(
          void Function(TwitchPlaylistSourceConfig_Channel) updates) =>
      super.copyWith((message) =>
              updates(message as TwitchPlaylistSourceConfig_Channel))
          as TwitchPlaylistSourceConfig_Channel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_Channel create() =>
      TwitchPlaylistSourceConfig_Channel._();
  @$core.override
  TwitchPlaylistSourceConfig_Channel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_Channel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchPlaylistSourceConfig_Channel>(
          create);
  static TwitchPlaylistSourceConfig_Channel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channel => $_getSZ(0);
  @$pb.TagNumber(1)
  set channel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannel() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannel() => $_clearField(1);

  @$pb.TagNumber(2)
  TwitchPlaylistContent get content => $_getN(1);
  @$pb.TagNumber(2)
  set content(TwitchPlaylistContent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

class TwitchPlaylistSourceConfig_FollowedLive extends $pb.GeneratedMessage {
  factory TwitchPlaylistSourceConfig_FollowedLive() => create();

  TwitchPlaylistSourceConfig_FollowedLive._();

  factory TwitchPlaylistSourceConfig_FollowedLive.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchPlaylistSourceConfig_FollowedLive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchPlaylistSourceConfig.FollowedLive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_FollowedLive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_FollowedLive copyWith(
          void Function(TwitchPlaylistSourceConfig_FollowedLive) updates) =>
      super.copyWith((message) =>
              updates(message as TwitchPlaylistSourceConfig_FollowedLive))
          as TwitchPlaylistSourceConfig_FollowedLive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_FollowedLive create() =>
      TwitchPlaylistSourceConfig_FollowedLive._();
  @$core.override
  TwitchPlaylistSourceConfig_FollowedLive createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_FollowedLive getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          TwitchPlaylistSourceConfig_FollowedLive>(create);
  static TwitchPlaylistSourceConfig_FollowedLive? _defaultInstance;
}

class TwitchPlaylistSourceConfig_CategoryLive extends $pb.GeneratedMessage {
  factory TwitchPlaylistSourceConfig_CategoryLive({
    $core.String? categoryId,
    $core.String? categoryName,
  }) {
    final result = create();
    if (categoryId != null) result.categoryId = categoryId;
    if (categoryName != null) result.categoryName = categoryName;
    return result;
  }

  TwitchPlaylistSourceConfig_CategoryLive._();

  factory TwitchPlaylistSourceConfig_CategoryLive.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchPlaylistSourceConfig_CategoryLive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchPlaylistSourceConfig.CategoryLive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'categoryId')
    ..aOS(2, _omitFieldNames ? '' : 'categoryName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_CategoryLive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_CategoryLive copyWith(
          void Function(TwitchPlaylistSourceConfig_CategoryLive) updates) =>
      super.copyWith((message) =>
              updates(message as TwitchPlaylistSourceConfig_CategoryLive))
          as TwitchPlaylistSourceConfig_CategoryLive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_CategoryLive create() =>
      TwitchPlaylistSourceConfig_CategoryLive._();
  @$core.override
  TwitchPlaylistSourceConfig_CategoryLive createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_CategoryLive getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          TwitchPlaylistSourceConfig_CategoryLive>(create);
  static TwitchPlaylistSourceConfig_CategoryLive? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get categoryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set categoryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get categoryName => $_getSZ(1);
  @$pb.TagNumber(2)
  set categoryName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryName() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryName() => $_clearField(2);
}

class TwitchPlaylistSourceConfig_SearchLive extends $pb.GeneratedMessage {
  factory TwitchPlaylistSourceConfig_SearchLive({
    $core.String? query,
  }) {
    final result = create();
    if (query != null) result.query = query;
    return result;
  }

  TwitchPlaylistSourceConfig_SearchLive._();

  factory TwitchPlaylistSourceConfig_SearchLive.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchPlaylistSourceConfig_SearchLive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchPlaylistSourceConfig.SearchLive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_SearchLive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig_SearchLive copyWith(
          void Function(TwitchPlaylistSourceConfig_SearchLive) updates) =>
      super.copyWith((message) =>
              updates(message as TwitchPlaylistSourceConfig_SearchLive))
          as TwitchPlaylistSourceConfig_SearchLive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_SearchLive create() =>
      TwitchPlaylistSourceConfig_SearchLive._();
  @$core.override
  TwitchPlaylistSourceConfig_SearchLive createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig_SearchLive getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          TwitchPlaylistSourceConfig_SearchLive>(create);
  static TwitchPlaylistSourceConfig_SearchLive? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);
}

enum TwitchPlaylistSourceConfig_Source {
  channel,
  followedLive,
  categoryLive,
  searchLive,
  notSet
}

class TwitchPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory TwitchPlaylistSourceConfig({
    $core.bool? shared,
    TwitchPlaylistSourceConfig_Channel? channel,
    TwitchPlaylistSourceConfig_FollowedLive? followedLive,
    TwitchPlaylistSourceConfig_CategoryLive? categoryLive,
    TwitchPlaylistSourceConfig_SearchLive? searchLive,
  }) {
    final result = create();
    if (shared != null) result.shared = shared;
    if (channel != null) result.channel = channel;
    if (followedLive != null) result.followedLive = followedLive;
    if (categoryLive != null) result.categoryLive = categoryLive;
    if (searchLive != null) result.searchLive = searchLive;
    return result;
  }

  TwitchPlaylistSourceConfig._();

  factory TwitchPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwitchPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TwitchPlaylistSourceConfig_Source>
      _TwitchPlaylistSourceConfig_SourceByTag = {
    2: TwitchPlaylistSourceConfig_Source.channel,
    3: TwitchPlaylistSourceConfig_Source.followedLive,
    4: TwitchPlaylistSourceConfig_Source.categoryLive,
    5: TwitchPlaylistSourceConfig_Source.searchLive,
    0: TwitchPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwitchPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aOB(1, _omitFieldNames ? '' : 'shared')
    ..aOM<TwitchPlaylistSourceConfig_Channel>(
        2, _omitFieldNames ? '' : 'channel',
        subBuilder: TwitchPlaylistSourceConfig_Channel.create)
    ..aOM<TwitchPlaylistSourceConfig_FollowedLive>(
        3, _omitFieldNames ? '' : 'followedLive',
        subBuilder: TwitchPlaylistSourceConfig_FollowedLive.create)
    ..aOM<TwitchPlaylistSourceConfig_CategoryLive>(
        4, _omitFieldNames ? '' : 'categoryLive',
        subBuilder: TwitchPlaylistSourceConfig_CategoryLive.create)
    ..aOM<TwitchPlaylistSourceConfig_SearchLive>(
        5, _omitFieldNames ? '' : 'searchLive',
        subBuilder: TwitchPlaylistSourceConfig_SearchLive.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwitchPlaylistSourceConfig copyWith(
          void Function(TwitchPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as TwitchPlaylistSourceConfig))
          as TwitchPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig create() => TwitchPlaylistSourceConfig._();
  @$core.override
  TwitchPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwitchPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwitchPlaylistSourceConfig>(create);
  static TwitchPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  TwitchPlaylistSourceConfig_Source whichSource() =>
      _TwitchPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get shared => $_getBF(0);
  @$pb.TagNumber(1)
  set shared($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShared() => $_has(0);
  @$pb.TagNumber(1)
  void clearShared() => $_clearField(1);

  @$pb.TagNumber(2)
  TwitchPlaylistSourceConfig_Channel get channel => $_getN(1);
  @$pb.TagNumber(2)
  set channel(TwitchPlaylistSourceConfig_Channel value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChannel() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannel() => $_clearField(2);
  @$pb.TagNumber(2)
  TwitchPlaylistSourceConfig_Channel ensureChannel() => $_ensure(1);

  @$pb.TagNumber(3)
  TwitchPlaylistSourceConfig_FollowedLive get followedLive => $_getN(2);
  @$pb.TagNumber(3)
  set followedLive(TwitchPlaylistSourceConfig_FollowedLive value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFollowedLive() => $_has(2);
  @$pb.TagNumber(3)
  void clearFollowedLive() => $_clearField(3);
  @$pb.TagNumber(3)
  TwitchPlaylistSourceConfig_FollowedLive ensureFollowedLive() => $_ensure(2);

  @$pb.TagNumber(4)
  TwitchPlaylistSourceConfig_CategoryLive get categoryLive => $_getN(3);
  @$pb.TagNumber(4)
  set categoryLive(TwitchPlaylistSourceConfig_CategoryLive value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCategoryLive() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategoryLive() => $_clearField(4);
  @$pb.TagNumber(4)
  TwitchPlaylistSourceConfig_CategoryLive ensureCategoryLive() => $_ensure(3);

  @$pb.TagNumber(5)
  TwitchPlaylistSourceConfig_SearchLive get searchLive => $_getN(4);
  @$pb.TagNumber(5)
  set searchLive(TwitchPlaylistSourceConfig_SearchLive value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSearchLive() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearchLive() => $_clearField(5);
  @$pb.TagNumber(5)
  TwitchPlaylistSourceConfig_SearchLive ensureSearchLive() => $_ensure(4);
}

class YoutubeMediaSourceConfig extends $pb.GeneratedMessage {
  factory YoutubeMediaSourceConfig({
    $core.String? videoId,
    $core.bool? shared,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    if (shared != null) result.shared = shared;
    return result;
  }

  YoutubeMediaSourceConfig._();

  factory YoutubeMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubeMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubeMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubeMediaSourceConfig copyWith(
          void Function(YoutubeMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as YoutubeMediaSourceConfig))
          as YoutubeMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubeMediaSourceConfig create() => YoutubeMediaSourceConfig._();
  @$core.override
  YoutubeMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubeMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<YoutubeMediaSourceConfig>(create);
  static YoutubeMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

class YoutubePlaylistSourceConfig_Playlist extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig_Playlist({
    $core.String? playlistId,
  }) {
    final result = create();
    if (playlistId != null) result.playlistId = playlistId;
    return result;
  }

  YoutubePlaylistSourceConfig_Playlist._();

  factory YoutubePlaylistSourceConfig_Playlist.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig_Playlist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig.Playlist',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'playlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Playlist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Playlist copyWith(
          void Function(YoutubePlaylistSourceConfig_Playlist) updates) =>
      super.copyWith((message) =>
              updates(message as YoutubePlaylistSourceConfig_Playlist))
          as YoutubePlaylistSourceConfig_Playlist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Playlist create() =>
      YoutubePlaylistSourceConfig_Playlist._();
  @$core.override
  YoutubePlaylistSourceConfig_Playlist createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Playlist getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          YoutubePlaylistSourceConfig_Playlist>(create);
  static YoutubePlaylistSourceConfig_Playlist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set playlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaylistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaylistId() => $_clearField(1);
}

class YoutubePlaylistSourceConfig_Channel extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig_Channel({
    $core.String? channelId,
    YoutubeChannelContent? content,
  }) {
    final result = create();
    if (channelId != null) result.channelId = channelId;
    if (content != null) result.content = content;
    return result;
  }

  YoutubePlaylistSourceConfig_Channel._();

  factory YoutubePlaylistSourceConfig_Channel.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig_Channel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig.Channel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'channelId')
    ..aE<YoutubeChannelContent>(2, _omitFieldNames ? '' : 'content',
        enumValues: YoutubeChannelContent.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Channel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Channel copyWith(
          void Function(YoutubePlaylistSourceConfig_Channel) updates) =>
      super.copyWith((message) =>
              updates(message as YoutubePlaylistSourceConfig_Channel))
          as YoutubePlaylistSourceConfig_Channel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Channel create() =>
      YoutubePlaylistSourceConfig_Channel._();
  @$core.override
  YoutubePlaylistSourceConfig_Channel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Channel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          YoutubePlaylistSourceConfig_Channel>(create);
  static YoutubePlaylistSourceConfig_Channel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  YoutubeChannelContent get content => $_getN(1);
  @$pb.TagNumber(2)
  set content(YoutubeChannelContent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

class YoutubePlaylistSourceConfig_Search extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig_Search({
    $core.String? query,
  }) {
    final result = create();
    if (query != null) result.query = query;
    return result;
  }

  YoutubePlaylistSourceConfig_Search._();

  factory YoutubePlaylistSourceConfig_Search.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig_Search.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig.Search',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Search clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Search copyWith(
          void Function(YoutubePlaylistSourceConfig_Search) updates) =>
      super.copyWith((message) =>
              updates(message as YoutubePlaylistSourceConfig_Search))
          as YoutubePlaylistSourceConfig_Search;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Search create() =>
      YoutubePlaylistSourceConfig_Search._();
  @$core.override
  YoutubePlaylistSourceConfig_Search createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Search getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<YoutubePlaylistSourceConfig_Search>(
          create);
  static YoutubePlaylistSourceConfig_Search? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);
}

class YoutubePlaylistSourceConfig_Subscriptions extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig_Subscriptions() => create();

  YoutubePlaylistSourceConfig_Subscriptions._();

  factory YoutubePlaylistSourceConfig_Subscriptions.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig_Subscriptions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig.Subscriptions',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Subscriptions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_Subscriptions copyWith(
          void Function(YoutubePlaylistSourceConfig_Subscriptions) updates) =>
      super.copyWith((message) =>
              updates(message as YoutubePlaylistSourceConfig_Subscriptions))
          as YoutubePlaylistSourceConfig_Subscriptions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Subscriptions create() =>
      YoutubePlaylistSourceConfig_Subscriptions._();
  @$core.override
  YoutubePlaylistSourceConfig_Subscriptions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_Subscriptions getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          YoutubePlaylistSourceConfig_Subscriptions>(create);
  static YoutubePlaylistSourceConfig_Subscriptions? _defaultInstance;
}

class YoutubePlaylistSourceConfig_LikedVideos extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig_LikedVideos() => create();

  YoutubePlaylistSourceConfig_LikedVideos._();

  factory YoutubePlaylistSourceConfig_LikedVideos.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig_LikedVideos.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig.LikedVideos',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_LikedVideos clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_LikedVideos copyWith(
          void Function(YoutubePlaylistSourceConfig_LikedVideos) updates) =>
      super.copyWith((message) =>
              updates(message as YoutubePlaylistSourceConfig_LikedVideos))
          as YoutubePlaylistSourceConfig_LikedVideos;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_LikedVideos create() =>
      YoutubePlaylistSourceConfig_LikedVideos._();
  @$core.override
  YoutubePlaylistSourceConfig_LikedVideos createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_LikedVideos getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          YoutubePlaylistSourceConfig_LikedVideos>(create);
  static YoutubePlaylistSourceConfig_LikedVideos? _defaultInstance;
}

class YoutubePlaylistSourceConfig_WatchLater extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig_WatchLater() => create();

  YoutubePlaylistSourceConfig_WatchLater._();

  factory YoutubePlaylistSourceConfig_WatchLater.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig_WatchLater.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig.WatchLater',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_WatchLater clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig_WatchLater copyWith(
          void Function(YoutubePlaylistSourceConfig_WatchLater) updates) =>
      super.copyWith((message) =>
              updates(message as YoutubePlaylistSourceConfig_WatchLater))
          as YoutubePlaylistSourceConfig_WatchLater;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_WatchLater create() =>
      YoutubePlaylistSourceConfig_WatchLater._();
  @$core.override
  YoutubePlaylistSourceConfig_WatchLater createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig_WatchLater getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          YoutubePlaylistSourceConfig_WatchLater>(create);
  static YoutubePlaylistSourceConfig_WatchLater? _defaultInstance;
}

enum YoutubePlaylistSourceConfig_Source {
  playlist,
  channel,
  search,
  subscriptions,
  likedVideos,
  watchLater,
  notSet
}

class YoutubePlaylistSourceConfig extends $pb.GeneratedMessage {
  factory YoutubePlaylistSourceConfig({
    $core.bool? shared,
    YoutubePlaylistSourceConfig_Playlist? playlist,
    YoutubePlaylistSourceConfig_Channel? channel,
    YoutubePlaylistSourceConfig_Search? search,
    YoutubePlaylistSourceConfig_Subscriptions? subscriptions,
    YoutubePlaylistSourceConfig_LikedVideos? likedVideos,
    YoutubePlaylistSourceConfig_WatchLater? watchLater,
  }) {
    final result = create();
    if (shared != null) result.shared = shared;
    if (playlist != null) result.playlist = playlist;
    if (channel != null) result.channel = channel;
    if (search != null) result.search = search;
    if (subscriptions != null) result.subscriptions = subscriptions;
    if (likedVideos != null) result.likedVideos = likedVideos;
    if (watchLater != null) result.watchLater = watchLater;
    return result;
  }

  YoutubePlaylistSourceConfig._();

  factory YoutubePlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory YoutubePlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, YoutubePlaylistSourceConfig_Source>
      _YoutubePlaylistSourceConfig_SourceByTag = {
    2: YoutubePlaylistSourceConfig_Source.playlist,
    3: YoutubePlaylistSourceConfig_Source.channel,
    4: YoutubePlaylistSourceConfig_Source.search,
    5: YoutubePlaylistSourceConfig_Source.subscriptions,
    6: YoutubePlaylistSourceConfig_Source.likedVideos,
    7: YoutubePlaylistSourceConfig_Source.watchLater,
    0: YoutubePlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'YoutubePlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7])
    ..aOB(1, _omitFieldNames ? '' : 'shared')
    ..aOM<YoutubePlaylistSourceConfig_Playlist>(
        2, _omitFieldNames ? '' : 'playlist',
        subBuilder: YoutubePlaylistSourceConfig_Playlist.create)
    ..aOM<YoutubePlaylistSourceConfig_Channel>(
        3, _omitFieldNames ? '' : 'channel',
        subBuilder: YoutubePlaylistSourceConfig_Channel.create)
    ..aOM<YoutubePlaylistSourceConfig_Search>(
        4, _omitFieldNames ? '' : 'search',
        subBuilder: YoutubePlaylistSourceConfig_Search.create)
    ..aOM<YoutubePlaylistSourceConfig_Subscriptions>(
        5, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: YoutubePlaylistSourceConfig_Subscriptions.create)
    ..aOM<YoutubePlaylistSourceConfig_LikedVideos>(
        6, _omitFieldNames ? '' : 'likedVideos',
        subBuilder: YoutubePlaylistSourceConfig_LikedVideos.create)
    ..aOM<YoutubePlaylistSourceConfig_WatchLater>(
        7, _omitFieldNames ? '' : 'watchLater',
        subBuilder: YoutubePlaylistSourceConfig_WatchLater.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  YoutubePlaylistSourceConfig copyWith(
          void Function(YoutubePlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as YoutubePlaylistSourceConfig))
          as YoutubePlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig create() =>
      YoutubePlaylistSourceConfig._();
  @$core.override
  YoutubePlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static YoutubePlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<YoutubePlaylistSourceConfig>(create);
  static YoutubePlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  YoutubePlaylistSourceConfig_Source whichSource() =>
      _YoutubePlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get shared => $_getBF(0);
  @$pb.TagNumber(1)
  set shared($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShared() => $_has(0);
  @$pb.TagNumber(1)
  void clearShared() => $_clearField(1);

  @$pb.TagNumber(2)
  YoutubePlaylistSourceConfig_Playlist get playlist => $_getN(1);
  @$pb.TagNumber(2)
  set playlist(YoutubePlaylistSourceConfig_Playlist value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaylist() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaylist() => $_clearField(2);
  @$pb.TagNumber(2)
  YoutubePlaylistSourceConfig_Playlist ensurePlaylist() => $_ensure(1);

  @$pb.TagNumber(3)
  YoutubePlaylistSourceConfig_Channel get channel => $_getN(2);
  @$pb.TagNumber(3)
  set channel(YoutubePlaylistSourceConfig_Channel value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChannel() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannel() => $_clearField(3);
  @$pb.TagNumber(3)
  YoutubePlaylistSourceConfig_Channel ensureChannel() => $_ensure(2);

  @$pb.TagNumber(4)
  YoutubePlaylistSourceConfig_Search get search => $_getN(3);
  @$pb.TagNumber(4)
  set search(YoutubePlaylistSourceConfig_Search value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);
  @$pb.TagNumber(4)
  YoutubePlaylistSourceConfig_Search ensureSearch() => $_ensure(3);

  @$pb.TagNumber(5)
  YoutubePlaylistSourceConfig_Subscriptions get subscriptions => $_getN(4);
  @$pb.TagNumber(5)
  set subscriptions(YoutubePlaylistSourceConfig_Subscriptions value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSubscriptions() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubscriptions() => $_clearField(5);
  @$pb.TagNumber(5)
  YoutubePlaylistSourceConfig_Subscriptions ensureSubscriptions() =>
      $_ensure(4);

  @$pb.TagNumber(6)
  YoutubePlaylistSourceConfig_LikedVideos get likedVideos => $_getN(5);
  @$pb.TagNumber(6)
  set likedVideos(YoutubePlaylistSourceConfig_LikedVideos value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLikedVideos() => $_has(5);
  @$pb.TagNumber(6)
  void clearLikedVideos() => $_clearField(6);
  @$pb.TagNumber(6)
  YoutubePlaylistSourceConfig_LikedVideos ensureLikedVideos() => $_ensure(5);

  @$pb.TagNumber(7)
  YoutubePlaylistSourceConfig_WatchLater get watchLater => $_getN(6);
  @$pb.TagNumber(7)
  set watchLater(YoutubePlaylistSourceConfig_WatchLater value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWatchLater() => $_has(6);
  @$pb.TagNumber(7)
  void clearWatchLater() => $_clearField(7);
  @$pb.TagNumber(7)
  YoutubePlaylistSourceConfig_WatchLater ensureWatchLater() => $_ensure(6);
}

class HuyaLiveSourceConfig extends $pb.GeneratedMessage {
  factory HuyaLiveSourceConfig({
    $core.String? roomId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    return result;
  }

  HuyaLiveSourceConfig._();

  factory HuyaLiveSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HuyaLiveSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HuyaLiveSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HuyaLiveSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HuyaLiveSourceConfig copyWith(void Function(HuyaLiveSourceConfig) updates) =>
      super.copyWith((message) => updates(message as HuyaLiveSourceConfig))
          as HuyaLiveSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HuyaLiveSourceConfig create() => HuyaLiveSourceConfig._();
  @$core.override
  HuyaLiveSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HuyaLiveSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HuyaLiveSourceConfig>(create);
  static HuyaLiveSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);
}

class HuyaVideoSourceConfig extends $pb.GeneratedMessage {
  factory HuyaVideoSourceConfig({
    $core.String? videoId,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    return result;
  }

  HuyaVideoSourceConfig._();

  factory HuyaVideoSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HuyaVideoSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HuyaVideoSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HuyaVideoSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HuyaVideoSourceConfig copyWith(
          void Function(HuyaVideoSourceConfig) updates) =>
      super.copyWith((message) => updates(message as HuyaVideoSourceConfig))
          as HuyaVideoSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HuyaVideoSourceConfig create() => HuyaVideoSourceConfig._();
  @$core.override
  HuyaVideoSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HuyaVideoSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HuyaVideoSourceConfig>(create);
  static HuyaVideoSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);
}

enum HuyaMediaSourceConfig_Source { live, video, notSet }

class HuyaMediaSourceConfig extends $pb.GeneratedMessage {
  factory HuyaMediaSourceConfig({
    HuyaLiveSourceConfig? live,
    HuyaVideoSourceConfig? video,
  }) {
    final result = create();
    if (live != null) result.live = live;
    if (video != null) result.video = video;
    return result;
  }

  HuyaMediaSourceConfig._();

  factory HuyaMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HuyaMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, HuyaMediaSourceConfig_Source>
      _HuyaMediaSourceConfig_SourceByTag = {
    1: HuyaMediaSourceConfig_Source.live,
    2: HuyaMediaSourceConfig_Source.video,
    0: HuyaMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HuyaMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<HuyaLiveSourceConfig>(1, _omitFieldNames ? '' : 'live',
        subBuilder: HuyaLiveSourceConfig.create)
    ..aOM<HuyaVideoSourceConfig>(2, _omitFieldNames ? '' : 'video',
        subBuilder: HuyaVideoSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HuyaMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HuyaMediaSourceConfig copyWith(
          void Function(HuyaMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as HuyaMediaSourceConfig))
          as HuyaMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HuyaMediaSourceConfig create() => HuyaMediaSourceConfig._();
  @$core.override
  HuyaMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HuyaMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HuyaMediaSourceConfig>(create);
  static HuyaMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  HuyaMediaSourceConfig_Source whichSource() =>
      _HuyaMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  HuyaLiveSourceConfig get live => $_getN(0);
  @$pb.TagNumber(1)
  set live(HuyaLiveSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLive() => $_has(0);
  @$pb.TagNumber(1)
  void clearLive() => $_clearField(1);
  @$pb.TagNumber(1)
  HuyaLiveSourceConfig ensureLive() => $_ensure(0);

  @$pb.TagNumber(2)
  HuyaVideoSourceConfig get video => $_getN(1);
  @$pb.TagNumber(2)
  set video(HuyaVideoSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVideo() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideo() => $_clearField(2);
  @$pb.TagNumber(2)
  HuyaVideoSourceConfig ensureVideo() => $_ensure(1);
}

class DouyuMediaSourceConfig extends $pb.GeneratedMessage {
  factory DouyuMediaSourceConfig({
    $core.String? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  DouyuMediaSourceConfig._();

  factory DouyuMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyuMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyuMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'room')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyuMediaSourceConfig copyWith(
          void Function(DouyuMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as DouyuMediaSourceConfig))
          as DouyuMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyuMediaSourceConfig create() => DouyuMediaSourceConfig._();
  @$core.override
  DouyuMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyuMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyuMediaSourceConfig>(create);
  static DouyuMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get room => $_getSZ(0);
  @$pb.TagNumber(1)
  set room($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
}

class DouyinVideoSourceConfig extends $pb.GeneratedMessage {
  factory DouyinVideoSourceConfig({
    $core.String? awemeId,
    $core.bool? shared,
  }) {
    final result = create();
    if (awemeId != null) result.awemeId = awemeId;
    if (shared != null) result.shared = shared;
    return result;
  }

  DouyinVideoSourceConfig._();

  factory DouyinVideoSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyinVideoSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyinVideoSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'awemeId')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinVideoSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinVideoSourceConfig copyWith(
          void Function(DouyinVideoSourceConfig) updates) =>
      super.copyWith((message) => updates(message as DouyinVideoSourceConfig))
          as DouyinVideoSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyinVideoSourceConfig create() => DouyinVideoSourceConfig._();
  @$core.override
  DouyinVideoSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyinVideoSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyinVideoSourceConfig>(create);
  static DouyinVideoSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get awemeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set awemeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAwemeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAwemeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

class DouyinLiveSourceConfig extends $pb.GeneratedMessage {
  factory DouyinLiveSourceConfig({
    $core.String? webRid,
    $core.bool? shared,
  }) {
    final result = create();
    if (webRid != null) result.webRid = webRid;
    if (shared != null) result.shared = shared;
    return result;
  }

  DouyinLiveSourceConfig._();

  factory DouyinLiveSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyinLiveSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyinLiveSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'webRid')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinLiveSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinLiveSourceConfig copyWith(
          void Function(DouyinLiveSourceConfig) updates) =>
      super.copyWith((message) => updates(message as DouyinLiveSourceConfig))
          as DouyinLiveSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyinLiveSourceConfig create() => DouyinLiveSourceConfig._();
  @$core.override
  DouyinLiveSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyinLiveSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyinLiveSourceConfig>(create);
  static DouyinLiveSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get webRid => $_getSZ(0);
  @$pb.TagNumber(1)
  set webRid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWebRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearWebRid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

enum DouyinMediaSourceConfig_Source { video, live, notSet }

class DouyinMediaSourceConfig extends $pb.GeneratedMessage {
  factory DouyinMediaSourceConfig({
    DouyinVideoSourceConfig? video,
    DouyinLiveSourceConfig? live,
  }) {
    final result = create();
    if (video != null) result.video = video;
    if (live != null) result.live = live;
    return result;
  }

  DouyinMediaSourceConfig._();

  factory DouyinMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyinMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DouyinMediaSourceConfig_Source>
      _DouyinMediaSourceConfig_SourceByTag = {
    1: DouyinMediaSourceConfig_Source.video,
    2: DouyinMediaSourceConfig_Source.live,
    0: DouyinMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyinMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<DouyinVideoSourceConfig>(1, _omitFieldNames ? '' : 'video',
        subBuilder: DouyinVideoSourceConfig.create)
    ..aOM<DouyinLiveSourceConfig>(2, _omitFieldNames ? '' : 'live',
        subBuilder: DouyinLiveSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinMediaSourceConfig copyWith(
          void Function(DouyinMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as DouyinMediaSourceConfig))
          as DouyinMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyinMediaSourceConfig create() => DouyinMediaSourceConfig._();
  @$core.override
  DouyinMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyinMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyinMediaSourceConfig>(create);
  static DouyinMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  DouyinMediaSourceConfig_Source whichSource() =>
      _DouyinMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  DouyinVideoSourceConfig get video => $_getN(0);
  @$pb.TagNumber(1)
  set video(DouyinVideoSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideo() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideo() => $_clearField(1);
  @$pb.TagNumber(1)
  DouyinVideoSourceConfig ensureVideo() => $_ensure(0);

  @$pb.TagNumber(2)
  DouyinLiveSourceConfig get live => $_getN(1);
  @$pb.TagNumber(2)
  set live(DouyinLiveSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLive() => $_has(1);
  @$pb.TagNumber(2)
  void clearLive() => $_clearField(2);
  @$pb.TagNumber(2)
  DouyinLiveSourceConfig ensureLive() => $_ensure(1);
}

class DouyinPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory DouyinPlaylistSourceConfig({
    $core.String? secUid,
    $core.bool? shared,
  }) {
    final result = create();
    if (secUid != null) result.secUid = secUid;
    if (shared != null) result.shared = shared;
    return result;
  }

  DouyinPlaylistSourceConfig._();

  factory DouyinPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DouyinPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DouyinPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'secUid')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DouyinPlaylistSourceConfig copyWith(
          void Function(DouyinPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as DouyinPlaylistSourceConfig))
          as DouyinPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DouyinPlaylistSourceConfig create() => DouyinPlaylistSourceConfig._();
  @$core.override
  DouyinPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DouyinPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DouyinPlaylistSourceConfig>(create);
  static DouyinPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get secUid => $_getSZ(0);
  @$pb.TagNumber(1)
  set secUid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

class AcFunVideoSourceConfig extends $pb.GeneratedMessage {
  factory AcFunVideoSourceConfig({
    $core.String? videoId,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    return result;
  }

  AcFunVideoSourceConfig._();

  factory AcFunVideoSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcFunVideoSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcFunVideoSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunVideoSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunVideoSourceConfig copyWith(
          void Function(AcFunVideoSourceConfig) updates) =>
      super.copyWith((message) => updates(message as AcFunVideoSourceConfig))
          as AcFunVideoSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcFunVideoSourceConfig create() => AcFunVideoSourceConfig._();
  @$core.override
  AcFunVideoSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcFunVideoSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcFunVideoSourceConfig>(create);
  static AcFunVideoSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);
}

class AcFunBangumiSourceConfig extends $pb.GeneratedMessage {
  factory AcFunBangumiSourceConfig({
    $core.String? bangumiId,
    $core.String? episodeQuery,
  }) {
    final result = create();
    if (bangumiId != null) result.bangumiId = bangumiId;
    if (episodeQuery != null) result.episodeQuery = episodeQuery;
    return result;
  }

  AcFunBangumiSourceConfig._();

  factory AcFunBangumiSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcFunBangumiSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcFunBangumiSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bangumiId')
    ..aOS(2, _omitFieldNames ? '' : 'episodeQuery')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunBangumiSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunBangumiSourceConfig copyWith(
          void Function(AcFunBangumiSourceConfig) updates) =>
      super.copyWith((message) => updates(message as AcFunBangumiSourceConfig))
          as AcFunBangumiSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcFunBangumiSourceConfig create() => AcFunBangumiSourceConfig._();
  @$core.override
  AcFunBangumiSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcFunBangumiSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcFunBangumiSourceConfig>(create);
  static AcFunBangumiSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bangumiId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bangumiId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBangumiId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBangumiId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get episodeQuery => $_getSZ(1);
  @$pb.TagNumber(2)
  set episodeQuery($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEpisodeQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearEpisodeQuery() => $_clearField(2);
}

class AcFunLiveSourceConfig extends $pb.GeneratedMessage {
  factory AcFunLiveSourceConfig({
    $core.String? authorId,
  }) {
    final result = create();
    if (authorId != null) result.authorId = authorId;
    return result;
  }

  AcFunLiveSourceConfig._();

  factory AcFunLiveSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcFunLiveSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcFunLiveSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authorId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunLiveSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunLiveSourceConfig copyWith(
          void Function(AcFunLiveSourceConfig) updates) =>
      super.copyWith((message) => updates(message as AcFunLiveSourceConfig))
          as AcFunLiveSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcFunLiveSourceConfig create() => AcFunLiveSourceConfig._();
  @$core.override
  AcFunLiveSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcFunLiveSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcFunLiveSourceConfig>(create);
  static AcFunLiveSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get authorId => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorId() => $_clearField(1);
}

enum AcFunMediaSourceConfig_Source { video, bangumi, live, notSet }

class AcFunMediaSourceConfig extends $pb.GeneratedMessage {
  factory AcFunMediaSourceConfig({
    AcFunVideoSourceConfig? video,
    AcFunBangumiSourceConfig? bangumi,
    AcFunLiveSourceConfig? live,
  }) {
    final result = create();
    if (video != null) result.video = video;
    if (bangumi != null) result.bangumi = bangumi;
    if (live != null) result.live = live;
    return result;
  }

  AcFunMediaSourceConfig._();

  factory AcFunMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcFunMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AcFunMediaSourceConfig_Source>
      _AcFunMediaSourceConfig_SourceByTag = {
    1: AcFunMediaSourceConfig_Source.video,
    2: AcFunMediaSourceConfig_Source.bangumi,
    3: AcFunMediaSourceConfig_Source.live,
    0: AcFunMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcFunMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<AcFunVideoSourceConfig>(1, _omitFieldNames ? '' : 'video',
        subBuilder: AcFunVideoSourceConfig.create)
    ..aOM<AcFunBangumiSourceConfig>(2, _omitFieldNames ? '' : 'bangumi',
        subBuilder: AcFunBangumiSourceConfig.create)
    ..aOM<AcFunLiveSourceConfig>(3, _omitFieldNames ? '' : 'live',
        subBuilder: AcFunLiveSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcFunMediaSourceConfig copyWith(
          void Function(AcFunMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as AcFunMediaSourceConfig))
          as AcFunMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcFunMediaSourceConfig create() => AcFunMediaSourceConfig._();
  @$core.override
  AcFunMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcFunMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcFunMediaSourceConfig>(create);
  static AcFunMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  AcFunMediaSourceConfig_Source whichSource() =>
      _AcFunMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AcFunVideoSourceConfig get video => $_getN(0);
  @$pb.TagNumber(1)
  set video(AcFunVideoSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideo() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideo() => $_clearField(1);
  @$pb.TagNumber(1)
  AcFunVideoSourceConfig ensureVideo() => $_ensure(0);

  @$pb.TagNumber(2)
  AcFunBangumiSourceConfig get bangumi => $_getN(1);
  @$pb.TagNumber(2)
  set bangumi(AcFunBangumiSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBangumi() => $_has(1);
  @$pb.TagNumber(2)
  void clearBangumi() => $_clearField(2);
  @$pb.TagNumber(2)
  AcFunBangumiSourceConfig ensureBangumi() => $_ensure(1);

  @$pb.TagNumber(3)
  AcFunLiveSourceConfig get live => $_getN(2);
  @$pb.TagNumber(3)
  set live(AcFunLiveSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLive() => $_has(2);
  @$pb.TagNumber(3)
  void clearLive() => $_clearField(3);
  @$pb.TagNumber(3)
  AcFunLiveSourceConfig ensureLive() => $_ensure(2);
}

class CctvMediaSourceConfig extends $pb.GeneratedMessage {
  factory CctvMediaSourceConfig({
    $core.String? resource,
  }) {
    final result = create();
    if (resource != null) result.resource = resource;
    return result;
  }

  CctvMediaSourceConfig._();

  factory CctvMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CctvMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CctvMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resource')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CctvMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CctvMediaSourceConfig copyWith(
          void Function(CctvMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as CctvMediaSourceConfig))
          as CctvMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CctvMediaSourceConfig create() => CctvMediaSourceConfig._();
  @$core.override
  CctvMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CctvMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CctvMediaSourceConfig>(create);
  static CctvMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resource => $_getSZ(0);
  @$pb.TagNumber(1)
  set resource($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResource() => $_has(0);
  @$pb.TagNumber(1)
  void clearResource() => $_clearField(1);
}

class FnosFileSourceConfig extends $pb.GeneratedMessage {
  factory FnosFileSourceConfig({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  FnosFileSourceConfig._();

  factory FnosFileSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosFileSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosFileSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosFileSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosFileSourceConfig copyWith(void Function(FnosFileSourceConfig) updates) =>
      super.copyWith((message) => updates(message as FnosFileSourceConfig))
          as FnosFileSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosFileSourceConfig create() => FnosFileSourceConfig._();
  @$core.override
  FnosFileSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosFileSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosFileSourceConfig>(create);
  static FnosFileSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class FnosLibraryItemSourceConfig extends $pb.GeneratedMessage {
  factory FnosLibraryItemSourceConfig({
    $core.String? itemGuid,
    $core.String? mediaGuid,
  }) {
    final result = create();
    if (itemGuid != null) result.itemGuid = itemGuid;
    if (mediaGuid != null) result.mediaGuid = mediaGuid;
    return result;
  }

  FnosLibraryItemSourceConfig._();

  factory FnosLibraryItemSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosLibraryItemSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosLibraryItemSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemGuid')
    ..aOS(2, _omitFieldNames ? '' : 'mediaGuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosLibraryItemSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosLibraryItemSourceConfig copyWith(
          void Function(FnosLibraryItemSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as FnosLibraryItemSourceConfig))
          as FnosLibraryItemSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosLibraryItemSourceConfig create() =>
      FnosLibraryItemSourceConfig._();
  @$core.override
  FnosLibraryItemSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosLibraryItemSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosLibraryItemSourceConfig>(create);
  static FnosLibraryItemSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemGuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemGuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemGuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemGuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaGuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaGuid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaGuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaGuid() => $_clearField(2);
}

enum FnosMediaSourceConfig_Source { file, libraryItem, notSet }

class FnosMediaSourceConfig extends $pb.GeneratedMessage {
  factory FnosMediaSourceConfig({
    $core.String? serverId,
    FnosFileSourceConfig? file,
    FnosLibraryItemSourceConfig? libraryItem,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (file != null) result.file = file;
    if (libraryItem != null) result.libraryItem = libraryItem;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  FnosMediaSourceConfig._();

  factory FnosMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FnosMediaSourceConfig_Source>
      _FnosMediaSourceConfig_SourceByTag = {
    2: FnosMediaSourceConfig_Source.file,
    3: FnosMediaSourceConfig_Source.libraryItem,
    0: FnosMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<FnosFileSourceConfig>(2, _omitFieldNames ? '' : 'file',
        subBuilder: FnosFileSourceConfig.create)
    ..aOM<FnosLibraryItemSourceConfig>(3, _omitFieldNames ? '' : 'libraryItem',
        subBuilder: FnosLibraryItemSourceConfig.create)
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosMediaSourceConfig copyWith(
          void Function(FnosMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as FnosMediaSourceConfig))
          as FnosMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosMediaSourceConfig create() => FnosMediaSourceConfig._();
  @$core.override
  FnosMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosMediaSourceConfig>(create);
  static FnosMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  FnosMediaSourceConfig_Source whichSource() =>
      _FnosMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  FnosFileSourceConfig get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(FnosFileSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);
  @$pb.TagNumber(2)
  FnosFileSourceConfig ensureFile() => $_ensure(1);

  @$pb.TagNumber(3)
  FnosLibraryItemSourceConfig get libraryItem => $_getN(2);
  @$pb.TagNumber(3)
  set libraryItem(FnosLibraryItemSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLibraryItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearLibraryItem() => $_clearField(3);
  @$pb.TagNumber(3)
  FnosLibraryItemSourceConfig ensureLibraryItem() => $_ensure(2);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class FnosFilesPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory FnosFilesPlaylistSourceConfig({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  FnosFilesPlaylistSourceConfig._();

  factory FnosFilesPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosFilesPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosFilesPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosFilesPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosFilesPlaylistSourceConfig copyWith(
          void Function(FnosFilesPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as FnosFilesPlaylistSourceConfig))
          as FnosFilesPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosFilesPlaylistSourceConfig create() =>
      FnosFilesPlaylistSourceConfig._();
  @$core.override
  FnosFilesPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosFilesPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosFilesPlaylistSourceConfig>(create);
  static FnosFilesPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class FnosMediaLibraryPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory FnosMediaLibraryPlaylistSourceConfig({
    $core.String? libraryGuid,
    $core.Iterable<$core.String>? mediaTypes,
    $core.String? parentGuid,
  }) {
    final result = create();
    if (libraryGuid != null) result.libraryGuid = libraryGuid;
    if (mediaTypes != null) result.mediaTypes.addAll(mediaTypes);
    if (parentGuid != null) result.parentGuid = parentGuid;
    return result;
  }

  FnosMediaLibraryPlaylistSourceConfig._();

  factory FnosMediaLibraryPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosMediaLibraryPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosMediaLibraryPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'libraryGuid')
    ..pPS(2, _omitFieldNames ? '' : 'mediaTypes')
    ..aOS(3, _omitFieldNames ? '' : 'parentGuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosMediaLibraryPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosMediaLibraryPlaylistSourceConfig copyWith(
          void Function(FnosMediaLibraryPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as FnosMediaLibraryPlaylistSourceConfig))
          as FnosMediaLibraryPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosMediaLibraryPlaylistSourceConfig create() =>
      FnosMediaLibraryPlaylistSourceConfig._();
  @$core.override
  FnosMediaLibraryPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosMediaLibraryPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          FnosMediaLibraryPlaylistSourceConfig>(create);
  static FnosMediaLibraryPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get libraryGuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryGuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryGuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryGuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get mediaTypes => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get parentGuid => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentGuid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParentGuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentGuid() => $_clearField(3);
}

class FnosFavoritesPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory FnosFavoritesPlaylistSourceConfig({
    $core.Iterable<$core.String>? mediaTypes,
  }) {
    final result = create();
    if (mediaTypes != null) result.mediaTypes.addAll(mediaTypes);
    return result;
  }

  FnosFavoritesPlaylistSourceConfig._();

  factory FnosFavoritesPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosFavoritesPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosFavoritesPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'mediaTypes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosFavoritesPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosFavoritesPlaylistSourceConfig copyWith(
          void Function(FnosFavoritesPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as FnosFavoritesPlaylistSourceConfig))
          as FnosFavoritesPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosFavoritesPlaylistSourceConfig create() =>
      FnosFavoritesPlaylistSourceConfig._();
  @$core.override
  FnosFavoritesPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosFavoritesPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosFavoritesPlaylistSourceConfig>(
          create);
  static FnosFavoritesPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get mediaTypes => $_getList(0);
}

class FnosHistoryPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory FnosHistoryPlaylistSourceConfig() => create();

  FnosHistoryPlaylistSourceConfig._();

  factory FnosHistoryPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosHistoryPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosHistoryPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosHistoryPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosHistoryPlaylistSourceConfig copyWith(
          void Function(FnosHistoryPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as FnosHistoryPlaylistSourceConfig))
          as FnosHistoryPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosHistoryPlaylistSourceConfig create() =>
      FnosHistoryPlaylistSourceConfig._();
  @$core.override
  FnosHistoryPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosHistoryPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosHistoryPlaylistSourceConfig>(
          create);
  static FnosHistoryPlaylistSourceConfig? _defaultInstance;
}

enum FnosPlaylistSourceConfig_Source {
  files,
  mediaLibrary,
  favorites,
  history,
  notSet
}

class FnosPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory FnosPlaylistSourceConfig({
    $core.String? serverId,
    FnosFilesPlaylistSourceConfig? files,
    FnosMediaLibraryPlaylistSourceConfig? mediaLibrary,
    FnosFavoritesPlaylistSourceConfig? favorites,
    FnosHistoryPlaylistSourceConfig? history,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (files != null) result.files = files;
    if (mediaLibrary != null) result.mediaLibrary = mediaLibrary;
    if (favorites != null) result.favorites = favorites;
    if (history != null) result.history = history;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  FnosPlaylistSourceConfig._();

  factory FnosPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FnosPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FnosPlaylistSourceConfig_Source>
      _FnosPlaylistSourceConfig_SourceByTag = {
    2: FnosPlaylistSourceConfig_Source.files,
    3: FnosPlaylistSourceConfig_Source.mediaLibrary,
    4: FnosPlaylistSourceConfig_Source.favorites,
    5: FnosPlaylistSourceConfig_Source.history,
    0: FnosPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FnosPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<FnosFilesPlaylistSourceConfig>(2, _omitFieldNames ? '' : 'files',
        subBuilder: FnosFilesPlaylistSourceConfig.create)
    ..aOM<FnosMediaLibraryPlaylistSourceConfig>(
        3, _omitFieldNames ? '' : 'mediaLibrary',
        subBuilder: FnosMediaLibraryPlaylistSourceConfig.create)
    ..aOM<FnosFavoritesPlaylistSourceConfig>(
        4, _omitFieldNames ? '' : 'favorites',
        subBuilder: FnosFavoritesPlaylistSourceConfig.create)
    ..aOM<FnosHistoryPlaylistSourceConfig>(5, _omitFieldNames ? '' : 'history',
        subBuilder: FnosHistoryPlaylistSourceConfig.create)
    ..aE<PlaybackProxyMode>(6, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FnosPlaylistSourceConfig copyWith(
          void Function(FnosPlaylistSourceConfig) updates) =>
      super.copyWith((message) => updates(message as FnosPlaylistSourceConfig))
          as FnosPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FnosPlaylistSourceConfig create() => FnosPlaylistSourceConfig._();
  @$core.override
  FnosPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FnosPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FnosPlaylistSourceConfig>(create);
  static FnosPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  FnosPlaylistSourceConfig_Source whichSource() =>
      _FnosPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  FnosFilesPlaylistSourceConfig get files => $_getN(1);
  @$pb.TagNumber(2)
  set files(FnosFilesPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFiles() => $_has(1);
  @$pb.TagNumber(2)
  void clearFiles() => $_clearField(2);
  @$pb.TagNumber(2)
  FnosFilesPlaylistSourceConfig ensureFiles() => $_ensure(1);

  @$pb.TagNumber(3)
  FnosMediaLibraryPlaylistSourceConfig get mediaLibrary => $_getN(2);
  @$pb.TagNumber(3)
  set mediaLibrary(FnosMediaLibraryPlaylistSourceConfig value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaLibrary() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaLibrary() => $_clearField(3);
  @$pb.TagNumber(3)
  FnosMediaLibraryPlaylistSourceConfig ensureMediaLibrary() => $_ensure(2);

  @$pb.TagNumber(4)
  FnosFavoritesPlaylistSourceConfig get favorites => $_getN(3);
  @$pb.TagNumber(4)
  set favorites(FnosFavoritesPlaylistSourceConfig value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFavorites() => $_has(3);
  @$pb.TagNumber(4)
  void clearFavorites() => $_clearField(4);
  @$pb.TagNumber(4)
  FnosFavoritesPlaylistSourceConfig ensureFavorites() => $_ensure(3);

  @$pb.TagNumber(5)
  FnosHistoryPlaylistSourceConfig get history => $_getN(4);
  @$pb.TagNumber(5)
  set history(FnosHistoryPlaylistSourceConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHistory() => $_has(4);
  @$pb.TagNumber(5)
  void clearHistory() => $_clearField(5);
  @$pb.TagNumber(5)
  FnosHistoryPlaylistSourceConfig ensureHistory() => $_ensure(4);

  @$pb.TagNumber(6)
  PlaybackProxyMode get proxyMode => $_getN(5);
  @$pb.TagNumber(6)
  set proxyMode(PlaybackProxyMode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasProxyMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearProxyMode() => $_clearField(6);
}

class QnapMediaSourceConfig extends $pb.GeneratedMessage {
  factory QnapMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  QnapMediaSourceConfig._();

  factory QnapMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QnapMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QnapMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aE<PlaybackProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QnapMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QnapMediaSourceConfig copyWith(
          void Function(QnapMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as QnapMediaSourceConfig))
          as QnapMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QnapMediaSourceConfig create() => QnapMediaSourceConfig._();
  @$core.override
  QnapMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QnapMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QnapMediaSourceConfig>(create);
  static QnapMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(PlaybackProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);
}

class QnapPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory QnapPlaylistSourceConfig({
    $core.String? serverId,
    $core.String? path,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  QnapPlaylistSourceConfig._();

  factory QnapPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QnapPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QnapPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aE<PlaybackProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QnapPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QnapPlaylistSourceConfig copyWith(
          void Function(QnapPlaylistSourceConfig) updates) =>
      super.copyWith((message) => updates(message as QnapPlaylistSourceConfig))
          as QnapPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QnapPlaylistSourceConfig create() => QnapPlaylistSourceConfig._();
  @$core.override
  QnapPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QnapPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QnapPlaylistSourceConfig>(create);
  static QnapPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(PlaybackProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);
}

class SynologyFileSourceConfig extends $pb.GeneratedMessage {
  factory SynologyFileSourceConfig({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  SynologyFileSourceConfig._();

  factory SynologyFileSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyFileSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyFileSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyFileSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyFileSourceConfig copyWith(
          void Function(SynologyFileSourceConfig) updates) =>
      super.copyWith((message) => updates(message as SynologyFileSourceConfig))
          as SynologyFileSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyFileSourceConfig create() => SynologyFileSourceConfig._();
  @$core.override
  SynologyFileSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyFileSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyFileSourceConfig>(create);
  static SynologyFileSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class SynologyLibraryItemSourceConfig extends $pb.GeneratedMessage {
  factory SynologyLibraryItemSourceConfig({
    SynologyLibraryItemKind? kind,
    $fixnum.Int64? itemId,
    $fixnum.Int64? fileId,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (itemId != null) result.itemId = itemId;
    if (fileId != null) result.fileId = fileId;
    return result;
  }

  SynologyLibraryItemSourceConfig._();

  factory SynologyLibraryItemSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyLibraryItemSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyLibraryItemSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aE<SynologyLibraryItemKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: SynologyLibraryItemKind.values)
    ..aInt64(2, _omitFieldNames ? '' : 'itemId')
    ..aInt64(3, _omitFieldNames ? '' : 'fileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyLibraryItemSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyLibraryItemSourceConfig copyWith(
          void Function(SynologyLibraryItemSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as SynologyLibraryItemSourceConfig))
          as SynologyLibraryItemSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyLibraryItemSourceConfig create() =>
      SynologyLibraryItemSourceConfig._();
  @$core.override
  SynologyLibraryItemSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyLibraryItemSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyLibraryItemSourceConfig>(
          create);
  static SynologyLibraryItemSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  SynologyLibraryItemKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SynologyLibraryItemKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get itemId => $_getI64(1);
  @$pb.TagNumber(2)
  set itemId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fileId => $_getI64(2);
  @$pb.TagNumber(3)
  set fileId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileId() => $_clearField(3);
}

enum SynologyMediaSourceConfig_Source { file, libraryItem, notSet }

class SynologyMediaSourceConfig extends $pb.GeneratedMessage {
  factory SynologyMediaSourceConfig({
    $core.String? serverId,
    SynologyFileSourceConfig? file,
    SynologyLibraryItemSourceConfig? libraryItem,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (file != null) result.file = file;
    if (libraryItem != null) result.libraryItem = libraryItem;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  SynologyMediaSourceConfig._();

  factory SynologyMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SynologyMediaSourceConfig_Source>
      _SynologyMediaSourceConfig_SourceByTag = {
    2: SynologyMediaSourceConfig_Source.file,
    3: SynologyMediaSourceConfig_Source.libraryItem,
    0: SynologyMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<SynologyFileSourceConfig>(2, _omitFieldNames ? '' : 'file',
        subBuilder: SynologyFileSourceConfig.create)
    ..aOM<SynologyLibraryItemSourceConfig>(
        3, _omitFieldNames ? '' : 'libraryItem',
        subBuilder: SynologyLibraryItemSourceConfig.create)
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyMediaSourceConfig copyWith(
          void Function(SynologyMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as SynologyMediaSourceConfig))
          as SynologyMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyMediaSourceConfig create() => SynologyMediaSourceConfig._();
  @$core.override
  SynologyMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyMediaSourceConfig>(create);
  static SynologyMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  SynologyMediaSourceConfig_Source whichSource() =>
      _SynologyMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  SynologyFileSourceConfig get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(SynologyFileSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);
  @$pb.TagNumber(2)
  SynologyFileSourceConfig ensureFile() => $_ensure(1);

  @$pb.TagNumber(3)
  SynologyLibraryItemSourceConfig get libraryItem => $_getN(2);
  @$pb.TagNumber(3)
  set libraryItem(SynologyLibraryItemSourceConfig value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLibraryItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearLibraryItem() => $_clearField(3);
  @$pb.TagNumber(3)
  SynologyLibraryItemSourceConfig ensureLibraryItem() => $_ensure(2);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class SynologyFilesPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyFilesPlaylistSourceConfig({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  SynologyFilesPlaylistSourceConfig._();

  factory SynologyFilesPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyFilesPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyFilesPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyFilesPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyFilesPlaylistSourceConfig copyWith(
          void Function(SynologyFilesPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SynologyFilesPlaylistSourceConfig))
          as SynologyFilesPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyFilesPlaylistSourceConfig create() =>
      SynologyFilesPlaylistSourceConfig._();
  @$core.override
  SynologyFilesPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyFilesPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyFilesPlaylistSourceConfig>(
          create);
  static SynologyFilesPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class SynologyMoviesPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyMoviesPlaylistSourceConfig({
    $fixnum.Int64? libraryId,
  }) {
    final result = create();
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  SynologyMoviesPlaylistSourceConfig._();

  factory SynologyMoviesPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyMoviesPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyMoviesPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyMoviesPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyMoviesPlaylistSourceConfig copyWith(
          void Function(SynologyMoviesPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SynologyMoviesPlaylistSourceConfig))
          as SynologyMoviesPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyMoviesPlaylistSourceConfig create() =>
      SynologyMoviesPlaylistSourceConfig._();
  @$core.override
  SynologyMoviesPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyMoviesPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyMoviesPlaylistSourceConfig>(
          create);
  static SynologyMoviesPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get libraryId => $_getI64(0);
  @$pb.TagNumber(1)
  set libraryId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);
}

class SynologyTvShowsPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyTvShowsPlaylistSourceConfig({
    $fixnum.Int64? libraryId,
  }) {
    final result = create();
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  SynologyTvShowsPlaylistSourceConfig._();

  factory SynologyTvShowsPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyTvShowsPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyTvShowsPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyTvShowsPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyTvShowsPlaylistSourceConfig copyWith(
          void Function(SynologyTvShowsPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SynologyTvShowsPlaylistSourceConfig))
          as SynologyTvShowsPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyTvShowsPlaylistSourceConfig create() =>
      SynologyTvShowsPlaylistSourceConfig._();
  @$core.override
  SynologyTvShowsPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyTvShowsPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SynologyTvShowsPlaylistSourceConfig>(create);
  static SynologyTvShowsPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get libraryId => $_getI64(0);
  @$pb.TagNumber(1)
  set libraryId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);
}

class SynologyEpisodesPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyEpisodesPlaylistSourceConfig({
    $fixnum.Int64? libraryId,
    $fixnum.Int64? tvShowId,
  }) {
    final result = create();
    if (libraryId != null) result.libraryId = libraryId;
    if (tvShowId != null) result.tvShowId = tvShowId;
    return result;
  }

  SynologyEpisodesPlaylistSourceConfig._();

  factory SynologyEpisodesPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyEpisodesPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyEpisodesPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'libraryId')
    ..aInt64(2, _omitFieldNames ? '' : 'tvShowId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyEpisodesPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyEpisodesPlaylistSourceConfig copyWith(
          void Function(SynologyEpisodesPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SynologyEpisodesPlaylistSourceConfig))
          as SynologyEpisodesPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyEpisodesPlaylistSourceConfig create() =>
      SynologyEpisodesPlaylistSourceConfig._();
  @$core.override
  SynologyEpisodesPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyEpisodesPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SynologyEpisodesPlaylistSourceConfig>(create);
  static SynologyEpisodesPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get libraryId => $_getI64(0);
  @$pb.TagNumber(1)
  set libraryId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get tvShowId => $_getI64(1);
  @$pb.TagNumber(2)
  set tvShowId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTvShowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTvShowId() => $_clearField(2);
}

class SynologyHomeVideosPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyHomeVideosPlaylistSourceConfig({
    $fixnum.Int64? libraryId,
  }) {
    final result = create();
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  SynologyHomeVideosPlaylistSourceConfig._();

  factory SynologyHomeVideosPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyHomeVideosPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyHomeVideosPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyHomeVideosPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyHomeVideosPlaylistSourceConfig copyWith(
          void Function(SynologyHomeVideosPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SynologyHomeVideosPlaylistSourceConfig))
          as SynologyHomeVideosPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyHomeVideosPlaylistSourceConfig create() =>
      SynologyHomeVideosPlaylistSourceConfig._();
  @$core.override
  SynologyHomeVideosPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyHomeVideosPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SynologyHomeVideosPlaylistSourceConfig>(create);
  static SynologyHomeVideosPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get libraryId => $_getI64(0);
  @$pb.TagNumber(1)
  set libraryId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);
}

class SynologyTvRecordingsPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyTvRecordingsPlaylistSourceConfig({
    $fixnum.Int64? libraryId,
  }) {
    final result = create();
    if (libraryId != null) result.libraryId = libraryId;
    return result;
  }

  SynologyTvRecordingsPlaylistSourceConfig._();

  factory SynologyTvRecordingsPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyTvRecordingsPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyTvRecordingsPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'libraryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyTvRecordingsPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyTvRecordingsPlaylistSourceConfig copyWith(
          void Function(SynologyTvRecordingsPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SynologyTvRecordingsPlaylistSourceConfig))
          as SynologyTvRecordingsPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyTvRecordingsPlaylistSourceConfig create() =>
      SynologyTvRecordingsPlaylistSourceConfig._();
  @$core.override
  SynologyTvRecordingsPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyTvRecordingsPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SynologyTvRecordingsPlaylistSourceConfig>(create);
  static SynologyTvRecordingsPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get libraryId => $_getI64(0);
  @$pb.TagNumber(1)
  set libraryId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLibraryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryId() => $_clearField(1);
}

enum SynologyPlaylistSourceConfig_Source {
  files,
  movies,
  tvShows,
  episodes,
  homeVideos,
  tvRecordings,
  notSet
}

class SynologyPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SynologyPlaylistSourceConfig({
    $core.String? serverId,
    SynologyFilesPlaylistSourceConfig? files,
    SynologyMoviesPlaylistSourceConfig? movies,
    SynologyTvShowsPlaylistSourceConfig? tvShows,
    SynologyEpisodesPlaylistSourceConfig? episodes,
    SynologyHomeVideosPlaylistSourceConfig? homeVideos,
    SynologyTvRecordingsPlaylistSourceConfig? tvRecordings,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (files != null) result.files = files;
    if (movies != null) result.movies = movies;
    if (tvShows != null) result.tvShows = tvShows;
    if (episodes != null) result.episodes = episodes;
    if (homeVideos != null) result.homeVideos = homeVideos;
    if (tvRecordings != null) result.tvRecordings = tvRecordings;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  SynologyPlaylistSourceConfig._();

  factory SynologyPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SynologyPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SynologyPlaylistSourceConfig_Source>
      _SynologyPlaylistSourceConfig_SourceByTag = {
    2: SynologyPlaylistSourceConfig_Source.files,
    3: SynologyPlaylistSourceConfig_Source.movies,
    4: SynologyPlaylistSourceConfig_Source.tvShows,
    5: SynologyPlaylistSourceConfig_Source.episodes,
    6: SynologyPlaylistSourceConfig_Source.homeVideos,
    7: SynologyPlaylistSourceConfig_Source.tvRecordings,
    0: SynologyPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SynologyPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<SynologyFilesPlaylistSourceConfig>(2, _omitFieldNames ? '' : 'files',
        subBuilder: SynologyFilesPlaylistSourceConfig.create)
    ..aOM<SynologyMoviesPlaylistSourceConfig>(
        3, _omitFieldNames ? '' : 'movies',
        subBuilder: SynologyMoviesPlaylistSourceConfig.create)
    ..aOM<SynologyTvShowsPlaylistSourceConfig>(
        4, _omitFieldNames ? '' : 'tvShows',
        subBuilder: SynologyTvShowsPlaylistSourceConfig.create)
    ..aOM<SynologyEpisodesPlaylistSourceConfig>(
        5, _omitFieldNames ? '' : 'episodes',
        subBuilder: SynologyEpisodesPlaylistSourceConfig.create)
    ..aOM<SynologyHomeVideosPlaylistSourceConfig>(
        6, _omitFieldNames ? '' : 'homeVideos',
        subBuilder: SynologyHomeVideosPlaylistSourceConfig.create)
    ..aOM<SynologyTvRecordingsPlaylistSourceConfig>(
        7, _omitFieldNames ? '' : 'tvRecordings',
        subBuilder: SynologyTvRecordingsPlaylistSourceConfig.create)
    ..aE<PlaybackProxyMode>(8, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SynologyPlaylistSourceConfig copyWith(
          void Function(SynologyPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as SynologyPlaylistSourceConfig))
          as SynologyPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SynologyPlaylistSourceConfig create() =>
      SynologyPlaylistSourceConfig._();
  @$core.override
  SynologyPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SynologyPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SynologyPlaylistSourceConfig>(create);
  static SynologyPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  SynologyPlaylistSourceConfig_Source whichSource() =>
      _SynologyPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  SynologyFilesPlaylistSourceConfig get files => $_getN(1);
  @$pb.TagNumber(2)
  set files(SynologyFilesPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFiles() => $_has(1);
  @$pb.TagNumber(2)
  void clearFiles() => $_clearField(2);
  @$pb.TagNumber(2)
  SynologyFilesPlaylistSourceConfig ensureFiles() => $_ensure(1);

  @$pb.TagNumber(3)
  SynologyMoviesPlaylistSourceConfig get movies => $_getN(2);
  @$pb.TagNumber(3)
  set movies(SynologyMoviesPlaylistSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMovies() => $_has(2);
  @$pb.TagNumber(3)
  void clearMovies() => $_clearField(3);
  @$pb.TagNumber(3)
  SynologyMoviesPlaylistSourceConfig ensureMovies() => $_ensure(2);

  @$pb.TagNumber(4)
  SynologyTvShowsPlaylistSourceConfig get tvShows => $_getN(3);
  @$pb.TagNumber(4)
  set tvShows(SynologyTvShowsPlaylistSourceConfig value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTvShows() => $_has(3);
  @$pb.TagNumber(4)
  void clearTvShows() => $_clearField(4);
  @$pb.TagNumber(4)
  SynologyTvShowsPlaylistSourceConfig ensureTvShows() => $_ensure(3);

  @$pb.TagNumber(5)
  SynologyEpisodesPlaylistSourceConfig get episodes => $_getN(4);
  @$pb.TagNumber(5)
  set episodes(SynologyEpisodesPlaylistSourceConfig value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEpisodes() => $_has(4);
  @$pb.TagNumber(5)
  void clearEpisodes() => $_clearField(5);
  @$pb.TagNumber(5)
  SynologyEpisodesPlaylistSourceConfig ensureEpisodes() => $_ensure(4);

  @$pb.TagNumber(6)
  SynologyHomeVideosPlaylistSourceConfig get homeVideos => $_getN(5);
  @$pb.TagNumber(6)
  set homeVideos(SynologyHomeVideosPlaylistSourceConfig value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasHomeVideos() => $_has(5);
  @$pb.TagNumber(6)
  void clearHomeVideos() => $_clearField(6);
  @$pb.TagNumber(6)
  SynologyHomeVideosPlaylistSourceConfig ensureHomeVideos() => $_ensure(5);

  @$pb.TagNumber(7)
  SynologyTvRecordingsPlaylistSourceConfig get tvRecordings => $_getN(6);
  @$pb.TagNumber(7)
  set tvRecordings(SynologyTvRecordingsPlaylistSourceConfig value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTvRecordings() => $_has(6);
  @$pb.TagNumber(7)
  void clearTvRecordings() => $_clearField(7);
  @$pb.TagNumber(7)
  SynologyTvRecordingsPlaylistSourceConfig ensureTvRecordings() => $_ensure(6);

  @$pb.TagNumber(8)
  PlaybackProxyMode get proxyMode => $_getN(7);
  @$pb.TagNumber(8)
  set proxyMode(PlaybackProxyMode value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasProxyMode() => $_has(7);
  @$pb.TagNumber(8)
  void clearProxyMode() => $_clearField(8);
}

class NextcloudMediaSourceConfig extends $pb.GeneratedMessage {
  factory NextcloudMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
    $fixnum.Int64? fileId,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (fileId != null) result.fileId = fileId;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  NextcloudMediaSourceConfig._();

  factory NextcloudMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NextcloudMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NextcloudMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'fileId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudMediaSourceConfig copyWith(
          void Function(NextcloudMediaSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as NextcloudMediaSourceConfig))
          as NextcloudMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NextcloudMediaSourceConfig create() => NextcloudMediaSourceConfig._();
  @$core.override
  NextcloudMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NextcloudMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NextcloudMediaSourceConfig>(create);
  static NextcloudMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fileId => $_getI64(2);
  @$pb.TagNumber(3)
  set fileId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileId() => $_clearField(3);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class NextcloudFolderPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory NextcloudFolderPlaylistSourceConfig({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  NextcloudFolderPlaylistSourceConfig._();

  factory NextcloudFolderPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NextcloudFolderPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NextcloudFolderPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudFolderPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudFolderPlaylistSourceConfig copyWith(
          void Function(NextcloudFolderPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as NextcloudFolderPlaylistSourceConfig))
          as NextcloudFolderPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NextcloudFolderPlaylistSourceConfig create() =>
      NextcloudFolderPlaylistSourceConfig._();
  @$core.override
  NextcloudFolderPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NextcloudFolderPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          NextcloudFolderPlaylistSourceConfig>(create);
  static NextcloudFolderPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class NextcloudFavoritesPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory NextcloudFavoritesPlaylistSourceConfig() => create();

  NextcloudFavoritesPlaylistSourceConfig._();

  factory NextcloudFavoritesPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NextcloudFavoritesPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NextcloudFavoritesPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudFavoritesPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudFavoritesPlaylistSourceConfig copyWith(
          void Function(NextcloudFavoritesPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as NextcloudFavoritesPlaylistSourceConfig))
          as NextcloudFavoritesPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NextcloudFavoritesPlaylistSourceConfig create() =>
      NextcloudFavoritesPlaylistSourceConfig._();
  @$core.override
  NextcloudFavoritesPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NextcloudFavoritesPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          NextcloudFavoritesPlaylistSourceConfig>(create);
  static NextcloudFavoritesPlaylistSourceConfig? _defaultInstance;
}

class NextcloudSearchPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory NextcloudSearchPlaylistSourceConfig({
    $core.String? path,
    $core.String? query,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (query != null) result.query = query;
    return result;
  }

  NextcloudSearchPlaylistSourceConfig._();

  factory NextcloudSearchPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NextcloudSearchPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NextcloudSearchPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudSearchPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudSearchPlaylistSourceConfig copyWith(
          void Function(NextcloudSearchPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as NextcloudSearchPlaylistSourceConfig))
          as NextcloudSearchPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NextcloudSearchPlaylistSourceConfig create() =>
      NextcloudSearchPlaylistSourceConfig._();
  @$core.override
  NextcloudSearchPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NextcloudSearchPlaylistSourceConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          NextcloudSearchPlaylistSourceConfig>(create);
  static NextcloudSearchPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);
}

enum NextcloudPlaylistSourceConfig_Source { folder, favorites, search, notSet }

class NextcloudPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory NextcloudPlaylistSourceConfig({
    $core.String? serverId,
    NextcloudFolderPlaylistSourceConfig? folder,
    NextcloudFavoritesPlaylistSourceConfig? favorites,
    NextcloudSearchPlaylistSourceConfig? search,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (folder != null) result.folder = folder;
    if (favorites != null) result.favorites = favorites;
    if (search != null) result.search = search;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  NextcloudPlaylistSourceConfig._();

  factory NextcloudPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NextcloudPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, NextcloudPlaylistSourceConfig_Source>
      _NextcloudPlaylistSourceConfig_SourceByTag = {
    2: NextcloudPlaylistSourceConfig_Source.folder,
    3: NextcloudPlaylistSourceConfig_Source.favorites,
    4: NextcloudPlaylistSourceConfig_Source.search,
    0: NextcloudPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NextcloudPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<NextcloudFolderPlaylistSourceConfig>(
        2, _omitFieldNames ? '' : 'folder',
        subBuilder: NextcloudFolderPlaylistSourceConfig.create)
    ..aOM<NextcloudFavoritesPlaylistSourceConfig>(
        3, _omitFieldNames ? '' : 'favorites',
        subBuilder: NextcloudFavoritesPlaylistSourceConfig.create)
    ..aOM<NextcloudSearchPlaylistSourceConfig>(
        4, _omitFieldNames ? '' : 'search',
        subBuilder: NextcloudSearchPlaylistSourceConfig.create)
    ..aE<PlaybackProxyMode>(5, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NextcloudPlaylistSourceConfig copyWith(
          void Function(NextcloudPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as NextcloudPlaylistSourceConfig))
          as NextcloudPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NextcloudPlaylistSourceConfig create() =>
      NextcloudPlaylistSourceConfig._();
  @$core.override
  NextcloudPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NextcloudPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NextcloudPlaylistSourceConfig>(create);
  static NextcloudPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  NextcloudPlaylistSourceConfig_Source whichSource() =>
      _NextcloudPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  NextcloudFolderPlaylistSourceConfig get folder => $_getN(1);
  @$pb.TagNumber(2)
  set folder(NextcloudFolderPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => $_clearField(2);
  @$pb.TagNumber(2)
  NextcloudFolderPlaylistSourceConfig ensureFolder() => $_ensure(1);

  @$pb.TagNumber(3)
  NextcloudFavoritesPlaylistSourceConfig get favorites => $_getN(2);
  @$pb.TagNumber(3)
  set favorites(NextcloudFavoritesPlaylistSourceConfig value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFavorites() => $_has(2);
  @$pb.TagNumber(3)
  void clearFavorites() => $_clearField(3);
  @$pb.TagNumber(3)
  NextcloudFavoritesPlaylistSourceConfig ensureFavorites() => $_ensure(2);

  @$pb.TagNumber(4)
  NextcloudSearchPlaylistSourceConfig get search => $_getN(3);
  @$pb.TagNumber(4)
  set search(NextcloudSearchPlaylistSourceConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);
  @$pb.TagNumber(4)
  NextcloudSearchPlaylistSourceConfig ensureSearch() => $_ensure(3);

  @$pb.TagNumber(5)
  PlaybackProxyMode get proxyMode => $_getN(4);
  @$pb.TagNumber(5)
  set proxyMode(PlaybackProxyMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasProxyMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearProxyMode() => $_clearField(5);
}

class SeafileMediaSourceConfig extends $pb.GeneratedMessage {
  factory SeafileMediaSourceConfig({
    $core.String? serverId,
    $core.String? repositoryId,
    $core.String? path,
    $core.String? objectId,
    $core.bool? hasThumbnail,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (repositoryId != null) result.repositoryId = repositoryId;
    if (path != null) result.path = path;
    if (objectId != null) result.objectId = objectId;
    if (hasThumbnail != null) result.hasThumbnail = hasThumbnail;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  SeafileMediaSourceConfig._();

  factory SeafileMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeafileMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeafileMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'repositoryId')
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..aOS(4, _omitFieldNames ? '' : 'objectId')
    ..aOB(5, _omitFieldNames ? '' : 'hasThumbnail')
    ..aE<PlaybackProxyMode>(6, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileMediaSourceConfig copyWith(
          void Function(SeafileMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as SeafileMediaSourceConfig))
          as SeafileMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeafileMediaSourceConfig create() => SeafileMediaSourceConfig._();
  @$core.override
  SeafileMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeafileMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeafileMediaSourceConfig>(create);
  static SeafileMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get repositoryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set repositoryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRepositoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRepositoryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get objectId => $_getSZ(3);
  @$pb.TagNumber(4)
  set objectId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObjectId() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjectId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasThumbnail => $_getBF(4);
  @$pb.TagNumber(5)
  set hasThumbnail($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasThumbnail() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasThumbnail() => $_clearField(5);

  @$pb.TagNumber(6)
  PlaybackProxyMode get proxyMode => $_getN(5);
  @$pb.TagNumber(6)
  set proxyMode(PlaybackProxyMode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasProxyMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearProxyMode() => $_clearField(6);
}

class SeafileFolderPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SeafileFolderPlaylistSourceConfig({
    $core.String? repositoryId,
    $core.String? path,
  }) {
    final result = create();
    if (repositoryId != null) result.repositoryId = repositoryId;
    if (path != null) result.path = path;
    return result;
  }

  SeafileFolderPlaylistSourceConfig._();

  factory SeafileFolderPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeafileFolderPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeafileFolderPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repositoryId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileFolderPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileFolderPlaylistSourceConfig copyWith(
          void Function(SeafileFolderPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SeafileFolderPlaylistSourceConfig))
          as SeafileFolderPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeafileFolderPlaylistSourceConfig create() =>
      SeafileFolderPlaylistSourceConfig._();
  @$core.override
  SeafileFolderPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeafileFolderPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeafileFolderPlaylistSourceConfig>(
          create);
  static SeafileFolderPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get repositoryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set repositoryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepositoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepositoryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);
}

class SeafileStarredPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SeafileStarredPlaylistSourceConfig() => create();

  SeafileStarredPlaylistSourceConfig._();

  factory SeafileStarredPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeafileStarredPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeafileStarredPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileStarredPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileStarredPlaylistSourceConfig copyWith(
          void Function(SeafileStarredPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SeafileStarredPlaylistSourceConfig))
          as SeafileStarredPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeafileStarredPlaylistSourceConfig create() =>
      SeafileStarredPlaylistSourceConfig._();
  @$core.override
  SeafileStarredPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeafileStarredPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeafileStarredPlaylistSourceConfig>(
          create);
  static SeafileStarredPlaylistSourceConfig? _defaultInstance;
}

class SeafileSearchPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SeafileSearchPlaylistSourceConfig({
    $core.String? repositoryId,
    $core.String? query,
  }) {
    final result = create();
    if (repositoryId != null) result.repositoryId = repositoryId;
    if (query != null) result.query = query;
    return result;
  }

  SeafileSearchPlaylistSourceConfig._();

  factory SeafileSearchPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeafileSearchPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeafileSearchPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'repositoryId')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileSearchPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafileSearchPlaylistSourceConfig copyWith(
          void Function(SeafileSearchPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as SeafileSearchPlaylistSourceConfig))
          as SeafileSearchPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeafileSearchPlaylistSourceConfig create() =>
      SeafileSearchPlaylistSourceConfig._();
  @$core.override
  SeafileSearchPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeafileSearchPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeafileSearchPlaylistSourceConfig>(
          create);
  static SeafileSearchPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get repositoryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set repositoryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepositoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepositoryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);
}

enum SeafilePlaylistSourceConfig_Source { folder, starred, search, notSet }

class SeafilePlaylistSourceConfig extends $pb.GeneratedMessage {
  factory SeafilePlaylistSourceConfig({
    $core.String? serverId,
    SeafileFolderPlaylistSourceConfig? folder,
    SeafileStarredPlaylistSourceConfig? starred,
    SeafileSearchPlaylistSourceConfig? search,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (folder != null) result.folder = folder;
    if (starred != null) result.starred = starred;
    if (search != null) result.search = search;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  SeafilePlaylistSourceConfig._();

  factory SeafilePlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeafilePlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SeafilePlaylistSourceConfig_Source>
      _SeafilePlaylistSourceConfig_SourceByTag = {
    2: SeafilePlaylistSourceConfig_Source.folder,
    3: SeafilePlaylistSourceConfig_Source.starred,
    4: SeafilePlaylistSourceConfig_Source.search,
    0: SeafilePlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeafilePlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<SeafileFolderPlaylistSourceConfig>(2, _omitFieldNames ? '' : 'folder',
        subBuilder: SeafileFolderPlaylistSourceConfig.create)
    ..aOM<SeafileStarredPlaylistSourceConfig>(
        3, _omitFieldNames ? '' : 'starred',
        subBuilder: SeafileStarredPlaylistSourceConfig.create)
    ..aOM<SeafileSearchPlaylistSourceConfig>(4, _omitFieldNames ? '' : 'search',
        subBuilder: SeafileSearchPlaylistSourceConfig.create)
    ..aE<PlaybackProxyMode>(5, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafilePlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeafilePlaylistSourceConfig copyWith(
          void Function(SeafilePlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as SeafilePlaylistSourceConfig))
          as SeafilePlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeafilePlaylistSourceConfig create() =>
      SeafilePlaylistSourceConfig._();
  @$core.override
  SeafilePlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeafilePlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeafilePlaylistSourceConfig>(create);
  static SeafilePlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  SeafilePlaylistSourceConfig_Source whichSource() =>
      _SeafilePlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  SeafileFolderPlaylistSourceConfig get folder => $_getN(1);
  @$pb.TagNumber(2)
  set folder(SeafileFolderPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => $_clearField(2);
  @$pb.TagNumber(2)
  SeafileFolderPlaylistSourceConfig ensureFolder() => $_ensure(1);

  @$pb.TagNumber(3)
  SeafileStarredPlaylistSourceConfig get starred => $_getN(2);
  @$pb.TagNumber(3)
  set starred(SeafileStarredPlaylistSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStarred() => $_has(2);
  @$pb.TagNumber(3)
  void clearStarred() => $_clearField(3);
  @$pb.TagNumber(3)
  SeafileStarredPlaylistSourceConfig ensureStarred() => $_ensure(2);

  @$pb.TagNumber(4)
  SeafileSearchPlaylistSourceConfig get search => $_getN(3);
  @$pb.TagNumber(4)
  set search(SeafileSearchPlaylistSourceConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearch() => $_clearField(4);
  @$pb.TagNumber(4)
  SeafileSearchPlaylistSourceConfig ensureSearch() => $_ensure(3);

  @$pb.TagNumber(5)
  PlaybackProxyMode get proxyMode => $_getN(4);
  @$pb.TagNumber(5)
  set proxyMode(PlaybackProxyMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasProxyMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearProxyMode() => $_clearField(5);
}

class TrueNasMediaSourceConfig extends $pb.GeneratedMessage {
  factory TrueNasMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  TrueNasMediaSourceConfig._();

  factory TrueNasMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrueNasMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrueNasMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aE<PlaybackProxyMode>(3, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasMediaSourceConfig copyWith(
          void Function(TrueNasMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TrueNasMediaSourceConfig))
          as TrueNasMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrueNasMediaSourceConfig create() => TrueNasMediaSourceConfig._();
  @$core.override
  TrueNasMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrueNasMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrueNasMediaSourceConfig>(create);
  static TrueNasMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  PlaybackProxyMode get proxyMode => $_getN(2);
  @$pb.TagNumber(3)
  set proxyMode(PlaybackProxyMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasProxyMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProxyMode() => $_clearField(3);
}

class TrueNasFolderPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory TrueNasFolderPlaylistSourceConfig({
    $core.String? path,
  }) {
    final result = create();
    if (path != null) result.path = path;
    return result;
  }

  TrueNasFolderPlaylistSourceConfig._();

  factory TrueNasFolderPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrueNasFolderPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrueNasFolderPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasFolderPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasFolderPlaylistSourceConfig copyWith(
          void Function(TrueNasFolderPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as TrueNasFolderPlaylistSourceConfig))
          as TrueNasFolderPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrueNasFolderPlaylistSourceConfig create() =>
      TrueNasFolderPlaylistSourceConfig._();
  @$core.override
  TrueNasFolderPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrueNasFolderPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrueNasFolderPlaylistSourceConfig>(
          create);
  static TrueNasFolderPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

class TrueNasSearchPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory TrueNasSearchPlaylistSourceConfig({
    $core.String? path,
    $core.String? query,
  }) {
    final result = create();
    if (path != null) result.path = path;
    if (query != null) result.query = query;
    return result;
  }

  TrueNasSearchPlaylistSourceConfig._();

  factory TrueNasSearchPlaylistSourceConfig.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrueNasSearchPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrueNasSearchPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasSearchPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasSearchPlaylistSourceConfig copyWith(
          void Function(TrueNasSearchPlaylistSourceConfig) updates) =>
      super.copyWith((message) =>
              updates(message as TrueNasSearchPlaylistSourceConfig))
          as TrueNasSearchPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrueNasSearchPlaylistSourceConfig create() =>
      TrueNasSearchPlaylistSourceConfig._();
  @$core.override
  TrueNasSearchPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrueNasSearchPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrueNasSearchPlaylistSourceConfig>(
          create);
  static TrueNasSearchPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);
}

enum TrueNasPlaylistSourceConfig_Source { folder, search, notSet }

class TrueNasPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory TrueNasPlaylistSourceConfig({
    $core.String? serverId,
    TrueNasFolderPlaylistSourceConfig? folder,
    TrueNasSearchPlaylistSourceConfig? search,
    PlaybackProxyMode? proxyMode,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (folder != null) result.folder = folder;
    if (search != null) result.search = search;
    if (proxyMode != null) result.proxyMode = proxyMode;
    return result;
  }

  TrueNasPlaylistSourceConfig._();

  factory TrueNasPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrueNasPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TrueNasPlaylistSourceConfig_Source>
      _TrueNasPlaylistSourceConfig_SourceByTag = {
    2: TrueNasPlaylistSourceConfig_Source.folder,
    3: TrueNasPlaylistSourceConfig_Source.search,
    0: TrueNasPlaylistSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrueNasPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOM<TrueNasFolderPlaylistSourceConfig>(2, _omitFieldNames ? '' : 'folder',
        subBuilder: TrueNasFolderPlaylistSourceConfig.create)
    ..aOM<TrueNasSearchPlaylistSourceConfig>(3, _omitFieldNames ? '' : 'search',
        subBuilder: TrueNasSearchPlaylistSourceConfig.create)
    ..aE<PlaybackProxyMode>(4, _omitFieldNames ? '' : 'proxyMode',
        enumValues: PlaybackProxyMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrueNasPlaylistSourceConfig copyWith(
          void Function(TrueNasPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as TrueNasPlaylistSourceConfig))
          as TrueNasPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrueNasPlaylistSourceConfig create() =>
      TrueNasPlaylistSourceConfig._();
  @$core.override
  TrueNasPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrueNasPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrueNasPlaylistSourceConfig>(create);
  static TrueNasPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  TrueNasPlaylistSourceConfig_Source whichSource() =>
      _TrueNasPlaylistSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get serverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerId() => $_clearField(1);

  @$pb.TagNumber(2)
  TrueNasFolderPlaylistSourceConfig get folder => $_getN(1);
  @$pb.TagNumber(2)
  set folder(TrueNasFolderPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => $_clearField(2);
  @$pb.TagNumber(2)
  TrueNasFolderPlaylistSourceConfig ensureFolder() => $_ensure(1);

  @$pb.TagNumber(3)
  TrueNasSearchPlaylistSourceConfig get search => $_getN(2);
  @$pb.TagNumber(3)
  set search(TrueNasSearchPlaylistSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSearch() => $_has(2);
  @$pb.TagNumber(3)
  void clearSearch() => $_clearField(3);
  @$pb.TagNumber(3)
  TrueNasSearchPlaylistSourceConfig ensureSearch() => $_ensure(2);

  @$pb.TagNumber(4)
  PlaybackProxyMode get proxyMode => $_getN(3);
  @$pb.TagNumber(4)
  set proxyMode(PlaybackProxyMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProxyMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearProxyMode() => $_clearField(4);
}

class TikTokVideoSourceConfig extends $pb.GeneratedMessage {
  factory TikTokVideoSourceConfig({
    $core.String? videoId,
    $core.bool? shared,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    if (shared != null) result.shared = shared;
    return result;
  }

  TikTokVideoSourceConfig._();

  factory TikTokVideoSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TikTokVideoSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TikTokVideoSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokVideoSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokVideoSourceConfig copyWith(
          void Function(TikTokVideoSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TikTokVideoSourceConfig))
          as TikTokVideoSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TikTokVideoSourceConfig create() => TikTokVideoSourceConfig._();
  @$core.override
  TikTokVideoSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TikTokVideoSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TikTokVideoSourceConfig>(create);
  static TikTokVideoSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

class TikTokLiveSourceConfig extends $pb.GeneratedMessage {
  factory TikTokLiveSourceConfig({
    $core.String? uniqueId,
    $core.bool? shared,
  }) {
    final result = create();
    if (uniqueId != null) result.uniqueId = uniqueId;
    if (shared != null) result.shared = shared;
    return result;
  }

  TikTokLiveSourceConfig._();

  factory TikTokLiveSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TikTokLiveSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TikTokLiveSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uniqueId')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokLiveSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokLiveSourceConfig copyWith(
          void Function(TikTokLiveSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TikTokLiveSourceConfig))
          as TikTokLiveSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TikTokLiveSourceConfig create() => TikTokLiveSourceConfig._();
  @$core.override
  TikTokLiveSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TikTokLiveSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TikTokLiveSourceConfig>(create);
  static TikTokLiveSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uniqueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uniqueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUniqueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUniqueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

enum TikTokMediaSourceConfig_Source { video, live, notSet }

class TikTokMediaSourceConfig extends $pb.GeneratedMessage {
  factory TikTokMediaSourceConfig({
    TikTokVideoSourceConfig? video,
    TikTokLiveSourceConfig? live,
  }) {
    final result = create();
    if (video != null) result.video = video;
    if (live != null) result.live = live;
    return result;
  }

  TikTokMediaSourceConfig._();

  factory TikTokMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TikTokMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TikTokMediaSourceConfig_Source>
      _TikTokMediaSourceConfig_SourceByTag = {
    1: TikTokMediaSourceConfig_Source.video,
    2: TikTokMediaSourceConfig_Source.live,
    0: TikTokMediaSourceConfig_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TikTokMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<TikTokVideoSourceConfig>(1, _omitFieldNames ? '' : 'video',
        subBuilder: TikTokVideoSourceConfig.create)
    ..aOM<TikTokLiveSourceConfig>(2, _omitFieldNames ? '' : 'live',
        subBuilder: TikTokLiveSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokMediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokMediaSourceConfig copyWith(
          void Function(TikTokMediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as TikTokMediaSourceConfig))
          as TikTokMediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TikTokMediaSourceConfig create() => TikTokMediaSourceConfig._();
  @$core.override
  TikTokMediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TikTokMediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TikTokMediaSourceConfig>(create);
  static TikTokMediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  TikTokMediaSourceConfig_Source whichSource() =>
      _TikTokMediaSourceConfig_SourceByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  TikTokVideoSourceConfig get video => $_getN(0);
  @$pb.TagNumber(1)
  set video(TikTokVideoSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideo() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideo() => $_clearField(1);
  @$pb.TagNumber(1)
  TikTokVideoSourceConfig ensureVideo() => $_ensure(0);

  @$pb.TagNumber(2)
  TikTokLiveSourceConfig get live => $_getN(1);
  @$pb.TagNumber(2)
  set live(TikTokLiveSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLive() => $_has(1);
  @$pb.TagNumber(2)
  void clearLive() => $_clearField(2);
  @$pb.TagNumber(2)
  TikTokLiveSourceConfig ensureLive() => $_ensure(1);
}

class TikTokPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory TikTokPlaylistSourceConfig({
    $core.String? secUid,
    $core.bool? shared,
  }) {
    final result = create();
    if (secUid != null) result.secUid = secUid;
    if (shared != null) result.shared = shared;
    return result;
  }

  TikTokPlaylistSourceConfig._();

  factory TikTokPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TikTokPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TikTokPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'secUid')
    ..aOB(2, _omitFieldNames ? '' : 'shared')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokPlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TikTokPlaylistSourceConfig copyWith(
          void Function(TikTokPlaylistSourceConfig) updates) =>
      super.copyWith(
              (message) => updates(message as TikTokPlaylistSourceConfig))
          as TikTokPlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TikTokPlaylistSourceConfig create() => TikTokPlaylistSourceConfig._();
  @$core.override
  TikTokPlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TikTokPlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TikTokPlaylistSourceConfig>(create);
  static TikTokPlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get secUid => $_getSZ(0);
  @$pb.TagNumber(1)
  set secUid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get shared => $_getBF(1);
  @$pb.TagNumber(2)
  set shared($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShared() => $_has(1);
  @$pb.TagNumber(2)
  void clearShared() => $_clearField(2);
}

enum MediaSourceConfig_Provider {
  directUrl,
  bilibili,
  alist,
  emby,
  rtmp,
  liveProxy,
  cloudreve,
  twitch,
  huya,
  douyu,
  douyin,
  acFun,
  cctv,
  fnos,
  qnap,
  synology,
  nextcloud,
  seafile,
  truenas,
  youtube,
  tiktok,
  notSet
}

class MediaSourceConfig extends $pb.GeneratedMessage {
  factory MediaSourceConfig({
    DirectUrlMediaSourceConfig? directUrl,
    BilibiliMediaSourceConfig? bilibili,
    AlistMediaSourceConfig? alist,
    EmbyMediaSourceConfig? emby,
    RtmpMediaSourceConfig? rtmp,
    LiveProxyMediaSourceConfig? liveProxy,
    CloudreveMediaSourceConfig? cloudreve,
    TwitchMediaSourceConfig? twitch,
    HuyaMediaSourceConfig? huya,
    DouyuMediaSourceConfig? douyu,
    DouyinMediaSourceConfig? douyin,
    AcFunMediaSourceConfig? acFun,
    CctvMediaSourceConfig? cctv,
    FnosMediaSourceConfig? fnos,
    QnapMediaSourceConfig? qnap,
    SynologyMediaSourceConfig? synology,
    NextcloudMediaSourceConfig? nextcloud,
    SeafileMediaSourceConfig? seafile,
    TrueNasMediaSourceConfig? truenas,
    YoutubeMediaSourceConfig? youtube,
    TikTokMediaSourceConfig? tiktok,
  }) {
    final result = create();
    if (directUrl != null) result.directUrl = directUrl;
    if (bilibili != null) result.bilibili = bilibili;
    if (alist != null) result.alist = alist;
    if (emby != null) result.emby = emby;
    if (rtmp != null) result.rtmp = rtmp;
    if (liveProxy != null) result.liveProxy = liveProxy;
    if (cloudreve != null) result.cloudreve = cloudreve;
    if (twitch != null) result.twitch = twitch;
    if (huya != null) result.huya = huya;
    if (douyu != null) result.douyu = douyu;
    if (douyin != null) result.douyin = douyin;
    if (acFun != null) result.acFun = acFun;
    if (cctv != null) result.cctv = cctv;
    if (fnos != null) result.fnos = fnos;
    if (qnap != null) result.qnap = qnap;
    if (synology != null) result.synology = synology;
    if (nextcloud != null) result.nextcloud = nextcloud;
    if (seafile != null) result.seafile = seafile;
    if (truenas != null) result.truenas = truenas;
    if (youtube != null) result.youtube = youtube;
    if (tiktok != null) result.tiktok = tiktok;
    return result;
  }

  MediaSourceConfig._();

  factory MediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, MediaSourceConfig_Provider>
      _MediaSourceConfig_ProviderByTag = {
    1: MediaSourceConfig_Provider.directUrl,
    2: MediaSourceConfig_Provider.bilibili,
    3: MediaSourceConfig_Provider.alist,
    4: MediaSourceConfig_Provider.emby,
    5: MediaSourceConfig_Provider.rtmp,
    6: MediaSourceConfig_Provider.liveProxy,
    7: MediaSourceConfig_Provider.cloudreve,
    8: MediaSourceConfig_Provider.twitch,
    9: MediaSourceConfig_Provider.huya,
    10: MediaSourceConfig_Provider.douyu,
    11: MediaSourceConfig_Provider.douyin,
    12: MediaSourceConfig_Provider.acFun,
    13: MediaSourceConfig_Provider.cctv,
    14: MediaSourceConfig_Provider.fnos,
    15: MediaSourceConfig_Provider.qnap,
    16: MediaSourceConfig_Provider.synology,
    17: MediaSourceConfig_Provider.nextcloud,
    18: MediaSourceConfig_Provider.seafile,
    19: MediaSourceConfig_Provider.truenas,
    20: MediaSourceConfig_Provider.youtube,
    21: MediaSourceConfig_Provider.tiktok,
    0: MediaSourceConfig_Provider.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21
    ])
    ..aOM<DirectUrlMediaSourceConfig>(1, _omitFieldNames ? '' : 'directUrl',
        subBuilder: DirectUrlMediaSourceConfig.create)
    ..aOM<BilibiliMediaSourceConfig>(2, _omitFieldNames ? '' : 'bilibili',
        subBuilder: BilibiliMediaSourceConfig.create)
    ..aOM<AlistMediaSourceConfig>(3, _omitFieldNames ? '' : 'alist',
        subBuilder: AlistMediaSourceConfig.create)
    ..aOM<EmbyMediaSourceConfig>(4, _omitFieldNames ? '' : 'emby',
        subBuilder: EmbyMediaSourceConfig.create)
    ..aOM<RtmpMediaSourceConfig>(5, _omitFieldNames ? '' : 'rtmp',
        subBuilder: RtmpMediaSourceConfig.create)
    ..aOM<LiveProxyMediaSourceConfig>(6, _omitFieldNames ? '' : 'liveProxy',
        subBuilder: LiveProxyMediaSourceConfig.create)
    ..aOM<CloudreveMediaSourceConfig>(7, _omitFieldNames ? '' : 'cloudreve',
        subBuilder: CloudreveMediaSourceConfig.create)
    ..aOM<TwitchMediaSourceConfig>(8, _omitFieldNames ? '' : 'twitch',
        subBuilder: TwitchMediaSourceConfig.create)
    ..aOM<HuyaMediaSourceConfig>(9, _omitFieldNames ? '' : 'huya',
        subBuilder: HuyaMediaSourceConfig.create)
    ..aOM<DouyuMediaSourceConfig>(10, _omitFieldNames ? '' : 'douyu',
        subBuilder: DouyuMediaSourceConfig.create)
    ..aOM<DouyinMediaSourceConfig>(11, _omitFieldNames ? '' : 'douyin',
        subBuilder: DouyinMediaSourceConfig.create)
    ..aOM<AcFunMediaSourceConfig>(12, _omitFieldNames ? '' : 'acFun',
        subBuilder: AcFunMediaSourceConfig.create)
    ..aOM<CctvMediaSourceConfig>(13, _omitFieldNames ? '' : 'cctv',
        subBuilder: CctvMediaSourceConfig.create)
    ..aOM<FnosMediaSourceConfig>(14, _omitFieldNames ? '' : 'fnos',
        subBuilder: FnosMediaSourceConfig.create)
    ..aOM<QnapMediaSourceConfig>(15, _omitFieldNames ? '' : 'qnap',
        subBuilder: QnapMediaSourceConfig.create)
    ..aOM<SynologyMediaSourceConfig>(16, _omitFieldNames ? '' : 'synology',
        subBuilder: SynologyMediaSourceConfig.create)
    ..aOM<NextcloudMediaSourceConfig>(17, _omitFieldNames ? '' : 'nextcloud',
        subBuilder: NextcloudMediaSourceConfig.create)
    ..aOM<SeafileMediaSourceConfig>(18, _omitFieldNames ? '' : 'seafile',
        subBuilder: SeafileMediaSourceConfig.create)
    ..aOM<TrueNasMediaSourceConfig>(19, _omitFieldNames ? '' : 'truenas',
        subBuilder: TrueNasMediaSourceConfig.create)
    ..aOM<YoutubeMediaSourceConfig>(20, _omitFieldNames ? '' : 'youtube',
        subBuilder: YoutubeMediaSourceConfig.create)
    ..aOM<TikTokMediaSourceConfig>(21, _omitFieldNames ? '' : 'tiktok',
        subBuilder: TikTokMediaSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaSourceConfig copyWith(void Function(MediaSourceConfig) updates) =>
      super.copyWith((message) => updates(message as MediaSourceConfig))
          as MediaSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaSourceConfig create() => MediaSourceConfig._();
  @$core.override
  MediaSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MediaSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaSourceConfig>(create);
  static MediaSourceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  MediaSourceConfig_Provider whichProvider() =>
      _MediaSourceConfig_ProviderByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  void clearProvider() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  DirectUrlMediaSourceConfig get directUrl => $_getN(0);
  @$pb.TagNumber(1)
  set directUrl(DirectUrlMediaSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDirectUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirectUrl() => $_clearField(1);
  @$pb.TagNumber(1)
  DirectUrlMediaSourceConfig ensureDirectUrl() => $_ensure(0);

  @$pb.TagNumber(2)
  BilibiliMediaSourceConfig get bilibili => $_getN(1);
  @$pb.TagNumber(2)
  set bilibili(BilibiliMediaSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBilibili() => $_has(1);
  @$pb.TagNumber(2)
  void clearBilibili() => $_clearField(2);
  @$pb.TagNumber(2)
  BilibiliMediaSourceConfig ensureBilibili() => $_ensure(1);

  @$pb.TagNumber(3)
  AlistMediaSourceConfig get alist => $_getN(2);
  @$pb.TagNumber(3)
  set alist(AlistMediaSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAlist() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlist() => $_clearField(3);
  @$pb.TagNumber(3)
  AlistMediaSourceConfig ensureAlist() => $_ensure(2);

  @$pb.TagNumber(4)
  EmbyMediaSourceConfig get emby => $_getN(3);
  @$pb.TagNumber(4)
  set emby(EmbyMediaSourceConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEmby() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmby() => $_clearField(4);
  @$pb.TagNumber(4)
  EmbyMediaSourceConfig ensureEmby() => $_ensure(3);

  @$pb.TagNumber(5)
  RtmpMediaSourceConfig get rtmp => $_getN(4);
  @$pb.TagNumber(5)
  set rtmp(RtmpMediaSourceConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRtmp() => $_has(4);
  @$pb.TagNumber(5)
  void clearRtmp() => $_clearField(5);
  @$pb.TagNumber(5)
  RtmpMediaSourceConfig ensureRtmp() => $_ensure(4);

  @$pb.TagNumber(6)
  LiveProxyMediaSourceConfig get liveProxy => $_getN(5);
  @$pb.TagNumber(6)
  set liveProxy(LiveProxyMediaSourceConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLiveProxy() => $_has(5);
  @$pb.TagNumber(6)
  void clearLiveProxy() => $_clearField(6);
  @$pb.TagNumber(6)
  LiveProxyMediaSourceConfig ensureLiveProxy() => $_ensure(5);

  @$pb.TagNumber(7)
  CloudreveMediaSourceConfig get cloudreve => $_getN(6);
  @$pb.TagNumber(7)
  set cloudreve(CloudreveMediaSourceConfig value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCloudreve() => $_has(6);
  @$pb.TagNumber(7)
  void clearCloudreve() => $_clearField(7);
  @$pb.TagNumber(7)
  CloudreveMediaSourceConfig ensureCloudreve() => $_ensure(6);

  @$pb.TagNumber(8)
  TwitchMediaSourceConfig get twitch => $_getN(7);
  @$pb.TagNumber(8)
  set twitch(TwitchMediaSourceConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTwitch() => $_has(7);
  @$pb.TagNumber(8)
  void clearTwitch() => $_clearField(8);
  @$pb.TagNumber(8)
  TwitchMediaSourceConfig ensureTwitch() => $_ensure(7);

  @$pb.TagNumber(9)
  HuyaMediaSourceConfig get huya => $_getN(8);
  @$pb.TagNumber(9)
  set huya(HuyaMediaSourceConfig value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasHuya() => $_has(8);
  @$pb.TagNumber(9)
  void clearHuya() => $_clearField(9);
  @$pb.TagNumber(9)
  HuyaMediaSourceConfig ensureHuya() => $_ensure(8);

  @$pb.TagNumber(10)
  DouyuMediaSourceConfig get douyu => $_getN(9);
  @$pb.TagNumber(10)
  set douyu(DouyuMediaSourceConfig value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDouyu() => $_has(9);
  @$pb.TagNumber(10)
  void clearDouyu() => $_clearField(10);
  @$pb.TagNumber(10)
  DouyuMediaSourceConfig ensureDouyu() => $_ensure(9);

  @$pb.TagNumber(11)
  DouyinMediaSourceConfig get douyin => $_getN(10);
  @$pb.TagNumber(11)
  set douyin(DouyinMediaSourceConfig value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDouyin() => $_has(10);
  @$pb.TagNumber(11)
  void clearDouyin() => $_clearField(11);
  @$pb.TagNumber(11)
  DouyinMediaSourceConfig ensureDouyin() => $_ensure(10);

  @$pb.TagNumber(12)
  AcFunMediaSourceConfig get acFun => $_getN(11);
  @$pb.TagNumber(12)
  set acFun(AcFunMediaSourceConfig value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAcFun() => $_has(11);
  @$pb.TagNumber(12)
  void clearAcFun() => $_clearField(12);
  @$pb.TagNumber(12)
  AcFunMediaSourceConfig ensureAcFun() => $_ensure(11);

  @$pb.TagNumber(13)
  CctvMediaSourceConfig get cctv => $_getN(12);
  @$pb.TagNumber(13)
  set cctv(CctvMediaSourceConfig value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCctv() => $_has(12);
  @$pb.TagNumber(13)
  void clearCctv() => $_clearField(13);
  @$pb.TagNumber(13)
  CctvMediaSourceConfig ensureCctv() => $_ensure(12);

  @$pb.TagNumber(14)
  FnosMediaSourceConfig get fnos => $_getN(13);
  @$pb.TagNumber(14)
  set fnos(FnosMediaSourceConfig value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFnos() => $_has(13);
  @$pb.TagNumber(14)
  void clearFnos() => $_clearField(14);
  @$pb.TagNumber(14)
  FnosMediaSourceConfig ensureFnos() => $_ensure(13);

  @$pb.TagNumber(15)
  QnapMediaSourceConfig get qnap => $_getN(14);
  @$pb.TagNumber(15)
  set qnap(QnapMediaSourceConfig value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasQnap() => $_has(14);
  @$pb.TagNumber(15)
  void clearQnap() => $_clearField(15);
  @$pb.TagNumber(15)
  QnapMediaSourceConfig ensureQnap() => $_ensure(14);

  @$pb.TagNumber(16)
  SynologyMediaSourceConfig get synology => $_getN(15);
  @$pb.TagNumber(16)
  set synology(SynologyMediaSourceConfig value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSynology() => $_has(15);
  @$pb.TagNumber(16)
  void clearSynology() => $_clearField(16);
  @$pb.TagNumber(16)
  SynologyMediaSourceConfig ensureSynology() => $_ensure(15);

  @$pb.TagNumber(17)
  NextcloudMediaSourceConfig get nextcloud => $_getN(16);
  @$pb.TagNumber(17)
  set nextcloud(NextcloudMediaSourceConfig value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasNextcloud() => $_has(16);
  @$pb.TagNumber(17)
  void clearNextcloud() => $_clearField(17);
  @$pb.TagNumber(17)
  NextcloudMediaSourceConfig ensureNextcloud() => $_ensure(16);

  @$pb.TagNumber(18)
  SeafileMediaSourceConfig get seafile => $_getN(17);
  @$pb.TagNumber(18)
  set seafile(SeafileMediaSourceConfig value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasSeafile() => $_has(17);
  @$pb.TagNumber(18)
  void clearSeafile() => $_clearField(18);
  @$pb.TagNumber(18)
  SeafileMediaSourceConfig ensureSeafile() => $_ensure(17);

  @$pb.TagNumber(19)
  TrueNasMediaSourceConfig get truenas => $_getN(18);
  @$pb.TagNumber(19)
  set truenas(TrueNasMediaSourceConfig value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasTruenas() => $_has(18);
  @$pb.TagNumber(19)
  void clearTruenas() => $_clearField(19);
  @$pb.TagNumber(19)
  TrueNasMediaSourceConfig ensureTruenas() => $_ensure(18);

  @$pb.TagNumber(20)
  YoutubeMediaSourceConfig get youtube => $_getN(19);
  @$pb.TagNumber(20)
  set youtube(YoutubeMediaSourceConfig value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasYoutube() => $_has(19);
  @$pb.TagNumber(20)
  void clearYoutube() => $_clearField(20);
  @$pb.TagNumber(20)
  YoutubeMediaSourceConfig ensureYoutube() => $_ensure(19);

  @$pb.TagNumber(21)
  TikTokMediaSourceConfig get tiktok => $_getN(20);
  @$pb.TagNumber(21)
  set tiktok(TikTokMediaSourceConfig value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasTiktok() => $_has(20);
  @$pb.TagNumber(21)
  void clearTiktok() => $_clearField(21);
  @$pb.TagNumber(21)
  TikTokMediaSourceConfig ensureTiktok() => $_ensure(20);
}

enum PlaylistSourceConfig_Provider {
  bilibili,
  alist,
  emby,
  cloudreve,
  twitch,
  douyin,
  fnos,
  qnap,
  synology,
  nextcloud,
  seafile,
  truenas,
  youtube,
  tiktok,
  notSet
}

class PlaylistSourceConfig extends $pb.GeneratedMessage {
  factory PlaylistSourceConfig({
    BilibiliPlaylistSourceConfig? bilibili,
    AlistPlaylistSourceConfig? alist,
    EmbyPlaylistSourceConfig? emby,
    CloudrevePlaylistSourceConfig? cloudreve,
    TwitchPlaylistSourceConfig? twitch,
    DouyinPlaylistSourceConfig? douyin,
    FnosPlaylistSourceConfig? fnos,
    QnapPlaylistSourceConfig? qnap,
    SynologyPlaylistSourceConfig? synology,
    NextcloudPlaylistSourceConfig? nextcloud,
    SeafilePlaylistSourceConfig? seafile,
    TrueNasPlaylistSourceConfig? truenas,
    YoutubePlaylistSourceConfig? youtube,
    TikTokPlaylistSourceConfig? tiktok,
  }) {
    final result = create();
    if (bilibili != null) result.bilibili = bilibili;
    if (alist != null) result.alist = alist;
    if (emby != null) result.emby = emby;
    if (cloudreve != null) result.cloudreve = cloudreve;
    if (twitch != null) result.twitch = twitch;
    if (douyin != null) result.douyin = douyin;
    if (fnos != null) result.fnos = fnos;
    if (qnap != null) result.qnap = qnap;
    if (synology != null) result.synology = synology;
    if (nextcloud != null) result.nextcloud = nextcloud;
    if (seafile != null) result.seafile = seafile;
    if (truenas != null) result.truenas = truenas;
    if (youtube != null) result.youtube = youtube;
    if (tiktok != null) result.tiktok = tiktok;
    return result;
  }

  PlaylistSourceConfig._();

  factory PlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PlaylistSourceConfig_Provider>
      _PlaylistSourceConfig_ProviderByTag = {
    2: PlaylistSourceConfig_Provider.bilibili,
    3: PlaylistSourceConfig_Provider.alist,
    4: PlaylistSourceConfig_Provider.emby,
    7: PlaylistSourceConfig_Provider.cloudreve,
    8: PlaylistSourceConfig_Provider.twitch,
    11: PlaylistSourceConfig_Provider.douyin,
    14: PlaylistSourceConfig_Provider.fnos,
    15: PlaylistSourceConfig_Provider.qnap,
    16: PlaylistSourceConfig_Provider.synology,
    17: PlaylistSourceConfig_Provider.nextcloud,
    18: PlaylistSourceConfig_Provider.seafile,
    19: PlaylistSourceConfig_Provider.truenas,
    20: PlaylistSourceConfig_Provider.youtube,
    21: PlaylistSourceConfig_Provider.tiktok,
    0: PlaylistSourceConfig_Provider.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 7, 8, 11, 14, 15, 16, 17, 18, 19, 20, 21])
    ..aOM<BilibiliPlaylistSourceConfig>(2, _omitFieldNames ? '' : 'bilibili',
        subBuilder: BilibiliPlaylistSourceConfig.create)
    ..aOM<AlistPlaylistSourceConfig>(3, _omitFieldNames ? '' : 'alist',
        subBuilder: AlistPlaylistSourceConfig.create)
    ..aOM<EmbyPlaylistSourceConfig>(4, _omitFieldNames ? '' : 'emby',
        subBuilder: EmbyPlaylistSourceConfig.create)
    ..aOM<CloudrevePlaylistSourceConfig>(7, _omitFieldNames ? '' : 'cloudreve',
        subBuilder: CloudrevePlaylistSourceConfig.create)
    ..aOM<TwitchPlaylistSourceConfig>(8, _omitFieldNames ? '' : 'twitch',
        subBuilder: TwitchPlaylistSourceConfig.create)
    ..aOM<DouyinPlaylistSourceConfig>(11, _omitFieldNames ? '' : 'douyin',
        subBuilder: DouyinPlaylistSourceConfig.create)
    ..aOM<FnosPlaylistSourceConfig>(14, _omitFieldNames ? '' : 'fnos',
        subBuilder: FnosPlaylistSourceConfig.create)
    ..aOM<QnapPlaylistSourceConfig>(15, _omitFieldNames ? '' : 'qnap',
        subBuilder: QnapPlaylistSourceConfig.create)
    ..aOM<SynologyPlaylistSourceConfig>(16, _omitFieldNames ? '' : 'synology',
        subBuilder: SynologyPlaylistSourceConfig.create)
    ..aOM<NextcloudPlaylistSourceConfig>(17, _omitFieldNames ? '' : 'nextcloud',
        subBuilder: NextcloudPlaylistSourceConfig.create)
    ..aOM<SeafilePlaylistSourceConfig>(18, _omitFieldNames ? '' : 'seafile',
        subBuilder: SeafilePlaylistSourceConfig.create)
    ..aOM<TrueNasPlaylistSourceConfig>(19, _omitFieldNames ? '' : 'truenas',
        subBuilder: TrueNasPlaylistSourceConfig.create)
    ..aOM<YoutubePlaylistSourceConfig>(20, _omitFieldNames ? '' : 'youtube',
        subBuilder: YoutubePlaylistSourceConfig.create)
    ..aOM<TikTokPlaylistSourceConfig>(21, _omitFieldNames ? '' : 'tiktok',
        subBuilder: TikTokPlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistSourceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistSourceConfig copyWith(void Function(PlaylistSourceConfig) updates) =>
      super.copyWith((message) => updates(message as PlaylistSourceConfig))
          as PlaylistSourceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistSourceConfig create() => PlaylistSourceConfig._();
  @$core.override
  PlaylistSourceConfig createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaylistSourceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistSourceConfig>(create);
  static PlaylistSourceConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(11)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  PlaylistSourceConfig_Provider whichProvider() =>
      _PlaylistSourceConfig_ProviderByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(11)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  void clearProvider() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  BilibiliPlaylistSourceConfig get bilibili => $_getN(0);
  @$pb.TagNumber(2)
  set bilibili(BilibiliPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBilibili() => $_has(0);
  @$pb.TagNumber(2)
  void clearBilibili() => $_clearField(2);
  @$pb.TagNumber(2)
  BilibiliPlaylistSourceConfig ensureBilibili() => $_ensure(0);

  @$pb.TagNumber(3)
  AlistPlaylistSourceConfig get alist => $_getN(1);
  @$pb.TagNumber(3)
  set alist(AlistPlaylistSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAlist() => $_has(1);
  @$pb.TagNumber(3)
  void clearAlist() => $_clearField(3);
  @$pb.TagNumber(3)
  AlistPlaylistSourceConfig ensureAlist() => $_ensure(1);

  @$pb.TagNumber(4)
  EmbyPlaylistSourceConfig get emby => $_getN(2);
  @$pb.TagNumber(4)
  set emby(EmbyPlaylistSourceConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEmby() => $_has(2);
  @$pb.TagNumber(4)
  void clearEmby() => $_clearField(4);
  @$pb.TagNumber(4)
  EmbyPlaylistSourceConfig ensureEmby() => $_ensure(2);

  @$pb.TagNumber(7)
  CloudrevePlaylistSourceConfig get cloudreve => $_getN(3);
  @$pb.TagNumber(7)
  set cloudreve(CloudrevePlaylistSourceConfig value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCloudreve() => $_has(3);
  @$pb.TagNumber(7)
  void clearCloudreve() => $_clearField(7);
  @$pb.TagNumber(7)
  CloudrevePlaylistSourceConfig ensureCloudreve() => $_ensure(3);

  @$pb.TagNumber(8)
  TwitchPlaylistSourceConfig get twitch => $_getN(4);
  @$pb.TagNumber(8)
  set twitch(TwitchPlaylistSourceConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTwitch() => $_has(4);
  @$pb.TagNumber(8)
  void clearTwitch() => $_clearField(8);
  @$pb.TagNumber(8)
  TwitchPlaylistSourceConfig ensureTwitch() => $_ensure(4);

  @$pb.TagNumber(11)
  DouyinPlaylistSourceConfig get douyin => $_getN(5);
  @$pb.TagNumber(11)
  set douyin(DouyinPlaylistSourceConfig value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDouyin() => $_has(5);
  @$pb.TagNumber(11)
  void clearDouyin() => $_clearField(11);
  @$pb.TagNumber(11)
  DouyinPlaylistSourceConfig ensureDouyin() => $_ensure(5);

  @$pb.TagNumber(14)
  FnosPlaylistSourceConfig get fnos => $_getN(6);
  @$pb.TagNumber(14)
  set fnos(FnosPlaylistSourceConfig value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFnos() => $_has(6);
  @$pb.TagNumber(14)
  void clearFnos() => $_clearField(14);
  @$pb.TagNumber(14)
  FnosPlaylistSourceConfig ensureFnos() => $_ensure(6);

  @$pb.TagNumber(15)
  QnapPlaylistSourceConfig get qnap => $_getN(7);
  @$pb.TagNumber(15)
  set qnap(QnapPlaylistSourceConfig value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasQnap() => $_has(7);
  @$pb.TagNumber(15)
  void clearQnap() => $_clearField(15);
  @$pb.TagNumber(15)
  QnapPlaylistSourceConfig ensureQnap() => $_ensure(7);

  @$pb.TagNumber(16)
  SynologyPlaylistSourceConfig get synology => $_getN(8);
  @$pb.TagNumber(16)
  set synology(SynologyPlaylistSourceConfig value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSynology() => $_has(8);
  @$pb.TagNumber(16)
  void clearSynology() => $_clearField(16);
  @$pb.TagNumber(16)
  SynologyPlaylistSourceConfig ensureSynology() => $_ensure(8);

  @$pb.TagNumber(17)
  NextcloudPlaylistSourceConfig get nextcloud => $_getN(9);
  @$pb.TagNumber(17)
  set nextcloud(NextcloudPlaylistSourceConfig value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasNextcloud() => $_has(9);
  @$pb.TagNumber(17)
  void clearNextcloud() => $_clearField(17);
  @$pb.TagNumber(17)
  NextcloudPlaylistSourceConfig ensureNextcloud() => $_ensure(9);

  @$pb.TagNumber(18)
  SeafilePlaylistSourceConfig get seafile => $_getN(10);
  @$pb.TagNumber(18)
  set seafile(SeafilePlaylistSourceConfig value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasSeafile() => $_has(10);
  @$pb.TagNumber(18)
  void clearSeafile() => $_clearField(18);
  @$pb.TagNumber(18)
  SeafilePlaylistSourceConfig ensureSeafile() => $_ensure(10);

  @$pb.TagNumber(19)
  TrueNasPlaylistSourceConfig get truenas => $_getN(11);
  @$pb.TagNumber(19)
  set truenas(TrueNasPlaylistSourceConfig value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasTruenas() => $_has(11);
  @$pb.TagNumber(19)
  void clearTruenas() => $_clearField(19);
  @$pb.TagNumber(19)
  TrueNasPlaylistSourceConfig ensureTruenas() => $_ensure(11);

  @$pb.TagNumber(20)
  YoutubePlaylistSourceConfig get youtube => $_getN(12);
  @$pb.TagNumber(20)
  set youtube(YoutubePlaylistSourceConfig value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasYoutube() => $_has(12);
  @$pb.TagNumber(20)
  void clearYoutube() => $_clearField(20);
  @$pb.TagNumber(20)
  YoutubePlaylistSourceConfig ensureYoutube() => $_ensure(12);

  @$pb.TagNumber(21)
  TikTokPlaylistSourceConfig get tiktok => $_getN(13);
  @$pb.TagNumber(21)
  set tiktok(TikTokPlaylistSourceConfig value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasTiktok() => $_has(13);
  @$pb.TagNumber(21)
  void clearTiktok() => $_clearField(21);
  @$pb.TagNumber(21)
  TikTokPlaylistSourceConfig ensureTiktok() => $_ensure(13);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
