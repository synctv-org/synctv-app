// This is a generated file - do not edit.
//
// Generated from proto/providers/cctv.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'cctv.pbenum.dart';
import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'cctv.pbenum.dart';

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
          _omitMessageNames ? '' : 'synctv.provider.cctv'),
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

class Chapter extends $pb.GeneratedMessage {
  factory Chapter({
    $core.String? id,
    $core.String? title,
    $fixnum.Int64? startMs,
    $fixnum.Int64? endMs,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (startMs != null) result.startMs = startMs;
    if (endMs != null) result.endMs = endMs;
    return result;
  }

  Chapter._();

  factory Chapter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chapter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chapter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.cctv'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'startMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'endMs', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chapter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chapter copyWith(void Function(Chapter) updates) =>
      super.copyWith((message) => updates(message as Chapter)) as Chapter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chapter create() => Chapter._();
  @$core.override
  Chapter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chapter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chapter>(create);
  static Chapter? _defaultInstance;

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
  $fixnum.Int64 get startMs => $_getI64(2);
  @$pb.TagNumber(3)
  set startMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get endMs => $_getI64(3);
  @$pb.TagNumber(4)
  set endMs($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndMs() => $_clearField(4);
}

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? videoId,
    $core.String? title,
    $core.String? description,
    $core.String? uploader,
    $core.String? producer,
    $core.String? channel,
    $core.String? column,
    $core.Iterable<$core.String>? tags,
    $core.String? thumbnailUrl,
    $core.double? durationSeconds,
    $fixnum.Int64? publishedAt,
    $core.Iterable<Chapter>? chapters,
    $core.bool? protected,
  }) {
    final result = create();
    if (videoId != null) result.videoId = videoId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (uploader != null) result.uploader = uploader;
    if (producer != null) result.producer = producer;
    if (channel != null) result.channel = channel;
    if (column != null) result.column = column;
    if (tags != null) result.tags.addAll(tags);
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (publishedAt != null) result.publishedAt = publishedAt;
    if (chapters != null) result.chapters.addAll(chapters);
    if (protected != null) result.protected = protected;
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
          _omitMessageNames ? '' : 'synctv.provider.cctv'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'videoId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'uploader')
    ..aOS(5, _omitFieldNames ? '' : 'producer')
    ..aOS(6, _omitFieldNames ? '' : 'channel')
    ..aOS(7, _omitFieldNames ? '' : 'column')
    ..pPS(8, _omitFieldNames ? '' : 'tags')
    ..aOS(9, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aD(10, _omitFieldNames ? '' : 'durationSeconds')
    ..aInt64(11, _omitFieldNames ? '' : 'publishedAt')
    ..pPM<Chapter>(12, _omitFieldNames ? '' : 'chapters',
        subBuilder: Chapter.create)
    ..aOB(13, _omitFieldNames ? '' : 'protected')
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
  $core.String get videoId => $_getSZ(0);
  @$pb.TagNumber(1)
  set videoId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uploader => $_getSZ(3);
  @$pb.TagNumber(4)
  set uploader($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUploader() => $_has(3);
  @$pb.TagNumber(4)
  void clearUploader() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get producer => $_getSZ(4);
  @$pb.TagNumber(5)
  set producer($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProducer() => $_has(4);
  @$pb.TagNumber(5)
  void clearProducer() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get channel => $_getSZ(5);
  @$pb.TagNumber(6)
  set channel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasChannel() => $_has(5);
  @$pb.TagNumber(6)
  void clearChannel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get column => $_getSZ(6);
  @$pb.TagNumber(7)
  set column($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasColumn() => $_has(6);
  @$pb.TagNumber(7)
  void clearColumn() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get tags => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get thumbnailUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set thumbnailUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasThumbnailUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearThumbnailUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get durationSeconds => $_getN(9);
  @$pb.TagNumber(10)
  set durationSeconds($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDurationSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearDurationSeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get publishedAt => $_getI64(10);
  @$pb.TagNumber(11)
  set publishedAt($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPublishedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearPublishedAt() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<Chapter> get chapters => $_getList(11);

  @$pb.TagNumber(13)
  $core.bool get protected => $_getBF(12);
  @$pb.TagNumber(13)
  set protected($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasProtected() => $_has(12);
  @$pb.TagNumber(13)
  void clearProtected() => $_clearField(13);
}

class Stream extends $pb.GeneratedMessage {
  factory Stream({
    $core.String? name,
    StreamKind? kind,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (kind != null) result.kind = kind;
    return result;
  }

  Stream._();

  factory Stream.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Stream.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stream',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.cctv'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aE<StreamKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: StreamKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stream clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stream copyWith(void Function(Stream) updates) =>
      super.copyWith((message) => updates(message as Stream)) as Stream;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stream create() => Stream._();
  @$core.override
  Stream createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Stream getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stream>(create);
  static Stream? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  StreamKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(StreamKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);
}

class ResolveResponse extends $pb.GeneratedMessage {
  factory ResolveResponse({
    Metadata? metadata,
    $core.Iterable<Stream>? streams,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
    if (metadata != null) result.metadata = metadata;
    if (streams != null) result.streams.addAll(streams);
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
          _omitMessageNames ? '' : 'synctv.provider.cctv'),
      createEmptyInstance: create)
    ..aOM<Metadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: Metadata.create)
    ..pPM<Stream>(2, _omitFieldNames ? '' : 'streams',
        subBuilder: Stream.create)
    ..aOM<$0.DiscoveredSource>(3, _omitFieldNames ? '' : 'source',
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
  Metadata get metadata => $_getN(0);
  @$pb.TagNumber(1)
  set metadata(Metadata value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetadata() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetadata() => $_clearField(1);
  @$pb.TagNumber(1)
  Metadata ensureMetadata() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Stream> get streams => $_getList(1);

  @$pb.TagNumber(3)
  $0.DiscoveredSource get source => $_getN(2);
  @$pb.TagNumber(3)
  set source($0.DiscoveredSource value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.DiscoveredSource ensureSource() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
