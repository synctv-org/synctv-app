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

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'source_config.pbenum.dart';

class DirectUrlMediaResourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlMediaResourceConfig({
    $core.String? name,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
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
}

class DirectUrlSubtitleSourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlSubtitleSourceConfig({
    $core.String? name,
    $core.String? language,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (language != null) result.language = language;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
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
}

class DirectUrlDanmakuSourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlDanmakuSourceConfig({
    $core.String? name,
    $core.String? url,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? headers,
    $core.String? format,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (url != null) result.url = url;
    if (headers != null) result.headers.addEntries(headers);
    if (format != null) result.format = format;
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
}

class DirectUrlMediaSourceConfig extends $pb.GeneratedMessage {
  factory DirectUrlMediaSourceConfig({
    $core.Iterable<DirectUrlMediaResourceConfig>? medias,
    $core.int? defaultMediaIndex,
    $core.Iterable<DirectUrlSubtitleSourceConfig>? subtitles,
    $core.int? defaultSubtitleIndex,
    $core.Iterable<DirectUrlDanmakuSourceConfig>? danmakus,
    $core.int? defaultDanmakuIndex,
    $core.bool? isLive,
    $core.double? durationSeconds,
    $core.bool? preferProxy,
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
    if (isLive != null) result.isLive = isLive;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (preferProxy != null) result.preferProxy = preferProxy;
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
    ..aOB(7, _omitFieldNames ? '' : 'isLive')
    ..aD(8, _omitFieldNames ? '' : 'durationSeconds')
    ..aOB(9, _omitFieldNames ? '' : 'preferProxy')
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
  $core.bool get isLive => $_getBF(6);
  @$pb.TagNumber(7)
  set isLive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsLive() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsLive() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get durationSeconds => $_getN(7);
  @$pb.TagNumber(8)
  set durationSeconds($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get preferProxy => $_getBF(8);
  @$pb.TagNumber(9)
  set preferProxy($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPreferProxy() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreferProxy() => $_clearField(9);
}

class AlistMediaSourceConfig extends $pb.GeneratedMessage {
  factory AlistMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
    $core.String? password,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (password != null) result.password = password;
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
}

class AlistPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory AlistPlaylistSourceConfig({
    $core.String? serverId,
    $core.String? path,
    $core.String? password,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
    if (password != null) result.password = password;
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
}

class CloudreveMediaSourceConfig extends $pb.GeneratedMessage {
  factory CloudreveMediaSourceConfig({
    $core.String? serverId,
    $core.String? path,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
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
}

class CloudrevePlaylistSourceConfig extends $pb.GeneratedMessage {
  factory CloudrevePlaylistSourceConfig({
    $core.String? serverId,
    $core.String? path,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (path != null) result.path = path;
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
}

class EmbyMediaSourceConfig extends $pb.GeneratedMessage {
  factory EmbyMediaSourceConfig({
    $core.String? serverId,
    $core.String? itemId,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (itemId != null) result.itemId = itemId;
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
}

class EmbyPlaylistSourceConfig extends $pb.GeneratedMessage {
  factory EmbyPlaylistSourceConfig({
    $core.String? serverId,
    $core.String? itemId,
  }) {
    final result = create();
    if (serverId != null) result.serverId = serverId;
    if (itemId != null) result.itemId = itemId;
    return result;
  }

  EmbyPlaylistSourceConfig._();

  factory EmbyPlaylistSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmbyPlaylistSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmbyPlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
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
}

class RtmpMediaSourceConfig extends $pb.GeneratedMessage {
  factory RtmpMediaSourceConfig() => create();

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
}

class LiveProxyMediaSourceConfig extends $pb.GeneratedMessage {
  factory LiveProxyMediaSourceConfig({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  LiveProxyMediaSourceConfig._();

  factory LiveProxyMediaSourceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveProxyMediaSourceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveProxyMediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
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
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
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
  }) {
    final result = create();
    if (video != null) result.video = video;
    if (pgc != null) result.pgc = pgc;
    if (live != null) result.live = live;
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
}

enum MediaSourceConfig_Provider {
  directUrl,
  bilibili,
  alist,
  emby,
  rtmp,
  liveProxy,
  cloudreve,
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
  }) {
    final result = create();
    if (directUrl != null) result.directUrl = directUrl;
    if (bilibili != null) result.bilibili = bilibili;
    if (alist != null) result.alist = alist;
    if (emby != null) result.emby = emby;
    if (rtmp != null) result.rtmp = rtmp;
    if (liveProxy != null) result.liveProxy = liveProxy;
    if (cloudreve != null) result.cloudreve = cloudreve;
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
    0: MediaSourceConfig_Provider.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7])
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
  MediaSourceConfig_Provider whichProvider() =>
      _MediaSourceConfig_ProviderByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
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
}

enum PlaylistSourceConfig_Provider { alist, emby, cloudreve, notSet }

class PlaylistSourceConfig extends $pb.GeneratedMessage {
  factory PlaylistSourceConfig({
    AlistPlaylistSourceConfig? alist,
    EmbyPlaylistSourceConfig? emby,
    CloudrevePlaylistSourceConfig? cloudreve,
  }) {
    final result = create();
    if (alist != null) result.alist = alist;
    if (emby != null) result.emby = emby;
    if (cloudreve != null) result.cloudreve = cloudreve;
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
    1: PlaylistSourceConfig_Provider.alist,
    2: PlaylistSourceConfig_Provider.emby,
    3: PlaylistSourceConfig_Provider.cloudreve,
    0: PlaylistSourceConfig_Provider.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistSourceConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.source_config'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<AlistPlaylistSourceConfig>(1, _omitFieldNames ? '' : 'alist',
        subBuilder: AlistPlaylistSourceConfig.create)
    ..aOM<EmbyPlaylistSourceConfig>(2, _omitFieldNames ? '' : 'emby',
        subBuilder: EmbyPlaylistSourceConfig.create)
    ..aOM<CloudrevePlaylistSourceConfig>(3, _omitFieldNames ? '' : 'cloudreve',
        subBuilder: CloudrevePlaylistSourceConfig.create)
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

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  PlaylistSourceConfig_Provider whichProvider() =>
      _PlaylistSourceConfig_ProviderByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearProvider() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AlistPlaylistSourceConfig get alist => $_getN(0);
  @$pb.TagNumber(1)
  set alist(AlistPlaylistSourceConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlist() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlist() => $_clearField(1);
  @$pb.TagNumber(1)
  AlistPlaylistSourceConfig ensureAlist() => $_ensure(0);

  @$pb.TagNumber(2)
  EmbyPlaylistSourceConfig get emby => $_getN(1);
  @$pb.TagNumber(2)
  set emby(EmbyPlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEmby() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmby() => $_clearField(2);
  @$pb.TagNumber(2)
  EmbyPlaylistSourceConfig ensureEmby() => $_ensure(1);

  @$pb.TagNumber(3)
  CloudrevePlaylistSourceConfig get cloudreve => $_getN(2);
  @$pb.TagNumber(3)
  set cloudreve(CloudrevePlaylistSourceConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCloudreve() => $_has(2);
  @$pb.TagNumber(3)
  void clearCloudreve() => $_clearField(3);
  @$pb.TagNumber(3)
  CloudrevePlaylistSourceConfig ensureCloudreve() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
