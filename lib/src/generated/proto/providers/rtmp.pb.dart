// This is a generated file - do not edit.
//
// Generated from proto/providers/rtmp.proto.

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

class CreatePublishKeyRequest extends $pb.GeneratedMessage {
  factory CreatePublishKeyRequest({
    $core.String? roomId,
    $core.String? mediaId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  CreatePublishKeyRequest._();

  factory CreatePublishKeyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePublishKeyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePublishKeyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePublishKeyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePublishKeyRequest copyWith(
          void Function(CreatePublishKeyRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePublishKeyRequest))
          as CreatePublishKeyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePublishKeyRequest create() => CreatePublishKeyRequest._();
  @$core.override
  CreatePublishKeyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePublishKeyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePublishKeyRequest>(create);
  static CreatePublishKeyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);
}

class CreatePublishKeyResponse extends $pb.GeneratedMessage {
  factory CreatePublishKeyResponse({
    $core.String? publishKey,
    $core.String? rtmpUrl,
    $core.String? streamKey,
    $fixnum.Int64? expiresAt,
  }) {
    final result = create();
    if (publishKey != null) result.publishKey = publishKey;
    if (rtmpUrl != null) result.rtmpUrl = rtmpUrl;
    if (streamKey != null) result.streamKey = streamKey;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  CreatePublishKeyResponse._();

  factory CreatePublishKeyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreatePublishKeyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePublishKeyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'publishKey')
    ..aOS(2, _omitFieldNames ? '' : 'rtmpUrl')
    ..aOS(3, _omitFieldNames ? '' : 'streamKey')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePublishKeyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePublishKeyResponse copyWith(
          void Function(CreatePublishKeyResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePublishKeyResponse))
          as CreatePublishKeyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePublishKeyResponse create() => CreatePublishKeyResponse._();
  @$core.override
  CreatePublishKeyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreatePublishKeyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePublishKeyResponse>(create);
  static CreatePublishKeyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rtmpUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set rtmpUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRtmpUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearRtmpUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get streamKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set streamKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStreamKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearStreamKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAt => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAt($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAt() => $_clearField(4);
}

class GetStreamInfoRequest extends $pb.GeneratedMessage {
  factory GetStreamInfoRequest({
    $core.String? roomId,
    $core.String? mediaId,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (mediaId != null) result.mediaId = mediaId;
    return result;
  }

  GetStreamInfoRequest._();

  factory GetStreamInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStreamInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStreamInfoRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreamInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreamInfoRequest copyWith(void Function(GetStreamInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetStreamInfoRequest))
          as GetStreamInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStreamInfoRequest create() => GetStreamInfoRequest._();
  @$core.override
  GetStreamInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStreamInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStreamInfoRequest>(create);
  static GetStreamInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaId() => $_clearField(2);
}

class StreamPublisherInfo extends $pb.GeneratedMessage {
  factory StreamPublisherInfo({
    $core.String? userId,
    $fixnum.Int64? startedAt,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  StreamPublisherInfo._();

  factory StreamPublisherInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamPublisherInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamPublisherInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.rtmp'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..aInt64(2, _omitFieldNames ? '' : 'startedAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamPublisherInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamPublisherInfo copyWith(void Function(StreamPublisherInfo) updates) =>
      super.copyWith((message) => updates(message as StreamPublisherInfo))
          as StreamPublisherInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamPublisherInfo create() => StreamPublisherInfo._();
  @$core.override
  StreamPublisherInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamPublisherInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamPublisherInfo>(create);
  static StreamPublisherInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get startedAt => $_getI64(1);
  @$pb.TagNumber(2)
  set startedAt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartedAt() => $_clearField(2);
}

class GetStreamInfoResponse extends $pb.GeneratedMessage {
  factory GetStreamInfoResponse({
    $core.bool? active,
    StreamPublisherInfo? publisher,
  }) {
    final result = create();
    if (active != null) result.active = active;
    if (publisher != null) result.publisher = publisher;
    return result;
  }

  GetStreamInfoResponse._();

  factory GetStreamInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetStreamInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStreamInfoResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.provider.rtmp'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'active')
    ..aOM<StreamPublisherInfo>(2, _omitFieldNames ? '' : 'publisher',
        subBuilder: StreamPublisherInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreamInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStreamInfoResponse copyWith(
          void Function(GetStreamInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetStreamInfoResponse))
          as GetStreamInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStreamInfoResponse create() => GetStreamInfoResponse._();
  @$core.override
  GetStreamInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetStreamInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetStreamInfoResponse>(create);
  static GetStreamInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get active => $_getBF(0);
  @$pb.TagNumber(1)
  set active($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActive() => $_has(0);
  @$pb.TagNumber(1)
  void clearActive() => $_clearField(1);

  @$pb.TagNumber(2)
  StreamPublisherInfo get publisher => $_getN(1);
  @$pb.TagNumber(2)
  set publisher(StreamPublisherInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPublisher() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublisher() => $_clearField(2);
  @$pb.TagNumber(2)
  StreamPublisherInfo ensurePublisher() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
