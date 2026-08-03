// This is a generated file - do not edit.
//
// Generated from proto/providers/youtube.proto.

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

@$core.Deprecated('Use bindRequestDescriptor instead')
const BindRequest$json = {
  '1': 'BindRequest',
  '2': [
    {'1': 'label', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'label'},
    {
      '1': 'visitor_data',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'visitorData',
      '17': true
    },
    {
      '1': 'po_token',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'poToken',
      '17': true
    },
    {'1': 'cookie', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'cookie', '17': true},
    {'1': 'instance_name', '3': 5, '4': 1, '5': 9, '10': 'instanceName'},
  ],
  '8': [
    {'1': '_visitor_data'},
    {'1': '_po_token'},
    {'1': '_cookie'},
  ],
};

/// Descriptor for `BindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindRequestDescriptor = $convert.base64Decode(
    'CgtCaW5kUmVxdWVzdBIdCgVsYWJlbBgBIAEoCUIHukgEcgIQAVIFbGFiZWwSJgoMdmlzaXRvcl'
    '9kYXRhGAIgASgJSABSC3Zpc2l0b3JEYXRhiAEBEh4KCHBvX3Rva2VuGAMgASgJSAFSB3BvVG9r'
    'ZW6IAQESGwoGY29va2llGAQgASgJSAJSBmNvb2tpZYgBARIjCg1pbnN0YW5jZV9uYW1lGAUgAS'
    'gJUgxpbnN0YW5jZU5hbWVCDwoNX3Zpc2l0b3JfZGF0YUILCglfcG9fdG9rZW5CCQoHX2Nvb2tp'
    'ZQ==');

@$core.Deprecated('Use bindResponseDescriptor instead')
const BindResponse$json = {
  '1': 'BindResponse',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '10': 'serverId'},
  ],
};

/// Descriptor for `BindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindResponseDescriptor = $convert.base64Decode(
    'CgxCaW5kUmVzcG9uc2USGwoJc2VydmVyX2lkGAEgASgJUghzZXJ2ZXJJZA==');

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

@$core.Deprecated('Use getBindsResponseDescriptor instead')
const GetBindsResponse$json = {
  '1': 'GetBindsResponse',
  '2': [
    {
      '1': 'binds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.youtube.BindInfo',
      '10': 'binds'
    },
  ],
};

/// Descriptor for `GetBindsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBindsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCaW5kc1Jlc3BvbnNlEjcKBWJpbmRzGAEgAygLMiEuc3luY3R2LnByb3ZpZGVyLnlvdX'
    'R1YmUuQmluZEluZm9SBWJpbmRz');

@$core.Deprecated('Use bindInfoDescriptor instead')
const BindInfo$json = {
  '1': 'BindInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'server_id', '3': 2, '4': 1, '5': 9, '10': 'serverId'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'has_visitor_data', '3': 4, '4': 1, '5': 8, '10': 'hasVisitorData'},
    {'1': 'has_po_token', '3': 5, '4': 1, '5': 8, '10': 'hasPoToken'},
    {'1': 'has_cookie', '3': 6, '4': 1, '5': 8, '10': 'hasCookie'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 3, '10': 'createdAt'},
    {
      '1': 'provider_instance_name',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'providerInstanceName'
    },
  ],
};

/// Descriptor for `BindInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindInfoDescriptor = $convert.base64Decode(
    'CghCaW5kSW5mbxIOCgJpZBgBIAEoCVICaWQSGwoJc2VydmVyX2lkGAIgASgJUghzZXJ2ZXJJZB'
    'IUCgVsYWJlbBgDIAEoCVIFbGFiZWwSKAoQaGFzX3Zpc2l0b3JfZGF0YRgEIAEoCFIOaGFzVmlz'
    'aXRvckRhdGESIAoMaGFzX3BvX3Rva2VuGAUgASgIUgpoYXNQb1Rva2VuEh0KCmhhc19jb29raW'
    'UYBiABKAhSCWhhc0Nvb2tpZRIdCgpjcmVhdGVkX2F0GAcgASgDUgljcmVhdGVkQXQSNAoWcHJv'
    'dmlkZXJfaW5zdGFuY2VfbmFtZRgIIAEoCVIUcHJvdmlkZXJJbnN0YW5jZU5hbWU=');

@$core.Deprecated('Use unbindRequestDescriptor instead')
const UnbindRequest$json = {
  '1': 'UnbindRequest',
  '2': [
    {'1': 'server_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'serverId'},
  ],
};

/// Descriptor for `UnbindRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbindRequestDescriptor = $convert.base64Decode(
    'Cg1VbmJpbmRSZXF1ZXN0EiQKCXNlcnZlcl9pZBgBIAEoCUIHukgEcgIQAVIIc2VydmVySWQ=');

@$core.Deprecated('Use unbindResponseDescriptor instead')
const UnbindResponse$json = {
  '1': 'UnbindResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 8, '10': 'removed'},
  ],
};

/// Descriptor for `UnbindResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unbindResponseDescriptor = $convert
    .base64Decode('Cg5VbmJpbmRSZXNwb25zZRIYCgdyZW1vdmVkGAEgASgIUgdyZW1vdmVk');

@$core.Deprecated('Use resolveRequestDescriptor instead')
const ResolveRequest$json = {
  '1': 'ResolveRequest',
  '2': [
    {'1': 'resource', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'resource'},
    {'1': 'instance_name', '3': 2, '4': 1, '5': 9, '10': 'instanceName'},
  ],
};

/// Descriptor for `ResolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveRequestDescriptor = $convert.base64Decode(
    'Cg5SZXNvbHZlUmVxdWVzdBIjCghyZXNvdXJjZRgBIAEoCUIHukgEcgIQAVIIcmVzb3VyY2USIw'
    'oNaW5zdGFuY2VfbmFtZRgCIAEoCVIMaW5zdGFuY2VOYW1l');

@$core.Deprecated('Use metadataDescriptor instead')
const Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'video_id', '3': 1, '4': 1, '5': 9, '10': 'videoId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'channel_id', '3': 3, '4': 1, '5': 9, '10': 'channelId'},
    {'1': 'channel_name', '3': 4, '4': 1, '5': 9, '10': 'channelName'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'duration_seconds',
      '3': 6,
      '4': 1,
      '5': 4,
      '9': 0,
      '10': 'durationSeconds',
      '17': true
    },
    {
      '1': 'view_count',
      '3': 7,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'viewCount',
      '17': true
    },
    {
      '1': 'thumbnail_url',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'thumbnailUrl',
      '17': true
    },
    {'1': 'keywords', '3': 9, '4': 3, '5': 9, '10': 'keywords'},
    {'1': 'is_live', '3': 10, '4': 1, '5': 8, '10': 'isLive'},
    {'1': 'is_private', '3': 11, '4': 1, '5': 8, '10': 'isPrivate'},
    {
      '1': 'publish_date',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'publishDate',
      '17': true
    },
    {
      '1': 'upload_date',
      '3': 13,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'uploadDate',
      '17': true
    },
    {
      '1': 'category',
      '3': 14,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'category',
      '17': true
    },
    {
      '1': 'live_start',
      '3': 15,
      '4': 1,
      '5': 9,
      '9': 6,
      '10': 'liveStart',
      '17': true
    },
    {
      '1': 'live_end',
      '3': 16,
      '4': 1,
      '5': 9,
      '9': 7,
      '10': 'liveEnd',
      '17': true
    },
  ],
  '8': [
    {'1': '_duration_seconds'},
    {'1': '_view_count'},
    {'1': '_thumbnail_url'},
    {'1': '_publish_date'},
    {'1': '_upload_date'},
    {'1': '_category'},
    {'1': '_live_start'},
    {'1': '_live_end'},
  ],
};

/// Descriptor for `Metadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metadataDescriptor = $convert.base64Decode(
    'CghNZXRhZGF0YRIZCgh2aWRlb19pZBgBIAEoCVIHdmlkZW9JZBIUCgV0aXRsZRgCIAEoCVIFdG'
    'l0bGUSHQoKY2hhbm5lbF9pZBgDIAEoCVIJY2hhbm5lbElkEiEKDGNoYW5uZWxfbmFtZRgEIAEo'
    'CVILY2hhbm5lbE5hbWUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEi4KEGR1cm'
    'F0aW9uX3NlY29uZHMYBiABKARIAFIPZHVyYXRpb25TZWNvbmRziAEBEiIKCnZpZXdfY291bnQY'
    'ByABKARIAVIJdmlld0NvdW50iAEBEigKDXRodW1ibmFpbF91cmwYCCABKAlIAlIMdGh1bWJuYW'
    'lsVXJsiAEBEhoKCGtleXdvcmRzGAkgAygJUghrZXl3b3JkcxIXCgdpc19saXZlGAogASgIUgZp'
    'c0xpdmUSHQoKaXNfcHJpdmF0ZRgLIAEoCFIJaXNQcml2YXRlEiYKDHB1Ymxpc2hfZGF0ZRgMIA'
    'EoCUgDUgtwdWJsaXNoRGF0ZYgBARIkCgt1cGxvYWRfZGF0ZRgNIAEoCUgEUgp1cGxvYWREYXRl'
    'iAEBEh8KCGNhdGVnb3J5GA4gASgJSAVSCGNhdGVnb3J5iAEBEiIKCmxpdmVfc3RhcnQYDyABKA'
    'lIBlIJbGl2ZVN0YXJ0iAEBEh4KCGxpdmVfZW5kGBAgASgJSAdSB2xpdmVFbmSIAQFCEwoRX2R1'
    'cmF0aW9uX3NlY29uZHNCDQoLX3ZpZXdfY291bnRCEAoOX3RodW1ibmFpbF91cmxCDwoNX3B1Ym'
    'xpc2hfZGF0ZUIOCgxfdXBsb2FkX2RhdGVCCwoJX2NhdGVnb3J5Qg0KC19saXZlX3N0YXJ0QgsK'
    'CV9saXZlX2VuZA==');

@$core.Deprecated('Use formatDescriptor instead')
const Format$json = {
  '1': 'Format',
  '2': [
    {'1': 'itag', '3': 1, '4': 1, '5': 13, '10': 'itag'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'container', '3': 3, '4': 1, '5': 9, '10': 'container'},
    {'1': 'bitrate', '3': 4, '4': 1, '5': 4, '10': 'bitrate'},
    {'1': 'width', '3': 5, '4': 1, '5': 13, '9': 0, '10': 'width', '17': true},
    {
      '1': 'height',
      '3': 6,
      '4': 1,
      '5': 13,
      '9': 1,
      '10': 'height',
      '17': true
    },
    {'1': 'fps', '3': 7, '4': 1, '5': 13, '9': 2, '10': 'fps', '17': true},
    {'1': 'codecs', '3': 8, '4': 3, '5': 9, '10': 'codecs'},
    {'1': 'adaptive', '3': 9, '4': 1, '5': 8, '10': 'adaptive'},
    {'1': 'audio_only', '3': 10, '4': 1, '5': 8, '10': 'audioOnly'},
  ],
  '8': [
    {'1': '_width'},
    {'1': '_height'},
    {'1': '_fps'},
  ],
};

/// Descriptor for `Format`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formatDescriptor = $convert.base64Decode(
    'CgZGb3JtYXQSEgoEaXRhZxgBIAEoDVIEaXRhZxISCgRuYW1lGAIgASgJUgRuYW1lEhwKCWNvbn'
    'RhaW5lchgDIAEoCVIJY29udGFpbmVyEhgKB2JpdHJhdGUYBCABKARSB2JpdHJhdGUSGQoFd2lk'
    'dGgYBSABKA1IAFIFd2lkdGiIAQESGwoGaGVpZ2h0GAYgASgNSAFSBmhlaWdodIgBARIVCgNmcH'
    'MYByABKA1IAlIDZnBziAEBEhYKBmNvZGVjcxgIIAMoCVIGY29kZWNzEhoKCGFkYXB0aXZlGAkg'
    'ASgIUghhZGFwdGl2ZRIdCgphdWRpb19vbmx5GAogASgIUglhdWRpb09ubHlCCAoGX3dpZHRoQg'
    'kKB19oZWlnaHRCBgoEX2Zwcw==');

@$core.Deprecated('Use subtitleDescriptor instead')
const Subtitle$json = {
  '1': 'Subtitle',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
    {'1': 'automatic', '3': 3, '4': 1, '5': 8, '10': 'automatic'},
    {'1': 'translatable', '3': 4, '4': 1, '5': 8, '10': 'translatable'},
  ],
};

/// Descriptor for `Subtitle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subtitleDescriptor = $convert.base64Decode(
    'CghTdWJ0aXRsZRISCgRuYW1lGAEgASgJUgRuYW1lEhoKCGxhbmd1YWdlGAIgASgJUghsYW5ndW'
    'FnZRIcCglhdXRvbWF0aWMYAyABKAhSCWF1dG9tYXRpYxIiCgx0cmFuc2xhdGFibGUYBCABKAhS'
    'DHRyYW5zbGF0YWJsZQ==');

@$core.Deprecated('Use resolveResponseDescriptor instead')
const ResolveResponse$json = {
  '1': 'ResolveResponse',
  '2': [
    {
      '1': 'metadata',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.provider.youtube.Metadata',
      '10': 'metadata'
    },
    {
      '1': 'formats',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.youtube.Format',
      '10': 'formats'
    },
    {
      '1': 'subtitles',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.synctv.provider.youtube.Subtitle',
      '10': 'subtitles'
    },
    {
      '1': 'storyboard_spec',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'storyboardSpec',
      '17': true
    },
    {
      '1': 'source_config',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.synctv.source_config.YoutubeMediaSourceConfig',
      '10': 'sourceConfig'
    },
  ],
  '8': [
    {'1': '_storyboard_spec'},
  ],
};

/// Descriptor for `ResolveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveResponseDescriptor = $convert.base64Decode(
    'Cg9SZXNvbHZlUmVzcG9uc2USPQoIbWV0YWRhdGEYASABKAsyIS5zeW5jdHYucHJvdmlkZXIueW'
    '91dHViZS5NZXRhZGF0YVIIbWV0YWRhdGESOQoHZm9ybWF0cxgCIAMoCzIfLnN5bmN0di5wcm92'
    'aWRlci55b3V0dWJlLkZvcm1hdFIHZm9ybWF0cxI/CglzdWJ0aXRsZXMYAyADKAsyIS5zeW5jdH'
    'YucHJvdmlkZXIueW91dHViZS5TdWJ0aXRsZVIJc3VidGl0bGVzEiwKD3N0b3J5Ym9hcmRfc3Bl'
    'YxgEIAEoCUgAUg5zdG9yeWJvYXJkU3BlY4gBARJTCg1zb3VyY2VfY29uZmlnGAUgASgLMi4uc3'
    'luY3R2LnNvdXJjZV9jb25maWcuWW91dHViZU1lZGlhU291cmNlQ29uZmlnUgxzb3VyY2VDb25m'
    'aWdCEgoQX3N0b3J5Ym9hcmRfc3BlYw==');
