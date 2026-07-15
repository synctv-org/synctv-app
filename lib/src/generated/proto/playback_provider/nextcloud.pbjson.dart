// This is a generated file - do not edit.
//
// Generated from proto/playback_provider/nextcloud.proto.

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

@$core.Deprecated('Use getNextcloudResourceRequestDescriptor instead')
const GetNextcloudResourceRequest$json = {
  '1': 'GetNextcloudResourceRequest',
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

/// Descriptor for `GetNextcloudResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNextcloudResourceRequestDescriptor = $convert.base64Decode(
    'ChtHZXROZXh0Y2xvdWRSZXNvdXJjZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAV'
    'IHdmVyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEh8KC21lZGlh'
    'X2luZGV4GAMgASgNUgptZWRpYUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2lnEhkKA3'
    'VpZBgFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlkEhAKA2V4'
    'cBgHIAEoA1IDZXhwEhkKBXJhbmdlGAggASgJSABSBXJhbmdliAEBEhIKBGhlYWQYCSABKAhSBG'
    'hlYWRCCAoGX3Jhbmdl');

@$core.Deprecated('Use nextcloudResourceResponseDescriptor instead')
const NextcloudResourceResponse$json = {
  '1': 'NextcloudResourceResponse',
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

/// Descriptor for `NextcloudResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudResourceResponseDescriptor =
    $convert.base64Decode(
        'ChlOZXh0Y2xvdWRSZXNvdXJjZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYX'
        'liYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

@$core.Deprecated('Use getNextcloudSubtitleRequestDescriptor instead')
const GetNextcloudSubtitleRequest$json = {
  '1': 'GetNextcloudSubtitleRequest',
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

/// Descriptor for `GetNextcloudSubtitleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNextcloudSubtitleRequestDescriptor = $convert.base64Decode(
    'ChtHZXROZXh0Y2xvdWRTdWJ0aXRsZVJlcXVlc3QSIQoHdmVyc2lvbhgBIAEoCUIHukgEcgIQAV'
    'IHdmVyc2lvbhIkCgltb2RlX25hbWUYAiABKAlCB7pIBHICEAFSCG1vZGVOYW1lEiUKDnN1YnRp'
    'dGxlX2luZGV4GAMgASgNUg1zdWJ0aXRsZUluZGV4EhkKA3NpZxgEIAEoCUIHukgEcgIQAVIDc2'
    'lnEhkKA3VpZBgFIAEoCUIHukgEcgIQAVIDdWlkEhkKA3JpZBgGIAEoCUIHukgEcgIQAVIDcmlk'
    'EhAKA2V4cBgHIAEoA1IDZXhw');

@$core.Deprecated('Use nextcloudSubtitleResponseDescriptor instead')
const NextcloudSubtitleResponse$json = {
  '1': 'NextcloudSubtitleResponse',
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

/// Descriptor for `NextcloudSubtitleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nextcloudSubtitleResponseDescriptor =
    $convert.base64Decode(
        'ChlOZXh0Y2xvdWRTdWJ0aXRsZVJlc3BvbnNlEkIKBWNodW5rGAEgASgLMiwuc3luY3R2LnBsYX'
        'liYWNrX3Byb3ZpZGVyLmNvbW1vbi5TdHJlYW1DaHVua1IFY2h1bms=');

const $core.Map<$core.String, $core.dynamic>
    NextcloudPlaybackProviderServiceBase$json = {
  '1': 'NextcloudPlaybackProviderService',
  '2': [
    {
      '1': 'GetResource',
      '2': '.synctv.playback_provider.nextcloud.GetNextcloudResourceRequest',
      '3': '.synctv.playback_provider.nextcloud.NextcloudResourceResponse',
      '6': true
    },
    {
      '1': 'GetSubtitle',
      '2': '.synctv.playback_provider.nextcloud.GetNextcloudSubtitleRequest',
      '3': '.synctv.playback_provider.nextcloud.NextcloudSubtitleResponse',
      '6': true
    },
  ],
};

@$core.Deprecated('Use nextcloudPlaybackProviderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    NextcloudPlaybackProviderServiceBase$messageJson = {
  '.synctv.playback_provider.nextcloud.GetNextcloudResourceRequest':
      GetNextcloudResourceRequest$json,
  '.synctv.playback_provider.nextcloud.NextcloudResourceResponse':
      NextcloudResourceResponse$json,
  '.synctv.playback_provider.common.StreamChunk': $0.StreamChunk$json,
  '.synctv.playback_provider.nextcloud.GetNextcloudSubtitleRequest':
      GetNextcloudSubtitleRequest$json,
  '.synctv.playback_provider.nextcloud.NextcloudSubtitleResponse':
      NextcloudSubtitleResponse$json,
};

/// Descriptor for `NextcloudPlaybackProviderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List nextcloudPlaybackProviderServiceDescriptor = $convert.base64Decode(
    'CiBOZXh0Y2xvdWRQbGF5YmFja1Byb3ZpZGVyU2VydmljZRKPAQoLR2V0UmVzb3VyY2USPy5zeW'
    '5jdHYucGxheWJhY2tfcHJvdmlkZXIubmV4dGNsb3VkLkdldE5leHRjbG91ZFJlc291cmNlUmVx'
    'dWVzdBo9LnN5bmN0di5wbGF5YmFja19wcm92aWRlci5uZXh0Y2xvdWQuTmV4dGNsb3VkUmVzb3'
    'VyY2VSZXNwb25zZTABEo8BCgtHZXRTdWJ0aXRsZRI/LnN5bmN0di5wbGF5YmFja19wcm92aWRl'
    'ci5uZXh0Y2xvdWQuR2V0TmV4dGNsb3VkU3VidGl0bGVSZXF1ZXN0Gj0uc3luY3R2LnBsYXliYW'
    'NrX3Byb3ZpZGVyLm5leHRjbG91ZC5OZXh0Y2xvdWRTdWJ0aXRsZVJlc3BvbnNlMAE=');
