// This is a generated file - do not edit.
//
// Generated from proto/providers/synology.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use synologyVideoEntryKindDescriptor instead')
const SynologyVideoEntryKind$json = {
  '1': 'SynologyVideoEntryKind',
  '2': [
    {'1': 'SYNOLOGY_VIDEO_ENTRY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SYNOLOGY_VIDEO_ENTRY_KIND_MOVIE', '2': 1},
    {'1': 'SYNOLOGY_VIDEO_ENTRY_KIND_TV_SHOW', '2': 2},
    {'1': 'SYNOLOGY_VIDEO_ENTRY_KIND_EPISODE', '2': 3},
    {'1': 'SYNOLOGY_VIDEO_ENTRY_KIND_HOME_VIDEO', '2': 4},
    {'1': 'SYNOLOGY_VIDEO_ENTRY_KIND_TV_RECORDING', '2': 5},
  ],
};

/// Descriptor for `SynologyVideoEntryKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List synologyVideoEntryKindDescriptor = $convert.base64Decode(
    'ChZTeW5vbG9neVZpZGVvRW50cnlLaW5kEikKJVNZTk9MT0dZX1ZJREVPX0VOVFJZX0tJTkRfVU'
    '5TUEVDSUZJRUQQABIjCh9TWU5PTE9HWV9WSURFT19FTlRSWV9LSU5EX01PVklFEAESJQohU1lO'
    'T0xPR1lfVklERU9fRU5UUllfS0lORF9UVl9TSE9XEAISJQohU1lOT0xPR1lfVklERU9fRU5UUl'
    'lfS0lORF9FUElTT0RFEAMSKAokU1lOT0xPR1lfVklERU9fRU5UUllfS0lORF9IT01FX1ZJREVP'
    'EAQSKgomU1lOT0xPR1lfVklERU9fRU5UUllfS0lORF9UVl9SRUNPUkRJTkcQBQ==');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'endpoint', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'endpoint'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'username'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'password'},
    {
      '1': 'otp_code',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'otpCode',
      '17': true
    },
    {
      '1': 'device_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'deviceName',
      '17': true
    },
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_otp_code'},
    {'1': '_device_name'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSIwoIZW5kcG9pbnQYASABKAlCB7pIBHICEAFSCGVuZHBvaW50EiMKCH'
    'VzZXJuYW1lGAIgASgJQge6SARyAhABUgh1c2VybmFtZRIjCghwYXNzd29yZBgDIAEoCUIHukgE'
    'cgIQAVIIcGFzc3dvcmQSHgoIb3RwX2NvZGUYBCABKAlIAFIHb3RwQ29kZYgBARIkCgtkZXZpY2'
    'VfbmFtZRgFIAEoCUgBUgpkZXZpY2VOYW1liAEBEiMKDWluc3RhbmNlX25hbWUYBiABKAlSDGlu'
    'c3RhbmNlTmFtZUILCglfb3RwX2NvZGVCDgoMX2RldmljZV9uYW1l');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
    {
      '1': 'video_station_available',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'videoStationAvailable'
    },
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEhsKCXNlcnZlcl9pZBgBIAEoCVIIc2VydmVySWQSNgoXdmlkZW9fc3'
    'RhdGlvbl9hdmFpbGFibGUYAiABKAhSFXZpZGVvU3RhdGlvbkF2YWlsYWJsZQ==');

@$core.Deprecated('Use listFilesRequestDescriptor instead')
const ListFilesRequest$json = {
  '1': 'ListFilesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListFilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0RmlsZXNSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySW'
    'QSEgoEcGF0aBgCIAEoCVIEcGF0aBIbCgRwYWdlGAMgASgEQge6SAQyAigBUgRwYWdlEicKCXBh'
    'Z2Vfc2l6ZRgEIAEoDUIKukgHKgUYyAEoAVIIcGFnZVNpemUSGwoGc2VhcmNoGAUgASgJSABSBn'
    'NlYXJjaIgBARIjCg1pbnN0YW5jZV9uYW1lGAYgASgJUgxpbnN0YW5jZU5hbWVCCQoHX3NlYXJj'
    'aA==');

@$core.Deprecated('Use fileItemDescriptor instead')
const FileItem$json = {
  '1': 'FileItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'is_dir', '3': 3, '4': 1, '5': 8, '10': 'isDir'},
    {'1': 'size', '3': 4, '4': 1, '5': 4, '10': 'size'},
    {'1': 'modified_at', '3': 5, '4': 1, '5': 4, '10': 'modifiedAt'},
    {'1': 'created_at', '3': 6, '4': 1, '5': 4, '10': 'createdAt'},
    {'1': 'file_type', '3': 7, '4': 1, '5': 9, '10': 'fileType'},
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `FileItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileItemDescriptor = $convert.base64Decode(
    'CghGaWxlSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEhIKBHBhdGgYAiABKAlSBHBhdGgSFQoGaX'
    'NfZGlyGAMgASgIUgVpc0RpchISCgRzaXplGAQgASgEUgRzaXplEh8KC21vZGlmaWVkX2F0GAUg'
    'ASgEUgptb2RpZmllZEF0Eh0KCmNyZWF0ZWRfYXQYBiABKARSCWNyZWF0ZWRBdBIbCglmaWxlX3'
    'R5cGUYByABKAlSCGZpbGVUeXBlEkAKBnNvdXJjZRgIIAEoCzIoLnN5bmN0di5wcm92aWRlci5j'
    'b21tb24uRGlzY292ZXJlZFNvdXJjZVIGc291cmNl');

@$core.Deprecated('Use listFilesResponseDescriptor instead')
const ListFilesResponse$json = {
  '1': 'ListFilesResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.synology.FileItem',
      '10': 'items'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '10': 'page'},
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ListFilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0RmlsZXNSZXNwb25zZRI4CgVpdGVtcxgBIAMoCzIiLnN5bmN0di5wcm92aWRlci5zeW'
    '5vbG9neS5GaWxlSXRlbVIFaXRlbXMSFAoFdG90YWwYAiABKARSBXRvdGFsEhIKBHBhZ2UYAyAB'
    'KARSBHBhZ2USGQoIaGFzX21vcmUYBCABKAhSB2hhc01vcmUSQAoGc291cmNlGAUgASgLMiguc3'
    'luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use listLibrariesRequestDescriptor instead')
const ListLibrariesRequest$json = {
  '1': 'ListLibrariesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ListLibrariesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLibrariesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0TGlicmFyaWVzUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcn'
    'ZlcklkEiMKDWluc3RhbmNlX25hbWUYAiABKAlSDGluc3RhbmNlTmFtZQ==');

@$core.Deprecated('Use videoLibraryDescriptor instead')
const VideoLibrary$json = {
  '1': 'VideoLibrary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'library_type', '3': 3, '4': 1, '5': 9, '10': 'libraryType'},
    {'1': 'is_public', '3': 4, '4': 1, '5': 8, '10': 'isPublic'},
    {'1': 'visible', '3': 5, '4': 1, '5': 8, '10': 'visible'},
  ],
};

/// Descriptor for `VideoLibrary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoLibraryDescriptor = $convert.base64Decode(
    'CgxWaWRlb0xpYnJhcnkSDgoCaWQYASABKANSAmlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIhCg'
    'xsaWJyYXJ5X3R5cGUYAyABKAlSC2xpYnJhcnlUeXBlEhsKCWlzX3B1YmxpYxgEIAEoCFIIaXNQ'
    'dWJsaWMSGAoHdmlzaWJsZRgFIAEoCFIHdmlzaWJsZQ==');

@$core.Deprecated('Use listLibrariesResponseDescriptor instead')
const ListLibrariesResponse$json = {
  '1': 'ListLibrariesResponse',
  '2': [
    {
      '1': 'libraries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.synology.VideoLibrary',
      '10': 'libraries'
    },
  ],
};

/// Descriptor for `ListLibrariesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLibrariesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0TGlicmFyaWVzUmVzcG9uc2USRAoJbGlicmFyaWVzGAEgAygLMiYuc3luY3R2LnByb3'
    'ZpZGVyLnN5bm9sb2d5LlZpZGVvTGlicmFyeVIJbGlicmFyaWVz');

@$core.Deprecated('Use listMoviesRequestDescriptor instead')
const ListMoviesRequest$json = {
  '1': 'ListMoviesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListMoviesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMoviesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0TW92aWVzUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCHNlcnZlck'
    'lkEiYKCmxpYnJhcnlfaWQYAiABKANCB7pIBCICKABSCWxpYnJhcnlJZBIbCgRwYWdlGAMgASgE'
    'Qge6SAQyAigBUgRwYWdlEicKCXBhZ2Vfc2l6ZRgEIAEoDUIKukgHKgUYyAEoAVIIcGFnZVNpem'
    'USGwoGc2VhcmNoGAUgASgJSABSBnNlYXJjaIgBARIjCg1pbnN0YW5jZV9uYW1lGAYgASgJUgxp'
    'bnN0YW5jZU5hbWVCCQoHX3NlYXJjaA==');

@$core.Deprecated('Use listTvShowsRequestDescriptor instead')
const ListTvShowsRequest$json = {
  '1': 'ListTvShowsRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListTvShowsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTvShowsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0VHZTaG93c1JlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZXJ2ZX'
    'JJZBImCgpsaWJyYXJ5X2lkGAIgASgDQge6SAQiAigAUglsaWJyYXJ5SWQSGwoEcGFnZRgDIAEo'
    'BEIHukgEMgIoAVIEcGFnZRInCglwYWdlX3NpemUYBCABKA1CCrpIByoFGMgBKAFSCHBhZ2VTaX'
    'plEhsKBnNlYXJjaBgFIAEoCUgAUgZzZWFyY2iIAQESIwoNaW5zdGFuY2VfbmFtZRgGIAEoCVIM'
    'aW5zdGFuY2VOYW1lQgkKB19zZWFyY2g=');

@$core.Deprecated('Use listEpisodesRequestDescriptor instead')
const ListEpisodesRequest$json = {
  '1': 'ListEpisodesRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
    {'1': 'tv_show_id', '3': 3, '4': 1, '5': 3, '8': {}, '10': 'tvShowId'},
    {'1': 'page', '3': 4, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 7, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListEpisodesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEpisodesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0RXBpc29kZXNSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2Vydm'
    'VySWQSJgoKbGlicmFyeV9pZBgCIAEoA0IHukgEIgIoAFIJbGlicmFyeUlkEiUKCnR2X3Nob3df'
    'aWQYAyABKANCB7pIBCICIABSCHR2U2hvd0lkEhsKBHBhZ2UYBCABKARCB7pIBDICKAFSBHBhZ2'
    'USJwoJcGFnZV9zaXplGAUgASgNQgq6SAcqBRjIASgBUghwYWdlU2l6ZRIbCgZzZWFyY2gYBiAB'
    'KAlIAFIGc2VhcmNoiAEBEiMKDWluc3RhbmNlX25hbWUYByABKAlSDGluc3RhbmNlTmFtZUIJCg'
    'dfc2VhcmNo');

@$core.Deprecated('Use listHomeVideosRequestDescriptor instead')
const ListHomeVideosRequest$json = {
  '1': 'ListHomeVideosRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListHomeVideosRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHomeVideosRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0SG9tZVZpZGVvc1JlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZX'
    'J2ZXJJZBImCgpsaWJyYXJ5X2lkGAIgASgDQge6SAQiAigAUglsaWJyYXJ5SWQSGwoEcGFnZRgD'
    'IAEoBEIHukgEMgIoAVIEcGFnZRInCglwYWdlX3NpemUYBCABKA1CCrpIByoFGMgBKAFSCHBhZ2'
    'VTaXplEhsKBnNlYXJjaBgFIAEoCUgAUgZzZWFyY2iIAQESIwoNaW5zdGFuY2VfbmFtZRgGIAEo'
    'CVIMaW5zdGFuY2VOYW1lQgkKB19zZWFyY2g=');

@$core.Deprecated('Use listTvRecordingsRequestDescriptor instead')
const ListTvRecordingsRequest$json = {
  '1': 'ListTvRecordingsRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 3, '8': {}, '10': 'libraryId'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '8': {}, '10': 'page'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 13, '8': {}, '10': 'pageSize'},
    {'1': 'search', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'search', '17': true},
    {'1': 'instance_name', '3': 6, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_search'},
  ],
};

/// Descriptor for `ListTvRecordingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTvRecordingsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0VHZSZWNvcmRpbmdzUmVxdWVzdBIkCglzZXJ2ZXJfaWQYASABKAlCB7pIBHICEAFSCH'
    'NlcnZlcklkEiYKCmxpYnJhcnlfaWQYAiABKANCB7pIBCICKABSCWxpYnJhcnlJZBIbCgRwYWdl'
    'GAMgASgEQge6SAQyAigBUgRwYWdlEicKCXBhZ2Vfc2l6ZRgEIAEoDUIKukgHKgUYyAEoAVIIcG'
    'FnZVNpemUSGwoGc2VhcmNoGAUgASgJSABSBnNlYXJjaIgBARIjCg1pbnN0YW5jZV9uYW1lGAYg'
    'ASgJUgxpbnN0YW5jZU5hbWVCCQoHX3NlYXJjaA==');

@$core.Deprecated('Use videoFileDescriptor instead')
const VideoFile$json = {
  '1': 'VideoFile',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    {'1': 'size', '3': 3, '4': 1, '5': 4, '10': 'size'},
    {'1': 'duration_seconds', '3': 4, '4': 1, '5': 4, '10': 'durationSeconds'},
    {'1': 'progress_seconds', '3': 5, '4': 1, '5': 4, '10': 'progressSeconds'},
    {'1': 'width', '3': 6, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 7, '4': 1, '5': 13, '10': 'height'},
    {'1': 'video_codec', '3': 8, '4': 1, '5': 9, '10': 'videoCodec'},
    {'1': 'audio_codec', '3': 9, '4': 1, '5': 9, '10': 'audioCodec'},
    {'1': 'container', '3': 10, '4': 1, '5': 9, '10': 'container'},
    {'1': 'video_bitrate', '3': 11, '4': 1, '5': 4, '10': 'videoBitrate'},
    {'1': 'audio_bitrate', '3': 12, '4': 1, '5': 4, '10': 'audioBitrate'},
    {
      '1': 'frame_rate_numerator',
      '3': 13,
      '4': 1,
      '5': 4,
      '10': 'frameRateNumerator'
    },
    {
      '1': 'frame_rate_denominator',
      '3': 14,
      '4': 1,
      '5': 4,
      '10': 'frameRateDenominator'
    },
    {'1': 'audio_channels', '3': 15, '4': 1, '5': 13, '10': 'audioChannels'},
    {
      '1': 'audio_frequency_hz',
      '3': 16,
      '4': 1,
      '5': 13,
      '10': 'audioFrequencyHz'
    },
    {
      '1': 'conversion_produced',
      '3': 17,
      '4': 1,
      '5': 8,
      '10': 'conversionProduced'
    },
  ],
};

/// Descriptor for `VideoFile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoFileDescriptor = $convert.base64Decode(
    'CglWaWRlb0ZpbGUSDgoCaWQYASABKANSAmlkEhIKBHBhdGgYAiABKAlSBHBhdGgSEgoEc2l6ZR'
    'gDIAEoBFIEc2l6ZRIpChBkdXJhdGlvbl9zZWNvbmRzGAQgASgEUg9kdXJhdGlvblNlY29uZHMS'
    'KQoQcHJvZ3Jlc3Nfc2Vjb25kcxgFIAEoBFIPcHJvZ3Jlc3NTZWNvbmRzEhQKBXdpZHRoGAYgAS'
    'gNUgV3aWR0aBIWCgZoZWlnaHQYByABKA1SBmhlaWdodBIfCgt2aWRlb19jb2RlYxgIIAEoCVIK'
    'dmlkZW9Db2RlYxIfCgthdWRpb19jb2RlYxgJIAEoCVIKYXVkaW9Db2RlYxIcCgljb250YWluZX'
    'IYCiABKAlSCWNvbnRhaW5lchIjCg12aWRlb19iaXRyYXRlGAsgASgEUgx2aWRlb0JpdHJhdGUS'
    'IwoNYXVkaW9fYml0cmF0ZRgMIAEoBFIMYXVkaW9CaXRyYXRlEjAKFGZyYW1lX3JhdGVfbnVtZX'
    'JhdG9yGA0gASgEUhJmcmFtZVJhdGVOdW1lcmF0b3ISNAoWZnJhbWVfcmF0ZV9kZW5vbWluYXRv'
    'chgOIAEoBFIUZnJhbWVSYXRlRGVub21pbmF0b3ISJQoOYXVkaW9fY2hhbm5lbHMYDyABKA1SDW'
    'F1ZGlvQ2hhbm5lbHMSLAoSYXVkaW9fZnJlcXVlbmN5X2h6GBAgASgNUhBhdWRpb0ZyZXF1ZW5j'
    'eUh6Ei8KE2NvbnZlcnNpb25fcHJvZHVjZWQYESABKAhSEmNvbnZlcnNpb25Qcm9kdWNlZA==');

@$core.Deprecated('Use videoItemDescriptor instead')
const VideoItem$json = {
  '1': 'VideoItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'library_id', '3': 2, '4': 1, '5': 3, '10': 'libraryId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.provider.synology.SynologyVideoEntryKind',
      '10': 'kind'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'sort_title', '3': 5, '4': 1, '5': 9, '10': 'sortTitle'},
    {'1': 'tagline', '3': 6, '4': 1, '5': 9, '10': 'tagline'},
    {'1': 'summary', '3': 7, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'certificate', '3': 8, '4': 1, '5': 9, '10': 'certificate'},
    {'1': 'rating', '3': 9, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'actors', '3': 10, '4': 3, '5': 9, '10': 'actors'},
    {'1': 'directors', '3': 11, '4': 3, '5': 9, '10': 'directors'},
    {'1': 'writers', '3': 12, '4': 3, '5': 9, '10': 'writers'},
    {'1': 'genres', '3': 13, '4': 3, '5': 9, '10': 'genres'},
    {
      '1': 'original_available',
      '3': 14,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'originalAvailable',
      '17': true
    },
    {'1': 'create_time', '3': 15, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'last_watched', '3': 16, '4': 1, '5': 3, '10': 'lastWatched'},
    {'1': 'watched_ratio', '3': 17, '4': 1, '5': 1, '10': 'watchedRatio'},
    {
      '1': 'parental_controlled',
      '3': 18,
      '4': 1,
      '5': 8,
      '10': 'parentalControlled'
    },
    {
      '1': 'season',
      '3': 19,
      '4': 1,
      '5': 13,
      '9': 1,
      '10': 'season',
      '17': true
    },
    {
      '1': 'episode',
      '3': 20,
      '4': 1,
      '5': 13,
      '9': 2,
      '10': 'episode',
      '17': true
    },
    {
      '1': 'tv_show_id',
      '3': 21,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'tvShowId',
      '17': true
    },
    {
      '1': 'poster_mtime',
      '3': 22,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'posterMtime',
      '17': true
    },
    {
      '1': 'backdrop_mtime',
      '3': 23,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'backdropMtime',
      '17': true
    },
    {
      '1': 'files',
      '3': 24,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.synology.VideoFile',
      '10': 'files'
    },
    {
      '1': 'source',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
  '8': [
    {'1': '_original_available'},
    {'1': '_season'},
    {'1': '_episode'},
    {'1': '_tv_show_id'},
    {'1': '_poster_mtime'},
    {'1': '_backdrop_mtime'},
  ],
};

/// Descriptor for `VideoItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoItemDescriptor = $convert.base64Decode(
    'CglWaWRlb0l0ZW0SDgoCaWQYASABKANSAmlkEh0KCmxpYnJhcnlfaWQYAiABKANSCWxpYnJhcn'
    'lJZBJECgRraW5kGAMgASgOMjAuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LlN5bm9sb2d5Vmlk'
    'ZW9FbnRyeUtpbmRSBGtpbmQSFAoFdGl0bGUYBCABKAlSBXRpdGxlEh0KCnNvcnRfdGl0bGUYBS'
    'ABKAlSCXNvcnRUaXRsZRIYCgd0YWdsaW5lGAYgASgJUgd0YWdsaW5lEhgKB3N1bW1hcnkYByAB'
    'KAlSB3N1bW1hcnkSIAoLY2VydGlmaWNhdGUYCCABKAlSC2NlcnRpZmljYXRlEhYKBnJhdGluZx'
    'gJIAEoBVIGcmF0aW5nEhYKBmFjdG9ycxgKIAMoCVIGYWN0b3JzEhwKCWRpcmVjdG9ycxgLIAMo'
    'CVIJZGlyZWN0b3JzEhgKB3dyaXRlcnMYDCADKAlSB3dyaXRlcnMSFgoGZ2VucmVzGA0gAygJUg'
    'ZnZW5yZXMSMgoSb3JpZ2luYWxfYXZhaWxhYmxlGA4gASgJSABSEW9yaWdpbmFsQXZhaWxhYmxl'
    'iAEBEh8KC2NyZWF0ZV90aW1lGA8gASgDUgpjcmVhdGVUaW1lEiEKDGxhc3Rfd2F0Y2hlZBgQIA'
    'EoA1ILbGFzdFdhdGNoZWQSIwoNd2F0Y2hlZF9yYXRpbxgRIAEoAVIMd2F0Y2hlZFJhdGlvEi8K'
    'E3BhcmVudGFsX2NvbnRyb2xsZWQYEiABKAhSEnBhcmVudGFsQ29udHJvbGxlZBIbCgZzZWFzb2'
    '4YEyABKA1IAVIGc2Vhc29uiAEBEh0KB2VwaXNvZGUYFCABKA1IAlIHZXBpc29kZYgBARIhCgp0'
    'dl9zaG93X2lkGBUgASgDSANSCHR2U2hvd0lkiAEBEiYKDHBvc3Rlcl9tdGltZRgWIAEoCUgEUg'
    'twb3N0ZXJNdGltZYgBARIqCg5iYWNrZHJvcF9tdGltZRgXIAEoCUgFUg1iYWNrZHJvcE10aW1l'
    'iAEBEjkKBWZpbGVzGBggAygLMiMuc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LlZpZGVvRmlsZV'
    'IFZmlsZXMSQAoGc291cmNlGBkgASgLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3Zl'
    'cmVkU291cmNlUgZzb3VyY2VCFQoTX29yaWdpbmFsX2F2YWlsYWJsZUIJCgdfc2Vhc29uQgoKCF'
    '9lcGlzb2RlQg0KC190dl9zaG93X2lkQg8KDV9wb3N0ZXJfbXRpbWVCEQoPX2JhY2tkcm9wX210'
    'aW1l');

@$core.Deprecated('Use listVideoItemsResponseDescriptor instead')
const ListVideoItemsResponse$json = {
  '1': 'ListVideoItemsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.synology.VideoItem',
      '10': 'items'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 4, '10': 'total'},
    {'1': 'page', '3': 3, '4': 1, '5': 4, '10': 'page'},
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.common.DiscoveredSource',
      '10': 'source'
    },
  ],
};

/// Descriptor for `ListVideoItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVideoItemsResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0VmlkZW9JdGVtc1Jlc3BvbnNlEjkKBWl0ZW1zGAEgAygLMiMuc3luY3R2LnByb3ZpZG'
    'VyLnN5bm9sb2d5LlZpZGVvSXRlbVIFaXRlbXMSFAoFdG90YWwYAiABKARSBXRvdGFsEhIKBHBh'
    'Z2UYAyABKARSBHBhZ2USGQoIaGFzX21vcmUYBCABKAhSB2hhc01vcmUSQAoGc291cmNlGAUgAS'
    'gLMiguc3luY3R2LnByb3ZpZGVyLmNvbW1vbi5EaXNjb3ZlcmVkU291cmNlUgZzb3VyY2U=');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySWQ=');

@$core.Deprecated('Use logoutResponseDescriptor instead')
const LogoutResponse$json = {
  '1': 'LogoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LogoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutResponseDescriptor = $convert
    .base64Decode('Cg5Mb2dvdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use getBindsRequestDescriptor instead')
const GetBindsRequest$json = {
  '1': 'GetBindsRequest',
  '2': [
    {'1': 'instance_name', '3': 1, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `GetBindsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCaW5kc1JlcXVlc3QSIwoNaW5zdGFuY2VfbmFtZRgBIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'endpoint', '3': 3, '4': 1, '5': 9, '10': 'endpoint'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'video_station_available',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'videoStationAvailable'
    },
    {'1': 'created_at', '3': 6, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IaCghlbmRwb2ludBgDIAEoCVIIZW5kcG9pbnQSGgoIdXNlcm5hbWUYBCABKAlSCHVzZXJuYW1l'
    'EjYKF3ZpZGVvX3N0YXRpb25fYXZhaWxhYmxlGAUgASgIUhV2aWRlb1N0YXRpb25BdmFpbGFibG'
    'USHQoKY3JlYXRlZF9hdBgGIAEoA1IJY3JlYXRlZEF0EjQKFnByb3ZpZGVyX2luc3RhbmNlX25h'
    'bWUYByABKAlSFHByb3ZpZGVySW5zdGFuY2VOYW1l');

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.synology.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjgKBWJpbmRzGAEgAygLMiIuc3luY3R2LnByb3ZpZGVyLnN5bm'
    '9sb2d5LkJpbmRJbmZvUgViaW5kcw==');

@$core.Deprecated('Use fileImageRequestDescriptor instead')
const FileImageRequest$json = {
  '1': 'FileImageRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'path'},
    {'1': 'size', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'size'},
  ],
};

/// Descriptor for `FileImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileImageRequestDescriptor = $convert.base64Decode(
    'ChBGaWxlSW1hZ2VSZXF1ZXN0EhsKBHBhdGgYASABKAlCB7pIBHICEAFSBHBhdGgSGwoEc2l6ZR'
    'gCIAEoCUIHukgEcgIQAVIEc2l6ZQ==');

@$core.Deprecated('Use posterImageRequestDescriptor instead')
const PosterImageRequest$json = {
  '1': 'PosterImageRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 3, '8': {}, '10': 'itemId'},
    {'1': 'media_type', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'mediaType'},
    {
      '1': 'poster_mtime',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'posterMtime',
      '17': true
    },
  ],
  '8': [
    {'1': '_poster_mtime'},
  ],
};

/// Descriptor for `PosterImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List posterImageRequestDescriptor = $convert.base64Decode(
    'ChJQb3N0ZXJJbWFnZVJlcXVlc3QSIAoHaXRlbV9pZBgBIAEoA0IHukgEIgIgAFIGaXRlbUlkEi'
    'YKCm1lZGlhX3R5cGUYAiABKAlCB7pIBHICEAFSCW1lZGlhVHlwZRImCgxwb3N0ZXJfbXRpbWUY'
    'AyABKAlIAFILcG9zdGVyTXRpbWWIAQFCDwoNX3Bvc3Rlcl9tdGltZQ==');

@$core.Deprecated('Use getImageRequestDescriptor instead')
const GetImageRequest$json = {
  '1': 'GetImageRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
    {
      '1': 'file',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.synology.FileImageRequest',
      '9': 0,
      '10': 'file'
    },
    {
      '1': 'poster',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.synology.PosterImageRequest',
      '9': 0,
      '10': 'poster'
    },
  ],
  '8': [
    {'1': 'image', '2': {}},
  ],
};

/// Descriptor for `GetImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getImageRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRJbWFnZVJlcXVlc3QSJAoJc2VydmVyX2lkGAEgASgJQge6SARyAhABUghzZXJ2ZXJJZB'
    'JACgRmaWxlGAIgASgLMiouc3luY3R2LnByb3ZpZGVyLnN5bm9sb2d5LkZpbGVJbWFnZVJlcXVl'
    'c3RIAFIEZmlsZRJGCgZwb3N0ZXIYAyABKAsyLC5zeW5jdHYucHJvdmlkZXIuc3lub2xvZ3kuUG'
    '9zdGVySW1hZ2VSZXF1ZXN0SABSBnBvc3RlckIOCgVpbWFnZRIFukgCCAE=');
