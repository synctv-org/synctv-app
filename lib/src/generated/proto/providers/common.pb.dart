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

import '../source_config.pbenum.dart' as $0;
import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

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
