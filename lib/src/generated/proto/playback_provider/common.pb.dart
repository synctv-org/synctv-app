// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/common.proto.

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

class StreamChunk extends $pb.GeneratedMessage {
  factory StreamChunk({
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
    return result;
  }

  StreamChunk._();

  factory StreamChunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamChunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamChunk',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'synctv.playback_provider.common'),
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
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamChunk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamChunk copyWith(void Function(StreamChunk) updates) =>
      super.copyWith((message) => updates(message as StreamChunk))
          as StreamChunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamChunk create() => StreamChunk._();
  @$core.override
  StreamChunk createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamChunk getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamChunk>(create);
  static StreamChunk? _defaultInstance;

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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
