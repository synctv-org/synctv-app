// This is a generated file - do not edit.
//
// Generated from proto/providers/huya.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;
import 'huya.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'huya.pbenum.dart';

class ResolveRequest extends $pb.GeneratedMessage {
  factory ResolveRequest({
    $core.String? resource,
    $core.String? instanceName,
  }) {
    final result = create();
    if (resource != null) result.resource = resource;
    if (instanceName != null) result.instanceName = instanceName;
    return result;
  }

  ResolveRequest._();

  factory ResolveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.huya'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resource')
    ..aOS(2, _omitFieldNames ? '' : 'instanceName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveRequest copyWith(void Function(ResolveRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveRequest))
          as ResolveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveRequest create() => ResolveRequest._();
  @$core.override
  ResolveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveRequest>(create);
  static ResolveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resource => $_getSZ(0);
  @$pb.TagNumber(1)
  set resource($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResource() => $_has(0);
  @$pb.TagNumber(1)
  void clearResource() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get instanceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set instanceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInstanceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstanceName() => $_clearField(2);
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? id,
    $core.String? title,
    $core.String? author,
    $core.String? authorId,
    $core.String? category,
    $core.String? thumbnailUrl,
    $core.String? avatarUrl,
    $core.bool? isLive,
    $core.String? description,
    $fixnum.Int64? durationSeconds,
    $fixnum.Int64? viewCount,
    $fixnum.Int64? commentCount,
    $fixnum.Int64? likeCount,
    $fixnum.Int64? publishedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (author != null) result.author = author;
    if (authorId != null) result.authorId = authorId;
    if (category != null) result.category = category;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (isLive != null) result.isLive = isLive;
    if (description != null) result.description = description;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (viewCount != null) result.viewCount = viewCount;
    if (commentCount != null) result.commentCount = commentCount;
    if (likeCount != null) result.likeCount = likeCount;
    if (publishedAt != null) result.publishedAt = publishedAt;
    return result;
  }

  Metadata._();

  factory Metadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Metadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Metadata',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.huya'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'authorId')
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aOS(6, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOS(7, _omitFieldNames ? '' : 'avatarUrl')
    ..aOB(8, _omitFieldNames ? '' : 'isLive')
    ..aOS(9, _omitFieldNames ? '' : 'description')
    ..a<$fixnum.Int64>(
        10, _omitFieldNames ? '' : 'durationSeconds', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'viewCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        12, _omitFieldNames ? '' : 'commentCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        13, _omitFieldNames ? '' : 'likeCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(14, _omitFieldNames ? '' : 'publishedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata copyWith(void Function(Metadata) updates) =>
      super.copyWith((message) => updates(message as Metadata)) as Metadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Metadata create() => Metadata._();
  @$core.override
  Metadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Metadata getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Metadata>(create);
  static Metadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set authorId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthorId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get thumbnailUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set thumbnailUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasThumbnailUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearThumbnailUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get avatarUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set avatarUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAvatarUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvatarUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isLive => $_getBF(7);
  @$pb.TagNumber(8)
  set isLive($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsLive() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsLive() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get durationSeconds => $_getI64(9);
  @$pb.TagNumber(10)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDurationSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearDurationSeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get viewCount => $_getI64(10);
  @$pb.TagNumber(11)
  set viewCount($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasViewCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearViewCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get commentCount => $_getI64(11);
  @$pb.TagNumber(12)
  set commentCount($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCommentCount() => $_has(11);
  @$pb.TagNumber(12)
  void clearCommentCount() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get likeCount => $_getI64(12);
  @$pb.TagNumber(13)
  set likeCount($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLikeCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearLikeCount() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get publishedAt => $_getI64(13);
  @$pb.TagNumber(14)
  set publishedAt($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPublishedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearPublishedAt() => $_clearField(14);
}

class Quality extends $pb.GeneratedMessage {
  factory Quality({
    $core.String? name,
    $core.String? cdn,
    StreamFormat? format,
    $fixnum.Int64? bitrate,
    $core.int? width,
    $core.int? height,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (cdn != null) result.cdn = cdn;
    if (format != null) result.format = format;
    if (bitrate != null) result.bitrate = bitrate;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  Quality._();

  factory Quality.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Quality.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Quality',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.huya'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'cdn')
    ..aE<StreamFormat>(3, _omitFieldNames ? '' : 'format',
        enumValues: StreamFormat.values)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'bitrate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(5, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OU3)
    ..aI(6, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quality clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quality copyWith(void Function(Quality) updates) =>
      super.copyWith((message) => updates(message as Quality)) as Quality;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Quality create() => Quality._();
  @$core.override
  Quality createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Quality getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quality>(create);
  static Quality? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cdn => $_getSZ(1);
  @$pb.TagNumber(2)
  set cdn($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCdn() => $_has(1);
  @$pb.TagNumber(2)
  void clearCdn() => $_clearField(2);

  @$pb.TagNumber(3)
  StreamFormat get format => $_getN(2);
  @$pb.TagNumber(3)
  set format(StreamFormat value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get bitrate => $_getI64(3);
  @$pb.TagNumber(4)
  set bitrate($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBitrate() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitrate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get width => $_getIZ(4);
  @$pb.TagNumber(5)
  set width($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWidth() => $_has(4);
  @$pb.TagNumber(5)
  void clearWidth() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get height => $_getIZ(5);
  @$pb.TagNumber(6)
  set height($core.int value) => $_setUnsignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeight() => $_clearField(6);
}

class ResolveResponse extends $pb.GeneratedMessage {
  factory ResolveResponse({
    ResourceKind? kind,
    Metadata? metadata,
    $core.Iterable<Quality>? qualities,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (metadata != null) result.metadata = metadata;
    if (qualities != null) result.qualities.addAll(qualities);
    if (source != null) result.source = source;
    return result;
  }

  ResolveResponse._();

  factory ResolveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.huya'),
      createEmptyInstance: create)
    ..aE<ResourceKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: ResourceKind.values)
    ..aOM<Metadata>(2, _omitFieldNames ? '' : 'metadata',
        subBuilder: Metadata.create)
    ..pPM<Quality>(3, _omitFieldNames ? '' : 'qualities',
        subBuilder: Quality.create)
    ..aOM<$0.DiscoveredSource>(4, _omitFieldNames ? '' : 'source',
        subBuilder: $0.DiscoveredSource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveResponse copyWith(void Function(ResolveResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveResponse))
          as ResolveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveResponse create() => ResolveResponse._();
  @$core.override
  ResolveResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveResponse>(create);
  static ResolveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ResourceKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(ResourceKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  Metadata get metadata => $_getN(1);
  @$pb.TagNumber(2)
  set metadata(Metadata value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  Metadata ensureMetadata() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<Quality> get qualities => $_getList(2);

  @$pb.TagNumber(4)
  $0.DiscoveredSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source($0.DiscoveredSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.DiscoveredSource ensureSource() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
