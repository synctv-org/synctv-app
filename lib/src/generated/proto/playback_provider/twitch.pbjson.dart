// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/twitch.proto.

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

@$core.Deprecated('Use getTwitchResourceRequestDescriptor instead')
const GetTwitchResourceRequest$json = {
  '1': 'GetTwitchResourceRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 3, '4': 1, '5': 13, '10': 'mediaIndex'},
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

/// Descriptor for `GetTwitchResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTwitchResourceRequestDescriptor = $convert.base64Decode(
    'ChhHZXRUd2l0Y2hSZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAVIHdm'
    'Vyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEh8KC21lZGlhX2lu'
    'ZGV4GAMgASgNUgptZWRpYUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3VpZB'
    'gFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4cBgH'
    'IAEoA1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBGhlYW'
    'RCCAoGX3Jhbmdl');

@$core.Deprecated('Use twitchResourceResponseDescriptor instead')
const TwitchResourceResponse$json = {
  '1': 'TwitchResourceResponse',
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

/// Descriptor for `TwitchResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchResourceResponseDescriptor =
    $convert.base64Decode(
        'ChZUd2l0Y2hSZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYXliYW'
        'NrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getTwitchSegmentRequestDescriptor instead')
const GetTwitchSegmentRequest$json = {
  '1': 'GetTwitchSegmentRequest',
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

/// Descriptor for `GetTwitchSegmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTwitchSegmentRequestDescriptor = $convert.base64Decode(
    'ChdHZXRUd2l0Y2hTZWdtZW50UmVxdWVzdBIhCgd2ZXJzaW9uGAEgASgJQge6SARyAhABUgd2ZX'
    'JzaW9uEiYKCnRhcmdldF91cmwYAiABKAlCB7pIBHICEAFSCXRhcmdldFVybBIZCgNzaWcYAyAB'
    'KAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBCABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBSABKA'
    'lCB7pIBHICEAFSA3JpZBIQCgNleHAYBiABKANSA2V4cBIZCgVyYW5nZRgHIAEoCUgAUgVyYW5n'
    'ZYgBARISCgRoZWFkGAggASgIUgRoZWFkQggKBl9yYW5nZQ==');

@$core.Deprecated('Use twitchSegmentResponseDescriptor instead')
const TwitchSegmentResponse$json = {
  '1': 'TwitchSegmentResponse',
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

/// Descriptor for `TwitchSegmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchSegmentResponseDescriptor = $convert.base64Decode(
    'ChVUd2l0Y2hTZWdtZW50UmVzcG9uc2USQgoFY2h1bmsYASABKAsyLC5zeW5jdHYucGxheWJhY2'
    'tfcHJvdmlkZXIuY29tbW9uLlN0cmVhbUNodW5rUgVjaHVuaw==');

@$core.Deprecated('Use watchTwitchChatRequestDescriptor instead')
const WatchTwitchChatRequest$json = {
  '1': 'WatchTwitchChatRequest',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'version'},
    {'1': 'mode_name', '3': 2, '4': 1, '5': 9, '8': {}, '10': 'modeName'},
    {'1': 'media_index', '3': 3, '4': 1, '5': 13, '10': 'mediaIndex'},
    {'1': 'sig', '3': 4, '4': 1, '5': 9, '8': {}, '10': 'sig'},
    {'1': 'uid', '3': 5, '4': 1, '5': 9, '8': {}, '10': 'uid'},
    {'1': 'rid', '3': 6, '4': 1, '5': 9, '8': {}, '10': 'rid'},
    {'1': 'exp', '3': 7, '4': 1, '5': 3, '10': 'exp'},
  ],
};

/// Descriptor for `WatchTwitchChatRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchTwitchChatRequestDescriptor = $convert.base64Decode(
    'ChZXYXRjaFR3aXRjaENoYXRSZXF1ZXN0EiEKB3ZlcnNpb24YASABKAlCB7pIBHICEAFSB3Zlcn'
    'Npb24SJAoJbW9kZV9uYW1lGAIgASgJQge6SARyAhABUghtb2RlTmFtZRIfCgttZWRpYV9pbmRl'
    'eBgDIAEoDVIKbWVkaWFJbmRleBIZCgNzaWcYBCABKAlCB7pIBHICEAFSA3NpZxIZCgN1aWQYBS'
    'ABKAlCB7pIBHICEAFSA3VpZBIZCgNyaWQYBiABKAlCB7pIBHICEAFSA3JpZBIQCgNleHAYByAB'
    'KANSA2V4cA==');

@$core.Deprecated('Use twitchChatEventDescriptor instead')
const TwitchChatEvent$json = {
  '1': 'TwitchChatEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'user_name', '3': 2, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'color', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'color', '17': true},
    {'1': 'badges', '3': 5, '4': 3, '5': 9, '10': 'badges'},
    {
      '1': 'sent_at_ms',
      '3': 6,
      '4': 1,
      '5': 4,
      '9': 1,
      '10': 'sentAtMs',
      '17': true
    },
  ],
  '8': [
    {'1': '_color'},
    {'1': '_sent_at_ms'},
  ],
};

/// Descriptor for `TwitchChatEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twitchChatEventDescriptor = $convert.base64Decode(
    'Cg9Ud2l0Y2hDaGF0RXZlbnQSDgoCaWQYASABKAlSAmlkEhsKCXVzZXJfbmFtZRgCIAEoCVIIdX'
    'Nlck5hbWUSEgoEdGV4dBgDIAEoCVIEdGV4dBIZCgVjb2xvchgEIAEoCUgAUgVjb2xvcogBARIW'
    'CgZiYWRnZXMYBSADKAlSBmJhZGdlcxIhCgpzZW50X2F0X21zGAYgASgESAFSCHNlbnRBdE1ziA'
    'EBQggKBl9jb2xvckINCgtfc2VudF9hdF9tcw==');

const $core.Map<$core.String, $core.dynamic>
    TwitchPlaybackProviderServiceBase$json = {
  '1': 'TwitchPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.twitch.GetTwitchResourceRequest',
      '3': '.synctv.playback_provider.twitch.TwitchResourceResponse',
      '6': true
    },
    {
      '1': 'GetSegment',
      '2': '.synctv.playback_provider.twitch.GetTwitchSegmentRequest',
      '3': '.synctv.playback_provider.twitch.TwitchSegmentResponse',
      '6': true
    },
    {
      '1': 'WatchChat',
      '2': '.synctv.playback_provider.twitch.WatchTwitchChatRequest',
      '3': '.synctv.playback_provider.twitch.TwitchChatEvent',
      '6': true
    },
  ],
};

@$core.Deprecated('Use twitchPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TwitchPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.twitch.GetTwitchResourceRequest':
      GetTwitchResourceRequest$json,
  '.synctv.playback_provider.twitch.TwitchResourceResponse':
      TwitchResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.twitch.GetTwitchSegmentRequest':
      GetTwitchSegmentRequest$json,
  '.synctv.playback_provider.twitch.TwitchSegmentResponse':
      TwitchSegmentResponse$json,
  '.synctv.playback_provider.twitch.WatchTwitchChatRequest':
      WatchTwitchChatRequest$json,
  '.synctv.playback_provider.twitch.TwitchChatEvent': TwitchChatEvent$json,
};

/// Descriptor for `TwitchPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List twitchPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'Ch1Ud2l0Y2hQbGF5YmFja1Byb3ZpZGVyU2VydmljZRKDAQoLR2V0UmVzb3VyY2USOS5zeW5jdH'
    'YucGxheWJhY2tfcHJvdmlkZXIudHdpdGNoLkdldFR3aXRjaFJlc291cmNlUmVxdWVzdBo3LnN5'
    'bmN0di5wbGF5YmFja19wcm92aWRlci50d2l0Y2guVHdpdGNoUmVzb3VyY2VSZXNwb25zZTABEo'
    'ABCgpHZXRTZWdtZW50Ejguc3luY3R2LnBsYXliYWNrX3Byb3ZpZGVyLnR3aXRjaC5HZXRUd2l0'
    'Y2hTZWdtZW50UmVxdWVzdBo2LnN5bmN0di5wbGF5YmFja19wcm92aWRlci50d2l0Y2guVHdpdG'
    'NoU2VnbWVudFJlc3BvbnNlMAESeAoJV2F0Y2hDaGF0Ejcuc3luY3R2LnBsYXliYWNrX3Byb3Zp'
    'ZGVyLnR3aXRjaC5XYXRjaFR3aXRjaENoYXRSZXF1ZXN0GjAuc3luY3R2LnBsYXliYWNrX3Byb3'
    'ZpZGVyLnR3aXRjaC5Ud2l0Y2hDaGF0RXZlbnQwAQ==');
