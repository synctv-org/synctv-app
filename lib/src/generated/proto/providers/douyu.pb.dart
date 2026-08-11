// This is a generated file - do not edit.
//
// Generated from proto/providers/douyu.proto.

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
import 'douyu.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'douyu.pbenum.dart';

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
          _omitMessageNames ? '' : 'synctv.provider.douyu'),
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
    $core.String? roomId,
    $core.String? title,
    $core.String? author,
    $core.String? category,
    $core.String? thumbnailUrl,
    $core.String? avatarUrl,
    $core.bool? isLive,
    $core.bool? isReplay,
    $core.bool? isVip,
    $fixnum.Int64? viewerCount,
    $core.String? startedAt,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (title != null) result.title = title;
    if (author != null) result.author = author;
    if (category != null) result.category = category;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (isLive != null) result.isLive = isLive;
    if (isReplay != null) result.isReplay = isReplay;
    if (isVip != null) result.isVip = isVip;
    if (viewerCount != null) result.viewerCount = viewerCount;
    if (startedAt != null) result.startedAt = startedAt;
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
          _omitMessageNames ? '' : 'synctv.provider.douyu'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aOS(5, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOS(6, _omitFieldNames ? '' : 'avatarUrl')
    ..aOB(7, _omitFieldNames ? '' : 'isLive')
    ..aOB(8, _omitFieldNames ? '' : 'isReplay')
    ..aOB(9, _omitFieldNames ? '' : 'isVip')
    ..a<$fixnum.Int64>(
        10, _omitFieldNames ? '' : 'viewerCount', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(11, _omitFieldNames ? '' : 'startedAt')
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
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

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
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get thumbnailUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set thumbnailUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasThumbnailUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearThumbnailUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get avatarUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set avatarUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAvatarUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvatarUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isLive => $_getBF(6);
  @$pb.TagNumber(7)
  set isLive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsLive() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsLive() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isReplay => $_getBF(7);
  @$pb.TagNumber(8)
  set isReplay($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsReplay() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsReplay() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isVip => $_getBF(8);
  @$pb.TagNumber(9)
  set isVip($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsVip() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsVip() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get viewerCount => $_getI64(9);
  @$pb.TagNumber(10)
  set viewerCount($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasViewerCount() => $_has(9);
  @$pb.TagNumber(10)
  void clearViewerCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get startedAt => $_getSZ(10);
  @$pb.TagNumber(11)
  set startedAt($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStartedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearStartedAt() => $_clearField(11);
}

class Quality extends $pb.GeneratedMessage {
  factory Quality({
    $core.String? name,
    $core.String? cdn,
    $core.String? cdnName,
    $fixnum.Int64? rate,
    $fixnum.Int64? bitrate,
    Codec? codec,
    StreamFormat? format,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (cdn != null) result.cdn = cdn;
    if (cdnName != null) result.cdnName = cdnName;
    if (rate != null) result.rate = rate;
    if (bitrate != null) result.bitrate = bitrate;
    if (codec != null) result.codec = codec;
    if (format != null) result.format = format;
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
          _omitMessageNames ? '' : 'synctv.provider.douyu'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'cdn')
    ..aOS(3, _omitFieldNames ? '' : 'cdnName')
    ..aInt64(4, _omitFieldNames ? '' : 'rate')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'bitrate', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aE<Codec>(6, _omitFieldNames ? '' : 'codec', enumValues: Codec.values)
    ..aE<StreamFormat>(7, _omitFieldNames ? '' : 'format',
        enumValues: StreamFormat.values)
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
  $core.String get cdnName => $_getSZ(2);
  @$pb.TagNumber(3)
  set cdnName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCdnName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCdnName() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get rate => $_getI64(3);
  @$pb.TagNumber(4)
  set rate($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get bitrate => $_getI64(4);
  @$pb.TagNumber(5)
  set bitrate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBitrate() => $_has(4);
  @$pb.TagNumber(5)
  void clearBitrate() => $_clearField(5);

  @$pb.TagNumber(6)
  Codec get codec => $_getN(5);
  @$pb.TagNumber(6)
  set codec(Codec value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCodec() => $_has(5);
  @$pb.TagNumber(6)
  void clearCodec() => $_clearField(6);

  @$pb.TagNumber(7)
  StreamFormat get format => $_getN(6);
  @$pb.TagNumber(7)
  set format(StreamFormat value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFormat() => $_has(6);
  @$pb.TagNumber(7)
  void clearFormat() => $_clearField(7);
}

class ResolveResponse extends $pb.GeneratedMessage {
  factory ResolveResponse({
    Metadata? metadata,
    $core.Iterable<Quality>? qualities,
    $0.DiscoveredSource? source,
  }) {
    final result = create();
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
          _omitMessageNames ? '' : 'synctv.provider.douyu'),
      createEmptyInstance: create)
    ..aOM<Metadata>(1, _omitFieldNames ? '' : 'metadata',
        subBuilder: Metadata.create)
    ..pPM<Quality>(2, _omitFieldNames ? '' : 'qualities',
        subBuilder: Quality.create)
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
  $pb.PbList<Quality> get qualities => $_getList(1);

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
