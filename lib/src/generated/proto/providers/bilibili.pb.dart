// This is a generated file - do not edit.
//
// Generated from proto/providers/bilibili.proto.

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
import 'bilibili.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'bilibili.pbenum.dart';

/// Parse video URL request
class ParseRequest extends $pb.GeneratedMessage {
  factory ParseRequest({
    $core.String? url,
    $core.String? instanceName,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ParseRequest._();

  factory ParseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseRequest copyWith(void Function(ParseRequest) updates) =>
      super.copyWith((message) => updates(message as ParseRequest))
          as ParseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParseRequest create() => ParseRequest._();
  @$core.override
  ParseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParseRequest>(create);
  static ParseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instanceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceName() => $_clearField(2);
}

/// Typed candidates that can be submitted directly to the existing add media or
/// create playlist APIs. Exactly one source config is present.
class ParseResponse extends $pb.GeneratedMessage {
  factory ParseResponse({
    $core.String? normalizedUrl,
    $core.Iterable<ParseCandidate>? candidates,
  }) {
    final result = create();
    if (normalizedUrl != null) result.normalizedUrl = normalizedUrl;
    if (candidates != null) result.candidates.addAll(candidates);
    return result;
  }

  ParseResponse._();

  factory ParseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'normalizedUrl')
    ..pPM<ParseCandidate>(2, _omitFieldNames ? '' : 'candidates',
        subBuilder: ParseCandidate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseResponse copyWith(void Function(ParseResponse) updates) =>
      super.copyWith((message) => updates(message as ParseResponse))
          as ParseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParseResponse create() => ParseResponse._();
  @$core.override
  ParseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParseResponse>(create);
  static ParseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get normalizedUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set normalizedUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNormalizedUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearNormalizedUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ParseCandidate> get candidates => $_getList(1);
}

enum ParseCandidate_SourceConfig { media, playlist, notSet }

class ParseCandidate extends $pb.GeneratedMessage {
  factory ParseCandidate({
    $core.String? title,
    $core.String? description,
    $core.String? cover,
    $core.Iterable<$core.String>? actors,
    $fixnum.Int64? durationSeconds,
    $core.int? partNumber,
    $fixnum.Int64? width,
    $fixnum.Int64? height,
    $0.MediaSourceConfig? media,
    $0.PlaylistSourceConfig? playlist,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (cover != null) result.cover = cover;
    if (actors != null) result.actors.addAll(actors);
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (partNumber != null) result.partNumber = partNumber;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (media != null) result.media = media;
    if (playlist != null) result.playlist = playlist;
    return result;
  }

  ParseCandidate._();

  factory ParseCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParseCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ParseCandidate_SourceConfig>
      _ParseCandidate_SourceConfigByTag = {
    9: ParseCandidate_SourceConfig.media,
    10: ParseCandidate_SourceConfig.playlist,
    0: ParseCandidate_SourceConfig.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParseCandidate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..oo(0, [9, 10])
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..pPS(4, _omitFieldNames ? '' : 'actors')
    ..a<$fixnum.Int64>(
        5, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(6, _omitFieldNames ? '' : 'partNumber', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.MediaSourceConfig>(9, _omitFieldNames ? '' : 'media',
        subBuilder: $0.MediaSourceConfig.create)
    ..aOM<$0.PlaylistSourceConfig>(10, _omitFieldNames ? '' : 'playlist',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseCandidate copyWith(void Function(ParseCandidate) updates) =>
      super.copyWith((message) => updates(message as ParseCandidate))
          as ParseCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParseCandidate create() => ParseCandidate._();
  @$core.override
  ParseCandidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParseCandidate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParseCandidate>(create);
  static ParseCandidate? _defaultInstance;

  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  ParseCandidate_SourceConfig whichSourceConfig() =>
      _ParseCandidate_SourceConfigByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  void clearSourceConfig() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get actors => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get durationSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDurationSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearDurationSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get partNumber => $_getIZ(5);
  @$pb.TagNumber(6)
  set partNumber($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPartNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearPartNumber() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get width => $_getI64(6);
  @$pb.TagNumber(7)
  set width($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWidth() => $_has(6);
  @$pb.TagNumber(7)
  void clearWidth() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get height => $_getI64(7);
  @$pb.TagNumber(8)
  set height($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHeight() => $_has(7);
  @$pb.TagNumber(8)
  void clearHeight() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.MediaSourceConfig get media => $_getN(8);
  @$pb.TagNumber(9)
  set media($0.MediaSourceConfig value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMedia() => $_has(8);
  @$pb.TagNumber(9)
  void clearMedia() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.MediaSourceConfig ensureMedia() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.PlaylistSourceConfig get playlist => $_getN(9);
  @$pb.TagNumber(10)
  set playlist($0.PlaylistSourceConfig value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPlaylist() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlaylist() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.PlaylistSourceConfig ensurePlaylist() => $_ensure(9);
}

/// List the live-area hierarchy used to build a live-area playlist source.
class ListLiveAreasRequest extends $pb.GeneratedMessage {
  factory ListLiveAreasRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListLiveAreasRequest._();

  factory ListLiveAreasRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLiveAreasRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLiveAreasRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiveAreasRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiveAreasRequest copyWith(void Function(ListLiveAreasRequest) updates) =>
      super.copyWith((message) => updates(message as ListLiveAreasRequest))
          as ListLiveAreasRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLiveAreasRequest create() => ListLiveAreasRequest._();
  @$core.override
  ListLiveAreasRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLiveAreasRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLiveAreasRequest>(create);
  static ListLiveAreasRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

class LiveArea extends $pb.GeneratedMessage {
  factory LiveArea({
    $fixnum.Int64? id,
    $fixnum.Int64? parentId,
    $core.String? name,
    $core.String? parentName,
    $core.String? picture,
    $core.bool? hot,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parentId != null) result.parentId = parentId;
    if (name != null) result.name = name;
    if (parentName != null) result.parentName = parentName;
    if (picture != null) result.picture = picture;
    if (hot != null) result.hot = hot;
    return result;
  }

  LiveArea._();

  factory LiveArea.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiveArea.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveArea',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'parentId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'parentName')
    ..aOS(5, _omitFieldNames ? '' : 'picture')
    ..aOB(6, _omitFieldNames ? '' : 'hot')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveArea clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveArea copyWith(void Function(LiveArea) updates) =>
      super.copyWith((message) => updates(message as LiveArea)) as LiveArea;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiveArea create() => LiveArea._();
  @$core.override
  LiveArea createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiveArea getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LiveArea>(create);
  static LiveArea? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get parentId => $_getI64(1);
  @$pb.TagNumber(2)
  set parentId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parentName => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentName() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get picture => $_getSZ(4);
  @$pb.TagNumber(5)
  set picture($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPicture() => $_has(4);
  @$pb.TagNumber(5)
  void clearPicture() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hot => $_getBF(5);
  @$pb.TagNumber(6)
  set hot($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHot() => $_has(5);
  @$pb.TagNumber(6)
  void clearHot() => $_clearField(6);
}

class ListLiveAreasResponse extends $pb.GeneratedMessage {
  factory ListLiveAreasResponse({
    $core.Iterable<LiveArea>? areas,
  }) {
    final result = create();
    if (areas != null) result.areas.addAll(areas);
    return result;
  }

  ListLiveAreasResponse._();

  factory ListLiveAreasResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLiveAreasResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLiveAreasResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<LiveArea>(1, _omitFieldNames ? '' : 'areas',
        subBuilder: LiveArea.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiveAreasResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiveAreasResponse copyWith(
          void Function(ListLiveAreasResponse) updates) =>
      super.copyWith((message) => updates(message as ListLiveAreasResponse))
          as ListLiveAreasResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLiveAreasResponse create() => ListLiveAreasResponse._();
  @$core.override
  ListLiveAreasResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLiveAreasResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLiveAreasResponse>(create);
  static ListLiveAreasResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LiveArea> get areas => $_getList(0);
}

class ListFavoriteFoldersRequest extends $pb.GeneratedMessage {
  factory ListFavoriteFoldersRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListFavoriteFoldersRequest._();

  factory ListFavoriteFoldersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFavoriteFoldersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFavoriteFoldersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavoriteFoldersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavoriteFoldersRequest copyWith(
          void Function(ListFavoriteFoldersRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListFavoriteFoldersRequest))
          as ListFavoriteFoldersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFavoriteFoldersRequest create() => ListFavoriteFoldersRequest._();
  @$core.override
  ListFavoriteFoldersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFavoriteFoldersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFavoriteFoldersRequest>(create);
  static ListFavoriteFoldersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

class FavoriteFolder extends $pb.GeneratedMessage {
  factory FavoriteFolder({
    $fixnum.Int64? mediaId,
    $core.String? title,
    $fixnum.Int64? mediaCount,
    $core.bool? private,
    $core.bool? defaultFolder,
    $0.PlaylistSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (mediaId != null) result.mediaId = mediaId;
    if (title != null) result.title = title;
    if (mediaCount != null) result.mediaCount = mediaCount;
    if (private != null) result.private = private;
    if (defaultFolder != null) result.defaultFolder = defaultFolder;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  FavoriteFolder._();

  factory FavoriteFolder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavoriteFolder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavoriteFolder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mediaId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'mediaCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(4, _omitFieldNames ? '' : 'private')
    ..aOB(5, _omitFieldNames ? '' : 'defaultFolder')
    ..aOM<$0.PlaylistSourceConfig>(6, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoriteFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoriteFolder copyWith(void Function(FavoriteFolder) updates) =>
      super.copyWith((message) => updates(message as FavoriteFolder))
          as FavoriteFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavoriteFolder create() => FavoriteFolder._();
  @$core.override
  FavoriteFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavoriteFolder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavoriteFolder>(create);
  static FavoriteFolder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mediaId => $_getI64(0);
  @$pb.TagNumber(1)
  set mediaId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get mediaCount => $_getI64(2);
  @$pb.TagNumber(3)
  set mediaCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMediaCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearMediaCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get private => $_getBF(3);
  @$pb.TagNumber(4)
  set private($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrivate() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrivate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get defaultFolder => $_getBF(4);
  @$pb.TagNumber(5)
  set defaultFolder($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDefaultFolder() => $_has(4);
  @$pb.TagNumber(5)
  void clearDefaultFolder() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.PlaylistSourceConfig get sourceConfig => $_getN(5);
  @$pb.TagNumber(6)
  set sourceConfig($0.PlaylistSourceConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.PlaylistSourceConfig ensureSourceConfig() => $_ensure(5);
}

class ListFavoriteFoldersResponse extends $pb.GeneratedMessage {
  factory ListFavoriteFoldersResponse({
    $core.Iterable<FavoriteFolder>? folders,
  }) {
    final result = create();
    if (folders != null) result.folders.addAll(folders);
    return result;
  }

  ListFavoriteFoldersResponse._();

  factory ListFavoriteFoldersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFavoriteFoldersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFavoriteFoldersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<FavoriteFolder>(1, _omitFieldNames ? '' : 'folders',
        subBuilder: FavoriteFolder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavoriteFoldersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavoriteFoldersResponse copyWith(
          void Function(ListFavoriteFoldersResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListFavoriteFoldersResponse))
          as ListFavoriteFoldersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFavoriteFoldersResponse create() =>
      ListFavoriteFoldersResponse._();
  @$core.override
  ListFavoriteFoldersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFavoriteFoldersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFavoriteFoldersResponse>(create);
  static ListFavoriteFoldersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FavoriteFolder> get folders => $_getList(0);
}

class ListFollowedPgcRequest extends $pb.GeneratedMessage {
  factory ListFollowedPgcRequest({
    $core.String? instanceName,
    PgcFollowType? type,
    $fixnum.Int64? page,
    $core.int? pageSize,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    if (type != null) result.type = type;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListFollowedPgcRequest._();

  factory ListFollowedPgcRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFollowedPgcRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFollowedPgcRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..aE<PgcFollowType>(2, _omitFieldNames ? '' : 'type',
        enumValues: PgcFollowType.values)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(4, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedPgcRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedPgcRequest copyWith(
          void Function(ListFollowedPgcRequest) updates) =>
      super.copyWith((message) => updates(message as ListFollowedPgcRequest))
          as ListFollowedPgcRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFollowedPgcRequest create() => ListFollowedPgcRequest._();
  @$core.override
  ListFollowedPgcRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFollowedPgcRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFollowedPgcRequest>(create);
  static ListFollowedPgcRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);

  @$pb.TagNumber(2)
  PgcFollowType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(PgcFollowType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get page => $_getI64(2);
  @$pb.TagNumber(3)
  set page($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class FollowedPgcSeason extends $pb.GeneratedMessage {
  factory FollowedPgcSeason({
    $fixnum.Int64? seasonId,
    $core.String? title,
    $core.String? cover,
    $core.String? description,
    $core.String? latestEpisode,
    $0.PlaylistSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (seasonId != null) result.seasonId = seasonId;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (description != null) result.description = description;
    if (latestEpisode != null) result.latestEpisode = latestEpisode;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  FollowedPgcSeason._();

  factory FollowedPgcSeason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FollowedPgcSeason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowedPgcSeason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'seasonId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'latestEpisode')
    ..aOM<$0.PlaylistSourceConfig>(6, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowedPgcSeason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowedPgcSeason copyWith(void Function(FollowedPgcSeason) updates) =>
      super.copyWith((message) => updates(message as FollowedPgcSeason))
          as FollowedPgcSeason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FollowedPgcSeason create() => FollowedPgcSeason._();
  @$core.override
  FollowedPgcSeason createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FollowedPgcSeason getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowedPgcSeason>(create);
  static FollowedPgcSeason? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get latestEpisode => $_getSZ(4);
  @$pb.TagNumber(5)
  set latestEpisode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLatestEpisode() => $_has(4);
  @$pb.TagNumber(5)
  void clearLatestEpisode() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.PlaylistSourceConfig get sourceConfig => $_getN(5);
  @$pb.TagNumber(6)
  set sourceConfig($0.PlaylistSourceConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.PlaylistSourceConfig ensureSourceConfig() => $_ensure(5);
}

class ListFollowedPgcResponse extends $pb.GeneratedMessage {
  factory ListFollowedPgcResponse({
    $core.Iterable<FollowedPgcSeason>? seasons,
    $fixnum.Int64? total,
    $core.bool? hasMore,
  }) {
    final result = create();
    if (seasons != null) result.seasons.addAll(seasons);
    if (total != null) result.total = total;
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  ListFollowedPgcResponse._();

  factory ListFollowedPgcResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFollowedPgcResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFollowedPgcResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<FollowedPgcSeason>(1, _omitFieldNames ? '' : 'seasons',
        subBuilder: FollowedPgcSeason.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedPgcResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFollowedPgcResponse copyWith(
          void Function(ListFollowedPgcResponse) updates) =>
      super.copyWith((message) => updates(message as ListFollowedPgcResponse))
          as ListFollowedPgcResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFollowedPgcResponse create() => ListFollowedPgcResponse._();
  @$core.override
  ListFollowedPgcResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFollowedPgcResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFollowedPgcResponse>(create);
  static ListFollowedPgcResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FollowedPgcSeason> get seasons => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);
}

class ListHistoryRequest extends $pb.GeneratedMessage {
  factory ListHistoryRequest({
    $0.BilibiliHistoryType? type,
    $core.String? cursor,
    $core.int? pageSize,
    $core.String? instanceName,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (cursor != null) result.cursor = cursor;
    if (pageSize != null) result.pageSize = pageSize;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListHistoryRequest._();

  factory ListHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aE<$0.BilibiliHistoryType>(1, _omitFieldNames ? '' : 'type',
        enumValues: $0.BilibiliHistoryType.values)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aI(3, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryRequest copyWith(void Function(ListHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as ListHistoryRequest))
          as ListHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHistoryRequest create() => ListHistoryRequest._();
  @$core.override
  ListHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHistoryRequest>(create);
  static ListHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.BilibiliHistoryType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type($0.BilibiliHistoryType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class HistoryItem extends $pb.GeneratedMessage {
  factory HistoryItem({
    $core.String? title,
    $core.String? subtitle,
    $core.String? cover,
    $core.String? author,
    $fixnum.Int64? viewedAt,
    $fixnum.Int64? progressSeconds,
    $fixnum.Int64? durationSeconds,
    $0.MediaSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (cover != null) result.cover = cover;
    if (author != null) result.author = author;
    if (viewedAt != null) result.viewedAt = viewedAt;
    if (progressSeconds != null) result.progressSeconds = progressSeconds;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  HistoryItem._();

  factory HistoryItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HistoryItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HistoryItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aOS(4, _omitFieldNames ? '' : 'author')
    ..aInt64(5, _omitFieldNames ? '' : 'viewedAt')
    ..aInt64(6, _omitFieldNames ? '' : 'progressSeconds')
    ..a<$fixnum.Int64>(
        7, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.MediaSourceConfig>(8, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.MediaSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryItem copyWith(void Function(HistoryItem) updates) =>
      super.copyWith((message) => updates(message as HistoryItem))
          as HistoryItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryItem create() => HistoryItem._();
  @$core.override
  HistoryItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HistoryItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HistoryItem>(create);
  static HistoryItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subtitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set subtitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get author => $_getSZ(3);
  @$pb.TagNumber(4)
  set author($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthor() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthor() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get viewedAt => $_getI64(4);
  @$pb.TagNumber(5)
  set viewedAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasViewedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearViewedAt() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get progressSeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set progressSeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProgressSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearProgressSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get durationSeconds => $_getI64(6);
  @$pb.TagNumber(7)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDurationSeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearDurationSeconds() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.MediaSourceConfig get sourceConfig => $_getN(7);
  @$pb.TagNumber(8)
  set sourceConfig($0.MediaSourceConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceConfig() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceConfig() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.MediaSourceConfig ensureSourceConfig() => $_ensure(7);
}

class ListHistoryResponse extends $pb.GeneratedMessage {
  factory ListHistoryResponse({
    $core.Iterable<HistoryItem>? items,
    $core.String? cursor,
    $core.bool? hasMore,
    $0.PlaylistSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  ListHistoryResponse._();

  factory ListHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<HistoryItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: HistoryItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'cursor')
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<$0.PlaylistSourceConfig>(4, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryResponse copyWith(void Function(ListHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as ListHistoryResponse))
          as ListHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHistoryResponse create() => ListHistoryResponse._();
  @$core.override
  ListHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHistoryResponse>(create);
  static ListHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HistoryItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get cursor => $_getSZ(1);
  @$pb.TagNumber(2)
  set cursor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.PlaylistSourceConfig get sourceConfig => $_getN(3);
  @$pb.TagNumber(4)
  set sourceConfig($0.PlaylistSourceConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceConfig() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.PlaylistSourceConfig ensureSourceConfig() => $_ensure(3);
}

class ListPgcTimelineRequest extends $pb.GeneratedMessage {
  factory ListPgcTimelineRequest({
    $0.BilibiliPgcTimelineType? type,
    $core.int? beforeDays,
    $core.int? afterDays,
    $core.String? instanceName,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (beforeDays != null) result.beforeDays = beforeDays;
    if (afterDays != null) result.afterDays = afterDays;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListPgcTimelineRequest._();

  factory ListPgcTimelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPgcTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPgcTimelineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aE<$0.BilibiliPgcTimelineType>(1, _omitFieldNames ? '' : 'type',
        enumValues: $0.BilibiliPgcTimelineType.values)
    ..aI(2, _omitFieldNames ? '' : 'beforeDays', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'afterDays', fieldType: $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcTimelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcTimelineRequest copyWith(
          void Function(ListPgcTimelineRequest) updates) =>
      super.copyWith((message) => updates(message as ListPgcTimelineRequest))
          as ListPgcTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPgcTimelineRequest create() => ListPgcTimelineRequest._();
  @$core.override
  ListPgcTimelineRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPgcTimelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPgcTimelineRequest>(create);
  static ListPgcTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.BilibiliPgcTimelineType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type($0.BilibiliPgcTimelineType value) => $_setField(1, value);
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

  @$pb.TagNumber(4)
  $core.String get instanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set instanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstanceName() => $_clearField(4);
}

class PgcTimelineItem extends $pb.GeneratedMessage {
  factory PgcTimelineItem({
    $fixnum.Int64? episodeId,
    $fixnum.Int64? seasonId,
    $core.String? title,
    $core.String? episodeTitle,
    $core.String? cover,
    $core.String? episodeCover,
    $fixnum.Int64? publishAt,
    $core.bool? published,
    $core.String? date,
    $core.int? dayOfWeek,
    $core.bool? delayed,
    $core.String? delayReason,
    $0.MediaSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (seasonId != null) result.seasonId = seasonId;
    if (title != null) result.title = title;
    if (episodeTitle != null) result.episodeTitle = episodeTitle;
    if (cover != null) result.cover = cover;
    if (episodeCover != null) result.episodeCover = episodeCover;
    if (publishAt != null) result.publishAt = publishAt;
    if (published != null) result.published = published;
    if (date != null) result.date = date;
    if (dayOfWeek != null) result.dayOfWeek = dayOfWeek;
    if (delayed != null) result.delayed = delayed;
    if (delayReason != null) result.delayReason = delayReason;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  PgcTimelineItem._();

  factory PgcTimelineItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PgcTimelineItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PgcTimelineItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'episodeId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'seasonId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'episodeTitle')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOS(6, _omitFieldNames ? '' : 'episodeCover')
    ..aInt64(7, _omitFieldNames ? '' : 'publishAt')
    ..aOB(8, _omitFieldNames ? '' : 'published')
    ..aOS(9, _omitFieldNames ? '' : 'date')
    ..aI(10, _omitFieldNames ? '' : 'dayOfWeek', fieldType: $pb.PbFieldType.OU3)
    ..aOB(11, _omitFieldNames ? '' : 'delayed')
    ..aOS(12, _omitFieldNames ? '' : 'delayReason')
    ..aOM<$0.MediaSourceConfig>(13, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.MediaSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PgcTimelineItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PgcTimelineItem copyWith(void Function(PgcTimelineItem) updates) =>
      super.copyWith((message) => updates(message as PgcTimelineItem))
          as PgcTimelineItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PgcTimelineItem create() => PgcTimelineItem._();
  @$core.override
  PgcTimelineItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PgcTimelineItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PgcTimelineItem>(create);
  static PgcTimelineItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get episodeId => $_getI64(0);
  @$pb.TagNumber(1)
  set episodeId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seasonId => $_getI64(1);
  @$pb.TagNumber(2)
  set seasonId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeasonId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeasonId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get episodeTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set episodeTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEpisodeTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearEpisodeTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get episodeCover => $_getSZ(5);
  @$pb.TagNumber(6)
  set episodeCover($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEpisodeCover() => $_has(5);
  @$pb.TagNumber(6)
  void clearEpisodeCover() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get publishAt => $_getI64(6);
  @$pb.TagNumber(7)
  set publishAt($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPublishAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPublishAt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get published => $_getBF(7);
  @$pb.TagNumber(8)
  set published($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPublished() => $_has(7);
  @$pb.TagNumber(8)
  void clearPublished() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get date => $_getSZ(8);
  @$pb.TagNumber(9)
  set date($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearDate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get dayOfWeek => $_getIZ(9);
  @$pb.TagNumber(10)
  set dayOfWeek($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDayOfWeek() => $_has(9);
  @$pb.TagNumber(10)
  void clearDayOfWeek() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get delayed => $_getBF(10);
  @$pb.TagNumber(11)
  set delayed($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDelayed() => $_has(10);
  @$pb.TagNumber(11)
  void clearDelayed() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get delayReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set delayReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDelayReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearDelayReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.MediaSourceConfig get sourceConfig => $_getN(12);
  @$pb.TagNumber(13)
  set sourceConfig($0.MediaSourceConfig value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSourceConfig() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceConfig() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.MediaSourceConfig ensureSourceConfig() => $_ensure(12);
}

class ListPgcTimelineResponse extends $pb.GeneratedMessage {
  factory ListPgcTimelineResponse({
    $core.Iterable<PgcTimelineItem>? items,
    $0.PlaylistSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  ListPgcTimelineResponse._();

  factory ListPgcTimelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPgcTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPgcTimelineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<PgcTimelineItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PgcTimelineItem.create)
    ..aOM<$0.PlaylistSourceConfig>(2, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcTimelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcTimelineResponse copyWith(
          void Function(ListPgcTimelineResponse) updates) =>
      super.copyWith((message) => updates(message as ListPgcTimelineResponse))
          as ListPgcTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPgcTimelineResponse create() => ListPgcTimelineResponse._();
  @$core.override
  ListPgcTimelineResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPgcTimelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPgcTimelineResponse>(create);
  static ListPgcTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PgcTimelineItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $0.PlaylistSourceConfig get sourceConfig => $_getN(1);
  @$pb.TagNumber(2)
  set sourceConfig($0.PlaylistSourceConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.PlaylistSourceConfig ensureSourceConfig() => $_ensure(1);
}

class ListPgcSeasonsRequest extends $pb.GeneratedMessage {
  factory ListPgcSeasonsRequest({
    PgcSeasonType? type,
    $fixnum.Int64? page,
    $core.int? pageSize,
    PgcSeasonOrder? order,
    $core.bool? ascending,
    $core.bool? finished,
    $core.String? area,
    $core.String? year,
    $fixnum.Int64? styleId,
    $core.String? instanceName,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (page != null) result.page = page;
    if (pageSize != null) result.pageSize = pageSize;
    if (order != null) result.order = order;
    if (ascending != null) result.ascending = ascending;
    if (finished != null) result.finished = finished;
    if (area != null) result.area = area;
    if (year != null) result.year = year;
    if (styleId != null) result.styleId = styleId;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ListPgcSeasonsRequest._();

  factory ListPgcSeasonsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPgcSeasonsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPgcSeasonsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aE<PgcSeasonType>(1, _omitFieldNames ? '' : 'type',
        enumValues: PgcSeasonType.values)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'page', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'pageSize', fieldType: $pb.PbFieldType.OU3)
    ..aE<PgcSeasonOrder>(4, _omitFieldNames ? '' : 'order',
        enumValues: PgcSeasonOrder.values)
    ..aOB(5, _omitFieldNames ? '' : 'ascending')
    ..aOB(6, _omitFieldNames ? '' : 'finished')
    ..aOS(7, _omitFieldNames ? '' : 'area')
    ..aOS(8, _omitFieldNames ? '' : 'year')
    ..a<$fixnum.Int64>(9, _omitFieldNames ? '' : 'styleId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(10, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcSeasonsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcSeasonsRequest copyWith(
          void Function(ListPgcSeasonsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPgcSeasonsRequest))
          as ListPgcSeasonsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPgcSeasonsRequest create() => ListPgcSeasonsRequest._();
  @$core.override
  ListPgcSeasonsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPgcSeasonsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPgcSeasonsRequest>(create);
  static ListPgcSeasonsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PgcSeasonType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(PgcSeasonType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get page => $_getI64(1);
  @$pb.TagNumber(2)
  set page($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  PgcSeasonOrder get order => $_getN(3);
  @$pb.TagNumber(4)
  set order(PgcSeasonOrder value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrder() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get ascending => $_getBF(4);
  @$pb.TagNumber(5)
  set ascending($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAscending() => $_has(4);
  @$pb.TagNumber(5)
  void clearAscending() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get finished => $_getBF(5);
  @$pb.TagNumber(6)
  set finished($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFinished() => $_has(5);
  @$pb.TagNumber(6)
  void clearFinished() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get area => $_getSZ(6);
  @$pb.TagNumber(7)
  set area($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasArea() => $_has(6);
  @$pb.TagNumber(7)
  void clearArea() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get year => $_getSZ(7);
  @$pb.TagNumber(8)
  set year($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasYear() => $_has(7);
  @$pb.TagNumber(8)
  void clearYear() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get styleId => $_getI64(8);
  @$pb.TagNumber(9)
  set styleId($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStyleId() => $_has(8);
  @$pb.TagNumber(9)
  void clearStyleId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get instanceName => $_getSZ(9);
  @$pb.TagNumber(10)
  set instanceName($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInstanceName() => $_has(9);
  @$pb.TagNumber(10)
  void clearInstanceName() => $_clearField(10);
}

class PgcSeason extends $pb.GeneratedMessage {
  factory PgcSeason({
    $fixnum.Int64? seasonId,
    $fixnum.Int64? mediaId,
    $fixnum.Int64? firstEpisodeId,
    $core.String? title,
    $core.String? subtitle,
    $core.String? cover,
    $core.String? firstEpisodeCover,
    $core.String? badge,
    $core.String? progress,
    $core.String? score,
    $core.bool? finished,
    PgcSeasonType? type,
    $0.PlaylistSourceConfig? sourceConfig,
  }) {
    final result = create();
    if (seasonId != null) result.seasonId = seasonId;
    if (mediaId != null) result.mediaId = mediaId;
    if (firstEpisodeId != null) result.firstEpisodeId = firstEpisodeId;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (cover != null) result.cover = cover;
    if (firstEpisodeCover != null) result.firstEpisodeCover = firstEpisodeCover;
    if (badge != null) result.badge = badge;
    if (progress != null) result.progress = progress;
    if (score != null) result.score = score;
    if (finished != null) result.finished = finished;
    if (type != null) result.type = type;
    if (sourceConfig != null) result.sourceConfig = sourceConfig;
    return result;
  }

  PgcSeason._();

  factory PgcSeason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PgcSeason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PgcSeason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'seasonId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'mediaId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'firstEpisodeId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'subtitle')
    ..aOS(6, _omitFieldNames ? '' : 'cover')
    ..aOS(7, _omitFieldNames ? '' : 'firstEpisodeCover')
    ..aOS(8, _omitFieldNames ? '' : 'badge')
    ..aOS(9, _omitFieldNames ? '' : 'progress')
    ..aOS(10, _omitFieldNames ? '' : 'score')
    ..aOB(11, _omitFieldNames ? '' : 'finished')
    ..aE<PgcSeasonType>(12, _omitFieldNames ? '' : 'type',
        enumValues: PgcSeasonType.values)
    ..aOM<$0.PlaylistSourceConfig>(13, _omitFieldNames ? '' : 'sourceConfig',
        subBuilder: $0.PlaylistSourceConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PgcSeason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PgcSeason copyWith(void Function(PgcSeason) updates) =>
      super.copyWith((message) => updates(message as PgcSeason)) as PgcSeason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PgcSeason create() => PgcSeason._();
  @$core.override
  PgcSeason createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PgcSeason getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PgcSeason>(create);
  static PgcSeason? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mediaId => $_getI64(1);
  @$pb.TagNumber(2)
  set mediaId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get firstEpisodeId => $_getI64(2);
  @$pb.TagNumber(3)
  set firstEpisodeId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFirstEpisodeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirstEpisodeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get subtitle => $_getSZ(4);
  @$pb.TagNumber(5)
  set subtitle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubtitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get cover => $_getSZ(5);
  @$pb.TagNumber(6)
  set cover($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCover() => $_has(5);
  @$pb.TagNumber(6)
  void clearCover() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get firstEpisodeCover => $_getSZ(6);
  @$pb.TagNumber(7)
  set firstEpisodeCover($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFirstEpisodeCover() => $_has(6);
  @$pb.TagNumber(7)
  void clearFirstEpisodeCover() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get badge => $_getSZ(7);
  @$pb.TagNumber(8)
  set badge($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBadge() => $_has(7);
  @$pb.TagNumber(8)
  void clearBadge() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get progress => $_getSZ(8);
  @$pb.TagNumber(9)
  set progress($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProgress() => $_has(8);
  @$pb.TagNumber(9)
  void clearProgress() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get score => $_getSZ(9);
  @$pb.TagNumber(10)
  set score($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearScore() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get finished => $_getBF(10);
  @$pb.TagNumber(11)
  set finished($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFinished() => $_has(10);
  @$pb.TagNumber(11)
  void clearFinished() => $_clearField(11);

  @$pb.TagNumber(12)
  PgcSeasonType get type => $_getN(11);
  @$pb.TagNumber(12)
  set type(PgcSeasonType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasType() => $_has(11);
  @$pb.TagNumber(12)
  void clearType() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.PlaylistSourceConfig get sourceConfig => $_getN(12);
  @$pb.TagNumber(13)
  set sourceConfig($0.PlaylistSourceConfig value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSourceConfig() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceConfig() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.PlaylistSourceConfig ensureSourceConfig() => $_ensure(12);
}

class ListPgcSeasonsResponse extends $pb.GeneratedMessage {
  factory ListPgcSeasonsResponse({
    $core.Iterable<PgcSeason>? seasons,
    $fixnum.Int64? total,
    $core.bool? hasMore,
  }) {
    final result = create();
    if (seasons != null) result.seasons.addAll(seasons);
    if (total != null) result.total = total;
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  ListPgcSeasonsResponse._();

  factory ListPgcSeasonsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPgcSeasonsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPgcSeasonsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<PgcSeason>(1, _omitFieldNames ? '' : 'seasons',
        subBuilder: PgcSeason.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcSeasonsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPgcSeasonsResponse copyWith(
          void Function(ListPgcSeasonsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPgcSeasonsResponse))
          as ListPgcSeasonsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPgcSeasonsResponse create() => ListPgcSeasonsResponse._();
  @$core.override
  ListPgcSeasonsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPgcSeasonsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPgcSeasonsResponse>(create);
  static ListPgcSeasonsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PgcSeason> get seasons => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);
}

/// QR code login request
class LoginQRRequest extends $pb.GeneratedMessage {
  factory LoginQRRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  LoginQRRequest._();

  factory LoginQRRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginQRRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginQRRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginQRRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginQRRequest copyWith(void Function(LoginQRRequest) updates) =>
      super.copyWith((message) => updates(message as LoginQRRequest))
          as LoginQRRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginQRRequest create() => LoginQRRequest._();
  @$core.override
  LoginQRRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginQRRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginQRRequest>(create);
  static LoginQRRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

/// QR code response
class QRCodeResponse extends $pb.GeneratedMessage {
  factory QRCodeResponse({
    $core.String? url,
    $core.String? key,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (key != null) result.key = key;
    return result;
  }

  QRCodeResponse._();

  factory QRCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QRCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QRCodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QRCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QRCodeResponse copyWith(void Function(QRCodeResponse) updates) =>
      super.copyWith((message) => updates(message as QRCodeResponse))
          as QRCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QRCodeResponse create() => QRCodeResponse._();
  @$core.override
  QRCodeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QRCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QRCodeResponse>(create);
  static QRCodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => $_clearField(2);
}

/// Check QR status request
class CheckQRRequest extends $pb.GeneratedMessage {
  factory CheckQRRequest({
    $core.String? key,
    $core.String? instanceName,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  CheckQRRequest._();

  factory CheckQRRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckQRRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckQRRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckQRRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckQRRequest copyWith(void Function(CheckQRRequest) updates) =>
      super.copyWith((message) => updates(message as CheckQRRequest))
          as CheckQRRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckQRRequest create() => CheckQRRequest._();
  @$core.override
  CheckQRRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckQRRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckQRRequest>(create);
  static CheckQRRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instanceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceName() => $_clearField(2);
}

/// QR status response
class QRStatusResponse extends $pb.GeneratedMessage {
  factory QRStatusResponse({
    QRLoginStatus? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  QRStatusResponse._();

  factory QRStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QRStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QRStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aE<QRLoginStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: QRLoginStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QRStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QRStatusResponse copyWith(void Function(QRStatusResponse) updates) =>
      super.copyWith((message) => updates(message as QRStatusResponse))
          as QRStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QRStatusResponse create() => QRStatusResponse._();
  @$core.override
  QRStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QRStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QRStatusResponse>(create);
  static QRStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  QRLoginStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(QRLoginStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

/// Start SMS login request
class StartSMSLoginRequest extends $pb.GeneratedMessage {
  factory StartSMSLoginRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  StartSMSLoginRequest._();

  factory StartSMSLoginRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSMSLoginRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSMSLoginRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSMSLoginRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSMSLoginRequest copyWith(void Function(StartSMSLoginRequest) updates) =>
      super.copyWith((message) => updates(message as StartSMSLoginRequest))
          as StartSMSLoginRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSMSLoginRequest create() => StartSMSLoginRequest._();
  @$core.override
  StartSMSLoginRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSMSLoginRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSMSLoginRequest>(create);
  static StartSMSLoginRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

/// Start SMS login response
class StartSMSLoginResponse extends $pb.GeneratedMessage {
  factory StartSMSLoginResponse({
    $core.String? sessionToken,
    $core.String? gt,
    $core.String? challenge,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (sessionToken != null) result.sessionToken = sessionToken;
    if (gt != null) result.gt = gt;
    if (challenge != null) result.challenge = challenge;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  StartSMSLoginResponse._();

  factory StartSMSLoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartSMSLoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartSMSLoginResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken')
    ..aOS(2, _omitFieldNames ? '' : 'gt')
    ..aOS(3, _omitFieldNames ? '' : 'challenge')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSMSLoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartSMSLoginResponse copyWith(
          void Function(StartSMSLoginResponse) updates) =>
      super.copyWith((message) => updates(message as StartSMSLoginResponse))
          as StartSMSLoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartSMSLoginResponse create() => StartSMSLoginResponse._();
  @$core.override
  StartSMSLoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartSMSLoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartSMSLoginResponse>(create);
  static StartSMSLoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gt => $_getSZ(1);
  @$pb.TagNumber(2)
  set gt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGt() => $_has(1);
  @$pb.TagNumber(2)
  void clearGt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get challenge => $_getSZ(2);
  @$pb.TagNumber(3)
  set challenge($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChallenge() => $_has(2);
  @$pb.TagNumber(3)
  void clearChallenge() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

/// Send SMS request
class SendSMSRequest extends $pb.GeneratedMessage {
  factory SendSMSRequest({
    $core.String? sessionToken,
    $core.String? phone,
    $core.String? validate,
  }) {
    final result = create();
    if (sessionToken != null) result.sessionToken = sessionToken;
    if (phone != null) result.phone = phone;
    if (validate != null) result.validate = validate;
    return result;
  }

  SendSMSRequest._();

  factory SendSMSRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendSMSRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendSMSRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'validate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSMSRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSMSRequest copyWith(void Function(SendSMSRequest) updates) =>
      super.copyWith((message) => updates(message as SendSMSRequest))
          as SendSMSRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendSMSRequest create() => SendSMSRequest._();
  @$core.override
  SendSMSRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendSMSRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendSMSRequest>(create);
  static SendSMSRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get validate => $_getSZ(2);
  @$pb.TagNumber(3)
  set validate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValidate() => $_has(2);
  @$pb.TagNumber(3)
  void clearValidate() => $_clearField(3);
}

/// Send SMS response
class SendSMSResponse extends $pb.GeneratedMessage {
  factory SendSMSResponse({
    $core.String? sessionToken,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (sessionToken != null) result.sessionToken = sessionToken;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  SendSMSResponse._();

  factory SendSMSResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendSMSResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendSMSResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken')
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSMSResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendSMSResponse copyWith(void Function(SendSMSResponse) updates) =>
      super.copyWith((message) => updates(message as SendSMSResponse))
          as SendSMSResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendSMSResponse create() => SendSMSResponse._();
  @$core.override
  SendSMSResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendSMSResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendSMSResponse>(create);
  static SendSMSResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAt => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAt() => $_clearField(2);
}

/// Login with SMS request
class LoginSMSRequest extends $pb.GeneratedMessage {
  factory LoginSMSRequest({
    $core.String? sessionToken,
    $core.String? code,
  }) {
    final result = create();
    if (sessionToken != null) result.sessionToken = sessionToken;
    if (code != null) result.code = code;
    return result;
  }

  LoginSMSRequest._();

  factory LoginSMSRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginSMSRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginSMSRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginSMSRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginSMSRequest copyWith(void Function(LoginSMSRequest) updates) =>
      super.copyWith((message) => updates(message as LoginSMSRequest))
          as LoginSMSRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginSMSRequest create() => LoginSMSRequest._();
  @$core.override
  LoginSMSRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginSMSRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginSMSRequest>(create);
  static LoginSMSRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
}

/// Login with SMS response
class LoginSMSResponse extends $pb.GeneratedMessage {
  factory LoginSMSResponse() => create();

  LoginSMSResponse._();

  factory LoginSMSResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginSMSResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginSMSResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginSMSResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginSMSResponse copyWith(void Function(LoginSMSResponse) updates) =>
      super.copyWith((message) => updates(message as LoginSMSResponse))
          as LoginSMSResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginSMSResponse create() => LoginSMSResponse._();
  @$core.override
  LoginSMSResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginSMSResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginSMSResponse>(create);
  static LoginSMSResponse? _defaultInstance;
}

/// User info request
class UserInfoRequest extends $pb.GeneratedMessage {
  factory UserInfoRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  UserInfoRequest._();

  factory UserInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfoRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoRequest copyWith(void Function(UserInfoRequest) updates) =>
      super.copyWith((message) => updates(message as UserInfoRequest))
          as UserInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfoRequest create() => UserInfoRequest._();
  @$core.override
  UserInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserInfoRequest>(create);
  static UserInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

/// User info response
class UserInfoResponse extends $pb.GeneratedMessage {
  factory UserInfoResponse({
    $core.bool? isLogin,
    $fixnum.Int64? userId,
    $core.String? username,
    $core.String? face,
    $core.bool? isVip,
  }) {
    final result = create();
    if (isLogin != null) result.isLogin = isLogin;
    if (userId != null) result.userId = userId;
    if (username != null) result.username = username;
    if (face != null) result.face = face;
    if (isVip != null) result.isVip = isVip;
    return result;
  }

  UserInfoResponse._();

  factory UserInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfoResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isLogin')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'userId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'username')
    ..aOS(4, _omitFieldNames ? '' : 'face')
    ..aOB(5, _omitFieldNames ? '' : 'isVip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoResponse copyWith(void Function(UserInfoResponse) updates) =>
      super.copyWith((message) => updates(message as UserInfoResponse))
          as UserInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfoResponse create() => UserInfoResponse._();
  @$core.override
  UserInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserInfoResponse>(create);
  static UserInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isLogin => $_getBF(0);
  @$pb.TagNumber(1)
  set isLogin($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsLogin() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsLogin() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userId => $_getI64(1);
  @$pb.TagNumber(2)
  set userId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(3);
  @$pb.TagNumber(4)
  set face($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isVip => $_getBF(4);
  @$pb.TagNumber(5)
  set isVip($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsVip() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsVip() => $_clearField(5);
}

/// Logout request
class LogoutRequest extends $pb.GeneratedMessage {
  factory LogoutRequest() => create();

  LogoutRequest._();

  factory LogoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutRequest copyWith(void Function(LogoutRequest) updates) =>
      super.copyWith((message) => updates(message as LogoutRequest))
          as LogoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutRequest create() => LogoutRequest._();
  @$core.override
  LogoutRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutRequest>(create);
  static LogoutRequest? _defaultInstance;
}

/// Logout response
class LogoutResponse extends $pb.GeneratedMessage {
  factory LogoutResponse({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  LogoutResponse._();

  factory LogoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LogoutResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogoutResponse copyWith(void Function(LogoutResponse) updates) =>
      super.copyWith((message) => updates(message as LogoutResponse))
          as LogoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogoutResponse create() => LogoutResponse._();
  @$core.override
  LogoutResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LogoutResponse>(create);
  static LogoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

/// Get binds request
class GetBindsRequest extends $pb.GeneratedMessage {
  factory GetBindsRequest({
    $core.String? instanceName,
  }) {
    final result = create();
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  GetBindsRequest._();

  factory GetBindsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBindsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBindsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsRequest copyWith(void Function(GetBindsRequest) updates) =>
      super.copyWith((message) => updates(message as GetBindsRequest))
          as GetBindsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBindsRequest create() => GetBindsRequest._();
  @$core.override
  GetBindsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBindsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBindsRequest>(create);
  static GetBindsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instanceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set instanceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstanceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstanceName() => $_clearField(1);
}

/// Get binds response
class GetBindsResponse extends $pb.GeneratedMessage {
  factory GetBindsResponse({
    $core.Iterable<BindInfo>? binds,
  }) {
    final result = create();
    if (binds != null) result.binds.addAll(binds);
    return result;
  }

  GetBindsResponse._();

  factory GetBindsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBindsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBindsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..pPM<BindInfo>(1, _omitFieldNames ? '' : 'binds',
        subBuilder: BindInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBindsResponse copyWith(void Function(GetBindsResponse) updates) =>
      super.copyWith((message) => updates(message as GetBindsResponse))
          as GetBindsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBindsResponse create() => GetBindsResponse._();
  @$core.override
  GetBindsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBindsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBindsResponse>(create);
  static GetBindsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BindInfo> get binds => $_getList(0);
}

/// Saved credential information
class BindInfo extends $pb.GeneratedMessage {
  factory BindInfo({
    $core.String? id,
    $core.String? serverId,
    $fixnum.Int64? createdAt,
    $core.String? providerInstanceName,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serverId != null) result.serverId = serverId;
    if (createdAt != null) result.createdAt = createdAt;
    if (providerInstanceName != null)
      result.providerInstanceName = providerInstanceName;
    return result;
  }

  BindInfo._();

  factory BindInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BindInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BindInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.bilibili'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serverId')
    ..aInt64(3, _omitFieldNames ? '' : 'createdAt')
    ..aOS(4, _omitFieldNames ? '' : 'providerInstanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BindInfo copyWith(void Function(BindInfo) updates) =>
      super.copyWith((message) => updates(message as BindInfo)) as BindInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BindInfo create() => BindInfo._();
  @$core.override
  BindInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BindInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindInfo>(create);
  static BindInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverId => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createdAt => $_getI64(2);
  @$pb.TagNumber(3)
  set createdAt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get providerInstanceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set providerInstanceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProviderInstanceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearProviderInstanceName() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
