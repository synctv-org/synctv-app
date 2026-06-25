// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/bilibili.proto.

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

import 'common.pbjson.dart' as $0;

@$core.Deprecated('Use bilibiliDashManifestModeDescriptor instead')
const BilibiliDashManifestMode$json = {
  '1': 'BilibiliDashManifestMode',
  '2': [
    {'1': 'BILIBILI_DASH_MANIFEST_MODE_UNSPECIFIED', '2': 0},
    {'1': 'BILIBILI_DASH_MANIFEST_MODE_DIRECT', '2': 1},
    {'1': 'BILIBILI_DASH_MANIFEST_MODE_PROXY', '2': 2},
  ],
};

/// Descriptor for `BilibiliDashManifestMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bilibiliDashManifestModeDescriptor = $convert.base64Decode(
    'ChhCaWxpYmlsaURhc2hNYW5pZmVzdE1vZGUSKwonQklMSUJJTElfREFTSF9NQU5JRkVTVF9NT0'
    'RFX1VOU1BFQ0lGSUVEEAASJgoiQklMSUJJTElfREFTSF9NQU5JRkVTVF9NT0RFX0RJUkVDVBAB'
    'EiUKIUJJTElCSUxJX0RBU0hfTUFOSUZFU1RfTU9ERV9QUk9YWRAC');

@$core.Deprecated('Use bilibiliLiveDanmakuEventTypeDescriptor instead')
const BilibiliLiveDanmakuEventType$json = {
  '1': 'BilibiliLiveDanmakuEventType',
  '2': [
    {'1': 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_CHAT', '2': 1},
    {'1': 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_USER_ENTER', '2': 2},
    {'1': 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_GIFT', '2': 3},
    {'1': 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_HEARTBEAT', '2': 4},
    {'1': 'BILIBILI_LIVE_DANMAKU_EVENT_TYPE_UNKNOWN', '2': 5},
  ],
};

/// Descriptor for `BilibiliLiveDanmakuEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bilibiliLiveDanmakuEventTypeDescriptor = $convert.base64Decode(
    'ChxCaWxpYmlsaUxpdmVEYW5tYWt1RXZlbnRUeXBlEjAKLEJJTElCSUxJX0xJVkVfREFOTUFLVV'
    '9FVkVOVF9UWVBFX1VOU1BFQ0lGSUVEEAASKQolQklMSUJJTElfTElWRV9EQU5NQUtVX0VWRU5U'
    'X1RZUEVfQ0hBVBABEi8KK0JJTElCSUxJX0xJVkVfREFOTUFLVV9FVkVOVF9UWVBFX1VTRVJfRU'
    '5URVIQAhIpCiVCSUxJQklMSV9MSVZFX0RBTk1BS1VfRVZFTlRfVFlQRV9HSUZUEAMSLgoqQklM'
    'SUJJTElfTElWRV9EQU5NQUtVX0VWRU5UX1RZUEVfSEVBUlRCRUFUEAQSLAooQklMSUJJTElfTE'
    'lWRV9EQU5NQUtVX0VWRU5UX1RZUEVfVU5LTk9XThAF');

@$core.Deprecated('Use getBilibiliMediaStreamRequestDescriptor instead')
const GetBilibiliMediaStreamRequest$json = {
  '1': 'GetBilibiliMediaStreamRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'url_index', '3': 3, '4': 1, '5': 13, '10': 'urlIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 8, '4': 1, '5': 9, '9': 0, '10': 'range', '17': true},
    {'1': 'head', '3': 9, '4': 1, '5': 8, '10': 'head'},
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetBilibiliMediaStreamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliMediaStreamRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRCaWxpYmlsaU1lZGlhU3RyZWFtUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAh'
    'ABUgd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSGwoJdXJs'
    'X2luZGV4GAMgASgNUgh1cmxJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZW'
    'FkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use bilibiliMediaStreamResponseDescriptor instead')
const BilibiliMediaStreamResponse$json = {
  '1': 'BilibiliMediaStreamResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliMediaStreamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliMediaStreamResponseDescriptor =
    $convert.base64Decode(
        'ChtCaWxpYmlsaU1lZGlhU3RyZWFtUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucG'
        'xheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getBilibiliHlsManifestRequestDescriptor instead')
const GetBilibiliHlsManifestRequest$json = {
  '1': 'GetBilibiliHlsManifestRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'url_index', '3': 3, '4': 1, '5': 13, '10': 'urlIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetBilibiliHlsManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliHlsManifestRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRCaWxpYmlsaUhsc01hbmlmZXN0UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAh'
    'ABUgd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSGwoJdXJs'
    'X2luZGV4GAMgASgNUgh1cmxJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cA==');

@$core.Deprecated('Use bilibiliHlsManifestResponseDescriptor instead')
const BilibiliHlsManifestResponse$json = {
  '1': 'BilibiliHlsManifestResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliHlsManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliHlsManifestResponseDescriptor =
    $convert.base64Decode(
        'ChtCaWxpYmlsaUhsc01hbmlmZXN0UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucG'
        'xheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getBilibiliHlsSegmentRequestDescriptor instead')
const GetBilibiliHlsSegmentRequest$json = {
  '1': 'GetBilibiliHlsSegmentRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'target_url', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'targetUrl'},
    {'1': 'sig', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 6, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 7, '4': 1, '5': 9, '9': 0, '10': 'range', '17': true},
    {'1': 'head', '3': 8, '4': 1, '5': 8, '10': 'head'},
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetBilibiliHlsSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliHlsSegmentRequestDescriptor = $convert.base64Decode(
    'ChxHZXRCaWxpYmlsaUhsc1NlZ21lbnRSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEA'
    'FSB3ZlcnNpb24SJgoKdGFyZ2V0X3VybBgCIAEoCUIHukgEcgIQAVIJdGFyZ2V0VXJsEhkKA3Np'
    'ZxgDIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZBgEIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZB'
    'gFIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgGIAEoA1IDZXhwEhkKBXJhbmdlGAcgASgJSABS'
    'BXJhbmdliAEBEhIKBGhlYWQYCCABKAhSBGhlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use bilibiliHlsSegmentResponseDescriptor instead')
const BilibiliHlsSegmentResponse$json = {
  '1': 'BilibiliHlsSegmentResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliHlsSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliHlsSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChpCaWxpYmlsaUhsc1NlZ21lbnRSZXNwb25zZRJCCgVjaHVuaxgBIAEoCzIsLnN5bmN0di5wbG'
        'F5YmFja19wcm92aWRlci5jb21tb24uU3RyZWFtQ2h1bmtSBWNodW5r');

@$core.Deprecated('Use getBilibiliDashManifestRequestDescriptor instead')
const GetBilibiliDashManifestRequest$json = {
  '1': 'GetBilibiliDashManifestRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.synctv.playback_provider.bilibili.BilibiliDashManifestMode',
      '8': {},
      '10': 'mode'
    },
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetBilibiliDashManifestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliDashManifestRequestDescriptor = $convert.base64Decode(
    'Ch5HZXRCaWxpYmlsaURhc2hNYW5pZmVzdFJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcg'
    'IQAVIHdmVyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lElkKBG1v'
    'ZGUYAyABKA4yOy5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYmlsaWJpbGkuQmlsaWJpbGlEYX'
    'NoTWFuaWZlc3RNb2RlQgi6SAWCAQIQAVIEbW9kZRIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3Np'
    'ZxIZCgN1aWQYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZB'
    'IQCgNleHAYByABKANSA2V4cA==');

@$core.Deprecated('Use bilibiliDashManifestResponseDescriptor instead')
const BilibiliDashManifestResponse$json = {
  '1': 'BilibiliDashManifestResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliDashManifestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliDashManifestResponseDescriptor =
    $convert.base64Decode(
        'ChxCaWxpYmlsaURhc2hNYW5pZmVzdFJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2Ln'
        'BsYXliYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getBilibiliDashSegmentRequestDescriptor instead')
const GetBilibiliDashSegmentRequest$json = {
  '1': 'GetBilibiliDashSegmentRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'url_index', '3': 3, '4': 1, '5': 13, '10': 'urlIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
    {'1': 'range', '3': 8, '4': 1, '5': 9, '9': 0, '10': 'range', '17': true},
    {'1': 'head', '3': 9, '4': 1, '5': 8, '10': 'head'},
  ],
  '8': [
    {'1': '_range'},
  ],
};

/// Descriptor for `GetBilibiliDashSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliDashSegmentRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRCaWxpYmlsaURhc2hTZWdtZW50UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAh'
    'ABUgd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSGwoJdXJs'
    'X2luZGV4GAMgASgNUgh1cmxJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aW'
    'QYBSABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAY'
    'ByABKANSA2V4cBIZCgVyYW5nZRgIIAEoCUgAUgVyYW5nZYgBARISCgRoZWFkGAkgASgIUgRoZW'
    'FkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use bilibiliDashSegmentResponseDescriptor instead')
const BilibiliDashSegmentResponse$json = {
  '1': 'BilibiliDashSegmentResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliDashSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliDashSegmentResponseDescriptor =
    $convert.base64Decode(
        'ChtCaWxpYmlsaURhc2hTZWdtZW50UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucG'
        'xheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getBilibiliSubtitleRequestDescriptor instead')
const GetBilibiliSubtitleRequest$json = {
  '1': 'GetBilibiliSubtitleRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'subtitle_index', '3': 3, '4': 1, '5': 13, '10': 'subtitleIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetBilibiliSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliSubtitleRequestDescriptor = $convert.base64Decode(
    'ChpHZXRCaWxpYmlsaVN1YnRpdGxlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUg'
    'd2ZXJzaW9uEiQKCW1vZGVfbmFtZRgCIAEoCUIHukgEcgIQAVIIbW9kZU5hbWUSJQoOc3VidGl0'
    'bGVfaW5kZXgYAyABKA1SDXN1YnRpdGxlSW5kZXgSGQoDc2lnGAQgASgJQge6SARyAhABUgNzaW'
    'cSGQoDdWlkGAUgASgJQge6SARyAhABUgN1aWQSGQoDcmlkGAYgASgJQge6SARyAhABUgNyaWQS'
    'EAoDZXhwGAcgASgDUgNleHA=');

@$core.Deprecated('Use bilibiliSubtitleResponseDescriptor instead')
const BilibiliSubtitleResponse$json = {
  '1': 'BilibiliSubtitleResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChhCaWxpYmlsaVN1YnRpdGxlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheW'
        'JhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use getBilibiliDanmakuFileRequestDescriptor instead')
const GetBilibiliDanmakuFileRequest$json = {
  '1': 'GetBilibiliDanmakuFileRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'danmaku_index', '3': 2, '4': 1, '5': 13, '10': 'danmakuIndex'},
    {'1': 'sig', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 6, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `GetBilibiliDanmakuFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBilibiliDanmakuFileRequestDescriptor = $convert.base64Decode(
    'Ch1HZXRCaWxpYmlsaURhbm1ha3VGaWxlUmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAh'
    'ABUgd2ZXJzaW9uEiMKDWRhbm1ha3VfaW5kZXgYAiABKA1SDGRhbm1ha3VJbmRleBIZCgNzaWcY'
    'AyABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBCABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBS'
    'ABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYBiABKANSA2V4cA==');

@$core.Deprecated('Use bilibiliDanmakuFileResponseDescriptor instead')
const BilibiliDanmakuFileResponse$json = {
  '1': 'BilibiliDanmakuFileResponse',
  '2': [
    {
      '1': 'chunk',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.synctv.playback_provider.common.StreamChunk',
      '10': 'chunk'
    },
  ],
};

/// Descriptor for `BilibiliDanmakuFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliDanmakuFileResponseDescriptor =
    $convert.base64Decode(
        'ChtCaWxpYmlsaURhbm1ha3VGaWxlUmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucG'
        'xheWJhY2tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use watchBilibiliLiveDanmakuRequestDescriptor instead')
const WatchBilibiliLiveDanmakuRequest$json = {
  '1': 'WatchBilibiliLiveDanmakuRequest',
  '2': [
    {'1': 'media_id', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'mediaId'},
  ],
};

/// Descriptor for `WatchBilibiliLiveDanmakuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchBilibiliLiveDanmakuRequestDescriptor =
    $convert.base64Decode(
        'Ch9XYXRjaEJpbGliaWxpTGl2ZURhbm1ha3VSZXF1ZXN0EiIKCG1lZGlhX2lkGAEgASgJQge6SA'
        'RyAhABUgdtZWRpYUlk');

@$core.Deprecated('Use bilibiliLiveDanmakuEventDescriptor instead')
const BilibiliLiveDanmakuEvent$json = {
  '1': 'BilibiliLiveDanmakuEvent',
  '2': [
    {'1': 'format', '3': 1, '4': 1, '5': 9, '10': 'format'},
    {'1': 'event_type', '3': 2, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'user', '3': 3, '4': 1, '5': 9, '10': 'user'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {'1': 'timestamp', '3': 5, '4': 1, '5': 4, '10': 'timestamp'},
    {'1': 'gift_name', '3': 6, '4': 1, '5': 9, '10': 'giftName'},
    {'1': 'gift_count', '3': 7, '4': 1, '5': 13, '10': 'giftCount'},
    {'1': 'online_count', '3': 8, '4': 1, '5': 13, '10': 'onlineCount'},
    {
      '1': 'type',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.synctv.playback_provider.bilibili.BilibiliLiveDanmakuEventType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `BilibiliLiveDanmakuEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibiliLiveDanmakuEventDescriptor = $convert.base64Decode(
    'ChhCaWxpYmlsaUxpdmVEYW5tYWt1RXZlbnQSFgoGZm9ybWF0GAEgASgJUgZmb3JtYXQSHQoKZX'
    'ZlbnRfdHlwZRgCIAEoCVIJZXZlbnRUeXBlEhIKBHVzZXIYAyABKAlSBHVzZXISGAoHbWVzc2Fn'
    'ZRgEIAEoCVIHbWVzc2FnZRIcCgl0aW1lc3RhbXAYBSABKARSCXRpbWVzdGFtcBIbCglnaWZ0X2'
    '5hbWUYBiABKAlSCGdpZnROYW1lEh0KCmdpZnRfY291bnQYByABKA1SCWdpZnRDb3VudBIhCgxv'
    'bmxpbmVfY291bnQYCCABKA1SC29ubGluZUNvdW50ElMKBHR5cGUYCSABKA4yPy5zeW5jdHYucG'
    'xheWJhY2tfcHJvdmlkZXIuYmlsaWJpbGkuQmlsaWJpbGlMaXZlRGFubWFrdUV2ZW50VHlwZVIE'
    'dHlwZQ==');

const $core.Map<$core.String, $core.dynamic>
    BilibiliPlaybackProviderServiceBase$json = {
  '1': 'BilibiliPlaybackProviderService',
  '2': [
    {
      '1': 'GetMediaStream',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliMediaStreamRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliMediaStreamResponse',
      '6': true
    },
    {
      '1': 'GetHlsManifest',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliHlsManifestRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliHlsManifestResponse',
      '6': true
    },
    {
      '1': 'GetHlsSegment',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliHlsSegmentRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliHlsSegmentResponse',
      '6': true
    },
    {
      '1': 'GetDashManifest',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliDashManifestRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliDashManifestResponse',
      '6': true
    },
    {
      '1': 'GetDashSegment',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliDashSegmentRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliDashSegmentResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliSubtitleRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliSubtitleResponse',
      '6': true
    },
    {
      '1': 'GetDanmakuFile',
      '2': '.synctv.playback_provider.bilibili.GetBilibiliDanmakuFileRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliDanmakuFileResponse',
      '6': true
    },
    {
      '1': 'WatchLiveDanmaku',
      '2': '.synctv.playback_provider.bilibili.WatchBilibiliLiveDanmakuRequest',
      '3': '.synctv.playback_provider.bilibili.BilibiliLiveDanmakuEvent',
      '6': true
    },
  ],
};

@$core.Deprecated('Use bilibiliPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BilibiliPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.bilibili.GetBilibiliMediaStreamRequest':
      GetBilibiliMediaStreamRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliMediaStreamResponse':
      BilibiliMediaStreamResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.bilibili.GetBilibiliHlsManifestRequest':
      GetBilibiliHlsManifestRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliHlsManifestResponse':
      BilibiliHlsManifestResponse$json,
  '.synctv.playback_provider.bilibili.GetBilibiliHlsSegmentRequest':
      GetBilibiliHlsSegmentRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliHlsSegmentResponse':
      BilibiliHlsSegmentResponse$json,
  '.synctv.playback_provider.bilibili.GetBilibiliDashManifestRequest':
      GetBilibiliDashManifestRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliDashManifestResponse':
      BilibiliDashManifestResponse$json,
  '.synctv.playback_provider.bilibili.GetBilibiliDashSegmentRequest':
      GetBilibiliDashSegmentRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliDashSegmentResponse':
      BilibiliDashSegmentResponse$json,
  '.synctv.playback_provider.bilibili.GetBilibiliSubtitleRequest':
      GetBilibiliSubtitleRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliSubtitleResponse':
      BilibiliSubtitleResponse$json,
  '.synctv.playback_provider.bilibili.GetBilibiliDanmakuFileRequest':
      GetBilibiliDanmakuFileRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliDanmakuFileResponse':
      BilibiliDanmakuFileResponse$json,
  '.synctv.playback_provider.bilibili.WatchBilibiliLiveDanmakuRequest':
      WatchBilibiliLiveDanmakuRequest$json,
  '.synctv.playback_provider.bilibili.BilibiliLiveDanmakuEvent':
      BilibiliLiveDanmakuEvent$json,
};

/// Descriptor for `BilibiliPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List bilibiliPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch9CaWxpYmlsaVBsYXliYWNrUHJvdmlkZXJTZXJ2aWNlEpQBCg5HZXRNZWRpYVN0cmVhbRJALn'
    'N5bmN0di5wbGF5YmFja19wcm92aWRlci5iaWxpYmlsaS5HZXRCaWxpYmlsaU1lZGlhU3RyZWFt'
    'UmVxdWVzdBo+LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5iaWxpYmlsaS5CaWxpYmlsaU1lZG'
    'lhU3RyZWFtUmVzcG9uc2UwARKUAQoOR2V0SGxzTWFuaWZlc3QSQC5zeW5jdHYucGxheWJhY2tf'
    'cHJvdmlkZXIuYmlsaWJpbGkuR2V0QmlsaWJpbGlIbHNNYW5pZmVzdFJlcXVlc3QaPi5zeW5jdH'
    'YucGxheWJhY2tfcHJvdmlkZXIuYmlsaWJpbGkuQmlsaWJpbGlIbHNNYW5pZmVzdFJlc3BvbnNl'
    'MAESkQEKDUdldEhsc1NlZ21lbnQSPy5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYmlsaWJpbG'
    'kuR2V0QmlsaWJpbGlIbHNTZWdtZW50UmVxdWVzdBo9LnN5bmN0di5wbGF5YmFja19wcm92aWRl'
    'ci5iaWxpYmlsaS5CaWxpYmlsaUhsc1NlZ21lbnRSZXNwb25zZTABEpcBCg9HZXREYXNoTWFuaW'
    'Zlc3QSQS5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYmlsaWJpbGkuR2V0QmlsaWJpbGlEYXNo'
    'TWFuaWZlc3RSZXF1ZXN0Gj8uc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmJpbGliaWxpLkJpbG'
    'liaWxpRGFzaE1hbmlmZXN0UmVzcG9uc2UwARKUAQoOR2V0RGFzaFNlZ21lbnQSQC5zeW5jdHYu'
    'cGxheWJhY2tfcHJvdmlkZXIuYmlsaWJpbGkuR2V0QmlsaWJpbGlEYXNoU2VnbWVudFJlcXVlc3'
    'QaPi5zeW5jdHYucGxheWJhY2tfcHJvdmlkZXIuYmlsaWJpbGkuQmlsaWJpbGlEYXNoU2VnbWVu'
    'dFJlc3BvbnNlMAESiwEKC0dldFN1YnRpdGxlEj0uc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLm'
    'JpbGliaWxpLkdldEJpbGliaWxpU3VidGl0bGVSZXF1ZXN0Gjsuc3luY3R2LnBsYXliYWNrX3By'
    'b3ZpZGVyLmJpbGliaWxpLkJpbGliaWxpU3VidGl0bGVSZXNwb25zZTABEpQBCg5HZXREYW5tYW'
    't1RmlsZRJALnN5bmN0di5wbGF5YmFja19wcm92aWRlci5iaWxpYmlsaS5HZXRCaWxpYmlsaURh'
    'bm1ha3VGaWxlUmVxdWVzdBo+LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5iaWxpYmlsaS5CaW'
    'xpYmlsaURhbm1ha3VGaWxlUmVzcG9uc2UwARKVAQoQV2F0Y2hMaXZlRGFubWFrdRJCLnN5bmN0'
    'di5wbGF5YmFja19wcm92aWRlci5iaWxpYmlsaS5XYXRjaEJpbGliaWxpTGl2ZURhbm1ha3VSZX'
    'F1ZXN0Gjsuc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLmJpbGliaWxpLkJpbGliaWxpTGl2ZURh'
    'bm1ha3VFdmVudDAB');
